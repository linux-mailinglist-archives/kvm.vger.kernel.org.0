Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828F35B6A8
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 10:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfGAISZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 04:18:25 -0400
Received: from foss.arm.com ([217.140.110.172]:57382 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfGAISZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 04:18:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FF132B;
        Mon,  1 Jul 2019 01:18:24 -0700 (PDT)
Received: from [10.1.35.148] (James-iPhone8.cambridge.arm.com [10.1.35.148])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0C583F718;
        Mon,  1 Jul 2019 01:18:23 -0700 (PDT)
Subject: Re: KVM works on RPi4
To:     Jan Kiszka <jan.kiszka@web.de>, Marc Zyngier <marc.zyngier@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why> <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
 <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
 <cbbeb948-23e5-97d9-2410-ef804ae2b80d@web.de>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <3fa336f7-0089-ae4a-a616-a000214fc1d1@arm.com>
Date:   Mon, 1 Jul 2019 09:18:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cbbeb948-23e5-97d9-2410-ef804ae2b80d@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/19 11:49 AM, Jan Kiszka wrote:
> On 30.06.19 12:18, Jan Kiszka wrote:
>> On 30.06.19 11:34, Jan Kiszka wrote:
>>> On 30.06.19 00:42, Marc Zyngier wrote:
>>>> On Sat, 29 Jun 2019 19:09:37 +0200
>>>> Jan Kiszka <jan.kiszka@web.de> wrote:
>>>>> However, as the Raspberry kernel is not yet ready for 64-bit (and
>>>>> upstream is not in sight), I had to use legacy 32-bit mode. And there we
>>>>> stumble over the core detection. This little patch made it work, though:
>>>>>
>>>>> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
>>>>> index 2b8de885b2bf..01606aad73cc 100644
>>>>> --- a/arch/arm/kvm/guest.c
>>>>> +++ b/arch/arm/kvm/guest.c
>>>>> @@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
>>>>>       case ARM_CPU_PART_CORTEX_A7:
>>>>>           return KVM_ARM_TARGET_CORTEX_A7;
>>>>>       case ARM_CPU_PART_CORTEX_A15:
>>>>> +    case ARM_CPU_PART_CORTEX_A72:
>>>>>           return KVM_ARM_TARGET_CORTEX_A15;
>>>>>       default:
>>>>>           return -EINVAL;
>>>>>
>>>>> That raises the question if this is hack or a valid change and if there
>>>>> is general interest in mapping 64-bit cores on 32-bit if they happen to
>>>>> run in 32-bit mode.
>>>>
>>>> The real thing to do here would be to move to a generic target, much
>>>> like we did on the 64bit side. Could you investigate that instead? It
>>>> would also allow KVM to be used on other 32bit cores such as
>>>> A12/A17/A32.
>>>
>>> You mean something like KVM_ARM_TARGET_GENERIC_V8? Need to study that...
>>>
>>
>> Hmm, looking at what KVM_ARM_TARGET_CORTEX_A7 and ..._A15 differentiates, I
>> found nothing so far:
>>
>> kvm_reset_vcpu:
>>          switch (vcpu->arch.target) {
>>          case KVM_ARM_TARGET_CORTEX_A7:
>>          case KVM_ARM_TARGET_CORTEX_A15:
>>                  reset_regs = &cortexa_regs_reset;
>>                  vcpu->arch.midr = read_cpuid_id();
>>                  break;
>>
>> And arch/arm/kvm/coproc_a15.c looks like a copy of coproc_a7.c, just with some
>> symbols renamed.
> 
> OK, found it: The reset values of SCTLR differ, in one bit. A15 starts with
> branch prediction (11) off, A7 with that feature enabled. Quite some boilerplate
> code for managing a single bit.
> 
> For a generic target, can we simply assume A15 reset behaviour?

IIUC, it'd work only for ARCH_VIRT guest, which is known not to touch IMP_DEF
registers. Unfortunately, other variants of guests (ARCH_VEXPRESS?) might touch
such registers, for instance, l2ctlr is often used for querying number of populated
cpus, and it might not be present at all on v8. Also, content of IMP_DEF register
is not fixed and meaning of the bits may wary between different implementations, so
guests may react differently.

Just my 2p.

Cheers
Vladimir

> 
> Jan
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

