Return-Path: <kvm+bounces-6504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A7A835A87
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 06:52:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07059285AA5
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 05:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73502134A;
	Mon, 22 Jan 2024 05:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BcuaeaGM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C492210F9;
	Mon, 22 Jan 2024 05:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705902554; cv=none; b=N4Y5pOAL8Q3C7XjOfuxZbl+zX9alBWBSQaPTOGB2kK5W0IzV/GIGMrnoxPuHrHl/uouQybhsDDeXtXiw93zVxtGVWyHfANrifjv8yhf8TBhFOOIG0w843Y2rzeg/hZm0eyFaLwEPHAdUPsSjWcHZdAR3fsiLkCDb6/4sjf4UPhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705902554; c=relaxed/simple;
	bh=LphvU08FzrJf3aoQ6lsmQhV2r6HuaqhWtUUuYKr5gYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jb2We6Ij2TbD+BdtpByqUvZY33lNs2HwiBIdPXeKjyitzYFcEPDhwfA1HEzGTAC3KdTxke32AP0VAXPQJ//pePfRdyjz+YvxJF30TQyz8yhzzXeU6HRuxKydKpJkLwtyATQqJ7MhoC4dmHbGMKVCzlwfbEuDcqYUxxgKQ6DNt5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BcuaeaGM; arc=none smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705902551; x=1737438551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LphvU08FzrJf3aoQ6lsmQhV2r6HuaqhWtUUuYKr5gYI=;
  b=BcuaeaGMXMKaHhVR57BrjNSlvvherzHcO6hVPTKEuGwjrVWvsvhoga+0
   p+cLhLN702mEG7U46jXE8seejYzKx5lqkimnvNDoJisq+/a1eAYEezoNB
   S3PtieFWsoKsCdDI18v6YrVdxt8Uo2VJOih9jjb1wb/fRcqbuZeUgR8yH
   WNVbV+IY7yc+Tfts9R5uaAhTBy2zA31opMmqMfOfzvoet0m1uM2I4ahc5
   /Xu29n7FI0OxKNUrUowA0Lm13e4Z88vmNe8W+0UJjcKEp9jHVUQ9+7Qbs
   tPRz1Hxe6E7OSKl09K7HiIxVRTPSfvxihP6dNi9/EutOlt2O9Uakts6NO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="467487162"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="467487162"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 21:49:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1116763989"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1116763989"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2024 21:49:06 -0800
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
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v10 09/16] iommu: Make iommu_queue_iopf() more generic
Date: Mon, 22 Jan 2024 13:43:01 +0800
Message-Id: <20240122054308.23901-10-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122054308.23901-1-baolu.lu@linux.intel.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
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


