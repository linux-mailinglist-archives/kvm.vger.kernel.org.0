Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7226B9F0
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 12:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfGQKTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 06:19:47 -0400
Received: from foss.arm.com ([217.140.110.172]:45536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfGQKTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 06:19:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C88F428;
        Wed, 17 Jul 2019 03:19:44 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F31903F71A;
        Wed, 17 Jul 2019 03:19:43 -0700 (PDT)
Subject: Re: [PATCH 55/59] arm64: KVM: nv: Add handling of EL2-specific timer
 registers
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-56-marc.zyngier@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9dca3fa9-e02b-ad4a-f9d0-0d637177b932@arm.com>
Date:   Wed, 17 Jul 2019 11:19:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-56-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/19 10:38 AM, Marc Zyngier wrote:
> Add the required handling for EL2 and EL02 registers, as
> well as EL1 registers used in the E2H context.

Shouldn't that be "[..] EL0 registers used in E2H context"?

Thanks,
Alex
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 72 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ba3bcd29c02d..0bd6a66b621e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1361,20 +1361,92 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  
>  	switch (reg) {
>  	case SYS_CNTP_TVAL_EL0:
> +		if (vcpu_mode_el2(vcpu) && vcpu_el2_e2h_is_set(vcpu))
> +			tmr = TIMER_HPTIMER;
> +		else
> +			tmr = TIMER_PTIMER;
> +		treg = TIMER_REG_TVAL;
> +		break;
> +
>  	case SYS_AARCH32_CNTP_TVAL:
> +	case SYS_CNTP_TVAL_EL02:
>  		tmr = TIMER_PTIMER;
>  		treg = TIMER_REG_TVAL;
>  		break;
> +
> +	case SYS_CNTV_TVAL_EL02:
> +		tmr = TIMER_VTIMER;
> +		treg = TIMER_REG_TVAL;
> +		break;
> +
> +	case SYS_CNTHP_TVAL_EL2:
> +		tmr = TIMER_HPTIMER;
> +		treg = TIMER_REG_TVAL;
> +		break;
> +
> +	case SYS_CNTHV_TVAL_EL2:
> +		tmr = TIMER_HVTIMER;
> +		treg = TIMER_REG_TVAL;
> +		break;
> +
>  	case SYS_CNTP_CTL_EL0:
> +		if (vcpu_mode_el2(vcpu) && vcpu_el2_e2h_is_set(vcpu))
> +			tmr = TIMER_HPTIMER;
> +		else
> +			tmr = TIMER_PTIMER;
> +		treg = TIMER_REG_CTL;
> +		break;
> +
>  	case SYS_AARCH32_CNTP_CTL:
> +	case SYS_CNTP_CTL_EL02:
>  		tmr = TIMER_PTIMER;
>  		treg = TIMER_REG_CTL;
>  		break;
> +
> +	case SYS_CNTV_CTL_EL02:
> +		tmr = TIMER_VTIMER;
> +		treg = TIMER_REG_CTL;
> +		break;
> +
> +	case SYS_CNTHP_CTL_EL2:
> +		tmr = TIMER_HPTIMER;
> +		treg = TIMER_REG_CTL;
> +		break;
> +
> +	case SYS_CNTHV_CTL_EL2:
> +		tmr = TIMER_HVTIMER;
> +		treg = TIMER_REG_CTL;
> +		break;
> +		
>  	case SYS_CNTP_CVAL_EL0:
> +		if (vcpu_mode_el2(vcpu) && vcpu_el2_e2h_is_set(vcpu))
> +			tmr = TIMER_HPTIMER;
> +		else
> +			tmr = TIMER_PTIMER;
> +		treg = TIMER_REG_CVAL;
> +		break;
> +
>  	case SYS_AARCH32_CNTP_CVAL:
> +	case SYS_CNTP_CVAL_EL02:
>  		tmr = TIMER_PTIMER;
>  		treg = TIMER_REG_CVAL;
>  		break;
> +
> +	case SYS_CNTV_CVAL_EL02:
> +		tmr = TIMER_VTIMER;
> +		treg = TIMER_REG_CVAL;
> +		break;
> +
> +	case SYS_CNTHP_CVAL_EL2:
> +		tmr = TIMER_HPTIMER;
> +		treg = TIMER_REG_CVAL;
> +		break;
> +
> +	case SYS_CNTHV_CVAL_EL2:
> +		tmr = TIMER_HVTIMER;
> +		treg = TIMER_REG_CVAL;
> +		break;
> +
>  	case SYS_CNTVOFF_EL2:
>  		tmr = TIMER_VTIMER;
>  		treg = TIMER_REG_VOFF;
