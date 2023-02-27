Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E766A3C88
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjB0IZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjB0IY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:56 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01941C337;
        Mon, 27 Feb 2023 00:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486254; x=1709022254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X+3zCrOz1M3BQjf665aykPhXZdf0cnWo4OHe8tVXUKQ=;
  b=bOnLCXRpdYVGg6WjvFcFUlG6vpxiobiHYnOGv/ntsfN6ujbc9O7gQz3W
   HBMxMYHeS96IItAHkTjTUEzkO+tE/vk00QaXqhwMN95Bou3Gew5XuMZOr
   c5X8xz+2MqyrIJ3b2++sCDo/tTcMLPI4mOpRxxSDKIFlJdW0ga8zsfmoC
   txnJO+1U3cG1C1boeDQelT8xqflK1u6E8nbX/tRhfaot1BcGxdl0tnSyI
   pCg6EygicZM8L6lIlH8JPTu6o7ixd3bZvBStKmyXHvL30VnKdwCQuAcLY
   qsmq8zCIsuCcMVR3k0SovXYaRjUKq89wUeOKHOWanWmIMdT2F0Cskihvo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608771"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608771"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242133"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242133"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:05 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v12 025/106] KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
Date:   Mon, 27 Feb 2023 00:22:24 -0800
Message-Id: <04d1691215b2ef7e81041b597f5330158103ff28.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX support will need the "suppress #VE" bit (bit 63) set as the
initial value for SPTE.  To reduce code change size, introduce a new macro
SHADOW_NONPRESENT_VALUE for the initial value for the shadow page table
entry (SPTE) and replace hard-coded value 0 for it.  Initialize shadow page
tables with their value.

The plan is to unconditionally set the "suppress #VE" bit for both AMD and
Intel as: 1) AMD hardware uses the bit 63 as NX for present SPTE and
ignored for non-present SPTE; 2) for conventional VMX guests, KVM never
enables the "EPT-violation #VE" in VMCS control and "suppress #VE" bit is
ignored by hardware.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 17 +++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h |  3 ++-
 arch/x86/kvm/mmu/spte.h        |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c     | 15 ++++++++-------
 4 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 38745d275e22..5ce591bb6c19 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -547,9 +547,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
 	if (!is_shadow_present_pte(old_spte) ||
 	    !spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, SHADOW_NONPRESENT_VALUE);
 
 	if (!is_shadow_present_pte(old_spte))
 		return old_spte;
@@ -583,7 +583,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -6001,7 +6001,16 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	/*
+	 * When X86_64, initial SEPT entries are initialized with
+	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
+	 * mmu_memory_cache_alloc_obj().
+	 */
+	if (IS_ENABLED(CONFIG_X86_64))
+		vcpu->arch.mmu_shadow_page_cache.init_value =
+			SHADOW_NONPRESENT_VALUE;
+	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
+		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e5662dbd519c..8ef7bc674d41 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1028,7 +1028,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		/* spt[i] has initial value of shadow page table allocation */
+		if (sp->spt[i] == SHADOW_NONPRESENT_VALUE)
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0d8deefee66c..f190eaf6b2b5 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -148,6 +148,8 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+#define SHADOW_NONPRESENT_VALUE	0ULL
+
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 59f47b51784d..380bd0cea939 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -690,7 +690,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present to non-present.  Use
 	 * the raw write helper to avoid an unnecessary check on volatile bits.
 	 */
-	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
+	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
 
 	return 0;
 }
@@ -867,8 +867,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared)
-			tdp_mmu_set_spte(kvm, &iter, 0);
-		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
+			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
+		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
 			goto retry;
 	}
 }
@@ -924,8 +924,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
 		return false;
 
-	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true, true);
+	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
+			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
+			   true, true);
 
 	return true;
 }
@@ -959,7 +960,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
+		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
 
@@ -1328,7 +1329,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * invariant that the PFN of a present * leaf SPTE can never change.
 	 * See __handle_changed_spte().
 	 */
-	tdp_mmu_set_spte(kvm, iter, 0);
+	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
 
 	if (!pte_write(range->pte)) {
 		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-- 
2.25.1

