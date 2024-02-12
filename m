Return-Path: <kvm+bounces-8528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB03850CA7
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF2121C208AF
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492C911182;
	Mon, 12 Feb 2024 01:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ehJxlNZB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39BE10A1D;
	Mon, 12 Feb 2024 01:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701326; cv=none; b=VwiWRK3P7fjkq6loXBZdawQuKe/unGuwgeZjBRfIWvHgIhdAqug6Om7ptqin4TK4AVADXNFkfWFacx1f2EUOj5Y69RNGGMNYrhp7Qwfo6Lr7ICTkxzdbEjHdbFpmvkFKPWEn0fg4ZaPOUl3YmKOHAMv9vOWm313fdoB4lwqnQKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701326; c=relaxed/simple;
	bh=MGty7MXvXiBmt/yJPAFE623zh2+tD5+K5TfpR4ZPBfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JgOKnSkeioqhDy8kk9QKqxS/n2ZBTFfiztogsrn/XM7lnZQ9lTK5afyCQbFNWA0zUJHEQIzFyDCDvDNFzH81zf7Q5gsNilKhksJ6CaKJgIws8nvWSEYAtodE/Zwo6U7D850zg7YG2VvqLHdEPlC4LCOvbfZstQo661/mCxWystM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ehJxlNZB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701325; x=1739237325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MGty7MXvXiBmt/yJPAFE623zh2+tD5+K5TfpR4ZPBfA=;
  b=ehJxlNZBQ8nfDDN1aqohZcu/gYi3Bl42FpwKdSRS5gR9TewU7V2wtVKV
   PCpcSvlo7hLQx5g/om4lAr2PJx84lxqYPDDkinlECBBE2GIgzGJhCIwA2
   TK/e3JuRi/N+43cBTGhzkIwMZT1YDKDX+BvOTHHvEI3dSxGu+98ODzfvG
   r2Q0FuUkQFvDz7ccirscFalZOCRafPAj2Gzl+2T6A6dwo+kuwiibJPUUH
   caEkf67i67MHYltWYCjIliT1Bmi6QQESaS/cl7bW+ckMSyvym8290UAwt
   gS8M8OMQOWJMc1KjSxPZwg/Z3hmtGGB0RKrYPwPexKpke9quBuF59JFyh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502122"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502122"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:28:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132196"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:28:40 -0800
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
Subject: [PATCH v13 07/16] iommu: Merge iommu_fault_event and iopf_fault
Date: Mon, 12 Feb 2024 09:22:18 +0800
Message-Id: <20240212012227.119381-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240212012227.119381-1-baolu.lu@linux.intel.com>
References: <20240212012227.119381-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu_fault_event and iopf_fault data structures store the same
information about an iopf fault. They are also used in the same way.
Merge these two data structures into a single one to make the code
more concise and easier to maintain.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h                       | 27 ++++++---------------
 drivers/iommu/intel/iommu.h                 |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 +--
 drivers/iommu/intel/svm.c                   |  5 ++--
 drivers/iommu/io-pgfault.c                  |  5 ----
 drivers/iommu/iommu.c                       |  8 +++---
 6 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6e7f49da7579..2e0cbd263962 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -40,7 +40,6 @@ struct iommu_domain_ops;
 struct iommu_dirty_ops;
 struct notifier_block;
 struct iommu_sva;
-struct iommu_fault_event;
 struct iommu_dma_cookie;
 struct iopf_queue;
 
@@ -121,6 +120,11 @@ struct iommu_page_response {
 	u32	code;
 };
 
+struct iopf_fault {
+	struct iommu_fault fault;
+	/* node for pending lists */
+	struct list_head list;
+};
 
 /* iommu fault flags */
 #define IOMMU_FAULT_READ	0x0
@@ -553,7 +557,7 @@ struct iommu_ops {
 	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
 
 	int (*page_response)(struct device *dev,
-			     struct iommu_fault_event *evt,
+			     struct iopf_fault *evt,
 			     struct iommu_page_response *msg);
 
 	int (*def_domain_type)(struct device *dev);
@@ -654,20 +658,6 @@ struct iommu_device {
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
@@ -818,8 +808,7 @@ extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
 
-extern int iommu_report_device_fault(struct device *dev,
-				     struct iommu_fault_event *evt);
+extern int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
 extern int iommu_page_response(struct device *dev,
 			       struct iommu_page_response *msg);
 
@@ -1229,7 +1218,7 @@ static inline void iommu_group_put(struct iommu_group *group)
 }
 
 static inline
-int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
+int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	return -ENODEV;
 }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index d02f916d8e59..696d95293a69 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1079,7 +1079,7 @@ struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
 void intel_svm_check(struct intel_iommu *iommu);
 int intel_svm_enable_prq(struct intel_iommu *iommu);
 int intel_svm_finish_prq(struct intel_iommu *iommu);
-int intel_svm_page_response(struct device *dev, struct iommu_fault_event *evt,
+int intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
 			    struct iommu_page_response *msg);
 struct iommu_domain *intel_svm_domain_alloc(void);
 void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4cf1054ed321..ab4f04c7f932 100644
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
@@ -1465,7 +1465,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
 	u32 sid = FIELD_GET(EVTQ_0_SID, evt[0]);
-	struct iommu_fault_event fault_evt = { };
+	struct iopf_fault fault_evt = { };
 	struct iommu_fault *flt = &fault_evt.fault;
 
 	switch (FIELD_GET(EVTQ_0_ID, evt[0])) {
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 40edd282903f..9751f037e188 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -565,13 +565,12 @@ static int prq_to_iommu_prot(struct page_req_dsc *req)
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
@@ -743,7 +742,7 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 }
 
 int intel_svm_page_response(struct device *dev,
-			    struct iommu_fault_event *evt,
+			    struct iopf_fault *evt,
 			    struct iommu_page_response *msg)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 4fda01de5589..10d48eb72608 100644
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
index 744fcb8e756b..6c429921f219 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1360,10 +1360,10 @@ EXPORT_SYMBOL_GPL(iommu_group_put);
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
 
@@ -1376,7 +1376,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
-		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
+		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
 				      GFP_KERNEL);
 		if (!evt_pending) {
 			ret = -ENOMEM;
@@ -1405,7 +1405,7 @@ int iommu_page_response(struct device *dev,
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


