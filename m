Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D7874E302
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 03:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjGKBJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 21:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjGKBJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 21:09:32 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A0C12A;
        Mon, 10 Jul 2023 18:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689037745; x=1720573745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tu0/OPEWkWpyHRU5FU3MEKAkLZnjJWJALBRzwq16sRE=;
  b=aF4JbhtORQVmOYw9xEylvEa2+MiUIV8KoB8YNZI5OOYySPuuNn1TAYpw
   1lYMjkBg1GXbyfsakqnErBnD37SGUSy0TAW6envjEjjzPNcksXOoA8fXx
   pe/6Ev7qTiae3bsxCW+W30UEYzswyUz3huHwFFKCkv1eB2aGDSkI2+N3W
   gkHhLmfDJSME92Heefwf7sLl/tEJexX5Xu/i5+O81rQx5c0HOuqESVI/X
   oGVFRfGii1E3kIMit6PmBgEaPdBePgI0KPHt896qBftv+ya3Fu4OI5FD9
   Xd2550pThZDCiZ04GDiFu851AG1Iiewq29Mk9STddK1IDlQVDpjPKrCdo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="344816135"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="344816135"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 18:09:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="810999932"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="810999932"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2023 18:08:59 -0700
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
Subject: [PATCH 7/9] iommu: Add helper to set iopf handler for domain
Date:   Tue, 11 Jul 2023 09:06:40 +0800
Message-Id: <20230711010642.19707-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711010642.19707-1-baolu.lu@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid open code everywhere.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 14 +++++++++++---
 drivers/iommu/iommu.c | 20 ++++++++++++++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f10be6680f8a..c86ff10b40f3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -198,6 +198,8 @@ struct iommu_page_response {
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
+typedef enum iommu_page_response_code (*iommu_iopf_handler_t)(struct iommu_fault *,
+			struct device *dev, void *data);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -247,9 +249,7 @@ struct iommu_domain {
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
 	struct iommu_dma_cookie *iova_cookie;
-	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault *fault,
-						      struct device *dev,
-						      void *data);
+	iommu_iopf_handler_t iopf_handler;
 	void *fault_data;
 	union {
 		struct {
@@ -634,6 +634,8 @@ extern ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
+void iommu_domain_set_iopf_handler(struct iommu_domain *domain,
+				   iommu_iopf_handler_t handler, void *data);
 
 extern void iommu_get_resv_regions(struct device *dev, struct list_head *list);
 extern void iommu_put_resv_regions(struct device *dev, struct list_head *list);
@@ -957,6 +959,12 @@ static inline void iommu_set_fault_handler(struct iommu_domain *domain,
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
index fc5e9698b35c..3dc59af24208 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1847,6 +1847,23 @@ void iommu_set_fault_handler(struct iommu_domain *domain,
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
@@ -3335,8 +3352,7 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
 	domain->mm = mm;
-	domain->iopf_handler = iommu_sva_handle_iopf;
-	domain->fault_data = mm;
+	iommu_domain_set_iopf_handler(domain, iommu_sva_handle_iopf, mm);
 
 	return domain;
 }
-- 
2.34.1

