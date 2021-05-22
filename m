Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBE838D274
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhEVAWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:22:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:2546 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231255AbhEVAWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:22:03 -0400
IronPort-SDR: fi+7dYaKZ4qTU+zU6svarIEbKrVvALqgplV+G+x3nJiOpBONuBrkXpm0LuLN1HD6S7zqXHl60Y
 75peFwzruLlA==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="188728167"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="188728167"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:39 -0700
IronPort-SDR: R6Ld8Jeh1YpVrBnCKtCCt9ZDuxVeJi+rAaPlJpE++vFtUQSWxurWeNvBCu1bU2JZIEwuG6LBjf
 SME2dqgGOKIA==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="628864663"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:38 -0700
Subject: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:37 -0700
Message-ID: <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add setup code for the IMS domain. This feeds the MSI subsystem the
relevant information for device IMS. The allocation of the IMS vectors are
done in common VFIO code if the correct domain set for the
mdev device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/idxd.h       |    1 +
 drivers/dma/idxd/init.c       |   14 ++++++++++++++
 drivers/vfio/mdev/idxd/mdev.c |    2 ++
 3 files changed, 17 insertions(+)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 0d9e2710fc76..81c78add74dd 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -297,6 +297,7 @@ struct idxd_device {
 	struct workqueue_struct *wq;
 	struct work_struct work;
 
+	struct irq_domain *ims_domain;
 	int *int_handles;
 
 	struct idxd_pmu *idxd_pmu;
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 809ca1827772..ead46761b23e 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -16,6 +16,8 @@
 #include <linux/idr.h>
 #include <linux/intel-svm.h>
 #include <linux/iommu.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip/irq-ims-msi.h>
 #include <uapi/linux/idxd.h>
 #include <linux/dmaengine.h>
 #include "../dmaengine.h"
@@ -66,6 +68,7 @@ MODULE_DEVICE_TABLE(pci, idxd_pci_tbl);
 int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
 {
 	struct device *dev = &idxd->pdev->dev;
+	struct ims_array_info ims_info;
 	int rc;
 
 	if (!idxd->ims_size)
@@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
 		return rc;
 	}
 
+	ims_info.max_slots = idxd->ims_size;
+	ims_info.slots = idxd->reg_base + idxd->ims_offset;
+	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
+	if (!idxd->ims_domain) {
+		dev_warn(dev, "Fail to acquire IMS domain\n");
+		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
+		return -ENODEV;
+	}
+
 	rc = mdev_register_device(dev, drv);
 	if (rc < 0) {
+		irq_domain_remove(idxd->ims_domain);
 		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
 		return rc;
 	}
@@ -93,6 +106,7 @@ void idxd_mdev_host_release(struct kref *kref)
 	struct idxd_device *idxd = container_of(kref, struct idxd_device, mdev_kref);
 	struct device *dev = &idxd->pdev->dev;
 
+	irq_domain_remove(idxd->ims_domain);
 	mdev_unregister_device(dev);
 	iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
 }
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 9f6c4997ec24..7dac024e2852 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -111,6 +111,7 @@ static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev
 					   struct vdcm_idxd_type *type)
 {
 	struct vdcm_idxd *vidxd;
+	struct device *dev = &mdev->dev;
 	struct idxd_wq *wq = NULL;
 	int rc;
 
@@ -129,6 +130,7 @@ static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev
 	vidxd->mdev = mdev;
 	vidxd->type = type;
 	vidxd->num_wqs = VIDXD_MAX_WQS;
+	dev_set_msi_domain(dev, idxd->ims_domain);
 
 	mutex_lock(&wq->wq_lock);
 	idxd_wq_get(wq);


