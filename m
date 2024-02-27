Return-Path: <kvm+bounces-10106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BA8869DDD
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88EC7B31D8A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223F113A877;
	Tue, 27 Feb 2024 17:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UDUpbCxg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B9135A69
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054857; cv=none; b=iyc7B44y/rdqP1cpP/+LuG0E4cPskOWJ3oLUmVilVLZAAxAU3uYf3/pAgkA2tEAwCAw4lTGcKp14y+zac/mn8uY5nZQvixKI34SJrtCDmsQuChnLQYJ/HOhdYPR4rKZNVm0AVev4E7Dt/JZIjHvLRBgMZymrhzV4qNnTlChtqvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054857; c=relaxed/simple;
	bh=/ca6YoNPZt4B8bn51bkMHorlkqWQB5HIT58nGbSQ0lc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uyli0jvEgdk5WyKKU7xPFE/CEJydghhPOOeEyTXbI2IOdCFvvjz1CgZddDkxy9pwpObS28e/IWGmNPbIQI2OWPg12o5KnDIZq5OGw5yCANhEjjilvz4R5ukVhTJvWD3LSXNjP50VZAbY5ciFFB6SHdW4pv/e3A5kg/tOg2nL+1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UDUpbCxg; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607e613a1baso75568767b3.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709054854; x=1709659654; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iaexche2xLr87sWaJZtNxgyiJKn9gpbfX02kZ4/7qhQ=;
        b=UDUpbCxg/U/47tUG3XCLWCKgZNMoafBjAl8riE4K0IIJJjDrA2D/ZqaUGidnl0/uKJ
         U19buUlkFzB80elqUReNnBdMq78krg2BrMFbNoMl0ffvUMmd2ze/qgGZjBZvp6ogkKHt
         ZW4Io1sYCYJgz36gyinhLNgzuLQhjeJ7Ff8/87dNNjdoxLA/V2APNexYszYKi2FFgoFm
         BfbI4+omcYsFjEj8rC4hXcNsxAeZkaV+T/72OCzYesDDn6264NobCRyPCe/PAl/wGtwu
         FcqpoLkcjM5VQvm7pLykFHn7W0dgWZJPzbfXOmfL+jDHxPl8Pt6yjr6UB7xGBNSdB+MN
         4JOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709054854; x=1709659654;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iaexche2xLr87sWaJZtNxgyiJKn9gpbfX02kZ4/7qhQ=;
        b=TqyJ9rm3JoZIyemOx6slyk+CsY/PmcS8wgZuTOj/w3BQKFdAM7E+a+/2Sjulzli1JY
         2bdFXlu9iC82kKU8U+S72Nfl6tQysUiM4ZTQLCtc8dQuClsEXi8XAgs689BknqAf80st
         GBUQJShPzQItvNRVn0aWv24G+4QUPHOcoE5sk08uzSnlWsRDTrIWf2blwHFfL6b4l0+2
         cPPDjTd3lnIau+4o6HqAtVcbEK/jVEjAxMJLZ2V/csU1f4DSPyB8GmRGiWxB/5jS2BrY
         YwH7PoddleUMS7Qd6dgX5cE1At1yoGqPCS+tlmoeLLrT5alqiH4gtxpOBrER5ghVeqhl
         PSRA==
X-Forwarded-Encrypted: i=1; AJvYcCUm/jEgxS4iGFuNJq13laDy1c/GGuIIEcDNHk0CObtMU623etpGuQfL2Dw948KqwkywEUya8GZM3hzV7q4lBRlVu7oq
X-Gm-Message-State: AOJu0Ywliz0usMK9fh7DVDlljcE32Um/Xt+CchuBKwqRwMNAfZZbCM69
	66FyqFATKxTrh67qT0loTZ5W5s5W2NZma088/s1s1aV/vKvCXm1lh1nQYG9Vw6oQR7/vEYYBKZD
	VRw==
X-Google-Smtp-Source: AGHT+IHcqVdYD6cZ1EYG7CJzl5uV/YjvPtEWlyClzb76Tu9bsPDe/m2Dp0Ity/CeKl/vZ2398MRc5Bh1l9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d54f:0:b0:609:3834:e0f4 with SMTP id
 x76-20020a0dd54f000000b006093834e0f4mr114963ywd.7.1709054854657; Tue, 27 Feb
 2024 09:27:34 -0800 (PST)
Date: Tue, 27 Feb 2024 09:27:33 -0800
In-Reply-To: <CABgObfaSGOt4AKRF5WEJt2fGMj_hLXd7J2x2etce2ymvT4HkpA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226143630.33643-1-jiangshanlai@gmail.com> <CABgObfaSGOt4AKRF5WEJt2fGMj_hLXd7J2x2etce2ymvT4HkpA@mail.gmail.com>
Message-ID: <Zd4bhQPwZDvyrF44@google.com>
Subject: Re: [RFC PATCH 00/73] KVM: x86/PVM: Introduce a new hypervisor
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel@vger.kernel.org, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, x86@kernel.org, 
	Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024, Paolo Bonzini wrote:
> On Mon, Feb 26, 2024 at 3:34=E2=80=AFPM Lai Jiangshan <jiangshanlai@gmail=
.com> wrote:
> > - Full control: In XENPV/Lguest, the host Linux (dom0) entry code is
> >   subordinate to the hypervisor/switcher, and the host Linux kernel
> >   loses control over the entry code. This can cause inconvenience if
> >   there is a need to update something when there is a bug in the
> >   switcher or hardware.  Integral entry gives the control back to the
> >   host kernel.
> >
> > - Zero overhead incurred: The integrated entry code doesn't cause any
> >   overhead in host Linux entry path, thanks to the discreet design with
> >   PVM code in the switcher, where the PVM path is bypassed on host even=
ts.
> >   While in XENPV/Lguest, host events must be handled by the
> >   hypervisor/switcher before being processed.
>=20
> Lguest... Now that's a name I haven't heard in a long time. :)  To be
> honest, it's a bit weird to see yet another PV hypervisor. I think
> what really killed Xen PV was the impossibility to protect from
> various speculation side channel attacks, and I would like to
> understand how PVM fares here.
>=20
> You obviously did a great job in implementing this within the KVM
> framework; the changes in arch/x86/ are impressively small. On the
> other hand this means it's also not really my call to decide whether
> this is suitable for merging upstream. The bulk of the changes are
> really in arch/x86/kernel/ and arch/x86/entry/, and those are well
> outside my maintenance area.

The bulk of changes in _this_ patchset are outside of arch/x86/kvm, but the=
re are
more changes on the horizon:

 : To mitigate the performance problem, we designed several optimizations
 : for the shadow MMU (not included in the patchset) and also planning to
 : build a shadow EPT in L0 for L2 PVM guests.

 : - Parallel Page fault for SPT and Paravirtualized MMU Optimization.

And even absent _new_ shadow paging functionality, merging PVM would effect=
ively
shatter any hopes of ever removing KVM's existing, complex shadow paging co=
de.

Specifically, unsync 4KiB PTE support in KVM provides almost no benefit for=
 nested
TDP.  So if we can ever drop support for legacy shadow paging, which is a b=
ig if,
but not completely impossible, then we could greatly simplify KVM's shadow =
MMU.

Which is a good segue into my main question: was there any one thing that w=
as
_the_ motivating factor for taking on the cost+complexity of shadow paging?=
  And
as alluded to be Paolo, taking on the downsides of reduced isolation?

It doesn't seem like avoiding L0 changes was the driving decision, since II=
UC
you have plans to make changes there as well.

 : To mitigate the performance problem, we designed several optimizations
 : for the shadow MMU (not included in the patchset) and also planning to
 : build a shadow EPT in L0 for L2 PVM guests.

Performance I can kinda sorta understand, but my gut feeling is that the pr=
oblems
with nested virtualization are solvable by adding nested paravirtualization=
 between
L0<=3D>L1, with likely lower overall cost+complexity than paravirtualizing =
L1<=3D>L2.

The bulk of the pain with nested hardware virtualization lies in having to =
emulate
VMX/SVM, and shadow L1's TDP page tables.  Hyper-V's eVMCS takes some of th=
e sting
off nVMX in particular, but eVMCS is still hobbled by its desire to be almo=
st
drop-in compatible with VMX.

If we're willing to define a fully PV interface between L0 and L1 hyperviso=
rs, I
suspect we provide performance far, far better than nVMX/nSVM.  E.g. if L0 =
provides
a hypercall to map an L2=3D>L1 GPA, then L0 doesn't need to shadow L1 TDP, =
and L1
doesn't even need to maintain hardware-defined page tables, it can use what=
ever
software-defined data structure best fits it needs.

And if we limit support to 64-bit L2 kernels and drop support for unnecessa=
ry cruft,
the L1<=3D>L2 entry/exit paths could be drastically simplified and streamli=
ned.  And
it should be very doable to concoct an ABI between L0 and L2 that allows L0=
 to
directly emulate "hot" instructions from L2, e.g. CPUID, common MSRs, etc. =
 I/O
would likely be solvable too, e.g. maybe with a mediated device type soluti=
on that
allows L0 to handle the data path for L2?

The one thing that I don't see line of sight to supporting is taking L0 out=
 of the
TCB, i.e. running L2 VMs inside TDX/SNP guests.  But for me at least, that =
alone
isn't sufficient justification for adding a PV flavor of KVM.

