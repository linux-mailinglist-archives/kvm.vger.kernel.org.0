Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF487CAFF9
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbjJPQk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbjJPQjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:39:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC83C8258;
        Mon, 16 Oct 2023 09:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473396; x=1729009396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y35oJUPopyeRbTd34DdLXBVXFicmHGF9J0ehvEF/xG0=;
  b=mKbBevXv1+UXK5+Lsljn5cYtREcta7uXcH6+Mw16+WEPw0I8zc5XF+S5
   jypaqru9S3EyPfQ1TUz3tfyzKtEPhi821/k3792SeRJqLPrWmO/MARkrT
   69/XrBgx5hVQQw/zbs+WIGGNtMI7XaxYOsoRIBVsmdXjRJh2S/99rFGck
   sEmXOXHGuMefECxPsX12bjtoU57eauEnNIV5DaBizMCjJGASzAtqT2WJM
   xCIe+dthNCitIY677Taq2lRfEx76583nArLvTLUELJCprTmTkIhc4Cb2D
   U6RSlwwyZukvRQOR8o1A1F9pyU/OPK4WaLxijCH9pry8l7N5uUiNllRUh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793146"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793146"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569231"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569231"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:14 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v5 06/16] KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large page
Date:   Mon, 16 Oct 2023 09:20:57 -0700
Message-Id: <f2260bfdaa1bcf53dfcd25073d8ba792383d9ed5.1697473009.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697473009.git.isaku.yamahata@intel.com>
References: <cover.1697473009.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c | 70 ++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 72672b2c30a1..992cf3ed02f2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1435,11 +1435,12 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
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
 
 static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
@@ -1456,7 +1457,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EAGAIN;
 	}
 	if (unlikely(err == (TDX_EPT_ENTRY_NOT_FREE | TDX_OPERAND_ID_RCX))) {
@@ -1472,7 +1473,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 					 &tmpout);
 		if (KVM_BUG_ON(tmp, kvm)) {
 			pr_tdx_error(TDH_MEM_SEPT_RD, tmp, &tmpout);
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			return -EIO;
 		}
 		pr_debug_ratelimited("gfn 0x%llx pg_level %d pfn 0x%llx entry 0x%llx level_stat 0x%llx\n",
@@ -1483,7 +1484,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 		if (level_state.level == tdx_level &&
 		    level_state.state == TDX_SEPT_PENDING &&
 		    entry.leaf && entry.pfn == pfn && entry.sve) {
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			WARN_ON_ONCE(!(to_kvm_tdx(kvm)->attributes &
 				       TDX_TD_ATTR_SEPT_VE_DISABLE));
 			return -EAGAIN;
@@ -1491,7 +1492,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 	}
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	}
 
@@ -1527,7 +1528,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1545,7 +1546,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1558,10 +1559,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+	int i;
 
 	/*
 	 * Because restricted mem doesn't support page migration with
@@ -1571,7 +1569,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * TODO: Once restricted mem introduces callback on page migration,
 	 * implement it and remove get_page/put_page().
 	 */
-	get_page(pfn_to_page(pfn));
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		get_page(pfn_to_page(pfn + i));
 
 	if (likely(is_td_finalized(kvm_tdx)))
 		return tdx_sept_page_aug(kvm, gfn, level, pfn);
@@ -1588,11 +1587,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
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
 
 	if (unlikely(!is_hkid_assigned(kvm_tdx))) {
 		/*
@@ -1602,7 +1599,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return 0;
 	}
 
@@ -1619,22 +1616,27 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
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
-	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
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
+		} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			r = -EIO;
+		} else {
+			tdx_clear_page(hpa, PAGE_SIZE);
+			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+		}
+		hpa += PAGE_SIZE;
 	}
-	tdx_clear_page(hpa, PAGE_SIZE);
-	tdx_unpin(kvm, pfn);
-	return 0;
+	return r;
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-- 
2.25.1

