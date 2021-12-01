Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2BD46586C
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 22:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbhLAVkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 16:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhLAVkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 16:40:01 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62D8C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 13:36:39 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f18so66387427lfv.6
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 13:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uUM8jHDIsoW8/oVyD5hYUWrRUgQvAR4uN8LsA/SmPbA=;
        b=G8w5Z5Z5/cmXcvw3GWCfTbHIkD33p/HmhIzVhk06kAVCtAoQiT3nGIWKKxQ/J8Sw39
         Qbxu7RT6n0W1aB89uCoY0sHosketfWuKscY8uxRJcTddlUr2MPWr/WX2WJuYq7dsls7d
         NwYhkj/Wiqj82eL6c8aQs2Vac2e7rwlr7IuGPWdr8ZugrxcUMpvCG6quHx7scRjNy1VT
         U2EQXhxH3Rw0N+Uyuoa0BUJTqCz5HOQEQOhKhPpxv1a3IQIUR2bt5XJ5Jy1skqnkR/mt
         LOlCGZVMpcFEpfPJNM6Rb5E9/xNOdw75v8ZMZPtz/+UdBbxn1bDuWRAHrHBV4qNgDLG6
         9HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uUM8jHDIsoW8/oVyD5hYUWrRUgQvAR4uN8LsA/SmPbA=;
        b=X1s4vmWuD7+6k87sRMZe6gzWgkwFJ+76fn4rkLxd8UUm1Y5zdBC25Thm5e0elHlQga
         BwPRAvzFY7VLK8GsPUqW1R1AwPEQ8NEsXaoV2D+nNiDVS+7zIRsJHFFIouPNJf6+sM/i
         XfYHUvU0p5HQ1CcAv1VipBz57lDyxxW+aPs19jeYKJTpfHY4Qzs8yV0B4byCAE/4KBe8
         aqMVv18Zr+IJo9onaqdfm3ozwJh3kS/MLzL7CDxdfM7XRKURTLoJyyX/JowcL6mHQNKA
         noH9e0X6iRPyzvdThkXZ8Umc4OKqmZ6xfKO3DiYLi7ykOf1m60qL47DtJ+9aKsk60rc2
         UJIQ==
X-Gm-Message-State: AOAM531/DjBgW7QOS96jR/9KmdJGdRfFvuQU2xGCRwgIoT37Et9iFHBK
        79FqZsFaqtegKbEOcSUeYKeFuER67TLXyjzx+30Awg==
X-Google-Smtp-Source: ABdhPJwy20dG+I/hexboBwMgC6uDlNh7qZWIAiGoLN55OfU5iLk1n5tSQhOscBPwFuuIXY6d4jUo46YIdCkcLydUiWA=
X-Received: by 2002:a05:6512:11e5:: with SMTP id p5mr7998037lfs.537.1638394597894;
 Wed, 01 Dec 2021 13:36:37 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local> <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com> <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
 <YabeFZxWqPAuoEtZ@xz-m1.local> <Yae+8Oshu9sVrrvd@google.com>
In-Reply-To: <Yae+8Oshu9sVrrvd@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 13:36:11 -0800
Message-ID: <CALzav=c9F+f=UqBjQD9sotNC72j2Gq1Fa=cdLoz2xOjRd5hypg@mail.gmail.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 1, 2021 at 10:29 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Dec 01, 2021, Peter Xu wrote:
> > On Tue, Nov 30, 2021 at 05:29:10PM -0800, David Matlack wrote:
> > > On Tue, Nov 30, 2021 at 5:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > So '1' is technically correct, but I think it's the wrong choice given the behavior
> > > > of this code.  E.g. if there's 1 object in the cache, the initial top-up will do
> > > > nothing,
> > >
> > > This scenario will not happen though, since we free the caches after
> > > splitting. So, the next time userspace enables dirty logging on a
> > > memslot and we go to do the initial top-up the caches will have 0
> > > objects.
>
> Ah.
>
> > > > and then tdp_mmu_split_large_pages_root() will almost immediately drop
> > > > mmu_lock to topup the cache.  Since the in-loop usage explicitly checks for an
> > > > empty cache, i.e. any non-zero @min will have identical behavior, I think it makes
> > > > sense to use KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE _and_ add a comment explaining why.
> > >
> > > If we set the min to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> > > kvm_mmu_topup_memory_cache will return ENOMEM if it can't allocate at
> > > least KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects, even though we really
> > > only need 1 to make forward progress.
> > >
> > > It's a total edge case but there could be a scenario where userspace
> > > sets the cgroup memory limits so tight that we can't allocate
> > > KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects when splitting the last few
> > > pages and in the end we only needed 1 or 2 objects to finish
> > > splitting. In this case we'd end up with a spurious pr_warn and may
> > > not split the last few pages depending on which cache failed to get
> > > topped up.
> >
> > IMHO when -ENOMEM happens, instead of keep trying with 1 shadow sp we should
> > just bail out even earlier.
> >
> > Say, if we only have 10 (<40) pages left for shadow sp's use, we'd better make
> > good use of them lazily to be consumed in follow up page faults when the guest
> > accessed any of the huge pages, rather than we take them all over to split the
> > next continuous huge pages assuming it'll be helpful..
> >
> > From that POV I have a slight preference over Sean's suggestion because that'll
> > make us fail earlier.  But I agree it shouldn't be a big deal.
>
> Hmm, in this particular case, I think using the caches is the wrong approach.  The
> behavior of pre-filling the caches makes sense for vCPUs because faults may need
> multiple objects and filling the cache ensures the entire fault can be handled
> without dropping mmu_lock.  And any extra/unused objects can be used by future
> faults.  For page splitting, neither of those really holds true.  If there are a
> lot of pages to split, KVM will have to drop mmu_lock to refill the cache.  And if
> there are few pages to split, or the caches are refilled toward the end of the walk,
> KVM may end up with a pile of unused objects it needs to free.
>
> Since this code already needs to handle failure, and more importantly, it's a
> best-effort optimization, I think trying to use the caches is a square peg, round
> hole scenario.
>
> Rather than use the caches, we could do allocation 100% on-demand and never drop
> mmu_lock to do allocation.  The one caveat is that direct reclaim would need to be
> disallowed so that the allocation won't sleep.  That would mean that eager splitting
> would fail under heavy memory pressure when it otherwise might succeed by reclaiming.
> That would mean vCPUs get penalized as they'd need to do the splitting on fault and
> potentially do direct reclaim as well.  It's not obvious that that would be a problem
> in practice, e.g. the vCPU is probably already seeing a fair amount of disruption due
> to memory pressure, and slowing down vCPUs might alleviate some of that pressure.

Not necessarily. The vCPUs might be running just fine in the VM being
split because they are in their steady state and not faulting in any
new memory. (Memory pressure might be coming from another VM landing
on the host.)

IMO, if we have an opportunity to avoid doing direct reclaim in the
critical path of customer execution we should take it.

The on-demand approach will also increase the amount of time we have
to hold the MMU lock to page splitting. This is not too terrible for
the TDP MMU since we are holding the MMU lock in read mode, but is
going to become a problem when we add page splitting support for the
shadow MMU.

I do agree that the caches approach, as implemented, will inevitably
end up with a pile of unused objects at the end that need to be freed.
I'd be happy to take a look and see if there's anyway to reduce the
amount of unused objects at the end with a bit smarter top-up logic.

>
> Not using the cache would also reduce the extra complexity, e.g. no need for
> special mmu_cache handling or a variant of tdp_mmu_iter_cond_resched().
>
> I'm thinking something like this (very incomplete):
>
> static void init_tdp_mmu_page(struct kvm_mmu_page *sp, u64 *spt, gfn_t gfn,
>                               union kvm_mmu_page_role role)
> {
>         sp->spt = spt;
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
>         sp->role = role;
>         sp->gfn = gfn;
>         sp->tdp_mmu_page = true;
>
>         trace_kvm_mmu_get_page(sp, true);
> }
>
> static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>                                                union kvm_mmu_page_role role)
> {
>         struct kvm_mmu_page *sp;
>         u64 *spt;
>
>         sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
>         spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>
>         init_tdp_mmu_page(sp, spt, gfn, role);
> }
>
> static union kvm_mmu_page_role get_child_page_role(struct tdp_iter *iter)
> {
>         struct kvm_mmu_page *parent = sptep_to_sp(rcu_dereference(iter->sptep));
>         union kvm_mmu_page_role role = parent->role;
>
>         role.level--;
>         return role;
> }
>
> static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
>                                       struct tdp_iter *iter,
>                                       struct kvm_mmu_page *sp,
>                                       bool account_nx)
> {
>         u64 spte;
>
>         spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
>
>         if (tdp_mmu_set_spte_atomic(kvm, iter, spte)) {
>                 tdp_mmu_link_page(kvm, sp, account_nx);
>                 return true;
>         }
>         return false;
> }
>
> static void tdp_mmu_split_large_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
>                                            gfn_t start, gfn_t end, int target_level)
> {
>         /*
>          * Disallow direct reclaim, allocations will be made while holding
>          * mmu_lock and must not sleep.
>          */
>         gfp_t gfp = (GFP_KERNEL_ACCOUNT | __GFP_ZERO) & ~__GFP_DIRECT_RECLAIM;
>         struct kvm_mmu_page *sp = NULL;
>         struct tdp_iter iter;
>         bool flush = false;
>         u64 *spt = NULL;
>         int r;
>
>         rcu_read_lock();
>
>         /*
>          * Traverse the page table splitting all large pages above the target
>          * level into one lower level. For example, if we encounter a 1GB page
>          * we split it into 512 2MB pages.
>          *
>          * Since the TDP iterator uses a pre-order traversal, we are guaranteed
>          * to visit an SPTE before ever visiting its children, which means we
>          * will correctly recursively split large pages that are more than one
>          * level above the target level (e.g. splitting 1GB to 2MB to 4KB).
>          */
>         for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
> retry:
>                 if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true))
>                         continue;
>
>                 if (!is_shadow_present_pte(iter.old_spte || !is_large_pte(pte))
>                         continue;
>
>                 if (!sp) {
>                         sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
>                         if (!sp)
>                                 break;
>                         spt = (void *)__get_free_page(gfp);
>                         if (!spt)
>                                 break;
>                 }
>
>                 init_tdp_mmu_page(sp, spt, iter->gfn,
>                                   get_child_page_role(&iter));
>
>                 if (!tdp_mmu_split_large_page(kvm, &iter, sp))
>                         goto retry;
>
>                 sp = NULL;
>                 spt = NULL;
>         }
>
>         free_page((unsigned long)spt);
>         kmem_cache_free(mmu_page_header_cache, sp);
>
>         rcu_read_unlock();
>
>         if (flush)
>                 kvm_flush_remote_tlbs(kvm);
> }
