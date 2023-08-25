Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568A0787DBC
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbjHYCeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242132AbjHYCeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:34:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38C81AD;
        Thu, 24 Aug 2023 19:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692930851; x=1724466851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DjkElweAqacP5Ktt1CUK2etPlms7F0Rs+4n56PpZN8w=;
  b=fNQOfKTepQc2pyu1wmLFwx4tw9HNHxXbkgeLZo2M3atc6727nER6+Om2
   Lp1cyY2gipcT06W7cjxXEWrmCHNoDHEmi3T4YgGwL90OC7Pv4OOv/4XRB
   w+HABGBzCY6MOyYOQsNoOatE5doUiN57gQuJBZQGysjHb4Tb+W+xfy4H1
   frHG1zd5krVEgduxTu35I3tzdQV0kQKTpH2S8IosOqbb4n1f25LOsniSZ
   BUgcXKAdeWCFNyqbYrES6zmX9dZktGaFl1j+OoiEsL4PuXUdsX3ZnTAIP
   +ZI45jO/yHTZpJLk4KWpyrtXohjvDeWTYVpyI7gEqL12LtTn4RDVQB3WI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="372009667"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="372009667"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 19:33:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="730875143"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="730875143"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 24 Aug 2023 19:33:49 -0700
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
Subject: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Date:   Fri, 25 Aug 2023 10:30:25 +0800
Message-Id: <20230825023026.132919-10-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230825023026.132919-1-baolu.lu@linux.intel.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
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

Make iommu_queue_iopf() more generic by making the iopf_group a minimal
set of iopf's that an iopf handler of domain should handle and respond
to. Add domain parameter to struct iopf_group so that the handler can
retrieve and use it directly.

Change iommu_queue_iopf() to forward groups of iopf's to the domain's
iopf handler. This is also a necessary step to decouple the sva iopf
handling code from this interface.

The iopf handling framework in the core requires that domain's lifetime
should cover all possible iopf. This has been documented in the comments
for iommu_queue_iopf(), which is the entry point of the framework. Add
some debugging code to enforce this requirement.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h      |  4 ++--
 drivers/iommu/iommu-sva.h  |  6 ++---
 drivers/iommu/io-pgfault.c | 49 ++++++++++++++++++++++++++++----------
 drivers/iommu/iommu-sva.c  |  3 +--
 drivers/iommu/iommu.c      | 23 ++++++++++++++++++
 5 files changed, 65 insertions(+), 20 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 19420ccd43a7..687dfde2c874 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -128,6 +128,7 @@ struct iopf_group {
 	struct list_head faults;
 	struct work_struct work;
 	struct device *dev;
+	struct iommu_domain *domain;
 };
 
 /**
@@ -197,8 +198,7 @@ struct iommu_domain {
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
 	struct iommu_dma_cookie *iova_cookie;
-	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault *fault,
-						      void *data);
+	int (*iopf_handler)(struct iopf_group *group);
 	void *fault_data;
 	union {
 		struct {
diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
index de7819c796ce..27c8da115b41 100644
--- a/drivers/iommu/iommu-sva.h
+++ b/drivers/iommu/iommu-sva.h
@@ -22,8 +22,7 @@ int iopf_queue_flush_dev(struct device *dev);
 struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
-enum iommu_page_response_code
-iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
+int iommu_sva_handle_iopf(struct iopf_group *group);
 
 #else /* CONFIG_IOMMU_SVA */
 static inline int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
@@ -62,8 +61,7 @@ static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
 	return -ENODEV;
 }
 
-static inline enum iommu_page_response_code
-iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
+static inline int iommu_sva_handle_iopf(struct iopf_group *group)
 {
 	return IOMMU_PAGE_RESP_INVALID;
 }
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 09e05f483b4f..06330d922925 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -13,6 +13,9 @@
 
 #include "iommu-sva.h"
 
+enum iommu_page_response_code
+iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm);
+
 static void iopf_free_group(struct iopf_group *group)
 {
 	struct iopf_fault *iopf, *next;
@@ -45,23 +48,18 @@ static void iopf_handler(struct work_struct *work)
 {
 	struct iopf_fault *iopf;
 	struct iopf_group *group;
-	struct iommu_domain *domain;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
 
 	group = container_of(work, struct iopf_group, work);
-	domain = iommu_get_domain_for_dev_pasid(group->dev,
-				group->last_fault.fault.prm.pasid, 0);
-	if (!domain || !domain->iopf_handler)
-		status = IOMMU_PAGE_RESP_INVALID;
-
 	list_for_each_entry(iopf, &group->faults, list) {
 		/*
 		 * For the moment, errors are sticky: don't handle subsequent
 		 * faults in the group if there is an error.
 		 */
-		if (status == IOMMU_PAGE_RESP_SUCCESS)
-			status = domain->iopf_handler(&iopf->fault,
-						      domain->fault_data);
+		if (status != IOMMU_PAGE_RESP_SUCCESS)
+			break;
+
+		status = iommu_sva_handle_mm(&iopf->fault, group->domain->mm);
 	}
 
 	iopf_complete_group(group->dev, &group->last_fault, status);
@@ -112,6 +110,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 {
 	int ret;
 	struct iopf_group *group;
+	struct iommu_domain *domain;
 	struct iopf_fault *iopf, *next;
 	struct iommu_fault_param *iopf_param;
 	struct dev_iommu *param = dev->iommu;
@@ -143,6 +142,19 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 		return 0;
 	}
 
+	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
+		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
+	else
+		domain = iommu_get_domain_for_dev(dev);
+
+	if (!domain || !domain->iopf_handler) {
+		dev_warn_ratelimited(dev,
+			"iopf from pasid %d received without handler installed\n",
+			 fault->prm.pasid);
+		ret = -ENODEV;
+		goto cleanup_partial;
+	}
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
 		/*
@@ -157,8 +169,8 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 	group->dev = dev;
 	group->last_fault.fault = *fault;
 	INIT_LIST_HEAD(&group->faults);
+	group->domain = domain;
 	list_add(&group->last_fault.list, &group->faults);
-	INIT_WORK(&group->work, iopf_handler);
 
 	/* See if we have partial faults for this group */
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
@@ -167,9 +179,11 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 			list_move(&iopf->list, &group->faults);
 	}
 
-	queue_work(iopf_param->queue->wq, &group->work);
-	return 0;
+	ret = domain->iopf_handler(group);
+	if (ret)
+		iopf_free_group(group);
 
+	return ret;
 cleanup_partial:
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
 		if (iopf->fault.prm.grpid == fault->prm.grpid) {
@@ -181,6 +195,17 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_queue_iopf);
 
+int iommu_sva_handle_iopf(struct iopf_group *group)
+{
+	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
+
+	INIT_WORK(&group->work, iopf_handler);
+	if (!queue_work(fault_param->queue->wq, &group->work))
+		return -EBUSY;
+
+	return 0;
+}
+
 /**
  * iopf_queue_flush_dev - Ensure that all queued faults have been processed
  * @dev: the endpoint whose faults need to be flushed.
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index b78671a8a914..ba0d5b7e106a 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -149,11 +149,10 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
  * I/O page fault handler for SVA
  */
 enum iommu_page_response_code
-iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
+iommu_sva_handle_mm(struct iommu_fault *fault, struct mm_struct *mm)
 {
 	vm_fault_t ret;
 	struct vm_area_struct *vma;
-	struct mm_struct *mm = data;
 	unsigned int access_flags = 0;
 	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 	struct iommu_fault_page_request *prm = &fault->prm;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index a7f6d0ec0400..0704a0f36349 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1951,6 +1951,27 @@ int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 	return 0;
 }
 
+static void assert_no_pending_iopf(struct device *dev, ioasid_t pasid)
+{
+	struct iommu_fault_param *iopf_param = dev->iommu->fault_param;
+	struct iopf_fault *iopf;
+
+	if (!iopf_param)
+		return;
+
+	mutex_lock(&iopf_param->lock);
+	list_for_each_entry(iopf, &iopf_param->partial, list) {
+		if (WARN_ON(iopf->fault.prm.pasid == pasid))
+			break;
+	}
+
+	list_for_each_entry(iopf, &iopf_param->faults, list) {
+		if (WARN_ON(iopf->fault.prm.pasid == pasid))
+			break;
+	}
+	mutex_unlock(&iopf_param->lock);
+}
+
 void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 {
 	struct iommu_group *group;
@@ -1959,6 +1980,7 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 	if (!group)
 		return;
 
+	assert_no_pending_iopf(dev, IOMMU_NO_PASID);
 	mutex_lock(&group->mutex);
 	if (WARN_ON(domain != group->domain) ||
 	    WARN_ON(list_count_nodes(&group->devices) != 1))
@@ -3269,6 +3291,7 @@ void iommu_detach_device_pasid(struct iommu_domain *domain, struct device *dev,
 {
 	struct iommu_group *group = iommu_group_get(dev);
 
+	assert_no_pending_iopf(dev, pasid);
 	mutex_lock(&group->mutex);
 	__iommu_remove_group_pasid(group, pasid);
 	WARN_ON(xa_erase(&group->pasid_array, pasid) != domain);
-- 
2.34.1

