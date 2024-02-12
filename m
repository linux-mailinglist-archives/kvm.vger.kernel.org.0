Return-Path: <kvm+bounces-8529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7379F850CAB
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBC8F1F23B39
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4047812B81;
	Mon, 12 Feb 2024 01:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPkm9Hky"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C0111717;
	Mon, 12 Feb 2024 01:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701329; cv=none; b=nUUrEdWWB7RbYWrEeWxkole4JoOvv/JC3e3DT+6V4sYm27V41hhLK13qX0EZx31xJH4Bwj33ZkHvrz867/QNs5T9YgLCAfRop3ykgxJNvwP8XUub9gi/Al+BSnz+7z5NvyfOnJcdTfRLWQ+UvBKTOCgCJvLmylhXxUBV9kziWds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701329; c=relaxed/simple;
	bh=nQSnxdM7XSa1aWIb1v4mMY0nZGRWhXyXA4CN17vWMXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BUYEkpWJrKWBZTsDDXz3mhLiuj2qAN2JreuHpbqyY+wKmEkyK5+3jTZBWo6NLvHs7yC7tyY0eIGXMHK7AnphvVAjZ1qSdAUy1D1GlOl+WbrFeFhEW+D9/lnQPxbagZSDDoZwrQCs3exzo509Qp4VDjdxMageU9DqDQMlUtz5wBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPkm9Hky; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701329; x=1739237329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nQSnxdM7XSa1aWIb1v4mMY0nZGRWhXyXA4CN17vWMXQ=;
  b=VPkm9HkyFl4niuPJPwc1mVdDwQ4uNaxlsUu7Ecj+5c40rqk/HDoiG2xv
   xzE1RI+WlZgaZncmOKZ8AJcwrAWnKX4q78QY+rtxtT6BciT0WCMm39Isb
   qpPGnzUgSOJCIsBHcOvk5beMxxiO63PlQUx5/SIRBluffE4b4CKSoCm+8
   Hs1KbMJ2nv7jNbqX8nNkVZiqPjbv3x2DG4zvQJaBbHyrW79C7O1C1U3DW
   zM/DqxKyRHeztM5S7BUeOMCf0jyAzCkGXDXvrcHxrK9W/n2E6/4VOd100
   mR/tA+3lb2Sz4v0B10E+ElTQ7ebBUZqjsWNRLXzOfK6sQOfF8o15OK6zT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502133"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502133"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:28:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132211"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:28:44 -0800
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
Subject: [PATCH v13 08/16] iommu: Prepare for separating SVA and IOPF
Date: Mon, 12 Feb 2024 09:22:19 +0800
Message-Id: <20240212012227.119381-9-baolu.lu@linux.intel.com>
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
index 2e0cbd263962..b352198cb030 100644
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


