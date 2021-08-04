Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90413DFFE5
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 13:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhHDLFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 07:05:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhHDLFt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 07:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628075136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rnt5ZaRSzt63eqyUBTbbjjsGf45vaJy5/1TJ1ezkZLk=;
        b=FY5jGk1M/fFR94bbqbozqFZkoe0QigCP8K0zzJetFVbVmDHXfOe3lpjMEO7S4HJB92Es+r
        i1S5tygB3BIMufz2275fmM+AI207FUl5t/BUl8npHIwvcd9szro5sKpL4ZjWt/tLiDJG+d
        cYelQh+XTblw1TcjpjFnz46+9isVzyU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-aQdOpw29MmSRX_XgcLSiig-1; Wed, 04 Aug 2021 07:05:35 -0400
X-MC-Unique: aQdOpw29MmSRX_XgcLSiig-1
Received: by mail-ed1-f71.google.com with SMTP id v26-20020aa7d9da0000b02903bda706c753so1269842eds.18
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 04:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rnt5ZaRSzt63eqyUBTbbjjsGf45vaJy5/1TJ1ezkZLk=;
        b=KVrINOqrEsJtKc0bGibG3zPLP6wN29ou6pIalrd9ncj9gmZfnSwg1PtKHkDvRbtglG
         HLihtKaIULH/1ceGTpvPeWIfnjKhzgwK7eu+9LmZTRZ5F9FA/jTn/jX19qVhub+RFARF
         Tq/JMl76hhJ/NMzNKEDZIe9oScRIpLSa+GlaBgOaIssDq5KzCkSihvtPD3WDgiIIfBBK
         qgFyO5MUpkFcnNB0P0jwKvCBQI50U3vFNxwJfWMZYsJzQBcR5+whfE9t6yisv4VQOVh/
         mjcmY35eVhltvEQBc3LeWIuR+onh76qVHzYNDLOchmoQh4p+2jpaZt/99s/I5Qajvbnr
         NmHw==
X-Gm-Message-State: AOAM530IM6+IggKIaM+7Uf6Gv/Rr1aYNdYN4JLotv3FOSZl944BDvmKq
        hqhUnmyK8XYT+81EoHMNwiFTPkBnwTE2PUBRlBzdQ3K9gyp3nC9Yxc/i8xDVzwvWp5ItWp1p5eG
        q19ApIYk9yanN
X-Received: by 2002:a05:6402:54f:: with SMTP id i15mr31989381edx.24.1628075134245;
        Wed, 04 Aug 2021 04:05:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS4p3ENgdD1bgF3e5dt67UzKynIo/dHcoz5HtKGCku7hd1z7A3W28yIRV1jMz1nmg6VChtpQ==
X-Received: by 2002:a05:6402:54f:: with SMTP id i15mr31989360edx.24.1628075134079;
        Wed, 04 Aug 2021 04:05:34 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id cf16sm795519edb.92.2021.08.04.04.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:05:33 -0700 (PDT)
Date:   Wed, 4 Aug 2021 13:05:31 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 19/21] KVM: arm64: Emulate physical counter offsetting
 on non-ECV systems
Message-ID: <20210804110531.x6gm2bpygg7laiau@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-20-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804085819.846610-20-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 08:58:17AM +0000, Oliver Upton wrote:
> Unfortunately, ECV hasn't yet arrived in any tangible hardware. At the
> same time, controlling the guest view of the physical counter-timer is
> useful. Support guest counter-timer offsetting on non-ECV systems by
> trapping guest accesses to the physical counter-timer. Emulate reads of
> the physical counter in the fast exit path.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h         |  1 +
>  arch/arm64/kvm/arch_timer.c             | 53 +++++++++++++++----------
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 29 ++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 11 ++++-
>  4 files changed, 70 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index c34672aa65b9..e49790ae5da4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -505,6 +505,7 @@
>  #define SYS_AMEVCNTR0_MEM_STALL		SYS_AMEVCNTR0_EL0(3)
>  
>  #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
> +#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
>  
>  #define SYS_CNTP_TVAL_EL0		sys_reg(3, 3, 14, 2, 0)
>  #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 9ead94aa867d..b7cb63acf2a0 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -51,7 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>  static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>  			      struct arch_timer_context *timer,
>  			      enum kvm_arch_timer_regs treg);
> -static void kvm_timer_enable_traps_vhe(void);
> +static void kvm_timer_enable_traps_vhe(struct kvm_vcpu *vcpu);
>  
>  u32 timer_get_ctl(struct arch_timer_context *ctxt)
>  {
> @@ -175,6 +175,12 @@ static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
>  	}
>  }
>  
> +static bool ptimer_emulation_required(struct kvm_vcpu *vcpu)
> +{
> +	return timer_get_offset(vcpu_ptimer(vcpu)) &&
> +			!cpus_have_const_cap(ARM64_ECV);

Whenever I see a static branch check and something else in the same
condition, I always wonder if we could trim a few instructions for
the static branch is false case by testing it first.

> +}
> +
>  u64 kvm_phys_timer_read(void)
>  {
>  	return timecounter->cc->read(timecounter->cc);
> @@ -184,8 +190,13 @@ static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
>  {
>  	if (has_vhe()) {
>  		map->direct_vtimer = vcpu_vtimer(vcpu);
> -		map->direct_ptimer = vcpu_ptimer(vcpu);
> -		map->emul_ptimer = NULL;
> +		if (!ptimer_emulation_required(vcpu)) {
> +			map->direct_ptimer = vcpu_ptimer(vcpu);
> +			map->emul_ptimer = NULL;
> +		} else {
> +			map->direct_ptimer = NULL;
> +			map->emul_ptimer = vcpu_ptimer(vcpu);
> +		}
>  	} else {
>  		map->direct_vtimer = vcpu_vtimer(vcpu);
>  		map->direct_ptimer = NULL;
> @@ -671,7 +682,7 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>  		timer_emulate(map.emul_ptimer);
>  
>  	if (has_vhe())
> -		kvm_timer_enable_traps_vhe();
> +		kvm_timer_enable_traps_vhe(vcpu);
>  }
>  
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -1392,22 +1403,29 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
>   * and this makes those bits have no effect for the host kernel execution.
>   */
> -static void kvm_timer_enable_traps_vhe(void)
> +static void kvm_timer_enable_traps_vhe(struct kvm_vcpu *vcpu)
>  {
>  	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
>  	u32 cnthctl_shift = 10;
> -	u64 val;
> +	u64 val, mask;
> +
> +	mask = CNTHCTL_EL1PCEN << cnthctl_shift;
> +	mask |= CNTHCTL_EL1PCTEN << cnthctl_shift;
>  
> -	/*
> -	 * VHE systems allow the guest direct access to the EL1 physical
> -	 * timer/counter.
> -	 */
>  	val = read_sysreg(cnthctl_el2);
> -	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
> -	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
>  
>  	if (cpus_have_const_cap(ARM64_ECV))
>  		val |= CNTHCTL_ECV;
> +
> +	/*
> +	 * VHE systems allow the guest direct access to the EL1 physical
> +	 * timer/counter if offsetting isn't requested on a non-ECV system.
> +	 */
> +	if (ptimer_emulation_required(vcpu))
> +		val &= ~mask;
> +	else
> +		val |= mask;
> +
>  	write_sysreg(val, cnthctl_el2);
>  }
>  
> @@ -1462,9 +1480,6 @@ static int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu,
>  	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>  	u64 offset;
>  
> -	if (!cpus_have_const_cap(ARM64_ECV))
> -		return -ENXIO;
> -
>  	if (get_user(offset, uaddr))
>  		return -EFAULT;
>  
> @@ -1513,9 +1528,6 @@ static int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu,
>  	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>  	u64 offset;
>  
> -	if (!cpus_have_const_cap(ARM64_ECV))
> -		return -ENXIO;
> -
>  	offset = timer_get_offset(vcpu_ptimer(vcpu));
>  	return put_user(offset, uaddr);
>  }
> @@ -1539,11 +1551,8 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
>  	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> -		return 0;
>  	case KVM_ARM_VCPU_TIMER_OFFSET:
> -		if (cpus_have_const_cap(ARM64_ECV))
> -			return 0;
> -		break;
> +		return 0;

So now, if userspace wants to know when they're using an emulated
TIMER_OFFSET vs. ECV, then they'll need to check the HWCAP. I guess
that's fair. We should update the selftest to report what it's testing
when the HWCAP is available.

>  	}
>  
>  	return -ENXIO;
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e4a2f295a394..abd3813a709e 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -15,6 +15,7 @@
>  #include <linux/jump_label.h>
>  #include <uapi/linux/psci.h>
>  
> +#include <kvm/arm_arch_timer.h>
>  #include <kvm/arm_psci.h>
>  
>  #include <asm/barrier.h>
> @@ -405,6 +406,31 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static inline u64 __timer_read_cntpct(struct kvm_vcpu *vcpu)
> +{
> +	return __arch_counter_get_cntpct() - vcpu_ptimer(vcpu)->host_offset;
> +}
> +
> +static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
> +{
> +	u32 sysreg;
> +	int rt;
> +	u64 rv;
> +
> +	if (kvm_vcpu_trap_get_class(vcpu) != ESR_ELx_EC_SYS64)
> +		return false;
> +
> +	sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> +	if (sysreg != SYS_CNTPCT_EL0)
> +		return false;
> +
> +	rt = kvm_vcpu_sys_get_rt(vcpu);
> +	rv = __timer_read_cntpct(vcpu);
> +	vcpu_set_reg(vcpu, rt, rv);
> +	__kvm_skip_instr(vcpu);
> +	return true;
> +}
> +
>  /*
>   * Return true when we were able to fixup the guest exit and should return to
>   * the guest, false when we should restore the host state and return to the
> @@ -439,6 +465,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	if (*exit_code != ARM_EXCEPTION_TRAP)
>  		goto exit;
>  
> +	if (__hyp_handle_counter(vcpu))
> +		goto guest;
> +
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
>  	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
>  	    handle_tx2_tvm(vcpu))
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> index 5b8b4cd02506..67236c2e0ba7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -44,10 +44,17 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
>  
>  	/*
>  	 * Disallow physical timer access for the guest
> -	 * Physical counter access is allowed
>  	 */
>  	val = read_sysreg(cnthctl_el2);
>  	val &= ~CNTHCTL_EL1PCEN;
> -	val |= CNTHCTL_EL1PCTEN;
> +
> +	/*
> +	 * Disallow physical counter access for the guest if offsetting is
> +	 * requested on a non-ECV system.
> +	 */
> +	if (vcpu_ptimer(vcpu)->host_offset && !cpus_have_const_cap(ARM64_ECV))

Shouldn't we expose and reuse ptimer_emulation_required() here?

> +		val &= ~CNTHCTL_EL1PCTEN;
> +	else
> +		val |= CNTHCTL_EL1PCTEN;
>  	write_sysreg(val, cnthctl_el2);
>  }
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

