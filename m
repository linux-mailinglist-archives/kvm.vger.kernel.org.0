Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A349AB3E5
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392619AbfIFIRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:17:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:23720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392610AbfIFIRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:17:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:17:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="383186188"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 01:17:43 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yan.y.zhao@intel.com, shaopeng.he@intel.com,
        chenbo.xia@intel.com, jun.j.tian@intel.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH v2 09/13] samples: add vfio-mdev-pci driver
Date:   Thu,  5 Sep 2019 15:59:26 +0800
Message-Id: <1567670370-4484-10-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds sample driver named vfio-mdev-pci. It is to wrap
a PCI device as a mediated device. For a pci device, once bound
to vfio-mdev-pci driver, user space access of this device will
go through vfio mdev framework. The usage of the device follows
mdev management method. e.g. user should create a mdev before
exposing the device to user-space.

Benefit of this new driver would be acting as a sample driver
for recent changes from "vfio/mdev: IOMMU aware mediated device"
patchset. Also it could be a good experiment driver for future
device specific mdev migration support.

To use this driver:
a) build and load vfio-mdev-pci.ko module
   execute "make menuconfig" and config CONFIG_SAMPLE_VFIO_MDEV_PCI
   then load it with following command
   > sudo modprobe vfio
   > sudo modprobe vfio-pci
   > sudo insmod drivers/vfio/pci/vfio-mdev-pci.ko

b) unbind original device driver
   e.g. use following command to unbind its original driver
   > echo $dev_bdf > /sys/bus/pci/devices/$dev_bdf/driver/unbind

c) bind vfio-mdev-pci driver to the physical device
   > echo $vend_id $dev_id > /sys/bus/pci/drivers/vfio-mdev-pci/new_id

d) check the supported mdev instances
   > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/
     vfio-mdev-pci-type_name
   > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
     vfio-mdev-pci-type_name/
     available_instances  create  device_api  devices  name

e)  create mdev on this physical device (only 1 instance)
   > echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1003" > \
     /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
     vfio-mdev-pci-type_name/create

f) passthru the mdev to guest
   add the following line in QEMU boot command
   -device vfio-pci,\
    sysfsdev=/sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003

g) destroy mdev
   > echo 1 > /sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003/\
     remove

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/Makefile        |   6 +
 drivers/vfio/pci/vfio_mdev_pci.c | 403 +++++++++++++++++++++++++++++++++++++++
 samples/Kconfig                  |  11 ++
 3 files changed, 420 insertions(+)
 create mode 100644 drivers/vfio/pci/vfio_mdev_pci.c

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index d94317a..ac118ef 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -5,4 +5,10 @@ vfio-pci-y := vfio_pci.o vfio_pci_common.o vfio_pci_intrs.o \
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
 
+vfio-mdev-pci-y := vfio_mdev_pci.o vfio_pci_common.o vfio_pci_intrs.o \
+			vfio_pci_rdwr.o vfio_pci_config.o
+vfio-mdev-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-mdev-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
+
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
+obj-$(CONFIG_SAMPLE_VFIO_MDEV_PCI) += vfio-mdev-pci.o
diff --git a/drivers/vfio/pci/vfio_mdev_pci.c b/drivers/vfio/pci/vfio_mdev_pci.c
new file mode 100644
index 0000000..07c8067
--- /dev/null
+++ b/drivers/vfio/pci/vfio_mdev_pci.c
@@ -0,0 +1,403 @@
+/*
+ * Copyright © 2019 Intel Corporation.
+ *     Author: Liu, Yi L <yi.l.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Derived from original vfio_pci.c:
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * Derived from original vfio:
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vgaarb.h>
+#include <linux/nospec.h>
+#include <linux/mdev.h>
+
+#include "vfio_pci_private.h"
+
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "Liu, Yi L <yi.l.liu@intel.com>"
+#define DRIVER_DESC     "VFIO Mdev PCI - Sample driver for PCI device as a mdev"
+
+#define VFIO_MDEV_PCI_NAME  "vfio-mdev-pci"
+
+static char ids[1024] __initdata;
+module_param_string(ids, ids, sizeof(ids), 0);
+MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio-mdev-pci driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
+
+static bool nointxmask;
+module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(nointxmask,
+		  "Disable support for PCI 2.3 style INTx masking.  If this resolves problems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel.org so the device can be fixed automatically via the broken_intx_masking flag.");
+
+#ifdef CONFIG_VFIO_PCI_VGA
+static bool disable_vga;
+module_param(disable_vga, bool, S_IRUGO);
+MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-mdev-pci");
+#endif
+
+static bool disable_idle_d3;
+module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(disable_idle_d3,
+		 "Disable using the PCI D3 low power state for idle, unused devices");
+
+static struct pci_driver vfio_mdev_pci_driver;
+
+static ssize_t
+name_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	return sprintf(buf, "%s-type1\n", dev_name(dev));
+}
+
+MDEV_TYPE_ATTR_RO(name);
+
+static ssize_t
+available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	return sprintf(buf, "%d\n", 1);
+}
+
+MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
+		char *buf)
+{
+	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
+}
+
+MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *vfio_mdev_pci_types_attrs[] = {
+	&mdev_type_attr_name.attr,
+	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_available_instances.attr,
+	NULL,
+};
+
+static struct attribute_group vfio_mdev_pci_type_group1 = {
+	.name  = "type1",
+	.attrs = vfio_mdev_pci_types_attrs,
+};
+
+struct attribute_group *vfio_mdev_pci_type_groups[] = {
+	&vfio_mdev_pci_type_group1,
+	NULL,
+};
+
+struct vfio_mdev_pci {
+	struct vfio_pci_device *vdev;
+	struct mdev_device *mdev;
+	unsigned long handle;
+};
+
+static int vfio_mdev_pci_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+	struct device *pdev;
+	struct vfio_pci_device *vdev;
+	struct vfio_mdev_pci *pmdev;
+	int ret;
+
+	pdev = mdev_parent_dev(mdev);
+	vdev = dev_get_drvdata(pdev);
+	pmdev = kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
+	if (pmdev == NULL) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	pmdev->mdev = mdev;
+	pmdev->vdev = vdev;
+	mdev_set_drvdata(mdev, pmdev);
+	ret = mdev_set_iommu_device(mdev_dev(mdev), pdev);
+	if (ret) {
+		pr_info("%s, failed to config iommu isolation for mdev: %s on pf: %s\n",
+			__func__, dev_name(mdev_dev(mdev)), dev_name(pdev));
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static int vfio_mdev_pci_remove(struct mdev_device *mdev)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	kfree(pmdev);
+	pr_info("%s, succeeded for mdev: %s\n", __func__,
+		     dev_name(mdev_dev(mdev)));
+
+	return 0;
+}
+
+static int vfio_mdev_pci_open(struct mdev_device *mdev)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+	struct vfio_pci_device *vdev = pmdev->vdev;
+	int ret = 0;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	mutex_lock(&vdev->reflck->lock);
+
+	if (!vdev->refcnt) {
+		ret = vfio_pci_enable(vdev);
+		if (ret)
+			goto error;
+
+		vfio_spapr_pci_eeh_open(vdev->pdev);
+	}
+	vdev->refcnt++;
+error:
+	mutex_unlock(&vdev->reflck->lock);
+	if (!ret)
+		pr_info("Succeeded to open mdev: %s on pf: %s\n",
+		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
+	else {
+		pr_info("Failed to open mdev: %s on pf: %s\n",
+		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
+		module_put(THIS_MODULE);
+	}
+	return ret;
+}
+
+static void vfio_mdev_pci_release(struct mdev_device *mdev)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+	struct vfio_pci_device *vdev = pmdev->vdev;
+
+	pr_info("Release mdev: %s on pf: %s\n",
+		dev_name(mdev_dev(mdev)), dev_name(&pmdev->vdev->pdev->dev));
+
+	mutex_lock(&vdev->reflck->lock);
+
+	if (!(--vdev->refcnt)) {
+		vfio_spapr_pci_eeh_release(vdev->pdev);
+		vfio_pci_disable(vdev);
+	}
+
+	mutex_unlock(&vdev->reflck->lock);
+
+	module_put(THIS_MODULE);
+}
+
+static long vfio_mdev_pci_ioctl(struct mdev_device *mdev, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_ioctl(pmdev->vdev, cmd, arg);
+}
+
+static int vfio_mdev_pci_mmap(struct mdev_device *mdev,
+				struct vm_area_struct *vma)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_mmap(pmdev->vdev, vma);
+}
+
+static ssize_t vfio_mdev_pci_read(struct mdev_device *mdev, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_read(pmdev->vdev, buf, count, ppos);
+}
+
+static ssize_t vfio_mdev_pci_write(struct mdev_device *mdev,
+				const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct vfio_mdev_pci *pmdev = mdev_get_drvdata(mdev);
+
+	return vfio_pci_write(pmdev->vdev, (char __user *)buf, count, ppos);
+}
+
+static const struct mdev_parent_ops vfio_mdev_pci_ops = {
+	.supported_type_groups	= vfio_mdev_pci_type_groups,
+	.create			= vfio_mdev_pci_create,
+	.remove			= vfio_mdev_pci_remove,
+
+	.open			= vfio_mdev_pci_open,
+	.release		= vfio_mdev_pci_release,
+
+	.read			= vfio_mdev_pci_read,
+	.write			= vfio_mdev_pci_write,
+	.mmap			= vfio_mdev_pci_mmap,
+	.ioctl			= vfio_mdev_pci_ioctl,
+};
+
+static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
+				       const struct pci_device_id *id)
+{
+	struct vfio_pci_device *vdev;
+	int ret;
+
+	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
+		return -EINVAL;
+
+	/*
+	 * Prevent binding to PFs with VFs enabled, this too easily allows
+	 * userspace instance with VFs and PFs from the same device, which
+	 * cannot work.  Disabling SR-IOV here would initiate removing the
+	 * VFs, which would unbind the driver, which is prone to blocking
+	 * if that VF is also in use by vfio-pci or vfio-mdev-pci. Just
+	 * reject these PFs and let the user sort it out.
+	 */
+	if (pci_num_vf(pdev)) {
+		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
+		return -EBUSY;
+	}
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vdev->pdev = pdev;
+	vdev->irq_type = VFIO_PCI_NUM_IRQS;
+	mutex_init(&vdev->igate);
+	spin_lock_init(&vdev->irqlock);
+	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	vdev->nointxmask = nointxmask;
+#ifdef CONFIG_VFIO_PCI_VGA
+	vdev->disable_vga = disable_vga;
+#endif
+	vdev->disable_idle_d3 = disable_idle_d3;
+
+	pci_set_drvdata(pdev, vdev);
+
+	ret = vfio_pci_reflck_attach(vdev);
+	if (ret) {
+		pci_set_drvdata(pdev, NULL);
+		kfree(vdev);
+		return ret;
+	}
+
+	if (vfio_pci_is_vga(pdev)) {
+		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
+		vga_set_legacy_decoding(pdev,
+					vfio_pci_set_vga_decode(vdev, false));
+	}
+
+	vfio_pci_probe_power_state(vdev);
+
+	if (!vdev->disable_idle_d3) {
+		/*
+		 * pci-core sets the device power state to an unknown value at
+		 * bootup and after being removed from a driver.  The only
+		 * transition it allows from this unknown state is to D0, which
+		 * typically happens when a driver calls pci_enable_device().
+		 * We're not ready to enable the device yet, but we do want to
+		 * be able to get to D3.  Therefore first do a D0 transition
+		 * before going to D3.
+		 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
+		vfio_pci_set_power_state(vdev, PCI_D3hot);
+	}
+
+	ret = mdev_register_device(&pdev->dev, &vfio_mdev_pci_ops);
+	if (ret)
+		pr_err("Cannot register mdev for device %s\n",
+			dev_name(&pdev->dev));
+	else
+		pr_info("Wrap device %s as a mdev\n", dev_name(&pdev->dev));
+
+	return ret;
+}
+
+static void vfio_mdev_pci_driver_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_device *vdev;
+
+	vdev = pci_get_drvdata(pdev);
+	if (!vdev)
+		return;
+
+	vfio_pci_reflck_put(vdev->reflck);
+
+	kfree(vdev->region);
+	mutex_destroy(&vdev->ioeventfds_lock);
+
+	if (!disable_idle_d3)
+		vfio_pci_set_power_state(vdev, PCI_D0);
+
+	kfree(vdev->pm_save);
+
+	if (vfio_pci_is_vga(pdev)) {
+		vga_client_register(pdev, NULL, NULL, NULL);
+		vga_set_legacy_decoding(pdev,
+				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
+				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
+	}
+
+	kfree(vdev);
+}
+
+static struct pci_driver vfio_mdev_pci_driver = {
+	.name		= VFIO_MDEV_PCI_NAME,
+	.id_table	= NULL, /* only dynamic ids */
+	.probe		= vfio_mdev_pci_driver_probe,
+	.remove		= vfio_mdev_pci_driver_remove,
+	.err_handler	= &vfio_err_handlers,
+};
+
+static void __exit vfio_mdev_pci_cleanup(void)
+{
+	pci_unregister_driver(&vfio_mdev_pci_driver);
+	vfio_pci_uninit_perm_bits();
+}
+
+static int __init vfio_mdev_pci_init(void)
+{
+	int ret;
+
+	/* Allocate shared config space permision data used by all devices */
+	ret = vfio_pci_init_perm_bits();
+	if (ret)
+		return ret;
+
+	/* Register and scan for devices */
+	ret = pci_register_driver(&vfio_mdev_pci_driver);
+	if (ret)
+		goto out_driver;
+
+	vfio_pci_fill_ids(ids, &vfio_mdev_pci_driver);
+
+	return 0;
+out_driver:
+	vfio_pci_uninit_perm_bits();
+	return ret;
+}
+
+module_init(vfio_mdev_pci_init);
+module_exit(vfio_mdev_pci_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/samples/Kconfig b/samples/Kconfig
index c8dacb4..1513fef 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -169,4 +169,15 @@ config SAMPLE_VFS
 	  as mount API and statx().  Note that this is restricted to the x86
 	  arch whilst it accesses system calls that aren't yet in all arches.
 
+config SAMPLE_VFIO_MDEV_PCI
+	tristate "Sample driver for wrapping PCI device as a mdev"
+	depends on PCI && EVENTFD && VFIO_MDEV_DEVICE
+	select VFIO_VIRQFD
+	select IRQ_BYPASS_MANAGER
+	help
+	  Sample driver for wrapping a PCI device as a mdev. Once bound to
+	  this driver, device passthru should through mdev path.
+
+	  If you don't know what to do here, say N.
+
 endif # SAMPLES
-- 
2.7.4

