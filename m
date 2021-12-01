Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830EC46556C
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 19:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbhLAScc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 13:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242575AbhLASca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 13:32:30 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CD9C061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 10:29:09 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p18so18354379plf.13
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 10:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y9Tx0kYOv0qLjLB9dfsBkHt5tK/OU7Frn9Ye7ydw9m4=;
        b=KznowQMEu1q0nmdSDGRSMvB64r4SsVEp9fZ1j9NZkT9FBfAP20bc2FeOZimGXBhx2b
         8KUNsRH/yTdVNSt3kAip5tVrTIOhTKM8KiIoKI5n2mQszXETaBNe5PswpAFk6+OWCHm/
         f9pdwCJOgDm6xptxOZnn/oS8aLm+Gxe33x2x6dF8Begtfv9BzzfHWrJUyTPEnxl+3DOg
         o8kFnUyzyhEaR+3ol/VubRm/j1xcrzY4S9mV2Jt/YubmABvIcZVsn/eggKlfRt1SGIUX
         DlvnQEqjnAmk6+Z9sWXfNovu3H4dt/T1rK/cZ4gMfOmmPR3OaNTmbuTKKhOlqZa2DatP
         nd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y9Tx0kYOv0qLjLB9dfsBkHt5tK/OU7Frn9Ye7ydw9m4=;
        b=ewEnw+tjmxIYYzzVvYzojGq96B1Qd5odFBg8n+BAg9Pqt/DNytQ8lD3b1r3VQeKH1V
         RMbbmPxK3hQWOUua75Mtqxe+fkueZrLNdUC5sp/0Av5j8+wKW9XPq3EPe1Q42XolJ9KT
         YpqrzzDs+ca0XEB+I05htB4gxrCnvDmA0oduQHabcnV8hYinmE+ry5G0Fa68glET2jUQ
         y5kc7YBHTf52ZmoLhW1zJUEQT1j7dYlP/HVdoFlwi2uaIS7JKeZDRo98DwHPLAPNho4Y
         oRF9h0+GLqXtVbklmpOIY/AW9KXKxvHqlnVNvK0Iw6+Nc60G6zOXEWk4TcQGGbpXZLjf
         ixnA==
X-Gm-Message-State: AOAM533N2WfXwiFUVOoSNML3EApsQJXk9aOD4y3pgrnr+glDOvcB7zOa
        CUzRV1ZUO1icJ0gQiLaUcUT3tQ==
X-Google-Smtp-Source: ABdhPJyU/G6PLIsBR/8PC2Hm8ZpQREax5NtkWYbauq/gz+V7/esP5WLvQHn/eOllQNbS2rozIl6VnA==
X-Received: by 2002:a17:90b:1b45:: with SMTP id nv5mr9671600pjb.120.1638383348996;
        Wed, 01 Dec 2021 10:29:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c18sm504002pfl.201.2021.12.01.10.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 10:29:08 -0800 (PST)
Date:   Wed, 1 Dec 2021 18:29:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
Message-ID: <Yae+8Oshu9sVrrvd@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local>
 <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com>
 <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
 <YabeFZxWqPAuoEtZ@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YabeFZxWqPAuoEtZ@xz-m1.local>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, Peter Xu wrote:
> On Tue, Nov 30, 2021 at 05:29:10PM -0800, David Matlack wrote:
> > On Tue, Nov 30, 2021 at 5:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > > So '1' is technically correct, but I think it's the wrong choice given the behavior
> > > of this code.  E.g. if there's 1 object in the cache, the initial top-up will do
> > > nothing,
> > 
> > This scenario will not happen though, since we free the caches after
> > splitting. So, the next time userspace enables dirty logging on a
> > memslot and we go to do the initial top-up the caches will have 0
> > objects.

Ah.

> > > and then tdp_mmu_split_large_pages_root() will almost immediately drop
> > > mmu_lock to topup the cache.  Since the in-loop usage explicitly checks for an
> > > empty cache, i.e. any non-zero @min will have identical behavior, I think it makes
> > > sense to use KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE _and_ add a comment explaining why.
> > 
> > If we set the min to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> > kvm_mmu_topup_memory_cache will return ENOMEM if it can't allocate at
> > least KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects, even though we really
> > only need 1 to make forward progress.
> > 
> > It's a total edge case but there could be a scenario where userspace
> > sets the cgroup memory limits so tight that we can't allocate
> > KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects when splitting the last few
> > pages and in the end we only needed 1 or 2 objects to finish
> > splitting. In this case we'd end up with a spurious pr_warn and may
> > not split the last few pages depending on which cache failed to get
> > topped up.
> 
> IMHO when -ENOMEM happens, instead of keep trying with 1 shadow sp we should
> just bail out even earlier.
> 
> Say, if we only have 10 (<40) pages left for shadow sp's use, we'd better make
> good use of them lazily to be consumed in follow up page faults when the guest
> accessed any of the huge pages, rather than we take them all over to split the
> next continuous huge pages assuming it'll be helpful..
> 
> From that POV I have a slight preference over Sean's suggestion because that'll
> make us fail earlier.  But I agree it shouldn't be a big deal.

Hmm, in this particular case, I think using the caches is the wrong approach.  The
behavior of pre-filling the caches makes sense for vCPUs because faults may need
multiple objects and filling the cache ensures the entire fault can be handled
without dropping mmu_lock.  And any extra/unused objects can be used by future
faults.  For page splitting, neither of those really holds true.  If there are a
lot of pages to split, KVM will have to drop mmu_lock to refill the cache.  And if
there are few pages to split, or the caches are refilled toward the end of the walk,
KVM may end up with a pile of unused objects it needs to free.

Since this code already needs to handle failure, and more importantly, it's a
best-effort optimization, I think trying to use the caches is a square peg, round
hole scenario.

Rather than use the caches, we could do allocation 100% on-demand and never drop
mmu_lock to do allocation.  The one caveat is that direct reclaim would need to be
disallowed so that the allocation won't sleep.  That would mean that eager splitting
would fail under heavy memory pressure when it otherwise might succeed by reclaiming.
That would mean vCPUs get penalized as they'd need to do the splitting on fault and
potentially do direct reclaim as well.  It's not obvious that that would be a problem
in practice, e.g. the vCPU is probably already seeing a fair amount of disruption due
to memory pressure, and slowing down vCPUs might alleviate some of that pressure.

Not using the cache would also reduce the extra complexity, e.g. no need for
special mmu_cache handling or a variant of tdp_mmu_iter_cond_resched().

I'm thinking something like this (very incomplete):

static void init_tdp_mmu_page(struct kvm_mmu_page *sp, u64 *spt, gfn_t gfn,
			      union kvm_mmu_page_role role)
{
	sp->spt = spt;
	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);

	sp->role = role;
	sp->gfn = gfn;
	sp->tdp_mmu_page = true;

	trace_kvm_mmu_get_page(sp, true);
}

static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
					       union kvm_mmu_page_role role)
{
	struct kvm_mmu_page *sp;
	u64 *spt;

	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
	spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);

	init_tdp_mmu_page(sp, spt, gfn, role);
}

static union kvm_mmu_page_role get_child_page_role(struct tdp_iter *iter)
{
	struct kvm_mmu_page *parent = sptep_to_sp(rcu_dereference(iter->sptep));
	union kvm_mmu_page_role role = parent->role;

	role.level--;
	return role;
}

static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
				      struct tdp_iter *iter,
				      struct kvm_mmu_page *sp,
				      bool account_nx)
{
	u64 spte;

	spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);

	if (tdp_mmu_set_spte_atomic(kvm, iter, spte)) {
		tdp_mmu_link_page(kvm, sp, account_nx);
		return true;
	}
	return false;
}

static void tdp_mmu_split_large_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
					   gfn_t start, gfn_t end, int target_level)
{
	/*
	 * Disallow direct reclaim, allocations will be made while holding
	 * mmu_lock and must not sleep.
	 */
	gfp_t gfp = (GFP_KERNEL_ACCOUNT | __GFP_ZERO) & ~__GFP_DIRECT_RECLAIM;
	struct kvm_mmu_page *sp = NULL;
	struct tdp_iter iter;
	bool flush = false;
	u64 *spt = NULL;
	int r;

	rcu_read_lock();

	/*
	 * Traverse the page table splitting all large pages above the target
	 * level into one lower level. For example, if we encounter a 1GB page
	 * we split it into 512 2MB pages.
	 *
	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
	 * to visit an SPTE before ever visiting its children, which means we
	 * will correctly recursively split large pages that are more than one
	 * level above the target level (e.g. splitting 1GB to 2MB to 4KB).
	 */
	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
retry:
		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true))
			continue;

		if (!is_shadow_present_pte(iter.old_spte || !is_large_pte(pte))
			continue;

		if (!sp) {
			sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
			if (!sp)
				break;
			spt = (void *)__get_free_page(gfp);
			if (!spt)
				break;
		}

		init_tdp_mmu_page(sp, spt, iter->gfn,
				  get_child_page_role(&iter));

		if (!tdp_mmu_split_large_page(kvm, &iter, sp))
			goto retry;

		sp = NULL;
		spt = NULL;
	}

	free_page((unsigned long)spt);
	kmem_cache_free(mmu_page_header_cache, sp);

	rcu_read_unlock();

	if (flush)
		kvm_flush_remote_tlbs(kvm);
}
