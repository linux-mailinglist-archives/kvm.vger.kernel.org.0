Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24B558BDE8
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbiHGWcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242291AbiHGWbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1496618370;
        Sun,  7 Aug 2022 15:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910733; x=1691446733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dYUOiB5tTFSzBs+i3koPMnn3IvN02+stBGoE31HoWro=;
  b=bjKCdsUu3r9bsJDWwmsm7L4w6UsFvAU+yYhsRgkH5HFiLiGiTu6h/Csx
   7/wcuevAhmihPaGpuyVvVhcSK4jqhEnsCIExfRizXUv6sw8usnMLCla0h
   cmoUGcf8Q33ynp42kTr6Or2DDtpLsX+FWKB39dPR1qLq1A+hyZXMYJDhI
   uVFBkffGkoCvn28Wrh2o1sl0Nxm0wQ5ivTOh+FFBr1oFPhVWz9TNoLi4W
   JuZF2sn3u8gF2zv3FLZZa1juOXtSkAYtspW8wnFWEDAwa0r8h9a7iYOmK
   WbmaLDXyur4t9Bl8+VXV6umc7laxfQRtw3Uw7Rf4Qmg4Rhmn/0AsAkKyd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852842"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852842"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642345"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 12/13] KVM: TDX: Split a large page when 4KB page within it converted to shared
Date:   Sun,  7 Aug 2022 15:18:45 -0700
Message-Id: <5831f5fad935edd3c3e0f198c0c3668f33eb65b3.1659854957.git.isaku.yamahata@intel.com>
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

When mapping the shared page for TDX, it needs to zap private alias.

In the case that private page is mapped as large page (2MB), it can be
removed directly only when the whole 2MB is converted to shared.
Otherwise, it has to split 2MB page into 512 4KB page, and only remove
the pages that converted to shared.

When a present large leaf spte switches to present non-leaf spte, TDX needs
to split the corresponding SEPT page to reflect it.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c      | 36 +++++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/tdx_arch.h |  1 +
 arch/x86/kvm/vmx/tdx_ops.h  |  7 +++++++
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e4e193b1a758..a340caeb9c62 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1595,6 +1595,28 @@ static int tdx_sept_link_private_sp(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn,
+				       enum pg_level level, void *sept_page)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn << PAGE_SHIFT;
+	hpa_t hpa = __pa(sept_page);
+	struct tdx_module_output out;
+	u64 err;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	err = tdh_mem_page_demote(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_DEMOTE, err, &out);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 				      enum pg_level level)
 {
@@ -1604,8 +1626,6 @@ static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct tdx_module_output out;
 	u64 err;
 
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
 	spin_lock(&kvm_tdx->seamcall_lock);
 	err = tdh_mem_range_block(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
 	spin_unlock(&kvm_tdx->seamcall_lock);
@@ -1717,13 +1737,11 @@ static void tdx_handle_changed_private_spte(
 	lockdep_assert_held(&kvm->mmu_lock);
 
 	if (change->new.is_present) {
-		/* TDP MMU doesn't change present -> present */
-		WARN_ON(change->old.is_present);
-		/*
-		 * Use different call to either set up middle level
-		 * private page table, or leaf.
-		 */
-		if (is_leaf)
+		if (level > PG_LEVEL_4K && was_leaf && !is_leaf) {
+			tdx_sept_zap_private_spte(kvm, gfn, level);
+			tdx_sept_tlb_remote_flush(kvm);
+			tdx_sept_split_private_spte(kvm, gfn, level, change->sept_page);
+		} else if (is_leaf)
 			tdx_sept_set_private_spte(
 				kvm, gfn, level, change->new.pfn);
 		else {
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index fbf334bc18c9..5970416e95b2 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -21,6 +21,7 @@
 #define TDH_MNG_CREATE			9
 #define TDH_VP_CREATE			10
 #define TDH_MNG_RD			11
+#define TDH_MEM_PAGE_DEMOTE		15
 #define TDH_MR_EXTEND			16
 #define TDH_MR_FINALIZE			17
 #define TDH_VP_FLUSH			18
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index da662aa46cd9..3b7373272d61 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -127,6 +127,13 @@ static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_output *out
 	return __seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
 }
 
+static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				      struct tdx_module_output *out)
+{
+	return seamcall_sept_retry(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page,
+				   0, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_output *out)
 {
-- 
2.25.1

