Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55681709940
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjESOPP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 19 May 2023 10:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjESOPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 10:15:10 -0400
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B719E73;
        Fri, 19 May 2023 07:14:42 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-96f44435d92so41006066b.0;
        Fri, 19 May 2023 07:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684505634; x=1687097634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtyjmo3U27wuRhuxdBoN4szAZEtqJIsshyVfilBgAD0=;
        b=C4ucInKXKAyY39AY1irPEpCBVp43HjLOS7XZaLrlqvoU5igMwHa/lQmESfH/lbVzqL
         hr4QX2dI5/a+KXZITwQj418BdH8tUWUH/F5JARAPxizo6a8P29Iig6d4ziEewjOFtyKx
         D0YflxZafGjGbffr3X3XQqWUpg8Wflux3xKgYu60wDWx8qIYuoKgM/d8LL4cmFKA+O6s
         k3NfqZMYdX8Zz8ivSfCCqxN5E7Fsm8X/Cs35SKGQyodk0xIlu3BdtULGdKPIrr/4QX48
         quqTNDAhI2r8quPODmTsXCMFjxKrGB9oRfGglvGxUzBX0gq9g9AppPw+ZgICYBiSNXh3
         iibQ==
X-Gm-Message-State: AC+VfDyvjeRmnh6F+HU6ygfTpk5tvyL+mj4B8iGHatfMTwWbG8Ju4ikg
        SDKe83tNbkAArusdWKn9dVCug5gW1BXZoaKDQBc=
X-Google-Smtp-Source: ACHHUZ68+/i2ffEZTXg6tj3QMitnfwpUc6ZolPA0xIlso352d5CtlPMyVKVablcnpHf+LCxLGPtLwAjOXXkDYlCuYhQ=
X-Received: by 2002:a17:906:729e:b0:96f:6590:cbdb with SMTP id
 b30-20020a170906729e00b0096f6590cbdbmr1995862ejl.6.1684505634451; Fri, 19 May
 2023 07:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230519102058.581557770@infradead.org> <20230519102716.045980863@infradead.org>
In-Reply-To: <20230519102716.045980863@infradead.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 19 May 2023 16:13:41 +0200
Message-ID: <CAJZ5v0hAyF8WK+jbWh6FZvmjfr0nxLg-phYTqFAyaUA5GJU4hQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/13] cpuidle: Use local_clock_noinstr()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 12:33 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> With the introduction of local_clock_noinstr(), local_clock() itself
> is no longer marked noinstr, use the correct function.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>  drivers/cpuidle/cpuidle.c    |    8 ++++----
>  drivers/cpuidle/poll_state.c |    4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -145,7 +145,7 @@ static noinstr void enter_s2idle_proper(
>
>         instrumentation_begin();
>
> -       time_start = ns_to_ktime(local_clock());
> +       time_start = ns_to_ktime(local_clock_noinstr());
>
>         tick_freeze();
>         /*
> @@ -169,7 +169,7 @@ static noinstr void enter_s2idle_proper(
>         tick_unfreeze();
>         start_critical_timings();
>
> -       time_end = ns_to_ktime(local_clock());
> +       time_end = ns_to_ktime(local_clock_noinstr());
>
>         dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
>         dev->states_usage[index].s2idle_usage++;
> @@ -243,7 +243,7 @@ noinstr int cpuidle_enter_state(struct c
>         sched_idle_set_state(target_state);
>
>         trace_cpu_idle(index, dev->cpu);
> -       time_start = ns_to_ktime(local_clock());
> +       time_start = ns_to_ktime(local_clock_noinstr());
>
>         stop_critical_timings();
>         if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE)) {
> @@ -276,7 +276,7 @@ noinstr int cpuidle_enter_state(struct c
>         start_critical_timings();
>
>         sched_clock_idle_wakeup_event();
> -       time_end = ns_to_ktime(local_clock());
> +       time_end = ns_to_ktime(local_clock_noinstr());
>         trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
>
>         /* The cpu is no longer idle or about to enter idle. */
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -15,7 +15,7 @@ static int __cpuidle poll_idle(struct cp
>  {
>         u64 time_start;
>
> -       time_start = local_clock();
> +       time_start = local_clock_noinstr();
>
>         dev->poll_time_limit = false;
>
> @@ -32,7 +32,7 @@ static int __cpuidle poll_idle(struct cp
>                                 continue;
>
>                         loop_count = 0;
> -                       if (local_clock() - time_start > limit) {
> +                       if (local_clock_noinstr() - time_start > limit) {
>                                 dev->poll_time_limit = true;
>                                 break;
>                         }
>
>
