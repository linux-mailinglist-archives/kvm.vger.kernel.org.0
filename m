Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919B43D13A7
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhGUPgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:36:48 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:57985
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232014AbhGUPgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:36:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcSZ0Ef8r9uK2O3wKazLprdTxxW/UZQgYkB0+6Wjqm00D1/RHq4V4/Ut5RI/13KxqKxTwzbQo0WgjhdlWV01PXvhCdHm7nsSAIvVMeiNvz8BqgPitSumwJG6RBp9C2hJC+wXWGm6QVjlpfyIsLBK8krbcml+2FTZtNKo2iP9fdAl5KamwYBHGS4wFhhtZ/RZb2Wt2WcRi0N1sVa73fIy3tJp/5CMvEhhbv7dHjwRwHhUn6yQICr26Re3XDwRV1D8O9/9Vj3nfvs4opFnp5YHzxTy5h4MC1ntnvHWXhOJA/ghnaq4M4KYNxL+Q41Aer6kBZlmWXCNk7lBVB57BjadXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8ZX6AXCZyWeTuh8CM3rz6v4t1ulLfOoWsAdKIbI2/o=;
 b=g5GQPJiBpfLUhKt1PYb0E3gzaclN4ch9CoSoKIt4A+Q+i6H6jjyNzJrksap763jQxAbDIOatUXAJt7ctanrwSqhbJJpqzs6+TZQPVNst5jrv3ERhFLsThxEVd0XG5qnqnPZSC69wsWJd592i8uvGDo5O/uLVCAlHofoGvXLE9IPuyjQqGY40b13IMXo5SS5C99RLIA9EXIdDTWI/aV1JXOpDUjS6S/D+iYBLhwrJJ8eNDVqvxfnOf0y7bR9557ZWzgCGLnspbO9rMVsNX0SD8wbUL2mQtz/6+MaDCfwx5NxrpuHTmMyUzGb6fzmWO+B1aQmcQ8Q7EEKQMHRYyGU0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8ZX6AXCZyWeTuh8CM3rz6v4t1ulLfOoWsAdKIbI2/o=;
 b=DV1PdQFEKAibkB00YB6fcqjvrlzr3u55Pc6kemSocZCS0BcE7IHg2kgb5L2Q0e8bXZQrA89wiwW5Q8ujn4qpNwQ7yllP9f/+f4o3ddAQ4lqBMzqnuR8EuweDYs8y5EBIYVHv9AFCGvrPiqh4o16LG9d8k2usaojpL7v7lrtX+u9OWqohymRgOvkXZFCA1cwPDteukukltsoavt5hRIeYl9mEL8psqdVa3mekniQSw0hhdZvSNH69i1GddL3gC5pYhoU6XuyQmBKNQym1+0qUC2qdKBMnRfJ8mVClbCdhMH8ExX+gCPExjefB0egDzigYR65jzXqx48WfVgeZ0eRscA==
Received: from MWHPR11CA0016.namprd11.prod.outlook.com (2603:10b6:301:1::26)
 by DM6PR12MB3225.namprd12.prod.outlook.com (2603:10b6:5:188::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Wed, 21 Jul
 2021 16:17:22 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:1:cafe::69) by MWHPR11CA0016.outlook.office365.com
 (2603:10b6:301:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:17:21 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:17 +0000
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
Subject: [PATCH 00/12] Introduce vfio_pci_core subsystem
Date:   Wed, 21 Jul 2021 19:15:57 +0300
Message-ID: <20210721161609.68223-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d668e02-2b88-4e23-aeee-08d94c63051f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3225:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3225729DD2641CDAD286D20EC3E39@DM6PR12MB3225.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7oU9+mzjm2y/97oIng6C7QotAa1eTXWhqGcyDgYtTwqf5Ra7uNPNJXB103hgFAYKaPj+AWIi4T8LxpuoRTHp780XjftCvUfMyU/BwJWb2zZNkKNWH2S9IDpHWMxZ4OHBO1IhbWyCHfnd0uYCAwysVlRpszu5lMfGOb2pHQ1wakcaEqAUStYi1cVY0+39FEy9Yk2CBy+geGVl+cxCaOr04o2KCNSkTTa5SAowfC6WPsWMCZfnwUjp/V/oXsfXmgQdrq9D3sGlESrDgtRp+uHreqXDDN3XqzD4bLO/h1y7LWzEk7YZmRTZYCr5mCRha8LyTbeRdBw3ZHACi8evhEO4J4nq2WEOz78p+Ud7w8yBlrgD5IS+7NkH1zg+0Xu5fTZ3SAm17j+77pmzEqng9Xe9B+WmUQgrbVMDwYqMKcpNiLHrBSSfvZ2cqLdxNTnRRqJw1RjS3ILaz3H3NigYWaZydLCSbed0UzwOyQhlJEF6krMwgVpmMSbma8yhTdXB7ISXWz2f649gAud7/PT3WBZk/zAuoa6naqYWsZnhabnDEDQWcApxoqJNLbtq7kDpjTLKA9+n744naA2tssUPpPUTVdYoZ5WTikEgTkAtWcvxIrs1ag99IMTYw6iHfsuPzWve2Ng0MAyiUfqbwC0wcu8kZzAAcmFrpi/oj7QQxG07B/5rcR9I75nmlRHJ5Dgq1Mp2bf+jRHoy2k48t5STdFi6xeUzjHFBV7jwH7Nekd2MD0rgSgqELnRTddQ2752ZxdXhPZBVNhXcE7V1RXhAoUQG62r8h1409u9jwWcHtFDKCA9ikNq5cKd35DxlZpRf+0mDy9SYKRPvQBtsSdiS3V+oeTD3bQcPc85eu8BnH/f42Y=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(36906005)(336012)(8936002)(110136005)(54906003)(7696005)(82310400003)(36860700001)(2616005)(6666004)(508600001)(7416002)(316002)(426003)(5660300002)(26005)(8676002)(2906002)(107886003)(4326008)(86362001)(70206006)(83380400001)(7636003)(966005)(36756003)(356005)(1076003)(47076005)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:21.9902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d668e02-2b88-4e23-aeee-08d94c63051f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3225
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prologue:

This is the second series of three to send the "mlx5_vfio_pci" driver
that has been discussed on the list for a while now. It comes on top of
the first series (i.e. Reorganize reflck to support splitting vfio_pci)
that was sent already and pending merge [1].

 - Split vfio_pci into vfio_pci/vfio_pci_core and provide infrastructure
   for non-generic VFIO PCI drivers.
 - The new driver mlx5_vfio_pci that is a full implementation of
   suspend/resume functionality for mlx5 devices.

A preview of all the patches can be seen here:
https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci

[1] https://lore.kernel.org/dri-devel/0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com/T/#t
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

1. https://lore.kernel.org/kvm/20200518024202.13996-1-yan.y.zhao@intel.com
   by Yan Zhao
2. https://lore.kernel.org/kvm/20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com
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
  PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id
  vfio/pci: Introduce vfio_pci_core.ko

Yishai Hadas (1):
  vfio/pci: Move module parameters to vfio_pci.c

 Documentation/PCI/pci.rst                     |    1 +
 drivers/pci/pci-driver.c                      |   25 +-
 drivers/vfio/Kconfig                          |   29 +-
 drivers/vfio/fsl-mc/Kconfig                   |    3 +-
 drivers/vfio/mdev/Kconfig                     |    1 -
 drivers/vfio/pci/Kconfig                      |   39 +-
 drivers/vfio/pci/Makefile                     |    8 +-
 drivers/vfio/pci/vfio_pci.c                   | 2238 +----------------
 drivers/vfio/pci/vfio_pci_config.c            |   70 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2138 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_igd.c               |   19 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
 drivers/vfio/platform/Kconfig                 |    6 +-
 drivers/vfio/platform/reset/Kconfig           |    4 +-
 include/linux/mod_devicetable.h               |    7 +
 include/linux/pci.h                           |   27 +
 .../linux/vfio_pci_core.h                     |   89 +-
 scripts/mod/devicetable-offsets.c             |    1 +
 scripts/mod/file2alias.c                      |    8 +-
 21 files changed, 2496 insertions(+), 2281 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)

-- 
2.18.1

