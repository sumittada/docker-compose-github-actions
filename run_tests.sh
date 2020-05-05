#!/bin/bash

echo "[+] Bringing up local environment"
docker-compose up -d

echo "[+] Trying to establish connection to container..."
docker exec bambus-backend bash -c "source /venv/bin/activate && python manage.py test_db_connectivity_or_timeout"

echo "[+] DB is (presumed) alive, running tests !!!"
docker exec postgres bash -c "pwd"
TEST_SUCCESS=$?

echo "[+] Bringing down local environment"
docker-compose down -v

echo "SUCCESS: $TEST_SUCCESS"
if [[ $TEST_SUCCESS != 0 ]]
then
    echo "#########################################"
    echo "# BUILD FAILED, CHECK ABOVE FOR ERRORS! #"
    echo "#########################################"
    exit -1
fi
