Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AD87D043E
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 23:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346614AbjJSVzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 17:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbjJSVzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 17:55:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B41E115
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 14:55:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9c83b656fso955695ad.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 14:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697752533; x=1698357333; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IyZf18g/hYMw/jx0X9JN9Tk6unDLwOWA43LEOcC1puk=;
        b=Jj+TqqpnTZuDzPGI1WP9bh2fYY4JwqEWF+ByYYMSathayPkWqjoSYzNxMcymyv5K4q
         cXAdUod3Db0hANJ/F8HzImtRLq34UJEoWxVciDrCC77s5sLuzj0XwD3NRIVCxvUuGQ5Q
         AYj89yigrLul3tyot/wByavcleDDFZOkvno4LMU9sU/VkCRq/GAUOGmMACGlheF1ZfEq
         ycPwT7Uj4y65VDrCNlM0ukxdaYJ0p7S1ko2qAwNDF1Di1u0+nl+13PEJcIEC1FGvnWja
         kkIV4C/mWpIDQSi6NZbkgbx3LhJu8QARsIl+QL8hU38tYlIBAILT6R/IdvpYb/HOgloy
         4OaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697752533; x=1698357333;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IyZf18g/hYMw/jx0X9JN9Tk6unDLwOWA43LEOcC1puk=;
        b=T+ckWq5Hp/uap6wQlMOtyZfkF0wdwvm9Xtw+om2TMYr+ZezGUA/Dmj1ruV2CGJlVn0
         JTgMdpxI+l6cL95JximiM8ZWCFpJyorZwkGmPhtozQ8+7L3dsKaV6xWpwybjmlFALX/R
         nwiMwWyU7Roo3d+PWw/RC82zGqimwb6s/InFv/IcWc2QXy6NXY2fPjXe+zQ5zXUqw2qO
         6C5eLbYaUQ3GbMakHqsRZSwdrCkVkS/AV7j1lDDDiKNq9qfUN2JQz2q4FFXYwLPQlWN9
         H0HG2CN0waSkE+P/E0aJy60GkMLlITkOVjrquQ3eHi47LwexrEfQQb8liNlRkPazUUxn
         d9qg==
X-Gm-Message-State: AOJu0YwiEtBFJbVvhbZ+W4yS0u1S9SMw2vHZ/nkp+PuzvCdSjJiy0x92
        mxJh9EA+bd6RU4ars8vdisZlfviYHjo=
X-Google-Smtp-Source: AGHT+IFhM6iY9A2x/so/AKEdbzE7+tV/XbrroYuetQU4DJej5VAahm9NkFuritc/lWDx7bQBQWQvrEv4fNY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7fc6:b0:1c9:e830:15fa with SMTP id
 t6-20020a1709027fc600b001c9e83015famr3079plb.0.1697752533448; Thu, 19 Oct
 2023 14:55:33 -0700 (PDT)
Date:   Thu, 19 Oct 2023 21:55:32 +0000
In-Reply-To: <20231019201138.2076865-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231019201138.2076865-1-seanjc@google.com>
Message-ID: <ZTGl1FgIpYbybqrw@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Stop zapping invalidated TDP MMU roots asynchronously
From:   Sean Christopherson <seanjc@google.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gah, sorry Greg, forgot to say that this is for 6.1-stable.

On Thu, Oct 19, 2023, Sean Christopherson wrote:
> [ Upstream commit 0df9dab891ff0d9b646d82e4fe038229e4c02451 ]
> 
> Stop zapping invalidate TDP MMU roots via work queue now that KVM
> preserves TDP MMU roots until they are explicitly invalidated.  Zapping
> roots asynchronously was effectively a workaround to avoid stalling a vCPU
> for an extended during if a vCPU unloaded a root, which at the time
> happened whenever the guest toggled CR0.WP (a frequent operation for some
> guest kernels).
> 
> While a clever hack, zapping roots via an unbound worker had subtle,
> unintended consequences on host scheduling, especially when zapping
> multiple roots, e.g. as part of a memslot.  Because the work of zapping a
> root is no longer bound to the task that initiated the zap, things like
> the CPU affinity and priority of the original task get lost.  Losing the
> affinity and priority can be especially problematic if unbound workqueues
> aren't affined to a small number of CPUs, as zapping multiple roots can
> cause KVM to heavily utilize the majority of CPUs in the system, *beyond*
> the CPUs KVM is already using to run vCPUs.
> 
> When deleting a memslot via KVM_SET_USER_MEMORY_REGION, the async root
> zap can result in KVM occupying all logical CPUs for ~8ms, and result in
> high priority tasks not being scheduled in in a timely manner.  In v5.15,
> which doesn't preserve unloaded roots, the issues were even more noticeable
> as KVM would zap roots more frequently and could occupy all CPUs for 50ms+.
> 
> Consuming all CPUs for an extended duration can lead to significant jitter
> throughout the system, e.g. on ChromeOS with virtio-gpu, deleting memslots
> is a semi-frequent operation as memslots are deleted and recreated with
> different host virtual addresses to react to host GPU drivers allocating
> and freeing GPU blobs.  On ChromeOS, the jitter manifests as audio blips
> during games due to the audio server's tasks not getting scheduled in
> promptly, despite the tasks having a high realtime priority.
> 
> Deleting memslots isn't exactly a fast path and should be avoided when
> possible, and ChromeOS is working towards utilizing MAP_FIXED to avoid the
> memslot shenanigans, but KVM is squarely in the wrong.  Not to mention
> that removing the async zapping eliminates a non-trivial amount of
> complexity.
> 
> Note, one of the subtle behaviors hidden behind the async zapping is that
> KVM would zap invalidated roots only once (ignoring partial zaps from
> things like mmu_notifier events).  Preserve this behavior by adding a flag
> to identify roots that are scheduled to be zapped versus roots that have
> already been zapped but not yet freed.
> 
> Add a comment calling out why kvm_tdp_mmu_invalidate_all_roots() can
> encounter invalid roots, as it's not at all obvious why zapping
> invalidated roots shouldn't simply zap all invalid roots.
> 
> Reported-by: Pattara Teerapong <pteerapong@google.com>
> Cc: David Stevens <stevensd@google.com>
> Cc: Yiwei Zhang<zzyiwei@google.com>
> Cc: Paul Hsia <paulhsia@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20230916003916.2545000-4-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Folks on Cc, it would be nice to get extra testing and/or reviews for this one
> before it's picked up for 6.1, there were quite a few conflicts to resolve.
> All of the conflicts were pretty straightforward, but I'd still appreciate an
> extra set of eyeballs or three.  Thanks! 
> 
>  arch/x86/include/asm/kvm_host.h |   3 +-
>  arch/x86/kvm/mmu/mmu.c          |   9 +--
>  arch/x86/kvm/mmu/mmu_internal.h |  15 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c      | 135 +++++++++++++-------------------
>  arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
>  arch/x86/kvm/x86.c              |   5 +-
>  6 files changed, 69 insertions(+), 102 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 08a84f801bfe..c1dcaa3d2d6e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1324,7 +1324,6 @@ struct kvm_arch {
>  	 * the thread holds the MMU lock in write mode.
>  	 */
>  	spinlock_t tdp_mmu_pages_lock;
> -	struct workqueue_struct *tdp_mmu_zap_wq;
>  #endif /* CONFIG_X86_64 */
>  
>  	/*
> @@ -1727,7 +1726,7 @@ void kvm_mmu_vendor_module_exit(void);
>  
>  void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
>  int kvm_mmu_create(struct kvm_vcpu *vcpu);
> -int kvm_mmu_init_vm(struct kvm *kvm);
> +void kvm_mmu_init_vm(struct kvm *kvm);
>  void kvm_mmu_uninit_vm(struct kvm *kvm);
>  
>  void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2a6fec4e2d19..d30325e297a0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5994,19 +5994,16 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  	kvm_mmu_zap_all_fast(kvm);
>  }
>  
> -int kvm_mmu_init_vm(struct kvm *kvm)
> +void kvm_mmu_init_vm(struct kvm *kvm)
>  {
>  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> -	int r;
>  
>  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>  	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
>  	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
>  	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
>  
> -	r = kvm_mmu_init_tdp_mmu(kvm);
> -	if (r < 0)
> -		return r;
> +	kvm_mmu_init_tdp_mmu(kvm);
>  
>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> @@ -6019,8 +6016,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  
>  	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
>  	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> -
> -	return 0;
>  }
>  
>  static void mmu_free_vm_memory_caches(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 582def531d4d..0a9d5f2925c3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -56,7 +56,12 @@ struct kvm_mmu_page {
>  
>  	bool tdp_mmu_page;
>  	bool unsync;
> -	u8 mmu_valid_gen;
> +	union {
> +		u8 mmu_valid_gen;
> +
> +		/* Only accessed under slots_lock.  */
> +		bool tdp_mmu_scheduled_root_to_zap;
> +	};
>  	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
>  
>  	/*
> @@ -92,13 +97,7 @@ struct kvm_mmu_page {
>  		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
>  		tdp_ptep_t ptep;
>  	};
> -	union {
> -		DECLARE_BITMAP(unsync_child_bitmap, 512);
> -		struct {
> -			struct work_struct tdp_mmu_async_work;
> -			void *tdp_mmu_async_data;
> -		};
> -	};
> +	DECLARE_BITMAP(unsync_child_bitmap, 512);
>  
>  	struct list_head lpage_disallowed_link;
>  #ifdef CONFIG_X86_32
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9b9fc4e834d0..c3b0f973375b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -14,24 +14,16 @@ static bool __read_mostly tdp_mmu_enabled = true;
>  module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
>  
>  /* Initializes the TDP MMU for the VM, if enabled. */
> -int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
> +void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  {
> -	struct workqueue_struct *wq;
> -
>  	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
> -		return 0;
> -
> -	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
> -	if (!wq)
> -		return -ENOMEM;
> +		return;
>  
>  	/* This should not be changed for the lifetime of the VM. */
>  	kvm->arch.tdp_mmu_enabled = true;
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>  	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
> -	kvm->arch.tdp_mmu_zap_wq = wq;
> -	return 1;
>  }
>  
>  /* Arbitrarily returns true so that this may be used in if statements. */
> @@ -57,20 +49,15 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	 * ultimately frees all roots.
>  	 */
>  	kvm_tdp_mmu_invalidate_all_roots(kvm);
> -
> -	/*
> -	 * Destroying a workqueue also first flushes the workqueue, i.e. no
> -	 * need to invoke kvm_tdp_mmu_zap_invalidated_roots().
> -	 */
> -	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
> +	kvm_tdp_mmu_zap_invalidated_roots(kvm);
>  
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>  
>  	/*
>  	 * Ensure that all the outstanding RCU callbacks to free shadow pages
> -	 * can run before the VM is torn down.  Work items on tdp_mmu_zap_wq
> -	 * can call kvm_tdp_mmu_put_root and create new callbacks.
> +	 * can run before the VM is torn down.  Putting the last reference to
> +	 * zapped roots will create new callbacks.
>  	 */
>  	rcu_barrier();
>  }
> @@ -97,46 +84,6 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>  	tdp_mmu_free_sp(sp);
>  }
>  
> -static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> -			     bool shared);
> -
> -static void tdp_mmu_zap_root_work(struct work_struct *work)
> -{
> -	struct kvm_mmu_page *root = container_of(work, struct kvm_mmu_page,
> -						 tdp_mmu_async_work);
> -	struct kvm *kvm = root->tdp_mmu_async_data;
> -
> -	read_lock(&kvm->mmu_lock);
> -
> -	/*
> -	 * A TLB flush is not necessary as KVM performs a local TLB flush when
> -	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> -	 * to a different pCPU.  Note, the local TLB flush on reuse also
> -	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
> -	 * intermediate paging structures, that may be zapped, as such entries
> -	 * are associated with the ASID on both VMX and SVM.
> -	 */
> -	tdp_mmu_zap_root(kvm, root, true);
> -
> -	/*
> -	 * Drop the refcount using kvm_tdp_mmu_put_root() to test its logic for
> -	 * avoiding an infinite loop.  By design, the root is reachable while
> -	 * it's being asynchronously zapped, thus a different task can put its
> -	 * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for an
> -	 * asynchronously zapped root is unavoidable.
> -	 */
> -	kvm_tdp_mmu_put_root(kvm, root, true);
> -
> -	read_unlock(&kvm->mmu_lock);
> -}
> -
> -static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root)
> -{
> -	root->tdp_mmu_async_data = kvm;
> -	INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
> -	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
> -}
> -
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			  bool shared)
>  {
> @@ -222,11 +169,11 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
>  	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
>  
> -#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)			\
> -	for (_root = tdp_mmu_next_root(_kvm, NULL, false, false);		\
> +#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)			\
> +	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, false);		\
>  	     _root;								\
> -	     _root = tdp_mmu_next_root(_kvm, _root, false, false))		\
> -		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, false)) {		\
> +	     _root = tdp_mmu_next_root(_kvm, _root, _shared, false))		\
> +		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, _shared)) {		\
>  		} else
>  
>  /*
> @@ -305,7 +252,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  	 * by a memslot update or by the destruction of the VM.  Initialize the
>  	 * refcount to two; one reference for the vCPU, and one reference for
>  	 * the TDP MMU itself, which is held until the root is invalidated and
> -	 * is ultimately put by tdp_mmu_zap_root_work().
> +	 * is ultimately put by kvm_tdp_mmu_zap_invalidated_roots().
>  	 */
>  	refcount_set(&root->tdp_mmu_root_count, 2);
>  
> @@ -963,7 +910,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
>  {
>  	struct kvm_mmu_page *root;
>  
> -	for_each_tdp_mmu_root_yield_safe(kvm, root)
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
>  		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
>  
>  	return flush;
> @@ -985,7 +932,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  	 * is being destroyed or the userspace VMM has exited.  In both cases,
>  	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>  	 */
> -	for_each_tdp_mmu_root_yield_safe(kvm, root)
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
>  		tdp_mmu_zap_root(kvm, root, false);
>  }
>  
> @@ -995,18 +942,47 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>   */
>  void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  {
> -	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
> +	struct kvm_mmu_page *root;
> +
> +	read_lock(&kvm->mmu_lock);
> +
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
> +		if (!root->tdp_mmu_scheduled_root_to_zap)
> +			continue;
> +
> +		root->tdp_mmu_scheduled_root_to_zap = false;
> +		KVM_BUG_ON(!root->role.invalid, kvm);
> +
> +		/*
> +		 * A TLB flush is not necessary as KVM performs a local TLB
> +		 * flush when allocating a new root (see kvm_mmu_load()), and
> +		 * when migrating a vCPU to a different pCPU.  Note, the local
> +		 * TLB flush on reuse also invalidates paging-structure-cache
> +		 * entries, i.e. TLB entries for intermediate paging structures,
> +		 * that may be zapped, as such entries are associated with the
> +		 * ASID on both VMX and SVM.
> +		 */
> +		tdp_mmu_zap_root(kvm, root, true);
> +
> +		/*
> +		 * The referenced needs to be put *after* zapping the root, as
> +		 * the root must be reachable by mmu_notifiers while it's being
> +		 * zapped
> +		 */
> +		kvm_tdp_mmu_put_root(kvm, root, true);
> +	}
> +
> +	read_unlock(&kvm->mmu_lock);
>  }
>  
>  /*
>   * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
>   * is about to be zapped, e.g. in response to a memslots update.  The actual
> - * zapping is performed asynchronously.  Using a separate workqueue makes it
> - * easy to ensure that the destruction is performed before the "fast zap"
> - * completes, without keeping a separate list of invalidated roots; the list is
> - * effectively the list of work items in the workqueue.
> + * zapping is done separately so that it happens with mmu_lock with read,
> + * whereas invalidating roots must be done with mmu_lock held for write (unless
> + * the VM is being destroyed).
>   *
> - * Note, the asynchronous worker is gifted the TDP MMU's reference.
> + * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
>   * See kvm_tdp_mmu_get_vcpu_root_hpa().
>   */
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> @@ -1031,19 +1007,20 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>  	/*
>  	 * As above, mmu_lock isn't held when destroying the VM!  There can't
>  	 * be other references to @kvm, i.e. nothing else can invalidate roots
> -	 * or be consuming roots, but walking the list of roots does need to be
> -	 * guarded against roots being deleted by the asynchronous zap worker.
> +	 * or get/put references to roots.
>  	 */
> -	rcu_read_lock();
> -
> -	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
> +	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> +		/*
> +		 * Note, invalid roots can outlive a memslot update!  Invalid
> +		 * roots must be *zapped* before the memslot update completes,
> +		 * but a different task can acquire a reference and keep the
> +		 * root alive after its been zapped.
> +		 */
>  		if (!root->role.invalid) {
> +			root->tdp_mmu_scheduled_root_to_zap = true;
>  			root->role.invalid = true;
> -			tdp_mmu_schedule_zap_root(kvm, root);
>  		}
>  	}
> -
> -	rcu_read_unlock();
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index d0a9fe0770fd..c82a8bb321bb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -65,7 +65,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
>  					u64 *spte);
>  
>  #ifdef CONFIG_X86_64
> -int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> +void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
>  
> @@ -86,7 +86,7 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  	return sp && is_tdp_mmu_page(sp) && sp->root_count;
>  }
>  #else
> -static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
> +static inline void kvm_mmu_init_tdp_mmu(struct kvm *kvm) {}
>  static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
>  static inline bool is_tdp_mmu(struct kvm_mmu *mmu) { return false; }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1931d3fcbbe0..b929254c7876 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12442,9 +12442,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (ret)
>  		goto out;
>  
> -	ret = kvm_mmu_init_vm(kvm);
> -	if (ret)
> -		goto out_page_track;
> +	kvm_mmu_init_vm(kvm);
>  
>  	ret = static_call(kvm_x86_vm_init)(kvm);
>  	if (ret)
> @@ -12489,7 +12487,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  out_uninit_mmu:
>  	kvm_mmu_uninit_vm(kvm);
> -out_page_track:
>  	kvm_page_track_cleanup(kvm);
>  out:
>  	return ret;
> 
> base-commit: adc4d740ad9ec780657327c69ab966fa4fdf0e8e
> -- 
> 2.42.0.655.g421f12c284-goog
> 
