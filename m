Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E87B14E712
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 03:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgAaCVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 21:21:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:9308 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgAaCVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 21:21:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 18:21:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="262395692"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 18:21:30 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 5/9] vfio/pci: let vfio_pci know how many vendor regions are registered
Date:   Thu, 30 Jan 2020 21:12:04 -0500
Message-Id: <20200131021204.27830-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131020803.27519-1-yan.y.zhao@intel.com>
References: <20200131020803.27519-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows a simpler VFIO_DEVICE_GET_INFO ioctl in vendor driver

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 3 ++-
 include/linux/vfio.h        | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 1a08b7cc9246..7530cceaeaa5 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -719,7 +719,8 @@ long vfio_pci_ioctl(void *device_data,
 		if (vdev->priv->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
+		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions +
+						vdev->num_vendor_regions;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 386d1b19da3d..4bb101ac3fff 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -210,6 +210,7 @@ struct vfio_pci_device_private;
 struct vfio_pci_device {
 	struct pci_dev			*pdev;
 	int				num_regions;
+	int				num_vendor_regions;
 	int				irq_type;
 	struct vfio_pci_device_private *priv;
 	struct vfio_pci_vendor_driver	*vendor_driver;
-- 
2.17.1

