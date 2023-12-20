Return-Path: <kvm+bounces-4890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ECF3819654
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 456B22824BB
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39194208D1;
	Wed, 20 Dec 2023 01:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IjT/Is9s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93ED20B0C;
	Wed, 20 Dec 2023 01:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703035766; x=1734571766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I7usIqEvI+BlUy2AV/Tl95lT59UUjSl8Gal1Jpnr6uI=;
  b=IjT/Is9sBX7SCGLaNOCiHbxPZkFOg2qZ+q2FWetWsupZUWIvDJjdcszH
   adg43JpEVf+OUIBQ9L91MiMmQDpCWDppf3daUzLvpXyA506l9tC+uiYGv
   6kSKcCxm1cvHouJ/mwvaE9TiwVmvm6hdmfzFrTTtKM1Nz7wYs9em/S6mM
   p0NFwxQp+ADceJlT/fdU7hyeJQFOSF96NFV15oeiI0bfiwOezdk0f5mnn
   oldKDkaAQXtPQeg3fJyELj1olh3VowcbmlHRpMHRAQmA0NY8mHW/XDch2
   X4YBdR5PLklnhe0QQZO2aL+FqEJADqjwRg4wgKTFH4rj/uPQHKC8aHngS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2965879"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="2965879"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:29:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="1023319213"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="1023319213"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2023 17:29:21 -0800
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
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v9 14/14] iommu: Track iopf group instead of last fault
Date: Wed, 20 Dec 2023 09:23:32 +0800
Message-Id: <20231220012332.168188-15-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220012332.168188-1-baolu.lu@linux.intel.com>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
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
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/iommu.h      |   2 +
 drivers/iommu/io-pgfault.c | 220 +++++++++++++------------------------
 2 files changed, 78 insertions(+), 144 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d8d173309469..2f765ae06021 100644
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
index 3221f6387beb..7d11b74e4048 100644
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
 
@@ -470,6 +401,7 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
 void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 {
 	struct iopf_fault *iopf, *next;
+	struct iopf_group *group, *temp;
 	struct iommu_page_response resp;
 	struct dev_iommu *param = dev->iommu;
 	struct iommu_fault_param *fault_param;
@@ -487,8 +419,9 @@ void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
 		kfree(iopf);
 
-	list_for_each_entry_safe(iopf, next, &fault_param->faults, list) {
+	list_for_each_entry_safe(group, temp, &fault_param->faults, pending_node) {
 		memset(&resp, 0, sizeof(struct iommu_page_response));
+		iopf = &group->last_fault;
 		resp.pasid = iopf->fault.prm.pasid;
 		resp.grpid = iopf->fault.prm.grpid;
 		resp.code = IOMMU_PAGE_RESP_INVALID;
@@ -497,8 +430,7 @@ void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
 
 		ops->page_response(dev, iopf, &resp);
-		list_del(&iopf->list);
-		kfree(iopf);
+		list_del_init(&group->pending_node);
 	}
 	mutex_unlock(&fault_param->lock);
 
-- 
2.34.1


