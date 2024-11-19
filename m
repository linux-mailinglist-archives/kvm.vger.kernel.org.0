Return-Path: <kvm+bounces-32037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B1A9D1C33
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 01:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30E0B281EF1
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 00:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D009101EE;
	Tue, 19 Nov 2024 00:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gGsORpEH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A0B9475
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 00:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731975755; cv=none; b=hEoP+Ytuh+K4atOTvn+Ae9jgupM19gjutsLidJTQGTQXE50nG8RYRP6pQ/rLWiAvvAVWfeNOjJwRhYqgzipiUaZkYRPY2glGROJQM7xnH86I7PklHD/6HYr7LQVW22dPfMLh4WczoASqv9cAcbo8lZ1OuZiYJph3T9lKsA8Ne4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731975755; c=relaxed/simple;
	bh=X+LfutNmkZLBYCMm3jRilySxLsginSJcHgXDLjyD2hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tNkqmTgAvkwq9PoqmQ/ZdlMdsObjeGrIoANXYpYZ9UIeZS7vHtmxS5Oh+LEvL8mvznt/Q9cmMXGoPB0rBNUkMxxZL5z5kX05ilc4yi7WqJQ0QEIiP+I5gd4oV1aWV1APv/oJ80eNrZFE1Pe/Ec/sw/P8/BzpMy4n+QaX7a6l7Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gGsORpEH; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso37290545e9.0
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 16:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731975752; x=1732580552; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSKTT9+CZJoWXlp0m+3yVsM3zVA66cqs91qqjLrHy/0=;
        b=gGsORpEHseiSX5FpSJkSkxnXPvJpa1xjF2a9srECwldhvF+B0bO25t86CG5WNHXEPO
         D4lUTyWTc2VSR6hmSa8qr5Ew3L0bNv1/TNpMvU34oW/sNYbSoXP3zDqdVhxdOF8QesBm
         Ph98lxaJrBbOAseZQRsAD4b36pPzjkvvjSc4i84GYhmLf9rdNIxLqrHI7uiKUR1o07MO
         xpRub+R9dWnqH9bWCMukS7qoGnupkW00I4xk9V3dAV+YXqISJYT9T3fxpukXZL64OOIV
         KlrLU9sWOVRi9MjQC9ZKn/6tI81KC0QTskfHuo8V2A9uWrMuKrEoJ8th8BpsiAu8uJHh
         /KzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731975752; x=1732580552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VSKTT9+CZJoWXlp0m+3yVsM3zVA66cqs91qqjLrHy/0=;
        b=JuC+6sMx7nPYDmZ77xNeM0J7tM7zCbeHTLee2mVBdw7k8CvjjzcHw3ZMBqU/o/DsQC
         6m+zPP3EAcyKAYVLdP6Umb+gfkCZ9zH1hlCpmuGgO3ZaIKTYHTUa+8+nRA/yy9nQRSmw
         BHM8/O3momKJ+Ly7AEz4tTNspdx1i4PB66iKfAl66HXvtGlCd75Fx7jzQPifE8jv0f4B
         ruJ+SGU8zAeneCA2zqZumPXjC+qpqrC1p324I5nHj2JhFzrDWlmb1xoCL7b4kkkvuJJA
         hzRzC/dbNxTq0LyKwwPnFJwNIGIgeq1e+qrhElKFuRcL9AczH+oDTKLl0ymSW2iApdR4
         RsCw==
X-Forwarded-Encrypted: i=1; AJvYcCWJ7w+iV+Ds/9zQQhCTfj0aKm3CYv0R0I+3H5S/ltJy2fwzJ7SrOkEBhRzpMPWFTW9WUaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxED4/f46mzMRgU9B9jP7AAyH+TFeimlgRSBjU+hqvAJvm7DkfM
	yHOlEXSpowOjAHVfmLccOfP0/l39b70ZcZqAVcmpg5Sg73aK7pD4wPHSXMO5OnlJuYTHeyaiZMb
	5TJvZePR/yQ9DXPqKc3vrZ/14Kz9i9dF+x62A
X-Google-Smtp-Source: AGHT+IFrQ0w4YKf6Tun2dYvIeZ8sw5qBscPut0n0CWGUA0i22fgbhRTxIf3RjbnCdYAKgRNa0rE3NQJXfNE+LvbgfJ4=
X-Received: by 2002:a05:600c:501e:b0:431:4847:47c0 with SMTP id
 5b1f17b1804b1-432df722c63mr140674345e9.7.1731975752011; Mon, 18 Nov 2024
 16:22:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118043745.1857272-1-suleiman@google.com> <20241118143311.3ca94405@gandalf.local.home>
 <CAJWu+oqR=SMKHd1EqvRm3nvz7e1r4e7Rj76hJ8jhDQQkNVo0ig@mail.gmail.com> <20241118191813.145031fc@gandalf.local.home>
In-Reply-To: <20241118191813.145031fc@gandalf.local.home>
From: Joel Fernandes <joelaf@google.com>
Date: Tue, 19 Nov 2024 09:22:20 +0900
Message-ID: <CAJWu+opw2gohuwU2wie1eBghT0fL=fX60LdBu+_B2TjkHc4yyw@mail.gmail.com>
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

On Tue, Nov 19, 2024 at 9:17=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Tue, 19 Nov 2024 09:10:41 +0900
> Joel Fernandes <joelaf@google.com> wrote:
>
> > > > +++ b/kernel/sched/core.c
> > > > @@ -766,13 +766,15 @@ static void update_rq_clock_task(struct rq *r=
q, s64 delta)
> > > >  #endif
> > > >  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> > > >       if (static_key_false((&paravirt_steal_rq_enabled))) {
> > > > -             steal =3D paravirt_steal_clock(cpu_of(rq));
> > > > +             u64 prev_steal;
> > > > +
> > > > +             steal =3D prev_steal =3D paravirt_steal_clock(cpu_of(=
rq));
> > > >               steal -=3D rq->prev_steal_time_rq;
> > > >
> > > >               if (unlikely(steal > delta))
> > > >                       steal =3D delta;
> > >
> > > So is the problem just the above if statement? That is, delta is alre=
ady
> > > calculated, but if we get interrupted by the host before steal is
> > > calculated and the time then becomes greater than delta, the time
> > > difference between delta and steal gets pushed off to the next task, =
right?
> >
> > Pretty much.. the steal being capped to delta means the rest of the
> > steal is pushed off to the future. Instead he discards the remaining
> > steal after this patch.
>
> Thanks for confirming. I just wanted to make sure I understand as the
> initial change log went into a lot of detail where I sorta got lost ;-)

No problem!! Glad we're on the same page about the change.

thanks,

 - Joel

