Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD3D5832F
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 15:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfF0NQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 09:16:06 -0400
Received: from foss.arm.com ([217.140.110.172]:54158 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfF0NQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 09:16:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E939A360;
        Thu, 27 Jun 2019 06:16:04 -0700 (PDT)
Received: from [10.37.8.60] (unknown [10.37.8.60])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 299C43F246;
        Thu, 27 Jun 2019 06:16:01 -0700 (PDT)
Subject: Re: [PATCH 35/59] KVM: arm/arm64: nv: Support multiple nested stage 2
 mmu structures
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-36-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <87564216-c7d0-351f-b3a6-1826706df89b@arm.com>
Date:   Thu, 27 Jun 2019 14:15:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-36-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/21/2019 10:38 AM, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Add stage 2 mmu data structures for virtual EL2 and for nested guests.
> We don't yet populate shadow stage 2 page tables, but we now have a
> framework for getting to a shadow stage 2 pgd.
> 
> We allocate twice the number of vcpus as stage 2 mmu structures because
> that's sufficient for each vcpu running two VMs without having to flush
> the stage 2 page tables.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h     |   4 +
>  arch/arm/include/asm/kvm_mmu.h      |   3 +
>  arch/arm64/include/asm/kvm_host.h   |  28 +++++
>  arch/arm64/include/asm/kvm_mmu.h    |   8 ++
>  arch/arm64/include/asm/kvm_nested.h |   7 ++
>  arch/arm64/kvm/nested.c             | 172 ++++++++++++++++++++++++++++
>  virt/kvm/arm/arm.c                  |  16 ++-
>  virt/kvm/arm/mmu.c                  |  31 ++---
>  8 files changed, 254 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index e3217c4ad25b..b821eb2383ad 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -424,4 +424,8 @@ static inline bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static inline void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu) {}
> +static inline int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu) { return 0; }
> +
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index be23e3f8e08c..e6984b6da2ce 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -420,6 +420,9 @@ static inline int hyp_map_aux_data(void)
>  
>  static inline void kvm_set_ipa_limit(void) {}
>  
> +static inline void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu) {}
> +static inline void kvm_init_nested(struct kvm *kvm) {}
> +
>  static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
>  {
>  	struct kvm_vmid *vmid = &mmu->vmid;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3dee5e17a4ee..cc238de170d2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -88,11 +88,39 @@ struct kvm_s2_mmu {
>  	phys_addr_t	pgd_phys;
>  
>  	struct kvm *kvm;
> +
> +	/*
> +	 * For a shadow stage-2 MMU, the virtual vttbr programmed by the guest
> +	 * hypervisor.  Unused for kvm_arch->mmu. Set to 1 when the structure
> +	 * contains no valid information.
> +	 */
> +	u64	vttbr;
> +
> +	/* true when this represents a nested context where virtual HCR_EL2.VM == 1 */
> +	bool	nested_stage2_enabled;
> +
> +	/*
> +	 *  0: Nobody is currently using this, check vttbr for validity
> +	 * >0: Somebody is actively using this.
> +	 */
> +	atomic_t refcnt;
>  };
>  
> +static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
> +{
> +	return !(mmu->vttbr & 1);
> +}
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> +	/*
> +	 * Stage 2 paging stage for VMs with nested virtual using a virtual
> +	 * VMID.
> +	 */
> +	struct kvm_s2_mmu *nested_mmus;
> +	size_t nested_mmus_size;
> +
>  	/* VTCR_EL2 value for this VM */
>  	u64    vtcr;
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 1eb6e0ca61c2..32bcaa1845dc 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -100,6 +100,7 @@ alternative_cb_end
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>  
>  void kvm_update_va_mask(struct alt_instr *alt,
>  			__le32 *origptr, __le32 *updptr, int nr_inst);
> @@ -164,6 +165,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  			     void **haddr);
>  void free_hyp_pgds(void);
>  
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>  void stage2_unmap_vm(struct kvm *kvm);
>  int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
> @@ -635,5 +637,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
>  	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
>  }
>  
> +static inline u64 get_vmid(u64 vttbr)
> +{
> +	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
> +		VTTBR_VMID_SHIFT;
> +}
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 61e71d0d2151..d4021d0892bd 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -10,6 +10,13 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
>  		test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features);
>  }
>  
> +extern void kvm_init_nested(struct kvm *kvm);
> +extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
> +extern void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu);
> +extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
> +extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
> +extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
> +
>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>  extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>  extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 3872e3cf1691..4b38dc5c0be3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -18,7 +18,161 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  
> +#include <asm/kvm_arm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
> +
> +void kvm_init_nested(struct kvm *kvm)
> +{
> +	kvm_init_s2_mmu(&kvm->arch.mmu);
> +
> +	kvm->arch.nested_mmus = NULL;
> +	kvm->arch.nested_mmus_size = 0;
> +}
> +
> +int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_s2_mmu *tmp;
> +	int num_mmus;
> +	int ret = -ENOMEM;
> +
> +	if (!test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features))
> +		return 0;
> +
> +	if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
> +	tmp = __krealloc(kvm->arch.nested_mmus,
> +			 num_mmus * sizeof(*kvm->arch.nested_mmus),
> +			 GFP_KERNEL | __GFP_ZERO);
> +
> +	if (tmp) {
> +		if (tmp != kvm->arch.nested_mmus)
> +			kfree(kvm->arch.nested_mmus);
> +
> +		tmp[num_mmus - 1].kvm = kvm;
> +		atomic_set(&tmp[num_mmus - 1].refcnt, 0);
> +		ret = kvm_alloc_stage2_pgd(&tmp[num_mmus - 1]);
> +		if (ret)
> +			goto out;
> +
> +		tmp[num_mmus - 2].kvm = kvm;
> +		atomic_set(&tmp[num_mmus - 2].refcnt, 0);
> +		ret = kvm_alloc_stage2_pgd(&tmp[num_mmus - 2]);
> +		if (ret) {
> +			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
> +			goto out;
> +		}
> +
> +		kvm->arch.nested_mmus_size = num_mmus;
> +		kvm->arch.nested_mmus = tmp;
> +		tmp = NULL;
> +	}
> +
> +out:
> +	kfree(tmp);
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}
> +
> +/* Must be called with kvm->lock held */
> +struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
> +{
> +	bool nested_stage2_enabled = hcr & HCR_VM;
> +	int i;
> +
> +	/* Don't consider the CnP bit for the vttbr match */
> +	vttbr = vttbr & ~1UL;
> +
> +	/* Search a mmu in the list using the virtual VMID as a key */
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		if (nested_stage2_enabled &&
> +		    mmu->nested_stage2_enabled &&
> +		    vttbr == mmu->vttbr)
> +			return mmu;
> +
> +		if (!nested_stage2_enabled &&
> +		    !mmu->nested_stage2_enabled &&
> +		    get_vmid(vttbr) == get_vmid(mmu->vttbr))
> +			return mmu;
> +	}
> +	return NULL;
> +}
> +
> +static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
> +	u64 hcr= vcpu_read_sys_reg(vcpu, HCR_EL2);
> +	struct kvm_s2_mmu *s2_mmu;
> +	int i;
> +
> +	s2_mmu = lookup_s2_mmu(kvm, vttbr, hcr);
> +	if (s2_mmu)
> +		goto out;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		s2_mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (atomic_read(&s2_mmu->refcnt) == 0)
> +			break;
> +	}
> +	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
> +
> +	if (kvm_s2_mmu_valid(s2_mmu)) {
> +		/* Clear the old state */
> +		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
> +		if (s2_mmu->vmid.vmid_gen)
> +			kvm_call_hyp(__kvm_tlb_flush_vmid, s2_mmu);
> +	}
> +
> +	/*
> +	 * The virtual VMID (modulo CnP) will be used as a key when matching
> +	 * an existing kvm_s2_mmu.
> +	 */
> +	s2_mmu->vttbr = vttbr & ~1UL;
> +	s2_mmu->nested_stage2_enabled = hcr & HCR_VM;
> +
> +out:
> +	atomic_inc(&s2_mmu->refcnt);
> +	return s2_mmu;
> +}
> +
> +void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu)
> +{
> +	mmu->vttbr = 1;
> +	mmu->nested_stage2_enabled = false;
> +	atomic_set(&mmu->refcnt, 0);
> +}
> +
> +void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +	if (is_hyp_ctxt(vcpu)) {
> +		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
> +	} else {
> +		spin_lock(&vcpu->kvm->mmu_lock);

For the allocation + initialization of s2 mmus, kvm->lock is taken in
kvm_vcpu_init_nested(). But here we take kvm->mmu_lock.

Are we in trouble? Or are we expecting
get_s2_mmu_nested()/lookup_s2_mmu() to be called only after
kvm_vcpu_init_nested() has completed on all vcpus of the VM? Otherwise
we could end up using the kvm->arch.nested_mmus when it has been freed
and before it is updated with the new pointer.

(I feel we should be taking kvm->mmu_lock in kvm_vcpu_init_nested() )

> +		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
> +		spin_unlock(&vcpu->kvm->mmu_lock);
> +	}
> +}
> +
> +void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu) {
> +		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
> +		vcpu->arch.hw_mmu = NULL;
> +	}
> +}
>  
>  /*
>   * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
> @@ -37,3 +191,21 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>  
>  	return -EINVAL;
>  }
> +
> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		WARN_ON(atomic_read(&mmu->refcnt));
> +
> +		if (!atomic_read(&mmu->refcnt))
> +			kvm_free_stage2_pgd(mmu);
> +	}
> +	kfree(kvm->arch.nested_mmus);
> +	kvm->arch.nested_mmus = NULL;
> +	kvm->arch.nested_mmus_size = 0;

Don't we need also to take the lock before modifying those? (Apprently
we're killing the VM, so there shouldn't be other user, but just want to
make sure...)

Cheers,

-- 
Julien Thierry
