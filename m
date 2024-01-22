Return-Path: <kvm+bounces-6509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A282835A91
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 06:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9742286C6D
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 05:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BC4EADB;
	Mon, 22 Jan 2024 05:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bRGMLYdR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965C639863;
	Mon, 22 Jan 2024 05:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705902575; cv=none; b=gcjX14oZtZWifOxFVC31C47X1Z7KzPkbjSfhiBDYuRLj+BEnfGgc7xqgfPlHLE1lP+8y5GqZWoo3sJp96Vg5rpkMRKBW+k2tJiyzkg+QWi//DFDjOKI1lVO7zCKAEami64VkdslkrE0JcVt6f6lDCVdFpVA/ZTfpNB1fNa5GDSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705902575; c=relaxed/simple;
	bh=EVHhmfV3PwiiIk9BghvE1EobsfbaEWt8K44eZUb76RE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b3wicT0KYIs51u368XQBPZCYtJylMlwVhwCq/7E/zFIRYfaEFLA5/68BS0FPtfGMbkGR/rwyX46xjsCX62ksnL4y5blf+Xhxc4VzrrPx3n2WitnVFu33GycID8uKt5Op2mxTag0GXdB0lgTsEZxhFl3gNkM9ouBcXccn5NEowvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bRGMLYdR; arc=none smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705902572; x=1737438572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EVHhmfV3PwiiIk9BghvE1EobsfbaEWt8K44eZUb76RE=;
  b=bRGMLYdRcb3jEpE/DmcjcWRxgAaRKiBzxWfkwyEAKA6i6Fb4Qz3+u7kX
   Zd0onQc5jYyJXtVYoRkmT54VeJrEMAS4icap1sqCJM9r9IAQdrRqe8dZa
   Ub8Xq2mFtR8edokO6ECbTDJBPofoygCDK3iXkCW0M25mr3mdpgaYJB0dl
   L1LKno3g1dMb3s3+1sOranJnomzboYxrdzHVtsw9iD4Oa4vbDGub1KlSe
   yoqTFYPccBnTgyO7dzpqxl2x2yCwkFb4qb/V17oHxZVa/oaS9U7toRFWb
   wyPaiQTZhaQhQCO6WfMZG7Kgwuc8mPGgdZBPiu3zM84yH/0ZKEhQ1qyv9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="467487258"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="467487258"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 21:49:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1116764048"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1116764048"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2024 21:49:27 -0800
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
Subject: [PATCH v10 14/16] iommu: Track iopf group instead of last fault
Date: Mon, 22 Jan 2024 13:43:06 +0800
Message-Id: <20240122054308.23901-15-baolu.lu@linux.intel.com>
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

Previously, before a group of page faults was passed to the domain's iopf
handler, the last page fault of the group was kept in the list of
iommu_fault_param::faults. In the page fault response path, the group's
last page fault was used to look up the list, and the page faults were
responded to device only if there was a matched fault.

The previous approach seems unnecessarily complex and not performance
friendly. Put the page fault group itself to the outstanding fault list.
It can be removed in the page fault response path or in the
iopf_queue_remove_device() path. The pending list is protected by
iommu_fault_param::lock. To allow checking for the group's presence in
the list using list_empty(), the iopf group should be removed from the
list with list_del_init().

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h      |   2 +
 drivers/iommu/io-pgfault.c | 237 +++++++++++++------------------------
 2 files changed, 87 insertions(+), 152 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d9a99a978ffa..48196efc9327 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -129,6 +129,8 @@ struct iopf_fault {
 struct iopf_group {
 	struct iopf_fault last_fault;
 	struct list_head faults;
+	/* list node for iommu_fault_param::faults */
+	struct list_head pending_node;
 	struct work_struct work;
 	struct iommu_domain *domain;
 	/* The device's fault data parameter. */
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 26e100ca3221..c22e13df84c2 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -78,12 +78,33 @@ static struct iommu_domain *get_domain_for_iopf(struct device *dev,
 	return domain;
 }
 
+/* Non-last request of a group. Postpone until the last one. */
+static int report_partial_fault(struct iommu_fault_param *fault_param,
+				struct iommu_fault *fault)
+{
+	struct iopf_fault *iopf;
+
+	iopf = kzalloc(sizeof(*iopf), GFP_KERNEL);
+	if (!iopf)
+		return -ENOMEM;
+
+	iopf->fault = *fault;
+
+	mutex_lock(&fault_param->lock);
+	list_add(&iopf->list, &fault_param->partial);
+	mutex_unlock(&fault_param->lock);
+
+	return 0;
+}
+
 /**
- * iommu_handle_iopf - IO Page Fault handler
- * @fault: fault event
- * @iopf_param: the fault parameter of the device.
+ * iommu_report_device_fault() - Report fault event to device driver
+ * @dev: the device
+ * @evt: fault event data
  *
- * Add a fault to the device workqueue, to be handled by mm.
+ * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
+ * handler. When this function fails and the fault is recoverable, it is the
+ * caller's responsibility to complete the fault.
  *
  * This module doesn't handle PCI PASID Stop Marker; IOMMU drivers must discard
  * them before reporting faults. A PASID Stop Marker (LRW = 0b100) doesn't
@@ -118,34 +139,37 @@ static struct iommu_domain *get_domain_for_iopf(struct device *dev,
  *
  * Return: 0 on success and <0 on error.
  */
-static int iommu_handle_iopf(struct iommu_fault *fault,
-			     struct iommu_fault_param *iopf_param)
+int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
-	int ret;
+	struct iommu_fault *fault = &evt->fault;
+	struct iommu_fault_param *iopf_param;
+	struct iopf_fault *iopf, *next;
+	struct iommu_domain *domain;
 	struct iopf_group *group;
-	struct iommu_domain *domain;
-	struct iopf_fault *iopf, *next;
-	struct device *dev = iopf_param->dev;
-
-	lockdep_assert_held(&iopf_param->lock);
+	int ret;
 
 	if (fault->type != IOMMU_FAULT_PAGE_REQ)
-		/* Not a recoverable page fault */
 		return -EOPNOTSUPP;
 
+	iopf_param = iopf_get_dev_fault_param(dev);
+	if (!iopf_param)
+		return -ENODEV;
+
 	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
-		iopf = kzalloc(sizeof(*iopf), GFP_KERNEL);
-		if (!iopf)
-			return -ENOMEM;
+		ret = report_partial_fault(iopf_param, fault);
+		iopf_put_dev_fault_param(iopf_param);
 
-		iopf->fault = *fault;
-
-		/* Non-last request of a group. Postpone until the last one */
-		list_add(&iopf->list, &iopf_param->partial);
-
-		return 0;
+		return ret;
 	}
 
+	/*
+	 * This is the last page fault of a group. Allocate an iopf group and
+	 * pass it to domain's page fault handler. The group holds a reference
+	 * count of the fault parameter. It will be released after response or
+	 * error path of this function. If an error is returned, the caller
+	 * will send a response to the hardware. We need to clean up before
+	 * leaving, otherwise partial faults will be stuck.
+	 */
 	domain = get_domain_for_iopf(dev, fault);
 	if (!domain) {
 		ret = -EINVAL;
@@ -154,11 +178,6 @@ static int iommu_handle_iopf(struct iommu_fault *fault,
 
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
-		/*
-		 * The caller will send a response to the hardware. But we do
-		 * need to clean up before leaving, otherwise partial faults
-		 * will be stuck.
-		 */
 		ret = -ENOMEM;
 		goto cleanup_partial;
 	}
@@ -166,145 +185,45 @@ static int iommu_handle_iopf(struct iommu_fault *fault,
 	group->fault_param = iopf_param;
 	group->last_fault.fault = *fault;
 	INIT_LIST_HEAD(&group->faults);
+	INIT_LIST_HEAD(&group->pending_node);
 	group->domain = domain;
 	list_add(&group->last_fault.list, &group->faults);
 
 	/* See if we have partial faults for this group */
+	mutex_lock(&iopf_param->lock);
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
 		if (iopf->fault.prm.grpid == fault->prm.grpid)
 			/* Insert *before* the last fault */
 			list_move(&iopf->list, &group->faults);
 	}
-
+	list_add(&group->pending_node, &iopf_param->faults);
 	mutex_unlock(&iopf_param->lock);
+
 	ret = domain->iopf_handler(group);
-	mutex_lock(&iopf_param->lock);
-	if (ret)
+	if (ret) {
+		mutex_lock(&iopf_param->lock);
+		list_del_init(&group->pending_node);
+		mutex_unlock(&iopf_param->lock);
 		iopf_free_group(group);
+	}
 
 	return ret;
+
 cleanup_partial:
+	mutex_lock(&iopf_param->lock);
 	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
 		if (iopf->fault.prm.grpid == fault->prm.grpid) {
 			list_del(&iopf->list);
 			kfree(iopf);
 		}
 	}
-	return ret;
-}
-
-/**
- * iommu_report_device_fault() - Report fault event to device driver
- * @dev: the device
- * @evt: fault event data
- *
- * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
- * handler. When this function fails and the fault is recoverable, it is the
- * caller's responsibility to complete the fault.
- *
- * Return 0 on success, or an error.
- */
-int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
-{
-	bool last_prq = evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
-		(evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE);
-	struct iommu_fault_param *fault_param;
-	struct iopf_fault *evt_pending;
-	int ret;
-
-	fault_param = iopf_get_dev_fault_param(dev);
-	if (!fault_param)
-		return -EINVAL;
-
-	mutex_lock(&fault_param->lock);
-	if (last_prq) {
-		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
-				      GFP_KERNEL);
-		if (!evt_pending) {
-			ret = -ENOMEM;
-			goto err_unlock;
-		}
-		list_add_tail(&evt_pending->list, &fault_param->faults);
-	}
-
-	ret = iommu_handle_iopf(&evt->fault, fault_param);
-	if (ret)
-		goto err_free;
-
-	mutex_unlock(&fault_param->lock);
-	/* The reference count of fault_param is now held by iopf_group. */
-	if (!last_prq)
-		iopf_put_dev_fault_param(fault_param);
-
-	return 0;
-err_free:
-	if (last_prq) {
-		list_del(&evt_pending->list);
-		kfree(evt_pending);
-	}
-err_unlock:
-	mutex_unlock(&fault_param->lock);
-	iopf_put_dev_fault_param(fault_param);
+	mutex_unlock(&iopf_param->lock);
+	iopf_put_dev_fault_param(iopf_param);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_report_device_fault);
 
-static int iommu_page_response(struct iopf_group *group,
-			       struct iommu_page_response *msg)
-{
-	bool needs_pasid;
-	int ret = -EINVAL;
-	struct iopf_fault *evt;
-	struct iommu_fault_page_request *prm;
-	struct device *dev = group->fault_param->dev;
-	const struct iommu_ops *ops = dev_iommu_ops(dev);
-	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
-	struct iommu_fault_param *fault_param = group->fault_param;
-
-	/* Only send response if there is a fault report pending */
-	mutex_lock(&fault_param->lock);
-	if (list_empty(&fault_param->faults)) {
-		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
-		goto done_unlock;
-	}
-	/*
-	 * Check if we have a matching page request pending to respond,
-	 * otherwise return -EINVAL
-	 */
-	list_for_each_entry(evt, &fault_param->faults, list) {
-		prm = &evt->fault.prm;
-		if (prm->grpid != msg->grpid)
-			continue;
-
-		/*
-		 * If the PASID is required, the corresponding request is
-		 * matched using the group ID, the PASID valid bit and the PASID
-		 * value. Otherwise only the group ID matches request and
-		 * response.
-		 */
-		needs_pasid = prm->flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID;
-		if (needs_pasid && (!has_pasid || msg->pasid != prm->pasid))
-			continue;
-
-		if (!needs_pasid && has_pasid) {
-			/* No big deal, just clear it. */
-			msg->flags &= ~IOMMU_PAGE_RESP_PASID_VALID;
-			msg->pasid = 0;
-		}
-
-		ret = ops->page_response(dev, evt, msg);
-		list_del(&evt->list);
-		kfree(evt);
-		break;
-	}
-
-done_unlock:
-	mutex_unlock(&fault_param->lock);
-
-	return ret;
-}
-
 /**
  * iopf_queue_flush_dev - Ensure that all queued faults have been processed
  * @dev: the endpoint whose faults need to be flushed.
@@ -346,18 +265,30 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
 int iopf_group_response(struct iopf_group *group,
 			enum iommu_page_response_code status)
 {
+	struct iommu_fault_param *fault_param = group->fault_param;
 	struct iopf_fault *iopf = &group->last_fault;
+	struct device *dev = group->fault_param->dev;
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_page_response resp = {
 		.pasid = iopf->fault.prm.pasid,
 		.grpid = iopf->fault.prm.grpid,
 		.code = status,
 	};
+	int ret = -EINVAL;
 
 	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
 	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
 		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
 
-	return iommu_page_response(group, &resp);
+	/* Only send response if there is a fault report pending */
+	mutex_lock(&fault_param->lock);
+	if (!list_empty(&group->pending_node)) {
+		ret = ops->page_response(dev, &group->last_fault, &resp);
+		list_del_init(&group->pending_node);
+	}
+	mutex_unlock(&fault_param->lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_group_response);
 
@@ -468,8 +399,9 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
  */
 void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 {
-	struct iopf_fault *iopf, *next;
-	struct iommu_page_response resp;
+	struct iopf_fault *partial_iopf;
+	struct iopf_fault *next;
+	struct iopf_group *group, *temp;
 	struct dev_iommu *param = dev->iommu;
 	struct iommu_fault_param *fault_param;
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
@@ -483,21 +415,22 @@ void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 		goto unlock;
 
 	mutex_lock(&fault_param->lock);
-	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
-		kfree(iopf);
+	list_for_each_entry_safe(partial_iopf, next, &fault_param->partial, list)
+		kfree(partial_iopf);
 
-	list_for_each_entry_safe(iopf, next, &fault_param->faults, list) {
-		memset(&resp, 0, sizeof(struct iommu_page_response));
-		resp.pasid = iopf->fault.prm.pasid;
-		resp.grpid = iopf->fault.prm.grpid;
-		resp.code = IOMMU_PAGE_RESP_INVALID;
+	list_for_each_entry_safe(group, temp, &fault_param->faults, pending_node) {
+		struct iopf_fault *iopf = &group->last_fault;
+		struct iommu_page_response resp = {
+			.pasid = iopf->fault.prm.pasid,
+			.grpid = iopf->fault.prm.grpid,
+			.code = IOMMU_PAGE_RESP_INVALID
+		};
 
 		if (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
 			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
 
 		ops->page_response(dev, iopf, &resp);
-		list_del(&iopf->list);
-		kfree(iopf);
+		list_del_init(&group->pending_node);
 	}
 	mutex_unlock(&fault_param->lock);
 
-- 
2.34.1


