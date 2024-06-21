Return-Path: <kvm+bounces-20231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA79A912221
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70D50283D02
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519D817167F;
	Fri, 21 Jun 2024 10:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KSEgiZZX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC22171641
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718965031; cv=none; b=Hil59EkmBmopE8fkkOAuyQSIqHSBJvkITTKd4gcjXAqcSwEr+MCEQ0Y256bchNfRRcnuMjSklhpRsUTvbd0mQHKIPwfUUSAu8T33h0MA3zIdhPAlHtdOSUfQOmU2xLq/JFIPv9rcWaClK5D6jTjJj2NiOIKzXFlGo5P39ira34A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718965031; c=relaxed/simple;
	bh=CsfKZUzget9haq+6Takg6rH6auGUUt7PGjnIlAjpGQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YcPxww5eI+Xvsy7sQdz1r0I+rPPDdF9DP/LafvkMaRJ8q0rJprwTMB/ySTde9rVOyZyBjHiRzpSSlntHCQK03MF3zTk5TO8RVD30txCeJX6E8ftiQtYIyInOi5s+prSxC8rY9au/KmHtk0PXjSBI91DLT8ZilLbSeVPTBSfOoIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KSEgiZZX; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-80d6534e302so512480241.0
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 03:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718965029; x=1719569829; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rj+95wbz1y5BU05zQfMwsaSKiMf6+ko9/vdHYSc+ZdM=;
        b=KSEgiZZXARdyYaTvWEsHSNjU7x1N3L7hY0alo5ZrD8folplylG5aiQxJWJ4YoxLVj4
         1UAknfvDv0pv+8k0BFhDs3MS9A7IzE9C75KuKxVVLiJY1pvfbTny04hI1hVEpDOVgUSB
         AE5bU8TWP+RtbOTo+YmMVhcIs8xCYF+D07M/wQfsbQZmRTPzde1POuY/nDW/Ku18Q8vK
         wmp5cK0/ET7TDHJuHkDXl7LaG/pxxuInV+hPeor5nVWwPsfvK7ftbmGlFUuCwQ06KJF1
         5mZe3v8IiORb04QZ8Mh44dFJJ5hRWo7+Ay7exSIJha7DwZE/jymuD2xQMscmW0RXDLwd
         ZXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718965029; x=1719569829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rj+95wbz1y5BU05zQfMwsaSKiMf6+ko9/vdHYSc+ZdM=;
        b=cfvV9ryx+/Wlw3O37UI1ITQ1MvqPp4uL01Y3K8b+i9Aw7mUqV9HbMDh+KHcP3cpy2J
         fBM6V5iZ2EgAPoNJZ/ZvJdN/AgOxtqaZhtP1cYIYZ+hotq1x1rpqJxVI2RPBcCZiFEgI
         Q8wLDD/KslTdFGgACuwgGeKOXvVQeOdDYyka5KBolvC5Pm9l8lH7488RICCU43nRaKlE
         BawM6X+3W7aKlRLhw91aYydwM7d7rK+qcomAlvjWUzidLQAf5FPyVH0A+eKhR2M0gsZs
         +zgI+nfXLoF59pXEQsAWhvlc3P/u80r/k+kcYv4kZyjZfwLcuquhFmRcwhHq/z451Tow
         EASw==
X-Forwarded-Encrypted: i=1; AJvYcCWX2W5dL3AFJgVyhq5xD/FK+Spj97zbe95oeS4JUZ/PLEhZ/41If87My8jcRy+a8wQ8X80O7xxhF75OxHEsv4QSlL2c
X-Gm-Message-State: AOJu0YwCXroUVuc+wHGa0NdujbcVq+E1o2jq27Ifkzb8XmNz70YX+8ps
	O4Zz6q+hzqZi3lphfWU/2V+hCbULMT3JpGdJxHQTM0I7Q8JgQSBh+WkfzPmGl7myF0qX+uO3UJR
	rMy60za4a9eb+lzk35rkEh+FaodxtluwR4NcI
X-Google-Smtp-Source: AGHT+IHuoaKqqqtcNELzZOldYxKUQFZjLBgVA+N0/LZsxsRcIdlqfqhZf/wkj72Q2EJvo+iVzs9z8CPGlwEa9DCk/RA=
X-Received: by 2002:a05:6102:93:b0:48f:3f6d:33 with SMTP id
 ada2fe7eead31-48f3f6d00acmr308656137.11.1718965028513; Fri, 21 Jun 2024
 03:17:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618-exclusive-gup-v1-0-30472a19c5d1@quicinc.com>
 <7fb8cc2c-916a-43e1-9edf-23ed35e42f51@nvidia.com> <14bd145a-039f-4fb9-8598-384d6a051737@redhat.com>
 <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com>
 <20240619115135.GE2494510@nvidia.com> <CA+EHjTz_=J+bDpqciaMnNja4uz1Njcpg5NVh_GW2tya-suA7kQ@mail.gmail.com>
 <ZnRMn1ObU8TFrms3@google.com> <CA+EHjTxvOyCqWRMTS3mXHznQtAJzDJLgqdS0Er2GA9FGdxd1vA@mail.gmail.com>
 <4c8b81a0-3a76-4802-875f-f26ff1844955@redhat.com> <CA+EHjTzvjsc4DKsNFA6LVT44YR_1C5A2JhpVSPG=R9ottfu70A@mail.gmail.com>
 <8e9436f2-6ebb-4ce1-a44f-2a941d354e2a@redhat.com>
In-Reply-To: <8e9436f2-6ebb-4ce1-a44f-2a941d354e2a@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 21 Jun 2024 11:16:31 +0100
Message-ID: <CA+EHjTzj9nDEG_ANMM3z90b08YRHegiX5ZqgvLihYS2bSyw1KA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
To: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>, Sean Christopherson <seanjc@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, 
	Elliot Berman <quic_eberman@quicinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, Matthew Wilcox <willy@infradead.org>, maz@kernel.org, 
	kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, Jun 21, 2024 at 10:10=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 21.06.24 10:54, Fuad Tabba wrote:
> > Hi David,
> >
> > On Fri, Jun 21, 2024 at 9:44=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >>>> Again from that thread, one of most important aspects guest_memfd is=
 that VMAs
> >>>> are not required.  Stating the obvious, lack of VMAs makes it really=
 hard to drive
> >>>> swap, reclaim, migration, etc. from code that fundamentally operates=
 on VMAs.
> >>>>
> >>>>    : More broadly, no VMAs are required.  The lack of stage-1 page t=
ables are nice to
> >>>>    : have; the lack of VMAs means that guest_memfd isn't playing sec=
ond fiddle, e.g.
> >>>>    : it's not subject to VMA protections, isn't restricted to host m=
apping size, etc.
> >>>>
> >>>> [1] https://lore.kernel.org/all/Zfmpby6i3PfBEcCV@google.com
> >>>> [2] https://lore.kernel.org/all/Zg3xF7dTtx6hbmZj@google.com
> >>>
> >>> I wonder if it might be more productive to also discuss this in one o=
f
> >>> the PUCKs, ahead of LPC, in addition to trying to go over this in LPC=
.
> >>
> >> I don't know in  which context you usually discuss that, but I could
> >> propose that as a topic in the bi-weekly MM meeting.
> >>
> >> This would, of course, be focused on the bigger MM picture: how to mma=
p,
> >> how how to support huge pages, interaction with page pinning, ... So
> >> obviously more MM focused once we are in agreement that we want to
> >> support shared memory in guest_memfd and how to make that work with co=
re-mm.
> >>
> >> Discussing if we want shared memory in guest_memfd might be betetr
> >> suited for a different, more CC/KVM specific meeting (likely the "PUCK=
s"
> >> mentioned here?).
> >
> > Sorry, I should have given more context on what a PUCK* is :) It's a
> > periodic (almost weekly) upstream call for KVM.
> >
> > [*] https://lore.kernel.org/all/20230512231026.799267-1-seanjc@google.c=
om/
> >
> > But yes, having a discussion in one of the mm meetings ahead of LPC
> > would also be great. When do these meetings usually take place, to try
> > to coordinate across timezones.
>
> It's Wednesday, 9:00 - 10:00am PDT (GMT-7) every second week.
>
> If we're in agreement, we could (assuming there are no other planned
> topics) either use the slot next week (June 26) or the following one
> (July 10).
>
> Selfish as I am, I would prefer July 10, because I'll be on vacation
> next week and there would be little time to prepare.
>
> @David R., heads up that this might become a topic ("shared and private
> memory in guest_memfd: mmap, pinning and huge pages"), if people here
> agree that this is a direction worth heading.

Thanks for the invite! Tentatively July 10th works for me, but I'd
like to talk to the others who might be interested (pKVM, Gunyah, and
others) to see if that works for them. I'll get back to you shortly.

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

