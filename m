Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B791F9728
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfKLRdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:33:07 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2662 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfKLRdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 12:33:07 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcaecd40000>; Tue, 12 Nov 2019 09:33:08 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 09:33:05 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 09:33:05 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 17:33:05 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Nov 2019 17:32:58 +0000
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
Subject: [PATCH v9 Kernel 3/5] vfio iommu: Add ioctl defination to unmap IOVA and return dirty bitmap
Date:   Tue, 12 Nov 2019 22:33:38 +0530
Message-ID: <1573578220-7530-4-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573579988; bh=ZL8WRUjv2HMqr+5c71mCqu+CqlFsMn0q7XRR6YFy7As=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=O8wySMnJz96tThtn5yOR+jCMWh6qABnnCPWLz3cdiGSOtiliQK4lhmHFp1riF6Kef
         8QWku+dA48Te8BFdge2IUI/gYPfN5QwAottVcUVYvZwd+Ib7tP72A7qFxwFib2e63V
         L0XbPiATETwH/HZpGRj3/iVJVF1UHvXDiXuuQOILWvDhMUSv6iYkQHw/lkTwyaKrL6
         72ndmFYV79GTUNXZUonCHDqLH6ndFyE0S+sEbZLRH3X2zHbEb8n+WCBtGMVk2qHZH8
         oMnAPwTVtNWZ5ZsZ6CrQD1xWwdRUWDM2oEi4HbosTCQvVa4TXt1/7noFylyv3M1Vih
         4ZeDcpe1PK0nQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With vIOMMU, during pre-copy phase of migration, while CPUs are still
running, IO virtual address unmap can happen while device still keeping
reference of guest pfns. Those pages should be reported as dirty before
unmap, so that VFIO user space application can copy content of those pages
from source to destination.

IOCTL defination added here add bitmap pointer, size and flag. If flag
VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set and bitmap memory is allocated
and bitmap_size of set, then ioctl will create bitmap of pinned pages and
then unmap those.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 include/uapi/linux/vfio.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 6fd3822aa610..72fd297baf52 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -925,6 +925,39 @@ struct vfio_iommu_type1_dirty_bitmap {
 
 #define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/**
+ * VFIO_IOMMU_UNMAP_DMA_GET_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
+ *				      struct vfio_iommu_type1_dma_unmap_bitmap)
+ *
+ * Unmap IO virtual addresses using the provided struct
+ * vfio_iommu_type1_dma_unmap_bitmap.  Caller sets argsz.
+ * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
+ * before unmapping IO virtual addresses. If this flag is not set, only IO
+ * virtual address are unmapped without creating pinned pages bitmap, that
+ * is, behave same as VFIO_IOMMU_UNMAP_DMA ioctl.
+ * User should allocate memory to get bitmap and should set size of allocated
+ * memory in bitmap_size field. One bit in bitmap is used to represent per page
+ * consecutively starting from iova offset. Bit set indicates page at that
+ * offset from iova is dirty.
+ * The actual unmapped size is returned in the size field and bitmap of pages
+ * in the range of unmapped size is returned in bitmap if flag
+ * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set.
+ *
+ * No guarantee is made to the user that arbitrary unmaps of iova or size
+ * different from those used in the original mapping call will succeed.
+ */
+struct vfio_iommu_type1_dma_unmap_bitmap {
+	__u32        argsz;
+	__u32        flags;
+#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
+	__u64        iova;                        /* IO virtual address */
+	__u64        size;                        /* Size of mapping (bytes) */
+	__u64        bitmap_size;                 /* in bytes */
+	void __user *bitmap;                      /* one bit per page */
+};
+
+#define VFIO_IOMMU_UNMAP_DMA_GET_BITMAP _IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.0

