Return-Path: <kvm+bounces-20519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E32E9176B9
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 05:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C76F328138C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 03:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6234471B3A;
	Wed, 26 Jun 2024 03:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1e4lL8ER"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB2C134C6
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 03:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719371969; cv=none; b=JMtabXqUE1Kz1x2AxcF1T+EoE4W1b/yrkGg8oAj8FZbR0U/+J2o0DbzNxnpF6ySNfS5B/QPRMrpMeBZrXQv14gIBl4JCebOIC9JSUrpPYghZdspbqbaER8EZsPIrnp8bJAUAfzW6iOG9IOZjk4lzB18VW8WxGF2oYWJU+FjoVYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719371969; c=relaxed/simple;
	bh=hUXgHF51lPNU1tjmMUrpwQio6r+zn/EwEX1X4j6f3tI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKNx0c+OCBBMBI4lpq/k5FyymH+aObUOaX3Af62518lQ2Mho0DX8Y5NY3YPewQMiYeVQ2TF8Sz72rc0VvLepkHfQiFex5G6Jx04nO3QVbufFgptNGkA80rs3SvLXAaku3KXLsZEomjhPMP2fvOWwdu9hUC5qSpu3yK+BXj2Zah4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1e4lL8ER; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a725282b926so402119566b.0
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 20:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719371966; x=1719976766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcEpi9Xsu+1gTxbES0/HeqU1vgappATrnUAd8kYmA4U=;
        b=1e4lL8ERjSSWLxbphXZaS5DK9ZdqdrG/L9uwfr9tHN2t0G3X+oNY2KabB+uaE6niqb
         6oMvtv58lMEiIDkeObKvjRRRscpbumOer1XZZkCvibHGT4wg7PmTVDpNTGrHu1+2HHfQ
         mJNUz+AXCUCLoHSe3TMw/YtaFxH0L4TQRpJvBwlxtOBGZO/mvJzTeSTvsDaETYzc7qeQ
         F48qY0vRjJV9PdkqAvRml1Z1vwuf68jwxDBQDrDpeLguN/yZ7uyiHy0HP38Zthdiilhv
         5JY5yB6riHFog7A7BKgHkUVjH3nCBtzcNoRLlGtCDSTSLm2i9S7y/+cinMfSOJewCRwH
         kelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719371966; x=1719976766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qcEpi9Xsu+1gTxbES0/HeqU1vgappATrnUAd8kYmA4U=;
        b=GX1VGt/3KukCvkKAKNw42/DBVeiByWv4maz5Pu36SU0yrSiXMRrptqGkpfa4w/l+Jf
         YZOxmU88WZo5qTMgbYLh9dh476i9R+uMo46k5NzFDFDijkbzdQnD35aXI/wS7a177Mj5
         6VQ08xdhSGZ+kopW3WW0bzTTydpOFZ1BMVuJ+y9omgU5isOCGVAV3PU92gi2abzZh6zC
         +PJlFM1qY1ZSTT+YYwxGwZNvC6brCjCp4C5PACTci/8DcKGqc/pGcSizvKqq2e3VA/jJ
         BzvXbhKOAkX/ZNuPgNGJLwmtMQW6XF5DFwSjSuvMQQ0KO+UtPUsHPKwYB/c0yRCEJJAF
         E9EA==
X-Forwarded-Encrypted: i=1; AJvYcCWSTI7TFkkPChPt856/OAiHiV2BlTi5QfvvSiaXhqoS/JPTG4Id7jGqcBsHiLOD1kR1RWcie0/m1V/nvnAKAYK6TvwD
X-Gm-Message-State: AOJu0YzM0gwfbhUwfE8TLnK8CTzBcGhq4woTjqULDfOpgvqK/ChEbmQ8
	Jtjw32FsDaZjDxi1f6tJIyWgrRAJgsq1RrM7GkNMvLeGf/APOExdY6FgMiLoFy8l8rrag9l8r40
	RkJNoq6yLjjbzL9a9S2EnUvlnUAi5XEC0lmpl
X-Google-Smtp-Source: AGHT+IFLY2qZ3ScXikR8P0OWMEtmq1PJfSmSw962tpdr7XOdzhTxVacIeRIFA9/1ZPYRAeIb5P9js56rVkdjLokuTK4=
X-Received: by 2002:a17:906:af97:b0:a6f:5609:9552 with SMTP id
 a640c23a62f3a-a7245c85b6amr586678266b.10.1719371965815; Tue, 25 Jun 2024
 20:19:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com>
 <20240619115135.GE2494510@nvidia.com> <CA+EHjTz_=J+bDpqciaMnNja4uz1Njcpg5NVh_GW2tya-suA7kQ@mail.gmail.com>
 <ZnRMn1ObU8TFrms3@google.com> <CA+EHjTxvOyCqWRMTS3mXHznQtAJzDJLgqdS0Er2GA9FGdxd1vA@mail.gmail.com>
 <4c8b81a0-3a76-4802-875f-f26ff1844955@redhat.com> <CA+EHjTzvjsc4DKsNFA6LVT44YR_1C5A2JhpVSPG=R9ottfu70A@mail.gmail.com>
 <8e9436f2-6ebb-4ce1-a44f-2a941d354e2a@redhat.com> <CA+EHjTzj9nDEG_ANMM3z90b08YRHegiX5ZqgvLihYS2bSyw1KA@mail.gmail.com>
 <20240621095319587-0700.eberman@hu-eberman-lv.qualcomm.com>
 <ZnnC6eh-zl16Cxn3@google.com> <5e14ebf6-2a7f-3828-c3f6-5155026d59ae@google.com>
In-Reply-To: <5e14ebf6-2a7f-3828-c3f6-5155026d59ae@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 25 Jun 2024 20:19:12 -0700
Message-ID: <CAGtprH8VT6B6efy0dC=6cQEf6mpz3dfh2q4gGp2S-m+wNJn5ew@mail.gmail.com>
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
To: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Elliot Berman <quic_eberman@quicinc.com>, 
	Fuad Tabba <tabba@google.com>, David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	John Hubbard <jhubbard@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, Matthew Wilcox <willy@infradead.org>, maz@kernel.org, 
	kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 2:50=E2=80=AFPM David Rientjes <rientjes@google.com=
> wrote:
>
> On Mon, 24 Jun 2024, Sean Christopherson wrote:
>
> > On Fri, Jun 21, 2024, Elliot Berman wrote:
> > > On Fri, Jun 21, 2024 at 11:16:31AM +0100, Fuad Tabba wrote:
> > > > On Fri, Jun 21, 2024 at 10:10=E2=80=AFAM David Hildenbrand <david@r=
edhat.com> wrote:
> > > > > On 21.06.24 10:54, Fuad Tabba wrote:
> > > > > > On Fri, Jun 21, 2024 at 9:44=E2=80=AFAM David Hildenbrand <davi=
d@redhat.com> wrote:
> > > > > >>
> > > > > >>>> Again from that thread, one of most important aspects guest_=
memfd is that VMAs
> > > > > >>>> are not required.  Stating the obvious, lack of VMAs makes i=
t really hard to drive
> > > > > >>>> swap, reclaim, migration, etc. from code that fundamentally =
operates on VMAs.
> > > > > >>>>
> > > > > >>>>    : More broadly, no VMAs are required.  The lack of stage-=
1 page tables are nice to
> > > > > >>>>    : have; the lack of VMAs means that guest_memfd isn't pla=
ying second fiddle, e.g.
> > > > > >>>>    : it's not subject to VMA protections, isn't restricted t=
o host mapping size, etc.
> > > > > >>>>
> > > > > >>>> [1] https://lore.kernel.org/all/Zfmpby6i3PfBEcCV@google.com
> > > > > >>>> [2] https://lore.kernel.org/all/Zg3xF7dTtx6hbmZj@google.com
> > > > > >>>
> > > > > >>> I wonder if it might be more productive to also discuss this =
in one of
> > > > > >>> the PUCKs, ahead of LPC, in addition to trying to go over thi=
s in LPC.
> > > > > >>
> > > > > >> I don't know in  which context you usually discuss that, but I=
 could
> > > > > >> propose that as a topic in the bi-weekly MM meeting.
> > > > > >>
> > > > > >> This would, of course, be focused on the bigger MM picture: ho=
w to mmap,
> > > > > >> how how to support huge pages, interaction with page pinning, =
... So
> > > > > >> obviously more MM focused once we are in agreement that we wan=
t to
> > > > > >> support shared memory in guest_memfd and how to make that work=
 with core-mm.
> > > > > >>
> > > > > >> Discussing if we want shared memory in guest_memfd might be be=
tetr
> > > > > >> suited for a different, more CC/KVM specific meeting (likely t=
he "PUCKs"
> > > > > >> mentioned here?).
> > > > > >
> > > > > > Sorry, I should have given more context on what a PUCK* is :) I=
t's a
> > > > > > periodic (almost weekly) upstream call for KVM.
> > > > > >
> > > > > > [*] https://lore.kernel.org/all/20230512231026.799267-1-seanjc@=
google.com/
> > > > > >
> > > > > > But yes, having a discussion in one of the mm meetings ahead of=
 LPC
> > > > > > would also be great. When do these meetings usually take place,=
 to try
> > > > > > to coordinate across timezones.
> >
> > Let's do the MM meeting.  As evidenced by the responses, it'll be easie=
r to get
> > KVM folks to join the MM meeting as opposed to other way around.
> >
> > > > > It's Wednesday, 9:00 - 10:00am PDT (GMT-7) every second week.
> > > > >
> > > > > If we're in agreement, we could (assuming there are no other plan=
ned
> > > > > topics) either use the slot next week (June 26) or the following =
one
> > > > > (July 10).
> > > > >
> > > > > Selfish as I am, I would prefer July 10, because I'll be on vacat=
ion
> > > > > next week and there would be little time to prepare.
> > > > >
> > > > > @David R., heads up that this might become a topic ("shared and p=
rivate
> > > > > memory in guest_memfd: mmap, pinning and huge pages"), if people =
here
> > > > > agree that this is a direction worth heading.
> > > >
> > > > Thanks for the invite! Tentatively July 10th works for me, but I'd
> > > > like to talk to the others who might be interested (pKVM, Gunyah, a=
nd
> > > > others) to see if that works for them. I'll get back to you shortly=
.
> > > >
> > >
> > > I'd like to join too, July 10th at that time works for me.
> >
> > July 10th works for me too.
> >
>
> Thanks all, and David H for the topic suggestion.  Let's tentatively
> pencil this in for the Wednesday, July 10th instance at 9am PDT and I'll
> follow-up offlist with those will be needed to lead the discussion to mak=
e
> sure we're on track.

I would like to join the call too.

Regards,
Vishal

