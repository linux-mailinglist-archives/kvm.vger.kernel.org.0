Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AC64BFE39
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 17:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiBVQNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 11:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBVQNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 11:13:24 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7733C165C38
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 08:12:58 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C9711063;
        Tue, 22 Feb 2022 08:12:58 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB3A33F70D;
        Tue, 22 Feb 2022 08:12:54 -0800 (PST)
Date:   Tue, 22 Feb 2022 16:13:14 +0000
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
Subject: Re: [PATCH v6 38/64] KVM: arm64: nv: Unmap/flush shadow stage 2 page
 tables
Message-ID: <YhULmh8BraFF5kd/@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-39-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-39-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 12:18:46PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Unmap/flush shadow stage 2 page tables for the nested VMs as well as the
> stage 2 page table for the guest hypervisor.
> 
> Note: A bunch of the code in mmu.c relating to MMU notifiers is
> currently dealt with in an extremely abrupt way, for example by clearing
> out an entire shadow stage-2 table. This will be handled in a more
> efficient way using the reverse mapping feature in a later version of
> the patch series.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_mmu.h    |  3 +++
>  arch/arm64/include/asm/kvm_nested.h |  3 +++
>  arch/arm64/kvm/mmu.c                | 31 +++++++++++++++++++----
>  arch/arm64/kvm/nested.c             | 39 +++++++++++++++++++++++++++++
>  4 files changed, 71 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 0750d022bbf8..afad4a27a6f2 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -160,6 +160,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>  			   void __iomem **haddr);
>  int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  			     void **haddr);
> +void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
> +			    phys_addr_t addr, phys_addr_t end);
>  void free_hyp_pgds(void);
>  
>  void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
> @@ -168,6 +170,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable);
> +void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
>  
>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index f4b846d09d86..8915bead0633 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -118,6 +118,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>  				    struct kvm_s2_trans *trans);
>  extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
> +extern void kvm_nested_s2_wp(struct kvm *kvm);
> +extern void kvm_nested_s2_clear(struct kvm *kvm);

Why is the function that removes all the entries from kvm->arch.mmu called
unmap_stage2 and the function that removes all the entries from the nested mmus
called s2_clear? Would be nice if the latter also used the verb unmap instead of
clear, to make the code easier to understand.

> +extern void kvm_nested_s2_flush(struct kvm *kvm);
>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>  extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>  			    u64 control_bit);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7c56e1522d3c..b9b11be65009 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -190,13 +190,20 @@ void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>  	__unmap_stage2_range(mmu, start, size, true);
>  }
>  
> +void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
> +			    phys_addr_t addr, phys_addr_t end)
> +{
> +	stage2_apply_range_resched(kvm_s2_mmu_to_kvm(mmu), addr, end, kvm_pgtable_stage2_flush);
> +}
> +
>  static void stage2_flush_memslot(struct kvm *kvm,
>  				 struct kvm_memory_slot *memslot)
>  {
>  	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>  	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
> +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
>  
> -	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
> +	kvm_stage2_flush_range(mmu, addr, end);
>  }
>  
>  /**
> @@ -219,6 +226,8 @@ static void stage2_flush_vm(struct kvm *kvm)
>  	kvm_for_each_memslot(memslot, bkt, slots)
>  		stage2_flush_memslot(kvm, memslot);
>  
> +	kvm_nested_s2_flush(kvm);
> +
>  	spin_unlock(&kvm->mmu_lock);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
> @@ -742,6 +751,8 @@ void stage2_unmap_vm(struct kvm *kvm)
>  	kvm_for_each_memslot(memslot, bkt, slots)
>  		stage2_unmap_memslot(kvm, memslot);
>  
> +	kvm_nested_s2_clear(kvm);
> +
>  	spin_unlock(&kvm->mmu_lock);
>  	mmap_read_unlock(current->mm);
>  	srcu_read_unlock(&kvm->srcu, idx);
> @@ -814,12 +825,12 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  }
>  
>  /**
> - * stage2_wp_range() - write protect stage2 memory region range
> + * kvm_stage2_wp_range() - write protect stage2 memory region range
>   * @mmu:        The KVM stage-2 MMU pointer
>   * @addr:	Start address of range
>   * @end:	End address of range
>   */
> -static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> +void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>  	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
> @@ -851,7 +862,8 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>  	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
>  
>  	spin_lock(&kvm->mmu_lock);
> -	stage2_wp_range(&kvm->arch.mmu, start, end);
> +	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
> +	kvm_nested_s2_wp(kvm);
>  	spin_unlock(&kvm->mmu_lock);
>  	kvm_flush_remote_tlbs(kvm);
>  }
> @@ -875,7 +887,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>  	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
>  	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
>  
> -	stage2_wp_range(&kvm->arch.mmu, start, end);
> +	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
>  }
>  
>  /*
> @@ -890,6 +902,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  		gfn_t gfn_offset, unsigned long mask)
>  {
>  	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
> +	kvm_nested_s2_wp(kvm);
>  }
>  
>  static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> @@ -1529,6 +1542,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  			     (range->end - range->start) << PAGE_SHIFT,
>  			     range->may_block);
>  
> +	kvm_nested_s2_clear(kvm);
>  	return false;
>  }
>  
> @@ -1560,6 +1574,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  			       PAGE_SIZE, __pfn_to_phys(pfn),
>  			       KVM_PGTABLE_PROT_R, NULL);
>  
> +	kvm_nested_s2_clear(kvm);
>  	return false;
>  }
>  
> @@ -1578,6 +1593,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  					range->start << PAGE_SHIFT);
>  	pte = __pte(kpte);
>  	return pte_valid(pte) && pte_young(pte);
> +
> +	/*
> +	 * TODO: Handle nested_mmu structures here using the reverse mapping in
> +	 * a later version of patch series.
> +	 */

Hm... does this mean that at the moment KVM cannot age a page in a nested MMU?

>  }
>  
>  bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> @@ -1789,6 +1809,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  
>  	spin_lock(&kvm->mmu_lock);
>  	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> +	kvm_nested_s2_clear(kvm);
>  	spin_unlock(&kvm->mmu_lock);
>  }
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index a74ffb1d2064..b39af4d87787 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -505,6 +505,45 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
>  	return kvm_inject_nested_sync(vcpu, esr_el2);
>  }
>  
> +/* expects kvm->mmu_lock to be held */

The function could do a lockdep_assert_held(&kvm->mmu_lock), which would serve
the double purpose of documenting that the lock should be held and also
verifying that that is indeed the case when lockdep checking is enabled.

> +void kvm_nested_s2_wp(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(kvm));

I'm not sure about KVM/arm64's plans to add support for dirty ring, but doing
this means that there is a change that duplicate pfns are added to the ring if
the same pfn is present in multiple MMUs.

Thanks,
Alex

> +	}
> +}
> +
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_clear(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
> +	}
> +}
> +
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_flush(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(kvm));
> +	}
> +}
> +
>  /*
>   * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>   * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
> -- 
> 2.30.2
> 
