Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A4932A735
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839067AbhCBQFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:20361 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447110AbhCBMm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:42:27 -0500
IronPort-SDR: ktqCn+FioXP8fHZI3WSpjF7VgBzCUucNjykZWS+K9uRm+LdRnYIPnC1fPZjBk0noCKC8ch301s
 tMlYtwEaCe4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="248204708"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="248204708"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:36:51 -0800
IronPort-SDR: Brd43w0LOZbDrTFJ3gfLSRxZiSLsUs5bSdjubJavIBPvwqtn6bag80PX1fhIwkM2RuBtTCLCww
 +5TJsxfnaKiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427471988"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:36:47 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        jgg@nvidia.com, Lingshan.Zhu@intel.com, vivek.gautam@arm.com
Subject: [Patch v8 01/10] iommu: Report domain nesting info
Date:   Wed,  3 Mar 2021 04:35:36 +0800
Message-Id: <20210302203545.436623-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203545.436623-1-yi.l.liu@intel.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMUs that support nesting translation needs report the capability info
to userspace. It gives information about requirements the userspace needs
to implement plus other features characterizing the physical implementation.

This patch introduces a new IOMMU UAPI struct that gives information about
the nesting capabilities and features. This struct is supposed to be returned
by iommu_domain_get_attr() with DOMAIN_ATTR_NESTING attribute parameter, with
one domain whose type has been set to DOMAIN_ATTR_NESTING.

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
v7 -> v8:
*) add padding in struct iommu_nesting_info_vtd
*) describe future extension rules for struct iommu_nesting_info in iommu.rst.
*) remove SYSWIDE_PASID

v6 -> v7:
*) rephrase the commit message, replace the @data[] field in struct
   iommu_nesting_info with union per comments from Eric Auger.

v5 -> v6:
*) rephrase the feature notes per comments from Eric Auger.
*) rename @size of struct iommu_nesting_info to @argsz.

v4 -> v5:
*) address comments from Eric Auger.

v3 -> v4:
*) split the SMMU driver changes to be a separate patch
*) move the @addr_width and @pasid_bits from vendor specific
   part to generic part.
*) tweak the description for the @features field of struct
   iommu_nesting_info.
*) add description on the @data[] field of struct iommu_nesting_info

v2 -> v3:
*) remvoe cap/ecap_mask in iommu_nesting_info.
*) reuse DOMAIN_ATTR_NESTING to get nesting info.
*) return an empty iommu_nesting_info for SMMU drivers per Jean'
   suggestion.
---
 Documentation/userspace-api/iommu.rst |  5 +-
 include/uapi/linux/iommu.h            | 72 +++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/Documentation/userspace-api/iommu.rst b/Documentation/userspace-api/iommu.rst
index d3108c1519d5..ad06bb94aad5 100644
--- a/Documentation/userspace-api/iommu.rst
+++ b/Documentation/userspace-api/iommu.rst
@@ -26,6 +26,7 @@ supported user-kernel APIs are as follows:
 2. Bind/Unbind guest PASID table (e.g. ARM SMMU)
 3. Invalidate IOMMU caches upon guest requests
 4. Report errors to the guest and serve page requests
+5. Read iommu_nesting_info from kernel
 
 Requirements
 ============
@@ -96,7 +97,9 @@ kernel. Simply recompiling existing code with newer kernel header should
 not be an issue in that only existing flags are used.
 
 IOMMU vendor driver should report the below features to IOMMU UAPI
-consumers (e.g. via VFIO).
+consumers (e.g. via VFIO). The feature list is passed by struct
+iommu_nesting_info. The future extension to this structure follows
+the rule defined in section "Extension Rules & Precautions".
 
 1. IOMMU_NESTING_FEAT_SYSWIDE_PASID
 2. IOMMU_NESTING_FEAT_BIND_PGTBL
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index e1d9e75f2c94..e924bfc091e8 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -338,4 +338,76 @@ struct iommu_gpasid_bind_data {
 	} vendor;
 };
 
+/*
+ * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info.
+ *
+ * @flags:	VT-d specific flags. Currently reserved for future
+ *		extension. must be set to 0.
+ * @cap_reg:	Describe basic capabilities as defined in VT-d capability
+ *		register.
+ * @ecap_reg:	Describe the extended capabilities as defined in VT-d
+ *		extended capability register.
+ */
+struct iommu_nesting_info_vtd {
+	__u32	flags;
+	__u8	padding[12];
+	__u64	cap_reg;
+	__u64	ecap_reg;
+};
+
+/*
+ * struct iommu_nesting_info - Information for nesting-capable IOMMU.
+ *			       userspace should check it before using
+ *			       nesting capability.
+ *
+ * @argsz:	size of the whole structure.
+ * @flags:	currently reserved for future extension. must set to 0.
+ * @format:	PASID table entry format, the same definition as struct
+ *		iommu_gpasid_bind_data @format.
+ * @features:	supported nesting features.
+ * @addr_width:	the output addr width of first level/stage translation
+ * @pasid_bits:	maximum supported PASID bits, 0 represents no PASID
+ *		support.
+ * @vendor:	vendor specific data, structure type can be deduced from
+ *		@format field.
+ *
+ * +===============+======================================================+
+ * | feature       |  Notes                                               |
+ * +===============+======================================================+
+ * | BIND_PGTBL    |  IOMMU vendor driver sets it to mandate userspace to |
+ * |               |  bind the first level/stage page table to associated |
+ * |               |  PASID (either the one specified in bind request or  |
+ * |               |  the default PASID of iommu domain), through IOMMU   |
+ * |               |  UAPI.                                               |
+ * +---------------+------------------------------------------------------+
+ * | CACHE_INVLD   |  IOMMU vendor driver sets it to mandate userspace to |
+ * |               |  explicitly invalidate the IOMMU cache through IOMMU |
+ * |               |  UAPI according to vendor-specific requirement when  |
+ * |               |  changing the 1st level/stage page table.            |
+ * +---------------+------------------------------------------------------+
+ *
+ * data struct types defined for @format:
+ * +================================+=====================================+
+ * | @format                        | data struct                         |
+ * +================================+=====================================+
+ * | IOMMU_PASID_FORMAT_INTEL_VTD   | struct iommu_nesting_info_vtd       |
+ * +--------------------------------+-------------------------------------+
+ *
+ */
+struct iommu_nesting_info {
+	__u32	argsz;
+	__u32	flags;
+	__u32	format;
+#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 0)
+#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 1)
+	__u32	features;
+	__u16	addr_width;
+	__u16	pasid_bits;
+	__u8	padding[12];
+	/* Vendor specific data */
+	union {
+		struct iommu_nesting_info_vtd vtd;
+	} vendor;
+};
+
 #endif /* _UAPI_IOMMU_H */
-- 
2.25.1

