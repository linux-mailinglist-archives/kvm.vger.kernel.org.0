Return-Path: <kvm+bounces-7440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C73CC841D63
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 09:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBE85B261AD
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044926087E;
	Tue, 30 Jan 2024 08:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P8oEDy9e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75895605DE;
	Tue, 30 Jan 2024 08:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602473; cv=none; b=qSmYJvbD0JpARVJiIaKPe+mJ2eT7hfDUHOcJBzEstt06ShEDWmWOOqBeqHvusauDZZcN53cmDeH/KleQduQStZS9sWCn7Y+teV+atQ0+KTk8Gx2J7I3eAQw0DH3bMWjjIzjzNY6mNuqvOJ2Se5L+6FzUy4miHPTi7orU9R4/a6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602473; c=relaxed/simple;
	bh=M7OgNEo9Cq36hPsDNIxha4y5uVLNpY9KrqnA+1BTBaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WtsCMVTiuBSV8lUlkSh8rdcgUaytVVJmeoCXFxv+DWTCqIROYrftZR/rxeZ1PCxq1x+dVsz3JJARUUya1r58pX9aACyXHLuEns4fr9v4z4lWFB/ZJUygzqg8iWE8TxkUgSmr3kEnws7AZ+7sTdPTjD9Ao9Fi1pdjTrjWArLsGAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P8oEDy9e; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706602472; x=1738138472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M7OgNEo9Cq36hPsDNIxha4y5uVLNpY9KrqnA+1BTBaQ=;
  b=P8oEDy9eKGs8ieDE761y92eiPUUbxkvdhjkjmCwiVHP07nutMxgV+ppR
   waDibM0lb7BG0HfdXN7lSImuGGvJSZsGKRKGIv/W6tghtmJEGpxyxkfTM
   Nt+u39rTA/EY+m74+sQti+P+/RIr731SzMAKVy5XjM++cwlJxahWTFQiT
   xYgRqSdOZSpuQd5TDAgySfxXKbhv0ZbXRg24jNwgRV2wRUuHJsCxP7pGt
   G7mYFkeWELnu3+mG/HPXRQpHRVWDijNssmmtWeTgQRwRlIqCDnvKMRO4g
   e0g6FiJYBTj4w8lY5krOSRasQNNcwEvpcwoWXEvlBnBqwXDoiFAY01REn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="10588306"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="10588306"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:14:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="3633769"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa003.fm.intel.com with ESMTP; 30 Jan 2024 00:14:27 -0800
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
Subject: [PATCH v11 05/16] iommu: Merge iopf_device_param into iommu_fault_param
Date: Tue, 30 Jan 2024 16:08:24 +0800
Message-Id: <20240130080835.58921-6-baolu.lu@linux.intel.com>
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
index b88dc3e0595c..e8f2bcea7f51 100644
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


