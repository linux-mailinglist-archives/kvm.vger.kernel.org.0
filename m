Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6320A1F67AF
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgFKMJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:09:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:41824 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgFKMJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:09:11 -0400
IronPort-SDR: MIvSTA61YwbAq7E8kNnrvLbRwe1hb33bKUuJIjbwq1jfMuavgS8yLe4yXGfFHmfrke1ShOhVWZ
 2KJo5JHTz5sw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:09:10 -0700
IronPort-SDR: UgngBC5o0rztw2qcTzpAkEo04MkcEm9MfxLvB1ItguxfQYidjlTVJ30U8VwqYTd+GpEhpnPiDn
 Oqm8wYJSqdSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="419082469"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga004.jf.intel.com with ESMTP; 11 Jun 2020 05:09:09 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/15] iommu: Report domain nesting info
Date:   Thu, 11 Jun 2020 05:15:21 -0700
Message-Id: <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMUs that support nesting translation needs report the capability info
to userspace, e.g. the format of first level/stage paging structures.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
@Jean, Eric: as nesting was introduced for ARM, but looks like no actual
user of it. right? So I'm wondering if we can reuse DOMAIN_ATTR_NESTING
to retrieve nesting info? how about your opinions?

 include/linux/iommu.h      |  1 +
 include/uapi/linux/iommu.h | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 78a26ae..f6e4b49 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -126,6 +126,7 @@ enum iommu_attr {
 	DOMAIN_ATTR_FSL_PAMUV1,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
+	DOMAIN_ATTR_NESTING_INFO,
 	DOMAIN_ATTR_MAX,
 };
 
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 303f148..02eac73 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -332,4 +332,38 @@ struct iommu_gpasid_bind_data {
 	};
 };
 
+struct iommu_nesting_info {
+	__u32	size;
+	__u32	format;
+	__u32	features;
+#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
+#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
+#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
+	__u32	flags;
+	__u8	data[];
+};
+
+/*
+ * @flags:	VT-d specific flags. Currently reserved for future
+ *		extension.
+ * @addr_width:	The output addr width of first level/stage translation
+ * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
+ *		support.
+ * @cap_reg:	Describe basic capabilities as defined in VT-d capability
+ *		register.
+ * @cap_mask:	Mark valid capability bits in @cap_reg.
+ * @ecap_reg:	Describe the extended capabilities as defined in VT-d
+ *		extended capability register.
+ * @ecap_mask:	Mark the valid capability bits in @ecap_reg.
+ */
+struct iommu_nesting_info_vtd {
+	__u32	flags;
+	__u16	addr_width;
+	__u16	pasid_bits;
+	__u64	cap_reg;
+	__u64	cap_mask;
+	__u64	ecap_reg;
+	__u64	ecap_mask;
+};
+
 #endif /* _UAPI_IOMMU_H */
-- 
2.7.4

