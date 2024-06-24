Return-Path: <kvm+bounces-20413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC579156E1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 21:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91D0D1C22F3A
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 19:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B46D21A00EF;
	Mon, 24 Jun 2024 19:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="20Ng9izA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902094503C
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 19:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719255788; cv=none; b=MZXwUHgZ3RHAj/ECJn4+UObdDLmNQjeob5iQarFLwPaANpU7zx8yW9SNpgvaPJCqrpHNplQuvlF6zPj3YdpImuV3DmAL6FAR67InGLUHr7IRa/tcWGEM7GOIhWdpwNe+zim3Gv3NhZlQ2I2FvnI3FW64WhN+B+tg3I+8I0Te8tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719255788; c=relaxed/simple;
	bh=nQJx7U4wppzNzHU/CuJjWT7D6ot8GC1fGwOFHaM9x9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K+d4WXEk65t3qZCJWUJLAA22SSM7rQ3rtL03Kut6exDDOK5x5pLEICkS//Bz7eNLiAUBi67/zpol49INFB4H2Tmyikhl1b3pCIN/sgBhWRn42xxVrojeJqEkJB/27Ux5CsMssO9ZGjB87lkzQ0SiEdA9FokHwKcKbV/jHJQA2M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=20Ng9izA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-719a0cd1ba8so3410691a12.1
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 12:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719255787; x=1719860587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o7o/m1CH/dRBIzMMb+h/etu/CnjVEHuwDUi7ZpKVVv0=;
        b=20Ng9izA0F1I67bV94JTpEsoAL6UpG/z4oOrIWJqhL+H3PdpdCjRX3XsCMrgsNF2oP
         vieh/cAap+B4Rz+hyGxfgAKZV9YaXekI1EahgkxG2VsUelKGWWxkrYDzQQxN2KPFJapr
         WHAsoAxI44FNDA0dxpbFSwSotFaUqAu3jJ8i5ycN9nQNki8h6FdP+qmrhbvSSXtuBlua
         cyeo0Xu7o0kAfwu33aP80cd96jaD5JYWKl5CCu92tc2CiKwJc5UG2C48Dt+N2UjbZdbG
         CYyWPtyn+zKPNTz7Sy5NQ+W0hlYnIl0E7mP8cBKCxYg3hfXBLXFqCUeDgIMKPw3hQz+v
         RKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719255787; x=1719860587;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o7o/m1CH/dRBIzMMb+h/etu/CnjVEHuwDUi7ZpKVVv0=;
        b=qwr3hoXTYJbjS3Gg8SIwb82R4f21bP4zbiSAFcH8lV1GICb2fzTHdwNyILsXIL9ixt
         vIg/IVHMmFA2Xw91KgY2cwmrGhzxY1bEqm4pNtq37/t3waY4jJcgZJKwRhRfImtpMoIl
         wF/pRgdlU3tesKqAE+I+hUvTHU/cI8BIioAXAjIDQxYoWIYMK56Un6bEFiwBE4+GVKvF
         OVyuBhKAVGMEb3KsuBUHuMi1gpVxlE3nJ9Rcz2oafi1hzyyHFq4P34llayDDIjEZKjV+
         N0e0uFq0o8TQwT5/cG2xG5NCyBbKthJgKRR1pD+YWrbNq9eodFHRZilam0hlG8bayQQ/
         JNjQ==
X-Forwarded-Encrypted: i=1; AJvYcCW20VQF14OxvMSqvwb4RXHLfAGy0ac7/nocypItXOh4ilTXOamYiI/0CmnOJLD6bTBDBNkEUO2zNnozbwGhzPS5CEyl
X-Gm-Message-State: AOJu0YwYH0zBeRecaKwVPnvfZpr3eo1pL4S0p817BfHr15kV5ATG4R0/
	BoZ2n73/rrEP2MM/YSgfBf12eBpDpu+Wb/y3vz5NGKpDK/muS4bsMnwjSZ0/lrtgMIj4au2JPu1
	oEg==
X-Google-Smtp-Source: AGHT+IHDUra1AWqKgVEmx2cHjqVYae4a6BBkOB3zJOshknnYOHghCXWpyZttMxipDCeP9+v4upkb3HpjkA0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d43:0:b0:71a:1f6f:1d0f with SMTP id
 41be03b00d2f7-71b5c3db10amr16088a12.6.1719255786814; Mon, 24 Jun 2024
 12:03:06 -0700 (PDT)
Date: Mon, 24 Jun 2024 12:03:05 -0700
In-Reply-To: <20240621095319587-0700.eberman@hu-eberman-lv.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com>
 <20240619115135.GE2494510@nvidia.com> <CA+EHjTz_=J+bDpqciaMnNja4uz1Njcpg5NVh_GW2tya-suA7kQ@mail.gmail.com>
 <ZnRMn1ObU8TFrms3@google.com> <CA+EHjTxvOyCqWRMTS3mXHznQtAJzDJLgqdS0Er2GA9FGdxd1vA@mail.gmail.com>
 <4c8b81a0-3a76-4802-875f-f26ff1844955@redhat.com> <CA+EHjTzvjsc4DKsNFA6LVT44YR_1C5A2JhpVSPG=R9ottfu70A@mail.gmail.com>
 <8e9436f2-6ebb-4ce1-a44f-2a941d354e2a@redhat.com> <CA+EHjTzj9nDEG_ANMM3z90b08YRHegiX5ZqgvLihYS2bSyw1KA@mail.gmail.com>
 <20240621095319587-0700.eberman@hu-eberman-lv.qualcomm.com>
Message-ID: <ZnnC6eh-zl16Cxn3@google.com>
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
From: Sean Christopherson <seanjc@google.com>
To: Elliot Berman <quic_eberman@quicinc.com>
Cc: Fuad Tabba <tabba@google.com>, David Hildenbrand <david@redhat.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, maz@kernel.org, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024, Elliot Berman wrote:
> On Fri, Jun 21, 2024 at 11:16:31AM +0100, Fuad Tabba wrote:
> > On Fri, Jun 21, 2024 at 10:10=E2=80=AFAM David Hildenbrand <david@redha=
t.com> wrote:
> > > On 21.06.24 10:54, Fuad Tabba wrote:
> > > > On Fri, Jun 21, 2024 at 9:44=E2=80=AFAM David Hildenbrand <david@re=
dhat.com> wrote:
> > > >>
> > > >>>> Again from that thread, one of most important aspects guest_memf=
d is that VMAs
> > > >>>> are not required.  Stating the obvious, lack of VMAs makes it re=
ally hard to drive
> > > >>>> swap, reclaim, migration, etc. from code that fundamentally oper=
ates on VMAs.
> > > >>>>
> > > >>>>    : More broadly, no VMAs are required.  The lack of stage-1 pa=
ge tables are nice to
> > > >>>>    : have; the lack of VMAs means that guest_memfd isn't playing=
 second fiddle, e.g.
> > > >>>>    : it's not subject to VMA protections, isn't restricted to ho=
st mapping size, etc.
> > > >>>>
> > > >>>> [1] https://lore.kernel.org/all/Zfmpby6i3PfBEcCV@google.com
> > > >>>> [2] https://lore.kernel.org/all/Zg3xF7dTtx6hbmZj@google.com
> > > >>>
> > > >>> I wonder if it might be more productive to also discuss this in o=
ne of
> > > >>> the PUCKs, ahead of LPC, in addition to trying to go over this in=
 LPC.
> > > >>
> > > >> I don't know in  which context you usually discuss that, but I cou=
ld
> > > >> propose that as a topic in the bi-weekly MM meeting.
> > > >>
> > > >> This would, of course, be focused on the bigger MM picture: how to=
 mmap,
> > > >> how how to support huge pages, interaction with page pinning, ... =
So
> > > >> obviously more MM focused once we are in agreement that we want to
> > > >> support shared memory in guest_memfd and how to make that work wit=
h core-mm.
> > > >>
> > > >> Discussing if we want shared memory in guest_memfd might be betetr
> > > >> suited for a different, more CC/KVM specific meeting (likely the "=
PUCKs"
> > > >> mentioned here?).
> > > >
> > > > Sorry, I should have given more context on what a PUCK* is :) It's =
a
> > > > periodic (almost weekly) upstream call for KVM.
> > > >
> > > > [*] https://lore.kernel.org/all/20230512231026.799267-1-seanjc@goog=
le.com/
> > > >
> > > > But yes, having a discussion in one of the mm meetings ahead of LPC
> > > > would also be great. When do these meetings usually take place, to =
try
> > > > to coordinate across timezones.

Let's do the MM meeting.  As evidenced by the responses, it'll be easier to=
 get
KVM folks to join the MM meeting as opposed to other way around.

> > > It's Wednesday, 9:00 - 10:00am PDT (GMT-7) every second week.
> > >
> > > If we're in agreement, we could (assuming there are no other planned
> > > topics) either use the slot next week (June 26) or the following one
> > > (July 10).
> > >
> > > Selfish as I am, I would prefer July 10, because I'll be on vacation
> > > next week and there would be little time to prepare.
> > >
> > > @David R., heads up that this might become a topic ("shared and priva=
te
> > > memory in guest_memfd: mmap, pinning and huge pages"), if people here
> > > agree that this is a direction worth heading.
> >=20
> > Thanks for the invite! Tentatively July 10th works for me, but I'd
> > like to talk to the others who might be interested (pKVM, Gunyah, and
> > others) to see if that works for them. I'll get back to you shortly.
> >=20
>=20
> I'd like to join too, July 10th at that time works for me.

July 10th works for me too.

