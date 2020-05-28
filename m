Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199371E6D23
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 23:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407540AbgE1VFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 17:05:16 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7035 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407509AbgE1VFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 17:05:05 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed027750000>; Thu, 28 May 2020 14:04:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 May 2020 14:05:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 May 2020 14:05:05 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 May
 2020 21:04:57 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 28 May 2020 21:04:51 +0000
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
Subject: [PATCH Kernel v24 7/8] vfio iommu: Add migration capability to report supported features
Date:   Fri, 29 May 2020 02:00:53 +0530
Message-ID: <1590697854-21364-8-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590699893; bh=0bysUrAZdTghBEVACB7CqJ8TvuHaDBozWIjH+OV3hXg=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=XFD4WIU0FNDla58DBD/qii/OaCVptXh28jhMRvxtiAilkmilR3TbP5q0RyqiCxfHQ
         UrAgTRUYu8U3jKOKGgyzA0iUy3l+SVjKKuBLM3d85q9lWyIAKLq3kRW2vXjFFtUte5
         TREMJ4SQGY5ZVtSUMaO82nwn6OqMw9HzidZMykz7ukOu+RL3/OQxNhVWj0YVZvdh8b
         ILu3tuhi1poFwuBQ1ftIx93xwohAGOW/Ny2GUrB98DlXNW6h1MWS9oWzXg1Kp9qY50
         gHv2UYlsbwOvyBetVmpmPmTOLMGThst+SvQmuZnIws9tDAgSbB2RUfuZGl3ovE7xDX
         cmZmstVq+wpyw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added migration capability in IOMMU info chain.
User application should check IOMMU info chain for migration capability
to use dirty page tracking feature provided by kernel module.
User application must check page sizes supported and maximum dirty
bitmap size returned by this capability structure for ioctls used to get
dirty bitmap.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++++++++-
 include/uapi/linux/vfio.h       | 23 +++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1c240d47d681..f27c29df6fc5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2423,6 +2423,22 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
+					   struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_cap_migration cap_mig;
+
+	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
+	cap_mig.header.version = 1;
+
+	cap_mig.flags = 0;
+	/* support minimum pgsize */
+	cap_mig.pgsize_bitmap = (size_t)1 << __ffs(iommu->pgsize_bitmap);
+	cap_mig.max_dirty_bitmap_size = DIRTY_BITMAP_SIZE_MAX;
+
+	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2469,8 +2485,13 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		info.iova_pgsizes = iommu->pgsize_bitmap;
 
-		ret = vfio_iommu_iova_build_caps(iommu, &caps);
+		ret = vfio_iommu_migration_build_caps(iommu, &caps);
+
+		if (!ret)
+			ret = vfio_iommu_iova_build_caps(iommu, &caps);
+
 		mutex_unlock(&iommu->lock);
+
 		if (ret)
 			return ret;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ff4b6706f7df..fde4692a6989 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1013,6 +1013,29 @@ struct vfio_iommu_type1_info_cap_iova_range {
 	struct	vfio_iova_range iova_ranges[];
 };
 
+/*
+ * The migration capability allows to report supported features for migration.
+ *
+ * The structures below define version 1 of this capability.
+ *
+ * The existence of this capability indicates that IOMMU kernel driver supports
+ * dirty page logging.
+ *
+ * pgsize_bitmap: Kernel driver returns bitmap of supported page sizes for dirty
+ * page logging.
+ * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
+ * size in bytes that can be used by user applications when getting the dirty
+ * bitmap.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
+
+struct vfio_iommu_type1_info_cap_migration {
+	struct	vfio_info_cap_header header;
+	__u32	flags;
+	__u64	pgsize_bitmap;
+	__u64	max_dirty_bitmap_size;		/* in bytes */
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
2.7.0

