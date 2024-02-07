Return-Path: <kvm+bounces-8180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E2984C20E
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49994B27F5F
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1948720308;
	Wed,  7 Feb 2024 01:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqVo3syy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9A71F952;
	Wed,  7 Feb 2024 01:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707270005; cv=none; b=ihuK8QTUDnx6ofhrQ8FfNZRPJPOmfAlto4p+L5x4qTb5PsfqRndWJpje+KNtuCQnvcbWcgkyX7ChSuBChmPFWMQ4agiBTr6RF3ofe1b/9YKTeWVxL766BdNNb0BJqpjUFWnt35jhGowTbccaYKRHyFFDHExhd869/WHjdbphIDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707270005; c=relaxed/simple;
	bh=xJjYsaefgZGHvEwRQ3CV5IkekvSpCZPTHHD42unBWt0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XxyYQl58rqdLgY04OOx/+Qjaq/LlEPc14xelrVHvS/j7UHshE7MrEvWdNzcOiai6iDdek/MEqM4mc77WuuslrquK7Yss8SqbGnUu08w+j8FC62xoIrTw0y2IzcKdo0+Hm8pDq2MK2juTy0qB/qTLCNbOs6zRGKcj4yDzgCZROjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqVo3syy; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707270003; x=1738806003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xJjYsaefgZGHvEwRQ3CV5IkekvSpCZPTHHD42unBWt0=;
  b=DqVo3syyz1dSjzi8PrhkN2SzCNPkADfBATT6QDUNYfQbzMx9dFu14OdF
   9AkmfdGxxRY4OZNdzZBuMmgkIJn7JDwAXLk4QUwdrdwY2nKEq+OzflN32
   wBcrdKvn2eZb26x84Lt94k6JOQQQDhjyNHvY1NSrGpmgQfrgbl1UZYYkh
   CpPW7FWK3Ti8zXiuYhwmWPXSkv8Tlnn9LkFKo6Dkn5KZWHZLSIy0dW+2u
   LMHrlhiCXWZ3dnNRPhpUWufRCEKDF6Hvi+CMWx+07YkQlsDjs2sVJklWP
   gjeuJS1YU97vdAwEMnkg7WuSkW7YgKUkWQNKr1sMYnZJ0CmiqaUKMqWJ1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11534230"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11534230"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:40:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190759"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:39:58 -0800
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
Subject: [PATCH v12 11/16] iommu: Refine locking for per-device fault data management
Date: Wed,  7 Feb 2024 09:33:20 +0800
Message-Id: <20240207013325.95182-12-baolu.lu@linux.intel.com>
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

The per-device fault data is a data structure that is used to store
information about faults that occur on a device. This data is allocated
when IOPF is enabled on the device and freed when IOPF is disabled. The
data is used in the paths of iopf reporting, handling, responding, and
draining.

The fault data is protected by two locks:

- dev->iommu->lock: This lock is used to protect the allocation and
  freeing of the fault data.
- dev->iommu->fault_parameter->lock: This lock is used to protect the
  fault data itself.

Apply the locking mechanism to the fault reporting and responding paths.

The fault_parameter->lock is also added in iopf_queue_discard_partial().
It does not fix any real issue, as iopf_queue_discard_partial() is only
used in the VT-d driver's prq_event_thread(), which is a single-threaded
path that reports the IOPFs.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/iommu/io-pgfault.c | 61 +++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index c1e88da973ce..5aea8402be47 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -53,7 +53,7 @@ static struct iommu_domain *get_domain_for_iopf(struct device *dev,
 /**
  * iommu_handle_iopf - IO Page Fault handler
  * @fault: fault event
- * @dev: struct device.
+ * @iopf_param: the fault parameter of the device.
  *
  * Add a fault to the device workqueue, to be handled by mm.
  *
@@ -90,29 +90,21 @@ static struct iommu_domain *get_domain_for_iopf(struct device *dev,
  *
  * Return: 0 on success and <0 on error.
  */
-static int iommu_handle_iopf(struct iommu_fault *fault, struct device *dev)
+static int iommu_handle_iopf(struct iommu_fault *fault,
+			     struct iommu_fault_param *iopf_param)
 {
 	int ret;
 	struct iopf_group *group;
 	struct iommu_domain *domain;
 	struct iopf_fault *iopf, *next;
-	struct iommu_fault_param *iopf_param;
-	struct dev_iommu *param = dev->iommu;
+	struct device *dev = iopf_param->dev;
 
-	lockdep_assert_held(&param->lock);
+	lockdep_assert_held(&iopf_param->lock);
 
 	if (fault->type != IOMMU_FAULT_PAGE_REQ)
 		/* Not a recoverable page fault */
 		return -EOPNOTSUPP;
 
-	/*
-	 * As long as we're holding param->lock, the queue can't be unlinked
-	 * from the device and therefore cannot disappear.
-	 */
-	iopf_param = param->fault_param;
-	if (!iopf_param)
-		return -ENODEV;
-
 	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
 		iopf = kzalloc(sizeof(*iopf), GFP_KERNEL);
 		if (!iopf)
@@ -186,18 +178,19 @@ static int iommu_handle_iopf(struct iommu_fault *fault, struct device *dev)
  */
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
 	struct iopf_fault *evt_pending = NULL;
-	struct iommu_fault_param *fparam;
+	struct dev_iommu *param = dev->iommu;
 	int ret = 0;
 
-	if (!param || !evt)
-		return -EINVAL;
-
-	/* we only report device fault if there is a handler registered */
 	mutex_lock(&param->lock);
-	fparam = param->fault_param;
+	fault_param = param->fault_param;
+	if (!fault_param) {
+		mutex_unlock(&param->lock);
+		return -EINVAL;
+	}
 
+	mutex_lock(&fault_param->lock);
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
 		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
@@ -206,20 +199,18 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 			ret = -ENOMEM;
 			goto done_unlock;
 		}
-		mutex_lock(&fparam->lock);
-		list_add_tail(&evt_pending->list, &fparam->faults);
-		mutex_unlock(&fparam->lock);
+		list_add_tail(&evt_pending->list, &fault_param->faults);
 	}
 
-	ret = iommu_handle_iopf(&evt->fault, dev);
+	ret = iommu_handle_iopf(&evt->fault, fault_param);
 	if (ret && evt_pending) {
-		mutex_lock(&fparam->lock);
 		list_del(&evt_pending->list);
-		mutex_unlock(&fparam->lock);
 		kfree(evt_pending);
 	}
 done_unlock:
+	mutex_unlock(&fault_param->lock);
 	mutex_unlock(&param->lock);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_report_device_fault);
@@ -232,18 +223,23 @@ int iommu_page_response(struct device *dev,
 	struct iopf_fault *evt;
 	struct iommu_fault_page_request *prm;
 	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
 
 	if (!ops->page_response)
 		return -ENODEV;
 
-	if (!param || !param->fault_param)
+	mutex_lock(&param->lock);
+	fault_param = param->fault_param;
+	if (!fault_param) {
+		mutex_unlock(&param->lock);
 		return -EINVAL;
+	}
 
 	/* Only send response if there is a fault report pending */
-	mutex_lock(&param->fault_param->lock);
-	if (list_empty(&param->fault_param->faults)) {
+	mutex_lock(&fault_param->lock);
+	if (list_empty(&fault_param->faults)) {
 		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
 		goto done_unlock;
 	}
@@ -251,7 +247,7 @@ int iommu_page_response(struct device *dev,
 	 * Check if we have a matching page request pending to respond,
 	 * otherwise return -EINVAL
 	 */
-	list_for_each_entry(evt, &param->fault_param->faults, list) {
+	list_for_each_entry(evt, &fault_param->faults, list) {
 		prm = &evt->fault.prm;
 		if (prm->grpid != msg->grpid)
 			continue;
@@ -279,7 +275,8 @@ int iommu_page_response(struct device *dev,
 	}
 
 done_unlock:
-	mutex_unlock(&param->fault_param->lock);
+	mutex_unlock(&fault_param->lock);
+	mutex_unlock(&param->lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_page_response);
@@ -362,11 +359,13 @@ int iopf_queue_discard_partial(struct iopf_queue *queue)
 
 	mutex_lock(&queue->lock);
 	list_for_each_entry(iopf_param, &queue->devices, queue_list) {
+		mutex_lock(&iopf_param->lock);
 		list_for_each_entry_safe(iopf, next, &iopf_param->partial,
 					 list) {
 			list_del(&iopf->list);
 			kfree(iopf);
 		}
+		mutex_unlock(&iopf_param->lock);
 	}
 	mutex_unlock(&queue->lock);
 	return 0;
-- 
2.34.1


