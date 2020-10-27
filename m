Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B597729C8A4
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 20:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829825AbgJ0TWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 15:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501930AbgJ0TV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 15:21:58 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4584D21556;
        Tue, 27 Oct 2020 19:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603826518;
        bh=0SBAd77pYFm4BteTna4tfs0VK/M8k+tKtAPPJZdQJ9w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AAFZkytz4Jdvx7ZpoxhVd7U0RcfoqiQfQ3Z8Pa0zUaE0GFOorH9qnBTo80s+A7wyN
         lRwE668TgEo7iYF4GsveFgqiID6tQeTLS77K0c9GIgaTtD4Pco9ZQCHfqoABqdGaD5
         Yz4bondg0X0w5cSOt82Hl5IyECJRW9OkDiq8a4q0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXUXc-004v5X-25; Tue, 27 Oct 2020 19:21:56 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 19:21:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: Re: [PATCH 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
In-Reply-To: <b4ef5e3e-a1a4-948f-bc9d-4bd297cb26a6@arm.com>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-9-maz@kernel.org>
 <b4ef5e3e-a1a4-948f-bc9d-4bd297cb26a6@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6b30a9c9d082aeabc6cb81aca97b5398@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-27 17:41, James Morse wrote:
> Hi Marc,
> 
> On 26/10/2020 13:34, Marc Zyngier wrote:
>> Similarily to what has been done for AArch64, move the AArch32 
>> exception
>> inhjection to HYP.
>> 
>> In order to not use the regmap selection code at EL2, simplify the 
>> code
>> populating the target mode's LR register by harcoding the two possible
>> LR registers (LR_abt in X20, LR_und in X22).
> 
> 
>> diff --git a/arch/arm64/kvm/hyp/exception.c 
>> b/arch/arm64/kvm/hyp/exception.c
>> index cd6e643639e8..8d1d1bcd9e69 100644
>> --- a/arch/arm64/kvm/hyp/exception.c
>> +++ b/arch/arm64/kvm/hyp/exception.c
>> @@ -57,10 +67,25 @@ static void __vcpu_write_spsr(struct kvm_vcpu 
>> *vcpu, u64 val)
> 
>> +static inline u32 __vcpu_read_cp15(const struct kvm_vcpu *vcpu, int 
>> reg)
>> +{
>> +	return __vcpu_read_sys_reg(vcpu, reg / 2);
>> +}
> 
> Doesn't this re-implement the issue 3204be4109ad biased?

I don't think it does. The issue existed when accessing the 32bit 
shadow,
and we had to pick which side of the 64bit register had our 32bit value.
Here, we directly access the 64bit file, which is safe.

But thinking of it, we may as well change the call sites to directly
use the 64bit enum, rather than playing games (we used to use the
32bit definition for the sake of the defunct 32bit port).

> 
> 
>> @@ -155,23 +180,189 @@ static void enter_exception64(struct kvm_vcpu 
>> *vcpu, unsigned long target_mode,
> 
>> +static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 
>> vect_offset)
>> +{
> 
>> +	/*
>> +	 * Table D1-27 of DDI 0487F.c shows the GPR mapping between
>> +	 * AArch32 and AArch64. We only deal with ABT/UND.
> 
> (to check I understand : because these are the only two KVM ever 
> injects?)

Yes, that's indeed the reason. I'll try to clarify.

> 
> 
>> +	 */
>> +	switch(mode) {
>> +	case PSR_AA32_MODE_ABT:
>> +		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
>> +		lr = 20;
>>  		break;
>> +
> 
> (two bonus tabs!)
> 
> 
>> +	case PSR_AA32_MODE_UND:
>> +		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
>> +		lr = 22;
>>  		break;
>>  	}> +
>> +	vcpu_set_reg(vcpu, lr, *vcpu_pc(vcpu) + return_offset);
> 
> 
> Can we, abuse, the compat_lr_abt definitions to do something like:
> 
> |	u32 return_address = *vcpu_pc(vcpu) + return_offset;
> [..]
> |	switch(mode) {
> |	case PSR_AA32_MODE_ABT:>
> |		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
> |		vcpu_gp_regs(vcpu)->compat_lr_abt = return_address;
> |		break;
> |	case PSR_AA32_MODE_UND:
> |		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
> |		vcpu_gp_regs(vcpu)->compat_lr_und = return_address;
> |		break;
> 
> ...as someone who has no clue about 32bit, this hides all the worrying
> magic-14==magic-22!

Ah, I totally forgot about them (the only use was in the file I delete
two patches later...)!

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
