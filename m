Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47968486BE2
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 22:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244242AbiAFV21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 16:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244230AbiAFV20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 16:28:26 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7BFC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 13:28:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d10-20020a17090a498a00b001b33bc40d01so1713092pjh.1
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 13:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pMGdYGG1ZxoWCuyMaxJ/nU/mdsb0CLA9UlhCeDzSEjg=;
        b=GiBCfZwFa6TGhf5fkt/FivjGwFrRTB4ezEAfFvxYNZYArnV1CNBsuixANSG4tzJ1c4
         +LEYHNo4zDhJJogxD+39uI4yf6c19UfrB+IOTVTxwCJ0GRx+2FWWq5hijxN+QOuNlxJL
         6fpnp8Tu/gMjzXaOOR3ZM2GPyopvbGhk/fo9gmCsWzI1ST7lkkEMhq6IwvzEleEmuyTI
         0wdbE4XSAU7oJoILck8qykkmw9+W5hDSM3Tyx7D1beXrWbHdmaPCAR054Rl0XI9lOoIw
         5OSmJs2AQeM49EXQuXYruwFfgYz3fRZxe3DoIbnjkAnMH614dOps5AnuBTOnxz7zUEYf
         feDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pMGdYGG1ZxoWCuyMaxJ/nU/mdsb0CLA9UlhCeDzSEjg=;
        b=ztN9AgO5S7Aq2o8/TCjNh7Zv5nWUQByCC8pQDTDFSjOtloOk3PJwW5ymeVSgWRg2X1
         xxNidCjL7IqluC4Sy61eI5atHMzDTOGwjmm64CoREbHxgbQVp39aMjekKg7Yzi+RJW/E
         ZLK82U9Z6zPNOAUr+2KeRdF6t31LaZgAc/LrwuFHADIG+ORLvTJS8krhFArlHlSFVKvH
         XeBhw5opy4KHbi/w9X+q+aFy2k8uVQt5e3l5wuKpVh7beN6etUK0yttNNQSOGf/kInkT
         6cJgptsELR7jbTR9edBn3zhwvbRnnTceMXRCmkyflWWtQuFaywiTuvVKJoQDmL/mb05s
         2/Yw==
X-Gm-Message-State: AOAM533L+NB36GaYnL31TEwpE2YcNSuKvoPIGCebdTTVY5cRb9Yp0mMY
        fn/DZhfz5uHV9edxLgZZBSRjpA==
X-Google-Smtp-Source: ABdhPJz42VI6+24oFVbvkxjylMf204tP5nX7p/AlCjFGHotUdONdiq10VIks+ghypGR9xYirXBzrqA==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr12184515pjb.160.1641504505772;
        Thu, 06 Jan 2022 13:28:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ot6sm3898250pjb.32.2022.01.06.13.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 13:28:25 -0800 (PST)
Date:   Thu, 6 Jan 2022 21:28:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty
 logging is enabled
Message-ID: <Ydde9VE9vD/qo/wN@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-10-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> When dirty logging is enabled without initially-all-set, attempt to
> split all huge pages in the memslot down to 4KB pages so that vCPUs
> do not have to take expensive write-protection faults to split huge
> pages.
> 
> Huge page splitting is best-effort only. This commit only adds the
> support for the TDP MMU, and even there splitting may fail due to out
> of memory conditions. Failures to split a huge page is fine from a
> correctness standpoint because we still always follow it up by write-
> protecting any remaining huge pages.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   3 +
>  arch/x86/kvm/mmu/mmu.c          |  14 +++
>  arch/x86/kvm/mmu/spte.c         |  59 ++++++++++++
>  arch/x86/kvm/mmu/spte.h         |   1 +
>  arch/x86/kvm/mmu/tdp_mmu.c      | 165 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.h      |   5 +
>  arch/x86/kvm/x86.c              |  10 ++
>  7 files changed, 257 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e863d569c89a..4a507109e886 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1573,6 +1573,9 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
>  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  				      const struct kvm_memory_slot *memslot,
>  				      int start_level);
> +void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
> +				       const struct kvm_memory_slot *memslot,
> +				       int target_level);
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  				   const struct kvm_memory_slot *memslot);
>  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c2cb4dd1f11..9116c6a4ced1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5807,6 +5807,20 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>  }
>  
> +void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
> +				       const struct kvm_memory_slot *memslot,
> +				       int target_level)
> +{
> +	u64 start = memslot->base_gfn;
> +	u64 end = start + memslot->npages;
> +
> +	if (is_tdp_mmu_enabled(kvm)) {
> +		read_lock(&kvm->mmu_lock);
> +		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
> +		read_unlock(&kvm->mmu_lock);
> +	}
> +}
> +
>  static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  					 struct kvm_rmap_head *rmap_head,
>  					 const struct kvm_memory_slot *slot)
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index fd34ae5d6940..11d0b3993ba5 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -191,6 +191,65 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	return wrprot;
>  }
>  
> +static u64 mark_spte_executable(u64 spte)
> +{
> +	bool is_access_track = is_access_track_spte(spte);
> +
> +	if (is_access_track)
> +		spte = restore_acc_track_spte(spte);
> +
> +	spte &= ~shadow_nx_mask;
> +	spte |= shadow_x_mask;
> +
> +	if (is_access_track)
> +		spte = mark_spte_for_access_track(spte);
> +
> +	return spte;
> +}
> +
> +/*
> + * Construct an SPTE that maps a sub-page of the given huge page SPTE where
> + * `index` identifies which sub-page.
> + *
> + * This is used during huge page splitting to build the SPTEs that make up the

Nit, to be consistent with the kernel, s/huge page/hugepage.

> + * new page table.
> + */
> +u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index, unsigned int access)

Newline.  Actually, just drop @access since there's exactly one caller that
unconditionally passes ACC_ALL.

> +{
> +	u64 child_spte;
> +	int child_level;
> +
> +	if (WARN_ON(is_mmio_spte(huge_spte)))
> +		return 0;

Unnecessary, this is covered by is_shadow_present_pte().

> +
> +	if (WARN_ON(!is_shadow_present_pte(huge_spte)))
> +		return 0;
> +
> +	if (WARN_ON(!is_large_pte(huge_spte)))

Probably best to make these WARN_ON_ONCE, I gotta image if KVM screws up then this
will flood dmesg.

> +		return 0;
> +
> +	child_spte = huge_spte;
> +	child_level = huge_level - 1;
> +
> +	/*
> +	 * The child_spte already has the base address of the huge page being
> +	 * split. So we just have to OR in the offset to the page at the next
> +	 * lower level for the given index.
> +	 */
> +	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
> +
> +	if (child_level == PG_LEVEL_4K) {
> +		child_spte &= ~PT_PAGE_SIZE_MASK;
> +
> +		/* Allow execution for 4K pages if it was disabled for NX HugePages. */

Nit, this just reiterates the "what".  Even though the "why" is fairly obvious,
maybe this instead?

		/*
		 * When splitting to a 4K page, make the new SPTE executable as
		 * the NX hugepage mitigation no longer applies.
		 */
		 
> +		if (is_nx_huge_page_enabled() && access & ACC_EXEC_MASK)

Beacuse the caller always passes @access=ACC_ALL, the "access & ACC_EXEC_MASK"
part goes away (which addresses other good feedback about parantheses).

> +			child_spte = mark_spte_executable(child_spte);

Maybe s/mark/make?  KVM usually uses "mark" when making modifications for tracking
purposes.  This is simply making a SPTE executable, there's no tracking involved.

> +	}
> +
> +	return child_spte;
> +}
> +
> +
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
>  {
>  	u64 spte = SPTE_MMU_PRESENT_MASK;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 9b0c7b27f23f..e13f335b4fef 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -334,6 +334,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
>  	       bool host_writable, u64 *new_spte);
> +u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index, unsigned int access);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a8354d8578f1..be5eb74ac053 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1264,6 +1264,171 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  	return spte_set;
>  }
>  
> +static struct kvm_mmu_page *alloc_tdp_mmu_page_from_kernel(gfp_t gfp)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	gfp |= __GFP_ZERO;
> +
> +	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
> +	if (!sp)
> +		return NULL;
> +
> +	sp->spt = (void *)__get_free_page(gfp);
> +	if (!sp->spt) {
> +		kmem_cache_free(mmu_page_header_cache, sp);
> +		return NULL;
> +	}
> +
> +	return sp;
> +}
> +
> +static struct kvm_mmu_page *alloc_tdp_mmu_page_for_split(struct kvm *kvm, bool *dropped_lock)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	lockdep_assert_held_read(&kvm->mmu_lock);
> +
> +	*dropped_lock = false;
> +
> +	/*
> +	 * Since we are allocating while under the MMU lock we have to be
> +	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
> +	 * reclaim and to avoid making any filesystem callbacks (which can end
> +	 * up invoking KVM MMU notifiers, resulting in a deadlock).
> +	 *
> +	 * If this allocation fails we drop the lock and retry with reclaim
> +	 * allowed.
> +	 */
> +	sp = alloc_tdp_mmu_page_from_kernel(GFP_NOWAIT | __GFP_ACCOUNT);
> +	if (sp)
> +		return sp;
> +
> +	rcu_read_unlock();
> +	read_unlock(&kvm->mmu_lock);
> +
> +	*dropped_lock = true;
> +
> +	sp = alloc_tdp_mmu_page_from_kernel(GFP_KERNEL_ACCOUNT);
> +
> +	read_lock(&kvm->mmu_lock);
> +	rcu_read_lock();
> +
> +	return sp;
> +}
> +
> +static bool

Please put the return type and attributes on the same line as the function name,
splitting them makes grep sad.  And separating these rarely saves more than a line,
e.g. even with conservative wrapping, this goes from 2=>3 lines.

static bool tdp_mmu_split_huge_page_atomic(struct kvm *kvm,
					   struct tdp_iter *iter,
					   struct kvm_mmu_page *sp)

And it doesn't save anything if we want to run over by a few chars, which IMO
isn't worth it in this case, but that's not a sticking point.

static bool tdp_mmu_split_huge_page_atomic(struct kvm *kvm, struct tdp_iter *iter,
					   struct kvm_mmu_page *sp)

> +tdp_mmu_split_huge_page_atomic(struct kvm *kvm, struct tdp_iter *iter, struct kvm_mmu_page *sp)
> +{
> +	const u64 huge_spte = iter->old_spte;
> +	const int level = iter->level;
> +	u64 child_spte;
> +	int i;
> +
> +	init_child_tdp_mmu_page(sp, iter);
> +
> +	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> +		child_spte = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);

No need for child_spte, not saving any chars versus setting sp->spt[i] directly.
And then if you hoist the comment above the for-loop you can drop the braces and
shave a line from the comment:

	/*
	 * No need for atomics since child_sp has not been installed in the
	 * table yet and thus is not reachable by any other thread.
	 */
	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);

> +
> +		/*
> +		 * No need for atomics since child_sp has not been installed
> +		 * in the table yet and thus is not reachable by any other
> +		 * thread.
> +		 */
> +		sp->spt[i] = child_spte;
> +	}
> +
> +	if (!tdp_mmu_install_sp_atomic(kvm, iter, sp, false))
> +		return false;
> +
> +	/*
> +	 * tdp_mmu_install_sp_atomic will handle subtracting the split huge

Please add () when referencing functions, it helps readers visually identify that
the comment refers to a different function.

> +	 * page from stats, but we have to manually update the new present child
> +	 * pages.
> +	 */
> +	kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
> +
> +	return true;
> +}
> +
> +static int tdp_mmu_split_huge_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +					 gfn_t start, gfn_t end, int target_level)
> +{
> +	struct kvm_mmu_page *sp = NULL;
> +	struct tdp_iter iter;
> +	bool dropped_lock;
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * Traverse the page table splitting all huge pages above the target
> +	 * level into one lower level. For example, if we encounter a 1GB page
> +	 * we split it into 512 2MB pages.
> +	 *
> +	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
> +	 * to visit an SPTE before ever visiting its children, which means we
> +	 * will correctly recursively split huge pages that are more than one
> +	 * level above the target level (e.g. splitting 1GB to 2MB to 4KB).
> +	 */
> +	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
> +retry:
> +		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
> +			continue;
> +
> +		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
> +			continue;
> +
> +		if (!sp) {
> +			sp = alloc_tdp_mmu_page_for_split(kvm, &dropped_lock);
> +			if (!sp)
> +				return -ENOMEM;
> +
> +			if (dropped_lock) {
> +				tdp_iter_restart(&iter);

Ah, this needs to be rebased to play nice with commit 3a0f64de479c ("KVM: x86/mmu:
Don't advance iterator after restart due to yielding").

With that in play, I think that best approach would be to drop dropped_lock (ha!)
and just do:

			sp = alloc_tdp_mmu_page_for_split(kvm, &iter);
			if (!sp)
				return -ENOMEM;

			if (iter.yielded)
				continue;

> +				continue;
> +			}
> +		}
> +
> +		if (!tdp_mmu_split_huge_page_atomic(kvm, &iter, sp))
> +			goto retry;
> +
> +		sp = NULL;
> +	}
> +
> +	/*
> +	 * It's possible to exit the loop having never used the last sp if, for
> +	 * example, a vCPU doing HugePage NX splitting wins the race and
> +	 * installs its own sp in place of the last sp we tried to split.
> +	 */
> +	if (sp)
> +		tdp_mmu_free_sp(sp);
> +
> +	rcu_read_unlock();

Uber nit, an unusued sp can be freed after dropping RCU.

> +
> +	return 0;
> +}
> +
> +int kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
> +				     const struct kvm_memory_slot *slot,
> +				     gfn_t start, gfn_t end,
> +				     int target_level)
> +{
> +	struct kvm_mmu_page *root;
> +	int r = 0;
> +
> +	lockdep_assert_held_read(&kvm->mmu_lock);
> +
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true) {
> +		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level);
> +		if (r) {
> +			kvm_tdp_mmu_put_root(kvm, root, true);
> +			break;
> +		}
> +	}
> +
> +	return r;
> +}
> +
>  /*
>   * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
>   * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 3899004a5d91..3557a7fcf927 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -71,6 +71,11 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn,
>  				   int min_level);
>  
> +int kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
> +				     const struct kvm_memory_slot *slot,
> +				     gfn_t start, gfn_t end,
> +				     int target_level);
> +
>  static inline void kvm_tdp_mmu_walk_lockless_begin(void)
>  {
>  	rcu_read_lock();
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 85127b3e3690..fb5592bf2eee 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -187,6 +187,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> +static bool __read_mostly eagerly_split_huge_pages_for_dirty_logging = true;
> +module_param(eagerly_split_huge_pages_for_dirty_logging, bool, 0644);

Heh, can we use a shorter name for the module param?  There's 0% chance I'll ever
type that correctly.  Maybe eager_hugepage_splitting?  Though even that is a bit
too long for my tastes.

This should also be documented somewhere, which is where we can/should explain
exactly what the param does instead of trying to shove all that info into the name.

> +
>  /*
>   * Restoring the host value for MSRs that are only consumed when running in
>   * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
> @@ -11837,6 +11840,13 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>  			return;
>  
> +		/*
> +		 * Attempt to split all large pages into 4K pages so that vCPUs
> +		 * do not have to take write-protection faults.
> +		 */
> +		if (READ_ONCE(eagerly_split_huge_pages_for_dirty_logging))
> +			kvm_mmu_slot_try_split_huge_pages(kvm, new, PG_LEVEL_4K);
> +
>  		if (kvm_x86_ops.cpu_dirty_log_size) {
>  			kvm_mmu_slot_leaf_clear_dirty(kvm, new);
>  			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
