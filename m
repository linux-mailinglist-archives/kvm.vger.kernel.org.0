Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB84260BB7
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgIHHSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:18:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:30573 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729295AbgIHHSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:18:10 -0400
IronPort-SDR: 7s9ALvXixq2J3i33Jd1hKZHmU66gfdgvDtiWlXjpGhQNoFbvsrUd73C9hAIqOoOFtEnPI6Mdub
 yflSmVWD0kgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="159058773"
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="159058773"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 00:18:06 -0700
IronPort-SDR: ZndmxuCdVVQ2yvIAJKZS5QIjK5fY1BBWim7eczhXA6Mtpcen8h/fWe8Z1NlX+SECXzONNhH+sq
 tQuiMdlfrr8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="448677740"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by orsmga004.jf.intel.com with ESMTP; 08 Sep 2020 00:18:03 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     mdf@kernel.org, alex.williamson@redhat.com, kwankhede@nvidia.com,
        linux-fpga@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     trix@redhat.com, lgoncalv@redhat.com, yilun.xu@intel.com
Subject: [PATCH 2/3] fpga: dfl: VFIO mdev support for DFL devices
Date:   Tue,  8 Sep 2020 15:13:31 +0800
Message-Id: <1599549212-24253-3-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is to provide VFIO support to DFL devices. When bound this
driver to a dfl device, it registers a set of callbacks to the mediated
device framework to enable mediated device creation. When a mediated
device is created by user via mdev interfaces, it will be exposed to
user as a VFIO platform device.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 drivers/fpga/Kconfig         |   9 +
 drivers/fpga/Makefile        |   1 +
 drivers/fpga/vfio-mdev-dfl.c | 391 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 401 insertions(+)
 create mode 100644 drivers/fpga/vfio-mdev-dfl.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 38c7130..88f64fb 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -202,6 +202,15 @@ config FPGA_DFL_NIOS_INTEL_PAC_N3000
 	  the card. It also instantiates the SPI master (spi-altera) for
 	  the card's BMC (Board Management Controller) control.
 
+config FPGA_VFIO_MDEV_DFL
+        tristate "VFIO Mdev support for DFL devices"
+        depends on FPGA_DFL && VFIO_MDEV
+        help
+	  Support for DFL devices with VFIO Mdev. This is required to make use
+	  of DFL devices present on the system using the VFIO Mdev framework.
+
+	  If you don't know what to do here, say N.
+
 config FPGA_DFL_PCI
 	tristate "FPGA DFL PCIe Device Driver"
 	depends on PCI && FPGA_DFL
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index 18dc9885..c69bfc9 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -45,6 +45,7 @@ dfl-afu-objs := dfl-afu-main.o dfl-afu-region.o dfl-afu-dma-region.o
 dfl-afu-objs += dfl-afu-error.o
 
 obj-$(CONFIG_FPGA_DFL_NIOS_INTEL_PAC_N3000)	+= dfl-n3000-nios.o
+obj-$(CONFIG_FPGA_VFIO_MDEV_DFL)	+= vfio-mdev-dfl.o
 
 # Drivers for FPGAs which implement DFL
 obj-$(CONFIG_FPGA_DFL_PCI)		+= dfl-pci.o
diff --git a/drivers/fpga/vfio-mdev-dfl.c b/drivers/fpga/vfio-mdev-dfl.c
new file mode 100644
index 0000000..34fb19f
--- /dev/null
+++ b/drivers/fpga/vfio-mdev-dfl.c
@@ -0,0 +1,391 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * VFIO Mediated device driver for DFL devices
+ *
+ * Copyright (C) 2019-2020 Intel Corporation, Inc.
+ */
+#include <linux/device.h>
+#include <linux/fpga/dfl-bus.h>
+#include <linux/init.h>
+#include <linux/iommu.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/kernel.h>
+#include <linux/mdev.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+
+struct vfio_mdev_dfl_dev {
+	struct device *dev;
+	void __iomem *ioaddr;
+	resource_size_t phys;
+	resource_size_t memsize;
+	int num_irqs;
+	u32 region_flags;
+	atomic_t avail;
+};
+
+static ssize_t
+name_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	return sprintf(buf, "%s-type1\n", dev_name(dev));
+}
+static MDEV_TYPE_ATTR_RO(name);
+
+static ssize_t
+available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct vfio_mdev_dfl_dev *vmdd = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", atomic_read(&vmdd->avail));
+}
+static MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
+			       char *buf)
+{
+	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PLATFORM_STRING);
+}
+static MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *mdev_types_attrs[] = {
+	&mdev_type_attr_name.attr,
+	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_available_instances.attr,
+	NULL,
+};
+
+static struct attribute_group dfl_mdev_type_group1 = {
+	.name  = "1",
+	.attrs = mdev_types_attrs,
+};
+
+static struct attribute_group *dfl_mdev_type_groups[] = {
+	&dfl_mdev_type_group1,
+	NULL,
+};
+
+static int dfl_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+	struct vfio_mdev_dfl_dev *vmdd =
+		dev_get_drvdata(mdev_parent_dev(mdev));
+
+	if (atomic_dec_if_positive(&vmdd->avail) < 0)
+		return -EPERM;
+
+	return 0;
+}
+
+static int dfl_mdev_remove(struct mdev_device *mdev)
+{
+	struct vfio_mdev_dfl_dev *vmdd =
+		dev_get_drvdata(mdev_parent_dev(mdev));
+
+	atomic_inc(&vmdd->avail);
+
+	return 0;
+}
+
+static ssize_t dfl_mdev_read(struct mdev_device *mdev, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct vfio_mdev_dfl_dev *vmdd =
+		dev_get_drvdata(mdev_parent_dev(mdev));
+	unsigned int done = 0;
+	loff_t off = *ppos;
+
+	if (off + count > vmdd->memsize)
+		return -EFAULT;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 8 && !(off % 8)) {
+			u64 val;
+
+			val = ioread64(vmdd->ioaddr + off);
+			if (copy_to_user(buf, &val, 8))
+				goto err;
+
+			filled = 8;
+		} else if (count >= 4 && !(off % 4)) {
+			u32 val;
+
+			val = ioread32(vmdd->ioaddr + off);
+			if (copy_to_user(buf, &val, 4))
+				goto err;
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			val = ioread16(vmdd->ioaddr + off);
+			if (copy_to_user(buf, &val, 2))
+				goto err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			val = ioread8(vmdd->ioaddr + off);
+			if (copy_to_user(buf, &val, 1))
+				goto err;
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		off += filled;
+		buf += filled;
+	}
+
+	return done;
+err:
+	return -EFAULT;
+}
+
+static ssize_t dfl_mdev_write(struct mdev_device *mdev, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct vfio_mdev_dfl_dev *vmdd =
+		dev_get_drvdata(mdev_parent_dev(mdev));
+	unsigned int done = 0;
+	loff_t off = *ppos;
+
+	if (off + count > vmdd->memsize)
+		return -EFAULT;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 8 && !(off % 8)) {
+			u64 val;
+
+			if (copy_from_user(&val, buf, 8))
+				goto err;
+			iowrite64(val, vmdd->ioaddr + off);
+
+			filled = 8;
+		} else if (count >= 4 && !(off % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, 4))
+				goto err;
+			iowrite32(val, vmdd->ioaddr + off);
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, 2))
+				goto err;
+			iowrite16(val, vmdd->ioaddr + off);
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, 1))
+				goto err;
+			iowrite8(val, vmdd->ioaddr + off);
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		off += filled;
+		buf += filled;
+	}
+
+	return done;
+err:
+	return -EFAULT;
+}
+
+static long dfl_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct vfio_mdev_dfl_dev *vmdd =
+		dev_get_drvdata(mdev_parent_dev(mdev));
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
+		info.flags = VFIO_DEVICE_FLAGS_PLATFORM;
+		info.num_regions = 1;
+		info.num_irqs = vmdd->num_irqs;
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
+		if (info.index >= 1)
+			return -EINVAL;
+
+		info.offset = 0;
+		info.size = vmdd->memsize;
+		info.flags = vmdd->region_flags;
+
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+			-EFAULT : 0;
+	}
+	}
+
+	return -ENOTTY;
+}
+
+static int dfl_mdev_mmap_mmio(struct vfio_mdev_dfl_dev *vmdd,
+			      struct vm_area_struct *vma)
+{
+	u64 req_len, req_start;
+
+	req_len = vma->vm_end - vma->vm_start;
+	req_start = vma->vm_pgoff << PAGE_SHIFT;
+
+	if (vmdd->memsize < PAGE_SIZE || req_start + req_len > vmdd->memsize)
+		return -EINVAL;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	return remap_pfn_range(vma, vma->vm_start,
+			       (vmdd->phys + req_start) >> PAGE_SHIFT,
+			       req_len, vma->vm_page_prot);
+}
+
+static int dfl_mdev_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+{
+	struct vfio_mdev_dfl_dev *vmdd =
+		dev_get_drvdata(mdev_parent_dev(mdev));
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+	if (vma->vm_start & ~PAGE_MASK)
+		return -EINVAL;
+	if (vma->vm_end & ~PAGE_MASK)
+		return -EINVAL;
+
+	if (!(vmdd->region_flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(vmdd->region_flags & VFIO_REGION_INFO_FLAG_READ) &&
+	    (vma->vm_flags & VM_READ))
+		return -EINVAL;
+
+	if (!(vmdd->region_flags & VFIO_REGION_INFO_FLAG_WRITE) &&
+	    (vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+
+	vma->vm_private_data = vmdd;
+
+	return dfl_mdev_mmap_mmio(vmdd, vma);
+}
+
+static int dfl_mdev_open(struct mdev_device *mdev)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void dfl_mdev_close(struct mdev_device *mdev)
+{
+	module_put(THIS_MODULE);
+}
+
+static const struct mdev_parent_ops dfl_mdev_ops = {
+	.owner                  = THIS_MODULE,
+	.supported_type_groups  = dfl_mdev_type_groups,
+	.create                 = dfl_mdev_create,
+	.remove			= dfl_mdev_remove,
+	.open                   = dfl_mdev_open,
+	.release                = dfl_mdev_close,
+	.read                   = dfl_mdev_read,
+	.write                  = dfl_mdev_write,
+	.ioctl		        = dfl_mdev_ioctl,
+	.mmap			= dfl_mdev_mmap,
+};
+
+static int vfio_mdev_dfl_probe(struct dfl_device *dfl_dev)
+{
+	struct device *dev = &dfl_dev->dev;
+	struct vfio_mdev_dfl_dev *vmdd;
+
+	vmdd = devm_kzalloc(dev, sizeof(*vmdd), GFP_KERNEL);
+	if (!vmdd)
+		return -ENOMEM;
+
+	dev_set_drvdata(&dfl_dev->dev, vmdd);
+
+	atomic_set(&vmdd->avail, 1);
+	vmdd->dev = &dfl_dev->dev;
+	vmdd->phys = dfl_dev->mmio_res.start;
+	vmdd->memsize = resource_size(&dfl_dev->mmio_res);
+	vmdd->region_flags = VFIO_REGION_INFO_FLAG_READ |
+			    VFIO_REGION_INFO_FLAG_WRITE;
+	/*
+	 * Only regions addressed with PAGE granularity may be MMAPed
+	 * securely.
+	 */
+	if (!(vmdd->phys & ~PAGE_MASK) && !(vmdd->memsize & ~PAGE_MASK))
+		vmdd->region_flags |= VFIO_REGION_INFO_FLAG_MMAP;
+
+	vmdd->ioaddr = devm_ioremap_resource(&dfl_dev->dev, &dfl_dev->mmio_res);
+	if (IS_ERR(vmdd->ioaddr)) {
+		dev_err(dev, "get mem resource fail!\n");
+		return PTR_ERR(vmdd->ioaddr);
+	}
+
+	/* irq not supported yet */
+	vmdd->num_irqs = 0;
+
+	return mdev_register_device(&dfl_dev->dev, &dfl_mdev_ops);
+}
+
+static void vfio_mdev_dfl_remove(struct dfl_device *dfl_dev)
+{
+	mdev_unregister_device(&dfl_dev->dev);
+}
+
+static struct dfl_driver vfio_mdev_dfl_driver = {
+	.drv	= {
+		.name       = "vfio-mdev-dfl",
+	},
+	.probe   = vfio_mdev_dfl_probe,
+	.remove  = vfio_mdev_dfl_remove,
+};
+
+module_dfl_driver(vfio_mdev_dfl_driver);
+
+MODULE_DESCRIPTION("VFIO MDEV DFL driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

