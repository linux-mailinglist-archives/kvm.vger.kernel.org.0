Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F62D3F7ABF
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241752AbhHYQh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239550AbhHYQh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:37:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F6FC061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 09:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OCIcZl5q/liLOTKBBkw3qH/DxWz2CTfxWHkFVn06KbE=; b=AB0IOswnZ8XEXva0LX/RnGlb/R
        aj38YuLh/K0yIqWyfGfekfCT1TJUdF7s8q10D+ZOnVfLChq1zqV90s2OiKcEfVx4oSbnDHYTULEbq
        1QBg+uIzG8WvLz7GYVni/QyZU2nDYyvHPXIquI0NEl2O910DvB1a71ku8ETZfuH1d7zMQyuqyeXNQ
        WnHeogHqBcy6iWiozsfdc1C8NMW5dWfFUdYJL9HPgyBgp3auKIPhHfCFxRWnFmnDt3FiMAoIje8L3
        VCT92RMIzqU05lyrXUYVUdHjFFeC/XT2cI4ab5GaKF63FLYRlQAN/5Q7jeO8VFjK+y6mTU7rwvVsg
        gcYJFDxA==;
Received: from [2001:4bb8:193:fd10:a3f9:5689:21a4:711f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIvrK-00CTj0-Af; Wed, 25 Aug 2021 16:35:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 10/14] vfio: remove the unused mdev iommu hook
Date:   Wed, 25 Aug 2021 18:19:11 +0200
Message-Id: <20210825161916.50393-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825161916.50393-1-hch@lst.de>
References: <20210825161916.50393-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu_device field in struct mdev_device has never been used
since it was added more than 2 years ago.

This is a manual revert of commit 7bd50f0cd2
("vfio/type1: Add domain at(de)taching group helpers").

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio_iommu_type1.c | 133 +++++++-------------------------
 include/linux/mdev.h            |  20 -----
 2 files changed, 26 insertions(+), 127 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 92777797578e50..39e2706d0b3f34 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -114,7 +114,6 @@ struct vfio_batch {
 struct vfio_iommu_group {
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
-	bool			mdev_group;	/* An mdev group */
 	bool			pinned_page_dirty_scope;
 };
 
@@ -1935,61 +1934,6 @@ static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
 	return ret;
 }
 
-static int vfio_mdev_attach_domain(struct device *dev, void *data)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-	struct iommu_domain *domain = data;
-	struct device *iommu_device;
-
-	iommu_device = mdev_get_iommu_device(mdev);
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
-	struct mdev_device *mdev = to_mdev_device(dev);
-	struct iommu_domain *domain = data;
-	struct device *iommu_device;
-
-	iommu_device = mdev_get_iommu_device(mdev);
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
-				   struct vfio_iommu_group *group)
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
-				    struct vfio_iommu_group *group)
-{
-	if (group->mdev_group)
-		iommu_group_for_each_dev(group->iommu_group, domain->domain,
-					 vfio_mdev_detach_domain);
-	else
-		iommu_detach_group(domain->domain, group->iommu_group);
-}
-
 static bool vfio_bus_is_mdev(struct bus_type *bus)
 {
 	struct bus_type *mdev_bus;
@@ -2004,20 +1948,6 @@ static bool vfio_bus_is_mdev(struct bus_type *bus)
 	return ret;
 }
 
-static int vfio_mdev_iommu_device(struct device *dev, void *data)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-	struct device **old = data, *new;
-
-	new = mdev_get_iommu_device(mdev);
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
@@ -2278,38 +2208,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_free;
 
 	if (vfio_bus_is_mdev(bus)) {
-		struct device *iommu_device = NULL;
-
-		group->mdev_group = true;
-
-		/* Determine the isolation type */
-		ret = iommu_group_for_each_dev(iommu_group, &iommu_device,
-					       vfio_mdev_iommu_device);
-		if (ret || !iommu_device) {
-			if (!iommu->external_domain) {
-				INIT_LIST_HEAD(&domain->group_list);
-				iommu->external_domain = domain;
-				vfio_update_pgsize_bitmap(iommu);
-			} else {
-				kfree(domain);
-			}
-
-			list_add(&group->next,
-				 &iommu->external_domain->group_list);
-			/*
-			 * Non-iommu backed group cannot dirty memory directly,
-			 * it can only use interfaces that provide dirty
-			 * tracking.
-			 * The iommu scope can only be promoted with the
-			 * addition of a dirty tracking group.
-			 */
-			group->pinned_page_dirty_scope = true;
-			mutex_unlock(&iommu->lock);
-
-			return 0;
+		if (!iommu->external_domain) {
+			INIT_LIST_HEAD(&domain->group_list);
+			iommu->external_domain = domain;
+			vfio_update_pgsize_bitmap(iommu);
+		} else {
+			kfree(domain);
 		}
 
-		bus = iommu_device->bus;
+		list_add(&group->next, &iommu->external_domain->group_list);
+		/*
+		 * Non-iommu backed group cannot dirty memory directly, it can
+		 * only use interfaces that provide dirty tracking.
+		 * The iommu scope can only be promoted with the addition of a
+		 * dirty tracking group.
+		 */
+		group->pinned_page_dirty_scope = true;
+		mutex_unlock(&iommu->lock);
+
+		return 0;
 	}
 
 	domain->domain = iommu_domain_alloc(bus);
@@ -2324,7 +2241,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			goto out_domain;
 	}
 
-	ret = vfio_iommu_attach_group(domain, group);
+	ret = iommu_attach_group(domain->domain, group->iommu_group);
 	if (ret)
 		goto out_domain;
 
@@ -2391,15 +2308,17 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
 		    d->prot == domain->prot) {
-			vfio_iommu_detach_group(domain, group);
-			if (!vfio_iommu_attach_group(d, group)) {
+			iommu_detach_group(domain->domain, group->iommu_group);
+			if (!iommu_attach_group(d->domain,
+						group->iommu_group)) {
 				list_add(&group->next, &d->group_list);
 				iommu_domain_free(domain->domain);
 				kfree(domain);
 				goto done;
 			}
 
-			ret = vfio_iommu_attach_group(domain, group);
+			ret = iommu_attach_group(domain->domain,
+						 group->iommu_group);
 			if (ret)
 				goto out_domain;
 		}
@@ -2436,7 +2355,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	return 0;
 
 out_detach:
-	vfio_iommu_detach_group(domain, group);
+	iommu_detach_group(domain->domain, group->iommu_group);
 out_domain:
 	iommu_domain_free(domain->domain);
 	vfio_iommu_iova_free(&iova_copy);
@@ -2601,7 +2520,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
-		vfio_iommu_detach_group(domain, group);
+		iommu_detach_group(domain->domain, group->iommu_group);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
@@ -2689,7 +2608,7 @@ static void vfio_release_domain(struct vfio_domain *domain, bool external)
 	list_for_each_entry_safe(group, group_tmp,
 				 &domain->group_list, next) {
 		if (!external)
-			vfio_iommu_detach_group(domain, group);
+			iommu_detach_group(domain->domain, group->iommu_group);
 		list_del(&group->next);
 		kfree(group);
 	}
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 68427e8fadebd6..15d03f6532d073 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -18,7 +18,6 @@ struct mdev_device {
 	void *driver_data;
 	struct list_head next;
 	struct mdev_type *type;
-	struct device *iommu_device;
 	bool active;
 };
 
@@ -27,25 +26,6 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
 	return container_of(dev, struct mdev_device, dev);
 }
 
-/*
- * Called by the parent device driver to set the device which represents
- * this mdev in iommu protection scope. By default, the iommu device is
- * NULL, that indicates using vendor defined isolation.
- *
- * @dev: the mediated device that iommu will isolate.
- * @iommu_device: a pci device which represents the iommu for @dev.
- */
-static inline void mdev_set_iommu_device(struct mdev_device *mdev,
-					 struct device *iommu_device)
-{
-	mdev->iommu_device = iommu_device;
-}
-
-static inline struct device *mdev_get_iommu_device(struct mdev_device *mdev)
-{
-	return mdev->iommu_device;
-}
-
 unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
 unsigned int mtype_get_type_group_id(struct mdev_type *mtype);
 struct device *mtype_get_parent_dev(struct mdev_type *mtype);
-- 
2.30.2

