Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A131D7B1193
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 06:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjI1Eb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 00:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjI1Ebf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 00:31:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C20CED;
        Wed, 27 Sep 2023 21:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695875485; x=1727411485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6yoOmweSJ/vdeCEKQ4PPMo8qS5GNR/XAZbNlJKukJQ8=;
  b=U7klKKku0isr89Eync3x3mDEGNqL+n4oiGd5tuTyKbQevfHz77yRctFU
   QbwQ9VSmq8GoTTFb8ywwAh+rdjRf1mXPhuh2Drn8d1clGA+6dcMfcyY3p
   MDGGOAPUBgoCzw7wJwbPT0lwQC4N71AHFyQAutoiaiOIO/5DZOYkfAW7e
   ii5IUCh0OdcV5lV6QcnRHsRYvZhW9+qtEe0a1b//oDwFQNHXWIKa5fT1B
   FifqWw+MegdGC7jJxnEhcxfbIwoQUceEGCmTsaBvQV6D+I5Zh1aXX8AjU
   N5jnVYTSNiIE9mKsd/xS9LcDaCdUUxecVXI0uExTEo/7kd8ZxHTotDiIX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="379260512"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="379260512"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 21:31:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="923068969"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="923068969"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga005.jf.intel.com with ESMTP; 27 Sep 2023 21:31:21 -0700
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
Subject: [PATCH v6 07/12] iommu: Merge iommu_fault_event and iopf_fault
Date:   Thu, 28 Sep 2023 12:27:29 +0800
Message-Id: <20230928042734.16134-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928042734.16134-1-baolu.lu@linux.intel.com>
References: <20230928042734.16134-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu_fault_event and iopf_fault data structures store the same
information about an iopf fault. They are also used in the same way.
Merge these two data structures into a single one to make the code
more concise and easier to maintain.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/iommu.h                       | 27 ++++++---------------
 drivers/iommu/intel/iommu.h                 |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 +--
 drivers/iommu/intel/svm.c                   |  5 ++--
 drivers/iommu/io-pgfault.c                  |  5 ----
 drivers/iommu/iommu.c                       |  8 +++---
 6 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1dedaddfcac5..53fe4b2c8e64 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -38,7 +38,6 @@ struct iommu_domain;
 struct iommu_domain_ops;
 struct notifier_block;
 struct iommu_sva;
-struct iommu_fault_event;
 struct iommu_dma_cookie;
 struct iopf_queue;
 
@@ -119,6 +118,11 @@ struct iommu_page_response {
 	u32	code;
 };
 
+struct iopf_fault {
+	struct iommu_fault fault;
+	/* node for pending lists */
+	struct list_head list;
+};
 
 /* iommu fault flags */
 #define IOMMU_FAULT_READ	0x0
@@ -370,7 +374,7 @@ struct iommu_ops {
 	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
 
 	int (*page_response)(struct device *dev,
-			     struct iommu_fault_event *evt,
+			     struct iopf_fault *evt,
 			     struct iommu_page_response *msg);
 
 	int (*def_domain_type)(struct device *dev);
@@ -461,20 +465,6 @@ struct iommu_device {
 	u32 max_pasids;
 };
 
-/**
- * struct iommu_fault_event - Generic fault event
- *
- * Can represent recoverable faults such as a page requests or
- * unrecoverable faults such as DMA or IRQ remapping faults.
- *
- * @fault: fault descriptor
- * @list: pending fault event list, used for tracking responses
- */
-struct iommu_fault_event {
-	struct iommu_fault fault;
-	struct list_head list;
-};
-
 /**
  * struct iommu_fault_param - per-device IOMMU fault data
  * @lock: protect pending faults list
@@ -607,8 +597,7 @@ extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
 
-extern int iommu_report_device_fault(struct device *dev,
-				     struct iommu_fault_event *evt);
+extern int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
 extern int iommu_page_response(struct device *dev,
 			       struct iommu_page_response *msg);
 
@@ -991,7 +980,7 @@ static inline void iommu_group_put(struct iommu_group *group)
 }
 
 static inline
-int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
+int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	return -ENODEV;
 }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 7dac94f62b4e..0f7c9bf0df45 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -847,7 +847,7 @@ struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn);
 void intel_svm_check(struct intel_iommu *iommu);
 int intel_svm_enable_prq(struct intel_iommu *iommu);
 int intel_svm_finish_prq(struct intel_iommu *iommu);
-int intel_svm_page_response(struct device *dev, struct iommu_fault_event *evt,
+int intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
 			    struct iommu_page_response *msg);
 struct iommu_domain *intel_svm_domain_alloc(void);
 void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a2a67b0a8261..bdc5b5a465b9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -922,7 +922,7 @@ static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
 }
 
 static int arm_smmu_page_response(struct device *dev,
-				  struct iommu_fault_event *unused,
+				  struct iopf_fault *unused,
 				  struct iommu_page_response *resp)
 {
 	struct arm_smmu_cmdq_ent cmd = {0};
@@ -1473,7 +1473,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
 	u32 sid = FIELD_GET(EVTQ_0_SID, evt[0]);
-	struct iommu_fault_event fault_evt = { };
+	struct iopf_fault fault_evt = { };
 	struct iommu_fault *flt = &fault_evt.fault;
 
 	switch (FIELD_GET(EVTQ_0_ID, evt[0])) {
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 50a481c895b8..9de349ea215c 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -543,13 +543,12 @@ static int prq_to_iommu_prot(struct page_req_dsc *req)
 static int intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
 				struct page_req_dsc *desc)
 {
-	struct iommu_fault_event event;
+	struct iopf_fault event = { };
 
 	if (!dev || !dev_is_pci(dev))
 		return -ENODEV;
 
 	/* Fill in event data for device specific processing */
-	memset(&event, 0, sizeof(struct iommu_fault_event));
 	event.fault.type = IOMMU_FAULT_PAGE_REQ;
 	event.fault.prm.addr = (u64)desc->addr << VTD_PAGE_SHIFT;
 	event.fault.prm.pasid = desc->pasid;
@@ -721,7 +720,7 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 }
 
 int intel_svm_page_response(struct device *dev,
-			    struct iommu_fault_event *evt,
+			    struct iopf_fault *evt,
 			    struct iommu_page_response *msg)
 {
 	struct iommu_fault_page_request *prm;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 31832aeacdba..c45977bb7da3 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -25,11 +25,6 @@ struct iopf_queue {
 	struct mutex			lock;
 };
 
-struct iopf_fault {
-	struct iommu_fault		fault;
-	struct list_head		list;
-};
-
 struct iopf_group {
 	struct iopf_fault		last_fault;
 	struct list_head		faults;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index db05079d4748..238e86c50727 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1311,10 +1311,10 @@ EXPORT_SYMBOL_GPL(iommu_group_put);
  *
  * Return 0 on success, or an error.
  */
-int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
+int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	struct dev_iommu *param = dev->iommu;
-	struct iommu_fault_event *evt_pending = NULL;
+	struct iopf_fault *evt_pending = NULL;
 	struct iommu_fault_param *fparam;
 	int ret = 0;
 
@@ -1327,7 +1327,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
-		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
+		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
 				      GFP_KERNEL);
 		if (!evt_pending) {
 			ret = -ENOMEM;
@@ -1356,7 +1356,7 @@ int iommu_page_response(struct device *dev,
 {
 	bool needs_pasid;
 	int ret = -EINVAL;
-	struct iommu_fault_event *evt;
+	struct iopf_fault *evt;
 	struct iommu_fault_page_request *prm;
 	struct dev_iommu *param = dev->iommu;
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
-- 
2.34.1

