Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF2C5AED4C
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbiIFOaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242284AbiIFO25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:28:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715F290C4E;
        Tue,  6 Sep 2022 06:55:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhSJ/hEQHkrHv78eeyaNXfV3TDRPKt+3VJHh9PAKdbpH6K9JXMXrWPsCTnqy3n2YEYmuCazKNxQ6Yz3BIUHW3n1i9RxTymwkOyq/172pAnDbwhYYHb8e4Nd6SzOsKA8/ltNVwh35JwOmiGPt/RShzB2ToXly982P28czhm4bDyGmcOqCGecGOSbeyeL/BVZLYsRpEzBRecLFfEAZPjj0dc5EpmVn4W2kS4c5ucVsHKQXDrhzLOju4nmjwfKdnp5XjFQOCrIoZxnwphaWTrPHQ/f5CakTJkyPfRv8/dYk1XNd3EkRjyiAkUwnOdfj3XUohOYZjXdHfmyai/8JKHQUcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpweB7oA0mMZDfBd2KNin3ucSqF3KYPf7GJcDMrWzRY=;
 b=W6P2RK6x/4NTLsGyx8JyOLAmon+79dSjZhMEQpFp7z0jKDTXDACuj3oC1QYRTJcjequTpY6vrl3RWAi3vSh2uJp+BPMwLK/1b/mJsOU3le+/DDeQKQNmhULAdekgTWjSHiHb5Jph+IF3W+57G5rOUxy5OYHTjo/LrJpzb3WfgF192LqxifbYqtsjVwMOu2LkIfVoqtcd7OgrgHekNqMeg+GBa6dsty2dSGkv788OZwSvO2sZkpzySi9GqyOeTYyYn2tCKKTE3ZL/jH8LChnbqf3bzY9TpITSZndzTgwj+bEF+k2elLIPiRW6a+LPMJLhjix6M32CLSEl2lrcigF20Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpweB7oA0mMZDfBd2KNin3ucSqF3KYPf7GJcDMrWzRY=;
 b=rs1lpTM6v3rUr8ECTKlIQs+1+KevgfwUxKXmVQl+YkJIhPbpgfSzlo75PcimXhYkRu74VzgNe0d5hlc3fPfq5P/YdkDsOkEk2vAJqgVGG7Ondf8N5l0P6c6j8pGqAccFYcFnH0HnKJCzdA98Y2hLg3kNoMH9g2DP9GT2tKtSJ6A=
Received: from CY5PR14CA0016.namprd14.prod.outlook.com (2603:10b6:930:2::22)
 by CH0PR12MB5043.namprd12.prod.outlook.com (2603:10b6:610:e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 13:49:14 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:930:2:cafe::6a) by CY5PR14CA0016.outlook.office365.com
 (2603:10b6:930:2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12 via Frontend
 Transport; Tue, 6 Sep 2022 13:49:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.9 via Frontend Transport; Tue, 6 Sep 2022 13:49:14 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:49:13 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 06:49:12 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:49:03 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <jgg@nvidia.com>, <robin.murphy@arm.com>,
        <will@kernel.org>, <joro@8bytes.org>, <masahiroy@kernel.org>,
        <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>,
        <aleksandar.radovanovic@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v3 6/7] vfio/cdx: add support for CDX bus
Date:   Tue, 6 Sep 2022 19:18:00 +0530
Message-ID: <20220906134801.4079497-7-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906134801.4079497-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|CH0PR12MB5043:EE_
X-MS-Office365-Filtering-Correlation-Id: 95dc4e33-e60f-426e-a555-08da900e95c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uelHK8Yhw5qrAwUOJWicBVCZcZhvxFIlnFTk0T5P4PrSmB2tw3xCzUtFQAObs7Qp0DGrlL+9P+qFa9f/pjwx90vf7kMiF/L/LNjyXaIN+UzmR/+tJxlOpdteRH32IaRjUY5MVxN2QXxqZMzeDamv/AYJg8mZTNJLODzKXNC6Cf/fbAiIVSoEVD4bR0lxlTS/j/Bx1lHmHCMmB8kA0FfViJlHpznBjC2PlI2PR5usVLMBD1BQuWeNvnm7yta5GtL7tSaARebZDmFgD0DDmQt/jwpm8QBAHic16QQPsIUnUHGPFFzX08sGQNd9PmOPSPIFxQIQVZ6vKuMXxgAMfRPpNjj55uVSDBiMjHs2/w8r5+/sgZIF7KUqGA7/HksoPun/RsH7lRYFIQ05YpaKGf7Y/Dok2KJ42nmAx0U6o27VxnJSkZx8mDLwOqoGGPvaJEMImQAkNNP1M3D5UcgORNeg9Ldhst6Izq9P1ih4vpjBjAhpPh94fiMiHIc+K0Tv5e6Xwv3GasuGBtAZIB/+/8BnJWMtqvt0nSCEHGK81oi//bFMhe7FP0gBkTQVSDf5alP9VfFw5Z6JecC7NJa1jk7t6DOUoOjr+ioxF770PnZKpmjeycwumP3W1nEVRpYpBf6w80RrREV2lJd+DhwQ9mEmOqYi2VZ8JWGt0BfX2SDFeCjPdpBRQpqFeO77M+OJRJTQ8IzPj0JGdJ3uIIIF0HO3aJKam9Iv3Jkw8iakhXFxFCl3IXoyuX3KppvnWVlCrM05HJaSSHLN/kh4l8KGHc3lZwd4iBvPIbYbkiZuU3ayc/BWzJ89Uqh78QnlTmTk9lfyzMIXAcX7mAt6bhuIOL5UzSZ7bsfPsGwY55Yt6ekfYj2KZ9X52eDB2x4nD862KCo+
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(346002)(136003)(36840700001)(46966006)(40470700004)(82740400003)(478600001)(2616005)(426003)(41300700001)(47076005)(336012)(83380400001)(26005)(1076003)(8936002)(82310400005)(186003)(44832011)(7416002)(30864003)(5660300002)(316002)(110136005)(40460700003)(40480700001)(54906003)(2906002)(4326008)(70586007)(70206006)(36756003)(8676002)(86362001)(81166007)(921005)(356005)(36860700001)(83996005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:49:14.1589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dc4e33-e60f-426e-a555-08da900e95c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5043
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 MAINTAINERS                         |   1 +
 drivers/vfio/Makefile               |   1 +
 drivers/vfio/cdx/Kconfig            |  10 +
 drivers/vfio/cdx/Makefile           |   4 +
 drivers/vfio/cdx/vfio_cdx.c         | 284 ++++++++++++++++++++++++++++
 drivers/vfio/cdx/vfio_cdx_private.h |  32 ++++
 6 files changed, 332 insertions(+)
 create mode 100644 drivers/vfio/cdx/Kconfig
 create mode 100644 drivers/vfio/cdx/Makefile
 create mode 100644 drivers/vfio/cdx/vfio_cdx.c
 create mode 100644 drivers/vfio/cdx/vfio_cdx_private.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 61af11c9fe06..e66a93ca2218 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -940,6 +940,7 @@ M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
 F:	drivers/bus/cdx/*
+F:	drivers/vfio/cdx/*
 F:	include/linux/cdx/*
 
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 1a32357592e3..7f4f5c891c28 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
 obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
+obj-$(CONFIG_CDX_BUS) += cdx/
diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
new file mode 100644
index 000000000000..728d7294a2c7
--- /dev/null
+++ b/drivers/vfio/cdx/Kconfig
@@ -0,0 +1,10 @@
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
index 000000000000..7a4183d76802
--- /dev/null
+++ b/drivers/vfio/cdx/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+
+#vfio-fsl-mc-y := vfio_cdx.o vfio_cdx_intr.o
+obj-y += vfio_cdx.o vfio_cdx_intr.o
diff --git a/drivers/vfio/cdx/vfio_cdx.c b/drivers/vfio/cdx/vfio_cdx.c
new file mode 100644
index 000000000000..2e5bd494057a
--- /dev/null
+++ b/drivers/vfio/cdx/vfio_cdx.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+#include <linux/cdx/cdx_bus.h>
+#include <linux/delay.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
+
+#include "vfio_cdx_private.h"
+
+static struct cdx_driver vfio_cdx_driver;
+
+static int vfio_cdx_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = vdev->cdx_dev;
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
+		 * MMAPed securely.
+		 */
+		if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
+				!(vdev->regions[i].size & ~PAGE_MASK))
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
+static int vfio_cdx_reset_device(struct vfio_cdx_device *vdev)
+{
+	struct vfio_device *core_vdev = &vdev->vdev;
+
+	return cdx_dev_reset(core_vdev->dev);
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
+	ret = vfio_cdx_reset_device(vdev);
+	if (WARN_ON(ret))
+		dev_warn(core_vdev->dev,
+			 "VFIO_CDX: reset device has failed (%d)\n", ret);
+}
+
+static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
+			   unsigned int cmd, unsigned long arg)
+{
+	unsigned long minsz;
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = vdev->cdx_dev;
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
+		info.flags = VFIO_DEVICE_FLAGS_RESET;
+
+		info.num_regions = cdx_dev->res_count;
+		info.num_irqs = 1;
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
+		info.offset = VFIO_CDX_INDEX_TO_OFFSET(info.index);
+		info.size = vdev->regions[info.index].size;
+		info.flags = vdev->regions[info.index].flags;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+		return 0;
+	}
+	case VFIO_DEVICE_RESET:
+	{
+		return vfio_cdx_reset_device(vdev);
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
+	u8 region_cacheable;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	base = pgoff << PAGE_SHIFT;
+
+	if (region.size < PAGE_SIZE || base + size > region.size)
+		return -EINVAL;
+
+	region_cacheable = (region.type & IORESOURCE_MEM);
+	if (!region_cacheable)
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       size, vma->vm_page_prot);
+}
+
+static int vfio_cdx_mmap(struct vfio_device *core_vdev,
+			    struct vm_area_struct *vma)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+	struct cdx_device *cdx_dev = vdev->cdx_dev;
+	unsigned int index;
+
+	index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (vma->vm_start & ~PAGE_MASK)
+		return -EINVAL;
+	if (vma->vm_end & ~PAGE_MASK)
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+	if (index >= cdx_dev->res_count)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ)
+			&& (vma->vm_flags & VM_READ))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
+			&& (vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+
+	vma->vm_private_data = cdx_dev;
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
+};
+
+static int vfio_cdx_probe(struct cdx_device *cdx_dev)
+{
+	struct vfio_cdx_device *vdev;
+	struct device *dev = &cdx_dev->dev;
+	int ret;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_cdx_ops);
+	vdev->cdx_dev = cdx_dev;
+	vdev->dev = dev;
+
+	ret = vfio_assign_device_set(&vdev->vdev, dev);
+	if (ret) {
+		dev_err(dev, "VFIO_CDX: vfio_assign_device_set failed\n");
+		goto out_uninit;
+	}
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
+	vfio_uninit_group_dev(&vdev->vdev);
+	kfree(vdev);
+	return ret;
+}
+
+static int vfio_cdx_remove(struct cdx_device *cdx_dev)
+{
+	struct device *dev = &cdx_dev->dev;
+	struct vfio_cdx_device *vdev = dev_get_drvdata(dev);
+
+	vfio_unregister_group_dev(&vdev->vdev);
+
+	vfio_uninit_group_dev(&vdev->vdev);
+	kfree(vdev);
+	return 0;
+}
+
+static struct cdx_driver vfio_cdx_driver = {
+	.probe		= vfio_cdx_probe,
+	.remove		= vfio_cdx_remove,
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
index 000000000000..d87b55663462
--- /dev/null
+++ b/drivers/vfio/cdx/vfio_cdx_private.h
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#ifndef VFIO_CDX_PRIVATE_H
+#define VFIO_CDX_PRIVATE_H
+
+#define VFIO_CDX_OFFSET_SHIFT    40
+#define VFIO_CDX_OFFSET_MASK (((u64)(1) << VFIO_CDX_OFFSET_SHIFT) - 1)
+
+#define VFIO_CDX_OFFSET_TO_INDEX(off) ((off) >> VFIO_CDX_OFFSET_SHIFT)
+
+#define VFIO_CDX_INDEX_TO_OFFSET(index)	\
+	((u64)(index) << VFIO_CDX_OFFSET_SHIFT)
+
+struct vfio_cdx_region {
+	u32			flags;
+	u32			type;
+	u64			addr;
+	resource_size_t		size;
+	void __iomem		*ioaddr;
+};
+
+struct vfio_cdx_device {
+	struct vfio_device		vdev;
+	struct cdx_device		*cdx_dev;
+	struct device			*dev;
+	struct vfio_cdx_region		*regions;
+};
+
+#endif /* VFIO_CDX_PRIVATE_H */
-- 
2.25.1

