Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71212158C99
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgBKKWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:22:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:44178 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgBKKWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:22:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:22:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221888644"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:22:35 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v3 5/9] vfio/pci: let vfio_pci know how many vendor regions are registered
Date:   Tue, 11 Feb 2020 05:13:16 -0500
Message-Id: <20200211101316.21008-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows a simpler VFIO_DEVICE_GET_INFO ioctl in vendor driver

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 3 ++-
 include/linux/vfio.h        | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e5bfb4948667..9e5d878f5f32 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -727,7 +727,8 @@ long vfio_pci_ioctl(void *device_data,
 		if (priv->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
+		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions +
+						vdev->num_vendor_regions;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 71a03471b208..4d7e80b2ed1b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -208,6 +208,7 @@ void vfio_pci_unregister_vendor_driver(struct vfio_device_ops *device_ops);
 struct vfio_pci_device {
 	struct pci_dev			*pdev;
 	int				num_regions;
+	int				num_vendor_regions;
 	int				irq_type;
 	void				*vendor_data;
 };
-- 
2.17.1

