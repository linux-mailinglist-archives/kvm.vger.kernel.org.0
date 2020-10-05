Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2105283D72
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgJERhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:37:21 -0400
Received: from inva020.nxp.com ([92.121.34.13]:52162 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728604AbgJERhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:37:02 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7B00B1A0940;
        Mon,  5 Oct 2020 19:37:00 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6B8CC1A091E;
        Mon,  5 Oct 2020 19:37:00 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 18B662032B;
        Mon,  5 Oct 2020 19:37:00 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v6 07/10] vfio/fsl-mc: Add irq infrastructure for fsl-mc devices
Date:   Mon,  5 Oct 2020 20:36:51 +0300
Message-Id: <20201005173654.31773-8-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
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
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 52 ++++++++++++++++++++++-
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 34 +++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  6 +++
 4 files changed, 91 insertions(+), 3 deletions(-)
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
index b52407c4e1ea..7803a9d6bfd9 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -217,11 +217,55 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
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
+		size_t data_size = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		ret = vfio_set_irqs_validate_and_prepare(&hdr, mc_dev->obj_desc.irq_count,
+					mc_dev->obj_desc.irq_count, &data_size);
+		if (ret)
+			return ret;
+
+		if (data_size) {
+			data = memdup_user((void __user *)(arg + minsz),
+				   data_size);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}
+
+		mutex_lock(&vdev->igate);
+		ret = vfio_fsl_mc_set_irqs_ioctl(vdev, hdr.flags,
+						 hdr.index, hdr.start,
+						 hdr.count, data);
+		mutex_unlock(&vdev->igate);
+		kfree(data);
+
+		return ret;
 	}
 	case VFIO_DEVICE_RESET:
 	{
@@ -423,6 +467,8 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	if (ret)
 		goto out_reflck;
 
+	mutex_init(&vdev->igate);
+
 	return 0;
 
 out_reflck:
@@ -443,6 +489,8 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (!vdev)
 		return -EINVAL;
 
+	mutex_destroy(&vdev->igate);
+
 	vfio_fsl_mc_reflck_put(vdev->reflck);
 
 	if (is_fsl_mc_bus_dprc(mc_dev)) {
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
new file mode 100644
index 000000000000..5232f208e361
--- /dev/null
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -0,0 +1,34 @@
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
+	if (flags & VFIO_IRQ_SET_ACTION_TRIGGER)
+		return  vfio_fsl_mc_set_irq_trigger(vdev, index, start,
+			  count, flags, data);
+	else
+		return -EINVAL;
+}
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index d47ef6215429..2c3f625a3240 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -33,6 +33,12 @@ struct vfio_fsl_mc_device {
 	int				refcnt;
 	struct vfio_fsl_mc_region	*regions;
 	struct vfio_fsl_mc_reflck   *reflck;
+	struct mutex         igate;
 };
 
+extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
+			       u32 flags, unsigned int index,
+			       unsigned int start, unsigned int count,
+			       void *data);
+
 #endif /* VFIO_FSL_MC_PRIVATE_H */
-- 
2.17.1

