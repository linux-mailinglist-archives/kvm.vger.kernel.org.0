Return-Path: <kvm+bounces-15575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 556FD8AD6BC
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 23:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 706A01C218CF
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 21:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 978D91CF9B;
	Mon, 22 Apr 2024 21:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sq0vL3B/"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3A11CD20
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713822223; cv=none; b=UFZ5bNVwORwCiMFsk/9a/NnJajwHa+e69W9QXbsTE0lFNsR1kM+PNV5fEPj3oO0IfVYBQL41s/Vyx0VYHFhrSQKCiO/h0W6JMj+17NoO062RURdkhePTpPCSm16n9VDJe9jXqDy/EOamGt8Fph/f2QlYd8C+MQIeoCfsI3WDgxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713822223; c=relaxed/simple;
	bh=xLZE5bqjy1mPJu01bI1nilRUwIDr5ANAP981riTJIB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfNK2mmsEgIWBMEHP+103VGD8paz4wS/ItMS9rQaSIHGx8hH3AILhmnOluRaE7y52JGarfLUeOdI+uXFS9dmuXlI3tYr5cXzMpxBKQnvmxBml0IePKWgfxqmNVNWOoohlsqWwG4Yy16xIvmQzKkUfwmwrkDfjYC1NUc803TLGMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sq0vL3B/; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Apr 2024 14:43:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713822220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qOHBnIZ60BpbamfCcbp9FtjSsLepjsFEyHBNJJNk5kc=;
	b=sq0vL3B/aLECcKUV52U/A2xmzSWt//LFJPQqNNQrrJLnJUbHK1iMaDovIXJv3A6PKtVAcN
	sokyh40MNRsXUvgLEDA0qW01nHjv8RIFNbfk362lxy5L8Aar/Q4zkPm21veaeC4kPPRW8k
	YkKhT4CwEp5Kykcx61b3dkDcwHSgrSI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4] KVM: arm64: Add early_param to control WFx trapping
Message-ID: <ZibaBKCFMz-dJNM4@linux.dev>
References: <20240422181716.237284-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422181716.237284-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Mon, Apr 22, 2024 at 06:17:16PM +0000, Colton Lewis wrote:
> Add an early_params to control WFI and WFE trapping. This is to
> control the degree guests can wait for interrupts on their own without
> being trapped by KVM. Options for each param are trap, notrap, and
> default. trap enables the trap. notrap disables the trap. default
> preserves current behavior, disabling the trap if only a single task
> is running and enabling otherwise.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
> v4:
> 
> * Fixed inaccurate names that incorrectly implied this controls interrupts
>   themselves instead of instructions waiting for interrupts and events
> * Split into two separate params as interrupts (WFI) and events (WFE) do
>   different things and may warrant separate controls.
> * Document new params in Documentation/admin-guide/kernel-parameters.txt
> 
> 
> v3:
> https://lore.kernel.org/kvmarm/20240410175437.793508-1-coltonlewis@google.com/
> 
> v2:
> https://lore.kernel.org/kvmarm/20240319164341.1674863-1-coltonlewis@google.com/
> 
> v1:
> https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@google.com/
> 
>  .../admin-guide/kernel-parameters.txt         | 22 +++++++-
>  arch/arm64/include/asm/kvm_emulate.h          | 24 ++++++++-
>  arch/arm64/include/asm/kvm_host.h             |  7 +++
>  arch/arm64/kvm/arm.c                          | 54 +++++++++++++++++--
>  4 files changed, 101 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 31b3a25680d0..f8d16c792e66 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2653,6 +2653,27 @@
>  			[KVM,ARM] Allow use of GICv4 for direct injection of
>  			LPIs.
> 
> +	kvm-arm.wfe_trap_policy=
> +			[KVM,ARM] Control when to set wfe instruction trap.

nitpick: when referring to the instruction, please capitalize it.

Also, it doesn't hurt to be verbose here and say this cmdline option
"Controls the WFE instruction trap behavior for KVM VMs"

I say this because there is a separate set of trap controls that allow
WFE or WFI to execute in EL0 (i.e. host userspace).

> +			trap: set wfe instruction trap
> +
> +			notrap: clear wfe instruction trap
> +
> +			default: set wfe instruction trap only if multiple
> +				 tasks are running on the CPU

I would strongly prefer we not make any default behavior user-visible.
The default KVM behavior can (and will) change in the future.

Only the absence of an explicit trap / notrap policy should fall back to
KVM's default heuristics.

> +	kvm-arm.wfi_trap_policy=
> +			[KVM,ARM] Control when to set wfi instruction trap.
> +
> +			trap: set wfi instruction trap
> +
> +			notrap: clear wfi instruction trap
> +
> +			default: set wfi instruction trap only if multiple
> +				 tasks are running on the CPU
> +
> +
>  	kvm_cma_resv_ratio=n [PPC]
>  			Reserves given percentage from system memory area for
>  			contiguous memory allocation for KVM hash pagetable
> @@ -7394,4 +7415,3 @@
>  				memory, and other data can't be written using
>  				xmon commands.
>  			off	xmon is disabled.
> -
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index b804fe832184..efd0a3fb6f00 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -109,9 +109,13 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>  	return (unsigned long *)&vcpu->arch.hcr_el2;
>  }
> 
> -static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
> +static inline void vcpu_clear_wfe_trap(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hcr_el2 &= ~HCR_TWE;
> +}
> +
> +static inline void vcpu_clear_wfi_trap(struct kvm_vcpu *vcpu)
> +{
>  	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
>  	    vcpu->kvm->arch.vgic.nassgireq)
>  		vcpu->arch.hcr_el2 &= ~HCR_TWI;
> @@ -119,12 +123,28 @@ static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcr_el2 |= HCR_TWI;
>  }

This helper definitely does not do as it says on the tin. It ignores the
policy requested on the command line and conditionally *sets* TWI. If
the operator believes they know best and ask for a particular trap policy
KVM should uphold it unconditionally. Even if they've managed to shoot
themselves in the foot.

> -static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
> +static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
> +{
> +	vcpu_clear_wfe_trap(vcpu);
> +	vcpu_clear_wfi_trap(vcpu);
> +}
> +
> +static inline void vcpu_set_wfe_trap(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hcr_el2 |= HCR_TWE;
> +}
> +
> +static inline void vcpu_set_wfi_trap(struct kvm_vcpu *vcpu)
> +{
>  	vcpu->arch.hcr_el2 |= HCR_TWI;
>  }
> 
> +static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
> +{
> +	vcpu_set_wfe_trap(vcpu);
> +	vcpu_set_wfi_trap(vcpu);
> +}
> +
>  static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 21c57b812569..315ee7bfc1cb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -67,6 +67,13 @@ enum kvm_mode {
>  	KVM_MODE_NV,
>  	KVM_MODE_NONE,
>  };
> +
> +enum kvm_wfx_trap_policy {
> +	KVM_WFX_NOTRAP_SINGLE_TASK, /* Default option */
> +	KVM_WFX_NOTRAP,
> +	KVM_WFX_TRAP,
> +};
> +
>  #ifdef CONFIG_KVM
>  enum kvm_mode kvm_get_mode(void);
>  #else
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a25265aca432..5106ba5a8a39 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -46,6 +46,8 @@
>  #include <kvm/arm_psci.h>
> 
>  static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
> +static enum kvm_wfx_trap_policy kvm_wfi_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;
> +static enum kvm_wfx_trap_policy kvm_wfe_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;
> 
>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
> 
> @@ -423,6 +425,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> 
>  }
> 
> +static bool kvm_should_clear_wfx_trap(enum kvm_wfx_trap_policy p)
> +{
> +	return (p == KVM_WFX_NOTRAP && kvm_vgic_global_state.has_gicv4)
> +		|| (p == KVM_WFX_NOTRAP_SINGLE_TASK && single_task_running());
> +}

style nitpick: operators should always go on the preceding line for a
multi-line statement.

>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct kvm_s2_mmu *mmu;
> @@ -456,10 +464,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>  		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> 
> -	if (single_task_running())
> -		vcpu_clear_wfx_traps(vcpu);
> +	if (kvm_should_clear_wfx_trap(kvm_wfi_trap_policy))
> +		vcpu_clear_wfi_trap(vcpu);
>  	else
> -		vcpu_set_wfx_traps(vcpu);
> +		vcpu_set_wfi_trap(vcpu);
> +
> +	if (kvm_should_clear_wfx_trap(kvm_wfe_trap_policy))
> +		vcpu_clear_wfe_trap(vcpu);
> +	else
> +		vcpu_set_wfe_trap(vcpu);
> 
>  	if (vcpu_has_ptrauth(vcpu))
>  		vcpu_ptrauth_disable(vcpu);

I find all of the layering rather hard to follow; we don't need
accessors for doing simple bit manipulation.

Rough sketch:

static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
{
	if (unlikely(kvm_wfi_trap != KVM_WFX_DEFAULT))
		return kvm_wfi_trap == KVM_WFX_NOTRAP;

	return single_task_running() &&
	       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
	        vcpu->kvm->arch.vgic.nassgireq);
}

static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
{
	if (unlikely(kvm_wfe_trap != KVM_WFX_DEFAULT))
		return kvm_wfe_trap == KVM_WFX_NOTRAP;

	return single_task_running();
}

static void kvm_vcpu_load_compute_hcr(struct kvm_vcpu *vcpu)
{
	vcpu->arch.hcr_el2 |= HCR_TWE | HCR_TWI;

	if (kvm_vcpu_should_clear_twe(vcpu))
		vcpu->arch.hcr_el2 &= ~HCR_TWE;
	if (kvm_vcpu_should_clear_twi(vcpu))
		vcpu->arch.hcr_el2 &= ~HCR_TWI;
}

And if we really wanted to, the non-default trap configuration could be
moved to vcpu_reset_hcr() if we cared.

-- 
Thanks,
Oliver

