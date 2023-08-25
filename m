Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9198B787DC1
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241308AbjHYCeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242119AbjHYCeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:34:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24B1BFD;
        Thu, 24 Aug 2023 19:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692930848; x=1724466848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o2nb6CjAxNzNuJzeTAaNW5Uel+hvUuw3xc8eExyhLNs=;
  b=ESZ5YaajGg2l1xZy6pile1W1wuJC8mc/hmwZmtvpyVd65s/1pUEYohnd
   FWoGWF4HmhXYsiaAE0oaJMrszc2j+h9n7sIfFIv0MQLM1wg5ohQE2fTJZ
   wpMBYofE4+y6y3wRx+6aM1ShI9aNPrxzmzKB1TmD7kwxN59lC3Sk3xaML
   D/pW4M+WSiuyFKaCCTlyy6ogkQaQcN/dBXPTi7tbBLqu+HpAgjvMCnl/T
   Yb77lcZKe6Kxc1wxmYnXnzZcPqfIXo8NF8vt0bihYMYAim5fUq4X+W+e0
   zlsXjzmQ88qoPaZXzivv40mB0LWZzZpwpkVnzJSDtAOO6sX57XzHuE9xy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="372009616"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="372009616"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 19:33:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="730875092"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="730875092"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 24 Aug 2023 19:33:41 -0700
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
Subject: [PATCH v4 07/10] iommu: Merge iommu_fault_event and iopf_fault
Date:   Fri, 25 Aug 2023 10:30:23 +0800
Message-Id: <20230825023026.132919-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230825023026.132919-1-baolu.lu@linux.intel.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
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

The iommu_fault_event and iopf_fault data structures store the same
information about an iopf fault. They are also used in the same way.
Merge these two data structures into a single one to make the code
more concise and easier to maintain.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h                       | 27 ++++++---------------
 drivers/iommu/intel/iommu.h                 |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 +--
 drivers/iommu/intel/svm.c                   |  5 ++--
 drivers/iommu/io-pgfault.c                  |  5 ----
 drivers/iommu/iommu.c                       |  8 +++---
 6 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3488da75d949..7c5781732665 100644
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
@@ -357,7 +361,7 @@ struct iommu_ops {
 	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
 
 	int (*page_response)(struct device *dev,
-			     struct iommu_fault_event *evt,
+			     struct iopf_fault *evt,
 			     struct iommu_page_response *msg);
 
 	int (*def_domain_type)(struct device *dev);
@@ -450,20 +454,6 @@ struct iommu_device {
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
 
@@ -990,7 +979,7 @@ static inline void iommu_group_put(struct iommu_group *group)
 }
 
 static inline
-int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
+int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	return -ENODEV;
 }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index c18fb699c87a..66221bb206f4 100644
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
index 90b281eda73f..e537b6c046c5 100644
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
index 9fbae9af6615..9e8d4d75d293 100644
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
index 8c541af107e8..a7f6d0ec0400 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1261,10 +1261,10 @@ EXPORT_SYMBOL_GPL(iommu_group_put);
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
 
@@ -1277,7 +1277,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
-		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
+		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
 				      GFP_KERNEL);
 		if (!evt_pending) {
 			ret = -ENOMEM;
@@ -1306,7 +1306,7 @@ int iommu_page_response(struct device *dev,
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

