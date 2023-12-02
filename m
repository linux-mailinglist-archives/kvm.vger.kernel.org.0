Return-Path: <kvm+bounces-3231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CCB801BDC
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 167CF1C20AE3
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B6313FF5;
	Sat,  2 Dec 2023 09:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PIS21ewV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ADA198;
	Sat,  2 Dec 2023 01:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510705; x=1733046705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=5tHj8FjpQu1zOKHpkDFSKBA08iJcnSpgfGv/y1ivWLI=;
  b=PIS21ewVdl6gu0+KyLc6oR27/mLImYs8GDdGT0vGnzMPTh0vaYOjxGtX
   KUk7TxUrdomXdrNBJFmiHBv2fkByQW97XFzS4+THiSTpHlFHW19+Ug9wt
   u7sWe68qaPrDiFn+nGEdFhX15piqHpgv2rQqw0/mGSBE8wAPj2V0/8L9g
   5Ej/MzpswILuT8bkAMGgCH3IGeWVcrz3flIzBXDNw4lwJj7f47x/xWert
   vK0HQlUU0efw9Eq6r0oBNwKE7ns6QaV6UXo5g2AYVw9QGb9wiwhIFEdII
   lcjSsn2mEWD1OOOwbnBgmJ+I2rUZoucyKKhIW40gjvXgQ3b0Gi7FuZinY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="6886646"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="6886646"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:51:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="746280146"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="746280146"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:51:40 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 15/42] iommufd: Add iopf handler to KVM hw pagetable
Date: Sat,  2 Dec 2023 17:22:45 +0800
Message-Id: <20231202092245.14335-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add iopf handler to KVM HW page table. The iopf handler is implemented to
forward IO page fault requests to KVM and return complete status back to
IOMMU driver via iommu_page_response().

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/iommu/iommufd/hw_pagetable_kvm.c | 87 ++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/iommu/iommufd/hw_pagetable_kvm.c b/drivers/iommu/iommufd/hw_pagetable_kvm.c
index e0e205f384ed5..bff9fa3d9f703 100644
--- a/drivers/iommu/iommufd/hw_pagetable_kvm.c
+++ b/drivers/iommu/iommufd/hw_pagetable_kvm.c
@@ -6,6 +6,89 @@
 #include "../iommu-priv.h"
 #include "iommufd_private.h"
 
+static int iommufd_kvmtdp_fault(void *data, struct mm_struct *mm,
+				unsigned long addr, u32 perm)
+{
+	struct iommufd_hw_pagetable *hwpt = data;
+	struct kvm_tdp_fault_type fault_type = {0};
+	unsigned long gfn = addr >> PAGE_SHIFT;
+	struct kvm_tdp_fd *tdp_fd;
+	int ret;
+
+	if (!hwpt || !hwpt_is_kvm(hwpt))
+		return IOMMU_PAGE_RESP_INVALID;
+
+	tdp_fd = to_hwpt_kvm(hwpt)->context;
+	if (!tdp_fd->ops->fault)
+		return IOMMU_PAGE_RESP_INVALID;
+
+	fault_type.read = !!(perm & IOMMU_FAULT_PERM_READ);
+	fault_type.write = !!(perm & IOMMU_FAULT_PERM_WRITE);
+	fault_type.exec = !!(perm & IOMMU_FAULT_PERM_EXEC);
+
+	ret = tdp_fd->ops->fault(tdp_fd, mm, gfn, fault_type);
+	return ret ? IOMMU_PAGE_RESP_FAILURE : IOMMU_PAGE_RESP_SUCCESS;
+}
+
+static int iommufd_kvmtdp_complete_group(struct device *dev, struct iopf_fault *iopf,
+				    enum iommu_page_response_code status)
+{
+	struct iommu_page_response resp = {
+		.pasid			= iopf->fault.prm.pasid,
+		.grpid			= iopf->fault.prm.grpid,
+		.code			= status,
+	};
+
+	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
+	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
+		resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+
+	return iommu_page_response(dev, &resp);
+}
+
+static void iommufd_kvmtdp_handle_iopf(struct work_struct *work)
+{
+	struct iopf_fault *iopf;
+	struct iopf_group *group;
+	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
+	struct iommu_domain *domain;
+	void *fault_data;
+	int ret;
+
+	group = container_of(work, struct iopf_group, work);
+	domain = group->domain;
+	fault_data = domain->fault_data;
+
+	list_for_each_entry(iopf, &group->faults, list) {
+		/*
+		 * For the moment, errors are sticky: don't handle subsequent
+		 * faults in the group if there is an error.
+		 */
+		if (status != IOMMU_PAGE_RESP_SUCCESS)
+			break;
+
+		status = iommufd_kvmtdp_fault(fault_data, domain->mm,
+					      iopf->fault.prm.addr,
+					      iopf->fault.prm.perm);
+	}
+
+	ret = iommufd_kvmtdp_complete_group(group->dev, &group->last_fault, status);
+
+	iopf_free_group(group);
+
+}
+
+static int iommufd_kvmtdp_iopf_handler(struct iopf_group *group)
+{
+	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
+
+	INIT_WORK(&group->work, iommufd_kvmtdp_handle_iopf);
+	if (!queue_work(fault_param->queue->wq, &group->work))
+		return -EBUSY;
+
+	return 0;
+}
+
 static void iommufd_kvmtdp_invalidate(void *data,
 				      unsigned long start, unsigned long size)
 {
@@ -169,6 +252,10 @@ iommufd_hwpt_kvm_alloc(struct iommufd_ctx *ictx,
 		goto out_abort;
 	}
 
+	hwpt->domain->mm = current->mm;
+	hwpt->domain->iopf_handler = iommufd_kvmtdp_iopf_handler;
+	hwpt->domain->fault_data = hwpt;
+
 	rc = kvmtdp_register(tdp_fd, hwpt);
 	if (rc)
 		goto out_abort;
-- 
2.17.1


