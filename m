Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB94CDE0F
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiCDUKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiCDUHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:49 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8672D14F3;
        Fri,  4 Mar 2022 12:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424132; x=1677960132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5XV4sEZhs5zaefdhwp0/a2DcOExXryV64uN38LbyoBo=;
  b=BhNO1M+NKDHFajl/dY1VReGqr/hijUz6sQzbeH7Rcevv6X/3ZverXKCD
   0ib73bgfjPehposWsBRWly5oP71zgKp6aD7roxol1fYyhfoFfuZlA2WkZ
   QkGWjV8wr1nJ2/IlJmQIK48FYqB2/0DUbJzBQ3A1Iwa8TLF6kYDgOtXga
   a+pZW95Tim5eJc1aJg1YzUcTKbsKP4cFVCvTJiEQXKbOppH6LhrRDZYpM
   5RNhEO2M6iEXEQLaxM+J05BGqqHIMBF8CnODOvFN4RQH24GhXOhNinMsw
   3QDnWnOxCXYfJopJQHsLc7kSAMx9/tscrEb5cj1xfG0f9EFQn9UbSmDGI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983462"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983462"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:20 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344311"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:19 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 037/104] KVM: x86/mmu: Allow non-zero init value for shadow PTE
Date:   Fri,  4 Mar 2022 11:48:53 -0800
Message-Id: <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX will run with EPT violation #VEs enabled for shared EPT, which means
KVM needs to set the "suppress #VE" bit in unused PTEs to avoid
unintentionally reflecting not-present EPT violations into the guest.

Because guest memory is protected with TDX, VMM can't parse instructions
in the guest memory.  Instead, MMIO hypercall is used to pass necessary
information to VMM.

To make unmodified device driver work, guest TD expects #VE on accessing
shared GPA.  The #VE handler converts MMIO access into MMIO hypercall with
the EPT entry of enabled "#VE" by clearing "suppress #VE" bit.  Before VMM
enabling #VE, it needs to figure out the given GPA is for MMIO by EPT
violation.  So the execution flow looks like

- allocate unused shared EPT entry with suppress #VE bit set.
- EPT violation on that GPA.
- VMM figures out the faulted GPA is for MMIO.
- VMM clears the suppress #VE bit.
- Guest TD gets #VE, and converts MMIO access into MMIO hypercall.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h      |  1 +
 arch/x86/kvm/mmu/mmu.c  | 50 +++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/spte.c | 10 +++++++++
 arch/x86/kvm/mmu/spte.h |  2 ++
 4 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3fb530359f81..0ae91b8b25df 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -66,6 +66,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
+void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9907cb759fd1..a474f2e76d78 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -617,9 +617,9 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	int level = sptep_to_sp(sptep)->role.level;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, shadow_init_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return old_spte;
@@ -651,7 +651,7 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, shadow_init_value);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -737,6 +737,42 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline void kvm_init_shadow_page(void *page)
+{
+#ifdef CONFIG_X86_64
+	int ign;
+
+	asm volatile (
+		"rep stosq\n\t"
+		: "=c"(ign), "=D"(page)
+		: "a"(shadow_init_value), "c"(4096/8), "D"(page)
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
+
+	if (shadow_init_value)
+		start = kvm_mmu_memory_cache_nr_free_objects(mc);
+
+	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
+	if (r)
+		return r;
+
+	if (shadow_init_value) {
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
@@ -746,8 +782,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				       PT64_ROOT_MAX_LEVEL);
+	r = mmu_topup_shadow_page_cache(vcpu);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -3146,7 +3181,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
-	u64 spte = 0ull;
+	u64 spte = shadow_init_value;
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
@@ -5598,7 +5633,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	if (!shadow_init_value)
+		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 73cfe62fdad1..5071e8332db2 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -35,6 +35,7 @@ u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
+u64 __read_mostly shadow_init_value;
 
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
@@ -223,6 +224,14 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
 	return new_spte;
 }
 
+void kvm_mmu_set_spte_init_value(u64 init_value)
+{
+	if (WARN_ON(!IS_ENABLED(CONFIG_X86_64) && init_value))
+		init_value = 0;
+	shadow_init_value = init_value;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_spte_init_value);
+
 static u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
@@ -367,6 +376,7 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_present_mask	= PT_PRESENT_MASK;
 	shadow_acc_track_mask	= 0;
 	shadow_me_mask		= sme_me_mask;
+	shadow_init_value	= 0;
 
 	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITEABLE;
 	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITEABLE;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index be6a007a4af3..8e13a35ab8c9 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -171,6 +171,8 @@ extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_mask;
 
+extern u64 __read_mostly shadow_init_value;
+
 /*
  * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_MASK;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
-- 
2.25.1

