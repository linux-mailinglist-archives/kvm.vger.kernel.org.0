Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929F53320AF
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCIIeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:23 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:64038
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229714AbhCIIeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvvvBNdtKkyx/sSOZ7MM1hwcbPfCtbieVMg1shK5nIWBeRGt04rP16QKwpWU+it6N8TbZs9Tmr+Pw+YhO8yskczavaLIXdkEaUGbmylRRFFO65xjKfXz3d4B1rGnC1RzhJatO5QoSf1hHC+dS+lozg+BJkBevm1qvu8KBcy4Bt4YxcmsoJjFBZ/F3jX820g7mehwb1VqpyfylnIMlvRg5W/v6DW4scXpZzgLwbd509VNUbBdJJt9jcBXSDJLA9XhKU07dsB+rMLyf7FCTx+Rlq69Z+nD2T9W7xeLNIp0B57pTOFylXsLBEiSCk+WDR5NVKFhJhVSF61xbOjyDcgI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjU+RYMaRHbey9D7K97YSu9boAD6syLikz+CAiYlQzk=;
 b=Mlq4b6KL1Okr8jszGhjvQ45oDR+0FmapP2GjI8ExtT950E3Gj6JDki2fsBFmR2c/+PRHGx/+ER7aP6zkLkq/1R+jh7fFwkORc+zWqA6BDH6W5vjuXbFnN5cAJcldYeDsAaoVWBfTVrZjFQZ65eVLZbH8hFuPdHE6FJM1pJij/JxG1rM2Vp+4u9EaGcJGl6ytdDhIfoKfj0LttDqFwgxkXRZqo8pTM9LbpN3W/W1umVjypxDSplKizTa3yyYlAMEgd4aA1Ie1ZKeupenqI6CieTZ19ssexJmEAy1+CSGnaMgSE0Qm6M3NVoVjthSyXa/0DDC3H6G/r/q/wohx2+idrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjU+RYMaRHbey9D7K97YSu9boAD6syLikz+CAiYlQzk=;
 b=amCeK0SWngAoKvazxG+3vFIkxsizrG6Fyin80AdEaEIJDw5JN4/ZexFwJHhXeEqgTA/e+za66C5xClloJrg7gx4HhRIsgjhb5EF29kgwHiANCg0Lv/GDg2cPtd1XWhqi8Dr/1hZi4tkgK9LTqxo79NPJOG4mCiz8tWbVIeUmscRrTuK78SN0e4lFaig2f7iETuCgb55iDKS1MZZQkL72DPMPE2a6BugwaoWLroz8Cnvq8lwK9oqPUUqyAOAxyzZLjLL5ieG+YW9J0VMt4On+47mUXIMhDRetYfutU8bMO6VtBEyepCstE687zQZUrmn3hhFnL5TLihNdFuGTawrkIg==
Received: from DM6PR17CA0032.namprd17.prod.outlook.com (2603:10b6:5:1b3::45)
 by BY5PR12MB4641.namprd12.prod.outlook.com (2603:10b6:a03:1f7::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 08:34:05 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::d8) by DM6PR17CA0032.outlook.office365.com
 (2603:10b6:5:1b3::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:05 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:03 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:33:58 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <aik@ozlabs.ru>, <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v3 0/9] Introduce vfio-pci-core subsystem
Date:   Tue, 9 Mar 2021 08:33:48 +0000
Message-ID: <20210309083357.65467-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 189f57ac-8b41-41b7-9ee6-08d8e2d6199b
X-MS-TrafficTypeDiagnostic: BY5PR12MB4641:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4641D57B8A7B6F0EF18CF32CDE929@BY5PR12MB4641.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96QLBKwjGcVf74kKudAaiUdZjcQidptvAAv1yuyAoppZOFmF73jk0lEulD7aCPnYg6kXdSGjpXjsZAp7BQUSe4+oEwH7zrhLvEaAiyrqmEWxXJCKkOakdykmddMvlkcV35KKpP1cl9AD6khC49C3wY+eT1zXkd4huvaqFz7x3+sEckQDrXYLHvEcsSqHPIzT9LCUIiQo9mJ3jaULFdHk+zeRQ54hIrb96YDeydVBO8uXoyJIZc9PbltOLBrnC3a3O/b/NrdeMcleXYGoLdc6QlGriyPzt5UrrC6xEPdAKdGOOAJn4HP4Uxor3dE7CdJ1Bx+QTQASL2UADIIQckCqe5eNzEtzPDSGf4KC2XtQMgI4NXLsUpQis5ZBrTw/oHQJzJMUrKKnuNOXsgcfC+3WkydHvAZdDrTM/+tIuXYARmLnOUswAJummVmgsvbkmJceeKs1f1v9PmkOoSPn/wPf784ue6SM7ieD2xJaKZNofKKzrZXxZY59W+yWtqUnctlahT+wUSpHNjqTNoUPzZ0TKGtn9Ub4EJiQn5UOjKx10W86KsFvQQPPYQbN0FWAd4vpsYB6Iio8Kjr/l26NoA4GidRM4QHD7tA2LW2jig/sGspcW6cPDjQPlqpunF8PFlKKDc62cbfmpibP5EeO8x2mm3/gicvljOOtN9yftQDECNsQT3LHxtfizrTzheGIaSZZ9Q+jIXdBPMpDABkPsOUlIIWAzByclxwUQaNSDSMvxuQMglIO+qPuTtSEydR+h9JVckGooYAKDlzGiW1I4OJKPQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(36840700001)(356005)(7636003)(110136005)(2906002)(316002)(86362001)(186003)(6666004)(36756003)(8936002)(36860700001)(82740400003)(70206006)(5660300002)(4326008)(47076005)(83380400001)(966005)(2616005)(1076003)(478600001)(336012)(70586007)(107886003)(34020700004)(82310400003)(54906003)(8676002)(426003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:05.2343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 189f57ac-8b41-41b7-9ee6-08d8e2d6199b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4641
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex and Cornelia,

This series split the vfio_pci driver into 2 parts: pci drivers and a
subsystem driver that will also be library of code. The main pci driver,
vfio_pci.ko will be used as before and it will bind to the subsystem
driver vfio_pci_core.ko to register to the VFIO subsystem.
New vendor vfio pci drivers were introduced in this series are:
- igd_vfio_pci.ko
- nvlink2gpu_vfio_pci.ko
- npu2_vfio_pci.ko

These drivers also will bind to the subsystem driver vfio_pci_core.ko to
register to the VFIO subsystem. These drivers will also add vendor
specific extensions that are relevant only for the devices that will be
driven by them. This is a typical Linux subsystem framework behaviour.

This series is coming to solve some of the issues that were raised in the
previous attempt for extending vfio-pci for vendor specific
functionality: https://lkml.org/lkml/2020/5/17/376 by Yan Zhao.

This solution is also deterministic in a sense that when a user will
bind to a vendor specific vfio-pci driver, it will get all the special
goodies of the HW. Non-common code will be pushed only to the specific
vfio_pci driver.
 
This subsystem framework will also ease on adding new vendor specific
functionality to VFIO devices in the future by allowing another module
to provide the pci_driver that can setup number of details before
registering to VFIO subsystem (such as inject its own operations).

Below we can see the proposed changes:

+-------------------------------------------------------------------+
|                                                                   |
|                               VFIO                                |
|                                                                   |
+-------------------------------------------------------------------+
                                                             
+-------------------------------------------------------------------+
|                                                                   |
|                           VFIO_PCI_CORE                           |
|                                                                   |
+-------------------------------------------------------------------+

+--------------+ +------------+ +-------------+ +-------------------+
|              | |            | |             | |                   |
|              | |            | |             | |                   |
|   VFIO_PCI   | |IGD_VFIO_PCI| |NPU2_VFIO_PCI| |NVLINK2GPU_VFIO_PCI|
|              | |            | |             | |                   |
|              | |            | |             | |                   |
+--------------+ +------------+ +-------------+ +-------------------+

Patches (1/9) - (4/9) introduce the above changes for vfio_pci and
vfio_pci_core.

Patches (6/9) and (7/9) are a preparation for adding nvlink2 related vfio
pci drivers.

Patch (8/9) introduce new npu2_vfio_pci and nvlink2gpu_vfio_pci drivers
that will drive NVLINK2 capable devices exist today (IBMs emulated PCI
managment device and NVIDIAs NVLINK2 capable GPUs). These drivers add
vendor specific functionality that is related to the IBM NPU2 unit which
is an NVLink2 host bus adapter and to capable NVIDIA GPUs.

Patch (9/9) introduce new igd_vfio_pci driver for adding special extensions
for INTELs Graphics card (GVT-d).

All new 3 vendor specific vfio_pci drivers can be extended easily and
new vendor specific functionality might be added to the needed vendor
drivers. In case there is a vendor specific vfio_pci driver for the
device that a user would like to use, this driver should be bounded to
that device. Otherwise, vfio_pci.ko should be bounded to it (backward
compatability is also supported).

This framework will allow adding more HW specific features such as Live
Migration in the future by extending existing vendor vfio_pci drivers or
creating new ones (e.g. mlx5_vfio_pci.ko that will drive live migration
for mlx5 PCI devices and mlx5_snap_vfio_pci.ko that will drive live
migration for mlx5_snap devices such as mlx5 NVMe and Virtio-BLK SNAP
devices).

Testing:
1. vfio_pci.ko was tested by using 2 VirtIO-BLK physical functions based
   on NVIDIAs Bluefield-2 SNAP technology. These 2 PCI functions were
   passed to a QEMU based VM after binding to vfio_pci.ko and basic FIO
   read/write was issued in the VM to each exposed block device (vda, vdb).
2. igd_vfio_pci.ko was only compiled and loaded/unloaded successfully on x86 server.
3. npu2_vfio_pci.ko and nvlink2gpu_vfio_pci.KO were successfully
   compiled and loaded/unloaded on P9 server + vfio probe/remove of devices (without
   QEMU/VM).

Note: After this series will be approved, a new discovery/matching mechanism
      should be introduced in order to help users to decide which driver should
      be bounded to which device.

changes from v2:
 - Use container_of approach between core and vfio_pci drivers.
 - Comment on private/public attributes for the core structure to ease on
   code maintanance.
 - rename core structure to vfio_pci_core_device.
 - create 3 new vendor drivers (igd_vfio_pci, npu2_vfio_pci,
   nvlink2gpu_vfio_pci) and preserve backward compatibility.
 - rebase on top of Linux 5.11 tag.
 - remove patches that were accepted as stand-alone.
 - removed mlx5_vfio_pci driver from this series (3 vendor drivers will be enough
   for emphasizing the approch).

changes from v1:
 - Create a private and public vfio-pci structures (From Alex)
 - register to vfio core directly from vfio-pci-core (for now, expose
   minimal public funcionality to vfio pci drivers. This will remove the
   implicit behaviour from v1. More power to the drivers can be added in
   the future)
 - Add patch 3/9 to emphasize the needed extension for LM feature (From
   Cornelia)
 - take/release refcount for the pci module during core open/release
 - update nvlink, igd and zdev to PowerNV, X86 and s390 extensions for
   vfio-pci core
 - fix segfault bugs in current vfio-pci zdev code

Max Gurtovoy (9):
  vfio-pci: rename vfio_pci.c to vfio_pci_core.c
  vfio-pci: rename vfio_pci_private.h to vfio_pci_core.h
  vfio-pci: rename vfio_pci_device to vfio_pci_core_device
  vfio-pci: introduce vfio_pci_core subsystem driver
  vfio/pci: introduce vfio_pci_device structure
  vfio-pci-core: export vfio_pci_register_dev_region function
  vfio/pci_core: split nvlink2 to nvlink2gpu and npu2
  vfio/pci: export nvlink2 support into vendor vfio_pci drivers
  vfio/pci: export igd support into vendor vfio_pci driver

 drivers/vfio/pci/Kconfig                      |   53 +-
 drivers/vfio/pci/Makefile                     |   20 +-
 .../pci/{vfio_pci_igd.c => igd_vfio_pci.c}    |  159 +-
 drivers/vfio/pci/igd_vfio_pci.h               |   24 +
 drivers/vfio/pci/npu2_trace.h                 |   50 +
 drivers/vfio/pci/npu2_vfio_pci.c              |  364 +++
 drivers/vfio/pci/npu2_vfio_pci.h              |   24 +
 .../vfio/pci/{trace.h => nvlink2gpu_trace.h}  |   27 +-
 ...io_pci_nvlink2.c => nvlink2gpu_vfio_pci.c} |  296 +-
 drivers/vfio/pci/nvlink2gpu_vfio_pci.h        |   24 +
 drivers/vfio/pci/vfio_pci.c                   | 2433 ++---------------
 drivers/vfio/pci/vfio_pci_config.c            |   70 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2245 +++++++++++++++
 drivers/vfio/pci/vfio_pci_core.h              |  242 ++
 drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
 drivers/vfio/pci/vfio_pci_private.h           |  228 --
 drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |   12 +-
 18 files changed, 3528 insertions(+), 2803 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_igd.c => igd_vfio_pci.c} (58%)
 create mode 100644 drivers/vfio/pci/igd_vfio_pci.h
 create mode 100644 drivers/vfio/pci/npu2_trace.h
 create mode 100644 drivers/vfio/pci/npu2_vfio_pci.c
 create mode 100644 drivers/vfio/pci/npu2_vfio_pci.h
 rename drivers/vfio/pci/{trace.h => nvlink2gpu_trace.h} (72%)
 rename drivers/vfio/pci/{vfio_pci_nvlink2.c => nvlink2gpu_vfio_pci.c} (57%)
 create mode 100644 drivers/vfio/pci/nvlink2gpu_vfio_pci.h
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 create mode 100644 drivers/vfio/pci/vfio_pci_core.h
 delete mode 100644 drivers/vfio/pci/vfio_pci_private.h

-- 
2.25.4

