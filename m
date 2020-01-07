Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E228132611
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 13:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgAGMVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 07:21:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:13867 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727814AbgAGMVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 07:21:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 04:21:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="422475991"
Received: from iov2.bj.intel.com ([10.238.145.72])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 04:21:03 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v4 01/12] vfio_pci: refine user config reference in vfio-pci module
Date:   Tue,  7 Jan 2020 20:01:38 +0800
Message-Id: <1578398509-26453-2-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds three fields in struct vfio_pci_device to pass the user
configurations of vfio-pci.ko module to some functions which could be
common in future usage. The values stored in struct vfio_pci_device will
be initiated in probe and refreshed in device open phase to allow runtime
modifications to parameters. e.g. disable_idle_d3 and nointxmask.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 37 ++++++++++++++++++++++++++-----------
 drivers/vfio/pci/vfio_pci_private.h |  8 ++++++++
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 379a02c..af507c2 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -54,10 +54,10 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
-static inline bool vfio_vga_disabled(void)
+static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
-	return disable_vga;
+	return vdev->disable_vga;
 #else
 	return true;
 #endif
@@ -78,7 +78,8 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 	unsigned char max_busnr;
 	unsigned int decodes;
 
-	if (single_vga || !vfio_vga_disabled() || pci_is_root_bus(pdev->bus))
+	if (single_vga || !vfio_vga_disabled(vdev) ||
+		pci_is_root_bus(pdev->bus))
 		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
 		       VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
 
@@ -289,7 +290,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	if (!vdev->pci_saved_state)
 		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
 
-	if (likely(!nointxmask)) {
+	if (likely(!vdev->nointxmask)) {
 		if (vfio_pci_nointx(pdev)) {
 			pci_info(pdev, "Masking broken INTx support\n");
 			vdev->nointx = true;
@@ -326,7 +327,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	} else
 		vdev->msix_bar = 0xFF;
 
-	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
+	if (!vfio_vga_disabled(vdev) && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
 
@@ -462,10 +463,17 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 	vfio_pci_try_bus_reset(vdev);
 
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
+void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
+			bool nointxmask, bool disable_idle_d3)
+{
+	vdev->nointxmask = nointxmask;
+	vdev->disable_idle_d3 = disable_idle_d3;
+}
+
 static void vfio_pci_release(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
@@ -490,6 +498,8 @@ static int vfio_pci_open(void *device_data)
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
+	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
+
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!vdev->refcnt) {
@@ -1330,6 +1340,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	vdev->nointxmask = nointxmask;
+#ifdef CONFIG_VFIO_PCI_VGA
+	vdev->disable_vga = disable_vga;
+#endif
+	vdev->disable_idle_d3 = disable_idle_d3;
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret) {
@@ -1354,7 +1369,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vfio_pci_probe_power_state(vdev);
 
-	if (!disable_idle_d3) {
+	if (!vdev->disable_idle_d3) {
 		/*
 		 * pci-core sets the device power state to an unknown value at
 		 * bootup and after being removed from a driver.  The only
@@ -1385,7 +1400,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	kfree(vdev->region);
 	mutex_destroy(&vdev->ioeventfds_lock);
 
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
 	kfree(vdev->pm_save);
@@ -1620,7 +1635,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 		if (!ret) {
 			tmp->needs_reset = false;
 
-			if (tmp != vdev && !disable_idle_d3)
+			if (tmp != vdev && !tmp->disable_idle_d3)
 				vfio_pci_set_power_state(tmp, PCI_D3hot);
 		}
 
@@ -1636,7 +1651,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(void)
+static void __init vfio_pci_fill_ids(char *ids)
 {
 	char *p, *id;
 	int rc;
@@ -1691,7 +1706,7 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
-	vfio_pci_fill_ids();
+	vfio_pci_fill_ids(ids);
 
 	return 0;
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 8a2c760..0398608 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -122,6 +122,11 @@ struct vfio_pci_device {
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+	bool			nointxmask;
+#ifdef CONFIG_VFIO_PCI_VGA
+	bool			disable_vga;
+#endif
+	bool			disable_idle_d3;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
@@ -130,6 +135,9 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
+extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
+				bool nointxmask, bool disable_idle_d3);
+
 extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
 
-- 
2.7.4

