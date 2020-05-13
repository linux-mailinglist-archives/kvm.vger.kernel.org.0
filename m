Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72D61D204A
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 22:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgEMUik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 16:38:40 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11768 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgEMUik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 16:38:40 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebc5a840000>; Wed, 13 May 2020 13:37:25 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 May 2020 13:38:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 May 2020 13:38:39 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 May
 2020 20:38:39 +0000
Received: from kwankhede-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 May 2020 20:38:33 +0000
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
Subject: [PATCH Kernel v19 7/8] vfio iommu: Add migration capability to report supported features
Date:   Thu, 14 May 2020 01:34:38 +0530
Message-ID: <1589400279-28522-8-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
References: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589402245; bh=uVBua6PfRlOu5xrjJ3GYKVz9O8f2lW6+Lw2fqrCfW6U=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=jaQ9JMFDYakW9Pm6GuX0y2ZZ+kQH4yYrvT8sGe33V6F3/+kGGyk1b11tcZAi9TIfQ
         GIjsxaeOVxGtImtow5Jf2EDypMQwY45i0DtjaXKrwi2Cl30YZ2PCdsfGiiqSv28gwt
         BuMnjIEzI8X4kxUSJzbislwACDrcg0fp+DZQ/x4wwkppVmGL/rZ+gCdDB9vDlHf8Df
         7MLsECXFX2ku7Kc9HApT2+H5TCaJSzGTWsRCyZcVHAiP4pCxfqCdrwu4/Wl7n/9u1T
         qE+K9BDOqcwGLfUudMi+oQBpp7l43JznPrcYFOmVOsDkUmwC+zfuKnjxqFS0Hf4PLg
         w/91hzU7qOGOg==
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
---
 drivers/vfio/vfio_iommu_type1.c | 24 +++++++++++++++++++++++-
 include/uapi/linux/vfio.h       | 21 +++++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4358be26ff80..77351497a9c2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2389,6 +2389,22 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
+					   struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_cap_migration cap_mig;
+
+	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
+	cap_mig.header.version = 1;
+	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
+
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
@@ -2433,10 +2449,16 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		mutex_lock(&iommu->lock);
 		info.flags = VFIO_IOMMU_INFO_PGSIZES;
 
+		vfio_pgsize_bitmap(iommu);
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
index e3cbf8b78623..c90604322798 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1013,6 +1013,27 @@ struct vfio_iommu_type1_info_cap_iova_range {
 	struct	vfio_iova_range iova_ranges[];
 };
 
+/*
+ * The migration capability allows to report supported features for migration.
+ *
+ * The structures below define version 1 of this capability.
+ *
+ * pgsize_bitmap: Kernel driver returns supported page sizes bitmap for dirty
+ * page tracking.
+ * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
+ * size in bytes to be used by user application for ioctls to get dirty bitmap.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
+
+struct vfio_iommu_type1_info_cap_migration {
+	struct	vfio_info_cap_header header;
+	__u32	flags;
+	/* supports dirty page tracking */
+#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)
+	__u64	pgsize_bitmap;
+	__u64	max_dirty_bitmap_size;		/* in bytes */
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
2.7.0

