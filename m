Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473203F07ED
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240027AbhHRPSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:18:18 -0400
Received: from mail-dm6nam11on2052.outbound.protection.outlook.com ([40.107.223.52]:38497
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239871AbhHRPSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:18:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDvfsROe3igRPctTuylW3WkbCBl+15NhHIEpt5mmp8RRqf/I76hXtGUT7AHSFCyaEWANpEAQ7EUAGrhN9z/QrXV/4Plcw76fd5yqExYl8k2OkQpOFvWne135cfsGPFLIxXVkBNjFy4qb0znGyJGDEGKPP3OK1mwxCYqjB1t5UYsdiyzMOlqnofE4W8pDtqihZ/FbIIMjSCy0TFqu+3+ESeVWmLgECZtUEGBOmBqJRNJV89uURzCzIecd/DnyOv9sRlELqpRMnke4JJTriSfFmAxOJd3Am52oLZm4nkUDGwPSRl6x9is9WKomkqHjTezzi4v0Es+WhrbOe/HzvqnIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=Wu2pKyJOR7HKvkam8yhzVeJvsxukTB4yjGm6J/T3Mmhag2hN0X9bzvD0N6zLiC+mKUg3iW1rjqvyuJoOcCULHbGEEJftSSgIXuGnsSja2QomZxXAMxBzx8dM3+nNSr3oEfVf5JnfOoIWL3+pcDlYNiY+mnadQVL1Os8/HX7DzCXVzduZD/bgBLP6M90m2VG2hkph+YjwdZNEZk8grkh9yJapyx9Ra4APA5K0exwQkVY/QwK+4Ab8OIyLZpoHvDMdsUrSuyJxLPwZux75kSKd6yQjokCh+CtP6Mp8QZTZN6K3JPnIfIOUzf4jT1V/rHSGWsCXhCUk5/bTb1ii+13YQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=gU1wutN9RIzYh2cLg7taAfNqE6GEN4iE+cMtlggxRG9HRrip3+/IsuoOY7rL8twihOmjQc4t4+cpxqYnGw+hwDll2DYHziaPDVjKvCQ+7vXtKGNcvJZ+suk0gi2zAYaPVAmmtmqm2Ws42e7I1eQYPf9LzqwqB9PQJCb0jbnARjxQnp/15loZ/Y69fxyg0j/Yrq/wp2NuxXV+lwOiLuWI8EoIXgTgk96ERM2Cwt0JnMyxzGYGZhtEeCSV13K7D6gOIrinucAxsaynkK49iYce5lksGKFFxbLau0Qjt4y9GXGE/1qlcSdg6ZihqQ9gsTheUT/MSbdwfHeSEsCq1kCwiw==
Received: from BN9PR03CA0572.namprd03.prod.outlook.com (2603:10b6:408:10d::7)
 by MN2PR12MB4816.namprd12.prod.outlook.com (2603:10b6:208:1b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 15:17:33 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::7d) by BN9PR03CA0572.outlook.office365.com
 (2603:10b6:408:10d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:33 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:17:32 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:28 +0000
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
Subject: [PATCH V2 11/12] vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'
Date:   Wed, 18 Aug 2021 18:16:05 +0300
Message-ID: <20210818151606.202815-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca978e8c-7597-4227-848a-08d9625b4dad
X-MS-TrafficTypeDiagnostic: MN2PR12MB4816:
X-Microsoft-Antispam-PRVS: <MN2PR12MB48168C78C8ECD68E97DF1C9EC3FF9@MN2PR12MB4816.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiGkxPdAYWwVctDo6f/XVhvlZE5Lgeolcpn6gHdvkgvm0zT1TVb6E9mRd7M+oyJzVWE8KSURwqthSqx6yry9ZfQVWBxPfbf13UiUm1BpbUUvdk1kf0iFDSzoY9YGXHKhoFURKDAKb+aOdungSjtTtIXkRo1dCGBM3I52vsD5mhS5YgqeSCWmEsP3K2amophqgZl3oRv15IC4rqcB6UvyxBIehB0mB4ylL9Sfi/px0GcPwzF9cVlFulAl4dWwDgjWQjVuNohkcW6wcQjColAw+sgGYXzyE7tIEzWiDHDu+n+j6Zcct2aaKc7UnLNpGfmzRMXywiltbb/amOGmFRQg948bUkzB9yKqa72QbOwq3mytliWh/8uomtHtpoVTnlMesaYfeGeKiDwZ7sPgdNeDNAKqss40/kBz6hfPw6HIoWK0GLx6626GjCkZULeM9UGYVEGvkOYaFYVqN46GG2rIwyo7lQ9HMgXXMmi/AbPH1Fs7ydlXxNyCJ62XUqe94DaAvzSKVPuywmEFf5GOB/Wm3u+aKFt09d1BawWI9M3mjJoy8RThk6FzAFz3ThywGhB1u3yRuOhRkfgvjGCDOfXxW5BEtACNpe29ymDvO5+KgZbOsFiMmb1dgC6T1vwgmUd7U11apOq1HXhZnHhhwH20zXpa/YLM973LSUTc6pWEmb/Om6CVe2FFXQ+PqD4KCxJc9dVCmn+Y7nQ5qmdyykuMhjQGDuVlJ7D2uA6xynvxCq8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(46966006)(36840700001)(82310400003)(478600001)(54906003)(110136005)(36860700001)(70206006)(70586007)(2906002)(1076003)(7636003)(6666004)(356005)(8936002)(316002)(36906005)(83380400001)(86362001)(5660300002)(36756003)(47076005)(7696005)(4326008)(336012)(426003)(82740400003)(2616005)(8676002)(7416002)(26005)(186003)(107886003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:33.2780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca978e8c-7597-4227-848a-08d9625b4dad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4816
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

