Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29489408563
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhIMHck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbhIMHcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 03:32:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3FDC061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=FhV9TlOjRN2/JZQUQ2+Qt3Dgr3yWKBJTJmrq9xkMNwQ=; b=AofGwQfz8Ea6Ni9QD7sV+KjdoS
        EVjLBCDdTR6gjuAjuVPyhDhwT1HqxpYiI7ZXUETUpS05I0TSG57ME6R6r3qy5VX5hDcE56DEhb33q
        Z3ZiNpm4IlrtRa1l7e8k+1cGi/12OST8ewV1eO/87nqYdWzYFgjxMahwEvC44XIo+Qv+/P6keTucr
        ziEfEfbYQK11RuxZnvmOcfpWJbaujfuIwxFuXxrJSVMAAXi8Ui7zbFsYJmwhitXcpEhvsj9Wa6dn+
        wcrr8p+hb8Df5VxLBPYDUUoMkJb/FARzeH36JGABM4cJT7y5EBLKXCp5QkRfodTE8RoRwd6ZdNdGx
        Bb5WUXdQ==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPgP4-00DGrq-KO; Mon, 13 Sep 2021 07:29:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Date:   Mon, 13 Sep 2021 09:16:05 +0200
Message-Id: <20210913071606.2966-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913071606.2966-1-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The external_domain concept rather misleading and not actually needed.
Replace it with a list of emulated groups in struct vfio_iommu.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 121 ++++++++++++++------------------
 1 file changed, 54 insertions(+), 67 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a48e9f597cb213..d2db62cb2aaa39 100644
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
@@ -78,6 +77,7 @@ struct vfio_iommu {
 	bool			nesting;
 	bool			dirty_page_tracking;
 	bool			container_open;
+	struct list_head	emulated_iommu_groups;
 };
 
 struct vfio_domain {
@@ -1892,8 +1892,8 @@ static struct vfio_iommu_group*
 vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 			    struct iommu_group *iommu_group)
 {
+	struct vfio_iommu_group *group;
 	struct vfio_domain *domain;
-	struct vfio_iommu_group *group = NULL;
 
 	list_for_each_entry(domain, &iommu->domain_list, next) {
 		group = find_iommu_group(domain, iommu_group);
@@ -1901,10 +1901,10 @@ vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 			return group;
 	}
 
-	if (iommu->external_domain)
-		group = find_iommu_group(iommu->external_domain, iommu_group);
-
-	return group;
+	list_for_each_entry(group, &iommu->emulated_iommu_groups, next)
+		if (group->iommu_group == iommu_group)
+			return group;
+	return NULL;
 }
 
 static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
@@ -2163,62 +2163,52 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
 	if (type == VFIO_EMULATED_IOMMU) {
-		if (!iommu->external_domain) {
-			INIT_LIST_HEAD(&domain->group_list);
-			iommu->external_domain = domain;
-			vfio_update_pgsize_bitmap(iommu);
-		} else {
-			kfree(domain);
-		}
-
-		list_add(&group->next, &iommu->external_domain->group_list);
+		list_add(&group->next, &iommu->emulated_iommu_groups);
 		/*
-		 * Non-iommu backed group cannot dirty memory directly, it can
+		 * An emulated IOMMU group cannot dirty memory directly, it can
 		 * only use interfaces that provide dirty tracking.
 		 * The iommu scope can only be promoted with the addition of a
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
@@ -2345,9 +2335,11 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
@@ -2472,25 +2464,19 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
+	list_for_each_entry(group, &iommu->emulated_iommu_groups, next) {
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
+		if (list_empty(&iommu->emulated_iommu_groups) &&
+		    !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+			WARN_ON(iommu->notifier.head);
+			vfio_iommu_unmap_unpin_all(iommu);
 		}
+		goto detach_group_done;
 	}
 
 	/*
@@ -2518,7 +2504,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		 */
 		if (list_empty(&domain->group_list)) {
 			if (list_is_singular(&iommu->domain_list)) {
-				if (!iommu->external_domain) {
+				if (list_empty(&iommu->emulated_iommu_groups)) {
 					WARN_ON(iommu->notifier.head);
 					vfio_iommu_unmap_unpin_all(iommu);
 				} else {
@@ -2582,41 +2568,42 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
 	init_waitqueue_head(&iommu->vaddr_wait);
+	INIT_LIST_HEAD(&iommu->emulated_iommu_groups);
 
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
+	struct vfio_iommu_group *group, *next_group;
 
-	if (iommu->external_domain) {
-		vfio_release_domain(iommu->external_domain, true);
-		kfree(iommu->external_domain);
+	list_for_each_entry_safe(group, next_group,
+			&iommu->emulated_iommu_groups, next) {
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

