Return-Path: <kvm+bounces-8176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 328BE84C203
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE36328B449
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776791CFA7;
	Wed,  7 Feb 2024 01:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dhwee2gn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0201CF8D;
	Wed,  7 Feb 2024 01:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707269984; cv=none; b=Rtoxr5Yyu5Z3meZMHosyoIEbyLDjQC3djpvdVn5itcf8SuGY5z738u+ne3s0uMqdEMIVonmOfw7nagWfnpOzezKYIgUsGl9Zn58e3PWfGDnYxfa2qz4BaJRH95Vh96GPaE7K6a6TGCVbpPP29U/2DX4MfpH3lWLVun2g7SOEAls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707269984; c=relaxed/simple;
	bh=68dA5qaC4AxXnKb56F3Lk/kkSNmeK0O7Qf8i/YceZZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f9RsBqQHGlcZz5TsDnrNB2O/kAMgoT0VopauyGKUvqpfMGnWRWAwkTRHE8j0NxNONd7PC3VLJmn80SoYSfzYRk6s7Jvie/2lOJ8AcU2WdhN/qbrCPCn+i9lFTs8p210uGftGNHXIMYRZHII66+GjWBRIGaExHK14x6u5XTMfovM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dhwee2gn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707269982; x=1738805982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=68dA5qaC4AxXnKb56F3Lk/kkSNmeK0O7Qf8i/YceZZM=;
  b=Dhwee2gnfSg0QCnms9f9cHTETJNjbMRKeKm19pz/G9ZDPBzBOOtuJa/9
   wMBOgQ/lgh7ckV/oY3MCrT4DtxdsJqrS0wT1CGa9UoLa5QYaIDY3cjNz4
   pOFGym9DyjaJE/WyJmwa9bvOydKu3YjmJH2Y+c6TuC22ecmQ64p2qj+bw
   LiLrF4sqrvA5n5IX3pfo6NjOpm2K8wuUvf4w9lMBVWUoLnXTAu8231KL2
   izs6fcyECHlHdZmq8vvf9Vrajs7JRBfUgq+VSV8ZZlNs6c4iVI5t47Qhh
   D7Ev6dyU00j9IBtUIWy642mY/GJov/pHplz0i92DZAhukQjtIHnOS47lr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11534124"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11534124"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:39:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190658"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:39:37 -0800
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
Subject: [PATCH v12 07/16] iommu: Merge iommu_fault_event and iopf_fault
Date: Wed,  7 Feb 2024 09:33:16 +0800
Message-Id: <20240207013325.95182-8-baolu.lu@linux.intel.com>
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
index 70176c1c5573..2320548a90f8 100644
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
@@ -802,8 +792,7 @@ extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
 
-extern int iommu_report_device_fault(struct device *dev,
-				     struct iommu_fault_event *evt);
+extern int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
 extern int iommu_page_response(struct device *dev,
 			       struct iommu_page_response *msg);
 
@@ -1213,7 +1202,7 @@ static inline void iommu_group_put(struct iommu_group *group)
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
index 5cb81dbe8d9d..15d7b2914780 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1341,10 +1341,10 @@ EXPORT_SYMBOL_GPL(iommu_group_put);
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
 
@@ -1357,7 +1357,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 
 	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
 	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
-		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
+		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
 				      GFP_KERNEL);
 		if (!evt_pending) {
 			ret = -ENOMEM;
@@ -1386,7 +1386,7 @@ int iommu_page_response(struct device *dev,
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


