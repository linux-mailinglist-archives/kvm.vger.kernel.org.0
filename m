Return-Path: <kvm+bounces-8121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E16484BCBD
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F49B1C231EF
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954C211CAF;
	Tue,  6 Feb 2024 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FgvvNVaG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F3DF43
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707243047; cv=none; b=oWdYfspcclVzftH76lU2PqeRuzj7PRyA3e/SMGSJ7unCFehD2CYxUodd+1mqsEmMdmW7ccM73RRFCi3BRemuyZavYmcdVkbwTzDY42aS5AhVIOkwWMXfYsP+uYGb/ZBjg+TtBmxftKoYJQ+Ox8DZsLBSwrvgjnXvP1tfQoDUoHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707243047; c=relaxed/simple;
	bh=+K4hkLAVOGFO0w9WP+eWJkb0HlQJo+4K5nbl+fFFDd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T4+7lolLD/9JnmvF+G95ZYgvCCh68Uau1rZrU0+l3k0RTEy+05KGc2J96nEQ1NtsFsduiL43TupwNjhEoc9f11/lnr6kHcfmuQPBFjmGMkSYh0W3Adzxyf3pw09RJKZzlgSFlqn6Lufu7jb0Hm0SG+6bV49CSNadq27vz7JzK+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FgvvNVaG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2966a804063so1521932a91.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707243045; x=1707847845; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l5PpeFFqdP626r1RWYoCpd0vGeqNqbDwh/mrIllBBs0=;
        b=FgvvNVaGjmIXER1pWm0mJz7IZdvsjRiBc9IijX8SzzB5iXmJxhRuVTtQ96w0lkrBBN
         rkt4C9H9+nYzsWpbuSOIEhuwRW1egFwyWTwx/+MyddsDqR5OKHKqweN3ryWaGxx2elBZ
         RW00EZFQdTIkOwQRmCJRxdQEGO21sqaTsoi25wHt71o5XtkCBQnC3p1qPk0GJHcItP0S
         YCkV7VVOh5QTexBKz/x2rXYpd9+/POp/bT2eeNWhaE61+znQCAkwVLmH1px/OVeJ7doP
         9Fj4XLU5tyMuWNQnwWT1jbkdrA69rwoiqMYiEV4pFTto1Xe/+H660r1V0GHf/MTaBH+Q
         1PdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707243045; x=1707847845;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l5PpeFFqdP626r1RWYoCpd0vGeqNqbDwh/mrIllBBs0=;
        b=ErgiRmNpQuk1vT6NkXGROFPR3VYkEvLGpuLU1IPI0DBS8D8sIEHawWfpSYM8tuvKFM
         ssc/NwmWeOo28mZRML4YdN0bEzlLJH7vHNXP4tPyjos+httBWXBd1u3rG0hm01pRmE/9
         y543ykZJ36BuLha/UzTOIRoNE8vlP9OlZGZTcx3aUGbr48GL8Hf3JqY7AknmFW6y3G7s
         mFfgASbDsQyAh7Sn4MV0e+g7voNpSa8et/s0Q4v8AEwNCRO33C46JpHj12U5dnOxMzXv
         Pa+1PXrJbsz6dz+E7h8CkqUamGR/iZjKlW0cm7iBz0jTEzdRadayG+y6x+Knsx3NPJFV
         WNOQ==
X-Gm-Message-State: AOJu0Yw7pBVuDDaSoLxuhHCnZrLh7ucmJLl+Pj35czIIhglK3+W1MYMK
	KXvMuePhMok6MPE6HLDDiCkt1r3UCqmzqSAtpM53FynNhFPpw4OZBlpuOxunovUs4cZu0tHTLWx
	5fA==
X-Google-Smtp-Source: AGHT+IHv/cfRhAxqlasS5Lb0Ej71aI4uOvnC4FgqsJn62AiiXiLOJkXlvzZYOYZ1hv3zAcbaNW4EBX3qdYM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4e8d:b0:295:c117:d9e9 with SMTP id
 sr13-20020a17090b4e8d00b00295c117d9e9mr597pjb.4.1707243045534; Tue, 06 Feb
 2024 10:10:45 -0800 (PST)
Date: Tue, 6 Feb 2024 10:10:44 -0800
In-Reply-To: <ZcJSmNRLbKacPfoq@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com> <20240111020048.844847-8-seanjc@google.com>
 <ZcJSmNRLbKacPfoq@yilunxu-OptiPlex-7050>
Message-ID: <ZcJ2JG54O0g07e-P@google.com>
Subject: Re: [PATCH 7/8] KVM: x86/mmu: Alloc TDP MMU roots while holding
 mmu_lock for read
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Xu Yilun wrote:
> On Wed, Jan 10, 2024 at 06:00:47PM -0800, Sean Christopherson wrote:
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 55 +++++++++++++++-----------------------
> >  1 file changed, 22 insertions(+), 33 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 9a8250a14fc1..d078157e62aa 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -223,51 +223,42 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
> >  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
> >  }
> >  
> > -static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
> > -{
> > -	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> > -	int as_id = kvm_mmu_role_as_id(role);
> > -	struct kvm *kvm = vcpu->kvm;
> > -	struct kvm_mmu_page *root;
> > -
> > -	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> > -		if (root->role.word == role.word)
> > -			return root;
> > -	}
> > -
> > -	return NULL;
> > -}
> > -
> >  int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> >  	union kvm_mmu_page_role role = mmu->root_role;
> > +	int as_id = kvm_mmu_role_as_id(role);
> >  	struct kvm *kvm = vcpu->kvm;
> >  	struct kvm_mmu_page *root;
> >  
> >  	/*
> > -	 * Check for an existing root while holding mmu_lock for read to avoid
> > +	 * Check for an existing root before acquiring the pages lock to avoid
> >  	 * unnecessary serialization if multiple vCPUs are loading a new root.
> >  	 * E.g. when bringing up secondary vCPUs, KVM will already have created
> >  	 * a valid root on behalf of the primary vCPU.
> >  	 */
> >  	read_lock(&kvm->mmu_lock);
> > -	root = kvm_tdp_mmu_try_get_root(vcpu);
> > -	read_unlock(&kvm->mmu_lock);
> >  
> > -	if (root)
> > -		goto out;
> > +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> > +		if (root->role.word == role.word)
> > +			goto out_read_unlock;
> > +	}
> >  
> > -	write_lock(&kvm->mmu_lock);
> 
> It seems really complex to me...
> 
> I failed to understand why the following KVM_BUG_ON() could be avoided
> without the mmu_lock for write. I thought a valid root could be added
> during zapping.
> 
>   void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>   {
> 	struct kvm_mmu_page *root;
> 
> 	read_lock(&kvm->mmu_lock);
> 
> 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
> 		if (!root->tdp_mmu_scheduled_root_to_zap)
> 			continue;
> 
> 		root->tdp_mmu_scheduled_root_to_zap = false;
> 		KVM_BUG_ON(!root->role.invalid, kvm);

tdp_mmu_scheduled_root_to_zap is set only when mmu_lock is held for write, i.e.
it's mutually exclusive with allocating a new root.

And tdp_mmu_scheduled_root_to_zap is cleared if and only if kvm_tdp_mmu_zap_invalidated_roots
is already set, and is only processed by kvm_tdp_mmu_zap_invalidated_roots(),
which runs under slots_lock (a mutex).

So a new, valid root can be added, but it won't have tdp_mmu_scheduled_root_to_zap
set, at least not until the current "fast zap" completes and a new one beings,
which as above requires taking mmu_lock for write.

