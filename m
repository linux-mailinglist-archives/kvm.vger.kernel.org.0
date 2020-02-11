Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F114F158CA1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgBKKYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:24:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:22872 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgBKKYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:24:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:24:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221888988"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:24:07 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 7/9] samples/vfio-pci: add a sample vendor module of vfio-pci for IGD devices
Date:   Tue, 11 Feb 2020 05:14:47 -0500
Message-Id: <20200211101447.21137-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This sample driver does nothing but calls default device ops of vfio-pci
to pass through IGD devices.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 samples/Kconfig           |   6 ++
 samples/Makefile          |   1 +
 samples/vfio-pci/Makefile |   2 +
 samples/vfio-pci/igd_pt.c | 148 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 157 insertions(+)
 create mode 100644 samples/vfio-pci/Makefile
 create mode 100644 samples/vfio-pci/igd_pt.c

diff --git a/samples/Kconfig b/samples/Kconfig
index c8dacb4dda80..84d6a91567af 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -169,4 +169,10 @@ config SAMPLE_VFS
 	  as mount API and statx().  Note that this is restricted to the x86
 	  arch whilst it accesses system calls that aren't yet in all arches.
 
+config SAMPLE_VFIO_PCI_IGD_PT
+	tristate "Build VFIO sample vendor driver to pass through IGD devices -- loadable modules only"
+	depends on VFIO_PCI && m
+	help
+	  Build a sample driver to pass through IGD devices as a vendor driver
+	  of VFIO PCI.
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 7d6e4ca28d69..db56daf3a11c 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -19,4 +19,5 @@ obj-$(CONFIG_SAMPLE_TRACE_EVENTS)	+= trace_events/
 obj-$(CONFIG_SAMPLE_TRACE_PRINTK)	+= trace_printk/
 obj-$(CONFIG_VIDEO_PCI_SKELETON)	+= v4l/
 obj-y					+= vfio-mdev/
+obj-y					+= vfio-pci/
 subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
diff --git a/samples/vfio-pci/Makefile b/samples/vfio-pci/Makefile
new file mode 100644
index 000000000000..7125f0a325c2
--- /dev/null
+++ b/samples/vfio-pci/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_SAMPLE_VFIO_PCI_IGD_PT) += igd_pt.o
diff --git a/samples/vfio-pci/igd_pt.c b/samples/vfio-pci/igd_pt.c
new file mode 100644
index 000000000000..45acbd1ad2fb
--- /dev/null
+++ b/samples/vfio-pci/igd_pt.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Pass through IGD devices as a vendor driver of vfio-pci device driver
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
+/*
+ * below are pciids of IGD devices supported in this driver
+ */
+static const struct pci_device_id pciidlist[] = {
+	{0x8086, 0x5927, ~0, ~0, 0x30000, 0xff0000, 0},
+	{0x8086, 0x591d, ~0, ~0, 0x30000, 0xff0000, 0},
+	{0x8086, 0x193b, ~0, ~0, 0x30000, 0xff0000, 0},
+};
+
+struct igd_pt_device {
+	__u32 vendor;
+	__u32 device;
+
+};
+
+void *igd_pt_probe(struct pci_dev *pdev)
+{
+	int supported_dev_cnt =
+		sizeof(pciidlist)/sizeof(struct pci_device_id);
+	int i;
+	struct igd_pt_device *igd_device;
+
+	for (i = 0; i < supported_dev_cnt; i++) {
+		if (pciidlist[i].vendor == pdev->vendor &&
+				pciidlist[i].device == pdev->device)
+			goto support;
+	}
+
+	return ERR_PTR(-ENODEV);
+
+support:
+
+	igd_device = kzalloc(sizeof(*igd_device), GFP_KERNEL);
+
+	if (!igd_device)
+		return ERR_PTR(-ENOMEM);
+
+	igd_device->vendor = pdev->vendor;
+	igd_device->device = pdev->device;
+
+	return igd_device;
+}
+
+static void igd_pt_remove(void *vendor_data)
+{
+	struct igd_pt_device *igd_device =
+		(struct igd_pt_device *)vendor_data;
+
+	kfree(igd_device);
+}
+
+static int igd_pt_open(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vfio_pci_open(vdev);
+}
+
+void igd_pt_release(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	vfio_pci_release(vdev);
+}
+
+static long igd_pt_ioctl(void *device_data,
+			 unsigned int cmd, unsigned long arg)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vfio_pci_ioctl(vdev, cmd, arg);
+}
+
+static ssize_t igd_pt_read(void *device_data, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vfio_pci_read(vdev, buf, count, ppos);
+}
+
+static ssize_t igd_pt_write(void *device_data, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vfio_pci_write(vdev, buf, count, ppos);
+}
+
+static int igd_pt_mmap(void *device_data, struct vm_area_struct *vma)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vfio_pci_mmap(vdev, vma);
+}
+
+static void igd_pt_request(void *device_data, unsigned int count)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	vfio_pci_request(vdev, count);
+}
+
+static struct vfio_device_ops igd_pt_device_ops_node = {
+	.name		= "IGD dt",
+	.open		= igd_pt_open,
+	.release	= igd_pt_release,
+	.ioctl		= igd_pt_ioctl,
+	.read		= igd_pt_read,
+	.write		= igd_pt_write,
+	.mmap		= igd_pt_mmap,
+	.request	= igd_pt_request,
+};
+
+#define igd_pt_device_ops (&igd_pt_device_ops_node)
+
+module_vfio_pci_register_vendor_handler("IGD dt", igd_pt_probe,
+					igd_pt_remove, igd_pt_device_ops);
+
+MODULE_ALIAS("vfio-pci:8086-591d");
+MODULE_ALIAS("vfio-pci:8086-5927");
+MODULE_LICENSE("GPL v2");
+MODULE_INFO(supported, "Sample driver as vendor driver of vfio-pci to pass through IGD");
+MODULE_VERSION(VERSION_STRING);
+MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
2.17.1

