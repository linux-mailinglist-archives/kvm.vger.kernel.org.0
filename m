Return-Path: <kvm+bounces-24692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43753959543
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 09:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C85EC1F24EDD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 07:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1241199FAB;
	Wed, 21 Aug 2024 07:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fPtZKrDh"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E34199FA6
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 07:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724223777; cv=none; b=C4e6EJ2U03j4o7DJ4hHNUXIXTId8ovYeYpDwPWySse7l8JOO1q4Jb1xt0n6uFBaayP8OD739VEaAw8qOLM6+NPCpha+4wYeqpmPAi8JIP7UY2XIqHnnU1VeA4z8AgSN5Cl6fF2JGi3b00eWPHXejVLWpUWPrd6FR/oK/183dJZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724223777; c=relaxed/simple;
	bh=ts4hzDpLD3PAaFr9EexWCRGqUS2r5RW/Wy1BfJWlo7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLAHRTaxAZHzqxXyA+Tp4kxn8u0G8OdFVsXC8+Y12rGrq11FX3jbrPxAaeTkPD3L98JFdk+biZpzg7lTE2lMpYAAQcLnVWzTwVFS6OB2tI5HAEluRUVnN/mpGbn/npBBEVss457PwKKlt509VZw1sFuECgIXU90dR30naV1Uqzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fPtZKrDh; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 21 Aug 2024 07:02:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724223772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U+crhYyjUYjbHiYn/PrY8K/Jrp7sjKcMzlcG9HdVR08=;
	b=fPtZKrDh2ajWDIW3Afcc6l0OQOu46maUbHI6I6DOmIcck/kAesLeCqmIClh0gr86PToJJO
	pSDl56YSqB9jcYWPeTEvqGOPJtcMRqGh2XN9HhuRN2KKiu16JBR6P/7Z7M0xq+/zSMGvic
	LkVZhSWuGdHcpjFJkwfkTdaxgiVV5Ro=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: Re: [PATCH v4 00/18] KVM: arm64: nv: Add support for address
 translation instructions
Message-ID: <ZsWRFGifEUJrUj7G@linux.dev>
References: <20240820103756.3545976-1-maz@kernel.org>
 <b3e34ca2-911e-471f-8418-5a3144044e56@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3e34ca2-911e-471f-8418-5a3144044e56@os.amperecomputing.com>
X-Migadu-Flow: FLOW_OUT

Hi Ganapat,

On Wed, Aug 21, 2024 at 09:55:37AM +0530, Ganapatrao Kulkarni wrote:
> Have you tested/tried NV with host/L0 booted with GICv4.x enabled?
> We do see L2 boot hang and I don't have much debug info at the moment.

Sorry, I've been sitting on a fix for this that I've been meaning to
send out.

The issue has to do with the fact that the vpe is marked as runnable
(its_vpe::pending_last = true) when descheduled w/o requesting a
doorbell IRQ. Once KVM completes the nested ERET, it believes an IRQ is
pending for L1 (kvm_vgic_vcpu_pending_irq() returns true), and injects
the nested exception.

This can be papered over by requesting the doorbell IRQ, which we need
anyway to kick us out of the L2 when an IRQ becomes pending for L1.

Could you take this diff for a spin?

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0ae093bae054..9d07184d79b1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -613,6 +613,12 @@ struct cpu_sve_state {
  * field.
  */
 struct kvm_host_data {
+	/* SVE enabled for EL0 */
+#define HOST_SVE_ENABLED	0
+	/* SME enabled for EL0 */
+#define HOST_SME_ENABLED	1
+	unsigned long flags;
+
 	struct kvm_cpu_context host_ctxt;
 
 	/*
@@ -908,10 +914,8 @@ struct kvm_vcpu_arch {
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
-/* SVE enabled for host EL0 */
-#define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
-/* SME enabled for EL0 */
-#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
+/* KVM is currently emulating a nested ERET */
+#define IN_NESTED_ERET		__vcpu_single_flag(sflags, BIT(0))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 /* WFIT instruction trapped */
@@ -1294,6 +1298,10 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
 	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
 #endif
 
+#define host_data_set_flag(nr)		set_bit(nr, host_data_ptr(flags))
+#define host_data_test_flag(nr)		test_bit(nr, host_data_ptr(flags))
+#define host_data_clear_flag(nr)	clear_bit(nr, host_data_ptr(flags))
+
 /* Check whether the FP regs are owned by the guest */
 static inline bool guest_owns_fp_regs(void)
 {
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..fd3d6275b777 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2310,6 +2310,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	}
 
 	preempt_disable();
+	vcpu_set_flag(vcpu, IN_NESTED_ERET);
 	kvm_arch_vcpu_put(vcpu);
 
 	if (!esr_iss_is_eretax(esr))
@@ -2321,6 +2322,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	*vcpu_cpsr(vcpu) = spsr;
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	vcpu_clear_flag(vcpu, IN_NESTED_ERET);
 	preempt_enable();
 }
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index c53e5b14038d..f7712c89adef 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -64,14 +64,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
 
-	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
+	host_data_clear_flag(HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
+		host_data_set_flag(HOST_SVE_ENABLED);
 
 	if (system_supports_sme()) {
-		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
+		host_data_clear_flag(HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
-			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
+			host_data_set_flag(HOST_SME_ENABLED);
 
 		/*
 		 * If PSTATE.SM is enabled then save any pending FP
@@ -167,7 +167,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	 */
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
-		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
+		if (host_data_test_flag(HOST_SME_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_SMEN);
 		else
 			sysreg_clear_set(CPACR_EL1,
@@ -226,7 +226,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		 * for EL0.  To avoid spurious traps, restore the trap state
 		 * seen by kvm_arch_vcpu_load_fp():
 		 */
-		if (vcpu_get_flag(vcpu, HOST_SVE_ENABLED))
+		if (host_data_test_flag(HOST_SVE_ENABLED))
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
 		else
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 74a67ad87f29..9f3f06ac76cc 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -336,6 +336,22 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
+static inline bool vgic_v4_want_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		return true;
+
+	if (likely(!vcpu_has_nv(vcpu)))
+		return false;
+
+	/*
+	 * GICv4 hardware is only ever used for the L1. Mark the vPE (i.e. the
+	 * L1 context) nonresident and request a doorbell to kick us out of the
+	 * L2 when an IRQ becomes pending.
+	 */
+	return vcpu_get_flag(vcpu, IN_NESTED_ERET);
+}
+
 int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
@@ -343,7 +359,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
 	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
-	return its_make_vpe_non_resident(vpe, !!vcpu_get_flag(vcpu, IN_WFI));
+	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
 }
 
 int vgic_v4_load(struct kvm_vcpu *vcpu)

-- 
Thanks,
Oliver

