Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0260647A13
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiLHXgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiLHXfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:55 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FC36ACF1;
        Thu,  8 Dec 2022 15:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542555; x=1702078555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZkzU93yGsqlH6pguX+JaKA3Qg8R4oA+6wDbuZ9tuIN8=;
  b=bCanLORXpMn0H27fXDrMW3lqXHm5WFmKg021NZGK3sbH5IkJGBH6lz4C
   9Sxmq7A0EILJfK60+fyASQ8zR/HRCzlsVvCbNvdggDlJLgu7MIyzVq9Iz
   hWdNcBzlPwJ+QgD3Qj9nTL/pjFYXjU60b5pMkP7RCvgQ8DhYz91Yhasul
   zHHKUMpWCovNwUSIO2rx3UzP+szv+GCbwEGDI+01iJ+iNQeXo82S73b04
   TGoMYycwDa93H8S4wuS+L6mTlyGSLY5p7NuWOJNoz8Ur6xzT4xfs+Acm7
   CPdeAOwcqjgLR+TtyJ5ewTCm32S6+7xdGjFu552N9jgwjE4GiqX/geUyQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586503"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586503"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950918"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950918"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:54 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 05/15] KVM: TDX: Pass size to reclaim_page()
Date:   Thu,  8 Dec 2022 15:35:40 -0800
Message-Id: <1844264da0ccee5570a6eace87d386426a9ac4c7.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
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

A 2MB large page can be tdh_mem_page_aug()'ed to TD directly. In this case,
it needs to reclaim and clear the page as 2MB size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5b392d9baa25..df213b488f89 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -184,14 +184,17 @@ void tdx_hardware_disable(void)
 		tdx_disassociate_vp(&tdx->vcpu);
 }
 
-static void tdx_clear_page(unsigned long page_pa)
+static void tdx_clear_page(unsigned long page_pa, int size)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	void *page = __va(page_pa);
 	unsigned long i;
 
+	WARN_ON_ONCE(size % PAGE_SIZE);
+
 	if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
-		clear_page(page);
+		for (i = 0; i < size; i += PAGE_SIZE)
+			clear_page(page + i);
 		return;
 	}
 
@@ -204,7 +207,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	 * The cache line could be poisoned (even without MKTME-i), clear the
 	 * poison bit.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
+	for (i = 0; i < size; i += 64)
 		movdir64b(page + i, zero_page);
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
@@ -213,7 +216,8 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
-static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
+static int tdx_reclaim_page(hpa_t pa, enum pg_level level,
+			    bool do_wb, u16 hkid)
 {
 	struct tdx_module_output out;
 	u64 err;
@@ -231,8 +235,10 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
 		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
 		return -EIO;
 	}
+	/* out.r8 == tdx sept page level */
+	WARN_ON_ONCE(out.r8 != pg_level_to_tdx_sept_level(level));
 
-	if (do_wb) {
+	if (do_wb && level == PG_LEVEL_4K) {
 		/*
 		 * Only TDR page gets into this path.  No contention is expected
 		 * because the last page of TD.
@@ -244,7 +250,7 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
 		}
 	}
 
-	tdx_clear_page(pa);
+	tdx_clear_page(pa, KVM_HPAGE_SIZE(level));
 	return 0;
 }
 
@@ -275,7 +281,7 @@ static void tdx_reclaim_td_page(struct tdx_td_page *page)
 		 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 		 * cache doesn't need to be flushed again.
 		 */
-		if (tdx_reclaim_page(page->pa, false, 0))
+		if (tdx_reclaim_page(page->pa, PG_LEVEL_4K, false, 0))
 			return;
 
 		page->added = false;
@@ -428,7 +434,8 @@ void tdx_vm_free(struct kvm *kvm)
 	 * TDX global HKID is needed.
 	 */
 	if (kvm_tdx->tdr.added &&
-		tdx_reclaim_page(kvm_tdx->tdr.pa, true, tdx_global_keyid))
+		tdx_reclaim_page(kvm_tdx->tdr.pa, PG_LEVEL_4K, true,
+				 tdx_global_keyid))
 		return;
 
 	free_page((unsigned long)__va(kvm_tdx->tdr.pa));
@@ -1398,7 +1405,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page(hpa, false, 0);
+		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
 		tdx_unpin(kvm, pfn);
@@ -1537,7 +1544,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * already flushed. We don't have to flush again.
 	 */
 	if (!is_hkid_assigned(kvm_tdx))
-		return tdx_reclaim_page(__pa(private_spt), false, 0);
+		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K, false, 0);
 
 	/*
 	 * free_private_spt() is (obviously) called when a shadow page is being
-- 
2.25.1

