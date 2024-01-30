Return-Path: <kvm+bounces-7444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4580841D6D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 09:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AA1428BE5E
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FC566B29;
	Tue, 30 Jan 2024 08:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZoyWJN1S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADBA664CB;
	Tue, 30 Jan 2024 08:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602489; cv=none; b=uIoqg3tfsKW7InsDRnPhr5mNf3ptQWAuZJCGffVxZYgdQnpZQSk5EEOePdONvILRC+wi6Wf/3sbhdtP1MPHDIj3/x7waGHloLEuacm8QF1XXis+tQk5YN8jmvy21xohbTFLOUbvElkZGTD3rap/Ii8eniKNE92HK4FxTKcbft6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602489; c=relaxed/simple;
	bh=LphvU08FzrJf3aoQ6lsmQhV2r6HuaqhWtUUuYKr5gYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RwGK0StP6C7FFPI/Dl9Zz/hq+rraQ190b1hD08IT9GUE83RVxy8fwr+/Vp8xhcdH5BajLGcLmQVSNvvLT7KORjgz7tkj/7Tz39MmzUk/LNwYsho3aCMz83ri4iErxjTQIdb12mTFSM273a0ySJRuZgFbCcw7WE+CDBZPFrg37Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZoyWJN1S; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706602488; x=1738138488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LphvU08FzrJf3aoQ6lsmQhV2r6HuaqhWtUUuYKr5gYI=;
  b=ZoyWJN1S0WnNGYh+k0xxZzkLQkj8uDuwXm9lPssZWwE2fMXLiGNBkiMp
   XnFdPdDgZCQ7QUzsrjjtsGdwjii/K5f/He2wBqI+3LM63n/zd2BS2dODg
   YE98vmRFTuZU4mv6E1FWdFNnowDS+2qAYB08bG0YvF1YTAMxi5IwSxAr2
   QHHBJ+MSAPoPdIwO3d/jK11yeZ4Sulm6M1WfeqDYSqjuJgMmT4ejBQHuV
   WLaJaBSVgJTPFRe+6tlrtlQbAmJzq2lQRrqe2Oe32Kr9FAXhO4pLNWxTT
   QYeQEqKwazoddIr1i8MgU5Kreudl3I02/1RsiDAh1gwkbE7L/UDmg2Uwu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="10588416"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="10588416"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:14:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="3633826"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa003.fm.intel.com with ESMTP; 30 Jan 2024 00:14:43 -0800
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
Subject: [PATCH v11 09/16] iommu: Make iommu_queue_iopf() more generic
Date: Tue, 30 Jan 2024 16:08:28 +0800
Message-Id: <20240130080835.58921-10-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240130080835.58921-1-baolu.lu@linux.intel.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
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


