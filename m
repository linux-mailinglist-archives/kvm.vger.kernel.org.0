Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7351C730
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383700AbiEESWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383212AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3B647AE1;
        Thu,  5 May 2022 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774554; x=1683310554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1jkcBKQleZuP+2LYbN3mGxRTD6jMnVu63Fc7/MnhhWw=;
  b=XW73NtPJFFJ4Kx+rg9y9JJrhAA0+h2NrhxfcRBaW1iwUK3lwvlnZhHbP
   MOmzYY2/Okpv0rGSBQHh95/1+Wi3GBrPPui9H0s7gwFNm5WRFkTnsz++O
   Ri9xM1fysVy6XPd7W9xal87fM5T37B/4Ky9FbRbdfGdkCp5bgZMOLpl5y
   yCuJwo/P5kyw/ZdbE9AZNMfTyBx6KXstfSfoLbqAFB73PFk6WSUC+sV0r
   ulB5WapgG71cF02FKyT0pEj9egOsE4HOBOsxE4t0tGdAJzyNpl4M7lRfA
   HJJSEITu+qdqL+3w+dXEaOmnkjgYv63lv0NhsYj+dZH3GSr5ze4hrMaZb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742019"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742019"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083261"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 037/104] KVM: x86/mmu: Allow non-zero value for non-present SPTE
Date:   Thu,  5 May 2022 11:14:31 -0700
Message-Id: <bfa4f7415a1d059bd3a4c6d14105f2baf2d03ba6.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX introduced a new ETP, Secure-EPT, in addition to the existing EPT.
Secure-EPT maps protected guest memory, which is called private. Since
Secure-EPT page tables is also protected, those page tables is also called
private.  The existing EPT is often called shared EPT to distinguish from
Secure-EPT.  And also page tables for share EPT is also called shared.

Virtualization Exception, #VE, is a new processor exception in VMX non-root
operation.  In certain virtualizatoin-related conditions, #VE is injected
into guest instead of exiting from guest to VMM so that guest is given a
chance to inspect it.  One important one is EPT violation.  When
"ETP-violation #VE" VM-execution is set, "#VE suppress bit" in EPT entry
is cleared, #VE is injected instead of EPT violation.

Because guest memory is protected with TDX, VMM can't parse instructions
in the guest memory.  Instead, MMIO hypercall is used for guest to pass
necessary information to VMM.

To make unmodified device driver work, guest TD expects #VE on accessing
shared GPA.  The #VE handler converts MMIO access into MMIO hypercall with
the EPT entry of enabled "#VE" by clearing "suppress #VE" bit.  Before VMM
enabling #VE, it needs to figure out the given GPA is for MMIO by EPT
violation.  So the execution flow looks like

- Allocate unused shared EPT entry with suppress #VE bit set.
- EPT violation on that GPA.
- VMM figures out the faulted GPA is for MMIO.
- VMM clears the suppress #VE bit.
- Guest TD gets #VE, and converts MMIO access into MMIO hypercall.
- If the GPA maps guest memory, VMM resolves it with guest pages.

For both cases, SPTE needs suppress #VE" bit set initially when it
is allocated or zapped, therefore non-zero non-present value for SPTE
needs to be allowed.

This change requires to update FNAME(sync_page) for shadow EPT.
"if(!sp->spte[i])" in FNAME(sync_page) means that the spte entry is the
initial value.  With the introduction of shadow_nonpresent_value which can
be non-zero, it doesn't hold any more. Replace zero check with
"!is_shadow_present_pte() && !is_mmio_spte()".

When "if (!spt[i])" doesn't hold, but the entry value is
shadow_nonpresent_value, the entry is wrongly synchronized from non-present
to non-present with (wrongly) pfn changed and tries to remove rmap wrongly
and BUG_ON() is hit.

TDP MMU uses REMOVED_SPTE = 0x5a0ULL as special constant to indicate the
intermediate value to indicate one thread is operating on it and the value
should be semi-arbitrary value.  For TDX (more correctly to use #VE), the
value should include suppress #VE value which is SHADOW_NONPRESENT_VALUE.
Rename REMOVED_SPTE to __REMOVED_SPTE and define REMOVED_SPTE as
SHADOW_NONPRESENT_VALUE | REMOVED_SPTE to set suppress #VE bit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 55 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
 arch/x86/kvm/mmu/spte.c        |  5 +++-
 arch/x86/kvm/mmu/spte.h        | 37 ++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c     | 23 +++++++++-----
 5 files changed, 105 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4a12d862bbb6..324ea25ee0c7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -693,6 +693,44 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline void kvm_init_shadow_page(void *page)
+{
+#ifdef CONFIG_X86_64
+	int ign;
+
+	WARN_ON_ONCE(shadow_nonpresent_value != SHADOW_NONPRESENT_VALUE);
+	asm volatile (
+		"rep stosq\n\t"
+		: "=c"(ign), "=D"(page)
+		: "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
+		: "memory"
+	);
+#else
+	BUG();
+#endif
+}
+
+static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
+	int start, end, i, r;
+	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
+
+	if (is_tdp_mmu && shadow_nonpresent_value)
+		start = kvm_mmu_memory_cache_nr_free_objects(mc);
+
+	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
+	if (r)
+		return r;
+
+	if (is_tdp_mmu && shadow_nonpresent_value) {
+		end = kvm_mmu_memory_cache_nr_free_objects(mc);
+		for (i = start; i < end; i++)
+			kvm_init_shadow_page(mc->objects[i]);
+	}
+	return 0;
+}
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -702,8 +740,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				       PT64_ROOT_MAX_LEVEL);
+	r = mmu_topup_shadow_page_cache(vcpu);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -5510,9 +5547,16 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 	 * what is used by the kernel for any given HVA, i.e. the kernel's
 	 * capabilities are ultimately consulted by kvm_mmu_hugepage_adjust().
 	 */
-	if (tdp_enabled)
+	if (tdp_enabled) {
+		/*
+		 * For TDP MMU, always set bit 63 for TDX support. See the
+		 * comment on SHADOW_NONPRESENT_VALUE.
+		 */
+#ifdef CONFIG_X86_64
+		shadow_nonpresent_value = SHADOW_NONPRESENT_VALUE;
+#endif
 		max_huge_page_level = tdp_huge_page_level;
-	else if (boot_cpu_has(X86_FEATURE_GBPAGES))
+	} else if (boot_cpu_has(X86_FEATURE_GBPAGES))
 		max_huge_page_level = PG_LEVEL_1G;
 	else
 		max_huge_page_level = PG_LEVEL_2M;
@@ -5643,7 +5687,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	if (!(is_tdp_mmu_enabled(vcpu->kvm) && shadow_nonpresent_value))
+		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b025decf610d..058efd4bbcbc 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1030,7 +1030,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		if (!is_shadow_present_pte(sp->spt[i]) &&
+		    !is_mmio_spte(sp->spt[i]))
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 75c9e87d446a..1bf934f64b6f 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -36,6 +36,9 @@ u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_value;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
+#ifdef CONFIG_X86_64
+u64 __read_mostly shadow_nonpresent_value;
+#endif
 
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
@@ -330,7 +333,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	 * not set any RWX bits.
 	 */
 	if (WARN_ON((mmio_value & mmio_mask) != mmio_value) ||
-	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
+	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
 	if (!mmio_value)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index fbbab180395e..3319ca7f8f48 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -140,6 +140,19 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+/*
+ * non-present SPTE value for both VMX and SVM for TDP MMU.
+ * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
+ * For VMX EPT, bit 63 is ignored if #VE is disabled.
+ *              bit 63 is #VE suppress if #VE is enabled.
+ */
+#ifdef CONFIG_X86_64
+#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
+static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
+#else
+#define SHADOW_NONPRESENT_VALUE	0ULL
+#endif
+
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
@@ -154,6 +167,12 @@ extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_value;
 extern u64 __read_mostly shadow_me_mask;
 
+#ifdef CONFIG_X86_64
+extern u64 __read_mostly shadow_nonpresent_value;
+#else
+#define shadow_nonpresent_value	0ULL
+#endif
+
 /*
  * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_MASK;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
@@ -174,9 +193,12 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 
 /*
  * If a thread running without exclusive control of the MMU lock must perform a
- * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
+ * multi-part operation on an SPTE, it can set the SPTE to __REMOVED_SPTE as a
  * non-present intermediate value. Other threads which encounter this value
- * should not modify the SPTE.
+ * should not modify the SPTE.  For the case that TDX is enabled,
+ * SHADOW_NONPRESENT_VALUE, which is "suppress #VE" bit set because TDX module
+ * always enables "EPT violation #VE".  The bit is ignored by non-TDX case as
+ * present bit (bit 0) is cleared.
  *
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
  * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
@@ -184,10 +206,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  *
  * Only used by the TDP MMU.
  */
-#define REMOVED_SPTE	0x5a0ULL
+#define __REMOVED_SPTE	0x5a0ULL
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
-static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
+static_assert(!(__REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
+static_assert(!(__REMOVED_SPTE & SHADOW_NONPRESENT_VALUE));
+
+/*
+ * See above comment around __REMOVED_SPTE.  REMOVED_SPTE is the actual
+ * intermediate value set to the removed SPET.  it sets the "suppress #VE" bit.
+ */
+#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | __REMOVED_SPTE)
 
 static inline bool is_removed_spte(u64 spte)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4fabb2cd0ba9..383904742f44 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -673,8 +673,16 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * special removed SPTE value. No bookkeeping is needed
 	 * here since the SPTE is going from non-present
 	 * to non-present.
+	 *
+	 * Set non-present value to SHADOW_NONPRESENT_VALUE, rather than 0.
+	 * It is because when TDX is enabled, TDX module always
+	 * enables "EPT-violation #VE", so KVM needs to set
+	 * "suppress #VE" bit in EPT table entries, in order to get
+	 * real EPT violation, rather than TDVMCALL.  KVM sets
+	 * SHADOW_NONPRESENT_VALUE (which sets "suppress #VE" bit) so it
+	 * can be set when EPT table entries are zapped.
 	 */
-	kvm_tdp_mmu_write_spte(iter->sptep, 0);
+	kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
 
 	return 0;
 }
@@ -846,8 +854,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared)
-			tdp_mmu_set_spte(kvm, &iter, 0);
-		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
+			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
+		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
 			goto retry;
 	}
 }
@@ -903,8 +911,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
 		return false;
 
-	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true, true);
+	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
+			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
+			   true, true);
 
 	return true;
 }
@@ -941,7 +950,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
+		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
 
@@ -1312,7 +1321,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * invariant that the PFN of a present * leaf SPTE can never change.
 	 * See __handle_changed_spte().
 	 */
-	tdp_mmu_set_spte(kvm, iter, 0);
+	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
 
 	if (!pte_write(range->pte)) {
 		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-- 
2.25.1

