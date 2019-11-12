Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEC2F972F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfKLRdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:33:20 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7610 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfKLRdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 12:33:20 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcaeca60000>; Tue, 12 Nov 2019 09:32:22 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 09:33:18 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 09:33:18 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 17:33:18 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Nov 2019 17:33:11 +0000
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
Subject: [PATCH v9 Kernel 5/5] vfio iommu: Implementation of ioctl to get dirty bitmap before unmap
Date:   Tue, 12 Nov 2019 22:33:40 +0530
Message-ID: <1573578220-7530-6-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573579942; bh=b76VG1CtaF0t0W+2xw926JIpF08VPIo1rVi43atlLHw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=HvyAOKaOIfCq27eIY++DpFpn6cLVxF3V9P5LNQc9uHf11GXj1ihxcOK+JmcFRfsNz
         qvqi0Y5BiUG3bMqb3O30JBCjnkRBpCjljKVmo8xzhXzA5TF1XXxsLCCr14DuAoyHfl
         Qo2Dd4hGGU1XLz/cieVBumRSxOb89vDZ0LGD9edGUniATX0P0/9q1juq0UC+DLN8pu
         zXqeqlU5ymQHbnV9/Kw3Y/OcJzWOKlRfE708v93GHAAFVF4tG+gR8Q6gdtU9xdagVl
         PSo1vUk/qp063s+/tkvt5n0jKmsNVHF2ht2VU1NM25ZfCEAIkMylqMnKAUPL3fvm5L
         8o9hcZnmFuIJg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If pages are pinned by external interface for requested IO virtual address
range, bitmap of such pages is created and then that range is unmapped.
To get bitmap during unmap, user should set flag
VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated and
bitmap_size should be set. If flag is not set, then it behaves same as
VFIO_IOMMU_UNMAP_DMA ioctl.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 71 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ac176e672857..d6b988452ba6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -926,7 +926,8 @@ static int vfio_iova_get_dirty_bitmap(struct vfio_iommu *iommu,
 }
 
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
-			     struct vfio_iommu_type1_dma_unmap *unmap)
+			     struct vfio_iommu_type1_dma_unmap *unmap,
+			     unsigned long *bitmap)
 {
 	uint64_t mask;
 	struct vfio_dma *dma, *dma_last = NULL;
@@ -1026,6 +1027,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 						    &nb_unmap);
 			goto again;
 		}
+
+		if (bitmap) {
+			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
+					       unmap->iova, bitmap);
+		}
+
 		unmapped += dma->size;
 		vfio_remove_dma(iommu, dma);
 	}
@@ -1039,6 +1046,43 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_dma_do_unmap_bitmap(struct vfio_iommu *iommu,
+		struct vfio_iommu_type1_dma_unmap_bitmap *unmap_bitmap)
+{
+	struct vfio_iommu_type1_dma_unmap unmap;
+	unsigned long *bitmap = NULL;
+	int ret;
+
+	/* check bitmap size */
+	if ((unmap_bitmap->flags | VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)) {
+		ret = verify_bitmap_size(unmap_bitmap->size >> PAGE_SHIFT,
+					 unmap_bitmap->bitmap_size);
+		if (ret)
+			return ret;
+
+		/* one bit per page */
+		bitmap = bitmap_zalloc(unmap_bitmap->size >> PAGE_SHIFT,
+					GFP_KERNEL);
+		if (!bitmap)
+			return -ENOMEM;
+	}
+
+	unmap.iova = unmap_bitmap->iova;
+	unmap.size = unmap_bitmap->size;
+	ret = vfio_dma_do_unmap(iommu, &unmap, bitmap);
+	if (!ret)
+		unmap_bitmap->size = unmap.size;
+
+	if (bitmap) {
+		if (!ret && copy_to_user(unmap_bitmap->bitmap, bitmap,
+					 unmap_bitmap->bitmap_size))
+			ret = -EFAULT;
+		bitmap_free(bitmap);
+	}
+
+	return ret;
+}
+
 static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 			  unsigned long pfn, long npage, int prot)
 {
@@ -2366,7 +2410,7 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (unmap.argsz < minsz || unmap.flags)
 			return -EINVAL;
 
-		ret = vfio_dma_do_unmap(iommu, &unmap);
+		ret = vfio_dma_do_unmap(iommu, &unmap, NULL);
 		if (ret)
 			return ret;
 
@@ -2389,6 +2433,29 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			return -EINVAL;
 
 		return vfio_iova_get_dirty_bitmap(iommu, &range);
+	} else if (cmd == VFIO_IOMMU_UNMAP_DMA_GET_BITMAP) {
+		struct vfio_iommu_type1_dma_unmap_bitmap unmap_bitmap;
+		long ret;
+
+		/* Supported for v2 version only */
+		if (!iommu->v2)
+			return -EACCES;
+
+		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap_bitmap,
+				    bitmap);
+
+		if (copy_from_user(&unmap_bitmap, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (unmap_bitmap.argsz < minsz)
+			return -EINVAL;
+
+		ret = vfio_dma_do_unmap_bitmap(iommu, &unmap_bitmap);
+		if (ret)
+			return ret;
+
+		return copy_to_user((void __user *)arg, &unmap_bitmap, minsz) ?
+			-EFAULT : 0;
 	}
 
 	return -ENOTTY;
-- 
2.7.0

