Return-Path: <kvm+bounces-3812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F58E80811E
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A0F281BB8
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAEF714A91;
	Thu,  7 Dec 2023 06:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="baN23Wj7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78772D73;
	Wed,  6 Dec 2023 22:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701931741; x=1733467741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kNMfOWm3364AzFC1aN/OWVyRikfgr+uI6tVHZFhfmTM=;
  b=baN23Wj7MwFXsstla5G5npGn572zUFSdE9fNkDEWlqU4GzMcc7LbZgW9
   Y6zzgcFojq7JClSR/wu9Ah1vsfIu+rSm+BHwpKYszXBCQs6RXGfQ4UbpC
   uiw1SZE+onV2yTXE2OreVMO2jWirXvjqZyH6HHqr/fOtJsJ1gaygqAnlp
   zzElodkd3HcipiY8gR/Ssk8+Cm77opAXdz9SYcyqDIOG+MGdPX5GdxrGL
   S3knz/qTkfDp3d6a1hBfvRUNwP7x9JHjZ5WJE92zpajL2XGS/zeX2K0v0
   cs5SRHNZwhIFWJ9FfQZbjDlsLP/wiWIxtS5M8MY6T0sqFwlg4ic0e+J6I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1015100"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1015100"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 22:49:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="771611861"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="771611861"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga002.jf.intel.com with ESMTP; 06 Dec 2023 22:48:56 -0800
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
Subject: [PATCH v8 12/12] iommu: Use refcount for fault data access
Date: Thu,  7 Dec 2023 14:43:08 +0800
Message-Id: <20231207064308.313316-13-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231207064308.313316-1-baolu.lu@linux.intel.com>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
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

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h      |  4 ++
 drivers/iommu/io-pgfault.c | 81 +++++++++++++++++++++++++-------------
 2 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 63df77cc0b61..8020bb44a64a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -597,6 +597,8 @@ struct iommu_device {
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
  * @lock: protect pending faults list
+ * @users: user counter to manage the lifetime of the data
+ * @ruc: rcu head for kfree_rcu()
  * @dev: the device that owns this param
  * @queue: IOPF queue
  * @queue_list: index into queue->devices
@@ -606,6 +608,8 @@ struct iommu_device {
  */
 struct iommu_fault_param {
 	struct mutex lock;
+	refcount_t users;
+	struct rcu_head rcu;
 
 	struct device *dev;
 	struct iopf_queue *queue;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 9439eaf54928..2ace32c6d13b 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -26,6 +26,44 @@ void iopf_free_group(struct iopf_group *group)
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
+	rcu_read_lock();
+	fault_param = param->fault_param;
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
+	struct dev_iommu *param = fault_param->dev->iommu;
+
+	rcu_read_lock();
+	if (!refcount_dec_and_test(&fault_param->users)) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	param->fault_param = NULL;
+	kfree_rcu(fault_param, rcu);
+}
+
 /**
  * iommu_handle_iopf - IO Page Fault handler
  * @fault: fault event
@@ -167,15 +205,11 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	struct iommu_fault_param *fault_param;
 	struct iopf_fault *evt_pending = NULL;
-	struct dev_iommu *param = dev->iommu;
 	int ret = 0;
 
-	mutex_lock(&param->lock);
-	fault_param = param->fault_param;
-	if (!fault_param) {
-		mutex_unlock(&param->lock);
+	fault_param = iopf_get_dev_fault_param(dev);
+	if (!fault_param)
 		return -EINVAL;
-	}
 
 	mutex_lock(&fault_param->lock);
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
@@ -196,7 +230,7 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 	}
 done_unlock:
 	mutex_unlock(&fault_param->lock);
-	mutex_unlock(&param->lock);
+	iopf_put_dev_fault_param(fault_param);
 
 	return ret;
 }
@@ -209,7 +243,6 @@ int iommu_page_response(struct device *dev,
 	int ret = -EINVAL;
 	struct iopf_fault *evt;
 	struct iommu_fault_page_request *prm;
-	struct dev_iommu *param = dev->iommu;
 	struct iommu_fault_param *fault_param;
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
@@ -217,12 +250,9 @@ int iommu_page_response(struct device *dev,
 	if (!ops->page_response)
 		return -ENODEV;
 
-	mutex_lock(&param->lock);
-	fault_param = param->fault_param;
-	if (!fault_param) {
-		mutex_unlock(&param->lock);
+	fault_param = iopf_get_dev_fault_param(dev);
+	if (!fault_param)
 		return -EINVAL;
-	}
 
 	/* Only send response if there is a fault report pending */
 	mutex_lock(&fault_param->lock);
@@ -263,7 +293,8 @@ int iommu_page_response(struct device *dev,
 
 done_unlock:
 	mutex_unlock(&fault_param->lock);
-	mutex_unlock(&param->lock);
+	iopf_put_dev_fault_param(fault_param);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_page_response);
@@ -282,22 +313,15 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
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
 
@@ -389,6 +413,8 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	INIT_LIST_HEAD(&fault_param->faults);
 	INIT_LIST_HEAD(&fault_param->partial);
 	fault_param->dev = dev;
+	refcount_set(&fault_param->users, 1);
+	init_rcu_head(&fault_param->rcu);
 	list_add(&fault_param->queue_list, &queue->devices);
 	fault_param->queue = queue;
 
@@ -441,8 +467,7 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
 		kfree(iopf);
 
-	param->fault_param = NULL;
-	kfree(fault_param);
+	iopf_put_dev_fault_param(fault_param);
 unlock:
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
-- 
2.34.1


