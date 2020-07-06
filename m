Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C1421575B
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 14:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgGFMfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 08:35:07 -0400
Received: from foss.arm.com ([217.140.110.172]:36136 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgGFMfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 08:35:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1F401FB;
        Mon,  6 Jul 2020 05:35:06 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BE003F68F;
        Mon,  6 Jul 2020 05:35:04 -0700 (PDT)
Subject: Re: [PATCH v2 06/17] KVM: arm64: Introduce accessor for ctxt->sys_reg
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-7-maz@kernel.org>
 <a9c3a43e-7850-e74d-5383-905885721ab4@arm.com>
 <2595cd556bcb8bd996f60ef527b512ef@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <35289626-8ad8-7802-1910-7677359932f4@arm.com>
Date:   Mon, 6 Jul 2020 13:35:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2595cd556bcb8bd996f60ef527b512ef@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/6/20 1:15 PM, Marc Zyngier wrote:
> Hi Alex,
>
> On 2020-06-26 16:39, Alexandru Elisei wrote:
>> Hi,
>>
>> On 6/15/20 2:27 PM, Marc Zyngier wrote:
>>> In order to allow the disintegration of the per-vcpu sysreg array,
>>> let's introduce a new helper (ctxt_sys_reg()) that returns the
>>> in-memory copy of a system register, picked from a given context.
>>>
>>> __vcpu_sys_reg() is rewritten to use this helper.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
>>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h
>>> b/arch/arm64/include/asm/kvm_host.h
>>> index e7fd03271e52..5314399944e7 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -405,12 +405,17 @@ struct kvm_vcpu_arch {
>>>  #define vcpu_gp_regs(v)        (&(v)->arch.ctxt.gp_regs)
>>>
>>>  /*
>>> - * Only use __vcpu_sys_reg if you know you want the memory backed version of a
>>> - * register, and not the one most recently accessed by a running VCPU.  For
>>> - * example, for userspace access or for system registers that are never context
>>> - * switched, but only emulated.
>>> + * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
>>> + * memory backed version of a register, and not the one most recently
>>> + * accessed by a running VCPU.  For example, for userspace access or
>>> + * for system registers that are never context switched, but only
>>> + * emulated.
>>>   */
>>> -#define __vcpu_sys_reg(v,r)    ((v)->arch.ctxt.sys_regs[(r)])
>>> +#define __ctxt_sys_reg(c,r)    (&(c)->sys_regs[(r)])
>>> +
>>> +#define ctxt_sys_reg(c,r)    (*__ctxt_sys_reg(c,r))
>>> +
>>> +#define __vcpu_sys_reg(v,r)    (ctxt_sys_reg(&(v)->arch.ctxt, (r)))
>>
>> This is confusing - __vcpu_sys_reg() returns the value, but __ctxt_sys_reg()
>> return a pointer to the value. Because of that, I made the mistake of thinking
>> that __vcpu_sys_reg() returns a pointer when reviewing the next patch in the
>> series, and I got really worried that stuff was seriously broken (it was not).
>
> This is intentional (the behaviour, not the confusing aspect... ;-), as
> __ctx_sys_reg() gets further rewritten as such:
>
> -#define __ctxt_sys_reg(c,r)    (&(c)->sys_regs[(r)])
> +static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
> +{
> +    if (unlikely(r >= __VNCR_START__ && ctxt->vncr_array))
> +        return &ctxt->vncr_array[r - __VNCR_START__];
> +
> +    return (u64 *)&ctxt->sys_regs[r];
> +}
>
> to deal with the VNCR page (depending on whether you use nesting or not,
> the sysreg is backed by the VNCR page or the usual sysreg array).
>
> To be clear, there shouldn't be much use of __ctxt_sys_reg (there is only
> 3 in the current code), all for good reasons (core_reg_addr definitely
> wants the address of a register).
>
>> I'm not sure what the reasonable solution is, or even if there is one.
>>
>> Some thoughts: we could have just one macro, ctxt_sys_reg() and dereference that
>> when we want the value; we could keep both and swap the macro definitions; or we
>> could encode the fact that a macro returns a pointer in the macro name (so we
>> would end up with __ctxt_sys_reg() -> __ctxt_sys_regp() and ctxt_sys_reg ->
>> __ctxt_sys_reg()).
>>
>> What do you think?
>
> I'm not opposed to any of this, provided that it doesn't create
> unnecessary churn and additional confusion. I'll keep it as such
> in the meantime, but I'm definitely willing to take a patch going
> over this if you think this is necessary.

That sounds very reasonable. I'll put it on my TODO list and I'll give it another
look after the series is merged.

Thanks,
Alex
