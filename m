Return-Path: <kvm+bounces-8524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA8E850CA0
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDDF51F22F4C
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13641877;
	Mon, 12 Feb 2024 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TZ72oWX4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD279FD;
	Mon, 12 Feb 2024 01:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701309; cv=none; b=m/Vrdwge9AiwRnxNaKJ0iS2/1JkiHr+7wZez5LrljYMlnWAf6ssVyxxg/3h9MICwOcLT7Cqn0YFaRQR3Dn058SQaoZbWDQiCOvmV7t7FRFTbzzlD0nCeIikGOE8je+dOI/v8w4KOIpIJkq1y9+039UCwk3zeTRPpQMp6FdqyxGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701309; c=relaxed/simple;
	bh=5r6D3Qdoii3/4RlUq+OLVXjHOxyAwVfMslu98LqAXaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RWTBo/kLgnwq15GpOSup0/waW77ih7AM2aCUzwpuFYtqOfk7+bh8ogz0z1EU4+HpEuWAbco8x5Woflqu4DPKKf9qP/NUadl+7gUQsgOZi/iLF0G4JBCdCYJl6BGGAOKTZyZTqIdBGCLjsWbkJcCLRBqPn/kFOZAhDI5+/qiFnkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TZ72oWX4; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701308; x=1739237308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5r6D3Qdoii3/4RlUq+OLVXjHOxyAwVfMslu98LqAXaw=;
  b=TZ72oWX4EZzQqBoJAElgVgDAT48cfF4K3eiyrkYUblNSzp3XW0APdQ2R
   tmUOemxzMosjymFyT01Z4M8sr+XVw1wZRw4s7lquFFiiikQKs9ceM4Bsw
   DFzWkO2fPrVWECvRwsYudRS3x6yNa6+CD7CNG4Gxm9tCe/5eh4hazDK6L
   sUXCNnadpCrRc24P+JjBlod4IFZ/Gze3egEUq5I5+TNAtgeaGRVnzelXL
   LYoJ87DuKqLV+fqjotgbFIXlgX3RF+TYjibvqfZF4TjbBDvIF94zeQgmW
   EJIHQJUk8zqqag175eqLtzB5wr+z5vKF5vsRbxVXhZdG3beMWmY2Etfhj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502080"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502080"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:28:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132154"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:28:24 -0800
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
Subject: [PATCH v13 03/16] iommu: Remove unrecoverable fault data
Date: Mon, 12 Feb 2024 09:22:14 +0800
Message-Id: <20240212012227.119381-4-baolu.lu@linux.intel.com>
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

The unrecoverable fault data is not used anywhere. Remove it to avoid
dead code.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h | 72 ++-----------------------------------------
 1 file changed, 2 insertions(+), 70 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d44af9168276..68ffbbacaaad 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -50,67 +50,7 @@ struct iommu_dma_cookie;
 
 /* Generic fault types, can be expanded IRQ remapping fault */
 enum iommu_fault_type {
-	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
-	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
-};
-
-enum iommu_fault_reason {
-	IOMMU_FAULT_REASON_UNKNOWN = 0,
-
-	/* Could not access the PASID table (fetch caused external abort) */
-	IOMMU_FAULT_REASON_PASID_FETCH,
-
-	/* PASID entry is invalid or has configuration errors */
-	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
-
-	/*
-	 * PASID is out of range (e.g. exceeds the maximum PASID
-	 * supported by the IOMMU) or disabled.
-	 */
-	IOMMU_FAULT_REASON_PASID_INVALID,
-
-	/*
-	 * An external abort occurred fetching (or updating) a translation
-	 * table descriptor
-	 */
-	IOMMU_FAULT_REASON_WALK_EABT,
-
-	/*
-	 * Could not access the page table entry (Bad address),
-	 * actual translation fault
-	 */
-	IOMMU_FAULT_REASON_PTE_FETCH,
-
-	/* Protection flag check failed */
-	IOMMU_FAULT_REASON_PERMISSION,
-
-	/* access flag check failed */
-	IOMMU_FAULT_REASON_ACCESS,
-
-	/* Output address of a translation stage caused Address Size fault */
-	IOMMU_FAULT_REASON_OOR_ADDRESS,
-};
-
-/**
- * struct iommu_fault_unrecoverable - Unrecoverable fault data
- * @reason: reason of the fault, from &enum iommu_fault_reason
- * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
- * @pasid: Process Address Space ID
- * @perm: requested permission access using by the incoming transaction
- *        (IOMMU_FAULT_PERM_* values)
- * @addr: offending page address
- * @fetch_addr: address that caused a fetch abort, if any
- */
-struct iommu_fault_unrecoverable {
-	__u32	reason;
-#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
-#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
-#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
-	__u32	flags;
-	__u32	pasid;
-	__u32	perm;
-	__u64	addr;
-	__u64	fetch_addr;
+	IOMMU_FAULT_PAGE_REQ = 1,	/* page request fault */
 };
 
 /**
@@ -142,19 +82,11 @@ struct iommu_fault_page_request {
 /**
  * struct iommu_fault - Generic fault data
  * @type: fault type from &enum iommu_fault_type
- * @padding: reserved for future use (should be zero)
- * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
  * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
- * @padding2: sets the fault size to allow for future extensions
  */
 struct iommu_fault {
 	__u32	type;
-	__u32	padding;
-	union {
-		struct iommu_fault_unrecoverable event;
-		struct iommu_fault_page_request prm;
-		__u8 padding2[56];
-	};
+	struct iommu_fault_page_request prm;
 };
 
 /**
-- 
2.34.1


