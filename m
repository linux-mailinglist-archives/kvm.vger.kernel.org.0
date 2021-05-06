Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A054A375323
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 13:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhEFLoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 07:44:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17135 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhEFLog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 07:44:36 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FbWpr1xXDzqSfJ;
        Thu,  6 May 2021 19:40:20 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 6 May 2021 19:43:26 +0800
Subject: Re: [PATCH v2 03/11] KVM: arm64: Make kvm_skip_instr() and co private
 to HYP
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <kernel-team@android.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>
References: <20201102164045.264512-1-maz@kernel.org>
 <20201102164045.264512-4-maz@kernel.org>
 <cef3517b-e66d-4d26-68a9-2d5fb433377c@huawei.com>
 <875yzxnn5w.wl-maz@kernel.org> <87zgx8mkwd.wl-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <db784fc8-3a52-49ff-0b75-83a1bbc81d98@huawei.com>
Date:   Thu, 6 May 2021 19:43:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87zgx8mkwd.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/6 14:33, Marc Zyngier wrote:
> On Wed, 05 May 2021 17:46:51 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
>>
>> Hi Zenghui,
>>
>> On Wed, 05 May 2021 15:23:02 +0100,
>> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On 2020/11/3 0:40, Marc Zyngier wrote:
>>>> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
>>>> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
>>>> to increment PC post emulation is now signalled via a flag in the
>>>> vcpu structure.
>>>>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>
>>> [...]
>>>
>>>> @@ -133,6 +134,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>>>>  	__load_guest_stage2(vcpu->arch.hw_mmu);
>>>>  	__activate_traps(vcpu);
>>>> +	__adjust_pc(vcpu);
>>>
>>> If the INCREMENT_PC flag was set (e.g., for WFx emulation) while we're
>>> handling PSCI CPU_ON call targetting this VCPU, the *target_pc* (aka
>>> entry point address, normally provided by the primary VCPU) will be
>>> unexpectedly incremented here. That's pretty bad, I think.
>>
>> How can you online a CPU using PSCI if that CPU is currently spinning
>> on a WFI? Or is that we have transitioned via userspace to perform the
>> vcpu reset? I can imagine it happening in that case.

I hadn't tried to reset VCPU from userspace. That would be a much easier
way to reproduce this problem.

>>> This was noticed with a latest guest kernel, at least with commit
>>> dccc9da22ded ("arm64: Improve parking of stopped CPUs"), which put the
>>> stopped VCPUs in the WFx loop. The guest kernel shouted at me that
>>>
>>> 	"CPU: CPUs started in inconsistent modes"
>>
>> Ah, the perks of running guests with "quiet"... Well caught.
>>
>>> *after* rebooting. The problem is that the secondary entry point was
>>> corrupted by KVM as explained above. All of the secondary processors
>>> started from set_cpu_boot_mode_flag(), with w0=0. Oh well...
>>>
>>> I write the below diff and guess it will help. But I have to look at all
>>> other places where we adjust PC directly to make a right fix. Please let
>>> me know what do you think.
>>>
>>>
>>> Thanks,
>>> Zenghui
>>>
>>> ---->8----
>>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>>> index 956cdc240148..ed647eb387c3 100644
>>> --- a/arch/arm64/kvm/reset.c
>>> +++ b/arch/arm64/kvm/reset.c
>>> @@ -265,7 +265,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>>  		if (vcpu->arch.reset_state.be)
>>>  			kvm_vcpu_set_be(vcpu);
>>>
>>> +		/*
>>> +		 * Don't bother with the KVM_ARM64_INCREMENT_PC flag while
>>> +		 * using this version of __adjust_pc().
>>> +		 */
>>>  		*vcpu_pc(vcpu) = target_pc;
>>> +		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
> 
> Actually, this is far worse than it looks, and this only papers over
> one particular symptom. We need to resolve all pending PC updates
> *before* returning to userspace, or things like live migration can
> observe an inconsistent state.

Ah yeah, agreed.

Apart from the PC manipulation, I noticed that when handling the user
GET_VCPU_EVENTS request:

|	/*
|	 * We never return a pending ext_dabt here because we deliver it to
|	 * the virtual CPU directly when setting the event and it's no longer
|	 * 'pending' at this point.
|	 */

Which isn't true anymore now that we defer the exception injection right
before the VCPU entry. The comment needs to be updated anyway whilst it
isn't clear to me that whether we should expose the in-kernel ext_dabt
to userspace, given that the exception state is already reflected by the
registers and the abort can be taken in the next VCPU entry (if we can
appropriately fix the PC updating problem).

> I'll try and cook something up.

Thanks.


Zenghui
