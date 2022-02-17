Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326DD4BA43B
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbiBQPXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:23:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242387AbiBQPXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:23:47 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34970291F89
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:23:29 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC1A012FC;
        Thu, 17 Feb 2022 07:23:28 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7060C3F66F;
        Thu, 17 Feb 2022 07:23:25 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:23:44 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 36/64] KVM: arm64: nv: Handle shadow stage 2 page
 faults
Message-ID: <Yg5ogI+WuGyI8rpe@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-37-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-37-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 12:18:44PM +0000, Marc Zyngier wrote:
> If we are faulting on a shadow stage 2 translation, we first walk the
> guest hypervisor's stage 2 page table to see if it has a mapping. If
> not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
> create a mapping in the shadow stage 2 page table.
> 
> Note that we have to deal with two IPAs when we got a shadow stage 2
> page fault. One is the address we faulted on, and is in the L2 guest
> phys space. The other is from the guest stage-2 page table walk, and is
> in the L1 guest phys space.  To differentiate them, we rename variables
> so that fault_ipa is used for the former and ipa is used for the latter.
> 
> Co-developed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: rewrote this multiple times...]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |   6 ++
>  arch/arm64/include/asm/kvm_nested.h  |  18 +++++
>  arch/arm64/kvm/mmu.c                 | 102 +++++++++++++++++++++++----
>  arch/arm64/kvm/nested.c              |  48 +++++++++++++
>  4 files changed, 159 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index ff8980a39ee8..dc6eeb0cc8a9 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -602,4 +602,10 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
>  	return test_bit(feature, vcpu->arch.features);
>  }
>  
> +static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
> +{
> +	return (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu &&
> +		vcpu->arch.hw_mmu->nested_stage2_enabled);
> +}
> +
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 48cf288ea238..4fad4d3848ce 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -82,9 +82,27 @@ struct kvm_s2_trans {
>  	u64 upper_attr;
>  };
>  
> +static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
> +{
> +	return trans->output;
> +}
> +
> +static inline unsigned long kvm_s2_trans_size(struct kvm_s2_trans *trans)
> +{
> +	return trans->block_size;
> +}
> +
> +static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
> +{
> +	return trans->esr;
> +}
> +
>  extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  			      struct kvm_s2_trans *result);
>  
> +extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
> +				    struct kvm_s2_trans *trans);
> +extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>  extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>  			    u64 control_bit);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 55525fd5743d..36f7ecb4f81b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -969,7 +969,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>  static unsigned long
>  transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  			    unsigned long hva, kvm_pfn_t *pfnp,
> -			    phys_addr_t *ipap)
> +			    phys_addr_t *ipap, phys_addr_t *fault_ipap)
>  {
>  	kvm_pfn_t pfn = *pfnp;
>  
> @@ -998,6 +998,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  		 * to PG_head and switch the pfn from a tail page to the head
>  		 * page accordingly.
>  		 */
> +		*fault_ipap &= PMD_MASK;
>  		*ipap &= PMD_MASK;
>  		kvm_release_pfn_clean(pfn);
>  		pfn &= ~(PTRS_PER_PMD - 1);
> @@ -1080,15 +1081,17 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  }
>  
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -			  struct kvm_memory_slot *memslot, unsigned long hva,
> -			  unsigned long fault_status)
> +			  struct kvm_s2_trans *nested,
> +			  struct kvm_memory_slot *memslot,
> +			  unsigned long hva, unsigned long fault_status)
>  {
>  	int ret = 0;
> -	bool write_fault, writable, force_pte = false;
> +	bool write_fault, writable;
>  	bool exec_fault;
>  	bool device = false;
>  	bool shared;
>  	unsigned long mmu_seq;
> +	phys_addr_t ipa = fault_ipa;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>  	struct vm_area_struct *vma;
> @@ -1100,6 +1103,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	unsigned long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> +	unsigned long max_map_size = PUD_SIZE;
>  
>  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
>  	write_fault = kvm_is_write_fault(vcpu);
> @@ -1128,7 +1132,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * memslots.
>  	 */
>  	if (logging_active) {
> -		force_pte = true;
> +		max_map_size = vma_pagesize = PAGE_SIZE;

I don't think it's needed to set vma_pagesize here, because...

>  		vma_shift = PAGE_SHIFT;
>  	} else {
>  		vma_shift = get_vma_page_shift(vma, hva);
> @@ -1152,7 +1156,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		fallthrough;
>  	case CONT_PTE_SHIFT:
>  		vma_shift = PAGE_SHIFT;
> -		force_pte = true;
> +		max_map_size = PAGE_SIZE;
>  		fallthrough;
>  	case PAGE_SHIFT:
>  		break;
> @@ -1161,10 +1165,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	}
>  
>  	vma_pagesize = 1UL << vma_shift;

...it's computed here based on vma_shift.

> +
> +	if (kvm_is_shadow_s2_fault(vcpu)) {
> +		ipa = kvm_s2_trans_output(nested);
> +
> +		/*
> +		 * If we're about to create a shadow stage 2 entry, then we
> +		 * can only create a block mapping if the guest stage 2 page
> +		 * table uses at least as big a mapping.
> +		 */
> +		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> +	}
> +
> +	vma_pagesize = min(vma_pagesize, max_map_size);

I find the usage of max_map_size slightly confusing, because when max_map_size
is PAGE_SIZE, vma_pagesize is also PAGE_SIZE, so max_map_size doesn't affect
the result of the min() function above. In all other cases, max_map_size is
PUD_SIZE (the maximum possible value), so the resulting page size is only
influenced by kvm_s2_trans_size() and the vma_pagesize.

Wouldn't it make more sense to rework the hunk above as:

	if (kvm_is_shadow_s2_fault(vcpu)) {
		ipa = kvm_s2_trans_output(nested);
		vma_pagesize = min(kvm_s2_trans_size(nested), vma_pagesize);
	}

and remove the max_map_size local variable entirely? Or is there something I'm
missing here?

> +
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		fault_ipa &= ~(vma_pagesize - 1);
>  
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	gfn = ipa >> PAGE_SHIFT;
> +
>  	mmap_read_unlock(current->mm);
>  
>  	/*
> @@ -1237,12 +1256,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
> +	if (vma_pagesize == PAGE_SIZE &&
> +	    !(max_map_size == PAGE_SIZE || device)) {
>  		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
>  			vma_pagesize = fault_granule;
>  		else
>  			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
>  								   hva, &pfn,
> +								   &ipa,

I don't understand this. The local variable ipa (L1 guest's virtual stage 2
output) is never used after this point. kvm_pgtable_stage2_{map,relax_perms}
below uses fault_ipa (which is the correct address to use).

>  								   &fault_ipa);
>  	}
>  
> @@ -1326,8 +1347,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long fault_status;
> -	phys_addr_t fault_ipa;
> +	phys_addr_t fault_ipa; /* The address we faulted on */
> +	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
>  	struct kvm_memory_slot *memslot;
> +	struct kvm_s2_trans nested_trans;
>  	unsigned long hva;
>  	bool is_iabt, write_fault, writable;
>  	gfn_t gfn;
> @@ -1335,7 +1358,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  
>  	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>  
> -	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> +	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>  
>  	/* Synchronous External Abort? */
> @@ -1356,6 +1379,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	/* Check the stage-2 fault is trans. fault or write fault */
>  	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>  	    fault_status != FSC_ACCESS) {
> +		/*
> +		 * We must never see an address size fault on shadow stage 2
> +		 * page table walk, because we would have injected an addr
> +		 * size fault when we walked the nested s2 page and not
> +		 * create the shadow entry.
> +		 */
>  		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>  			kvm_vcpu_trap_get_class(vcpu),
>  			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> @@ -1365,7 +1394,49 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>  
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	/*
> +	 * We may have faulted on a shadow stage 2 page table if we are
> +	 * running a nested guest.  In this case, we have to resolve the L2
> +	 * IPA to the L1 IPA first, before knowing what kind of memory should
> +	 * back the L1 IPA.
> +	 *
> +	 * If the shadow stage 2 page table walk faults, then we simply inject
> +	 * this to the guest and carry on.
> +	 */
> +	if (kvm_is_shadow_s2_fault(vcpu)) {
> +		u32 esr;
> +
> +		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
> +		esr = kvm_s2_trans_esr(&nested_trans);
> +		if (esr)
> +			kvm_inject_s2_fault(vcpu, esr);

This code reads very strange, because ret has the same semantic meaning as esr,
they are both non-zero when the software stage 2 walker encounters a virtual
stage 2 fault.

I think something like this would read a lot better:

		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested);
		if (ret) {
			esr = kvm_s2_trans_esr(&nested_trans);
			kvm_inject_s2_fault(vcpu, esr);
			goto out_unlock;
		}

> +		if (ret)
> +			goto out_unlock;
> +
> +		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
> +		esr = kvm_s2_trans_esr(&nested_trans);
> +		if (esr)
> +			kvm_inject_s2_fault(vcpu, esr);
> +		if (ret)
> +			goto out_unlock;
> +
> +		ipa = kvm_s2_trans_output(&nested_trans);
> +	} else {
> +		nested_trans = (struct kvm_s2_trans) {
> +			/*
> +			 * Default to RWX so that we don't filter
> +			 * anything while evaluating the permissions.
> +			 */
> +			.writable	= true,
> +			.readable	= true,
> +			.upper_attr	= 0,
> +			.output		= ipa,
> +			.level		= kvm_vcpu_trap_get_fault_level(vcpu),
> +			.esr		= kvm_vcpu_get_esr(vcpu),
> +		};

I don't think this is needed, user_mem_abort() reads nested_trans only if
kvm_is_shadow_s2_fault().

> +	}
> +
> +	gfn = ipa >> PAGE_SHIFT;
>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>  	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>  	write_fault = kvm_is_write_fault(vcpu);
> @@ -1409,13 +1480,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		 * faulting VA. This is always 12 bits, irrespective
>  		 * of the page size.
>  		 */
> -		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
> -		ret = io_mem_abort(vcpu, fault_ipa);
> +		ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
> +		ret = io_mem_abort(vcpu, ipa);
>  		goto out_unlock;
>  	}
>  
>  	/* Userspace should not be able to register out-of-bounds IPAs */
> -	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
> +	VM_BUG_ON(ipa >= kvm_phys_size(vcpu->kvm));
>  
>  	if (fault_status == FSC_ACCESS) {
>  		handle_access_fault(vcpu, fault_ipa);
> @@ -1423,7 +1494,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		goto out_unlock;
>  	}
>  
> -	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
> +	ret = user_mem_abort(vcpu, fault_ipa, &nested_trans,
> +			     memslot, hva, fault_status);
>  	if (ret == 0)
>  		ret = 1;
>  out:

I've tried to follow the nested fault logic in kvm_handle_guest_abort(), but I
found that extremely difficult because it's not clear what checks and error
conditions apply to the nested fault case versus the regular case.

For example, when handling this condition:

if (kvm_is_error_hva(hva) || (write_fault && !writable))

I think the second part (write_fault && !writable) is always false in the nested
case, because kvm_s2_handle_perm_fault() already has this check.

This part:

		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
			kvm_incr_pc(vcpu);
			ret = 1;
			goto out_unlock;
		}

should the DABT be reflected back to the L1 guest? At this point we know that
fault_ipa is mapped to ipa in the virtual stage 2.

And this:

	if (fault_status == FSC_ACCESS) {
		handle_access_fault(vcpu, fault_ipa);
		ret = 1;
		goto out_unlock;
	}

I couldn't figure out if kvm_walk_nested_s2() alreay handles that case.

IMO, it might make handle_guest_abort() a lot easier to understand if the two
paths were clearly separated into distinct functions, one that handles the
nested abort case, and one that handle the normal case. On the other hand, that
might make maintaining the code a lot harder.

What do you think?

Thanks,
Alex

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c2a99b672368..0a9708f776fc 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -108,6 +108,15 @@ static u32 compute_fsc(int level, u32 fsc)
>  	return fsc | (level & 0x3);
>  }
>  
> +static int esr_s2_fault(struct kvm_vcpu *vcpu, int level, u32 fsc)
> +{
> +	u32 esr;
> +
> +	esr = kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC;
> +	esr |= compute_fsc(level, fsc);
> +	return esr;
> +}
> +
>  static int check_base_s2_limits(struct s2_walk_info *wi,
>  				int level, int input_size, int stride)
>  {
> @@ -457,6 +466,45 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +/*
> + * Returns non-zero if permission fault is handled by injecting it to the next
> + * level hypervisor.
> + */
> +int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
> +{
> +	unsigned long fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
> +	bool forward_fault = false;
> +
> +	trans->esr = 0;
> +
> +	if (fault_status != FSC_PERM)
> +		return 0;
> +
> +	if (kvm_vcpu_trap_is_iabt(vcpu)) {
> +		forward_fault = (trans->upper_attr & BIT(54));
> +	} else {
> +		bool write_fault = kvm_is_write_fault(vcpu);
> +
> +		forward_fault = ((write_fault && !trans->writable) ||
> +				 (!write_fault && !trans->readable));
> +	}
> +
> +	if (forward_fault) {
> +		trans->esr = esr_s2_fault(vcpu, trans->level, ESR_ELx_FSC_PERM);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
> +{
> +	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.far_el2, FAR_EL2);
> +	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.hpfar_el2, HPFAR_EL2);
> +
> +	return kvm_inject_nested_sync(vcpu, esr_el2);
> +}
> +
>  /*
>   * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>   * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
> -- 
> 2.30.2
> 
