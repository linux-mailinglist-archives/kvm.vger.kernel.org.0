Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0505176464A
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjG0Fxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbjG0FxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:53:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592D11FF3;
        Wed, 26 Jul 2023 22:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437149; x=1721973149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OrB4GkbjupQVUOggSlcnw0nzLKoABWATL0bGy51+mmY=;
  b=HxCaC5UZCk1rRgB51xpd3oBKzAaZi67G4QYdh/LM6fE0aahU8Ff0eseS
   O2nhl7pOp+XmecixV3fzC6dhknvSkUCjIIyR4BSJoQiZinqTLnNJ1pOmU
   MVhUZn1qGAvxJyWi0OeHRbdqMkuo6n4/nvEOF0RBk/TgaCDjU4pEMAfR3
   IFEUq2g7YavncVXH28K+aym2lwvcpPGnSC5cuKfW2APLTpV+cK3yWRqw6
   79/GTzMcavG0ETWKXc29cR+Q7BjJ5cr0KWLNVNvZhRHM39g/YpvCISdfd
   5/j7oMfDSoZhY1/452vGHbmvEt3nO9wDqSvGWtVuN4rS7/coOtKGAQAzB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152663"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152663"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:51:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585335"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585335"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:51:24 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 12/12] iommu: Add helper to set iopf handler for domain
Date:   Thu, 27 Jul 2023 13:48:37 +0800
Message-Id: <20230727054837.147050-13-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230727054837.147050-1-baolu.lu@linux.intel.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid open code everywhere.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 11 ++++++++++-
 drivers/iommu/iommu.c | 20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d725500344a4..4e0b75befefc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -132,6 +132,7 @@ struct iommu_page_response {
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
+typedef int (*iommu_iopf_handler_t)(struct iopf_group *group);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -181,7 +182,7 @@ struct iommu_domain {
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
 	struct iommu_dma_cookie *iova_cookie;
-	int (*iopf_handler)(struct iopf_group *group);
+	iommu_iopf_handler_t iopf_handler;
 	void *fault_data;
 	union {
 		struct {
@@ -581,6 +582,8 @@ extern ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
+void iommu_domain_set_iopf_handler(struct iommu_domain *domain,
+				   iommu_iopf_handler_t handler, void *data);
 
 extern void iommu_get_resv_regions(struct device *dev, struct list_head *list);
 extern void iommu_put_resv_regions(struct device *dev, struct list_head *list);
@@ -904,6 +907,12 @@ static inline void iommu_set_fault_handler(struct iommu_domain *domain,
 {
 }
 
+static inline void iommu_domain_set_iopf_handler(struct iommu_domain *domain,
+						 iommu_iopf_handler_t handler,
+						 void *data)
+{
+}
+
 static inline void iommu_get_resv_regions(struct device *dev,
 					struct list_head *list)
 {
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9d964d16d0ad..2254b0ef91fb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1839,6 +1839,23 @@ void iommu_set_fault_handler(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_set_fault_handler);
 
+/**
+ * iommu_domain_set_iopf_handler() - set io page fault handler for a domain
+ * @domain: iommu domain
+ * @handler: fault handler
+ * @data: user data, will be passed back to the fault handler
+ *
+ * This function should be used by iommu domain users which want to be notified
+ * whenever an IOMMU I/O page fault happens.
+ */
+void iommu_domain_set_iopf_handler(struct iommu_domain *domain,
+				   iommu_iopf_handler_t handler, void *data)
+{
+	domain->iopf_handler = handler;
+	domain->fault_data = data;
+}
+EXPORT_SYMBOL_GPL(iommu_domain_set_iopf_handler);
+
 static struct iommu_domain *__iommu_domain_alloc(const struct bus_type *bus,
 						 unsigned type)
 {
@@ -3328,8 +3345,7 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
 	domain->mm = mm;
-	domain->iopf_handler = iommu_sva_handle_iopf_group;
-	domain->fault_data = mm;
+	iommu_domain_set_iopf_handler(domain, iommu_sva_handle_iopf_group, mm);
 
 	return domain;
 }
-- 
2.34.1

