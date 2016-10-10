#!/bin/bash

# Deploy the whole site or some assets only.
# Usage: DEBUG=1 deploy.sh [filename|all]

TARGET=${TARGET:=https://dfs.cern.ch/dfs/websites/c/club-go}
USER=${USER:=simko}
DEBUG=${DEBUG:=0}

usage () {
    echo "Usage: $0 [filename|all]"
}

if [ "x$1" = "x" ]; then
    usage
    exit 1
else
    file=$1
    if [ -e "$file" ]; then
        # deploying one file
        if [ ${DEBUG} -ne 0 ]; then
            echo curl -u "${USER}" -T "$file" "${TARGET}/$file"
        else
            curl -u "${USER}" -T "$file" "${TARGET}/$file"
        fi
    elif [ "$file" = "all" ]; then
        # deploying all files
        echo "Target: $TARGET"
        echo "User: $USER"
        if [ ${DEBUG} -ne 0 ]; then
            pass='mypass123'
        else
            echo -n "Password: "
            read -s pass
            echo
        fi
        for file in $(git ls-files | grep -v Makefile); do
            if [ ${DEBUG} -ne 0 ]; then
                echo curl -u "${USER}:$pass" -T "$file" "${TARGET}/$file"
            else
                curl -u "${USER}:$pass" -T "$file" "${TARGET}/$file"
            fi
        done
    else
        echo "Error: file $file not found."
        usage
        exit 1
    fi
fi
