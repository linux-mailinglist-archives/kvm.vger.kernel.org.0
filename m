Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F101CF993
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgELPrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:47:22 -0400
Received: from foss.arm.com ([217.140.110.172]:57512 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgELPrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 11:47:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7BA71FB;
        Tue, 12 May 2020 08:47:20 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80A763F305;
        Tue, 12 May 2020 08:47:18 -0700 (PDT)
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data from
 struct kvm
To:     James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5134e123-18ec-9b69-2e0a-b83798e01507@arm.com>
Date:   Tue, 12 May 2020 16:47:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <76d811eb-b304-c49f-1f21-fe9d95112a28@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/12/20 12:17 PM, James Morse wrote:
> Hi Alex, Marc,
>
> (just on this last_vcpu_ran thing...)
>
> On 11/05/2020 17:38, Alexandru Elisei wrote:
>> On 4/22/20 1:00 PM, Marc Zyngier wrote:
>>> From: Christoffer Dall <christoffer.dall@arm.com>
>>>
>>> As we are about to reuse our stage 2 page table manipulation code for
>>> shadow stage 2 page tables in the context of nested virtualization, we
>>> are going to manage multiple stage 2 page tables for a single VM.
>>>
>>> This requires some pretty invasive changes to our data structures,
>>> which moves the vmid and pgd pointers into a separate structure and
>>> change pretty much all of our mmu code to operate on this structure
>>> instead.
>>>
>>> The new structure is called struct kvm_s2_mmu.
>>>
>>> There is no intended functional change by this patch alone.
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 7dd8fefa6aecd..664a5d92ae9b8 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -63,19 +63,32 @@ struct kvm_vmid {
>>>  	u32    vmid;
>>>  };
>>>  
>>> -struct kvm_arch {
>>> +struct kvm_s2_mmu {
>>>  	struct kvm_vmid vmid;
>>>  
>>> -	/* stage2 entry level table */
>>> -	pgd_t *pgd;
>>> -	phys_addr_t pgd_phys;
>>> -
>>> -	/* VTCR_EL2 value for this VM */
>>> -	u64    vtcr;
>>> +	/*
>>> +	 * stage2 entry level table
>>> +	 *
>>> +	 * Two kvm_s2_mmu structures in the same VM can point to the same pgd
>>> +	 * here.  This happens when running a non-VHE guest hypervisor which
>>> +	 * uses the canonical stage 2 page table for both vEL2 and for vEL1/0
>>> +	 * with vHCR_EL2.VM == 0.
>> It makes more sense to me to say that a non-VHE guest hypervisor will use the
>> canonical stage *1* page table when running at EL2
> Can KVM say anything about stage1? Its totally under the the guests control even at vEL2...

It is. My interpretation of the comment was that if the guest doesn't have virtual
stage 2 enabled (we're not running a guest of the L1 hypervisor), then the L0 host
can use the same L0 stage 2 tables because we're running the same guest (the L1
VM), regardless of the actual exception level for the guest. If I remember
correctly, KVM assigns different vmids for guests running at vEL1/0 and vEL2 with
vHCR_EL2.VM == 0 because the translation regimes are different, but keeps the same
translation tables.

>
>
>> (the "Non-secure EL2 translation regime" as ARM DDI 0487F.b calls it on page D5-2543).
>> I think that's
>> the only situation where vEL2 and vEL1&0 will use the same L0 stage 2 tables. It's
>> been quite some time since I reviewed the initial version of the NV patches, did I
>> get that wrong?
>
>>> +	 */
>>> +	pgd_t		*pgd;
>>> +	phys_addr_t	pgd_phys;
>>>  
>>>  	/* The last vcpu id that ran on each physical CPU */
>>>  	int __percpu *last_vcpu_ran;
>> It makes sense for the other fields to be part of kvm_s2_mmu, but I'm struggling
>> to figure out why last_vcpu_ran is here. Would you mind sharing the rationale? I
>> don't see this change in v1 or v2 of the NV series.
> Marc may have a better rationale. My thinking was because kvm_vmid is in here too.
>
> last_vcpu_ran exists to prevent KVM accidentally emulating CNP without the opt-in. (we
> call it defacto CNP).
>
> The guest may expect to be able to use asid-4 with different page tables on different

I'm afraid I don't know what asid-4 is.

> vCPUs, assuming the TLB isn't shared. But if KVM is switching between those vCPU on one
> physical CPU, the TLB is shared, ... the VMID and ASID are the same, but the page tables
> are not. Not fun to debug!
>
>
> NV makes this problem per-stage2, because each stage2 has its own VMID, we need to track
> the vcpu_id that last ran this stage2 on this physical CPU. If its not the same, we need
> to blow away this VMIDs TLB entries.
>
> The workaround lives in virt/kvm/arm/arm.c::kvm_arch_vcpu_load()

Makes sense, thank you for explaining that.

Thanks,
Alex
>
>
>> More below.
> (lightly trimmed!)
>
> Thanks,
>
> James
>
>
>>>  
>>> +	struct kvm *kvm;
>>> +};
> [...]
>
>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>> index 53b3ba9173ba7..03f01fcfa2bd5 100644
>>> --- a/virt/kvm/arm/arm.c
>>> +++ b/virt/kvm/arm/arm.c
>> There's a comment that still mentions arch.vmid that you missed in this file:
>>
>> static bool need_new_vmid_gen(struct kvm_vmid *vmid)
>> {
>>     u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
>>     smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
>>
> [..]
>
>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>> index e3b9ee268823b..2f99749048285 100644
>>> --- a/virt/kvm/arm/mmu.c
>>> +++ b/virt/kvm/arm/mmu.c
>>> @@ -886,21 +898,23 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>>>  }
>>>  
>>>  /**
>>> - * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
>>> - * @kvm:	The KVM struct pointer for the VM.
>>> + * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
>>> + * @kvm:	The pointer to the KVM structure
>>> + * @mmu:	The pointer to the s2 MMU structure
>>>   *
>>>   * Allocates only the stage-2 HW PGD level table(s) of size defined by
>>> - * stage2_pgd_size(kvm).
>>> + * stage2_pgd_size(mmu->kvm).
>>>   *
>>>   * Note we don't need locking here as this is only called when the VM is
>>>   * created, which can only be done once.
>>>   */
>>> -int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>>>  {
>>>  	phys_addr_t pgd_phys;
>>>  	pgd_t *pgd;
>>> +	int cpu;
>>>  
>>> -	if (kvm->arch.pgd != NULL) {
>>> +	if (mmu->pgd != NULL) {
>>>  		kvm_err("kvm_arch already initialized?\n");
>>>  		return -EINVAL;
>>>  	}
>>> @@ -914,8 +928,20 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>>  	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
>> We don't free the pgd here, but we do free it if alloc_percpu fails. Is that
>> intentional?
>
>>>  		return -EINVAL;
>>>  
>>> -	kvm->arch.pgd = pgd;
>>> -	kvm->arch.pgd_phys = pgd_phys;
>>> +	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
>>> +	if (!mmu->last_vcpu_ran) {
>>> +		free_pages_exact(pgd, stage2_pgd_size(kvm));
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	for_each_possible_cpu(cpu)
>>> +		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
>>> +
>>> +	mmu->kvm = kvm;
>>> +	mmu->pgd = pgd;
>>> +	mmu->pgd_phys = pgd_phys;
>>> +	mmu->vmid.vmid_gen = 0;
>>> +
>>>  	return 0;
>>>  }
>>>  
>>> @@ -986,39 +1012,34 @@ void stage2_unmap_vm(struct kvm *kvm)
>>>  	srcu_read_unlock(&kvm->srcu, idx);
>>>  }
>>>  
>>> -/**
>>> - * kvm_free_stage2_pgd - free all stage-2 tables
>>> - * @kvm:	The KVM struct pointer for the VM.
>>> - *
>>> - * Walks the level-1 page table pointed to by kvm->arch.pgd and frees all
>>> - * underlying level-2 and level-3 tables before freeing the actual level-1 table
>>> - * and setting the struct pointer to NULL.
>>> - */
>>> -void kvm_free_stage2_pgd(struct kvm *kvm)
>>> +void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>>  {
>>> +	struct kvm *kvm = mmu->kvm;
>>>  	void *pgd = NULL;
>>>  
>>>  	spin_lock(&kvm->mmu_lock);
>>> -	if (kvm->arch.pgd) {
>>> -		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm));
>>> -		pgd = READ_ONCE(kvm->arch.pgd);
>>> -		kvm->arch.pgd = NULL;
>>> -		kvm->arch.pgd_phys = 0;
>>> +	if (mmu->pgd) {
>>> +		unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
>>> +		pgd = READ_ONCE(mmu->pgd);
>>> +		mmu->pgd = NULL;
>> The kvm->arch.pgd_phys = 0 instruction seems to have been dropped here. Is that
>> intentional?
