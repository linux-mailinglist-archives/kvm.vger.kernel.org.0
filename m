Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3071C1637AE
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgBRXy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:54:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:60654 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgBRXyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:54:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:54:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="224313172"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 18 Feb 2020 15:54:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/9] KVM: x86: Copy kvm_x86_ops by value to eliminate layer of indirection
Date:   Tue, 18 Feb 2020 15:54:34 -0800
Message-Id: <20200218235437.20533-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218235437.20533-1-sean.j.christopherson@intel.com>
References: <20200218235437.20533-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the kvm_x86_ops pointer in common x86 with an instance of the
struct to save one memory instance when invoking function.  Copy the
struct by value to set the ops during kvm_init().

Arbitrarily use kvm_x86_ops.hardware_enable to track whether or not the
ops have been initialized, i.e. a vendor KVM module has been loaded.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  20 +-
 arch/x86/kvm/cpuid.c            |  24 +--
 arch/x86/kvm/hyperv.c           |   8 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  30 +--
 arch/x86/kvm/mmu.h              |   4 +-
 arch/x86/kvm/mmu/mmu.c          |  38 ++--
 arch/x86/kvm/pmu.c              |  30 +--
 arch/x86/kvm/pmu.h              |   2 +-
 arch/x86/kvm/svm.c              |   2 +-
 arch/x86/kvm/trace.h            |   4 +-
 arch/x86/kvm/vmx/nested.c       |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   4 +-
 arch/x86/kvm/x86.c              | 370 ++++++++++++++++----------------
 arch/x86/kvm/x86.h              |   4 +-
 16 files changed, 277 insertions(+), 277 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55e72b0e592b..b0c2431f8374 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1270,25 +1270,25 @@ struct kvm_arch_async_pf {
 	bool direct_map;
 };
 
-extern struct kvm_x86_ops *kvm_x86_ops;
+extern struct kvm_x86_ops kvm_x86_ops;
 extern struct kmem_cache *x86_fpu_cache;
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return kvm_x86_ops->vm_alloc();
+	return kvm_x86_ops.vm_alloc();
 }
 
 static inline void kvm_arch_free_vm(struct kvm *kvm)
 {
-	return kvm_x86_ops->vm_free(kvm);
+	return kvm_x86_ops.vm_free(kvm);
 }
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
 static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 {
-	if (kvm_x86_ops->tlb_remote_flush &&
-	    !kvm_x86_ops->tlb_remote_flush(kvm))
+	if (kvm_x86_ops.tlb_remote_flush &&
+	    !kvm_x86_ops.tlb_remote_flush(kvm))
 		return 0;
 	else
 		return -ENOTSUPP;
@@ -1373,7 +1373,7 @@ extern u64 kvm_mce_cap_supported;
  *
  * EMULTYPE_SKIP - Set when emulating solely to skip an instruction, i.e. to
  *		   decode the instruction length.  For use *only* by
- *		   kvm_x86_ops->skip_emulated_instruction() implementations.
+ *		   kvm_x86_ops.skip_emulated_instruction() implementations.
  *
  * EMULTYPE_ALLOW_RETRY - Set when the emulator should resume the guest to
  *			  retry native execution under certain conditions.
@@ -1664,14 +1664,14 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops->vcpu_blocking)
-		kvm_x86_ops->vcpu_blocking(vcpu);
+	if (kvm_x86_ops.vcpu_blocking)
+		kvm_x86_ops.vcpu_blocking(vcpu);
 }
 
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops->vcpu_unblocking)
-		kvm_x86_ops->vcpu_unblocking(vcpu);
+	if (kvm_x86_ops.vcpu_unblocking)
+		kvm_x86_ops.vcpu_unblocking(vcpu);
 }
 
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..9acc0d5c2448 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -48,7 +48,7 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 bool kvm_mpx_supported(void)
 {
 	return ((host_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))
-		 && kvm_x86_ops->mpx_supported());
+		 && kvm_x86_ops.mpx_supported());
 }
 EXPORT_SYMBOL_GPL(kvm_mpx_supported);
 
@@ -232,7 +232,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	cpuid_fix_nx_cap(vcpu);
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops->cpuid_update(vcpu);
+	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
 
 out:
@@ -255,7 +255,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops->cpuid_update(vcpu);
+	kvm_x86_ops.cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
 out:
 	return r;
@@ -348,12 +348,12 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
 
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 {
-	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
+	unsigned f_invpcid = kvm_x86_ops.invpcid_supported() ? F(INVPCID) : 0;
 	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
-	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
-	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
+	unsigned f_umip = kvm_x86_ops.umip_emulated() ? F(UMIP) : 0;
+	unsigned f_intel_pt = kvm_x86_ops.pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
-	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
+	unsigned f_pku = kvm_x86_ops.pku_supported() ? F(PKU) : 0;
 
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
@@ -436,16 +436,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	int r;
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
 #ifdef CONFIG_X86_64
-	unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
+	unsigned f_gbpages = (kvm_x86_ops.get_lpage_level() == PT_PDPE_LEVEL)
 				? F(GBPAGES) : 0;
 	unsigned f_lm = F(LM);
 #else
 	unsigned f_gbpages = 0;
 	unsigned f_lm = 0;
 #endif
-	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
-	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
-	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
+	unsigned f_rdtscp = kvm_x86_ops.rdtscp_supported() ? F(RDTSCP) : 0;
+	unsigned f_xsaves = kvm_x86_ops.xsaves_supported() ? F(XSAVES) : 0;
+	unsigned f_intel_pt = kvm_x86_ops.pt_supported() ? F(INTEL_PT) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_cpuid_1_edx_x86_features =
@@ -807,7 +807,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	}
 
-	kvm_x86_ops->set_supported_cpuid(function, entry);
+	kvm_x86_ops.set_supported_cpuid(function, entry);
 
 	r = 0;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a86fda7a1d03..bcefa9d4e57e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1022,7 +1022,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		addr = gfn_to_hva(kvm, gfn);
 		if (kvm_is_error_hva(addr))
 			return 1;
-		kvm_x86_ops->patch_hypercall(vcpu, instructions);
+		kvm_x86_ops.patch_hypercall(vcpu, instructions);
 		((unsigned char *)instructions)[3] = 0xc3; /* ret */
 		if (__copy_to_user((void __user *)addr, instructions, 4))
 			return 1;
@@ -1607,7 +1607,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	 * hypercall generates UD from non zero cpl and real mode
 	 * per HYPER-V spec
 	 */
-	if (kvm_x86_ops->get_cpl(vcpu) != 0 || !is_protmode(vcpu)) {
+	if (kvm_x86_ops.get_cpl(vcpu) != 0 || !is_protmode(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -1800,8 +1800,8 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
 
-	if (kvm_x86_ops->nested_get_evmcs_version)
-		evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
+	if (kvm_x86_ops.nested_get_evmcs_version)
+		evmcs_ver = kvm_x86_ops.nested_get_evmcs_version(vcpu);
 
 	/* Skip NESTED_FEATURES if eVMCS is not supported */
 	if (!evmcs_ver)
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 58767020de41..62558b9bdda7 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -68,7 +68,7 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 		return 0;
 
 	if (!kvm_register_is_available(vcpu, reg))
-		kvm_x86_ops->cache_reg(vcpu, reg);
+		kvm_x86_ops.cache_reg(vcpu, reg);
 
 	return vcpu->arch.regs[reg];
 }
@@ -108,7 +108,7 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 	might_sleep();  /* on svm */
 
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
-		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_PDPTR);
+		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_PDPTR);
 
 	return vcpu->arch.walk_mmu->pdptrs[index];
 }
@@ -117,7 +117,7 @@ static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
 	ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
 	if (tmask & vcpu->arch.cr0_guest_owned_bits)
-		kvm_x86_ops->decache_cr0_guest_bits(vcpu);
+		kvm_x86_ops.decache_cr0_guest_bits(vcpu);
 	return vcpu->arch.cr0 & mask;
 }
 
@@ -130,14 +130,14 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
 	ulong tmask = mask & KVM_POSSIBLE_CR4_GUEST_BITS;
 	if (tmask & vcpu->arch.cr4_guest_owned_bits)
-		kvm_x86_ops->decache_cr4_guest_bits(vcpu);
+		kvm_x86_ops.decache_cr4_guest_bits(vcpu);
 	return vcpu->arch.cr4 & mask;
 }
 
 static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_CR3);
+		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR3);
 	return vcpu->arch.cr3;
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index eafc631d305c..63f02b6677e7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -448,7 +448,7 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 	if (unlikely(vcpu->arch.apicv_active)) {
 		/* need to update RVI */
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
-		kvm_x86_ops->hwapic_irr_update(vcpu,
+		kvm_x86_ops.hwapic_irr_update(vcpu,
 				apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
@@ -473,7 +473,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		kvm_x86_ops->hwapic_isr_update(vcpu, vec);
+		kvm_x86_ops.hwapic_isr_update(vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -521,7 +521,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		kvm_x86_ops->hwapic_isr_update(vcpu,
+		kvm_x86_ops.hwapic_isr_update(vcpu,
 					       apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
@@ -657,7 +657,7 @@ static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 {
 	int highest_irr;
 	if (apic->vcpu->arch.apicv_active)
-		highest_irr = kvm_x86_ops->sync_pir_to_irr(apic->vcpu);
+		highest_irr = kvm_x86_ops.sync_pir_to_irr(apic->vcpu);
 	else
 		highest_irr = apic_find_highest_irr(apic);
 	if (highest_irr == -1 || (highest_irr & 0xF0) <= ppr)
@@ -1047,7 +1047,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		}
 
 		if (vcpu->arch.apicv_active)
-			kvm_x86_ops->deliver_posted_interrupt(vcpu, vector);
+			kvm_x86_ops.deliver_posted_interrupt(vcpu, vector);
 		else {
 			kvm_lapic_set_irr(vector, apic);
 
@@ -1735,7 +1735,7 @@ static void cancel_hv_timer(struct kvm_lapic *apic)
 {
 	WARN_ON(preemptible());
 	WARN_ON(!apic->lapic_timer.hv_timer_in_use);
-	kvm_x86_ops->cancel_hv_timer(apic->vcpu);
+	kvm_x86_ops.cancel_hv_timer(apic->vcpu);
 	apic->lapic_timer.hv_timer_in_use = false;
 }
 
@@ -1746,13 +1746,13 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 	bool expired;
 
 	WARN_ON(preemptible());
-	if (!kvm_x86_ops->set_hv_timer)
+	if (!kvm_x86_ops.set_hv_timer)
 		return false;
 
 	if (!ktimer->tscdeadline)
 		return false;
 
-	if (kvm_x86_ops->set_hv_timer(vcpu, ktimer->tscdeadline, &expired))
+	if (kvm_x86_ops.set_hv_timer(vcpu, ktimer->tscdeadline, &expired))
 		return false;
 
 	ktimer->hv_timer_in_use = true;
@@ -2177,7 +2177,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
-		kvm_x86_ops->set_virtual_apic_mode(vcpu);
+		kvm_x86_ops.set_virtual_apic_mode(vcpu);
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
@@ -2254,9 +2254,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
 	if (vcpu->arch.apicv_active) {
-		kvm_x86_ops->apicv_post_state_restore(vcpu);
-		kvm_x86_ops->hwapic_irr_update(vcpu, -1);
-		kvm_x86_ops->hwapic_isr_update(vcpu, -1);
+		kvm_x86_ops.apicv_post_state_restore(vcpu);
+		kvm_x86_ops.hwapic_irr_update(vcpu, -1);
+		kvm_x86_ops.hwapic_isr_update(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -2504,10 +2504,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
-		kvm_x86_ops->apicv_post_state_restore(vcpu);
-		kvm_x86_ops->hwapic_irr_update(vcpu,
+		kvm_x86_ops.apicv_post_state_restore(vcpu);
+		kvm_x86_ops.hwapic_irr_update(vcpu,
 				apic_find_highest_irr(apic));
-		kvm_x86_ops->hwapic_isr_update(vcpu,
+		kvm_x86_ops.hwapic_isr_update(vcpu,
 				apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d55674f44a18..36ec808b205e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -157,8 +157,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				  unsigned pte_access, unsigned pte_pkey,
 				  unsigned pfec)
 {
-	int cpl = kvm_x86_ops->get_cpl(vcpu);
-	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
+	int cpl = kvm_x86_ops.get_cpl(vcpu);
+	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
 
 	/*
 	 * If CPL < 3, SMAP prevention are disabled if EFLAGS.AC = 1.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7011a4e54866..020a7da8e5b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -313,7 +313,7 @@ kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_available_flush_tlb_with_range(void)
 {
-	return kvm_x86_ops->tlb_remote_flush_with_range;
+	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
 static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
@@ -321,8 +321,8 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 {
 	int ret = -ENOTSUPP;
 
-	if (range && kvm_x86_ops->tlb_remote_flush_with_range)
-		ret = kvm_x86_ops->tlb_remote_flush_with_range(kvm, range);
+	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
+		ret = kvm_x86_ops.tlb_remote_flush_with_range(kvm, range);
 
 	if (ret)
 		kvm_flush_remote_tlbs(kvm);
@@ -1650,7 +1650,7 @@ static bool spte_set_dirty(u64 *sptep)
 	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
 
 	/*
-	 * Similar to the !kvm_x86_ops->slot_disable_log_dirty case,
+	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
 	 * do not bother adding back write access to pages marked
 	 * SPTE_AD_WRPROT_ONLY_MASK.
 	 */
@@ -1739,8 +1739,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
-	if (kvm_x86_ops->enable_log_dirty_pt_masked)
-		kvm_x86_ops->enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
+	if (kvm_x86_ops.enable_log_dirty_pt_masked)
+		kvm_x86_ops.enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
 				mask);
 	else
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
@@ -1755,8 +1755,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
  */
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops->write_log_dirty)
-		return kvm_x86_ops->write_log_dirty(vcpu);
+	if (kvm_x86_ops.write_log_dirty)
+		return kvm_x86_ops.write_log_dirty(vcpu);
 
 	return 0;
 }
@@ -3044,7 +3044,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
-		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
+		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
 	if (host_writable)
@@ -3292,7 +3292,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PT_PAGE_TABLE_LEVEL;
 
-	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
+	max_level = min(max_level, kvm_x86_ops.get_lpage_level());
 	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
 		linfo = lpage_info_slot(gfn, slot, max_level);
 		if (!linfo->disallow_lpage)
@@ -4907,7 +4907,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, base_only);
 
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
-	role.base.level = kvm_x86_ops->get_tdp_level(vcpu);
+	role.base.level = kvm_x86_ops.get_tdp_level(vcpu);
 	role.base.direct = true;
 	role.base.gpte_is_8_bytes = true;
 
@@ -4929,9 +4929,9 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
 	context->update_pte = nonpaging_update_pte;
-	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
+	context->shadow_root_level = kvm_x86_ops.get_tdp_level(vcpu);
 	context->direct_map = true;
-	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
+	context->set_cr3 = kvm_x86_ops.set_tdp_cr3;
 	context->get_cr3 = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
@@ -5079,7 +5079,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *context = vcpu->arch.mmu;
 
 	kvm_init_shadow_mmu(vcpu);
-	context->set_cr3           = kvm_x86_ops->set_cr3;
+	context->set_cr3           = kvm_x86_ops.set_cr3;
 	context->get_cr3           = get_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
@@ -5186,7 +5186,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	kvm_mmu_load_cr3(vcpu);
-	kvm_x86_ops->tlb_flush(vcpu, true);
+	kvm_x86_ops.tlb_flush(vcpu, true);
 out:
 	return r;
 }
@@ -5482,7 +5482,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
 	 */
 	if (unlikely(insn && !insn_len)) {
-		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
+		if (!kvm_x86_ops.need_emulation_on_page_fault(vcpu))
 			return 1;
 	}
 
@@ -5517,7 +5517,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 		if (VALID_PAGE(mmu->prev_roots[i].hpa))
 			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 
-	kvm_x86_ops->tlb_flush_gva(vcpu, gva);
+	kvm_x86_ops.tlb_flush_gva(vcpu, gva);
 	++vcpu->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
@@ -5542,7 +5542,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	}
 
 	if (tlb_flush)
-		kvm_x86_ops->tlb_flush_gva(vcpu, gva);
+		kvm_x86_ops.tlb_flush_gva(vcpu, gva);
 
 	++vcpu->stat.invlpg;
 
@@ -5659,7 +5659,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
 	 * skip allocating the PDP table.
 	 */
-	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
+	if (tdp_enabled && kvm_x86_ops.get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;
 
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bcc6a73d6628..73e6ef471695 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -211,7 +211,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops->pmu_ops->find_arch_event(pmc_to_pmu(pmc),
+		config = kvm_x86_ops.pmu_ops->find_arch_event(pmc_to_pmu(pmc),
 						      event_select,
 						      unit_mask);
 		if (config != PERF_COUNT_HW_MAX)
@@ -265,7 +265,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops->pmu_ops->find_fixed_event(idx),
+			      kvm_x86_ops.pmu_ops->find_fixed_event(idx),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
@@ -274,7 +274,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
+	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
 
 	if (!pmc)
 		return;
@@ -296,7 +296,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	int bit;
 
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, bit);
+		struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
 			clear_bit(bit, pmu->reprogram_pmi);
@@ -318,7 +318,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 /* check if idx is a valid index to access PMU */
 int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_x86_ops->pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
+	return kvm_x86_ops.pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -368,7 +368,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_x86_ops->pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
+	pmc = kvm_x86_ops.pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -384,14 +384,14 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	return kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
-		kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, msr);
+	return kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
+		kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, msr);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr);
+	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -399,13 +399,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
-	return kvm_x86_ops->pmu_ops->get_msr(vcpu, msr, data);
+	return kvm_x86_ops.pmu_ops->get_msr(vcpu, msr, data);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-	return kvm_x86_ops->pmu_ops->set_msr(vcpu, msr_info);
+	return kvm_x86_ops.pmu_ops->set_msr(vcpu, msr_info);
 }
 
 /* refresh PMU settings. This function generally is called when underlying
@@ -414,7 +414,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops->pmu_ops->refresh(vcpu);
+	kvm_x86_ops.pmu_ops->refresh(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -422,7 +422,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_x86_ops->pmu_ops->reset(vcpu);
+	kvm_x86_ops.pmu_ops->reset(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -430,7 +430,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_x86_ops->pmu_ops->init(vcpu);
+	kvm_x86_ops.pmu_ops->init(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -462,7 +462,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
 
 	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
-		pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, i);
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 13332984b6d5..f9aaeec33230 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -88,7 +88,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 
 static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 {
-	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
+	return kvm_x86_ops.pmu_ops->pmc_is_enabled(pmc);
 }
 
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b1faf6c33541..83b12928d709 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7351,7 +7351,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	 * TODO: Last condition latch INIT signals on vCPU when
 	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
 	 * To properly emulate the INIT intercept, SVM should implement
-	 * kvm_x86_ops->check_nested_events() and call nested_svm_vmexit()
+	 * kvm_x86_ops.check_nested_events() and call nested_svm_vmexit()
 	 * there if an INIT signal is pending.
 	 */
 	return !gif_set(svm) ||
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index f194dd058470..9ffd345d25f2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -240,7 +240,7 @@ TRACE_EVENT(kvm_exit,
 		__entry->guest_rip	= kvm_rip_read(vcpu);
 		__entry->isa            = isa;
 		__entry->vcpu_id        = vcpu->vcpu_id;
-		kvm_x86_ops->get_exit_info(vcpu, &__entry->info1,
+		kvm_x86_ops.get_exit_info(vcpu, &__entry->info1,
 					   &__entry->info2);
 	),
 
@@ -744,7 +744,7 @@ TRACE_EVENT(kvm_emulate_insn,
 		),
 
 	TP_fast_assign(
-		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);
+		__entry->csbase = kvm_x86_ops.get_segment_base(vcpu, VCPU_SREG_CS);
 		__entry->len = vcpu->arch.emulate_ctxt.fetch.ptr
 			       - vcpu->arch.emulate_ctxt.fetch.data;
 		__entry->rip = vcpu->arch.emulate_ctxt._eip - __entry->len;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 07db28f5087d..6b3ac24abaaa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4460,7 +4460,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 		return;
 
 	vmx = to_vmx(vcpu);
-	if (kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
 		vmx->nested.msrs.entry_ctls_high |=
 				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 		vmx->nested.msrs.exit_ctls_high |=
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fd21cdb10b79..c6bcc4c61e97 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -329,7 +329,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-	if (kvm_x86_ops->pt_supported())
+	if (kvm_x86_ops.pt_supported())
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 098203b6508f..8c7dea508dcb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2978,7 +2978,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		eptp = construct_eptp(vcpu, cr3);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		if (kvm_x86_ops->tlb_remote_flush) {
+		if (kvm_x86_ops.tlb_remote_flush) {
 			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 			to_vmx(vcpu)->ept_pointer = eptp;
 			to_kvm_vmx(kvm)->ept_pointers_match
@@ -7381,7 +7381,7 @@ static void pi_post_block(struct kvm_vcpu *vcpu)
 
 static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops->set_hv_timer)
+	if (kvm_x86_ops.set_hv_timer)
 		kvm_lapic_switch_to_hv_timer(vcpu);
 
 	pi_post_block(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bffd1f703f8e..81146188757d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -109,7 +109,7 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
 
-struct kvm_x86_ops *kvm_x86_ops __read_mostly;
+struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
 static bool __read_mostly ignore_msrs = 0;
@@ -623,7 +623,7 @@ EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
  */
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 {
-	if (kvm_x86_ops->get_cpl(vcpu) <= required_cpl)
+	if (kvm_x86_ops.get_cpl(vcpu) <= required_cpl)
 		return true;
 	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 	return false;
@@ -764,7 +764,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 			if (!is_pae(vcpu))
 				return 1;
-			kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+			kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 			if (cs_l)
 				return 1;
 		} else
@@ -777,7 +777,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
-	kvm_x86_ops->set_cr0(vcpu, cr0);
+	kvm_x86_ops.set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
@@ -873,7 +873,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
+	if (kvm_x86_ops.get_cpl(vcpu) != 0 ||
 	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -910,7 +910,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 	if (cpuid_ecx(0x7) & feature_bit(LA57))
 		reserved_bits &= ~X86_CR4_LA57;
 
-	if (kvm_x86_ops->umip_emulated())
+	if (kvm_x86_ops.umip_emulated())
 		reserved_bits &= ~X86_CR4_UMIP;
 
 	return reserved_bits;
@@ -954,7 +954,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
-	if (kvm_x86_ops->set_cr4(vcpu, cr4))
+	if (kvm_x86_ops.set_cr4(vcpu, cr4))
 		return 1;
 
 	if (((cr4 ^ old_cr4) & pdptr_bits) ||
@@ -1038,7 +1038,7 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 static void kvm_update_dr6(struct kvm_vcpu *vcpu)
 {
 	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
-		kvm_x86_ops->set_dr6(vcpu, vcpu->arch.dr6);
+		kvm_x86_ops.set_dr6(vcpu, vcpu->arch.dr6);
 }
 
 static void kvm_update_dr7(struct kvm_vcpu *vcpu)
@@ -1049,7 +1049,7 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
 		dr7 = vcpu->arch.guest_debug_dr7;
 	else
 		dr7 = vcpu->arch.dr7;
-	kvm_x86_ops->set_dr7(vcpu, dr7);
+	kvm_x86_ops.set_dr7(vcpu, dr7);
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
 	if (dr7 & DR7_BP_EN_MASK)
 		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
@@ -1119,7 +1119,7 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
 			*val = vcpu->arch.dr6;
 		else
-			*val = kvm_x86_ops->get_dr6(vcpu);
+			*val = kvm_x86_ops.get_dr6(vcpu);
 		break;
 	case 5:
 		/* fall through */
@@ -1354,7 +1354,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
 	default:
-		if (kvm_x86_ops->get_msr_feature(msr))
+		if (kvm_x86_ops.get_msr_feature(msr))
 			return 1;
 	}
 	return 0;
@@ -1422,7 +1422,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	efer &= ~EFER_LMA;
 	efer |= vcpu->arch.efer & EFER_LMA;
 
-	kvm_x86_ops->set_efer(vcpu, efer);
+	kvm_x86_ops.set_efer(vcpu, efer);
 
 	/* Update reserved bits */
 	if ((efer ^ old_efer) & EFER_NX)
@@ -1478,7 +1478,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
-	return kvm_x86_ops->set_msr(vcpu, &msr);
+	return kvm_x86_ops.set_msr(vcpu, &msr);
 }
 
 /*
@@ -1496,7 +1496,7 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
-	ret = kvm_x86_ops->get_msr(vcpu, &msr);
+	ret = kvm_x86_ops.get_msr(vcpu, &msr);
 	if (!ret)
 		*data = msr.data;
 	return ret;
@@ -1877,7 +1877,7 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 
 static void update_ia32_tsc_adjust_msr(struct kvm_vcpu *vcpu, s64 offset)
 {
-	u64 curr_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
+	u64 curr_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
 	vcpu->arch.ia32_tsc_adjust_msr += offset - curr_offset;
 }
 
@@ -1919,7 +1919,7 @@ static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
-	u64 tsc_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
+	u64 tsc_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
 
 	return tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
 }
@@ -1927,7 +1927,7 @@ EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
-	vcpu->arch.tsc_offset = kvm_x86_ops->write_l1_tsc_offset(vcpu, offset);
+	vcpu->arch.tsc_offset = kvm_x86_ops.write_l1_tsc_offset(vcpu, offset);
 }
 
 static inline bool kvm_check_tsc_unstable(void)
@@ -2051,7 +2051,7 @@ EXPORT_SYMBOL_GPL(kvm_write_tsc);
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 					   s64 adjustment)
 {
-	u64 tsc_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
+	u64 tsc_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
 	kvm_vcpu_write_tsc_offset(vcpu, tsc_offset + adjustment);
 }
 
@@ -2649,7 +2649,7 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops->tlb_flush(vcpu, invalidate_gpa);
+	kvm_x86_ops.tlb_flush(vcpu, invalidate_gpa);
 }
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
@@ -2802,7 +2802,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		/*
-		 * We do support PT if kvm_x86_ops->pt_supported(), but we do
+		 * We do support PT if kvm_x86_ops.pt_supported(), but we do
 		 * not support IA32_XSS[bit 8]. Guests will have to use
 		 * RDMSR/WRMSR rather than XSAVES/XRSTORS to save/restore PT
 		 * MSRs.
@@ -3369,10 +3369,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * fringe case that is not enabled except via specific settings
 		 * of the module parameters.
 		 */
-		r = kvm_x86_ops->has_emulated_msr(MSR_IA32_SMBASE);
+		r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
 		break;
 	case KVM_CAP_VAPIC:
-		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
+		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
 		break;
 	case KVM_CAP_NR_VCPUS:
 		r = KVM_SOFT_MAX_VCPUS;
@@ -3399,14 +3399,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_X2APIC_API_VALID_FLAGS;
 		break;
 	case KVM_CAP_NESTED_STATE:
-		r = kvm_x86_ops->get_nested_state ?
-			kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
+		r = kvm_x86_ops.get_nested_state ?
+			kvm_x86_ops.get_nested_state(NULL, NULL, 0) : 0;
 		break;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
-		r = kvm_x86_ops->enable_direct_tlbflush != NULL;
+		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
 		break;
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
-		r = kvm_x86_ops->nested_enable_evmcs != NULL;
+		r = kvm_x86_ops.nested_enable_evmcs != NULL;
 		break;
 	default:
 		break;
@@ -3522,14 +3522,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
-		if (kvm_x86_ops->has_wbinvd_exit())
+		if (kvm_x86_ops.has_wbinvd_exit())
 			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
 		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
 			smp_call_function_single(vcpu->cpu,
 					wbinvd_ipi, NULL, 1);
 	}
 
-	kvm_x86_ops->vcpu_load(vcpu, cpu);
+	kvm_x86_ops.vcpu_load(vcpu, cpu);
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -3596,7 +3596,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	int idx;
 
 	if (vcpu->preempted)
-		vcpu->arch.preempted_in_kernel = !kvm_x86_ops->get_cpl(vcpu);
+		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
 	/*
 	 * Disable page faults because we're in atomic context here.
@@ -3615,7 +3615,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_steal_time_set_preempted(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	pagefault_enable();
-	kvm_x86_ops->vcpu_put(vcpu);
+	kvm_x86_ops.vcpu_put(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*
 	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
@@ -3629,7 +3629,7 @@ static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
 	if (vcpu->arch.apicv_active)
-		kvm_x86_ops->sync_pir_to_irr(vcpu);
+		kvm_x86_ops.sync_pir_to_irr(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
 }
@@ -3737,7 +3737,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	for (bank = 0; bank < bank_num; bank++)
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 
-	kvm_x86_ops->setup_mce(vcpu);
+	kvm_x86_ops.setup_mce(vcpu);
 out:
 	return r;
 }
@@ -3826,11 +3826,11 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
 	events->interrupt.nr = vcpu->arch.interrupt.nr;
 	events->interrupt.soft = 0;
-	events->interrupt.shadow = kvm_x86_ops->get_interrupt_shadow(vcpu);
+	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
-	events->nmi.masked = kvm_x86_ops->get_nmi_mask(vcpu);
+	events->nmi.masked = kvm_x86_ops.get_nmi_mask(vcpu);
 	events->nmi.pad = 0;
 
 	events->sipi_vector = 0; /* never valid when reporting to user space */
@@ -3897,13 +3897,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
 	vcpu->arch.interrupt.soft = events->interrupt.soft;
 	if (events->flags & KVM_VCPUEVENT_VALID_SHADOW)
-		kvm_x86_ops->set_interrupt_shadow(vcpu,
+		kvm_x86_ops.set_interrupt_shadow(vcpu,
 						  events->interrupt.shadow);
 
 	vcpu->arch.nmi_injected = events->nmi.injected;
 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
 		vcpu->arch.nmi_pending = events->nmi.pending;
-	kvm_x86_ops->set_nmi_mask(vcpu, events->nmi.masked);
+	kvm_x86_ops.set_nmi_mask(vcpu, events->nmi.masked);
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
 	    lapic_in_kernel(vcpu))
@@ -4178,9 +4178,9 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		return kvm_hv_activate_synic(vcpu, cap->cap ==
 					     KVM_CAP_HYPERV_SYNIC2);
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
-		if (!kvm_x86_ops->nested_enable_evmcs)
+		if (!kvm_x86_ops.nested_enable_evmcs)
 			return -ENOTTY;
-		r = kvm_x86_ops->nested_enable_evmcs(vcpu, &vmcs_version);
+		r = kvm_x86_ops.nested_enable_evmcs(vcpu, &vmcs_version);
 		if (!r) {
 			user_ptr = (void __user *)(uintptr_t)cap->args[0];
 			if (copy_to_user(user_ptr, &vmcs_version,
@@ -4189,10 +4189,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		}
 		return r;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
-		if (!kvm_x86_ops->enable_direct_tlbflush)
+		if (!kvm_x86_ops.enable_direct_tlbflush)
 			return -ENOTTY;
 
-		return kvm_x86_ops->enable_direct_tlbflush(vcpu);
+		return kvm_x86_ops.enable_direct_tlbflush(vcpu);
 
 	default:
 		return -EINVAL;
@@ -4495,7 +4495,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		u32 user_data_size;
 
 		r = -EINVAL;
-		if (!kvm_x86_ops->get_nested_state)
+		if (!kvm_x86_ops.get_nested_state)
 			break;
 
 		BUILD_BUG_ON(sizeof(user_data_size) != sizeof(user_kvm_nested_state->size));
@@ -4503,7 +4503,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (get_user(user_data_size, &user_kvm_nested_state->size))
 			break;
 
-		r = kvm_x86_ops->get_nested_state(vcpu, user_kvm_nested_state,
+		r = kvm_x86_ops.get_nested_state(vcpu, user_kvm_nested_state,
 						  user_data_size);
 		if (r < 0)
 			break;
@@ -4525,7 +4525,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		int idx;
 
 		r = -EINVAL;
-		if (!kvm_x86_ops->set_nested_state)
+		if (!kvm_x86_ops.set_nested_state)
 			break;
 
 		r = -EFAULT;
@@ -4547,7 +4547,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			break;
 
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		r = kvm_x86_ops->set_nested_state(vcpu, user_kvm_nested_state, &kvm_state);
+		r = kvm_x86_ops.set_nested_state(vcpu, user_kvm_nested_state, &kvm_state);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
@@ -4591,14 +4591,14 @@ static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
 
 	if (addr > (unsigned int)(-3 * PAGE_SIZE))
 		return -EINVAL;
-	ret = kvm_x86_ops->set_tss_addr(kvm, addr);
+	ret = kvm_x86_ops.set_tss_addr(kvm, addr);
 	return ret;
 }
 
 static int kvm_vm_ioctl_set_identity_map_addr(struct kvm *kvm,
 					      u64 ident_addr)
 {
-	return kvm_x86_ops->set_identity_map_addr(kvm, ident_addr);
+	return kvm_x86_ops.set_identity_map_addr(kvm, ident_addr);
 }
 
 static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
@@ -4779,8 +4779,8 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	/*
 	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
 	 */
-	if (kvm_x86_ops->flush_log_dirty)
-		kvm_x86_ops->flush_log_dirty(kvm);
+	if (kvm_x86_ops.flush_log_dirty)
+		kvm_x86_ops.flush_log_dirty(kvm);
 
 	r = kvm_get_dirty_log_protect(kvm, log, &flush);
 
@@ -4806,8 +4806,8 @@ int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *lo
 	/*
 	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
 	 */
-	if (kvm_x86_ops->flush_log_dirty)
-		kvm_x86_ops->flush_log_dirty(kvm);
+	if (kvm_x86_ops.flush_log_dirty)
+		kvm_x86_ops.flush_log_dirty(kvm);
 
 	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
 
@@ -5173,8 +5173,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
-		if (kvm_x86_ops->mem_enc_op)
-			r = kvm_x86_ops->mem_enc_op(kvm, argp);
+		if (kvm_x86_ops.mem_enc_op)
+			r = kvm_x86_ops.mem_enc_op(kvm, argp);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_REG_REGION: {
@@ -5185,8 +5185,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops->mem_enc_reg_region)
-			r = kvm_x86_ops->mem_enc_reg_region(kvm, &region);
+		if (kvm_x86_ops.mem_enc_reg_region)
+			r = kvm_x86_ops.mem_enc_reg_region(kvm, &region);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
@@ -5197,8 +5197,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops->mem_enc_unreg_region)
-			r = kvm_x86_ops->mem_enc_unreg_region(kvm, &region);
+		if (kvm_x86_ops.mem_enc_unreg_region)
+			r = kvm_x86_ops.mem_enc_unreg_region(kvm, &region);
 		break;
 	}
 	case KVM_HYPERV_EVENTFD: {
@@ -5249,28 +5249,28 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_TSC_AUX:
-			if (!kvm_x86_ops->rdtscp_supported())
+			if (!kvm_x86_ops.rdtscp_supported())
 				continue;
 			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
-			if (!kvm_x86_ops->pt_supported())
+			if (!kvm_x86_ops.pt_supported())
 				continue;
 			break;
 		case MSR_IA32_RTIT_CR3_MATCH:
-			if (!kvm_x86_ops->pt_supported() ||
+			if (!kvm_x86_ops.pt_supported() ||
 			    !intel_pt_validate_hw_cap(PT_CAP_cr3_filtering))
 				continue;
 			break;
 		case MSR_IA32_RTIT_OUTPUT_BASE:
 		case MSR_IA32_RTIT_OUTPUT_MASK:
-			if (!kvm_x86_ops->pt_supported() ||
+			if (!kvm_x86_ops.pt_supported() ||
 				(!intel_pt_validate_hw_cap(PT_CAP_topa_output) &&
 				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
 				continue;
 			break;
 		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
-			if (!kvm_x86_ops->pt_supported() ||
+			if (!kvm_x86_ops.pt_supported() ||
 				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
@@ -5293,7 +5293,7 @@ static void kvm_init_msr_list(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
+		if (!kvm_x86_ops.has_emulated_msr(emulated_msrs_all[i]))
 			continue;
 
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
@@ -5356,13 +5356,13 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 static void kvm_set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	kvm_x86_ops->set_segment(vcpu, var, seg);
+	kvm_x86_ops.set_segment(vcpu, var, seg);
 }
 
 void kvm_get_segment(struct kvm_vcpu *vcpu,
 		     struct kvm_segment *var, int seg)
 {
-	kvm_x86_ops->get_segment(vcpu, var, seg);
+	kvm_x86_ops.get_segment(vcpu, var, seg);
 }
 
 gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
@@ -5382,14 +5382,14 @@ gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 			      struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_FETCH_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
@@ -5397,7 +5397,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 			       struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_WRITE_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
@@ -5446,7 +5446,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 				struct x86_exception *exception)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	unsigned offset;
 	int ret;
 
@@ -5471,7 +5471,7 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 			       gva_t addr, void *val, unsigned int bytes,
 			       struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 
 	/*
 	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
@@ -5492,7 +5492,7 @@ static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = 0;
 
-	if (!system && kvm_x86_ops->get_cpl(vcpu) == 3)
+	if (!system && kvm_x86_ops.get_cpl(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
 	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access, exception);
@@ -5545,7 +5545,7 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = PFERR_WRITE_MASK;
 
-	if (!system && kvm_x86_ops->get_cpl(vcpu) == 3)
+	if (!system && kvm_x86_ops.get_cpl(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
@@ -5608,7 +5608,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 				gpa_t *gpa, struct x86_exception *exception,
 				bool write)
 {
-	u32 access = ((kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0)
+	u32 access = ((kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0)
 		| (write ? PFERR_WRITE_MASK : 0);
 
 	/*
@@ -5996,7 +5996,7 @@ static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
 
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
-	return kvm_x86_ops->get_segment_base(vcpu, seg);
+	return kvm_x86_ops.get_segment_base(vcpu, seg);
 }
 
 static void emulator_invlpg(struct x86_emulate_ctxt *ctxt, ulong address)
@@ -6009,7 +6009,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 	if (!need_emulate_wbinvd(vcpu))
 		return X86EMUL_CONTINUE;
 
-	if (kvm_x86_ops->has_wbinvd_exit()) {
+	if (kvm_x86_ops.has_wbinvd_exit()) {
 		int cpu = get_cpu();
 
 		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
@@ -6114,27 +6114,27 @@ static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
 
 static int emulator_get_cpl(struct x86_emulate_ctxt *ctxt)
 {
-	return kvm_x86_ops->get_cpl(emul_to_vcpu(ctxt));
+	return kvm_x86_ops.get_cpl(emul_to_vcpu(ctxt));
 }
 
 static void emulator_get_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops->get_gdt(emul_to_vcpu(ctxt), dt);
+	kvm_x86_ops.get_gdt(emul_to_vcpu(ctxt), dt);
 }
 
 static void emulator_get_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops->get_idt(emul_to_vcpu(ctxt), dt);
+	kvm_x86_ops.get_idt(emul_to_vcpu(ctxt), dt);
 }
 
 static void emulator_set_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops->set_gdt(emul_to_vcpu(ctxt), dt);
+	kvm_x86_ops.set_gdt(emul_to_vcpu(ctxt), dt);
 }
 
 static void emulator_set_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops->set_idt(emul_to_vcpu(ctxt), dt);
+	kvm_x86_ops.set_idt(emul_to_vcpu(ctxt), dt);
 }
 
 static unsigned long emulator_get_cached_segment_base(
@@ -6256,7 +6256,7 @@ static int emulator_intercept(struct x86_emulate_ctxt *ctxt,
 			      struct x86_instruction_info *info,
 			      enum x86_intercept_stage stage)
 {
-	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage);
+	return kvm_x86_ops.check_intercept(emul_to_vcpu(ctxt), info, stage);
 }
 
 static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
@@ -6292,7 +6292,7 @@ static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulon
 
 static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
 {
-	kvm_x86_ops->set_nmi_mask(emul_to_vcpu(ctxt), masked);
+	kvm_x86_ops.set_nmi_mask(emul_to_vcpu(ctxt), masked);
 }
 
 static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
@@ -6308,7 +6308,7 @@ static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_fla
 static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
 				  const char *smstate)
 {
-	return kvm_x86_ops->pre_leave_smm(emul_to_vcpu(ctxt), smstate);
+	return kvm_x86_ops.pre_leave_smm(emul_to_vcpu(ctxt), smstate);
 }
 
 static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
@@ -6370,7 +6370,7 @@ static const struct x86_emulate_ops emulate_ops = {
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 {
-	u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(vcpu);
+	u32 int_shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
 	/*
 	 * an sti; sti; sequence only disable interrupts for the first
 	 * instruction. So, if the last instruction, be it emulated or
@@ -6381,7 +6381,7 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	if (int_shadow & mask)
 		mask = 0;
 	if (unlikely(int_shadow || mask)) {
-		kvm_x86_ops->set_interrupt_shadow(vcpu, mask);
+		kvm_x86_ops.set_interrupt_shadow(vcpu, mask);
 		if (!mask)
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
@@ -6406,7 +6406,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	int cs_db, cs_l;
 
-	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
 	ctxt->eflags = kvm_get_rflags(vcpu);
 	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
@@ -6466,7 +6466,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
-	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
+	if (!is_guest_mode(vcpu) && kvm_x86_ops.get_cpl(vcpu) == 0) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;
@@ -6645,10 +6645,10 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
+	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
 	int r;
 
-	r = kvm_x86_ops->skip_emulated_instruction(vcpu);
+	r = kvm_x86_ops.skip_emulated_instruction(vcpu);
 	if (unlikely(!r))
 		return 0;
 
@@ -6872,7 +6872,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		r = 1;
 
 	if (writeback) {
-		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
+		unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		if (!ctxt->have_exception ||
@@ -7208,7 +7208,7 @@ static int kvm_is_user_mode(void)
 	int user_mode = 3;
 
 	if (__this_cpu_read(current_vcpu))
-		user_mode = kvm_x86_ops->get_cpl(__this_cpu_read(current_vcpu));
+		user_mode = kvm_x86_ops.get_cpl(__this_cpu_read(current_vcpu));
 
 	return user_mode != 0;
 }
@@ -7288,7 +7288,7 @@ int kvm_arch_init(void *opaque)
 	struct kvm_x86_init_ops *ops = opaque;
 	int r;
 
-	if (kvm_x86_ops) {
+	if (kvm_x86_ops.hardware_enable) {
 		printk(KERN_ERR "kvm: already loaded the other module\n");
 		r = -EEXIST;
 		goto out;
@@ -7381,7 +7381,7 @@ void kvm_arch_exit(void)
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
 #endif
-	kvm_x86_ops = NULL;
+	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_module_exit();
 	free_percpu(shared_msrs);
 	kmem_cache_destroy(x86_fpu_cache);
@@ -7519,7 +7519,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (kvm_x86_ops->get_cpl(vcpu) != 0) {
+	if (kvm_x86_ops.get_cpl(vcpu) != 0) {
 		ret = -KVM_EPERM;
 		goto out;
 	}
@@ -7565,7 +7565,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	char instruction[3];
 	unsigned long rip = kvm_rip_read(vcpu);
 
-	kvm_x86_ops->patch_hypercall(vcpu, instruction);
+	kvm_x86_ops.patch_hypercall(vcpu, instruction);
 
 	return emulator_write_emulated(ctxt, rip, instruction, 3,
 		&ctxt->exception);
@@ -7594,7 +7594,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 {
 	int max_irr, tpr;
 
-	if (!kvm_x86_ops->update_cr8_intercept)
+	if (!kvm_x86_ops.update_cr8_intercept)
 		return;
 
 	if (!lapic_in_kernel(vcpu))
@@ -7613,7 +7613,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 
 	tpr = kvm_lapic_get_cr8(vcpu);
 
-	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
+	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
@@ -7623,7 +7623,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected)
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_x86_ops.queue_exception(vcpu);
 	/*
 	 * Do not inject an NMI or interrupt if there is a pending
 	 * exception.  Exceptions and interrupts are recognized at
@@ -7640,9 +7640,9 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 	 */
 	else if (!vcpu->arch.exception.pending) {
 		if (vcpu->arch.nmi_injected)
-			kvm_x86_ops->set_nmi(vcpu);
+			kvm_x86_ops.set_nmi(vcpu);
 		else if (vcpu->arch.interrupt.injected)
-			kvm_x86_ops->set_irq(vcpu);
+			kvm_x86_ops.set_irq(vcpu);
 	}
 
 	/*
@@ -7651,8 +7651,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 	 * from L2 to L1 due to pending L1 events which require exit
 	 * from L2 to L1.
 	 */
-	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-		r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
+		r = kvm_x86_ops.check_nested_events(vcpu, req_int_win);
 		if (r != 0)
 			return r;
 	}
@@ -7689,7 +7689,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 			}
 		}
 
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_x86_ops.queue_exception(vcpu);
 	}
 
 	/* Don't consider new event if we re-injected an event */
@@ -7697,14 +7697,14 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 		return 0;
 
 	if (vcpu->arch.smi_pending && !is_smm(vcpu) &&
-	    kvm_x86_ops->smi_allowed(vcpu)) {
+	    kvm_x86_ops.smi_allowed(vcpu)) {
 		vcpu->arch.smi_pending = false;
 		++vcpu->arch.smi_count;
 		enter_smm(vcpu);
-	} else if (vcpu->arch.nmi_pending && kvm_x86_ops->nmi_allowed(vcpu)) {
+	} else if (vcpu->arch.nmi_pending && kvm_x86_ops.nmi_allowed(vcpu)) {
 		--vcpu->arch.nmi_pending;
 		vcpu->arch.nmi_injected = true;
-		kvm_x86_ops->set_nmi(vcpu);
+		kvm_x86_ops.set_nmi(vcpu);
 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
 		/*
 		 * Because interrupts can be injected asynchronously, we are
@@ -7713,15 +7713,15 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 		 * proposal and current concerns.  Perhaps we should be setting
 		 * KVM_REQ_EVENT only on certain events and not unconditionally?
 		 */
-		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
-			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
+		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
+			r = kvm_x86_ops.check_nested_events(vcpu, req_int_win);
 			if (r != 0)
 				return r;
 		}
-		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
+		if (kvm_x86_ops.interrupt_allowed(vcpu)) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
 					    false);
-			kvm_x86_ops->set_irq(vcpu);
+			kvm_x86_ops.set_irq(vcpu);
 		}
 	}
 
@@ -7737,7 +7737,7 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	 * If an NMI is already in progress, limit further NMIs to just one.
 	 * Otherwise, allow two (and we'll inject the first one immediately).
 	 */
-	if (kvm_x86_ops->get_nmi_mask(vcpu) || vcpu->arch.nmi_injected)
+	if (kvm_x86_ops.get_nmi_mask(vcpu) || vcpu->arch.nmi_injected)
 		limit = 1;
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
@@ -7827,11 +7827,11 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7f7c, seg.limit);
 	put_smstate(u32, buf, 0x7f78, enter_smm_get_segment_flags(&seg));
 
-	kvm_x86_ops->get_gdt(vcpu, &dt);
+	kvm_x86_ops.get_gdt(vcpu, &dt);
 	put_smstate(u32, buf, 0x7f74, dt.address);
 	put_smstate(u32, buf, 0x7f70, dt.size);
 
-	kvm_x86_ops->get_idt(vcpu, &dt);
+	kvm_x86_ops.get_idt(vcpu, &dt);
 	put_smstate(u32, buf, 0x7f58, dt.address);
 	put_smstate(u32, buf, 0x7f54, dt.size);
 
@@ -7881,7 +7881,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7e94, seg.limit);
 	put_smstate(u64, buf, 0x7e98, seg.base);
 
-	kvm_x86_ops->get_idt(vcpu, &dt);
+	kvm_x86_ops.get_idt(vcpu, &dt);
 	put_smstate(u32, buf, 0x7e84, dt.size);
 	put_smstate(u64, buf, 0x7e88, dt.address);
 
@@ -7891,7 +7891,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7e74, seg.limit);
 	put_smstate(u64, buf, 0x7e78, seg.base);
 
-	kvm_x86_ops->get_gdt(vcpu, &dt);
+	kvm_x86_ops.get_gdt(vcpu, &dt);
 	put_smstate(u32, buf, 0x7e64, dt.size);
 	put_smstate(u64, buf, 0x7e68, dt.address);
 
@@ -7921,28 +7921,28 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	 * vCPU state (e.g. leave guest mode) after we've saved the state into
 	 * the SMM state-save area.
 	 */
-	kvm_x86_ops->pre_enter_smm(vcpu, buf);
+	kvm_x86_ops.pre_enter_smm(vcpu, buf);
 
 	vcpu->arch.hflags |= HF_SMM_MASK;
 	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, buf, sizeof(buf));
 
-	if (kvm_x86_ops->get_nmi_mask(vcpu))
+	if (kvm_x86_ops.get_nmi_mask(vcpu))
 		vcpu->arch.hflags |= HF_SMM_INSIDE_NMI_MASK;
 	else
-		kvm_x86_ops->set_nmi_mask(vcpu, true);
+		kvm_x86_ops.set_nmi_mask(vcpu, true);
 
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0x8000);
 
 	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
-	kvm_x86_ops->set_cr0(vcpu, cr0);
+	kvm_x86_ops.set_cr0(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
 
-	kvm_x86_ops->set_cr4(vcpu, 0);
+	kvm_x86_ops.set_cr4(vcpu, 0);
 
 	/* Undocumented: IDT limit is set to zero on entry to SMM.  */
 	dt.address = dt.size = 0;
-	kvm_x86_ops->set_idt(vcpu, &dt);
+	kvm_x86_ops.set_idt(vcpu, &dt);
 
 	__kvm_set_dr(vcpu, 7, DR7_FIXED_1);
 
@@ -7973,7 +7973,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		kvm_x86_ops->set_efer(vcpu, 0);
+		kvm_x86_ops.set_efer(vcpu, 0);
 #endif
 
 	kvm_update_cpuid(vcpu);
@@ -8011,7 +8011,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
 	kvm_apic_update_apicv(vcpu);
-	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
+	kvm_x86_ops.refresh_apicv_exec_ctrl(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
@@ -8024,8 +8024,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
-	if (!kvm_x86_ops->check_apicv_inhibit_reasons ||
-	    !kvm_x86_ops->check_apicv_inhibit_reasons(bit))
+	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
+	    !kvm_x86_ops.check_apicv_inhibit_reasons(bit))
 		return;
 
 	if (activate) {
@@ -8039,8 +8039,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	}
 
 	trace_kvm_apicv_update_request(activate, bit);
-	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
-		kvm_x86_ops->pre_update_apicv_exec_ctrl(kvm, activate);
+	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
+		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
@@ -8056,7 +8056,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
 	else {
 		if (vcpu->arch.apicv_active)
-			kvm_x86_ops->sync_pir_to_irr(vcpu);
+			kvm_x86_ops.sync_pir_to_irr(vcpu);
 		if (ioapic_in_kernel(vcpu->kvm))
 			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
 	}
@@ -8076,7 +8076,7 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 
 	bitmap_or((ulong *)eoi_exit_bitmap, vcpu->arch.ioapic_handled_vectors,
 		  vcpu_to_synic(vcpu)->vec_bitmap, 256);
-	kvm_x86_ops->load_eoi_exitmap(vcpu, eoi_exit_bitmap);
+	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
 int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
@@ -8103,13 +8103,13 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	if (!lapic_in_kernel(vcpu))
 		return;
 
-	if (!kvm_x86_ops->set_apic_access_page_addr)
+	if (!kvm_x86_ops.set_apic_access_page_addr)
 		return;
 
 	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page))
 		return;
-	kvm_x86_ops->set_apic_access_page_addr(vcpu, page_to_phys(page));
+	kvm_x86_ops.set_apic_access_page_addr(vcpu, page_to_phys(page));
 
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier
@@ -8141,7 +8141,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
-			if (unlikely(!kvm_x86_ops->get_vmcs12_pages(vcpu))) {
+			if (unlikely(!kvm_x86_ops.get_vmcs12_pages(vcpu))) {
 				r = 0;
 				goto out;
 			}
@@ -8265,12 +8265,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			 *    SMI.
 			 */
 			if (vcpu->arch.smi_pending && !is_smm(vcpu))
-				if (!kvm_x86_ops->enable_smi_window(vcpu))
+				if (!kvm_x86_ops.enable_smi_window(vcpu))
 					req_immediate_exit = true;
 			if (vcpu->arch.nmi_pending)
-				kvm_x86_ops->enable_nmi_window(vcpu);
+				kvm_x86_ops.enable_nmi_window(vcpu);
 			if (kvm_cpu_has_injectable_intr(vcpu) || req_int_win)
-				kvm_x86_ops->enable_irq_window(vcpu);
+				kvm_x86_ops.enable_irq_window(vcpu);
 			WARN_ON(vcpu->arch.exception.pending);
 		}
 
@@ -8287,7 +8287,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
-	kvm_x86_ops->prepare_guest_switch(vcpu);
+	kvm_x86_ops.prepare_guest_switch(vcpu);
 
 	/*
 	 * Disable IRQs before setting IN_GUEST_MODE.  Posted interrupt
@@ -8318,7 +8318,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * notified with kvm_vcpu_kick.
 	 */
 	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
-		kvm_x86_ops->sync_pir_to_irr(vcpu);
+		kvm_x86_ops.sync_pir_to_irr(vcpu);
 
 	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
 	    || need_resched() || signal_pending(current)) {
@@ -8333,7 +8333,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		kvm_x86_ops->request_immediate_exit(vcpu);
+		kvm_x86_ops.request_immediate_exit(vcpu);
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
@@ -8353,7 +8353,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	kvm_x86_ops->run(vcpu);
+	kvm_x86_ops.run(vcpu);
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
@@ -8363,7 +8363,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
-		kvm_x86_ops->sync_dirty_debug_regs(vcpu);
+		kvm_x86_ops.sync_dirty_debug_regs(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr6(vcpu);
 		kvm_update_dr7(vcpu);
@@ -8385,7 +8385,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops->handle_exit_irqoff(vcpu, &exit_fastpath);
+	kvm_x86_ops.handle_exit_irqoff(vcpu, &exit_fastpath);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of
@@ -8429,11 +8429,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_lapic_sync_from_vapic(vcpu);
 
 	vcpu->arch.gpa_available = false;
-	r = kvm_x86_ops->handle_exit(vcpu, exit_fastpath);
+	r = kvm_x86_ops.handle_exit(vcpu, exit_fastpath);
 	return r;
 
 cancel_injection:
-	kvm_x86_ops->cancel_injection(vcpu);
+	kvm_x86_ops.cancel_injection(vcpu);
 	if (unlikely(vcpu->arch.apic_attention))
 		kvm_lapic_sync_from_vapic(vcpu);
 out:
@@ -8443,13 +8443,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
-	    (!kvm_x86_ops->pre_block || kvm_x86_ops->pre_block(vcpu) == 0)) {
+	    (!kvm_x86_ops.pre_block || kvm_x86_ops.pre_block(vcpu) == 0)) {
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
-		if (kvm_x86_ops->post_block)
-			kvm_x86_ops->post_block(vcpu);
+		if (kvm_x86_ops.post_block)
+			kvm_x86_ops.post_block(vcpu);
 
 		if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
 			return 1;
@@ -8476,8 +8476,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events)
-		kvm_x86_ops->check_nested_events(vcpu, false);
+	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events)
+		kvm_x86_ops.check_nested_events(vcpu, false);
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
@@ -8633,7 +8633,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.user_fpu);
 
-	/* PKRU is separately restored in kvm_x86_ops->run.  */
+	/* PKRU is separately restored in kvm_x86_ops.run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
 
@@ -8836,10 +8836,10 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	kvm_get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	kvm_get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-	kvm_x86_ops->get_idt(vcpu, &dt);
+	kvm_x86_ops.get_idt(vcpu, &dt);
 	sregs->idt.limit = dt.size;
 	sregs->idt.base = dt.address;
-	kvm_x86_ops->get_gdt(vcpu, &dt);
+	kvm_x86_ops.get_gdt(vcpu, &dt);
 	sregs->gdt.limit = dt.size;
 	sregs->gdt.base = dt.address;
 
@@ -8987,10 +8987,10 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
-	kvm_x86_ops->set_idt(vcpu, &dt);
+	kvm_x86_ops.set_idt(vcpu, &dt);
 	dt.size = sregs->gdt.limit;
 	dt.address = sregs->gdt.base;
-	kvm_x86_ops->set_gdt(vcpu, &dt);
+	kvm_x86_ops.set_gdt(vcpu, &dt);
 
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
@@ -9000,16 +9000,16 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	kvm_set_cr8(vcpu, sregs->cr8);
 
 	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
-	kvm_x86_ops->set_efer(vcpu, sregs->efer);
+	kvm_x86_ops.set_efer(vcpu, sregs->efer);
 
 	mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
-	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
+	kvm_x86_ops.set_cr0(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
 	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	cpuid_update_needed |= ((kvm_read_cr4(vcpu) ^ sregs->cr4) &
 				(X86_CR4_OSXSAVE | X86_CR4_PKE));
-	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
+	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
 	if (cpuid_update_needed)
 		kvm_update_cpuid(vcpu);
 
@@ -9115,7 +9115,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	 */
 	kvm_set_rflags(vcpu, rflags);
 
-	kvm_x86_ops->update_bp_intercept(vcpu);
+	kvm_x86_ops.update_bp_intercept(vcpu);
 
 	r = 0;
 
@@ -9324,7 +9324,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_hv_vcpu_init(vcpu);
 
-	r = kvm_x86_ops->vcpu_create(vcpu);
+	r = kvm_x86_ops.vcpu_create(vcpu);
 	if (r)
 		goto free_guest_fpu;
 
@@ -9391,7 +9391,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
-	kvm_x86_ops->vcpu_free(vcpu);
+	kvm_x86_ops.vcpu_free(vcpu);
 
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
@@ -9478,7 +9478,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.ia32_xss = 0;
 
-	kvm_x86_ops->vcpu_reset(vcpu, init_event);
+	kvm_x86_ops.vcpu_reset(vcpu, init_event);
 }
 
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
@@ -9503,7 +9503,7 @@ int kvm_arch_hardware_enable(void)
 	bool stable, backwards_tsc = false;
 
 	kvm_shared_msr_cpu_online();
-	ret = kvm_x86_ops->hardware_enable();
+	ret = kvm_x86_ops.hardware_enable();
 	if (ret != 0)
 		return ret;
 
@@ -9585,7 +9585,7 @@ int kvm_arch_hardware_enable(void)
 
 void kvm_arch_hardware_disable(void)
 {
-	kvm_x86_ops->hardware_disable();
+	kvm_x86_ops.hardware_disable();
 	drop_user_return_notifiers();
 }
 
@@ -9598,7 +9598,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (r != 0)
 		return r;
 
-	kvm_x86_ops = ops->runtime_ops;
+	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 
 	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
 
@@ -9625,7 +9625,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	kvm_x86_ops->hardware_unsetup();
+	kvm_x86_ops.hardware_unsetup();
 }
 
 int kvm_arch_check_processor_compat(void *opaque)
@@ -9664,7 +9664,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		pmu->need_cleanup = true;
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
-	kvm_x86_ops->sched_in(vcpu, cpu);
+	kvm_x86_ops.sched_in(vcpu, cpu);
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
@@ -9701,7 +9701,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
 
-	return kvm_x86_ops->vm_init(kvm);
+	return kvm_x86_ops.vm_init(kvm);
 }
 
 int kvm_arch_post_init_vm(struct kvm *kvm)
@@ -9819,8 +9819,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
-	if (kvm_x86_ops->vm_destroy)
-		kvm_x86_ops->vm_destroy(kvm);
+	if (kvm_x86_ops.vm_destroy)
+		kvm_x86_ops.vm_destroy(kvm);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
@@ -9955,7 +9955,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	/*
 	 * Call kvm_x86_ops dirty logging hooks when they are valid.
 	 *
-	 * kvm_x86_ops->slot_disable_log_dirty is called when:
+	 * kvm_x86_ops.slot_disable_log_dirty is called when:
 	 *
 	 *  - KVM_MR_CREATE with dirty logging is disabled
 	 *  - KVM_MR_FLAGS_ONLY with dirty logging is disabled in new flag
@@ -9967,7 +9967,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * any additional overhead from PML when guest is running with dirty
 	 * logging disabled for memory slots.
 	 *
-	 * kvm_x86_ops->slot_enable_log_dirty is called when switching new slot
+	 * kvm_x86_ops.slot_enable_log_dirty is called when switching new slot
 	 * to dirty logging mode.
 	 *
 	 * If kvm_x86_ops dirty logging hooks are invalid, use write protect.
@@ -9983,13 +9983,13 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * See the comments in fast_page_fault().
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
-		if (kvm_x86_ops->slot_enable_log_dirty)
-			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
+		if (kvm_x86_ops.slot_enable_log_dirty)
+			kvm_x86_ops.slot_enable_log_dirty(kvm, new);
 		else
 			kvm_mmu_slot_remove_write_access(kvm, new);
 	} else {
-		if (kvm_x86_ops->slot_disable_log_dirty)
-			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
+		if (kvm_x86_ops.slot_disable_log_dirty)
+			kvm_x86_ops.slot_disable_log_dirty(kvm, new);
 	}
 }
 
@@ -10053,8 +10053,8 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	return (is_guest_mode(vcpu) &&
-			kvm_x86_ops->guest_apic_has_interrupt &&
-			kvm_x86_ops->guest_apic_has_interrupt(vcpu));
+			kvm_x86_ops.guest_apic_has_interrupt &&
+			kvm_x86_ops.guest_apic_has_interrupt(vcpu));
 }
 
 static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
@@ -10073,7 +10073,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
 	    (vcpu->arch.nmi_pending &&
-	     kvm_x86_ops->nmi_allowed(vcpu)))
+	     kvm_x86_ops.nmi_allowed(vcpu)))
 		return true;
 
 	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
@@ -10106,7 +10106,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
 		 kvm_test_request(KVM_REQ_EVENT, vcpu))
 		return true;
 
-	if (vcpu->arch.apicv_active && kvm_x86_ops->dy_apicv_has_pending_interrupt(vcpu))
+	if (vcpu->arch.apicv_active && kvm_x86_ops.dy_apicv_has_pending_interrupt(vcpu))
 		return true;
 
 	return false;
@@ -10124,7 +10124,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-	return kvm_x86_ops->interrupt_allowed(vcpu);
+	return kvm_x86_ops.interrupt_allowed(vcpu);
 }
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
@@ -10146,7 +10146,7 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 {
 	unsigned long rflags;
 
-	rflags = kvm_x86_ops->get_rflags(vcpu);
+	rflags = kvm_x86_ops.get_rflags(vcpu);
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		rflags &= ~X86_EFLAGS_TF;
 	return rflags;
@@ -10158,7 +10158,7 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
 	    kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip))
 		rflags |= X86_EFLAGS_TF;
-	kvm_x86_ops->set_rflags(vcpu, rflags);
+	kvm_x86_ops.set_rflags(vcpu, rflags);
 }
 
 void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
@@ -10269,7 +10269,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 
 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
 	    (vcpu->arch.apf.send_user_only &&
-	     kvm_x86_ops->get_cpl(vcpu) == 0))
+	     kvm_x86_ops.get_cpl(vcpu) == 0))
 		return false;
 
 	return true;
@@ -10289,7 +10289,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 	 * If interrupts are off we cannot even use an artificial
 	 * halt state.
 	 */
-	return kvm_x86_ops->interrupt_allowed(vcpu);
+	return kvm_x86_ops.interrupt_allowed(vcpu);
 }
 
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
@@ -10418,7 +10418,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 
 	irqfd->producer = prod;
 
-	return kvm_x86_ops->update_pi_irte(irqfd->kvm,
+	return kvm_x86_ops.update_pi_irte(irqfd->kvm,
 					   prod->irq, irqfd->gsi, 1);
 }
 
@@ -10438,7 +10438,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
-	ret = kvm_x86_ops->update_pi_irte(irqfd->kvm, prod->irq, irqfd->gsi, 0);
+	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
@@ -10447,7 +10447,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 				   uint32_t guest_irq, bool set)
 {
-	return kvm_x86_ops->update_pi_irte(kvm, host_irq, guest_irq, set);
+	return kvm_x86_ops.update_pi_irte(kvm, host_irq, guest_irq, set);
 }
 
 bool kvm_vector_hashing_enabled(void)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3624665acee4..e5d4418ad89a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -96,7 +96,7 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
 
 	if (!is_long_mode(vcpu))
 		return false;
-	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 	return cs_l;
 }
 
@@ -247,7 +247,7 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 
 static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 {
-	return is_smm(vcpu) || kvm_x86_ops->apic_init_signal_blocked(vcpu);
+	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
 }
 
 void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
-- 
2.24.1

