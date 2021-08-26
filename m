Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BB83F85AE
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241583AbhHZKlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:41:23 -0400
Received: from mail-sn1anam02on2051.outbound.protection.outlook.com ([40.107.96.51]:55915
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241773AbhHZKlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:41:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzTz45UiFLzwJ8HphOuOqaRrYM0j7LGDbCmKh+vLIuzBwVThuUXXYx9NT0ByJpYTap5PZoEzIZdZhGmYLJ2sgAn7Sw6tGiBkSwmAfEwncfCcbKnexEUUYShxL3zUv66+6rGOatPbTtNZLEpok3YiuQZ5hqK3KqU5fvpqaiHenYLfs1DnsmX2vxbqE+5gwyX2pUhUsMMlC+ThsAqSZeXUmSQlt5eiObGvtuOUqTO7/jM/5OTCJ7O5EKph4jpcpicNn2Q5Mv6brgx0bfDdF4RFwHtSNGHWAMjuuWs7NUp2fJBu6Vxi5bWskw+FNmQfbrTVVwoGrUAwhICzxExYWuPl4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIWrdSV2PJxyLxJI9bCslke1EeqUYnUyoVqCxuXESR4=;
 b=g+8/O8morVmigO+VQR0ANP9cCivevYqCj9Jcv9B6k/i3qGQ553zuwobM6y69CbIvIpkdQxnpwBIL6wzIuaWWs/5kbReXVMIIW2+GIRKSOjQvpLMrisrKouFdF16KcX7C5az6X8u+87Cfwaa/PBQqZ0TkybSYcDkS1gLymcdCR4jCqP10tjeBlQOiDdP3LYkJtgYoSSFhbNEf3EoNRRxQcnUQpRoX3v39+i0QDho8V8ti4F7b5V5wHRNTboIa13feQiq/LdaiWm74kN3V9LigS2V1Ee0gdwMZa38Qr4pA0tGrqPS2Dz50qSE+LbDERbls2XH7jmvKfE83uApQt7XGQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIWrdSV2PJxyLxJI9bCslke1EeqUYnUyoVqCxuXESR4=;
 b=lrljMe2vzFBrf/3HEsiRVfovEN7XJl4OxFWGuI9sYjH/NITdywnUBM/YtGDyuF5o35if+YFAgC2wrlWhLQ1spkhkSl1MUKVvpQhClKqP2bh4UzNiCP/YLGK8hcT2pJ4TM18ePNM8YibHWrH5aikl84oWEo8yqerj4kE32Tf5yrjbcIz5dwkt1TbQb1FhA7FZ5V28fn+15EPZlFjbMSfG/5CHMRQtPq4iVa6+UsMV531u4hy+5WPYWF82GUx33Jub72wnv1q0R0Xo7JfrjKjEiNC/2HlOVOat9nBC5013GTprsrGgBlWOSKT8iG8MC1LvVHXeHuZmevTXQZv8Y5L85g==
Received: from DM6PR06CA0024.namprd06.prod.outlook.com (2603:10b6:5:120::37)
 by MWHPR12MB1166.namprd12.prod.outlook.com (2603:10b6:300:7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 10:40:31 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::b5) by DM6PR06CA0024.outlook.office365.com
 (2603:10b6:5:120::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:40:30 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 03:40:30 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:25 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>, "Christoph Hellwig" <hch@lst.de>
Subject: [PATCH V5 12/13] vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'
Date:   Thu, 26 Aug 2021 13:39:11 +0300
Message-ID: <20210826103912.128972-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6511f09d-d77a-4a81-7624-08d9687ded25
X-MS-TrafficTypeDiagnostic: MWHPR12MB1166:
X-Microsoft-Antispam-PRVS: <MWHPR12MB116635124D9B914E00949268C3C79@MWHPR12MB1166.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZFU3Poilzq9siSfiyTEPuUtKXJGGOhD5470W2TuWiF7eyyVrot/Tg3W2QLA4rqYXTfN1D1N+wm/85M/h34VR5ba4KSDsOqzWJiM08ZCyJ/RomKiiRYuTw6VVHePcFo6RSg7UeRxk8Xgkc5dR22IAfE99QU3soRcuRBIHRWO+vMJft0Ct6sxj25psPP9WW7EFjQ35G+IHXkzWlYm4LAvWe6qWP8knNM/2JSfxLnJ4s/7t55GnNjY4qOYgn9UHmhwveXgO+lU4SNS911uqktZeSrjWOsVFdiHqhbcBB2UYFfMpfCKRqts/PeTaBzzM+8Lcr63W3JsIRR1icxqNoHexpMhYFoo+icWxD8imAWFq+YlCTPINjjpCQf4Ls0f4o0UhdOoKhIPkkGfjjCKBC94xiXyI+pHtratOOUJcCmSfAiAt6IavTlWt/1PwdNZzuRGMAeg1TpbQKfgqc64GIRHO9EROl3kYVlAOqJvHM33WS29628V1ubk7pfapxDTuRnpeFigzGAGVob2KZMHsAzcv6mErmONxK3iZT+8fwQIiasYPBN6R5x4uHAVqoAm4zHrtBrfZHpRj39vNV/+SJ3+yw+RPW9BZ6KtPcGOde4vSxLmXQLeFidySLgs8Km1+8Ixseb0Bz7+T5I52wajM7DxVuda7Uem1esxWfzQhit8MQXGdEo8Z+CHekGpyFrAANjIKDb59UCHl1TRu8SRkNVNnl56bXpL5BwIfR/9qohguuk=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(36840700001)(316002)(26005)(4326008)(186003)(2616005)(86362001)(2906002)(82310400003)(36756003)(6666004)(5660300002)(47076005)(478600001)(82740400003)(8936002)(7416002)(356005)(1076003)(336012)(36860700001)(426003)(83380400001)(70586007)(7696005)(54906003)(110136005)(70206006)(7636003)(8676002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:40:30.7382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6511f09d-d77a-4a81-7624-08d9687ded25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1166
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This results in less kconfig wordage and a simpler understanding of the
required "depends on" to create the menu structure.

The next patch increases the nesting level a lot so this is a nice
preparatory simplification.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

