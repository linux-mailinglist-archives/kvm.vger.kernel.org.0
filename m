Return-Path: <kvm+bounces-31412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D87009C39A3
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FCCB1C21794
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D28A15E5BB;
	Mon, 11 Nov 2024 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TI67Oamc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42F213E02E
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313655; cv=none; b=UYNNhZGjc+v+y1oyack5FQHTgpNIoWU4YNOR5sqVtu5fNo63PClN4C41hYq4DTGjJxwINWtI5WW8PG2kI/huguBOX8yjHCpOGFf7ziCYcgh38aRqyNxCa0gjn6YidyoSmIq6MYgT4lfcVb9tnbU5gEN5LLTCkB637B07yaSQHVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313655; c=relaxed/simple;
	bh=oTlZ4xJedYzVMnb4atsTXhQWqyB2ECChSFkUmRbl3i0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZEBKnYhSFeZ6U/GEEZqqf5D70UJwe1kiFie3ZWLF/Ns6y3P8GG8viXBL+bJOJ0Iv+zWvaLMULugsKHZiyvUm8BXM9h9sH/bGloySBMipp7EsM/Lz/48tzqBTcVPQYLiTUulxAF5J5qQBNmEh0dx2BvYct+KdgQ9B2DETfylMz4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TI67Oamc; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c932b47552so7088a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 00:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731313652; x=1731918452; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oTlZ4xJedYzVMnb4atsTXhQWqyB2ECChSFkUmRbl3i0=;
        b=TI67OamcXjV4gNjI3V8WSJ+Qi/RnUqjsSSGPdstOtQ3XmjZMJofYvaXo3B5Gye5cvv
         T3+xFnbRqNin5XfmByudPGS3gZQBSrX4HdA2sOyFit9BKi/kvUS2ZSv05iQ8tgRnfLE1
         WRsfpkijNgwdyennbNEjpgzTibl6t4tFxNQqhr+5evX5KxL94wDiaEGikbIAf5w+d7o3
         wcujwfFNBe7TeLaKsFva5gS86T1djKDA54SPkOjLQVY0lu7GXV+B9yGV9h059hjgLogq
         xqfL4w5W2p6ZzxfrhjEhNQTjsuTCmqgLuB6KwPniZdp22/L95lv5okr4uWSGj8Wz1DUG
         UgHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731313652; x=1731918452;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oTlZ4xJedYzVMnb4atsTXhQWqyB2ECChSFkUmRbl3i0=;
        b=ireM6y/Qpi9R/V72LUwnk51Y2jd8onjuVeWgZcm0jeSiFrjccI2hhZLyzX3agWkssV
         Mj3Aq17T3vifepymp9x2If6g48wxj7bWqYN1+KteWFKglERUMImTS9ADp2xtrPN64EJf
         oDZkXKiVfhCDWrBOsDZS0/SfaD0C63DmcZYujDSgKOVuzUkggK6Hw2SwrqiG/EGeSo72
         PoihyGRe2h8+fHkfP108tEinHGO3eSLm+s7RbQnK92YfTkFRKTAWo3b74RsyyuhCFF/J
         p1nTSePmIVNpnZOdZxtGELuOpQMiW0reptbThq0visuGPOV/cu6GrTq8IWHwWBpuiNjL
         JNLA==
X-Forwarded-Encrypted: i=1; AJvYcCU57K6A2oXbG66DXTNQ1tba3rLDpMCo1AyKsTfg5LQgEPGxV+lj8iMuGqtGi/MjJ4MAoGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJSmdCnKcA7fpIX6Zvz8upe76yB32HkoKbVMUu/nb3BXrPRfxM
	sHFtb4RXIoMW3JCO3nDBVazPbcNT37gL+5uTfiwDS2rzPgeK88B5NX2p7gEN6WoLCd7C3qtF91l
	pU+L0x1+dT2AOP78/aOp6jGDnKtwPlkuWMq9F
X-Gm-Gg: ASbGncsAaUQu43ngHKDVvSq75MGaEMPOPZgVZ2GsedSobQ2B/9yJTdd8RyaMqK1Z8nA
	ymxklxlnkT2+kERigzbSsrrhXD8QuNA==
X-Google-Smtp-Source: AGHT+IEsLtD4/gOd20okj8nZ9YDzz7v0ASgpzD8te1wJetCOEqNBZw2DVQaobhIGcOfsx2LNSc32Qzn/r3Tf8+lUjc0=
X-Received: by 2002:a50:999e:0:b0:5ca:18ba:4a79 with SMTP id
 4fb4d7f45d1cf-5cf2273ee9fmr135365a12.7.1731313650537; Mon, 11 Nov 2024
 00:27:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com> <20241108170501.GI539304@nvidia.com>
 <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
In-Reply-To: <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 11 Nov 2024 08:26:54 +0000
Message-ID: <CA+EHjTy3kNdg7pfN9HufgibE7qY1S+WdMZfRFRiF5sHtMzo64w@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	rppt@kernel.org, jglisse@redhat.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, simona@ffwll.ch, airlied@gmail.com, 
	pbonzini@redhat.com, seanjc@google.com, willy@infradead.org, 
	jhubbard@nvidia.com, ackerleytng@google.com, vannapurve@google.com, 
	mail@maciej.szmigiero.name, kirill.shutemov@linux.intel.com, 
	quic_eberman@quicinc.com, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk
Content-Type: text/plain; charset="UTF-8"

Hi Jason and David,

On Fri, 8 Nov 2024 at 19:33, David Hildenbrand <david@redhat.com> wrote:
>
> On 08.11.24 18:05, Jason Gunthorpe wrote:
> > On Fri, Nov 08, 2024 at 04:20:30PM +0000, Fuad Tabba wrote:
> >> Some folios, such as hugetlb folios and zone device folios,
> >> require special handling when the folio's reference count reaches
> >> 0, before being freed. Moreover, guest_memfd folios will likely
> >> require special handling to notify it once a folio's reference
> >> count reaches 0, to facilitate shared to private folio conversion
> >> [*]. Currently, each usecase has a dedicated callback when the
> >> folio refcount reaches 0 to that effect. Adding yet more
> >> callbacks is not ideal.
> >
>
> Thanks for having a look!
>
> Replying to clarify some things. Fuad, feel free to add additional
> information.

Thanks for your comments Jason, and for clarifying my cover letter
David. I think David has covered everything, and I'll make sure to
clarify this in the cover letter when I respin.

Cheers,
/fuad

>
> > Honestly, I question this thesis. How complex would it be to have 'yet
> > more callbacks'? Is the challenge really that the mm can't detect when
> > guestmemfd is the owner of the page because the page will be
> > ZONE_NORMAL?
>
> Fuad might have been a bit imprecise here: We don't want an ever growing
> list of checks+callbacks on the page freeing fast path.
>
> This series replaces the two cases we have by a single generic one,
> which is nice independent of guest_memfd I think.
>
> >
> > So the point of this is really to allow ZONE_NORMAL pages to have a
> > per-allocator callback?
>
> To intercept the refcount going to zero independent of any zones or
> magic page types, without as little overhead in the common page freeing
> path.
>
> It can be used to implement custom allocators, like factored out for
> hugetlb in this series. It's not necessarily limited to that, though. It
> can be used as a form of "asynchronous page ref freezing", where you get
> notified once all references are gone.
>
> (I might have another use case with PageOffline, where we want to
> prevent virtio-mem ones of them from getting accidentally leaked into
> the buddy during memory offlining with speculative references --
> virtio_mem_fake_offline_going_offline() contains the interesting bits.
> But I did not look into the dirty details yet, just some thought where
> we'd want to intercept the refcount going to 0.)
>
> >
> > But this is also why I suggested to shift them to ZONE_DEVICE for
> > guestmemfd, because then you get these things for free from the pgmap.
>
> With this series even hugetlb gets it for "free", and hugetlb is not
> quite the nail for the ZONE_DEVICE hammer IMHO :)
>
> For things we can statically set aside early during boot and never
> really want to return to the buddy/another allocator, I would agree that
> static ZONE_DEVICE would have possible.
>
> Whenever the buddy or other allocators are involved, and we might have
> granularity as a handful of pages (e.g., taken from the buddy), getting
> ZONE_DEVICE involved is not a good (or even feasible) approach.
>
> After all, all we want is intercept the refcount going to 0.
>
> --
> Cheers,
>
> David / dhildenb
>

