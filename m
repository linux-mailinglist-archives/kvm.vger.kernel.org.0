Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C25206F3B
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 10:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388798AbgFXIs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 04:48:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:1312 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388627AbgFXIs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 04:48:58 -0400
IronPort-SDR: TkiZ07cZ2DcNPiP3jt/NNjwEJ6cpaRDcn9weCllO1/RLIPxWG5+kvEiUIw7HwDLh2oGzBPNDHQ
 XB9jz3DQAqIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="162484868"
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="162484868"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 01:48:56 -0700
IronPort-SDR: H7pfF6pVsFfantbj3FlPTng1XOH3Wr2GzXJBZGsTYaTbZl0ony5hF+i9sJks/onbo/JRtsSkFb
 wBQoI34QZHmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="275624496"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga003.jf.intel.com with ESMTP; 24 Jun 2020 01:48:55 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/14] iommu: Report domain nesting info
Date:   Wed, 24 Jun 2020 01:55:15 -0700
Message-Id: <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMUs that support nesting translation needs report the capability info
to userspace, e.g. the format of first level/stage paging structures.

This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
nesting info after setting DOMAIN_ATTR_NESTING.

v2 -> v3:
*) remvoe cap/ecap_mask in iommu_nesting_info.
*) reuse DOMAIN_ATTR_NESTING to get nesting info.
*) return an empty iommu_nesting_info for SMMU drivers per Jean'
   suggestion.

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
 drivers/iommu/arm-smmu-v3.c | 29 ++++++++++++++++++++--
 drivers/iommu/arm-smmu.c    | 29 ++++++++++++++++++++--
 include/uapi/linux/iommu.h  | 59 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index f578677..0c45d4d 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
+static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
+					void *data)
+{
+	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
+	u32 size;
+
+	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -ENODEV;
+
+	size = sizeof(struct iommu_nesting_info);
+
+	/*
+	 * if provided buffer size is not equal to the size, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->size != size) {
+		info->size = size;
+		return 0;
+	}
+
+	/* report an empty iommu_nesting_info for now */
+	memset(info, 0x0, size);
+	info->size = size;
+	return 0;
+}
+
 static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
@@ -3028,8 +3054,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	case IOMMU_DOMAIN_UNMANAGED:
 		switch (attr) {
 		case DOMAIN_ATTR_NESTING:
-			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
-			return 0;
+			return arm_smmu_domain_nesting_info(smmu_domain, data);
 		default:
 			return -ENODEV;
 		}
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 243bc4c..908607d 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1506,6 +1506,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
+static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
+					void *data)
+{
+	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
+	u32 size;
+
+	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -ENODEV;
+
+	size = sizeof(struct iommu_nesting_info);
+
+	/*
+	 * if provided buffer size is not equal to the size, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->size != size) {
+		info->size = size;
+		return 0;
+	}
+
+	/* report an empty iommu_nesting_info for now */
+	memset(info, 0x0, size);
+	info->size = size;
+	return 0;
+}
+
 static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
@@ -1515,8 +1541,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	case IOMMU_DOMAIN_UNMANAGED:
 		switch (attr) {
 		case DOMAIN_ATTR_NESTING:
-			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
-			return 0;
+			return arm_smmu_domain_nesting_info(smmu_domain, data);
 		default:
 			return -ENODEV;
 		}
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 1afc661..898c99a 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -332,4 +332,63 @@ struct iommu_gpasid_bind_data {
 	} vendor;
 };
 
+/*
+ * struct iommu_nesting_info - Information for nesting-capable IOMMU.
+ *				user space should check it before using
+ *				nesting capability.
+ *
+ * @size:	size of the whole structure
+ * @format:	PASID table entry format, the same definition with
+ *		@format of struct iommu_gpasid_bind_data.
+ * @features:	supported nesting features.
+ * @flags:	currently reserved for future extension.
+ * @data:	vendor specific cap info.
+ *
+ * +---------------+----------------------------------------------------+
+ * | feature       |  Notes                                             |
+ * +===============+====================================================+
+ * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs used  |
+ * |               |  in the system should be allocated by host kernel  |
+ * +---------------+----------------------------------------------------+
+ * | BIND_PGTBL    |  bind page tables to host PASID, the PASID could   |
+ * |               |  either be a host PASID passed in bind request or  |
+ * |               |  default PASIDs (e.g. default PASID of aux-domain) |
+ * +---------------+----------------------------------------------------+
+ * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU       |
+ * +---------------+----------------------------------------------------+
+ *
+ */
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
+ * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
+ *
+ *
+ * @flags:	VT-d specific flags. Currently reserved for future
+ *		extension.
+ * @addr_width:	The output addr width of first level/stage translation
+ * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
+ *		support.
+ * @cap_reg:	Describe basic capabilities as defined in VT-d capability
+ *		register.
+ * @ecap_reg:	Describe the extended capabilities as defined in VT-d
+ *		extended capability register.
+ */
+struct iommu_nesting_info_vtd {
+	__u32	flags;
+	__u16	addr_width;
+	__u16	pasid_bits;
+	__u64	cap_reg;
+	__u64	ecap_reg;
+};
+
 #endif /* _UAPI_IOMMU_H */
-- 
2.7.4

