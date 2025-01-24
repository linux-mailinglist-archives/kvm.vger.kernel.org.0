Return-Path: <kvm+bounces-36546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 319D1A1B982
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B8CF3A38C7
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 15:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39932156257;
	Fri, 24 Jan 2025 15:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="clPnZthq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D8B111AD
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 15:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737733009; cv=none; b=A/t4nZyOEbkSsC7N9FJnmkDlr62VDBZ8EXEqO2AsguTSoz+zVGdNn6nvqsFhopnD+NpJZx3rILRACYpMRmYCrQb+JW5X2oZveDN7P1v8YSrfG+2Dkta4f2Se+Hym2yy1fmv1guoo4yCwLxGWFA2UHwMpArZVB1Fr4U8RUcacjvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737733009; c=relaxed/simple;
	bh=fG4aDY8zhpKCiKdQRcXqyteAruEVD1PJikGp4m2uDTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=me2mrI0IpFt7mKcROluW6BtVBnnGIXf6iFpVtrWcegp65U+oiLuvLln6cSOLbEzpLt9Hd/kkUnek7xr4SLt+KPwnzCKY7RykJLPsh2thK5W0wkN5ORIkAW2k/LRGp7ieiamIFteZZuMezi1WM/2n0DXAjK2B+EffPbJO/vJxOLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=clPnZthq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9b9981f1so6312941a91.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 07:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737733007; x=1738337807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zySajsS8cwcbLlH1pRl9LatQbg5W2rfh2JDwbVXk9PM=;
        b=clPnZthqLFi2ldlq9M2NhptRr2pi05VZzl44/dV3an44J802R8mVD1GAaSuyiKKKFA
         V6JAJb/VT8nb6QY5XRSSobq/Zi24pV8j/+xc8p5Yx3eucilw+f+ybBYE7YRUNUDNcz1e
         +Lwi9Jm1SizRKWF2jX3GeNER7nVy/T0ZMDd1Pb+IhqgDA8+EmJFzp1qvR5h1PH9cxbts
         FSAqCRprYbqQJG7TEpmqhUaO0XP4VTgYyKFOhbhsj+nHHeMZAidO2b7jtUlkTfIXsjwL
         KrEQsiPFA8opZU8MJk/gwck7aJnTD8ndDiGgznftSp5/f0zEzzVT/X0b2cGm8/sb9/+W
         jGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737733007; x=1738337807;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zySajsS8cwcbLlH1pRl9LatQbg5W2rfh2JDwbVXk9PM=;
        b=ZeaqITIP3dFQtIqFtzY+FdDjpXLT+c5g0dc2TdwqPo4n6gd2Dxm/qVFO1upjoHhZW8
         KQaQBf4Iq6iQPceUf+/wnirJVViU1UwlAgHcwUpQVdrDMWV+m8YWCeK6upnBoExFZZxm
         Tl10WCmnZrRLCtqojZ6ZEvrZEk3+P+f8h5PZ/IIb3/3aV1xbbpfC87fs8f7G6tR0ZB/F
         Xv2DVLtgcIg5i3Y2S+t/DXI8M/+bpJxZBdF09zQ4QLNMsxnhCTdibt8NAU/f21/2Wn01
         2Zo92kK1/DDtLAYL7Ls4FwqQdq92tkusGOnUPnnjU+YXCynn8Oye5OwDhZOi+yi8/raN
         HjMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMOXQq6p7DUE58x/LTntdjXBhiBsUwcfLzhpWOUwemNvT9+gMZgLSFqJolB6NUKUwNy3o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1jUIRZFRNJdWchlKneVXgJG2fRK1rnVjOWXt04sNfmpcESgPv
	jIGfh7Gwxk/2xAsA7Zzog7NH15RoffILA/CRIu7yBSUwA+JYD4LBoneGiI8GPYtB+2zeIfmgZR+
	WMA==
X-Google-Smtp-Source: AGHT+IGwDamLsIG5SMyUkpnBBffaQBPnLO+znhjCx6dxksry2Nng62jhf6tyHwFuU1xlMzJrpqs4p8rDJ7I=
X-Received: from pfbcg7.prod.google.com ([2002:a05:6a00:2907:b0:728:aad0:33a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18a7:b0:725:f376:f4ff
 with SMTP id d2e1a72fcca58-72dafa46e92mr39729312b3a.13.1737733007188; Fri, 24
 Jan 2025 07:36:47 -0800 (PST)
Date: Fri, 24 Jan 2025 07:36:45 -0800
In-Reply-To: <pfx63yk5euw6zsjmmpuetfuhhk7jcann3trlirp6y5u26lljn7@mtbwoswzoae3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain>
 <Z4qYrXJ4YtvpNztT@google.com> <pfx63yk5euw6zsjmmpuetfuhhk7jcann3trlirp6y5u26lljn7@mtbwoswzoae3>
Message-ID: <Z5OzjYqOVz7nrnJ1@google.com>
Subject: Re: [bug report] KVM: x86: Unify TSC logic (sleeping in atomic?)
From: Sean Christopherson <seanjc@google.com>
To: "Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Dan Carpenter <dan.carpenter@linaro.org>, kvm@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2025, Michal Koutn=C3=BD wrote:
> On Fri, Jan 17, 2025 at 09:51:41AM -0800, Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > That's not the problematic commit.  This popped because commit 8722903c=
bb8f
> > ("sched: Define sched_clock_irqtime as static key") in the tip tree tur=
ned
> > sched_clock_irqtime into a static key (it was a simple "int").
> >=20
> > https://lore.kernel.org/all/20250103022409.2544-2-laoar.shao@gmail.com
>=20
> Thanks for the analysis, it's spot on. What a bad luck.
>=20
> Is there a precedent for static key switching in non-preemptible
> contexts?

Abuse static_key_deferred to push the patching to a workqueue?

> More generally, why does KVM do this tsc check in vcpu_load?=20

The logic triggers when a vCPU migrates to a different pCPU.  The code dete=
cts
that the case where TSC is inconsistent between pCPUs, and would cause time=
 to go
backwards from the guest's perspective.  E.g. TSC =3D X on CPU0, migrate to=
 CPU1
where TSC =3D X - Y.

> Shouldn't possible unstability for that cpu be already checked and decide=
d at
> boot (regardless of KVM)? (Unless unstability itself is not stable proper=
ty.
> Which means any previously measured IRQ times are skewed.)

This isn't a problem that's unique to KVM.  The clocksource watchdog also m=
arks
TSC unstable from non-preemptible context (presumably from IRQ context?)

  clocksource_watchdog()
  |
  -> spin_lock(&watchdog_lock);
     |
     -> __clocksource_unstable()
        |
        -> clocksource.mark_unstable() =3D=3D tsc_cs_mark_unstable()
           |
           -> disable_sched_clock_irqtime()

Uh, and sched_clock_register() toggles the static key on with IRQs disabled=
...

	/* Cannot register a sched_clock with interrupts on */
	local_irq_save(flags);

	...

	/* Enable IRQ time accounting if we have a fast enough sched_clock() */
	if (irqtime > 0 || (irqtime =3D=3D -1 && rate >=3D 1000000))
		enable_sched_clock_irqtime();

	local_irq_restore(flags);

> (Or a third option to revert the static-keyness if Yafang doesn't have

Given there are issues all over the place, either a revert or a generic fix=
.

