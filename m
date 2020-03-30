Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8AC198242
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 19:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgC3RYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 13:24:54 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8337 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbgC3RYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 13:24:54 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e822b580000>; Mon, 30 Mar 2020 10:24:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 30 Mar 2020 10:24:53 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 30 Mar 2020 10:24:53 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Mar
 2020 17:24:53 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 30 Mar 2020 17:24:46 +0000
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
Subject: [PATCH v17 Kernel 6/7] vfio iommu: Adds flag to indicate dirty pages tracking capability support
Date:   Mon, 30 Mar 2020 22:20:43 +0530
Message-ID: <1585587044-2408-7-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585589080; bh=HmCqHH2I4fmHzCZdrV/Nh3fYOyJ7Zyzr6LDRd5l0BCA=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=JOchW1siWS/3HJN6xcVDqUZY8Np/LACCqQYGTBXPXuAsZTDqCENBej+C0Aqsjzy6G
         7PVbVYmg3lQ8z/v+X+pXgjX8HK1VOpaLWqh6VNjDZnH52VlkwLw8NjIVVwaBBKfhD1
         ZVHUWp1jYwvVWsO1aphw0Bg6Zao99m0cB4klJTLe3BXdqi9+YOe+gG1mTsi0S4hKms
         SKKZoK0orqwNWCP/WinHGnjPgvyAUqNEvZl5OvzWXHp7zKWB8Gv+yetOq554myYhra
         udLMdb0yeGVSU8K+7C0K50PpRGonrVxuf7D83SILvJy4chdNfDgQKI1FMB0BRJBPTl
         pcRP6NsRJ5phA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flag VFIO_IOMMU_INFO_DIRTY_PGS in VFIO_IOMMU_GET_INFO indicates that driver
support dirty pages tracking.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 3 ++-
 include/uapi/linux/vfio.h       | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 266550bd7307..9fe12b425976 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2390,7 +2390,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			info.cap_offset = 0; /* output, no-recopy necessary */
 		}
 
-		info.flags = VFIO_IOMMU_INFO_PGSIZES;
+		info.flags = VFIO_IOMMU_INFO_PGSIZES |
+			     VFIO_IOMMU_INFO_DIRTY_PGS;
 
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index e3cbf8b78623..0fe7c9a6f211 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -985,8 +985,9 @@ struct vfio_device_feature {
 struct vfio_iommu_type1_info {
 	__u32	argsz;
 	__u32	flags;
-#define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
-#define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
+#define VFIO_IOMMU_INFO_PGSIZES   (1 << 0) /* supported page sizes info */
+#define VFIO_IOMMU_INFO_CAPS      (1 << 1) /* Info supports caps */
+#define VFIO_IOMMU_INFO_DIRTY_PGS (1 << 2) /* supports dirty page tracking */
 	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
 };
-- 
2.7.0

