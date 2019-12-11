Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6542211A120
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 03:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfLKCNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 21:13:19 -0500
Received: from mga04.intel.com ([192.55.52.120]:52878 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbfLKCNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 21:13:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 18:13:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="225352983"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 10 Dec 2019 18:13:15 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v3 1/6] iommu/vt-d: Identify domains using first level page table
Date:   Wed, 11 Dec 2019 10:12:14 +0800
Message-Id: <20191211021219.8997-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211021219.8997-1-baolu.lu@linux.intel.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This checks whether a domain should use the first level page
table for map/unmap and marks it in the domain structure.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 39 +++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 82b9687e82d3..c93fe716e6b0 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -307,6 +307,14 @@ static int hw_pass_through = 1;
  */
 #define DOMAIN_FLAG_LOSE_CHILDREN		BIT(1)
 
+/*
+ * When VT-d works in the scalable mode, it allows DMA translation to
+ * happen through either first level or second level page table. This
+ * bit marks that the DMA translation for the domain goes through the
+ * first level page table, otherwise, it goes through the second level.
+ */
+#define DOMAIN_FLAG_USE_FIRST_LEVEL		BIT(2)
+
 #define for_each_domain_iommu(idx, domain)			\
 	for (idx = 0; idx < g_num_of_iommus; idx++)		\
 		if (domain->iommu_refcnt[idx])
@@ -1714,6 +1722,35 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 #endif
 }
 
+/*
+ * Check and return whether first level is used by default for
+ * DMA translation. Currently, we make it off by setting
+ * first_level_support = 0, and will change it to -1 after all
+ * map/unmap paths support first level page table.
+ */
+static bool first_level_by_default(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	static int first_level_support = 0;
+
+	if (likely(first_level_support != -1))
+		return first_level_support;
+
+	first_level_support = 1;
+
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (!sm_supported(iommu) || !ecap_flts(iommu->ecap)) {
+			first_level_support = 0;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return first_level_support;
+}
+
 static struct dmar_domain *alloc_domain(int flags)
 {
 	struct dmar_domain *domain;
@@ -1725,6 +1762,8 @@ static struct dmar_domain *alloc_domain(int flags)
 	memset(domain, 0, sizeof(*domain));
 	domain->nid = NUMA_NO_NODE;
 	domain->flags = flags;
+	if (first_level_by_default())
+		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
 	domain->has_iotlb_device = false;
 	INIT_LIST_HEAD(&domain->devices);
 
-- 
2.17.1

