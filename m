Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6C6E6001
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 13:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjDRLhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 07:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDRLhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 07:37:46 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61295E58;
        Tue, 18 Apr 2023 04:37:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0mWZ9/UAi29D1eeomcfLfgF2KmiXGwSpzmCoEtsrSczHdH1XB4aulDg9c8WO2ol7ZQ7StqZWQq/VCyLK3r5XznyvINgR0qMkzcpV3ugjY5MVFch3S9eBZ8ky/dqDr/gq8MGT3FAjzepiAM38Gkm5O+UlQXLPrraBKPuth2ONTFmTkw8wP+3ff08dIJB2I8RnH/zs+puawxk8jPkD87GPjpGrpTlFgSBZ+KxU6RaQ32jrCwpOUfmwiZN10ggn+dsCUOvdWHuuAFM3kyzzjUz9IVA8NiPyZ6h09iilRVZN+yR4/wwSKuo4IB00vP/QamUm/ZFDINeAkXIrZxa+/sJvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnEsKy/EO8Uk4X+75gqxy5mOEET8aV4BlBqKb05Ip78=;
 b=PZu6YUqjAf4A0Z/QWXCBLfSF5n1T7FZ0JCph3cfkMy74Et5mwm0qrE0AnnX2NT0XfGapbdilywUSS+Se1Z3+ievNLjbQ8//6mP0FQPv3pFYI/c4HT9hP6/iDi9X2RYfu6uIZHInVGIRH4tUcDlX+Oe9a1olRDdVRFJjJlmjJVDJVagHrv7qAcTgdGsYA48Seq03Lpc//I6WuV9CekzvIaiTNREnZW5UnHcT8/vJVYoYbB3Ny+HHhXCflrL9WIq7mdNVKVPKlPHnFqBoJ4V//qdT1Sg6VJ4+RhBDixCfeRRTPgSuL/GImHzbRmMd08GjwqmfFh+Go8ezcyfO4xMGmtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnEsKy/EO8Uk4X+75gqxy5mOEET8aV4BlBqKb05Ip78=;
 b=0Q3ySgJz/8PI53YFfvruDlJITfH3Qsajim5Hx8oSM1VQu5zRRpKNkLRRD1NnHB3nXPvYi4QrN9AN4mOisQo5kGUQk89zyCj7FgI9SCHpcUhiZZy7Ebs2uRa/UHrIISeT6V/KsJepEGFNb1cpooInm1qwjInT+FXVnUXLrx1b+Gc=
Received: from BN0PR04CA0093.namprd04.prod.outlook.com (2603:10b6:408:ec::8)
 by PH0PR12MB7959.namprd12.prod.outlook.com (2603:10b6:510:282::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:37:04 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::6d) by BN0PR04CA0093.outlook.office365.com
 (2603:10b6:408:ec::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 11:37:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.31 via Frontend Transport; Tue, 18 Apr 2023 11:37:04 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 18 Apr
 2023 06:37:02 -0500
Received: from xhdipdslab41.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 18 Apr 2023 06:36:58 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <alex.williamson@redhat.com>, <jgg@ziepe.ca>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <masahiroy@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <nicolas@fjasle.eu>
CC:     <git@amd.com>, <harpreet.anand@amd.com>,
        <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
        <michal.simek@amd.com>, Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH v4] vfio/cdx: add support for CDX bus
Date:   Tue, 18 Apr 2023 17:06:55 +0530
Message-ID: <20230418113655.25207-1-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|PH0PR12MB7959:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5f2428-aef6-4624-bb54-08db40013b84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zu/bnZmw9spD+ghijKhHjsVGRCRreILhW8R4Oaqq6J8Lyvf3xGTVdFYU88xv+wV1bHzXrS9DQ+jHxTcIYHZgKZAseqZ75Xv+rPKvdHbN01gfH+uqkxS1+87cXZxJjUUqLK2iQ15C+adIR4JbPvFnboQpglxEms/4hwFWj+f3OhzaFt3gnksL5cop/s2wnnlffobg5CCe0RQ4IHI5dfAJIOpZggSud5lrSK9VKlcEqmM8OQeDa/OuG7qOc24DDC61lE3IhMGK8p7Mc5UqWXHZMDgfCpXRx0fVvECVQEgVXDqSU9zDgZNRw3U4KoSpXYkO3jbBeb2wS3ERLO1sQPEaflMGUKK+a1c5Ay56dDdajeJuOe13XojZRho8pZbbfnSoKw4a4/mnycsOiH9jP5pvCRZ456vvirhPZzqeSjgaQ2ylAak+P2i429wsRQiYbseHGFgrMOvibyE/AdzSAqx7IiM+8YbObAiJj5tJa22UAGhHrePJS+wTgHJH+UPuv13UhmSBEsXCW20OiCXpNsWaAG+8xj3J4t51Y+rQV+nVuNArDORyf84HcEGobW/qZvTZjh40iXdLUqBtZLEB1s0wQebPY414+n1W/zwZJB2Dgt0k0zyX4FcqR+uxONJqHwoGl5mo3dwkNDOX4+lBc3zw9TfrekTWLOazz0/Sov6WaVLu5s0+ijeHuB03IbtbmvGGAQENTBdJzNX5nah4e+9nU3W8yDwiVi84kcJQcdbpI7B2Wi6uiSfDJFSUp8NZFCet
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(8936002)(8676002)(316002)(82740400003)(41300700001)(4326008)(40480700001)(70586007)(70206006)(81166007)(54906003)(110136005)(40460700003)(356005)(186003)(2906002)(30864003)(36756003)(1076003)(26005)(426003)(83380400001)(86362001)(336012)(47076005)(82310400005)(2616005)(36860700001)(5660300002)(44832011)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:37:04.0131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5f2428-aef6-4624-bb54-08db40013b84
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7959
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio-cdx driver enables IOCTLs for user space to query
MMIO regions for CDX devices and mmap them. This change
also adds support for reset of CDX devices.

This change adds the VFIO CDX driver and enables the following
ioctls for CDX devices:
 - VFIO_DEVICE_GET_INFO:
 - VFIO_DEVICE_GET_REGION_INFO
 - VFIO_DEVICE_RESET

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Tested-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
---

Changes v3->v4:
- fix vfio info flags

Changes v2->v3:
- removed redundant init and release functions
- removed redundant dev and cdx_dev from vfio_cdx_device
- added support for iommufd
- added VFIO_DEVICE_FLAGS_CDX
- removed unrequried WARN_ON
- removed unused ioaddr

Changes v1->v2:
- Updated file2alias to support vfio_cdx
- removed some un-necessary checks in mmap
- removed vfio reset wrapper API
- converted complex macros to static APIs
- used pgprot_device and io_remap_pfn_range

 MAINTAINERS                         |   7 +
 drivers/vfio/Kconfig                |   1 +
 drivers/vfio/Makefile               |   1 +
 drivers/vfio/cdx/Kconfig            |  17 ++
 drivers/vfio/cdx/Makefile           |   8 +
 drivers/vfio/cdx/vfio_cdx.c         | 271 ++++++++++++++++++++++++++++
 drivers/vfio/cdx/vfio_cdx_private.h |  28 +++
 include/linux/cdx/cdx_bus.h         |   1 -
 include/linux/mod_devicetable.h     |   6 +
 include/uapi/linux/vfio.h           |   1 +
 scripts/mod/devicetable-offsets.c   |   1 +
 scripts/mod/file2alias.c            |  17 +-
 12 files changed, 357 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/cdx/Kconfig
 create mode 100644 drivers/vfio/cdx/Makefile
 create mode 100644 drivers/vfio/cdx/vfio_cdx.c
 create mode 100644 drivers/vfio/cdx/vfio_cdx_private.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f74d8571ac9..c4fd42ba8f46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22064,6 +22064,13 @@ F:	Documentation/filesystems/vfat.rst
 F:	fs/fat/
 F:	tools/testing/selftests/filesystems/fat/
 
+VFIO CDX DRIVER
+M:	Nipun Gupta <nipun.gupta@amd.com>
+M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/cdx/*
+
 VFIO DRIVER
 M:	Alex Williamson <alex.williamson@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 89e06c981e43..aba36f5be4ec 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -57,6 +57,7 @@ source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
 source "drivers/vfio/fsl-mc/Kconfig"
+source "drivers/vfio/cdx/Kconfig"
 endif
 
 source "virt/lib/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 70e7dcb302ef..1a27b2516612 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
 obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
+obj-$(CONFIG_VFIO_CDX) += cdx/
diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
new file mode 100644
index 000000000000..e6de0a0caa32
--- /dev/null
+++ b/drivers/vfio/cdx/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# VFIO CDX configuration
+#
+# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+#
+
+config VFIO_CDX
+	tristate "VFIO support for CDX bus devices"
+	depends on CDX_BUS
+	select EVENTFD
+	help
+	  Driver to enable VFIO support for the devices on CDX bus.
+	  This is required to make use of CDX devices present in
+	  the system using the VFIO framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
new file mode 100644
index 000000000000..82e4ef412c0f
--- /dev/null
+++ b/drivers/vfio/cdx/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+#
+
+obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
+
+vfio-cdx-objs := vfio_cdx.o
diff --git a/drivers/vfio/cdx/vfio_cdx.c b/drivers/vfio/cdx/vfio_cdx.c
new file mode 100644
index 000000000000..b99cc53a9028
--- /dev/null
+++ b/drivers/vfio/cdx/vfio_cdx.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/vfio.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "vfio_cdx_private.h"
+
+static struct cdx_driver vfio_cdx_driver;
+
+/**
+ * CDX_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
+ *                                   "driver_override" CDX device.
+ * @vend: the 16 bit CDX Vendor ID
+ * @dev: the 16 bit CDX Device ID
+ *
+ * This macro is used to create a struct cdx_device_id that matches a
+ * specific device. driver_override will be set to
+ * CDX_ID_F_VFIO_DRIVER_OVERRIDE.
+ */
+#define CDX_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
+	CDX_DEVICE_DRIVER_OVERRIDE(vend, dev, CDX_ID_F_VFIO_DRIVER_OVERRIDE)
+
+static int vfio_cdx_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
+	int count = cdx_dev->res_count;
+	int i;
+
+	vdev->regions = kcalloc(count, sizeof(struct vfio_cdx_region),
+				GFP_KERNEL);
+	if (!vdev->regions)
+		return -ENOMEM;
+
+	for (i = 0; i < count; i++) {
+		struct resource *res = &cdx_dev->res[i];
+
+		vdev->regions[i].addr = res->start;
+		vdev->regions[i].size = resource_size(res);
+		vdev->regions[i].type = res->flags;
+		/*
+		 * Only regions addressed with PAGE granularity may be
+		 * MMAP'ed securely.
+		 */
+		if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
+		    !(vdev->regions[i].size & ~PAGE_MASK))
+			vdev->regions[i].flags |=
+					VFIO_REGION_INFO_FLAG_MMAP;
+		vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
+		if (!(cdx_dev->res[i].flags & IORESOURCE_READONLY))
+			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
+	}
+
+	return 0;
+}
+
+static void vfio_cdx_regions_cleanup(struct vfio_cdx_device *vdev)
+{
+	kfree(vdev->regions);
+}
+
+static void vfio_cdx_close_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	int ret;
+
+	vfio_cdx_regions_cleanup(vdev);
+
+	/* reset the device before cleaning up the interrupts */
+	ret = cdx_dev_reset(core_vdev->dev);
+	if (ret)
+		dev_warn(core_vdev->dev,
+			 "VFIO_CDX: reset device has failed (%d)\n", ret);
+}
+
+static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
+			   unsigned int cmd, unsigned long arg)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
+	unsigned long minsz;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+	{
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = VFIO_DEVICE_FLAGS_CDX;
+		info.flags |= VFIO_DEVICE_FLAGS_RESET;
+
+		info.num_regions = cdx_dev->res_count;
+		info.num_irqs = 0;
+
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+			-EFAULT : 0;
+	}
+	case VFIO_DEVICE_GET_REGION_INFO:
+	{
+		struct vfio_region_info info;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= cdx_dev->res_count)
+			return -EINVAL;
+
+		/* map offset to the physical address  */
+		info.offset = vfio_cdx_index_to_offset(info.index);
+		info.size = vdev->regions[info.index].size;
+		info.flags = vdev->regions[info.index].flags;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+		return 0;
+	}
+	case VFIO_DEVICE_RESET:
+	{
+		return cdx_dev_reset(core_vdev->dev);
+	}
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
+			      struct vm_area_struct *vma)
+{
+	u64 size = vma->vm_end - vma->vm_start;
+	u64 pgoff, base;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	base = pgoff << PAGE_SHIFT;
+
+	if (region.size < PAGE_SIZE || base + size > region.size)
+		return -EINVAL;
+
+	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
+	vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
+
+	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+				  size, vma->vm_page_prot);
+}
+
+static int vfio_cdx_mmap(struct vfio_device *core_vdev,
+			 struct vm_area_struct *vma)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
+	unsigned int index;
+
+	index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (index >= cdx_dev->res_count)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
+	    (vma->vm_flags & VM_READ))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
+	    (vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+
+	return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
+}
+
+static const struct vfio_device_ops vfio_cdx_ops = {
+	.name		= "vfio-cdx",
+	.open_device	= vfio_cdx_open_device,
+	.close_device	= vfio_cdx_close_device,
+	.ioctl		= vfio_cdx_ioctl,
+	.mmap		= vfio_cdx_mmap,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
+};
+
+static int vfio_cdx_probe(struct cdx_device *cdx_dev)
+{
+	struct vfio_cdx_device *vdev = NULL;
+	struct device *dev = &cdx_dev->dev;
+	int ret;
+
+	vdev = vfio_alloc_device(vfio_cdx_device, vdev, dev,
+				 &vfio_cdx_ops);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	ret = vfio_register_group_dev(&vdev->vdev);
+	if (ret) {
+		dev_err(dev, "VFIO_CDX: Failed to add to vfio group\n");
+		goto out_uninit;
+	}
+
+	dev_set_drvdata(dev, vdev);
+	return 0;
+
+out_uninit:
+	vfio_put_device(&vdev->vdev);
+	return ret;
+}
+
+static int vfio_cdx_remove(struct cdx_device *cdx_dev)
+{
+	struct device *dev = &cdx_dev->dev;
+	struct vfio_cdx_device *vdev;
+
+	vdev = dev_get_drvdata(dev);
+	vfio_unregister_group_dev(&vdev->vdev);
+	vfio_put_device(&vdev->vdev);
+
+	return 0;
+}
+
+static const struct cdx_device_id vfio_cdx_table[] = {
+	{ CDX_DRIVER_OVERRIDE_DEVICE_VFIO(CDX_ANY_ID, CDX_ANY_ID) }, /* match all by default */
+	{}
+};
+
+MODULE_DEVICE_TABLE(cdx, vfio_cdx_table);
+
+static struct cdx_driver vfio_cdx_driver = {
+	.probe		= vfio_cdx_probe,
+	.remove		= vfio_cdx_remove,
+	.match_id_table	= vfio_cdx_table,
+	.driver	= {
+		.name	= "vfio-cdx",
+		.owner	= THIS_MODULE,
+	},
+	.driver_managed_dma = true,
+};
+
+static int __init vfio_cdx_driver_init(void)
+{
+	return cdx_driver_register(&vfio_cdx_driver);
+}
+
+static void __exit vfio_cdx_driver_exit(void)
+{
+	cdx_driver_unregister(&vfio_cdx_driver);
+}
+
+module_init(vfio_cdx_driver_init);
+module_exit(vfio_cdx_driver_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("VFIO for CDX devices - User Level meta-driver");
diff --git a/drivers/vfio/cdx/vfio_cdx_private.h b/drivers/vfio/cdx/vfio_cdx_private.h
new file mode 100644
index 000000000000..8bdc117ea88e
--- /dev/null
+++ b/drivers/vfio/cdx/vfio_cdx_private.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef VFIO_CDX_PRIVATE_H
+#define VFIO_CDX_PRIVATE_H
+
+#define VFIO_CDX_OFFSET_SHIFT    40
+
+static inline u64 vfio_cdx_index_to_offset(u32 index)
+{
+	return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
+}
+
+struct vfio_cdx_region {
+	u32			flags;
+	u32			type;
+	u64			addr;
+	resource_size_t		size;
+};
+
+struct vfio_cdx_device {
+	struct vfio_device	vdev;
+	struct vfio_cdx_region	*regions;
+};
+
+#endif /* VFIO_CDX_PRIVATE_H */
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index 35ef41d8a61a..bead71b7bc73 100644
--- a/include/linux/cdx/cdx_bus.h
+++ b/include/linux/cdx/cdx_bus.h
@@ -14,7 +14,6 @@
 #include <linux/mod_devicetable.h>
 
 #define MAX_CDX_DEV_RESOURCES	4
-#define CDX_ANY_ID (0xFFFF)
 #define CDX_CONTROLLER_ID_SHIFT 4
 #define CDX_BUS_NUM_MASK 0xF
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ccaaeda792c0..ccf017353bb6 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -912,6 +912,12 @@ struct ishtp_device_id {
 	kernel_ulong_t driver_data;
 };
 
+#define CDX_ANY_ID (0xFFFF)
+
+enum {
+	CDX_ID_F_VFIO_DRIVER_OVERRIDE = 1,
+};
+
 /**
  * struct cdx_device_id - CDX device identifier
  * @vendor: Vendor ID
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..8e91aaf973e7 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -213,6 +213,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
 #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
 #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
+#define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 62dc988df84d..abe65f8968dd 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -265,6 +265,7 @@ int main(void)
 	DEVID(cdx_device_id);
 	DEVID_FIELD(cdx_device_id, vendor);
 	DEVID_FIELD(cdx_device_id, device);
+	DEVID_FIELD(cdx_device_id, override_only);
 
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 28da34ba4359..38120f932b0d 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1458,8 +1458,23 @@ static int do_cdx_entry(const char *filename, void *symval,
 {
 	DEF_FIELD(symval, cdx_device_id, vendor);
 	DEF_FIELD(symval, cdx_device_id, device);
+	DEF_FIELD(symval, cdx_device_id, override_only);
 
-	sprintf(alias, "cdx:v%08Xd%08Xd", vendor, device);
+	switch (override_only) {
+	case 0:
+		strcpy(alias, "cdx:");
+		break;
+	case CDX_ID_F_VFIO_DRIVER_OVERRIDE:
+		strcpy(alias, "vfio_cdx:");
+		break;
+	default:
+		warn("Unknown CDX driver_override alias %08X\n",
+		     override_only);
+		return 0;
+	}
+
+	ADD(alias, "v", vendor != CDX_ANY_ID, vendor);
+	ADD(alias, "d", device != CDX_ANY_ID, device);
 	return 1;
 }
 
-- 
2.17.1

