Return-Path: <kvm+bounces-8533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A006850CB2
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1564B1F210AC
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF87C179AD;
	Mon, 12 Feb 2024 01:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j0HTZhyq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D0517980;
	Mon, 12 Feb 2024 01:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701346; cv=none; b=H5D/Vs+WiDCBQJFJDGuEujoJUnSNPiuRz921+1izvdEFLotvTEt1eaRmw9Fu53Vzj6jcte2xXGuDRgPhGFc9M9M6L3/cZq7+wTUY6eCmE1sqibepwbM24Pr5fsPGWzpY3CEz3/kPR82KcYzK5plma2SPUo3jRrxS9ZhnUoVvmEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701346; c=relaxed/simple;
	bh=yrXTjKtpfQ6r2HcJutGuOgehPEptVdDhiAnvZm3Nb8g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DBYBSIiYqOUoZcYCwarxu0rIXk9fyUaOLLBYojK5lbFO0gdP3YjOxbmDKtLOZSyWbNRxx2chrRmQRaRHOxz6jqgbMIU9w9qH8l/94ma2iEdjhA2pZJKKeCF+jTXTaxhw4dxx0nmtav3OqIj2eFkzxAz61tPwN1JgDGhdBJSspg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j0HTZhyq; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701345; x=1739237345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yrXTjKtpfQ6r2HcJutGuOgehPEptVdDhiAnvZm3Nb8g=;
  b=j0HTZhyqfHQlpd6SUt6CL837tZeRxxXOh80VmLG9IwacGqeDdMDTBMm0
   R0LyyMSNYUShdzuV/ybwLsd/KVl1B3TUMAdHAkNPr0h5QQUfznph3/CA1
   E1aXVmiMI4HCDmAdnJjUi/0BHYF7yHax2tSziHxPGRRyFQBuwmPgNDiow
   T0fnu20ZPKyDr8NeJw4gEw2FmnPnxciJBp6dYJZ8K6MzTGCUDfhZwUU7E
   Tj4vOco59q3ltlDx6LmDf93c8IMNOi4K160yoYHWFiJneXidEDl7S5YWB
   4BWDDFmLrAQcGaYd1NzbDB8uFTGHy+Q+5zx20eJZoMD1KyYGWBBg6sKPy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502178"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502178"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:29:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132241"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:29:00 -0800
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
Subject: [PATCH v13 12/16] iommu: Use refcount for fault data access
Date: Mon, 12 Feb 2024 09:22:23 +0800
Message-Id: <20240212012227.119381-13-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240212012227.119381-1-baolu.lu@linux.intel.com>
References: <20240212012227.119381-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The per-device fault data structure stores information about faults
occurring on a device. Its lifetime spans from IOPF enablement to
disablement. Multiple paths, including IOPF reporting, handling, and
responding, may access it concurrently.

Previously, a mutex protected the fault data from use after free. But
this is not performance friendly due to the critical nature of IOPF
handling paths.

Refine this with a refcount-based approach. The fault data pointer is
obtained within an RCU read region with a refcount. The fault data
pointer is returned for usage only when the pointer is valid and a
refcount is successfully obtained. The fault data is freed with
kfree_rcu(), ensuring data is only freed after all RCU critical regions
complete.

An iopf handling work starts once an iopf group is created. The handling
work continues until iommu_page_response() is called to respond to the
iopf and the iopf group is freed. During this time, the device fault
parameter should always be available. Add a pointer to the device fault
parameter in the iopf_group structure and hold the reference until the
iopf_group is freed.

Make iommu_page_response() static as it is only used in io-pgfault.c.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h      |  17 +++--
 drivers/iommu/io-pgfault.c | 127 +++++++++++++++++++++++--------------
 drivers/iommu/iommu-sva.c  |   2 +-
 3 files changed, 88 insertions(+), 58 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b31bfc0bc726..99cc55c3137f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -41,6 +41,7 @@ struct iommu_dirty_ops;
 struct notifier_block;
 struct iommu_sva;
 struct iommu_dma_cookie;
+struct iommu_fault_param;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -129,8 +130,9 @@ struct iopf_group {
 	struct iopf_fault last_fault;
 	struct list_head faults;
 	struct work_struct work;
-	struct device *dev;
 	struct iommu_domain *domain;
+	/* The device's fault data parameter. */
+	struct iommu_fault_param *fault_param;
 };
 
 /**
@@ -679,6 +681,8 @@ struct iommu_device {
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
  * @lock: protect pending faults list
+ * @users: user counter to manage the lifetime of the data
+ * @rcu: rcu head for kfree_rcu()
  * @dev: the device that owns this param
  * @queue: IOPF queue
  * @queue_list: index into queue->devices
@@ -688,6 +692,8 @@ struct iommu_device {
  */
 struct iommu_fault_param {
 	struct mutex lock;
+	refcount_t users;
+	struct rcu_head rcu;
 
 	struct device *dev;
 	struct iopf_queue *queue;
@@ -715,7 +721,7 @@ struct iommu_fault_param {
  */
 struct dev_iommu {
 	struct mutex lock;
-	struct iommu_fault_param	*fault_param;
+	struct iommu_fault_param __rcu	*fault_param;
 	struct iommu_fwspec		*fwspec;
 	struct iommu_device		*iommu_dev;
 	void				*priv;
@@ -1567,7 +1573,6 @@ void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
 void iopf_free_group(struct iopf_group *group);
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
-int iommu_page_response(struct device *dev, struct iommu_page_response *msg);
 int iopf_group_response(struct iopf_group *group,
 			enum iommu_page_response_code status);
 #else
@@ -1612,12 +1617,6 @@ iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 	return -ENODEV;
 }
 
-static inline int
-iommu_page_response(struct device *dev, struct iommu_page_response *msg)
-{
-	return -ENODEV;
-}
-
 static inline int iopf_group_response(struct iopf_group *group,
 				      enum iommu_page_response_code status)
 {
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 5aea8402be47..ce7058892b59 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -13,6 +13,32 @@
 
 #include "iommu-priv.h"
 
+/*
+ * Return the fault parameter of a device if it exists. Otherwise, return NULL.
+ * On a successful return, the caller takes a reference of this parameter and
+ * should put it after use by calling iopf_put_dev_fault_param().
+ */
+static struct iommu_fault_param *iopf_get_dev_fault_param(struct device *dev)
+{
+	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
+
+	rcu_read_lock();
+	fault_param = rcu_dereference(param->fault_param);
+	if (fault_param && !refcount_inc_not_zero(&fault_param->users))
+		fault_param = NULL;
+	rcu_read_unlock();
+
+	return fault_param;
+}
+
+/* Caller must hold a reference of the fault parameter. */
+static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
+{
+	if (refcount_dec_and_test(&fault_param->users))
+		kfree_rcu(fault_param, rcu);
+}
+
 void iopf_free_group(struct iopf_group *group)
 {
 	struct iopf_fault *iopf, *next;
@@ -22,6 +48,8 @@ void iopf_free_group(struct iopf_group *group)
 			kfree(iopf);
 	}
 
+	/* Pair with iommu_report_device_fault(). */
+	iopf_put_dev_fault_param(group->fault_param);
 	kfree(group);
 }
 EXPORT_SYMBOL_GPL(iopf_free_group);
@@ -135,7 +163,7 @@ static int iommu_handle_iopf(struct iommu_fault *fault,
 		goto cleanup_partial;
 	}
 
-	group->dev = dev;
+	group->fault_param = iopf_param;
 	group->last_fault.fault = *fault;
 	INIT_LIST_HEAD(&group->faults);
 	group->domain = domain;
@@ -178,64 +206,61 @@ static int iommu_handle_iopf(struct iommu_fault *fault,
  */
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
+	bool last_prq = evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
+		(evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE);
 	struct iommu_fault_param *fault_param;
-	struct iopf_fault *evt_pending = NULL;
-	struct dev_iommu *param = dev->iommu;
-	int ret = 0;
+	struct iopf_fault *evt_pending;
+	int ret;
 
-	mutex_lock(&param->lock);
-	fault_param = param->fault_param;
-	if (!fault_param) {
-		mutex_unlock(&param->lock);
+	fault_param = iopf_get_dev_fault_param(dev);
+	if (!fault_param)
 		return -EINVAL;
-	}
 
 	mutex_lock(&fault_param->lock);
-	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
-	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
+	if (last_prq) {
 		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
 				      GFP_KERNEL);
 		if (!evt_pending) {
 			ret = -ENOMEM;
-			goto done_unlock;
+			goto err_unlock;
 		}
 		list_add_tail(&evt_pending->list, &fault_param->faults);
 	}
 
 	ret = iommu_handle_iopf(&evt->fault, fault_param);
-	if (ret && evt_pending) {
+	if (ret)
+		goto err_free;
+
+	mutex_unlock(&fault_param->lock);
+	/* The reference count of fault_param is now held by iopf_group. */
+	if (!last_prq)
+		iopf_put_dev_fault_param(fault_param);
+
+	return 0;
+err_free:
+	if (last_prq) {
 		list_del(&evt_pending->list);
 		kfree(evt_pending);
 	}
-done_unlock:
+err_unlock:
 	mutex_unlock(&fault_param->lock);
-	mutex_unlock(&param->lock);
+	iopf_put_dev_fault_param(fault_param);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_report_device_fault);
 
-int iommu_page_response(struct device *dev,
-			struct iommu_page_response *msg)
+static int iommu_page_response(struct iopf_group *group,
+			       struct iommu_page_response *msg)
 {
 	bool needs_pasid;
 	int ret = -EINVAL;
 	struct iopf_fault *evt;
 	struct iommu_fault_page_request *prm;
-	struct dev_iommu *param = dev->iommu;
-	struct iommu_fault_param *fault_param;
+	struct device *dev = group->fault_param->dev;
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
-
-	if (!ops->page_response)
-		return -ENODEV;
-
-	mutex_lock(&param->lock);
-	fault_param = param->fault_param;
-	if (!fault_param) {
-		mutex_unlock(&param->lock);
-		return -EINVAL;
-	}
+	struct iommu_fault_param *fault_param = group->fault_param;
 
 	/* Only send response if there is a fault report pending */
 	mutex_lock(&fault_param->lock);
@@ -276,10 +301,9 @@ int iommu_page_response(struct device *dev,
 
 done_unlock:
 	mutex_unlock(&fault_param->lock);
-	mutex_unlock(&param->lock);
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(iommu_page_response);
 
 /**
  * iopf_queue_flush_dev - Ensure that all queued faults have been processed
@@ -295,22 +319,20 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
  */
 int iopf_queue_flush_dev(struct device *dev)
 {
-	int ret = 0;
 	struct iommu_fault_param *iopf_param;
-	struct dev_iommu *param = dev->iommu;
 
-	if (!param)
+	/*
+	 * It's a driver bug to be here after iopf_queue_remove_device().
+	 * Therefore, it's safe to dereference the fault parameter without
+	 * holding the lock.
+	 */
+	iopf_param = rcu_dereference_check(dev->iommu->fault_param, true);
+	if (WARN_ON(!iopf_param))
 		return -ENODEV;
 
-	mutex_lock(&param->lock);
-	iopf_param = param->fault_param;
-	if (iopf_param)
-		flush_workqueue(iopf_param->queue->wq);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&param->lock);
+	flush_workqueue(iopf_param->queue->wq);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
 
@@ -335,7 +357,7 @@ int iopf_group_response(struct iopf_group *group,
 	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
 		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
 
-	return iommu_page_response(group->dev, &resp);
+	return iommu_page_response(group, &resp);
 }
 EXPORT_SYMBOL_GPL(iopf_group_response);
 
@@ -384,10 +406,15 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	int ret = 0;
 	struct dev_iommu *param = dev->iommu;
 	struct iommu_fault_param *fault_param;
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+
+	if (!ops->page_response)
+		return -ENODEV;
 
 	mutex_lock(&queue->lock);
 	mutex_lock(&param->lock);
-	if (param->fault_param) {
+	if (rcu_dereference_check(param->fault_param,
+				  lockdep_is_held(&param->lock))) {
 		ret = -EBUSY;
 		goto done_unlock;
 	}
@@ -402,10 +429,11 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	INIT_LIST_HEAD(&fault_param->faults);
 	INIT_LIST_HEAD(&fault_param->partial);
 	fault_param->dev = dev;
+	refcount_set(&fault_param->users, 1);
 	list_add(&fault_param->queue_list, &queue->devices);
 	fault_param->queue = queue;
 
-	param->fault_param = fault_param;
+	rcu_assign_pointer(param->fault_param, fault_param);
 
 done_unlock:
 	mutex_unlock(&param->lock);
@@ -429,10 +457,12 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	int ret = 0;
 	struct iopf_fault *iopf, *next;
 	struct dev_iommu *param = dev->iommu;
-	struct iommu_fault_param *fault_param = param->fault_param;
+	struct iommu_fault_param *fault_param;
 
 	mutex_lock(&queue->lock);
 	mutex_lock(&param->lock);
+	fault_param = rcu_dereference_check(param->fault_param,
+					    lockdep_is_held(&param->lock));
 	if (!fault_param) {
 		ret = -ENODEV;
 		goto unlock;
@@ -454,8 +484,9 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
 		kfree(iopf);
 
-	param->fault_param = NULL;
-	kfree(fault_param);
+	/* dec the ref owned by iopf_queue_add_device() */
+	rcu_assign_pointer(param->fault_param, NULL);
+	iopf_put_dev_fault_param(fault_param);
 unlock:
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 9de878e40413..b51995b4fe90 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -251,7 +251,7 @@ static void iommu_sva_handle_iopf(struct work_struct *work)
 
 static int iommu_sva_iopf_handler(struct iopf_group *group)
 {
-	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
+	struct iommu_fault_param *fault_param = group->fault_param;
 
 	INIT_WORK(&group->work, iommu_sva_handle_iopf);
 	if (!queue_work(fault_param->queue->wq, &group->work))
-- 
2.34.1


