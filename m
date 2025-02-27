Return-Path: <kvm+bounces-39555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C0C0A47896
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 10:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99852188B338
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8B6227B95;
	Thu, 27 Feb 2025 09:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lL8Y66jD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4341215DBB3
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 09:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740647053; cv=none; b=jzsRM4JwUNQ1XAO2J/zq2rJhLhs9j0cNk7uPnFwFmNxlYyR1df4hoJ0s55te2+ozl+hz6+laJMYoHS/QVaKuvy7+AGwOh1pEd4QGwtjDuyakZOGW2hZw81HKit/EliYAwvlAW9cTe1OIQ0vr7SUoabs+h9nvS6xeVEbdi0SSGQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740647053; c=relaxed/simple;
	bh=9UELi51ewmWIjHiA7B4nlgq4NGyPCYajQTc5lxmZ59Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mdiklzSBroyl+kVnzCAjBAGLmc4pZE7LuGktgfjdU8x6kPsQhGl6fcKmYniNT5/ilL3ck+2zcIFv6ag3cLAauk4iAaYHqcRrFoaamrb8UDgyJo+oZskuC/M9PpGmcMw/CRyXPTsMZADjQhum4je7200ZjBoAzzd7Ky/1PjMmyRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lL8Y66jD; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5ded69e6134so1055986a12.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740647049; x=1741251849; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9UELi51ewmWIjHiA7B4nlgq4NGyPCYajQTc5lxmZ59Y=;
        b=lL8Y66jDOUwgyUv8f42uWlPPXupIM5tWbRmnJmZxpfNDTafi0Vq2Za3VKHogQU4jU0
         bVJZulC4NsjfHUprNjon4vIxfEi++1z10QMQwow1/1KIUS3TuoSYZmVe/ihwjjaBACwT
         ea2+GrwVzJNb9X/u2saiYrRD6zaZ3Y/wvMh6Q//Se6Wkp4kNf6D8iu/+jS5/R2uWKQfj
         fxM9scyFrR/7O9pvpzv0Ti/IJsTkg5bEtTlvgk9rSqfRtdXPT5G2mLZg2fDljogYbFOH
         M8GrXPjrNTYQW9nFzUckyJl2PbaJCfovMqDDxmSVsJGdMqYvjbHWYRe9OBCjiUP6g4Pg
         uXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740647049; x=1741251849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9UELi51ewmWIjHiA7B4nlgq4NGyPCYajQTc5lxmZ59Y=;
        b=H8WdT72XUWxI+RokX3BoclIMcWRVjbucXwMjfLvh4Z54L/zLJqJl2AQr+aLl7WFPGK
         X3+u2468Yjn+7sWp7g0zovOZEhhcvrk6mTK1/vfD4uzt4WHMiqALdGLqub7ZY3GU69IG
         y8kZB0UejlFWBurVILVLIsTYu+Ltaz9yKV5NIgSTJnSvB+bAevL6Ns3qX3EHHkwrhUvU
         ZnWcp+tbsMjQbDYXId10nHsGrO0urEh6Oyzd6a0biUOw8K5XW+oyludB6AX9aNE9BBM9
         fslwUpf8GYm+1OsJSq7egajUi69rpjgkTuF/2p2zwsC10vZHC71G7X4a6jFGj4xKw7U9
         katg==
X-Forwarded-Encrypted: i=1; AJvYcCUYgbKYDK+4t6XxoUbnyHSlOBvi3YRkT6WRUvES7qQp/MDUhqRoHpzjRmZaQhgNkV25fDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOkBCE/pe+LrdQVM/oq2jCGE3UkO3GRXCHnlYryq8a82W96XtT
	9Aq/cXu6G6C3Y8F9f8HWyqbCXrsKaQMYUv67A0WAg0K0sABSvGElRN3GulCQX/BVmGT4ncOqAGF
	HdoTMWmaM0yyfnhgY7+zRoCGPi8BF3HOYMWF0YA==
X-Gm-Gg: ASbGnctq9s9NZqA23eAW3bGZ8TGII3Vua2zc4ADGpbLWsIG/C3f8ZghZpTu3PrseRGx
	9NyUDHz8BQ0Z5yQRX2eo/5xgStGOYZvjAWCbESkctyXlOpzy+YzXv48Q4XMDN2g6N8E4aWyHoRT
	1huVt9VitujmOdtqUXBDpYcnl/IB3hl+BJP6MX
X-Google-Smtp-Source: AGHT+IEL8jwJ7+Gx3xJdJeHDsZTHpaCquM4MW1jp1zytycJLxfwfsjyTlAbBkYEONnTUZIEzwyZgbc0AuBqEo7yItF8=
X-Received: by 2002:a05:6402:26ce:b0:5db:f423:19c5 with SMTP id
 4fb4d7f45d1cf-5e4a0d45ba9mr8937725a12.5.1740647049379; Thu, 27 Feb 2025
 01:04:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218202618.567363-1-sieberf@amazon.com> <20250218202618.567363-4-sieberf@amazon.com>
 <CAKfTPtDx3vVK1ZgBwicTeP82wL=wGOKdxheuBHCBjzM6mSDPOQ@mail.gmail.com> <591b12f8c31264d1b7c7417ed916541196eddd58.camel@amazon.com>
In-Reply-To: <591b12f8c31264d1b7c7417ed916541196eddd58.camel@amazon.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 27 Feb 2025 10:03:58 +0100
X-Gm-Features: AQ5f1JpPsBJHinsoIgFp7A0EoT2EP8A_Ofo81ZptF2TzVMQisI0TKNHfxPF_aj0
Message-ID: <CAKfTPtBoVCnoO+vScNXRqXXWwRBT0MGOqeeAZ4VeAB+pPZVrCw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] sched, x86: Make the scheduler guest unhalted aware
To: "Sieber, Fernand" <sieberf@amazon.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Feb 2025 at 09:27, Sieber, Fernand <sieberf@amazon.com> wrote:
>
> On Thu, 2025-02-27 at 08:34 +0100, Vincent Guittot wrote:
> > On Tue, 18 Feb 2025 at 21:27, Fernand Sieber <sieberf@amazon.com>
> > wrote:
> > >
> > > With guest hlt/mwait/pause pass through, the scheduler has no
> > > visibility into
> > > real vCPU activity as it sees them all 100% active. As such, load
> > > balancing
> > > cannot make informed decisions on where it is preferrable to
> > > collocate
> > > tasks when necessary. I.e as far as the load balancer is concerned,
> > > a
> > > halted vCPU and an idle polling vCPU look exactly the same so it
> > > may decide
> > > that either should be preempted when in reality it would be
> > > preferrable to
> > > preempt the idle one.
> > >
> > > This commits enlightens the scheduler to real guest activity in
> > > this
> > > situation. Leveraging gtime unhalted, it adds a hook for kvm to
> > > communicate
> > > to the scheduler the duration that a vCPU spends halted. This is
> > > then used in
> > > PELT accounting to discount it from real activity. This results in
> > > better
> > > placement and overall steal time reduction.
> >
> > NAK, PELT account for time spent by se on the CPU.
>
> I was essentially aiming to adjust this concept to "PELT account for
> the time spent by se *unhalted* on the CPU". Would such an adjustments
> of the definition cause problems?

Yes, It's not in the scope of PELT to know that a se is a vcpu and if
this vcpu is halted or not

>
> > If your thread/vcpu doesn't do anything but burn cycles, find another
> > way to report thatto the host
>
> The main advantage of hooking into PELT is that it means that load
> balancing will just work out of the box as it immediately adjusts the
> sched_group util/load/runnable values.
>
> It may be possible to scope down my change to load balancing without
> touching PELT if that is not viable. For example instead of using PELT
> we could potentially adjust the calculation of sgs->avg_load in
> update_sg_lb_stats for overloaded groups to include a correcting factor
> based on recent halted cycles of the CPU. The comparison of two
> overloaded groups would then favor pulling tasks on the one that has
> the most halted cycles. This approach is more scoped down as it doesn't
> change the classification of scheduling groups, instead it just changes
> how overloaded groups are compared. I would need to prototype to see if
> it works.

This is not better than PELT

>
> Let me know if this would go in the right direction or if you have any
> other ideas of alternate options?

The below should give you some insights

https://lore.kernel.org/kvm/CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com/

I don't think that you need any change in the scheduler. Use the
current public scheduler interfaces to adjust the priority of your
vcpu. As an example switching your thread to SCHED_IDLE is a good way
to say that your thread has a very low priority and the scheduler is
able to handle such information

>
> > Furthermore this breaks all the hierarchy dependency
>
> I am not understanding the meaning of this comment, could you please
> provide more details?
>
> >
> > >
> > > This initial implementation assumes that non-idle CPUs are ticking
> > > as it
> > > hooks the unhalted time the PELT decaying load accounting. As such
> > > it
> > > doesn't work well if PELT is updated infrequenly with large chunks
> > > of
> > > halted time. This is not a fundamental limitation but more complex
> > > accounting is needed to generalize the use case to nohz full.
>
>
>
> Amazon Development Centre (South Africa) (Proprietary) Limited
> 29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
> Registration Number: 2004 / 034463 / 07

