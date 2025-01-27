Return-Path: <kvm+bounces-36652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4C5A1D66A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49E23164CFA
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 13:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71671FF7BE;
	Mon, 27 Jan 2025 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZG3s2wc7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB7B1FF1DF
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737983643; cv=none; b=V7BClC2p0rMQ3vKmSP1QOqvdflGnZLBWwdENyV6cULekMwcFkWLFg/czIFQFBkzKvx6pmxLbT5lbYwynBtnLxPqo8kgezIvgZ99Mfw2aLV/u3Mv6GTIwSIdoxBSTxJjGX7hk2as36rYV6DM+KA+7sIWWlVAT9PwVlSr4GWii/Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737983643; c=relaxed/simple;
	bh=i5IhVDc9BA62gBfypVyLkDa8joZ1oeyrngvRmSMlkeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XXPGc/ZTQNeOUkJOmWpgelYJX9izkQ9FvOqlJFceD1s0JtU/63hr01Qrev5g7nqURfRq+9Tjc/Gx/KgNo9Z3a2gy+Lg74WIGrWGTCw1lkwg3ApjkhimP+uslbQPC2yGDur+sWOHltULEI6zHgJ2fi0PqdptfpfFRQXK/yepBlNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZG3s2wc7; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fc01so9098426a12.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 05:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737983639; x=1738588439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcUfd5mp2lx6IXkGpr4cVB2RPJkcpZBWLFBIJNyBPvE=;
        b=ZG3s2wc7q8KJundmeXGwbjETHfR3+ftoL2NX7Cn/gAWnJyIJvJkszprZSlkfc5OyGC
         SkKv/vSFexavH8agqHEBKEz0Dcq4wU8TMhDTx4xE0o+ZiJbyJl2IpORLy30X7z96LQoa
         RXHnc1b0Va+R+wrSy4kalh1vKchaV+DjVZ4RKG19WBEUIs4tRUCuIifsSFMrFN5xNO86
         Z6ocakGBQk+lzn+4NGCP6/AqFRLNmp9ScjAS5lrl87dIiChfKeUdzba6h99f2aO0dJg4
         6lBFUyo8Fpc76265wsk/59B880a2HR7qi6RuNiaPS/2tdT+K37XtuwMdRURsGTr8UCTi
         UdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737983639; x=1738588439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CcUfd5mp2lx6IXkGpr4cVB2RPJkcpZBWLFBIJNyBPvE=;
        b=px7V4V1ybjIYumxjVpdTNw58HoexhIfnAgn8BJZvcbYB2ItpNHcDZhfupFPXaVli0z
         OSP1qnZ9x0pyU59geDKBx2W9rPt/IOZX63myA0YMmEK3lq3pBkelRR7LWU8BaH54Kk1B
         JSpWyUdTBqMBF0URdMxq3XvxFK2QiyulT2SolRHSxhb2PhSMYVdcAjdUN/zBpCT+AtG/
         92KWxBa7Nf4RVj+eaUBcULOVwQtsmJUVRZisSiFRaaBLcAeEpJJ7NdG0luIgZxivx9iU
         d6UAMuAvfaQrVmLyKJqyhLKMHM4+b5GR4t++o2m1yC8IO0VRqbKb76j7rofeBBqSheLe
         3xEA==
X-Forwarded-Encrypted: i=1; AJvYcCVc5fHKyW2wMyvtHCRKY4uKojVKgD9t+cCFzxOGG1i/0gUigGEnAgMzULxu56W0UArp0Ec=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyml8WHPOwVT/nV8Z4OHXjHTYm8DXmCdByQmdPvl3rXPsD49IvT
	s/egnKi47zWlpFc/e1LaD4uQCobkoDrguK+pmSJ/IwTt/4VueTc9Enp2bLnUYhuB7dKwdP2JZyc
	dBlbUb2x8q37Bbk3VGXl5v18VpgPjtUaaSwRIJg==
X-Gm-Gg: ASbGncsmTKQf0yjU3/cR6bB6TN0RVqDN4bdooB+LQ4rgG3FclAOjR1K9vweA22U7FUi
	SuN/IyOsH1XfVWiKiS6zXgOfs96YaCXZUjeQtFzevPJtzVHF223ReeMzxlgv8ghBiYqRWIBpek5
	TDn6MpYObrLZJV7do=
X-Google-Smtp-Source: AGHT+IGI+VNA7V7vT5sQhD8d+UlyV27Z43VMfPM0LyL7oiir6/nPuDhT4k+ynoarvhmcks1njPutMxv7A9DwBJXJY/A=
X-Received: by 2002:a05:6402:2552:b0:5d9:f9b8:e7fb with SMTP id
 4fb4d7f45d1cf-5db7d8272fbmr36561402a12.22.1737983638980; Mon, 27 Jan 2025
 05:13:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250126065037.97935-1-laoar.shao@gmail.com>
In-Reply-To: <20250126065037.97935-1-laoar.shao@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 27 Jan 2025 14:13:47 +0100
X-Gm-Features: AWEUYZltbEXYI2SWsaYfgq7yLJSZppCT_HmNUsYoWoSx42Xsp8W2ZVgsHhR9pXM
Message-ID: <CAKfTPtAB1cv_MxOveenxa5Y5zjsNC-RqinSr9Z2vrC7S92NOUw@mail.gmail.com>
Subject: Re: [PATCH] sched: Don't define sched_clock_irqtime as static key
To: Yafang Shao <laoar.shao@gmail.com>
Cc: dan.carpenter@linaro.org, seanjc@google.com, mkoutny@suse.com, 
	peterz@infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Jan 2025 at 07:50, Yafang Shao <laoar.shao@gmail.com> wrote:
>
> The sched_clock_irqtime was defined as a static key in commit 8722903cbb8=
f
> ('sched: Define sched_clock_irqtime as static key'). However, this change
> introduces a 'sleeping in atomic context' warning, as shown below:
>
>         arch/x86/kernel/tsc.c:1214 mark_tsc_unstable()
>         warn: sleeping in atomic context
>
> As analyzed by Dan, the affected code path is as follows:
>
> vcpu_load() <- disables preempt
> -> kvm_arch_vcpu_load()
>    -> mark_tsc_unstable() <- sleeps
>
> virt/kvm/kvm_main.c
>    166  void vcpu_load(struct kvm_vcpu *vcpu)
>    167  {
>    168          int cpu =3D get_cpu();
>                           ^^^^^^^^^^
> This get_cpu() disables preemption.
>
>    169
>    170          __this_cpu_write(kvm_running_vcpu, vcpu);
>    171          preempt_notifier_register(&vcpu->preempt_notifier);
>    172          kvm_arch_vcpu_load(vcpu, cpu);
>    173          put_cpu();
>    174  }
>
> arch/x86/kvm/x86.c
>   4979          if (unlikely(vcpu->cpu !=3D cpu) || kvm_check_tsc_unstabl=
e()) {
>   4980                  s64 tsc_delta =3D !vcpu->arch.last_host_tsc ? 0 :
>   4981                                  rdtsc() - vcpu->arch.last_host_ts=
c;
>   4982                  if (tsc_delta < 0)
>   4983                          mark_tsc_unstable("KVM discovered backwar=
ds TSC");
>
> arch/x86/kernel/tsc.c
>     1206 void mark_tsc_unstable(char *reason)
>     1207 {
>     1208         if (tsc_unstable)
>     1209                 return;
>     1210
>     1211         tsc_unstable =3D 1;
>     1212         if (using_native_sched_clock())
>     1213                 clear_sched_clock_stable();
> --> 1214         disable_sched_clock_irqtime();
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> kernel/jump_label.c
>    245  void static_key_disable(struct static_key *key)
>    246  {
>    247          cpus_read_lock();
>                 ^^^^^^^^^^^^^^^^
> This lock has a might_sleep() in it which triggers the static checker
> warning.
>
>    248          static_key_disable_cpuslocked(key);
>    249          cpus_read_unlock();
>    250  }
>
> Let revert this change for now as {disable,enable}_sched_clock_irqtime
> are used in many places, as pointed out by Sean, including the following:
>
> The code path in clocksource_watchdog():
>
>   clocksource_watchdog()
>   |
>   -> spin_lock(&watchdog_lock);
>      |
>      -> __clocksource_unstable()
>         |
>         -> clocksource.mark_unstable() =3D=3D tsc_cs_mark_unstable()
>            |
>            -> disable_sched_clock_irqtime()
>
> And the code path in sched_clock_register():
>
>         /* Cannot register a sched_clock with interrupts on */
>         local_irq_save(flags);
>
>         ...
>
>         /* Enable IRQ time accounting if we have a fast enough sched_cloc=
k() */
>         if (irqtime > 0 || (irqtime =3D=3D -1 && rate >=3D 1000000))
>                 enable_sched_clock_irqtime();
>
>         local_irq_restore(flags);
>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/kvm/37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@=
stanley.mountain/
> Debugged-by: Dan Carpenter <dan.carpenter@linaro.org>
> Debugged-by: Sean Christopherson <seanjc@google.com>
> Debugged-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Fixes: 8722903cbb8f ("sched: Define sched_clock_irqtime as static key")
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Peter Zijlstra" <peterz@infradead.org>
> Cc: Vincent Guittot" <vincent.guittot@linaro.org>

I overlooked that this was used under atomic context

Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>

> ---
>  kernel/sched/cputime.c | 8 ++++----
>  kernel/sched/sched.h   | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 5d9143dd0879..c7904ce2345a 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -9,8 +9,6 @@
>
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>
> -DEFINE_STATIC_KEY_FALSE(sched_clock_irqtime);
> -
>  /*
>   * There are no locks covering percpu hardirq/softirq time.
>   * They are only modified in vtime_account, on corresponding CPU
> @@ -24,14 +22,16 @@ DEFINE_STATIC_KEY_FALSE(sched_clock_irqtime);
>   */
>  DEFINE_PER_CPU(struct irqtime, cpu_irqtime);
>
> +static int sched_clock_irqtime;
> +
>  void enable_sched_clock_irqtime(void)
>  {
> -       static_branch_enable(&sched_clock_irqtime);
> +       sched_clock_irqtime =3D 1;
>  }
>
>  void disable_sched_clock_irqtime(void)
>  {
> -       static_branch_disable(&sched_clock_irqtime);
> +       sched_clock_irqtime =3D 0;
>  }
>
>  static void irqtime_account_delta(struct irqtime *irqtime, u64 delta,
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 38e0e323dda2..ab16d3d0e51c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -3259,11 +3259,11 @@ struct irqtime {
>  };
>
>  DECLARE_PER_CPU(struct irqtime, cpu_irqtime);
> -DECLARE_STATIC_KEY_FALSE(sched_clock_irqtime);
> +extern int sched_clock_irqtime;
>
>  static inline int irqtime_enabled(void)
>  {
> -       return static_branch_likely(&sched_clock_irqtime);
> +       return sched_clock_irqtime;
>  }
>
>  /*
> --
> 2.43.5
>

