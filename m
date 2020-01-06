Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A64131615
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 17:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgAFQb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 11:31:58 -0500
Received: from foss.arm.com ([217.140.110.172]:45768 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgAFQb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 11:31:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E35B231B;
        Mon,  6 Jan 2020 08:31:56 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D09A3F6C4;
        Mon,  6 Jan 2020 08:31:55 -0800 (PST)
Subject: Re: [PATCH 35/59] KVM: arm/arm64: nv: Support multiple nested stage 2
 mmu structures
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-36-marc.zyngier@arm.com>
 <d3d32c8c-35e4-d4fd-ba6d-708d4c990f36@arm.com> <86mub2gmph.wl-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4e185a5d-af01-a549-2438-aaf5d816dae8@arm.com>
Date:   Mon, 6 Jan 2020 16:31:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <86mub2gmph.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/5/20 11:35 AM, Marc Zyngier wrote:
> [Blast from the past!]
>
> Hi Alexandru,
>
> I'm currently reworking this series, so taking the opportunity to go
> through your comments (I won't reply to them all, as most are
> perfectly valid and need no further discussion).
>
> On Thu, 04 Jul 2019 16:51:52 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> On 6/21/19 10:38 AM, Marc Zyngier wrote:
>>
>>> From: Christoffer Dall <christoffer.dall@arm.com>
>>>
>>> Add stage 2 mmu data structures for virtual EL2 and for nested guests.
>>> We don't yet populate shadow stage 2 page tables, but we now have a
>>> framework for getting to a shadow stage 2 pgd.
>>>
>>> We allocate twice the number of vcpus as stage 2 mmu structures because
>>> that's sufficient for each vcpu running two VMs without having to flush
>>> the stage 2 page tables.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  arch/arm/include/asm/kvm_host.h     |   4 +
>>>  arch/arm/include/asm/kvm_mmu.h      |   3 +
>>>  arch/arm64/include/asm/kvm_host.h   |  28 +++++
>>>  arch/arm64/include/asm/kvm_mmu.h    |   8 ++
>>>  arch/arm64/include/asm/kvm_nested.h |   7 ++
>>>  arch/arm64/kvm/nested.c             | 172 ++++++++++++++++++++++++++++
>>>  virt/kvm/arm/arm.c                  |  16 ++-
>>>  virt/kvm/arm/mmu.c                  |  31 ++---
>>>  8 files changed, 254 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>> index e3217c4ad25b..b821eb2383ad 100644
>>> --- a/arch/arm/include/asm/kvm_host.h
>>> +++ b/arch/arm/include/asm/kvm_host.h
>>> @@ -424,4 +424,8 @@ static inline bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>>>  	return true;
>>>  }
>>>  
>>> +static inline void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu) {}
>>> +static inline void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu) {}
>>> +static inline int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu) { return 0; }
>>> +
>>>  #endif /* __ARM_KVM_HOST_H__ */
>>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>>> index be23e3f8e08c..e6984b6da2ce 100644
>>> --- a/arch/arm/include/asm/kvm_mmu.h
>>> +++ b/arch/arm/include/asm/kvm_mmu.h
>>> @@ -420,6 +420,9 @@ static inline int hyp_map_aux_data(void)
>>>  
>>>  static inline void kvm_set_ipa_limit(void) {}
>>>  
>>> +static inline void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu) {}
>>> +static inline void kvm_init_nested(struct kvm *kvm) {}
>>> +
>>>  static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
>>>  {
>>>  	struct kvm_vmid *vmid = &mmu->vmid;
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 3dee5e17a4ee..cc238de170d2 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -88,11 +88,39 @@ struct kvm_s2_mmu {
>>>  	phys_addr_t	pgd_phys;
>>>  
>>>  	struct kvm *kvm;
>>> +
>>> +	/*
>>> +	 * For a shadow stage-2 MMU, the virtual vttbr programmed by the guest
>>> +	 * hypervisor.  Unused for kvm_arch->mmu. Set to 1 when the structure
>>> +	 * contains no valid information.
>>> +	 */
>>> +	u64	vttbr;
>>> +
>>> +	/* true when this represents a nested context where virtual HCR_EL2.VM == 1 */
>>> +	bool	nested_stage2_enabled;
>>> +
>>> +	/*
>>> +	 *  0: Nobody is currently using this, check vttbr for validity
>>> +	 * >0: Somebody is actively using this.
>>> +	 */
>>> +	atomic_t refcnt;
>>>  };
>>>  
>>> +static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
>>> +{
>>> +	return !(mmu->vttbr & 1);
>>> +}
>>> +
>>>  struct kvm_arch {
>>>  	struct kvm_s2_mmu mmu;
>>>  
>>> +	/*
>>> +	 * Stage 2 paging stage for VMs with nested virtual using a virtual
>>> +	 * VMID.
>>> +	 */
>>> +	struct kvm_s2_mmu *nested_mmus;
>>> +	size_t nested_mmus_size;
>>> +
>>>  	/* VTCR_EL2 value for this VM */
>>>  	u64    vtcr;
>>>  
>>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>>> index 1eb6e0ca61c2..32bcaa1845dc 100644
>>> --- a/arch/arm64/include/asm/kvm_mmu.h
>>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>>> @@ -100,6 +100,7 @@ alternative_cb_end
>>>  #include <asm/mmu_context.h>
>>>  #include <asm/pgtable.h>
>>>  #include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_nested.h>
>>>  
>>>  void kvm_update_va_mask(struct alt_instr *alt,
>>>  			__le32 *origptr, __le32 *updptr, int nr_inst);
>>> @@ -164,6 +165,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>>>  			     void **haddr);
>>>  void free_hyp_pgds(void);
>>>  
>>> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>>>  void stage2_unmap_vm(struct kvm *kvm);
>>>  int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
>>>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>>> @@ -635,5 +637,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
>>>  	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
>>>  }
>>>  
>>> +static inline u64 get_vmid(u64 vttbr)
>>> +{
>>> +	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
>>> +		VTTBR_VMID_SHIFT;
>>> +}
>>> +
>>>  #endif /* __ASSEMBLY__ */
>>>  #endif /* __ARM64_KVM_MMU_H__ */
>>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>>> index 61e71d0d2151..d4021d0892bd 100644
>>> --- a/arch/arm64/include/asm/kvm_nested.h
>>> +++ b/arch/arm64/include/asm/kvm_nested.h
>>> @@ -10,6 +10,13 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
>>>  		test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features);
>>>  }
>>>  
>>> +extern void kvm_init_nested(struct kvm *kvm);
>>> +extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>>> +extern void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu);
>>> +extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
>>> +extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
>>> +extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
>>> +
>>>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>>>  extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>>>  extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>> index 3872e3cf1691..4b38dc5c0be3 100644
>>> --- a/arch/arm64/kvm/nested.c
>>> +++ b/arch/arm64/kvm/nested.c
>>> @@ -18,7 +18,161 @@
>>>  #include <linux/kvm.h>
>>>  #include <linux/kvm_host.h>
>>>  
>>> +#include <asm/kvm_arm.h>
>>>  #include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_mmu.h>
>>> +#include <asm/kvm_nested.h>
>>> +
>>> +void kvm_init_nested(struct kvm *kvm)
>>> +{
>>> +	kvm_init_s2_mmu(&kvm->arch.mmu);
>>> +
>>> +	kvm->arch.nested_mmus = NULL;
>>> +	kvm->arch.nested_mmus_size = 0;
>>> +}
>>> +
>>> +int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	struct kvm_s2_mmu *tmp;
>>> +	int num_mmus;
>>> +	int ret = -ENOMEM;
>>> +
>>> +	if (!test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features))
>>> +		return 0;
>>> +
>>> +	if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
>>> +		return -EINVAL;
>>> +
>>> +	mutex_lock(&kvm->lock);
>>> +
>>> +	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
>>> +	tmp = __krealloc(kvm->arch.nested_mmus,
>>> +			 num_mmus * sizeof(*kvm->arch.nested_mmus),
>>> +			 GFP_KERNEL | __GFP_ZERO);
>>> +
>>> +	if (tmp) {
>>> +		if (tmp != kvm->arch.nested_mmus)
>>> +			kfree(kvm->arch.nested_mmus);
>> Here we are freeing a resource that is shared between all virtual
>> CPUs. So if kvm_alloc_stage2_pgd (below) fails, we could end up
>> freeing something that has been initialized by previous
>> vcpu(s). Same thing happens if tmp == kvm->arch.nested_mmus (because
>> of kfree(tmp)).
>>
>> Looking at Documentation/virtual/kvm/api.txt (section 4.82,
>> KVM_ARM_VCPU_IOCTL):
>>
>> Userspace can call this function multiple times for a given vcpu,
>> including after the vcpu has been run. This will reset the vcpu to
>> its initial state.
>>
>> It seems to me that it is allowed for userspace to try to call
>> KVM_ARM_VCPU_IOCTL again after it failed. I was wondering if it's
>> possible to end up in a situation where the second call succeeds,
>> but kvm->arch.nested_mmus is not initialized properly and if we
>> should care about that.
> Indeed, this needs reworking. I think that in the event of any
> allocation failure, we're better off leaving things in place. Given
> that we always perform a krealloc(), it should be safe to do so.
>
>>> +
>>> +		tmp[num_mmus - 1].kvm = kvm;
>>> +		atomic_set(&tmp[num_mmus - 1].refcnt, 0);
>>> +		ret = kvm_alloc_stage2_pgd(&tmp[num_mmus - 1]);
>>> +		if (ret)
>>> +			goto out;
>>> +
>>> +		tmp[num_mmus - 2].kvm = kvm;
>>> +		atomic_set(&tmp[num_mmus - 2].refcnt, 0);
>>> +		ret = kvm_alloc_stage2_pgd(&tmp[num_mmus - 2]);
>>> +		if (ret) {
>>> +			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
>>> +			goto out;
>>> +		}
>>> +
>>> +		kvm->arch.nested_mmus_size = num_mmus;
>>> +		kvm->arch.nested_mmus = tmp;
>>> +		tmp = NULL;
>>> +	}
>>> +
>>> +out:
>>> +	kfree(tmp);
>>> +	mutex_unlock(&kvm->lock);
>>> +	return ret;
>>> +}
>>> +
>>> +/* Must be called with kvm->lock held */
>>> +struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
>>> +{
>>> +	bool nested_stage2_enabled = hcr & HCR_VM;
>>> +	int i;
>>> +
>>> +	/* Don't consider the CnP bit for the vttbr match */
>>> +	vttbr = vttbr & ~1UL;
>> There's a define for that bit, VTTBR_CNP_BIT in kvm_arm.h (which this file
>> includes).
> Fair enough.
>
>>> +
>>> +	/* Search a mmu in the list using the virtual VMID as a key */
>> I think when the guest has stage 2 enabled we also match on
>> VTTBR_EL2.VMID + VTTBR_EL2.BADDR.
> Yes.
>
>>> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>> +
>>> +		if (!kvm_s2_mmu_valid(mmu))
>>> +			continue;
>>> +
>>> +		if (nested_stage2_enabled &&
>>> +		    mmu->nested_stage2_enabled &&
>>> +		    vttbr == mmu->vttbr)
>>> +			return mmu;
>>> +
>>> +		if (!nested_stage2_enabled &&
>>> +		    !mmu->nested_stage2_enabled &&
>>> +		    get_vmid(vttbr) == get_vmid(mmu->vttbr))
>>> +			return mmu;
>> I'm struggling to understand why we do this. As far as I can tell,
>> this applies only to non-vhe guest hypervisors, because that's the
>> only situation where we run something at vEL1 without shadow stage 2
>> enabled.
> I don't think the non-VHE consideration is relevant here. Trying to
> distinguish between arbitrary use cases is just a massive distraction
> and gets in the way of implementing the architecture correctly.

This is very true. By the time I had finished reviewing the series I had fallen
into this trap several times. Lesson learned, I hope.

>
>> There's only one MMU that matches that guest, because
>> there's only one host for the non-vhe hypervisor. So why are we
>> matching on vmid only, instead of matching on the entire vttbr? Is
>> it because we don't want to get fooled by a naughty guest that
>> changes the BADDR each time it switches to its EL1 host? Or
>> something else entirely that I'm missing?
> First, let's remember one thing: No matter whether we have S2 enabled
> or not, TLBs are tagged by VMID. I wondered about that for a long
> time, but couldn't find anything in the architecture that would
> contradict this. And if you think of what a CPU must implement, it
> makes more sense to always tag things than try to come up with more
> fancy schemes.
>
> Given that our shadow S2 is an ugly form of SW-loaded TLBs, matching
> the VMID is critical to hit the right shadow MMU context. And since S2
> *translation* is disabled, it is perfectly valid to ignore the BADDR
> part of VTTBR, and VHE-vs-!VHE doesn't come into the equation.

Very true.

>
> Now, the real cause for questioning is the previous statement: why do
> we decide to match on the whole VTTBR when S2 translation is enabled?
> Let's imagine a guest that reuses the same VMID for different
> translations (that's a bit bonkers, but unfortunately not forbidden by
> the architecture if you consider per-CPU translations).
>
> And even in the single VCPU case that would change BADDR each time
> without invalidating the TLBs: If we only matched on the VMID, we
> could potentially end-up with TLB conflicts, and that's not a nice
> place to be. So we will just pick a new MMU context, and start
> populating shadow translations based on this context. This is pretty
> forgiving for broken guests, but it also simplifies the implementation.

I think I understand what you are saying, thank you for the explanation.

>
>>> +	}
>>> +	return NULL;
>>> +}
>>> +
>>> +static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
>>> +	u64 hcr= vcpu_read_sys_reg(vcpu, HCR_EL2);
>>> +	struct kvm_s2_mmu *s2_mmu;
>>> +	int i;
>>> +
>>> +	s2_mmu = lookup_s2_mmu(kvm, vttbr, hcr);
>>> +	if (s2_mmu)
>>> +		goto out;
>>> +
>>> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>> +		s2_mmu = &kvm->arch.nested_mmus[i];
>>> +
>>> +		if (atomic_read(&s2_mmu->refcnt) == 0)
>>> +			break;
>>> +	}
>>> +	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
>>> +
>>> +	if (kvm_s2_mmu_valid(s2_mmu)) {
>>> +		/* Clear the old state */
>>> +		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
>>> +		if (s2_mmu->vmid.vmid_gen)
>>> +			kvm_call_hyp(__kvm_tlb_flush_vmid, s2_mmu);
>>> +	}
>>> +
>>> +	/*
>>> +	 * The virtual VMID (modulo CnP) will be used as a key when matching
>>> +	 * an existing kvm_s2_mmu.
>>> +	 */
>>> +	s2_mmu->vttbr = vttbr & ~1UL;
>>> +	s2_mmu->nested_stage2_enabled = hcr & HCR_VM;
>>> +
>>> +out:
>>> +	atomic_inc(&s2_mmu->refcnt);
>>> +	return s2_mmu;
>>> +}
>>> +
>>> +void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu)
>>> +{
>>> +	mmu->vttbr = 1;
>>> +	mmu->nested_stage2_enabled = false;
>>> +	atomic_set(&mmu->refcnt, 0);
>>> +}
>>> +
>>> +void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>>> +{
>>> +	if (is_hyp_ctxt(vcpu)) {
>> If userspace has set the nested feature, but hasn't set the vcpu
>> mode to PSR_MODE_EL2h/PSR_MODE_EL2t, we will never use
>> kvm->arch.mmu, and instead we'll always take the mmu_lock and search
>> for the mmu. Is that something we should care about?
> I'm really not worried about this. If the user has asked for nested
> support but doesn't make use of it, tough luck.

Fair enough.

>
>>> +		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>>> +	} else {
>>> +		spin_lock(&vcpu->kvm->mmu_lock);
>>> +		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
>>> +		spin_unlock(&vcpu->kvm->mmu_lock);
>>> +	}
>>> +}
>>> +
>>> +void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
>>> +{
>>> +	if (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu) {
>>> +		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
>>> +		vcpu->arch.hw_mmu = NULL;
>>> +	}
>>> +}
>>>  
>>>  /*
>>>   * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>>> @@ -37,3 +191,21 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>>>  
>>>  	return -EINVAL;
>>>  }
>>> +
>>> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>> +
>>> +		WARN_ON(atomic_read(&mmu->refcnt));
>>> +
>>> +		if (!atomic_read(&mmu->refcnt))
>>> +			kvm_free_stage2_pgd(mmu);
>>> +	}
>>> +	kfree(kvm->arch.nested_mmus);
>>> +	kvm->arch.nested_mmus = NULL;
>>> +	kvm->arch.nested_mmus_size = 0;
>>> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
>>> +}
>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>> index 5d4371633e1c..4e3cbfa1ecbe 100644
>>> --- a/virt/kvm/arm/arm.c
>>> +++ b/virt/kvm/arm/arm.c
>>> @@ -36,6 +36,7 @@
>>>  #include <asm/kvm_arm.h>
>>>  #include <asm/kvm_asm.h>
>>>  #include <asm/kvm_mmu.h>
>>> +#include <asm/kvm_nested.h>
>>>  #include <asm/kvm_emulate.h>
>>>  #include <asm/kvm_coproc.h>
>>>  #include <asm/sections.h>
>>> @@ -126,6 +127,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>  	kvm->arch.mmu.vmid.vmid_gen = 0;
>>>  	kvm->arch.mmu.kvm = kvm;
>>>  
>>> +	kvm_init_nested(kvm);
>> More context:
>>
>> @@ -120,18 +121,20 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>  
>>      ret = kvm_alloc_stage2_pgd(&kvm->arch.mmu);
>>      if (ret)
>>          goto out_fail_alloc;
>>  
>>      /* Mark the initial VMID generation invalid */
>>      kvm->arch.mmu.vmid.vmid_gen = 0;
>>      kvm->arch.mmu.kvm = kvm;
>>  
>> +    kvm_init_nested(kvm);
>> +
>>
>> kvm_alloc_stage2_pgd ends up calling kvm_init_s2_mmu for
>> kvm->arch.mmu.  kvm_init_nested does the same thing, and we end up
>> calling kvm_init_s2_mmu for kvm->arch.mmu twice. There's really no
>> harm in doing it twice, but I thought I could mention it because it
>> looks to me that the fix is simple: remove the kvm_init_s2_mmu call
>> from kvm_init_nested. The double initialization is also true for the
>> tip of the series.
> I've reworked this part a bit, and need to reconcile the above with
> what I now have. Overall, I do agree that there is some vastly
> redundant init here.
>
> And a very belated thanks for all the work you've put into reviewing
> this difficult series. Rest assured that this wasn't in vain!

Thank you, reviewing this series has been very useful for learning how KVM works,
as well as some of the finer points of the Arm architecture. I look forward to
reviewing v2 of the patches when they're ready.

Thanks,
Alex
>
> Thanks,
>
> 	M.
>
