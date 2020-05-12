Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69BF1CFA42
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 18:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgELQNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 12:13:40 -0400
Received: from foss.arm.com ([217.140.110.172]:57894 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgELQNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 12:13:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 595BC1FB;
        Tue, 12 May 2020 09:13:39 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09D253F305;
        Tue, 12 May 2020 09:13:36 -0700 (PDT)
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data from
 struct kvm
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
 <a7c8207c-9061-ad0e-c9f8-64c995e928b6@arm.com>
 <76d811eb-b304-c49f-1f21-fe9d95112a28@arm.com>
 <5134e123-18ec-9b69-2e0a-b83798e01507@arm.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <cc50e08b-0d7e-83b6-88ee-6f8726dcd9bb@arm.com>
Date:   Tue, 12 May 2020 17:13:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5134e123-18ec-9b69-2e0a-b83798e01507@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 12/05/2020 16:47, Alexandru Elisei wrote:
> On 5/12/20 12:17 PM, James Morse wrote:
>> On 11/05/2020 17:38, Alexandru Elisei wrote:
>>> On 4/22/20 1:00 PM, Marc Zyngier wrote:
>>>> From: Christoffer Dall <christoffer.dall@arm.com>
>>>>
>>>> As we are about to reuse our stage 2 page table manipulation code for
>>>> shadow stage 2 page tables in the context of nested virtualization, we
>>>> are going to manage multiple stage 2 page tables for a single VM.
>>>>
>>>> This requires some pretty invasive changes to our data structures,
>>>> which moves the vmid and pgd pointers into a separate structure and
>>>> change pretty much all of our mmu code to operate on this structure
>>>> instead.
>>>>
>>>> The new structure is called struct kvm_s2_mmu.
>>>>
>>>> There is no intended functional change by this patch alone.
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index 7dd8fefa6aecd..664a5d92ae9b8 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -63,19 +63,32 @@ struct kvm_vmid {
>>>>  	u32    vmid;
>>>>  };
>>>>  
>>>> -struct kvm_arch {
>>>> +struct kvm_s2_mmu {
>>>>  	struct kvm_vmid vmid;
>>>>  
>>>> -	/* stage2 entry level table */
>>>> -	pgd_t *pgd;
>>>> -	phys_addr_t pgd_phys;
>>>> -
>>>> -	/* VTCR_EL2 value for this VM */
>>>> -	u64    vtcr;
>>>> +	/*
>>>> +	 * stage2 entry level table
>>>> +	 *
>>>> +	 * Two kvm_s2_mmu structures in the same VM can point to the same pgd
>>>> +	 * here.  This happens when running a non-VHE guest hypervisor which
>>>> +	 * uses the canonical stage 2 page table for both vEL2 and for vEL1/0
>>>> +	 * with vHCR_EL2.VM == 0.

>>> It makes more sense to me to say that a non-VHE guest hypervisor will use the
>>> canonical stage *1* page table when running at EL2

>> Can KVM say anything about stage1? Its totally under the the guests control even at vEL2...

> It is. My interpretation of the comment was that if the guest doesn't have virtual
> stage 2 enabled (we're not running a guest of the L1 hypervisor), then the L0 host
> can use the same L0 stage 2 tables because we're running the same guest (the L1
> VM), regardless of the actual exception level for the guest.

I think you're right, but I can't see where stage 1 comes in to it!


> If I remember
> correctly, KVM assigns different vmids for guests running at vEL1/0 and vEL2 with
> vHCR_EL2.VM == 0 because the translation regimes are different, but keeps the same
> translation tables.

Interesting. Is that because vEL2 really has ASIDs so it needs its own VMID space?



>>> (the "Non-secure EL2 translation regime" as ARM DDI 0487F.b calls it on page D5-2543).
>>> I think that's
>>> the only situation where vEL2 and vEL1&0 will use the same L0 stage 2 tables. It's
>>> been quite some time since I reviewed the initial version of the NV patches, did I
>>> get that wrong?
>>
>>>> +	 */
>>>> +	pgd_t		*pgd;
>>>> +	phys_addr_t	pgd_phys;
>>>>  
>>>>  	/* The last vcpu id that ran on each physical CPU */
>>>>  	int __percpu *last_vcpu_ran;

>>> It makes sense for the other fields to be part of kvm_s2_mmu, but I'm struggling
>>> to figure out why last_vcpu_ran is here. Would you mind sharing the rationale? I
>>> don't see this change in v1 or v2 of the NV series.

>> Marc may have a better rationale. My thinking was because kvm_vmid is in here too.
>>
>> last_vcpu_ran exists to prevent KVM accidentally emulating CNP without the opt-in. (we
>> call it defacto CNP).
>>
>> The guest may expect to be able to use asid-4 with different page tables on different

> I'm afraid I don't know what asid-4 is.

Sorry - 4 was just a random number![0]
'to use the same asid number on different vcpus'.


>> vCPUs, assuming the TLB isn't shared. But if KVM is switching between those vCPU on one
>> physical CPU, the TLB is shared, ... the VMID and ASID are the same, but the page tables
>> are not. Not fun to debug!
>>
>>
>> NV makes this problem per-stage2, because each stage2 has its own VMID, we need to track
>> the vcpu_id that last ran this stage2 on this physical CPU. If its not the same, we need
>> to blow away this VMIDs TLB entries.
>>
>> The workaround lives in virt/kvm/arm/arm.c::kvm_arch_vcpu_load()
> 
> Makes sense, thank you for explaining that.

Great,


Thanks,

James


[0] https://xkcd.com/221/
