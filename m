Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2A71D3FBC
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 23:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgENVLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 17:11:44 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5574 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgENVLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 17:11:44 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebdb4030000>; Thu, 14 May 2020 14:11:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 14 May 2020 14:11:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 14 May 2020 14:11:44 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 May
 2020 21:11:43 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 14 May 2020 21:11:37 +0000
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
Subject: [PATCH Kernel v20 6/8] vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
Date:   Fri, 15 May 2020 02:07:45 +0530
Message-ID: <1589488667-9683-7-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589490692; bh=izB/kfrbOkgeuoTy4WvibQk5KhK5lRPGhMmv3elCpMw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=eMV9NEycBQ1zpD8foR+Y4AibzuuuOydDT555I9rJ027rrAjPx4wPovQ5u8Ct0H73B
         HXBCXOk0p0FMnunTSYcf+w26oqUtU+qv/zprfu7y2gWkORnG5amfz3XibO0MM7Dyn5
         rQ+Exmq61pOeli4gWjWnJOwdJYqrd1DhvMEXvSxx+wUclJd1vYDlz4V0awhrlJ+LIN
         sjXSp3Do5jnHPmg5f/mfXz3c4oQkNwRAh5hspuKp7A4sv4bSA/OybYytYf9LY9Edhx
         SXd6sUitb0JbukPcutRuWY9igjdFkXAoaReeeeOlsE2Nuh5mobZULmwaCw/CSjvDzw
         5MuFd4obrqtfQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DMA mapped pages, including those pinned by mdev vendor drivers, might
get unpinned and unmapped while migration is active and device is still
running. For example, in pre-copy phase while guest driver could access
those pages, host device or vendor driver can dirty these mapped pages.
Such pages should be marked dirty so as to maintain memory consistency
for a user making use of dirty page tracking.

To get bitmap during unmap, user should allocate memory for bitmap, set
it all zeros, set size of allocated memory, set page size to be
considered for bitmap and set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 77 ++++++++++++++++++++++++++++++++++-------
 include/uapi/linux/vfio.h       | 10 ++++++
 2 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b76d3b14abfd..a1dc57bcece5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -195,11 +195,15 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
 static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
 {
 	uint64_t npages = dma->size / pgsize;
+	size_t bitmap_size;
 
 	if (npages > DIRTY_BITMAP_PAGES_MAX)
 		return -EINVAL;
 
-	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
+	/* Allocate extra 64 bits which are used for bitmap manipulation */
+	bitmap_size = DIRTY_BITMAP_BYTES(npages) + sizeof(u64);
+
+	dma->bitmap = kvzalloc(bitmap_size, GFP_KERNEL);
 	if (!dma->bitmap)
 		return -ENOMEM;
 
@@ -999,23 +1003,25 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
 }
 
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
-			     struct vfio_iommu_type1_dma_unmap *unmap)
+			     struct vfio_iommu_type1_dma_unmap *unmap,
+			     struct vfio_bitmap *bitmap)
 {
-	uint64_t mask;
 	struct vfio_dma *dma, *dma_last = NULL;
-	size_t unmapped = 0;
+	size_t unmapped = 0, pgsize;
 	int ret = 0, retries = 0;
+	unsigned long pgshift;
 
 	mutex_lock(&iommu->lock);
 
-	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
+	pgshift = __ffs(iommu->pgsize_bitmap);
+	pgsize = (size_t)1 << pgshift;
 
-	if (unmap->iova & mask) {
+	if (unmap->iova & (pgsize - 1)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
 
-	if (!unmap->size || unmap->size & mask) {
+	if (!unmap->size || unmap->size & (pgsize - 1)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -1026,9 +1032,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		goto unlock;
 	}
 
-	WARN_ON(mask & PAGE_MASK);
-again:
+	/* When dirty tracking is enabled, allow only min supported pgsize */
+	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
+	WARN_ON((pgsize - 1) & PAGE_MASK);
+again:
 	/*
 	 * vfio-iommu-type1 (v1) - User mappings were coalesced together to
 	 * avoid tracking individual mappings.  This means that the granularity
@@ -1066,6 +1078,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			ret = -EINVAL;
 			goto unlock;
 		}
+
 		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
 		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
 			ret = -EINVAL;
@@ -1083,6 +1096,23 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
+		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+		    (dma_last != dma)) {
+
+			/*
+			 * mark all pages dirty if all pages are pinned and
+			 * mapped
+			 */
+			if (dma->iommu_mapped)
+				bitmap_set(dma->bitmap, 0,
+					   dma->size >> pgshift);
+
+			ret = update_user_bitmap(bitmap->data, dma,
+						 unmap->iova, pgsize);
+			if (ret)
+				break;
+		}
+
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			struct vfio_iommu_type1_dma_unmap nb_unmap;
 
@@ -2447,17 +2477,40 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
 		struct vfio_iommu_type1_dma_unmap unmap;
-		long ret;
+		struct vfio_bitmap bitmap = { 0 };
+		int ret;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
 
 		if (copy_from_user(&unmap, (void __user *)arg, minsz))
 			return -EFAULT;
 
-		if (unmap.argsz < minsz || unmap.flags)
+		if (unmap.argsz < minsz ||
+		    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
 			return -EINVAL;
 
-		ret = vfio_dma_do_unmap(iommu, &unmap);
+		if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
+			unsigned long pgshift;
+
+			if (unmap.argsz < (minsz + sizeof(bitmap)))
+				return -EINVAL;
+
+			if (copy_from_user(&bitmap,
+					   (void __user *)(arg + minsz),
+					   sizeof(bitmap)))
+				return -EFAULT;
+
+			if (!access_ok((void __user *)bitmap.data, bitmap.size))
+				return -EINVAL;
+
+			pgshift = __ffs(bitmap.pgsize);
+			ret = verify_bitmap_size(unmap.size >> pgshift,
+						 bitmap.size);
+			if (ret)
+				return ret;
+		}
+
+		ret = vfio_dma_do_unmap(iommu, &unmap, &bitmap);
 		if (ret)
 			return ret;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 123de3bc2dce..0a0c7315ddd6 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1048,12 +1048,22 @@ struct vfio_bitmap {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
+ * before unmapping IO virtual addresses. When this flag is set, user must
+ * provide data[] as structure vfio_bitmap. User must allocate memory to get
+ * bitmap, zero the bitmap memory and must set size of allocated memory in
+ * vfio_bitmap.size field. A bit in bitmap represents one page of user provided
+ * page size in 'pgsize', consecutively starting from iova offset. Bit set
+ * indicates page at that offset from iova is dirty. Bitmap of pages in the
+ * range of unmapped size is returned in vfio_bitmap.data
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
+	__u8    data[];
 };
 
 #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
-- 
2.7.0

