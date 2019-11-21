Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3937410719B
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKVLmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:42:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:15269 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbfKVLmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 06:42:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 03:42:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,229,1571727600"; 
   d="scan'208";a="358110491"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2019 03:42:14 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, jean-philippe.brucker@arm.com,
        peterx@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 04/10] vfio_pci: make common functions be extern
Date:   Thu, 21 Nov 2019 19:23:41 +0800
Message-Id: <1574335427-3763-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch makes the common functions (module agnostic functions) in
vfio_pci.c to extern. So that such functions could be moved to a common
source file.
  *) vfio_pci_set_vga_decode
  *) vfio_pci_enable
  *) vfio_pci_disable
  *) vfio_pci_ioctl
  *) vfio_pci_read
  *) vfio_pci_write
  *) vfio_pci_mmap
  *) vfio_pci_request
  *) vfio_pci_fill_ids
  *) vfio_pci_reflck_attach
  *) vfio_pci_reflck_put
  *) vfio_pci_probe_power_state

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 30 +++++++++++++-----------------
 drivers/vfio/pci/vfio_pci_private.h | 15 +++++++++++++++
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2096e66..80a6b15 100644
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
@@ -163,7 +163,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 }
 
 static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
-static void vfio_pci_disable(struct vfio_pci_device *vdev);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -194,7 +193,7 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 	return false;
 }
 
-static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
+void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u16 pmcsr;
@@ -245,7 +244,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_device *vdev)
+int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -352,7 +351,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static void vfio_pci_disable(struct vfio_pci_device *vdev)
+void vfio_pci_disable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
@@ -684,8 +683,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(void *device_data,
-			   unsigned int cmd, unsigned long arg)
+long vfio_pci_ioctl(void *device_data,
+		   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_device *vdev = device_data;
 	unsigned long minsz;
@@ -1170,7 +1169,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+ssize_t vfio_pci_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1179,7 +1178,7 @@ static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1188,7 +1187,7 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1250,7 +1249,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 			       req_len, vma->vm_page_prot);
 }
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+void vfio_pci_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1282,9 +1281,6 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.request	= vfio_pci_request,
 };
 
-static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
-static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
-
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
@@ -1487,7 +1483,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
+int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 {
 	bool slot = !pci_probe_reset_slot(vdev->pdev->slot);
 
@@ -1513,7 +1509,7 @@ static void vfio_pci_reflck_release(struct kref *kref)
 	mutex_unlock(&reflck_lock);
 }
 
-static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
+void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 {
 	kref_put_mutex(&reflck->kref, vfio_pci_reflck_release, &reflck_lock);
 }
@@ -1637,7 +1633,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
+void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
 	int rc;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index eae8d94..670268e 100644
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

