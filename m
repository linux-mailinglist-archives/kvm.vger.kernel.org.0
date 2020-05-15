Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0B1D5BC9
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEOVrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 17:47:17 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17722 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgEOVrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 17:47:16 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebf0d980000>; Fri, 15 May 2020 14:46:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 15 May 2020 14:47:16 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 15 May 2020 14:47:16 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 May
 2020 21:47:16 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 May 2020 21:47:09 +0000
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
Subject: [PATCH Kernel v21 6/8] vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
Date:   Sat, 16 May 2020 02:43:21 +0530
Message-ID: <1589577203-20640-7-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589577203-20640-1-git-send-email-kwankhede@nvidia.com>
References: <1589577203-20640-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589579160; bh=cnD0sJD2OYs6r8f7XYx+hRjDaf2I1KczvL40aVcttHQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=WRj1/cJSdL7Og4f+ZyYR+Vk89R6IEYu/3PrewZmWx46Tgwk3noC91+xB0W3E65UM/
         vAz81VlIC/p7TYdmAv0HO8R7GtKNgEfqcHag8sJAvkxWhUt8O0b5FRM8/Vd+HSpXR7
         ktmV6as0V3jvR4D/J0JFBI4zXV/RGHPQEFW2/vgBKpy4/TQUmHmB/Nb3g4qMjEKUUi
         kI6HoiAsKv8kK/wB732a9CCAdsD14kCY4kRlt5ltl7oz3gJzZro5J2by85q+DPxZRS
         9PrTOzcnqBAf0uB20AUZsv7VKzOOuKTBrZB757M9S5b9xMt4itwYdKVMUmuMtRBP4v
         JGCY5P9m8omIw==
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
 drivers/vfio/vfio_iommu_type1.c | 68 +++++++++++++++++++++++++++++++++--------
 include/uapi/linux/vfio.h       | 10 ++++++
 2 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8b8fe171f4c2..d687794c721c 100644
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
 
@@ -1011,23 +1015,25 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
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
@@ -1038,9 +1044,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1078,6 +1090,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			ret = -EINVAL;
 			goto unlock;
 		}
+
 		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
 		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
 			ret = -EINVAL;
@@ -1121,6 +1134,14 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			mutex_lock(&iommu->lock);
 			goto again;
 		}
+
+		if (unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
+			ret = update_user_bitmap(bitmap->data, dma,
+						 unmap->iova, pgsize);
+			if (ret)
+				break;
+		}
+
 		unmapped += dma->size;
 		vfio_remove_dma(iommu, dma);
 	}
@@ -2459,17 +2480,40 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
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
index 4850c1fef1f8..a1dd2150971e 100644
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

