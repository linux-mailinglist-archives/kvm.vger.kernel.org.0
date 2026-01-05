Return-Path: <kvm+bounces-67063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6ACCF5020
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 18:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BEBCF3019E01
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 17:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D033533E36A;
	Mon,  5 Jan 2026 17:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uGfxZdmX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F3233D4FC
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 17:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767634269; cv=none; b=PIBWK9gsQJGjZJmFHP6GupqmZZTjU50UFCg1uPBOs3tCSuUCg9Ydf5sPhk9e7YLgJoI10//OopEds1y/46kcEqIWlB/m3521vMPCfpDY+m0DVHn5P1Bq4yhpN6f7TBqo6QAB+DpJBqAZ9zx6wOpDZLcFL2oDP6uvvUwXT6N+Gos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767634269; c=relaxed/simple;
	bh=CxZ4OgJGj/k3K59SPvzFQSboJQlhCSm/PlRd8ioDSvI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jJJSLGjdS3uzTz7Wb6d+lWmdpuT5JkVNuuQWJ6oPOHfHP2V5hzHK6oXJ6wYQVZnF22VHYbhGsIXNTg2Y2T7r7Rkmi6sxZHbjyiOzFZYjQmeTrH1Vus9c5PkghWk8BJxjHM4F8HqXBjlijDcNjaXTaud4c1iNfGu4P/lIWnCMdZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uGfxZdmX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso583689a91.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 09:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767634267; x=1768239067; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8kSIPJzul/X8QFqPR13PL+AQ9eUnhoQcnkip5GRavHI=;
        b=uGfxZdmX5TkKJXc+bdE8nuacRkRqvHrMEdWKdHhK0TaF2Jg/N8WbSzDB4qJjzP5SpG
         yzI4bGE7H4Ara68Z7h7SO5xjFPYLnksdO1k7Qwu0EB8m/laUCCvqhfwzqE5KH0ZGUp/C
         wWFDjmBs6r/+3WKOTByUl9XPyOMiJ2TkPZckDPEnqujzEp9Rtve8rJRgmBdRShlF09Ee
         iOn1nTtgZk6EKaoc/eKCc4n2eOO6IMknbsse7Gl7WoYtGVwQLAMWee0sjX6MQiMfn9yj
         ySyJQJ8k0B5HWdmsvLIsXVsjkprPYlsZabB9qfEfSGtxnahseilxbqeYZOKRj9xm8OJr
         i/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767634267; x=1768239067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8kSIPJzul/X8QFqPR13PL+AQ9eUnhoQcnkip5GRavHI=;
        b=CB4q1GBzgCmpdam/XSxayk/+wkzohaalj1Mqrsbql9H9TpGaZPFdxK9JOPbQ3oLe3/
         5wB9KwumUGa7m8js5vgTW2b9RaGJa6Ky5xZSWOWulW6WhfKiZVudbjHnfTeNmbcyWS0i
         GJH5Og5cDoDABiqVSUqjjybCKexh7osyzMyHMi2H2wmAgZIuyTCYwiF2KAZL1k1/Uum9
         6AJqNTYg2+bBMG4j/gSUbenoSRhV+NMrtgJW/XDUT3ddrg7wxsJk8jfP8TkIAzAVka+n
         KlYowsBIzPUSN82b33VUzFGURTgFXW8v41UxHguY7lpav78sa931vibvfUBkt9VEUYIb
         JCfg==
X-Forwarded-Encrypted: i=1; AJvYcCVLDxexKDQUPyoWsgE4uW81E37HlaWJ2TJ/2Oe+VPQNWkqqwBgkkfv/kOB1N6JwJrXfjX8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/wB8mnNY4tLms8S0aIdvO9mRkiFYbLTu3DopvrkkVmKpZvcBS
	vx0aU1Uvx/bJLUDaS9jsieOO/SnHJ4lRF6J7dsSo0XG9OoGdA4+ch7pajbioStKwCENbratRYCc
	JIpOtbQ==
X-Google-Smtp-Source: AGHT+IFNFCW51z5uQhSMaKAD/3SNzpI333xLiv4+CS5A7/6N6OYcuHjrQA1qzr3I/rduC2hfHA1d6uzkn6Q=
X-Received: from pjok2.prod.google.com ([2002:a17:90a:9102:b0:34a:bcb2:43ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c46:b0:340:5c27:a096
 with SMTP id 98e67ed59e1d1-34f5f273bebmr106658a91.6.1767634266701; Mon, 05
 Jan 2026 09:31:06 -0800 (PST)
Date: Mon, 5 Jan 2026 09:31:05 -0800
In-Reply-To: <aig6cfdj7vxmm5yt6lvfsyqwlnavrcl2n4z3gzomqydce5suxm@ydomfhhmwd7y>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-2-pbonzini@redhat.com>
 <aig6cfdj7vxmm5yt6lvfsyqwlnavrcl2n4z3gzomqydce5suxm@ydomfhhmwd7y>
Message-ID: <aVv1WTR9Zsx2FpZ0@google.com>
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan0329os@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 03, 2026, Yao Yuan wrote:
> On Thu, Jan 01, 2026 at 10:05:13AM +0100, Paolo Bonzini wrote:
> > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > index da233f20ae6f..166c380b0161 100644
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -319,10 +319,29 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
> >  #ifdef CONFIG_X86_64
> >  void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
> >  {
> > +	struct fpstate *fpstate = guest_fpu->fpstate;
> > +
> >  	fpregs_lock();
> > -	guest_fpu->fpstate->xfd = xfd;
> > -	if (guest_fpu->fpstate->in_use)
> > -		xfd_update_state(guest_fpu->fpstate);
> > +
> > +	/*
> > +	 * KVM's guest ABI is that setting XFD[i]=1 *can* immediately revert
> > +	 * the save state to initialized.  Likewise, KVM_GET_XSAVE does the
> > +	 * same as XSAVE and returns XSTATE_BV[i]=0 whenever XFD[i]=1.
> > +	 *
> > +	 * If the guest's FPU state is in hardware, just update XFD: the XSAVE
> > +	 * in fpu_swap_kvm_fpstate will clear XSTATE_BV[i] whenever XFD[i]=1.
> > +	 *
> > +	 * If however the guest's FPU state is NOT resident in hardware, clear
> > +	 * disabled components in XSTATE_BV now, or a subsequent XRSTOR will
> > +	 * attempt to load disabled components and generate #NM _in the host_.
> > +	 */
> 
> Hi Sean and Paolo,
> 
> > +	if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
> > +		fpstate->regs.xsave.header.xfeatures &= ~xfd;
> > +
> > +	fpstate->xfd = xfd;
> > +	if (fpstate->in_use)
> > +		xfd_update_state(fpstate);
> 
> I see a *small* window that the Host IRQ can happen just after above
> TIF_NEED_FPU_LOAD checking, which could set TIF_NEED_FPU_LOAD

Only if the code using FPU from IRQ context is buggy.  More below.

> but w/o clear the xfd from fpstate->regs.xsave.header.xfeatures.
> 
> But there's WARN in in kernel_fpu_begin_mask():
> 
> 	WARN_ON_FPU(!irq_fpu_usable());
> 
> irq_fpu_usable()
> {
> 	...
> 	/*
> 	 * In hard interrupt context it's safe when soft interrupts
> 	 * are enabled, which means the interrupt did not hit in
> 	 * a fpregs_lock()'ed critical region.
> 	 */
> 	return !softirq_count();
> }
> 
> Looks we are relying on this to catch the above *small* window
> yet, we're in fpregs_lock() region yet.

Kernel use of FPU from (soft) IRQ context is required to check irq_fpu_usable()
(e.g. via may_use_simd()), i.e. calling fpregs_lock() protects against the kernel
using the FPU and thus setting TIF_NEED_FPU_LOAD.

The WARN in kernel_fpu_begin_mask() is purely a sanity check to help detect and
debug buggy users.

