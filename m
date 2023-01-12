Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61573667C47
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbjALRMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjALRMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:12:10 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C17CDF0;
        Thu, 12 Jan 2023 08:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542136; x=1705078136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nIjTfGGdZyqyIE1lEPQNVb+HiQZclRMOxDxgV3JrZtc=;
  b=T+Hd8tbV8PoTcRCNP9RfLHpdw06LN2dK1aHFATihCwJr2TEKSQuKsCev
   mCgwewB4NJPyL63wCDZa2p7n+GqoCgnff4vNBjgRzeXIJtZrqfWc9BnIJ
   Wot1oK/wYIfjaYa4f7aTXPbsqUwoi4Sx8YZAzKd3wmJIl0zyjXmRmFEAB
   AxDymcwJ0AV4GJN3hXY5ICvPrAkWZ+qcCD38uIP58xw5HTD6gcqBD/emH
   7reD/wc4A3XSmu1l11QCveEK/xSE34ZEeJb93+eXE2HD5ydkGytnz77p2
   qF6LcSXMOnqF+Kmil1ZrfjkA7YIn9MFL3hzMao1rHCZMn5WvM7dVa7weK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816299"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816299"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658338"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658338"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 06/16] KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large page
Date:   Thu, 12 Jan 2023 08:43:58 -0800
Message-Id: <591f477bd44f0cfbc7475194be32e9f771c3f2f8.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Allow large page level AUG and REMOVE for TDX pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 63 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8bc8fd7f28eb..d7be634edf3c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1322,11 +1322,12 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
+static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
 {
-	struct page *page = pfn_to_page(pfn);
+	int i;
 
-	put_page(page);
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		put_page(pfn_to_page(pfn + i));
 }
 
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1340,6 +1341,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	hpa_t source_pa;
 	bool measure;
 	u64 err;
+	int i;
 
 	/*
 	 * Because restricted mem doesn't support page migration with
@@ -1349,22 +1351,19 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * TODO: Once restricted mem introduces callback on page migration,
 	 * implement it and remove get_page/put_page().
 	 */
-	get_page(pfn_to_page(pfn));
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		get_page(pfn_to_page(pfn + i));
 
 	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
 	if (likely(is_td_finalized(kvm_tdx))) {
-		/* TODO: handle large pages. */
-		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-			return -EINVAL;
-
 		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 		if (err == TDX_ERROR_SEPT_BUSY) {
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			return -EAGAIN;
 		}
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			return -EIO;
 		}
 		return 0;
@@ -1387,7 +1386,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1405,7 +1404,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	} while (err == TDX_ERROR_SEPT_BUSY);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1422,11 +1421,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	hpa_t hpa_with_hkid;
+	int r = 0;
 	u64 err;
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+	int i;
 
 	if (!is_hkid_assigned(kvm_tdx)) {
 		/*
@@ -1436,7 +1433,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return 0;
 	}
 
@@ -1453,21 +1450,25 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 
-	hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
-	do {
-		/*
-		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
-		 * this page was removed above, other thread shouldn't be
-		 * repeatedly operating on this page.  Just retry loop.
-		 */
-		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
-	} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
-		return -EIO;
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++) {
+		hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
+		do {
+			/*
+			 * TDX_OPERAND_BUSY can happen on locking PAMT entry.
+			 * Because this page was removed above, other thread
+			 * shouldn't be repeatedly operating on this page.
+			 * Simple retry should work.
+			 */
+			err = tdh_phymem_page_wbinvd(hpa_with_hkid);
+		} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			r = -EIO;
+		} else
+			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+		hpa += PAGE_SIZE;
 	}
-	tdx_unpin(kvm, pfn);
-	return 0;
+	return r;
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-- 
2.25.1

