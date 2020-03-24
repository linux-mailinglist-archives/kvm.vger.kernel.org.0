Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0FB191A7C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 21:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgCXUG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 16:06:29 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5439 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgCXUG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 16:06:28 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7a68160001>; Tue, 24 Mar 2020 13:05:43 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 24 Mar 2020 13:06:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 24 Mar 2020 13:06:27 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 20:06:27 +0000
Received: from kwankhede-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 24 Mar 2020 20:06:21 +0000
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
Subject: [PATCH v16 Kernel 3/7] vfio iommu: Add ioctl definition for dirty pages tracking.
Date:   Wed, 25 Mar 2020 01:02:35 +0530
Message-ID: <1585078359-20124-4-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585080343; bh=BrPeI7sQjxK91okpQbGqSXZjZtwv0h6W3KiI5+LGiM8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=NZD0BG2jSPqRDuA6EjjiLawkXbsYJw8xyHD84YpCaf1wkqwWtM2fsJZItePA1EP7K
         UbZX9eVzZmK8N49CQ3CbdhNl9CcTXjIT1SJtskugpeiyiD+bWN05ILioJ4BedPbhTb
         1sliSvvjh6SptLhgiFpjig5/vJ3U8CMKvtnD0E88GusrJZWdSXMWJFNb5z9qbYyQGM
         7H+TEYGL7fUISf3kP47A6RSP2iOUmxqOS3wsBKt1ql1raIO043K9nTEJt2HNJ9zs/F
         rXWsc5HURGxw3FZ8XLLWrAqUUfPzXEOJnuiVrAcFrEr+0nhbGiGldZ5xJXMaOwApWa
         RdFApLIoTXJMw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
All pages pinned by vendor driver through this API should be considered as
dirty during migration. When container consists of IOMMU capable device and
all pages are pinned and mapped, then all pages are marked dirty.
Added support to start/stop dirtied pages tracking and to get bitmap of all
dirtied pages for requested IO virtual address range.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 include/uapi/linux/vfio.h | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8641e022c3b0..0018721fb744 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -996,6 +996,12 @@ struct vfio_iommu_type1_dma_map {
 
 #define VFIO_IOMMU_MAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 13)
 
+struct vfio_bitmap {
+	__u64        pgsize;	/* page size for bitmap in bytes */
+	__u64        size;	/* in bytes */
+	__u64 __user *data;	/* one bit per page */
+};
+
 /**
  * VFIO_IOMMU_UNMAP_DMA - _IOWR(VFIO_TYPE, VFIO_BASE + 14,
  *							struct vfio_dma_unmap)
@@ -1022,6 +1028,56 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
+ *                                     struct vfio_iommu_type1_dirty_bitmap)
+ * IOCTL is used for dirty pages tracking.
+ * Caller should set flag depending on which operation to perform, details as
+ * below:
+ *
+ * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_START set, indicates
+ * migration is active and IOMMU module should track pages which are dirtied or
+ * potentially dirtied by device.
+ * Dirty pages are tracked until tracking is stopped by user application by
+ * setting VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
+ *
+ * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP set, indicates
+ * IOMMU should stop tracking dirtied pages.
+ *
+ * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
+ * IOCTL returns dirty pages bitmap for IOMMU container during migration for
+ * given IOVA range. User must provide data[] as the structure
+ * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range and
+ * pgsize. IOVA range must match to that used in original mapping call. This
+ * interface supports to get bitmap of smallest supported pgsize only and can
+ * be modified in future to get bitmap of specified pgsize.
+ * User must allocate memory for bitmap and set size of allocated memory in
+ * bitmap.size field. One bit is used to represent one page consecutively
+ * starting from iova offset. User should provide page size in bitmap.pgsize
+ * field. Bit set in bitmap indicates page at that offset from iova is
+ * dirty. Caller must set argsz including size of structure
+ * vfio_iommu_type1_dirty_bitmap_get.
+ *
+ * Only one of the flags _START, STOP and _GET may be specified at a time.
+ *
+ */
+struct vfio_iommu_type1_dirty_bitmap {
+	__u32        argsz;
+	__u32        flags;
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_START	(1 << 0)
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP	(1 << 1)
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP	(1 << 2)
+	__u8         data[];
+};
+
+struct vfio_iommu_type1_dirty_bitmap_get {
+	__u64              iova;	/* IO virtual address */
+	__u64              size;	/* Size of iova range */
+	struct vfio_bitmap bitmap;
+};
+
+#define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.0

