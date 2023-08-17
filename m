Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4216C7801D0
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356195AbjHQXn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356181AbjHQXns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:43:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE432D64;
        Thu, 17 Aug 2023 16:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692315827; x=1723851827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=acuNhuaNmcBvJkylPFZgd5i0ZqRSl0hayLxvR0i2OtU=;
  b=F4FKx+Hp8K7TSNYJKwEu1kX9rZHWsEvG0umaCWRkIDfSyM9g55b7+kWY
   mYOkbVfBQplBtjcbssOATe5QdBgNRt21EalEQiXSlT/FiTqWfusExIGoN
   l4WkQh86gxnTzHoMQYgio99Umb9ds4yVLBnZUEVkt9xN1aEiQ2F3ERuCK
   fFb8qW8vhIqoe+ed+u4YhP/S0d7AA58phfkkcwW6CBokmP6lMSn+HlUN3
   0w/G442t62spylzGPyqBPyxH9Y5vh7uw3RbcskmvvuRUHJ6MOisZhz2N/
   qcvYOs9oTKdjkNgNbtaXZD1lxENaQELwV/Fq3N37CPmGTsHItCN/uvGg6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="352552044"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="352552044"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 16:43:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849051816"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="849051816"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2023 16:43:42 -0700
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
Subject: [PATCH v3 05/11] iommu: Merge iopf_device_param into iommu_fault_param
Date:   Fri, 18 Aug 2023 07:40:41 +0800
Message-Id: <20230817234047.195194-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230817234047.195194-1-baolu.lu@linux.intel.com>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 include/linux/iommu.h      |  20 +++++--
 drivers/iommu/io-pgfault.c | 113 ++++++++++++++++++-------------------
 drivers/iommu/iommu.c      |  34 ++---------
 3 files changed, 76 insertions(+), 91 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index fd11bfa278f1..78e14a7440f5 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -40,6 +40,7 @@ struct notifier_block;
 struct iommu_sva;
 struct iommu_fault_event;
 struct iommu_dma_cookie;
+struct iopf_queue;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -472,21 +473,31 @@ struct iommu_fault_event {
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
+ * @faults: holds the pending faults which needs response
  */
 struct iommu_fault_param {
 	iommu_dev_fault_handler_t handler;
 	void *data;
-	struct list_head faults;
-	struct mutex lock;
+	struct mutex			lock;
+
+	struct device			*dev;
+	struct iopf_queue		*queue;
+	struct list_head		queue_list;
+
+	struct list_head		partial;
+	struct list_head		faults;
 };
 
 /**
  * struct dev_iommu - Collection of per-device IOMMU data
  *
  * @fault_param: IOMMU detected device fault reporting data
- * @iopf_param:	 I/O Page Fault queue and data
  * @fwspec:	 IOMMU fwspec data
  * @iommu_dev:	 IOMMU device this device is linked to
  * @priv:	 IOMMU Driver private data
@@ -501,7 +512,6 @@ struct iommu_fault_param {
 struct dev_iommu {
 	struct mutex lock;
 	struct iommu_fault_param	*fault_param;
-	struct iopf_device_param	*iopf_param;
 	struct iommu_fwspec		*fwspec;
 	struct iommu_device		*iommu_dev;
 	void				*priv;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 24b5545352ae..b1cf28055525 100644
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
@@ -287,34 +272,38 @@ EXPORT_SYMBOL_GPL(iopf_queue_discard_partial);
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
+	get_device(dev);
+	fault_param = kzalloc(sizeof(*fault_param), GFP_KERNEL);
+	if (!fault_param) {
+		put_device(dev);
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
@@ -330,34 +319,42 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
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
+	put_device(dev);
+unlock:
+	mutex_unlock(&param->lock);
+	mutex_unlock(&queue->lock);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_queue_remove_device);
 
@@ -403,7 +400,7 @@ EXPORT_SYMBOL_GPL(iopf_queue_alloc);
  */
 void iopf_queue_free(struct iopf_queue *queue)
 {
-	struct iopf_device_param *iopf_param, *next;
+	struct iommu_fault_param *iopf_param, *next;
 
 	if (!queue)
 		return;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1aae0264bbb8..89e101baa08b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1316,27 +1316,18 @@ int iommu_register_device_fault_handler(struct device *dev,
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
@@ -1357,29 +1348,16 @@ EXPORT_SYMBOL_GPL(iommu_register_device_fault_handler);
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

