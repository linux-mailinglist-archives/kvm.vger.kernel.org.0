Return-Path: <kvm+bounces-25223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AECDE961C66
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 04:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DECEE1C22FCE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 02:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F7412EBD6;
	Wed, 28 Aug 2024 02:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AO++8kg9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59A6482EB
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 02:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724813729; cv=none; b=R5zjO4AY+6hX/FE8EwxluTRhpbaiGtO4Xmo584hnT0Bdq5cdTcHyHu8PeZsa9yzWd6FG1ugfq1eG1QSjPx79k0rYq6sSh9rSVAhdy0HoCWAeOZLGzj5v69cAVLQOmfsp2QctykMIcgHPU5ABGA/zmefIAdcOSYv7nmSiGui3iIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724813729; c=relaxed/simple;
	bh=pJEgJeTQwVs5vx66mBxar+N9b1m9N3pdSmF9ogkPcWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t6y3rS7AxgNMLS+5efyo/IXLcon8EhplZkdZ1i/MFUvNJj9ZxuAY/AbQ57wxdEl3nZSL/CTXEedvlVDcnWS6mRCoz50oOQkASJ5Aa4X/ihDxn41Y3W3UTJEHGpdIF6IBfuRZF3TaCtGRPuhdXpsTmA+vnJrdR5c8eY8Kt0j49Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AO++8kg9; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-39d3ad05f8eso60165ab.1
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 19:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724813727; x=1725418527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fLdemAYHyaRjrEjX/PyMbIb7irsWTXj+jd0WtbNIYg=;
        b=AO++8kg9U+gLr3sIFi2wteqpHAY1ALP6PCclv+9wmfMKrxKulGggBxYLS5ElJ68zhI
         M/8x7zPk/pVKvDvu40BO64rScUss26fZcJUykyNNST6JrHUwmEMgyPLU9CWjAm/GWpM4
         DqYyaf5eSQF0Xt/Uljw1ffsDQg/n+vf5bmR1DqrK7z0zJwvnB1RZ+HHby5Svr1/sjZCz
         fa0LhcqlwZ4d1w2TetDbKzoxGHPx6JD+rTi9AFLnAiUnEG2r0H2OC4LSbl5EU7LEw+U6
         TfkfG/5yOfuY7gjoyTnJskSpoTUCHzLmGCl13vdYb5yNCzGPDAyMwbB52XR58zIhUTZB
         tEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724813727; x=1725418527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9fLdemAYHyaRjrEjX/PyMbIb7irsWTXj+jd0WtbNIYg=;
        b=rtYeoYRU5nm8VPCNUDXYysr74xNjvVBfVpwPctdF53YsWjqHHhlmMLHuukOWMp7og2
         oG4gE9GeVyXIGb1h9eC5BC1he+AxZTey6s4RxqhyqeWeUHPl/9zscDJzhS1FJ9D5/1mm
         OSOSaHIJwhqwXByzb649pXByGNZIV8qspoJqltB1+YQwGOkA21m9u5ZqGrvCZraPI6Yk
         vCavqRTvaszWNb8/A88QOW1NqeWFO73cuxGNTQySVpbW+Yi89YFot0q5azfdOKOWKQ/d
         wItOHEVtJwu3lFe/rfNMTlgR7V+P+FSJgh+lkuiBJ2VC78+52KaUbmBOYGzPPByXkMWY
         aOyw==
X-Forwarded-Encrypted: i=1; AJvYcCWsgbT1E79gXfYebVQFk1/vnsPebpW3co3/Roh6cqkYN+zlrgJ5605+eO7OAvakVL1aXwc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx14lYDndgZJkm+qpsVIxPZUgIh5hug0EytB8BtnCADKkMQxiWk
	Zmeb1Xbjqmrqjbl675IKTqCrJ7ZlRQS4Phk7TNZfppj01Jb2a+yoRNScH3sUjWUDflT7VXGDYDM
	jqNDklEFBjoqDPs0jezL7tlx/N2gwHF8nwpDY
X-Google-Smtp-Source: AGHT+IHxQMCM8ygBU1B/o9noyTf8DTeb1f+v9mIev+ysxWN/9s4XOVSoquTlsvNsVPNlXOyOwHBmh6KJiTTKZW7YvPA=
X-Received: by 2002:a92:cd8b:0:b0:39d:24d4:708c with SMTP id
 e9e14a558f8ab-39f320a721emr1116765ab.7.1724813726715; Tue, 27 Aug 2024
 19:55:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826071641.2691374-1-manojvishy@google.com>
 <20240826110447.6522e0a7.alex.williamson@redhat.com> <20240826231749.GM3773488@nvidia.com>
 <a0cfcbe4-cab4-48b2-bcba-0bc28d97e996@arm.com>
In-Reply-To: <a0cfcbe4-cab4-48b2-bcba-0bc28d97e996@arm.com>
From: Manoj Vishwanathan <manojvishy@google.com>
Date: Tue, 27 Aug 2024 19:55:15 -0700
Message-ID: <CA+M8utNVshFNJyrw1PcrVSJbFbDqPRkM_PjpF8CGy7Nf8pJRjQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] vfio/iommu: Flag to allow userspace to set DMA
 buffers system cacheable
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Dillow <dillow@google.com>, David Decotigny <decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 10:31=E2=80=AFAM Robin Murphy <robin.murphy@arm.com=
> wrote:
>
> On 27/08/2024 12:17 am, Jason Gunthorpe wrote:
> > On Mon, Aug 26, 2024 at 11:04:47AM -0600, Alex Williamson wrote:
> >> On Mon, 26 Aug 2024 07:16:37 +0000
> >> Manoj Vishwanathan <manojvishy@google.com> wrote:
> >>
> >>> Hi maintainers,
> >>>
> >>> This RFC patch introduces the ability for userspace to control whethe=
r
> >>> device (DMA) buffers are marked as cacheable, enabling them to utiliz=
e
> >>> the system-level cache.
> >>>
> >>> The specific changes made in this patch are:
> >>>
> >>> * Introduce a new flag in `include/linux/iommu.h`:
> >>>      * `IOMMU_SYS_CACHE` -  Indicates if the associated page should b=
e cached in the system's cache hierarchy.
> >>> * Add `VFIO_DMA_MAP_FLAG_SYS_CACHE` to `include/uapi/linux/vfio.h`:
> >
> > You'll need a much better description of what this is supposed to do
> > when you resend it.
> >
Thanks Jason, I will add more information before re-sending the patch.
> > IOMMU_CACHE already largely means that pages should be cached.
> >
> > So I don't know what ARM's "INC_OCACHE" actually is doing. Causing
> > writes to land in a cache somewhere in hierarchy? Something platform
> > specific?
>
> Kinda both - the Inner Non-Cacheable attribute means it's still
> fundamentally non-snooping and non-coherent with CPU caches, but the
> Outer Write-back Write-allocate attribute can still control allocation
> in a system cache downstream of the point of coherency if the platform
> is built with such a thing (it's not overly common).
>
> However, as you point out, this is in direct conflict with the Inner
> Write-back Write-allocate attribute implied by the IOMMU_CACHE which
> VFIO adds in further down in vfio_iommu_map(). Plus the way it's
> actually implemented in patch #2, IOMMU_CACHE still takes precedence and
> would lead to this new value being completely ignored, so there's a lot
> which smells suspicious here...
>
Thanks for your quick feedback.
I tested this with a 5.15-based kernel and applied the patch to get
early results.
I see the issue with IOMMU_CACHE overriding IOMMU_SYS_CACHE in patch #2.
This would likely be a problem on 5.15 as well, and I need to
investigate further
to understand how we observed better performance in our tests
while trying to exercise the system cache.
Let me do some more testing and get back.
Thanks,
Manoj
> Thanks,
> Robin.
>
> > I have no idea. By your description it sounds similar to the
> > x86 data placement stuff, whatever that was called, and the more
> > modern TPH approach.
> >
> > Jason

