Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D161D6F2C
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 04:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgERC7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 22:59:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:18921 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgERC7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 22:59:04 -0400
IronPort-SDR: LNprU+NXPqN3d4PfX2SWfRpNy/iTG2wxSvoTwmuQrqN7Diy3suZWGKzyniS75aXDFD8jtoELuQ
 qRE6cHYngJWg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 19:59:00 -0700
IronPort-SDR: kqg+56nQW5C1KiOo1+hxJMBYyeF5hU/ZEj0gR+engB0MQZJ+NIoGTmxc9dmkyXjl81SYnZWg0w
 4/tdCaUCu0Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411104728"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 19:58:57 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 03/10] vfio/pci: export vendor_data, irq_type, num_regions, pdev and functions in vfio_pci_ops
Date:   Sun, 17 May 2020 22:49:05 -0400
Message-Id: <20200518024905.14207-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518024202.13996-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

export functions vfio_pci_vendor_data(), vfio_pci_irq_type(),
vfio_pci_num_regions(), vfio_pci_pdev(), and functions in vfio_pci_ops,
so they are able to be called from outside modules and make them a kind of
inherited by vfio_device_ops provided by vendor modules

Cc: Kevin Tian <kevin.tian@intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 56 +++++++++++++++++++++++++++++++------
 include/linux/vfio.h        | 18 ++++++++++++
 2 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 43d10d34cbc2..290b7ab55ecf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -73,6 +73,38 @@ static struct vfio_pci {
 	struct  list_head	vendor_drivers_list;
 } vfio_pci;
 
+struct pci_dev *vfio_pci_pdev(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vdev->pdev;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_pdev);
+
+int vfio_pci_num_regions(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vdev->num_regions;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_num_regions);
+
+int vfio_pci_irq_type(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vdev->irq_type;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_irq_type);
+
+void *vfio_pci_vendor_data(void *device_data)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return vdev->vendor_data;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_vendor_data);
+
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -514,7 +546,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
 	vfio_device_put(pf_dev);
 }
 
-static void vfio_pci_release(void *device_data)
+void vfio_pci_release(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 
@@ -530,8 +562,9 @@ static void vfio_pci_release(void *device_data)
 
 	module_put(THIS_MODULE);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_release);
 
-static int vfio_pci_open(void *device_data)
+int vfio_pci_open(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 	int ret = 0;
@@ -556,6 +589,7 @@ static int vfio_pci_open(void *device_data)
 		module_put(THIS_MODULE);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_open);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
@@ -741,7 +775,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(void *device_data,
+long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_device *vdev = device_data;
@@ -1253,6 +1287,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_ioctl);
 
 static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1286,7 +1321,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+ssize_t vfio_pci_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1294,8 +1329,9 @@ static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_read);
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	if (!count)
@@ -1303,8 +1339,9 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_write);
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1365,8 +1402,9 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       req_len, vma->vm_page_prot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_mmap);
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+void vfio_pci_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
@@ -1386,6 +1424,7 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_request);
 
 static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 				      bool vf_token, uuid_t *uuid)
@@ -1482,7 +1521,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(void *device_data, char *buf)
+int vfio_pci_match(void *device_data, char *buf)
 {
 	struct vfio_pci_device *vdev = device_data;
 	bool vf_token = false;
@@ -1530,6 +1569,7 @@ static int vfio_pci_match(void *device_data, char *buf)
 
 	return 1; /* Match */
 }
+EXPORT_SYMBOL_GPL(vfio_pci_match);
 
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f3746608c2d9..6ededceb1964 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -214,6 +214,24 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+extern int vfio_pci_irq_type(void *device_data);
+extern int vfio_pci_num_regions(void *device_data);
+extern struct pci_dev *vfio_pci_pdev(void *device_data);
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
+extern int vfio_pci_match(void *device_data, char *buf);
+
+extern void *vfio_pci_vendor_data(void *device_data);
+
 struct vfio_pci_vendor_driver_ops {
 	char			*name;
 	struct module		*owner;
-- 
2.17.1

