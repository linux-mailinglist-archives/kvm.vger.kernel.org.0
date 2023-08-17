Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A937801E1
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356243AbjHQXo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356228AbjHQXoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:44:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB132D64;
        Thu, 17 Aug 2023 16:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692315841; x=1723851841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TX8fseiassAcpz/7vNWRclthRxweuzm+QsCrbSik+Y0=;
  b=ShVKt4TIN45X/dYdzxvusoR1zmFBxgvY/3rxjHaVR7ifWhWudYaMUE9B
   KxIqSUV4Ilk7NuxfC6F4ruDG2jQe57EMZknoo5gX0H6/lZ/PyyZL0CzP9
   YQ3Xj1vtesOv3W3BNLu/CRZ+prkivfMA1MeHxVTJHj9wiCIh7Un6LlsH1
   nxeclyXM3zeZhenpVjnXxAuJ3GwTLg7t/4y07icX7qb4wD50nG2TLtCOf
   YKPapHKgy+jpQ7tM0L6GWfwM8XiJsAuQCT5JaRZ0z2PV2oG1zVoKXYAMO
   RHFIIO9K8F/YlxvvssOx+CULse/f6GZ73ADHYL/HyuJFFbRk0IPvgUlxr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="352552099"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="352552099"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 16:44:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849051883"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="849051883"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2023 16:43:56 -0700
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
Subject: [PATCH v3 08/11] iommu: Move iopf_handler() to iommu-sva.c
Date:   Fri, 18 Aug 2023 07:40:44 +0800
Message-Id: <20230817234047.195194-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230817234047.195194-1-baolu.lu@linux.intel.com>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/iommu/iommu-sva.c  | 48 ++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 46 deletions(-)

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
index d07586cd37fd..00c2e447b740 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -25,7 +25,8 @@ struct iopf_queue {
 	struct mutex			lock;
 };
 
-static void iopf_free_group(struct iopf_group *group)
+/* Called by the iopf handler to free the iopf group. */
+void iopf_free_group(struct iopf_group *group)
 {
 	struct iopf_fault *iopf, *next;
 
@@ -37,50 +38,7 @@ static void iopf_free_group(struct iopf_group *group)
 	kfree(group);
 }
 
-static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
-			       enum iommu_page_response_code status)
-{
-	struct iommu_page_response resp = {
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
 	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
 
@@ -189,7 +147,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 			list_move(&iopf->list, &group->faults);
 	}
 
-	ret = iopf_queue_work(group, iopf_handler);
+	ret = iommu_sva_handle_iopf_group(group);
 	if (ret)
 		iopf_free_group(group);
 
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index b78671a8a914..df8734b6ec00 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -210,3 +210,51 @@ void mm_pasid_drop(struct mm_struct *mm)
 
 	iommu_free_global_pasid(mm->pasid);
 }
+
+static int iommu_sva_complete_iopf(struct device *dev, struct iopf_fault *iopf,
+				   enum iommu_page_response_code status)
+{
+	struct iommu_page_response resp = {
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
+static void iommu_sva_iopf_handler(struct work_struct *work)
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
+	iommu_sva_complete_iopf(group->dev, &group->last_fault, status);
+	iopf_free_group(group);
+}
+
+int iommu_sva_handle_iopf_group(struct iopf_group *group)
+{
+	return iopf_queue_work(group, iommu_sva_iopf_handler);
+}
-- 
2.34.1

