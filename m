Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5CF972C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKLRdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:33:13 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7591 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfKLRdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 12:33:13 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcaeca00000>; Tue, 12 Nov 2019 09:32:16 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 09:33:12 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 09:33:12 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 17:33:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 17:33:11 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Nov 2019 17:33:05 +0000
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
Subject: [PATCH v9 Kernel 4/5] vfio iommu: Implementation of ioctl to get dirty pages bitmap.
Date:   Tue, 12 Nov 2019 22:33:39 +0530
Message-ID: <1573578220-7530-5-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573579936; bh=U7o8nopuwa5svw0kgwL12cP5oHdgEJ1PRVw74v24iMA=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=Oa9jIzdSNDv8nSrjw2gE/HEM5+chCLs5VFmZT1f6pXZk2cFN2f9W961uIXq4C6J9A
         0wbQ+0xoH0eWsgA3rGKkd/gky0UIN++q7AC3MnvsywmVH7DJzmCoyPdKJ/uf4Wue6u
         CDCX1KhJPZulX2UrjHmKmiI+IiztBcspQsdKf+zomDq1oNFRvyiGPBgyiEa/9xKtvs
         r61NvcpH54uToWIdrnMcGwiyNyq2UJptvqwmFsa2K/Vr1zTsnAUp+I22nbw2pWEoNN
         TplD8/9Vf9QAcl4os7DY6lFZGzZXG2iJp4aBxkG2VQgl1zytul1kVTRvgfWiTOhoSi
         EunXiz8XRiqMA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU container maintains list of external pinned pages. Bitmap of pinned
pages for input IO virtual address range is created and returned.
IO virtual address range should be from a single mapping created by
map request. Input bitmap_size is validated by calculating the size of
requested range.
This ioctl returns bitmap of dirty pages, its user space application
responsibility to copy content of dirty pages from source to destination
during migration.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 92 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ada8e6cdb88..ac176e672857 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -850,6 +850,81 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 	return bitmap;
 }
 
+/*
+ * start_iova is the reference from where bitmaping started. This is called
+ * from DMA_UNMAP where start_iova can be different than iova
+ */
+
+static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
+				  size_t size, dma_addr_t start_iova,
+				  unsigned long *bitmap)
+{
+	struct vfio_dma *dma;
+	dma_addr_t temp_iova = iova;
+
+	dma = vfio_find_dma(iommu, iova, size);
+	if (!dma)
+		return -EINVAL;
+
+	/*
+	 * Range should be from a single mapping created by map request.
+	 */
+
+	if ((iova < dma->iova) ||
+	    ((dma->iova + dma->size) < (iova + size)))
+		return -EINVAL;
+
+	while (temp_iova < iova + size) {
+		struct vfio_pfn *vpfn = NULL;
+
+		vpfn = vfio_find_vpfn(dma, temp_iova);
+		if (vpfn)
+			__bitmap_set(bitmap, vpfn->iova - start_iova, 1);
+
+		temp_iova += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+static int verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
+{
+	unsigned long bsize = ALIGN(npages, BITS_PER_LONG) / 8;
+
+	if ((bitmap_size == 0) || (bitmap_size < bsize))
+		return -EINVAL;
+	return 0;
+}
+
+static int vfio_iova_get_dirty_bitmap(struct vfio_iommu *iommu,
+				struct vfio_iommu_type1_dirty_bitmap *range)
+{
+	unsigned long *bitmap;
+	int ret;
+
+	ret = verify_bitmap_size(range->size >> PAGE_SHIFT, range->bitmap_size);
+	if (ret)
+		return ret;
+
+	/* one bit per page */
+	bitmap = bitmap_zalloc(range->size >> PAGE_SHIFT, GFP_KERNEL);
+	if (!bitmap)
+		return -ENOMEM;
+
+	mutex_lock(&iommu->lock);
+	ret = vfio_iova_dirty_bitmap(iommu, range->iova, range->size,
+				     range->iova, bitmap);
+	mutex_unlock(&iommu->lock);
+
+	if (!ret) {
+		if (copy_to_user(range->bitmap, bitmap, range->bitmap_size))
+			ret = -EFAULT;
+	}
+
+	bitmap_free(bitmap);
+	return ret;
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap)
 {
@@ -2297,6 +2372,23 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+	} else if (cmd == VFIO_IOMMU_GET_DIRTY_BITMAP) {
+		struct vfio_iommu_type1_dirty_bitmap range;
+
+		/* Supported for v2 version only */
+		if (!iommu->v2)
+			return -EACCES;
+
+		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
+					bitmap);
+
+		if (copy_from_user(&range, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (range.argsz < minsz)
+			return -EINVAL;
+
+		return vfio_iova_get_dirty_bitmap(iommu, &range);
 	}
 
 	return -ENOTTY;
-- 
2.7.0

