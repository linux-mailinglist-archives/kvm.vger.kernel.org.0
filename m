Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A43F8572
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbhHZKk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:40:28 -0400
Received: from mail-bn8nam11on2071.outbound.protection.outlook.com ([40.107.236.71]:47840
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233929AbhHZKk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:40:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7+vwEg+oI/8HdMo6VAP6yb6YoNKZrogRU2xzzY76t8RWESa6PTEFBaMLD6D4cyp+jbZZkpRgv7CzmQNA0YbhmcXRzHFZ+0QQ2wCF1/VdY2wnqqKTO5lxAmw7LIZ05MW938SFx/x/xexig1zfr7jUNGmkfeMLgaYvkCybX9Dkwlq8jqi3AAz6Vo+T4ygaVq80Xis6F8nMmdxmgw/LqmMj39+DsCBbGTfnVq9SQ8X7uXt39ww8u/zMWSlxQSXlcqBuZ8WGo73J0x9pDcD7M5qTmQR73DV9ILr40PVs9prywSqtpmiT00qnyY9sxTxt4KIF9gZzixWZqXUtTjvjimtVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHYHs2I1P0FRYV6fMpgKsyhehrikvnSnGXbPAuKZjYE=;
 b=RB4ykvTz8u7FqU6N1Ffj3t8eSwgz+M7wURFk3Z786qkT46+BFzeJJY9HAhjWLhzUwVr3TQVt8jLdqcKvMNOgB4elVBUSMt5YFUlapZwIKz5GIWCGBpGSzI+A5XiJDURviQD9xjDqqIhONDWD2yIqBBUl9nJ+8S0rBgHdUprppSVX2NDs24XvNCPFFk4Jy46Bq0gmteFZpV6381N0K4IZ9dJBgmj/Ikw/1eRmWp3NmWO1foHIIN+zK5V02ZmwKCu8M+0KxA8t5yFU4B3HLgR7dYySWq8kerLsqDmD0+gTUDsYUMbYNhqUMcls0iT/9kKQB4fcxy8ELBzFVSGm8Dv0Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHYHs2I1P0FRYV6fMpgKsyhehrikvnSnGXbPAuKZjYE=;
 b=gsLFCChWKkFr2PFJjiddasdUPg4ugbKQoev/zlHvKdK8jsn1kYJFouVcb1tEkFxfBgm2mqGXj2nifQ7FFpBL6xrq1614WGqbKRv7vcdmLsxqCn7Em4Gx/ET39u2vpOOmvQiy3DJxueQMPWFVWHs7KzeL/m+xl5OPLV0FZSLKJ1y6U6fiFiffD8cxQnGoOXLYlxZsu4477SMW5/sBLrgolmasqXr+a30eJ4Eo7BmjdkhJINZtHzBdmoww3QrR8ITbrijtI352nVv60vJvqIAnHVO1q3FPUvdwOuUBlmz40tBYteQphF6ScXkTXz/HOCmQwk5I/c9GfC3ui+kP8AHAGA==
Received: from MW4PR03CA0198.namprd03.prod.outlook.com (2603:10b6:303:b8::23)
 by DM6PR12MB4091.namprd12.prod.outlook.com (2603:10b6:5:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Thu, 26 Aug
 2021 10:39:37 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::ff) by MW4PR03CA0198.outlook.office365.com
 (2603:10b6:303:b8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:39:37 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:39:36 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:32 +0000
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
Subject: [PATCH V5 00/13] Introduce vfio_pci_core subsystem
Date:   Thu, 26 Aug 2021 13:38:59 +0300
Message-ID: <20210826103912.128972-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8406dacc-1728-410f-19a0-08d9687dcd3e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4091:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4091808CA57F182356021CD4C3C79@DM6PR12MB4091.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WnyL8sI//FXnTijjG6N2e7UTJybje2bfucOULhp7jU/mOPjkpAeuiDkM4d52R6OtVOt5P5MjzwKZLmAMz05s0YN/s8kTjIzvzjLuGcKPTbxlmoEpun1DmnJMWLucUFTk9oyaQcpzo/pYEPCDLD640taRooBwC4C1XYZSXW0+d53lzfsoXPY27Ri8EjLOn5Xw3P6BhVykOKk0+dyi1CZHRKgVh3qO1K9nOw8W4w2wJT2aWk/gGCyhxZGxCTKfupCelfLvJ9M5A88KF/V5RfQ9qGzryLCpBC+ZsQaHuzvwWOd6v/Po7AMFL8hYgpOab6r0lMI/masd+VA2fup+7Dm8BE6N8Pt5rE49HR1gtu58VJFd6RM+wJPbnH9xlVvt9z4ws3N/mXwqasfsIkc/R4a11hO0A0d/MOU/94Ahr6IdH75bOfVK7YqDOBnD8ANSbWOc3M0FtcwBjkaSCOsKuULrwkdulPVRhNaXhrNv2GqEvWTWyrIpP4fZjt2P0EC0v0I/t10XaZvFRK2IqfKr+ePsfeD6U8/V5vHtFZgOfnQRQFnw3ao+bhVxfFwSyUU8dpGaNhWB8eG+lrcz1EycBc0ktAvzkUNH5IBHMFfL//uMoiiN789hyT1e6GB2HjVT6QyzKKQWAiktLbzk88KcEbu3JAWirVOh61ssNR3ipgKSn9QsmnhMldQJNrZJzvN6aZ8HBt9jNlAv4guYQcYU3kFGgoQErOiMRhqCi3B0ZPVEeIIKtgeWJfHb1bJKlO5UfvUmUU/VgrAr7NZ4zaOG8siFVzwCbTREZpbpYJPe0O0K0zktjslQsZtkF+dr6mQVblI9Nud1Zx/GG30DoBbkYJ8jWmItvi1uudDUHgbKEyCDP3k=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(2616005)(107886003)(7416002)(110136005)(54906003)(70586007)(36756003)(26005)(966005)(426003)(86362001)(316002)(70206006)(336012)(5660300002)(47076005)(6666004)(36906005)(1076003)(478600001)(83380400001)(186003)(82310400003)(8676002)(7636003)(7696005)(82740400003)(356005)(2906002)(36860700001)(4326008)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:39:37.2116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8406dacc-1728-410f-19a0-08d9687dcd3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

v5:
- Add Reviewed-by: Christoph Hellwig and Acked-by: Bjorn Helgaas to the
  relevant patches.

Patch #9:
- Rephrase commit log as was suggested by Bjorn Helgaas.

Patch #10:
- Use a switch statement to enforce a valid override_only value as was
  asked by Alex Williamson.

v4:
Patch #6:
- Delete might_sleep() from the vfio_pci_sriov_configure() path as the
  annotation through mutex_lock() which is used down the road is enough
  on its own.

Patch #13:
- Add include/linux/vfio_pci_core.h to the MAINTAINERS file as was
  previously asked by Alex Williamson.

v3:
Patch #6:
- Upon error flow, print PF driver name instead of hard-coded vfio-pci.
Patch #9:
- Split into two patches and follow the notes given by Bjorn Helgaas.

v2:
Patch #6:
- Drop DRIVER_VERSION as it's useless and not required any more.

Patch #9:
- Follow Bjorn Helgaas suggestion to enable having "vfio_" prefix in
  modules.alias file without the unnecessary VFIO connection in
  pci_match_device.

- Add the sequence of commands/algorithm that is required by
  userspace to discover the matching driver to the commit message to let
  the patch documentation be self-contained.

Patch #12:
- Save compatibility with Kconfig as was asked in the mailing list.
- Drop DRIVER_VERSION as it's useless and not required any more.

Yishai

Jason Gunthorpe (2):
  vfio: Use select for eventfd
  vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'

Max Gurtovoy (10):
  vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
  vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
  vfio/pci: Rename vfio_pci_device to vfio_pci_core_device
  vfio/pci: Rename ops functions to fit core namings
  vfio/pci: Include vfio header in vfio_pci_core.h
  vfio/pci: Split the pci_driver code out of vfio_pci_core.c
  vfio/pci: Move igd initialization to vfio_pci.c
  PCI: Add 'override_only' field to struct pci_device_id
  PCI / VFIO: Add 'override_only' support for VFIO PCI sub system
  vfio/pci: Introduce vfio_pci_core.ko

Yishai Hadas (1):
  vfio/pci: Move module parameters to vfio_pci.c

 Documentation/PCI/pci.rst                     |    1 +
 MAINTAINERS                                   |    1 +
 drivers/pci/pci-driver.c                      |   28 +-
 drivers/vfio/Kconfig                          |   29 +-
 drivers/vfio/fsl-mc/Kconfig                   |    3 +-
 drivers/vfio/mdev/Kconfig                     |    1 -
 drivers/vfio/pci/Kconfig                      |   40 +-
 drivers/vfio/pci/Makefile                     |    8 +-
 drivers/vfio/pci/vfio_pci.c                   | 2262 +----------------
 drivers/vfio/pci/vfio_pci_config.c            |   70 +-
 drivers/vfio/pci/vfio_pci_core.c              | 2158 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_igd.c               |   19 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
 drivers/vfio/platform/Kconfig                 |    6 +-
 drivers/vfio/platform/reset/Kconfig           |    4 +-
 include/linux/mod_devicetable.h               |    6 +
 include/linux/pci.h                           |   29 +
 .../linux/vfio_pci_core.h                     |   89 +-
 scripts/mod/devicetable-offsets.c             |    1 +
 scripts/mod/file2alias.c                      |   17 +-
 22 files changed, 2525 insertions(+), 2311 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_core.c
 rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)

-- 
2.18.1

