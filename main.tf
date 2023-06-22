terraform {
  required_providers { #Подключаю провайдера
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.90"
    }
  }
    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "state-bucket"
    region     = "ru-central1-a"
    key        = "issue1/lemp.tfstate"
    access_key = "********************"
    secret_key = "********************************"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" { #Авторизация на провайдере
  token     = "********************************"
  cloud_id  = "**********************"
  folder_id = "*********************"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "mynetwork-001" { #Создаю сеть
  name = "mynetwork-001"
}

resource "yandex_vpc_subnet" "subnet" { #Подсеть
  name           = "subnet01"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.mynetwork-001.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" { #Подключаю модуль
  source        = "./modules"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}
