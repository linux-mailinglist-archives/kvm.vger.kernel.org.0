Return-Path: <kvm+bounces-35844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E34B8A1563A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0423A7A4ADD
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584611A262A;
	Fri, 17 Jan 2025 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qk2by4jg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15EB1993B1
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737136912; cv=none; b=jD8rNybNyq9aQwSQw9Dv1laecCM6FK+ROZTBwHUcVATHBJF8Ra4Tm/xURIQTkcHhCjrh/HgaB8CgWjYPpGWuAlle6uMUb/QSYw4ixRtLi+6tWSFG3DxC7fjVyY7ZCManxPvVs9ER/NWOroboF/JZqbY0tRnbo408xhZd6ukLjQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737136912; c=relaxed/simple;
	bh=IYzFko9KIlsqtQTTgIf9aNVZ3kO3ee2tnOcsKs1ABsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cWqVKo7ga+07/6TwxTQrzn9ALQU3G5Xn+paPN+wDnJ7lpuHfjG6vdhsi8N6/sh8H9vH0lXRontOw6dCMUdkUAMEzQMvP6ZDejNSyoU49yKHg04j529TkZhlFWwWAC7AGD3I2PaHZzJE3QheS7bcKJQwNRTyF1235FTnMtjJZH0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qk2by4jg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9dbeb848so4592072a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737136910; x=1737741710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ZlDFLge8M0GjaKcSPR/oviwgRjviZuJ0u+CiB45rmM=;
        b=Qk2by4jg1NO+bTWtfrozO8BiWXPwcQnNjCe4TIExO6e1aOwg2wooDz2AmWfL2egV9m
         kf391CgWkJpPRfF7ZkVQ8eSBukJnxg+XcYbydEjm8KqAbAGt5PU8asP/6+hX7N9zWI0M
         XXEOHbk7Serq3E4DL/VCsrl3+/Pj/x/hYGyaX8Wb0sseTP3IgYS+j7NKCETe1+MDme9a
         HRSCe1RdvggKimLtSN8pUEUDVRpUchrqXdIj7TipG6Vakx4P1svjPE4gAz0p6CBSFoQg
         1Qfu8tFuzefMKuRghuKVbEZhQ49DX/CMohr8B4lGYNyd/grZcXo73EPQzROwYdXY8P4g
         Oi4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737136910; x=1737741710;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2ZlDFLge8M0GjaKcSPR/oviwgRjviZuJ0u+CiB45rmM=;
        b=d5fEfIsqrGpKfn1p70jEGLpp/WbEFiQihLzHz6+HqayZph6M58d+pQdpBcWqnTj1A7
         VDISN128IZPn8EzjSEnwGZROl+lMXPtNpguXshi7QsiXhCHFS/Q/FBhpB3mz7FI+dSDk
         HpZWwAReG+QN24/XH7ABFScKVYqXZIvhwtAvOUCBqp/1NYAK6ld01qwT+khOd/P2PBld
         hl0DuO/hIUlpAGbG57xTkozhGBUb3HRb2zi/1lr5wvM6jFi3/UrNrxDe2Vv3M4MAI/xa
         oGno/n0BTOTT7F1xQO4yVzyHsMw+W/mAiwnTmSSkU/GU9LMoJInkyjwXhu0gyonyUpdH
         uV1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWIMbYjM3e//wn2HEX8IyBEWdIyt1FlIzjP0U4ZM61r+mS3ncAA7JtLS/1cTewSAYHeAb0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8jZzdNsbhM0HyWEa9UaK/TBISNVtG5vHuvlaINBnozf42IqNL
	6jm5xT5lV2NHtJ/y6Zj6zFvoywcKEb+b0+HFtrVkNlns89sB3xEWG88ULf+jiX2L8IwZMKVbbdM
	7DQ==
X-Google-Smtp-Source: AGHT+IH3kzsHHbyB3ao4JI9g/yvY0oQnMhcP/65HRt4C5eeyTU1NotxImCSHfQxwAU7EgktU1S5w5Kip3fI=
X-Received: from pjbso13.prod.google.com ([2002:a17:90b:1f8d:b0:2ea:756d:c396])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8b:b0:2f6:539:3cd8
 with SMTP id 98e67ed59e1d1-2f782ca2291mr5677862a91.18.1737136910364; Fri, 17
 Jan 2025 10:01:50 -0800 (PST)
Date: Fri, 17 Jan 2025 10:01:48 -0800
In-Reply-To: <CAJD7tkahmyjXvwKO2=EfQRWu_BHPJ-8+eSEteZH5TGG3+jHtWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
 <Z4mJpu3MvBeL4d1Q@google.com> <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
 <Z4mlsr-xJnKxnDKc@google.com> <CAJD7tkahmyjXvwKO2=EfQRWu_BHPJ-8+eSEteZH5TGG3+jHtWw@mail.gmail.com>
Message-ID: <Z4qbDBduEYWEwjkS@google.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> On Thu, Jan 16, 2025 at 4:35=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > > On Thu, Jan 16, 2025 at 2:35=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > How about:
> > > >
> > > >          * Note, only the hardware TLB entries need to be flushed, =
as VPID is
> > > >          * fully enabled from L1's perspective, i.e. there's no arc=
hitectural
> > > >          * TLB flush from L1's perspective.
> > >
> > > I hate to bikeshed, but I want to explicitly call out that we do not
> > > need to synchronize the MMU.
> >
> > Why?  Honest question, I want to understand what's unclear.  My hesitat=
ion to
> > talk about synchronizing MMUs is that it brings things into play that a=
ren't
> > super relevant to this specific code, and might even add confusion.  Sp=
ecifically,
> > kvm_vcpu_flush_tlb_guest() does NOT synchronize MMUs when EPT/TDP is en=
abled, but
> > the fact that this path is reachable if and only if EPT is enabled is c=
ompletely
> > coincidental.
>=20
> Personally, the main thing that was unclear to me and I wanted to add
> a comment to clarify was why we use KVM_REQ_TLB_FLUSH_GUEST in the
> first two cases but KVM_REQ_TLB_FLUSH_CURRENT in the last one.
>
> Here's my understanding:
>=20
> In the first case (i.e. !nested_cpu_has_vpid(vmcs12)), the flush is
> architecturally required from L1's perspective to we need to flush
> guest-generated TLB entries (and potentially synchronize KVM's MMU).
>=20
> In the second case, KVM does not track the history of VPID12, so the
> flush *may* be architecturally required from L1's perspective, so we
> do the same thing.
>=20
> In the last case though, the flush is NOT architecturally required
> from L1's perspective, it's just an artifact of KVM's potential
> failure to allocate a dedicated VPID for L2 despite L1 asking for it.
>=20
> So ultimately, I don't want to specifically call out synchronizing
> MMUs, as much as I want to call out why this case uses
> KVM_REQ_TLB_FLUSH_CURRENT and not KVM_REQ_TLB_FLUSH_GUEST like the
> others. I only suggested calling out the MMU synchronization since
> it's effectively the only difference between the two in this case.

Yep.  I suspect the issue is lack of documentation for TLB_FLUSH_GUEST and
TLB_FLUSH_CURRENT.  I'm not entirely sure where it would be best to documen=
t
them.  I guess maybe where they are #defined?

TLB_FLUSH_GUEST is used when a flush of the guest's TLB, from the guest's
perspective, is architecturally required.  The one oddity with TLB_FLUSH_GU=
EST
is that it does NOT include guest-physical mappings, i.e. TLB entries that =
are
associated with an EPT root.

TLB_FLUSH_CURRENT is used when KVM needs to flush the hardware TLB(s) for t=
he
current CPU+context.  The most "obvious" case is for when KVM has modified =
its
page tables.  More subtle cases are things like changing which physical CPU=
 the
vCPU is running on, and this case where KVM is switching the shadow CR3, VP=
ID is
enabled in the host (i.e. hardware won't flush TLBs), and the L1 vs. L2 sha=
dow
CR3s are not tagged (i.e. use the same hardware VPID).

The use of TLB_FLUSH_GUEST *may* result in an MMU sync, but that's a side e=
ffect
of an architectural guest TLB flush occurring, not the other way around.

