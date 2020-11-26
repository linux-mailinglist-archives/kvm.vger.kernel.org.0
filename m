Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4177C2C4CB1
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 02:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgKZBex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 20:34:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:29161 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgKZBex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 20:34:53 -0500
IronPort-SDR: 3GkKJmJXyIoTS+CKb0TJCwuFIkeg0UAYJMTFrqX4Iwpr18Hx2r2eKgfzetug2rB/n6KtDMV0kG
 BCaQnDsJU3Ww==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="172379669"
X-IronPort-AV: E=Sophos;i="5.78,370,1599548400"; 
   d="scan'208";a="172379669"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 17:34:52 -0800
IronPort-SDR: Ju/OJVcePi+BPbWhGCJq86Ftbi/dH9cTkOGoM3RgHSHroeUUJ8o7RywvcZXioaOeD0L39E0YrN
 pDlm5itLN/bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,370,1599548400"; 
   d="scan'208";a="362616801"
Received: from allen-box.sh.intel.com ([10.239.159.28])
  by fmsmga004.fm.intel.com with ESMTP; 25 Nov 2020 17:34:49 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 1/1] vfio/type1: Add vfio_group_domain()
Date:   Thu, 26 Nov 2020 09:27:26 +0800
Message-Id: <20201126012726.1185171-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the API for getting the domain from a vfio group. This could be used
by the physical device drivers which rely on the vfio/mdev framework for
mediated device user level access. The typical use case like below:

	unsigned int pasid;
	struct vfio_group *vfio_group;
	struct iommu_domain *iommu_domain;
	struct device *dev = mdev_dev(mdev);
	struct device *iommu_device = mdev_get_iommu_device(dev);

	if (!iommu_device ||
	    !iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
		return -EINVAL;

	vfio_group = vfio_group_get_external_user_from_dev(dev);(dev);
	if (IS_ERR_OR_NULL(vfio_group))
		return -EFAULT;

	iommu_domain = vfio_group_domain(vfio_group);
	if (IS_ERR_OR_NULL(iommu_domain)) {
		vfio_group_put_external_user(vfio_group);
		return -EFAULT;
	}

	pasid = iommu_aux_get_pasid(iommu_domain, iommu_device);
	if (pasid < 0) {
		vfio_group_put_external_user(vfio_group);
		return -EFAULT;
	}

	/* Program device context with pasid value. */
	...

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio.c             | 18 ++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++++++
 include/linux/vfio.h            |  3 +++
 3 files changed, 44 insertions(+)

Change log:
 - v1: https://lore.kernel.org/linux-iommu/20201112022407.2063896-1-baolu.lu@linux.intel.com/
 - Changed according to comments @ https://lore.kernel.org/linux-iommu/20201116125631.2d043fcd@w520.home/

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2151bc7f87ab..62c652111c88 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2331,6 +2331,24 @@ int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
 }
 EXPORT_SYMBOL(vfio_unregister_notifier);
 
+struct iommu_domain *vfio_group_domain(struct vfio_group *group)
+{
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+
+	if (!group)
+		return ERR_PTR(-EINVAL);
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->group_domain))
+		return driver->ops->group_domain(container->iommu_data,
+						 group->iommu_group);
+	else
+		return ERR_PTR(-ENOTTY);
+}
+EXPORT_SYMBOL(vfio_group_domain);
+
 /**
  * Module/class support
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 67e827638995..783f18f21b95 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2980,6 +2980,28 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	return ret;
 }
 
+static void *vfio_iommu_type1_group_domain(void *iommu_data,
+					   struct iommu_group *iommu_group)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct iommu_domain *domain = NULL;
+	struct vfio_domain *d;
+
+	if (!iommu || !iommu_group)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		if (find_iommu_group(d, iommu_group)) {
+			domain = d->domain;
+			break;
+		}
+	}
+	mutex_unlock(&iommu->lock);
+
+	return domain;
+}
+
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -2993,6 +3015,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.register_notifier	= vfio_iommu_type1_register_notifier,
 	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
+	.group_domain		= vfio_iommu_type1_group_domain,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 38d3c6a8dc7e..a0613a6f21cc 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -90,6 +90,7 @@ struct vfio_iommu_driver_ops {
 					       struct notifier_block *nb);
 	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
 				  void *data, size_t count, bool write);
+	void		*(*group_domain)(void *iommu_data, struct iommu_group *group);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
@@ -126,6 +127,8 @@ extern int vfio_group_unpin_pages(struct vfio_group *group,
 extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
 		       void *data, size_t len, bool write);
 
+extern struct iommu_domain *vfio_group_domain(struct vfio_group *group);
+
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,
-- 
2.25.1

