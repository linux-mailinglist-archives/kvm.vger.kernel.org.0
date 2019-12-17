Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7871233B9
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfLQRjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 12:39:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11840 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfLQRjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 12:39:53 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df912df0000>; Tue, 17 Dec 2019 09:39:43 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 17 Dec 2019 09:39:52 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 17 Dec 2019 09:39:52 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 17:39:52 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Dec 2019 17:39:45 +0000
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
Subject: [PATCH v11 Kernel 2/6] vfio iommu: Add ioctl definition for dirty pages tracking.
Date:   Tue, 17 Dec 2019 22:40:47 +0530
Message-ID: <1576602651-15430-3-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576604383; bh=Y7ec53IcGD4zcnvo82N9DW1lEyMmknttTvvdgtYF6eY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=XmmXOTHza0I3A7M92DGGBDPTAiijyH4b3PtWvzx6LN4FAkplgwuxEv/34DZMEGJPE
         FJdk/9s4dpOJp9EFlm0/as/N3jNOHhAdG9PxgZWG7SG9ycOfodVBOs9gVSUMqqKhRG
         9DhzHPxngovCyiUJwhw/BAdW8/i2K683VQ90okFApxf544bHEQ9l8fkrEoihnlL5qB
         zbnm5SD9ykykg3RlC4tq4xzWAAln4TBLcmH77Srugc0L6BPb6z+ivSpyN/g+1MDNXP
         85asmmCdCFA+kK88/051bY1/KyOCGeQp/58HZiQra+Q3dsJPaxEcHo/D8CjIbi0f6h
         8JvcxeoAP66YA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
All pages pinned by vendor driver through this API should be considered as
dirty during migration. When container consists of IOMMU capable device and
all pages are pinned and mapped, then all pages are marked dirty.
Added support to start/stop unpinned pages tracking and to get bitmap of
all dirtied pages for requested IO virtual address range. Unpinned page
tracking is cleared either when bitmap is read by user application or
unpinned page tracking is stopped.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 include/uapi/linux/vfio.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index b7ac8f7c0d3c..8268634e7e08 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -981,6 +981,49 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
+ *                                     struct vfio_iommu_type1_dirty_bitmap)
+ * IOCTL is used for dirty pages tracking. Caller sets argsz, which is size of
+ * struct vfio_iommu_type1_dirty_bitmap. Caller set flag depend on which
+ * operation to perform, details as below:
+ *
+ * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_START set, indicates
+ * migration is active and IOMMU module should track pages which are being
+ * unpinned. Unpinned pages are tracked until bitmap for that range is queried
+ * or tracking is stopped by user application by setting
+ * VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
+ *
+ * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP set, indicates
+ * IOMMU should stop tracking unpinned pages and also free previously tracked
+ * unpinned pages data.
+ *
+ * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
+ * IOCTL returns dirty pages bitmap for IOMMU container during migration for
+ * given IOVA range. User must allocate memory to get bitmap, zero the bitmap
+ * memory and set size of allocated memory in bitmap_size field. One bit is
+ * used to represent one page consecutively starting from iova offset. User
+ * should provide page size in 'pgsize'. Bit set in bitmap indicates page at
+ * that offset from iova is dirty.
+ *
+ * Only one flag should be set at a time.
+ *
+ */
+struct vfio_iommu_type1_dirty_bitmap {
+	__u32        argsz;
+	__u32        flags;
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_START	(1 << 0)
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP	(1 << 1)
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP	(1 << 2)
+	__u64        iova;		/* IO virtual address */
+	__u64        size;		/* Size of iova range */
+	__u64	     pgsize;		/* page size for bitmap */
+	__u64        bitmap_size;	/* in bytes */
+	void __user *bitmap;		/* one bit per page */
+};
+
+#define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.0

