Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17A56DC895
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjDJPfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDJPfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:35:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78715BAB
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:34:46 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a2104d8b00so332355ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681140886; x=1683732886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5B8WOLUO5bkG5KJUoHhJ2LLIwuNgHJHj1AC8T37BCc=;
        b=STUo2BLfBRIOLevbIcQ9agTqxEEXS6G+kHcy0khrvExBZf7aSAxCXzxMk6w4oa3pnJ
         /FGxPlO0HChcypcBW7aQ52fl14+PdyzyixFtrZNyRcilearwW4KpleQOTVXxEA5TSjXE
         ydaxWMH1YcjyNRUq/p52o6eF+CquTCMZWhJU5y83JC97pw7Oy55XigHqWrl2ISnIM+3J
         ZH9ZMVchHTQg7CiD1eGNBbWTr06fDMq8pViro+A9Ysx/Zl3DvucNw+WAqALGc/V/98Js
         BPuAaJt3COPKNJnfTsiwon78kfN/UXtkvjDGu/p9QTu+l1Xe4bULJSy69LITtbT4JzwF
         w0Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681140886; x=1683732886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5B8WOLUO5bkG5KJUoHhJ2LLIwuNgHJHj1AC8T37BCc=;
        b=j+srBYqOno2jRa/p9gNU/qNRPzVJcq/yLm5/EE5rTvDXAhPEpnbzDEooOr+DFnA/5t
         cJ2EJrlX4SlvNG1B1zJgg7sC5N4YTSxW3hsE7bSapzNyvjQzHiWeqqdJUus+fJjrScLU
         PhQ5ngFKkdfKcWGHiWAhn7IQN7FN/xhpCT5ee9DJAUwEDIi5DCneOB2zD/TOMVnbAYbq
         4aCPH2oe5Owp7BwPcQnfnYG0p3QymIJ2fhkNRtrmj/gAdBErNaD8jJ1t+n73trbyCyr5
         R5n290lSK2xgyoiM0w5+8EuYWopXs7eq0gz4Sv3IYwwcnN6vdqJEOhgJ2n+OcRLqAcI8
         qfJQ==
X-Gm-Message-State: AAQBX9f0XMdk0GhUhXRXNdwFKJ54f2JCcdQpYzFA8ttaCnv2Hs9XqAtK
        0XAOeXh9ALuH0Zlb3Hk3betzMw==
X-Google-Smtp-Source: AKy350bDpAiRoM3P1ElDc+eukU/YFhcf7QH9EkUzPIfrdGKe6BHvUg1bBw2scNVOR8srw2Dmip2v3A==
X-Received: by 2002:a17:903:1358:b0:198:af4f:de0b with SMTP id jl24-20020a170903135800b00198af4fde0bmr452964plb.11.1681140886054;
        Mon, 10 Apr 2023 08:34:46 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id jh3-20020a170903328300b001963a178dfcsm6039218plb.244.2023.04.10.08.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 08:34:45 -0700 (PDT)
Date:   Mon, 10 Apr 2023 08:34:41 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: Re: [PATCH v4 05/20] KVM: arm64: timers: Allow physical offset
 without CNTPOFF_EL2
Message-ID: <20230410153441.vddskgxu2zzsi7bq@google.com>
References: <20230330174800.2677007-1-maz@kernel.org>
 <20230330174800.2677007-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330174800.2677007-6-maz@kernel.org>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Mar 30, 2023 at 06:47:45PM +0100, Marc Zyngier wrote:
> CNTPOFF_EL2 is awesome, but it is mostly vapourware, and no publicly
> available implementation has it. So for the common mortals, let's
> implement the emulated version of this thing.
> 
> It means trapping accesses to the physical counter and timer, and
> emulate some of it as necessary.
> 
> As for CNTPOFF_EL2, nobody sets the offset yet.
> 
> Reviewed-by: Colton Lewis <coltonlewis@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h    |  2 +
>  arch/arm64/kvm/arch_timer.c        | 98 +++++++++++++++++++++++-------
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c | 18 ++++--
>  arch/arm64/kvm/sys_regs.c          |  9 +++
>  4 files changed, 98 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9e3ecba3c4e6..f8da9e1b0c11 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -388,6 +388,7 @@
>  
>  #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
>  
> +#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
>  #define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
>  #define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
>  
> @@ -400,6 +401,7 @@
>  
>  #define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
>  #define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
> +#define SYS_AARCH32_CNTPCT		sys_reg(0, 0, 0, 14, 0)
>  #define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
>  
>  #define __PMEV_op2(n)			((n) & 0x7)
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3118ea0a1b41..bb64a71ae193 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -458,6 +458,8 @@ static void timer_save_state(struct arch_timer_context *ctx)
>  		goto out;
>  
>  	switch (index) {
> +		u64 cval;
> +
>  	case TIMER_VTIMER:
>  		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
>  		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
> @@ -485,7 +487,12 @@ static void timer_save_state(struct arch_timer_context *ctx)
>  		break;
>  	case TIMER_PTIMER:
>  		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
> -		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTP_CVAL));
> +		cval = read_sysreg_el0(SYS_CNTP_CVAL);
> +
> +		if (!has_cntpoff())
> +			cval -= timer_get_offset(ctx);
> +
> +		timer_set_cval(ctx, cval);
>  
>  		/* Disable the timer */
>  		write_sysreg_el0(0, SYS_CNTP_CTL);
> @@ -555,6 +562,8 @@ static void timer_restore_state(struct arch_timer_context *ctx)
>  		goto out;
>  
>  	switch (index) {
> +		u64 cval, offset;
> +
>  	case TIMER_VTIMER:
>  		set_cntvoff(timer_get_offset(ctx));
>  		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
> @@ -562,8 +571,12 @@ static void timer_restore_state(struct arch_timer_context *ctx)
>  		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
>  		break;
>  	case TIMER_PTIMER:
> -		set_cntpoff(timer_get_offset(ctx));
> -		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
> +		cval = timer_get_cval(ctx);
> +		offset = timer_get_offset(ctx);
> +		set_cntpoff(offset);
> +		if (!has_cntpoff())
> +			cval += offset;
> +		write_sysreg_el0(cval, SYS_CNTP_CVAL);
>  		isb();
>  		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
>  		break;
> @@ -634,6 +647,61 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
>  		enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
>  }
>  
> +/* If _pred is true, set bit in _set, otherwise set it in _clr */
> +#define assign_clear_set_bit(_pred, _bit, _clr, _set)			\
> +	do {								\
> +		if (_pred)						\
> +			(_set) |= (_bit);				\
> +		else							\
> +			(_clr) |= (_bit);				\
> +	} while (0)
> +
> +static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
> +{
> +	bool tpt, tpc;
> +	u64 clr, set;
> +
> +	/*
> +	 * No trapping gets configured here with nVHE. See
> +	 * __timer_enable_traps(), which is where the stuff happens.
> +	 */
> +	if (!has_vhe())
> +		return;
> +
> +	/*
> +	 * Our default policy is not to trap anything. As we progress
> +	 * within this function, reality kicks in and we start adding
> +	 * traps based on emulation requirements.
> +	 */
> +	tpt = tpc = false;
> +
> +	/*
> +	 * We have two possibility to deal with a physical offset:
> +	 *
> +	 * - Either we have CNTPOFF (yay!) or the offset is 0:
> +	 *   we let the guest freely access the HW
> +	 *
> +	 * - or neither of these condition apply:
> +	 *   we trap accesses to the HW, but still use it
> +	 *   after correcting the physical offset
> +	 */
> +	if (!has_cntpoff() && timer_get_offset(map->direct_ptimer))
> +		tpt = tpc = true;
> +
> +	/*
> +	 * Now that we have collected our requirements, compute the
> +	 * trap and enable bits.
> +	 */
> +	set = 0;
> +	clr = 0;
> +
> +	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
> +	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);

Nit: IMHO the way the code specifies the 'set' and 'clr' arguments for
the macro might be a bit confusing ('set' is for '_clr', and 'clr' is
for '_set')?
Perhaps changing the parameter names of assign_clear_set_bit() like
below or flipping the condition (i.e. Specify !tpt or no_tpt instead
of tpt) might be less confusing?

#define assign_clear_set_bit(_pred, _bit, _t_val, _f_val)	\
do {								\
	if (_pred)						\
		(_t_val) |= (_bit);				\
	else							\
		(_f_val) |= (_bit);				\
} while (0)


> +
> +	/* This only happens on VHE, so use the CNTKCTL_EL1 accessor */
> +	sysreg_clear_set(cntkctl_el1, clr, set);
> +}
> +
>  void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
> @@ -657,9 +725,10 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>  	timer_restore_state(map.direct_vtimer);
>  	if (map.direct_ptimer)
>  		timer_restore_state(map.direct_ptimer);
> -
>  	if (map.emul_ptimer)
>  		timer_emulate(map.emul_ptimer);
> +
> +	timer_set_traps(vcpu, &map);
>  }
>  
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -1292,28 +1361,11 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -/*
> - * On VHE system, we only need to configure the EL2 timer trap register once,
> - * not for every world switch.
> - * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
> - * and this makes those bits have no effect for the host kernel execution.
> - */
> +/* If we have CNTPOFF, permanently set ECV to enable it */
>  void kvm_timer_init_vhe(void)
>  {
> -	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
> -	u32 cnthctl_shift = 10;
> -	u64 val;
> -
> -	/*
> -	 * VHE systems allow the guest direct access to the EL1 physical
> -	 * timer/counter.
> -	 */
> -	val = read_sysreg(cnthctl_el2);
> -	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
> -	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
>  	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
> -		val |= CNTHCTL_ECV;
> -	write_sysreg(val, cnthctl_el2);
> +		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
>  }
>  
>  static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> index 9072e71693ba..b185ac0dbd47 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -9,6 +9,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>
>  
>  void __kvm_timer_set_cntvoff(u64 cntvoff)
>  {
> @@ -35,14 +36,19 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
>   */
>  void __timer_enable_traps(struct kvm_vcpu *vcpu)
>  {
> -	u64 val;
> +	u64 clr = 0, set = 0;
>  
>  	/*
>  	 * Disallow physical timer access for the guest
> -	 * Physical counter access is allowed
> +	 * Physical counter access is allowed if no offset is enforced
> +	 * or running protected (we don't offset anything in this case).
>  	 */
> -	val = read_sysreg(cnthctl_el2);
> -	val &= ~CNTHCTL_EL1PCEN;
> -	val |= CNTHCTL_EL1PCTEN;
> -	write_sysreg(val, cnthctl_el2);
> +	clr = CNTHCTL_EL1PCEN;

Nit: Perhaps "clr |= CNTHCTL_EL1PCEN;" would be more
straightforward (or initialize 'clr' to CNTHCTL_EL1PCEN ?).

> +	if (is_protected_kvm_enabled() ||
> +	    !kern_hyp_va(vcpu->kvm)->arch.timer_data.poffset)
> +		set |= CNTHCTL_EL1PCTEN;
> +	else
> +		clr |= CNTHCTL_EL1PCTEN;
> +
> +	sysreg_clear_set(cnthctl_el2, clr, set);
>  }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 53749d3a0996..be7c2598e563 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1139,6 +1139,12 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  		tmr = TIMER_PTIMER;
>  		treg = TIMER_REG_CVAL;
>  		break;
> +	case SYS_CNTPCT_EL0:
> +	case SYS_CNTPCTSS_EL0:
> +	case SYS_AARCH32_CNTPCT:
> +		tmr = TIMER_PTIMER;
> +		treg = TIMER_REG_CNT;
> +		break;
>  	default:
>  		print_sys_reg_msg(p, "%s", "Unhandled trapped timer register");
>  		kvm_inject_undefined(vcpu);
> @@ -2075,6 +2081,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	AMU_AMEVTYPER1_EL0(14),
>  	AMU_AMEVTYPER1_EL0(15),
>  
> +	{ SYS_DESC(SYS_CNTPCT_EL0), access_arch_timer },
> +	{ SYS_DESC(SYS_CNTPCTSS_EL0), access_arch_timer },
>  	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
>  	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
>  	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
> @@ -2525,6 +2533,7 @@ static const struct sys_reg_desc cp15_64_regs[] = {
>  	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR0_EL1 },
>  	{ CP15_PMU_SYS_REG(DIRECT, 0, 0, 9, 0), .access = access_pmu_evcntr },
>  	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI1R */
> +	{ SYS_DESC(SYS_AARCH32_CNTPCT),	      access_arch_timer },

Shouldn't KVM also emulate CNTPCTSS (Aarch32) when its trapping is
enabled on the host with ECV_CNTPOFF ?


>  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
>  	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
>  	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
> -- 
> 2.34.1
> 
> 

Nit: In emulating reading physical counter/timer for direct_ptimer
(poffset != 0 on VHE without ECV_CNTPOFF), it appears that
kvm_arm_timer_read_sysreg() unnecessarily calls
timer_{save,restore}_state(), and kvm_arm_timer_write_sysreg()
unnecessarily calls timer_save_state().  Couldn't we skip those
unnecessary calls ? (I didn't check all the following patches, but
the current code would be more convenient in the following patches ?)

Thank you,
Reiji

