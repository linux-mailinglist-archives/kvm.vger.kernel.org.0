Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D327A3F4012
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhHVOic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:32 -0400
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:51298
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234391AbhHVOi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:38:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnx82wZ9schwFEholL08HXznTTTe+fGCMnOyKwtEPxEd3ncsjCnuGF7LQItSNsFscsTuFoIricgQYwIT6ipewESWximGOznskCgLQIvpf7ZWqOdBafLqBwV8pw8ordotIEDSy/Y92SQDM8SVNBihJxDQjXdL+Tw20n1iV2SWFyEkmCRPPf6c2uGVbS5HtcRkaPhdYQHLN/9A3COyL+oJdn3iGkTmnRERMRHX9jZ/7VplGbXCIzXnZC9C0OZkNL9gF7RuQOpPCzu9ymdkTahgYpyAbTVv+fkwWO1zXst3RMEaFhu6gR0DZIDpC9qxi6+Wgb5P+XlPo0LRzZ1NueSv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=jlQDYWp+fp7R5QBjJs91KeULmWDS1x/X4HuuucHYe0bjfP9eGu3TdBMuobGVCyPUoyIbk+EAm8ZDwNqweHuT8qH+6DTfErnSic3phoCSRPtz5snppwWlE1Vpr/A2VFh3O9F3GycPOSHqgwAH2y3uA75f7RxOQ53Xm62pKr4XRckdDtkH1HUXVvCAFHuqvPhSPVsGQ+ZwVc9aQ+fhKNsQMscewrrJ0SvYd9tgHfq0qHIpD4632WKhf1R31aOOhkqReXlWbDWqBp+x4IQ+NhpVMDwjm0eATG8FSiX4ZE0/N92EWJVgqKra0miuHnU2j1jQVPPqXkxKmyplLeocCDlSjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScvnVbH5aFpm4+rLMaeiRmg0U15ebcGKQVsrvV9fT14=;
 b=uDwqlArQ3laU5Wm5TODVy2+fEW/j9aPE16r2nWRhUYI7YqzaA94IhwPI6msnf93AbKuXPxNJKy11MrtKQQ/kJWWLf4jd3NucPOlmMsu/D45b5I/0LG1q06nMN1l4NtPRpqSkGghrXm8T6nqCeka8wdP89O/4utTmOn5BgCXPa9Voy1mVAGXrX5LNAfdDxvTv9Olnmh/5fNm44HCENXHQExgnRigLs+uNeastF3KwpVJNlh2ZgZdys8KuOTc/6M1ibLgOGhux4jWMoA18Ig6Z5DtpzpLC8rbXingMBYjznF/pfN+FIYu+pZvP0aUHNWNUbXueETM3IUg+1iJpd59EIg==
Received: from DM5PR11CA0016.namprd11.prod.outlook.com (2603:10b6:3:115::26)
 by DM6PR12MB3049.namprd12.prod.outlook.com (2603:10b6:5:11d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sun, 22 Aug
 2021 14:37:47 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::fc) by DM5PR11CA0016.outlook.office365.com
 (2603:10b6:3:115::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:47 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 07:37:46 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:42 +0000
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
Subject: [PATCH V3 12/13] vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'
Date:   Sun, 22 Aug 2021 17:36:01 +0300
Message-ID: <20210822143602.153816-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8320a2dc-88ac-4f42-171f-08d9657a68fd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3049:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3049BB02C3D450176D80B8D7C3C39@DM6PR12MB3049.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTFEYkGQwmV5Yaj2rqWLJDMuZC/w5AGpEuxehe8j8Pvwx17XQQrSyUH4mLIHFW9ayXmn91KxaiAzVjo3JW/f6ydPgRHEX9Ak/K4fY9hcqGLH8NBNozAlg6PTwl8PPHLP/Z5tQEIyYiVhJyqB5+/5EpxpcUjutlLDAG3SOwtuN9sI7826yALGJpnqBWtRusG5K5rA8UdRR9zov9dxsahzta4L8PS0CmqoCJKHjKFFot0apGGxj42GykzUtT+QvyItLJ22jmfC1NNuudAbP0OJ/J1A4DPtaH4hJ7gafA9DtquiVukxXRgW7L02zbWR13wKYzWIyNBQcJGYb4I+zqO6F3lQkB1hZzAbjlXEIrUrbJlkTMQHGBybReoTFvjJxHz5NVd0+DMrVsYWbJzyyHAqCOfjiJNcxFB0Pr48xc8q4fX8niMu1MGBZtPr3ml+DGMoqwPRfqPcEdQWTaTMLiTaCxGNscE8LCKFyHazvomcrbH9AfIRdHom/5n8XMrjS5rOOaDGHUlheXmTJIJDlOWzPbEzfbjzCGv9R14AhwWmyyPHkzSj+nIXZdPUODT2mbmDAgK38rgZILn413sbnrq9ZNJdbtdmAJoBY5yMxaG+fOnKlzXB+zitaAurevfeJnp+frtCLxLiMetlpV4yJXDRwJA9f9/suSmsD2pGXqmNzg1m+GexfEQ5mMQF+uCLkKwEPa8qr5dmOpnbBjTrScy9CgWRrQu6lrFRCgBhRm/J5/I=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(54906003)(6666004)(110136005)(7416002)(47076005)(4326008)(82740400003)(426003)(7636003)(1076003)(26005)(70586007)(186003)(82310400003)(356005)(86362001)(7696005)(70206006)(107886003)(5660300002)(2906002)(478600001)(8676002)(36860700001)(316002)(8936002)(336012)(36756003)(2616005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:47.0019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8320a2dc-88ac-4f42-171f-08d9657a68fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3049
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

