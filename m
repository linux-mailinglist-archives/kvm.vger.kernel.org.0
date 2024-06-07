Return-Path: <kvm+bounces-19042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 135F78FF88D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 02:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BD87285DFD
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 00:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469A7EC2;
	Fri,  7 Jun 2024 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pChbJ9y9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65E4802
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 00:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717719150; cv=none; b=OkRfrqFO5Gqu/MHJJJ5zNmc00SClnewhSzxArynQf5+0i32B1r2ey+AXTRXA/xhZuYp3IGpud/PEgGLQdhIoUziCbuJVyAeqZswMcesE8MLfZ8U/wv0OHeFI1S6srJsIsIlqcUnXOFa3npFkE6K/ykZZG3rJIbUmX8ZT2XTJNeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717719150; c=relaxed/simple;
	bh=fmdJX9NVh0KqmD9d0T3Ahst4mxmc2z/LhTOQs0YThNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pge8t7Ww0sf6Hc9if3hEsFVasdBa0PpawXVbAJ57yw/TrzAIQCZMfzjWfJ8bE+pzlraA0tH78FbP8Uvi6OIfijC8RbK2owLYV3INA8dRRCoyGsNO1kGFC3iWYqd9OheZnKt5gg0baxIPqj4AHFelLr57AjLGO1j8wybSqAk0GWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pChbJ9y9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df771b5e942so2425220276.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 17:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717719148; x=1718323948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LXWv/irqUOwkItTU+Xwz+dedNLgYPZaRnVpj2re2jg=;
        b=pChbJ9y9DeO+VOrdgYxT+0xKrLmmUTbeJfso8KhhC4Gt90NklDoAs0IcoQfGW5UP26
         nql+wa9mjMhYwK13Ne3R5N3z9EmNkwEUmCDGpu5uB5LzBv7J1/BSFYNN0DOjumEN4W0S
         l41dY3LDBatz+MEqHjmeCNoGwwOTve4A1TELxS0+71GFaYyDJoIWLvtwOOz6y86mKETx
         K9BFwVZE6t9C/XgRg+tKRl7G9UlVHjVKtm/55XWdmL1kIYp+gWk0Ik4hYEidcAUhOXAC
         oBDGMnQnSY9ta7OxP3NVXR/ehQ5KKjGRyU+0qDXOTJeFOokXEQtoDOaVs5iATfam39A1
         YlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717719148; x=1718323948;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/LXWv/irqUOwkItTU+Xwz+dedNLgYPZaRnVpj2re2jg=;
        b=mKt2nWdeXzIhgcc3absFdFqoTZJfKKD+tH0GUf0e84EmvVcG5OBT9BY8pnkAd7Y/G6
         6O5OR5jz+lrTtbM5A8Dwedy6UEq/tcxFLdR2sNbYRHaeYnkf69p6aSo2fpNJOQuXPG7z
         iGX3D4lw++n8hW2ara2Ps9ctMKzSuqKUw2FuzmezksKNqua4Glv54JPEFaBRarwe12j3
         9TeDCCDeWlS02ROVL112kCSEsD3q2GA87eszX+B5HiutDos0a2GC45q5u80PeFMPkig2
         Y31rxgmgE6UBuQWDJe+F8tj/nkXDnoH/3Ja/SlWgKb3PvTfiJbIkehCj9gj28fNmGoZk
         onJw==
X-Forwarded-Encrypted: i=1; AJvYcCXEhqDHqV8M/5IGZicoDwxCCRnxI8rgaT3Z2/8Y8hZTvZRAGwo1RNnrknnzWV2slbc/ewzXGE8rLDBmPH0bEFn3GQc+
X-Gm-Message-State: AOJu0Yzlv2V5v9oZUYXkY7ZZZTXpHOK+bYWqsgdbHK+valGm1YYnKIV0
	R6PA7oaAejljzDSFI40fACarOAEw6mgPFZk331v4baGX5GisQDA8ykNFR9GkYj5B8SBHgU2XNZv
	43A==
X-Google-Smtp-Source: AGHT+IHjNJ3HLDjNXW7p4enlieJFYV14UoNsQPlNFtKcsqwES0WKJS27d8ZOGnugeEsqAPP8SGlXQDKx+94=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100c:b0:dfa:59bc:8858 with SMTP id
 3f1490d57ef6-dfaf64c9026mr96592276.1.1717719147917; Thu, 06 Jun 2024 17:12:27
 -0700 (PDT)
Date: Thu, 6 Jun 2024 17:12:21 -0700
In-Reply-To: <516b4fd8-e1fd-43ec-a138-f670cc62a625@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605220504.2941958-1-minipli@grsecurity.net>
 <20240605220504.2941958-2-minipli@grsecurity.net> <ZmDnQkNL5NYUmyMN@google.com>
 <0ef7c46b-669b-4f46-9bb8-b7904d4babea@grsecurity.net> <ZmHN3SUsnTXI_71J@google.com>
 <516b4fd8-e1fd-43ec-a138-f670cc62a625@grsecurity.net>
Message-ID: <ZmJQZe6WWxojO7Bk@google.com>
Subject: Re: [PATCH 1/2] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2024, Mathias Krause wrote:
> On 06.06.24 16:55, Sean Christopherson wrote:
> > On Thu, Jun 06, 2024, Mathias Krause wrote:
> The first part is _completely_ handled by the 'id >=3D KVM_MAX_VCPU_IDS'
> test, as 'id' is still the "raw" value userland provided.=20

I'm not arguing it doesn't, all I'm saying is that I don't like overloading=
 a
check against an arbitrary limit to also protect against truncation issues.

> > E.g. x86 has another potentially more restrictive check on @id, and it =
looks
> > quite odd to check @id against KVM_MAX_VCPU_IDS as an "unsigned long" i=
n flow
> > flow, but as an "unsigned int" in another.
>=20
> Again, that's two distinct things, even if looking similar. The first
> check against KVM_MAX_VCPU_IDS does actually two things:
>=20
> 1/ Ensure the full user ABI provided value (ulong) is sane and
> 2/ ensure it's within the hard limits KVM expects (fits unsigned int).
>=20
> Now we do both with only a single compare and maybe that's what's so
> hard to grasp -- that a single check can do both things. But why not
> make use of simple things when we can do so?

Because it's unnecessarily clever.  I've dealt with waaaay too much legacy =
KVM
code that probably seemed super obvious at the time, but 8+ years and lots =
of
code churn later was completely nonsensical and all but impossible to decip=
her.

That's less likely to happen these days, as we have better tracking via lor=
e, and
I like to think we have better changelogs.  But I still dislike doing unnec=
essarily
clever things because it tends to set the next generation up to fail.

> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -4200,12 +4200,13 @@ static void kvm_create_vcpu_debugfs(struct
> >> kvm_vcpu *vcpu)
> >>  /*
> >>   * Creates some virtual cpus.  Good luck creating more than one.
> >>   */
> >> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> >> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id=
)
> >>  {
> >>         int r;
> >>         struct kvm_vcpu *vcpu;
> >>         struct page *page;
> >>
> >> +       BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
> >=20
> > This should be UINT_MAX, no?
>=20
> No, I chose INT_MAX very intentional, as the underlying type of
> 'vcpu_id' is actually an int.

Oof, I didn't realize (or more likely, simply forgot) that vcpu_id and vcpu=
_idx
are tracked as "int".

> There's no "need" for the BUILD_BUG_ON(). It's just a cheap (compile
> time only, no runtime "overhead") assert that the code won't allow
> truncated values which may lead to follow-up bugs because of unintended
> truncation. And, after all, you suggested something like that (a
> truncation check) yourself. I just tried to provide it as something that
> doesn't need the odd '__id' argument and an explicit truncation check
> which would do the wrong thing if we would like to push KVM_MAX_VCPU_IDS
> above UINT_MAX (failing only at runtime, not at compile time).

Yeah, I know all that.  I'm not arguing the actual cost of the code is at a=
ll
meaningful.  I'm purely concerned about the long-term maintenance cost.  Th=
is is
obviously a small thing that is unlikely to ever cause problems, but again,=
 I
suspect that past KVM developers said exactly that about things that have p=
egged
my WTF-o-meter.

> >              If @id is checked as a 32-bit value, and we somehow screw =
up and
> > define KVM_MAX_VCPU_IDS to be a 64-bit value, clang will rightly compla=
in that
> > the check is useless, e.g. given "#define KVM_MAX_VCPU_ID_TEST	BIT(32)"
> >=20
> > arch/x86/kvm/x86.c:12171:9: error: result of comparison of constant 429=
4967296 with
> > expression of type 'unsigned int' is always false [-Werror,-Wtautologic=
al-constant-out-of-range-compare]
> >         if (id > KVM_MAX_VCPU_ID_TEST)
> >             ~~ ^ ~~~~~~~~~~~~~~~~~~~~
> > 1 error generated.
>   ^^^^^^^^^^^^^^^^^^
> Perfect! So this breaks the build. How much better can we prevent this
> bug from going unnoticed?

Yes, but iff @id is a 32-bit value, i.e. this trick doesn't work on 64-bit =
kernels
if the comparison is done with @id is an unsigned long (and I'm hoping that=
 we
can kill off 32-bit KVM support in the not too distant future).

> =C2=B9 IMHO, using 'int' for vcpu_id is actually *very* *wrong*, as it's =
used
> as an index in certain constructs and having a signed type doesn't feel
> right at all. But that's just a side matter, as, according to the checks
> on the ioctl() path, the actual value of vcpu_id can never be negative.
> So lets not distract.

Hmm, I 100% agree that it's horrific, but I disagree that it's a distractio=
n.
I think we should fix that at the same time as we harden the trunction stuf=
f, so
that it's (hopefully) clear what KVM _intends_ to support, as opposed to wh=
at the
code happens to allow.

In the end, I'm ok relying on the KVM_MAX_VCPU_IDS check, so long as there'=
s
a BUILD_BUG_ON() and a comment.

