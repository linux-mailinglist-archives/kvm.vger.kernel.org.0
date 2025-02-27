Return-Path: <kvm+bounces-39543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF59AA476A9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C26ED3ACDC1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 07:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69847223308;
	Thu, 27 Feb 2025 07:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UkA+6NBp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830BD21CC78
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 07:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740641690; cv=none; b=FpBXOV2dcFIrJh3GKlFf0dg46L9HJlwfn6lbiC7a/fNrKI94iBW4tvVmZ1a1vY5uRbI5X5gYWS/lsOUOpKE/9rYVQeCtobGmVLjcXL4ewDbbLuxCWRxWdh5L3R8gGf6jSjYzhmdNajpPsChCp/1sZX9Ac1bSdqSle4gz5wW54tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740641690; c=relaxed/simple;
	bh=cXIuTmWhfOuayb7KCSU9YQYtmVZoqw4DwJ+xmh63kLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TGfGfU0sfeKjaaHfAqJssA6WM3NfXix0y3mF86GmsY6hPgzKFRGA74jALqDG9yAbsYfkvMpK+lz0VSfv4bnvpHdJBHHcpOeP9/zhDFu6YgOkhZjQDPGgbWimyT+v/LJGMcxypUANXUpAsKa+Cz1VuyuK4TrjKo+Nfsbe3jx3LOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UkA+6NBp; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5ded46f323fso745567a12.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 23:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740641687; x=1741246487; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U1dvznxTvyKsNgavWSNufwqT+/wcUbgTbrkSbuXEd74=;
        b=UkA+6NBpc0GEalc20xvfZjlYXl1IxYUalClK0MEwc1jzKYYDwex2Us1G24u8YbMcbi
         lLhKWQ4ip4b5ilE05wzhFsegYLFap+9dbAuhQuPaEzbJ3E4Q4zSTSI9pT4Nr5KkTCcTn
         2g0Evj3uaXY46f371TfZt/emqNpiXwLr7l5RDt1VcARN2AFQgSwIdgwGUtmwmldSsT6u
         YAJurzsF72i8bEuUeXr5wuZpAxZT27alCU0QbBpbm4WbyM0ak/M/LlqeI89veBr6AWSs
         /1xQfLl7b9N4JMKUUE003OptUT0YMRCcv1NV7divjjzHF4yJqOLnY5u8d1p7r2bFVr7X
         A21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740641687; x=1741246487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U1dvznxTvyKsNgavWSNufwqT+/wcUbgTbrkSbuXEd74=;
        b=jAwH/ZDfCR9P4cLzbkEM9V3uW2eWJOHSZCa7H86mF75hhQkXm3gmMEl7doSQC1lHGP
         ZZbaTorqkAWOW2Dw6JEqJoX4EjYfaINIvgE4IKUVBEMknyH35Uq7oUDLFgjOmHt4sAys
         IOPyVNE/7ZpY5njCs6ylgsoXioViohlEGhLFA/ECNnkYi8LRhvKLmZUAlHrNlVNLxXZf
         7uYZnV9qgwSNcIwfhw+PW1+fal11NbldtweZqHIDmnsURSJkLseQIE6Vg1xRJnlX9fbP
         vJqRWRiI5bpfFjUiUeDamlpauPikvq8zR1Y4gGt39Bgx7sLaepYKBNqtIKhJMdB4pmIt
         6bog==
X-Forwarded-Encrypted: i=1; AJvYcCWBTWfZo38EqvMx+3vgAXsFcVaFvrXqhocNREx0StMUxErCBN3Wl3a9jmc1KUXTdlDEtvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyesOmnvG6LFO59bB3ZxgNLBea6CRxD6b7rp4D7FHG/WTqZH51s
	RWzs8Q1X7po6eo9GU+sArNVVw2VEdlVrJWW0LcvEpxMyhbAsLtYd852ZML/omxkPSFkFAZ3scqB
	SP/9hKAmwQu1JQdVMBQ3hFfqpLZr5VdhC9UnZRg==
X-Gm-Gg: ASbGncsMXlGRKTCO7fXVvNSYZJHFxcFMMDxbMRkidgZg09O81m8MUU3dffTqf/rMPI1
	Bfwq4lvC+GpPskxfrWEjjigfVFi9h6j9Sm/I2Xo5VJHxSUI7D8GLzoVblUPvmEXJ2jhfrN40MfC
	1m4na+dg1iB1l5YwgI8alay4aaoZhla1rCyoPe
X-Google-Smtp-Source: AGHT+IG40fFQ2lZ5Y5gBYJwjOho6MPsxU/d0jrx/euil0xdNDtB9YEZMLR+7LzonAdQFy0BRswCDj1snE8yhcsE+RL8=
X-Received: by 2002:a05:6402:35c3:b0:5dc:c9ce:b01b with SMTP id
 4fb4d7f45d1cf-5e4a0d71e54mr8252438a12.8.1740641686623; Wed, 26 Feb 2025
 23:34:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218202618.567363-1-sieberf@amazon.com> <20250218202618.567363-4-sieberf@amazon.com>
In-Reply-To: <20250218202618.567363-4-sieberf@amazon.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 27 Feb 2025 08:34:34 +0100
X-Gm-Features: AQ5f1JoKDGirAsal6mP4kiQGkcQt6k2-DzG_AvNjeWNJ-UrBioNyUhKA-GkvBl8
Message-ID: <CAKfTPtDx3vVK1ZgBwicTeP82wL=wGOKdxheuBHCBjzM6mSDPOQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] sched,x86: Make the scheduler guest unhalted aware
To: Fernand Sieber <sieberf@amazon.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Feb 2025 at 21:27, Fernand Sieber <sieberf@amazon.com> wrote:
>
> With guest hlt/mwait/pause pass through, the scheduler has no visibility into
> real vCPU activity as it sees them all 100% active. As such, load balancing
> cannot make informed decisions on where it is preferrable to collocate
> tasks when necessary. I.e as far as the load balancer is concerned, a
> halted vCPU and an idle polling vCPU look exactly the same so it may decide
> that either should be preempted when in reality it would be preferrable to
> preempt the idle one.
>
> This commits enlightens the scheduler to real guest activity in this
> situation. Leveraging gtime unhalted, it adds a hook for kvm to communicate
> to the scheduler the duration that a vCPU spends halted. This is then used in
> PELT accounting to discount it from real activity. This results in better
> placement and overall steal time reduction.

NAK, PELT account for time spent by se on the CPU. If your thread/vcpu
doesn't do anything but burn cycles, find another way to report thatto
the host
Furthermore this breaks all the hierarchy dependency

>
> This initial implementation assumes that non-idle CPUs are ticking as it
> hooks the unhalted time the PELT decaying load accounting. As such it
> doesn't work well if PELT is updated infrequenly with large chunks of
> halted time. This is not a fundamental limitation but more complex
> accounting is needed to generalize the use case to nohz full.
> ---
>  arch/x86/kvm/x86.c    |  8 ++++++--
>  include/linux/sched.h |  4 ++++
>  kernel/sched/core.c   |  1 +
>  kernel/sched/fair.c   | 25 +++++++++++++++++++++++++
>  kernel/sched/pelt.c   | 42 +++++++++++++++++++++++++++++++++++-------
>  kernel/sched/sched.h  |  2 ++
>  6 files changed, 73 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 46975b0a63a5..156cf05b325f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10712,6 +10712,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         int r;
>         unsigned long long cycles, cycles_start = 0;
>         unsigned long long unhalted_cycles, unhalted_cycles_start = 0;
> +       unsigned long long halted_cycles_ns = 0;
>         bool req_int_win =
>                 dm_request_for_irq_injection(vcpu) &&
>                 kvm_cpu_accept_dm_intr(vcpu);
> @@ -11083,8 +11084,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                 cycles = get_cycles() - cycles_start;
>                 unhalted_cycles = get_unhalted_cycles() -
>                         unhalted_cycles_start;
> -               if (likely(cycles > unhalted_cycles))
> -                       current->gtime_halted += cycles2ns(cycles - unhalted_cycles);
> +               if (likely(cycles > unhalted_cycles)) {
> +                       halted_cycles_ns = cycles2ns(cycles - unhalted_cycles);
> +                       current->gtime_halted += halted_cycles_ns;
> +                       sched_account_gtime_halted(current, halted_cycles_ns);
> +               }
>         }
>
>         local_irq_enable();
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5f6745357e20..5409fac152c9 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -367,6 +367,8 @@ struct vtime {
>         u64                     gtime;
>  };
>
> +extern void sched_account_gtime_halted(struct task_struct *p, u64 gtime_halted);
> +
>  /*
>   * Utilization clamp constraints.
>   * @UCLAMP_MIN:        Minimum utilization
> @@ -588,6 +590,8 @@ struct sched_entity {
>          */
>         struct sched_avg                avg;
>  #endif
> +
> +       u64                             gtime_halted;
>  };
>
>  struct sched_rt_entity {
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9aecd914ac69..1f3ced2b2636 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4487,6 +4487,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>         p->se.nr_migrations             = 0;
>         p->se.vruntime                  = 0;
>         p->se.vlag                      = 0;
> +       p->se.gtime_halted              = 0;
>         INIT_LIST_HEAD(&p->se.group_node);
>
>         /* A delayed task cannot be in clone(). */
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1c0ef435a7aa..5ff52711d459 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -13705,4 +13705,29 @@ __init void init_sched_fair_class(void)
>  #endif
>  #endif /* SMP */
>
> +
> +}
> +
> +#ifdef CONFIG_NO_HZ_FULL
> +void sched_account_gtime_halted(struct task_struct *p, u64 gtime_halted)
> +{
>  }
> +#else
> +/*
> + * The implementation hooking into PELT requires regular updates of
> + * gtime_halted. This is guaranteed unless we run on CONFIG_NO_HZ_FULL.
> + */
> +void sched_account_gtime_halted(struct task_struct *p, u64 gtime_halted)
> +{
> +       struct sched_entity *se = &p->se;
> +
> +       if (unlikely(!gtime_halted))
> +               return;
> +
> +       for_each_sched_entity(se) {
> +               se->gtime_halted += gtime_halted;
> +               se->cfs_rq->gtime_halted += gtime_halted;
> +       }
> +}
> +#endif
> +EXPORT_SYMBOL(sched_account_gtime_halted);
> diff --git a/kernel/sched/pelt.c b/kernel/sched/pelt.c
> index 7a8534a2deff..9f96b7c46c00 100644
> --- a/kernel/sched/pelt.c
> +++ b/kernel/sched/pelt.c
> @@ -305,10 +305,23 @@ int __update_load_avg_blocked_se(u64 now, struct sched_entity *se)
>
>  int __update_load_avg_se(u64 now, struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> -       if (___update_load_sum(now, &se->avg, !!se->on_rq, se_runnable(se),
> -                               cfs_rq->curr == se)) {
> +       int ret = 0;
> +       u64 delta = now - se->avg.last_update_time;
> +       u64 gtime_halted = min(delta, se->gtime_halted);
>
> -               ___update_load_avg(&se->avg, se_weight(se));
> +       ret = ___update_load_sum(now - gtime_halted, &se->avg, !!se->on_rq, se_runnable(se),
> +                       cfs_rq->curr == se);
> +
> +       if (gtime_halted) {
> +               ret |= ___update_load_sum(now, &se->avg, 0, 0, 0);
> +               se->gtime_halted -= gtime_halted;
> +
> +               /* decay residual halted time */
> +               if (ret && se->gtime_halted)
> +                       se->gtime_halted = decay_load(se->gtime_halted, delta / 1024);
> +       }
> +
> +       if (ret) {
>                 cfs_se_util_change(&se->avg);
>                 trace_pelt_se_tp(se);
>                 return 1;
> @@ -319,10 +332,25 @@ int __update_load_avg_se(u64 now, struct cfs_rq *cfs_rq, struct sched_entity *se
>
>  int __update_load_avg_cfs_rq(u64 now, struct cfs_rq *cfs_rq)
>  {
> -       if (___update_load_sum(now, &cfs_rq->avg,
> -                               scale_load_down(cfs_rq->load.weight),
> -                               cfs_rq->h_nr_runnable,
> -                               cfs_rq->curr != NULL)) {
> +       int ret = 0;
> +       u64 delta = now - cfs_rq->avg.last_update_time;
> +       u64 gtime_halted = min(delta, cfs_rq->gtime_halted);
> +
> +       ret =  ___update_load_sum(now - gtime_halted, &cfs_rq->avg,
> +                       scale_load_down(cfs_rq->load.weight),
> +                       cfs_rq->h_nr_runnable,
> +                       cfs_rq->curr != NULL);
> +
> +       if (gtime_halted) {
> +               ret |= ___update_load_sum(now, &cfs_rq->avg, 0, 0, 0);
> +               cfs_rq->gtime_halted -= gtime_halted;
> +
> +               /* decay any residual halted time */
> +               if (ret && cfs_rq->gtime_halted)
> +                       cfs_rq->gtime_halted = decay_load(cfs_rq->gtime_halted, delta / 1024);
> +       }
> +
> +       if (ret) {
>
>                 ___update_load_avg(&cfs_rq->avg, 1);
>                 trace_pelt_cfs_tp(cfs_rq);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index b93c8c3dc05a..79b1166265bf 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -744,6 +744,8 @@ struct cfs_rq {
>         struct list_head        throttled_csd_list;
>  #endif /* CONFIG_CFS_BANDWIDTH */
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
> +
> +       u64                     gtime_halted;
>  };
>
>  #ifdef CONFIG_SCHED_CLASS_EXT
> --
> 2.43.0
>
>
>
>
> Amazon Development Centre (South Africa) (Proprietary) Limited
> 29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
> Registration Number: 2004 / 034463 / 07
>

