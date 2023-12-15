Return-Path: <kvm+bounces-4589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8765814FE3
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 19:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D6B7286FD5
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4453FB10;
	Fri, 15 Dec 2023 18:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="DdE1mvda"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC04D30104
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3ba46a19689so186817b6e.3
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 10:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702666370; x=1703271170; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v1j/kr7DabT2GwNTO7aTxaDhKyH0NDXQOeQEkDTIM9Y=;
        b=DdE1mvda2pqg7wK/Q/Ms74b4G8sLbrCjIXo6yeUf9QaVs9Qz6g0lSgRjQkpAHzcvp6
         3uYUeuSXBavsf5ulPmxG2bOLqTQb45rd7NfCQCf9slp4Qx11/qcPCkRJhDKI8NdIhDhD
         8Qzq69TGCVd+p1saOx/70E5rvq9dHG8AfxiL0cWZ03z7h/uilPgSyL2hybSBE94TU3uc
         xoSCSok1OFKdk3Y+pFbajNBRpM7QMxvYkrPYdpjmbEd/rs2xY2+fyiRVjHu+jYsE+I4E
         mlo3ghWHofEIszZ7GDIAkpoW9r3jR49XWI+2rB1uZrtgeRaTIT1IaIz2DKY+q6dVgft0
         7+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702666370; x=1703271170;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v1j/kr7DabT2GwNTO7aTxaDhKyH0NDXQOeQEkDTIM9Y=;
        b=ITRICRQwHuh3j3FHUQR38+Y6v6b8BLUvWDHZGbYX5EKIEj8SP61VCGyEufHrFM91gt
         lOhmlaPdYNThKOCPQNCVkUyane7c5oGr1IzgTjIyRVImaBCIaF8g6TUtSIYeulXKAXFW
         aPPdDobqWClmzWGXqjOt6uD5QdrlvVL2yna6j26yaT6MqQQX+ocYqAMoIJw5afZF1TqV
         VdqYv4+FRAkE6zVmQzX9XYJigmeiXS6bwkFpteNhFePSv0T/KGDyS3BaZYytqMeV2m8J
         n74XaS0Vpw1QxUhSaC99B6Y+MQRYCffmdGC9AVgZsFgE+6nxur7NHRdmL/fZ0QyAkeNC
         Vwmw==
X-Gm-Message-State: AOJu0YzyjTvx7qGLbgReE3AQAGUo0xGHqSXv8okSWxKPoQxf16D0pOPm
	/fC8nlnqGyw/JP00MzsjKZu1WNWiE29H4awKFWUrFg==
X-Google-Smtp-Source: AGHT+IFrVOGR9/l5kx+EYplmIUESVcg+goSGivI87+3cwlVZj/gGp4/fJnSxd3clBZcCgUxChDtTD0Nuon9B9bOs+z0=
X-Received: by 2002:a05:6871:7b8c:b0:1fb:75c:3ff2 with SMTP id
 pg12-20020a0568717b8c00b001fb075c3ff2mr17479561oac.82.1702666370622; Fri, 15
 Dec 2023 10:52:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <20231214024727.3503870-9-vineeth@bitbyteword.org> <87zfybml5w.ffs@tglx>
In-Reply-To: <87zfybml5w.ffs@tglx>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Fri, 15 Dec 2023 13:52:38 -0500
Message-ID: <CAO7JXPiFyLybt3F3bQca1iQqssYTwGn=ZyhXmutH84jUa_QVUg@mail.gmail.com>
Subject: Re: [RFC PATCH 8/8] irq: boost/unboost in irq/nmi entry/exit and softirq
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"

[...snip..]
> > +#ifdef CONFIG_PARAVIRT_SCHED
> > +     if (pv_sched_enabled() && !in_hardirq() && !local_softirq_pending() &&
> > +                     !need_resched() && !task_is_realtime(current))
> > +             pv_sched_unboost_vcpu();
> > +#endif
>
> Symmetry is overrated. Just pick a spot and slap your hackery in.
>
> Aside of that this whole #ifdeffery is tasteless at best.
>
> >       instrumentation_end();
>
> > +#ifdef CONFIG_PARAVIRT_SCHED
> > +     if (pv_sched_enabled())
> > +             pv_sched_boost_vcpu_lazy();
> > +#endif
>
> But what's worse is that this is just another approach of sprinkling
> random hints all over the place and see what sticks.
>
Understood. WIll have a full re-write of guest side logic for v2.

> Abusing KVM as the man in the middle to communicate between guest and
> host scheduler is creative, but ill defined.
>
> From the host scheduler POV the vCPU is just a user space thread and
> making the guest special is just the wrong approach.
>
> The kernel has no proper general interface to convey information from a
> user space task to the scheduler.
>
> So instead of adding some ad-hoc KVM hackery the right thing is to solve
> this problem from ground up in a generic way and KVM can just utilize
> that instead of having the special snow-flake hackery which is just a
> maintainability nightmare.
>
We had a constructive and productive discussion on the cover letter
thread and reaching a consensus on the kvm side of the design. Will
work towards that and post iterative revisions.

Thanks,
Vineeth

