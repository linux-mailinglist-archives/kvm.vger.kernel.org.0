Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE09218A398
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 21:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgCRUPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 16:15:14 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19297 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRUPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 16:15:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7281430001>; Wed, 18 Mar 2020 13:15:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 18 Mar 2020 13:15:13 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 18 Mar 2020 13:15:13 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Mar
 2020 20:15:12 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 18 Mar 2020 20:15:05 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v14 Kernel 4/7] vfio iommu: Implementation of ioctl for dirty pages tracking.
Date:   Thu, 19 Mar 2020 01:11:11 +0530
Message-ID: <1584560474-19946-5-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584562500; bh=1OwWYme6vYhj21KkGF1uTk4TCnE80yOJLlVxiM1gKRk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=hDACaJ1Qj3sW3CuaTq1pYH6LVQCK4ca4AiDQgUuu0EnbM5rBk07YuPGHYUT7xNAYk
         bibfguRe+P16JQgLCJUjhn7u7GogRF01EHBvpFzrkxVnYqvb+i3PJMgWZKsV7oaSO5
         9jrmXqjcs7K/14C6m/OrxGHFOI7ICsyNb6yOIAY1hRTfucSkNNWznAVlmnS2TE2sNV
         M06EBriZV7o9cm2wK2aGiQPAT9CYDmPVf2szEOthCYu6zRhH5rp7hhhOIenKI2BnFE
         DhmQMJ/6NQ9it06F4kqJeRqg6DN6ZCFo4dFguPazcCO+OUNzD8HdZKjFH6U33urxY4
         MmjP2arYiiTqQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
- Start dirty pages tracking while migration is active
- Stop dirty pages tracking.
- Get dirty pages bitmap. Its user space application's responsibility to
  copy content of dirty pages from source to destination during migration.

To prevent DoS attack, memory for bitmap is allocated per vfio_dma
structure. Bitmap size is calculated considering smallest supported page
size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled

Bitmap is populated for already pinned pages when bitmap is allocated for
a vfio_dma with the smallest supported page size. Update bitmap from
pinning functions when tracking is enabled. When user application queries
bitmap, check if requested page size is same as page size used to
populated bitmap. If it is equal, copy bitmap, but if not equal, return
error.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 205 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 203 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 70aeab921d0f..d6417fb02174 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -71,6 +71,7 @@ struct vfio_iommu {
 	unsigned int		dma_avail;
 	bool			v2;
 	bool			nesting;
+	bool			dirty_page_tracking;
 };
 
 struct vfio_domain {
@@ -91,6 +92,7 @@ struct vfio_dma {
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
+	unsigned long		*bitmap;
 };
 
 struct vfio_group {
@@ -125,7 +127,10 @@ struct vfio_regions {
 #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
 					(!list_empty(&iommu->domain_list))
 
+#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
+
 static int put_pfn(unsigned long pfn, int prot);
+static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
 
 /*
  * This code handles mapping and unmapping of user data buffers
@@ -175,6 +180,55 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
 	rb_erase(&old->node, &iommu->dma_list);
 }
 
+static int vfio_dma_bitmap_alloc(struct vfio_iommu *iommu, uint64_t pgsize)
+{
+	struct rb_node *n = rb_first(&iommu->dma_list);
+
+	for (; n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+		struct rb_node *p;
+		unsigned long npages = dma->size / pgsize;
+
+		dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
+		if (!dma->bitmap) {
+			struct rb_node *p = rb_prev(n);
+
+			for (; p; p = rb_prev(p)) {
+				struct vfio_dma *dma = rb_entry(n,
+							struct vfio_dma, node);
+
+				kfree(dma->bitmap);
+				dma->bitmap = NULL;
+			}
+			return -ENOMEM;
+		}
+
+		if (RB_EMPTY_ROOT(&dma->pfn_list))
+			continue;
+
+		for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
+			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
+							 node);
+
+			bitmap_set(dma->bitmap,
+					(vpfn->iova - dma->iova) / pgsize, 1);
+		}
+	}
+	return 0;
+}
+
+static void vfio_dma_bitmap_free(struct vfio_iommu *iommu)
+{
+	struct rb_node *n = rb_first(&iommu->dma_list);
+
+	for (; n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		kfree(dma->bitmap);
+		dma->bitmap = NULL;
+	}
+}
+
 /*
  * Helper Functions for host iova-pfn list
  */
@@ -567,6 +621,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			vfio_unpin_page_external(dma, iova, do_accounting);
 			goto pin_unwind;
 		}
+
+		if (iommu->dirty_page_tracking) {
+			unsigned long pgshift =
+					 __ffs(vfio_pgsize_bitmap(iommu));
+
+			bitmap_set(dma->bitmap,
+				   (vpfn->iova - dma->iova) >> pgshift, 1);
+		}
 	}
 
 	ret = i;
@@ -801,6 +863,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	kfree(dma->bitmap);
 	kfree(dma);
 	iommu->dma_avail++;
 }
@@ -831,6 +894,50 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 	return bitmap;
 }
 
+static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
+				  size_t size, uint64_t pgsize,
+				  unsigned char __user *bitmap)
+{
+	struct vfio_dma *dma;
+	unsigned long pgshift = __ffs(pgsize);
+	unsigned int npages, bitmap_size;
+
+	dma = vfio_find_dma(iommu, iova, 1);
+
+	if (!dma)
+		return -EINVAL;
+
+	if (dma->iova != iova || dma->size != size)
+		return -EINVAL;
+
+	npages = dma->size >> pgshift;
+	bitmap_size = DIRTY_BITMAP_BYTES(npages);
+
+	/* mark all pages dirty if all pages are pinned and mapped. */
+	if (dma->iommu_mapped)
+		bitmap_set(dma->bitmap, 0, npages);
+
+	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
+{
+	uint64_t bsize;
+
+	if (!npages || !bitmap_size || bitmap_size > UINT_MAX)
+		return -EINVAL;
+
+	bsize = DIRTY_BITMAP_BYTES(npages);
+
+	if (bitmap_size < bsize)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap)
 {
@@ -2278,6 +2385,93 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
+		struct vfio_iommu_type1_dirty_bitmap dirty;
+		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
+				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
+				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
+		int ret = 0;
+
+		if (!iommu->v2)
+			return -EACCES;
+
+		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
+				    flags);
+
+		if (copy_from_user(&dirty, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (dirty.argsz < minsz || dirty.flags & ~mask)
+			return -EINVAL;
+
+		/* only one flag should be set at a time */
+		if (__ffs(dirty.flags) != __fls(dirty.flags))
+			return -EINVAL;
+
+		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
+			uint64_t pgsize = 1 << __ffs(vfio_pgsize_bitmap(iommu));
+
+			mutex_lock(&iommu->lock);
+			if (!iommu->dirty_page_tracking) {
+				ret = vfio_dma_bitmap_alloc(iommu, pgsize);
+				if (!ret)
+					iommu->dirty_page_tracking = true;
+			}
+			mutex_unlock(&iommu->lock);
+			return ret;
+		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
+			mutex_lock(&iommu->lock);
+			if (iommu->dirty_page_tracking) {
+				iommu->dirty_page_tracking = false;
+				vfio_dma_bitmap_free(iommu);
+			}
+			mutex_unlock(&iommu->lock);
+			return 0;
+		} else if (dirty.flags &
+				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
+			struct vfio_iommu_type1_dirty_bitmap_get range;
+			unsigned long pgshift;
+			size_t data_size = dirty.argsz - minsz;
+			uint64_t iommu_pgsize =
+					 1 << __ffs(vfio_pgsize_bitmap(iommu));
+
+			if (!data_size || data_size < sizeof(range))
+				return -EINVAL;
+
+			if (copy_from_user(&range, (void __user *)(arg + minsz),
+					   sizeof(range)))
+				return -EFAULT;
+
+			/* allow only min supported pgsize */
+			if (range.bitmap.pgsize != iommu_pgsize)
+				return -EINVAL;
+			if (range.iova & (iommu_pgsize - 1))
+				return -EINVAL;
+			if (!range.size || range.size & (iommu_pgsize - 1))
+				return -EINVAL;
+			if (range.iova + range.size < range.iova)
+				return -EINVAL;
+			if (!access_ok((void __user *)range.bitmap.data,
+				       range.bitmap.size))
+				return -EINVAL;
+
+			pgshift = __ffs(range.bitmap.pgsize);
+			ret = verify_bitmap_size(range.size >> pgshift,
+						 range.bitmap.size);
+			if (ret)
+				return ret;
+
+			mutex_lock(&iommu->lock);
+			if (iommu->dirty_page_tracking)
+				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
+					 range.size, range.bitmap.pgsize,
+				    (unsigned char __user *)range.bitmap.data);
+			else
+				ret = -EINVAL;
+			mutex_unlock(&iommu->lock);
+
+			return ret;
+		}
 	}
 
 	return -ENOTTY;
@@ -2345,10 +2539,17 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 
 	vaddr = dma->vaddr + offset;
 
-	if (write)
+	if (write) {
 		*copied = __copy_to_user((void __user *)vaddr, data,
 					 count) ? 0 : count;
-	else
+		if (*copied && iommu->dirty_page_tracking) {
+			unsigned long pgshift =
+				__ffs(vfio_pgsize_bitmap(iommu));
+
+			bitmap_set(dma->bitmap, offset >> pgshift,
+				   *copied >> pgshift);
+		}
+	} else
 		*copied = __copy_from_user(data, (void __user *)vaddr,
 					   count) ? 0 : count;
 	if (kthread)
-- 
2.7.0

