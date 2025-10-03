Return-Path: <kvm+bounces-59468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A00BB79CE
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 18:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8966B4EE20A
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 16:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73ED72D4B6D;
	Fri,  3 Oct 2025 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JlLqXfzA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DAD2D29CE
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759510412; cv=none; b=Zwx3PpeibSPq9UImIkGgUhyCPmebN9n+GvTHJudo6lXMOeRPGGJDgS/T+xBV7LnqjSdTpJlpocETQsBLg9UoLYmw/lysh+IMUU1l1S/qXQRmUUMWuH2dzwpGT2xzum+fF+oiMO6LRJGFPLnS8A4R7d7XYDai0YFt2eH0QCkyTSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759510412; c=relaxed/simple;
	bh=O6iTRtCHWa1pvTeaZbaPlBhhtaQYociVnx8+jdF7glw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jFru3dnRQQj/5aT20bpGX1jQs2/VKn0C/fNbADDQpfI+lWNLLEj2i5XxA0grHwpkPsMI7xT76FCsy+Q2UNLL4uciKHJperndu6CZVuIW5Vd9zYm55dOB3W5AiAQ0++nSde6sdeelPwA53VUUf3KI9/sD2vp8px2XU+ucl6atJWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JlLqXfzA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28e8d1d9b13so26627825ad.0
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 09:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759510410; x=1760115210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=POxElydVI0BOx7r8DQaDF+v2DBnqT3dmlQuZlhTe5JY=;
        b=JlLqXfzARNP3rWtRBYXZoeQVSgcJTmUP2IdCmaIBCS7FTmY+duyDYs4vHTGPMouX7A
         W04VPMRg/5jE1hpB3cEzUQHQcYDMYKJiSvhChgN5mD2jJnKOC//wOWmc9qVUOKUJclpw
         lz1zUgL2BgyClerauQO3XTJdrhR4DNlZf9BGMydU6CpZhBpXsTt/M1yzgrbIpAU6EqUv
         FNxT8SRmmk/Ul7jL6bQZpjYllmBeNZgGHSjHKqgSQO7/UNst6Qo/1+bFbYlLGjZrlu3H
         lyZ2iqrMk/AYkChMOtIjG9AlreijdgZcCNF9pwZMMN5VZtcXJBun1lN2d23T68HmdroI
         pBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759510410; x=1760115210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=POxElydVI0BOx7r8DQaDF+v2DBnqT3dmlQuZlhTe5JY=;
        b=GrTLZY1Pth8CIQ7FzfQDWPh9Ltov94QafDuAvCby4mVFWn+7HXvVjbe3zeG8CHF+Bv
         t023YQQc5Gads71gAKR0mo3V4LSugGXoG/cdKQes7pNUSy6ntY9opyukngM2jUJoW62+
         VtxJbWFk8+dNIjuzai8+vATCrdk4yq85qw8E65LzXPc8IZ+4J89sLsTFfJihOhOInfh9
         YnKCT5i304kEaM7yPSqOVOm9uqET99g/x0jxiqU4tiS6t9qn4ZSH2xor4NV1iJhWYLAH
         HUgg3LduUjqJi1D4muW+Ukkh/MicwAORv/xmfp/XqSCKZ7xbYDHIO1uOZzHHVWet0AlW
         eokg==
X-Forwarded-Encrypted: i=1; AJvYcCX+SwGEA5bgyJmxNNi7eNg5hsBSQNcoza/a7sNlrZvuvz+4nSV5mIgVNJSErDFXzq1HXbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGleKundxtnq3k4TvtZ6KR6OwKAN1tnx7hlTeVQOqfsQnRfCYo
	y32iTDJhVd0/GA2F77nrKqzFxh7FzvhhPOKsXmrNKHGmfnbFTaybThWoQ3LNoXS3VD1eoquJz9u
	X4IsFMQ==
X-Google-Smtp-Source: AGHT+IGJmYTs5YOjCOYNdr7vzDkZcbFbNXzxJPl12PvUCdaYwJfPVY9C6I0Va+eERizS2P2TzJ5KMzCvIF8=
X-Received: from pgag24.prod.google.com ([2002:a05:6a02:2f18:b0:b56:3de0:d767])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:298d:b0:264:70e9:dcb8
 with SMTP id d9443c01a7336-28e9a6fd918mr42863915ad.55.1759510410399; Fri, 03
 Oct 2025 09:53:30 -0700 (PDT)
Date: Fri, 3 Oct 2025 09:53:28 -0700
In-Reply-To: <aN/VaVklfXO5rId4@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214259.1584273-1-seanjc@google.com> <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com> <aNwFTLM3yt6AGAzd@google.com> <aN/VaVklfXO5rId4@yzhao56-desk.sh.intel.com>
Message-ID: <aN__iPxo5P1bFCNk@google.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 03, 2025, Yan Zhao wrote:
> Sorry for the slow response due to the PRC holiday.
> 
> On Tue, Sep 30, 2025 at 09:29:00AM -0700, Sean Christopherson wrote:
> > On Tue, Sep 30, 2025, Yan Zhao wrote:
> > > On Tue, Sep 30, 2025 at 08:22:41PM +0800, Yan Zhao wrote:
> > > > On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> > > > > Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> > > > > and use the helper kvm_set_user_return_msr() to make it obvious that the
> > > > > double-underscores version is doing a subset of the work of the "full"
> > > > > setter.
> > > > > 
> > > > > While the function does indeed update a cache, the nomenclature becomes
> > > > > slightly misleading when adding a getter[1], as the current value isn't
> > > > > _just_ the cached value, it's also the value that's currently loaded in
> > > > > hardware.
> > > > Nit:
> > > > 
> > > > For TDX, "it's also the value that's currently loaded in hardware" is not true.
> > > since tdx module invokes wrmsr()s before each exit to VMM, while KVM only
> > > invokes __kvm_set_user_return_msr() in tdx_vcpu_put().
> > 
> > No?  kvm_user_return_msr_update_cache() is passed the value that's currently
> > loaded in hardware, by way of the TDX-Module zeroing some MSRs on TD-Exit.
> > 
> > Ah, I suspect you're calling out that the cache can be stale.  Maybe this?
> Right. But not just that the cache can be stale. My previous reply was quite
> misleading.
> 
> As with below tables, where
> CURR: msrs->values[slot].curr.
> REAL: value that's currently loaded in hardware
> 
> For TDs,
>                             CURR          REAL
>    -----------------------------------------------------------------------
> 1. enable virtualization    host value    host value
> 
> 2. TDH.VP.ENTER             host value    guest value (updated by tdx module)
> 3. TDH.VP.ENTER return      host value    defval (updated by tdx module)
> 4. tdx_vcpu_put             defval        defval
> 5. exit to user mode        host value    host value
> 
> 
> For normal VMs,
>                             CURR                 REAL
>    -----------------------------------------------------------------------
> 1. enable virtualization    host value           host value
> 2. before vcpu_run          shadow guest value   shadow guest value
> 3. after vcpu_run           shadow guest value   shadow guest value
> 4. exit to user mode        host value           host value
> 
> 
> Unlike normal VMs, where msrs->values[slot].curr always matches the the value
> that's currently loaded in hardware. 

That isn't actually true, see the bottom.

> For TDs, msrs->values[slot].curr does not contain the value that's currently
> loaded in hardware in stages 2-3.
> 
> >   While the function does indeed update a cache, the nomenclature becomes
> >   slightly misleading when adding a getter[1], as the current value isn't
> >   _just_ the cached value, it's also the value that's currently loaded in
> >   hardware (ignoring that the cache holds stale data until the vCPU is put,
> So, "stale data" is not accurate.
> It just can't hold the current hardware loaded value when guest is running in
> TD.

Eh, that's still "stale data" as far as KVM is concerned.  Though I'm splitting
hairs, I totally agree that as written the changelog is misleading.

> it's also the value that's currently loaded in hardware.

I just need to append "when KVM is actively running" (or probably something more
verbose).

> >   i.e. until KVM prepares to switch back to the host).
> > 
> > Actually, that's a bug waiting to happen when the getter comes along.  Rather
> > than document the potential pitfall, what about adding a prep patch to mimize
> > the window?  Then _this_ patch shouldn't need the caveat about the cache being
> > stale.
> With below patch,
> 
> For TDs,
>                             CURR          REAL
>    -----------------------------------------------------------------------
> 1. enable virtualization    host value    host value
> 2. before TDH.VP.ENTER      defval        host value or defval
> 3. TDH.VP.ENTER             defval        guest value (updated by tdx module)
> 4. TDH.VP.ENTER return      defval        defval (updated by tdx module)
> 5. exit to user mode        host value    host value
> 
> msrs->values[slot].curr is still not the current value loaded in hardware.

Right, this where it becomes stale from my perspective.

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index ff41d3d00380..326fa81cb35f 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -789,6 +789,14 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> >                 vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> >  
> >         vt->guest_state_loaded = true;
> > +
> > +       /*
> > +        * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
> Hmm, my previous mail didn't mention that besides saving guest value + clobber
> hardware value before exit to VMM, the TDX module also loads saved guest value
> to hardware on TDH.VP.ENTER.

That's not actually unique to TDX.  EFER is setup as a user return MSR, but is
context switched on VM-Enter/VM-Exit except when running on ancient hardware
without VM_{ENTRY,EXIT}_LOAD_IA32_EFER (and even then, only when KVM doesn't
need to atomically switch to avoid toggling EFER.NX while in the host).

I.e. msrs->values[<EFER slot>].curr won't match hardware either while running
the guest.  But because EFER is atomically loaded on VM-Exit in those cases, the
curr value can't be stale while KVM is running.

