Return-Path: <kvm+bounces-24836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B42C95BC6E
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 18:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BC901C22A63
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DA71CB31B;
	Thu, 22 Aug 2024 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l1hb+IfY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C471CDA27
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724345406; cv=none; b=ZH9WcdJ7t+Wy22os00KUFkmbW4S1oTUdy7XGLLU4GBQ1t32e0QCPCLIeFHQJZkzqvtyPSerTU2TA+cvoBalKkx8V/Z5ifPSzWB3lFkq5Vi5CFdHGP9RNI/oBeowFT6S1zXJyXx188ImBvnXJyLIoOVcK7CBknHjD4UK6WZSMORQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724345406; c=relaxed/simple;
	bh=5q7SQGrz78cONc3+vAJKNwyD+blDjOvgwxV73Th25ss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fnSImDxi94ldrzJ7FRzKHdPSVEg3FrB1QNNVP+761o3iilaW3NOTgrCPZulLBKrC/yBgbAkwYuwqvOhhh5d85Z79piP6imdqs8IS75AfBHd3ULEe94zHwm3JvHeti9OPvugwmxJPE1hpeNzy0VlajDxlOHLE1fo6PJbCxDGXkq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l1hb+IfY; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b8f13f2965so21453757b3.1
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 09:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724345404; x=1724950204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IRYUwayMAx0W0p6sT68bMO4Q5/OUGBikQLNg50L0268=;
        b=l1hb+IfYEAfWjOpSgG4RvEVK5HB+iXSlojrkTI7CVR4sbkxLTJF1BImvNMlMJ3H52l
         BxzW8xs3B2vb2rYUpFVEsqhT96iNIgiPZ1oRyfXq/gKr6n41+7EnKn8lXGiuBDra4LdW
         i80GKTkaqUS8Z2y+qeinaWYgWPRiAXG7PMTuD5shYQ2silAZtFJXyzO/1ybToZzK5r7O
         8e6qAaeEa0eArG25U6Wh23NbtY4yMPrp41beiftURok7lrwGDhGd0xm/rQRU48svfhni
         Mkt9OK2pGEPPmX9rxtXIG+MLnNhmZLbuvMLBACP/EG1S+efoWAk0xhPx3Xyif6pfpj15
         +nHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724345404; x=1724950204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IRYUwayMAx0W0p6sT68bMO4Q5/OUGBikQLNg50L0268=;
        b=nvObU8gajUASvlr6A9jNr0CWNRQKveLREjzOF+8lrR1aepfJBXxaZbea9TrlEESjS4
         K+ULEKgriG61CTtlqcCnm9JJfdcL7+OLlhJsRMeW+YBJOxr4t2yvCuwXYkNYbNnlpBx3
         ec+4K0EKvkWNuofGHg0MyGa5OeET7C0dRplBeKwaxeXl58WBbX69XJODW6KnFUoK+umr
         Ix7OOmQsDXMt2I6One+1zhyVWfkUP/sy3dU94faLW+mzs5qtcOyB4eEofNgY1Os2h+KI
         KMIJhqNpiY1V6u2Q95fRoMmXcNr9VPl3CdVcZwREokOMnb4j7LHl6Q3gQdZ91DB+jnsQ
         V1GA==
X-Forwarded-Encrypted: i=1; AJvYcCUjRqBhjQx5dPfmZT77Ij/aUCJv1KXTXOzq34F3A6moyBeaMQQETZtF495AnbFTBsnYlaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz3/r32X+Ci2a1CCxTR9SZzmEo5M/wBcIOhmat6YXhxC/kLOHo
	BilX7hOEhVQ4sgp6Eocx575wciUqedQ7egPIQl8EzVnM3LrySXS0iwKq6LlYZvvPfGbkfNz3XrI
	m9g==
X-Google-Smtp-Source: AGHT+IGFXjasoevdzk3dGqcU4WgmV0zAfOOPTJNn6l2sQV1iMonWGnm//WMahBT9ePqLt8AuFOh/9I3XbYY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6487:b0:622:cd7d:fec4 with SMTP id
 00721157ae682-6c5bfecf536mr407b3.9.1724345403777; Thu, 22 Aug 2024 09:50:03
 -0700 (PDT)
Date: Thu, 22 Aug 2024 09:50:02 -0700
In-Reply-To: <20240805233114.4060019-8-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com> <20240805233114.4060019-8-dmatlack@google.com>
Message-ID: <ZsdsOpWnZY47J5sU@google.com>
Subject: Re: [PATCH 7/7] KVM: x86/mmu: Recheck SPTE points to a PT during huge
 page recovery
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, David Matlack wrote:
> Recheck the iter.old_spte still points to a page table when recovering
> huge pages. Since mmu_lock is held for read and tdp_iter_step_up()
> re-reads iter.sptep, it's possible the SPTE was zapped or recovered by
> another CPU in between stepping down and back up.
> 
> This could avoids a useless cmpxchg (and possibly a remote TLB flush) if
> another CPU is recovering huge SPTEs in parallel (e.g. the NX huge page
> recovery worker, or vCPUs taking faults on the huge page region).
> 
> This also makes it clear that tdp_iter_step_up() re-reads the SPTE and
> thus can see a different value, which is not immediately obvious when
> reading the code.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 07d5363c9db7..bdc7fd476721 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1619,6 +1619,17 @@ static void recover_huge_pages_range(struct kvm *kvm,
>  		while (max_mapping_level > iter.level)
>  			tdp_iter_step_up(&iter);
>  
> +		/*
> +		 * Re-check that iter.old_spte still points to a page table.
> +		 * Since mmu_lock is held for read and tdp_iter_step_up()
> +		 * re-reads iter.sptep, it's possible the SPTE was zapped or
> +		 * recovered by another CPU in between stepping down and
> +		 * stepping back up.
> +		 */
> +		if (!is_shadow_present_pte(iter.old_spte) ||
> +		    is_last_spte(iter.old_spte, iter.level))
> +			continue;

This is the part of the step-up logic that I do not like.  Even this check doesn't
guarantee that the SPTE that is being replaced is the same non-leaf SPTE that was
used to reach the leaf SPTE.  E.g. in an absurdly theoretical situation, the SPTE
could be zapped and then re-set with another non-leaf SPTE.  Which is fine, but
only because of several very subtle mechanisms.

kvm_mmu_max_mapping_level() ensures that there are no write-tracked gfns anywhere
in the huge range, so it's safe to propagate any and all WRITABLE bits.  This
requires knowing/remembering that KVM disallows huge pages when a gfn is write-
tracked, and relies on that never changing (which is a fairly safe bet, but the
behavior isn't fully set in stone).
not set.

And the presence of a shadow-present leaf SPTE ensures there are no in-flight
mmu_notifier invalidations, as kvm_mmu_notifier_invalidate_range_start() won't
return until all relevant leaf SPTEs have been zapped.

And even more subtly, recover_huge_pages_range() can install a huge SPTE while
tdp_mmu_zap_leafs() is running, e.g. if tdp_mmu_zap_leafs() is processing 4KiB
SPTEs because the greater 2MiB page is being unmapped by the primary MMU, and
tdp_mmu_zap_leafs() yields.   That's again safe only because upon regaining
control, tdp_mmu_zap_leafs() will restart at the root and thus observe and zap
the new huge SPTE.

So while I'm pretty sure this logic is functionally ok, its safety is extremely
dependent on a number of behaviors in KVM.

That said, I can't tell which option I dislike less.  E.g. we could do something
like this, where kvm_mmu_name_tbd() grabs the pfn+writable information from the
primary MMU's PTE/PMD/PUD.  Ideally, KVM would use GUP, but then KVM wouldn't
be able to create huge SPTEs for non-GUP-able memory, e.g. PFNMAP'd memory.

I don't love this either, primarily because not using GUP makes this yet another
custom flow, i.e. isn't any less tricky than reusing a child SPTE.  It does have
the advantage of not having to find a shadow-present child though, i.e. is likely
the most performant option.  I agree that that likely doesn't matter in practice,
especially since the raw latency of disabling dirty logging isn't terribly
important.

	rcu_read_lock();

	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
retry:
		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
			continue;

		if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
		    !is_shadow_present_pte(iter.old_spte))
			continue;

		/* 
		 * TODO: this should skip to the end of the parent, because if
		 * the first SPTE can't be made huger, then no SPTEs at this
		 * level can be huger.
		 */
		if (is_last_spte(iter.old_spte, iter.level))
			continue;

		/*
		 * If iter.gfn resides outside of the slot, i.e. the page for
		 * the current level overlaps but is not contained by the slot,
		 * then the SPTE can't be made huge.  More importantly, trying
		 * to query that info from slot->arch.lpage_info will cause an
		 * out-of-bounds access.
		 */
		if (iter.gfn < start || iter.gfn >= end)
			continue;

		if (kvm_mmu_name_tbd(kvm, slot, iter.gfn, &pfn, &writable,
				     &max_mapping_level))
			continue;

		/*
		 * If the range is being invalidated, do not install a SPTE as
		 * KVM may have already zapped this specific gfn, e.g. if KVM's
		 * unmapping has run to completion, but the primary MMU hasn't
		 * zapped its PTEs.  There is no need to check for *past*
		 * invalidations, because all information is gathered while
		 * holding mmu_lock, i.e. it can't have become stale due to a
		 * entire mmu_notifier invalidation sequence completing.
		 */
		if (mmu_invalidate_retry_gfn(kvm, kvm->mmu_invalidate_seq, iter.gfn))
			continue;

		/*
		 * KVM disallows huge pages for write-protected gfns, it should
		 * impossible for make_spte() to encounter such a gfn since
		 * write-protecting a gfn requires holding mmu_lock for write.
		 */
		flush |= __tdp_mmu_map_gfn(...);
		WARN_ON_ONCE(r == RET_PF_EMULATE);
	}

	rcu_read_unlock();

Assuming you don't like the above idea (I'm not sure I do), what if instead of
doing the step-up, KVM starts a second iteration using the shadow page it wants
to replace as the root of the walk?

This has the same subtle dependencies on kvm_mmu_max_mapping_level() and the
ordering with respect to an mmu_notifier invalidation, but it at least avoids
having to reason about the correctness of re-reading a SPTE and modifying the
iteration level within the body of an interation loop.

It should also yield smaller diffs overall, e.g. no revert, no separate commit
to recheck the SPTE, etc.  And I believe it's more performant that the step-up
approach when there are SPTE that _can't_ be huge, as KVM won't traverse down
into the leafs in that case.

An alternative to the tdp_mmu_iter_needs_reched() logic would be to pass in
&flush, but I think that ends up being more confusing and harder to follow.

static int tdp_mmu_make_huge_spte(struct kvm *kvm, struct tdp_iter *parent,
				  u64 *huge_spte)
{
	struct kvm_mmu_page *root = sptep_to_sp(parent->sptep);
	gfn_t start = parent->gfn;
	gfn_t end = start + ???; /* use parent's level */
	struct tdp_iter iter;

	tdp_root_for_each_leaf_pte(iter, root, start, end) 	{
		/*
		 * Use the parent iterator when checking for forward progress,
		 * so that KVM doesn't get stuck due to always yielding while
		 * walking child SPTEs.
		 */
		if (tdp_mmu_iter_needs_reched(kvm, parent))
			return -EAGAIN;

		*huge_spte = make_huge_spte(kvm, iter.old_spte);
		return 0;
	}

	return -ENOENT;
}

static void recover_huge_pages_range(struct kvm *kvm,
				     struct kvm_mmu_page *root,
				     const struct kvm_memory_slot *slot)
{
	gfn_t start = slot->base_gfn;
	gfn_t end = start + slot->npages;
	struct tdp_iter iter;
	int max_mapping_level;
	bool flush = false;
	u64 huge_spte;

	if (WARN_ON_ONCE(kvm_slot_dirty_track_enabled(slot)))
		return;

	rcu_read_lock();

	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
restart:
		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
			flush = false;
			continue;
		}

		if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
		    !is_shadow_present_pte(iter.old_spte))
			continue;

                /*
                 * If iter.gfn resides outside of the slot, i.e. the page for
                 * the current level overlaps but is not contained by the slot,
                 * then the SPTE can't be made huge.  More importantly, trying
                 * to query that info from slot->arch.lpage_info will cause an
                 * out-of-bounds access.
                 */
                if (iter.gfn < start || iter.gfn >= end)
                        continue;

                max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
                if (max_mapping_level < iter.level)
                        continue;

		r = tdp_mmu_make_huge_spte(kvm, &iter, &huge_spte);
		if (r == -EAGAIN)
			goto restart;
		else if (r)
			continue;

		/*
		 * If setting the SPTE fails, e.g. because it has been modified
		 * by a different task, iteration will naturally continue with
		 * the next SPTE.  Don't bother retrying this SPTE, races are
		 * uncommon and odds are good the SPTE 
		 */
		if (!tdp_mmu_set_spte_atomic(kvm, &iter, huge_spte))
			flush = true;
	}

	if (flush)
		kvm_flush_remote_tlbs_memslot(kvm, slot);

	rcu_read_unlock();
}

static inline bool tdp_mmu_iter_needs_reched(struct kvm *kvm,
					     struct tdp_iter *iter)
{
	/* Ensure forward progress has been made before yielding. */
	return iter->next_last_level_gfn != iter->yielded_gfn &&
	       (need_resched() || rwlock_needbreak(&kvm->mmu_lock));

}

/*
 * Yield if the MMU lock is contended or this thread needs to return control
 * to the scheduler.
 *
 * If this function should yield and flush is set, it will perform a remote
 * TLB flush before yielding.
 *
 * If this function yields, iter->yielded is set and the caller must skip to
 * the next iteration, where tdp_iter_next() will reset the tdp_iter's walk
 * over the paging structures to allow the iterator to continue its traversal
 * from the paging structure root.
 *
 * Returns true if this function yielded.
 */
static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
							  struct tdp_iter *iter,
							  bool flush, bool shared)
{
	WARN_ON_ONCE(iter->yielded);

	if (!tdp_mmu_iter_needs_reched(kvm, iter))
		return false;

	if (flush)
		kvm_flush_remote_tlbs(kvm);

	rcu_read_unlock();

	if (shared)
		cond_resched_rwlock_read(&kvm->mmu_lock);
	else
		cond_resched_rwlock_write(&kvm->mmu_lock);

	rcu_read_lock();

	WARN_ON_ONCE(iter->gfn > iter->next_last_level_gfn);

	iter->yielded = true;
	return true;
}

