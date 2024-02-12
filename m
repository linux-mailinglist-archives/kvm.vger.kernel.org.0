Return-Path: <kvm+bounces-8535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A6F850CB6
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 463A1B239A6
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3421979FE;
	Mon, 12 Feb 2024 01:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I8e7kj1Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A625317C9B;
	Mon, 12 Feb 2024 01:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701354; cv=none; b=Z8zc5/jCO5hFRLtN6Bv4R4j2RfwvKe0nwn8Ai6vPnN9DMOsveWDiP0lYQDlkV8HqwsWVY8FWfSeeIVlCoSKojP0TiEOZsf29tw+00M+OB4LwaOjuN0AM41rMp2nXr+ufBtYVMUuWtF6H9121CvIkQL80t5YSAMqJYyI5A7MoN74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701354; c=relaxed/simple;
	bh=HZgoL1M9kjT9lBOogQGT7Go0q2/IffOrRQfB73xcxZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=muuwpDxHNxwn1x728v5M/1ayvkScL5+bAygYcYOAUBssGybpMzm2u8W039NTLZ4RRr8mT4uhEPbQ6QluB//PsXD7Wprk8ZwZFrGv+JhIVdjLTpZ9u9kKfOlC3cKOjA8itPIdTN7KCrgTChcQkmOQPKcNMeU2kGxikHHBJKSO76M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I8e7kj1Y; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701353; x=1739237353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HZgoL1M9kjT9lBOogQGT7Go0q2/IffOrRQfB73xcxZw=;
  b=I8e7kj1YQ0+Ao9JavlqX3ftknsuU4EjktLe5XMQynGYUcANKMdoT72/c
   pTohtkbpnSJmVRnvEU5apdGYw3JYahQM5I4G+CjUwvzA9VxAJe1G6t7Ft
   9fE+lDcUiV5NVgSzMX7kkTUqR4/EqpiF4EdBZogcirKfU8zSsOIIMIyLa
   prEscAcOSdkAuJBDMAGyYJfFVadMH9uio6RgLVaSZUGTR2V2xQ0baC7qt
   pRJ4k8fqh765DpixfeQAc0sdC7+nZMaTOzX59P6LZY8Ga0CPoc4U3pBwA
   z26+8HtjjZuZuKuzzqh+FtBYxsjKnrhOpCN5avJI/bNs3TDGDpSWUerN8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502201"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502201"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:29:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132251"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:29:09 -0800
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
Subject: [PATCH v13 14/16] iommu: Track iopf group instead of last fault
Date: Mon, 12 Feb 2024 09:22:25 +0800
Message-Id: <20240212012227.119381-15-baolu.lu@linux.intel.com>
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
index 7c60692d9cf2..beb9c53f06bb 100644
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
index ece09552e5cf..05e49e2e6a52 100644
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


