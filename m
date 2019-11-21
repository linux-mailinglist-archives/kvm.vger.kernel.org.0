Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84CA1071A5
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfKVLmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:42:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:15269 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbfKVLmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 06:42:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 03:42:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,229,1571727600"; 
   d="scan'208";a="358110481"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2019 03:42:08 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, jean-philippe.brucker@arm.com,
        peterx@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 02/10] vfio_pci: refine user config reference in vfio-pci module
Date:   Thu, 21 Nov 2019 19:23:39 +0800
Message-Id: <1574335427-3763-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds three fields in struct vfio_pci_device to pass the user
configs of vfio-pci module to some functions which could be common in
future usage.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 33 ++++++++++++++++++++++++---------
 drivers/vfio/pci/vfio_pci_private.h | 12 ++++++++++--
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 79460c3..b04e43a 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -69,7 +69,8 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 	unsigned char max_busnr;
 	unsigned int decodes;
 
-	if (single_vga || !vfio_vga_disabled() || pci_is_root_bus(pdev->bus))
+	if (single_vga || !vfio_vga_disabled(vdev) ||
+		pci_is_root_bus(pdev->bus))
 		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
 		       VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
 
@@ -273,7 +274,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	if (!vdev->pci_saved_state)
 		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
 
-	if (likely(!nointxmask)) {
+	if (likely(!vdev->nointxmask)) {
 		if (vfio_pci_nointx(pdev)) {
 			pci_info(pdev, "Masking broken INTx support\n");
 			vdev->nointx = true;
@@ -310,7 +311,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	} else
 		vdev->msix_bar = 0xFF;
 
-	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
+	if (!vfio_vga_disabled(vdev) && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
 
@@ -445,10 +446,17 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
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
@@ -473,6 +481,8 @@ static int vfio_pci_open(void *device_data)
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
+	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
+
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!vdev->refcnt) {
@@ -1313,6 +1323,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1337,7 +1352,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vfio_pci_probe_power_state(vdev);
 
-	if (!disable_idle_d3) {
+	if (!vdev->disable_idle_d3) {
 		/*
 		 * pci-core sets the device power state to an unknown value at
 		 * bootup and after being removed from a driver.  The only
@@ -1368,7 +1383,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	kfree(vdev->region);
 	mutex_destroy(&vdev->ioeventfds_lock);
 
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
 	kfree(vdev->pm_save);
@@ -1603,7 +1618,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 		if (!ret) {
 			tmp->needs_reset = false;
 
-			if (tmp != vdev && !disable_idle_d3)
+			if (tmp != vdev && !tmp->disable_idle_d3)
 				vfio_pci_set_power_state(tmp, PCI_D3hot);
 		}
 
@@ -1619,7 +1634,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(void)
+static void __init vfio_pci_fill_ids(char *ids)
 {
 	char *p, *id;
 	int rc;
@@ -1674,7 +1689,7 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
-	vfio_pci_fill_ids();
+	vfio_pci_fill_ids(ids);
 
 	return 0;
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index f12d92c..eae8d94 100644
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
@@ -135,15 +140,18 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
-static inline bool vfio_vga_disabled(void)
+static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
-	return disable_vga;
+	return vdev->disable_vga;
 #else
 	return true;
 #endif
 }
 
+extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
+				bool nointxmask, bool disable_idle_d3);
+
 extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
 
-- 
2.7.4

