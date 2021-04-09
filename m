Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872E4359358
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhDIDpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:45:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16424 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhDIDpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:45:05 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FGkVZ6HPszlWqS;
        Fri,  9 Apr 2021 11:43:02 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 11:44:43 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>
CC:     Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [RFC PATCH v3 7/8] vfio/type1: Add selective DMA faulting support
Date:   Fri, 9 Apr 2021 11:44:19 +0800
Message-ID: <20210409034420.1799-8-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210409034420.1799-1-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some devices only allow selective DMA faulting. Similar to the selective
dirty page tracking, the vendor driver can call vfio_pin_pages() to
indicate the non-faultable scope, we add a new struct vfio_range to
record it, then when the IOPF handler receives any page request out
of the scope, we can directly return with an invalid response.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio.c             |   4 +-
 drivers/vfio/vfio_iommu_type1.c | 357 +++++++++++++++++++++++++++++++-
 include/linux/vfio.h            |   1 +
 3 files changed, 358 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 38779e6fd80c..44c8dfabf7de 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2013,7 +2013,8 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unpin_pages))
-		ret = driver->ops->unpin_pages(container->iommu_data, user_pfn,
+		ret = driver->ops->unpin_pages(container->iommu_data,
+					       group->iommu_group, user_pfn,
 					       npage);
 	else
 		ret = -ENOTTY;
@@ -2112,6 +2113,7 @@ int vfio_group_unpin_pages(struct vfio_group *group,
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unpin_pages))
 		ret = driver->ops->unpin_pages(container->iommu_data,
+					       group->iommu_group,
 					       user_iova_pfn, npage);
 	else
 		ret = -ENOTTY;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index dcc93c3b258c..ba2b5a1cf6e9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -150,10 +150,19 @@ struct vfio_regions {
 static struct rb_root iopf_group_list = RB_ROOT;
 static DEFINE_MUTEX(iopf_group_list_lock);
 
+struct vfio_range {
+	struct rb_node		node;
+	dma_addr_t		base_iova;
+	size_t			span;
+	unsigned int		ref_count;
+};
+
 struct vfio_iopf_group {
 	struct rb_node		node;
 	struct iommu_group	*iommu_group;
 	struct vfio_iommu	*iommu;
+	struct rb_root		pinned_range_list;
+	bool			selective_faulting;
 };
 
 #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
@@ -496,6 +505,255 @@ static void vfio_unlink_iopf_group(struct vfio_iopf_group *old)
 	mutex_unlock(&iopf_group_list_lock);
 }
 
+/*
+ * Helper functions for range list, handle one page at a time.
+ */
+static struct vfio_range *vfio_find_range(struct rb_root *range_list,
+					  dma_addr_t iova)
+{
+	struct rb_node *node = range_list->rb_node;
+	struct vfio_range *range;
+
+	while (node) {
+		range = rb_entry(node, struct vfio_range, node);
+
+		if (iova + PAGE_SIZE <= range->base_iova)
+			node = node->rb_left;
+		else if (iova >= range->base_iova + range->span)
+			node = node->rb_right;
+		else
+			return range;
+	}
+
+	return NULL;
+}
+
+/* Do the possible merge adjacent to the input range. */
+static void vfio_merge_range_list(struct rb_root *range_list,
+				  struct vfio_range *range)
+{
+	struct rb_node *node_prev = rb_prev(&range->node);
+	struct rb_node *node_next = rb_next(&range->node);
+
+	if (node_next) {
+		struct vfio_range *range_next = rb_entry(node_next,
+							 struct vfio_range,
+							 node);
+
+		if (range_next->base_iova == (range->base_iova + range->span) &&
+		    range_next->ref_count == range->ref_count) {
+			rb_erase(node_next, range_list);
+			range->span += range_next->span;
+			kfree(range_next);
+		}
+	}
+
+	if (node_prev) {
+		struct vfio_range *range_prev = rb_entry(node_prev,
+							 struct vfio_range,
+							 node);
+
+		if (range->base_iova == (range_prev->base_iova + range_prev->span)
+		    && range->ref_count == range_prev->ref_count) {
+			rb_erase(&range->node, range_list);
+			range_prev->span += range->span;
+			kfree(range);
+		}
+	}
+}
+
+static void vfio_link_range(struct rb_root *range_list, struct vfio_range *new)
+{
+	struct rb_node **link, *parent = NULL;
+	struct vfio_range *range;
+
+	link = &range_list->rb_node;
+
+	while (*link) {
+		parent = *link;
+		range = rb_entry(parent, struct vfio_range, node);
+
+		if (new->base_iova < range->base_iova)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+
+	rb_link_node(&new->node, parent, link);
+	rb_insert_color(&new->node, range_list);
+
+	vfio_merge_range_list(range_list, new);
+}
+
+static int vfio_add_to_range_list(struct rb_root *range_list,
+				  dma_addr_t iova)
+{
+	struct vfio_range *range = vfio_find_range(range_list, iova);
+
+	if (range) {
+		struct vfio_range *new_prev, *new_next;
+		size_t span_prev, span_next;
+
+		/* May split the found range into three parts. */
+		span_prev = iova - range->base_iova;
+		span_next = range->span - span_prev - PAGE_SIZE;
+
+		if (span_prev) {
+			new_prev = kzalloc(sizeof(*new_prev), GFP_KERNEL);
+			if (!new_prev)
+				return -ENOMEM;
+
+			new_prev->base_iova = range->base_iova;
+			new_prev->span = span_prev;
+			new_prev->ref_count = range->ref_count;
+		}
+
+		if (span_next) {
+			new_next = kzalloc(sizeof(*new_next), GFP_KERNEL);
+			if (!new_next) {
+				if (span_prev)
+					kfree(new_prev);
+				return -ENOMEM;
+			}
+
+			new_next->base_iova = iova + PAGE_SIZE;
+			new_next->span = span_next;
+			new_next->ref_count = range->ref_count;
+		}
+
+		range->base_iova = iova;
+		range->span = PAGE_SIZE;
+		range->ref_count++;
+		vfio_merge_range_list(range_list, range);
+
+		if (span_prev)
+			vfio_link_range(range_list, new_prev);
+
+		if (span_next)
+			vfio_link_range(range_list, new_next);
+	} else {
+		struct vfio_range *new;
+
+		new = kzalloc(sizeof(*new), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+
+		new->base_iova = iova;
+		new->span = PAGE_SIZE;
+		new->ref_count = 1;
+
+		vfio_link_range(range_list, new);
+	}
+
+	return 0;
+}
+
+static int vfio_remove_from_range_list(struct rb_root *range_list,
+				       dma_addr_t iova)
+{
+	struct vfio_range *range = vfio_find_range(range_list, iova);
+	struct vfio_range *news[3];
+	size_t span_prev, span_in, span_next;
+	int i, num_news;
+
+	if (!range)
+		return 0;
+
+	span_prev = iova - range->base_iova;
+	span_in = range->ref_count > 1 ? PAGE_SIZE : 0;
+	span_next = range->span - span_prev - PAGE_SIZE;
+
+	num_news = (int)!!span_prev + (int)!!span_in + (int)!!span_next;
+	if (!num_news) {
+		rb_erase(&range->node, range_list);
+		kfree(range);
+		return 0;
+	}
+
+	for (i = 0; i < num_news - 1; i++) {
+		news[i] = kzalloc(sizeof(struct vfio_range), GFP_KERNEL);
+		if (!news[i]) {
+			if (i > 0)
+				kfree(news[0]);
+			return -ENOMEM;
+		}
+	}
+	/* Reuse the found range. */
+	news[i] = range;
+
+	i = 0;
+	if (span_prev) {
+		news[i]->base_iova = range->base_iova;
+		news[i]->span = span_prev;
+		news[i++]->ref_count = range->ref_count;
+	}
+	if (span_in) {
+		news[i]->base_iova = iova;
+		news[i]->span = span_in;
+		news[i++]->ref_count = range->ref_count - 1;
+	}
+	if (span_next) {
+		news[i]->base_iova = iova + PAGE_SIZE;
+		news[i]->span = span_next;
+		news[i]->ref_count = range->ref_count;
+	}
+
+	vfio_merge_range_list(range_list, range);
+
+	for (i = 0; i < num_news - 1; i++)
+		vfio_link_range(range_list, news[i]);
+
+	return 0;
+}
+
+static void vfio_range_list_free(struct rb_root *range_list)
+{
+	struct rb_node *n;
+
+	while ((n = rb_first(range_list))) {
+		struct vfio_range *range = rb_entry(n, struct vfio_range, node);
+
+		rb_erase(&range->node, range_list);
+		kfree(range);
+	}
+}
+
+static int vfio_range_list_get_copy(struct vfio_iopf_group *iopf_group,
+				    struct rb_root *range_list_copy)
+{
+	struct rb_root *range_list = &iopf_group->pinned_range_list;
+	struct rb_node *n, **link = &range_list_copy->rb_node, *parent = NULL;
+	int ret;
+
+	for (n = rb_first(range_list); n; n = rb_next(n)) {
+		struct vfio_range *range, *range_copy;
+
+		range = rb_entry(n, struct vfio_range, node);
+
+		range_copy = kzalloc(sizeof(*range_copy), GFP_KERNEL);
+		if (!range_copy) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		range_copy->base_iova = range->base_iova;
+		range_copy->span = range->span;
+		range_copy->ref_count = range->ref_count;
+
+		rb_link_node(&range_copy->node, parent, link);
+		rb_insert_color(&range_copy->node, range_list_copy);
+
+		parent = *link;
+		link = &(*link)->rb_right;
+	}
+
+	return 0;
+
+out_free:
+	vfio_range_list_free(range_list_copy);
+	return ret;
+}
+
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
 	struct mm_struct *mm;
@@ -910,6 +1168,9 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
 	return unlocked;
 }
 
+static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
+					   struct iommu_group *iommu_group);
+
 static int vfio_iommu_type1_pin_pages(void *iommu_data,
 				      struct iommu_group *iommu_group,
 				      unsigned long *user_pfn,
@@ -923,6 +1184,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	struct vfio_dma *dma;
 	bool do_accounting;
 	dma_addr_t iova;
+	struct vfio_iopf_group *iopf_group = NULL;
+	struct rb_root range_list_copy = RB_ROOT;
 
 	if (!iommu || !user_pfn || !phys_pfn)
 		return -EINVAL;
@@ -955,6 +1218,31 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		goto pin_done;
 	}
 
+	/*
+	 * Some devices only allow selective DMA faulting. Similar to the
+	 * selective dirty tracking, the vendor driver can call vfio_pin_pages()
+	 * to indicate the non-faultable scope, and we record it to filter
+	 * out the invalid page requests in the IOPF handler.
+	 */
+	if (iommu->iopf_enabled) {
+		iopf_group = vfio_find_iopf_group(iommu_group);
+		if (iopf_group) {
+			/*
+			 * We don't want to work on the original range
+			 * list as the list gets modified and in case
+			 * of failure we have to retain the original
+			 * list. Get a copy here.
+			 */
+			ret = vfio_range_list_get_copy(iopf_group,
+						       &range_list_copy);
+			if (ret)
+				goto pin_done;
+		} else {
+			WARN_ON(!find_iommu_group(iommu->external_domain,
+						  iommu_group));
+		}
+	}
+
 	/*
 	 * If iommu capable domain exist in the container then all pages are
 	 * already pinned and accounted. Accouting should be done if there is no
@@ -981,6 +1269,15 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
 		if (vpfn) {
 			phys_pfn[i] = vpfn->pfn;
+			if (iopf_group) {
+				ret = vfio_add_to_range_list(&range_list_copy,
+							     iova);
+				if (ret) {
+					vfio_unpin_page_external(dma, iova,
+								 do_accounting);
+					goto pin_unwind;
+				}
+			}
 			continue;
 		}
 
@@ -997,6 +1294,15 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			goto pin_unwind;
 		}
 
+		if (iopf_group) {
+			ret = vfio_add_to_range_list(&range_list_copy, iova);
+			if (ret) {
+				vfio_unpin_page_external(dma, iova,
+							 do_accounting);
+				goto pin_unwind;
+			}
+		}
+
 		if (iommu->dirty_page_tracking) {
 			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
 
@@ -1010,6 +1316,13 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	}
 	ret = i;
 
+	if (iopf_group) {
+		vfio_range_list_free(&iopf_group->pinned_range_list);
+		iopf_group->pinned_range_list.rb_node = range_list_copy.rb_node;
+		if (!iopf_group->selective_faulting)
+			iopf_group->selective_faulting = true;
+	}
+
 	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
 	if (!group->pinned_page_dirty_scope) {
 		group->pinned_page_dirty_scope = true;
@@ -1019,6 +1332,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	goto pin_done;
 
 pin_unwind:
+	if (iopf_group)
+		vfio_range_list_free(&range_list_copy);
 	phys_pfn[i] = 0;
 	for (j = 0; j < i; j++) {
 		dma_addr_t iova;
@@ -1034,12 +1349,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 }
 
 static int vfio_iommu_type1_unpin_pages(void *iommu_data,
+					struct iommu_group *iommu_group,
 					unsigned long *user_pfn,
 					int npage)
 {
 	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_iopf_group *iopf_group = NULL;
 	bool do_accounting;
-	int i;
+	int i, ret;
 
 	if (!iommu || !user_pfn)
 		return -EINVAL;
@@ -1050,6 +1367,13 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
+	if (iommu->iopf_enabled) {
+		iopf_group = vfio_find_iopf_group(iommu_group);
+		if (!iopf_group)
+			WARN_ON(!find_iommu_group(iommu->external_domain,
+						  iommu_group));
+	}
+
 	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) ||
 			iommu->iopf_enabled;
 	for (i = 0; i < npage; i++) {
@@ -1058,14 +1382,24 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 
 		iova = user_pfn[i] << PAGE_SHIFT;
 		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
-		if (!dma)
+		if (!dma) {
+			ret = -EINVAL;
 			goto unpin_exit;
+		}
+
+		if (iopf_group) {
+			ret = vfio_remove_from_range_list(
+					&iopf_group->pinned_range_list, iova);
+			if (ret)
+				goto unpin_exit;
+		}
+
 		vfio_unpin_page_external(dma, iova, do_accounting);
 	}
 
 unpin_exit:
 	mutex_unlock(&iommu->lock);
-	return i > npage ? npage : (i > 0 ? i : -EINVAL);
+	return i > npage ? npage : (i > 0 ? i : ret);
 }
 
 static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
@@ -2591,6 +2925,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 		iopf_group->iommu_group = iommu_group;
 		iopf_group->iommu = iommu;
+		iopf_group->pinned_range_list = RB_ROOT;
 
 		vfio_link_iopf_group(iopf_group);
 	}
@@ -2886,6 +3221,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 
 			iopf_group = vfio_find_iopf_group(iommu_group);
 			if (!WARN_ON(!iopf_group)) {
+				WARN_ON(!RB_EMPTY_ROOT(
+						&iopf_group->pinned_range_list));
 				vfio_unlink_iopf_group(iopf_group);
 				kfree(iopf_group);
 			}
@@ -3482,6 +3819,7 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
 	struct vfio_iommu *iommu;
 	struct vfio_dma *dma;
 	struct vfio_batch batch;
+	struct vfio_range *range;
 	dma_addr_t iova = ALIGN_DOWN(fault->prm.addr, PAGE_SIZE);
 	int access_flags = 0;
 	size_t premap_len, map_len, mapped_len = 0;
@@ -3506,6 +3844,12 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
 
 	mutex_lock(&iommu->lock);
 
+	if (iopf_group->selective_faulting) {
+		range = vfio_find_range(&iopf_group->pinned_range_list, iova);
+		if (!range)
+			goto out_invalid;
+	}
+
 	ret = vfio_find_dma_valid(iommu, iova, PAGE_SIZE, &dma);
 	if (ret < 0)
 		goto out_invalid;
@@ -3523,6 +3867,12 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
 
 	premap_len = IOPF_PREMAP_LEN << PAGE_SHIFT;
 	npages = dma->size >> PAGE_SHIFT;
+	if (iopf_group->selective_faulting) {
+		dma_addr_t range_end = range->base_iova + range->span;
+
+		if (range_end < dma->iova + dma->size)
+			npages = (range_end - dma->iova) >> PAGE_SHIFT;
+	}
 	map_len = PAGE_SIZE;
 	for (i = bit_offset + 1; i < npages; i++) {
 		if (map_len >= premap_len || IOPF_MAPPED_BITMAP_GET(dma, i))
@@ -3647,6 +3997,7 @@ static int vfio_iommu_type1_enable_iopf(struct vfio_iommu *iommu)
 
 			iopf_group->iommu_group = g->iommu_group;
 			iopf_group->iommu = iommu;
+			iopf_group->pinned_range_list = RB_ROOT;
 
 			vfio_link_iopf_group(iopf_group);
 		}
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b7e18bde5aa8..a7b426d579df 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -87,6 +87,7 @@ struct vfio_iommu_driver_ops {
 				     int npage, int prot,
 				     unsigned long *phys_pfn);
 	int		(*unpin_pages)(void *iommu_data,
+				       struct iommu_group *group,
 				       unsigned long *user_pfn, int npage);
 	int		(*register_notifier)(void *iommu_data,
 					     unsigned long *events,
-- 
2.19.1

