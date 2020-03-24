Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D328D191A7F
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 21:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgCXUGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 16:06:48 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18913 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgCXUGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 16:06:48 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7a684a0000>; Tue, 24 Mar 2020 13:06:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 24 Mar 2020 13:06:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 24 Mar 2020 13:06:47 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 20:06:47 +0000
Received: from kwankhede-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 24 Mar 2020 20:06:41 +0000
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
Subject: [PATCH v16 Kernel 6/7] vfio iommu: Adds flag to indicate dirty pages tracking capability support
Date:   Wed, 25 Mar 2020 01:02:38 +0530
Message-ID: <1585078359-20124-7-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585080394; bh=3LO4uROSUaH06pVbclbUpV+en/LfMMy1iRPQpP7PANc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=Fx1luZUREDDjjzKJtHpUa/y7xEI49amKmejk8DEWP8YOLxezw1jpxQ+1plOs9PCqc
         vhevzWGgrW4wgHGYdsyDqm0tzK0qrkU5jUS38n399G9lYTEDCw1ZPcPTCYdQCOB0Oi
         iP+qsXq8yTh8mvHylCnSLkiQ0LgACOwqN6V99i30zSMsslqGC3HULeQrSZKC3ZZSB7
         gZsCIbgta67ZFKzdW3DpcrKnMLwYRkcoOQl3D3BL3aIYE9/LlAPkRflnp3xaSjAKGw
         wTiiDg6gh7foIImmPSCbBvNc0I5BR92EGbicB/q7731pqE16wpdKmxUALEK2hnmUTd
         DO+7FWsLMWfpQ==
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
index b98a8d79e13a..5b233ded7a9a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2388,7 +2388,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			info.cap_offset = 0; /* output, no-recopy necessary */
 		}
 
-		info.flags = VFIO_IOMMU_INFO_PGSIZES;
+		info.flags = VFIO_IOMMU_INFO_PGSIZES |
+			     VFIO_IOMMU_INFO_DIRTY_PGS;
 
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 7c888041136f..39bd734a5064 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -948,8 +948,9 @@ struct vfio_device_ioeventfd {
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

