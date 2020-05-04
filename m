Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24AA1C3FF4
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbgEDQc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:32:56 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10714 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729686AbgEDQc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:32:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb043720001>; Mon, 04 May 2020 09:31:46 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 May 2020 09:32:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 May 2020 09:32:55 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 May
 2020 16:32:55 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 4 May 2020 16:32:49 +0000
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
Subject: [PATCH Kernel v18 6/7] vfio iommu: Add migration capability to report supported features
Date:   Mon, 4 May 2020 21:28:58 +0530
Message-ID: <1588607939-26441-7-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588609906; bh=eKWxGCJSaCMw8/JZ+CKqJ19dAxq6VyRQTcNZQaVOJro=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=e0UKExHEpbB3C+eRYRhEio+sWSLxtoRaQ25Gp3h8UMIrcITOYt0tToZzs4RLjhrPx
         oIxau3OkjoAg6c5+Kafi/edEeX9cCrQdrawzCoxVXG9jcTHZ+2tAgQ5YSuKH5nG4k0
         WcZtlWPb5eyJOmoyTsvqMz6Bi32c4OYBZnbh2Ygr11fcC6OCauZDjTKogHsokEWJhR
         CkNxUVnOmeTW0y+xhLm3EtB3+Bp0DvH8INMMxT1WsD4AgUWOZpq0+zdWE86qm9h9RV
         Q8F8CWbCXVsCwJ7ISOE5niPuLFVV2/JEm7pdqL0gYA4q74L1XpklGcG5+lZuS+mauz
         +EprDHloN5K8Q==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added migration capability in IOMMU info chain.
User application should check IOMMU info chain for migration capability
to use dirty page tracking feature provided by kernel module.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++++
 include/uapi/linux/vfio.h       | 14 ++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8b27faf1ec38..b38d278d7bff 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2378,6 +2378,17 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_migration_build_caps(struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_cap_migration cap_mig;
+
+	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
+	cap_mig.header.version = 1;
+	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
+
+	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2427,6 +2438,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		if (ret)
 			return ret;
 
+		ret = vfio_iommu_migration_build_caps(&caps);
+		if (ret)
+			return ret;
+
 		if (caps.size) {
 			info.flags |= VFIO_IOMMU_INFO_CAPS;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index e3cbf8b78623..df9ce8aaafab 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1013,6 +1013,20 @@ struct vfio_iommu_type1_info_cap_iova_range {
 	struct	vfio_iova_range iova_ranges[];
 };
 
+/*
+ * The migration capability allows to report supported features for migration.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
+
+struct vfio_iommu_type1_info_cap_migration {
+	struct	vfio_info_cap_header header;
+	__u32	flags;
+	/* supports dirty page tracking */
+#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
2.7.0

