Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA0358BDEF
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242345AbiHGWcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242189AbiHGWbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0502118361;
        Sun,  7 Aug 2022 15:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910730; x=1691446730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0eQxR6em7YwtSJ4aNxbKq4cfhsibGseChB89myr5XqY=;
  b=fBJAlYAqZKc//40OFVOSvjZV1LhaOR+Aw2peLMaCLaUsmH3JqS/s7Ahb
   FRe1D1e+hHAFjqdPzr0l22/H5LOxLWQQJywzKTReOgQEk3JQTG2cyjEfq
   KoCCjoFkEXsspqGTEOR0qcqwvaPzKOE60HCpuHbnsDLAM7f6erQDnaQ7x
   8TR1ygDqCdgbdn+yGXf/WLWZfpapl02YpuYpxdY2b0m2mzfphiFw15EEH
   SuTul1Cwf/wIxxvZWQD2zLloMkhBIfQ89TkQxMM/OuGFpB3TzRdVDYgpI
   4/cq5fPBCbG+u1nBMpFcoPqE44x+9vbVxVlPyxShfBxsK/SwldrreYo4r
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852834"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852834"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642317"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 06/13] KVM: TDX: Pass size to reclaim_page()
Date:   Sun,  7 Aug 2022 15:18:39 -0700
Message-Id: <5dda5dbae9b4db639b1f1d4c66d64a164115c024.1659854957.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854957.git.isaku.yamahata@intel.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b7a75c0adbfa..0b9f9075e1ea 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -189,11 +189,13 @@ void tdx_hardware_disable(void)
 		tdx_disassociate_vp(&tdx->vcpu);
 }
 
-static void tdx_clear_page(unsigned long page)
+static void tdx_clear_page(unsigned long page, int size)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	unsigned long i;
 
+	WARN_ON_ONCE(size % 64);
+
 	/*
 	 * Zeroing the page is only necessary for systems with MKTME-i:
 	 * when re-assign one page from old keyid to a new keyid, MOVDIR64B is
@@ -203,13 +205,14 @@ static void tdx_clear_page(unsigned long page)
 	if (!static_cpu_has(X86_FEATURE_MOVDIR64B))
 		return;
 
-	for (i = 0; i < 4096; i += 64)
+	for (i = 0; i < size; i += 64)
 		/* MOVDIR64B [rdx], es:rdi */
 		asm (".byte 0x66, 0x0f, 0x38, 0xf8, 0x3a"
 		     : : "d" (zero_page), "D" (page + i) : "memory");
 }
 
-static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
+static int tdx_reclaim_page(unsigned long va, hpa_t pa, enum pg_level level,
+			    bool do_wb, u16 hkid)
 {
 	struct tdx_module_output out;
 	u64 err;
@@ -219,8 +222,11 @@ static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
 		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
 		return -EIO;
 	}
+	/* out.r8 == tdx sept page level */
+	WARN_ON_ONCE(out.r8 != pg_level_to_tdx_sept_level(level));
 
-	if (do_wb) {
+	/* only TDR page gets into this path */
+	if (do_wb && level == PG_LEVEL_4K) {
 		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
 		if (WARN_ON_ONCE(err)) {
 			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
@@ -228,7 +234,7 @@ static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
 		}
 	}
 
-	tdx_clear_page(va);
+	tdx_clear_page(va, KVM_HPAGE_SIZE(level));
 	return 0;
 }
 
@@ -257,7 +263,7 @@ static void tdx_reclaim_td_page(struct tdx_td_page *page)
 		 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 		 * cache doesn't need to be flushed again.
 		 */
-		if (tdx_reclaim_page(page->va, page->pa, false, 0))
+		if (tdx_reclaim_page(page->va, page->pa, PG_LEVEL_4K, false, 0))
 			return;
 
 		page->added = false;
@@ -404,8 +410,8 @@ void tdx_vm_free(struct kvm *kvm)
 	 * TDX global HKID is needed.
 	 */
 	if (kvm_tdx->tdr.added &&
-		tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa, true,
-				tdx_global_keyid))
+		tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa, PG_LEVEL_4K,
+				 true, tdx_global_keyid))
 		return;
 
 	free_page(kvm_tdx->tdr.va);
@@ -1548,7 +1554,8 @@ static void tdx_sept_drop_private_spte(
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page((unsigned long)__va(hpa), hpa, false, 0);
+		err = tdx_reclaim_page((unsigned long)__va(hpa), hpa, level,
+				       false, 0);
 
 unlock:
 	spin_unlock(&kvm_tdx->seamcall_lock);
@@ -1667,7 +1674,8 @@ static int tdx_sept_free_private_sp(struct kvm *kvm, gfn_t gfn, enum pg_level le
 	 * already flushed. We don't have to flush again.
 	 */
 	spin_lock(&kvm_tdx->seamcall_lock);
-	ret = tdx_reclaim_page((unsigned long)sept_page, __pa(sept_page), false, 0);
+	ret = tdx_reclaim_page((unsigned long)sept_page, __pa(sept_page),
+			       PG_LEVEL_4K, false, 0);
 	spin_unlock(&kvm_tdx->seamcall_lock);
 
 	return ret;
-- 
2.25.1

