Return-Path: <kvm+bounces-3228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E22801BD6
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E173281D0D
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C7213FF5;
	Sat,  2 Dec 2023 09:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bynbUnr1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D34197;
	Sat,  2 Dec 2023 01:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510612; x=1733046612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=WCJPtEQsnD+jMdSa58ByeKd9Udd++7gtpjWFBhxkT8o=;
  b=bynbUnr1p6FdWy3LqmAyL6aefJu7Unp06M5joR+PftSgrlnnWLwr0Pgv
   yo9VKa/GofQMK2WFUmylPmM/3N9/GROo4q1AVgSFQTP3HXXUBvfF9anl0
   pYb3RSobbyttdC9zETXEtH4txe9EZrZlfk8OxDuO0rEmir/9txVQEXhDY
   oKrxNtSkSjRDisx2NAB7Se6YcxwHG14Gk41KEn2b97W4LgnUWHSJeRNuX
   IZccfX9H2OhqUSnX5pu4jhPVPYUei1hpw2CXmYsRuHs2ykHIEIXV7RQNQ
   v96KWXkGjNym3A6/gE2K9kASPv3bG61SMMVY4aeHg/q5lW1v9WNC3oB/B
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="479794120"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="479794120"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:50:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="11414203"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:50:09 -0800
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
Subject: [RFC PATCH 12/42] iommufd: Introduce allocation data info and flag for KVM managed HWPT
Date: Sat,  2 Dec 2023 17:21:13 +0800
Message-Id: <20231202092113.14141-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add allocation data info iommu_hwpt_kvm_info to allow IOMMUFD to create a
KVM managed HWPT via ioctl IOMMU_HWPT_ALLOC.

As KVM managed HWPT serves as stage-2 page tables whose paging structure
and page mapping/unmapping are managed by KVM, there's no need to connect
KVM managed HWPT to IOAS or parent HWPT.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/uapi/linux/iommufd.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 71c009cc614a4..08570f3a751fc 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -390,6 +390,15 @@ struct iommu_hwpt_vtd_s1 {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_kvm_info - KVM managed stage-2 page table info
+ *                              (IOMMU_HWPT_DATA_KVM)
+ * @fd: The fd of the page table shared from KVM
+ */
+struct iommu_hwpt_kvm_info {
+	__aligned_u64 fd;
+};
+
 /**
  * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
  *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
@@ -413,11 +422,13 @@ struct iommu_hwpt_arm_smmuv3 {
  * @IOMMU_HWPT_DATA_NONE: no data
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
  * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
+ * @IOMMU_HWPT_DATA_KVM: KVM managed stage-2 page table
  */
 enum iommu_hwpt_data_type {
 	IOMMU_HWPT_DATA_NONE,
 	IOMMU_HWPT_DATA_VTD_S1,
 	IOMMU_HWPT_DATA_ARM_SMMUV3,
+	IOMMU_HWPT_DATA_KVM,
 };
 
 /**
@@ -447,6 +458,10 @@ enum iommu_hwpt_data_type {
  * must be set to a pre-defined type corresponding to an I/O page table
  * type supported by the underlying IOMMU hardware.
  *
+ * A KVM-managed HWPT will be created if @data_type is IOMMU_HWPT_DATA_KVM.
+ * @pt_id is not queried if data_type is IOMMU_HWPT_DATA_KVM because KVM-managed
+ * HWPT doesn't have any IOAS or parent HWPT associated.
+ *
  * If the @data_type is set to IOMMU_HWPT_DATA_NONE, @data_len and
  * @data_uptr should be zero. Otherwise, both @data_len and @data_uptr
  * must be given.
-- 
2.17.1


