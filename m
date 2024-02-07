Return-Path: <kvm+bounces-8183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A0684C213
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:44:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D1931F28B69
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E2320B10;
	Wed,  7 Feb 2024 01:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jshRfFRT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A31620B12;
	Wed,  7 Feb 2024 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707270019; cv=none; b=PYIUe2J4a/eeTsmHJC9Qb++UMnbxMeMu+A3Ut+yk2p/4mI5Z/JQm/KySGHg16aXai8T3+EG+J3iFkMrmnRKFbqJLQ3wdopMD2HcNV7Kz1hb2JL/JhoVhXb/EiMLv6WdcxYUDsCONFwz+wpeB1aVKQ8LrXYyxBXmC21vwrjM1WJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707270019; c=relaxed/simple;
	bh=zAPLAw2nHK4oPkhuLwNrmFL8it8TmX6PMbnjs9wheHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G5JgwMPtb3I8E/ZAY925tPyGe6J+5IDbttlJ2eb2Hzhtl9NvkbCsHFLcQGlOFW/HJRk9nE9hg8FSP1ZBeWzpXcm+GUZFxsH82wYeMDxnp8H0W+d5xBNJ4DdYVK8EYMR0XFcgsIQSIiv4Gsu7WBjuF9yanw04KPGomRrwSM7ssMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jshRfFRT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707270017; x=1738806017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zAPLAw2nHK4oPkhuLwNrmFL8it8TmX6PMbnjs9wheHc=;
  b=jshRfFRTTntbVGjEo0bOCwNhOMDqmUFT5PlGlXtF/F4Zfh7l9xfjTOeq
   FPKv1E8DNQa0hhR25CAjPjb09SV1hMos3nq2fc3y4IceSBfu2+NCENdns
   sxyV8c0n/a+CM6Mre1FsTug5k0YMr0jbk+8GO2EoFvf13qEqG/eNTfKQE
   C513WKpA8lZtI3WWlW23Ri9H+6HL7Kk5Ew0SWSsft9BkobNKZfwssuEgG
   zabNBBRQSAfRjYsb+u8FSuSzVAeTgaF76r90GQCNJLwtNiwZBfmp9EpN6
   aUl8ZIlErPcRiQO+/vMQMK8MhMHC0unB+Yrto1RzfDXTIgzrC3f5SP5jh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11534304"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11534304"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:40:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190909"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:40:13 -0800
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
Subject: [PATCH v12 14/16] iommu: Track iopf group instead of last fault
Date: Wed,  7 Feb 2024 09:33:23 +0800
Message-Id: <20240207013325.95182-15-baolu.lu@linux.intel.com>
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

IOMMU_PAGE_RESP_PASID_VALID is set in the code but not used anywhere.
Remove it to make the code clean. IOMMU_PAGE_RESP_PASID_VALID is set
in the response message indicating that the response message includes
a valid PASID value. Actually, we should keep this hardware detail in
the individual driver. When the page fault handling framework in IOMMU
and IOMMUFD subsystems includes a valid PASID in the fault message, the
response message should always contain the same PASID value. Individual
drivers should be responsible for deciding whether to include the PASID
in the messages they provide for the hardware.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h      |   6 +-
 drivers/iommu/io-pgfault.c | 242 +++++++++++++------------------------
 2 files changed, 86 insertions(+), 162 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 92dfd9b94577..f8ed1cc7212e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -106,15 +106,11 @@ enum iommu_page_response_code {
 
 /**
  * struct iommu_page_response - Generic page response information
- * @flags: encodes whether the corresponding fields are valid
- *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
  * @pasid: Process Address Space ID
  * @grpid: Page Request Group Index
  * @code: response code from &enum iommu_page_response_code
  */
 struct iommu_page_response {
-#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
-	u32	flags;
 	u32	pasid;
 	u32	grpid;
 	u32	code;
@@ -129,6 +125,8 @@ struct iopf_fault {
 struct iopf_group {
 	struct iopf_fault last_fault;
 	struct list_head faults;
+	/* list node for iommu_fault_param::faults */
+	struct list_head pending_node;
 	struct work_struct work;
 	struct iommu_domain *domain;
 	/* The device's fault data parameter. */
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index b20f49bd5e4a..c001b9d3e6dd 100644
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
@@ -346,18 +265,26 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
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
 
-	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
-	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
-		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+	/* Only send response if there is a fault report pending */
+	mutex_lock(&fault_param->lock);
+	if (!list_empty(&group->pending_node)) {
+		ret = ops->page_response(dev, &group->last_fault, &resp);
+		list_del_init(&group->pending_node);
+	}
+	mutex_unlock(&fault_param->lock);
 
-	return iommu_page_response(group, &resp);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iopf_group_response);
 
@@ -468,8 +395,9 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
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
@@ -483,21 +411,19 @@ void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
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
-
-		if (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
-			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+	list_for_each_entry_safe(group, temp, &fault_param->faults, pending_node) {
+		struct iopf_fault *iopf = &group->last_fault;
+		struct iommu_page_response resp = {
+			.pasid = iopf->fault.prm.pasid,
+			.grpid = iopf->fault.prm.grpid,
+			.code = IOMMU_PAGE_RESP_INVALID
+		};
 
 		ops->page_response(dev, iopf, &resp);
-		list_del(&iopf->list);
-		kfree(iopf);
+		list_del_init(&group->pending_node);
 	}
 	mutex_unlock(&fault_param->lock);
 
-- 
2.34.1


