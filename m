Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0757529FCF3
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgJ3FFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:05:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:5284 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgJ3FFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:05:22 -0400
IronPort-SDR: a+zGajveEaxoIVJKfaJ84QZLarMZltz/EvlU60AwHc/Lag4VTjTVyy7H/U05HRMxiHQfrWxbuV
 ap86YAd9BS4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="230196565"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="230196565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:05:21 -0700
IronPort-SDR: oHD+TcdfaLN26CEhhjanZXvl5LLtjVm4yk5X0xvtAzVmCOmqfAODIVRNaV6AdCtTIRYFpPdWnL
 cYMFRQADkBUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="425261596"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2020 22:05:18 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 5/5] vfio/type1: Use mdev bus iommu_ops for IOMMU callbacks
Date:   Fri, 30 Oct 2020 12:58:09 +0800
Message-Id: <20201030045809.957927-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030045809.957927-1-baolu.lu@linux.intel.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the IOMMU driver registering iommu_ops for the mdev_bus, the IOMMU
operations on an mdev could be done in the same way as any normal device
(for example, PCI/PCIe). There's no need to distinguish an mdev from
others for iommu operations. Remove the unnecessary code.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/mdev/mdev_core.c    |  18 -----
 drivers/vfio/mdev/mdev_driver.c  |   6 ++
 drivers/vfio/mdev/mdev_private.h |   1 -
 drivers/vfio/vfio_iommu_type1.c  | 128 +++----------------------------
 include/linux/mdev.h             |  14 ----
 5 files changed, 18 insertions(+), 149 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 6b9ab71f89e7..f4fd5f237c49 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -386,24 +386,6 @@ int mdev_device_remove(struct device *dev)
 	return 0;
 }
 
-int mdev_set_iommu_device(struct device *dev, struct device *iommu_device)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-
-	mdev->iommu_device = iommu_device;
-
-	return 0;
-}
-EXPORT_SYMBOL(mdev_set_iommu_device);
-
-struct device *mdev_get_iommu_device(struct device *dev)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-
-	return mdev->iommu_device;
-}
-EXPORT_SYMBOL(mdev_get_iommu_device);
-
 static int __init mdev_init(void)
 {
 	return mdev_bus_register();
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 0d3223aee20b..487402f16355 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -18,6 +18,9 @@ static int mdev_attach_iommu(struct mdev_device *mdev)
 	int ret;
 	struct iommu_group *group;
 
+	if (iommu_present(&mdev_bus_type))
+		return 0;
+
 	group = iommu_group_alloc();
 	if (IS_ERR(group))
 		return PTR_ERR(group);
@@ -33,6 +36,9 @@ static int mdev_attach_iommu(struct mdev_device *mdev)
 
 static void mdev_detach_iommu(struct mdev_device *mdev)
 {
+	if (iommu_present(&mdev_bus_type))
+		return;
+
 	iommu_group_remove_device(&mdev->dev);
 	dev_info(&mdev->dev, "MDEV: detaching iommu\n");
 }
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7d922950caaf..efe0aefdb52f 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -31,7 +31,6 @@ struct mdev_device {
 	void *driver_data;
 	struct list_head next;
 	struct kobject *type_kobj;
-	struct device *iommu_device;
 	bool active;
 };
 
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bb2684cc245e..e231b7070ca5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,7 +100,6 @@ struct vfio_dma {
 struct vfio_group {
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
-	bool			mdev_group;	/* An mdev group */
 	bool			pinned_page_dirty_scope;
 };
 
@@ -1675,102 +1674,6 @@ static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
 	return ret;
 }
 
-static struct device *vfio_mdev_get_iommu_device(struct device *dev)
-{
-	struct device *(*fn)(struct device *dev);
-	struct device *iommu_device;
-
-	fn = symbol_get(mdev_get_iommu_device);
-	if (fn) {
-		iommu_device = fn(dev);
-		symbol_put(mdev_get_iommu_device);
-
-		return iommu_device;
-	}
-
-	return NULL;
-}
-
-static int vfio_mdev_attach_domain(struct device *dev, void *data)
-{
-	struct iommu_domain *domain = data;
-	struct device *iommu_device;
-
-	iommu_device = vfio_mdev_get_iommu_device(dev);
-	if (iommu_device) {
-		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
-			return iommu_aux_attach_device(domain, iommu_device);
-		else
-			return iommu_attach_device(domain, iommu_device);
-	}
-
-	return -EINVAL;
-}
-
-static int vfio_mdev_detach_domain(struct device *dev, void *data)
-{
-	struct iommu_domain *domain = data;
-	struct device *iommu_device;
-
-	iommu_device = vfio_mdev_get_iommu_device(dev);
-	if (iommu_device) {
-		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
-			iommu_aux_detach_device(domain, iommu_device);
-		else
-			iommu_detach_device(domain, iommu_device);
-	}
-
-	return 0;
-}
-
-static int vfio_iommu_attach_group(struct vfio_domain *domain,
-				   struct vfio_group *group)
-{
-	if (group->mdev_group)
-		return iommu_group_for_each_dev(group->iommu_group,
-						domain->domain,
-						vfio_mdev_attach_domain);
-	else
-		return iommu_attach_group(domain->domain, group->iommu_group);
-}
-
-static void vfio_iommu_detach_group(struct vfio_domain *domain,
-				    struct vfio_group *group)
-{
-	if (group->mdev_group)
-		iommu_group_for_each_dev(group->iommu_group, domain->domain,
-					 vfio_mdev_detach_domain);
-	else
-		iommu_detach_group(domain->domain, group->iommu_group);
-}
-
-static bool vfio_bus_is_mdev(struct bus_type *bus)
-{
-	struct bus_type *mdev_bus;
-	bool ret = false;
-
-	mdev_bus = symbol_get(mdev_bus_type);
-	if (mdev_bus) {
-		ret = (bus == mdev_bus);
-		symbol_put(mdev_bus_type);
-	}
-
-	return ret;
-}
-
-static int vfio_mdev_iommu_device(struct device *dev, void *data)
-{
-	struct device **old = data, *new;
-
-	new = vfio_mdev_get_iommu_device(dev);
-	if (!new || (*old && *old != new))
-		return -EINVAL;
-
-	*old = new;
-
-	return 0;
-}
-
 /*
  * This is a helper function to insert an address range to iova list.
  * The list is initially created with a single entry corresponding to
@@ -1999,7 +1902,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_group *group;
 	struct vfio_domain *domain, *d;
-	struct bus_type *bus = NULL;
+	struct bus_type *bus = NULL, *mdev_bus;
 	int ret;
 	bool resv_msi, msi_remap;
 	phys_addr_t resv_msi_base = 0;
@@ -2037,15 +1940,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_free;
 
-	if (vfio_bus_is_mdev(bus)) {
-		struct device *iommu_device = NULL;
-
-		group->mdev_group = true;
-
-		/* Determine the isolation type */
-		ret = iommu_group_for_each_dev(iommu_group, &iommu_device,
-					       vfio_mdev_iommu_device);
-		if (ret || !iommu_device) {
+	mdev_bus = symbol_get(mdev_bus_type);
+	if (mdev_bus) {
+		if (bus == mdev_bus && !iommu_present(bus)) {
+			symbol_put(mdev_bus_type);
 			if (!iommu->external_domain) {
 				INIT_LIST_HEAD(&domain->group_list);
 				iommu->external_domain = domain;
@@ -2070,8 +1968,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 			return 0;
 		}
-
-		bus = iommu_device->bus;
 	}
 
 	domain->domain = iommu_domain_alloc(bus);
@@ -2089,7 +1985,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			goto out_domain;
 	}
 
-	ret = vfio_iommu_attach_group(domain, group);
+	ret = iommu_attach_group(domain->domain, iommu_group);
 	if (ret)
 		goto out_domain;
 
@@ -2157,15 +2053,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
 		    d->prot == domain->prot) {
-			vfio_iommu_detach_group(domain, group);
-			if (!vfio_iommu_attach_group(d, group)) {
+			iommu_detach_group(domain->domain, iommu_group);
+			if (!iommu_attach_group(d->domain, iommu_group)) {
 				list_add(&group->next, &d->group_list);
 				iommu_domain_free(domain->domain);
 				kfree(domain);
 				goto done;
 			}
 
-			ret = vfio_iommu_attach_group(domain, group);
+			ret = iommu_attach_group(domain->domain, iommu_group);
 			if (ret)
 				goto out_domain;
 		}
@@ -2202,7 +2098,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	return 0;
 
 out_detach:
-	vfio_iommu_detach_group(domain, group);
+	iommu_detach_group(domain->domain, iommu_group);
 out_domain:
 	iommu_domain_free(domain->domain);
 	vfio_iommu_iova_free(&iova_copy);
@@ -2385,7 +2281,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
-		vfio_iommu_detach_group(domain, group);
+		iommu_detach_group(domain->domain, iommu_group);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
@@ -2466,7 +2362,7 @@ static void vfio_release_domain(struct vfio_domain *domain, bool external)
 	list_for_each_entry_safe(group, group_tmp,
 				 &domain->group_list, next) {
 		if (!external)
-			vfio_iommu_detach_group(domain, group);
+			iommu_detach_group(domain->domain, group->iommu_group);
 		list_del(&group->next);
 		kfree(group);
 	}
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..f7aee86bd2b0 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -12,20 +12,6 @@
 
 struct mdev_device;
 
-/*
- * Called by the parent device driver to set the device which represents
- * this mdev in iommu protection scope. By default, the iommu device is
- * NULL, that indicates using vendor defined isolation.
- *
- * @dev: the mediated device that iommu will isolate.
- * @iommu_device: a pci device which represents the iommu for @dev.
- *
- * Return 0 for success, otherwise negative error value.
- */
-int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
-
-struct device *mdev_get_iommu_device(struct device *dev);
-
 /**
  * struct mdev_parent_ops - Structure to be registered for each parent device to
  * register the device to mdev module.
-- 
2.25.1

