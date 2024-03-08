Return-Path: <kvm+bounces-11380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 788C08769C0
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 052861F252C9
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF62057335;
	Fri,  8 Mar 2024 17:21:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533094F213
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709918471; cv=none; b=q/Omdon+3bgfqctuIUb1XdE7ZysUxROW0ElUDQqMUz/Ipc0qNj7ED3FVpA4XDjTuRlzobqfhvl1OMQHXwphyHRpC0DJPd9MuBjkNXlnEnH0IFUzp23mwOtLLGLTgkWB9MWQcr0hNsqSI1DT1j7APa3K2t+nKYXIBiwdH2w3Rrpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709918471; c=relaxed/simple;
	bh=i37/8mp8aujBGo+6L2woz8WoAapVoQ4OPIaSRPWVPMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuHBAq+H0ksNq9xpgw+5jVH2KxIhMm1wzdb0A1bYV8MJfitxu4I8CR4hUfcWMV1IBu/AKHqwEXH3HVS6Sq8r0K13xWvzBHDfdGUL35tuBBKTFy2TbuOvAnSz8nky43oFh2ew9lpOTa28QKGsJ8gEiyaTG1KYupdXGAG+ixYVb8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78594C15;
	Fri,  8 Mar 2024 09:21:45 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5611C3F738;
	Fri,  8 Mar 2024 09:21:07 -0800 (PST)
Date: Fri, 8 Mar 2024 17:20:59 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 11/13] KVM: arm64: nv: Add emulation for ERETAx
 instructions
Message-ID: <20240308172059.GA1052268@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-12-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-12-maz@kernel.org>

Phew..

On Mon, Feb 26, 2024 at 10:05:59AM +0000, Marc Zyngier wrote:
> FEAT_NV has the interesting property of relying on ERET being
> trapped. An added complexity is that it also traps ERETAA and
> ERETAB, meaning that the Pointer Authentication aspect of these
> instruction must be emulated.
> 
> Add an emulation of Pointer Authentication, limited to ERETAx
> (always using SP_EL2 as the modifier and ELR_EL2 as the pointer),
> using the Generic Authentication instructions.
> 
> The emulation, however small, is placed in its own compilation
> unit so that it can be avoided if the configuration doesn't
> include it (or the toolchan in not up to the task).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h    |  12 ++
>  arch/arm64/include/asm/pgtable-hwdef.h |   1 +
>  arch/arm64/kvm/Makefile                |   1 +
>  arch/arm64/kvm/pauth.c                 | 196 +++++++++++++++++++++++++
>  4 files changed, 210 insertions(+)
>  create mode 100644 arch/arm64/kvm/pauth.c
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index dbc4e3a67356..5e0ab0596246 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -64,4 +64,16 @@ extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
>  
>  int kvm_init_nv_sysregs(struct kvm *kvm);
>  
> +#ifdef CONFIG_ARM64_PTR_AUTH
> +bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr);
> +#else
> +static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
> +{
> +	/* We really should never execute this... */
> +	WARN_ON_ONCE(1);
> +	*elr = 0xbad9acc0debadbad;
> +	return false;
> +}
> +#endif
> +
>  #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index e4944d517c99..bb88e9ef6296 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -277,6 +277,7 @@
>  #define TCR_TBI1		(UL(1) << 38)
>  #define TCR_HA			(UL(1) << 39)
>  #define TCR_HD			(UL(1) << 40)
> +#define TCR_TBID0		(UL(1) << 51)
>  #define TCR_TBID1		(UL(1) << 52)
>  #define TCR_NFD0		(UL(1) << 53)
>  #define TCR_NFD1		(UL(1) << 54)
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index c0c050e53157..04882b577575 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -23,6 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o
>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> +kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>  
>  always-y := hyp_constants.h hyp-constants.s
>  
> diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
> new file mode 100644
> index 000000000000..a3a5c404375b
> --- /dev/null
> +++ b/arch/arm64/kvm/pauth.c
> @@ -0,0 +1,196 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024 - Google LLC
> + * Author: Marc Zyngier <maz@kernel.org>
> + *
> + * Primitive PAuth emulation for ERETAA/ERETAB.
> + *
> + * This code assumes that is is run from EL2, and that it is part of
> + * the emulation of ERETAx for a guest hypervisor. That's a lot of
> + * baked-in assumptions and shortcuts.
> + *
> + * Do no reuse for anything else!
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_emulate.h>
> +#include <asm/pointer_auth.h>
> +
> +static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
> +		       struct ptrauth_key ikey)
> +{
> +	struct ptrauth_key gkey;
> +	u64 mod, pac = 0;
> +
> +	preempt_disable();
> +
> +	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
> +		mod = __vcpu_sys_reg(vcpu, SP_EL2);
> +	else
> +		mod = read_sysreg(sp_el1);
> +
> +	gkey.lo = read_sysreg_s(SYS_APGAKEYLO_EL1);
> +	gkey.hi = read_sysreg_s(SYS_APGAKEYHI_EL1);
> +
> +	__ptrauth_key_install_nosync(APGA, ikey);
> +	isb();
> +
> +	asm volatile(ARM64_ASM_PREAMBLE ".arch_extension pauth\n"
> +		     "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
> +	isb();
> +
> +	__ptrauth_key_install_nosync(APGA, gkey);
> +
> +	preempt_enable();
> +
> +	/* PAC in the top 32bits */
> +	return pac;
> +}
> +
> +static bool effective_tbi(struct kvm_vcpu *vcpu, bool bit55)
> +{
> +	u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
> +	bool tbi, tbid;
> +
> +	/*
> +	 * Since we are authenticating an instruction address, we have
> +	 * to take TBID into account. If E2H==0, ignore VA[55], as
> +	 * TCR_EL2 only has a single TBI/TBID. If VA[55] was set in
> +	 * this case, this is likely a guest bug...
> +	 */
> +	if (!vcpu_el2_e2h_is_set(vcpu)) {
> +		tbi = tcr & BIT(20);
> +		tbid = tcr & BIT(29);
> +	} else if (bit55) {
> +		tbi = tcr & TCR_TBI1;
> +		tbid = tcr & TCR_TBID1;
> +	} else {
> +		tbi = tcr & TCR_TBI0;
> +		tbid = tcr & TCR_TBID0;
> +	}
> +
> +	return tbi && !tbid;
> +}
> +
> +static int compute_bottom_pac(struct kvm_vcpu *vcpu, bool bit55)
> +{
> +	static const int maxtxsz = 39; // Revisit these two values once
> +	static const int mintxsz = 16; // (if) we support TTST/LVA/LVA2
> +	u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
> +	int txsz;
> +
> +	if (!vcpu_el2_e2h_is_set(vcpu) || !bit55)
> +		txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
> +	else
> +		txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
> +
> +	return 64 - clamp(txsz, mintxsz, maxtxsz);
> +}
> +
> +static u64 compute_pac_mask(struct kvm_vcpu *vcpu, bool bit55)
> +{
> +	int bottom_pac;
> +	u64 mask;
> +
> +	bottom_pac = compute_bottom_pac(vcpu, bit55);
> +
> +	mask = GENMASK(54, bottom_pac);
> +	if (!effective_tbi(vcpu, bit55))
> +		mask |= GENMASK(63, 56);
> +
> +	return mask;
> +}
> +
> +static u64 to_canonical_addr(struct kvm_vcpu *vcpu, u64 ptr, u64 mask)
> +{
> +	bool bit55 = !!(ptr & BIT(55));
> +
> +	if (bit55)
> +		return ptr | mask;
> +
> +	return ptr & ~mask;
> +}
> +
> +static u64 corrupt_addr(struct kvm_vcpu *vcpu, u64 ptr)
> +{
> +	bool bit55 = !!(ptr & BIT(55));
> +	u64 mask, error_code;
> +	int shift;
> +
> +	if (effective_tbi(vcpu, bit55)) {
> +		mask = GENMASK(54, 53);
> +		shift = 53;
> +	} else {
> +		mask = GENMASK(62, 61);
> +		shift = 61;
> +	}
> +
> +	if (esr_iss_is_eretab(kvm_vcpu_get_esr(vcpu)))
> +		error_code = 2 << shift;
> +	else
> +		error_code = 1 << shift;
> +
> +	ptr &= ~mask;
> +	ptr |= error_code;
> +
> +	return ptr;
> +}
> +
> +/*
> + * Authenticate an ERETAA/ERETAB instruction, returning true if the
> + * authentication succeeded and false otherwise. In all cases, *elr
> + * contains the VA to ERET to. Potential exception injection is left
> + * to the caller.
> + */
> +bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
> +{
> +	u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +	u64 esr = kvm_vcpu_get_esr(vcpu);
> +	u64 ptr, cptr, pac, mask;
> +	struct ptrauth_key ikey;
> +
> +	*elr = ptr = vcpu_read_sys_reg(vcpu, ELR_EL2);
> +
> +	/* We assume we're already in the context of an ERETAx */
> +	if (esr_iss_is_eretab(esr)) {
> +		if (!(sctlr & SCTLR_EL1_EnIB))
> +			return true;
> +
> +		ikey.lo = __vcpu_sys_reg(vcpu, APIBKEYLO_EL1);
> +		ikey.hi = __vcpu_sys_reg(vcpu, APIBKEYHI_EL1);
> +	} else {
> +		if (!(sctlr & SCTLR_EL1_EnIA))
> +			return true;
> +
> +		ikey.lo = __vcpu_sys_reg(vcpu, APIAKEYLO_EL1);
> +		ikey.hi = __vcpu_sys_reg(vcpu, APIAKEYHI_EL1);
> +	}
> +
> +	mask = compute_pac_mask(vcpu, !!(ptr & BIT(55)));
> +	cptr = to_canonical_addr(vcpu, ptr, mask);
> +
> +	pac = compute_pac(vcpu, cptr, ikey);
> +
> +	/*
> +	 * Slightly deviate from the pseudocode: if we have a PAC
> +	 * match with the signed pointer, then it must be good.
> +	 * Anything after this point is pure error handling.
> +	 */
> +	if ((pac & mask) == (ptr & mask)) {
> +		*elr = cptr;
> +		return true;
> +	}
> +
> +	/*
> +	 * Authentication failed, corrupt the canonical address if
> +	 * PAuth2 isn't implemented, or some XORing if it is.
> +	 */
> +	if (!kvm_has_pauth(vcpu->kvm, PAuth2))
> +		cptr = corrupt_addr(vcpu, cptr);
> +	else
> +		cptr = ptr ^ (pac & mask);
> +
> +	*elr = cptr;
> +	return false;
> +}

Each function in this file is quite small, but there's certainly a lot of
complexity and background knowledge required to understand them!

I spent quite some time on each part to see if it matches what I understood
from the Arm ARM.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>


A side note / thing I considered. KVM doesn't currently handle ERET exceptions
from EL1.

1. If an ERETA{A,B} were executed from a nested EL1 guest, that would be
trapped up to Host KVM at EL2.

2. kvm_hyp_handle_eret() returns false since it's not from vEL2.  Inside
kvm_handle_eret(), is_hyp_ctxt() is false so the exception is injected into
vEL2 (via kvm_inject_nested_sync()).

3. vEL2 gets the exception, kvm_hyp_handle_eret() returns false as before.
Inside kvm_handle_eret(), is_hyp_ctxt() is also false, so
kvm_inject_nested_sync() is called but now errors out since vcpu_has_nv() is
false.

Is that flow right? Am I missing something?

Thanks,
Joey

