Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FAA1325F8
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 13:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgAGMVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 07:21:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:13867 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbgAGMVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 07:21:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 04:21:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="422475999"
Received: from iov2.bj.intel.com ([10.238.145.72])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 04:21:05 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v4 02/12] vfio_pci: move vfio_pci_is_vga/vfio_vga_disabled to header file
Date:   Tue,  7 Jan 2020 20:01:39 +0800
Message-Id: <1578398509-26453-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch moves two inline functions to vfio_pci_private.h for further
sharing across source files. Also avoids below compiling error in further
code split.

"error: inlining failed in call to always_inline ‘vfio_pci_is_vga’:
function body not available".

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 14 --------------
 drivers/vfio/pci/vfio_pci_private.h | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index af507c2..009d2df 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -54,15 +54,6 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
-static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
-{
-#ifdef CONFIG_VFIO_PCI_VGA
-	return vdev->disable_vga;
-#else
-	return true;
-#endif
-}
-
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -103,11 +94,6 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 	return decodes;
 }
 
-static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
-{
-	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-}
-
 static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 {
 	struct resource *res;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 0398608..9263021 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -135,6 +135,20 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
+static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
+{
+	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
+}
+
+static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
+{
+#ifdef CONFIG_VFIO_PCI_VGA
+	return vdev->disable_vga;
+#else
+	return true;
+#endif
+}
+
 extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
 				bool nointxmask, bool disable_idle_d3);
 
-- 
2.7.4

