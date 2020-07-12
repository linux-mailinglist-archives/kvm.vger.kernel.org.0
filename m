Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E2921C8E5
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 13:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgGLLQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 07:16:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:45844 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbgGLLOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 07:14:32 -0400
IronPort-SDR: I5XG32ytbg+oGRB9E2/FRa1RrQZqLkZ+xV6OwMf8nPIB3WweT9lZ89Kq9wui7eCHEKDx/STm0D
 G17QopTWE/KA==
X-IronPort-AV: E=McAfee;i="6000,8403,9679"; a="149952681"
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="149952681"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 04:14:29 -0700
IronPort-SDR: lWWf3JX2TzCNYiIJJmYl0EDW/NAMcUl5e9mgT/VNlObDICYY3QqEZcboxM/ErFtCORjjLduN2D
 W+RSshX42inw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="315788555"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 12 Jul 2020 04:14:29 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/15] iommu: Report domain nesting info
Date:   Sun, 12 Jul 2020 04:20:57 -0700
Message-Id: <1594552870-55687-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMUs that support nesting translation needs report the capability info
to userspace, e.g. the format of first level/stage paging structures.

This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
nesting info after setting DOMAIN_ATTR_NESTING.

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
 include/uapi/linux/iommu.h | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 1afc661..d2a47c4 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -332,4 +332,81 @@ struct iommu_gpasid_bind_data {
 	} vendor;
 };
 
+/*
+ * struct iommu_nesting_info - Information for nesting-capable IOMMU.
+ *			       user space should check it before using
+ *			       nesting capability.
+ *
+ * @size:	size of the whole structure
+ * @format:	PASID table entry format, the same definition as struct
+ *		iommu_gpasid_bind_data @format.
+ * @features:	supported nesting features.
+ * @flags:	currently reserved for future extension.
+ * @addr_width:	The output addr width of first level/stage translation
+ * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
+ *		support.
+ * @data:	vendor specific cap info. data[] structure type can be deduced
+ *		from @format field.
+ *
+ * +===============+======================================================+
+ * | feature       |  Notes                                               |
+ * +===============+======================================================+
+ * | SYSWIDE_PASID |  PASIDs are managed in system-wide, instead of per   |
+ * |               |  device. When a device is assigned to userspace or   |
+ * |               |  VM, proper uAPI (userspace driver framework uAPI,   |
+ * |               |  e.g. VFIO) must be used to allocate/free PASIDs for |
+ * |               |  the assigned device.                                |
+ * +---------------+------------------------------------------------------+
+ * | BIND_PGTBL    |  The owner of the first level/stage page table must  |
+ * |               |  explicitly bind the page table to associated PASID  |
+ * |               |  (either the one specified in bind request or the    |
+ * |               |  default PASID of iommu domain), through userspace   |
+ * |               |  driver framework uAPI (e.g. VFIO_IOMMU_NESTING_OP). |
+ * +---------------+------------------------------------------------------+
+ * | CACHE_INVLD   |  The owner of the first level/stage page table must  |
+ * |               |  explicitly invalidate the IOMMU cache through uAPI  |
+ * |               |  provided by userspace driver framework (e.g. VFIO)  |
+ * |               |  according to vendor-specific requirement when       |
+ * |               |  changing the page table.                            |
+ * +---------------+------------------------------------------------------+
+ *
+ * @data[] types defined for @format:
+ * +================================+=====================================+
+ * | @format                        | @data[]                             |
+ * +================================+=====================================+
+ * | IOMMU_PASID_FORMAT_INTEL_VTD   | struct iommu_nesting_info_vtd       |
+ * +--------------------------------+-------------------------------------+
+ *
+ */
+struct iommu_nesting_info {
+	__u32	size;
+	__u32	format;
+#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
+#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
+#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
+	__u32	features;
+	__u32	flags;
+	__u16	addr_width;
+	__u16	pasid_bits;
+	__u32	padding;
+	__u8	data[];
+};
+
+/*
+ * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
+ *
+ * @flags:	VT-d specific flags. Currently reserved for future
+ *		extension.
+ * @cap_reg:	Describe basic capabilities as defined in VT-d capability
+ *		register.
+ * @ecap_reg:	Describe the extended capabilities as defined in VT-d
+ *		extended capability register.
+ */
+struct iommu_nesting_info_vtd {
+	__u32	flags;
+	__u32	padding;
+	__u64	cap_reg;
+	__u64	ecap_reg;
+};
+
 #endif /* _UAPI_IOMMU_H */
-- 
2.7.4

