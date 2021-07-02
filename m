Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829113BA57F
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhGBWIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:50197 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233226AbhGBWIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472756"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472756"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:27 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814817"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:27 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 43/69] KVM: x86/mmu: Allow non-zero init value for shadow PTE
Date:   Fri,  2 Jul 2021 15:04:49 -0700
Message-Id: <2a12f8867229459dba2da233bf7762cb1ac2722c.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX will run with EPT violation #VEs enabled, which means KVM needs to
set the "suppress #VE" bit in unused PTEs to avoid unintentionally
reflecting not-present EPT violations into the guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h      |  1 +
 arch/x86/kvm/mmu/mmu.c  | 50 +++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/spte.c | 10 +++++++++
 arch/x86/kvm/mmu/spte.h |  2 ++
 4 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 69b82857acdb..6ec8d9fdff35 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -61,6 +61,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
+void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 631b92e6e9ba..1c40dfd05979 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -550,9 +550,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, shadow_init_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return 0;
@@ -582,7 +582,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, shadow_init_value);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -660,6 +660,42 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
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
@@ -669,8 +705,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				       PT64_ROOT_MAX_LEVEL);
+	r = mmu_topup_shadow_page_cache(vcpu);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -3041,7 +3076,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
-	u64 spte = 0ull;
+	u64 spte = shadow_init_value;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(error_code))
@@ -5383,7 +5418,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	if (!shadow_init_value)
+		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 66d43cec0c31..0b931f1c2210 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -34,6 +34,7 @@ u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
+u64 __read_mostly shadow_init_value;
 
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
@@ -211,6 +212,14 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
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
@@ -355,6 +364,7 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_present_mask	= PT_PRESENT_MASK;
 	shadow_acc_track_mask	= 0;
 	shadow_me_mask		= sme_me_mask;
+	shadow_init_value	= 0;
 
 	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITEABLE;
 	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITEABLE;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index bca0ba11cccf..f88cf3db31c7 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -152,6 +152,8 @@ extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_mask;
 
+extern u64 __read_mostly shadow_init_value;
+
 /*
  * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_MASK;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
-- 
2.25.1

