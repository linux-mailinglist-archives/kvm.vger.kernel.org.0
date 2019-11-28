Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B60E10C25D
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 03:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfK1CaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 21:30:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:17935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbfK1CaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 21:30:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 18:30:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="221176214"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 18:30:09 -0800
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
Subject: [PATCH v2 6/8] iommu/vt-d: Implement first level page table ops
Date:   Thu, 28 Nov 2019 10:25:48 +0800
Message-Id: <20191128022550.9832-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128022550.9832-1-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds the implementation of page table callbacks for
the first level page table.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 56 +++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a314892ee72b..695a7a5fbe8e 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -414,6 +414,7 @@ int for_each_device_domain(int (*fn)(struct device_domain_info *info,
 }
 
 const struct iommu_ops intel_iommu_ops;
+static const struct pgtable_ops first_lvl_pgtable_ops;
 static const struct pgtable_ops second_lvl_pgtable_ops;
 
 static bool translation_pre_enabled(struct intel_iommu *iommu)
@@ -2330,6 +2331,61 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	return 0;
 }
 
+static int first_lvl_domain_map_range(struct dmar_domain *domain,
+				      unsigned long iova, phys_addr_t paddr,
+				      size_t size, int prot)
+{
+	return first_lvl_map_range(domain, PAGE_ALIGN(iova),
+				   round_up(iova + size, PAGE_SIZE),
+				   PAGE_ALIGN(paddr), prot);
+}
+
+static struct page *
+first_lvl_domain_unmap_range(struct dmar_domain *domain,
+			     unsigned long iova, size_t size)
+{
+	return first_lvl_unmap_range(domain, PAGE_ALIGN(iova),
+				     round_up(iova + size, PAGE_SIZE));
+}
+
+static phys_addr_t
+first_lvl_domain_iova_to_phys(struct dmar_domain *domain,
+			      unsigned long iova)
+{
+	return first_lvl_iova_to_phys(domain, iova);
+}
+
+static void
+first_lvl_domain_flush_tlb_range(struct dmar_domain *domain,
+				 struct intel_iommu *iommu,
+				 unsigned long iova, size_t size, bool ih)
+{
+	unsigned long pages = aligned_nrpages(iova, size);
+	u16 did = domain->iommu_did[iommu->seq_id];
+	unsigned int mask;
+
+	if (pages) {
+		mask = ilog2(__roundup_pow_of_two(pages));
+		iova &= (u64)-1 << (VTD_PAGE_SHIFT + mask);
+	} else {
+		mask = MAX_AGAW_PFN_WIDTH;
+		iova = 0;
+		pages = -1;
+	}
+
+	iommu->flush.p_iotlb_inv(iommu, did, domain->default_pasid,
+				 iova, pages, ih);
+
+	iommu_flush_dev_iotlb(domain, iova, mask);
+}
+
+static const struct pgtable_ops first_lvl_pgtable_ops = {
+	.map_range		= first_lvl_domain_map_range,
+	.unmap_range		= first_lvl_domain_unmap_range,
+	.iova_to_phys		= first_lvl_domain_iova_to_phys,
+	.flush_tlb_range	= first_lvl_domain_flush_tlb_range,
+};
+
 static int second_lvl_domain_map_range(struct dmar_domain *domain,
 				       unsigned long iova, phys_addr_t paddr,
 				       size_t size, int prot)
-- 
2.17.1

