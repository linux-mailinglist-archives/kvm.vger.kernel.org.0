Return-Path: <kvm+bounces-24657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE3D958C37
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 18:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B6CA1C21C7F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 16:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A021B3F08;
	Tue, 20 Aug 2024 16:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwMp4Urv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0B34409;
	Tue, 20 Aug 2024 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724171540; cv=none; b=aoJnCcSSqKM2HAbHW/Ne6z433y6fh0tHL49NGSYr1ELjIgQEn8dXr1tlliwUq6sDx4zvtHlHtzUpzrXR0/LTrHyoUacUeSih5+BGxQXOtP+8CurVTReXHYbxWG/8ZqxyQJsaPODnZbD+kE9Z/Wjl55P2DzvmspZCIZJqBVbG8rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724171540; c=relaxed/simple;
	bh=sKSLSYeyG3cz5N3VPlYdys9YYWm2DA22kSv3LrlYA/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJtFH1fqFqgmgktnEPz0KRb1WX6xvXYbTcnDGNCaYKlSNWbE77K6NleUBFsgRH7w/ryOZpT9xk24LtMi/AcVFdvzdwtzC8vkLO/kTjDqrkp/h6lRgjP6F+B6mYKQLll4ykX/boAQnZzcMx0ahzjCEGyX+JkcmYBMDn2h+5ReFwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwMp4Urv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9B2C4AF0B;
	Tue, 20 Aug 2024 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724171540;
	bh=sKSLSYeyG3cz5N3VPlYdys9YYWm2DA22kSv3LrlYA/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lwMp4UrvmbsPqfUtfAp1f4x7udLu7LkQwiI093JH7xciXpW1WiP9/zsQm+1otZJ0z
	 3OTJqAMM9rQoUL+SgbA4X/53QK56hB4FdWyfkoy8G9Wew4zQzgIpc3NxjF72tCm7/h
	 +uk4fHpXLSPgNlwtVWgO4WWLDDsxB11+2yAk1SBZJUsz2c+V6eq8jw1OKQ3rrQIoUv
	 +5G1PGf/3nWPGfcFC/VSrJqn4MEG9wyOdJotXxqdzCtggQLvXVdyWT1Ca9VbjmCVCG
	 E4LaTXiTFW33NSpazRhunMSNoiWYarPIc5pdfQ5RnBsbPj4dTDDPECJMbhXzQujgZb
	 AxxFiBzgJRdcQ==
Date: Tue, 20 Aug 2024 17:32:15 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: Use precise range-based flush in mmu_notifier hooks
 when possible
Message-ID: <20240820163213.GD28750@willie-the-truck>
References: <20240802191617.312752-1-seanjc@google.com>
 <20240820154150.GA28750@willie-the-truck>
 <ZsS_OmxwFzrqDcfY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsS_OmxwFzrqDcfY@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 20, 2024 at 09:07:22AM -0700, Sean Christopherson wrote:
> On Tue, Aug 20, 2024, Will Deacon wrote:
> > On Fri, Aug 02, 2024 at 12:16:17PM -0700, Sean Christopherson wrote:
> > > Do arch-specific range-based TLB flushes (if they're supported) when
> > > flushing in response to mmu_notifier events, as a single range-based flush
> > > is almost always more performant.  This is especially true in the case of
> > > mmu_notifier events, as the majority of events that hit a running VM
> > > operate on a relatively small range of memory.
> > > 
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Will Deacon <will@kernel.org>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > > 
> > > This is *very* lightly tested, a thumbs up from the ARM world would be much
> > > appreciated.
> > > 
> > >  virt/kvm/kvm_main.c | 15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index d0788d0a72cc..46bb95d58d53 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -599,6 +599,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
> > >  	struct kvm_gfn_range gfn_range;
> > >  	struct kvm_memory_slot *slot;
> > >  	struct kvm_memslots *slots;
> > > +	bool need_flush = false;
> > >  	int i, idx;
> > >  
> > >  	if (WARN_ON_ONCE(range->end <= range->start))
> > > @@ -651,10 +652,22 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
> > >  					goto mmu_unlock;
> > >  			}
> > >  			r.ret |= range->handler(kvm, &gfn_range);
> > > +
> > > +			/*
> > > +			 * Use a precise gfn-based TLB flush when possible, as
> > > +			 * most mmu_notifier events affect a small-ish range.
> > > +			 * Fall back to a full TLB flush if the gfn-based flush
> > > +			 * fails, and don't bother trying the gfn-based flush
> > > +			 * if a full flush is already pending.
> > > +			 */
> > > +			if (range->flush_on_ret && !need_flush && r.ret &&
> > > +			    kvm_arch_flush_remote_tlbs_range(kvm, gfn_range.start,
> > > +							     gfn_range.end - gfn_range.start))
> > > +				need_flush = true;
> > 
> > Thanks for having a crack at this.
> > 
> > We could still do better in the ->clear_flush_young() case if the
> 
> For clear_flush_young(), I 100% think we should let architectures opt out of the
> flush.  For architectures where it's safe, the primary MMU doesn't do a TLB flush,
> and hasn't for years.  Sending patches for this (for at least x86 and arm64) is
> on my todo list.

I can see the appeal of dropping the invalidation altogether, although
with the zoo of different micro-architectures we have on arm64 I do
worry that it could potentially make the AF information a lot useful on
some parts. Does x86 make any guarantees about when an old pte becomes
visible to the CPU in the absence of explicit TLB invalidation? (e.g.
I'm wondering if it's bounded by the next context switch or something
like that).

> Even better would be to kill off mmu_notifier_clear_flush_young() entirely, e.g.
> if all KVM architectures can elide the flush.

I, for one, would love to see fewer MMU notifiers :)

> And even better than that would be to kill pxxx_clear_flush_young_notify() in
> the kernel, but I suspect that's not feasible as there are architectures that
> require a TLB flush for correctness.

I think you might want it for IOMMUs as well.

> > handler could do the invalidation as part of its page-table walk (for
> > example, it could use information about the page-table structure such
> > as the level of the leaves to optimise the invalidation further), but
> > this does at least avoid zapping the whole VMID on CPUs with range
> > support.
> > 
> > My only slight concern is that, should clear_flush_young() be extended
> > to operate on more than a single page-at-a-time in future, this will
> > silently end up invalidating the entire VMID for each memslot unless we
> > teach kvm_arch_flush_remote_tlbs_range() to return !0 in that case.
> 
> I'm not sure I follow the "entire VMID for each memslot" concern.  Are you
> worried about kvm_arch_flush_remote_tlbs_range() failing and triggering a VM-wide
> flush?

The arm64 implementation of kvm_arch_flush_remote_tlbs_range()
unconditionally returns 0, so we could end up over-invalidating pretty
badly if that doesn't change. It should be straightforward to fix, but
I just wanted to point it out because it would be easy to miss too!

Will

