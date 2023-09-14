Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4979FF60
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbjINJBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbjINJAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:00:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6EA2736;
        Thu, 14 Sep 2023 02:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694682027; x=1726218027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v6+ZvOavVLioRIfaA/ZxVSpcZRoD3Mv/EaLjimjJ5yc=;
  b=WZC3BpU8UogrVVzYdUr+5Z1C6iuIUblRchKsNoxa8m+Xp7BQKMbgSJuD
   04v9Lthwh4Pm6vAqFWzJYCIDJCzvo0m4kIDVU8ZdE9YvWFjX3Y0dWRq8z
   utw5nURmHOWhiClPtMKb9XZ/c/rSimSXazGApH13dHiB4AqjeVTwqmrAS
   9enMO6un9JuGsv5ptn0SjCba2GmsG6wioLkhQ1Ra2x6ocpVu8JONBXEQw
   k8hprsVgNC6as2tt1XL37za3Wh0lLXWKSs7OQeriUTk7ZmMfk3WV184eS
   hEB78RWLT03lVRlQh7WhQrCX89T6jV9Waq1DnH0/6NHWDHM7f0Af1jwPQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465266510"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465266510"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:00:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="859613401"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="859613401"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 14 Sep 2023 02:00:22 -0700
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
Subject: [PATCH v5 11/12] iommu: Consolidate per-device fault data management
Date:   Thu, 14 Sep 2023 16:56:37 +0800
Message-Id: <20230914085638.17307-12-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914085638.17307-1-baolu.lu@linux.intel.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 include/linux/iommu.h      |   3 +
 drivers/iommu/io-pgfault.c | 122 +++++++++++++++++++++++--------------
 2 files changed, 79 insertions(+), 46 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1697ac168f05..77ad33ffe3ac 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -480,6 +480,8 @@ struct iommu_device {
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
  * @lock: protect pending faults list
+ * @users: user counter to manage the lifetime of the data, this field
+ *         is protected by dev->iommu->lock.
  * @dev: the device that owns this param
  * @queue: IOPF queue
  * @queue_list: index into queue->devices
@@ -489,6 +491,7 @@ struct iommu_device {
  */
 struct iommu_fault_param {
 	struct mutex lock;
+	int users;
 
 	struct device *dev;
 	struct iopf_queue *queue;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 7e5c6798ce24..3e6845bc5902 100644
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
 	struct iommu_domain *domain;
 	struct iopf_fault *iopf, *next;
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
@@ -167,18 +201,15 @@ static int iommu_handle_iopf(struct iommu_fault *fault, struct device *dev)
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
@@ -187,20 +218,18 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
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
@@ -212,19 +241,20 @@ int iommu_page_response(struct device *dev,
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
@@ -232,7 +262,7 @@ int iommu_page_response(struct device *dev,
 	 * Check if we have a matching page request pending to respond,
 	 * otherwise return -EINVAL
 	 */
-	list_for_each_entry(evt, &param->fault_param->faults, list) {
+	list_for_each_entry(evt, &fault_param->faults, list) {
 		prm = &evt->fault.prm;
 		if (prm->grpid != msg->grpid)
 			continue;
@@ -260,7 +290,9 @@ int iommu_page_response(struct device *dev,
 	}
 
 done_unlock:
-	mutex_unlock(&param->fault_param->lock);
+	mutex_unlock(&fault_param->lock);
+	iopf_put_dev_fault_param(fault_param);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_page_response);
@@ -279,22 +311,15 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
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
 
@@ -318,11 +343,13 @@ int iopf_queue_discard_partial(struct iopf_queue *queue)
 
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
@@ -361,6 +388,7 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	INIT_LIST_HEAD(&fault_param->faults);
 	INIT_LIST_HEAD(&fault_param->partial);
 	fault_param->dev = dev;
+	fault_param->users = 1;
 	list_add(&fault_param->queue_list, &queue->devices);
 	fault_param->queue = queue;
 
@@ -413,9 +441,11 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
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

