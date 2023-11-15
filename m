Return-Path: <kvm+bounces-1724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1F57EBB8C
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 04:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 990B81F25F14
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 03:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D824687;
	Wed, 15 Nov 2023 03:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N3VQ1kBA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281594416
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:07:47 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E11219F;
	Tue, 14 Nov 2023 19:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700017648; x=1731553648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8cX7Oz5UK1iAtPODtWmYwRan6akZgj2D9du4TSJDYN8=;
  b=N3VQ1kBA1S5t78zboTZPgpmVKKbT7GUVPcGqowtuGwewkamVCsswuHQ1
   W4X6HPi/S+7Pw4Sf6OW6N36yZxObANFnvOAnZJLUBrLUoS37Hd8QZ1j+N
   y4NgGJgFfxYEAuYKsddRXsBfp0dvdIv9O95PPVtp4mKzIvJ4N2ERJz94w
   N7o9w5MODDES7BjmhfI9d52Leu8Ena0w/sOc1PayMI9PzissZsvo847P9
   DH/V8Xt1pMrGS/aTfrJEyofWObP2rmOuGVogvMn8GYjXHFDGMX+LekO+t
   2WGRqW4t/K/oC/CN/KQ/4My2zUEajJjoIf7PErNQbDUVBAAt+EjDY5Q7k
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="394715506"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="394715506"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 19:07:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="1012128925"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="1012128925"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 14 Nov 2023 19:07:19 -0800
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
	Yan Zhao <yan.y.zhao@intel.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 11/12] iommu: Consolidate per-device fault data management
Date: Wed, 15 Nov 2023 11:02:25 +0800
Message-Id: <20231115030226.16700-12-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115030226.16700-1-baolu.lu@linux.intel.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
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

To make the code simpler and easier to maintain, consolidate the lock
mechanism into two helper functions.

The dev->iommu->fault_parameter->lock lock is also used in
iopf_queue_discard_partial() to improve code readability. This does not
fix any existing issues, as iopf_queue_discard_partial() is only used in
the VT-d driver's prq_event_thread(), which is a single-threaded path that
reports the IOPFs.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h      |   3 +
 drivers/iommu/io-pgfault.c | 122 +++++++++++++++++++++++--------------
 2 files changed, 79 insertions(+), 46 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d19031c1b0e6..c17d5979d70d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -597,6 +597,8 @@ struct iommu_device {
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
  * @lock: protect pending faults list
+ * @users: user counter to manage the lifetime of the data, this field
+ *         is protected by dev->iommu->lock.
  * @dev: the device that owns this param
  * @queue: IOPF queue
  * @queue_list: index into queue->devices
@@ -606,6 +608,7 @@ struct iommu_device {
  */
 struct iommu_fault_param {
 	struct mutex lock;
+	int users;
 
 	struct device *dev;
 	struct iopf_queue *queue;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 3c119bfa1d4a..b80574323cbc 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -26,6 +26,49 @@ void iopf_free_group(struct iopf_group *group)
 }
 EXPORT_SYMBOL_GPL(iopf_free_group);
 
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
+	if (!param)
+		return NULL;
+
+	mutex_lock(&param->lock);
+	fault_param = param->fault_param;
+	if (fault_param)
+		fault_param->users++;
+	mutex_unlock(&param->lock);
+
+	return fault_param;
+}
+
+/* Caller must hold a reference of the fault parameter. */
+static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
+{
+	struct device *dev = fault_param->dev;
+	struct dev_iommu *param = dev->iommu;
+
+	mutex_lock(&param->lock);
+	if (WARN_ON(fault_param->users <= 0 ||
+		    fault_param != param->fault_param)) {
+		mutex_unlock(&param->lock);
+		return;
+	}
+
+	if (--fault_param->users == 0) {
+		param->fault_param = NULL;
+		kfree(fault_param);
+		put_device(dev);
+	}
+	mutex_unlock(&param->lock);
+}
+
 /**
  * iommu_handle_iopf - IO Page Fault handler
  * @fault: fault event
@@ -72,23 +115,14 @@ static int iommu_handle_iopf(struct iommu_fault *fault, struct device *dev)
 	struct iopf_group *group;
 	struct iopf_fault *iopf, *next;
 	struct iommu_domain *domain = NULL;
-	struct iommu_fault_param *iopf_param;
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *iopf_param = dev->iommu->fault_param;
 
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
@@ -173,18 +207,15 @@ static int iommu_handle_iopf(struct iommu_fault *fault, struct device *dev)
  */
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
 	struct iopf_fault *evt_pending = NULL;
-	struct iommu_fault_param *fparam;
 	int ret = 0;
 
-	if (!param || !evt)
+	fault_param = iopf_get_dev_fault_param(dev);
+	if (!fault_param)
 		return -EINVAL;
 
-	/* we only report device fault if there is a handler registered */
-	mutex_lock(&param->lock);
-	fparam = param->fault_param;
-
+	mutex_lock(&fault_param->lock);
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
 		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
@@ -193,20 +224,18 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 			ret = -ENOMEM;
 			goto done_unlock;
 		}
-		mutex_lock(&fparam->lock);
-		list_add_tail(&evt_pending->list, &fparam->faults);
-		mutex_unlock(&fparam->lock);
+		list_add_tail(&evt_pending->list, &fault_param->faults);
 	}
 
 	ret = iommu_handle_iopf(&evt->fault, dev);
 	if (ret && evt_pending) {
-		mutex_lock(&fparam->lock);
 		list_del(&evt_pending->list);
-		mutex_unlock(&fparam->lock);
 		kfree(evt_pending);
 	}
 done_unlock:
-	mutex_unlock(&param->lock);
+	mutex_unlock(&fault_param->lock);
+	iopf_put_dev_fault_param(fault_param);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_report_device_fault);
@@ -218,19 +247,20 @@ int iommu_page_response(struct device *dev,
 	int ret = -EINVAL;
 	struct iopf_fault *evt;
 	struct iommu_fault_page_request *prm;
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
 
 	if (!ops->page_response)
 		return -ENODEV;
 
-	if (!param || !param->fault_param)
-		return -EINVAL;
+	fault_param = iopf_get_dev_fault_param(dev);
+	if (!fault_param)
+		return -ENODEV;
 
 	/* Only send response if there is a fault report pending */
-	mutex_lock(&param->fault_param->lock);
-	if (list_empty(&param->fault_param->faults)) {
+	mutex_lock(&fault_param->lock);
+	if (list_empty(&fault_param->faults)) {
 		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
 		goto done_unlock;
 	}
@@ -238,7 +268,7 @@ int iommu_page_response(struct device *dev,
 	 * Check if we have a matching page request pending to respond,
 	 * otherwise return -EINVAL
 	 */
-	list_for_each_entry(evt, &param->fault_param->faults, list) {
+	list_for_each_entry(evt, &fault_param->faults, list) {
 		prm = &evt->fault.prm;
 		if (prm->grpid != msg->grpid)
 			continue;
@@ -266,7 +296,9 @@ int iommu_page_response(struct device *dev,
 	}
 
 done_unlock:
-	mutex_unlock(&param->fault_param->lock);
+	mutex_unlock(&fault_param->lock);
+	iopf_put_dev_fault_param(fault_param);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_page_response);
@@ -285,22 +317,15 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
  */
 int iopf_queue_flush_dev(struct device *dev)
 {
-	int ret = 0;
-	struct iommu_fault_param *iopf_param;
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(dev);
 
-	if (!param)
+	if (!iopf_param)
 		return -ENODEV;
 
-	mutex_lock(&param->lock);
-	iopf_param = param->fault_param;
-	if (iopf_param)
-		flush_workqueue(iopf_param->queue->wq);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&param->lock);
+	flush_workqueue(iopf_param->queue->wq);
+	iopf_put_dev_fault_param(iopf_param);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
 
@@ -349,11 +374,13 @@ int iopf_queue_discard_partial(struct iopf_queue *queue)
 
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
@@ -392,6 +419,7 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	INIT_LIST_HEAD(&fault_param->faults);
 	INIT_LIST_HEAD(&fault_param->partial);
 	fault_param->dev = dev;
+	fault_param->users = 1;
 	list_add(&fault_param->queue_list, &queue->devices);
 	fault_param->queue = queue;
 
@@ -444,9 +472,11 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
 		kfree(iopf);
 
-	param->fault_param = NULL;
-	kfree(fault_param);
-	put_device(dev);
+	if (--fault_param->users == 0) {
+		param->fault_param = NULL;
+		kfree(fault_param);
+		put_device(dev);
+	}
 unlock:
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
-- 
2.34.1


