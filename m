Return-Path: <kvm+bounces-11916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 709B287D10A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E09DD1F23C9B
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493D245970;
	Fri, 15 Mar 2024 16:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cen7+Cvt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B04044C86
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710519441; cv=none; b=mBFyaGMye/Mi1qKUMQpxWarXi+/yO5mrOXdr3IdaTkG4FqPNquk+ht3YPHfcVdWzUNrS9kZzkVnEgkexoRroCn0V/g/LQqx2WRWtxKEdu0klrQVJGrZHpoliRqA/rIBF09uSEUyF+bRFQi8a8X+jx0oMHIUw8O9kwaC4ntZtRo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710519441; c=relaxed/simple;
	bh=fIvQ/7dT03a07rywBiZKwU4kbI9dFy8nHM66+ChDcHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fBLsV0c/R4jXq4NdpW4tFl91EgbB+ywy0+NaW0/qSTrV4YQBiK/PlAmIMae0dqe3HKsGBREu93lJDxd1Mn8frhFJCMziuiGP4ulTWA9d97WtVDb1MqYDp4ZnR9lrMIjC97vZig/iQt3CjtW5XSjSV+0ZLWAljxy+yIabbytdiH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cen7+Cvt; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-513d717269fso1501001e87.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 09:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710519438; x=1711124238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gg0TYzkl0UxVlxeIgrkhXJopu1CdOE320qaBHoGPlBg=;
        b=Cen7+CvtGWHgT2NqRii20gy8BRFDt9gPBnTEZjHNn6vuR9VdzCIZwrT/FvGpkCziN/
         fqzWh0wpmUmE3vB9iFWRorSVoqZWWPjsPVbgYkgpCg3mjGPtEdWjh0S7kplDrhHFoBT9
         NHI2cRc+cVndZ/1wJ8mBApO9MJtwbx6v7J1uV8IjHcHFEd9uaqKJ3Xgu4VfLJdkChetD
         f30Gfmwk3JmqSKh19NgC479FhchGYpCcszmjkgUVuulK4ga1HmEn0ALE6V3COwugPsI2
         L76fh8skim4sfSOTxEzjDzpfNWar4ws3uXsf09SKfQHsXWonOVKKZ1FnAk2XrUFFQbeT
         naoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710519438; x=1711124238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gg0TYzkl0UxVlxeIgrkhXJopu1CdOE320qaBHoGPlBg=;
        b=BSRmt5RTQZSzU/2CZhoygS0ep6xnm5vsVLXebBic2F1DGxccbk7dJx9+vbsP/56QZE
         X9tQsvm1pOm4EYulH8NlEDem6WvEWWD5XOJZamllLVMezL0Jj8VfsmGFGuzTmqd4RHE3
         ufM+9286JHwjOQmuQPO77RcwWduuZJ9tnQzyA1QuCC06hGX5ki2hM8gO8PPZ47hBFykP
         PaEpdSD/r1rPi3FUJ/PuVQYfaLm4Xq9DbkC2BPUirr/kIQ5uUJa0zolXOOHI52FC4/M7
         /CBpcSoMam6uHXZ/9rxRE4KMP4Sv61NDLSuysicRpoGPIVva4oXLGF8SkTowwnOmNPiT
         6Nzw==
X-Forwarded-Encrypted: i=1; AJvYcCUGmCZWKRrUMWSYr2Cwr+6svjTqls9qyUkCzaJGdqhIxUQsPWPZtMR7vv9E7r5C8eMKOecFws92NK9nOotXa90qphYQ
X-Gm-Message-State: AOJu0Yw6NC7du0JZKUjln9dczPjNNq7GnCODSthFyCPzBfRf2KNeyJfa
	0tHmvss5Mbn1QP4yuVbJZOQoNzQxu687Qv3y9ahhuES9Yp7zh4nXQg+Jgv3tO2WTr8L7gi4797C
	RStxww2SKKWXgpx5ptSjeSpMhq6lpQ7zTI2G9
X-Google-Smtp-Source: AGHT+IGp8kiRyTEWLA4+GiDAcMjnyRvEbCmpbYUPfI9r/tFeOzSYgxHCFIPwgAMDq50bEyd9emHZDLUHbVd3frfmk6I=
X-Received: by 2002:a19:3810:0:b0:513:96ff:a04a with SMTP id
 f16-20020a193810000000b0051396ffa04amr2529285lfa.43.1710519437564; Fri, 15
 Mar 2024 09:17:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307194255.1367442-1-dmatlack@google.com> <ZepBlYLPSuhISTTc@google.com>
 <ZepNYLTPghJPYCtA@google.com> <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com>
 <ZfG41PbWqXXf6CF-@google.com> <CALzav=fGUnYHiEc40Ym2Yh-H6wMRdw6biYj4+e1vZ0xmBDAnsg@mail.gmail.com>
 <ZfOEzMxn73M0kZk_@google.com>
In-Reply-To: <ZfOEzMxn73M0kZk_@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 15 Mar 2024 09:16:49 -0700
Message-ID: <CALzav=cLRJOtCyY+DVRWBxBMaV5S8Cy9bBKxmfdUhGLwS0+_6A@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	nrb@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024 at 4:14=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Mar 14, 2024, David Matlack wrote:
> > On Wed, Mar 13, 2024 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Mar 07, 2024, David Matlack wrote:
> > > > On Thu, Mar 7, 2024 at 3:27=E2=80=AFPM David Matlack <dmatlack@goog=
le.com> wrote:
> > > > >
> > > > > On 2024-03-07 02:37 PM, Sean Christopherson wrote:
> > > > > > On Thu, Mar 07, 2024, David Matlack wrote:
> > > > > > > Create memslot 0 at 0x100000000 (4GiB) to avoid it overlappin=
g with
> > > > > > > KVM's private memslot for the APIC-access page.
> > > > > >
> > > > > > Any chance we can solve this by using huge pages in the guest, =
and adjusting the
> > > > > > gorilla math in vm_nr_pages_required() accordingly?  There's re=
ally no reason to
> > > > > > use 4KiB pages for a VM with 256GiB of memory.  That'd also be =
more represantitive
> > > > > > of real world workloads (at least, I hope real world workloads =
are using 2MiB or
> > > > > > 1GiB pages in this case).
> > > > >
> > > > > There are real world workloads that use TiB of RAM with 4KiB mapp=
ings
> > > > > (looking at you SAP HANA).
> > > > >
> > > > > What about giving tests an explicit "start" GPA they can use? Tha=
t would
> > > > > fix max_guest_memory_test and avoid tests making assumptions abou=
t 4GiB
> > > > > being a magically safe address to use.
> > >
> > > So, rather than more hardcoded addresses and/or a knob to control _al=
l_ code
> > > allocations, I think we should provide knob to say that MEM_REGION_PT=
 should go
> > > to memory above 4GiB. And to make memslot handling maintainable in th=
e long term:
> > >
> > >   1. Add a knob to place MEM_REGION_PT at 4GiB (and as of this initia=
l patch,
> > >      conditionally in their own memslot).
> > >
> > >   2. Use the PT_AT_4GIB (not the real name) knob for the various mems=
tress tests
> > >      that need it.
> >
> > Making tests pick when to place page tables at 4GiB seems unnecessary.
> > Tests that don't otherwise need a specific physical memory layout
> > should be able to create a VM with any amount of memory and have it
> > just work.
> >
> > It's also not impossible that a test has 4GiB+ .bss because the guest
> > needs a big array for something. In that case we'd need a knob to move
> > MEM_REGION_CODE above 4GiB on x86_64 as well.
>
> LOL, at that point, the test can darn well dynamically allocate its memor=
y.
> Though I'd love to see a test that needs a 3GiB array :-)
>
> > For x86_64 (which is the only architecture AFAIK that has a private
> > memslot in KVM the framework can overlap with), what's the downside of
> > always putting all memslots above 4GiB?
>
> Divergence from other architectures, divergence from "real" VM configurat=
ions,
> and a more compliciated programming environment for the vast majority of =
tests.
> E.g. a test that uses more than ~3GiB of memory would need to dynamically=
 place
> its test specific memslots, whereas if the core library keeps everything =
under
> 4GiB by default, then on x86 every test knows it has 4GiB+ to play with.

Divergence from real VM configurations is a really good point. I was
thinking we _could_ make all architectures start at 4GiB and make
32GiB the new static address available for tests to solve the
architecture divergence and complexity problems. But that would mean
all KVM selftests don't use GPAs 0-4GiB, and that seems like a
terrible idea now that you point it out.

Thanks for the thoughtful feedback. I'll give your suggestions a try in v2.

>
> One could argue that dynamically placing test specific would be more eleg=
ant,
> but I'd prefer to avoid that because I can't think of any value it would =
add
> from a test coverage perspective, and static addresses are much easier wh=
en it
> comes to debug.
>
> Having tests use e.g. 2GiB-3GiB or 1GiB-3GiB, would kinda sorta work, but=
 that
> 2GiB limit isn't a trivial, e.g. max_guest_memory_test creates TiBs of me=
mslots.
>
> IMO, memstress is the odd one out, it should be the one that needs to do =
special
> things.

Fair point.

>
> > >   3. Formalize memslots 0..2 (CODE, DATA, and PT) as being owned by t=
he library,
> > >      with memslots 3..MAX available for test usage.
> > >
> > >   4. Modify tests that assume memslots 1..MAX are available, i.e. for=
ce them to
> > >      start at MEM_REGION_TEST_DATA.
> >
> > I think MEM_REGION_TEST_DATA is just where the framework will satisfy
> > test-initiated dynamic memory allocations. That's different from which
> > slots are free for the test to use.
> >
> > But assuming I understand your intention, I agree in spirit... Tests
> > should be allowed to use slots TEST_SLOT..MAX and physical addresses
> > TEST_GPA..MAX. The framework should provide both TEST_SLOT and
> > TEST_GPA (names pending), and existing tests should use those instead
> > of random hard-coded values.
> >
> > >
> > >   5. Use separate memslots for CODE, DATA, and PT by default.  This w=
ill allow
> > >      for more precise sizing of the CODE and DATA slots.
> >
> > What do you mean by "[separate memslots] will allow for more precise si=
zing"?
>
> I suspect there is a _lot_ of slop in the arbitrary 512 pages that are ta=
cked on
> by vm_nr_pages_required().  Those 2MiBs probably don't matter, I just don=
't like
> completely magical numbers.

That makes sense, we can probably tighten up those heuristics and
maybe even get rid of the magic numbers. But I wasn't following what
_separate memslots_ has to do with it?

