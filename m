Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03942679BB2
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjAXOZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbjAXOZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:25:07 -0500
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6899346174;
        Tue, 24 Jan 2023 06:25:06 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id az20so39502988ejc.1;
        Tue, 24 Jan 2023 06:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HFiY49QSpECHmg3/XnIBpM7+6TWXqD6hxAB2tKV4uVM=;
        b=trKfX0QKqQCcAFesVGpTCQrZJiut5jfyIjysJCeZjnSzDYYyWMBCxJ4a7MRMIY7nez
         9KrA6eAHK44775RsvUKck63XA6W0+JffAYwRfd65Y7wOwJaPk+uovk6lZJvUkeAMHUbV
         UAipStfZYzkBeBBkYFRYzG+kVlWfBPg9e3/7bwCKTi8QJ8HNU+r7iRK6y/ZgSWNKfa8o
         5UpxenUmhZqPF3r9DArqM0Z0ew2fHjX+rT/y8kJcpvnYt+YfqIq92uv0V6QPtiR1aWb3
         IkiSW60GjGMiMkSHo9Y4iHMIfo6rC2zgBZxZXFPefEF08XciMu5s9qSOnqBX4H9pc42W
         n4Dg==
X-Gm-Message-State: AFqh2kqNJBNsmmwdzZMX3z9ulUSlXyVuaXy3gB99vbPfwhh6Hsk0hO1H
        J188Xw77bRSBWQWtVW/5wkYDSSbsLVs4FCLg5iM=
X-Google-Smtp-Source: AMrXdXuJpYU/fVjzod6h2/vaXZp4NAt4KpSzd9J+SqARc7LgKOGgdEnk0S9WeDDl/G8RAbK5Y/RXyWsg2NY+LUrUB/o=
X-Received: by 2002:a17:907:2b23:b0:877:8b1d:354e with SMTP id
 gc35-20020a1709072b2300b008778b1d354emr2505342ejc.309.1674570304853; Tue, 24
 Jan 2023 06:25:04 -0800 (PST)
MIME-Version: 1.0
References: <20230123205009.790550642@infradead.org> <20230123205515.233366796@infradead.org>
In-Reply-To: <20230123205515.233366796@infradead.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 24 Jan 2023 15:24:53 +0100
Message-ID: <CAJZ5v0jnmyWDQw=VXcViZLUfjjVgkP8TYKg3nS62jANT2qr-mg@mail.gmail.com>
Subject: Re: [PATCH 6/6] cpuidle: Fix poll_idle() noinstr annotation
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, rostedt@goodmis.org, mhiramat@kernel.org,
        wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 9:58 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> The instrumentation_begin()/end() annotations in poll_idle() were
> complete nonsense. Specifically they caused tracing to happen in the
> middle of noinstr code, resulting in RCU splats.
>
> Now that local_clock() is noinstr, mark up the rest and let it rip.
>
> Fixes: 00717eb8c955 ("cpuidle: Annotate poll_idle()")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/oe-lkp/202301192148.58ece903-oliver.sang@intel.com

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/cpuidle/cpuidle.c    |    2 +-
>  drivers/cpuidle/poll_state.c |    2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)
>
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -426,7 +426,7 @@ void cpuidle_reflect(struct cpuidle_devi
>   * @dev:   the cpuidle device
>   *
>   */
> -u64 cpuidle_poll_time(struct cpuidle_driver *drv,
> +__cpuidle u64 cpuidle_poll_time(struct cpuidle_driver *drv,
>                       struct cpuidle_device *dev)
>  {
>         int i;
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -15,7 +15,6 @@ static int __cpuidle poll_idle(struct cp
>  {
>         u64 time_start;
>
> -       instrumentation_begin();
>         time_start = local_clock();
>
>         dev->poll_time_limit = false;
> @@ -42,7 +41,6 @@ static int __cpuidle poll_idle(struct cp
>         raw_local_irq_disable();
>
>         current_clr_polling();
> -       instrumentation_end();
>
>         return index;
>  }
>
>
