Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908A81D5BC7
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 23:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgEOVrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 17:47:03 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17687 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgEOVrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 17:47:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebf0d8a0000>; Fri, 15 May 2020 14:45:46 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 15 May 2020 14:47:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 15 May 2020 14:47:02 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 May
 2020 21:47:02 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 May 2020 21:46:55 +0000
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
Subject: [PATCH Kernel v21 4/8] vfio iommu: Add ioctl definition for dirty pages tracking
Date:   Sat, 16 May 2020 02:43:19 +0530
Message-ID: <1589577203-20640-5-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589577203-20640-1-git-send-email-kwankhede@nvidia.com>
References: <1589577203-20640-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589579146; bh=LmRuj9HLht4qxGnuBJiCNy2AAHfKyJHNRvke0GVSok8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=knucKiypFOcxMUferycBem0BUMfo9bSYnlt4kz9UwnI1jiNoXUc5wh9laaMIN53wK
         OQ44ZFiUwGtk9LXSjGkBVsWC2EU53bj3RNBHxA9tz09kRWcPWNsC72gHMlHyV89HZj
         Cmwsj+zZ5RH0IH5Vk4Ts7yt7UdfEnsHJWIccS3ZKvHBttiSAUHXeWpz6YQVYBwrVpp
         zhSudv4yQ8RTbaRlI4bBmxUICzeifxBr69bEVBlTNCv47PCxTkeW+F69ny1TuKkaA3
         CJ2n1/T7NojoHlhR8EC7wBsT/ZPEddyPQGCFtkH1a5w9zVtyQe0VBy/XUBZLYe/2Ta
         0SrUPxZ597m+g==
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
 include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ad9bb5af3463..4850c1fef1f8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1033,6 +1033,12 @@ struct vfio_iommu_type1_dma_map {
 
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
@@ -1059,6 +1065,55 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
+ *                                     struct vfio_iommu_type1_dirty_bitmap)
+ * IOCTL is used for dirty pages tracking.
+ * Caller should set flag depending on which operation to perform, details as
+ * below:
+ *
+ * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_START flag set, instructs
+ * the IOMMU driver to track pages that are dirtied or potentially dirtied by
+ * device; designed to be used when a migration is in progress. Dirty pages are
+ * tracked until tracking is stopped by user application by calling the IOCTL
+ * with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
+ *
+ * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag set, instructs
+ * the IOMMU driver to stop tracking dirtied pages.
+ *
+ * Calling the  IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set
+ * returns the dirty pages bitmap for IOMMU container for a given IOVA range.
+ * User must specify the IOVA range and the pgsize through the structure
+ * vfio_iommu_type1_dirty_bitmap_get in the data[] portion. This interface
+ * supports to get bitmap of smallest supported pgsize only and can be modified
+ * in future to get bitmap of specified pgsize. The user must provide a zeroed
+ * memory area for the bitmap memory and specify its size in bitmap.size.
+ * One bit is used to represent one page consecutively starting from iova
+ * offset. The user should provide page size in bitmap.pgsize field. A bit set
+ * in the bitmap indicates that the page at that offset from iova is dirty.
+ * The caller must set argsz including size of structure
+ * vfio_iommu_type1_dirty_bitmap_get.
+ *
+ * Only one of the flags _START, _STOP and _GET may be specified at a time.
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

