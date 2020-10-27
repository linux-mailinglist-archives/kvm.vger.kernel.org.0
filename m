Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5799729C2F0
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821237AbgJ0Rlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:41:32 -0400
Received: from foss.arm.com ([217.140.110.172]:48704 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1821232AbgJ0Rla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:41:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D58D139F;
        Tue, 27 Oct 2020 10:41:30 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B55DF3F719;
        Tue, 27 Oct 2020 10:41:28 -0700 (PDT)
Subject: Re: [PATCH 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-9-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <b4ef5e3e-a1a4-948f-bc9d-4bd297cb26a6@arm.com>
Date:   Tue, 27 Oct 2020 17:41:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026133450.73304-9-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 26/10/2020 13:34, Marc Zyngier wrote:
> Similarily to what has been done for AArch64, move the AArch32 exception
> inhjection to HYP.
> 
> In order to not use the regmap selection code at EL2, simplify the code
> populating the target mode's LR register by harcoding the two possible
> LR registers (LR_abt in X20, LR_und in X22).


> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index cd6e643639e8..8d1d1bcd9e69 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -57,10 +67,25 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)

> +static inline u32 __vcpu_read_cp15(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	return __vcpu_read_sys_reg(vcpu, reg / 2);
> +}

Doesn't this re-implement the issue 3204be4109ad biased?


> @@ -155,23 +180,189 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,

> +static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
> +{

> +	/*
> +	 * Table D1-27 of DDI 0487F.c shows the GPR mapping between
> +	 * AArch32 and AArch64. We only deal with ABT/UND.

(to check I understand : because these are the only two KVM ever injects?)


> +	 */
> +	switch(mode) {
> +	case PSR_AA32_MODE_ABT:
> +		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
> +		lr = 20;
>  		break;
> +		

(two bonus tabs!)


> +	case PSR_AA32_MODE_UND:
> +		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
> +		lr = 22;
>  		break;
>  	}> +
> +	vcpu_set_reg(vcpu, lr, *vcpu_pc(vcpu) + return_offset);


Can we, abuse, the compat_lr_abt definitions to do something like:

|	u32 return_address = *vcpu_pc(vcpu) + return_offset;
[..]
|	switch(mode) {
|	case PSR_AA32_MODE_ABT:>
|		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
|		vcpu_gp_regs(vcpu)->compat_lr_abt = return_address;
|		break;
|	case PSR_AA32_MODE_UND:
|		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
|		vcpu_gp_regs(vcpu)->compat_lr_und = return_address;
|		break;

...as someone who has no clue about 32bit, this hides all the worrying magic-14==magic-22!



Thanks,

James

> +}
