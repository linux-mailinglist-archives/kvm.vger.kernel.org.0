Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92DC2644A3
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgIJKv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:51:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:21877 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgIJKsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:48:47 -0400
IronPort-SDR: rAT5ofDjQiDCVbR1BMKm11W2YUNGYwQ/gIIiAjo6RiJTLRDg0lObnEcDugpD/iunS3OmvPeyqm
 pk/EbxrA7muw==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066295"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="220066295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:35 -0700
IronPort-SDR: +Z+rKAmPU2v0Ms/6/w9V7+CB+A5Gfv8ltEEGIXPAb4gnZcDBzAA6ws46vA4oOwAgacSwbJO0Cj
 qBmZ1+dvigKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334137226"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:35 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 16/16] iommu/vt-d: Support reporting nesting capability info
Date:   Thu, 10 Sep 2020 03:45:33 -0700
Message-Id: <1599734733-6431-17-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
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
v6 -> v7:
*) split the patch in v6 into two patches:
   [PATCH v7 15/16] iommu/vt-d: Only support nesting when nesting caps are consistent across iommu units
   [PATCH v7 16/16] iommu/vt-d: Support reporting nesting capability info

v2 -> v3:
*) remove cap/ecap_mask in iommu_nesting_info.
---
 drivers/iommu/intel/iommu.c | 74 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 38c6c9b..e46214e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -6089,6 +6089,79 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
 	return ret;
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
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED ||
+	    !(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE))
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
+	info->features = IOMMU_NESTING_FEAT_SYSWIDE_PASID |
+			 IOMMU_NESTING_FEAT_BIND_PGTBL |
+			 IOMMU_NESTING_FEAT_CACHE_INVLD;
+	info->pasid_bits = ilog2(intel_pasid_max_id);
+	memset(&info->padding, 0x0, 12);
+
+	vtd.flags = 0;
+	vtd.cap_reg = cap;
+	vtd.ecap_reg = ecap;
+
+	memcpy(&info->vendor.vtd, &vtd, sizeof(vtd));
+	return 0;
+}
+
+static int intel_iommu_domain_get_attr(struct iommu_domain *domain,
+				       enum iommu_attr attr, void *data)
+{
+	switch (attr) {
+	case DOMAIN_ATTR_NESTING:
+	{
+		struct iommu_nesting_info *info =
+				(struct iommu_nesting_info *)data;
+		unsigned long flags;
+		int ret;
+
+		spin_lock_irqsave(&device_domain_lock, flags);
+		ret = intel_iommu_get_nesting_info(domain, info);
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		return ret;
+	}
+	default:
+		return -ENOENT;
+	}
+}
+
 /*
  * Check that the device does not live on an external facing PCI port that is
  * marked as untrusted. Such devices should not be able to apply quirks and
@@ -6111,6 +6184,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_free		= intel_iommu_domain_free,
 	.domain_set_attr	= intel_iommu_domain_set_attr,
+	.domain_get_attr	= intel_iommu_domain_get_attr,
 	.attach_dev		= intel_iommu_attach_device,
 	.detach_dev		= intel_iommu_detach_device,
 	.aux_attach_dev		= intel_iommu_aux_attach_device,
-- 
2.7.4

