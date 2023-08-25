Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86010787DB0
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbjHYCd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbjHYCda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:33:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0934A1AD;
        Thu, 24 Aug 2023 19:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692930809; x=1724466809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cvTs9Fvd3z0/VMEYN+fjeI+gwQkvUA3Okx83E/hK5Gw=;
  b=PilQFmppGyWkAfP1FFOBZ17HsIq2TZo0xnxugepGElJJ0PvNJdviP7I0
   WlyGXebopcFocmc+PkAvclD9Rep43zuto+hae8Ta3bYEFXZhfcsORFLg2
   lJlSctrwqXvHqeur7PP2NGzw8eYEluZZcgqhu2L6Rzp2E20OC+OTkYjBu
   TbRmh0daQpg50dSBpm8Czxz9ypFRgEJR5OlIelaIrf+BP8g8p5ZI2niUe
   3bAOhkwoPFhfCubuq1eMKTrrbiJUitYTDjhcnUHsWwdsIhHRi19MfVCjX
   7FdfXQwVdPXW++ZuA35/d46LSUMVcQQGiG+QLoOZgqj8+T6tvSfhnsurY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="372009440"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="372009440"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 19:33:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="730875031"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="730875031"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 24 Aug 2023 19:33:24 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v4 03/10] iommu: Remove unrecoverable fault data
Date:   Fri, 25 Aug 2023 10:30:19 +0800
Message-Id: <20230825023026.132919-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230825023026.132919-1-baolu.lu@linux.intel.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The unrecoverable fault data is not used anywhere. Remove it to avoid
dead code.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h | 70 +------------------------------------------
 1 file changed, 1 insertion(+), 69 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 18103045bf44..1c8f33d0a4c1 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -48,69 +48,9 @@ struct iommu_dma_cookie;
 
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
@@ -140,19 +80,11 @@ struct iommu_fault_page_request {
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

