Return-Path: <kvm+bounces-32035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CEF9D1C22
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 01:11:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55A2B282601
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 00:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86FFA33DF;
	Tue, 19 Nov 2024 00:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eGh1Jpns"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8377139B
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 00:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731975056; cv=none; b=Jq2NUrs9XpkY8ZyIqh+vz9erpiCByga5RfeliKZCUPc8ux+k3WqNEBFOECOq3Ojikxforh0EvTWpTACyvITMttF7mQG1+GAc/Z8a9IpzzA/z3gxlTQGE6YdD+OE+rk9biccHRHA80LiD4qSwoWCG2NINDlDcQxIxInkjZfdmy+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731975056; c=relaxed/simple;
	bh=/YOZGgqJDcZihtUs5OKVeC2EjXTpTsHoe22/h/yFDq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oqdKK8FgXSKpMElWfRuYBjh3b8QXw7sC/rqOEgcifM4y7OSBS0snHulFVPD3jZCXgpj0K6JcmUjFiiloWXnOKn33frgkUzWIkSw9/v8A5FFArJUIH/bbDe4fmVjofZfQcrI2Y8tbvsKBhXnahbhdtiFm4okPnjwMSwcokSKmTWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eGh1Jpns; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4315abed18aso22354265e9.2
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 16:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731975053; x=1732579853; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eb+g06ME6NnsPxsqVhQ7KX0aLm3BCbxT0dAE0bAEBmM=;
        b=eGh1Jpnsc0cbzecpWleR2Fx4tGG3v8KqQRWtIXrYqw+xte+yiEQuJqByySDlKrVU0B
         FCpWehaRXjgWNj3QK4H11Wi2ryYysAzjf5K/0vwYuZpGXB2LgJqoJltARfYRU+t+7BXG
         qSt/dh3iJLReHH0zs5oySD/UUYktHYfIsN1LXZ2Q/6C0pgQCelwXEH5IW0hdiFI56VKE
         ytTmNKwkjB0sEcKgm6mJswhhMplOOT0GvCebh9eM1ruzzmAPJb1b1gf1tDJ2AGVMewxl
         sXCo5XkPSK9VbSMdep+m6uaJsMK14l8murgmQmvG962jTNHPWXTInkv/qlwA/mup1qts
         9rHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731975053; x=1732579853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eb+g06ME6NnsPxsqVhQ7KX0aLm3BCbxT0dAE0bAEBmM=;
        b=tFoKiV0HqqHeBhm/A6weL5ZhNlDP6fNqPrQaJT0ZOFOx6ThfAaSaH07ZqzWZ3MtiWj
         lnW9vRXX2fKPvGuedGlx2FoXZXKayG8cD6OyZa8cBt7/JbHet4A/qWOrxsfaFz8paE7o
         ogNHhlzHkmnw0O7oJ01PMUtepkTQjo5WdFtpw83iQX34sH1KgObJxeAKd1mzKVNXwTiq
         TVmz3xqrxz5i3+Dm7oSYFzaKONETkG4erURMpwVgGh3yIAhdCjeHMYhg0tjo3ybyRlsF
         FOak0/E8WnaITq5Y7EqGQzVfW4d/H7iwtDkBIZfy8dW0ExtIjOZCP3omCXQCjgPkf8Xh
         gCFg==
X-Forwarded-Encrypted: i=1; AJvYcCWREoBW++hBXByL376HbLTWN5IDNv9gn9EkaONdDRHia6cqJkBfHdK81uUwssoo5Gw/v8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZEXEBeFOfwO2oBAu8p8WqcDuEgh75bu+61PThW435SW5haBBb
	n1wQjecTwoRJSfzMotgLnGG2G/gFqNXIBSuTHj3LNv1L34SyCk0sp6zXqr8WoJmW6jpsl6RhdrL
	YL5BTLyzEnDRH9drF0YVaD6cPzeP9qCbbIGlH
X-Google-Smtp-Source: AGHT+IHJrEauu2TZnNRCpiWqNaLGAkKCuMY11iqqb6uC53aKSjXLofanXihMuG4HLnUbNhVoLX9Z3YFzoq3LgU4C9F4=
X-Received: by 2002:a05:600c:4f02:b0:432:7c08:d11e with SMTP id
 5b1f17b1804b1-432df71b1c7mr97321475e9.1.1731975053136; Mon, 18 Nov 2024
 16:10:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118043745.1857272-1-suleiman@google.com> <20241118143311.3ca94405@gandalf.local.home>
In-Reply-To: <20241118143311.3ca94405@gandalf.local.home>
From: Joel Fernandes <joelaf@google.com>
Date: Tue, 19 Nov 2024 09:10:41 +0900
Message-ID: <CAJWu+oqR=SMKHd1EqvRm3nvz7e1r4e7Rj76hJ8jhDQQkNVo0ig@mail.gmail.com>
Subject: Re: [PATCH v3] sched: Don't try to catch up excess steal time.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Suleiman Souhlal <suleiman@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com, 
	Srikar Dronamraju <srikar@linux.ibm.com>, David Woodhouse <dwmw2@infradead.org>, vineethrp@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 4:32=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Mon, 18 Nov 2024 13:37:45 +0900
> Suleiman Souhlal <suleiman@google.com> wrote:
>
> > When steal time exceeds the measured delta when updating clock_task, we
> > currently try to catch up the excess in future updates.
> > However, this results in inaccurate run times for the future things usi=
ng
> > clock_task, in some situations, as they end up getting additional steal
> > time that did not actually happen.
> > This is because there is a window between reading the elapsed time in
> > update_rq_clock() and sampling the steal time in update_rq_clock_task()=
.
> > If the VCPU gets preempted between those two points, any additional
> > steal time is accounted to the outgoing task even though the calculated
> > delta did not actually contain any of that "stolen" time.
> > When this race happens, we can end up with steal time that exceeds the
> > calculated delta, and the previous code would try to catch up that exce=
ss
> > steal time in future clock updates, which is given to the next,
> > incoming task, even though it did not actually have any time stolen.
> >
> > This behavior is particularly bad when steal time can be very long,
> > which we've seen when trying to extend steal time to contain the durati=
on
> > that the host was suspended [0]. When this happens, clock_task stays
> > frozen, during which the running task stays running for the whole
> > duration, since its run time doesn't increase.
> > However the race can happen even under normal operation.
> >
> > Ideally we would read the elapsed cpu time and the steal time atomicall=
y,
> > to prevent this race from happening in the first place, but doing so
> > is non-trivial.
> >
> > Since the time between those two points isn't otherwise accounted anywh=
ere,
> > neither to the outgoing task nor the incoming task (because the "end of
> > outgoing task" and "start of incoming task" timestamps are the same),
> > I would argue that the right thing to do is to simply drop any excess s=
teal
> > time, in order to prevent these issues.
> >
> > [0] https://lore.kernel.org/kvm/20240820043543.837914-1-suleiman@google=
.com/
> >
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > ---
> > v3:
> > - Reword commit message.
> > - Revert back to v1 code, since it's more understandable.
> >
> > v2: https://lore.kernel.org/lkml/20240911111522.1110074-1-suleiman@goog=
le.com
> > - Slightly changed to simply moving one line up instead of adding
> >   new variable.
> >
> > v1: https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@goog=
le.com
> > ---
> >  kernel/sched/core.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index a1c353a62c56..13f70316ef39 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -766,13 +766,15 @@ static void update_rq_clock_task(struct rq *rq, s=
64 delta)
> >  #endif
> >  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> >       if (static_key_false((&paravirt_steal_rq_enabled))) {
> > -             steal =3D paravirt_steal_clock(cpu_of(rq));
> > +             u64 prev_steal;
> > +
> > +             steal =3D prev_steal =3D paravirt_steal_clock(cpu_of(rq))=
;
> >               steal -=3D rq->prev_steal_time_rq;
> >
> >               if (unlikely(steal > delta))
> >                       steal =3D delta;
>
> So is the problem just the above if statement? That is, delta is already
> calculated, but if we get interrupted by the host before steal is
> calculated and the time then becomes greater than delta, the time
> difference between delta and steal gets pushed off to the next task, righ=
t?

Pretty much.. the steal being capped to delta means the rest of the
steal is pushed off to the future. Instead he discards the remaining
steal after this patch.

Thanks


Joel

