Return-Path: <kvm+bounces-26724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A99976C44
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8068B23552
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C291B373A;
	Thu, 12 Sep 2024 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2uGVAGt8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1DB1AD279
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726151799; cv=none; b=SyKRkGyBdDYNFA2PAGkrrGFpYnam2HIkUQGuP2xnBWZLz3y0o+ZA5M27AkqLbsQy1ypz9O64x6oD/1NatsPxE56T3JX1gmC/VM5QwFg+xZLy9+H0UdDR30aTdBeR4IoNU0/Jh+Wnjd+GHG8ePc47o+FfxcMaoDd+8Qm6nvuJsCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726151799; c=relaxed/simple;
	bh=ZoHEMiLHNAklQqy8n7zR1GpdffFQA3RiPrxrJvYrbkU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d6rdYujebXRPt2HSyKRW9wcxs9tS5XXwNZsd2suGeercX/7Ys+eUJ10V85JWFePKrC5RGOLOO4FCOlaE34Fs7SDOZ0crAEKJ252DnWHQwOT5lIzwkFQUgp10bx3GFgK83jLXwYfVEkB/4KQIJGSUANJQ+pD3XLNYXt80PUkXACo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2uGVAGt8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-207464a9b59so13749435ad.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726151797; x=1726756597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IuWyNxzcGe6GM7Msd7pGsCR+v4gYGRud4L+CnasmxO4=;
        b=2uGVAGt8+7M/VfnAFduB6YZz0LUpTjFVyhdTgsV+Tw7RDOVWvH50ZxIzlkoo3fVz2d
         kT/ltGae1nflUaD6D5rDW135zg1DxCtGoFJ7cyrmIE0JcRYo4r5Qd1C28kG/Mtaa9HX8
         2Cizs82jE4mhZQkCosmsHigLA/mOUrLxzQM9Tavw2Ce+jkktV/+hMeZGUY5C2W3KAfyQ
         T9c6uoaWDAQ77NPQKD9HbTByKWjSHnuOM/ziy4nOiJ+zuuaLUMv6d/qE5UxKQQzRHBlN
         cyDuPf8UEm4Edf2GqfN5xFcz0oSZWBtgyk3QtNS3/Bry7O9uQFxF8xBybPdcHdEVDnse
         i9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726151797; x=1726756597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IuWyNxzcGe6GM7Msd7pGsCR+v4gYGRud4L+CnasmxO4=;
        b=euLjIwAtyi3AzxJbc3mRuJkC7w2xxyvUGDIE37c6cOyVefAPzsda4tY6/LQgOSBHtu
         feH1QrivI166NoF8ue5H02Wni5leFUJh7mJQ5k8bANe+Q3dbVCUIsAbWxYh1GndOQZ3H
         U37C/nb8/VUHpLNkbJShip9KANBja7jrqGqvFxxYpCjccRfKpG9IRTR/e4ZYYSGbHY72
         Fla4bg9PEztFuQw6DfsYLhMaqoYT86tgREBE/ljy14LDkiUcIuKnQUtqJ3ncoAyby1Rr
         6Z3cBPYffQkvmjPwD9JaxpQURZMh0N3yyPKunZueodvtPfdgMDjuJI0CU6qIZgS8gLYi
         7/Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXjoBRnCjUmDzgLWDHdT/i6e+dTQNbPkQrc0qwmZAP6iF57+NUiggh27YkpeXfAbQIFUZs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwBbPjjM5LH96EpZLT6Vw6/e9UykFFOUU1m/2YIoFU8t0GzBxN
	Uo9qrKsJbHcju0JpyGTEvEgb61Zh/Y+24Ff0O1312TUoLuvoOV5X6TqjOXcxocyI5h2yFdZ8azk
	0/A==
X-Google-Smtp-Source: AGHT+IFuWC8JsJR3HsGyaRESNbHfLvQfpWc/wR0gpPN/S8O3DJQxAYIEFm0Vm/kFYnlxP670Kr6C2sD3R10=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa47:b0:205:71fb:2b27 with SMTP id
 d9443c01a7336-2076e3793dbmr630405ad.4.1726151796967; Thu, 12 Sep 2024
 07:36:36 -0700 (PDT)
Date: Thu, 12 Sep 2024 07:36:35 -0700
In-Reply-To: <CADrL8HW+hUNKPbaL7xYb0FEesB2t-AwAw07iOCDj8KHp0RwVpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240911204158.2034295-14-seanjc@google.com>
 <CADrL8HW+hUNKPbaL7xYb0FEesB2t-AwAw07iOCDj8KHp0RwVpQ@mail.gmail.com>
Message-ID: <ZuL8c7SCV0I16cma@google.com>
Subject: Re: [PATCH v2 13/13] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024, James Houghton wrote:
> On Wed, Sep 11, 2024 at 1:42=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > @@ -31,6 +33,42 @@ static void guest_code(uint64_t start_gpa, uint64_t =
end_gpa, uint64_t stride)
> >                 *((volatile uint64_t *)gpa);
> >         GUEST_SYNC(2);
> >
> > +       /*
> > +        * Write to the region while mprotect(PROT_READ) is underway.  =
Keep
> > +        * looping until the memory is guaranteed to be read-only, othe=
rwise
> > +        * vCPUs may complete their writes and advance to the next stag=
e
> > +        * prematurely.
> > +        *
> > +        * For architectures that support skipping the faulting instruc=
tion,
> > +        * generate the store via inline assembly to ensure the exact l=
ength
> > +        * of the instruction is known and stable (vcpu_arch_put_guest(=
) on
> > +        * fixed-length architectures should work, but the cost of para=
noia
> > +        * is low in this case).  For x86, hand-code the exact opcode s=
o that
> > +        * there is no room for variability in the generated instructio=
n.
> > +        */
> > +       do {
> > +               for (gpa =3D start_gpa; gpa < end_gpa; gpa +=3D stride)
> > +#ifdef __x86_64__
> > +                       asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa)=
 : "memory"); /* mov %rax, (%rax) */
>=20
> I'm curious what you think about using labels (in asm, but perhaps
> also in C) and *setting* the PC instead of incrementing the PC.=20

I have nothing against asm labels, but generally speaking I don't like usin=
g
_global_ labels to skip instructions.  E.g. __KVM_ASM_SAFE() uses labels to=
 compute
the instruction size, but those labels are local and never directly used ou=
tside
of the macro.

The biggest problem with global labels is that they don't scale.  E.g. if w=
e
extend this test in the future with another testcase that needs to skip a g=
pa,
then we'll end up with skip_page1 and skip_page2, and the code starts to be=
come
even harder to follow.

Don't get me wrong, skipping a fixed instruction size is awful too, but in =
my
experience they are less painful to maintain over the long haul.

> Diff attached (tested on x86).

Nit, in the future, just copy+pase the diff for small things like this (and=
 even
for large diffs in many cases) so that readers don't need to open an attach=
ment
(depending on their mail client), and so that it's easier to comment on the
proposed changed.

`git am --scissors` (a.k.a. `git am -c`) can be used to essentially extract=
 and
apply such a diff from the mail.

> It might even be safe/okay to always use vcpu_arch_put_guest(), just set =
the
> PC to a label immediately following it.

That would not be safe/feasible.  Labels in C code are scoped to the functi=
on.
And AFAIK, labels for use with goto are also not visible symbols, they are
statements.  The "standard" way to expose a label from a function is to use=
 inline
asm, at which point there are zero guarantees that nothing necessary is gen=
erated
between vcpu_arch_put_guest() and the next asm() block.

E.g. ignoring the inline asm for the moment, the compiler could generate mu=
ltiple
paths for a loop, e.g. an unrolled version for a small number of iterations=
, and
an actual loop for a larger number of iterations.  Trying to define a label=
 as a
singular symbol for that is nonsensical.

