Return-Path: <kvm+bounces-24555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE214957741
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 00:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AA84B22DE8
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 22:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E0D1DC48B;
	Mon, 19 Aug 2024 22:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XHIIzNCG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEAB196C7C
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 22:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105567; cv=none; b=e+xw23OoB5rVeK1knbwmkf2cS5AGspFXI4YgUSlgSiQo2Hry5JknxAir1hp0rvQU96nasQtCe9JhfqiIzLvdX1lCPISIh+1LfoNpRDLp0YBf76WU4L6FHXW7KIjAoFh+gF4YlZcyQwOl/DhA4Nxcv6Kkq3uEts7Xa3Ar/jVBkrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105567; c=relaxed/simple;
	bh=UiXs6zD28hssZRLCLo9EvBEDjgK4mstg9o5FXfDEMIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mmtRoezuJWCgpaVPqzksA6SDKP3BjhuflpI7M42fRDKIC3H1xK48lFZPdxzueKgmWjNYv1ZhtOglO8MDyCNrPpwJw1Go25uF2F3bZyKwZrBme/Iz9wQRCsJi2B5XAT+1yQoCVbKzvI8JlopxVlfRmz/W4TJN3y54PlK/7K6pwbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XHIIzNCG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201e7b422ffso40114745ad.2
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724105565; x=1724710365; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iXnF7CFflCVzg+5rIL0bGi4MMOBAsXmrKtPHvfvnNLU=;
        b=XHIIzNCGnTsJTT3H4JO1Q7L4d4ArRy/drCtHO+NHz0sX8p74JjkgHeV/p4forjF8ep
         W1VignPRKMZTeYo0OqZLZjF1MyJuqnud1xmt/vjRlYD5n8FKXcAEbDL5P8GTDcklEGNA
         z29uc/re2zIE5o1Bz9LY7I/2XM+Wd+ZBoK+vu2Q+uFcCu/s41SRSJSaElGJYTygi6zbA
         smNwZ1jrIgtx5xKFs10BB3rwH2W5yH3ZN2jU24YeaMN+o7smlhSNBm8OPj8TjpUubyD7
         CyY3qGiaeLR2nXQiiKrz//GXLS0HMJADFMkg0zKa2ypCN7Re233w6sL2DcoxFQeEv84j
         3Z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724105565; x=1724710365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXnF7CFflCVzg+5rIL0bGi4MMOBAsXmrKtPHvfvnNLU=;
        b=dIh8suILFOcRVbYcQ0GsBBydG+erfCZy79+mBqnE//E0pWnIbv5QOX4izpYSug6lqA
         C/Ng980VhyV1A/EH9HJ9J9i+0N681pVPo4qPdNau+E/4vtP+8vedSPm0ULjBpohjqJbS
         FLdFw8XyTJuJHXcHN5IHg5x0Xdzvn5Kn3B3X9oZ+IChAASjfeJ5Tr2ENcUOq5sKFcw04
         6gyDgmcoZ5yby04yo8B/yxVXleZ4llSZIn9FWTJXRQwW2RbvkTCOANp6X+G4MCm9KJIO
         hDhCNO82RUaksZ9EvJsVcDUU4A10DjYnkcOXqj2nFQRYXRob/DqpGdGb6pC2CMrg/sS+
         sZGw==
X-Forwarded-Encrypted: i=1; AJvYcCVvU/s6wj+qw577q+V0WkI8U8GjK6Hx8MphKSWxuM1qrk4Z5+ZpfMSmedi0hrGMnwt4LPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVlh+e/SrRDe6OYELx0gDnlahtJ9D7CYLJ+uGbJsTo5biZr8Yl
	Bkwl3fJOdBW4B7KKHA0jhyZUxHF9rzytKbLKaaBtBp7PVbAnb6882D2uJ0rt89ymqW+j6O+X55y
	a9w==
X-Google-Smtp-Source: AGHT+IGEA574v2J9KAPMCMxHEShCkR/wuKzeCiNAavZMxYHu7+AsVX7MwmdhLN3WT6ZWko3ibb65f6BkS8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:247:b0:1fa:2b89:f550 with SMTP id
 d9443c01a7336-20203e5ea60mr10956245ad.1.1724105564411; Mon, 19 Aug 2024
 15:12:44 -0700 (PDT)
Date: Mon, 19 Aug 2024 15:12:42 -0700
In-Reply-To: <20240819173453.GB2210585.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com> <20240812171341.1763297-3-vipinsh@google.com>
 <Zr_i3caXmIZgQL0t@google.com> <20240819173453.GB2210585.vipinsh@google.com>
Message-ID: <ZsPDWqOiv_g7Wh_H@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 19, 2024, Vipin Sharma wrote:
> On 2024-08-16 16:38:05, Sean Christopherson wrote:
> > On Mon, Aug 12, 2024, Vipin Sharma wrote:
> > > @@ -1831,12 +1845,17 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
> > >  		 * recovered, along with all the other huge pages in the slot,
> > >  		 * when dirty logging is disabled.
> > >  		 */
> > > -		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
> > > +		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
> > > +			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > >  			unaccount_nx_huge_page(kvm, sp);
> > > -		else
> > > -			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
> > > -
> > > -		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> > > +			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > > +			to_zap--;
> > > +			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> > > +		} else if (tdp_mmu_zap_sp(kvm, sp)) {
> > > +			flush = true;
> > > +			to_zap--;
> > 
> > This is actively dangerous.  In the old code, tdp_mmu_zap_sp() could fail only
> > in a WARN-able scenario, i.e. practice was guaranteed to succeed.  And, the
> > for-loop *always* decremented to_zap, i.e. couldn't get stuck in an infinite
> > loop.
> > 
> > Neither of those protections exist in this version.  Obviously it shouldn't happen,
> > but it's possible this could flail on the same SP over and over, since nothing
> > guarnatees forward progress.  The cond_resched() would save KVM from true pain,
> > but it's still a wart in the implementation.
> > 
> > Rather than loop on to_zap, just do
> > 
> > 	list_for_each_entry(...) {
> > 
> > 		if (!to_zap)
> > 			break;
> > 	}
> > 
> > And if we don't use separate lists, that'll be an improvement too, as it KVM
> > will only have to skip "wrong" shadow pages once, whereas this approach means
> > every iteration of the loop has to walk past the "wrong" shadow pages.
> 
> TDP MMU accesses possible_nx_huge_pages using tdp_mmu_pages_lock spin
> lock. We cannot hold it for recovery duration.

Ah, right.  Hmm, we actually can.  More thoughts below.

> In this patch, tdp_mmu_zap_sp() has been modified to retry failures,
> which is similar to other retry mechanism in TDP MMU. Won't it be the
> same issue with other TDP MMU retry flows?

Similar, but not exactly the same.  The other flows are guarnateed to make forward
progress, as they'll never revisit a SPTE.  I.e. once a SPTE is observed to be
!shadow-present, that SPTE will never again be processed.

This is spinning on a pre-computed variable, and waiting until that many SPs have
been zapped.  The early break if the list is empty mostly protects against an
infinite loop, but it's theoretically possible other tasks could keep adding and
deleting from the list, in perpetuity.

Side topic, with the proposed changes, kvm_tdp_mmu_zap_sp() should return an int,
not a bool, i.e. 0/-errno, not true/false.  The existing code is specifically
returning whether or not a flush is needed, it does NOT indicate whether or not
the shadow page was successfully zapped, i.e. the !PRESENT case is treated as
being successful since something apparently already zapped the page.

[never mind, I've since come up with a better idea, but I typed  all this out,
 so I'm leaving it]

What about something like this?  If the shadow page can't be zapped because
something else was modifying it, just move on and deal with it next time.

	for ( ; to_zap; --to_zap) {
		...


		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
			unaccount_nx_huge_page(kvm, sp);
			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
		} else if (!tdp_mmu_zap_sp(...)) {
			flush = true;
		} else {
			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
			list_move_tail(&sp->possible_nx_huge_page_link, kvm->
				       &kvm->arch.possible_nx_huge_pages);
			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
		}
	}

But jumping back to the "we actually can [hold tdp_mmu_pages_lock]", if the zap
is split into the actually CMPXCHG vs. handle_removed_pt() call, then the lock
can be held while walking+zapping.  And it's quite straightforward, if we're
willing to forego the sanity checks on the old_spte, which would require wrapping
the sp in a struct to create a tuple.

The only part that gives me pause is the fact that it's not super obvious that,
ignoring the tracepoint, handle_changed_spte() is just a fat wrapper for
handle_removed_pt() when zapping a SP.

Huh.  Actually, after a lot of fiddling and staring, there's a simpler solution,
and it would force us to comment/document an existing race that's subly ok.

For the dirty logging case, the result of kvm_mmu_sp_dirty_logging_enabled() is
visible to the NX recovery thread before the memslot update task is guaranteed
to finish (or even start) kvm_mmu_zap_collapsible_sptes().  I.e. KVM could
unaccount an NX shadow page before it is zapped, and that could lead to a vCPU
replacing the shadow page with an NX huge page.

Functionally, that's a-ok, because the accounting doesn't provide protection
against iTLB multi-hit bug, it's there purely to prevent KVM from bouncing a gfn
between an NX hugepage and an execute small page.  The only downside to the vCPU
doing the replacement is that the vCPU will get saddle with tearing down all the
child SPTEs.  But this should be a very rare race, so I can't imagine that would
be problematic in practice.

This contains some feedback I gathered along the, I'll respond to the original
patch since the context is lost.

static bool tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,
					      struct kvm_mmu_page *sp)
{
	struct tdp_iter iter = {
		.old_spte = sp->ptep ? kvm_tdp_mmu_read_spte(sp->ptep) : 0,
		.sptep = sp->ptep,
		.level = sp->role.level + 1,
		.gfn = sp->gfn,
		.as_id = kvm_mmu_page_as_id(sp),
	};

	lockdep_assert_held_read(&kvm->mmu_lock);

	/*
	 * Root shadow pages don't a parent page table and thus no associated
	 * entry, but they can never be possible NX huge pages.
	 */
	if (WARN_ON_ONCE(!sp->ptep))
		return false;

	/*
	 * Since mmu_lock is held in read mode, it's possible another task has
	 * already modified the SPTE.  Zap the SPTE if and only if the SPTE
	 * points at the SP's page table, as checking  shadow-present isn't
	 * sufficient, e.g. the SPTE could be replaced by a leaf SPTE, or even
	 * another SP.  Note, spte_to_child_pt() also checks that the SPTE is
	 * shadow-present, i.e. guards against zapping a frozen SPTE.
	 */
	if (sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
		return false;

	/*
	 * If a different task modified the SPTE, then it should be impossible
	 * for the SPTE to still be used for the to-be-zapped SP.  Non-leaf
	 * SPTEs don't have Dirty bits, KVM always sets the Accessed bit when
	 * creating non-leaf SPTEs, and all other bits are immutable for non-
	 * leaf SPTEs, i.e. the only legal operations for non-leaf SPTEs are
	 * zapping and replacement.
	 */
	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE)) {
		WARN_ON_ONCE(sp->spt == spte_to_child_pt(iter.old_spte, iter.level));
		return false;
	}

	return true;
}

void kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, unsigned long to_zap)
{
	struct kvm_mmu_page *sp;
	bool flush = false;

	lockdep_assert_held_read(&kvm->mmu_lock);
	/*
	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
	 * be done under RCU protection, because the pages are freed via RCU
	 * callback.
	 */
	rcu_read_lock();

	for ( ; to_zap; --to_zap) {
		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
		if (list_empty(&kvm->arch.possible_tdp_mmu_nx_huge_pages))
			break;

		sp = list_first_entry(&kvm->arch.possible_tdp_mmu_nx_huge_pages,
				      struct kvm_mmu_page,
				      possible_nx_huge_page_link);

		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
		WARN_ON_ONCE(!sp->role.direct);

		/*
		 * Unaccount the shadow page before zapping its SPTE so as to
		 * avoid bouncing tdp_mmu_pages_lock() more than is necessary.
		 * Clearing nx_huge_page_disallowed before zapping is safe, as
		 * the flag doesn't protect against iTLB multi-hit, it's there
		 * purely to prevent bouncing the gfn between an NX huge page
		 * and an X small spage.  A vCPU could get stuck tearing down
		 * the shadow page, e.g. if it happens to fault on the region
		 * before the SPTE is zapped and replaces the shadow page with
		 * an NX huge page and get stuck tearing down the child SPTEs,
		 * but that is a rare race, i.e. shouldn't impact performance.
		 */
		unaccount_nx_huge_page(kvm, sp);

		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);

		/*
		 * Don't bother zapping shadow pages if the memslot is being
		 * dirty logged, as the relevant pages would just be faulted
		 * back in as 4KiB pages.  Potential NX Huge Pages in this slot
		 * will be recovered, along with all the other huge pages in
		 * the slot, when dirty logging is disabled.
		 */
		if (!kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
			flush |= tdp_mmu_zap_possible_nx_huge_page(kvm, sp);

		WARN_ON_ONCE(sp->nx_huge_page_disallowed);

		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
			if (flush) {
				kvm_flush_remote_tlbs(kvm);
				flush = false;
			}
			rcu_read_unlock();
			cond_resched_rwlock_read(&kvm->mmu_lock);
			rcu_read_lock();
		}
	}

	if (flush)
		kvm_flush_remote_tlbs(kvm);
	rcu_read_unlock();
}


