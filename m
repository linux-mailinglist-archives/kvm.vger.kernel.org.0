Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6C818C1C5
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 21:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCSUut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 16:50:49 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16464 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbgCSUus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 16:50:48 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e73db1a0000>; Thu, 19 Mar 2020 13:50:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 19 Mar 2020 13:50:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 19 Mar 2020 13:50:47 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Mar
 2020 20:50:47 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 19 Mar 2020 20:50:41 +0000
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
Subject: [PATCH v15 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
Date:   Fri, 20 Mar 2020 01:46:42 +0530
Message-ID: <1584649004-8285-6-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584651035; bh=MOsbTOYhqV35rmjXEgH3UV2bzrMBXZJ/IwUsOwjoOIM=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=C+VejKklxiIYCGPxcTyBC76I1hx7tk46loxtS35knpuig+ZUYG3u3ixJqXj0mBZU6
         4VZhBV7Un9T2CYbATK1iR+Uz0eDg5nemBMwPt7dxohTWFh7b6judRRIyxNbzoD5oiZ
         CrSsWQQP2I4A72JbpFx1w3ZWj4cbnFbCu0vq9283aNcMaqnAL//saekdMMByR3R3gU
         cwbP1HtJAG20N4V5yc5Xf1aXARgNMeuV+/7splrnjAGGcqzc9NHGtquptpmKOuNKFS
         8B1o4fJyHcexJ0tHpy1fR/XTqF+R1a3L76CBb8caCON58ePIV54ubzY4+UpiIuXtgR
         3WfN7DKN+v6ZA==
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
 drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/vfio.h       | 10 ++++++++
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 239f61764d03..e79c1ff6fb41 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -962,7 +962,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
 }
 
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
-			     struct vfio_iommu_type1_dma_unmap *unmap)
+			     struct vfio_iommu_type1_dma_unmap *unmap,
+			     struct vfio_bitmap *bitmap)
 {
 	uint64_t mask;
 	struct vfio_dma *dma, *dma_last = NULL;
@@ -1013,6 +1014,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	 * will be returned if these conditions are not met.  The v2 interface
 	 * will only return success and a size of zero if there were no
 	 * mappings within the range.
+	 *
+	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
+	 * must be for single mapping. Multiple mappings with this flag set is
+	 * not supported.
 	 */
 	if (iommu->v2) {
 		dma = vfio_find_dma(iommu, unmap->iova, 1);
@@ -1020,6 +1025,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			ret = -EINVAL;
 			goto unlock;
 		}
+
+		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+
 		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
 		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
 			ret = -EINVAL;
@@ -1037,6 +1049,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
+		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+		     iommu->dirty_page_tracking)
+			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
+						bitmap->pgsize, bitmap->data);
+
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			struct vfio_iommu_type1_dma_unmap nb_unmap;
 
@@ -2398,17 +2415,46 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
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
+			uint64_t iommu_pgsize =
+					 1 << __ffs(vfio_pgsize_bitmap(iommu));
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
index 8138f94cac15..2780a5742c04 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1010,12 +1010,22 @@ struct vfio_bitmap {
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

