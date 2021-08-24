Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B453F6140
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 17:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbhHXPFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 11:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238056AbhHXPFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 11:05:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06714C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ENFVyklJG3Zi9gLMERxRIBrGYWtOVBu/0RR9gFF3Uuo=; b=tKgTsaXQ3I3nZTiA8zOZH9KDQH
        BI+/M7RZeHyyKfMGLidPy2PeAEFFiwJ8yFcbJloBSRrLio8Y5zVkyESKxaQfWaehoPvNdCwEWKB6i
        vLPMrYRG4vDeM6Jvr1n7aml9FZ8Mc2dvzWqkM8QkYMJqopHldh0THu0JkL8hu0hqE1f1V5pFiX8d7
        X9PyIgDj3uVPovdDEL99srOo0rN4kDylucx/0oHXd0bq8I1cyvNZri0x1YtVt0/73ddZjMRLFg0+g
        +Z2NZdXEO5B6y5it9yvi+JQMhkDV5Y/zLH9jjXea8TNN4Fk1lU7aepIvNWEVVkxdyKwpCcxpdt+Zh
        twfHzYzg==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXxb-00BCrO-5f; Tue, 24 Aug 2021 15:03:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Date:   Tue, 24 Aug 2021 16:46:48 +0200
Message-Id: <20210824144649.1488190-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824144649.1488190-1-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The external_domain concept rather misleading and not actually needed.
Replace it with a list of mediated groups in struct vfio_iommu and
document the purpose.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio_iommu_type1.c | 123 +++++++++++++++-----------------
 1 file changed, 57 insertions(+), 66 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 44a3abdca580a0..205f13c05b236e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -65,7 +65,6 @@ MODULE_PARM_DESC(dma_entry_limit,
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct list_head	iova_list;
-	struct vfio_domain	*external_domain; /* domain for external user */
 	struct mutex		lock;
 	struct rb_root		dma_list;
 	struct blocking_notifier_head notifier;
@@ -78,6 +77,12 @@ struct vfio_iommu {
 	bool			nesting;
 	bool			dirty_page_tracking;
 	bool			container_open;
+
+	/*
+	 * Tracks the fake iommu groups created by vfio to support mediated
+	 * devices.  These are not backed by an actual IOMMU.
+	 */
+	struct list_head	mediated_groups;
 };
 
 struct vfio_domain {
@@ -1892,8 +1897,8 @@ static struct vfio_iommu_group*
 vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 			    struct iommu_group *iommu_group)
 {
+	struct vfio_iommu_group *group;
 	struct vfio_domain *domain;
-	struct vfio_iommu_group *group = NULL;
 
 	list_for_each_entry(domain, &iommu->domain_list, next) {
 		group = find_iommu_group(domain, iommu_group);
@@ -1901,10 +1906,10 @@ vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 			return group;
 	}
 
-	if (iommu->external_domain)
-		group = find_iommu_group(iommu->external_domain, iommu_group);
-
-	return group;
+	list_for_each_entry(group, &iommu->mediated_groups, next)
+		if (group->iommu_group == iommu_group)
+			return group;
+	return NULL;
 }
 
 static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
@@ -2163,45 +2168,27 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_iommu_group *group;
 	struct vfio_domain *domain, *d;
 	struct bus_type *bus = NULL;
-	int ret;
 	bool resv_msi, msi_remap;
 	phys_addr_t resv_msi_base = 0;
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
+	int ret = -EINVAL;
 
 	mutex_lock(&iommu->lock);
 
 	/* Check for duplicates */
-	if (vfio_iommu_find_iommu_group(iommu, iommu_group)) {
-		mutex_unlock(&iommu->lock);
-		return -EINVAL;
-	}
+	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
+		goto out_unlock;
 
+	ret = -ENOMEM;
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!group || !domain) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
+	if (!group)
+		goto out_unlock;
 	group->iommu_group = iommu_group;
 
-	/* Determine bus_type in order to allocate a domain */
-	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
-	if (ret)
-		goto out_free;
-
 	if (flags & VFIO_MEDIATED) {
-		if (!iommu->external_domain) {
-			INIT_LIST_HEAD(&domain->group_list);
-			iommu->external_domain = domain;
-			vfio_update_pgsize_bitmap(iommu);
-		} else {
-			kfree(domain);
-		}
-
-		list_add(&group->next, &iommu->external_domain->group_list);
+		list_add(&group->next, &iommu->mediated_groups);
 		/*
 		 * Non-iommu backed group cannot dirty memory directly, it can
 		 * only use interfaces that provide dirty tracking.
@@ -2209,16 +2196,24 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		 * dirty tracking group.
 		 */
 		group->pinned_page_dirty_scope = true;
-		mutex_unlock(&iommu->lock);
-
-		return 0;
+		ret = 0;
+		goto out_unlock;
 	}
 
+	/* Determine bus_type in order to allocate a domain */
+	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
+	if (ret)
+		goto out_free_group;
+
+	ret = -ENOMEM;
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		goto out_free_group;
+
+	ret = -EIO;
 	domain->domain = iommu_domain_alloc(bus);
-	if (!domain->domain) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (!domain->domain)
+		goto out_free_domain;
 
 	if (iommu->nesting) {
 		ret = iommu_enable_nesting(domain->domain);
@@ -2345,9 +2340,11 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	iommu_domain_free(domain->domain);
 	vfio_iommu_iova_free(&iova_copy);
 	vfio_iommu_resv_free(&group_resv_regions);
-out_free:
+out_free_domain:
 	kfree(domain);
+out_free_group:
 	kfree(group);
+out_unlock:
 	mutex_unlock(&iommu->lock);
 	return ret;
 }
@@ -2472,25 +2469,19 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
+	list_for_each_entry(group, &iommu->mediated_groups, next) {
+		if (group->iommu_group != iommu_group)
+			continue;
+		update_dirty_scope = !group->pinned_page_dirty_scope;
+		list_del(&group->next);
+		kfree(group);
 
-	if (iommu->external_domain) {
-		group = find_iommu_group(iommu->external_domain, iommu_group);
-		if (group) {
-			update_dirty_scope = !group->pinned_page_dirty_scope;
-			list_del(&group->next);
-			kfree(group);
-
-			if (list_empty(&iommu->external_domain->group_list)) {
-				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
-					WARN_ON(iommu->notifier.head);
-					vfio_iommu_unmap_unpin_all(iommu);
-				}
-
-				kfree(iommu->external_domain);
-				iommu->external_domain = NULL;
-			}
-			goto detach_group_done;
+		if (list_empty(&iommu->mediated_groups) &&
+		    !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+			WARN_ON(iommu->notifier.head);
+			vfio_iommu_unmap_unpin_all(iommu);
 		}
+		goto detach_group_done;
 	}
 
 	/*
@@ -2518,7 +2509,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		 */
 		if (list_empty(&domain->group_list)) {
 			if (list_is_singular(&iommu->domain_list)) {
-				if (!iommu->external_domain) {
+				if (list_empty(&iommu->mediated_groups)) {
 					WARN_ON(iommu->notifier.head);
 					vfio_iommu_unmap_unpin_all(iommu);
 				} else {
@@ -2582,41 +2573,41 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
 	init_waitqueue_head(&iommu->vaddr_wait);
+	INIT_LIST_HEAD(&iommu->mediated_groups);
 
 	return iommu;
 }
 
-static void vfio_release_domain(struct vfio_domain *domain, bool external)
+static void vfio_release_domain(struct vfio_domain *domain)
 {
 	struct vfio_iommu_group *group, *group_tmp;
 
 	list_for_each_entry_safe(group, group_tmp,
 				 &domain->group_list, next) {
-		if (!external)
-			iommu_detach_group(domain->domain, group->iommu_group);
+		iommu_detach_group(domain->domain, group->iommu_group);
 		list_del(&group->next);
 		kfree(group);
 	}
 
-	if (!external)
-		iommu_domain_free(domain->domain);
+	iommu_domain_free(domain->domain);
 }
 
 static void vfio_iommu_type1_release(void *iommu_data)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain, *domain_tmp;
+	struct vfio_iommu_group *group, *n;
 
-	if (iommu->external_domain) {
-		vfio_release_domain(iommu->external_domain, true);
-		kfree(iommu->external_domain);
+	list_for_each_entry_safe(group, n, &iommu->mediated_groups, next) {
+		list_del(&group->next);
+		kfree(group);
 	}
 
 	vfio_iommu_unmap_unpin_all(iommu);
 
 	list_for_each_entry_safe(domain, domain_tmp,
 				 &iommu->domain_list, next) {
-		vfio_release_domain(domain, false);
+		vfio_release_domain(domain);
 		list_del(&domain->next);
 		kfree(domain);
 	}
-- 
2.30.2

