Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3395E7801D3
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356206AbjHQXn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356183AbjHQXnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:43:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6227C35AA;
        Thu, 17 Aug 2023 16:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692315831; x=1723851831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nhvienGgYejuf8bTCeAruZ4dxDgfU3q8Je7kib+7Vb8=;
  b=e9/WH9JxWIUxtybg4KvPdcvL4rfyxX9iiodMsaD62q904bsckZ3Hi3Kq
   RQZFgo1emT59SjkAHnidUT4uoB3Y2gffgqLWba3ROvdbqtLkcHF5Iz2+O
   Nts45NaQzP+U835HGDpSeMAU6g5ooA+03rHk/Nr+39FOB9cexKEaKY/aX
   47sFw2yl2aX5YyzO3tetfLsJIRONQ4HdqITqx7SlMvNL8j1b2X0620Hjh
   G2kwADdm4NWJoqf3debHVCfO0wQyFcL2urCW2fTX5nP3APtjsNen/EDuN
   ailDaii4topumQbDxp/hXO3pl1vghhMGbn8Il8SnqBK2i4/bHB5heF/9s
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="352552060"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="352552060"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 16:43:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849051841"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="849051841"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2023 16:43:46 -0700
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
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 06/11] iommu: Remove iommu_[un]register_device_fault_handler()
Date:   Fri, 18 Aug 2023 07:40:42 +0800
Message-Id: <20230817234047.195194-7-baolu.lu@linux.intel.com>
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
---
 include/linux/iommu.h                         | 23 ------
 drivers/iommu/iommu-sva.h                     |  4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 13 +---
 drivers/iommu/intel/iommu.c                   | 24 ++----
 drivers/iommu/io-pgfault.c                    |  6 +-
 drivers/iommu/iommu.c                         | 76 +------------------
 6 files changed, 13 insertions(+), 133 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 78e14a7440f5..8243d72098ea 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -126,7 +126,6 @@ struct iommu_page_response {
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
-typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault *, void *);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -471,8 +470,6 @@ struct iommu_fault_event {
 
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
- * @handler: Callback function to handle IOMMU faults at device level
- * @data: handler private data
  * @lock: protect pending faults list
  * @dev: the device that owns this param
  * @queue: IOPF queue
@@ -482,8 +479,6 @@ struct iommu_fault_event {
  * @faults: holds the pending faults which needs response
  */
 struct iommu_fault_param {
-	iommu_dev_fault_handler_t handler;
-	void *data;
 	struct mutex			lock;
 
 	struct device			*dev;
@@ -616,11 +611,6 @@ extern int iommu_group_for_each_dev(struct iommu_group *group, void *data,
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
@@ -1006,19 +996,6 @@ static inline void iommu_group_put(struct iommu_group *group)
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
index 5e6b39881c04..7748ee30f8c0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -437,7 +437,6 @@ bool arm_smmu_master_sva_enabled(struct arm_smmu_master *master)
 
 static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master *master)
 {
-	int ret;
 	struct device *dev = master->dev;
 
 	/*
@@ -450,16 +449,7 @@ static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master *master)
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
@@ -469,7 +459,6 @@ static void arm_smmu_master_sva_disable_iopf(struct arm_smmu_master *master)
 	if (!master->iopf_enabled)
 		return;
 
-	iommu_unregister_device_fault_handler(dev);
 	iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
 }
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index dd8ff358867d..35839ef69089 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4574,23 +4574,15 @@ static int intel_iommu_enable_iopf(struct device *dev)
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
@@ -4613,11 +4605,9 @@ static int intel_iommu_disable_iopf(struct device *dev)
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
index b1cf28055525..31832aeacdba 100644
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
index 89e101baa08b..b280b9f4d8b4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1291,76 +1291,6 @@ void iommu_group_put(struct iommu_group *group)
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
@@ -1385,10 +1315,6 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 	/* we only report device fault if there is a handler registered */
 	mutex_lock(&param->lock);
 	fparam = param->fault_param;
-	if (!fparam || !fparam->handler) {
-		ret = -EINVAL;
-		goto done_unlock;
-	}
 
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
@@ -1403,7 +1329,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 		mutex_unlock(&fparam->lock);
 	}
 
-	ret = fparam->handler(&evt->fault, fparam->data);
+	ret = iommu_queue_iopf(&evt->fault, dev);
 	if (ret && evt_pending) {
 		mutex_lock(&fparam->lock);
 		list_del(&evt_pending->list);
-- 
2.34.1

