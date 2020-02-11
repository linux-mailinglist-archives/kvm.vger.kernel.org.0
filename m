Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9564158C9D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgBKKXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:23:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:61464 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgBKKXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:23:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:23:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221888886"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:23:40 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 6/9] vfio/pci: export vfio_pci_setup_barmap
Date:   Tue, 11 Feb 2020 05:14:19 -0500
Message-Id: <20200211101419.21067-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows vendor driver to read/write to bars directly which is useful
in security checking condition.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 26 +++++++++++++-------------
 include/linux/vfio.h             |  2 ++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a0ef1de4f74a..3ba85fb2af5b 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -129,7 +129,7 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
+void __iomem *vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
@@ -137,22 +137,23 @@ static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 	void __iomem *io;
 
 	if (priv->barmap[bar])
-		return 0;
+		return priv->barmap[bar];
 
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
 
 	priv->barmap[bar] = io;
 
-	return 0;
+	return io;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_setup_barmap);
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
@@ -190,11 +191,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			return -ENOMEM;
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
-		if (ret)
-			return ret;
-
-		io = priv->barmap[bar];
+		io = vfio_pci_setup_barmap(vdev, bar);
+		if (!io)
+			return -EFAULT;
 	}
 
 	if (bar == priv->msix_bar) {
@@ -309,6 +308,7 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 	loff_t pos = offset & VFIO_PCI_OFFSET_MASK;
 	int ret, bar = VFIO_PCI_OFFSET_TO_INDEX(offset);
 	struct vfio_pci_ioeventfd *ioeventfd;
+	void __iomem *io;
 
 	/* Only support ioeventfds into BARs */
 	if (bar > VFIO_PCI_BAR5_REGION_INDEX)
@@ -328,9 +328,9 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
-	if (ret)
-		return ret;
+	io = vfio_pci_setup_barmap(vdev, bar);
+	if (!io)
+		return -EFAULT;
 
 	mutex_lock(&priv->ioeventfds_lock);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4d7e80b2ed1b..00112ffd9ad0 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -223,6 +223,8 @@ extern int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma);
 extern void vfio_pci_request(void *device_data, unsigned int count);
 extern int vfio_pci_open(void *device_data);
 extern void vfio_pci_release(void *device_data);
+extern void __iomem *vfio_pci_setup_barmap(struct vfio_pci_device *vdev,
+					   int bar);
 
 #define vfio_pci_register_vendor_driver(__name, __probe, __remove,	\
 					__device_ops)			\
-- 
2.17.1

