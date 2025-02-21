Return-Path: <kvm+bounces-38820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C50F3A3E9A7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B7FC189ECF8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F75381A3;
	Fri, 21 Feb 2025 01:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Np/yl9h5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCC3EEC8
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740100131; cv=none; b=lrQTAxviS+uQdmUICNvjd2X0s6xVT84J2K1FOpKud2OJLQJTxAH+3GoD8q0VSueghzlUpTUYrEwpNbYw8sYRgNhtNaIS5U9jQKAto9bjjNY1/yQCsADVXLE4x9YrzcHPWmNSD5X6PPrqSD8C/zezxmB/ryhIVvJQANhpWrL5uKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740100131; c=relaxed/simple;
	bh=3fHapjZeNh1VjYeXTfp2z5nti+mCkYcx8zwxVW4YXrE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sHNEwC8hn7hmvwghDswH/kA/QAzWfs/NpDcfezhawK3qFNG1xbqjlShfOsAZ2Ax7+sI+rn5y3+8Yl1mpn/p49ToIDaaIYdjzUo6oNjysqeIAmu2/HZwaG2f13EoWBZ9ouwvJLk9w2t3zt7Yyh+JU8VUFz3RIWcqcW5iQjztwsGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Np/yl9h5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc17c3eeb5so3515755a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740100129; x=1740704929; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FQFtq5zh8p2czyGe6VdUykaj2fCcZy9a/aoX6y/tI5o=;
        b=Np/yl9h5Yd6gWoxEpEaPokQRUS3jucWrtyPrv2c8KZLPLGxoFZyEOiIrGetC+z/a82
         8fgbhW22fTtFVWLox2XlRGqddOf52BULDb9oKsC7FJl0cjl27cGfTeaViiYDBTKGVr8/
         8parOVaU1lPROa1PtZxx5uZza/dJBgqZoXb6Ab54Fh2UlLeBgnvp8aKHW7tx2intX5+F
         SJNZ8a1cnHg9ZLKZyfvIzLBFHXOmcRPzv43zxyI8AncylB2A8eCRLxM72HOnwZWwTzCq
         kHaF8JJLJrRCFP7UepaJcL/T3D6rdtefm7AOlas2e2RjphAwOBbeUAlXArmFfxjQZwaP
         GZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740100129; x=1740704929;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQFtq5zh8p2czyGe6VdUykaj2fCcZy9a/aoX6y/tI5o=;
        b=mJohZLT22+JDAwABKdmo8CRQe0/FAlRQ9J/pna9O3GxNc8K6DzAf7ZUFtBIQwniESK
         MTpxLoqyDD0kyAFVg4MV6sADu2YLjLRGqRGUba/f2/gi2gwknOnpwBPJ9bjFJSB8BoAc
         6wOwAYPYBoaN+moQm6oLSNZsBLukLNOTyYLkfQl4ksIv/PT1XSafUV6QgwgBeUPE8JpD
         LDHzR9BIrgilTCf+b3/QXLulAz8lxvnuwyO8E+Z21BZt6kUZS33ca9Fv+WhzddlD6C8v
         G5kLbNpqvFDb8yw3QadGKrbQyaIISmWcNnNl4WGJG4aJmdsnazxV/9OMRusuCvYdDnFV
         GVdQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1DyFNVsyF8teMOU+/8RZfhSE85mZ8MaskDkA9jfJqPjr/fZN4KaSOT4dcDKu+aQDCZo8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/ElRDkZ3BoUxBohmqZHsPo6DgSG8J+dfHWZjbbaD4ODZinFp5
	3Sl+QBMkbap+7cy5InneLzVv6+j8SvC0OgPtVWUf8U6MyIokXw43W//XHDMazYBHrG9LJoznD3E
	few==
X-Google-Smtp-Source: AGHT+IGvGA5L3s3OecPlM4JUTxJyjvxBe691JnF9OIkyTKNxVRjzLqxhj39XqoXWXYt1NKhGI05T1/JGVwI=
X-Received: from pjbsy7.prod.google.com ([2002:a17:90b:2d07:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c10:b0:2ee:b4bf:2d06
 with SMTP id 98e67ed59e1d1-2fce86d0e70mr1396072a91.19.1740100129598; Thu, 20
 Feb 2025 17:08:49 -0800 (PST)
Date: Thu, 20 Feb 2025 17:08:48 -0800
In-Reply-To: <Z7fO9gqzgaETeMYB@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250220170604.2279312-1-pbonzini@redhat.com> <20250220170604.2279312-21-pbonzini@redhat.com>
 <Z7fO9gqzgaETeMYB@google.com>
Message-ID: <Z7fSIMABm4jp5ADA@google.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Tony Lindgren <tony.lindgren@linux.intel.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 20, 2025, Sean Christopherson wrote:
> TL;DR: Please don't merge this patch to kvm/next or kvm/queue.
> 
> On Thu, Feb 20, 2025, Paolo Bonzini wrote:
> > @@ -72,8 +94,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.has_emulated_msr = vmx_has_emulated_msr,
> >  
> >  	.vm_size = sizeof(struct kvm_vmx),
> > -	.vm_init = vmx_vm_init,
> > -	.vm_destroy = vmx_vm_destroy,
> > +
> > +	.vm_init = vt_vm_init,
> > +	.vm_destroy = vt_vm_destroy,
> > +	.vm_free = vt_vm_free,
> >  
> >  	.vcpu_precreate = vmx_vcpu_precreate,
> >  	.vcpu_create = vmx_vcpu_create,
> 
> ...
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 374d89e6663f..e0b9b845df58 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12884,6 +12884,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >  	kvm_page_track_cleanup(kvm);
> >  	kvm_xen_destroy_vm(kvm);
> >  	kvm_hv_destroy_vm(kvm);
> > +	static_call_cond(kvm_x86_vm_free)(kvm);
> >  }
> 
> Sorry to throw a wrench in things, but I have a fix that I want to send for 6.14[1],
> i.e. before this code, and to land that fix I need/want to destroy vCPUs before
> calling kvm_x86_ops.vm_destroy().  *sigh*
> 
> The underlying issue is that both nVMX and nSVM suck and access all manner of VM-wide
> state when destroying a vCPU that is currently in nested guest mode, and I want
> to fix the most pressing issue of destroying vCPUs at a random time once and for
> all.  nVMX and nSVM also need to be cleaned up to not access so much darn state,
> but I'm worried that "fixing" the nested cases will only whack the biggest mole.

...

> And so my plan is to carved out a kvm_destroy_mmus() helper, which can then call
> the TDX hook to release/reclaim the HKID, which I assume needs to be done after
> KVM's general MMU destruction, but before vCPUs are freed.

...

> void kvm_arch_destroy_vm(struct kvm *kvm)
> {
> 	/*
> 	 * WARNING!  MMUs must be destroyed before vCPUs, and vCPUs must be
> 	 * destroyed before any VM state.  Most MMU state is VM-wide, but is
> 	 * tracked per-vCPU, and so must be unloaded/freed in its entirety
> 	 * before any one vCPU is destroyed.

Argh, after digging more, this isn't actually true.  The separate "unload MMUs"
code is leftover from when KVM rather stupidly tried to free all MMU pages when
freeing a vCPU.

Commit 7b53aa565084 ("KVM: Fix vcpu freeing for guest smp") "fixed" things by
unloading MMUs before destroying vCPUs, but the underlying problem was trying to
free _all_ MMU pages when destroying a single vCPU.  That eventually got fixed
for good (haven't checked when), but the separate MMU unloading never got cleaned
up.

So, scratch the mmu_destroy() idea.  But I still want/need to move vCPU destruction
before vm_destroy.

Now that kvm_arch_pre_destroy_vm() is a thing, one idea would be to add
kvm_x86_ops.pre_destroy_vm(), which would pair decently well with the existing
call to kvm_mmu_pre_destroy_vm().

