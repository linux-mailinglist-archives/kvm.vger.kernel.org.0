Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2326113A73
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 04:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfLEDfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 22:35:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:10227 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfLEDfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 22:35:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 19:35:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,279,1571727600"; 
   d="scan'208";a="243095169"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 04 Dec 2019 19:35:15 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 5/9] samples/vfio-pci/igd_dt: sample driver to mediate a passthrough IGD
Date:   Wed,  4 Dec 2019 22:27:04 -0500
Message-Id: <20191205032704.29841-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205032419.29606-1-yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a sample driver to use mediate ops for passthrough IGDs.

This sample driver does not directly bind to IGD device but defines what
IGD devices to support via a pciidlist.

It registers its vfio_pci_mediate_ops to vfio-pci on driver loading.

when vfio_pci->open() calls vfio_pci_mediate_ops->open(), it will check
the vendor id and device id of the pdev passed in. If they match in
pciidlist, success is returned; otherwise, failure is return.

After a success vfio_pci_mediate_ops->open(), vfio-pci will further call
.get_region_info/.rw/.mmap interface with a mediate handle for each region
and therefore the regions access get mediated/customized.

when vfio-pci->release() is called on the IGD, it first calls
vfio_pci_mediate_ops->release() with a mediate_handle to close the
opened IGD device instance in this sample driver.

This sample driver unregister its vfio_pci_mediate_ops on driver exiting.

Cc: Kevin Tian <kevin.tian@intel.com>

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 samples/Kconfig           |   6 ++
 samples/Makefile          |   1 +
 samples/vfio-pci/Makefile |   2 +
 samples/vfio-pci/igd_dt.c | 191 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 200 insertions(+)
 create mode 100644 samples/vfio-pci/Makefile
 create mode 100644 samples/vfio-pci/igd_dt.c

diff --git a/samples/Kconfig b/samples/Kconfig
index c8dacb4dda80..2da42a725c03 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -169,4 +169,10 @@ config SAMPLE_VFS
 	  as mount API and statx().  Note that this is restricted to the x86
 	  arch whilst it accesses system calls that aren't yet in all arches.
 
+config SAMPLE_VFIO_PCI_IGD_DT
+	tristate "Build example driver to dynamicaly trap a passthroughed device bound to VFIO-PCI -- loadable modules only"
+	depends on VFIO_PCI && m
+	help
+	  Build a sample driver to show how to dynamically trap a passthroughed device that bound to VFIO-PCI
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 7d6e4ca28d69..f0f422e7dd11 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -18,5 +18,6 @@ subdir-$(CONFIG_SAMPLE_SECCOMP)		+= seccomp
 obj-$(CONFIG_SAMPLE_TRACE_EVENTS)	+= trace_events/
 obj-$(CONFIG_SAMPLE_TRACE_PRINTK)	+= trace_printk/
 obj-$(CONFIG_VIDEO_PCI_SKELETON)	+= v4l/
+obj-$(CONFIG_SAMPLE_VFIO_PCI_IGD_DT)	+= vfio-pci/
 obj-y					+= vfio-mdev/
 subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
diff --git a/samples/vfio-pci/Makefile b/samples/vfio-pci/Makefile
new file mode 100644
index 000000000000..4b8acc145d65
--- /dev/null
+++ b/samples/vfio-pci/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_SAMPLE_VFIO_PCI_IGD_DT) += igd_dt.o
diff --git a/samples/vfio-pci/igd_dt.c b/samples/vfio-pci/igd_dt.c
new file mode 100644
index 000000000000..857e8d01b0d1
--- /dev/null
+++ b/samples/vfio-pci/igd_dt.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Dynamic trap IGD device that bound to vfio-pci device driver
+ * Copyright(c) 2019 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/vfio.h>
+#include <linux/sysfs.h>
+#include <linux/file.h>
+#include <linux/pci.h>
+#include <linux/eventfd.h>
+
+#define VERSION_STRING  "0.1"
+#define DRIVER_AUTHOR   "Intel Corporation"
+
+/* helper macros copied from vfio-pci */
+#define VFIO_PCI_OFFSET_SHIFT   40
+#define VFIO_PCI_OFFSET_TO_INDEX(off)   ((off) >> VFIO_PCI_OFFSET_SHIFT)
+#define VFIO_PCI_OFFSET_MASK    (((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
+
+/* This driver supports to open max 256 device devices */
+#define MAX_OPEN_DEVICE 256
+
+/*
+ * below are pciids of two IGD devices supported in this driver
+ * It is only for demo purpose.
+ * You can add more device ids in this list to support any pci devices
+ * that you want to dynamically trap its pci bars
+ */
+static const struct pci_device_id pciidlist[] = {
+	{0x8086, 0x5927, ~0, ~0, 0x30000, 0xff0000, 0},
+	{0x8086, 0x193b, ~0, ~0, 0x30000, 0xff0000, 0},
+};
+
+static long igd_device_bits[MAX_OPEN_DEVICE/BITS_PER_LONG + 1];
+static DEFINE_MUTEX(device_bit_lock);
+
+struct igd_dt_device {
+	__u32 vendor;
+	__u32 device;
+	__u32 handle;
+};
+
+static struct igd_dt_device *igd_device_array[MAX_OPEN_DEVICE];
+
+int igd_dt_open(struct pci_dev *pdev, u64 *caps, u32 *mediate_handle)
+{
+	int supported_dev_cnt = sizeof(pciidlist)/sizeof(struct pci_device_id);
+	int i, ret = 0;
+	struct igd_dt_device *igd_device;
+	int handle;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	for (i = 0; i < supported_dev_cnt; i++) {
+		if (pciidlist[i].vendor == pdev->vendor &&
+				pciidlist[i].device == pdev->device)
+			goto support;
+	}
+
+	module_put(THIS_MODULE);
+	return -ENODEV;
+
+support:
+	mutex_lock(&device_bit_lock);
+	handle = find_next_zero_bit(igd_device_bits, MAX_OPEN_DEVICE, 0);
+	if (handle >= MAX_OPEN_DEVICE) {
+		ret = -EBUSY;
+		goto error;
+	}
+
+	igd_device = kzalloc(sizeof(*igd_device), GFP_KERNEL);
+
+	if (!igd_device) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	igd_device->vendor = pdev->vendor;
+	igd_device->device = pdev->device;
+	igd_device->handle = handle;
+	igd_device_array[handle] = igd_device;
+	set_bit(handle, igd_device_bits);
+
+	pr_info("%s open device %x %x, handle=%x\n", __func__,
+			pdev->vendor, pdev->device, handle);
+
+	*mediate_handle = handle;
+
+error:
+	mutex_unlock(&device_bit_lock);
+	if (ret < 0)
+		module_put(THIS_MODULE);
+	return ret;
+}
+
+void igd_dt_release(int handle)
+{
+	struct igd_dt_device *igd_device;
+
+	mutex_lock(&device_bit_lock);
+
+	if (handle >= MAX_OPEN_DEVICE || !igd_device_array[handle] ||
+			!test_bit(handle, igd_device_bits)) {
+		pr_err("handle mismatch, please check interaction with vfio-pci module\n");
+		mutex_unlock(&device_bit_lock);
+		return;
+	}
+
+	igd_device = igd_device_array[handle];
+	igd_device_array[handle] = NULL;
+	clear_bit(handle, igd_device_bits);
+	mutex_unlock(&device_bit_lock);
+
+	pr_info("release: handle=%d, igd_device VID DID =%x %x\n",
+			handle, igd_device->vendor, igd_device->device);
+
+
+	kfree(igd_device);
+	module_put(THIS_MODULE);
+
+}
+
+static void igd_dt_get_region_info(int handle,
+		struct vfio_region_info *info,
+		struct vfio_info_cap *caps,
+		struct vfio_region_info_cap_type *cap_type)
+{
+}
+
+static ssize_t igd_dt_rw(int handle, char __user *buf,
+			   size_t count, loff_t *ppos,
+			   bool iswrite, bool *pt)
+{
+	*pt = true;
+
+	return 0;
+}
+
+static int igd_dt_mmap(int handle, struct vm_area_struct *vma, bool *pt)
+{
+	*pt = true;
+
+	return 0;
+}
+
+
+static struct vfio_pci_mediate_ops igd_dt_ops = {
+	.name = "IGD dt",
+	.open = igd_dt_open,
+	.release = igd_dt_release,
+	.get_region_info = igd_dt_get_region_info,
+	.rw = igd_dt_rw,
+	.mmap = igd_dt_mmap,
+};
+
+
+static int __init igd_dt_init(void)
+{
+	int ret = 0;
+
+	pr_info("igd_dt: %s\n", __func__);
+
+	memset(igd_device_bits, 0, sizeof(igd_device_bits));
+	memset(igd_device_array, 0, sizeof(igd_device_array));
+	vfio_pci_register_mediate_ops(&igd_dt_ops);
+	return ret;
+}
+
+static void __exit igd_dt_exit(void)
+{
+	pr_info("igd_dt: Unloaded!\n");
+	vfio_pci_unregister_mediate_ops(&igd_dt_ops);
+}
+
+module_init(igd_dt_init)
+module_exit(igd_dt_exit)
+
+MODULE_LICENSE("GPL v2");
+MODULE_INFO(supported, "Sample driver that Dynamic Trap a passthoughed IGD bound to vfio-pci");
+MODULE_VERSION(VERSION_STRING);
+MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
2.17.1

