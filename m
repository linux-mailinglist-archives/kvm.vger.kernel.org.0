Return-Path: <kvm+bounces-57485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15811B55A96
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 02:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3324AC0390
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 00:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47AD35962;
	Sat, 13 Sep 2025 00:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bGYDJcYF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DA511CA9
	for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757722703; cv=none; b=CDa9nwIfJXZQrYekwsMr83OQHB/TpiAAdorJAsHjADXDy1c/tCLPQcc+qcP3ajmSzppCWh2fKF0vIulbzXXbJbJA8EG/WE31AtXh8VzeuaJ4HJsOR8ILCInNMzZBeLPmm3VUrqKIZlm2X1ttoXHkIwckkYX0j6CkSqJx+EKLV3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757722703; c=relaxed/simple;
	bh=Mh6aGJrEoSKc8SjghJ9/lN7NlH7QvKqYibdt1arxBbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tUlSTRQiKTvImmZAhJ0n35wXxfVs2duQf5QLSR5cw9s3C7LIgglj73QRHJ2vfw9/Ew5xn4CkXgYYvrxc4U0znFLZoV2fkbjhpKHHZQYgcsrSv4vnTqzP7SudTmuiOiCtfeBahWrc2xa5yO/R8GWpRTrqFR++LauZMX85PCKiovw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bGYDJcYF; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24b2d018f92so41555ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 17:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757722700; x=1758327500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oE3G8ORdwUU6jAQHJONdXUYaEO2BnYkTOmxj8OqkFn8=;
        b=bGYDJcYFTB8L6n5vjTI6ouZqtNyQs6JGh00JjAaQv8Ed8aFEVz694UhhtOEkwYI8mV
         6ASzX/HgppuN0Y4ZH3EbnD6hE5XBrTTLD/r1Wowp+0NpTVqfCVTLZdeIdGyoIeelpOJN
         d2j+ZEvar4GAhtHSXlzIpsJysS8WFp6nWY8Vq6G6lZPFjJfD1GdXCvhQ0sRlMN9FTJRp
         IDXhswjxb8OkVGl939tGbOFD92whrxIQTka0cNeUbi/Z3fjgDaVzkqsY92Qjmslt5fzm
         4CTfX1cAqESLcn483nYWvdCReceUV6aB3ZzrJ8frEZeySS6bATxAskN+xj17BLzZjsWf
         LwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722700; x=1758327500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oE3G8ORdwUU6jAQHJONdXUYaEO2BnYkTOmxj8OqkFn8=;
        b=if4AZcVgFB4qienfOroSwTWPiGt21IiIAEAdMQ81oBVHY1Y7EKCZEIs6KHKW6nyWj8
         Opx1EIIv0OGOhG/EiFstVEWeeFjVwvfPW+El1XRCy9BJDF9oGHLMmxcYw5IEuU1owNo7
         W2uVvV/fNGA+T1HySogEagP6SPnbf/hyGeryC334Y22AtSq6cBur1jJEZMsWv2Fl16NI
         8SCe5YMV0fv8PyK3s5MNatvTeLEE3MCjCf7eRKwxrtODCTCagFyTHjDzqUTT1rQK0HO+
         tBdL6CaOHrQJhpKCuRc0k3AE0fMfMUwswBICae2ab4fY4U9bhzJxyPp8qFmJ2kkxv0ZO
         Oegw==
X-Forwarded-Encrypted: i=1; AJvYcCWO8UEJRCasUpVaDbn0MUedVWdIH9Qmc6B/WrLYNAu1Gk9wy96MmplRIh6lJnrXla84a7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHLUz/6dqvxd9ATUcPHnTlz7l+0LWHzZus8s12UpTnidz1Pwdj
	yjUbPFFtfyfBhmjJKL8DjU9ZKqW187U6+4cIdhfgSUPe3iQ9xOU/ksMDxziY/s88t9Lk/oCcoGQ
	AqhQsE48NkbKtnQHi119RDdIsdc74/OEHhcWoaD5O
X-Gm-Gg: ASbGncsi4WVGu+nWZLyyS5WmKQxJLAogU02ve9wKTlB5BrKhp6vSphUyha2qcu9MiXs
	TQUZ+zj/i8JpfMeR+Ri0v5WNkS+XU3dsWZAMS5doYyiuRsigvEdbXn6+eaJLe3b+uzMOMB5KZCY
	3yQsPsqE+3VlUGZTUJl+nb+cpuiyWq2vhdDqbCC8uIn4FvHlLXyrUwyYPySG229cVwHWNUdk1rj
	aF406mDvrqEaxBLwtrLAVl0emqdVaOtxLEIAi2fDpoI
X-Google-Smtp-Source: AGHT+IGzaRnKMgioFkIn9MZTAWIdQlLt1DnmIKhZcaFLkMy9Q3yssinqrzxX1g/AzMrr4tSaSGNncmZBKNCa8ms9HGE=
X-Received: by 2002:a17:903:2343:b0:25b:fba3:afa7 with SMTP id
 d9443c01a7336-260e5f7673cmr1151165ad.10.1757722699324; Fri, 12 Sep 2025
 17:18:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902111951.58315-1-kalyazin@amazon.com> <20250902111951.58315-2-kalyazin@amazon.com>
 <CADrL8HV8+dh4xPv6Da5CR+CwGJwg5uHyNmiVmHhWFJSwy8ChRw@mail.gmail.com>
 <87d562a1-89fe-42a8-aa53-c052acf4c564@amazon.com> <8e55ba3a-e7ae-422a-9c79-11aa0e17eae9@redhat.com>
 <bc26eaf1-9f01-4a65-87a6-1f73fcd00663@amazon.com> <55b727fc-8fd3-4e03-8143-1ed6dcab2781@redhat.com>
In-Reply-To: <55b727fc-8fd3-4e03-8143-1ed6dcab2781@redhat.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 12 Sep 2025 17:18:06 -0700
X-Gm-Features: Ac12FXw70ExrJvBQi4rgyWRbyc1xOL8CupFdmrDzb2GfYcck5L74n4hu4AFRWBE
Message-ID: <CAGtprH8QjeuR90QJ7byxoAPfb30kmUEDhRhzqNZqSpR8y_+z9g@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] KVM: guest_memfd: add generic population via write
To: David Hildenbrand <david@redhat.com>
Cc: kalyazin@amazon.com, James Houghton <jthoughton@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "michael.day@amd.com" <michael.day@amd.com>, 
	"Roy, Patrick" <roypat@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 8:39=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> >>>> What's meant to happen if we do use this for CoCo VMs? I would expec=
t
> >>>> write() to fail, but I don't see why it would (seems like we need/wa=
nt
> >>>> a check that we aren't write()ing to private memory).
> >>>
> >>> I am not so sure that write() should fail even in CoCo VMs if we acce=
ss
> >>> not-yet-prepared pages.  My understanding was that the CoCoisation of
> >>> the memory occurs during "preparation".  But I may be wrong here.
> >>
> >> But how do you handle that a page is actually inaccessible and should
> >> not be touched?
> >>
> >> IOW, with CXL you could crash the host.
> >>
> >> There is likely some state check missing, or it should be restricted t=
o
> >> VM types.
> >
> > Sorry, I'm missing the link between VM types and CXL.  How are they rel=
ated?
>
> I think what you explain below clarifies it.
>
> >
> > My thinking was it is a regular (accessible) page until it is "prepared=
"
> > by the CoCo hardware, which is currently tracked by the up-to-date flag=
,
> > so it is safe to assume that until it is "prepared", it is accessible
> > because it was allocated by filemap_grab_folio() ->
> > filemap_alloc_folio() and hasn't been taken over by the CoCo hardware.
> > What scenario can you see where it doesn't apply as of now?
>
> Thanks for clarifying, see below.
>
> >
> > I am aware of an attempt to remove preparation tracking from
> > guest_memfd, but it is still at an RFC stage AFAIK [1].
> >
> >>
> >> Do we know how this would interact with the direct-map removal?
> >
> > I'm using folio_test_uptodate() to determine if the page has been
> > removed from the direct map as kvm_gmem_mark_prepared() is what
> > currently removes the page from the direct map and marks it as
> > up-to-date.  [2] is a Firecracker feature branch where the two work in
> > combination.
>
> Ah, okay. Yes, I recalled [1] that we wanted to change these semantics
> to be "uptodate: was zeroed", and that preparation handling would be
> essentially handled by the arch backend.

Yes, I think we should not be overloading uptodate flag to be an
indicator of what is private for CoCo guests. Uptodate flag should
just mean zeroed/fresh folio. It's possible that future allocator
backing for huge pages already provides uptodate folios.

If there is no current use case for read/write for CoCo VMs, I think
it makes sense to disable it for now by checking the VM type before
adding further overloading of uptodate flags.

>
> --
> Cheers
>
> David / dhildenb
>
>

