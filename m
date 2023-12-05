Return-Path: <kvm+bounces-3624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C3E805E85
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C2741C210A4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 19:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C936D1DC;
	Tue,  5 Dec 2023 19:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ev8Hh1P0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4D81A1
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 11:21:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-db547d41413so117033276.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 11:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701804113; x=1702408913; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+PHueKnu6twn/8T3xEnp+ZFlbZ1HcVdnlRPtBHugQhw=;
        b=Ev8Hh1P0Lkn6rpwHqo6XRBJORC5pIsg8zENzrjNDjrI56SN7yuJz1Rr68Pqz7l7lMx
         k4WwCo2Tj7AurXyzwDuPABQKnj+HotokvhE+iZcsEaH0FqEVPtb8sm1k6FBkjiEEBeWV
         BwwvoWxBDymDs1cTorQpvI7Drb04zj/BLheY9skbS05hzIuVUiesuLgv6IPO9wo7WwUz
         BUJB/dnP/ln0HCkbQsh+xbBzASDLJc4XFAAis88NOyLWNZrAfl/ZGixx5n5kYLvTp3bw
         RvuS6tSavP181mlYlLba8Upo+d2S2tzTyla9rR1tQopXZFG2fb15oy6QgDE82cAhBSym
         xXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701804113; x=1702408913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+PHueKnu6twn/8T3xEnp+ZFlbZ1HcVdnlRPtBHugQhw=;
        b=oMVPMBDJ4bdAecsNDoPq13stBeNk7O2mx1Xqu6w6+cbP4ObFgunTyABcy0rJhMujBm
         IK7QJcESZePW2rNwm8Ko2s3W631892ioELcWICmMBAAWFohwsdneKPqEynArZcOJymec
         PAAyqrlIIKHfDZ7Stzxcz+Jp0depjZ6cDClWIRs0k0o3CRsuukHwMJbNAOZY1YWFC4EI
         5xf5Vnd9bASfLPPcUaAKTp1kwF+BH4XUTyos47FOLd6b4op/w+/muebNxrx5m0ndtG0J
         w2OqODd52lyd4XFUC+o3y9Zb4cWxCowqQ/21Cglsl04wFI1iYvRChDCcwxM5FBrMqSTY
         6RyQ==
X-Gm-Message-State: AOJu0YzfT6cSKIwGed2LOgatQdAssrgRKqOCTYIxKYK1oOqiT4tMef1b
	kT8r0yn3gg1YCceZXCxxiBOpAnGlqSU=
X-Google-Smtp-Source: AGHT+IEDojI9r2jUP7SnFhGrIGalU4Ij3ADFSMH3T+bKNraCDRbJqd/r79BOcS/tAV9dHezzcWCAi9z33D0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bccd:0:b0:d9a:ca20:1911 with SMTP id
 l13-20020a25bccd000000b00d9aca201911mr63207ybm.4.1701804113124; Tue, 05 Dec
 2023 11:21:53 -0800 (PST)
Date: Tue, 5 Dec 2023 11:21:51 -0800
In-Reply-To: <CXD7AW5T9R7G.2REFR2IRSVRVZ@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-6-nsaenz@amazon.com>
 <f4495d1f697cf9a7ddfb786eaeeac90f554fc6db.camel@redhat.com>
 <CXD4TVV5QWUK.3SH495QSBTTUF@amazon.com> <ZWoKlJUKJGGhRRgM@google.com>
 <CXD5HJ5LQMTE.11XP9UB9IL8LY@amazon.com> <ZWocI-2ajwudA-S5@google.com> <CXD7AW5T9R7G.2REFR2IRSVRVZ@amazon.com>
Message-ID: <ZW94T8Fx2eJpwKQS@google.com>
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return
 prologues in hypercall page
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com, 
	x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> On Fri Dec 1, 2023 at 5:47 PM UTC, Sean Christopherson wrote:
> > On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > > On Fri Dec 1, 2023 at 4:32 PM UTC, Sean Christopherson wrote:
> > > > On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > > > > > To support this I think that we can add a userspace msr filter on the HV_X64_MSR_HYPERCALL,
> > > > > > although I am not 100% sure if a userspace msr filter overrides the in-kernel msr handling.
> > > > >
> > > > > I thought about it at the time. It's not that simple though, we should
> > > > > still let KVM set the hypercall bytecode, and other quirks like the Xen
> > > > > one.
> > > >
> > > > Yeah, that Xen quirk is quite the killer.
> > > >
> > > > Can you provide pseudo-assembly for what the final page is supposed to look like?
> > > > I'm struggling mightily to understand what this is actually trying to do.
> > >
> > > I'll make it as simple as possible (diregard 32bit support and that xen
> > > exists):
> > >
> > > vmcall             <-  Offset 0, regular Hyper-V hypercalls enter here
> > > ret
> > > mov rax,rcx  <-  VTL call hypercall enters here
> >
> > I'm missing who/what defines "here" though.  What generates the CALL that points
> > at this exact offset?  If the exact offset is dictated in the TLFS, then aren't
> > we screwed with the whole Xen quirk, which inserts 5 bytes before that first VMCALL?
> 
> Yes, sorry, I should've included some more context.
> 
> Here's a rundown (from memory) of how the first VTL call happens:
>  - CPU0 start running at VTL0.
>  - Hyper-V enables VTL1 on the partition.
>  - Hyper-V enabled VTL1 on CPU0, but doesn't yet switch to it. It passes
>    the initial VTL1 CPU state alongside the enablement hypercall
>    arguments.
>  - Hyper-V sets the Hypercall page overlay address through
>    HV_X64_MSR_HYPERCALL. KVM fills it.
>  - Hyper-V gets the VTL-call and VTL-return offset into the hypercall
>    page using the VP Register HvRegisterVsmCodePageOffsets (VP register
>    handling is in user-space).

Ah, so the guest sets the offsets by "writing" HvRegisterVsmCodePageOffsets via
a HvSetVpRegisters() hypercall.

I don't see a sane way to handle this in KVM if userspace handles HvSetVpRegisters().
E.g. if the guest requests offsets that don't leave enough room for KVM to shove
in its data, then presumably userspace needs to reject HvSetVpRegisters().  But
that requires userspace to know exactly how many bytes KVM is going to write at
each offsets.

My vote is to have userspace do all the patching.  IIUC, all of this is going to
be mutually exclusive with kvm_xen_hypercall_enabled(), i.e. userspace doesn't
need to worry about setting RAX[31].  At that point, it's just VMCALL versus
VMMCALL, and userspace is more than capable of identifying whether its running
on Intel or AMD.

>  - Hyper-V performs the first VTL-call, and has all it needs to move
>    between VTL0/1.
> 
> Nicolas

