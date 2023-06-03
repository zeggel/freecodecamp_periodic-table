#! /bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  INPUT=$1
  
  # Element info
  re='^[0-9]+$'
  if [[ $INPUT =~ $re ]]
  then
    RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $INPUT")
  else
    RESULT=$($PSQL "SELECT * FROM elements WHERE symbol = '$INPUT' OR name = '$INPUT'")
  fi
  IFS="|" read NUMBER SYMBOL NAME <<< "$RESULT"

  # Element properties
  if [[ -z $NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    PROPERTIES=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties LEFT JOIN types USING (type_id) WHERE atomic_number = $NUMBER")
    IFS="|" read NUMBER MASS MELTING BOILING TYPE <<< "$PROPERTIES"
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
  
fi
