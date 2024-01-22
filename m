Return-Path: <kvm+bounces-6511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33216835A95
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 06:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC9931F258B7
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 05:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EEB39FC4;
	Mon, 22 Jan 2024 05:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uwyc6mhh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F353A39AED;
	Mon, 22 Jan 2024 05:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705902583; cv=none; b=GAxQ3nsAJNoB3RZv/Fe3dx7xB/y8wLVbLSKE4SEFbJ4OJsWBU0ifpasodUjwqzJ43NQ5q1nyxV9+sdGpohg6MCexmE7kcr6i+znnwEPCe3riLIZodke5eqXt6dm6BEZDvwqgIh82KG/WfaVrGncKhj6eNF5x862hTIqOrSR7Mjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705902583; c=relaxed/simple;
	bh=BLtxq+XOleGqe8WYTNfjgRlN9LqjjrbkeOKmLxK4Prk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Anqe+q5b94p30eOXMW7zMx8rE8D4kwVE1HMzaCLsYazkMlPR9H/I2ar/G/6zVeT9v1Irc3W2fKA6i+niFenN8D57rO+iWQpxt59wky5gZ/5wiYh5kuE0bP/tqeZeyYpVeE3LcohzX5JdYGWfVxQuM6wvsoXD3Fj8gPYyaPbOxPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uwyc6mhh; arc=none smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705902581; x=1737438581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BLtxq+XOleGqe8WYTNfjgRlN9LqjjrbkeOKmLxK4Prk=;
  b=Uwyc6mhhGX1WfOLOUz/tiw8ZzaKB9Hu3KD6SBA2PMBAmhztiKzDQd1UM
   JKxmjn5HRzbzSnoXi3FCsV5SPIlwL74mPDn4nHnAtHOkoj50J7Q1z7/dt
   9xILUkXORr/DZEwZ9Uk120hh1CUpjaLWo4NI/KbDNpEno9e3PzgVfr1NC
   pM04l1aMcDKJg6JlAlBf6NAz0PGksaujfTSIkRomsLNRqJ7eO6Qy+HFWp
   9UGGIZvTyBNKpqlgFBOOu2TTUOnbVrsiw2eH16xUmD8SQDssxJ1L8FtiV
   OXFI+4GLtMh/ml1W3gVdFgDw8SqAjhywQXi/dCaSfJstMsiblg2j/Ldic
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="467487308"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="467487308"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 21:49:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1116764074"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1116764074"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2024 21:49:36 -0800
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
Subject: [PATCH v10 16/16] iommu: Make iommu_report_device_fault() reutrn void
Date: Mon, 22 Jan 2024 13:43:08 +0800
Message-Id: <20240122054308.23901-17-baolu.lu@linux.intel.com>
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

As the iommu_report_device_fault() has been converted to auto-respond a
page fault if it fails to enqueue it, there's no need to return a code
in any case. Make it return void.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h                       |  5 ++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 ++--
 drivers/iommu/intel/svm.c                   | 19 +++++++----------
 drivers/iommu/io-pgfault.c                  | 23 +++++++--------------
 4 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d7b6f4017254..1ccad10e8164 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1549,7 +1549,7 @@ struct iopf_queue *iopf_queue_alloc(const char *name);
 void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
 void iopf_free_group(struct iopf_group *group);
-int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
+void iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
 void iopf_group_response(struct iopf_group *group,
 			 enum iommu_page_response_code status);
 #else
@@ -1587,10 +1587,9 @@ static inline void iopf_free_group(struct iopf_group *group)
 {
 }
 
-static inline int
+static inline void
 iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
-	return -ENODEV;
 }
 
 static inline void iopf_group_response(struct iopf_group *group,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 42eb59cb99f4..02580364acda 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1455,7 +1455,7 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 /* IRQ and event handlers */
 static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 {
-	int ret;
+	int ret = 0;
 	u32 perm = 0;
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
@@ -1511,7 +1511,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 		goto out_unlock;
 	}
 
-	ret = iommu_report_device_fault(master->dev, &fault_evt);
+	iommu_report_device_fault(master->dev, &fault_evt);
 out_unlock:
 	mutex_unlock(&smmu->streams_mutex);
 	return ret;
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 2f8716636dbb..b644d57da841 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -561,14 +561,11 @@ static int prq_to_iommu_prot(struct page_req_dsc *req)
 	return prot;
 }
 
-static int intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
-				struct page_req_dsc *desc)
+static void intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
+				 struct page_req_dsc *desc)
 {
 	struct iopf_fault event = { };
 
-	if (!dev || !dev_is_pci(dev))
-		return -ENODEV;
-
 	/* Fill in event data for device specific processing */
 	event.fault.type = IOMMU_FAULT_PAGE_REQ;
 	event.fault.prm.addr = (u64)desc->addr << VTD_PAGE_SHIFT;
@@ -601,7 +598,7 @@ static int intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
 		event.fault.prm.private_data[0] = ktime_to_ns(ktime_get());
 	}
 
-	return iommu_report_device_fault(dev, &event);
+	iommu_report_device_fault(dev, &event);
 }
 
 static void handle_bad_prq_event(struct intel_iommu *iommu,
@@ -704,12 +701,10 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 		if (!pdev)
 			goto bad_req;
 
-		if (intel_svm_prq_report(iommu, &pdev->dev, req))
-			handle_bad_prq_event(iommu, req, QI_RESP_INVALID);
-		else
-			trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
-					 req->priv_data[0], req->priv_data[1],
-					 iommu->prq_seq_number++);
+		intel_svm_prq_report(iommu, &pdev->dev, req);
+		trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
+				 req->priv_data[0], req->priv_data[1],
+				 iommu->prq_seq_number++);
 		pci_dev_put(pdev);
 prq_advance:
 		head = (head + sizeof(*req)) & PRQ_RING_MASK;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 6e63e5a02884..b64229dab976 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -179,23 +179,21 @@ static struct iopf_group *iopf_group_alloc(struct iommu_fault_param *iopf_param,
  *
  * Return: 0 on success and <0 on error.
  */
-int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
+void iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	struct iommu_fault *fault = &evt->fault;
 	struct iommu_fault_param *iopf_param;
 	struct iopf_group abort_group = {};
 	struct iopf_group *group;
-	int ret;
 
 	iopf_param = iopf_get_dev_fault_param(dev);
 	if (WARN_ON(!iopf_param))
-		return -ENODEV;
+		return;
 
 	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
-		ret = report_partial_fault(iopf_param, fault);
+		report_partial_fault(iopf_param, fault);
 		iopf_put_dev_fault_param(iopf_param);
 		/* A request that is not the last does not need to be ack'd */
-		return ret;
 	}
 
 	/*
@@ -207,25 +205,21 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 	 * leaving, otherwise partial faults will be stuck.
 	 */
 	group = iopf_group_alloc(iopf_param, evt, &abort_group);
-	if (group == &abort_group) {
-		ret = -ENOMEM;
+	if (group == &abort_group)
 		goto err_abort;
-	}
 
 	group->domain = get_domain_for_iopf(dev, fault);
-	if (!group->domain) {
-		ret = -EINVAL;
+	if (!group->domain)
 		goto err_abort;
-	}
 
 	/*
 	 * On success iopf_handler must call iopf_group_response() and
 	 * iopf_free_group()
 	 */
-	ret = group->domain->iopf_handler(group);
-	if (ret)
+	if (group->domain->iopf_handler(group))
 		goto err_abort;
-	return 0;
+
+	return;
 
 err_abort:
 	iopf_group_response(group, IOMMU_PAGE_RESP_FAILURE);
@@ -233,7 +227,6 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 		__iopf_free_group(group);
 	else
 		iopf_free_group(group);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_report_device_fault);
 
-- 
2.34.1


