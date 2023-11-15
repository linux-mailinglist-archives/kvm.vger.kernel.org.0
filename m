Return-Path: <kvm+bounces-1716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C317EBB7E
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 04:07:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D206EB20B04
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 03:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71698257B;
	Wed, 15 Nov 2023 03:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W3kRDH6X"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09FE7EE
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:06:57 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7100DB;
	Tue, 14 Nov 2023 19:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700017615; x=1731553615;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4WHpnPAgpgICs8FBrxCtS/2uBCk1GaTVpWDqcaGoIf8=;
  b=W3kRDH6Xq6I/0ANzQzIgt+H6MLJNC7QjTUywq5WnKTPx0nRsNEXZjvIC
   t2h8d3TDq5HGkv8PeH98QHr/iUh5EuqXVzhGafcef4CSf3x5+o/ZdGRxk
   Wzc0JkGjTUhVsESsvr39R8fYU1DQqpw2oUXENRNTO00n6BhCFDVy6Z1S6
   6ajsDbBgmWc5gdTGcjBWpvdY30Rpw1HHCfy8ldZgHZvr1tcMv8GFLFvsW
   OiRaCq/iir9tbLGQ5liXcNwMjH3lUpst4RoOZcBoasBgU8RN6ykBFsaDD
   r6BpV25Hr4XIE6MLCIdOAn4sqbBOy5p3f53hwA75lsJIxziwuKhoTEfQO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="394715339"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="394715339"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 19:06:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="1012128786"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="1012128786"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 14 Nov 2023 19:06:52 -0800
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
	Yan Zhao <yan.y.zhao@intel.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v7 03/12] iommu: Remove unrecoverable fault data
Date: Wed, 15 Nov 2023 11:02:17 +0800
Message-Id: <20231115030226.16700-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115030226.16700-1-baolu.lu@linux.intel.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
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
---
 include/linux/iommu.h | 70 +------------------------------------------
 1 file changed, 1 insertion(+), 69 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c2e2225184cf..81eee1afec72 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -50,69 +50,9 @@ struct iommu_dma_cookie;
 
 /* Generic fault types, can be expanded IRQ remapping fault */
 enum iommu_fault_type {
-	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
 	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
 };
 
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
-};
-
 /**
  * struct iommu_fault_page_request - Page Request data
  * @flags: encodes whether the corresponding fields are valid and whether this
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


