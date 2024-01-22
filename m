Return-Path: <kvm+bounces-6503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 420C2835A85
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 06:52:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCFF51F24728
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 05:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5F820DFE;
	Mon, 22 Jan 2024 05:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WKD0imqa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4839220DE0;
	Mon, 22 Jan 2024 05:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705902550; cv=none; b=pH9UUAVMso+5BVOUumj6oDKUdFQ+U/eiF0TlMLwYCx9JhXugobOubPvGUnsrzccFVxeXcvhVXofRN8LZdbYwkM1i9Ui5E4qaAb4ULQR+mj9JeaqIwTCd+qjsMMCM3Wm3lnKt//2i/TWvJlrxsOqryZJ2q5a5vU8wmMtTO94NIV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705902550; c=relaxed/simple;
	bh=/X4TrhX+nZJIzlXo68bwW7s6fFh3t8lvBg+xVPbIT+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E/r4XUU5i6WCmKBpjoHYm+3cF71IER0CpWZ/lwoU6+UdvvBd+S96PVPJbi8hQTYI809PKgbV7mFVuUQcfYdJW9jGtvGxO19izZKrn8K3wl1sWE/Ti0bTZmEj80rBce9ueoZyM2zlIOhqwY7nxAxOtdYHn+QNVyEAiBQ2VCFvH78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WKD0imqa; arc=none smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705902547; x=1737438547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/X4TrhX+nZJIzlXo68bwW7s6fFh3t8lvBg+xVPbIT+8=;
  b=WKD0imqaRkSEcmQAU2WQM8quRs8CKW/uqVEp4UziwlZ0ieDRrq3kDu3C
   DRtCL7Nt1rNlqT9Pg6PFOOvFWktYuTetjkLiYt+3NCcQ1GCPQZRMsJmGw
   FQiGTQRDn+d657PPbxjvrVuLn0bf3UroIsbN7/22xKvmnyskveFF+wj0d
   2oMJJaZJMEGExgXU+T25dtEeY9Wc2buFLdWlqDo9ecg+uUJ8pw4V5gDpm
   UHpezWQJ5njtEZvAoqILCido7lmsXA947XYIiz51+C8p+UGrFTYRoppEd
   mB+ZfgNHiMfkjdYaACKTZiB08mSwb+r/mzUdlHzu7DO6d1a8H572EMeMX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="467487146"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="467487146"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 21:49:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1116763975"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1116763975"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2024 21:49:02 -0800
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
Subject: [PATCH v10 08/16] iommu: Prepare for separating SVA and IOPF
Date: Mon, 22 Jan 2024 13:43:00 +0800
Message-Id: <20240122054308.23901-9-baolu.lu@linux.intel.com>
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

Move iopf_group data structure to iommu.h to make it a minimal set of
faults that a domain's page fault handler should handle.

Add a new function, iopf_free_group(), to free a fault group after all
faults in the group are handled. This function will be made global so
that it can be called from other files, such as iommu-sva.c.

Move iopf_queue data structure to iommu.h to allow the workqueue to be
scheduled out of this file.

This will simplify the sequential patches.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h      | 20 +++++++++++++++++++-
 drivers/iommu/io-pgfault.c | 37 +++++++++++++------------------------
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2320548a90f8..c9d4f175f121 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -41,7 +41,6 @@ struct iommu_dirty_ops;
 struct notifier_block;
 struct iommu_sva;
 struct iommu_dma_cookie;
-struct iopf_queue;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -126,6 +125,25 @@ struct iopf_fault {
 	struct list_head list;
 };
 
+struct iopf_group {
+	struct iopf_fault last_fault;
+	struct list_head faults;
+	struct work_struct work;
+	struct device *dev;
+};
+
+/**
+ * struct iopf_queue - IO Page Fault queue
+ * @wq: the fault workqueue
+ * @devices: devices attached to this queue
+ * @lock: protects the device list
+ */
+struct iopf_queue {
+	struct workqueue_struct *wq;
+	struct list_head devices;
+	struct mutex lock;
+};
+
 /* iommu fault flags */
 #define IOMMU_FAULT_READ	0x0
 #define IOMMU_FAULT_WRITE	0x1
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 10d48eb72608..c7e6bbed5c05 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -13,24 +13,17 @@
 
 #include "iommu-sva.h"
 
-/**
- * struct iopf_queue - IO Page Fault queue
- * @wq: the fault workqueue
- * @devices: devices attached to this queue
- * @lock: protects the device list
- */
-struct iopf_queue {
-	struct workqueue_struct		*wq;
-	struct list_head		devices;
-	struct mutex			lock;
-};
+static void iopf_free_group(struct iopf_group *group)
+{
+	struct iopf_fault *iopf, *next;
 
-struct iopf_group {
-	struct iopf_fault		last_fault;
-	struct list_head		faults;
-	struct work_struct		work;
-	struct device			*dev;
-};
+	list_for_each_entry_safe(iopf, next, &group->faults, list) {
+		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
+			kfree(iopf);
+	}
+
+	kfree(group);
+}
 
 static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
 			       enum iommu_page_response_code status)
@@ -50,9 +43,9 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
 
 static void iopf_handler(struct work_struct *work)
 {
+	struct iopf_fault *iopf;
 	struct iopf_group *group;
 	struct iommu_domain *domain;
-	struct iopf_fault *iopf, *next;
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
 
 	group = container_of(work, struct iopf_group, work);
@@ -61,7 +54,7 @@ static void iopf_handler(struct work_struct *work)
 	if (!domain || !domain->iopf_handler)
 		status = IOMMU_PAGE_RESP_INVALID;
 
-	list_for_each_entry_safe(iopf, next, &group->faults, list) {
+	list_for_each_entry(iopf, &group->faults, list) {
 		/*
 		 * For the moment, errors are sticky: don't handle subsequent
 		 * faults in the group if there is an error.
@@ -69,14 +62,10 @@ static void iopf_handler(struct work_struct *work)
 		if (status == IOMMU_PAGE_RESP_SUCCESS)
 			status = domain->iopf_handler(&iopf->fault,
 						      domain->fault_data);
-
-		if (!(iopf->fault.prm.flags &
-		      IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
-			kfree(iopf);
 	}
 
 	iopf_complete_group(group->dev, &group->last_fault, status);
-	kfree(group);
+	iopf_free_group(group);
 }
 
 /**
-- 
2.34.1


