Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090C21C3FF2
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgEDQcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:32:50 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16908 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbgEDQct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:32:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb043310000>; Mon, 04 May 2020 09:30:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 May 2020 09:32:49 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 May 2020 09:32:49 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 May
 2020 16:32:49 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 4 May 2020 16:32:42 +0000
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
Subject: [PATCH Kernel v18 5/7] vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
Date:   Mon, 4 May 2020 21:28:57 +0530
Message-ID: <1588607939-26441-6-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588609841; bh=IydrTVSgWnh96i9/dcLXaGOHfNSfoVwJzRX627HeWms=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=SDPLKd9x8bag9P6bH8mRaYA6FxdtaYfy4AYrx4CqXLd3w1pcDCVOCi0TiwYhorncF
         NZ4e7/k5flASqviDsf3oIEokLFzd4zauO/g1OIWIJsu0v3u4krNvSMmHfmTnIK4bbD
         VX+94yoxmU7M21uMhLEGbZ7Fw4Zf4Dz9twiVcGksm2wQV3XdT7rY8uVTxM54yNXa0J
         fpeXDpJg6z6yX9TZaAKrE8zPpQvtGIOGugcAtmV5+5mSakFGfSP9OoAQ8tJKZporzV
         4F9vuy3pxY/c47IRnR5ChcCBMoN9IUkFP2crQvif0Y/tLpJlLOCYtOl9GdGzW1jIbX
         bqF7YTC4wacTA==
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
size of allocated memory, set page size to be considered for bitmap and
set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 84 +++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h       | 10 +++++
 2 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 01dcb417836f..8b27faf1ec38 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -983,12 +983,14 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
 }
 
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
-			     struct vfio_iommu_type1_dma_unmap *unmap)
+			     struct vfio_iommu_type1_dma_unmap *unmap,
+			     struct vfio_bitmap *bitmap)
 {
 	uint64_t mask;
 	struct vfio_dma *dma, *dma_last = NULL;
 	size_t unmapped = 0;
 	int ret = 0, retries = 0;
+	unsigned long *final_bitmap = NULL, *temp_bitmap = NULL;
 
 	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
 
@@ -1041,6 +1043,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			ret = -EINVAL;
 			goto unlock;
 		}
+
 		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
 		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
 			ret = -EINVAL;
@@ -1048,6 +1051,22 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		}
 	}
 
+	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+	     iommu->dirty_page_tracking) {
+		final_bitmap = kvzalloc(bitmap->size, GFP_KERNEL);
+		if (!final_bitmap) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+
+		temp_bitmap = kvzalloc(bitmap->size, GFP_KERNEL);
+		if (!temp_bitmap) {
+			ret = -ENOMEM;
+			kfree(final_bitmap);
+			goto unlock;
+		}
+	}
+
 	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
 		if (!iommu->v2 && unmap->iova > dma->iova)
 			break;
@@ -1058,6 +1077,24 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
+		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+		     iommu->dirty_page_tracking) {
+			unsigned long pgshift = __ffs(bitmap->pgsize);
+			unsigned int npages = dma->size >> pgshift;
+			unsigned int shift;
+
+			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
+					bitmap->pgsize, (u64 *)temp_bitmap);
+
+			shift = (dma->iova - unmap->iova) >> pgshift;
+			if (shift)
+				bitmap_shift_left(temp_bitmap, temp_bitmap,
+						  shift, npages);
+			bitmap_or(final_bitmap, final_bitmap, temp_bitmap,
+				  shift + npages);
+			memset(temp_bitmap, 0, bitmap->size);
+		}
+
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			struct vfio_iommu_type1_dma_unmap nb_unmap;
 
@@ -1088,6 +1125,16 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 unlock:
+	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+	     iommu->dirty_page_tracking && final_bitmap) {
+		if (copy_to_user((void __user *)bitmap->data, final_bitmap,
+				 bitmap->size))
+			ret = -EFAULT;
+
+		kfree(final_bitmap);
+		kfree(temp_bitmap);
+	}
+
 	mutex_unlock(&iommu->lock);
 
 	/* Report how much was unmapped */
@@ -2419,17 +2466,46 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
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
+			size_t iommu_pgsize =
+				(size_t)1 << __ffs(vfio_pgsize_bitmap(iommu));
+
+			if (unmap.argsz < (minsz + sizeof(bitmap)))
+				return -EINVAL;
+
+			if (copy_from_user(&bitmap,
+					   (void __user *)(arg + minsz),
+					   sizeof(bitmap)))
+				return -EFAULT;
+
+			/* allow only min supported pgsize */
+			if (bitmap.pgsize != iommu_pgsize)
+				return -EINVAL;
+			if (!access_ok((void __user *)bitmap.data, bitmap.size))
+				return -EINVAL;
+
+			pgshift = __ffs(bitmap.pgsize);
+			ret = verify_bitmap_size(unmap.size >> pgshift,
+						 bitmap.size);
+			if (ret)
+				return ret;
+
+		}
+
+		ret = vfio_dma_do_unmap(iommu, &unmap, &bitmap);
 		if (ret)
 			return ret;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5f359c63f5ef..e3cbf8b78623 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1048,12 +1048,22 @@ struct vfio_bitmap {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
+ * before unmapping IO virtual addresses. When this flag is set, user must
+ * provide data[] as structure vfio_bitmap. User must allocate memory to get
+ * bitmap and must set size of allocated memory in vfio_bitmap.size field.
+ * A bit in bitmap represents one page of user provided page size in 'pgsize',
+ * consecutively starting from iova offset. Bit set indicates page at that
+ * offset from iova is dirty. Bitmap of pages in the range of unmapped size is
+ * returned in vfio_bitmap.data
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

