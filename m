Return-Path: <kvm+bounces-8174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D644984C200
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EF4DB26523
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6C51BF27;
	Wed,  7 Feb 2024 01:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h9WL660z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C9E14A8D;
	Wed,  7 Feb 2024 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707269974; cv=none; b=PCMjozsdo1VdBAbjuPSLNJ4o9aRZ0EMwBhVphdkeDjwTmX1TARZTNJ9EY9td1tr97UVEigZFYdTfSmhUROwq+q9ITM677mqJVh5YX97LqCDgz5Mduo4GqBTPF5Pp9BTOyEUsLP7HYy+gtKNEqpFx368mBv7ZaGW7QNl5K8/Hr88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707269974; c=relaxed/simple;
	bh=ZxkjzYv2VyDYWW9nDCxX3MxMTN6CnL8H/UNXVv2aGgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rWcyusnE7EV3eWDxtsYU3tygrXp7+vmDhZ4wvvsQH5yS+WhcjMvpV6zBSX5qcaqq/VHIpoKeJzvpK+nQNFJVSOiVy32+Pn+rN2Cr0WGb2jBRXlWSeueARZgk+4VL2rx93bYe/jVuFA5AYso2BOfruwfAS+CzykeihCV/qGOljaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h9WL660z; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707269973; x=1738805973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZxkjzYv2VyDYWW9nDCxX3MxMTN6CnL8H/UNXVv2aGgE=;
  b=h9WL660ziYxYRDNnMWscexDuvQ/5GV1mD+4klL2DoqXKjdAIVLBFjYvc
   9ARDcoZr5e3CiV2uGthBec9CJh57QVcCILRkKxldJDP1+ZhqWbaZbjtHX
   OmnHQXuBPDFjdBN4evkyqC18sBFPAmneBWV0YLQaf1o+IEPVXkVtyZdAc
   alwT90FP0vSufPasFpFYMuEQUVeZQoMkEOaMbpLM+Pn54qax/0jab+F2S
   hiDmaqB/mj81HtAP5bdrJmV895YBv+wC8G1c0P6WDKkmrDF0AUK6SaEa1
   PVmuc6hy3TEvwORFM2DKLuFHM7Hqjoym9suhfPElAjj74tvU6VLsk//5f
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11534069"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11534069"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:39:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190624"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:39:27 -0800
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
Subject: [PATCH v12 05/16] iommu: Merge iopf_device_param into iommu_fault_param
Date: Wed,  7 Feb 2024 09:33:14 +0800
Message-Id: <20240207013325.95182-6-baolu.lu@linux.intel.com>
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

The struct dev_iommu contains two pointers, fault_param and iopf_param.
The fault_param pointer points to a data structure that is used to store
pending faults that are awaiting responses. The iopf_param pointer points
to a data structure that is used to store partial faults that are part of
a Page Request Group.

The fault_param and iopf_param pointers are essentially duplicate. This
causes memory waste. Merge the iopf_device_param pointer into the
iommu_fault_param pointer to consolidate the code and save memory. The
consolidated pointer would be allocated on demand when the device driver
enables the iopf on device, and would be freed after iopf is disabled.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h      |  18 ++++--
 drivers/iommu/io-pgfault.c | 110 ++++++++++++++++++-------------------
 drivers/iommu/iommu.c      |  34 ++----------
 3 files changed, 72 insertions(+), 90 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 829bcb5a8e23..bbb7c2ad5184 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -42,6 +42,7 @@ struct notifier_block;
 struct iommu_sva;
 struct iommu_fault_event;
 struct iommu_dma_cookie;
+struct iopf_queue;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -672,21 +673,31 @@ struct iommu_fault_event {
  * struct iommu_fault_param - per-device IOMMU fault data
  * @handler: Callback function to handle IOMMU faults at device level
  * @data: handler private data
- * @faults: holds the pending faults which needs response
  * @lock: protect pending faults list
+ * @dev: the device that owns this param
+ * @queue: IOPF queue
+ * @queue_list: index into queue->devices
+ * @partial: faults that are part of a Page Request Group for which the last
+ *           request hasn't been submitted yet.
+ * @faults: holds the pending faults which need response
  */
 struct iommu_fault_param {
 	iommu_dev_fault_handler_t handler;
 	void *data;
+	struct mutex lock;
+
+	struct device *dev;
+	struct iopf_queue *queue;
+	struct list_head queue_list;
+
+	struct list_head partial;
 	struct list_head faults;
-	struct mutex lock;
 };
 
 /**
  * struct dev_iommu - Collection of per-device IOMMU data
  *
  * @fault_param: IOMMU detected device fault reporting data
- * @iopf_param:	 I/O Page Fault queue and data
  * @fwspec:	 IOMMU fwspec data
  * @iommu_dev:	 IOMMU device this device is linked to
  * @priv:	 IOMMU Driver private data
@@ -702,7 +713,6 @@ struct iommu_fault_param {
 struct dev_iommu {
 	struct mutex lock;
 	struct iommu_fault_param	*fault_param;
-	struct iopf_device_param	*iopf_param;
 	struct iommu_fwspec		*fwspec;
 	struct iommu_device		*iommu_dev;
 	void				*priv;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 24b5545352ae..f948303b2a91 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -25,21 +25,6 @@ struct iopf_queue {
 	struct mutex			lock;
 };
 
-/**
- * struct iopf_device_param - IO Page Fault data attached to a device
- * @dev: the device that owns this param
- * @queue: IOPF queue
- * @queue_list: index into queue->devices
- * @partial: faults that are part of a Page Request Group for which the last
- *           request hasn't been submitted yet.
- */
-struct iopf_device_param {
-	struct device			*dev;
-	struct iopf_queue		*queue;
-	struct list_head		queue_list;
-	struct list_head		partial;
-};
-
 struct iopf_fault {
 	struct iommu_fault		fault;
 	struct list_head		list;
@@ -144,7 +129,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
 	int ret;
 	struct iopf_group *group;
 	struct iopf_fault *iopf, *next;
-	struct iopf_device_param *iopf_param;
+	struct iommu_fault_param *iopf_param;
 
 	struct device *dev = cookie;
 	struct dev_iommu *param = dev->iommu;
@@ -159,7 +144,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
 	 * As long as we're holding param->lock, the queue can't be unlinked
 	 * from the device and therefore cannot disappear.
 	 */
-	iopf_param = param->iopf_param;
+	iopf_param = param->fault_param;
 	if (!iopf_param)
 		return -ENODEV;
 
@@ -229,14 +214,14 @@ EXPORT_SYMBOL_GPL(iommu_queue_iopf);
 int iopf_queue_flush_dev(struct device *dev)
 {
 	int ret = 0;
-	struct iopf_device_param *iopf_param;
+	struct iommu_fault_param *iopf_param;
 	struct dev_iommu *param = dev->iommu;
 
 	if (!param)
 		return -ENODEV;
 
 	mutex_lock(&param->lock);
-	iopf_param = param->iopf_param;
+	iopf_param = param->fault_param;
 	if (iopf_param)
 		flush_workqueue(iopf_param->queue->wq);
 	else
@@ -260,7 +245,7 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
 int iopf_queue_discard_partial(struct iopf_queue *queue)
 {
 	struct iopf_fault *iopf, *next;
-	struct iopf_device_param *iopf_param;
+	struct iommu_fault_param *iopf_param;
 
 	if (!queue)
 		return -EINVAL;
@@ -287,34 +272,36 @@ EXPORT_SYMBOL_GPL(iopf_queue_discard_partial);
  */
 int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 {
-	int ret = -EBUSY;
-	struct iopf_device_param *iopf_param;
+	int ret = 0;
 	struct dev_iommu *param = dev->iommu;
-
-	if (!param)
-		return -ENODEV;
-
-	iopf_param = kzalloc(sizeof(*iopf_param), GFP_KERNEL);
-	if (!iopf_param)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&iopf_param->partial);
-	iopf_param->queue = queue;
-	iopf_param->dev = dev;
+	struct iommu_fault_param *fault_param;
 
 	mutex_lock(&queue->lock);
 	mutex_lock(&param->lock);
-	if (!param->iopf_param) {
-		list_add(&iopf_param->queue_list, &queue->devices);
-		param->iopf_param = iopf_param;
-		ret = 0;
+	if (param->fault_param) {
+		ret = -EBUSY;
+		goto done_unlock;
 	}
+
+	fault_param = kzalloc(sizeof(*fault_param), GFP_KERNEL);
+	if (!fault_param) {
+		ret = -ENOMEM;
+		goto done_unlock;
+	}
+
+	mutex_init(&fault_param->lock);
+	INIT_LIST_HEAD(&fault_param->faults);
+	INIT_LIST_HEAD(&fault_param->partial);
+	fault_param->dev = dev;
+	list_add(&fault_param->queue_list, &queue->devices);
+	fault_param->queue = queue;
+
+	param->fault_param = fault_param;
+
+done_unlock:
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
 
-	if (ret)
-		kfree(iopf_param);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_add_device);
@@ -330,34 +317,41 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
  */
 int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 {
-	int ret = -EINVAL;
+	int ret = 0;
 	struct iopf_fault *iopf, *next;
-	struct iopf_device_param *iopf_param;
 	struct dev_iommu *param = dev->iommu;
-
-	if (!param || !queue)
-		return -EINVAL;
+	struct iommu_fault_param *fault_param = param->fault_param;
 
 	mutex_lock(&queue->lock);
 	mutex_lock(&param->lock);
-	iopf_param = param->iopf_param;
-	if (iopf_param && iopf_param->queue == queue) {
-		list_del(&iopf_param->queue_list);
-		param->iopf_param = NULL;
-		ret = 0;
+	if (!fault_param) {
+		ret = -ENODEV;
+		goto unlock;
 	}
-	mutex_unlock(&param->lock);
-	mutex_unlock(&queue->lock);
-	if (ret)
-		return ret;
+
+	if (fault_param->queue != queue) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	if (!list_empty(&fault_param->faults)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	list_del(&fault_param->queue_list);
 
 	/* Just in case some faults are still stuck */
-	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list)
+	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
 		kfree(iopf);
 
-	kfree(iopf_param);
+	param->fault_param = NULL;
+	kfree(fault_param);
+unlock:
+	mutex_unlock(&param->lock);
+	mutex_unlock(&queue->lock);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_remove_device);
 
@@ -403,7 +397,7 @@ EXPORT_SYMBOL_GPL(iopf_queue_alloc);
  */
 void iopf_queue_free(struct iopf_queue *queue)
 {
-	struct iopf_device_param *iopf_param, *next;
+	struct iommu_fault_param *iopf_param, *next;
 
 	if (!queue)
 		return;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6a4d9bc0641d..9575cb75732a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1355,27 +1355,18 @@ int iommu_register_device_fault_handler(struct device *dev,
 	struct dev_iommu *param = dev->iommu;
 	int ret = 0;
 
-	if (!param)
+	if (!param || !param->fault_param)
 		return -EINVAL;
 
 	mutex_lock(&param->lock);
 	/* Only allow one fault handler registered for each device */
-	if (param->fault_param) {
+	if (param->fault_param->handler) {
 		ret = -EBUSY;
 		goto done_unlock;
 	}
 
-	get_device(dev);
-	param->fault_param = kzalloc(sizeof(*param->fault_param), GFP_KERNEL);
-	if (!param->fault_param) {
-		put_device(dev);
-		ret = -ENOMEM;
-		goto done_unlock;
-	}
 	param->fault_param->handler = handler;
 	param->fault_param->data = data;
-	mutex_init(&param->fault_param->lock);
-	INIT_LIST_HEAD(&param->fault_param->faults);
 
 done_unlock:
 	mutex_unlock(&param->lock);
@@ -1396,29 +1387,16 @@ EXPORT_SYMBOL_GPL(iommu_register_device_fault_handler);
 int iommu_unregister_device_fault_handler(struct device *dev)
 {
 	struct dev_iommu *param = dev->iommu;
-	int ret = 0;
 
-	if (!param)
+	if (!param || !param->fault_param)
 		return -EINVAL;
 
 	mutex_lock(&param->lock);
-
-	if (!param->fault_param)
-		goto unlock;
-
-	/* we cannot unregister handler if there are pending faults */
-	if (!list_empty(&param->fault_param->faults)) {
-		ret = -EBUSY;
-		goto unlock;
-	}
-
-	kfree(param->fault_param);
-	param->fault_param = NULL;
-	put_device(dev);
-unlock:
+	param->fault_param->handler = NULL;
+	param->fault_param->data = NULL;
 	mutex_unlock(&param->lock);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler);
 
-- 
2.34.1


