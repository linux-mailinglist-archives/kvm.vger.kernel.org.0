Return-Path: <kvm+bounces-8536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0FF2850CB8
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86A03287916
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1900C18C1A;
	Mon, 12 Feb 2024 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hwvmQ4X5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D93182BE;
	Mon, 12 Feb 2024 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701360; cv=none; b=VPsjLz13ePv8SZzdZepqXtWUlTRcoaJ+2OSPsafynPx3n2CwokY/wnSWId/qHyNIx0ij/wU0EJxgr5s8yWwwI0Xjac/YidA062Cy8UJvC4r4bDcwVXI8eAHGv8kvTO/nO5L213kfJgMl5s5DaaEN72f2vyhtYlOu4Q7fLWiKitQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701360; c=relaxed/simple;
	bh=ScQlebitAFUkQStyFkq+BY6F131u3iItGv4qW/SNHxc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sc+kweDhYWR28QTn28W2Y46xC8PDldVY2eim2fnnAtvtw8PTS+RvIZtG3yWxTwcF+wFA0+jrcLm9CrfZdRfnt3glT3L3ZY4DpllQAg3kEda99XctngRcD/1gngqdulc47qxCPFSHGRkClzIqbGM4Bacxu4KNHnJCQ2bhZsrTJoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hwvmQ4X5; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701357; x=1739237357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ScQlebitAFUkQStyFkq+BY6F131u3iItGv4qW/SNHxc=;
  b=hwvmQ4X5ujFyddIn1wcf4ATl92nrXmpeUYkKi8Kt3tqBOqAgiwODGsii
   BsfpZ/c3+QTcfZj0lbr6QgasMD7LDir+O04/IN6qOdM91WAPNs/Rjr7IH
   1F2/xwzdRwdLMoHokNa91wthygYueIEobIIil5LHaRJHj5oMgoYhdS5Zv
   3lx5ntU/gyox2wl5hTNTVOOLUp7ocI0uSWveu3xQUhkrC+pGrdakoL2kQ
   RWUrw1qnVutTuGFWRRMaYEijBP7lYh4hsQzcZ9AgXV/kcm/ZYCK/KM3+8
   47Ff5WXPQpqQl0t+c/jGAnd5QXVAvvXhp0Q+gJG8p9jPGNK06zLxufwEq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502211"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502211"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:29:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132264"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:29:13 -0800
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
Subject: [PATCH v13 15/16] iommu: Make iopf_group_response() return void
Date: Mon, 12 Feb 2024 09:22:26 +0800
Message-Id: <20240212012227.119381-16-baolu.lu@linux.intel.com>
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

The iopf_group_response() should return void, as nothing can do anything
with the failure. This implies that ops->page_response() must also return
void; this is consistent with what the drivers do. The failure paths,
which are all integrity validations of the fault, should be WARN_ON'd,
not return codes.

If the iommu core fails to enqueue the fault, it should respond the fault
directly by calling ops->page_response() instead of returning an error
number and relying on the iommu drivers to do so. Consolidate the error
fault handling code in the core.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/iommu.h                       |  14 +-
 drivers/iommu/intel/iommu.h                 |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  50 +++-----
 drivers/iommu/intel/svm.c                   |  18 +--
 drivers/iommu/io-pgfault.c                  | 134 +++++++++++---------
 5 files changed, 99 insertions(+), 121 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index beb9c53f06bb..326aae1ab3a2 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -574,9 +574,8 @@ struct iommu_ops {
 	int (*dev_enable_feat)(struct device *dev, enum iommu_dev_features f);
 	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
 
-	int (*page_response)(struct device *dev,
-			     struct iopf_fault *evt,
-			     struct iommu_page_response *msg);
+	void (*page_response)(struct device *dev, struct iopf_fault *evt,
+			      struct iommu_page_response *msg);
 
 	int (*def_domain_type)(struct device *dev);
 	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
@@ -1571,8 +1570,8 @@ void iopf_queue_free(struct iopf_queue *queue);
 int iopf_queue_discard_partial(struct iopf_queue *queue);
 void iopf_free_group(struct iopf_group *group);
 int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
-int iopf_group_response(struct iopf_group *group,
-			enum iommu_page_response_code status);
+void iopf_group_response(struct iopf_group *group,
+			 enum iommu_page_response_code status);
 #else
 static inline int
 iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
@@ -1614,10 +1613,9 @@ iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 	return -ENODEV;
 }
 
-static inline int iopf_group_response(struct iopf_group *group,
-				      enum iommu_page_response_code status)
+static inline void iopf_group_response(struct iopf_group *group,
+				       enum iommu_page_response_code status)
 {
-	return -ENODEV;
 }
 #endif /* CONFIG_IOMMU_IOPF */
 #endif /* __LINUX_IOMMU_H */
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 696d95293a69..cf9a28c7fab8 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1079,8 +1079,8 @@ struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
 void intel_svm_check(struct intel_iommu *iommu);
 int intel_svm_enable_prq(struct intel_iommu *iommu);
 int intel_svm_finish_prq(struct intel_iommu *iommu);
-int intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
-			    struct iommu_page_response *msg);
+void intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
+			     struct iommu_page_response *msg);
 struct iommu_domain *intel_svm_domain_alloc(void);
 void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
 void intel_drain_pasid_prq(struct device *dev, u32 pasid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4e93e845458c..42eb59cb99f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -920,31 +920,29 @@ static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
 	return arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmds, cmds->num, true);
 }
 
-static int arm_smmu_page_response(struct device *dev,
-				  struct iopf_fault *unused,
-				  struct iommu_page_response *resp)
+static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused,
+				   struct iommu_page_response *resp)
 {
 	struct arm_smmu_cmdq_ent cmd = {0};
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	int sid = master->streams[0].id;
 
-	if (master->stall_enabled) {
-		cmd.opcode		= CMDQ_OP_RESUME;
-		cmd.resume.sid		= sid;
-		cmd.resume.stag		= resp->grpid;
-		switch (resp->code) {
-		case IOMMU_PAGE_RESP_INVALID:
-		case IOMMU_PAGE_RESP_FAILURE:
-			cmd.resume.resp = CMDQ_RESUME_0_RESP_ABORT;
-			break;
-		case IOMMU_PAGE_RESP_SUCCESS:
-			cmd.resume.resp = CMDQ_RESUME_0_RESP_RETRY;
-			break;
-		default:
-			return -EINVAL;
-		}
-	} else {
-		return -ENODEV;
+	if (WARN_ON(!master->stall_enabled))
+		return;
+
+	cmd.opcode		= CMDQ_OP_RESUME;
+	cmd.resume.sid		= sid;
+	cmd.resume.stag		= resp->grpid;
+	switch (resp->code) {
+	case IOMMU_PAGE_RESP_INVALID:
+	case IOMMU_PAGE_RESP_FAILURE:
+		cmd.resume.resp = CMDQ_RESUME_0_RESP_ABORT;
+		break;
+	case IOMMU_PAGE_RESP_SUCCESS:
+		cmd.resume.resp = CMDQ_RESUME_0_RESP_RETRY;
+		break;
+	default:
+		break;
 	}
 
 	arm_smmu_cmdq_issue_cmd(master->smmu, &cmd);
@@ -954,8 +952,6 @@ static int arm_smmu_page_response(struct device *dev,
 	 * terminated... at some point in the future. PRI_RESP is fire and
 	 * forget.
 	 */
-
-	return 0;
 }
 
 /* Context descriptor manipulation functions */
@@ -1516,16 +1512,6 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	}
 
 	ret = iommu_report_device_fault(master->dev, &fault_evt);
-	if (ret && flt->type == IOMMU_FAULT_PAGE_REQ) {
-		/* Nobody cared, abort the access */
-		struct iommu_page_response resp = {
-			.pasid		= flt->prm.pasid,
-			.grpid		= flt->prm.grpid,
-			.code		= IOMMU_PAGE_RESP_FAILURE,
-		};
-		arm_smmu_page_response(master->dev, &fault_evt, &resp);
-	}
-
 out_unlock:
 	mutex_unlock(&smmu->streams_mutex);
 	return ret;
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index e1cbcb9515f0..2f8716636dbb 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -740,9 +740,8 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 	return IRQ_RETVAL(handled);
 }
 
-int intel_svm_page_response(struct device *dev,
-			    struct iopf_fault *evt,
-			    struct iommu_page_response *msg)
+void intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
+			     struct iommu_page_response *msg)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
@@ -751,7 +750,6 @@ int intel_svm_page_response(struct device *dev,
 	bool private_present;
 	bool pasid_present;
 	bool last_page;
-	int ret = 0;
 	u16 sid;
 
 	prm = &evt->fault.prm;
@@ -760,16 +758,6 @@ int intel_svm_page_response(struct device *dev,
 	private_present = prm->flags & IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA;
 	last_page = prm->flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
 
-	if (!pasid_present) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (prm->pasid == 0 || prm->pasid >= PASID_MAX) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/*
 	 * Per VT-d spec. v3.0 ch7.7, system software must respond
 	 * with page group response if private data is present (PDP)
@@ -798,8 +786,6 @@ int intel_svm_page_response(struct device *dev,
 
 		qi_submit_sync(iommu, &desc, 1, 0);
 	}
-out:
-	return ret;
 }
 
 static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 05e49e2e6a52..6a325bff8164 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -39,7 +39,7 @@ static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
 		kfree_rcu(fault_param, rcu);
 }
 
-void iopf_free_group(struct iopf_group *group)
+static void __iopf_free_group(struct iopf_group *group)
 {
 	struct iopf_fault *iopf, *next;
 
@@ -50,6 +50,11 @@ void iopf_free_group(struct iopf_group *group)
 
 	/* Pair with iommu_report_device_fault(). */
 	iopf_put_dev_fault_param(group->fault_param);
+}
+
+void iopf_free_group(struct iopf_group *group)
+{
+	__iopf_free_group(group);
 	kfree(group);
 }
 EXPORT_SYMBOL_GPL(iopf_free_group);
@@ -97,14 +102,49 @@ static int report_partial_fault(struct iommu_fault_param *fault_param,
 	return 0;
 }
 
+static struct iopf_group *iopf_group_alloc(struct iommu_fault_param *iopf_param,
+					   struct iopf_fault *evt,
+					   struct iopf_group *abort_group)
+{
+	struct iopf_fault *iopf, *next;
+	struct iopf_group *group;
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group) {
+		/*
+		 * We always need to construct the group as we need it to abort
+		 * the request at the driver if it can't be handled.
+		 */
+		group = abort_group;
+	}
+
+	group->fault_param = iopf_param;
+	group->last_fault.fault = evt->fault;
+	INIT_LIST_HEAD(&group->faults);
+	INIT_LIST_HEAD(&group->pending_node);
+	list_add(&group->last_fault.list, &group->faults);
+
+	/* See if we have partial faults for this group */
+	mutex_lock(&iopf_param->lock);
+	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
+		if (iopf->fault.prm.grpid == evt->fault.prm.grpid)
+			/* Insert *before* the last fault */
+			list_move(&iopf->list, &group->faults);
+	}
+	list_add(&group->pending_node, &iopf_param->faults);
+	mutex_unlock(&iopf_param->lock);
+
+	return group;
+}
+
 /**
  * iommu_report_device_fault() - Report fault event to device driver
  * @dev: the device
  * @evt: fault event data
  *
  * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
- * handler. When this function fails and the fault is recoverable, it is the
- * caller's responsibility to complete the fault.
+ * handler. If this function fails then ops->page_response() was called to
+ * complete evt if required.
  *
  * This module doesn't handle PCI PASID Stop Marker; IOMMU drivers must discard
  * them before reporting faults. A PASID Stop Marker (LRW = 0b100) doesn't
@@ -143,22 +183,18 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	struct iommu_fault *fault = &evt->fault;
 	struct iommu_fault_param *iopf_param;
-	struct iopf_fault *iopf, *next;
-	struct iommu_domain *domain;
+	struct iopf_group abort_group = {};
 	struct iopf_group *group;
 	int ret;
 
-	if (fault->type != IOMMU_FAULT_PAGE_REQ)
-		return -EOPNOTSUPP;
-
 	iopf_param = iopf_get_dev_fault_param(dev);
-	if (!iopf_param)
+	if (WARN_ON(!iopf_param))
 		return -ENODEV;
 
 	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
 		ret = report_partial_fault(iopf_param, fault);
 		iopf_put_dev_fault_param(iopf_param);
-
+		/* A request that is not the last does not need to be ack'd */
 		return ret;
 	}
 
@@ -170,56 +206,33 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 	 * will send a response to the hardware. We need to clean up before
 	 * leaving, otherwise partial faults will be stuck.
 	 */
-	domain = get_domain_for_iopf(dev, fault);
-	if (!domain) {
+	group = iopf_group_alloc(iopf_param, evt, &abort_group);
+	if (group == &abort_group) {
+		ret = -ENOMEM;
+		goto err_abort;
+	}
+
+	group->domain = get_domain_for_iopf(dev, fault);
+	if (!group->domain) {
 		ret = -EINVAL;
-		goto cleanup_partial;
+		goto err_abort;
 	}
 
-	group = kzalloc(sizeof(*group), GFP_KERNEL);
-	if (!group) {
-		ret = -ENOMEM;
-		goto cleanup_partial;
-	}
-
-	group->fault_param = iopf_param;
-	group->last_fault.fault = *fault;
-	INIT_LIST_HEAD(&group->faults);
-	INIT_LIST_HEAD(&group->pending_node);
-	group->domain = domain;
-	list_add(&group->last_fault.list, &group->faults);
-
-	/* See if we have partial faults for this group */
-	mutex_lock(&iopf_param->lock);
-	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
-		if (iopf->fault.prm.grpid == fault->prm.grpid)
-			/* Insert *before* the last fault */
-			list_move(&iopf->list, &group->faults);
-	}
-	list_add(&group->pending_node, &iopf_param->faults);
-	mutex_unlock(&iopf_param->lock);
+	/*
+	 * On success iopf_handler must call iopf_group_response() and
+	 * iopf_free_group()
+	 */
+	ret = group->domain->iopf_handler(group);
+	if (ret)
+		goto err_abort;
+	return 0;
 
-	ret = domain->iopf_handler(group);
-	if (ret) {
-		mutex_lock(&iopf_param->lock);
-		list_del_init(&group->pending_node);
-		mutex_unlock(&iopf_param->lock);
+err_abort:
+	iopf_group_response(group, IOMMU_PAGE_RESP_FAILURE);
+	if (group == &abort_group)
+		__iopf_free_group(group);
+	else
 		iopf_free_group(group);
-	}
-
-	return ret;
-
-cleanup_partial:
-	mutex_lock(&iopf_param->lock);
-	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
-		if (iopf->fault.prm.grpid == fault->prm.grpid) {
-			list_del(&iopf->list);
-			kfree(iopf);
-		}
-	}
-	mutex_unlock(&iopf_param->lock);
-	iopf_put_dev_fault_param(iopf_param);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_report_device_fault);
@@ -259,11 +272,9 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
  * iopf_group_response - Respond a group of page faults
  * @group: the group of faults with the same group id
  * @status: the response code
- *
- * Return 0 on success and <0 on error.
  */
-int iopf_group_response(struct iopf_group *group,
-			enum iommu_page_response_code status)
+void iopf_group_response(struct iopf_group *group,
+			 enum iommu_page_response_code status)
 {
 	struct iommu_fault_param *fault_param = group->fault_param;
 	struct iopf_fault *iopf = &group->last_fault;
@@ -274,17 +285,14 @@ int iopf_group_response(struct iopf_group *group,
 		.grpid = iopf->fault.prm.grpid,
 		.code = status,
 	};
-	int ret = -EINVAL;
 
 	/* Only send response if there is a fault report pending */
 	mutex_lock(&fault_param->lock);
 	if (!list_empty(&group->pending_node)) {
-		ret = ops->page_response(dev, &group->last_fault, &resp);
+		ops->page_response(dev, &group->last_fault, &resp);
 		list_del_init(&group->pending_node);
 	}
 	mutex_unlock(&fault_param->lock);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_group_response);
 
-- 
2.34.1


