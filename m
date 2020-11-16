Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D232B4F49
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbgKPS2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:20636 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388231AbgKPS2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:11 -0500
IronPort-SDR: ql51VDgYSUtYUgb3wneOzqUFlYshvj3wtpb1HZSK0spOU/GCQ1nN62af6892Bl9sr+rbfjjbxI
 F745jW3aMz8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410053"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410053"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:10 -0800
IronPort-SDR: b4d4hd9uvgO57+SWANxqk2M2ikqPLMBIbH0OJjdYSlYo2TR/xLrfxktGCIoWrNUV8XR+w+eufB
 Zc9gtgltOxvg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528141"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:10 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 38/67] KVM: x86/mmu: Allow non-zero init value for shadow PTE
Date:   Mon, 16 Nov 2020 10:26:23 -0800
Message-Id: <d8447d317d5fee37b0cff586ecc3a8bc3da94984.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX will run with EPT violation #VEs enabled, which means KVM needs to
set the "suppress #VE" bit in unused PTEs to avoid unintentionally
reflecting not-present EPT violations into the guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.h      |  1 +
 arch/x86/kvm/mmu/mmu.c  | 50 +++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/spte.c | 10 +++++++++
 arch/x86/kvm/mmu/spte.h |  2 ++
 4 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 05c2898cb2a2..e9598a51090b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -55,6 +55,7 @@ static inline u64 rsvd_bits(int s, int e)
 void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value,
 				u64 access_mask);
 void kvm_mmu_set_default_mmio_spte_mask(u64 mask);
+void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index da2a58fa86a8..732510ecda36 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -560,9 +560,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, shadow_init_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return 0;
@@ -592,7 +592,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, shadow_init_value);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -670,6 +670,42 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
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
@@ -679,8 +715,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				       PT64_ROOT_MAX_LEVEL);
+	r = mmu_topup_shadow_page_cache(vcpu);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -3074,7 +3109,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
-	u64 spte = 0ull;
+	u64 spte = shadow_init_value;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(error_code))
@@ -5356,7 +5391,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	if (!shadow_init_value)
+		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 574c8ccac0bf..079bbef7b8aa 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -27,6 +27,7 @@ u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
+u64 __read_mostly shadow_init_value;
 
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
@@ -195,6 +196,14 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
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
@@ -291,6 +300,7 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_present_mask = 0;
 	shadow_acc_track_mask = 0;
 	shadow_default_mmio_mask = 0;
+	shadow_init_value = 0;
 
 	shadow_phys_bits = kvm_get_shadow_phys_bits();
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 22256cc8cce6..a5eab5607606 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -91,6 +91,8 @@ extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_mask;
 
+extern u64 __read_mostly shadow_init_value;
+
 /*
  * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
-- 
2.17.1

