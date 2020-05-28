Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359F61E6D1F
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 23:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407529AbgE1VFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 17:05:02 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7022 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407505AbgE1VE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 17:04:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed0276c0000>; Thu, 28 May 2020 14:04:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 May 2020 14:04:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 May 2020 14:04:56 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 May
 2020 21:04:51 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 28 May 2020 21:04:44 +0000
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
Subject: [PATCH Kernel v24 6/8] vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
Date:   Fri, 29 May 2020 02:00:52 +0530
Message-ID: <1590697854-21364-7-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590699884; bh=GASCDVmPUI2UJ0LTQX2Bb9UU2p3QzvTbaLujBq3OiZ8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=qVC1YFoYYWNdl2ZREoYija+4mUL1getQZW/lRJ2/qcoVEK5+8wRRYicmtSsLSgP/x
         Ql/wfT+ooRXT58wP9Ui4oo6GYDurddC/qf7Res8dSPltKYoZ3mxDkz65O/vJOfnMTH
         2Y1x7bqjTuWuT3oDtvb/7qZXtThlCKoFbd+5MdEzrwMK1x8RxbNqynNC+WKO0wWXdM
         6LXPogJgOWZ5U2Vg1BhvrP0XbHPco6P+UtYtO78creWZV87xePE1adweLfXphOktoA
         gNKV2iZ2IPdHqcJ3eBLwbFuw+WL40DC1ZuPOnRQPzSEkTOI53Ql/BG/fOQR7wqpZlZ
         x4C8D7OV6/ZaA==
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 61 +++++++++++++++++++++++++++++++++--------
 include/uapi/linux/vfio.h       | 11 ++++++++
 2 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 057614c90900..1c240d47d681 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1049,23 +1049,25 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
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
@@ -1076,9 +1078,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1159,6 +1167,14 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -2497,17 +2513,40 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
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
index 009a8c80079d..ff4b6706f7df 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1048,12 +1048,23 @@ struct vfio_bitmap {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
+ * before unmapping IO virtual addresses. When this flag is set, the user must
+ * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
+ * memory via vfio_bitmap.data and its size in the vfio_bitmap.size field.
+ * A bit in the bitmap represents one page, of user provided page size in
+ * vfio_bitmap.pgsize field, consecutively starting from iova offset. Bit set
+ * indicates that the page at that offset from iova is dirty. A Bitmap of the
+ * pages in the range of unmapped size is returned in the user-provided
+ * vfio_bitmap.data.
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

