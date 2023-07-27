Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37A4764646
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjG0FxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjG0Fwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:52:33 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A082D73;
        Wed, 26 Jul 2023 22:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437123; x=1721973123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=so27hNvj4wHtYdDHzwY6sYPqWpUndv7Nfn/yIy3LK9Y=;
  b=JgwxNowdLf24O1orGWJVJSqiHc0ObIh50cOpbjKydrvbuZ28h5qtlpqY
   6YE6xR5uIGXA+RwiUGqs0VQs+8VfEoQCir5JJqhS4pHacJnZsxQYN7tQM
   aD4JQzA07b3HXamy9FNQiUjPB8pxpHRql/B8RBpvAiGKog/hZavDTRLq3
   4fhKbrjkDl6+AWXZtF+xRfYSSjAahV/R2CMv6jxKtuMYy1fR3j+7Q/RDI
   mhsf88APr2fS6+SHFSKgU2MIdi99uZ+pRiOEIlby6Cax964dAooc0GEMI
   vyoUFjD2wHsiaSqW92RUo2+rxf3xNimYrgHNhLA2tcd1BsF5kzzo+Er6v
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152608"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152608"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:51:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585311"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585311"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:51:15 -0700
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
Subject: [PATCH v2 09/12] iommu: Move iopf_handler() to iommu-sva.c
Date:   Thu, 27 Jul 2023 13:48:34 +0800
Message-Id: <20230727054837.147050-10-baolu.lu@linux.intel.com>
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

The iopf_handler() function handles a fault_group for a SVA domain. Move
it to the right place.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu-sva.h  | 17 +++++++++++++
 drivers/iommu/io-pgfault.c | 50 +++-----------------------------------
 drivers/iommu/iommu-sva.c  | 49 +++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 47 deletions(-)

diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
index de7819c796ce..510a7df23fba 100644
--- a/drivers/iommu/iommu-sva.h
+++ b/drivers/iommu/iommu-sva.h
@@ -24,6 +24,9 @@ void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
 enum iommu_page_response_code
 iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
+void iopf_free_group(struct iopf_group *group);
+int iopf_queue_work(struct iopf_group *group, work_func_t func);
+int iommu_sva_handle_iopf_group(struct iopf_group *group);
 
 #else /* CONFIG_IOMMU_SVA */
 static inline int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
@@ -67,5 +70,19 @@ iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
 {
 	return IOMMU_PAGE_RESP_INVALID;
 }
+
+static inline void iopf_free_group(struct iopf_group *group)
+{
+}
+
+static inline int iopf_queue_work(struct iopf_group *group, work_func_t func)
+{
+	return -ENODEV;
+}
+
+static inline int iommu_sva_handle_iopf_group(struct iopf_group *group)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_IOMMU_SVA */
 #endif /* _IOMMU_SVA_H */
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 1432751ff4d4..3614a800638c 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -40,7 +40,7 @@ struct iopf_device_param {
 	struct list_head		partial;
 };
 
-static void iopf_free_group(struct iopf_group *group)
+void iopf_free_group(struct iopf_group *group)
 {
 	struct iopf_fault *iopf, *next;
 
@@ -52,51 +52,7 @@ static void iopf_free_group(struct iopf_group *group)
 	kfree(group);
 }
 
-static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
-			       enum iommu_page_response_code status)
-{
-	struct iommu_page_response resp = {
-		.version		= IOMMU_PAGE_RESP_VERSION_1,
-		.pasid			= iopf->fault.prm.pasid,
-		.grpid			= iopf->fault.prm.grpid,
-		.code			= status,
-	};
-
-	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
-	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
-		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
-
-	return iommu_page_response(dev, &resp);
-}
-
-static void iopf_handler(struct work_struct *work)
-{
-	struct iopf_fault *iopf;
-	struct iopf_group *group;
-	struct iommu_domain *domain;
-	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
-
-	group = container_of(work, struct iopf_group, work);
-	domain = iommu_get_domain_for_dev_pasid(group->dev,
-				group->last_fault.fault.prm.pasid, 0);
-	if (!domain || !domain->iopf_handler)
-		status = IOMMU_PAGE_RESP_INVALID;
-
-	list_for_each_entry(iopf, &group->faults, list) {
-		/*
-		 * For the moment, errors are sticky: don't handle subsequent
-		 * faults in the group if there is an error.
-		 */
-		if (status == IOMMU_PAGE_RESP_SUCCESS)
-			status = domain->iopf_handler(&iopf->fault,
-						      domain->fault_data);
-	}
-
-	iopf_complete_group(group->dev, &group->last_fault, status);
-	iopf_free_group(group);
-}
-
-static int iopf_queue_work(struct iopf_group *group, work_func_t func)
+int iopf_queue_work(struct iopf_group *group, work_func_t func)
 {
 	struct iopf_device_param *iopf_param = group->dev->iommu->iopf_param;
 
@@ -204,7 +160,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 			list_move(&iopf->list, &group->faults);
 	}
 
-	ret = iopf_queue_work(group, iopf_handler);
+	ret = iommu_sva_handle_iopf_group(group);
 	if (ret)
 		iopf_free_group(group);
 
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 05c0fb2acbc4..ab42cfdd7636 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -219,3 +219,52 @@ void mm_pasid_drop(struct mm_struct *mm)
 
 	ida_free(&iommu_global_pasid_ida, mm->pasid);
 }
+
+static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
+			       enum iommu_page_response_code status)
+{
+	struct iommu_page_response resp = {
+		.version		= IOMMU_PAGE_RESP_VERSION_1,
+		.pasid			= iopf->fault.prm.pasid,
+		.grpid			= iopf->fault.prm.grpid,
+		.code			= status,
+	};
+
+	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
+	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
+		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+
+	return iommu_page_response(dev, &resp);
+}
+
+static void iopf_handler(struct work_struct *work)
+{
+	struct iopf_fault *iopf;
+	struct iopf_group *group;
+	struct iommu_domain *domain;
+	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
+
+	group = container_of(work, struct iopf_group, work);
+	domain = iommu_get_domain_for_dev_pasid(group->dev,
+				group->last_fault.fault.prm.pasid, 0);
+	if (!domain || !domain->iopf_handler)
+		status = IOMMU_PAGE_RESP_INVALID;
+
+	list_for_each_entry(iopf, &group->faults, list) {
+		/*
+		 * For the moment, errors are sticky: don't handle subsequent
+		 * faults in the group if there is an error.
+		 */
+		if (status == IOMMU_PAGE_RESP_SUCCESS)
+			status = domain->iopf_handler(&iopf->fault,
+						      domain->fault_data);
+	}
+
+	iopf_complete_group(group->dev, &group->last_fault, status);
+	iopf_free_group(group);
+}
+
+int iommu_sva_handle_iopf_group(struct iopf_group *group)
+{
+	return iopf_queue_work(group, iopf_handler);
+}
-- 
2.34.1

