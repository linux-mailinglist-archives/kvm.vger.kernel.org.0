Return-Path: <kvm+bounces-6501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E8B835A81
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 06:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C936C1F24408
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 05:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 557921A70A;
	Mon, 22 Jan 2024 05:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TdER+c06"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF4C182D5;
	Mon, 22 Jan 2024 05:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705902540; cv=none; b=iy0kNyEP1TpydWVioPRMBwm2dsSpw38xgirMceh9QA1I7Hh+WI9pyZ75PDJaC+rfKN4q3Tk/oVQ2VG3bMP34Wf8fv7pyrPCCmY9neyV1sH36svnDPhxFYyBEJhqmO3Il96/c0lGg+DGVHRbqNYsVEnQm/z6S22icobezJUZOdq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705902540; c=relaxed/simple;
	bh=l3Af7GHyuFLQsJ1P/+PY5az0mAa0WeIDa4w3PSF1Fyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iN72aMJf+cm1uwtGoY6KFyVJoaiiVw94Ejw8WKwgppC0T8OLbwLqZPOK75CPrRpL3Gbokd7Pqkk3Rk2pjtPyb5P4AU7GUpJa320LzmnCsC/TcZFi8W5pfQzUeZJbrk7rlzorDPChvC7Q36wBGznSgAU+fMhrrcjhiD6ONgGt3fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TdER+c06; arc=none smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705902538; x=1737438538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l3Af7GHyuFLQsJ1P/+PY5az0mAa0WeIDa4w3PSF1Fyw=;
  b=TdER+c06c15+T4mRz3BE25QQRG3+e6qrjYwypC7A2wVn5mrPNt1sVjXj
   8udybdwe/uaL/Oyc8w/WCpvwjhVdjmcyNTcskaOM3brWAkg2RmSr6pXpa
   oOkdpLTg1fSx6CKTo6e/Xizg6XSc+vJA7L7PExOa8sX6m3Qsn40epwlRq
   u06mZaYYF/cQFvzj5hhaNxrNpXIxZN7Qix1lYizrjIYuY1KofL4xXgAn4
   rXdq67NOjewCtoeLpZ/Y/OhcI+m2znMYnPYWF1zt4vb/6ScE+j93QOxPB
   ++YVqyZQ2Gu9Js/XWhRbbtWd43WB7sknJUcGrEV30Ivyvk4Ovw161grNq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="467487116"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="467487116"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 21:48:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1116763934"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1116763934"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2024 21:48:53 -0800
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
Subject: [PATCH v10 06/16] iommu: Remove iommu_[un]register_device_fault_handler()
Date: Mon, 22 Jan 2024 13:42:58 +0800
Message-Id: <20240122054308.23901-7-baolu.lu@linux.intel.com>
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

The individual iommu driver reports the iommu page faults by calling
iommu_report_device_fault(), where a pre-registered device fault handler
is called to route the fault to another fault handler installed on the
corresponding iommu domain.

The pre-registered device fault handler is static and won't be dynamic
as the fault handler is eventually per iommu domain. Replace calling
device fault handler with iommu_queue_iopf().

After this replacement, the registering and unregistering fault handler
interfaces are not needed anywhere. Remove the interfaces and the related
data structures to avoid dead code.

Convert cookie parameter of iommu_queue_iopf() into a device pointer that
is really passed.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h                         | 23 ------
 drivers/iommu/iommu-sva.h                     |  4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 13 +---
 drivers/iommu/intel/iommu.c                   | 24 ++----
 drivers/iommu/io-pgfault.c                    |  6 +-
 drivers/iommu/iommu.c                         | 76 +------------------
 6 files changed, 13 insertions(+), 133 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index bbb7c2ad5184..70176c1c5573 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -128,7 +128,6 @@ struct iommu_page_response {
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
-typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault *, void *);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -671,8 +670,6 @@ struct iommu_fault_event {
 
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
- * @handler: Callback function to handle IOMMU faults at device level
- * @data: handler private data
  * @lock: protect pending faults list
  * @dev: the device that owns this param
  * @queue: IOPF queue
@@ -682,8 +679,6 @@ struct iommu_fault_event {
  * @faults: holds the pending faults which need response
  */
 struct iommu_fault_param {
-	iommu_dev_fault_handler_t handler;
-	void *data;
 	struct mutex lock;
 
 	struct device *dev;
@@ -806,11 +801,6 @@ extern int iommu_group_for_each_dev(struct iommu_group *group, void *data,
 extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
-extern int iommu_register_device_fault_handler(struct device *dev,
-					iommu_dev_fault_handler_t handler,
-					void *data);
-
-extern int iommu_unregister_device_fault_handler(struct device *dev);
 
 extern int iommu_report_device_fault(struct device *dev,
 				     struct iommu_fault_event *evt);
@@ -1222,19 +1212,6 @@ static inline void iommu_group_put(struct iommu_group *group)
 {
 }
 
-static inline
-int iommu_register_device_fault_handler(struct device *dev,
-					iommu_dev_fault_handler_t handler,
-					void *data)
-{
-	return -ENODEV;
-}
-
-static inline int iommu_unregister_device_fault_handler(struct device *dev)
-{
-	return 0;
-}
-
 static inline
 int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 {
diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
index 54946b5a7caf..de7819c796ce 100644
--- a/drivers/iommu/iommu-sva.h
+++ b/drivers/iommu/iommu-sva.h
@@ -13,7 +13,7 @@ struct iommu_fault;
 struct iopf_queue;
 
 #ifdef CONFIG_IOMMU_SVA
-int iommu_queue_iopf(struct iommu_fault *fault, void *cookie);
+int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev);
 
 int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
 int iopf_queue_remove_device(struct iopf_queue *queue,
@@ -26,7 +26,7 @@ enum iommu_page_response_code
 iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
 
 #else /* CONFIG_IOMMU_SVA */
-static inline int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
+static inline int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 {
 	return -ENODEV;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e..ab2b0a5e4369 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -487,7 +487,6 @@ bool arm_smmu_master_sva_enabled(struct arm_smmu_master *master)
 
 static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master *master)
 {
-	int ret;
 	struct device *dev = master->dev;
 
 	/*
@@ -500,16 +499,7 @@ static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master *master)
 	if (!master->iopf_enabled)
 		return -EINVAL;
 
-	ret = iopf_queue_add_device(master->smmu->evtq.iopf, dev);
-	if (ret)
-		return ret;
-
-	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
-	if (ret) {
-		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
-		return ret;
-	}
-	return 0;
+	return iopf_queue_add_device(master->smmu->evtq.iopf, dev);
 }
 
 static void arm_smmu_master_sva_disable_iopf(struct arm_smmu_master *master)
@@ -519,7 +509,6 @@ static void arm_smmu_master_sva_disable_iopf(struct arm_smmu_master *master)
 	if (!master->iopf_enabled)
 		return;
 
-	iommu_unregister_device_fault_handler(dev);
 	iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
 }
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6fb5f6fceea1..df6ceefc09ee 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4427,23 +4427,15 @@ static int intel_iommu_enable_iopf(struct device *dev)
 	if (ret)
 		return ret;
 
-	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
-	if (ret)
-		goto iopf_remove_device;
-
 	ret = pci_enable_pri(pdev, PRQ_DEPTH);
-	if (ret)
-		goto iopf_unregister_handler;
+	if (ret) {
+		iopf_queue_remove_device(iommu->iopf_queue, dev);
+		return ret;
+	}
+
 	info->pri_enabled = 1;
 
 	return 0;
-
-iopf_unregister_handler:
-	iommu_unregister_device_fault_handler(dev);
-iopf_remove_device:
-	iopf_queue_remove_device(iommu->iopf_queue, dev);
-
-	return ret;
 }
 
 static int intel_iommu_disable_iopf(struct device *dev)
@@ -4466,11 +4458,9 @@ static int intel_iommu_disable_iopf(struct device *dev)
 	info->pri_enabled = 0;
 
 	/*
-	 * With PRI disabled and outstanding PRQs drained, unregistering
-	 * fault handler and removing device from iopf queue should never
-	 * fail.
+	 * With PRI disabled and outstanding PRQs drained, removing device
+	 * from iopf queue should never fail.
 	 */
-	WARN_ON(iommu_unregister_device_fault_handler(dev));
 	WARN_ON(iopf_queue_remove_device(iommu->iopf_queue, dev));
 
 	return 0;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index f948303b2a91..4fda01de5589 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -87,7 +87,7 @@ static void iopf_handler(struct work_struct *work)
 /**
  * iommu_queue_iopf - IO Page Fault handler
  * @fault: fault event
- * @cookie: struct device, passed to iommu_register_device_fault_handler.
+ * @dev: struct device.
  *
  * Add a fault to the device workqueue, to be handled by mm.
  *
@@ -124,14 +124,12 @@ static void iopf_handler(struct work_struct *work)
  *
  * Return: 0 on success and <0 on error.
  */
-int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
+int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
 {
 	int ret;
 	struct iopf_group *group;
 	struct iopf_fault *iopf, *next;
 	struct iommu_fault_param *iopf_param;
-
-	struct device *dev = cookie;
 	struct dev_iommu *param = dev->iommu;
 
 	lockdep_assert_held(&param->lock);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e8f2bcea7f51..bfa3c594542c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1330,76 +1330,6 @@ void iommu_group_put(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_put);
 
-/**
- * iommu_register_device_fault_handler() - Register a device fault handler
- * @dev: the device
- * @handler: the fault handler
- * @data: private data passed as argument to the handler
- *
- * When an IOMMU fault event is received, this handler gets called with the
- * fault event and data as argument. The handler should return 0 on success. If
- * the fault is recoverable (IOMMU_FAULT_PAGE_REQ), the consumer should also
- * complete the fault by calling iommu_page_response() with one of the following
- * response code:
- * - IOMMU_PAGE_RESP_SUCCESS: retry the translation
- * - IOMMU_PAGE_RESP_INVALID: terminate the fault
- * - IOMMU_PAGE_RESP_FAILURE: terminate the fault and stop reporting
- *   page faults if possible.
- *
- * Return 0 if the fault handler was installed successfully, or an error.
- */
-int iommu_register_device_fault_handler(struct device *dev,
-					iommu_dev_fault_handler_t handler,
-					void *data)
-{
-	struct dev_iommu *param = dev->iommu;
-	int ret = 0;
-
-	if (!param || !param->fault_param)
-		return -EINVAL;
-
-	mutex_lock(&param->lock);
-	/* Only allow one fault handler registered for each device */
-	if (param->fault_param->handler) {
-		ret = -EBUSY;
-		goto done_unlock;
-	}
-
-	param->fault_param->handler = handler;
-	param->fault_param->data = data;
-
-done_unlock:
-	mutex_unlock(&param->lock);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(iommu_register_device_fault_handler);
-
-/**
- * iommu_unregister_device_fault_handler() - Unregister the device fault handler
- * @dev: the device
- *
- * Remove the device fault handler installed with
- * iommu_register_device_fault_handler().
- *
- * Return 0 on success, or an error.
- */
-int iommu_unregister_device_fault_handler(struct device *dev)
-{
-	struct dev_iommu *param = dev->iommu;
-
-	if (!param || !param->fault_param)
-		return -EINVAL;
-
-	mutex_lock(&param->lock);
-	param->fault_param->handler = NULL;
-	param->fault_param->data = NULL;
-	mutex_unlock(&param->lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler);
-
 /**
  * iommu_report_device_fault() - Report fault event to device driver
  * @dev: the device
@@ -1424,10 +1354,6 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 	/* we only report device fault if there is a handler registered */
 	mutex_lock(&param->lock);
 	fparam = param->fault_param;
-	if (!fparam || !fparam->handler) {
-		ret = -EINVAL;
-		goto done_unlock;
-	}
 
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
@@ -1442,7 +1368,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 		mutex_unlock(&fparam->lock);
 	}
 
-	ret = fparam->handler(&evt->fault, fparam->data);
+	ret = iommu_queue_iopf(&evt->fault, dev);
 	if (ret && evt_pending) {
 		mutex_lock(&fparam->lock);
 		list_del(&evt_pending->list);
-- 
2.34.1


