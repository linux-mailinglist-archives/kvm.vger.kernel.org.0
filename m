Return-Path: <kvm+bounces-8123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E4684BCD0
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43BFF1F23A6F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE48A134AC;
	Tue,  6 Feb 2024 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4fBZle52"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E45CDF71
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707243666; cv=none; b=RYh/o2oynbezlqpaaj3igWY2ilt7J7OXdJm4Pc1u/KR82ZIu6wXa0rNZh3stQORxxKxJvqDeeFdk69Igwr4SJOmg7Az9CwMreh9JKVfpY11bPFH+Jyuhx0ev6u2WBvWjY/MpUKbAKiYN6BrBqqGOUq5fvlOrlXDuqvN8BedrtjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707243666; c=relaxed/simple;
	bh=/MlM5rAxErSc52f8uAboDn9Px2mtKuGXMTnYEUz69g4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qoiffhcfQMD8BehTCOmmwD7yYPLceKyllBJLwHkjO/W5Axcl7XC3npPP4WNzTSD0mZxMs60j9cg3DSWVXz+kg2gzXW7jsenk/+ltuxQt9N9WE7dicWYPTwszAeVTfxinlTEM3Tw78kqBcxW60RNzMteo1l48zWX7ixxyIVQfWMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4fBZle52; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ba69e803so9896678276.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707243662; x=1707848462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YWkxJlkXZn2XKzfrRn210wVpvl5epIQvB1ytCNVqVwI=;
        b=4fBZle52k1ZTsQ8Q3ingUJouXzR8PGGblLmjqm6RzuUG4W0ZVXp3+DaQN6gcyP4VPh
         eFdAlcYllbAeAOr3ZyzGCByoXNY/2Z9t8Fd8mUzWRhvWG94u/+r2sZZ2NpWTj3hjGEEO
         Q38Z7PdStGh9m+ryqLOS6d5/QrRbeaVUGxAaI5dnC/hgxJOH8Hs0uEes6mzWFOvepmIM
         cqD0ZiO2AemIxClFff/LUYP7prWT48ooiL9H2jMj7BQvmHfj7jGe+Z2anKiDT0Ebo64t
         C9lVb5c9nV13a/QbxlRwPRAAugjdnIfHw7uj6ay06eVcAanbMt1aktjFXEN1615bjAKy
         D74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707243662; x=1707848462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YWkxJlkXZn2XKzfrRn210wVpvl5epIQvB1ytCNVqVwI=;
        b=CQYGCJF7HFsccuboz3X5NknNw3Gbh+SROSYC85uiDicXLbErIkyyDnKD5hd10CIrAB
         rxloMWWJe1AI3WDYM9geK4ZEbdi1SjDbuIKz2BoFwcZOTuxl0fFCO8zTk4avDbR0RWcs
         uxxuPyUzPPgzzginUhRY02fa5lDU4DIizKt9EiFW07B5X0UyLOsMancC9ahH+zVoTLRo
         kahogE4xn1QCUifu9DDjaeHu+u+4IfXKLzUMDA0c6zjAwoLw6ysdgva6EJchlySHo0F/
         mC5cdBHZcSCWswxSPkrvHOCapN32Ux5spu6+B3eJT+R4LypH7VBSiPVz6UsXFdjKHQop
         ICJQ==
X-Gm-Message-State: AOJu0Yz+O+LyASClbIlv5Tl4+dVerhWTxOr/qFvyBxaJN7KfzlQxCLIb
	/HmD+XSqPvWT22bSE39UcyvdbYdpdHEMZB6Fs1esiFE6qU0oxyQj7KJAQBp2Z0emvW3hBxvMTND
	kzA==
X-Google-Smtp-Source: AGHT+IGXCRY9CRGbeWTa8dniGzgzbjU3X1mgUxh9V8P5owxu1shZ410wWmVoq1XhC8hJAT9SL613yOyomMI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2842:b0:dc6:519b:5425 with SMTP id
 ee2-20020a056902284200b00dc6519b5425mr612720ybb.11.1707243662363; Tue, 06 Feb
 2024 10:21:02 -0800 (PST)
Date: Tue, 6 Feb 2024 10:21:00 -0800
In-Reply-To: <ZcJHYtMZsQHInVEI@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com> <20240111020048.844847-7-seanjc@google.com>
 <ZcIFTkWaTqItQPsj@yilunxu-OptiPlex-7050> <ZcJHYtMZsQHInVEI@yilunxu-OptiPlex-7050>
Message-ID: <ZcJ4jBQatw7ti46D@google.com>
Subject: Re: [PATCH 6/8] KVM: x86/mmu: Check for usable TDP MMU root while
 holding mmu_lock for read
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Xu Yilun wrote:
> On Tue, Feb 06, 2024 at 06:09:18PM +0800, Xu Yilun wrote:
> > On Wed, Jan 10, 2024 at 06:00:46PM -0800, Sean Christopherson wrote:
> > > When allocating a new TDP MMU root, check for a usable root while holding
> > > mmu_lock for read and only acquire mmu_lock for write if a new root needs
> > > to be created.  There is no need to serialize other MMU operations if a
> > > vCPU is simply grabbing a reference to an existing root, holding mmu_lock
> > > for write is "necessary" (spoiler alert, it's not strictly necessary) only
> > > to ensure KVM doesn't end up with duplicate roots.
> > > 
> > > Allowing vCPUs to get "new" roots in parallel is beneficial to VM boot and
> > > to setups that frequently delete memslots, i.e. which force all vCPUs to
> > > reload all roots.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c     |  8 ++---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 60 +++++++++++++++++++++++++++++++-------
> > >  arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
> > >  3 files changed, 55 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 3c844e428684..ea18aca23196 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3693,15 +3693,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> > >  	unsigned i;
> > >  	int r;
> > >  
> > > +	if (tdp_mmu_enabled)
> > > +		return kvm_tdp_mmu_alloc_root(vcpu);
> > > +
> > >  	write_lock(&vcpu->kvm->mmu_lock);
> > >  	r = make_mmu_pages_available(vcpu);
> > >  	if (r < 0)
> > >  		goto out_unlock;
> > >  
> > > -	if (tdp_mmu_enabled) {
> > > -		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > > -		mmu->root.hpa = root;
> > > -	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > > +	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > >  		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
> > >  		mmu->root.hpa = root;
> > >  	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index e0a8343f66dc..9a8250a14fc1 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -223,21 +223,52 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
> > >  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
> > >  }
> > >  
> > > -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > > +static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
> > >  {
> > >  	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> > > +	int as_id = kvm_mmu_role_as_id(role);
> > >  	struct kvm *kvm = vcpu->kvm;
> > >  	struct kvm_mmu_page *root;
> > >  
> > > -	lockdep_assert_held_write(&kvm->mmu_lock);
> > > -
> > > -	/* Check for an existing root before allocating a new one. */
> > > -	for_each_valid_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> > > -		if (root->role.word == role.word &&
> > > -		    kvm_tdp_mmu_get_root(root))
> > > -			goto out;
> > > +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> > 
> > No lock yielding attempt in this loop, why change to _yield_safe version?

Because variants that don't allow yielding, i.e. for_each_valid_tdp_mmu_root()
as of this patch, require mmu_lock be held for write.  Holding mmu_lock for write
is necessary because that simpler version uses list_for_each_entry() and doesn't
grab a reference to the root, i.e. entries on the list could be freed, e.g. by
kvm_tdp_mmu_zap_invalidated_roots().

The _yield_safe() versions don't require the user to want to yield.  The naming
is _yield_safe() because the yield-safe iterators can run with mmu_lock held for
read *or* right.

> Oh, I assume you just want to early exit the loop with the reference to
> root hold.  But I feel it makes harder for us to have a clear
> understanding of the usage of _yield_safe and non _yield_safe helpers.
> 
> Maybe change it back?

No.  There's even a comment above for_each_tdp_mmu_root() (which is
for_each_valid_tdp_mmu_root() as of this patch) that explains the difference.
The rule is essentially, use the yield-safe variant unless there's a good reason
not to.

/*
 * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
 * the implication being that any flow that holds mmu_lock for read is
 * inherently yield-friendly and should use the yield-safe variant above.
 * Holding mmu_lock for write obviates the need for RCU protection as the list
 * is guaranteed to be stable.
 */

