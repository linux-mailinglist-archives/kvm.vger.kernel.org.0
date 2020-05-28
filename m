Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A71E6D2B
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 23:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407520AbgE1VEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 17:04:52 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8900 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407470AbgE1VEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 17:04:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed027120000>; Thu, 28 May 2020 14:03:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 May 2020 14:04:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 May 2020 14:04:45 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 May
 2020 21:04:36 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 28 May 2020 21:04:29 +0000
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
Subject: [PATCH Kernel v24 4/8] vfio iommu: Add ioctl definition for dirty pages tracking
Date:   Fri, 29 May 2020 02:00:50 +0530
Message-ID: <1590697854-21364-5-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590699794; bh=MAdh/taHvkt8ypYvS/kvFQ2uf0sas7Nt+CMV5JYv8dU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=NNGjqDBlB0FfVC0UoHH+ufwiAPU/UNJRCr/ppRwrU8UzhPCN+fHkeQ8zplJ+uk0G3
         WFsbkbONqS2kkeA1n3vShEcoqDwiMtybas7reCeMT2+t+UGapoGst3NGqKvnPWk0gk
         nlnPQ/+OrqQRDECrILfb5+vcZ67uPYMmxZvD3sc5/L+hcShkS5gXxCV5wrth3sqT8I
         hXqaDDcv7YWb00gf5u1s/OvdLE7verRFdzXR2scPmXUpN9RmL5qu26e5STyUQJjqkw
         DoPSU+d2p6SW2n43RPS/VsqrdC/kGBwRYvVu7zGfHUk1+6/LNcncoAg9hkD/+cdKjD
         E5NdJyYUPbJmw==
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/uapi/linux/vfio.h | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ad9bb5af3463..009a8c80079d 100644
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
@@ -1059,6 +1065,57 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
+ *                                     struct vfio_iommu_type1_dirty_bitmap)
+ * IOCTL is used for dirty pages logging.
+ * Caller should set flag depending on which operation to perform, details as
+ * below:
+ *
+ * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_START flag set, instructs
+ * the IOMMU driver to log pages that are dirtied or potentially dirtied by
+ * the device; designed to be used when a migration is in progress. Dirty pages
+ * are logged until logging is disabled by user application by calling the IOCTL
+ * with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
+ *
+ * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag set, instructs
+ * the IOMMU driver to stop logging dirtied pages.
+ *
+ * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set
+ * returns the dirty pages bitmap for IOMMU container for a given IOVA range.
+ * The user must specify the IOVA range and the pgsize through the structure
+ * vfio_iommu_type1_dirty_bitmap_get in the data[] portion. This interface
+ * supports getting a bitmap of the smallest supported pgsize only and can be
+ * modified in future to get a bitmap of any specified supported pgsize. The
+ * user must provide a zeroed memory area for the bitmap memory and specify its
+ * size in bitmap.size. One bit is used to represent one page consecutively
+ * starting from iova offset. The user should provide page size in bitmap.pgsize
+ * field. A bit set in the bitmap indicates that the page at that offset from
+ * iova is dirty. The caller must set argsz to a value including the size of
+ * structure vfio_iommu_type1_dirty_bitmap_get, but excluding the size of the
+ * actual bitmap. If dirty pages logging is not enabled, an error will be
+ * returned.
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

