Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69046132605
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 13:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgAGMV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 07:21:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:13883 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbgAGMVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 07:21:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 04:21:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="422476087"
Received: from iov2.bj.intel.com ([10.238.145.72])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 04:21:23 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v4 10/12] vfio: build vfio_pci_common.c into a kernel module
Date:   Tue,  7 Jan 2020 20:01:47 +0800
Message-Id: <1578398509-26453-11-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch makes vfio_pci_common.c to be built as a kernel module,
which is a preparation for further share vfio_pci common codes outside
drivers/vfio/pci/.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/Kconfig           |  9 ++++++--
 drivers/vfio/pci/Makefile          |  9 +++++---
 drivers/vfio/pci/vfio_pci.c        | 14 ++-----------
 drivers/vfio/pci/vfio_pci_common.c | 43 ++++++++++++++++++++++++++++++++++++--
 include/linux/vfio_pci_common.h    |  2 +-
 5 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index ac3c1dd..1a1fb3b 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,9 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
-	tristate "VFIO support for PCI devices"
+
+config VFIO_PCI_COMMON
 	depends on VFIO && PCI && EVENTFD
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
+	tristate
+
+config VFIO_PCI
+	tristate "VFIO support for PCI devices"
+	select VFIO_PCI_COMMON
 	help
 	  Support for the PCI VFIO bus driver.  This is required to make
 	  use of PCI drivers using the VFIO framework.
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index d94317a..ad60cfd 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,8 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_common.o vfio_pci_intrs.o \
+vfio-pci-common-y := vfio_pci_common.o vfio_pci_intrs.o \
 		vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
+vfio-pci-common-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-pci-common-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
 
+vfio-pci-y := vfio_pci.o
+
+obj-$(CONFIG_VFIO_PCI_COMMON) += vfio-pci-common.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7e24da2..7047667 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -225,36 +225,26 @@ static struct pci_driver vfio_pci_driver = {
 	.id_table	= NULL, /* only dynamic ids */
 	.probe		= vfio_pci_probe,
 	.remove		= vfio_pci_remove,
-	.err_handler	= &vfio_err_handlers,
+	.err_handler	= &vfio_pci_err_handlers,
 };
 
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_uninit_perm_bits();
 }
 
 static int __init vfio_pci_init(void)
 {
 	int ret;
 
-	/* Allocate shared config space permision data used by all devices */
-	ret = vfio_pci_init_perm_bits();
-	if (ret)
-		return ret;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
-		goto out_driver;
+		return ret;
 
 	vfio_pci_fill_ids(ids, &vfio_pci_driver);
 
 	return 0;
-
-out_driver:
-	vfio_pci_uninit_perm_bits();
-	return ret;
 }
 
 module_init(vfio_pci_init);
diff --git a/drivers/vfio/pci/vfio_pci_common.c b/drivers/vfio/pci/vfio_pci_common.c
index 15d8b55..edda7e4 100644
--- a/drivers/vfio/pci/vfio_pci_common.c
+++ b/drivers/vfio/pci/vfio_pci_common.c
@@ -27,9 +27,14 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
+#include <linux/vfio_pci_common.h>
 
 #include "vfio_pci_private.h"
 
+#define DRIVER_VERSION  "0.2"
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC     "VFIO PCI Common"
+
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -69,6 +74,7 @@ unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 
 	return decodes;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_set_vga_decode);
 
 static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 {
@@ -183,6 +189,7 @@ void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 
 	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_probe_power_state);
 
 /*
  * pci_set_power_state() wrapper handling devices which perform a soft reset on
@@ -221,6 +228,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_set_power_state);
 
 int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
@@ -328,6 +336,7 @@ int vfio_pci_enable(struct vfio_pci_device *vdev)
 	vfio_pci_disable(vdev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_enable);
 
 void vfio_pci_disable(struct vfio_pci_device *vdev)
 {
@@ -427,6 +436,7 @@ void vfio_pci_disable(struct vfio_pci_device *vdev)
 	if (!vdev->disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_disable);
 
 void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
 			bool nointxmask, bool disable_idle_d3)
@@ -434,6 +444,7 @@ void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
 	vdev->nointxmask = nointxmask;
 	vdev->disable_idle_d3 = disable_idle_d3;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_refresh_config);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
@@ -618,6 +629,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 long vfio_pci_ioctl(void *device_data,
 		   unsigned int cmd, unsigned long arg)
@@ -1072,6 +1084,7 @@ long vfio_pci_ioctl(void *device_data,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_ioctl);
 
 static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1113,6 +1126,7 @@ ssize_t vfio_pci_read(void *device_data, char __user *buf,
 
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_read);
 
 ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
@@ -1122,6 +1136,7 @@ ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_write);
 
 int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
@@ -1184,6 +1199,7 @@ int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       req_len, vma->vm_page_prot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_mmap);
 
 void vfio_pci_request(void *device_data, unsigned int count)
 {
@@ -1205,6 +1221,7 @@ void vfio_pci_request(void *device_data, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_request);
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
@@ -1234,9 +1251,10 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-const struct pci_error_handlers vfio_err_handlers = {
+const struct pci_error_handlers vfio_pci_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
+EXPORT_SYMBOL_GPL(vfio_pci_err_handlers);
 
 static DEFINE_MUTEX(reflck_lock);
 
@@ -1303,6 +1321,7 @@ int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 
 	return PTR_ERR_OR_ZERO(vdev->reflck);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_reflck_attach);
 
 static void vfio_pci_reflck_release(struct kref *kref)
 {
@@ -1318,6 +1337,7 @@ void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 {
 	kref_put_mutex(&reflck->kref, vfio_pci_reflck_release, &reflck_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_reflck_put);
 
 struct vfio_devices {
 	struct vfio_device **devices;
@@ -1431,7 +1451,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	kfree(devs.devices);
 }
 
-void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
+void vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
 	int rc;
@@ -1471,3 +1491,22 @@ void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 				class, class_mask);
 	}
 }
+EXPORT_SYMBOL_GPL(vfio_pci_fill_ids);
+
+static int __init vfio_pci_common_init(void)
+{
+	/* Allocate shared config space permision data used by all devices */
+	return vfio_pci_init_perm_bits();
+}
+module_init(vfio_pci_common_init);
+
+static void __exit vfio_pci_common_exit(void)
+{
+	vfio_pci_uninit_perm_bits();
+}
+module_exit(vfio_pci_common_exit);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/vfio_pci_common.h b/include/linux/vfio_pci_common.h
index 862cd80..439666a 100644
--- a/include/linux/vfio_pci_common.h
+++ b/include/linux/vfio_pci_common.h
@@ -109,7 +109,7 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-extern const struct pci_error_handlers vfio_err_handlers;
+extern const struct pci_error_handlers vfio_pci_err_handlers;
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
-- 
2.7.4

