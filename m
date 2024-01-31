Return-Path: <kvm+bounces-7523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6208432B2
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A25B287584
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1334815C9;
	Wed, 31 Jan 2024 01:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvY9CP2s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F2C1368
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706664401; cv=none; b=m40xfuci+vUM/3wfm2mXMnaM3Kl+GlmzdFYXIkWODiJBw2hglZbZsoANrNrau+Wd4C1NXsbdd/nN+/41gVQsCagCqTKFxULfThNeiAyHEYjBj/Ly9fGrX1s3qXdUB7stDmoK1ObpHUnOS7BR0ief/6d0p1zGCYy+cmEvLSIrka4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706664401; c=relaxed/simple;
	bh=ZNhDLzIeR/fzPEPKReexeRhO7EbokrTcuamNJtnSDoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gNgW9ylOV4wjI638iXsglvEj1it5G10xjvs9ww9aN+LUmfUkqzXSOpHV3zkRaf1/IMDnFBhFk5yfwm8crh0ITEylaRzaSCW4tgTNPd6YS5TtHTzQlXVuZoVzEIifOIbbDOc8q7YRMANUV5eK+l1ajRUvGVOYaU0lzs5nyt+i0xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvY9CP2s; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7d5c7443956so1184235241.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706664398; x=1707269198; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h93BkgVFUuRnPb2+mPK0buA3QG1DHMAEwTXxdNF0ziU=;
        b=VvY9CP2sjjMqBTWJID0aQxcuCRg161JOuUQC/S5SQVgzL6iuzmm5yqJAYTcs45U14V
         ajX/VqWkEQxEKVAKW8WE/dunnW2AybH8RQGnSOARGB29IzXp15pFY5wayuKZ+i9yZQem
         AAIFy/jkIXyiqp4X9W82wk5pnQjFs8uBFbR2ieEdbI+SxUWid5a7CshogY80gijC1FX+
         qdyyo+izxmykSLZ7tDwAxB0xs1M5sI6pXGG0xNf3Ggfb4xg3s+ko5S7jCyI0Zxgah24X
         CdaFYmY27Pw/SOkaqTOwf1a3u2S7Zgkg/hUbVOzjcwtNq68a46TxO0F+7ewAfe3lPQ/+
         3ACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706664398; x=1707269198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h93BkgVFUuRnPb2+mPK0buA3QG1DHMAEwTXxdNF0ziU=;
        b=aNTJxrvcyKIlbFO9QnWVR6a+TWysALC9Cw+2lM7dmNMKfzsLgvhBhQpWyJZk2zhMWN
         FJouBrmGUDW/t6GZS7GrKX43W9gCs0wS9je+BQlG7eD7MO21GVrPIDJa/Bt3VB3pBttU
         Rm5qYhXDQMJn8g7V0zQNI7zXyBWo5eiLOZ34E0KTMbhcbP9Y2BWjN+4Gn8WBuxJUKoKQ
         T6gFmTxL1WrI87Ep+pR1nAYtKMB43GoEzjKhYLgJT8n6OTjeJR6iRugAhkeQ+iX1h8/u
         JnIb6+DsKeS5eRXjrGHqGawOIUywux/HEJYIQexkUgvIJV4//d6QIAC4BYM6k7aJIn8p
         JPlw==
X-Gm-Message-State: AOJu0Yy6KwAzjcBXGvc1c7gnnITKoZqL9evjrqhhU4ytw1UU82kiZ4YE
	55oj6wu/Klh94VNY9S4LtnvQrWNC2H2VZk1DoTbS+DOyhjUPjuorvxzY5il5qOXBUoOeHhvxmwr
	AdbHob65gY0eoGH0JROYypXrnc+w=
X-Google-Smtp-Source: AGHT+IEyWGLO3/jvjHtdjXsT7PNhenjAm0xbQRnRwO0JBpDoipIMfct79gY1WGUaNOu7+iZ+11d5WShu6OqllnLtNJ4=
X-Received: by 2002:a67:f90a:0:b0:46b:3fe2:4ae6 with SMTP id
 t10-20020a67f90a000000b0046b3fe24ae6mr93787vsq.27.1706664398424; Tue, 30 Jan
 2024 17:26:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QU2M0e56M0S9ztMDO7eyqFB-p1KgwxJhzwkxt=CuS_PqA@mail.gmail.com>
 <mhng-e7014372-2334-430e-b22e-17227af21bd9@palmer-ri-x1c9a>
In-Reply-To: <mhng-e7014372-2334-430e-b22e-17227af21bd9@palmer-ri-x1c9a>
From: Alistair Francis <alistair23@gmail.com>
Date: Wed, 31 Jan 2024 11:26:11 +1000
Message-ID: <CAKmqyKMAQ1vrf9QnCx17DbKgGTqgDd58y46RLwZvzW4Sk4zyjA@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: stefanha@gmail.com, Alistair Francis <Alistair.Francis@wdc.com>, dbarboza@ventanamicro.com, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com, 
	alex.bennee@linaro.org, eperezma@redhat.com, gmaglione@redhat.com, 
	marcandre.lureau@redhat.com, rjones@redhat.com, sgarzare@redhat.com, 
	imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com, 
	danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, 
	shentey@gmail.com, npiggin@gmail.com, seanjc@google.com, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 10:30=E2=80=AFAM Palmer Dabbelt <palmer@dabbelt.com=
> wrote:
>
> On Tue, 30 Jan 2024 12:28:27 PST (-0800), stefanha@gmail.com wrote:
> > On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote=
:
> >>
> >> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
> >> > Dear QEMU and KVM communities,
> >> > QEMU will apply for the Google Summer of Code and Outreachy internsh=
ip
> >> > programs again this year. Regular contributors can submit project
> >> > ideas that they'd like to mentor by replying to this email before
> >> > January 30th.
> >>
> >> It's the 30th, sorry if this is late but I just saw it today.  +Alista=
ir
> >> and Daniel, as I didn't sync up with anyone about this so not sure if
> >> someone else is looking already (we're not internally).
> >>
> >> > Internship programs
> >> > ---------------------------
> >> > GSoC (https://summerofcode.withgoogle.com/) and Outreachy
> >> > (https://www.outreachy.org/) offer paid open source remote work
> >> > internships to eligible people wishing to participate in open source
> >> > development. QEMU has been part of these internship programs for man=
y
> >> > years. Our mentors have enjoyed helping talented interns make their
> >> > first open source contributions and some former interns continue to
> >> > participate today.
> >> >
> >> > Who can mentor
> >> > ----------------------
> >> > Regular contributors to QEMU and KVM can participate as mentors.
> >> > Mentorship involves about 5 hours of time commitment per week to
> >> > communicate with the intern, review their patches, etc. Time is also
> >> > required during the intern selection phase to communicate with
> >> > applicants. Being a mentor is an opportunity to help someone get
> >> > started in open source development, will give you experience with
> >> > managing a project in a low-stakes environment, and a chance to
> >> > explore interesting technical ideas that you may not have time to
> >> > develop yourself.
> >> >
> >> > How to propose your idea
> >> > ----------------------------------
> >> > Reply to this email with the following project idea template filled =
in:
> >> >
> >> > =3D=3D=3D TITLE =3D=3D=3D
> >> >
> >> > '''Summary:''' Short description of the project
> >> >
> >> > Detailed description of the project that explains the general idea,
> >> > including a list of high-level tasks that will be completed by the
> >> > project, and provides enough background for someone unfamiliar with
> >> > the codebase to do research. Typically 2 or 3 paragraphs.
> >> >
> >> > '''Links:'''
> >> > * Wiki links to relevant material
> >> > * External links to mailing lists or web sites
> >> >
> >> > '''Details:'''
> >> > * Skill level: beginner or intermediate or advanced
> >> > * Language: C/Python/Rust/etc
> >>
> >> I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended a=
nd
> >> might have some tricky parts.  That said it's tripping some people up
> >> and as far as I know nobody's started looking at it, so I figrued I'd
> >> write something up.
> >>
> >> I can try and dig up some more links if folks thing it's interesting,
> >> IIRC there's been a handful of bug reports related to very small loops
> >> that run ~10x slower when vectorized.  Large benchmarks like SPEC have
> >> also shown slowdowns.
> >
> > Hi Palmer,
> > Performance optimization can be challenging for newcomers. I wouldn't
> > recommend it for a GSoC project unless you have time to seed the
> > project idea with specific optimizations to implement based on your
> > experience and profiling. That way the intern has a solid starting
> > point where they can have a few successes before venturing out to do
> > their own performance analysis.
>
> Ya, I agree.  That's part of the reason why I wasn't sure if it's a
> good idea.  At least for this one I think there should be some easy to
> understand performance issue, as the loops that go very slowly consist
> of a small number of instructions and go a lot slower.
>
> I'm actually more worried about this running into a rabbit hole of
> adding new TCG operations or even just having no well defined mappings
> between RVV and AVX, those might make the project really hard.
>
> > Do you have the time to profile and add specifics to the project idea
> > by Feb 21st? If that sounds good to you, I'll add it to the project
> > ideas list and you can add more detailed tasks in the coming weeks.
>
> I can at least dig up some of the examples I ran into, there's been a
> handful filtering in over the last year or so.
>
> This one
> <https://gist.github.com/compnerd/daa7e68f7b4910cb6b27f856e6c2beba>
> still has a much more than 10x slowdown (73ms -> 13s) with
> vectorization, for example.

It's probably worth creating a Gitlab issue for this and adding all of
the examples there. That way we have a single place to store them all

Alistair

>
> > Thanks,
> > Stefan
>

