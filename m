Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8673E18FB3A
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 18:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgCWRTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 13:19:31 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50456 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgCWRTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 13:19:30 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5B4711A14DE;
        Mon, 23 Mar 2020 18:19:27 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C6CB1A14D4;
        Mon, 23 Mar 2020 18:19:27 +0100 (CET)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E8F832035C;
        Mon, 23 Mar 2020 18:19:26 +0100 (CET)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     kvm@vger.kernel.org, alex.williamson@redhat.com,
        laurentiu.tudor@nxp.com, linux-arm-kernel@lists.infradead.org,
        bharatb.yadav@gmail.com
Cc:     linux-kernel@vger.kernel.org,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH 1/9] vfio/fsl-mc: Add VFIO framework skeleton for fsl-mc devices
Date:   Mon, 23 Mar 2020 19:19:03 +0200
Message-Id: <20200323171911.27178-2-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
References: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bharat Bhushan <Bharat.Bhushan@nxp.com>

DPAA2 (Data Path Acceleration Architecture) consists in
mechanisms for processing Ethernet packets, queue management,
accelerators, etc.

The Management Complex (mc) is a hardware entity that manages the DPAA2
hardware resources. It provides an object-based abstraction for software
drivers to use the DPAA2 hardware. The MC mediates operations such as
create, discover, destroy of DPAA2 objects.
The MC provides memory-mapped I/O command interfaces (MC portals) which
DPAA2 software drivers use to operate on DPAA2 objects.

A DPRC is a container object that holds other types of DPAA2 objects.
Each object in the DPRC is a Linux device and bound to a driver.
The MC-bus driver is a platform driver (different from PCI or platform
bus). The DPRC driver does runtime management of a bus instance. It
performs the initial scan of the DPRC and handles changes in the DPRC
configuration (adding/removing objects).

All objects inside a container share the same hardware isolation
context, meaning that only an entire DPRC can be assigned to
a virtual machine.
When a container is assigned to a virtual machine, all the objects
within that container are assigned to that virtual machine.
The DPRC container assigned to the virtual machine is not allowed
to change contents (add/remove objects) by the guest. The restriction
is set by the host and enforced by the mc hardware.

The DPAA2 objects can be directly assigned to the guest. However
the MC portals (the memory mapped command interface to the MC) need
to be emulated because there are commands that configure the
interrupts and the isolation IDs which are virtual in the guest.

Example:
echo vfio-fsl-mc > /sys/bus/fsl-mc/devices/dprc.2/driver_override
echo dprc.2 > /sys/bus/fsl-mc/drivers/vfio-fsl-mc/bind

The dprc.2 is bound to the VFIO driver and all the objects within
dprc.2 are going to be bound to the VFIO driver.

This patch adds the infrastructure for VFIO support for fsl-mc
devices. Subsequent patches will add support for binding and secure
assigning these devices using VFIO.

More details about the DPAA2 objects can be found here:
Documentation/networking/device_drivers/freescale/dpaa2/overview.rst

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 MAINTAINERS                               |   6 +
 drivers/vfio/Kconfig                      |   1 +
 drivers/vfio/Makefile                     |   1 +
 drivers/vfio/fsl-mc/Kconfig               |   9 ++
 drivers/vfio/fsl-mc/Makefile              |   2 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 161 ++++++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  14 ++
 include/uapi/linux/vfio.h                 |   1 +
 8 files changed, 195 insertions(+)
 create mode 100644 drivers/vfio/fsl-mc/Kconfig
 create mode 100644 drivers/vfio/fsl-mc/Makefile
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc.c
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h

diff --git a/MAINTAINERS b/MAINTAINERS
index cc1d18cb5d18..fc547e6f5bf8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17566,6 +17566,12 @@ F:	drivers/vfio/
 F:	include/linux/vfio.h
 F:	include/uapi/linux/vfio.h
 
+VFIO FSL-MC DRIVER
+M:	Diana Craciun <diana.craciun@oss.nxp.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/fsl-mc/
+
 VFIO MEDIATED DEVICE DRIVERS
 M:	Kirti Wankhede <kwankhede@nvidia.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index fd17db9b432f..5533df91b257 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -47,4 +47,5 @@ menuconfig VFIO_NOIOMMU
 source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
+source "drivers/vfio/fsl-mc/Kconfig"
 source "virt/lib/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index de67c4725cce..fee73f3d9480 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
 obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
+obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
new file mode 100644
index 000000000000..b1a527d6b6f2
--- /dev/null
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -0,0 +1,9 @@
+config VFIO_FSL_MC
+	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
+	depends on VFIO && FSL_MC_BUS && EVENTFD
+	help
+	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
+	  (Management Complex) devices. This is required to passthrough
+	  fsl-mc bus devices using the VFIO framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/fsl-mc/Makefile b/drivers/vfio/fsl-mc/Makefile
new file mode 100644
index 000000000000..6f2b80645d5b
--- /dev/null
+++ b/drivers/vfio/fsl-mc/Makefile
@@ -0,0 +1,2 @@
+vfio-fsl_mc-y := vfio_fsl_mc.o
+obj-$(CONFIG_VFIO_FSL_MC) += vfio_fsl_mc.o
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
new file mode 100644
index 000000000000..320fb09b5691
--- /dev/null
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/*
+ * Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2016-2017,2019-2020 NXP
+ */
+
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+#include <linux/fsl/mc.h>
+
+#include "vfio_fsl_mc_private.h"
+
+static int vfio_fsl_mc_open(void *device_data)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void vfio_fsl_mc_release(void *device_data)
+{
+	module_put(THIS_MODULE);
+}
+
+static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
+			      unsigned long arg)
+{
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+	{
+		return -EINVAL;
+	}
+	case VFIO_DEVICE_GET_REGION_INFO:
+	{
+		return -EINVAL;
+	}
+	case VFIO_DEVICE_GET_IRQ_INFO:
+	{
+		return -EINVAL;
+	}
+	case VFIO_DEVICE_SET_IRQS:
+	{
+		return -EINVAL;
+	}
+	case VFIO_DEVICE_RESET:
+	{
+		return -EINVAL;
+	}
+	default:
+		return -EINVAL;
+	}
+}
+
+static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
+{
+	return -EINVAL;
+}
+
+static const struct vfio_device_ops vfio_fsl_mc_ops = {
+	.name		= "vfio-fsl-mc",
+	.open		= vfio_fsl_mc_open,
+	.release	= vfio_fsl_mc_release,
+	.ioctl		= vfio_fsl_mc_ioctl,
+	.read		= vfio_fsl_mc_read,
+	.write		= vfio_fsl_mc_write,
+	.mmap		= vfio_fsl_mc_mmap,
+};
+
+static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
+{
+	struct iommu_group *group;
+	struct vfio_fsl_mc_device *vdev;
+	struct device *dev = &mc_dev->dev;
+	int ret;
+
+	group = vfio_iommu_group_get(dev);
+	if (!group) {
+		dev_err(dev, "%s: VFIO: No IOMMU group\n", __func__);
+		return -EINVAL;
+	}
+
+	vdev = devm_kzalloc(dev, sizeof(*vdev), GFP_KERNEL);
+	if (!vdev) {
+		vfio_iommu_group_put(group, dev);
+		return -ENOMEM;
+	}
+
+	vdev->mc_dev = mc_dev;
+
+	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
+	if (ret) {
+		dev_err(dev, "%s: Failed to add to vfio group\n", __func__);
+		vfio_iommu_group_put(group, dev);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
+{
+	struct vfio_fsl_mc_device *vdev;
+	struct device *dev = &mc_dev->dev;
+
+	vdev = vfio_del_group_dev(dev);
+	if (!vdev)
+		return -EINVAL;
+
+	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
+	devm_kfree(dev, vdev);
+
+	return 0;
+}
+
+/*
+ * vfio-fsl_mc is a meta-driver, so use driver_override interface to
+ * bind a fsl_mc container with this driver and match_id_table is NULL.
+ */
+static struct fsl_mc_driver vfio_fsl_mc_driver = {
+	.probe		= vfio_fsl_mc_probe,
+	.remove		= vfio_fsl_mc_remove,
+	.match_id_table = NULL,
+	.driver	= {
+		.name	= "vfio-fsl-mc",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init vfio_fsl_mc_driver_init(void)
+{
+	return fsl_mc_driver_register(&vfio_fsl_mc_driver);
+}
+
+static void __exit vfio_fsl_mc_driver_exit(void)
+{
+	fsl_mc_driver_unregister(&vfio_fsl_mc_driver);
+}
+
+module_init(vfio_fsl_mc_driver_init);
+module_exit(vfio_fsl_mc_driver_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("VFIO for FSL-MC devices - User Level meta-driver");
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
new file mode 100644
index 000000000000..b92858a003c0
--- /dev/null
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/*
+ * Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2016,2019-2020 NXP
+ */
+
+#ifndef VFIO_FSL_MC_PRIVATE_H
+#define VFIO_FSL_MC_PRIVATE_H
+
+struct vfio_fsl_mc_device {
+	struct fsl_mc_device		*mc_dev;
+};
+
+#endif /* VFIO_PCI_PRIVATE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..6d0a7a071ef4 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -201,6 +201,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
 #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
+#define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
2.17.1

