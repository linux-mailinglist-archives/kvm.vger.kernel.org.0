Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610AA14E714
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 03:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgAaCV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 21:21:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:17541 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgAaCV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 21:21:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 18:21:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="262395768"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 18:21:56 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 6/9] vfio/pci: export vfio_pci_setup_barmap
Date:   Thu, 30 Jan 2020 21:12:39 -0500
Message-Id: <20200131021239.27886-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131020803.27519-1-yan.y.zhao@intel.com>
References: <20200131020803.27519-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows vendor driver to read/write to bars directly, which is useful
in security checking condition.
E.g. if a value is invalid, vendor driver can modify the value before
writing to hardware; if a value is valid, vendor driver calls default
vfio_pci_write().

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 26 +++++++++++++-------------
 include/linux/vfio.h             |  2 ++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index d68e860a2603..c50f2c80ede3 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -129,29 +129,30 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
+void __iomem *vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
 	void __iomem *io;
 
 	if (vdev->priv->barmap[bar])
-		return 0;
+		return vdev->priv->barmap[bar];
 
 	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
 	if (ret)
-		return ret;
+		return NULL;
 
 	io = pci_iomap(pdev, bar, 0);
 	if (!io) {
 		pci_release_selected_regions(pdev, 1 << bar);
-		return -ENOMEM;
+		return NULL;
 	}
 
 	vdev->priv->barmap[bar] = io;
 
-	return 0;
+	return io;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_setup_barmap);
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
@@ -188,11 +189,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			return -ENOMEM;
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
-		if (ret)
-			return ret;
-
-		io = vdev->priv->barmap[bar];
+		io = vfio_pci_setup_barmap(vdev, bar);
+		if (!io)
+			return -EFAULT;
 	}
 
 	if (bar == vdev->priv->msix_bar) {
@@ -305,6 +304,7 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 	loff_t pos = offset & VFIO_PCI_OFFSET_MASK;
 	int ret, bar = VFIO_PCI_OFFSET_TO_INDEX(offset);
 	struct vfio_pci_ioeventfd *ioeventfd;
+	void __iomem *io;
 
 	/* Only support ioeventfds into BARs */
 	if (bar > VFIO_PCI_BAR5_REGION_INDEX)
@@ -324,9 +324,9 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
-	if (ret)
-		return ret;
+	io = vfio_pci_setup_barmap(vdev, bar);
+	if (!io)
+		return -EFAULT;
 
 	mutex_lock(&vdev->priv->ioeventfds_lock);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4bb101ac3fff..1dcafde951ec 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -227,6 +227,8 @@ extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
 extern void vfio_pci_request(void *device_data, unsigned int count);
 extern int vfio_pci_open(void *device_data);
 extern void vfio_pci_release(void *device_data);
+extern void __iomem *vfio_pci_setup_barmap(struct vfio_pci_device *vdev,
+					   int bar);
 
 #define vfio_pci_register_vendor_driver(__name, __probe, __remove,	\
 					__device_ops)			\
-- 
2.17.1

