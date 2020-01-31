Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905AE14E70B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 03:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgAaCTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 21:19:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:35423 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbgAaCTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 21:19:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 18:19:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="262395346"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 18:19:43 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 2/9] vfio/pci: export functions in vfio_pci_ops
Date:   Thu, 30 Jan 2020 21:10:21 -0500
Message-Id: <20200131021021.27660-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131020803.27519-1-yan.y.zhao@intel.com>
References: <20200131020803.27519-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

export functions in vfio_pci_ops,
including
    vfio_pci_open,
    vfio_pci_release,
    vfio_pci_ioctl,
    vfio_pci_read,
    vfio_pci_write,
    vfio_pci_mmap,
    vfio_pci_request,

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 21 ++++++++++++++-------
 include/linux/vfio.h        | 11 +++++++++++
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 1ed6c941eadc..f72c6d80d0e9 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -466,7 +466,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
-static void vfio_pci_release(void *device_data)
+void vfio_pci_release(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 
@@ -481,8 +481,9 @@ static void vfio_pci_release(void *device_data)
 
 	module_put(THIS_MODULE);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_release);
 
-static int vfio_pci_open(void *device_data)
+int vfio_pci_open(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 	int ret = 0;
@@ -506,6 +507,7 @@ static int vfio_pci_open(void *device_data)
 		module_put(THIS_MODULE);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_open);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
@@ -691,7 +693,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(void *device_data,
+long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_device *vdev = device_data;
@@ -1146,6 +1148,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_ioctl);
 
 static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1179,7 +1182,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+ssize_t vfio_pci_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1187,8 +1190,9 @@ static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_read);
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1196,8 +1200,9 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_write);
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1258,8 +1263,9 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       req_len, vma->vm_page_prot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_mmap);
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+void vfio_pci_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1279,6 +1285,7 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 
 	mutex_unlock(&vdev->priv->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_request);
 
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index fe4a3ad0d4e7..291e25b4d850 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -202,4 +202,15 @@ struct vfio_pci_device {
 	int				irq_type;
 	struct vfio_pci_device_private *priv;
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

