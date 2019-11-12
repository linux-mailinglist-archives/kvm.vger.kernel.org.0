Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1332F9727
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfKLRdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:33:00 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7561 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfKLRc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 12:32:59 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcaec930000>; Tue, 12 Nov 2019 09:32:03 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 09:32:59 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 09:32:59 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 17:32:58 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 17:32:58 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Nov 2019 17:32:52 +0000
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
Subject: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get dirty pages bitmap.
Date:   Tue, 12 Nov 2019 22:33:37 +0530
Message-ID: <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573579923; bh=hsCfdH2jXMq4AsAY8CLWysoECSs3dz6mo7Od5e+A1nQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=WnTSTsCxfyZuYr5B4jwHp9VwBUAYt/aX9LHKlO7qDzEQQVLICYR9bndQww9nBlKY/
         8al3gR/WhXoaK+QVlD/K1JX87hLjrMNBQPCjl6fKrbMQEXIHUnPZGpnldCR1nOdQCh
         3ZdbeSWle/0T/c+0oKSnItWSrUPo8bQ0xo3rJQv2kFAKpaBqa1a3xB62rgUSL5W7g9
         3fFaoXY+D+Qey5pKGRp81hzCc6UPydO3A/rHdQf1NXLOXg/Il/b7Th2+VCKa/hhBGq
         1Y3qDQimx4/P8ISQice0xZo75koOuD7ADdzddcEoUr7SF+IOra6aisNXTrbbXL/8uc
         fzGZuIHwuILTg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All pages pinned by vendor driver through vfio_pin_pages API should be
considered as dirty during migration. IOMMU container maintains a list of
all such pinned pages. Added an ioctl defination to get bitmap of such
pinned pages for requested IO virtual address range.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 include/uapi/linux/vfio.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 35b09427ad9f..6fd3822aa610 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -902,6 +902,29 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_GET_DIRTY_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
+ *                                     struct vfio_iommu_type1_dirty_bitmap)
+ *
+ * IOCTL to get dirty pages bitmap for IOMMU container during migration.
+ * Get dirty pages bitmap of given IO virtual addresses range using
+ * struct vfio_iommu_type1_dirty_bitmap. Caller sets argsz, which is size of
+ * struct vfio_iommu_type1_dirty_bitmap. User should allocate memory to get
+ * bitmap and should set size of allocated memory in bitmap_size field.
+ * One bit is used to represent per page consecutively starting from iova
+ * offset. Bit set indicates page at that offset from iova is dirty.
+ */
+struct vfio_iommu_type1_dirty_bitmap {
+	__u32        argsz;
+	__u32        flags;
+	__u64        iova;                      /* IO virtual address */
+	__u64        size;                      /* Size of iova range */
+	__u64        bitmap_size;               /* in bytes */
+	void __user *bitmap;                    /* one bit per page */
+};
+
+#define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VFIO_BASE + 17)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.0

