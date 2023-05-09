Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C046FCB16
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjEIQSX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 9 May 2023 12:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEIQSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 12:18:22 -0400
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87365A6;
        Tue,  9 May 2023 09:18:21 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5068638856dso1446775a12.1;
        Tue, 09 May 2023 09:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683649100; x=1686241100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PaErfZ7CFuBtAl5PK49szGukMRl5+5+t7uieLVNF3k=;
        b=IGkTG8emTqYAYdhprseHuxIt2LKFcHelzLoR7/LO1EJYhfxhQqegR9L1EUYmnhtNxX
         rCjvq9FQL8usKAQa5RwNaSGsKPoqVkVHRtztv96/7vRfq9vqwLzdoa2lEbOhdm4gafgT
         38DHIECD5PDHxGQvsDwaYZMCsCymhBNp5uPmJKZXW0GJG/5fc6Da8mShopWjKo5JP8Lr
         5xzmzqfWgDjQLymI7PXnG8wRFnrHBhdKGBjIar6OX0aZlhnMHSZdmhOH41xe0xRHlyeW
         zXCE/fSEybaSjr/dKTZddrWczWb19OPblCiWGZnQ09X40F8E4NVbFMThvfEsva8SHdSA
         SeAw==
X-Gm-Message-State: AC+VfDw7IWiMymUKuvFyzI9weGV+ZQNFjKnSL2s6x/mF2xXYq49n/rU6
        xDHfPq5TmMR6Z/tvJbQXPvkDsyE7qx0k5shOva0=
X-Google-Smtp-Source: ACHHUZ5VvVh2YXPbdCQ+/kDWfNv8AsaUnyBBjPvTmT7MkhPyC1xgWUZ4lEdD8jDiuaVk8g4ag7V/4WDc1wznS3fa+Lk=
X-Received: by 2002:a05:6402:3482:b0:508:40a5:beb4 with SMTP id
 v2-20020a056402348200b0050840a5beb4mr14832425edc.3.1683649099853; Tue, 09 May
 2023 09:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230508211951.901961964@infradead.org> <20230508213147.990013706@infradead.org>
In-Reply-To: <20230508213147.990013706@infradead.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 9 May 2023 18:18:08 +0200
Message-ID: <CAJZ5v0jc29fSGFzN2Yeb+xRQZ9Y0V2_Ge17YnsEG5Um9OV25uw@mail.gmail.com>
Subject: Re: [RFC][PATCH 9/9] cpuidle: Use local_clock_noinstr()
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

On Mon, May 8, 2023 at 11:34 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> With the introduction of local_clock_noinstr(), local_clock() itself
> is no longer marked noinstr, use the correct function.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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

The above LGTM, but the teo governors uses local_clock() too.  Should
it use the _noinstr() version?
