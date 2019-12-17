Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB491233BC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfLQRkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 12:40:08 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13184 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfLQRkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 12:40:07 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df912da0001>; Tue, 17 Dec 2019 09:39:38 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 17 Dec 2019 09:40:06 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 17 Dec 2019 09:40:06 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 17:40:06 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Dec 2019 17:39:59 +0000
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
Subject: [PATCH v11 Kernel 4/6] vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
Date:   Tue, 17 Dec 2019 22:40:49 +0530
Message-ID: <1576602651-15430-5-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576604379; bh=2nMmRAaeH0WSsVoEecdWNddlInLw13rMje59Myo1b2U=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=d2A2YA8hbAtlWBG+5ogsn1ob7VoFncErN7DhNyrnfCbA3HbNEN4i2WY0xFnVBVETR
         22sHsgUISiaj/g8KJdwIISixWYsn2LDvfEmAMJhgBbJPd3/iaJCBFZYzVcAOXPAKwo
         z9PZSDvVENuClSsUDdlTInYfIGR2d0gjOQ8nuFhQ3KjdQss448ESYwwht5ezsMd9ja
         B/3ti8uRxU/eeYStINGjPECtOt/dPLBa3s+pFop7ILnZw2CEqPnfCZf0y3IN+T4snJ
         pJTg8wZ+Dsp4Twe45jmcV1ftSz64KB5O1iiVd5YVDjaRMkBDcqhvSskmPiJVNfM8sK
         j6bxLGlyazLoA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pages, pinned by external interface for requested IO virtual address
range,  might get unpinned  and unmapped while migration is active and
device is still running, that is, in pre-copy phase while guest driver
still could access those pages. Host device can write to these pages while
those were mapped. Such pages should be marked dirty so that after
migration guest driver should still be able to complete the operation.

To get bitmap during unmap, user should set flag
VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated and
zeroed by user space application. Bitmap size and page size should be set
by user application.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 63 ++++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/vfio.h       | 12 ++++++++
 2 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 215aecb25453..101c2b1e72b4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -974,7 +974,8 @@ static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
 }
 
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
-			     struct vfio_iommu_type1_dma_unmap *unmap)
+			     struct vfio_iommu_type1_dma_unmap *unmap,
+			     unsigned long *bitmap)
 {
 	uint64_t mask;
 	struct vfio_dma *dma, *dma_last = NULL;
@@ -1049,6 +1050,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
+		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+		    (dma_last != dma))
+			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
+					     unmap->bitmap_pgsize, unmap->iova,
+					     bitmap);
+		else
+			vfio_remove_unpinned_from_pfn_list(dma, true);
+
+
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			struct vfio_iommu_type1_dma_unmap nb_unmap;
 
@@ -1074,6 +1084,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 						    &nb_unmap);
 			goto again;
 		}
+
 		unmapped += dma->size;
 		vfio_remove_dma(iommu, dma);
 	}
@@ -2404,22 +2415,60 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
 		struct vfio_iommu_type1_dma_unmap unmap;
-		long ret;
+		unsigned long *bitmap = NULL;
+		long ret, bsize;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
 
-		if (copy_from_user(&unmap, (void __user *)arg, minsz))
+		if (copy_from_user(&unmap, (void __user *)arg, sizeof(unmap)))
 			return -EFAULT;
 
-		if (unmap.argsz < minsz || unmap.flags)
+		if (unmap.argsz < minsz ||
+		    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
 			return -EINVAL;
 
-		ret = vfio_dma_do_unmap(iommu, &unmap);
+		if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
+			unsigned long pgshift = __ffs(unmap.bitmap_pgsize);
+			uint64_t iommu_pgmask =
+			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
+
+			if (((unmap.bitmap_pgsize - 1) & iommu_pgmask) !=
+			     (unmap.bitmap_pgsize - 1))
+				return -EINVAL;
+
+			bsize = verify_bitmap_size(unmap.size >> pgshift,
+						   unmap.bitmap_size);
+			if (bsize < 0)
+				return bsize;
+
+			bitmap = kmalloc(bsize, GFP_KERNEL);
+			if (!bitmap)
+				return -ENOMEM;
+
+			if (copy_from_user(bitmap, (void __user *)unmap.bitmap,
+					   bsize)) {
+				ret = -EFAULT;
+				goto unmap_exit;
+			}
+		}
+
+		ret = vfio_dma_do_unmap(iommu, &unmap, bitmap);
 		if (ret)
-			return ret;
+			goto unmap_exit;
 
-		return copy_to_user((void __user *)arg, &unmap, minsz) ?
+		if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
+			if (copy_to_user((void __user *)unmap.bitmap, bitmap,
+					  bsize)) {
+				ret = -EFAULT;
+				goto unmap_exit;
+			}
+		}
+
+		ret = copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+unmap_exit:
+		kfree(bitmap);
+		return ret;
 	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
 		struct vfio_iommu_type1_dirty_bitmap range;
 		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8268634e7e08..e8e044c4974d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -964,12 +964,24 @@ struct vfio_iommu_type1_dma_map {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
+ * before unmapping IO virtual addresses. When this flag is set, user should
+ * allocate memory to get bitmap, clear the bitmap memory by setting zero and
+ * should set size of allocated memory in bitmap_size field. One bit in bitmap
+ * represents per page , page of user provided page size in 'bitmap_pgsize',
+ * consecutively starting from iova offset. Bit set indicates page at that
+ * offset from iova is dirty. Bitmap of pages in the range of unmapped size is
+ * returned in bitmap.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
+	__u64        bitmap_pgsize;		/* page size for bitmap */
+	__u64        bitmap_size;               /* in bytes */
+	void __user *bitmap;                    /* one bit per page */
 };
 
 #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
-- 
2.7.0

