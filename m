Return-Path: <kvm+bounces-16790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 017718BDB3C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67E991F2308F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0EE6F079;
	Tue,  7 May 2024 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T5cp43p+"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FE66EB5C
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 06:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715062645; cv=none; b=kR5Ap8xgbduYD7cZffxQA06NUnNnvFGGVBI6tH01pr284OA1QU4hINiNrDWuVaTI/d/Fk/00BUttZpGsgCoFEfk0TAEQuvzqRdOmS6hZSxyxyvgbMr1uqZOc+v0bEGBupBmoPk8oN2u68U3eE36KKmB14VS4XtUmh+ZNqho6Fig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715062645; c=relaxed/simple;
	bh=3dZPkA+nwSyMTd6U+V4rXlS76mTp/E5yZ51rAhVLz9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxph3Rc2Px6Oi5vxWrDLvztw8BGtkJFOkAqR0USBLkxDFoLlCxZ2hvtSSoW54H1PJyt8Vmfmy/Q4sKHZAn1U1j+gT2KJ9igDG4g1NcceGmJW1k5RBrrb83jSyDfAXdtRZhORU1cAsZFFIXBKH7OsRdlF2KacOx5/D0gboSOVeoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T5cp43p+; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 7 May 2024 06:17:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715062639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Be0ITYf24HMA4luYiI4DDGp0ibKW+UMcO5ndzu1yIIY=;
	b=T5cp43p+XIXyD5E/iiZYmIs4lEyXFbq7ZJKGwSVFjuX+dJKtkMdvwqz8M3faSUyZ4IMfJL
	ZNWx5wS3XSZylbuLsBYWjsf61QaqU1E87pBwuofkj36UAP976tnoisRKXBWoKpxGObiEYJ
	+1xFv91BX7Rv4YDFviQypddpT6oX8oc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 01/16] KVM: arm64: nv: Support multiple nested Stage-2
 mmu structures
Message-ID: <ZjnHaYjgMqcpfxdV@linux.dev>
References: <20240409175448.3507472-1-maz@kernel.org>
 <20240409175448.3507472-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409175448.3507472-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Tue, Apr 09, 2024 at 06:54:33PM +0100, Marc Zyngier wrote:
> +static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
> +{
> +	return !(mmu->tlb_vttbr & 1);
> +}

More readable if you use VTTBR_CNP_BIT here.

>  struct kvm_arch_memory_slot {
>  };
>  
> @@ -264,6 +296,14 @@ struct kvm_arch {
>  	 */
>  	u64 fgu[__NR_FGT_GROUP_IDS__];
>  
> +	/*
> +	 * Stage 2 paging state for VMs with nested S2 using a virtual
> +	 * VMID.
> +	 */
> +	struct kvm_s2_mmu *nested_mmus;
> +	size_t nested_mmus_size;
> +	int nested_mmus_next;
> +
>  	/* Interrupt controller */
>  	struct vgic_dist	vgic;
>  
> @@ -1239,6 +1279,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
>  
>  int __init kvm_set_ipa_limit(void);
> +u32 kvm_get_pa_bits(struct kvm *kvm);
>  
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  struct kvm *kvm_arch_alloc_vm(void);
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index d5e48d870461..b48c9e12e7ff 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -98,6 +98,7 @@ alternative_cb_end
>  #include <asm/mmu_context.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_host.h>
> +#include <asm/kvm_nested.h>
>  
>  void kvm_update_va_mask(struct alt_instr *alt,
>  			__le32 *origptr, __le32 *updptr, int nr_inst);
> @@ -165,6 +166,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
>  void __init free_hyp_pgds(void);
>  
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>  void stage2_unmap_vm(struct kvm *kvm);
>  int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
>  void kvm_uninit_stage2_mmu(struct kvm *kvm);
> @@ -326,5 +328,12 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>  {
>  	return container_of(mmu->arch, struct kvm, arch);
>  }
> +
> +static inline u64 get_vmid(u64 vttbr)
> +{
> +	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
> +		VTTBR_VMID_SHIFT;
> +}
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index c77d795556e1..1a4004e7573d 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -60,6 +60,12 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
>  	return ttbr0 & ~GENMASK_ULL(63, 48);
>  }
>  
> +extern void kvm_init_nested(struct kvm *kvm);
> +extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
> +extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
> +extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
> +extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
> +extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
>  
>  int kvm_init_nv_sysregs(struct kvm *kvm);
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c4a0a35e02c7..bb19c53b6539 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -147,6 +147,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	mutex_unlock(&kvm->lock);
>  #endif
>  
> +	kvm_init_nested(kvm);
> +
>  	ret = kvm_share_hyp(kvm, kvm + 1);
>  	if (ret)
>  		return ret;
> @@ -433,6 +435,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	struct kvm_s2_mmu *mmu;
>  	int *last_ran;
>  
> +	if (vcpu_has_nv(vcpu))
> +		kvm_vcpu_load_hw_mmu(vcpu);
> +
>  	mmu = vcpu->arch.hw_mmu;
>  	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
>  
> @@ -483,6 +488,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_timer_vcpu_put(vcpu);
>  	kvm_vgic_put(vcpu);
>  	kvm_vcpu_pmu_restore_host(vcpu);
> +	if (vcpu_has_nv(vcpu))
> +		kvm_vcpu_put_hw_mmu(vcpu);
>  	kvm_arm_vmid_clear_active();
>  
>  	vcpu_clear_on_unsupported_cpu(vcpu);
> @@ -1346,6 +1353,10 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>  	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
>  		ret = kvm_arm_set_default_pmu(kvm);
>  
> +	/* Prepare for nested if required */
> +	if (!ret)
> +		ret = kvm_vcpu_init_nested(vcpu);
> +
>  	return ret;
>  }
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index dc04bc767865..24a946814831 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -328,7 +328,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>  				   may_block));
>  }
>  
> -static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>  {
>  	__unmap_stage2_range(mmu, start, size, true);
>  }
> @@ -855,21 +855,9 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.icache_inval_pou	= invalidate_icache_guest_page,
>  };
>  
> -/**
> - * kvm_init_stage2_mmu - Initialise a S2 MMU structure
> - * @kvm:	The pointer to the KVM structure
> - * @mmu:	The pointer to the s2 MMU structure
> - * @type:	The machine type of the virtual machine
> - *
> - * Allocates only the stage-2 HW PGD level table(s).
> - * Note we don't need locking here as this is only called when the VM is
> - * created, which can only be done once.
> - */
> -int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
> +static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>  {
>  	u32 kvm_ipa_limit = get_kvm_ipa_limit();
> -	int cpu, err;
> -	struct kvm_pgtable *pgt;
>  	u64 mmfr0, mmfr1;
>  	u32 phys_shift;
>  
> @@ -896,11 +884,58 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
>  	mmu->vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
>  
> +	return 0;
> +}
> +
> +/**
> + * kvm_init_stage2_mmu - Initialise a S2 MMU structure
> + * @kvm:	The pointer to the KVM structure
> + * @mmu:	The pointer to the s2 MMU structure
> + * @type:	The machine type of the virtual machine
> + *
> + * Allocates only the stage-2 HW PGD level table(s).
> + * Note we don't need locking here as this is only called in two cases:
> + *
> + * - when the VM is created, which can't race against anything
> + *
> + * - when secondary kvm_s2_mmu structures are initialised for NV
> + *   guests, and the caller must hold kvm->lock as this is called on a
> + *   per-vcpu basis.
> + */
> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
> +{
> +	int cpu, err;
> +	struct kvm_pgtable *pgt;
> +
> +	/*
> +	 * If we already have our page tables in place, and that the
> +	 * MMU context is the canonical one, we have a bug somewhere,
> +	 * as this is only supposed to ever happen once per VM.
> +	 *
> +	 * Otherwise, we're building nested page tables, and that's
> +	 * probably because userspace called KVM_ARM_VCPU_INIT more
> +	 * than once on the same vcpu. Since that's actually legal,
> +	 * don't kick a fuss and leave gracefully.
> +	 */
>  	if (mmu->pgt != NULL) {
> +		if (&kvm->arch.mmu != mmu)

A helper might be a good idea, I see this repeated several times:

static inline bool kvm_is_nested_s2_mmu(struct kvm_s2_mmu *mmu)
{
	return &arch->mmu != mmu;
}

> +			return 0;
> +
>  		kvm_err("kvm_arch already initialized?\n");
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * We only initialise the IPA range on the canonical MMU, so
> +	 * the type is meaningless in all other situations.
> +	 */
> +	if (&kvm->arch.mmu != mmu)
> +		type = kvm_get_pa_bits(kvm);

I'm not sure I follow this comment, because kvm_init_ipa_range() still
gets called on nested MMUs. Is this suggesting that the configured IPA
limit of the shadow MMUs doesn't matter as they can only ever map things
in the canonical IPA space?

> +	err = kvm_init_ipa_range(mmu, type);
> +	if (err)
> +		return err;
> +
>  	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL_ACCOUNT);
>  	if (!pgt)
>  		return -ENOMEM;
> @@ -925,6 +960,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  
>  	mmu->pgt = pgt;
>  	mmu->pgd_phys = __pa(pgt->pgd);
> +
> +	if (&kvm->arch.mmu != mmu)
> +		kvm_init_nested_s2_mmu(mmu);
> +
>  	return 0;
>  
>  out_destroy_pgtable:
> @@ -976,7 +1015,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>  
>  		if (!(vma->vm_flags & VM_PFNMAP)) {
>  			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
> -			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
> +			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
>  		}
>  		hva = vm_end;
>  	} while (hva < reg_end);
> @@ -2054,11 +2093,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>  {
>  }
>  
> -void kvm_arch_flush_shadow_all(struct kvm *kvm)
> -{
> -	kvm_uninit_stage2_mmu(kvm);
> -}
> -
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot)
>  {
> @@ -2066,7 +2100,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  	phys_addr_t size = slot->npages << PAGE_SHIFT;
>  
>  	write_lock(&kvm->mmu_lock);
> -	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> +	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
>  	write_unlock(&kvm->mmu_lock);
>  }
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index ced30c90521a..1f4f80a8c011 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -7,7 +7,9 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  
> +#include <asm/kvm_arm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  #include <asm/kvm_nested.h>
>  #include <asm/sysreg.h>
>  
> @@ -16,6 +18,209 @@
>  /* Protection against the sysreg repainting madness... */
>  #define NV_FTR(r, f)		ID_AA64##r##_EL1_##f
>  
> +void kvm_init_nested(struct kvm *kvm)
> +{
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
> +	if (!test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->kvm->arch.vcpu_features))
> +		return 0;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +		return -EINVAL;

nitpick: maybe guard the call to kvm_vcpu_init_nested() with
vcpu_has_nv() and collapse these into

	if (!vcpu_has_nv(vcpu))
		return -EINVAL;

> +	/*
> +	 * Let's treat memory allocation failures as benign: If we fail to
> +	 * allocate anything, return an error and keep the allocated array
> +	 * alive. Userspace may try to recover by intializing the vcpu
> +	 * again, and there is no reason to affect the whole VM for this.
> +	 */

This code feels a bit tricky, and I'm not sure much will be done to
recover the VM in practice should this allocation / ioctl fail.

Is it possible to do this late in kvm_arch_vcpu_run_pid_change() and
only have the first vCPU to reach the call do the initialization for the
whole VM? We could then dispose of the reallocation / fixup scheme
below.

If we keep this code...

> +	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
> +	tmp = krealloc(kvm->arch.nested_mmus,
> +		       num_mmus * sizeof(*kvm->arch.nested_mmus),
> +		       GFP_KERNEL_ACCOUNT | __GFP_ZERO);

Just do an early 'return -ENOMEM' here to cut a level of indendation for
the rest that follows.

> +	if (tmp) {
> +		/*
> +		 * If we went through a realocation, adjust the MMU
> +		 * back-pointers in the previously initialised
> +		 * pg_table structures.

nitpick: pgtable or kvm_pgtable structures

> +		 */
> +		if (kvm->arch.nested_mmus != tmp) {
> +			int i;
> +
> +			for (i = 0; i < num_mmus - 2; i++)
> +				tmp[i].pgt->mmu = &tmp[i];
> +		}
> +
> +		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1], 0) ||
> +		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2], 0)) {
> +			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
> +			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
> +		} else {
> +			kvm->arch.nested_mmus_size = num_mmus;
> +			ret = 0;
> +		}
> +
> +		kvm->arch.nested_mmus = tmp;
> +	}
> +
> +	return ret;
> +}
> +
> +struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
> +{
> +	bool nested_stage2_enabled;
> +	u64 vttbr, vtcr, hcr;
> +	struct kvm *kvm;
> +	int i;
> +
> +	kvm = vcpu->kvm;

nit: just do this when declaring the local.

> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
> +	vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
> +	hcr = vcpu_read_sys_reg(vcpu, HCR_EL2);
> +
> +	nested_stage2_enabled = hcr & HCR_VM;
> +
> +	/* Don't consider the CnP bit for the vttbr match */
> +	vttbr = vttbr & ~VTTBR_CNP_BIT;

nit: &=

> +	/*
> +	 * Two possibilities when looking up a S2 MMU context:
> +	 *
> +	 * - either S2 is enabled in the guest, and we need a context that is
> +         *   S2-enabled and matches the full VTTBR (VMID+BADDR) and VTCR,
> +         *   which makes it safe from a TLB conflict perspective (a broken
> +         *   guest won't be able to generate them),
> +	 *
> +	 * - or S2 is disabled, and we need a context that is S2-disabled
> +         *   and matches the VMID only, as all TLBs are tagged by VMID even
> +         *   if S2 translation is disabled.
> +	 */

Looks like some spaces snuck in and got the indendation weird.

-- 
Thanks,
Oliver

