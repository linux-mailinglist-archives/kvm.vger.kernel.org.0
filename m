Return-Path: <kvm+bounces-12864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4CEE88E698
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 892781F310EC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E944C13A86C;
	Wed, 27 Mar 2024 13:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YIoyDyqR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE5E13A879
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711545138; cv=none; b=JwNV7CIAw7YszKB0Kmd1TApGIZ8fTITqp9TU+VqwgOog2/XoKONddSrZjBlu8ENUr5NsvjSoL9FVCi/oXERe3uYkWgdcS7n+u1hW601AgUE1YnQtEGTTv50KkG/MgZScVRYS8YqAaDj2IXtng+dnJv6n+iif4o+bKC6BYg6Zs9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711545138; c=relaxed/simple;
	bh=EZD9R7kQPOleNH6dfp89r0J0EVvWnkBrQ3luSyujP4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oN6zPqO+6FNmC701LMn3b4WSiPG6GjKcUiP6vN+fVBv4dDWbun9tOYPKq+4/2FryC/Ze1n+myXzfMoAlVV1pPPB5pnpFCCBETEWRd+H1PjZRE+ZTZZK9pOkZry/n69vuVRzncJWkttd/F7Z5a1zhI5uKkKu8p4Arx2zxUt0AIto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YIoyDyqR; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56c2cfdd728so9100a12.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 06:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711545135; x=1712149935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lh0qAZ9DGKUKt/wTT7PZWIc64SA1BHl18Bv9aAtPYd8=;
        b=YIoyDyqROZM5KzgcfOAxrBhJsgvWqGYsSExNrnvgi3SkyrB26dGEJqQlURWJMVPv6v
         KgWM3YTVmBf1uoyUAU0M6AwhHFLqHEHyptqR9vMvTSF/WCjbxGQqCv6/5D4F5Qwo3GkQ
         oZoygEStJ0yC/wBtBj37glD5S8I9ldHZkYJRdeUWSFAQzWllA82pvVvXDOvW0/VJSy/r
         6BVCJ9xgnziX+pRoapNxTfAVrMTqaTthluds/pzkv9/+4XovGauONKGGKQ2KZUlPOMo/
         Gm5OSRdkkIF/Y3uf0xzxSckk99biiQe4NTXVlL73uvu0p59waCkaSaioivfj9QVhAPZQ
         ji2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711545135; x=1712149935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lh0qAZ9DGKUKt/wTT7PZWIc64SA1BHl18Bv9aAtPYd8=;
        b=xFrpbWfkH+/H0f3VEWhooVBpS+jtAbKYRMlRTo7n2nHbPlKAXFea+/0J0towLs3iUJ
         nxqqgep6i6bWfKAbqn6ZM8oRqKthrCXgYv7x73F3oto+GJNBrpUP+9MBj9acnJuA6IF7
         M2WZ/GbsHdrTI4p1vJSync55opVAB9dMyxL35iqo2+V23A2HPPJ4/cQyz8OhZYWLu1PC
         AD4g4+7AZHJCyFIjQtYDmw7RqT5KdiUjFrVlXuvS8dcTdvZnsGkqy06xZEjCG75DmA94
         dMJiq8Cvyjo0/eNjbgKioLk0mmeT5PN0GnI9zUVIQnL8raEwkDR5jAWxVFHBJqjPeEEX
         RAiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfGWaSiqfPJJkOvlzagaq8ak+cC+axqfF1Wed15aW7CasQwi/XsdaCHXVsU16acyG6/x9ahLTN8rqh8PV04Y1BeO7a
X-Gm-Message-State: AOJu0YyojZdaXD4Z7mVZ18EH2HYMKH1BbNQrc4dh4OM8z5AV65EYAsIT
	GQLHNONTWDg0qhUSjTf7J4/V+ekARsKwrCtZvXoWyXs/eeCGAN7ByYx6hyAjaz9nXh3f0WG0zO2
	t78QVKXIym6czw1bb6+XArd+GuUwXZZ9J3qPB
X-Google-Smtp-Source: AGHT+IEXMaD8KKZ3q3120e6KG9qOf73GrC9gddy36kNW4t7F75Lwbo97LNYeyJwa97KmVaiaP1kaYiovo6xodOGckQE=
X-Received: by 2002:aa7:c0c6:0:b0:56c:5dc:ed7 with SMTP id j6-20020aa7c0c6000000b0056c05dc0ed7mr91414edp.4.1711545135114;
 Wed, 27 Mar 2024 06:12:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com> <20240103031409.2504051-4-dapeng1.mi@linux.intel.com>
In-Reply-To: <20240103031409.2504051-4-dapeng1.mi@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 27 Mar 2024 06:11:59 -0700
Message-ID: <CALMp9eRLVJrGORS5RrXefLOiMkhvbSAMgHLcPHM1Y0sLbQ4MmA@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch v3 03/11] x86: pmu: Add asserts to warn
 inconsistent fixed events and counters
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 2, 2024 at 7:09=E2=80=AFPM Dapeng Mi <dapeng1.mi@linux.intel.co=
m> wrote:
>
> Current PMU code deosn't check whether PMU fixed counter number is
> larger than pre-defined fixed events. If so, it would cause memory
> access out of range.
>
> So add assert to warn this invalid case.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a13b8a8398c6..a42fff8d8b36 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -111,8 +111,12 @@ static struct pmu_event* get_counter_event(pmu_count=
er_t *cnt)
>                 for (i =3D 0; i < gp_events_size; i++)
>                         if (gp_events[i].unit_sel =3D=3D (cnt->config & 0=
xffff))
>                                 return &gp_events[i];
> -       } else
> -               return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0]=
;
> +       } else {
> +               int idx =3D cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
> +
> +               assert(idx < ARRAY_SIZE(fixed_events));
> +               return &fixed_events[idx];
> +       }
>
>         return (void*)0;
>  }
> @@ -245,6 +249,7 @@ static void check_fixed_counters(void)
>         };
>         int i;
>
> +       assert(pmu.nr_fixed_counters <=3D ARRAY_SIZE(fixed_events));
>         for (i =3D 0; i < pmu.nr_fixed_counters; i++) {
>                 cnt.ctr =3D fixed_events[i].unit_sel;
>                 measure_one(&cnt);
> @@ -266,6 +271,7 @@ static void check_counters_many(void)
>                         gp_events[i % gp_events_size].unit_sel;
>                 n++;
>         }
> +       assert(pmu.nr_fixed_counters <=3D ARRAY_SIZE(fixed_events));

Can we assert this just once, in main()?

>         for (i =3D 0; i < pmu.nr_fixed_counters; i++) {
>                 cnt[n].ctr =3D fixed_events[i].unit_sel;
>                 cnt[n].config =3D EVNTSEL_OS | EVNTSEL_USR;
> --
> 2.34.1
>

