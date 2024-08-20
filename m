Return-Path: <kvm+bounces-24661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02141958CBF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 19:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC95C2874B0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 17:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812BC1BDA9A;
	Tue, 20 Aug 2024 17:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flXUSKdM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3F91922D3
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724173565; cv=none; b=L1hPV6JtqHnZDP61ztLg/wwAqDSupeltpBRuJJ6D+DhZqXyAgD28MYdCk5fWAmoeIzOyTJ5goc/l4XnElAZ5ZkVfsdqSdYBJjRjqbhZAHAF5H+uMwLgdI++y5qSoQxkKBbhr9kcTaeZaZs6hvBZ4O3zLtWxRT5X31GVzNmUOfno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724173565; c=relaxed/simple;
	bh=EuNvhjGdxLOn8Y7aFVLHEiHc6QDNELr4w8qUxZScPAs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AWRfYKhYsCHDsg+USb69TTTDpNtr9+jzDeVxrkz9tKBn3pLx9i2ppCjz/OiMWJsQkppjBaokrU0ZAGjokWt+JYIF6PyqrxKVzVG+ytfVq639YwT7epcn9id34kYvNeeOA/7BezdsbRKqvNeUoQluUAMQbJvH9FEI54VoXP5rgmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flXUSKdM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7141ab07fddso411083b3a.0
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 10:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724173562; x=1724778362; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnfPRtkJtWGuNOam4xWRBqpUc7C9ZTAOrKLGKcWYgso=;
        b=flXUSKdMuj9aBvzk9ESeVcMqdWNKVSvZ1vkyWuRfuNCS4i2T4b/jvpZK6gnjBmFir+
         s+lgIs8J3191NGshE//UqpYLptfqvyeYaa6+YK+JZyD0/XBQlX1aCdoBOyyewGBh61+r
         K1HPFnLrQlwsOhd+aAPfqo+qOsYq3MYaByE0Bn/UvwsWFalvKgHmxuneiGWW5lK6fctE
         uOlKaE/SSMG0QIo0GAdYCeUMrnBndf7R+8RV6V97YtE5275Vsuxq+h5y2oAdOTpMqWm2
         ZiO/wsz4uVU5Sh0eEjP9ZyqhNMzGlP3LhbD6g7WGKMYD/e++GkWoyrhFjKBfyrl8htiF
         SE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724173562; x=1724778362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xnfPRtkJtWGuNOam4xWRBqpUc7C9ZTAOrKLGKcWYgso=;
        b=r1+lSdm1zmKbcs64FqTLsLIcOQzFN3TS9doSraV3JACJDtIVSdxgEbCeWhrAqPltqT
         MZqcH6SiPyoROOP2Va1wPkAiP+l6TJCjjjdvUx2BZTxjLCMWETXn3HlfarmClzA9YMlr
         7J8Qv6OUyg8sOE03/1//mgpcA9Der57foNPN+YgvB4LyFHMLf1mg2a//9umMin1bf4TI
         sGnVUJBslgBfEWU+xGjjXGKgKKCHCLD8zk6iVP1hEZ1DI9xxV9jyktm3UQLkbTg3Ure/
         oKqMeQHW1mv76DpBFFse3a8G+ccp8qQkAo/BEa5U4AEDICklHTaPBLaVK4LCIcUPhcxz
         7dqw==
X-Forwarded-Encrypted: i=1; AJvYcCVOIO+mks0/R1N//DN0kgR/srOtXAtMK5z11Xrd8lazccctuyK+SqppgjqSum+0UfSOw30=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhSz6UYjBdRuGDIuKX4VSTid1Uue0Dgb2SofFHOe/B/5tka/cz
	FyrE1WdwY8hp0khVRxOcN4O/AuuiHBkU+z+Gh0kvqWKdWguijgGARBWNgw6oPVtCgkbwmyulH2b
	/+Q==
X-Google-Smtp-Source: AGHT+IG9Fct7a82/pANZsrBLxffOf52NxCKBO7eUULMtkjcylX54yi0AFF867FTtAGlClqIDZ8YKA/hqqj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:7c7:b0:70e:9e1e:e6ed with SMTP id
 d2e1a72fcca58-713c4e0c407mr46988b3a.2.1724173561608; Tue, 20 Aug 2024
 10:06:01 -0700 (PDT)
Date: Tue, 20 Aug 2024 10:06:00 -0700
In-Reply-To: <20240820163213.GD28750@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802191617.312752-1-seanjc@google.com> <20240820154150.GA28750@willie-the-truck>
 <ZsS_OmxwFzrqDcfY@google.com> <20240820163213.GD28750@willie-the-truck>
Message-ID: <ZsTM-Olv8aT2rql6@google.com>
Subject: Re: [PATCH] KVM: Use precise range-based flush in mmu_notifier hooks
 when possible
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Will Deacon wrote:
> On Tue, Aug 20, 2024 at 09:07:22AM -0700, Sean Christopherson wrote:
> > On Tue, Aug 20, 2024, Will Deacon wrote:
> > > On Fri, Aug 02, 2024 at 12:16:17PM -0700, Sean Christopherson wrote:
> > > > Do arch-specific range-based TLB flushes (if they're supported) when
> > > > flushing in response to mmu_notifier events, as a single range-based flush
> > > > is almost always more performant.  This is especially true in the case of
> > > > mmu_notifier events, as the majority of events that hit a running VM
> > > > operate on a relatively small range of memory.
> > > > 
> > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > > 
> > > > This is *very* lightly tested, a thumbs up from the ARM world would be much
> > > > appreciated.
> > > > 
> > > >  virt/kvm/kvm_main.c | 15 ++++++++++++++-
> > > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index d0788d0a72cc..46bb95d58d53 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -599,6 +599,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
> > > >  	struct kvm_gfn_range gfn_range;
> > > >  	struct kvm_memory_slot *slot;
> > > >  	struct kvm_memslots *slots;
> > > > +	bool need_flush = false;
> > > >  	int i, idx;
> > > >  
> > > >  	if (WARN_ON_ONCE(range->end <= range->start))
> > > > @@ -651,10 +652,22 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
> > > >  					goto mmu_unlock;
> > > >  			}
> > > >  			r.ret |= range->handler(kvm, &gfn_range);
> > > > +
> > > > +			/*
> > > > +			 * Use a precise gfn-based TLB flush when possible, as
> > > > +			 * most mmu_notifier events affect a small-ish range.
> > > > +			 * Fall back to a full TLB flush if the gfn-based flush
> > > > +			 * fails, and don't bother trying the gfn-based flush
> > > > +			 * if a full flush is already pending.
> > > > +			 */
> > > > +			if (range->flush_on_ret && !need_flush && r.ret &&
> > > > +			    kvm_arch_flush_remote_tlbs_range(kvm, gfn_range.start,
> > > > +							     gfn_range.end - gfn_range.start))
> > > > +				need_flush = true;
> > > 
> > > Thanks for having a crack at this.
> > > 
> > > We could still do better in the ->clear_flush_young() case if the
> > 
> > For clear_flush_young(), I 100% think we should let architectures opt out of the
> > flush.  For architectures where it's safe, the primary MMU doesn't do a TLB flush,
> > and hasn't for years.  Sending patches for this (for at least x86 and arm64) is
> > on my todo list.
> 
> I can see the appeal of dropping the invalidation altogether, although
> with the zoo of different micro-architectures we have on arm64 I do
> worry that it could potentially make the AF information a lot useful on
> some parts. Does x86 make any guarantees about when an old pte becomes
> visible to the CPU in the absence of explicit TLB invalidation? (e.g.
> I'm wondering if it's bounded by the next context switch or something
> like that).

Nope.  As pointed out by Yu in the MGLRU series[*], the main argument is that if
there is memory pressure, i.e. a need for reclaim, then it's all but guaranteed
that there will be even more TLB pressure.  And while false negatives are certainly
possible, nr_scanned >> nr_reclaimed >> nr_bad_reclaims, i.e. the total cost of
false negatives is less than the total cost of the flushes because there are
orders of magnitude more pages scanned than there are pages that are incorrectly
reclaimed.

https://lore.kernel.org/all/CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com

> 
> > Even better would be to kill off mmu_notifier_clear_flush_young() entirely, e.g.
> > if all KVM architectures can elide the flush.
> 
> I, for one, would love to see fewer MMU notifiers :)
> 
> > And even better than that would be to kill pxxx_clear_flush_young_notify() in
> > the kernel, but I suspect that's not feasible as there are architectures that
> > require a TLB flush for correctness.
> 
> I think you might want it for IOMMUs as well.
> 
> > > handler could do the invalidation as part of its page-table walk (for
> > > example, it could use information about the page-table structure such
> > > as the level of the leaves to optimise the invalidation further), but
> > > this does at least avoid zapping the whole VMID on CPUs with range
> > > support.
> > > 
> > > My only slight concern is that, should clear_flush_young() be extended
> > > to operate on more than a single page-at-a-time in future, this will
> > > silently end up invalidating the entire VMID for each memslot unless we
> > > teach kvm_arch_flush_remote_tlbs_range() to return !0 in that case.
> > 
> > I'm not sure I follow the "entire VMID for each memslot" concern.  Are you
> > worried about kvm_arch_flush_remote_tlbs_range() failing and triggering a VM-wide
> > flush?
> 
> The arm64 implementation of kvm_arch_flush_remote_tlbs_range()
> unconditionally returns 0, so we could end up over-invalidating pretty
> badly if that doesn't change. It should be straightforward to fix, but
> I just wanted to point it out because it would be easy to miss too!

Sorry, I'm still not following.  0==success, and gfn_range.{start,end} is scoped
precisely to the overlap between the memslot and hva range.  Regardless of the
number of pages that are passed into clear_flush_young(), KVM should naturally
flush only the exact range being aged.  The only hiccup would be if the hva range
straddles multiple memslots, but if userspace creates multiple memslots for a
single vma, then that's a userspace problem.

