Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AFE1D6F2F
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 04:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgERC7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 22:59:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:4477 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgERC7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 22:59:42 -0400
IronPort-SDR: yjkIprTiIpcMw+Ln4BjgRYBUtvfsRx5iC/RJ1DCz3Dy/DPqenC5/Y78w7Y/+RmWDrT+zMLVpTn
 WFu5gSdbzwMw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 19:59:41 -0700
IronPort-SDR: CLkgpeC95vYKERnqRDBQB3CrlTou/Ki0yED5Gr1dbfqcwXDseZQ8ySd7LVctblNGcSQVVZKt2l
 KM06JQHYVDuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411104839"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 19:59:38 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 04/10] vfio/pci: let vfio_pci know number of vendor regions and vendor irqs
Date:   Sun, 17 May 2020 22:49:44 -0400
Message-Id: <20200518024944.14263-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518024202.13996-1-yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows a simpler VFIO_DEVICE_GET_INFO ioctl in vendor driver

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c         | 23 +++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_private.h |  2 ++
 include/linux/vfio.h                |  3 +++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 290b7ab55ecf..30137c1c5308 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -105,6 +105,24 @@ void *vfio_pci_vendor_data(void *device_data)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_vendor_data);
 
+int vfio_pci_set_vendor_regions(void *device_data, int num_vendor_regions)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	vdev->num_vendor_regions = num_vendor_regions;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_set_vendor_regions);
+
+
+int vfio_pci_set_vendor_irqs(void *device_data, int num_vendor_irqs)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	vdev->num_vendor_irqs = num_vendor_irqs;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_set_vendor_irqs);
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -797,8 +815,9 @@ long vfio_pci_ioctl(void *device_data,
 		if (vdev->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
-		info.num_irqs = VFIO_PCI_NUM_IRQS;
+		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions +
+						vdev->num_vendor_regions;
+		info.num_irqs = VFIO_PCI_NUM_IRQS + vdev->num_vendor_irqs;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 7758a20546fa..c6cfc4605987 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -110,6 +110,8 @@ struct vfio_pci_device {
 	int			num_ctx;
 	int			irq_type;
 	int			num_regions;
+	int			num_vendor_regions;
+	int			num_vendor_irqs;
 	struct vfio_pci_region	*region;
 	u8			msi_qmax;
 	u8			msix_bar;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 6ededceb1964..6310c53f9d36 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -231,6 +231,9 @@ extern void vfio_pci_release(void *device_data);
 extern int vfio_pci_match(void *device_data, char *buf);
 
 extern void *vfio_pci_vendor_data(void *device_data);
+extern int vfio_pci_set_vendor_regions(void *device_data,
+				       int num_vendor_regions);
+extern int vfio_pci_set_vendor_irqs(void *device_data, int num_vendor_irqs);
 
 struct vfio_pci_vendor_driver_ops {
 	char			*name;
-- 
2.17.1

