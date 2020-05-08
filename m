Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171361CA50E
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEHHVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 03:21:14 -0400
Received: from inva021.nxp.com ([92.121.34.21]:59262 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgEHHUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 03:20:49 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C073F201045;
        Fri,  8 May 2020 09:20:47 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B374120096A;
        Fri,  8 May 2020 09:20:47 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 33231204BD;
        Fri,  8 May 2020 09:20:47 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, laurentiu.tudor@nxp.com,
        bharatb.linux@gmail.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v2 7/9] vfio/fsl-mc: Add irq infrastructure for fsl-mc devices
Date:   Fri,  8 May 2020 10:20:37 +0300
Message-Id: <20200508072039.18146-8-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
References: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the skeleton for interrupt support
for fsl-mc devices. The interrupts are not yet functional,
the functionality will be added by subsequent patches.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/Makefile              |  2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 71 ++++++++++++++++++++++-
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 63 ++++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  5 ++
 4 files changed, 138 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c

diff --git a/drivers/vfio/fsl-mc/Makefile b/drivers/vfio/fsl-mc/Makefile
index 0c6e5d2ddaae..cad6dbf0b735 100644
--- a/drivers/vfio/fsl-mc/Makefile
+++ b/drivers/vfio/fsl-mc/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 
-vfio-fsl-mc-y := vfio_fsl_mc.o
+vfio-fsl-mc-y := vfio_fsl_mc.o vfio_fsl_mc_intr.o
 obj-$(CONFIG_VFIO_FSL_MC) += vfio-fsl-mc.o
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 3c43f52ca162..68b206f6db6f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -211,11 +211,75 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 	}
 	case VFIO_DEVICE_GET_IRQ_INFO:
 	{
-		return -ENOTTY;
+		struct vfio_irq_info info;
+
+		minsz = offsetofend(struct vfio_irq_info, count);
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= mc_dev->obj_desc.irq_count)
+			return -EINVAL;
+
+		info.flags = VFIO_IRQ_INFO_EVENTFD;
+		info.count = 1;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
 	}
 	case VFIO_DEVICE_SET_IRQS:
 	{
-		return -ENOTTY;
+		struct vfio_irq_set hdr;
+		u8 *data = NULL;
+		int ret = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (hdr.argsz < minsz)
+			return -EINVAL;
+
+		if (hdr.index >= mc_dev->obj_desc.irq_count)
+			return -EINVAL;
+
+		if (hdr.start != 0 || hdr.count > 1)
+			return -EINVAL;
+
+		if (hdr.count == 0 &&
+		    (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE) ||
+		    !(hdr.flags & VFIO_IRQ_SET_ACTION_TRIGGER)))
+			return -EINVAL;
+
+		if (hdr.flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
+				  VFIO_IRQ_SET_ACTION_TYPE_MASK))
+			return -EINVAL;
+
+		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
+			size_t size;
+
+			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
+				size = sizeof(uint8_t);
+			else if (hdr.flags & VFIO_IRQ_SET_DATA_EVENTFD)
+				size = sizeof(int32_t);
+			else
+				return -EINVAL;
+
+			if (hdr.argsz - minsz < hdr.count * size)
+				return -EINVAL;
+
+			data = memdup_user((void __user *)(arg + minsz),
+					   hdr.count * size);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}
+
+		ret = vfio_fsl_mc_set_irqs_ioctl(vdev, hdr.flags,
+						 hdr.index, hdr.start,
+						 hdr.count, data);
+		return ret;
 	}
 	case VFIO_DEVICE_RESET:
 	{
@@ -337,6 +401,9 @@ static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
 	int ret = 0;
 
+	/* innherit the msi domain from parent */
+	dev_set_msi_domain(&mc_dev->dev, dev_get_msi_domain(mc_dev->dev.parent));
+
 	/* Non-dprc devices share mc_io from parent */
 	if (!is_fsl_mc_bus_dprc(mc_dev)) {
 		struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
new file mode 100644
index 000000000000..058aa97aa54a
--- /dev/null
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/*
+ * Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2019 NXP
+ */
+
+#include <linux/vfio.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/eventfd.h>
+#include <linux/msi.h>
+
+#include "linux/fsl/mc.h"
+#include "vfio_fsl_mc_private.h"
+
+static int vfio_fsl_mc_irq_mask(struct vfio_fsl_mc_device *vdev,
+				unsigned int index, unsigned int start,
+				unsigned int count, u32 flags,
+				void *data)
+{
+	return -EINVAL;
+}
+
+static int vfio_fsl_mc_irq_unmask(struct vfio_fsl_mc_device *vdev,
+				unsigned int index, unsigned int start,
+				unsigned int count, u32 flags,
+				void *data)
+{
+	return -EINVAL;
+}
+
+static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
+				       unsigned int index, unsigned int start,
+				       unsigned int count, u32 flags,
+				       void *data)
+{
+	return -EINVAL;
+}
+
+int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
+			       u32 flags, unsigned int index,
+			       unsigned int start, unsigned int count,
+			       void *data)
+{
+	int ret = -ENOTTY;
+
+	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+	case VFIO_IRQ_SET_ACTION_MASK:
+		ret = vfio_fsl_mc_irq_mask(vdev, index, start, count,
+					   flags, data);
+		break;
+	case VFIO_IRQ_SET_ACTION_UNMASK:
+		ret = vfio_fsl_mc_irq_unmask(vdev, index, start, count,
+					     flags, data);
+		break;
+	case VFIO_IRQ_SET_ACTION_TRIGGER:
+		ret = vfio_fsl_mc_set_irq_trigger(vdev, index, start,
+						  count, flags, data);
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index f34fe8721848..40e8cc8d32de 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -39,4 +39,9 @@ struct vfio_fsl_mc_device {
 
 };
 
+extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
+			       u32 flags, unsigned int index,
+			       unsigned int start, unsigned int count,
+			       void *data);
+
 #endif /* VFIO_FSL_MC_PRIVATE_H */
-- 
2.17.1

