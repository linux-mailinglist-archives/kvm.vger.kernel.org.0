Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B678158C91
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgBKKUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:20:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:22662 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728206AbgBKKUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:20:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:20:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221888307"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:20:35 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 2/9] vfio/pci: export functions in vfio_pci_ops
Date:   Tue, 11 Feb 2020 05:11:16 -0500
Message-Id: <20200211101116.20831-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

export functions in vfio_pci_ops, so they are able to be called from
outside modules and make them a kind of inherited by vfio_device_ops
provided by other modules
including
    vfio_pci_open,
    vfio_pci_release,
    vfio_pci_ioctl,
    vfio_pci_read,
    vfio_pci_write,
    vfio_pci_mmap,
    vfio_pci_request,

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 21 ++++++++++++++-------
 include/linux/vfio.h        | 11 +++++++++++
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f19e2dc498a4..02297bd3f6c2 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -468,7 +468,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
-static void vfio_pci_release(void *device_data)
+void vfio_pci_release(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
@@ -484,8 +484,9 @@ static void vfio_pci_release(void *device_data)
 
 	module_put(THIS_MODULE);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_release);
 
-static int vfio_pci_open(void *device_data)
+int vfio_pci_open(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
@@ -510,6 +511,7 @@ static int vfio_pci_open(void *device_data)
 		module_put(THIS_MODULE);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_open);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
@@ -698,7 +700,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(void *device_data,
+long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_device *vdev = device_data;
@@ -1152,6 +1154,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_ioctl);
 
 static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1186,7 +1189,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+ssize_t vfio_pci_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1194,8 +1197,9 @@ static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_read);
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1203,8 +1207,9 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_write);
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
@@ -1266,8 +1271,9 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       req_len, vma->vm_page_prot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_mmap);
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+void vfio_pci_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1288,6 +1294,7 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 
 	mutex_unlock(&priv->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_request);
 
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 70a2b8fb6179..64714cbd02f9 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -200,4 +200,15 @@ struct vfio_pci_device {
 	int				num_regions;
 	int				irq_type;
 };
+
+extern long vfio_pci_ioctl(void *device_data,
+			   unsigned int cmd, unsigned long arg);
+extern ssize_t vfio_pci_read(void *device_data, char __user *buf,
+			     size_t count, loff_t *ppos);
+extern ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+			      size_t count, loff_t *ppos);
+extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
+extern void vfio_pci_request(void *device_data, unsigned int count);
+extern int vfio_pci_open(void *device_data);
+extern void vfio_pci_release(void *device_data);
 #endif /* VFIO_H */
-- 
2.17.1

