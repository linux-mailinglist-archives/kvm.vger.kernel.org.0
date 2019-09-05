Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162BDAB3D7
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390318AbfIFIR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:17:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:23720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389928AbfIFIR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:17:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:17:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="383186125"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 01:17:24 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yan.y.zhao@intel.com, shaopeng.he@intel.com,
        chenbo.xia@intel.com, jun.j.tian@intel.com
Subject: [PATCH v2 02/13] vfio_pci: refine user config reference in vfio-pci module
Date:   Thu,  5 Sep 2019 15:59:19 +0800
Message-Id: <1567670370-4484-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
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
 drivers/vfio/pci/vfio_pci.c         | 24 +++++++++++++++---------
 drivers/vfio/pci/vfio_pci_private.h |  9 +++++++--
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 38271df..fed2687 100644
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
 
 
@@ -436,7 +437,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 	vfio_pci_try_bus_reset(vdev);
 
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
@@ -1304,6 +1305,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1328,7 +1334,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vfio_pci_probe_power_state(vdev);
 
-	if (!disable_idle_d3) {
+	if (!vdev->disable_idle_d3) {
 		/*
 		 * pci-core sets the device power state to an unknown value at
 		 * bootup and after being removed from a driver.  The only
@@ -1359,7 +1365,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	kfree(vdev->region);
 	mutex_destroy(&vdev->ioeventfds_lock);
 
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
 	kfree(vdev->pm_save);
@@ -1594,7 +1600,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 		if (!ret) {
 			tmp->needs_reset = false;
 
-			if (tmp != vdev && !disable_idle_d3)
+			if (tmp != vdev && !tmp->disable_idle_d3)
 				vfio_pci_set_power_state(tmp, PCI_D3hot);
 		}
 
@@ -1610,7 +1616,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(void)
+static void __init vfio_pci_fill_ids(char *ids)
 {
 	char *p, *id;
 	int rc;
@@ -1665,7 +1671,7 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
-	vfio_pci_fill_ids();
+	vfio_pci_fill_ids(&ids[0]);
 
 	return 0;
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index f12d92c..68521d2 100644
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
@@ -135,10 +140,10 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
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
-- 
2.7.4

