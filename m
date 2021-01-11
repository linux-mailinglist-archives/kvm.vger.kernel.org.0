Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277272F1C4C
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbhAKR1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731215AbhAKR1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:27:46 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60048C061786;
        Mon, 11 Jan 2021 09:27:06 -0800 (PST)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BH01G9020280;
        Mon, 11 Jan 2021 17:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=CjgG+afAbId5LmKvfEWq2dguWOXwcJFsmQpcb5QKBz0=;
 b=hrMKEdsOA0GhpycU0D889T8pVp63fbgCIiau9NuIFHOcxeq2dCY54AyTWlWQrC/1L55Z
 ITuClaz6aJ6QnafjObPzrkO33bXrwerqIDnldzrmHxzKU+MqcdXMwDQBkOKNdNzJcTz+
 0QKlS/RttZBi71OTKDx+2rmMekPeQYPt4VEiJg3qj+wXVrggWUMlwqqEN6CcVEk2Knb2
 8XZfgo1nUfu5dur/QyKrPVKeZcwJSaE3s2nG7Ysq8MtN5Lqq2OvqJuDs0zN2QyBZ9wwM
 ujLhQHOwQsbMblRR1h9piAcfO8RL5Cs16EYzfAzpB0qD8tft5oONyCCEfc3c9FtukqOo NA== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 35y5frfsxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:00:11 +0000
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BGo1Jb018254;
        Mon, 11 Jan 2021 12:00:10 -0500
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint7.akamai.com with ESMTP id 35y8q39xsu-1;
        Mon, 11 Jan 2021 12:00:10 -0500
Received: from bos-lpjec.145bw.corp.akamai.com (unknown [172.28.3.71])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 5DF014D0;
        Mon, 11 Jan 2021 17:00:09 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: use static calls to reduce kvm_x86_ops overhead
Date:   Mon, 11 Jan 2021 11:57:28 -0500
Message-Id: <3ed5255546e5649523df103a0ff06e0f4c7552ba.1610379877.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610379877.git.jbaron@akamai.com>
References: <cover.1610379877.git.jbaron@akamai.com>
In-Reply-To: <cover.1610379877.git.jbaron@akamai.com>
References: <cover.1610379877.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110098
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110099
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.33)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint7
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert kvm_x86_ops to use static calls. Note that all kvm_x86_ops are
covered here except for 'pmu_ops and 'nested ops'.

Here are some numbers running cpuid in a loop and measured timing
in the vm (lower is better).

cpuid loop (1 million calls(avg. of 5 runs)):

           |default    |mitigations=off
---------------------------------------
vanilla    |.671s      |.486s
static call|.573s(-15%)|.458s(-6%)

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 arch/x86/include/asm/kvm_host.h |   6 +-
 arch/x86/kvm/cpuid.c            |   2 +-
 arch/x86/kvm/hyperv.c           |   4 +-
 arch/x86/kvm/irq.c              |   2 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  28 ++--
 arch/x86/kvm/mmu.h              |   6 +-
 arch/x86/kvm/mmu/mmu.c          |  12 +-
 arch/x86/kvm/mmu/spte.c         |   2 +-
 arch/x86/kvm/pmu.c              |   2 +-
 arch/x86/kvm/trace.h            |   4 +-
 arch/x86/kvm/x86.c              | 294 ++++++++++++++++++++--------------------
 arch/x86/kvm/x86.h              |   6 +-
 13 files changed, 189 insertions(+), 189 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e947522..2d47cff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1402,7 +1402,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
 static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 {
 	if (kvm_x86_ops.tlb_remote_flush &&
-	    !kvm_x86_ops.tlb_remote_flush(kvm))
+	    !static_call(kvm_x86_tlb_remote_flush)(kvm))
 		return 0;
 	else
 		return -ENOTSUPP;
@@ -1793,13 +1793,13 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops.vcpu_blocking)
-		kvm_x86_ops.vcpu_blocking(vcpu);
+		static_call(kvm_x86_vcpu_blocking)(vcpu);
 }
 
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops.vcpu_unblocking)
-		kvm_x86_ops.vcpu_unblocking(vcpu);
+		static_call(kvm_x86_vcpu_unblocking)(vcpu);
 }
 
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 13036cf..f951d18 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -182,7 +182,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	/* Invoke the vendor callback only after the above state is updated. */
-	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
+	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
 }
 
 static int is_efer_nx(void)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 922c69d..5c45d80 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1154,7 +1154,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		addr = gfn_to_hva(kvm, gfn);
 		if (kvm_is_error_hva(addr))
 			return 1;
-		kvm_x86_ops.patch_hypercall(vcpu, instructions);
+		static_call(kvm_x86_patch_hypercall)(vcpu, instructions);
 		((unsigned char *)instructions)[3] = 0xc3; /* ret */
 		if (__copy_to_user((void __user *)addr, instructions, 4))
 			return 1;
@@ -1745,7 +1745,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	 * hypercall generates UD from non zero cpl and real mode
 	 * per HYPER-V spec
 	 */
-	if (kvm_x86_ops.get_cpl(vcpu) != 0 || !is_protmode(vcpu)) {
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 || !is_protmode(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 814698e..67c634a 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -144,7 +144,7 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
 	if (kvm_x86_ops.migrate_timers)
-		kvm_x86_ops.migrate_timers(vcpu);
+		static_call(kvm_x86_migrate_timers)(vcpu);
 }
 
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index f15bc16..61d2965 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -69,7 +69,7 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 		return 0;
 
 	if (!kvm_register_is_available(vcpu, reg))
-		kvm_x86_ops.cache_reg(vcpu, reg);
+		static_call(kvm_x86_cache_reg)(vcpu, reg);
 
 	return vcpu->arch.regs[reg];
 }
@@ -109,7 +109,7 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 	might_sleep();  /* on svm */
 
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
-		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_PDPTR);
+		static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_PDPTR);
 
 	return vcpu->arch.walk_mmu->pdptrs[index];
 }
@@ -119,7 +119,7 @@ static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 	ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
 	if ((tmask & vcpu->arch.cr0_guest_owned_bits) &&
 	    !kvm_register_is_available(vcpu, VCPU_EXREG_CR0))
-		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR0);
+		static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR0);
 	return vcpu->arch.cr0 & mask;
 }
 
@@ -133,14 +133,14 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 	ulong tmask = mask & KVM_POSSIBLE_CR4_GUEST_BITS;
 	if ((tmask & vcpu->arch.cr4_guest_owned_bits) &&
 	    !kvm_register_is_available(vcpu, VCPU_EXREG_CR4))
-		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR4);
+		static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR4);
 	return vcpu->arch.cr4 & mask;
 }
 
 static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR3);
+		static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR3);
 	return vcpu->arch.cr3;
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3136e05..4c56389 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -484,7 +484,7 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 	if (unlikely(vcpu->arch.apicv_active)) {
 		/* need to update RVI */
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
-		kvm_x86_ops.hwapic_irr_update(vcpu,
+		static_call(kvm_x86_hwapic_irr_update)(vcpu,
 				apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
@@ -515,7 +515,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		kvm_x86_ops.hwapic_isr_update(vcpu, vec);
+		static_call(kvm_x86_hwapic_isr_update)(vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -563,7 +563,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		kvm_x86_ops.hwapic_isr_update(vcpu,
+		static_call(kvm_x86_hwapic_isr_update)(vcpu,
 					       apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
@@ -701,7 +701,7 @@ static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 {
 	int highest_irr;
 	if (apic->vcpu->arch.apicv_active)
-		highest_irr = kvm_x86_ops.sync_pir_to_irr(apic->vcpu);
+		highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
 	else
 		highest_irr = apic_find_highest_irr(apic);
 	if (highest_irr == -1 || (highest_irr & 0xF0) <= ppr)
@@ -1090,7 +1090,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 						       apic->regs + APIC_TMR);
 		}
 
-		if (kvm_x86_ops.deliver_posted_interrupt(vcpu, vector)) {
+		if (static_call(kvm_x86_deliver_posted_interrupt)(vcpu, vector)) {
 			kvm_lapic_set_irr(vector, apic);
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
@@ -1814,7 +1814,7 @@ static void cancel_hv_timer(struct kvm_lapic *apic)
 {
 	WARN_ON(preemptible());
 	WARN_ON(!apic->lapic_timer.hv_timer_in_use);
-	kvm_x86_ops.cancel_hv_timer(apic->vcpu);
+	static_call(kvm_x86_cancel_hv_timer)(apic->vcpu);
 	apic->lapic_timer.hv_timer_in_use = false;
 }
 
@@ -1831,7 +1831,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 	if (!ktimer->tscdeadline)
 		return false;
 
-	if (kvm_x86_ops.set_hv_timer(vcpu, ktimer->tscdeadline, &expired))
+	if (static_call(kvm_x86_set_hv_timer)(vcpu, ktimer->tscdeadline, &expired))
 		return false;
 
 	ktimer->hv_timer_in_use = true;
@@ -2261,7 +2261,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
-		kvm_x86_ops.set_virtual_apic_mode(vcpu);
+		static_call(kvm_x86_set_virtual_apic_mode)(vcpu);
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
@@ -2338,9 +2338,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
 	if (vcpu->arch.apicv_active) {
-		kvm_x86_ops.apicv_post_state_restore(vcpu);
-		kvm_x86_ops.hwapic_irr_update(vcpu, -1);
-		kvm_x86_ops.hwapic_isr_update(vcpu, -1);
+		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call(kvm_x86_hwapic_irr_update)(vcpu, -1);
+		static_call(kvm_x86_hwapic_isr_update)(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -2601,10 +2601,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
-		kvm_x86_ops.apicv_post_state_restore(vcpu);
-		kvm_x86_ops.hwapic_irr_update(vcpu,
+		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call(kvm_x86_hwapic_irr_update)(vcpu,
 				apic_find_highest_irr(apic));
-		kvm_x86_ops.hwapic_isr_update(vcpu,
+		static_call(kvm_x86_hwapic_isr_update)(vcpu,
 				apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9c4a9c8..6ec46b5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -95,7 +95,7 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(root_hpa))
 		return;
 
-	kvm_x86_ops.load_mmu_pgd(vcpu, root_hpa | kvm_get_active_pcid(vcpu),
+	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa | kvm_get_active_pcid(vcpu),
 				 vcpu->arch.mmu->shadow_root_level);
 }
 
@@ -167,8 +167,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				  unsigned pte_access, unsigned pte_pkey,
 				  unsigned pfec)
 {
-	int cpl = kvm_x86_ops.get_cpl(vcpu);
-	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
+	int cpl = static_call(kvm_x86_get_cpl)(vcpu);
+	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 
 	/*
 	 * If CPL < 3, SMAP prevention are disabled if EFLAGS.AC = 1.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c478904..96bb1b1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -190,7 +190,7 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 	int ret = -ENOTSUPP;
 
 	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
-		ret = kvm_x86_ops.tlb_remote_flush_with_range(kvm, range);
+		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
 
 	if (ret)
 		kvm_flush_remote_tlbs(kvm);
@@ -1283,7 +1283,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				gfn_t gfn_offset, unsigned long mask)
 {
 	if (kvm_x86_ops.enable_log_dirty_pt_masked)
-		kvm_x86_ops.enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
+		static_call(kvm_x86_enable_log_dirty_pt_masked)(kvm, slot, gfn_offset,
 				mask);
 	else
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
@@ -1292,7 +1292,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 int kvm_cpu_dirty_log_size(void)
 {
 	if (kvm_x86_ops.cpu_dirty_log_size)
-		return kvm_x86_ops.cpu_dirty_log_size();
+		return static_call(kvm_x86_cpu_dirty_log_size)();
 
 	return 0;
 }
@@ -4804,7 +4804,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	kvm_mmu_load_pgd(vcpu);
-	kvm_x86_ops.tlb_flush_current(vcpu);
+	static_call(kvm_x86_tlb_flush_current)(vcpu);
 out:
 	return r;
 }
@@ -5118,7 +5118,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		if (is_noncanonical_address(gva, vcpu))
 			return;
 
-		kvm_x86_ops.tlb_flush_gva(vcpu, gva);
+		static_call(kvm_x86_tlb_flush_gva)(vcpu, gva);
 	}
 
 	if (!mmu->invlpg)
@@ -5175,7 +5175,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	}
 
 	if (tlb_flush)
-		kvm_x86_ops.tlb_flush_gva(vcpu, gva);
+		static_call(kvm_x86_tlb_flush_gva)(vcpu, gva);
 
 	++vcpu->stat.invlpg;
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c51ad54..ef55f0b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -120,7 +120,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
-		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
+		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
 	if (host_writable)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 67741d2..326c740 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -373,7 +373,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 		return 1;
 
 	if (!(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
-	    (kvm_x86_ops.get_cpl(vcpu) != 0) &&
+	    (static_call(kvm_x86_get_cpl)(vcpu) != 0) &&
 	    (kvm_read_cr0(vcpu) & X86_CR0_PE))
 		return 1;
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 2de30c2..5ef2386 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -256,7 +256,7 @@ TRACE_EVENT(name,							     \
 		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
 		__entry->isa            = isa;				     \
 		__entry->vcpu_id        = vcpu->vcpu_id;		     \
-		kvm_x86_ops.get_exit_info(vcpu, &__entry->info1,	     \
+		static_call(kvm_x86_get_exit_info)(vcpu, &__entry->info1,    \
 					  &__entry->info2,		     \
 					  &__entry->intr_info,		     \
 					  &__entry->error_code);	     \
@@ -738,7 +738,7 @@ TRACE_EVENT(kvm_emulate_insn,
 		),
 
 	TP_fast_assign(
-		__entry->csbase = kvm_x86_ops.get_segment_base(vcpu, VCPU_SREG_CS);
+		__entry->csbase = static_call(kvm_x86_get_segment_base)(vcpu, VCPU_SREG_CS);
 		__entry->len = vcpu->arch.emulate_ctxt->fetch.ptr
 			       - vcpu->arch.emulate_ctxt->fetch.data;
 		__entry->rip = vcpu->arch.emulate_ctxt->_eip - __entry->len;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ae32ab..1759fcf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -696,7 +696,7 @@ EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
  */
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 {
-	if (kvm_x86_ops.get_cpl(vcpu) <= required_cpl)
+	if (static_call(kvm_x86_get_cpl)(vcpu) <= required_cpl)
 		return true;
 	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 	return false;
@@ -856,7 +856,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 		if (!is_pae(vcpu))
 			return 1;
-		kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+		static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
 		if (cs_l)
 			return 1;
 	}
@@ -869,7 +869,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
-	kvm_x86_ops.set_cr0(vcpu, cr0);
+	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
 
@@ -974,7 +974,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (kvm_x86_ops.get_cpl(vcpu) != 0 ||
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
 	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -991,7 +991,7 @@ bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
 		return false;
 
-	return kvm_x86_ops.is_valid_cr4(vcpu, cr4);
+	return static_call(kvm_x86_is_valid_cr4)(vcpu, cr4);
 }
 EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
@@ -1035,7 +1035,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
-	kvm_x86_ops.set_cr4(vcpu, cr4);
+	static_call(kvm_x86_set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
 
@@ -1118,7 +1118,7 @@ void kvm_update_dr7(struct kvm_vcpu *vcpu)
 		dr7 = vcpu->arch.guest_debug_dr7;
 	else
 		dr7 = vcpu->arch.dr7;
-	kvm_x86_ops.set_dr7(vcpu, dr7);
+	static_call(kvm_x86_set_dr7)(vcpu, dr7);
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
 	if (dr7 & DR7_BP_EN_MASK)
 		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
@@ -1422,7 +1422,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
 	default:
-		return kvm_x86_ops.get_msr_feature(msr);
+		return static_call(kvm_x86_get_msr_feature)(msr);
 	}
 	return 0;
 }
@@ -1498,7 +1498,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	efer &= ~EFER_LMA;
 	efer |= vcpu->arch.efer & EFER_LMA;
 
-	r = kvm_x86_ops.set_efer(vcpu, efer);
+	r = static_call(kvm_x86_set_efer)(vcpu, efer);
 	if (r) {
 		WARN_ON(r > 0);
 		return r;
@@ -1595,7 +1595,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
-	return kvm_x86_ops.set_msr(vcpu, &msr);
+	return static_call(kvm_x86_set_msr)(vcpu, &msr);
 }
 
 static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
@@ -1628,7 +1628,7 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
-	ret = kvm_x86_ops.get_msr(vcpu, &msr);
+	ret = static_call(kvm_x86_get_msr)(vcpu, &msr);
 	if (!ret)
 		*data = msr.data;
 	return ret;
@@ -1669,12 +1669,12 @@ static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
 		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
 	}
 
-	return kvm_x86_ops.complete_emulated_msr(vcpu, err);
+	return static_call(kvm_x86_complete_emulated_msr)(vcpu, err);
 }
 
 static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
 {
-	return kvm_x86_ops.complete_emulated_msr(vcpu, vcpu->run->msr.error);
+	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
 }
 
 static u64 kvm_msr_reason(int r)
@@ -1746,7 +1746,7 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 		trace_kvm_msr_read_ex(ecx);
 	}
 
-	return kvm_x86_ops.complete_emulated_msr(vcpu, r);
+	return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
@@ -1772,7 +1772,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	else
 		trace_kvm_msr_write_ex(ecx, data);
 
-	return kvm_x86_ops.complete_emulated_msr(vcpu, r);
+	return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
@@ -2204,7 +2204,7 @@ EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vcpu->arch.l1_tsc_offset = offset;
-	vcpu->arch.tsc_offset = kvm_x86_ops.write_l1_tsc_offset(vcpu, offset);
+	vcpu->arch.tsc_offset = static_call(kvm_x86_write_l1_tsc_offset)(vcpu, offset);
 }
 
 static inline bool kvm_check_tsc_unstable(void)
@@ -2950,13 +2950,13 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops.tlb_flush_all(vcpu);
+	static_call(kvm_x86_tlb_flush_all)(vcpu);
 }
 
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops.tlb_flush_guest(vcpu);
+	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
@@ -3795,10 +3795,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * fringe case that is not enabled except via specific settings
 		 * of the module parameters.
 		 */
-		r = kvm_x86_ops.has_emulated_msr(kvm, MSR_IA32_SMBASE);
+		r = static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32_SMBASE);
 		break;
 	case KVM_CAP_VAPIC:
-		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
+		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
 		break;
 	case KVM_CAP_NR_VCPUS:
 		r = KVM_SOFT_MAX_VCPUS;
@@ -3957,14 +3957,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
-		if (kvm_x86_ops.has_wbinvd_exit())
+		if (static_call(kvm_x86_has_wbinvd_exit)())
 			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
 		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
 			smp_call_function_single(vcpu->cpu,
 					wbinvd_ipi, NULL, 1);
 	}
 
-	kvm_x86_ops.vcpu_load(vcpu, cpu);
+	static_call(kvm_x86_vcpu_load)(vcpu, cpu);
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
@@ -4034,7 +4034,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	int idx;
 
 	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
-		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
+		vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
 
 	/*
 	 * Disable page faults because we're in atomic context here.
@@ -4053,7 +4053,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_steal_time_set_preempted(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	pagefault_enable();
-	kvm_x86_ops.vcpu_put(vcpu);
+	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*
 	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
@@ -4067,7 +4067,7 @@ static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
 	if (vcpu->arch.apicv_active)
-		kvm_x86_ops.sync_pir_to_irr(vcpu);
+		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
 }
@@ -4177,7 +4177,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	for (bank = 0; bank < bank_num; bank++)
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 
-	kvm_x86_ops.setup_mce(vcpu);
+	static_call(kvm_x86_setup_mce)(vcpu);
 out:
 	return r;
 }
@@ -4281,11 +4281,11 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
 	events->interrupt.nr = vcpu->arch.interrupt.nr;
 	events->interrupt.soft = 0;
-	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
+	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
-	events->nmi.masked = kvm_x86_ops.get_nmi_mask(vcpu);
+	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
 	events->nmi.pad = 0;
 
 	events->sipi_vector = 0; /* never valid when reporting to user space */
@@ -4352,13 +4352,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
 	vcpu->arch.interrupt.soft = events->interrupt.soft;
 	if (events->flags & KVM_VCPUEVENT_VALID_SHADOW)
-		kvm_x86_ops.set_interrupt_shadow(vcpu,
+		static_call(kvm_x86_set_interrupt_shadow)(vcpu,
 						  events->interrupt.shadow);
 
 	vcpu->arch.nmi_injected = events->nmi.injected;
 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
 		vcpu->arch.nmi_pending = events->nmi.pending;
-	kvm_x86_ops.set_nmi_mask(vcpu, events->nmi.masked);
+	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
 	    lapic_in_kernel(vcpu))
@@ -4653,7 +4653,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		if (!kvm_x86_ops.enable_direct_tlbflush)
 			return -ENOTTY;
 
-		return kvm_x86_ops.enable_direct_tlbflush(vcpu);
+		return static_call(kvm_x86_enable_direct_tlbflush)(vcpu);
 
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		vcpu->arch.pv_cpuid.enforce = cap->args[0];
@@ -5045,14 +5045,14 @@ static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
 
 	if (addr > (unsigned int)(-3 * PAGE_SIZE))
 		return -EINVAL;
-	ret = kvm_x86_ops.set_tss_addr(kvm, addr);
+	ret = static_call(kvm_x86_set_tss_addr)(kvm, addr);
 	return ret;
 }
 
 static int kvm_vm_ioctl_set_identity_map_addr(struct kvm *kvm,
 					      u64 ident_addr)
 {
-	return kvm_x86_ops.set_identity_map_addr(kvm, ident_addr);
+	return static_call(kvm_x86_set_identity_map_addr)(kvm, ident_addr);
 }
 
 static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
@@ -5210,7 +5210,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
 	 */
 	if (kvm_x86_ops.flush_log_dirty)
-		kvm_x86_ops.flush_log_dirty(kvm);
+		static_call(kvm_x86_flush_log_dirty)(kvm);
 }
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
@@ -5678,7 +5678,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_op)
-			r = kvm_x86_ops.mem_enc_op(kvm, argp);
+			r = static_call(kvm_x86_mem_enc_op)(kvm, argp);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_REG_REGION: {
@@ -5690,7 +5690,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_reg_region)
-			r = kvm_x86_ops.mem_enc_reg_region(kvm, &region);
+			r = static_call(kvm_x86_mem_enc_reg_region)(kvm, &region);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
@@ -5702,7 +5702,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_unreg_region)
-			r = kvm_x86_ops.mem_enc_unreg_region(kvm, &region);
+			r = static_call(kvm_x86_mem_enc_unreg_region)(kvm, &region);
 		break;
 	}
 	case KVM_HYPERV_EVENTFD: {
@@ -5804,7 +5804,7 @@ static void kvm_init_msr_list(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!kvm_x86_ops.has_emulated_msr(NULL, emulated_msrs_all[i]))
+		if (!static_call(kvm_x86_has_emulated_msr)(NULL, emulated_msrs_all[i]))
 			continue;
 
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
@@ -5867,13 +5867,13 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 static void kvm_set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	kvm_x86_ops.set_segment(vcpu, var, seg);
+	static_call(kvm_x86_set_segment)(vcpu, var, seg);
 }
 
 void kvm_get_segment(struct kvm_vcpu *vcpu,
 		     struct kvm_segment *var, int seg)
 {
-	kvm_x86_ops.get_segment(vcpu, var, seg);
+	static_call(kvm_x86_get_segment)(vcpu, var, seg);
 }
 
 gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
@@ -5893,14 +5893,14 @@ gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 			      struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_FETCH_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
@@ -5908,7 +5908,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 			       struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_WRITE_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
@@ -5957,7 +5957,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 				struct x86_exception *exception)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	unsigned offset;
 	int ret;
 
@@ -5982,7 +5982,7 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 			       gva_t addr, void *val, unsigned int bytes,
 			       struct x86_exception *exception)
 {
-	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 
 	/*
 	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
@@ -6003,7 +6003,7 @@ static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = 0;
 
-	if (!system && kvm_x86_ops.get_cpl(vcpu) == 3)
+	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
 	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access, exception);
@@ -6056,7 +6056,7 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = PFERR_WRITE_MASK;
 
-	if (!system && kvm_x86_ops.get_cpl(vcpu) == 3)
+	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
@@ -6081,7 +6081,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 	char sig[5]; /* ud2; .ascii "kvm" */
 	struct x86_exception e;
 
-	if (unlikely(!kvm_x86_ops.can_emulate_instruction(vcpu, NULL, 0)))
+	if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, NULL, 0)))
 		return 1;
 
 	if (force_emulation_prefix &&
@@ -6115,7 +6115,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 				gpa_t *gpa, struct x86_exception *exception,
 				bool write)
 {
-	u32 access = ((kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0)
+	u32 access = ((static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0)
 		| (write ? PFERR_WRITE_MASK : 0);
 
 	/*
@@ -6523,7 +6523,7 @@ static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
 
 static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
-	return kvm_x86_ops.get_segment_base(vcpu, seg);
+	return static_call(kvm_x86_get_segment_base)(vcpu, seg);
 }
 
 static void emulator_invlpg(struct x86_emulate_ctxt *ctxt, ulong address)
@@ -6536,7 +6536,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 	if (!need_emulate_wbinvd(vcpu))
 		return X86EMUL_CONTINUE;
 
-	if (kvm_x86_ops.has_wbinvd_exit()) {
+	if (static_call(kvm_x86_has_wbinvd_exit)()) {
 		int cpu = get_cpu();
 
 		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
@@ -6641,27 +6641,27 @@ static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
 
 static int emulator_get_cpl(struct x86_emulate_ctxt *ctxt)
 {
-	return kvm_x86_ops.get_cpl(emul_to_vcpu(ctxt));
+	return static_call(kvm_x86_get_cpl)(emul_to_vcpu(ctxt));
 }
 
 static void emulator_get_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops.get_gdt(emul_to_vcpu(ctxt), dt);
+	static_call(kvm_x86_get_gdt)(emul_to_vcpu(ctxt), dt);
 }
 
 static void emulator_get_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops.get_idt(emul_to_vcpu(ctxt), dt);
+	static_call(kvm_x86_get_idt)(emul_to_vcpu(ctxt), dt);
 }
 
 static void emulator_set_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops.set_gdt(emul_to_vcpu(ctxt), dt);
+	static_call(kvm_x86_set_gdt)(emul_to_vcpu(ctxt), dt);
 }
 
 static void emulator_set_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
 {
-	kvm_x86_ops.set_idt(emul_to_vcpu(ctxt), dt);
+	static_call(kvm_x86_set_idt)(emul_to_vcpu(ctxt), dt);
 }
 
 static unsigned long emulator_get_cached_segment_base(
@@ -6803,7 +6803,7 @@ static int emulator_intercept(struct x86_emulate_ctxt *ctxt,
 			      struct x86_instruction_info *info,
 			      enum x86_intercept_stage stage)
 {
-	return kvm_x86_ops.check_intercept(emul_to_vcpu(ctxt), info, stage,
+	return static_call(kvm_x86_check_intercept)(emul_to_vcpu(ctxt), info, stage,
 					    &ctxt->exception);
 }
 
@@ -6841,7 +6841,7 @@ static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulon
 
 static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
 {
-	kvm_x86_ops.set_nmi_mask(emul_to_vcpu(ctxt), masked);
+	static_call(kvm_x86_set_nmi_mask)(emul_to_vcpu(ctxt), masked);
 }
 
 static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
@@ -6857,7 +6857,7 @@ static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_fla
 static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
 				  const char *smstate)
 {
-	return kvm_x86_ops.pre_leave_smm(emul_to_vcpu(ctxt), smstate);
+	return static_call(kvm_x86_pre_leave_smm)(emul_to_vcpu(ctxt), smstate);
 }
 
 static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
@@ -6919,7 +6919,7 @@ static const struct x86_emulate_ops emulate_ops = {
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 {
-	u32 int_shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
+	u32 int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 	/*
 	 * an sti; sti; sequence only disable interrupts for the first
 	 * instruction. So, if the last instruction, be it emulated or
@@ -6930,7 +6930,7 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	if (int_shadow & mask)
 		mask = 0;
 	if (unlikely(int_shadow || mask)) {
-		kvm_x86_ops.set_interrupt_shadow(vcpu, mask);
+		static_call(kvm_x86_set_interrupt_shadow)(vcpu, mask);
 		if (!mask)
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
@@ -6972,7 +6972,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int cs_db, cs_l;
 
-	kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
 
 	ctxt->gpa_available = false;
 	ctxt->eflags = kvm_get_rflags(vcpu);
@@ -7033,7 +7033,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
-	if (!is_guest_mode(vcpu) && kvm_x86_ops.get_cpl(vcpu) == 0) {
+	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;
@@ -7214,10 +7214,10 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
+	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 	int r;
 
-	r = kvm_x86_ops.skip_emulated_instruction(vcpu);
+	r = static_call(kvm_x86_skip_emulated_instruction)(vcpu);
 	if (unlikely(!r))
 		return 0;
 
@@ -7311,7 +7311,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	bool writeback = true;
 	bool write_fault_to_spt;
 
-	if (unlikely(!kvm_x86_ops.can_emulate_instruction(vcpu, insn, insn_len)))
+	if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, insn, insn_len)))
 		return 1;
 
 	vcpu->arch.l1tf_flush_l1d = true;
@@ -7454,7 +7454,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		r = 1;
 
 	if (writeback) {
-		unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
+		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		if (!ctxt->have_exception ||
@@ -7463,7 +7463,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
 			if (kvm_x86_ops.update_emulated_instruction)
-				kvm_x86_ops.update_emulated_instruction(vcpu);
+				static_call(kvm_x86_update_emulated_instruction)(vcpu);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 
@@ -7792,7 +7792,7 @@ static int kvm_is_user_mode(void)
 	int user_mode = 3;
 
 	if (__this_cpu_read(current_vcpu))
-		user_mode = kvm_x86_ops.get_cpl(__this_cpu_read(current_vcpu));
+		user_mode = static_call(kvm_x86_get_cpl)(__this_cpu_read(current_vcpu));
 
 	return user_mode != 0;
 }
@@ -8113,7 +8113,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (kvm_x86_ops.get_cpl(vcpu) != 0) {
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
 		ret = -KVM_EPERM;
 		goto out;
 	}
@@ -8170,7 +8170,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	char instruction[3];
 	unsigned long rip = kvm_rip_read(vcpu);
 
-	kvm_x86_ops.patch_hypercall(vcpu, instruction);
+	static_call(kvm_x86_patch_hypercall)(vcpu, instruction);
 
 	return emulator_write_emulated(ctxt, rip, instruction, 3,
 		&ctxt->exception);
@@ -8225,7 +8225,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 
 	tpr = kvm_lapic_get_cr8(vcpu);
 
-	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
+	static_call(kvm_x86_update_cr8_intercept)(vcpu, tpr, max_irr);
 }
 
 static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
@@ -8236,7 +8236,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected) {
-		kvm_x86_ops.queue_exception(vcpu);
+		static_call(kvm_x86_queue_exception)(vcpu);
 		can_inject = false;
 	}
 	/*
@@ -8255,10 +8255,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	 */
 	else if (!vcpu->arch.exception.pending) {
 		if (vcpu->arch.nmi_injected) {
-			kvm_x86_ops.set_nmi(vcpu);
+			static_call(kvm_x86_set_nmi)(vcpu);
 			can_inject = false;
 		} else if (vcpu->arch.interrupt.injected) {
-			kvm_x86_ops.set_irq(vcpu);
+			static_call(kvm_x86_set_irq)(vcpu);
 			can_inject = false;
 		}
 	}
@@ -8299,7 +8299,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			}
 		}
 
-		kvm_x86_ops.queue_exception(vcpu);
+		static_call(kvm_x86_queue_exception)(vcpu);
 		can_inject = false;
 	}
 
@@ -8315,7 +8315,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	 * The kvm_x86_ops hooks communicate this by returning -EBUSY.
 	 */
 	if (vcpu->arch.smi_pending) {
-		r = can_inject ? kvm_x86_ops.smi_allowed(vcpu, true) : -EBUSY;
+		r = can_inject ? static_call(kvm_x86_smi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
 			goto busy;
 		if (r) {
@@ -8324,35 +8324,35 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			enter_smm(vcpu);
 			can_inject = false;
 		} else
-			kvm_x86_ops.enable_smi_window(vcpu);
+			static_call(kvm_x86_enable_smi_window)(vcpu);
 	}
 
 	if (vcpu->arch.nmi_pending) {
-		r = can_inject ? kvm_x86_ops.nmi_allowed(vcpu, true) : -EBUSY;
+		r = can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
 			goto busy;
 		if (r) {
 			--vcpu->arch.nmi_pending;
 			vcpu->arch.nmi_injected = true;
-			kvm_x86_ops.set_nmi(vcpu);
+			static_call(kvm_x86_set_nmi)(vcpu);
 			can_inject = false;
-			WARN_ON(kvm_x86_ops.nmi_allowed(vcpu, true) < 0);
+			WARN_ON(static_call(kvm_x86_nmi_allowed)(vcpu, true) < 0);
 		}
 		if (vcpu->arch.nmi_pending)
-			kvm_x86_ops.enable_nmi_window(vcpu);
+			static_call(kvm_x86_enable_nmi_window)(vcpu);
 	}
 
 	if (kvm_cpu_has_injectable_intr(vcpu)) {
-		r = can_inject ? kvm_x86_ops.interrupt_allowed(vcpu, true) : -EBUSY;
+		r = can_inject ? static_call(kvm_x86_interrupt_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
 			goto busy;
 		if (r) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
-			kvm_x86_ops.set_irq(vcpu);
-			WARN_ON(kvm_x86_ops.interrupt_allowed(vcpu, true) < 0);
+			static_call(kvm_x86_set_irq)(vcpu);
+			WARN_ON(static_call(kvm_x86_interrupt_allowed)(vcpu, true) < 0);
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))
-			kvm_x86_ops.enable_irq_window(vcpu);
+			static_call(kvm_x86_enable_irq_window)(vcpu);
 	}
 
 	if (is_guest_mode(vcpu) &&
@@ -8377,7 +8377,7 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	 * If an NMI is already in progress, limit further NMIs to just one.
 	 * Otherwise, allow two (and we'll inject the first one immediately).
 	 */
-	if (kvm_x86_ops.get_nmi_mask(vcpu) || vcpu->arch.nmi_injected)
+	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
 		limit = 1;
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
@@ -8467,11 +8467,11 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7f7c, seg.limit);
 	put_smstate(u32, buf, 0x7f78, enter_smm_get_segment_flags(&seg));
 
-	kvm_x86_ops.get_gdt(vcpu, &dt);
+	static_call(kvm_x86_get_gdt)(vcpu, &dt);
 	put_smstate(u32, buf, 0x7f74, dt.address);
 	put_smstate(u32, buf, 0x7f70, dt.size);
 
-	kvm_x86_ops.get_idt(vcpu, &dt);
+	static_call(kvm_x86_get_idt)(vcpu, &dt);
 	put_smstate(u32, buf, 0x7f58, dt.address);
 	put_smstate(u32, buf, 0x7f54, dt.size);
 
@@ -8521,7 +8521,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7e94, seg.limit);
 	put_smstate(u64, buf, 0x7e98, seg.base);
 
-	kvm_x86_ops.get_idt(vcpu, &dt);
+	static_call(kvm_x86_get_idt)(vcpu, &dt);
 	put_smstate(u32, buf, 0x7e84, dt.size);
 	put_smstate(u64, buf, 0x7e88, dt.address);
 
@@ -8531,7 +8531,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7e74, seg.limit);
 	put_smstate(u64, buf, 0x7e78, seg.base);
 
-	kvm_x86_ops.get_gdt(vcpu, &dt);
+	static_call(kvm_x86_get_gdt)(vcpu, &dt);
 	put_smstate(u32, buf, 0x7e64, dt.size);
 	put_smstate(u64, buf, 0x7e68, dt.address);
 
@@ -8561,28 +8561,28 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	 * vCPU state (e.g. leave guest mode) after we've saved the state into
 	 * the SMM state-save area.
 	 */
-	kvm_x86_ops.pre_enter_smm(vcpu, buf);
+	static_call(kvm_x86_pre_enter_smm)(vcpu, buf);
 
 	vcpu->arch.hflags |= HF_SMM_MASK;
 	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, buf, sizeof(buf));
 
-	if (kvm_x86_ops.get_nmi_mask(vcpu))
+	if (static_call(kvm_x86_get_nmi_mask)(vcpu))
 		vcpu->arch.hflags |= HF_SMM_INSIDE_NMI_MASK;
 	else
-		kvm_x86_ops.set_nmi_mask(vcpu, true);
+		static_call(kvm_x86_set_nmi_mask)(vcpu, true);
 
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0x8000);
 
 	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
-	kvm_x86_ops.set_cr0(vcpu, cr0);
+	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
 
-	kvm_x86_ops.set_cr4(vcpu, 0);
+	static_call(kvm_x86_set_cr4)(vcpu, 0);
 
 	/* Undocumented: IDT limit is set to zero on entry to SMM.  */
 	dt.address = dt.size = 0;
-	kvm_x86_ops.set_idt(vcpu, &dt);
+	static_call(kvm_x86_set_idt)(vcpu, &dt);
 
 	__kvm_set_dr(vcpu, 7, DR7_FIXED_1);
 
@@ -8613,7 +8613,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		kvm_x86_ops.set_efer(vcpu, 0);
+		static_call(kvm_x86_set_efer)(vcpu, 0);
 #endif
 
 	kvm_update_cpuid_runtime(vcpu);
@@ -8651,7 +8651,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
 	kvm_apic_update_apicv(vcpu);
-	kvm_x86_ops.refresh_apicv_exec_ctrl(vcpu);
+	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
@@ -8668,7 +8668,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	unsigned long old, new, expected;
 
 	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
-	    !kvm_x86_ops.check_apicv_inhibit_reasons(bit))
+	    !static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
 		return;
 
 	old = READ_ONCE(kvm->arch.apicv_inhibit_reasons);
@@ -8688,7 +8688,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 
 	trace_kvm_apicv_update_request(activate, bit);
 	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
-		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
+		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
 
 	/*
 	 * Sending request to update APICV for all other vcpus,
@@ -8714,7 +8714,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
 	else {
 		if (vcpu->arch.apicv_active)
-			kvm_x86_ops.sync_pir_to_irr(vcpu);
+			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 		if (ioapic_in_kernel(vcpu->kvm))
 			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
 	}
@@ -8734,7 +8734,7 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 
 	bitmap_or((ulong *)eoi_exit_bitmap, vcpu->arch.ioapic_handled_vectors,
 		  vcpu_to_synic(vcpu)->vec_bitmap, 256);
-	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
+	static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
 }
 
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
@@ -8759,7 +8759,7 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	if (!kvm_x86_ops.set_apic_access_page_addr)
 		return;
 
-	kvm_x86_ops.set_apic_access_page_addr(vcpu);
+	static_call(kvm_x86_set_apic_access_page_addr)(vcpu);
 }
 
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
@@ -8902,7 +8902,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
-			kvm_x86_ops.msr_filter_changed(vcpu);
+			static_call(kvm_x86_msr_filter_changed)(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
@@ -8915,7 +8915,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		inject_pending_event(vcpu, &req_immediate_exit);
 		if (req_int_win)
-			kvm_x86_ops.enable_irq_window(vcpu);
+			static_call(kvm_x86_enable_irq_window)(vcpu);
 
 		if (kvm_lapic_enabled(vcpu)) {
 			update_cr8_intercept(vcpu);
@@ -8930,7 +8930,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
-	kvm_x86_ops.prepare_guest_switch(vcpu);
+	static_call(kvm_x86_prepare_guest_switch)(vcpu);
 
 	/*
 	 * Disable IRQs before setting IN_GUEST_MODE.  Posted interrupt
@@ -8961,7 +8961,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * notified with kvm_vcpu_kick.
 	 */
 	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
-		kvm_x86_ops.sync_pir_to_irr(vcpu);
+		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
@@ -8975,7 +8975,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		kvm_x86_ops.request_immediate_exit(vcpu);
+		static_call(kvm_x86_request_immediate_exit)(vcpu);
 	}
 
 	trace_kvm_entry(vcpu);
@@ -8994,7 +8994,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	exit_fastpath = kvm_x86_ops.run(vcpu);
+	exit_fastpath = static_call(kvm_x86_run)(vcpu);
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
@@ -9004,7 +9004,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
-		kvm_x86_ops.sync_dirty_debug_regs(vcpu);
+		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
@@ -9026,7 +9026,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops.handle_exit_irqoff(vcpu);
+	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of
@@ -9068,13 +9068,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.apic_attention)
 		kvm_lapic_sync_from_vapic(vcpu);
 
-	r = kvm_x86_ops.handle_exit(vcpu, exit_fastpath);
+	r = static_call(kvm_x86_handle_exit)(vcpu, exit_fastpath);
 	return r;
 
 cancel_injection:
 	if (req_immediate_exit)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-	kvm_x86_ops.cancel_injection(vcpu);
+	static_call(kvm_x86_cancel_injection)(vcpu);
 	if (unlikely(vcpu->arch.apic_attention))
 		kvm_lapic_sync_from_vapic(vcpu);
 out:
@@ -9084,13 +9084,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
-	    (!kvm_x86_ops.pre_block || kvm_x86_ops.pre_block(vcpu) == 0)) {
+	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
 		if (kvm_x86_ops.post_block)
-			kvm_x86_ops.post_block(vcpu);
+			static_call(kvm_x86_post_block)(vcpu);
 
 		if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
 			return 1;
@@ -9484,10 +9484,10 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	kvm_get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	kvm_get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-	kvm_x86_ops.get_idt(vcpu, &dt);
+	static_call(kvm_x86_get_idt)(vcpu, &dt);
 	sregs->idt.limit = dt.size;
 	sregs->idt.base = dt.address;
-	kvm_x86_ops.get_gdt(vcpu, &dt);
+	static_call(kvm_x86_get_gdt)(vcpu, &dt);
 	sregs->gdt.limit = dt.size;
 	sregs->gdt.base = dt.address;
 
@@ -9637,10 +9637,10 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
-	kvm_x86_ops.set_idt(vcpu, &dt);
+	static_call(kvm_x86_set_idt)(vcpu, &dt);
 	dt.size = sregs->gdt.limit;
 	dt.address = sregs->gdt.base;
-	kvm_x86_ops.set_gdt(vcpu, &dt);
+	static_call(kvm_x86_set_gdt)(vcpu, &dt);
 
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
@@ -9650,14 +9650,14 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	kvm_set_cr8(vcpu, sregs->cr8);
 
 	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
-	kvm_x86_ops.set_efer(vcpu, sregs->efer);
+	static_call(kvm_x86_set_efer)(vcpu, sregs->efer);
 
 	mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
-	kvm_x86_ops.set_cr0(vcpu, sregs->cr0);
+	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
 	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
-	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
+	static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (is_pae_paging(vcpu)) {
@@ -9765,7 +9765,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	 */
 	kvm_set_rflags(vcpu, rflags);
 
-	kvm_x86_ops.update_exception_bitmap(vcpu);
+	static_call(kvm_x86_update_exception_bitmap)(vcpu);
 
 	r = 0;
 
@@ -9992,7 +9992,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_hv_vcpu_init(vcpu);
 
-	r = kvm_x86_ops.vcpu_create(vcpu);
+	r = static_call(kvm_x86_vcpu_create)(vcpu);
 	if (r)
 		goto free_guest_fpu;
 
@@ -10055,7 +10055,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
-	kvm_x86_ops.vcpu_free(vcpu);
+	static_call(kvm_x86_vcpu_free)(vcpu);
 
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
@@ -10144,7 +10144,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.ia32_xss = 0;
 
-	kvm_x86_ops.vcpu_reset(vcpu, init_event);
+	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 }
 
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
@@ -10169,7 +10169,7 @@ int kvm_arch_hardware_enable(void)
 	bool stable, backwards_tsc = false;
 
 	kvm_user_return_msr_cpu_online();
-	ret = kvm_x86_ops.hardware_enable();
+	ret = static_call(kvm_x86_hardware_enable)();
 	if (ret != 0)
 		return ret;
 
@@ -10251,7 +10251,7 @@ int kvm_arch_hardware_enable(void)
 
 void kvm_arch_hardware_disable(void)
 {
-	kvm_x86_ops.hardware_disable();
+	static_call(kvm_x86_hardware_disable)();
 	drop_user_return_notifiers();
 }
 
@@ -10270,6 +10270,7 @@ int kvm_arch_hardware_setup(void *opaque)
 		return r;
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
+	kvm_ops_static_call_update();
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
@@ -10298,7 +10299,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
-	kvm_x86_ops.hardware_unsetup();
+	static_call(kvm_x86_hardware_unsetup)();
 }
 
 int kvm_arch_check_processor_compat(void *opaque)
@@ -10338,7 +10339,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		pmu->need_cleanup = true;
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
-	kvm_x86_ops.sched_in(vcpu, cpu);
+	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
@@ -10382,7 +10383,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
 
-	return kvm_x86_ops.vm_init(kvm);
+	return static_call(kvm_x86_vm_init)(kvm);
 }
 
 int kvm_arch_post_init_vm(struct kvm *kvm)
@@ -10527,8 +10528,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
-	if (kvm_x86_ops.vm_destroy)
-		kvm_x86_ops.vm_destroy(kvm);
+	static_call_cond(kvm_x86_vm_destroy)(kvm);
 	for (i = 0; i < kvm->arch.msr_filter.count; i++)
 		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
 	kvm_pic_destroy(kvm);
@@ -10719,7 +10719,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		if (kvm_x86_ops.slot_enable_log_dirty) {
-			kvm_x86_ops.slot_enable_log_dirty(kvm, new);
+			static_call(kvm_x86_slot_enable_log_dirty)(kvm, new);
 		} else {
 			int level =
 				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
@@ -10737,7 +10737,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		}
 	} else {
 		if (kvm_x86_ops.slot_disable_log_dirty)
-			kvm_x86_ops.slot_disable_log_dirty(kvm, new);
+			static_call(kvm_x86_slot_disable_log_dirty)(kvm, new);
 	}
 }
 
@@ -10776,7 +10776,7 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	return (is_guest_mode(vcpu) &&
 			kvm_x86_ops.guest_apic_has_interrupt &&
-			kvm_x86_ops.guest_apic_has_interrupt(vcpu));
+			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
 }
 
 static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
@@ -10795,12 +10795,12 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
 	    (vcpu->arch.nmi_pending &&
-	     kvm_x86_ops.nmi_allowed(vcpu, false)))
+	     static_call(kvm_x86_nmi_allowed)(vcpu, false)))
 		return true;
 
 	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
 	    (vcpu->arch.smi_pending &&
-	     kvm_x86_ops.smi_allowed(vcpu, false)))
+	     static_call(kvm_x86_smi_allowed)(vcpu, false)))
 		return true;
 
 	if (kvm_arch_interrupt_allowed(vcpu) &&
@@ -10834,7 +10834,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
 		 kvm_test_request(KVM_REQ_EVENT, vcpu))
 		return true;
 
-	if (vcpu->arch.apicv_active && kvm_x86_ops.dy_apicv_has_pending_interrupt(vcpu))
+	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
 		return true;
 
 	return false;
@@ -10852,7 +10852,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-	return kvm_x86_ops.interrupt_allowed(vcpu, false);
+	return static_call(kvm_x86_interrupt_allowed)(vcpu, false);
 }
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
@@ -10878,7 +10878,7 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 {
 	unsigned long rflags;
 
-	rflags = kvm_x86_ops.get_rflags(vcpu);
+	rflags = static_call(kvm_x86_get_rflags)(vcpu);
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		rflags &= ~X86_EFLAGS_TF;
 	return rflags;
@@ -10890,7 +10890,7 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
 	    kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip))
 		rflags |= X86_EFLAGS_TF;
-	kvm_x86_ops.set_rflags(vcpu, rflags);
+	static_call(kvm_x86_set_rflags)(vcpu, rflags);
 }
 
 void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
@@ -11020,7 +11020,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 		return false;
 
 	if (!kvm_pv_async_pf_enabled(vcpu) ||
-	    (vcpu->arch.apf.send_user_only && kvm_x86_ops.get_cpl(vcpu) == 0))
+	    (vcpu->arch.apf.send_user_only && static_call(kvm_x86_get_cpl)(vcpu) == 0))
 		return false;
 
 	return true;
@@ -11165,7 +11165,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 
 	irqfd->producer = prod;
 	kvm_arch_start_assignment(irqfd->kvm);
-	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
+	ret = static_call(kvm_x86_update_pi_irte)(irqfd->kvm,
 					 prod->irq, irqfd->gsi, 1);
 
 	if (ret)
@@ -11190,7 +11190,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
-	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm, prod->irq, irqfd->gsi, 0);
+	ret = static_call(kvm_x86_update_pi_irte)(irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
@@ -11201,7 +11201,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 				   uint32_t guest_irq, bool set)
 {
-	return kvm_x86_ops.update_pi_irte(kvm, host_irq, guest_irq, set);
+	return static_call(kvm_x86_update_pi_irte)(kvm, host_irq, guest_irq, set);
 }
 
 bool kvm_vector_hashing_enabled(void)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5..62f4f64 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -98,7 +98,7 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
 
 	if (!is_long_mode(vcpu))
 		return false;
-	kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
 	return cs_l;
 }
 
@@ -129,7 +129,7 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops.tlb_flush_current(vcpu);
+	static_call(kvm_x86_tlb_flush_current)(vcpu);
 }
 
 static inline int is_pae(struct kvm_vcpu *vcpu)
@@ -244,7 +244,7 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 
 static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 {
-	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
+	return is_smm(vcpu) || static_call(kvm_x86_apic_init_signal_blocked)(vcpu);
 }
 
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
-- 
2.7.4

