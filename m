Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53DC1F67A9
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgFKMK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:10:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:19245 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbgFKMJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:09:13 -0400
IronPort-SDR: 31m7BoBifjHKe+D8ndYZ3mhKdraAPGfHMz/zNOsZFcgVNJXHCaxo5FUL5KWcT5SYNQDJomjiFD
 KScMWqiSWL9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:09:10 -0700
IronPort-SDR: OPpcBOmwGlPnHo8b/0efIaorPIe39HBGnzJgbp6wfoG66DKVua5psE/K+zZ+vt/d9fiyMQvU/U
 4m6wEr/ERC9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="419082509"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga004.jf.intel.com with ESMTP; 11 Jun 2020 05:09:10 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/15] iommu/vt-d: Support reporting nesting capability info
Date:   Thu, 11 Jun 2020 05:15:34 -0700
Message-Id: <1591877734-66527-16-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 drivers/iommu/intel-iommu.c | 81 +++++++++++++++++++++++++++++++++++++++++++--
 include/linux/intel-iommu.h | 16 +++++++++
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 25650ac..5415dc7 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5655,12 +5655,16 @@ static inline bool iommu_pasid_support(void)
 static inline bool nested_mode_support(void)
 {
 	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
+	struct intel_iommu *iommu, *prev = NULL;
 	bool ret = true;
 
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
-		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap)) {
+		if (!prev)
+			prev = iommu;
+		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap) ||
+		    (VTD_CAP_MASK & (iommu->cap ^ prev->cap)) ||
+		    (VTD_ECAP_MASK & (iommu->ecap ^ prev->ecap))) {
 			ret = false;
 			break;
 		}
@@ -6069,11 +6073,84 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
 	return ret;
 }
 
+static int intel_iommu_get_nesting_info(struct iommu_domain *domain,
+					struct iommu_nesting_info *info)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	u64 cap = VTD_CAP_MASK, ecap = VTD_ECAP_MASK;
+	struct device_domain_info *domain_info;
+	struct iommu_nesting_info_vtd vtd;
+	unsigned long flags;
+	u32 size;
+
+	if ((domain->type != IOMMU_DOMAIN_UNMANAGED) ||
+	    !(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE))
+		return -ENODEV;
+
+	if (!info)
+		return -EINVAL;
+
+	size = sizeof(struct iommu_nesting_info) +
+		sizeof(struct iommu_nesting_info_vtd);
+	/*
+	 * if provided buffer size is not equal to the size, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->size != size) {
+		info->size = size;
+		return 0;
+	}
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	/*
+	 * arbitrary select the first domain_info as all nesting
+	 * related capabilities should be consistent across iommu
+	 * units.
+	 */
+	domain_info = list_first_entry(&dmar_domain->devices,
+				      struct device_domain_info, link);
+	cap &= domain_info->iommu->cap;
+	ecap &= domain_info->iommu->ecap;
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+
+	info->format = IOMMU_PASID_FORMAT_INTEL_VTD;
+	info->features = IOMMU_NESTING_FEAT_SYSWIDE_PASID |
+			 IOMMU_NESTING_FEAT_BIND_PGTBL |
+			 IOMMU_NESTING_FEAT_CACHE_INVLD;
+	vtd.flags = 0;
+	vtd.addr_width = dmar_domain->gaw;
+	vtd.pasid_bits = ilog2(intel_pasid_max_id);
+	vtd.cap_reg = cap;
+	vtd.cap_mask = VTD_CAP_MASK;
+	vtd.ecap_reg = ecap;
+	vtd.ecap_mask = VTD_ECAP_MASK;
+
+	memcpy(info->data, &vtd, sizeof(vtd));
+	return 0;
+}
+
+static int intel_iommu_domain_get_attr(struct iommu_domain *domain,
+				       enum iommu_attr attr, void *data)
+{
+	switch (attr) {
+	case DOMAIN_ATTR_NESTING_INFO:
+	{
+		struct iommu_nesting_info *info =
+				(struct iommu_nesting_info *) data;
+
+		return intel_iommu_get_nesting_info(domain, info);
+	}
+	default:
+		return -ENODEV;
+	}
+}
+
 const struct iommu_ops intel_iommu_ops = {
 	.capable		= intel_iommu_capable,
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_free		= intel_iommu_domain_free,
 	.domain_set_attr	= intel_iommu_domain_set_attr,
+	.domain_get_attr	= intel_iommu_domain_get_attr,
 	.attach_dev		= intel_iommu_attach_device,
 	.detach_dev		= intel_iommu_detach_device,
 	.aux_attach_dev		= intel_iommu_aux_attach_device,
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 0b238c3..be48f4e 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -196,6 +196,22 @@
 #define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
 #define ecap_sc_support(e)	((e >> 7) & 0x1) /* Snooping Control */
 
+/* Nesting Support Capability Alignment */
+#define VTD_CAP_FL1GP		(1ULL << 56)
+#define VTD_CAP_FL5LP		(1ULL << 60)
+#define VTD_ECAP_PRS		(1ULL << 29)
+#define VTD_ECAP_ERS		(1ULL << 30)
+#define VTD_ECAP_SRS		(1ULL << 31)
+#define VTD_ECAP_EAFS		(1ULL << 34)
+#define VTD_ECAP_PASID		(1ULL << 40)
+
+/* Only capabilities marked in below MASKs are reported */
+#define VTD_CAP_MASK		(VTD_CAP_FL1GP | VTD_CAP_FL5LP)
+
+#define VTD_ECAP_MASK		(VTD_ECAP_PRS | VTD_ECAP_ERS | \
+				 VTD_ECAP_SRS | VTD_ECAP_EAFS | \
+				 VTD_ECAP_PASID)
+
 /* Virtual command interface capability */
 #define vccap_pasid(v)		(((v) & DMA_VCS_PAS)) /* PASID allocation */
 
-- 
2.7.4

