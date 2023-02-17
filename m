Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D369B0D6
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjBQQ2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjBQQ2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:28:09 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3AE39CDE
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:27:44 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id g15-20020a056a000b8f00b005a8ea29c7a6so835337pfj.15
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YVD4HPM/U13lNq5dcSbfCi+RC3l2lmmTDVnKk+U87I=;
        b=r6zpCgId+uislgL2VVqaVYl20g/yj/ZxvMorG6frzYxsXigXoBoC4GaqLH/wBq4mb+
         RejV930LZfpO7fKKbvv6E+KaaRpzxx1gY58ABOIPQwUPIjLpmmnJdDj/6rNcWmjWIJfe
         5BzRJYORELvSFKpOvDBNnF6ZroaZ7wivI32ru2/cQ7tSgPCfLvtw6Hi/hXe3B6Bcb0GE
         mz/LnDcQgMSJM+4MVP2nH75vjPeikaqWCWyH1R91i3VG5Vnjlqy0N0q6OL1+nzgR8J5Y
         1z025g8HTtIwrRNKZKyGOXPAFSyWGQA6voopYCTtnT4gw3L9QejJKyTO3lJmFGnNhRRo
         eJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YVD4HPM/U13lNq5dcSbfCi+RC3l2lmmTDVnKk+U87I=;
        b=K7n3VzFlqxQ5SZ/bzfWqgQrTF09FHqGNrzOSfQ3Qfpf4CYrJPESqaCMzCt3SfSSPEW
         zISOk+htSGmMmzTU8zij+31rs7CNrrmilWLXZN9VKbuCQhB+iTgQwxS+A9wWqo4+RosE
         5cW3w390YMJleMDQU4O28+xKhoNrC8rWq8oNKPurd6I4xvRSFcgtK+P24DiR/wuxxJ4i
         C2k2dUo6FvcIIfSpbZzlYpDbYZtj7REb5/Y9ybp0hJg8K4Esk+vGRD2uV0bAD9yZlu/K
         Ajc2gWVP2DOx9RMIuc/GbnOCoe2hGygm/hz8IFfcGcihmnoUdnNUBnm6KTWfbWD8pwGm
         wiVA==
X-Gm-Message-State: AO0yUKV8S1iIC0M/aRtDqFmeHrodFwkZ8h3/86wWhtklVk9lMyBP7ynH
        RLMaA3vw7r02Epi3TYC6eoxF+wsXre8=
X-Google-Smtp-Source: AK7set/1TAAUCASnSdsSbh6GvLTlKAx3R2Pc64lwPVqnFhcILEnQ1mn6YtGj91WtZHv454ZGEIXwznWd6Lk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c3:b0:199:1a40:dccc with SMTP id
 e3-20020a17090301c300b001991a40dcccmr270951plh.9.1676651263720; Fri, 17 Feb
 2023 08:27:43 -0800 (PST)
Date:   Fri, 17 Feb 2023 08:27:42 -0800
In-Reply-To: <20230217041230.2417228-3-yuzhao@google.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
Message-ID: <Y++q/lglE6FJBdjt@google.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023, Yu Zhao wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6aaae18f1854..d2995c9e8f07 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1367,6 +1367,12 @@ struct kvm_arch {
>  	 *	the MMU lock in read mode + the tdp_mmu_pages_lock or
>  	 *	the MMU lock in write mode
>  	 *
> +	 * kvm_arch_test_clear_young() is a special case. It relies on two

No, it's not.  The TDP MMU already employs on RCU and CMPXCHG.  Just drop the
entire comment.

> +	 * techniques, RCU and cmpxchg, to safely test and clear the accessed
> +	 * bit without taking the MMU lock. The former protects KVM page tables
> +	 * from being freed while the latter clears the accessed bit atomically
> +	 * against both the hardware and other software page table walkers.
> +	 *
>  	 * Roots will remain in the list until their tdp_mmu_root_count
>  	 * drops to zero, at which point the thread that decremented the
>  	 * count to zero should removed the root from the list and clean
> @@ -2171,4 +2177,25 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>  	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
>  	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
>  
> +extern u64 __read_mostly shadow_accessed_mask;
> +
> +/*
> + * Returns true if A/D bits are supported in hardware and are enabled by KVM.
> + * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
> + * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
> + * scenario where KVM is using A/D bits for L1, but not L2.
> + */
> +static inline bool kvm_ad_enabled(void)
> +{
> +	return shadow_accessed_mask;
> +}

Absolutely not.  This information is not getting directly exposed outside of KVM.

> +
> +/* see the comments on the generic kvm_arch_has_test_clear_young() */
> +#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
> +static inline bool kvm_arch_has_test_clear_young(void)
> +{
> +	return IS_ENABLED(CONFIG_KVM) && IS_ENABLED(CONFIG_X86_64) &&
> +	       (!IS_REACHABLE(CONFIG_KVM) || (kvm_ad_enabled() && tdp_enabled));
> +}

Pending the justification for why this is KVM-only, I would strongly prefer we
find a way to have the mmu_notifier framework track whether or not any listeners
have a test_clear_young().  E.g. have KVM nullify its hook during module load.

> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 6f54dc9409c9..0dc7fed1f3fd 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -153,7 +153,6 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
>  extern u64 __read_mostly shadow_nx_mask;
>  extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
>  extern u64 __read_mostly shadow_user_mask;
> -extern u64 __read_mostly shadow_accessed_mask;
>  extern u64 __read_mostly shadow_dirty_mask;
>  extern u64 __read_mostly shadow_mmio_value;
>  extern u64 __read_mostly shadow_mmio_mask;
> @@ -247,17 +246,6 @@ static inline bool is_shadow_present_pte(u64 pte)
>  	return !!(pte & SPTE_MMU_PRESENT_MASK);
>  }
>  
> -/*
> - * Returns true if A/D bits are supported in hardware and are enabled by KVM.
> - * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
> - * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
> - * scenario where KVM is using A/D bits for L1, but not L2.
> - */
> -static inline bool kvm_ad_enabled(void)
> -{
> -	return !!shadow_accessed_mask;
> -}

As Oliver said in the ARM patch, _if_ this is justified, please do code movement
in a separate patch.

> -
>  static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
>  {
>  	return sp->role.ad_disabled;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d6df38d371a0..9028e09f1aab 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1309,6 +1309,47 @@ bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
>  }
>  
> +bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range,
> +			       gfn_t lsb_gfn, unsigned long *bitmap)
> +{
> +	struct kvm_mmu_page *root;
> +
> +	if (WARN_ON_ONCE(!kvm_arch_has_test_clear_young()))
> +		return false;
> +
> +	if (kvm_memslots_have_rmaps(kvm))

This completely disables the API on VMs that have _ever_ run a nested VM.  I doubt
that's the intended behavior.

> +		return false;
> +
> +	/* see the comments on kvm_arch->tdp_mmu_roots */
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
> +		struct tdp_iter iter;
> +
> +		if (kvm_mmu_page_as_id(root) != range->slot->as_id)
> +			continue;

for_each_tdp_mmu_root() does this for you.

> +
> +		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
> +			u64 *sptep = rcu_dereference(iter.sptep);

kvm_tdp_mmu_read_spte(), thought it's not clear to me why this doesn't test+clear
the SPTE's accessed bit and then toggle the bitmap.

> +			u64 new_spte = iter.old_spte & ~shadow_accessed_mask;
> +
> +			VM_WARN_ON_ONCE(!page_count(virt_to_page(sptep)));

This doesn't do what I assume it's intended to do.  The sptep points at a KVM,
a.k.a. kernel, allocated page, not at guest memory.  Assuming the intent is to
assert that the memory being aged has an elevated refcount, this would need to
extract the pfn out of the SPTE and get the struct page for that.  But that's
completely unsafe because KVM supports mapping VM_PFNMAP and VM_IO memory into
the guest.  Maybe the proposed caller only operates on struct page memory, but
I am not willing to make that assumption in KVM.

TL;DR: drop this.

> +			VM_WARN_ON_ONCE(iter.gfn < range->start || iter.gfn >= range->end);

This adds no value, KVM is completely hosed if tdp_root_for_each_leaf_pte() botches
the ranges.

> +
> +			if (new_spte == iter.old_spte)
> +				continue;
> +
> +			/* see the comments on the generic kvm_arch_has_test_clear_young() */

No, "see xyz" for unintuitive logic is not acceptable.  Add a helper and document
the logic there, don't splatter "see XYZ" comments everywhere.

> +			if (__test_and_change_bit(lsb_gfn - iter.gfn, bitmap))
> +				cmpxchg64(sptep, iter.old_spte, new_spte);

Clearing a single bit doesn't need a CMPXCHG.  Please weigh in on a relevant series
that is modifying the aging flows[*], I want to have exactly one helper for aging
TDP MMU SPTEs.

[*] https://lore.kernel.org/all/20230211014626.3659152-5-vipinsh@google.com
