Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F90B3F4016
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhHVOih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:37 -0400
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:60691
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234507AbhHVOid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATFTjZjgWW1P4UpR91yYdt9dGXU6YRM1ru9j9I9L1zx7vlQJIMh5ThpXjPKJLo2lw76mzutEXwPsabo5QJ5HX625ztwKhoAqmijG11w7bGvvDAPADrsEoQsZdbbSdQ/GpNrX3AoWC2FduAXPZ22bRm91mQnoUkkGKLpLwRBf842aZ2GAS3WKb6JS2VZn8hNmQKYtC9j7GFn+WmuwLREqX+gcPjsgWBJ8mKKqxaMPOE2cyHqzNbvO7I24JifNRUOyaBpUbRwP/6J54RNJYqBhcCp1Yq92aJO/13UDr2dUavjXHrBc7ijTJC6oY21aiLq9c2z/W7vdFC0asNJDQUAYQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljNt91RXaMUeUb4xw+o4cw+E7E+Cf/9o6Z+j7JDC/6k=;
 b=ZExEEDiV4yoxJmmkXHLDTMCeRzkxO8NFeLeUp5Q3DFmunjlZSwtYEKhwZmTqh2Zqj4atHQLezMJ6Q6M9qDV6rj+onKmJ7YefH1g/2ct/Ai8185TLbAkvh5uOlj4R/ko/cSz//2qLec0eEJzgPexz9/LEWPhyQrlWxSCS7O24XdnZdXlyM2dbD4BNILJgQfjDKjeXsebYYTaO4T3fQ1PBxCdJHFjjXnJPTk7t/nMbyRNZ49i+k4++e60rgUgf/r1ST7npvw490G8OEVyk9c5RXPoVMwdHwkKqnswaParGcfHMH1lC1+DRuA2BM+meF1AWOiC14iGwpyqtTpiBLYqR3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljNt91RXaMUeUb4xw+o4cw+E7E+Cf/9o6Z+j7JDC/6k=;
 b=bHBqt9KvQv+LKxyEFftSFGp/YGyFSY5Q+7Q/zqohbAWz/BZUSk5+9d6vsdBj6f9N8bZH6vLVdAjH21p4hNPejCqp++sF8VTZv9d3EyyboPk+FtB/UCYRKAnu9sKP15DGZ0RIoH5fPFPU0532pmLZ6bSa/GwwnnOpq6dlqKeky7KGTAKqkhXYEsNtzriAgYDo7pYwDDIRHzqiIjTvdvq8XQABu6CFEmOLAoTsI4SF4pMF+MBsv29BTqURNBeglPHynldYchQHnW/BfdMY7SvxcBm323iuM1A9eDe17RRXAhrpR8O31UrEkwSVEYWJicAbDqMuKs6luWTLTfIb+0n6og==
Received: from DM3PR03CA0014.namprd03.prod.outlook.com (2603:10b6:0:50::24) by
 DM6PR12MB4315.namprd12.prod.outlook.com (2603:10b6:5:223::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.21; Sun, 22 Aug 2021 14:37:51 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::fd) by DM3PR03CA0014.outlook.office365.com
 (2603:10b6:0:50::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 14:37:51 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:47 +0000
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
Subject: [PATCH V3 13/13] vfio/pci: Introduce vfio_pci_core.ko
Date:   Sun, 22 Aug 2021 17:36:02 +0300
Message-ID: <20210822143602.153816-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c187c2b1-0df9-4ffc-f577-08d9657a6b7a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4315:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4315FB286CF8FE90A4B049C2C3C39@DM6PR12MB4315.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIVNbIgiTLJdtNatvVLH1R+/zoPad8kWcA9t+do0cVGikwgPmwS7X5Mp4UNakvPRaKkn2I+wB/2FpADvLEhdhERJIx+rB3XX02qC/8PsN5Fbnk9UaSbgalB4nHsGBBIoXWylqA9kd9/HdcpOhb24/moH08Bs/nBEg1SR4nliPuVFHhVjG5qlGzKKVIZbzzB1TfPbAHgPJvmHiJhirOs6erwSI6nMxZxtHszL/yyM5JZ4ZPU/M+qygqwuyeG+VplL+0fcsekKdrhB16ob4hb1SpAqKvQhG17e1B4zqBEuCremWGFyvWTHd3t+rvNfRfzIkHvrorL4nSjYLDw0mYPoKE7vjAmuQWrRnbhphrrpX5KFWs11/5MgHzjVFjVw9YveV3uQVQuPqwwOTi35HMiI4BsjUFK8VKbu1Jp00CYfOnS/qsoOKtClIm4G6mfIfWaCPjKq2AKNzv0qAqHqsMHNNa+8cvyHBTjZnasA5Nc0vY85DlqS79/IBsvyWtMUZYd9aTT15ZxNYmpAtnGHHalbuZU4RcewxWoh6haFYgRgLmGkQReZqpSwGek3dp121H7o2LghTERUH9P7lfz+Uw3KLj6qFscobwjilQjgpPYYPTT00QmWLfbRvOqW85pHFCx2Y8ojmI1qsty6twBPiU0kz7G4ThJXGfiqb440s4TAZ1t1nBWpvGzNenrhL07fq7jCc+rRQFC5jOufpIQBjbs5S/unFWuT1g1PWo9my8gbmPE=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966006)(36840700001)(1076003)(54906003)(8676002)(8936002)(110136005)(316002)(2616005)(2906002)(47076005)(7416002)(83380400001)(36756003)(82740400003)(36906005)(356005)(7636003)(36860700001)(30864003)(70206006)(70586007)(4326008)(82310400003)(426003)(478600001)(186003)(336012)(5660300002)(86362001)(107886003)(7696005)(6666004)(26005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:51.2202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c187c2b1-0df9-4ffc-f577-08d9657a6b7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4315
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Now that vfio_pci has been split into two source modules, one focusing on
the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
(vfio_pci_core.c), complete the split and move them into two different
kernel modules.

As before vfio_pci.ko continues to present the same interface under sysfs
and this change will have no functional impact.

Splitting into another module and adding exports allows creating new HW
specific VFIO PCI drivers that can implement device specific
functionality, such as VFIO migration interfaces or specialized device
requirements.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/Kconfig                      | 33 +++++++++-------
 drivers/vfio/pci/Makefile                     |  8 ++--
 drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
 drivers/vfio/pci/vfio_pci_config.c            |  2 +-
 drivers/vfio/pci/vfio_pci_core.c              | 39 ++++++++++++++++---
 drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
 drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
 .../pci => include/linux}/vfio_pci_core.h     |  2 -
 10 files changed, 64 insertions(+), 42 deletions(-)
 rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index afdab7d71e98..860424ccda1b 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,19 +1,28 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
-	tristate "VFIO support for PCI devices"
-	depends on PCI
-	depends on MMU
+if PCI && MMU
+config VFIO_PCI_CORE
+	tristate
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
+
+config VFIO_PCI_MMAP
+	def_bool y if !S390
+
+config VFIO_PCI_INTX
+	def_bool y if !S390
+
+config VFIO_PCI
+	tristate "Generic VFIO support for any PCI device"
+	select VFIO_PCI_CORE
 	help
-	  Support for the PCI VFIO bus driver.  This is required to make
-	  use of PCI drivers using the VFIO framework.
+	  Support for the generic PCI VFIO bus driver which can connect any
+	  PCI device to the VFIO framework.
 
 	  If you don't know what to do here, say N.
 
 if VFIO_PCI
 config VFIO_PCI_VGA
-	bool "VFIO PCI support for VGA devices"
+	bool "Generic VFIO PCI support for VGA devices"
 	depends on X86 && VGA_ARB
 	help
 	  Support for VGA extension to VFIO PCI.  This exposes an additional
@@ -22,14 +31,8 @@ config VFIO_PCI_VGA
 
 	  If you don't know what to do here, say N.
 
-config VFIO_PCI_MMAP
-	def_bool y if !S390
-
-config VFIO_PCI_INTX
-	def_bool y if !S390
-
 config VFIO_PCI_IGD
-	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
+	bool "Generic VFIO PCI extensions for Intel graphics (GVT-d)"
 	depends on X86
 	default y
 	help
@@ -39,5 +42,5 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
-
+endif
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 8aa517b4b671..349d68d242b4 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,7 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
+vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
+obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
+vfio-pci-y := vfio_pci.o
+vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index c52620ac5e70..24ea9f4ff0d7 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -25,7 +25,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
@@ -153,6 +153,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
 		goto out_free;
+	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_free:
@@ -248,14 +249,10 @@ static int __init vfio_pci_init(void)
 
 	vfio_pci_core_set_params(nointxmask, is_disable_vga, disable_idle_d3);
 
-	ret = vfio_pci_core_init();
-	if (ret)
-		return ret;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
-		goto out;
+		return ret;
 
 	vfio_pci_fill_ids();
 
@@ -263,17 +260,12 @@ static int __init vfio_pci_init(void)
 		pr_warn("device denylist disabled.\n");
 
 	return 0;
-
-out:
-	vfio_pci_core_cleanup();
-	return ret;
 }
 module_init(vfio_pci_init);
 
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_core_cleanup();
 }
 module_exit(vfio_pci_cleanup);
 
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 1f034f768a27..6e58b4bf7a60 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -26,7 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 /* Fake capability ID for standard config space */
 #define PCI_CAP_ID_BASIC	0
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 8908725c13f6..c67751948504 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -8,6 +8,8 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/eventfd.h>
 #include <linux/file.h>
@@ -25,7 +27,10 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
+
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC "core driver for VFIO based PCI devices"
 
 static bool nointxmask;
 static bool disable_vga;
@@ -306,6 +311,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
@@ -403,6 +409,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
 static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
 {
@@ -459,6 +466,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	}
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
@@ -466,6 +474,7 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
@@ -624,6 +633,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg)
@@ -1168,6 +1178,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1211,6 +1222,7 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_read);
 
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos)
@@ -1223,6 +1235,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 
 	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_write);
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
 static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
@@ -1501,6 +1514,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_mmap);
 
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
@@ -1523,6 +1537,7 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
 static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 				      bool vf_token, uuid_t *uuid)
@@ -1667,6 +1682,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 
 	return 1; /* Match */
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_match);
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
@@ -1775,6 +1791,7 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
 
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 {
@@ -1785,6 +1802,7 @@ void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 {
@@ -1852,7 +1870,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_power;
-	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_power:
@@ -1864,6 +1881,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
@@ -1881,6 +1899,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
@@ -1926,10 +1945,12 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 
 	return ret < 0 ? ret : nr_virtfn;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
+EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
 static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 			       struct vfio_pci_group_info *groups)
@@ -2118,16 +2139,22 @@ void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
 	disable_vga = is_disable_vga;
 	disable_idle_d3 = is_disable_idle_d3;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_set_params);
 
-/* This will become the __exit function of vfio_pci_core.ko */
-void vfio_pci_core_cleanup(void)
+static void vfio_pci_core_cleanup(void)
 {
 	vfio_pci_uninit_perm_bits();
 }
 
-/* This will become the __init function of vfio_pci_core.ko */
-int __init vfio_pci_core_init(void)
+static int __init vfio_pci_core_init(void)
 {
 	/* Allocate shared config space permission data used by all devices */
 	return vfio_pci_init_perm_bits();
 }
+
+module_init(vfio_pci_core_init);
+module_exit(vfio_pci_core_cleanup);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index a324ca7e6b5a..7ca4109bba48 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -15,7 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 945ddbdf4d11..6069a11fb51a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -20,7 +20,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 /*
  * INTx
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 8fff4689dd44..57d3b2cbbd8e 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,7 +17,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 #ifdef __LITTLE_ENDIAN
 #define vfio_ioread64	ioread64
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 2ffbdc11f089..fe4def9ffffb 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -19,7 +19,7 @@
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
-#include "vfio_pci_core.h"
+#include <linux/vfio_pci_core.h>
 
 /*
  * Add the Base PCI Function information to the device info region.
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/include/linux/vfio_pci_core.h
similarity index 99%
rename from drivers/vfio/pci/vfio_pci_core.h
rename to include/linux/vfio_pci_core.h
index 7a2da1e14de3..ef9a44b6cf5d 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -207,8 +207,6 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-void vfio_pci_core_cleanup(void);
-int vfio_pci_core_init(void);
 void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
-- 
2.18.1

