Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068DA264472
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgIJKoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:44:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:21893 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbgIJKoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:44:08 -0400
IronPort-SDR: YU/xfr0TYznu3J7oBfGfCD103UkYpP+z4pLSTdIl4ZsPLqL3AlQSjzKJ3egPGUDziNhFs8pZf6
 anff1jpLcQBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066280"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066280"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:34 -0700
IronPort-SDR: Q8ZMKACCpo2M5VtsGTtm1gIqPI663DUsQVkaDafwkJU2H00J07AmakgiRMiP1ws+Q8wCbAae6u
 09Zahmo9yacQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137179"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:34 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 01/16] iommu: Report domain nesting info
Date:   Thu, 10 Sep 2020 03:45:18 -0700
Message-Id: <1599734733-6431-2-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
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
 include/uapi/linux/iommu.h | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 1ebc23d..ff987e4 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -341,4 +341,80 @@ struct iommu_gpasid_bind_data {
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
+ * @addr_width:	The output addr width of first level/stage translation
+ * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
+ *		support.
+ * @vendor:	vendor specific data, structure type can be deduced from
+ *		@format field.
+ *
+ * +===============+======================================================+
+ * | feature       |  Notes                                               |
+ * +===============+======================================================+
+ * | SYSWIDE_PASID |  IOMMU vendor driver sets it to mandate userspace    |
+ * |               |  to allocate PASID from kernel. All PASID allocation |
+ * |               |  free must be mediated through the IOMMU UAPI.       |
+ * +---------------+------------------------------------------------------+
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
+#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
+#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
+#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
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
2.7.4

