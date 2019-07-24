Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75D173052
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 15:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfGXN4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 09:56:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33205 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfGXN4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 09:56:38 -0400
Received: by mail-lj1-f193.google.com with SMTP id h10so44619890ljg.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 06:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=54j3Rj1BXvYBjlVWokMkDuv8Oaagn4PllYy8yHElvpY=;
        b=NwZd6yqTUcteXpUZ0IGi33Soy/VPvyQzZ//L8nseZ2jkBr5cmxpituFU0uUN8X0zGy
         nwKaovJdV3763+hbbhbIArizrT86nxgiRscQKYUZiJ8WAr+3Y//LRvVDMXe9da6vmYSJ
         EU7GkkUGBUdRaT9bCIQkCHjyc5wH95o/ONyNMlbLoOz7XfRn9Q5YM8CRer0ziB+/ewXv
         TjClo7gCgUcE/jVq55UyQGOfZiYpEOnZuIckWX84vzCDOHpcBcXHIyx+pQkgruC55JTf
         88883q5PF/LlRsx4mh6kR1p1MiJqzAHWpCd4otRMU64nY0tiA0z3XRDb9/OY+69RB0fe
         R/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=54j3Rj1BXvYBjlVWokMkDuv8Oaagn4PllYy8yHElvpY=;
        b=bWa9Ys8RGQL6oo5vkQqQo2czyrr5FMal4DUgxtJ2QXW2bBYVVJVvruFngtQpJyXPzo
         D1nfYRqwQICSFLdyj9gmFFdrpyAe+o2ox9v8RQYMvE3HkYf7KIYE2rYyfgOvUerZqIo7
         oplp5Vs8BHsJzvpS2mpT4BmSKAv4cCSmw9vnj/d4d0FmIUtS5q52k0/6sFr5iCMR5t2X
         An+TXZTdw0RBlPku/HuoBCokHQjkUyBXkpkMM1CvQgc474CRM6TUyvMeHkdHD27kkaZS
         PcFDGSDxUneG2cN+5yD1RercyUKSZMd5Pa777ekiWFrsOOt6Xto+/mSAexyr/HUo0bmC
         1f/g==
X-Gm-Message-State: APjAAAUVWMW2w+2I1+/lzaqTK5rUBv9qjqKCk9r4zh+BHkdvJL4O2qjq
        QN8SCoQzT/0ilL4qPuRBROk=
X-Google-Smtp-Source: APXvYqxO6yaPyMuq/MsVLMDvTjMxjWahFQFdCvdqAa57e+Yug9UF5euQajKuVL6dDDPv1F8dFEhYvw==
X-Received: by 2002:a2e:8396:: with SMTP id x22mr44283342ljg.135.1563976595050;
        Wed, 24 Jul 2019 06:56:35 -0700 (PDT)
Received: from [192.168.1.9] ([83.68.95.66])
        by smtp.googlemail.com with ESMTPSA id r17sm8675692ljc.85.2019.07.24.06.56.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 06:56:34 -0700 (PDT)
Subject: Re: [PATCH 43/59] KVM: arm64: nv: Trap and emulate AT instructions
 from virtual EL2
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-44-marc.zyngier@arm.com>
 <0411c636-adbd-98d0-5191-2b073daaf68e@semihalf.com>
 <327dfc0e-e7c9-0d18-2615-1db5b05121f4@arm.com>
From:   Tomasz Nowicki <tn@semihalf.com>
Message-ID: <5b4719fc-d189-41fa-cb64-9a731a80bf7e@semihalf.com>
Date:   Wed, 24 Jul 2019 15:56:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <327dfc0e-e7c9-0d18-2615-1db5b05121f4@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.07.2019 14:39, Marc Zyngier wrote:
> On 24/07/2019 11:25, Tomasz Nowicki wrote:
>> On 21.06.2019 11:38, Marc Zyngier wrote:
>>> From: Jintack Lim <jintack.lim@linaro.org>
>>>
>>> When supporting nested virtualization a guest hypervisor executing AT
>>> instructions must be trapped and emulated by the host hypervisor,
>>> because untrapped AT instructions operating on S1E1 will use the wrong
>>> translation regieme (the one used to emulate virtual EL2 in EL1 instead
>>> of virtual EL1) and AT instructions operating on S12 will not work from
>>> EL1.
>>>
>>> This patch does several things.
>>>
>>> 1. List and define all AT system instructions to emulate and document
>>> the emulation design.
>>>
>>> 2. Implement AT instruction handling logic in EL2. This will be used to
>>> emulate AT instructions executed in the virtual EL2.
>>>
>>> AT instruction emulation works by loading the proper processor
>>> context, which depends on the trapped instruction and the virtual
>>> HCR_EL2, to the EL1 virtual memory control registers and executing AT
>>> instructions. Note that ctxt->hw_sys_regs is expected to have the
>>> proper processor context before calling the handling
>>> function(__kvm_at_insn) implemented in this patch.
>>>
>>> 4. Emulate AT S1E[01] instructions by issuing the same instructions in
>>> EL2. We set the physical EL1 registers, NV and NV1 bits as described in
>>> the AT instruction emulation overview.
>>>
>>> 5. Emulate AT A12E[01] instructions in two steps: First, do the stage-1
>>> translation by reusing the existing AT emulation functions.  Second, do
>>> the stage-2 translation by walking the guest hypervisor's stage-2 page
>>> table in software. Record the translation result to PAR_EL1.
>>>
>>> 6. Emulate AT S1E2 instructions by issuing the corresponding S1E1
>>> instructions in EL2. We set the physical EL1 registers and the HCR_EL2
>>> register as described in the AT instruction emulation overview.
>>>
>>> 7. Forward system instruction traps to the virtual EL2 if the corresponding
>>> virtual AT bit is set in the virtual HCR_EL2.
>>>
>>>     [ Much logic above has been reworked by Marc Zyngier ]
>>>
>>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_arm.h |   2 +
>>>    arch/arm64/include/asm/kvm_asm.h |   2 +
>>>    arch/arm64/include/asm/sysreg.h  |  17 +++
>>>    arch/arm64/kvm/hyp/Makefile      |   1 +
>>>    arch/arm64/kvm/hyp/at.c          | 217 +++++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/hyp/switch.c      |  13 +-
>>>    arch/arm64/kvm/sys_regs.c        | 202 +++++++++++++++++++++++++++-
>>>    7 files changed, 450 insertions(+), 4 deletions(-)
>>>    create mode 100644 arch/arm64/kvm/hyp/at.c
>>>
>>
>> [...]
>>
>>> +
>>> +void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>>> +{
>>> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
>>> +	struct mmu_config config;
>>> +	struct kvm_s2_mmu *mmu;
>>> +
>>> +	/*
>>> +	 * We can only get here when trapping from vEL2, so we're
>>> +	 * translating a guest guest VA.
>>> +	 *
>>> +	 * FIXME: Obtaining the S2 MMU for a a guest guest is horribly
>>> +	 * racy, and we may not find it.
>>> +	 */
>>> +	spin_lock(&vcpu->kvm->mmu_lock);
>>> +
>>> +	mmu = lookup_s2_mmu(vcpu->kvm,
>>> +			    vcpu_read_sys_reg(vcpu, VTTBR_EL2),
>>> +			    vcpu_read_sys_reg(vcpu, HCR_EL2));
>>> +
>>> +	if (WARN_ON(!mmu))
>>> +		goto out;
>>> +
>>> +	/* We've trapped, so everything is live on the CPU. */
>>> +	__mmu_config_save(&config);
>>> +
>>> +	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
>>> +	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
>>> +	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
>>> +	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
>>> +	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
>>> +	/* FIXME: write S2 MMU VTCR_EL2 */
>>> +	write_sysreg(config.hcr & ~HCR_TGE,		hcr_el2);
>>
>> All below AT S1E* operations may initiate stage-1 PTW. And stage-1 table
>> walk addresses are themselves subject to stage-2 translation.
>>
>> So should we enable stage-2 translation here by setting HCR_VM bit?
> 
> Hopefully that's already the case, otherwise nothing works. Have you
> verified that it is actually clear at this stage?

Yes, HCR_EL2.VM is clear at this stage (cleared during guest exit when 
deactivating traps). The weird thing is that my Fastmodel is still 
working with HCR_EL2.VM=0 here and this path is being exercised.

Thanks,
Tomasz

