Return-Path: <kvm+bounces-31046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C219BF9E4
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 00:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E18A61C21C03
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 23:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3085420D51B;
	Wed,  6 Nov 2024 23:21:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206CE201110;
	Wed,  6 Nov 2024 23:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730935317; cv=none; b=q1+S61mrSKcCMNKfQRTpgrJY7fJ1ogtQGhv1BZcN87xVvcpkXuSFoRma7UCwdiCaXiDvB1SIvSS1C1Z16tyqqBztQcnM7jImhVg6WdMNKGR2jnbXVYn7P3/7P3DtGg6FadIgymG6VTdGjqU8Bo+aPT8BlQnB/sjAqJn9UEPvtoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730935317; c=relaxed/simple;
	bh=zNW1PkJb8oTMYdvD6wQ28czWu/t5wPxE88GgXumzFsI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H721+PDRk5jibvG0DLFw/6ar1+aX645OwaumeFTKKDdCrrepd8pzOrwGu8rJ6PZNbRUlH/3i3AhshVvos/Uk3PSKgH7coBPKvcB+MHH7HJ06F9y+jStegLYR84eHDxwdESM/buPkBWae3WFBeHiTf0ylygzAu//3VMvLxywXiBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e290222fdd0so379216276.2;
        Wed, 06 Nov 2024 15:21:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730935315; x=1731540115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mr7I/DCsBa7zp/nLt0wZ2PXjhJ/fsQvKBF0WA8i4t9c=;
        b=b1zKIl6HQW+e9DuftWdFNi/oiAWvTaPM98O34I/5GfOd8d9DVrvWBq4sSLNskeHcFA
         q9vy2ohHdloX9G6sZSKbCWCeZWaSq93wV9PMGcT+BHh7Kz7EWuCFO8Ops/c/ZN/0EpTA
         0y0iIRAeXyRGEMFbHsF2OusxHo+ItqqNJBRa1WB1t2rXylRZgHcGdCJCZnd0XySPVHTn
         C3pW4uU5cys8qKjmUctbDEEdDW8AvL2M8qSMBVGV0aH+40ovR7ORgMnH/H3D7maVn/Dc
         fiLU7MluQQXI83fyqfj7g35QO4ub0Mo5sA48SNzAS9/ZZRAHtdKSNCj63dIs2SabFmv3
         +FxQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2M+mtLfzr4aa9PmShB9XenWt0EZVCe928u3kgpyE8zeKrJvHUboClwVhtI38jGTZLOXGt@vger.kernel.org, AJvYcCV9NccFOuf2qxqUX+ggBWjjv66SzQBxNat25HZPo6mDcaBfPizfuFwShuWv3deSTqEY/LRasjEC4y0mSr9w@vger.kernel.org, AJvYcCX00M5LiN3Ynzkqti0Cq2K77+23qQnEodQsh3hUM6BcQidZhbsyakFs5rIwg1xWKv8D8NrFwjKh@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7CH5zPvfrZ4z/DSvQnwMI340aXP+6zyTGeWQdnWOCCcsMmqsX
	c0sK0l4r9b5nT7jOkUyeEYQmzsGDfwZjya5ho+puRtyMrEbBF/75Jg9KWw==
X-Google-Smtp-Source: AGHT+IGJjB3lEXI1jdfkqW5oz3WLZbO/nFQitm3Pad7mcqyXbxOEfRo0S6IFYVUUqvugxF9LVRiB9g==
X-Received: by 2002:a05:6902:154f:b0:e29:2f53:9e15 with SMTP id 3f1490d57ef6-e3087b86ed6mr33952137276.29.1730935314959;
        Wed, 06 Nov 2024 15:21:54 -0800 (PST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336f1f204esm7749276.60.2024.11.06.15.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 15:21:54 -0800 (PST)
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e30d212b6b1so352469276.0;
        Wed, 06 Nov 2024 15:21:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVOso+HBQzVXGMQcLv8v+bBwFdb1ziB10sqQrGKBd2k/AsiIp2vFQ8lcMrULApzfL4fWjlE@vger.kernel.org, AJvYcCVdCJoggbYoi6VtV/RB2PKWjO7GfUanNzQ38s4/4mDUPycrelEdUjSZCACpwUmbf2iyLNisX2mCVUqanWV1@vger.kernel.org, AJvYcCW8wy6ijRiwduQTal7X+XQeBcnsU4aPuDz3lHNjMr11pomMYTpJOkXAXxT13syGtEibihMCeQ5d@vger.kernel.org
X-Received: by 2002:a05:690c:c94:b0:6e3:2cfb:9a86 with SMTP id
 00721157ae682-6e9d89970dfmr459496897b3.26.1730935313939; Wed, 06 Nov 2024
 15:21:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyAnSAw34jwWicJl@slm.duckdns.org> <1998a069-50a0-46a2-8420-ebdce7725720@redhat.com>
 <ZyF858Ruj-jgdLLw@slm.duckdns.org> <CABgObfYR6e0XV94USugVOO5XcOfyctr1rAm+ZWJwfu9AHYPtiA@mail.gmail.com>
 <ZyJ3eG8YHeyxqOe_@slm.duckdns.org>
In-Reply-To: <ZyJ3eG8YHeyxqOe_@slm.duckdns.org>
From: Luca Boccassi <bluca@debian.org>
Date: Wed, 6 Nov 2024 23:21:43 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnQk5ttytEKO6pK+VLEhSO9diRAqE9DEUwjXnQkz+Vf7kA@mail.gmail.com>
Message-ID: <CAMw=ZnQk5ttytEKO6pK+VLEhSO9diRAqE9DEUwjXnQkz+Vf7kA@mail.gmail.com>
Subject: Re: cgroup2 freezer and kvm_vm_worker_thread()
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Oct 2024 at 18:14, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Oct 30, 2024 at 01:05:16PM +0100, Paolo Bonzini wrote:
> > On Wed, Oct 30, 2024 at 1:25=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote=
:
> > > > I'm not sure if the KVM worker thread should process signals.  We w=
ant it
> > > > to take the CPU time it uses from the guest, but otherwise it's not=
 running
> > > > on behalf of userspace in the way that io_wq_worker() is.
> > >
> > > I see, so io_wq_worker()'s handle signals only partially. It sets
> > > PF_USER_WORKER which ignores fatal signals, so the only signals which=
 take
> > > effect are STOP/CONT (and friends) which is handled in do_signal_stop=
()
> > > which is also where the cgroup2 freezer is implemented.
> >
> > What about SIGKILL? That's the one that I don't want to have for KVM
> > workers, because they should only stop when the file descriptor is
> > closed.
>
> I don't think SIGKILL does anything for PF_USER_WORKER threads. Those are
> all handled in the fatal: label in kernel/signal.c::get_signal() and the
> function just returns for PF_USER_WORKER threads. I haven't used it mysel=
f
> but looking at io_uring usage, it seems pretty straightforward.
>
> > (Replying to Luca: the kthreads are dropping some internal data
> > structures that KVM had to "de-optimize" to deal with processor bugs.
> > They allow the data structures to be rebuilt in the optimal way using
> > large pages).
> >
> > > Given that the kthreads are tied to user processes, I think it'd be b=
etter
> > > to behave similarly to user tasks as possible in this regard if users=
pace
> > > being able to stop/cont these kthreads are okay.
> >
> > Yes, I totally agree with you on that, I'm just not sure of the best
> > way to do it.
> >
> > I will try keeping the kthread and adding allow_signal(SIGSTOP).  That
> > should allow me to process the SIGSTOP via get_signal().
>
> I *think* you can just copy what io_wq_worker() is doing.
>
> Thanks.
>
> --
> tejun

Hi,

Any update on this? We keep getting reports of this issue, so it would
be great if there was a fix for 6.12. Thanks!

