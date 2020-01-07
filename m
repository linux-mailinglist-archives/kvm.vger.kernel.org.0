Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776921325FA
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 13:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgAGMVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 07:21:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:13867 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgAGMVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 07:21:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 04:21:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="422476016"
Received: from iov2.bj.intel.com ([10.238.145.72])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 04:21:09 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v4 04/12] vfio_pci: make common functions be extern
Date:   Tue,  7 Jan 2020 20:01:41 +0800
Message-Id: <1578398509-26453-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch makes the common functions (module agnostic functions) in
vfio_pci.c to be extern. So that such functions could be moved to a
common source file.

*) vfio_pci_set_vga_decode
*) vfio_pci_probe_power_state
*) vfio_pci_set_power_state
*) vfio_pci_enable
*) vfio_pci_disable
*) vfio_pci_refresh_config
*) vfio_pci_register_dev_region
*) vfio_pci_ioctl
*) vfio_pci_read
*) vfio_pci_write
*) vfio_pci_mmap
*) vfio_pci_request
*) vfio_pci_err_handlers
*) vfio_pci_reflck_attach
*) vfio_pci_reflck_put
*) vfio_pci_fill_ids

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 30 +++++++++++++-----------------
 drivers/vfio/pci/vfio_pci_private.h | 15 +++++++++++++++
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9140f5e5..103e493 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(disable_idle_d3,
  * has no way to get to it and routing can be disabled externally at the
  * bridge.
  */
-static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
+unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 {
 	struct vfio_pci_device *vdev = opaque;
 	struct pci_dev *tmp = NULL, *pdev = vdev->pdev;
@@ -165,7 +165,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 }
 
 static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
-static void vfio_pci_disable(struct vfio_pci_device *vdev);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -196,7 +195,7 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 	return false;
 }
 
-static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
+void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u16 pmcsr;
@@ -247,7 +246,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_device *vdev)
+int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -354,7 +353,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static void vfio_pci_disable(struct vfio_pci_device *vdev)
+void vfio_pci_disable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
@@ -687,8 +686,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(void *device_data,
-			   unsigned int cmd, unsigned long arg)
+long vfio_pci_ioctl(void *device_data,
+		   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_device *vdev = device_data;
 	unsigned long minsz;
@@ -1173,7 +1172,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+ssize_t vfio_pci_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1182,7 +1181,7 @@ static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1191,7 +1190,7 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1253,7 +1252,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 			       req_len, vma->vm_page_prot);
 }
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+void vfio_pci_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1285,9 +1284,6 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.request	= vfio_pci_request,
 };
 
-static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
-static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
-
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
@@ -1490,7 +1486,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
+int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 {
 	bool slot = !pci_probe_reset_slot(vdev->pdev->slot);
 
@@ -1516,7 +1512,7 @@ static void vfio_pci_reflck_release(struct kref *kref)
 	mutex_unlock(&reflck_lock);
 }
 
-static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
+void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 {
 	kref_put_mutex(&reflck->kref, vfio_pci_reflck_release, &reflck_lock);
 }
@@ -1639,7 +1635,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
+void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
 	int rc;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 9263021..194d487 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -185,6 +185,21 @@ extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 
 extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
 				    pci_power_t state);
+extern unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga);
+extern int vfio_pci_enable(struct vfio_pci_device *vdev);
+extern void vfio_pci_disable(struct vfio_pci_device *vdev);
+extern long vfio_pci_ioctl(void *device_data,
+			unsigned int cmd, unsigned long arg);
+extern ssize_t vfio_pci_read(void *device_data, char __user *buf,
+			size_t count, loff_t *ppos);
+extern ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+			size_t count, loff_t *ppos);
+extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
+extern void vfio_pci_request(void *device_data, unsigned int count);
+extern void vfio_pci_fill_ids(char *ids, struct pci_driver *driver);
+extern int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
+extern void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
+extern void vfio_pci_probe_power_state(struct vfio_pci_device *vdev);
 
 #ifdef CONFIG_VFIO_PCI_IGD
 extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
-- 
2.7.4

