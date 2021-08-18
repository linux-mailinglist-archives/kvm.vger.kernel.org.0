Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711B93F07B5
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhHRPR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:17:28 -0400
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:25920
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239781AbhHRPRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:17:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyFur5W1BcqN7g52ECy2932Q1GcdllWNstKxAGElKtw4KeYO7p0651j8EFWszikNo/kboN2yu013EPVya8UCEjcMOtAngVRGWyx4kILB1/CExTCXTvW5pZ5RQtfkG4dZzOIc4obHRnwl+EuooWWLMtg46iP1iMUPAC+6AyN3xklQpCVHkF0tmmstJKFMaQkvr3wZ75CHWLA1zXp1mpdcwMq6M5SMX7LRAecMj/DG69zkFSf5ZXZELOpNMj6r2Q1yoILMiE4RcaZ3d5LaJWm6vJwLdV5oxgsEJyGPebkg/4s8qRw0PwQqh47OFtJMkNIOHzjTgx21M1V9fg4eFpV0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBKfEDEP7iPVIplnpf2WIXFtXiDH/Arq9Qj0XorjMpM=;
 b=hz3oR+M9J8VzdqDIyY6G566FaZdClQk8EXjecKlksG6DFVqaZhpI+aT/Et0xDKlzALzAU5S2ibgOXwrGaXdhbRbMDNimoBkrs0lUeCLMY+k8yFKzWEyrdvPktjs8hT0Y8e99kWpl3Coy/dzqOy8eqxapQOJXiZZlAshQKPwV7HkdyT7QpjOGUS1z2RXh/P0bIvUcCuIeRNC1PsPxaAD2/hQLyL3Y42Vzs/clLinBWRt9jOH26OjE841rxLllvnDH1YYeukjmXLFvIZnHNtb9uV3dFdB5q6K6NTIeKg8obbPwXAknG54d+hJDPsPxxPy8DRd0QzyInCUTWD6+eJLD8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBKfEDEP7iPVIplnpf2WIXFtXiDH/Arq9Qj0XorjMpM=;
 b=J1S8q1bKadBHzA4GeiwEBHMX920GbU80x+rxiW9owgkW5lvPfzFOS2Dhiyw225OwCW9d7pyHgjuRXRjTX3Kp036Ijqcs0IZ15SiXrkDho41PdINBlVmjA2Pq1W/Fcs2BBAtosyBAB7HthwM57udEufPxcrJrvj3dxqiqnRV4RgKGMjuLS6xv+jhRZvDQQX2/5y/xYbFe/nYozTFeeY/UwnFdSfuq6oNNaeQvl2J9irzO0U/HGSZ230A+GBZaebXh375e6m4zsrWsvkHFSgeAbpRo1u0maQ3CS1ZlACBmmomcFyAjF/KLrCtO/1FjBLmAFSVIxLlH3nMS99O+sUe9Ng==
Received: from BN6PR18CA0015.namprd18.prod.outlook.com (2603:10b6:404:121::25)
 by MWHPR12MB1486.namprd12.prod.outlook.com (2603:10b6:301:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 18 Aug
 2021 15:16:47 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::b7) by BN6PR18CA0015.outlook.office365.com
 (2603:10b6:404:121::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:16:45 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:16:44 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:40 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V2 00/12] Introduce vfio_pci_core subsystem
Date:   Wed, 18 Aug 2021 18:15:54 +0300
Message-ID: <20210818151606.202815-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df601143-d9da-40b8-4b51-08d9625b315b
X-MS-TrafficTypeDiagnostic: MWHPR12MB1486:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1486A66F4B845CDFDF9A8D3FC3FF9@MWHPR12MB1486.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dxB1azBlagMBJKBlehRR7YGnxCyfAenygl2flurImCDdaq69eI8H0vc90L3OhKwpp8nwLnZ4ATxfPAe7jYZIeQX9Gq/7Tgoxi2Qc2c0KnObtpSJ/Zchgn+/iikJvdC1rcVtTg9TayzvCoJ7mP7DJIUlMYqqkl4wTulerz3GNdu7XXu3mW4E4hkTBbVLrlc5OcdTPGqCnzCdHZdcI6la5lLJSZjj2c+pMmwR9Q7joUEOjPxi2I/gGvwQ/XMgerctfN7FjjnXieaM5bC+uLYYzpMVOK7GL4ESKmR0fkKyC77/azkyM6mv16Sz8iL4ostVcygcPxvFAQkEyRnghuzSlP5m3TnMaCuWEd/Ean93NViRGHMhuctKV/cjuZ4+xN+X7Q2zWGzVYaZONka8+yCCk9vABuBgZaRpSx3ns7wrlnrUJdf8jJC0gfdr+ysm1u0U5P65Mi4R3U84JKCv0txRAnV3d51261uFrzG0tvspnYbC0d5Br+GTe7JDO6DVPn+/iB8eTcnW8Eiz9TWGgVVjTYEc3h/CB4zbfl2BWBj2pgwJPcuIfjvjFPxhx77bHnKQgRa4qGAgQv84GS4+RibmryaPv9Yg3/tHTZePwS3PLdw2vyDKOMXU6CNITHomWA38bX8yQpyMhsbsgxmR1CBQlSTb5c21OEGvo6RkkMNr8qn8aZB5uKGQWyUwBlEOhzeAXmFboIj2d5A602EPlcACMBMTzAnYD+zgciBKpQFHIVX10DUOluhlatvihBqF413PIGdyKWnZ6ICmtnLS+Hdpe3wrYKF9xX5K5h85L15V7FPicN3ftRH4sv5vvXF+8PiZsBr7/lnvprsWaTOv7qUNf9w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(46966006)(36840700001)(82310400003)(36860700001)(47076005)(54906003)(83380400001)(86362001)(6666004)(4326008)(2906002)(186003)(7416002)(7636003)(356005)(107886003)(7696005)(478600001)(5660300002)(70586007)(70206006)(2616005)(8676002)(82740400003)(316002)(336012)(426003)(36756003)(26005)(966005)(110136005)(1076003)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:16:45.7209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df601143-d9da-40b8-4b51-08d9625b315b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1486
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prologue:

This is the second series of three to send the "mlx5_vfio_pci" driver
that has been discussed on the list for a while now. It comes on top of
the first series (i.e. Reorganize reflck to support splitting vfio_pci)
that was merged already.

 - Split vfio_pci into vfio_pci/vfio_pci_core and provide infrastructure
   for non-generic VFIO PCI drivers.
 - The new driver mlx5_vfio_pci that is a full implementation of
   suspend/resume functionality for mlx5 devices.

A preview of the third series for mlx5_vfio_pci can be seen here:
https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci
=====================

From Max Gurtovoy:
====================
This series splits the vfio_pci driver into two parts, a PCI driver and
a subsystem driver that will also be library of code. The main PCI
driver, vfio_pci.ko, will remain as before and it will use the library
module vfio_pci_core.ko to help create the vfio_device.

This series is intended to solve the issues that were raised in the
previous attempts for extending vfio-pci for device specific
functionality:

1.
https://lore.kernel.org/kvm/20200518024202.13996-1-yan.y.zhao@intel.com
   by Yan Zhao
2.
https://lore.kernel.org/kvm/20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com
   by Longfang Liu

Also to support proposed future changes to virtio and other common
protocols to support migration:

https://lists.oasis-open.org/archives/virtio-comment/202106/msg00044.html

This subsystem framework will also ease adding new device specific
functionality to VFIO devices in the future by allowing another module
to provide the pci_driver that can setup a number of details before
registering to the VFIO subsystem, such as injecting its own operations.

This series also extends the "driver_override" mechanism. A flag is
added for PCI drivers that will declare themselves as "driver_override"
capable which sends their match table to the modules.alias file but
otherwise leaves them outside of the normal driver core auto-binding
world, like vfio_pci.

In order to get the best match for "driver_override" drivers, one can
create a userspace program to inspect the modules.alias, an example can
be found at:

https://github.com/maxgurtovoy/linux_tools/blob/main/vfio/bind_vfio_pci_driver.py

Which finds the 'best match' according to a simple algorithm: "the
driver with the fewest '*' matches wins."

For example, the vfio-pci driver will match to any pci device. So it
will have the maximal '*' matches.

In case we are looking for a match to a mlx5 based device, we'll have a
match to vfio-pci.ko and mlx5-vfio-pci.ko. We'll prefer mlx5-vfio-pci.ko
since it will have less '*' matches (probably vendor and device IDs will
match). This will work in the future for NVMe/Virtio devices that can
match according to a class code or other criteria.

v2:
Patch #6:
- Drop DRIVER_VERSION as it's useless and not required any more.

Patch #9:
- Follow Bjorn Helgaas suggestion to enable having "vfio_" prefix in
  modules.alias file without the unnecessary VFIO connection in
  pci_match_device.

- Add the sequence of commands/algorithm that is required by
  userspace to discover the matching driver to the commit message to let the
  patch documentation be self-contained.

Patch #12:
- Save compatibility with Kconfig as was asked in the mailing list.
- Drop DRIVER_VERSION as it's useless and not required any more.

Yishai

Jason Gunthorpe (2):
  vfio: Use select for eventfd
  vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'

Max Gurtovoy (9):
  vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
  vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
  vfio/pci: Rename vfio_pci_device to vfio_pci_core_device
  vfio/pci: Rename ops functions to fit core namings
  vfio/pci: Include vfio header in vfio_pci_core.h
  vfio/pci: Split the pci_driver code out of vfio_pci_core.c
  vfio/pci: Move igd initialization to vfio_pci.c
  PCI: Add 'override_only' bitmap to struct pci_device_id
  vfio/pci: Introduce vfio_pci_core.ko

Yishai Hadas (1):
  vfio/pci: Move module parameters to vfio_pci.c

 Documentation/PCI/pci.rst                     |    1 +
 drivers/pci/pci-driver.c                      |   27 +-
 drivers/vfio/Kconfig                          |   29 +-
 drivers/vfio/fsl-mc/Kconfig                   |    3 +-
 drivers/vfio/mdev/Kconfig                     |    1 -
 drivers/vfio/pci/Kconfig                      |   40 +-
 drivers/vfio/pci/Makefile                     |    8 +-
 drivers/vfio/pci/vfio_pci.c                   | 2262 +----------------
 drivers/vfio/pci/vfio_pci_config.c            |   70 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2159 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_igd.c               |   19 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
 drivers/vfio/platform/Kconfig                 |    6 +-
 drivers/vfio/platform/reset/Kconfig           |    4 +-
 include/linux/mod_devicetable.h               |    6 +
 include/linux/pci.h                           |   28 +
 .../linux/vfio_pci_core.h                     |   89 +-
 scripts/mod/devicetable-offsets.c             |    1 +
 scripts/mod/file2alias.c                      |    8 +-
 21 files changed, 2515 insertions(+), 2310 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)

-- 
2.18.1

