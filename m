Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1209C3F7691
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhHYNxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:40 -0400
Received: from mail-bn8nam12on2065.outbound.protection.outlook.com ([40.107.237.65]:32384
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241567AbhHYNxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BllVdBFl+9LOI2pnl2zJAxBZsYbBx5C/BtEw7zvM447oqdrHR674eDxGLTHRmdaGwvcrug8eYRUaefQwz44eDbOikPhsvipsFVcdByC3nL77mvdgbXrP8dSo+u2f2nti1mLnBD4N8vXbE1H5ZmhWZLEgYMH6KMI3CqELVdKWXj+4UpMkLXo0DnjdVUCrRPfy6jYkvC2SM3v4Sb7COROGUJzcm8YSDeHruzGHpOJQtdEpabeIPvwQXy22Ey9z3roLvJnpxfuSsvdVUj3gnbuKEUeUZNCYX2AKQRyazDy2sJpZxDJ0j71Qa0BrugToXk6Vt3AS8j8hGQKiIRRCzHhq8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=CKrOl6v9otGZJCaA+MqVncr1Nj+gmchdC63PCBfzMoOYfefxex1UadIbV18fjEfiamvLXiNfE3X34YrgOlbRFqoLJYQZGmdiDzfS5LPCs24JUP6VJaAwii7LeejyuNC1cB1j+2sVdvbwUrcmYEYc1fLhkcO+XXADB/PVmhFMkIxiyVdM42p+Bwku2xwmiL3LOe7Bw/mZWR2j4dXyuI4KHlfCN+xcDDfHn5CU0ahyiOQAlL7RFfrf9hKo6E8683ixmQUtzVRBcbmOwnuSAs2vMr5qYObAkAQlhb5NLtbWVKz/gxnegeZQrwI91dZ+z5ZwO2d3z87lsxwNMZtdANN17A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=K0pBPxHo/sGkPZ4QtyMolPSasOe0VPcI4dd06DMEvlM3T3SbILCFjQrleEqG9Op5+fNgMx7/RyDaHmdvFGGcsK9A30u9o+KGYqAJQto8A6IzMw5zopAMAwkpVuiX5rmrpjvkkdLwl72GZVQczr+kEBejmOYS9A3+tGMeIIRl7aVnSuZYYKlSewmwIr41ui839NS8V1lYdw9QWBZeiu1YFFTYp5hyCOErf7r+awgkg2nk8Kw56GhsfiTgBcZe4mjJTt0R3Raew/iqZJ39oZQDqe01gEAFl1mbg11FiK7D3FHivZoAWzWrt4x5JH8/d70VgQC051VJebpf3j/mmL8k/g==
Received: from MW4PR04CA0014.namprd04.prod.outlook.com (2603:10b6:303:69::19)
 by DM6PR12MB2809.namprd12.prod.outlook.com (2603:10b6:5:4a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 13:52:50 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:69:cafe::54) by MW4PR04CA0014.outlook.office365.com
 (2603:10b6:303:69::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:50 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 06:52:49 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:45 -0700
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
Subject: [PATCH V4 12/13] vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'
Date:   Wed, 25 Aug 2021 16:51:38 +0300
Message-ID: <20210825135139.79034-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b8cfc58-0ac3-43a8-f6cb-08d967cfa0dd
X-MS-TrafficTypeDiagnostic: DM6PR12MB2809:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2809FA690F7B816187D9E2B4C3C69@DM6PR12MB2809.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOj9zq1ex0oXN1vjRynpwgp8d6c718HLLCANGp9hdcxOG0in+CHuwT4wrFsU/FFJbl9RWpp6VSoGf6DMLEKA2W0mEosO+zkc0qd+tPzgK3bM5nm/7m6VKZUlkMKtUsMD+MpO3YBoEX29kMMMFX0cjIu16pnYVgzLAZATsWBWQybaiE5vO4IQx4AgIJwUOXjECeQArIhr5askAvs/AuRoAP98RR3ljazc2Hdd0fwHH6TsdQ6gf3GVoGTgXBPcin2qBgzGla1yJNwq+3HCDc75Ubv2xYx3gdUzZE0k+BNHIm6DmQ8SoBVd4e3CyNi7oWne7DLqCxpoXqJiYDQ6bsyQN+wwOzPYv3gwHKNuiVU1YYmSkgUI43pm9MiL+5b3jwgxkfMWrWWsRvysuYCsD54qeAcm1eZn624NLtZM5ttREFyREsDl4QcAeLsLJyzhle1wDn200Db94dL2PlFfN/740ISss8FFCyAe2aadx0X4keh3yGmx5N3cKjl7J9v20F0hYvYezpJxTL4JH9tqyK7yq1TIdbqLq2ta3c/5DO43b1MoqlLeYa3TQeGj5GlNCBhOOFsvWCsU0s0mjIfrcRqRLl8CoqtUZ3KVi+l9R84dECvi8GrU4/lzY2R0EjNnS3L6OI/um9rMYdhSrFzyx+gN3rsRB8UNAlJl961pxuM6Ph37MkwTb9KdswK4UocnLqaR8iIS+I/8xk+4k64o2G5XHHawxdziKMYpm+5ORCfbdQQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(46966006)(36840700001)(70586007)(426003)(70206006)(7696005)(356005)(86362001)(1076003)(2616005)(336012)(8676002)(7636003)(82740400003)(8936002)(36756003)(7416002)(6666004)(83380400001)(4326008)(110136005)(107886003)(26005)(316002)(54906003)(5660300002)(82310400003)(186003)(2906002)(478600001)(47076005)(36860700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:50.3458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8cfc58-0ac3-43a8-f6cb-08d967cfa0dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2809
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This results in less kconfig wordage and a simpler understanding of the
required "depends on" to create the menu structure.

The next patch increases the nesting level a lot so this is a nice
preparatory simplification.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Kconfig                | 28 ++++++++++++++--------------
 drivers/vfio/fsl-mc/Kconfig         |  2 +-
 drivers/vfio/mdev/Kconfig           |  1 -
 drivers/vfio/pci/Kconfig            | 11 ++++++-----
 drivers/vfio/platform/Kconfig       |  6 ++++--
 drivers/vfio/platform/reset/Kconfig |  4 +---
 6 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 698ca35b3f03..6130d00252ed 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -1,12 +1,22 @@
 # SPDX-License-Identifier: GPL-2.0-only
+menuconfig VFIO
+	tristate "VFIO Non-Privileged userspace driver framework"
+	select IOMMU_API
+	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	help
+	  VFIO provides a framework for secure userspace device drivers.
+	  See Documentation/driver-api/vfio.rst for more details.
+
+	  If you don't know what to do here, say N.
+
+if VFIO
 config VFIO_IOMMU_TYPE1
 	tristate
-	depends on VFIO
 	default n
 
 config VFIO_IOMMU_SPAPR_TCE
 	tristate
-	depends on VFIO && SPAPR_TCE_IOMMU
+	depends on SPAPR_TCE_IOMMU
 	default VFIO
 
 config VFIO_SPAPR_EEH
@@ -16,23 +26,11 @@ config VFIO_SPAPR_EEH
 
 config VFIO_VIRQFD
 	tristate
-	depends on VFIO
 	select EVENTFD
 	default n
 
-menuconfig VFIO
-	tristate "VFIO Non-Privileged userspace driver framework"
-	select IOMMU_API
-	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
-	help
-	  VFIO provides a framework for secure userspace device drivers.
-	  See Documentation/driver-api/vfio.rst for more details.
-
-	  If you don't know what to do here, say N.
-
 config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
-	depends on VFIO
 	help
 	  VFIO is built on the ability to isolate devices using the IOMMU.
 	  Only with an IOMMU can userspace access to DMA capable devices be
@@ -49,4 +47,6 @@ source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
 source "drivers/vfio/fsl-mc/Kconfig"
+endif
+
 source "virt/lib/Kconfig"
diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index 6df66813c882..597d338c5c8a 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -1,6 +1,6 @@
 config VFIO_FSL_MC
 	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
-	depends on VFIO && FSL_MC_BUS
+	depends on FSL_MC_BUS
 	select EVENTFD
 	help
 	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 763c877a1318..646dbed44eb2 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -2,7 +2,6 @@
 
 config VFIO_MDEV
 	tristate "Mediated device driver framework"
-	depends on VFIO
 	default n
 	help
 	  Provides a framework to virtualize devices.
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index d208a95a2767..afdab7d71e98 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PCI
 	tristate "VFIO support for PCI devices"
-	depends on VFIO && PCI
+	depends on PCI
 	depends on MMU
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
@@ -11,9 +11,10 @@ config VFIO_PCI
 
 	  If you don't know what to do here, say N.
 
+if VFIO_PCI
 config VFIO_PCI_VGA
 	bool "VFIO PCI support for VGA devices"
-	depends on VFIO_PCI && X86 && VGA_ARB
+	depends on X86 && VGA_ARB
 	help
 	  Support for VGA extension to VFIO PCI.  This exposes an additional
 	  region on VGA devices for accessing legacy VGA addresses used by
@@ -22,16 +23,14 @@ config VFIO_PCI_VGA
 	  If you don't know what to do here, say N.
 
 config VFIO_PCI_MMAP
-	depends on VFIO_PCI
 	def_bool y if !S390
 
 config VFIO_PCI_INTX
-	depends on VFIO_PCI
 	def_bool y if !S390
 
 config VFIO_PCI_IGD
 	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
-	depends on VFIO_PCI && X86
+	depends on X86
 	default y
 	help
 	  Support for Intel IGD specific extensions to enable direct
@@ -40,3 +39,5 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
+
+endif
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 7f78eb96a5d5..331a5920f5ab 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM
 	tristate "VFIO support for platform devices"
-	depends on VFIO && (ARM || ARM64 || COMPILE_TEST)
+	depends on ARM || ARM64 || COMPILE_TEST
 	select VFIO_VIRQFD
 	help
 	  Support for platform devices with VFIO. This is required to make
@@ -10,9 +10,10 @@ config VFIO_PLATFORM
 
 	  If you don't know what to do here, say N.
 
+if VFIO_PLATFORM
 config VFIO_AMBA
 	tristate "VFIO support for AMBA devices"
-	depends on VFIO_PLATFORM && (ARM_AMBA || COMPILE_TEST)
+	depends on ARM_AMBA || COMPILE_TEST
 	help
 	  Support for ARM AMBA devices with VFIO. This is required to make
 	  use of ARM AMBA devices present on the system using the VFIO
@@ -21,3 +22,4 @@ config VFIO_AMBA
 	  If you don't know what to do here, say N.
 
 source "drivers/vfio/platform/reset/Kconfig"
+endif
diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index 1edbe9ee7356..12f5f3d80387 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM_CALXEDAXGMAC_RESET
 	tristate "VFIO support for calxeda xgmac reset"
-	depends on VFIO_PLATFORM
 	help
 	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
 
@@ -9,7 +8,6 @@ config VFIO_PLATFORM_CALXEDAXGMAC_RESET
 
 config VFIO_PLATFORM_AMDXGBE_RESET
 	tristate "VFIO support for AMD XGBE reset"
-	depends on VFIO_PLATFORM
 	help
 	  Enables the VFIO platform driver to handle reset for AMD XGBE
 
@@ -17,7 +15,7 @@ config VFIO_PLATFORM_AMDXGBE_RESET
 
 config VFIO_PLATFORM_BCMFLEXRM_RESET
 	tristate "VFIO support for Broadcom FlexRM reset"
-	depends on VFIO_PLATFORM && (ARCH_BCM_IPROC || COMPILE_TEST)
+	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	default ARCH_BCM_IPROC
 	help
 	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
-- 
2.18.1

