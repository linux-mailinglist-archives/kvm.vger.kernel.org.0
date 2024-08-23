Return-Path: <kvm+bounces-24861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D0A95C287
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 02:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 448921F21A3B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 00:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE29D51A;
	Fri, 23 Aug 2024 00:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CC+yJAOi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B4418E28
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 00:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724373557; cv=none; b=cxd9yaspgyfjzdpkta3M1oIiN8/YgySMIWt4RhCdjq36x2eZyTmHEU9lh1hrdHr0lQW22Vm78Qyfp4HuuQP6rmpaVBw8jui/7jAo+k/0I7UG9428eJJ5bR10ZN5bjbbwDcIg1CWIWdNbo0ER6u1vLeB+BIKPwVm5mTDMLl8D4Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724373557; c=relaxed/simple;
	bh=VV9shzB6btQ9Uug5Gos9cV/pH26R4tbhtMoVPZ6WA5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sl6FNPGzKv9Q9Pj5cQ/8+UAIElpwWC4ijbnwaBtTXkhvKJbgcrzk+XCXIDFpbYzq0wVrmk0z9PzElP51dwUA4g2kZ39lOjXEznHoTs5MbRlw/l68c8MBWxLinz7p9fJdJutPPRN/+T8uboosI92zG3w32OAhpFvdaf/n7XvXhPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CC+yJAOi; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b2822668c2so27654837b3.1
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 17:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724373555; x=1724978355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1rsSkGvgyxp0c4ulMorE6unuu52d8tR+jZ1RRdDXprI=;
        b=CC+yJAOi1NH44zzrcrA4P9Vbc6x7gB2xnUIZDxxy8+Rt2ts4/NYP3P44VEfJjJPrMb
         F77naPtRjKvrAHfnd8NA9JHtQOY7h3tM2uDOzwt8ZbL9i0QnroF3cXAqzSqezFTHUccB
         9hFyz63icQ2qltsG0m/WL55ibE8oYXzmwFttKzrqrWh9otV7oI+E+A5PAxNi27DMduXg
         6kcCrw+MFNHfzDIDwY4ecIkTWN2nLHSGeChMSIZ0cRbOMoK89OxXN0TuPyjxscO8fdyS
         A1H+vfPfCZ3tN9LpMbbIqVR5E2F0+pSTzO8hMpsHfUVce9vq5pmIfQR5mT8FTlCcohL7
         XcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724373555; x=1724978355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1rsSkGvgyxp0c4ulMorE6unuu52d8tR+jZ1RRdDXprI=;
        b=KB5JQBekwZ8fkW9slB7bceay8WgOAInopalf8c6Ofc7Cmx1yw98lQ+lt+Ddlg8Pas5
         z1/WFg5EAppxd7y/bc/kk8e2H3I/Ps2dWSTY3QfoMAi95uS6w69GKpXxjJ8WpPvqAhNA
         73UgrG11CCXwRAhFMgMh6W3ql/+MLd416gm815HztmU03SseifPGrVaV5cxGmh/9n/a0
         DQkHLO5M3Tp1xx3Qy8q+8P1+HuVmdYAGXVXMVmcTbX5EWiRINLJfQMc6107V9vS5vu6F
         TrmjJbjfLBDQN2Gp+tr4IbSrkOgopNjebcIwruD6jT1+nIr9iCNCf7d9zSH8heVz0MoH
         JscA==
X-Forwarded-Encrypted: i=1; AJvYcCXb6g3vnUwMAInOajMf3gwOpAeQXdfQmOI8unZDDQyPJwGIf135rgNrz1WArgXbC5ZXn44=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz46neqdymU4r/CV35pWQ6gruMsBF47E1rRcJ8/iMrj1eWNzrUb
	jPd4MFIDXr5m4EevQq32+h8YTmKSl25BCxbphaTlS10wjUW5uOxrlk+xOKXUtWJ1HPjh82TDboy
	y/A==
X-Google-Smtp-Source: AGHT+IG8P9KF8lAnU3i6hSPoPo+DYcbErohVdHM4WYvKFm5HirDV9T7msZ7enruQOaPDVqAhBm83mYPe9UM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:fe09:0:b0:690:d536:27e1 with SMTP id
 00721157ae682-6c6249de630mr15017b3.2.1724373555043; Thu, 22 Aug 2024 17:39:15
 -0700 (PDT)
Date: Thu, 22 Aug 2024 17:39:13 -0700
In-Reply-To: <6fsgci4fceoin7fp3ejeulbaybaitx3yo3nylzecanoba5gvhd@3ubrvlykgonn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-5-seanjc@google.com>
 <20240814142256.7neuthobi7k2ilr6@yy-desk-7060> <6fsgci4fceoin7fp3ejeulbaybaitx3yo3nylzecanoba5gvhd@3ubrvlykgonn>
Message-ID: <ZsfaMes4Atc3-O7h@google.com>
Subject: Re: [PATCH 04/22] KVM: x86/mmu: Skip emulation on page fault iff 1+
 SPs were unprotected
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan0329os@gmail.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

+Tom

On Fri, Aug 16, 2024, Yao Yuan wrote:
> On Wed, Aug 14, 2024 at 10:22:56PM GMT, Yuan Yao wrote:
> > On Fri, Aug 09, 2024 at 12:03:01PM -0700, Sean Christopherson wrote:
> > > When doing "fast unprotection" of nested TDP page tables, skip emulation
> > > if and only if at least one gfn was unprotected, i.e. continue with
> > > emulation if simply resuming is likely to hit the same fault and risk
> > > putting the vCPU into an infinite loop.
> > >
> > > Note, it's entirely possible to get a false negative, e.g. if a different
> > > vCPU faults on the same gfn and unprotects the gfn first, but that's a
> > > relatively rare edge case, and emulating is still functionally ok, i.e.
> > > the risk of putting the vCPU isn't an infinite loop isn't justified.
> > >
> > > Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++++--------
> > >  1 file changed, 20 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e3aa04c498ea..95058ac4b78c 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -5967,17 +5967,29 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > >  	bool direct = vcpu->arch.mmu->root_role.direct;
> > >
> > >  	/*
> > > -	 * Before emulating the instruction, check if the error code
> > > -	 * was due to a RO violation while translating the guest page.
> > > -	 * This can occur when using nested virtualization with nested
> > > -	 * paging in both guests. If true, we simply unprotect the page
> > > -	 * and resume the guest.
> > > +	 * Before emulating the instruction, check to see if the access may be
> > > +	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
> > > +	 * gfn being written is for gPTEs that KVM is shadowing and has write-
> > > +	 * protected.  Because AMD CPUs walk nested page table using a write
> 
> Hi Sean,
> 
> I Just want to consult how often of this on EPT:
> 
> The PFERR_GUEST_PAGE_MASK is set when EPT violation happens
> in middle of walking the guest CR3 page table, and the guest
> CR3 page table page is write-protected on EPT01, are these
> guest CR3 page table pages also are EPT12 page table pages
> often?  I just think most of time they should be data page
> on guest CR3 table for L1 to access them by L1 GVA, if so
> the PFERR_GUEST_FINAL_MASK should be set but not
> PFERR_GUEST_PAGE_MASK.

Hmm, now I'm confused too.  I thought this was handling the case where L1 is
accessing EPT12/NTP12 entries, but as you say, that doesn't make sense because
those accesses would be PFERR_GUEST_FINAL_MASK.  And the EPT12/NPT12 entries
should never be used by hardware.

The only thing that I can think of is if L1 stops using the pages for EPT/NPT
entries, and instead reallocates them for IA32 page tables.  But that doesn't
make much sense either, because KVM's write-flooding detection should kick in
when L1 repurposes the page for its own page tables, before L1 actually starts
using the page tables.

I'll try to reproduce the excessive emulation that this code is handling, because
I think I'm missing something too.

