Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBCF7626D2
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjGYWgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjGYWfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641684C03;
        Tue, 25 Jul 2023 15:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324159; x=1721860159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vRTwnVkAPRceYB8hWCuKqbqhiGxKBfRejTzNTUTVWEo=;
  b=lG9IOhBbP4bARo0MKUSEK+nQuqAP9bfTPCK8m8fPOdaTfLVibX8Jn8/O
   GGjspN9Mx4i83ymFo0i69lfKgGpr7NgOTcPgu1jByNTLuGIi/oNSKzbuH
   grjs+w8MuLALmj2fQ8t4CKusNjlTSp3Be2aDN7t1Ab599wpbmVLxvWxAF
   LciqPMT7Az67UOLu/6hqPZ0PAKGUT2+4CC52tWuVrWoOxAZm1sep1GTAA
   ni4I66esbHr6xsi21OrOalGocTyf7oR1W+0HEW8iW2/LGWdJ/5g1pqbr9
   Auo5vFiDYpiqMj6y6C06lwo3yxyZ5OUdallnDSabdoQOoKAx+LhtMstWu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467117"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467117"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855799"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855799"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:09 -0700
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
Subject: [RFC PATCH v4 05/16] KVM: TDX: Pass size to reclaim_page()
Date:   Tue, 25 Jul 2023 15:23:51 -0700
Message-Id: <48b900ccfa2257ddbfeea475b9b43ee36fb52080.1690323516.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690323516.git.isaku.yamahata@intel.com>
References: <cover.1690323516.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

A 2MB large page can be tdh_mem_page_aug()'ed to TD directly. In this case,
it needs to reclaim and clear the page as 2MB size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3522ee232eda..86cfbf435671 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -198,12 +198,13 @@ static void tdx_disassociate_vp_on_cpu(struct kvm_vcpu *vcpu)
 	smp_call_function_single(cpu, tdx_disassociate_vp_arg, vcpu, 1);
 }
 
-static void tdx_clear_page(unsigned long page_pa)
+static void tdx_clear_page(unsigned long page_pa, int size)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	void *page = __va(page_pa);
 	unsigned long i;
 
+	WARN_ON_ONCE(size % PAGE_SIZE);
 	/*
 	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
 	 * required to clear/write the page with new keyid to prevent integrity
@@ -212,7 +213,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	 * clflush doesn't flush cache with HKID set.  The cache line could be
 	 * poisoned (even without MKTME-i), clear the poison bit.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
+	for (i = 0; i < size; i += 64)
 		movdir64b(page + i, zero_page);
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
@@ -221,7 +222,8 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
-static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
+static int tdx_reclaim_page(hpa_t pa, enum pg_level level,
+			    bool do_wb, u16 hkid)
 {
 	struct tdx_module_output out;
 	u64 err;
@@ -239,8 +241,10 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
 		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
 		return -EIO;
 	}
+	/* out.r8 == tdx sept page level */
+	WARN_ON_ONCE(out.r8 != pg_level_to_tdx_sept_level(level));
 
-	if (do_wb) {
+	if (do_wb && level == PG_LEVEL_4K) {
 		/*
 		 * Only TDR page gets into this path.  No contention is expected
 		 * because of the last page of TD.
@@ -252,7 +256,7 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
 		}
 	}
 
-	tdx_clear_page(pa);
+	tdx_clear_page(pa, KVM_HPAGE_SIZE(level));
 	return 0;
 }
 
@@ -266,7 +270,7 @@ static void tdx_reclaim_td_page(unsigned long td_page_pa)
 	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 	 * cache doesn't need to be flushed again.
 	 */
-	if (tdx_reclaim_page(td_page_pa, false, 0))
+	if (tdx_reclaim_page(td_page_pa, PG_LEVEL_4K, false, 0))
 		/*
 		 * Leak the page on failure:
 		 * tdx_reclaim_page() returns an error if and only if there's an
@@ -474,7 +478,7 @@ void tdx_vm_free(struct kvm *kvm)
 	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
 	 * TDX global HKID is needed.
 	 */
-	if (tdx_reclaim_page(kvm_tdx->tdr_pa, true, tdx_global_keyid))
+	if (tdx_reclaim_page(kvm_tdx->tdr_pa, PG_LEVEL_4K, true, tdx_global_keyid))
 		return;
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
@@ -1468,7 +1472,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page(hpa, false, 0);
+		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
 		tdx_unpin(kvm, pfn);
@@ -1501,7 +1505,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return -EIO;
 	}
-	tdx_clear_page(hpa);
+	tdx_clear_page(hpa, PAGE_SIZE);
 	tdx_unpin(kvm, pfn);
 	return 0;
 }
@@ -1612,7 +1616,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * already flushed. We don't have to flush again.
 	 */
 	if (!is_hkid_assigned(kvm_tdx))
-		return tdx_reclaim_page(__pa(private_spt), false, 0);
+		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K, false, 0);
 
 	/*
 	 * free_private_spt() is (obviously) called when a shadow page is being
-- 
2.25.1

