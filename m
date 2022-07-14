Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16B057552D
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 20:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbiGNSlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 14:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiGNSlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 14:41:15 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EAF57E1D;
        Thu, 14 Jul 2022 11:41:13 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id l124so2609322pfl.8;
        Thu, 14 Jul 2022 11:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZdWafMDntHq94O19v3BVGEgP72GYF27Ou8vnDfzDrXA=;
        b=lXCrZPJse1d0AcdI5EZM41trCmpQfNemrbpdJ16cprXeFU5/1VzNYu32NBfWE4/l6i
         V58y8dcKi1IPeY17jbXW5/CN9bdBco2x1Q0bVzdUcw8xitVt7IDzJJJcagyFHV+lkk4I
         Mzz5e2bA1kSqjPs2L0AaztF7qfmtbUC+1Vq1cLJRsodZmiFu+SAhxD0ywcdYU0zkEns4
         AUB5cZNVpJ1clSITBUFuHEqiLJ/8Q82SDp0uBAhawz03WeijJ21YytlaKpPupKEpERWH
         yfGYMH0/DVfgPMJGgbNX0eDpSkW/kmafv47ei4J3OMmA/XeFeY0oNlYs95Zv1v6jGdB7
         HmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZdWafMDntHq94O19v3BVGEgP72GYF27Ou8vnDfzDrXA=;
        b=byXWpqqgOjrmZSL6Gt0pfQZQuZHw7BMM4zsjvN+n9rMzLeNzZ1LlLj5NPiIfg5Ddx3
         6eRq/mcdsXYNHvkXT52ZzQhp7KtKeRtxcSVDzZioCvzNI7imila0U3HFFIvjoXsArLwT
         V7mEnJ91JCH95W/xyQX3o1yqb2Kk4N5LAPSUr9zVbtg+gtrR/2qJgnpI3MztX+zSho3T
         59LCDTAbtTK7xZxDsMB5N9Mf9oNY5/4J7bQ9W5Fwg5UwO53N0MvkiIcLB+1VYvvOxgZv
         VB/D4WImDD/HCw8dUA0J/VKqf1FuYkwg/+77IiWB4cXN8Ro+SP/zc4yArMkssdJv6w4v
         u40g==
X-Gm-Message-State: AJIora+lyzwFZKHKhR/pGXSrjEPR7OtBPUK4k7isXkEC/u4QKKLhZAun
        mqWc2zCSZAobh4YO+Biq+T9ErbLE7qU=
X-Google-Smtp-Source: AGRyM1vFDi+oWAGhW2VO7lb4cIJDvErBwuP1itjV0s2xKmr0dF3QKqxsvVGqlPct962tGMQp/M1+Vw==
X-Received: by 2002:a05:6a00:8cb:b0:510:9ec4:8f85 with SMTP id s11-20020a056a0008cb00b005109ec48f85mr9416631pfu.24.1657824073295;
        Thu, 14 Jul 2022 11:41:13 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id 188-20020a6308c5000000b00413d592af6asm1714768pgi.50.2022.07.14.11.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 11:41:12 -0700 (PDT)
Date:   Thu, 14 Jul 2022 11:41:11 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <20220714184111.GT1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for review. Now here is the updated version.

From f1ee540d62ba13511b2c7d3db7662e32bd263e48 Mon Sep 17 00:00:00 2001
Message-Id: <f1ee540d62ba13511b2c7d3db7662e32bd263e48.1657823906.git.isaku.yamahata@intel.com>
In-Reply-To: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1657823906.git.isaku.yamahata@intel.com>
References: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1657823906.git.isaku.yamahata@intel.com>
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Mon, 29 Jul 2019 19:23:46 -0700
Subject: [PATCH 036/304] KVM: x86/mmu: Allow non-zero value for non-present
 SPTE

TDX introduced a new ETP, Secure-EPT, in addition to the existing EPT.
Secure-EPT maps protected guest memory, which is called private. Since
Secure-EPT page tables is also protected, those page tables is also called
private.  The existing EPT is often called shared EPT to distinguish from
Secure-EPT.  And also page tables for shared EPT is also called shared.

TDX module enables #VE injection by setting "EPT-violation #VE" in
secondary processor-based VM-execution controls of TD VMCS.  It also sets
"suppress #VE" bit in Secure-EPT so that EPT violation on Secure-EPT causes
exit to VMM.

Because guest memory is protected with TDX, VMM can't parse instructions in
the guest memory.  Instead, MMIO hypercall is used for guest TD to pass
necessary information to VMM.  To make unmodified device driver work, guest
TD expects #VE on accessing shared GPA for MMIO. The #VE handler of guest
TD converts MMIO access into MMIO hypercall.  To trigger #VE in guest TD,
VMM needs to clear "suppress #VE" bit in shared EPT entry that corresponds
to MMIO address.

So the execution flow related for MMIO is as follows

- TDX module sets "EPT-violation #VE" in secondary processor-based
  VM-execution controls of TD VMCS.
- Allocate page for shared EPT PML4E page. Shared EPT entries are
  initialized with suppress #VE bit set.  Update the EPTP pointer.
- TD accesses a GPA for MMIO to trigger EPT violation.  It exits to VMM with
  EPT violation due to suppress #VE bit of EPT entries of PML4E page.
- VMM figures out the faulted GPA is for MMIO
- start shared EPT page table walk.
- Allocate non-leaf EPT pages for the shared EPT.
- Allocate leaf EPT page for the shared EPT and initialize EPT entries with
  suppress #VE bit set.
- VMM clears the suppress #VE bit for faulted GPA for MMIO.
  Please notice the leaf EPT page has 512 SPTE and other 511 SPTE entries
  need to keep "suppress #VE" bit set because GPAs for those SPTEs are not
  known to be MMIO. (It requires further lookups.)
  If GPA is a guest page, link the guest page from the leaf SPTE entry.
- resume TD vcpu.
- Guest TD gets #VE, and converts MMIO access into MMIO hypercall.
- If the GPA maps guest memory, VMM resolves it with guest pages.

SPTEs for shared EPT need suppress #VE" bit set initially when it
is allocated or zapped, therefore non-zero non-present value for SPTE
needs to be allowed.

TDP MMU uses REMOVED_SPTE = 0x5a0ULL as special constant to indicate the
intermediate value to indicate one thread is operating on it and the value
should be semi-arbitrary value.  For TDX (more exactly to use #VE), the
value should include suppress #VE bit.  Rename REMOVED_SPTE to
__REMOVED_SPTE and define REMOVED_SPTE as (REMOVED_SPTE | "suppress #VE")
bit.

For simplicity, "suppress #VE" bit is set unconditionally for X86_64 for
non-present SPTE.  Because "suppress #VE" bit (bit position of 63) for
non-present SPTE is ignored for non-TD case (AMD CPUs or Intel VMX case
with "EPT-violation #VE" cleared), the functionality shouldn't change.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 71 ++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
 arch/x86/kvm/mmu/spte.c        |  5 ++-
 arch/x86/kvm/mmu/spte.h        | 28 +++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c     | 23 +++++++----
 5 files changed, 116 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 51306b80f47c..992f31458f94 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -668,6 +668,55 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+#ifdef CONFIG_X86_64
+static inline void kvm_init_shadow_page(void *page)
+{
+	int ign;
+
+	/*
+	 * AMD: "suppress #VE" bit is ignored
+	 * Intel non-TD(VMX): "suppress #VE" bit is ignored because
+	 *   EPT_VIOLATION_VE isn't set.
+	 * guest TD: TDX module sets EPT_VIOLATION_VE
+	 *   conventional SEPT: "suppress #VE" bit must be set to get EPT violation
+	 *   private SEPT: "suppress #VE" bit is ignored.  CPU doesn't walk it
+	 *
+	 * For simplicity, unconditionally initialize SPET to set "suppress #VE".
+	 */
+	asm volatile ("rep stosq\n\t"
+		      : "=c"(ign), "=D"(page)
+		      : "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
+		      : "memory"
+	);
+}
+
+static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
+	int start, end, i, r;
+
+	start = kvm_mmu_memory_cache_nr_free_objects(mc);
+	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
+
+	/*
+	 * Note, topup may have allocated objects even if it failed to allocate
+	 * the minimum number of objects required to make forward progress _at
+	 * this time_.  Initialize newly allocated objects even on failure, as
+	 * userspace can free memory and rerun the vCPU in response to -ENOMEM.
+	 */
+	end = kvm_mmu_memory_cache_nr_free_objects(mc);
+	for (i = start; i < end; i++)
+		kvm_init_shadow_page(mc->objects[i]);
+	return r;
+}
+#else
+static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
+{
+	return kvm_mmu_topup_memory_cache(vcpu->arch.mmu_shadow_page_cache,
+					  PT64_ROOT_MAX_LEVEL);
+}
+#endif /* CONFIG_X86_64 */
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -677,8 +726,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				       PT64_ROOT_MAX_LEVEL);
+	r = mmu_topup_shadow_page_cache(vcpu);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -5654,7 +5702,24 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	/*
+	 * When X86_64, initial SEPT entries are initialized with
+	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
+	 * mmu_topup_shadow_page_cache().
+	 *
+	 * Shared EPTEs need to be initialized with SUPPRESS_VE=1, otherwise
+	 * not-present EPT violations would be reflected into the guest by
+	 * hardware as #VE exceptions.  This is handled by initializing page
+	 * allocations via kvm_init_shadow_page() during cache topup.
+	 * In that case, telling the page allocation to zero-initialize the page
+	 * would be wasted effort.
+	 *
+	 * The initialization is harmless for S-EPT entries because KVM's copy
+	 * of the S-EPT isn't consumed by hardware, and because under the hood
+	 * S-EPT entries should never #VE.
+	 */
+	if (!IS_ENABLED(X86_64))
+		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fe35d8fd3276..964ec76579f0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1031,7 +1031,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		/* spt[i] has initial value of shadow page table allocation */
+		if (sp->spt[i] != SHADOW_NONPRESENT_VALUE)
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cda1851ec155..bd441458153f 100644
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
@@ -360,7 +363,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	 * not set any RWX bits.
 	 */
 	if (WARN_ON((mmio_value & mmio_mask) != mmio_value) ||
-	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
+	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
 	if (!mmio_value)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0127bb6e3c7d..f5fd22f6bf5f 100644
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
@@ -178,16 +191,27 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  * non-present intermediate value. Other threads which encounter this value
  * should not modify the SPTE.
  *
+ * For X86_64 case, SHADOW_NONPRESENT_VALUE, "suppress #VE" bit, is set because
+ * "EPT violation #VE" in the secondary VM execution control may be enabled.
+ * Because TDX module sets "EPT violation #VE" for TD, "suppress #VE" bit for
+ * the conventional EPT needs to be set.
+ *
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
  * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
  * vulnerability.  Use only low bits to avoid 64-bit immediates.
  *
  * Only used by the TDP MMU.
  */
-#define REMOVED_SPTE	0x5a0ULL
+#define __REMOVED_SPTE	0x5a0ULL
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
-static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
+static_assert(!(__REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
+
+/*
+ * See above comment around __REMOVED_SPTE.  REMOVED_SPTE is the actual
+ * intermediate value set to the removed SPET.  it sets the "suppress #VE" bit.
+ */
+#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | __REMOVED_SPTE)
 
 static inline bool is_removed_spte(u64 spte)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7b9265d67131..2ca03ec3bf52 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -692,8 +692,16 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * overwrite the special removed SPTE value. No bookkeeping is needed
 	 * here since the SPTE is going from non-present to non-present.  Use
 	 * the raw write helper to avoid an unnecessary check on volatile bits.
+	 *
+	 * Set non-present value to SHADOW_NONPRESENT_VALUE, rather than 0.
+	 * It is because when TDX is enabled, TDX module always
+	 * enables "EPT-violation #VE", so KVM needs to set
+	 * "suppress #VE" bit in EPT table entries, in order to get
+	 * real EPT violation, rather than TDVMCALL.  KVM sets
+	 * SHADOW_NONPRESENT_VALUE (which sets "suppress #VE" bit) so it
+	 * can be set when EPT table entries are zapped.
 	 */
-	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
+	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
 
 	return 0;
 }
@@ -870,8 +878,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared)
-			tdp_mmu_set_spte(kvm, &iter, 0);
-		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
+			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
+		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
 			goto retry;
 	}
 }
@@ -927,8 +935,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
 		return false;
 
-	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true, true);
+	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
+			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
+			   true, true);
 
 	return true;
 }
@@ -965,7 +974,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
+		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
 
@@ -1330,7 +1339,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * invariant that the PFN of a present * leaf SPTE can never change.
 	 * See __handle_changed_spte().
 	 */
-	tdp_mmu_set_spte(kvm, iter, 0);
+	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
 
 	if (!pte_write(range->pte)) {
 		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-- 
2.25.1



-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
