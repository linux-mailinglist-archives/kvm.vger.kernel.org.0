Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487D51DBD1B
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 20:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgETSl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 14:41:57 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1916 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgETSl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 14:41:57 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec579e80001>; Wed, 20 May 2020 11:41:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 20 May 2020 11:41:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 20 May 2020 11:41:56 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 May
 2020 18:41:56 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 20 May 2020 18:41:49 +0000
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
        "Kirti Wankhede" <kwankhede@nvidia.com>
Subject: [PATCH Kernel v23 5/8] vfio iommu: Implementation of ioctl for dirty pages tracking
Date:   Wed, 20 May 2020 23:38:05 +0530
Message-ID: <1589998088-3250-6-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589998088-3250-1-git-send-email-kwankhede@nvidia.com>
References: <1589998088-3250-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590000104; bh=9uGOo2irusNkHS2pEWa02PBpHW4Fwr+U6Got5ap3rRY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=A7301Y9SRloVcmsN6NIlUETGTFgUnCDqR8BV2MX0x/KCArc7UWKu+Xd6B47GF665W
         UasjsX/03FrZroNMKZfuLVtbqGNvhscFEQOGNqigFgd0zNuLjz1JIQTj/b8w+B/FzM
         81x4Rx3cm6kZR9/buum6TOVvKmcfv9SWjulrlVlv/fytJIAwSbZfn6SviaIOFdwICf
         li/eCOSTXb7sj3OX/BuPz+NfLNpEHy1hq5uFiYtAQdUtz7CAa9Z38hK83qDWH4moVP
         tBu2hgMMUlNsl4ciQqGCd29J+0G10pJ7/h2VOQsXZ/GsM584mp4LVhpyPJIY19b8YC
         6tKIf24kq/L8w==
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

Fixed error reported by build bot by changing pgsize type from uint64_t
to size_t.
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 313 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 307 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index d41bc7557adb..aa535c84d2e6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,6 +72,7 @@ struct vfio_iommu {
 	uint64_t		pgsize_bitmap;
 	bool			v2;
 	bool			nesting;
+	bool			dirty_page_tracking;
 };
 
 struct vfio_domain {
@@ -92,6 +93,7 @@ struct vfio_dma {
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
+	unsigned long		*bitmap;
 };
 
 struct vfio_group {
@@ -126,6 +128,19 @@ struct vfio_regions {
 #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
 					(!list_empty(&iommu->domain_list))
 
+#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
+
+/*
+ * Input argument of number of bits to bitmap_set() is unsigned integer, which
+ * further casts to signed integer for unaligned multi-bit operation,
+ * __bitmap_set().
+ * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
+ * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
+ * system.
+ */
+#define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
+#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
+
 static int put_pfn(unsigned long pfn, int prot);
 
 /*
@@ -176,6 +191,80 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
 	rb_erase(&old->node, &iommu->dma_list);
 }
 
+
+static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
+{
+	uint64_t npages = dma->size / pgsize;
+
+	if (npages > DIRTY_BITMAP_PAGES_MAX)
+		return -EINVAL;
+
+	/*
+	 * Allocate extra 64 bits that are used to calculate shift required for
+	 * bitmap_shift_left() to manipulate and club unaligned number of pages
+	 * in adjacent vfio_dma ranges.
+	 */
+	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages) + sizeof(u64),
+			       GFP_KERNEL);
+	if (!dma->bitmap)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void vfio_dma_bitmap_free(struct vfio_dma *dma)
+{
+	kfree(dma->bitmap);
+	dma->bitmap = NULL;
+}
+
+static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
+{
+	struct rb_node *p;
+
+	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
+		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
+
+		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
+	}
+}
+
+static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
+{
+	struct rb_node *n;
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+		int ret;
+
+		ret = vfio_dma_bitmap_alloc(dma, pgsize);
+		if (ret) {
+			struct rb_node *p;
+
+			for (p = rb_prev(n); p; p = rb_prev(p)) {
+				struct vfio_dma *dma = rb_entry(n,
+							struct vfio_dma, node);
+
+				vfio_dma_bitmap_free(dma);
+			}
+			return ret;
+		}
+		vfio_dma_populate_bitmap(dma, pgsize);
+	}
+	return 0;
+}
+
+static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
+{
+	struct rb_node *n;
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		vfio_dma_bitmap_free(dma);
+	}
+}
+
 /*
  * Helper Functions for host iova-pfn list
  */
@@ -568,6 +657,17 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			vfio_unpin_page_external(dma, iova, do_accounting);
 			goto pin_unwind;
 		}
+
+		if (iommu->dirty_page_tracking) {
+			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
+
+			/*
+			 * Bitmap populated with the smallest supported page
+			 * size
+			 */
+			bitmap_set(dma->bitmap,
+				   (iova - dma->iova) >> pgshift, 1);
+		}
 	}
 
 	ret = i;
@@ -802,6 +902,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	vfio_dma_bitmap_free(dma);
 	kfree(dma);
 	iommu->dma_avail++;
 }
@@ -829,6 +930,93 @@ static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
 	}
 }
 
+static int update_user_bitmap(u64 __user *bitmap, struct vfio_dma *dma,
+			      dma_addr_t base_iova, size_t pgsize)
+{
+	unsigned long pgshift = __ffs(pgsize);
+	unsigned long nbits = dma->size >> pgshift;
+	unsigned long bit_offset = (dma->iova - base_iova) >> pgshift;
+	unsigned long copy_offset = bit_offset / BITS_PER_LONG;
+	unsigned long shift = bit_offset % BITS_PER_LONG;
+	unsigned long leftover;
+
+	/* mark all pages dirty if all pages are pinned and mapped. */
+	if (dma->iommu_mapped)
+		bitmap_set(dma->bitmap, 0, nbits);
+
+	if (shift) {
+		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
+				  nbits + shift);
+
+		if (copy_from_user(&leftover, (u64 *)bitmap + copy_offset,
+				   sizeof(leftover)))
+			return -EFAULT;
+
+		bitmap_or(dma->bitmap, dma->bitmap, &leftover, shift);
+	}
+
+	if (copy_to_user((u64 *)bitmap + copy_offset, dma->bitmap,
+			 DIRTY_BITMAP_BYTES(nbits + shift)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
+				  dma_addr_t iova, size_t size, size_t pgsize)
+{
+	struct vfio_dma *dma;
+	struct rb_node *n;
+	unsigned long pgshift = __ffs(pgsize);
+	int ret;
+
+	/*
+	 * GET_BITMAP request must fully cover vfio_dma mappings.  Multiple
+	 * vfio_dma mappings may be clubbed by specifying large ranges, but
+	 * there must not be any previous mappings bisected by the range.
+	 * An error will be returned if these conditions are not met.
+	 */
+	dma = vfio_find_dma(iommu, iova, 1);
+	if (dma && dma->iova != iova)
+		return -EINVAL;
+
+	dma = vfio_find_dma(iommu, iova + size - 1, 0);
+	if (dma && dma->iova + dma->size != iova + size)
+		return -EINVAL;
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		if (dma->iova < iova)
+			continue;
+
+		if (dma->iova > iova + size - 1)
+			break;
+
+		ret = update_user_bitmap(bitmap, dma, iova, pgsize);
+		if (ret)
+			return ret;
+
+		/*
+		 * Re-populate bitmap to include all pinned pages which are
+		 * considered as dirty but exclude pages which are unpinned and
+		 * pages which are marked dirty by vfio_dma_rw()
+		 */
+		bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
+		vfio_dma_populate_bitmap(dma, pgsize);
+	}
+	return 0;
+}
+
+static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
+{
+	if (!npages || !bitmap_size || (bitmap_size > DIRTY_BITMAP_SIZE_MAX) ||
+	    (bitmap_size < DIRTY_BITMAP_BYTES(npages)))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap)
 {
@@ -1046,7 +1234,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	unsigned long vaddr = map->vaddr;
 	size_t size = map->size;
 	int ret = 0, prot = 0;
-	uint64_t mask;
+	size_t pgsize;
 	struct vfio_dma *dma;
 
 	/* Verify that none of our __u64 fields overflow */
@@ -1061,11 +1249,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
-	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
+	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
 
-	WARN_ON(mask & PAGE_MASK);
+	WARN_ON((pgsize - 1) & PAGE_MASK);
 
-	if (!prot || !size || (size | iova | vaddr) & mask) {
+	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1142,6 +1330,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	else
 		ret = vfio_pin_map_dma(iommu, dma, size);
 
+	if (!ret && iommu->dirty_page_tracking) {
+		ret = vfio_dma_bitmap_alloc(dma, pgsize);
+		if (ret)
+			vfio_remove_dma(iommu, dma);
+	}
+
 out_unlock:
 	mutex_unlock(&iommu->lock);
 	return ret;
@@ -2288,6 +2482,104 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
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
+			size_t pgsize;
+
+			mutex_lock(&iommu->lock);
+			pgsize = 1 << __ffs(iommu->pgsize_bitmap);
+			if (!iommu->dirty_page_tracking) {
+				ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
+				if (!ret)
+					iommu->dirty_page_tracking = true;
+			}
+			mutex_unlock(&iommu->lock);
+			return ret;
+		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
+			mutex_lock(&iommu->lock);
+			if (iommu->dirty_page_tracking) {
+				iommu->dirty_page_tracking = false;
+				vfio_dma_bitmap_free_all(iommu);
+			}
+			mutex_unlock(&iommu->lock);
+			return 0;
+		} else if (dirty.flags &
+				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
+			struct vfio_iommu_type1_dirty_bitmap_get range;
+			unsigned long pgshift;
+			size_t data_size = dirty.argsz - minsz;
+			size_t iommu_pgsize;
+
+			if (!data_size || data_size < sizeof(range))
+				return -EINVAL;
+
+			if (copy_from_user(&range, (void __user *)(arg + minsz),
+					   sizeof(range)))
+				return -EFAULT;
+
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
+
+			iommu_pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
+
+			/* allow only smallest supported pgsize */
+			if (range.bitmap.pgsize != iommu_pgsize) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
+			if (range.iova & (iommu_pgsize - 1)) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
+			if (!range.size || range.size & (iommu_pgsize - 1)) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
+
+			if (iommu->dirty_page_tracking)
+				ret = vfio_iova_dirty_bitmap(range.bitmap.data,
+						iommu, range.iova, range.size,
+						range.bitmap.pgsize);
+			else
+				ret = -EINVAL;
+out_unlock:
+			mutex_unlock(&iommu->lock);
+
+			return ret;
+		}
 	}
 
 	return -ENOTTY;
@@ -2355,10 +2647,19 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 
 	vaddr = dma->vaddr + offset;
 
-	if (write)
+	if (write) {
 		*copied = copy_to_user((void __user *)vaddr, data,
 					 count) ? 0 : count;
-	else
+		if (*copied && iommu->dirty_page_tracking) {
+			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
+			/*
+			 * Bitmap populated with the smallest supported page
+			 * size
+			 */
+			bitmap_set(dma->bitmap, offset >> pgshift,
+				   *copied >> pgshift);
+		}
+	} else
 		*copied = copy_from_user(data, (void __user *)vaddr,
 					   count) ? 0 : count;
 	if (kthread)
-- 
2.7.0

