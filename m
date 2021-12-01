Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDB84659E7
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 00:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353809AbhLAXlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 18:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343755AbhLAXlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 18:41:06 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44237C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 15:37:45 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q17so18899277plr.11
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 15:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vRPZmcKbrSGltlyP8eVgc0SH8m1nTFpzhyvoHwEyKNo=;
        b=OXDRE9fncYGj7dJ6BOBPYejMU57rRh3ZOiunIXuNi3VY9IW0RwSYZLoyEwe64hLu0J
         a9LU31DRMG2E0SCTAU4kBstHL13a5+m8v9bIwK9DPqNhWTgf5RbJ5GwBMaVrORehBHs0
         R6VMyhv+APwTyhwi1r1bj9K5ZLQok092IdUs08pCh7kvqXrScxcF44jFip2x7V2F8/Wz
         qHTGUco0wB1ZIyGRy31/HX5FfsrmTXDmxQf7x6j+qtrPWlCzDMOalfqKR0z+pPcPFRYe
         81V2kjX0v33AMX55dm4Bm+VUCFjV3/Vep4oXwGBczSOM0x0kc0ltTISBHHE+D3pi65bt
         QecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vRPZmcKbrSGltlyP8eVgc0SH8m1nTFpzhyvoHwEyKNo=;
        b=n8A6lZW7Psk5+ZIintJX2fa+zDxo976Kntw7GP1AsVJtpyMq5pzhWtH2wEZClOR+yT
         F+0D1fQxm+EZD8DRmwnLNp/FY9OJI3QHDiNtyUiUg4RRhvxeFAsKFqsmuSBgitV8SC3v
         hrpeG8Jtc8MiDJjPw++XKT9R+GzaVZLURu0Iu9MffaFFoRO8zsmNgERO9xNr828XCrPL
         z67XzvwdP10w43bPnXar73CjfRJEXaBd2zdCEuL+bWkQlXDZGM86fbeFtUojwH/30QCL
         LO9or68UwGcpEPEnn7izV3/T2wdBNuYGePqwofha/8Sqvuo16uq/Ad32R+F9EFBYDzCL
         QNHg==
X-Gm-Message-State: AOAM53041hE55tfyvE+TdUQxyXCk/UtVnTKWbFua4b+CJ9oXR1mbyoFS
        fCXwBwTRdGfLRH9rgPXvolaHtQ==
X-Google-Smtp-Source: ABdhPJwAUWWZ+3AjOkdo2mBCD1YK2jl/X/fAJcw4agL0TtL2k89rQAq/Zn7NhRO2V7PKrNMLSAuZ0w==
X-Received: by 2002:a17:902:e749:b0:141:edaa:fde1 with SMTP id p9-20020a170902e74900b00141edaafde1mr11454233plf.72.1638401864516;
        Wed, 01 Dec 2021 15:37:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m3sm636340pgj.25.2021.12.01.15.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 15:37:43 -0800 (PST)
Date:   Wed, 1 Dec 2021 23:37:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
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
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
Message-ID: <YagHRESjukJoS7NQ@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local>
 <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com>
 <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
 <YabeFZxWqPAuoEtZ@xz-m1.local>
 <Yae+8Oshu9sVrrvd@google.com>
 <CALzav=c9F+f=UqBjQD9sotNC72j2Gq1Fa=cdLoz2xOjRd5hypg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=c9F+f=UqBjQD9sotNC72j2Gq1Fa=cdLoz2xOjRd5hypg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, David Matlack wrote:
> On Wed, Dec 1, 2021 at 10:29 AM Sean Christopherson <seanjc@google.com> wrote:
> > Hmm, in this particular case, I think using the caches is the wrong approach.  The
> > behavior of pre-filling the caches makes sense for vCPUs because faults may need
> > multiple objects and filling the cache ensures the entire fault can be handled
> > without dropping mmu_lock.  And any extra/unused objects can be used by future
> > faults.  For page splitting, neither of those really holds true.  If there are a
> > lot of pages to split, KVM will have to drop mmu_lock to refill the cache.  And if
> > there are few pages to split, or the caches are refilled toward the end of the walk,
> > KVM may end up with a pile of unused objects it needs to free.
> >
> > Since this code already needs to handle failure, and more importantly, it's a
> > best-effort optimization, I think trying to use the caches is a square peg, round
> > hole scenario.
> >
> > Rather than use the caches, we could do allocation 100% on-demand and never drop
> > mmu_lock to do allocation.  The one caveat is that direct reclaim would need to be
> > disallowed so that the allocation won't sleep.  That would mean that eager splitting
> > would fail under heavy memory pressure when it otherwise might succeed by reclaiming.
> > That would mean vCPUs get penalized as they'd need to do the splitting on fault and
> > potentially do direct reclaim as well.  It's not obvious that that would be a problem
> > in practice, e.g. the vCPU is probably already seeing a fair amount of disruption due
> > to memory pressure, and slowing down vCPUs might alleviate some of that pressure.
> 
> Not necessarily. The vCPUs might be running just fine in the VM being
> split because they are in their steady state and not faulting in any
> new memory. (Memory pressure might be coming from another VM landing
> on the host.)

Hrm, true.

> IMO, if we have an opportunity to avoid doing direct reclaim in the
> critical path of customer execution we should take it.
>
> 
> The on-demand approach will also increase the amount of time we have
> to hold the MMU lock to page splitting. This is not too terrible for
> the TDP MMU since we are holding the MMU lock in read mode, but is
> going to become a problem when we add page splitting support for the
> shadow MMU.
> 
> I do agree that the caches approach, as implemented, will inevitably
> end up with a pile of unused objects at the end that need to be freed.
> I'd be happy to take a look and see if there's anyway to reduce the
> amount of unused objects at the end with a bit smarter top-up logic.

It's not just the extra objects, it's the overall complexity that bothers me.
Complexity isn't really the correct word, it's more that as written, the logic
is spread over several files and is disingenuous from the perspective that the
split_cache is in kvm->arch, which implies persistence, but the cache are
completely torn down after evey memslot split.

I suspect part of the problem is that the code is trying to plan for a future
where nested MMUs also support splitting large pages.  Usually I'm all for that
sort of thing, but in this case it creates a lot of APIs that should not exist,
either because the function is not needed at all, or because it's a helper buried
in tdp_mmu.c.  E.g. assert_split_caches_invariants() is overkill.

That's solvable by refactoring and shuffling code, but using kvm_mmu_memory_cache
still feels wrong.  The caches don't fully solve the might_sleep() problem since
the loop still has to drop mmu_lock purely because it needs to allocate memory,
and at the same time the caches are too agressive because we can theoretically get
false positives on OOM scenarios, e.g. a topup could fail when trying to allocate
25 objects, when only 1 is needed.  We could enhance the cache code, which is
pretty rudimentary, but it still feels forced.

One thing we can take advantage of is that remote TLB flushes can be deferred
until after all roots are done, and don't need to be serviced if mmu_lock is
dropped.  Changes from a hugepage to a collection of smaller pages is atomic, no
memory is freed, and there are no changes in gfn=>pfn made by the split.  If
something else comes along and modifies the newly created sp or its children,
then it will flush accordingly.  Similar to write-protecting the page, the only
requirement is that all vCPUs see the small pages before the ioctl() returns,
i.e. before userspace can query the dirty log.  Never needing to flush is one
less reason to use a variant of tdp_mmu_iter_cond_resched(). 

So, what if we do something like this?  Try to allocate on-demand without dropping
mmu_lock.  In the happy case, it will succeed and there's no need to drop mmu_lock.
If allocation fails, drop RCU and mmu_lock and retry with direct relcaim allowed.

Some ugly gotos to reduce indentation, there's probably a better way to dress
this up.  Comments obviously needed.  This also doesn't track whether or not a
flush is needed, that will sadly need to be an in/out param, assuming we want to
return success/failure.

static struct kvm_mmu_page *tdp_mmu_alloc_sp(gfp_t allow_direct_reclaim)
{
	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | allow_direct_reclaim;
	struct kvm_mmu_page *sp;
	u64 *spt;

	spt = (void *)__get_free_page(gfp);
	if (!spt)
		return NULL;

	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
	if (!sp) {
		free_page((unsigned long)spt);
		return NULL;
	}

	sp->spt = spt;

	return sp;
}

static int tdp_mmu_split_large_pages(struct kvm *kvm, struct kvm_mmu_page *root,
				     gfn_t start, gfn_t end, int target_level)
{
	struct kvm_mmu_page *sp = NULL;
	struct tdp_iter iter;

	rcu_read_lock();

	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
retry:
		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
			continue;

		if (!is_shadow_present_pte(iter.old_spte || !is_large_pte(pte))
			continue;

		if (likely(sp))
			goto do_split;

		sp = tdp_mmu_alloc_sp(0);
		if (!sp) {
			rcu_read_unlock();
			read_unlock(&kvm->mmu_lock);

			sp = tdp_mmu_alloc_sp(__GFP_DIRECT_RECLAIM);

			read_lock(&kvm->mmu_lock);

			if (!sp)
				return -ENOMEM;

			rcu_read_lock();
			tdp_iter_restart(iter);
			continue;
		}

do_split:
		init_tdp_mmu_page(sp, iter->gfn, get_child_page_role(&iter));

		if (!tdp_mmu_split_large_page(kvm, &iter, sp))
			goto retry;

		sp = NULL;
	}

	rcu_read_unlock();

	return 0;
}

