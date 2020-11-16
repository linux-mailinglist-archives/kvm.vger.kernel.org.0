Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE692B4FA2
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388238AbgKPS2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:20636 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388222AbgKPS2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:10 -0500
IronPort-SDR: +iIuRkOUHIQnyMiFgwOrDhG0BQPoG9kbJuCHFMAToHqNQCORSodkMbrkUWZC6Ubkko693LPvho
 0fQdTh4YtisQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410051"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410051"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:09 -0800
IronPort-SDR: at79M/MEaeJfBfe6CFEYDNwXWRC88rqn6Ywhj97LFbSV3XoFiiOguFtrtAhqjIKUDujowN/eg7
 XH8K1Y5GfbBg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528118"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:09 -0800
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
Subject: [RFC PATCH 36/67] KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
Date:   Mon, 16 Nov 2020 10:26:21 -0800
Message-Id: <1e5ce007ad1046ee34408708c0e369b7fcab917b.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              |  4 +++-
 arch/x86/kvm/mmu/mmu.c          | 24 +++---------------------
 arch/x86/kvm/mmu/spte.c         | 26 ++++++++++++++++++++++----
 arch/x86/kvm/mmu/spte.h         |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 18 +++++++-----------
 7 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6dfc09092bc9..d4fd9859fcd5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -915,6 +915,8 @@ struct kvm_arch {
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
 
+	u64 shadow_mmio_value;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7ce8f0256d6d..05c2898cb2a2 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,7 +52,9 @@ static inline u64 rsvd_bits(int s, int e)
 	return ((1ULL << (e - s + 1)) - 1) << s;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask);
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value,
+				u64 access_mask);
+void kvm_mmu_set_default_mmio_spte_mask(u64 mask);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c4d657b26066..da2a58fa86a8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5507,6 +5507,9 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+
+	kvm_mmu_set_mmio_spte_mask(kvm, shadow_default_mmio_mask,
+				   ACC_WRITE_MASK | ACC_USER_MASK);
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -5835,25 +5838,6 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
-static void kvm_set_mmio_spte_mask(void)
-{
-	u64 mask;
-
-	/*
-	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
-	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
-	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
-	 * 52-bit physical addresses then there are no reserved PA bits in the
-	 * PTEs and so the reserved PA approach must be disabled.
-	 */
-	if (shadow_phys_bits < 52)
-		mask = BIT_ULL(51) | PT_PRESENT_MASK;
-	else
-		mask = 0;
-
-	kvm_mmu_set_mmio_spte_mask(mask, ACC_WRITE_MASK | ACC_USER_MASK);
-}
-
 static bool get_nx_auto_mode(void)
 {
 	/* Return true when CPU has the bug, and mitigations are ON */
@@ -5919,8 +5903,6 @@ int kvm_mmu_module_init(void)
 
 	kvm_mmu_reset_all_pte_masks();
 
-	kvm_set_mmio_spte_mask();
-
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
 					    0, SLAB_ACCOUNT, NULL);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fcac2cac78fe..574c8ccac0bf 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -22,7 +22,7 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 u64 __read_mostly shadow_user_mask;
 u64 __read_mostly shadow_accessed_mask;
 u64 __read_mostly shadow_dirty_mask;
-u64 __read_mostly shadow_mmio_value;
+u64 __read_mostly shadow_default_mmio_mask;
 u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_mask;
@@ -52,7 +52,7 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 gpa = gfn << PAGE_SHIFT;
 
 	access &= shadow_mmio_access_mask;
-	mask |= shadow_mmio_value | access;
+	mask |= vcpu->kvm->arch.shadow_mmio_value | SPTE_MMIO_MASK | access;
 	mask |= gpa | shadow_nonpresent_or_rsvd_mask;
 	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
@@ -242,12 +242,13 @@ u64 mark_spte_for_access_track(u64 spte)
 	return spte;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value,
+				u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << SHADOW_NONPRESENT_OR_RSVD_MASK_LEN));
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
-	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
+	kvm->arch.shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
 	shadow_mmio_access_mask = access_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
@@ -289,6 +290,7 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_x_mask = 0;
 	shadow_present_mask = 0;
 	shadow_acc_track_mask = 0;
+	shadow_default_mmio_mask = 0;
 
 	shadow_phys_bits = kvm_get_shadow_phys_bits();
 
@@ -315,4 +317,20 @@ void kvm_mmu_reset_all_pte_masks(void)
 
 	shadow_nonpresent_or_rsvd_lower_gfn_mask =
 		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
+
+	/*
+	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
+	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
+	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
+	 * 52-bit physical addresses then there are no reserved PA bits in the
+	 * PTEs and so the reserved PA approach must be disabled.
+	 */
+	if (shadow_phys_bits < 52)
+		shadow_default_mmio_mask = BIT_ULL(51) | PT_PRESENT_MASK;
+}
+
+void kvm_mmu_set_default_mmio_spte_mask(u64 mask)
+{
+	shadow_default_mmio_mask = mask;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_set_default_mmio_spte_mask);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 5c75a451c000..e5c94848ade1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -86,7 +86,7 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
 extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
-extern u64 __read_mostly shadow_mmio_value;
+extern u64 __read_mostly shadow_default_mmio_mask;
 extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_mask;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8be23240c74f..0aa29a30f922 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -871,7 +871,7 @@ static __init void svm_adjust_mmio_mask(void)
 	 */
 	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
 
-	kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
+	kvm_mmu_set_default_mmio_spte_mask(mask);
 }
 
 static void svm_hardware_teardown(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index deeec105e963..997a391f0842 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4276,15 +4276,6 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	vmx->secondary_exec_control = exec_control;
 }
 
-static void ept_set_mmio_spte_mask(void)
-{
-	/*
-	 * EPT Misconfigurations can be generated if the value of bits 2:0
-	 * of an EPT paging-structure entry is 110b (write/execute).
-	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE, 0);
-}
-
 #define VMX_XSS_EXIT_BITMAP 0
 
 /*
@@ -5473,8 +5464,6 @@ static void vmx_enable_tdp(void)
 		0ull, VMX_EPT_EXECUTABLE_MASK,
 		cpu_has_vmx_ept_execute_only() ? 0ull : VMX_EPT_READABLE_MASK,
 		VMX_EPT_RWX_MASK, 0ull);
-
-	ept_set_mmio_spte_mask();
 }
 
 /*
@@ -6983,6 +6972,13 @@ static int vmx_vm_init(struct kvm *kvm)
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
 
+	/*
+	 * EPT Misconfigurations can be generated if the value of bits 2:0
+	 * of an EPT paging-structure entry is 110b (write/execute).
+	 */
+	if (enable_ept)
+		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE, 0);
+
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
 		case L1TF_MITIGATION_OFF:
-- 
2.17.1

