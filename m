Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E779210C261
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 03:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfK1CaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 21:30:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:17935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbfK1CaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 21:30:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 18:30:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="221176261"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 18:30:15 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [PATCH v2 8/8] iommu/vt-d: Add set domain DOMAIN_ATTR_NESTING attr
Date:   Thu, 28 Nov 2019 10:25:50 +0800
Message-Id: <20191128022550.9832-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128022550.9832-1-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds the Intel VT-d specific callback of setting
DOMAIN_ATTR_NESTING domain attribution. It is necessary
to let the VT-d driver know that the domain represents
a virutual machine which requires the IOMMU hardware to
support nested translation mode. Return success if the
IOMMU hardware suports nested mode, otherwise failure.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 56 +++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 68b2f98ecd65..ee717dcb9644 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -308,6 +308,12 @@ static int hw_pass_through = 1;
  */
 #define DOMAIN_FLAG_LOSE_CHILDREN		BIT(1)
 
+/*
+ * Domain represents a virtual machine which demands iommu nested
+ * translation mode support.
+ */
+#define DOMAIN_FLAG_NESTING_MODE		BIT(2)
+
 #define for_each_domain_iommu(idx, domain)			\
 	for (idx = 0; idx < g_num_of_iommus; idx++)		\
 		if (domain->iommu_refcnt[idx])
@@ -5929,6 +5935,24 @@ static inline bool iommu_pasid_support(void)
 	return ret;
 }
 
+static inline bool nested_mode_support(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	bool ret = true;
+
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap)) {
+			ret = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
@@ -6305,10 +6329,42 @@ static bool intel_iommu_is_attach_deferred(struct iommu_domain *domain,
 	return dev->archdata.iommu == DEFER_DEVICE_DOMAIN_INFO;
 }
 
+static int
+intel_iommu_domain_set_attr(struct iommu_domain *domain,
+			    enum iommu_attr attr, void *data)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	unsigned long flags;
+	int ret = 0;
+
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
+
+	switch (attr) {
+	case DOMAIN_ATTR_NESTING:
+		spin_lock_irqsave(&device_domain_lock, flags);
+		if (nested_mode_support() &&
+		    list_empty(&dmar_domain->devices)) {
+			dmar_domain->flags |= DOMAIN_FLAG_NESTING_MODE;
+			dmar_domain->ops = &second_lvl_pgtable_ops;
+		} else {
+			ret = -ENODEV;
+		}
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 const struct iommu_ops intel_iommu_ops = {
 	.capable		= intel_iommu_capable,
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_free		= intel_iommu_domain_free,
+	.domain_set_attr	= intel_iommu_domain_set_attr,
 	.attach_dev		= intel_iommu_attach_device,
 	.detach_dev		= intel_iommu_detach_device,
 	.aux_attach_dev		= intel_iommu_aux_attach_device,
-- 
2.17.1

