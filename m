Return-Path: <kvm+bounces-14950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 08AA88A8017
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:48:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8ACE3B2171E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25785137C33;
	Wed, 17 Apr 2024 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rn8aKDCp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A4412F59F
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713347300; cv=none; b=ON8P8iX3o+F/taAQ/+Fs8XroS1YGBCzz4LJZscB9NLcegTJhTjSRBDrBHutosbSCAyYBoclyCK0CRQEzUZ0kXt8t2aeg/5+ByU/DLXZWZZ8kObjoFN82lfB1Y89lCIi8RyYDsi/cOEO/UGCkV7KsmyO1YQpAAavSDmXTYByprJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713347300; c=relaxed/simple;
	bh=i68APQ2lyTogjhJB0PE4zswrWF6uoMSKRUDeEj8xzHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oyBG0dECJE/2YoKJ1C+1A6Nnb6b/e/xNRC/mXV/Ops7XilaMejMRZU0+QAmu4e//XMDlYgvXrCKJO2P5IxO9KAbFCsb60yW/aXXyq5kYIrmEg87joPMHI7jL5LHRxQlmFsBao+iRZ0wiHxddEd/teQlYQ2JBftCT+mYUzNiVFhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rn8aKDCp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713347297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zlZxHt3hkdiGt31RAOSNUlAzN6IqVMpUhfirTvNIdlw=;
	b=Rn8aKDCpSZqXytSSt1XndRpdq9G1XiKUs3BoSqSgrY3aHTu2E8mwBiRT80ioSoDI7VJatg
	2XtpwYiAaT3f3g4nUjQ8Z5EBkgnkSKOS+QMqqLoq0n4G/rF/nfxiKsToTwn3vij5fTfc07
	8C7Y0HCag45IqsvxfHxsdga0IZ1Nayk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-D7klw1IrPhCMrutcteVZBQ-1; Wed, 17 Apr 2024 05:48:15 -0400
X-MC-Unique: D7klw1IrPhCMrutcteVZBQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-349e1effeb5so39301f8f.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 02:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713347294; x=1713952094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zlZxHt3hkdiGt31RAOSNUlAzN6IqVMpUhfirTvNIdlw=;
        b=K+oJ3N62vgQnE18B3TBWWBMFJ+yLs2F9FseBhvdld4jCooiEnRFDeKZ9nf073wPl3Q
         UqwaP/nn/Xl8U3ykLS4Cx7towEsRq9PjALK9Yx5dGnFEg2z/SjBjJwcqch8r8Tu9urg6
         UGTKB9kOWWMkCoAA+M0VhdFF//ux/GcFvn0qrPaIeQZOrafSZsf7+D6atykjiwZ/owvJ
         aCReXwqHGyz0ciSsrptHDgh9SLZ8fXNyyM3w7qkSQa6SDThcLSYuFGf4tdjcE7EcIT7f
         X1haPZ8M5iQsY0uzM9t5uvNjhIvYOaaH9b32MgfwE74XmoI9Bx/R2kpRlzPBUosqA+Cq
         ZjIA==
X-Forwarded-Encrypted: i=1; AJvYcCVEjjwjxA8WVvqRqYfrcUZc8WfAtoujvE6hK526sGBDBP9+zhDrgefd6CJ/6TqY1sRyKsIHLQKGYIFjcYhOn826UlUg
X-Gm-Message-State: AOJu0YzfgOIr4Rktt9Cq47c5g4k+Sn60m5oeJssWAVpfyDMmAoswTVNU
	nERt86IZwwjEZI4ZzQfyegXPzp8J0nGWYsXno0A6KzttDmQ9lHGfNZxZpC/N2eBZqh6j92DYqT+
	ya0IuolaJQnFLxdaLQvdjKe4rXRgp8Tb/RjQVFVOHdYKPcpl2AWKJIzzhTQfhZIE8f3xOq3iU2S
	0Dq+S00Zlew2ErE6zulhmtyf4F
X-Received: by 2002:a5d:591b:0:b0:346:f830:db09 with SMTP id v27-20020a5d591b000000b00346f830db09mr4009523wrd.31.1713347294590;
        Wed, 17 Apr 2024 02:48:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQeuW8BecLZVPGV76NLmrX87lWpte9uNU+aOHfPGt/rbtIo4U4Ln8Ue3LR30ngxFm9oN2rCQ0jUO/W+zuxjMY=
X-Received: by 2002:a5d:591b:0:b0:346:f830:db09 with SMTP id
 v27-20020a5d591b000000b00346f830db09mr4009506wrd.31.1713347294140; Wed, 17
 Apr 2024 02:48:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <Zh6-h0lBCpYBahw7@google.com> <CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6OqA35HzA@mail.gmail.com>
 <Zh79D2BdtS0jKO6W@google.com>
In-Reply-To: <Zh79D2BdtS0jKO6W@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 11:48:01 +0200
Message-ID: <CABgObfaSTa7pC0FBhx45NVGyLtBGceZJCZbjjko-tA-J8a1tiA@mail.gmail.com>
Subject: Re: [RFC 0/3] Export APICv-related state via binary stats interface
To: Sean Christopherson <seanjc@google.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, joao.m.martins@oracle.com, 
	boris.ostrovsky@oracle.com, mark.kanda@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 12:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > > The hiccup with stats are that they are ABI, e.g. we can't (easily) d=
itch stats
> > > once they're added, and KVM needs to maintain the exact behavior.
> >
> > Stats are not ABI---why would they be?
>
> Because they exposed through an ioctl(), and userspace can and will use s=
tats for
> functional purposes?  Maybe I just had the wrong takeaway from an old thr=
ead about
> adding a big pile of stats[1], where unfortunately (for me) you weighed i=
n on
> whether or not tracepoints are ABI, but not stats.

I think we can agree that:
- you don't want hundreds of stats (Marc's point)
- a large part of the stats are very stable, but just as many (while
useful) depend on details which are very much implementation dependent
- a subset of stats is pretty close to being ABI (e.g. guest_mode),
but others can change meaning depending on processor model, guest
configuration and/or guest type (e.g. all of them affect
interrupt-related stats due to APICv inhibits).

While there are exceptions, the main consumer of stats (but indeed not
the only one) is intended to be the user, not a program. This is the
same as tracepoints, and it's why the introspection bits exist.
(User-friendliness also means that bitmask stats are "ouch"; I guess
we could add support for bit-sized boolean stats is things get out of
control).

For many stats, using them for functional purposes would be
wrong/dumb. You have to be ready for the exact behavior to change even
if the stats remain the same. If userspace doesn't, it's being dumb.
KVM can't be blocked from supporting new features just because they
"break" stats, and shouldn't be blocked from adding useful debugging
stats just because userspace could be dumb.

For example, the point of pf_fast is mostly to compare it with other
pf_* stats and see if there's something smelly going on.pf_fast used
to affect pretty much only dirty bits; nowadays it also affects
accessed bits on !ept_ad machines and it does not affect dirty bits if
you have PML. So in the past it was possible to use pf_fast as a proxy
for the number of dirty pages, for example during migration. That
usage doesn't work anymore. Tough luck.

Perhaps you could use the halt-polling stats to toggle DISABLE_EXITS
for VMs that consume a lot of time polling. That would be a more
plausible use of stats to drive heuristics, but again, the power to
look into low-level details of KVM and guest behavior comes with the
accompanying responsibility. It is _not_ guaranteed to keep working in
the same way as processors come out and optimizations are added to
KVM.

So you would have to look at intentional stats breakages one by one,
and this is again a lot like tracepoints. And many potential breakages
would go unnoticed anyway, because there's an infinite supply of bad
ideas when it comes to stats and heuristics.

> That said, I'm definitely not opposed to stats _not_ being ABI, because t=
hat would
> give us a ton of flexibility.  E.g. we have a non-trivial number of inter=
nal stats
> that are super useful _for us_, but are rather heavy and might not be des=
irable
> for most environments.  If stats aren't considered ABI, then I'm pretty s=
ure we
> could land some of the more generally useful ones upstream, but off-by-de=
fault
> and guarded by a Kconfig.  E.g. we have a pile of stats related to mmu_lo=
ck that
> are very helpful in identifying performance issues, but they aren't thing=
s I would
> want enabled by default.

That would be great indeed.

> > Not everything makes a good stat but, if in doubt and it's cheap
> > enough to collect it, go ahead and add it.
>
> Marc raised the (IMO) valid concern that "if it's cheap, add it" will lea=
d to
> death by a thousand cuts.  E.g. add a few hundred vCPU stats and suddenly=
 vCPUs
> consumes an extra KiB or three of memory.
>
> A few APIC stats obviously aren't going to move the needle much, I'm just=
 pointing
> out that not everyone agrees that KVM should be hyper permissive when it =
comes to
> adding new stats.

Yeah, that's why I made it conditional to "if in doubt". "Stats are
not ABI" is not a free pass to add anything, also because the truth is
closer than "Stats are generally not ABI but keeping them stable is a
good idea". Many more stats are obviously bad to have upstream, than
there are good ones; and when adding stats it makes sense to consider
their stability but without making it an absolute criterion for
inclusion.

So for this patch, I would weigh advantages to be substantial:
+ APICv inhibits at this point are relatively stable
+ the performance impact is large enough that APICv/AVIC stats _can_
be useful, both boolean and cumulative ones; so for example I'd add an
interrupt_injections stat for unaccelerated injections causing a
vmexit or otherwise hitting lapic.c.

But absolutely would not go with a raw bitmask because:
- the exact set of inhibits is subject to change
- super high detail into niche APICv inhibits is unlikely to be useful
- many if not most inhibits are trivially derived from VM configuration

Paolo


