Return-Path: <kvm+bounces-8178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3238984C208
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6ECF1F27CA1
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E152C1CFB9;
	Wed,  7 Feb 2024 01:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XcX7BsJL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622FD1F61D;
	Wed,  7 Feb 2024 01:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707269994; cv=none; b=kwnMaDC7lqSl6VD4WlADuxHhTHsdYkWgHpB1raLSMtHQ987CFCJlOrnOoMYkNZOoYeEqFYmLCB8ii8AS6iJ6PRIl1iNrBwycDMLvK2i2Anofx6sgmez9Wed59L6X29tJSf+vh9bezgJZghK7hHxZMNpFOgiG1kZFceUznT9ZJ6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707269994; c=relaxed/simple;
	bh=LphvU08FzrJf3aoQ6lsmQhV2r6HuaqhWtUUuYKr5gYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b59RfigQxSA4ob1DbKc4Co53mTWxr5wDOllFHzz6t/AKqpo0ORt7mYwk2rhu2DUHnZ56V1gKM5Ahg9ui/3ePHLym+T65zwlZDb1cfHSsH3PqDxRXyZhwM82DPIgBlmtnpCbt+BOS44LbzcJ2VHA4gVulZgqgcAOjoby9O9CzNGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XcX7BsJL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707269992; x=1738805992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LphvU08FzrJf3aoQ6lsmQhV2r6HuaqhWtUUuYKr5gYI=;
  b=XcX7BsJLG3nQN9IepyfJ1Ke9nfdngUphfvkAuKYpb/CcBretYjsw7+9T
   OUks0VgfUH3oUj1a39BEOnwyVEv88qj/XLrBHFhe14DuHKFikBA2ojBXI
   zMCIM4sZ2/T58iFVBKaGjM2xwzyobtU55xkFPVdaL5U7uNiK3La91e5Vk
   pyt9+hyFTaeBCFOxF0+kGo1ASC7PF/ejAe1lg4gew5aPe5e+i8tJKeruk
   Xg37XBWwWM3yaMLgu3YC5R6gxbensXB7UG7/IPNvpv2fAQdUDwdD4rDe4
   1Yl8sXxqlzpJAMNFElLprRlvdr9OkYEeXJ6kiNWMeh+gSGMDzKB5sTgh2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11534175"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11534175"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:39:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190691"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:39:46 -0800
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Joel Granados <j.granados@samsung.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v12 09/16] iommu: Make iommu_queue_iopf() more generic
Date: Wed,  7 Feb 2024 09:33:18 +0800
Message-Id: <20240207013325.95182-10-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240207013325.95182-1-baolu.lu@linux.intel.com>
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make iommu_queue_iopf() more generic by making the iopf_group a minimal
set of iopf's that an iopf handler of domain should handle and respond
to. Add domain parameter to struct iopf_group so that the handler can
retrieve and use it directly.

Change iommu_queue_iopf() to forward groups of iopf's to the domain's
iopf handler. This is also a necessary step to decouple the sva iopf
handling code from this interface.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h      |  4 +--
 drivers/iommu/iommu-sva.h  |  6 ++--
 drivers/iommu/io-pgfault.c | 68 +++++++++++++++++++++++++++++++-------
 drivers/iommu/iommu-sva.c  |  3 +-
 4 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c9d4f175f121..791f183a988e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -130,6 +130,7 @@ struct iopf_group {
 	struct list_head faults;
 	struct work_struct work;
 	struct device *dev;
+	struct iommu_domain *domain;
 };
 
 /**
@@ -209,8 +210,7 @@ struct iommu_domain {
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
index c7e6bbed5c05..13cd0929e766 100644
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
@@ -45,29 +48,48 @@ static void iopf_handler(struct work_struct *work)
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
 	iopf_free_group(group);
 }
 
+static struct iommu_domain *get_domain_for_iopf(struct device *dev,
+						struct iommu_fault *fault)
+{
+	struct iommu_domain *domain;
+
+	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) {
+		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
+		if (IS_ERR(domain))
+			domain = NULL;
+	} else {
+		domain = iommu_get_domain_for_dev(dev);
+	}
+
+	if (!domain || !domain->iopf_handler) {
+		dev_warn_ratelimited(dev,
+			"iopf (pasid %d) without domain attached or handler installed\n",
+			 fault->prm.pasid);
+
+		return NULL;
+	}
+
+	return domain;
+}
+
 /**
  * iommu_queue_iopf - IO Page Fault handler
  * @fault: fault event
@@ -112,6 +134,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 {
 	int ret;
 	struct iopf_group *group;
+	struct iommu_domain *domain;
 	struct iopf_fault *iopf, *next;
 	struct iommu_fault_param *iopf_param;
 	struct dev_iommu *param = dev->iommu;
@@ -143,6 +166,12 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 		return 0;
 	}
 
+	domain = get_domain_for_iopf(dev, fault);
+	if (!domain) {
+		ret = -EINVAL;
+		goto cleanup_partial;
+	}
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
 		/*
@@ -157,8 +186,8 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 	group->dev = dev;
 	group->last_fault.fault = *fault;
 	INIT_LIST_HEAD(&group->faults);
+	group->domain = domain;
 	list_add(&group->last_fault.list, &group->faults);
-	INIT_WORK(&group->work, iopf_handler);
 
 	/* See if we have partial faults for this group */
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
@@ -167,9 +196,13 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 			list_move(&iopf->list, &group->faults);
 	}
 
-	queue_work(iopf_param->queue->wq, &group->work);
-	return 0;
+	mutex_unlock(&iopf_param->lock);
+	ret = domain->iopf_handler(group);
+	mutex_lock(&iopf_param->lock);
+	if (ret)
+		iopf_free_group(group);
 
+	return ret;
 cleanup_partial:
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
 		if (iopf->fault.prm.grpid == fault->prm.grpid) {
@@ -181,6 +214,17 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
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
index c3fc9201d0be..fcae7308fcb7 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -163,11 +163,10 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
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
-- 
2.34.1


