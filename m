Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1D32A72A
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575924AbhCBQEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:04:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:37930 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446856AbhCBMl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:41:26 -0500
IronPort-SDR: CdrsD0npF45DwrNYJJOc/EwfC5w2qOFW/38FjUAMecPlWm36GpmRrAY+f7uVgK8tabzby2uZFD
 5S8l3PKQgufg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="206431325"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="206431325"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:37:35 -0800
IronPort-SDR: Cw503WDu7ZdRLf3uhlRhRA1QpVjOli0pmzPL6o558oEiYtrGBh5O7aGTh+e7gtmTWvwfpRoefs
 GJMqj0+wjpPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472223"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:37:31 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        jgg@nvidia.com, Lingshan.Zhu@intel.com, vivek.gautam@arm.com
Subject: [Patch v8 10/10] iommu/vt-d: Support reporting nesting capability info
Date:   Wed,  3 Mar 2021 04:35:45 +0800
Message-Id: <20210302203545.436623-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203545.436623-1-yi.l.liu@intel.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch reports nesting info when iommu_domain_get_attr() is called with
DOMAIN_ATTR_NESTING and one domain with nesting set.

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
*) tweak per latest code base

v6 -> v7:
*) split the patch in v6 into two patches:
   [PATCH v7 15/16] iommu/vt-d: Only support nesting when nesting caps are consistent across iommu units
   [PATCH v7 16/16] iommu/vt-d: Support reporting nesting capability info

v2 -> v3:
*) remove cap/ecap_mask in iommu_nesting_info.
---
 drivers/iommu/intel/cap_audit.h |  7 ++++
 drivers/iommu/intel/iommu.c     | 68 ++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/cap_audit.h b/drivers/iommu/intel/cap_audit.h
index 74cfccae0e81..787e98282a02 100644
--- a/drivers/iommu/intel/cap_audit.h
+++ b/drivers/iommu/intel/cap_audit.h
@@ -60,6 +60,13 @@
 #define ECAP_QI_MASK		BIT_ULL(1)
 #define ECAP_C_MASK		BIT_ULL(0)
 
+/* Capabilities related to nested translation */
+#define VTD_CAP_MASK		(CAP_FL1GP_MASK | CAP_FL5LP_MASK)
+
+#define VTD_ECAP_MASK		(ECAP_PRS_MASK | ECAP_ERS_MASK | \
+				 ECAP_SRS_MASK | ECAP_EAFS_MASK | \
+				 ECAP_PASID_MASK)
+
 /*
  * u64 intel_iommu_cap_sanity, intel_iommu_ecap_sanity will be adjusted as each
  * IOMMU gets audited.
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 4409d86b4e18..f7432fb1c6ea 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5508,13 +5508,79 @@ static bool domain_use_flush_queue(void)
 	return r;
 }
 
+static int intel_iommu_get_nesting_info(struct iommu_domain *domain,
+					struct iommu_nesting_info *info)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	u64 cap = VTD_CAP_MASK, ecap = VTD_ECAP_MASK;
+	struct device_domain_info *domain_info;
+	struct iommu_nesting_info_vtd vtd;
+	unsigned int size;
+
+	if (!info)
+		return -EINVAL;
+
+	if (!(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE))
+		return -ENODEV;
+
+	size = sizeof(struct iommu_nesting_info);
+	/*
+	 * if provided buffer size is smaller than expected, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->argsz < size) {
+		info->argsz = size;
+		return 0;
+	}
+
+	/*
+	 * arbitrary select the first domain_info as all nesting
+	 * related capabilities should be consistent across iommu
+	 * units.
+	 */
+	domain_info = list_first_entry(&dmar_domain->devices,
+				       struct device_domain_info, link);
+	cap &= domain_info->iommu->cap;
+	ecap &= domain_info->iommu->ecap;
+
+	info->addr_width = dmar_domain->gaw;
+	info->format = IOMMU_PASID_FORMAT_INTEL_VTD;
+	info->features = IOMMU_NESTING_FEAT_BIND_PGTBL |
+			 IOMMU_NESTING_FEAT_CACHE_INVLD;
+	info->pasid_bits = ilog2(intel_pasid_max_id);
+	memset(&info->padding, 0x0, 12);
+
+	vtd.flags = 0;
+	memset(&vtd.padding, 0x0, 12);
+	vtd.cap_reg = cap & VTD_CAP_MASK;
+	vtd.ecap_reg = ecap & VTD_ECAP_MASK;
+
+	memcpy(&info->vendor.vtd, &vtd, sizeof(vtd));
+	return 0;
+}
+
 static int
 intel_iommu_domain_get_attr(struct iommu_domain *domain,
 			    enum iommu_attr attr, void *data)
 {
 	switch (domain->type) {
 	case IOMMU_DOMAIN_UNMANAGED:
-		return -ENODEV;
+		switch (attr) {
+		case DOMAIN_ATTR_NESTING:
+		{
+			struct iommu_nesting_info *info =
+				(struct iommu_nesting_info *)data;
+			unsigned long flags;
+			int ret;
+
+			spin_lock_irqsave(&device_domain_lock, flags);
+			ret = intel_iommu_get_nesting_info(domain, info);
+			spin_unlock_irqrestore(&device_domain_lock, flags);
+			return ret;
+		}
+		default:
+			return -ENODEV;
+		}
 	case IOMMU_DOMAIN_DMA:
 		switch (attr) {
 		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-- 
2.25.1

