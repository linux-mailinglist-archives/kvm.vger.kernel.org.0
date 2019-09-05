Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42BAB3E0
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391294AbfIFIRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:17:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:23720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391182AbfIFIRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:17:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:17:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="383186156"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 01:17:35 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yan.y.zhao@intel.com, shaopeng.he@intel.com,
        chenbo.xia@intel.com, jun.j.tian@intel.com
Subject: [PATCH v2 06/13] vfio_pci: shrink vfio_pci_common.c
Date:   Thu,  5 Sep 2019 15:59:23 +0800
Message-Id: <1567670370-4484-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch removes the vfio-pci module specific codes in vfio_pci_common.c
to make vfio_pci_common.c be a common source file.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_common.c | 233 -------------------------------------
 1 file changed, 233 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_common.c b/drivers/vfio/pci/vfio_pci_common.c
index 90a44a7..11365f1 100644
--- a/drivers/vfio/pci/vfio_pci_common.c
+++ b/drivers/vfio/pci/vfio_pci_common.c
@@ -30,30 +30,6 @@
 
 #include "vfio_pci_private.h"
 
-#define DRIVER_VERSION  "0.2"
-#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
-#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
-
-static char ids[1024] __initdata;
-module_param_string(ids, ids, sizeof(ids), 0);
-MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
-
-static bool nointxmask;
-module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(nointxmask,
-		  "Disable support for PCI 2.3 style INTx masking.  If this resolves problems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel.org so the device can be fixed automatically via the broken_intx_masking flag.");
-
-#ifdef CONFIG_VFIO_PCI_VGA
-static bool disable_vga;
-module_param(disable_vga, bool, S_IRUGO);
-MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-pci");
-#endif
-
-static bool disable_idle_d3;
-module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(disable_idle_d3,
-		 "Disable using the PCI D3 low power state for idle, unused devices");
-
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -440,47 +416,6 @@ void vfio_pci_disable(struct vfio_pci_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
-static void vfio_pci_release(void *device_data)
-{
-	struct vfio_pci_device *vdev = device_data;
-
-	mutex_lock(&vdev->reflck->lock);
-
-	if (!(--vdev->refcnt)) {
-		vfio_spapr_pci_eeh_release(vdev->pdev);
-		vfio_pci_disable(vdev);
-	}
-
-	mutex_unlock(&vdev->reflck->lock);
-
-	module_put(THIS_MODULE);
-}
-
-static int vfio_pci_open(void *device_data)
-{
-	struct vfio_pci_device *vdev = device_data;
-	int ret = 0;
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
-	mutex_lock(&vdev->reflck->lock);
-
-	if (!vdev->refcnt) {
-		ret = vfio_pci_enable(vdev);
-		if (ret)
-			goto error;
-
-		vfio_spapr_pci_eeh_open(vdev->pdev);
-	}
-	vdev->refcnt++;
-error:
-	mutex_unlock(&vdev->reflck->lock);
-	if (ret)
-		module_put(THIS_MODULE);
-	return ret;
-}
-
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
@@ -1252,129 +1187,6 @@ void vfio_pci_request(void *device_data, unsigned int count)
 	mutex_unlock(&vdev->igate);
 }
 
-static const struct vfio_device_ops vfio_pci_ops = {
-	.name		= "vfio-pci",
-	.open		= vfio_pci_open,
-	.release	= vfio_pci_release,
-	.ioctl		= vfio_pci_ioctl,
-	.read		= vfio_pci_read,
-	.write		= vfio_pci_write,
-	.mmap		= vfio_pci_mmap,
-	.request	= vfio_pci_request,
-};
-
-static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	struct vfio_pci_device *vdev;
-	struct iommu_group *group;
-	int ret;
-
-	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
-		return -EINVAL;
-
-	/*
-	 * Prevent binding to PFs with VFs enabled, this too easily allows
-	 * userspace instance with VFs and PFs from the same device, which
-	 * cannot work.  Disabling SR-IOV here would initiate removing the
-	 * VFs, which would unbind the driver, which is prone to blocking
-	 * if that VF is also in use by vfio-pci.  Just reject these PFs
-	 * and let the user sort it out.
-	 */
-	if (pci_num_vf(pdev)) {
-		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
-		return -EBUSY;
-	}
-
-	group = vfio_iommu_group_get(&pdev->dev);
-	if (!group)
-		return -EINVAL;
-
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		vfio_iommu_group_put(group, &pdev->dev);
-		return -ENOMEM;
-	}
-
-	vdev->pdev = pdev;
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	mutex_init(&vdev->igate);
-	spin_lock_init(&vdev->irqlock);
-	mutex_init(&vdev->ioeventfds_lock);
-	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	vdev->nointxmask = nointxmask;
-#ifdef CONFIG_VFIO_PCI_VGA
-	vdev->disable_vga = disable_vga;
-#endif
-	vdev->disable_idle_d3 = disable_idle_d3;
-
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
-	if (ret) {
-		vfio_iommu_group_put(group, &pdev->dev);
-		kfree(vdev);
-		return ret;
-	}
-
-	ret = vfio_pci_reflck_attach(vdev);
-	if (ret) {
-		vfio_del_group_dev(&pdev->dev);
-		vfio_iommu_group_put(group, &pdev->dev);
-		kfree(vdev);
-		return ret;
-	}
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
-		vga_set_legacy_decoding(pdev,
-					vfio_pci_set_vga_decode(vdev, false));
-	}
-
-	vfio_pci_probe_power_state(vdev);
-
-	if (!vdev->disable_idle_d3) {
-		/*
-		 * pci-core sets the device power state to an unknown value at
-		 * bootup and after being removed from a driver.  The only
-		 * transition it allows from this unknown state is to D0, which
-		 * typically happens when a driver calls pci_enable_device().
-		 * We're not ready to enable the device yet, but we do want to
-		 * be able to get to D3.  Therefore first do a D0 transition
-		 * before going to D3.
-		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
-	}
-
-	return ret;
-}
-
-static void vfio_pci_remove(struct pci_dev *pdev)
-{
-	struct vfio_pci_device *vdev;
-
-	vdev = vfio_del_group_dev(&pdev->dev);
-	if (!vdev)
-		return;
-
-	vfio_pci_reflck_put(vdev->reflck);
-
-	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
-	kfree(vdev->region);
-	mutex_destroy(&vdev->ioeventfds_lock);
-
-	if (!vdev->disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D0);
-
-	kfree(vdev->pm_save);
-	kfree(vdev);
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, NULL, NULL, NULL);
-		vga_set_legacy_decoding(pdev,
-				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
-				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
-	}
-}
-
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
 {
@@ -1407,14 +1219,6 @@ static const struct pci_error_handlers vfio_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
 
-static struct pci_driver vfio_pci_driver = {
-	.name		= "vfio-pci",
-	.id_table	= NULL, /* only dynamic ids */
-	.probe		= vfio_pci_probe,
-	.remove		= vfio_pci_remove,
-	.err_handler	= &vfio_err_handlers,
-};
-
 static DEFINE_MUTEX(reflck_lock);
 
 static struct vfio_pci_reflck *vfio_pci_reflck_alloc(void)
@@ -1609,12 +1413,6 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	kfree(devs.devices);
 }
 
-static void __exit vfio_pci_cleanup(void)
-{
-	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_uninit_perm_bits();
-}
-
 void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
@@ -1655,34 +1453,3 @@ void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 				class, class_mask);
 	}
 }
-
-static int __init vfio_pci_init(void)
-{
-	int ret;
-
-	/* Allocate shared config space permision data used by all devices */
-	ret = vfio_pci_init_perm_bits();
-	if (ret)
-		return ret;
-
-	/* Register and scan for devices */
-	ret = pci_register_driver(&vfio_pci_driver);
-	if (ret)
-		goto out_driver;
-
-	vfio_pci_fill_ids(&ids[0], &vfio_pci_driver);
-
-	return 0;
-
-out_driver:
-	vfio_pci_uninit_perm_bits();
-	return ret;
-}
-
-module_init(vfio_pci_init);
-module_exit(vfio_pci_cleanup);
-
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-- 
2.7.4

