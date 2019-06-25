Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172FB55A45
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 23:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfFYVwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 17:52:22 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43016 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYVwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 17:52:22 -0400
Received: by mail-ot1-f66.google.com with SMTP id i8so392643oth.10;
        Tue, 25 Jun 2019 14:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PeaFG8sSRkL5QAtxQVwgKRYjmhEoU7m8Mrz4PHoXbbM=;
        b=Wazoq6q9TgpSDN9JCCzbnIB12gabbyyjyqc7rAg4HYSJkNFu5oWKaUuvC3yRHbjAkt
         Z6mJLTW0S4zhmDAgso96Q1Lc407kZdrkcsYWpx69QxhY2alD1KOCxv7zV3XaJrfqB7Fc
         zsvDIQgGbBTDxI/o8xtuiR4k1ix7lPE4R9rdPw/8jUjklPyeUWs83NY0/W2eJqSXaeOe
         +EQfN+KwsHqM6Thou3UNXLUAkxRRRQ+zC9B8J1fBLvAwVmvMTo5fYcSqMbIhYue3vWVj
         EMmXzkp0MBBiaFDaPiUyHQ4gqgWyvL9Jn66lNVPPFVMzDbF3jAMzSYOjm9t0xOVV7/Jl
         Qj7Q==
X-Gm-Message-State: APjAAAWJDjo6dfFcKXRA5SGJN4NQWK4y4Pz7RVI3eYby4fh3dohSigC0
        F/bUEGZjmaN5HaoR7ItirA6Rte5v6rMCZYGaLWE=
X-Google-Smtp-Source: APXvYqy8BxtHUbcupP14Lxe4doqiR7htSMLrRY5rExwS7ddnb7PARJevSrO3sL8XIu071ybtyaaHKmyqw/LoeqVjRVI=
X-Received: by 2002:a9d:5d15:: with SMTP id b21mr493957oti.262.1561499541231;
 Tue, 25 Jun 2019 14:52:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190613224532.949768676@redhat.com> <20190613225022.969533311@redhat.com>
In-Reply-To: <20190613225022.969533311@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 25 Jun 2019 23:52:10 +0200
Message-ID: <CAJZ5v0jk=jO2yVMDA-aNB6_DFW-zg9dBT9zxYPDDNsGa-jUYhA@mail.gmail.com>
Subject: Re: [patch 2/5] cpuidle: add get_poll_time callback
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 12:55 AM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> Add a "get_poll_time" callback to the cpuidle_governor structure,
> and change poll state to poll for that amount of time.
>
> Provide a default method for it, while allowing individual governors
> to override it.
>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Fair enough:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

>
> ---
>  drivers/cpuidle/cpuidle.c    |   40 ++++++++++++++++++++++++++++++++++++++++
>  drivers/cpuidle/poll_state.c |   11 ++---------
>  include/linux/cpuidle.h      |    8 ++++++++
>  3 files changed, 50 insertions(+), 9 deletions(-)
>
> Index: linux-2.6.git/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/cpuidle.c        2019-06-13 17:57:33.111185824 -0400
> +++ linux-2.6.git/drivers/cpuidle/cpuidle.c     2019-06-13 18:09:48.158500660 -0400
> @@ -362,6 +362,46 @@
>  }
>
>  /**
> + * cpuidle_default_poll_time - default routine used to return poll time
> + * governors can override it if necessary
> + *
> + * @drv:   the cpuidle driver tied with the cpu
> + * @dev:   the cpuidle device
> + *
> + */
> +static u64 cpuidle_default_poll_time(struct cpuidle_driver *drv,
> +                                    struct cpuidle_device *dev)
> +{
> +       int i;
> +
> +       for (i = 1; i < drv->state_count; i++) {
> +               if (drv->states[i].disabled || dev->states_usage[i].disable)
> +                       continue;
> +
> +               return (u64)drv->states[i].target_residency * NSEC_PER_USEC;
> +       }
> +
> +       return TICK_NSEC;
> +}
> +
> +/**
> + * cpuidle_get_poll_time - tell the polling driver how much time to poll,
> + *                        in nanoseconds.
> + *
> + * @drv: the cpuidle driver tied with the cpu
> + * @dev: the cpuidle device
> + *
> + */
> +u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
> +                         struct cpuidle_device *dev)
> +{
> +       if (cpuidle_curr_governor->get_poll_time)
> +               return cpuidle_curr_governor->get_poll_time(drv, dev);
> +
> +       return cpuidle_default_poll_time(drv, dev);
> +}
> +
> +/**
>   * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
>   */
>  void cpuidle_install_idle_handler(void)
> Index: linux-2.6.git/drivers/cpuidle/poll_state.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/poll_state.c     2019-06-13 17:57:33.111185824 -0400
> +++ linux-2.6.git/drivers/cpuidle/poll_state.c  2019-06-13 18:01:19.846944820 -0400
> @@ -20,16 +20,9 @@
>         local_irq_enable();
>         if (!current_set_polling_and_test()) {
>                 unsigned int loop_count = 0;
> -               u64 limit = TICK_NSEC;
> -               int i;
> +               u64 limit;
>
> -               for (i = 1; i < drv->state_count; i++) {
> -                       if (drv->states[i].disabled || dev->states_usage[i].disable)
> -                               continue;
> -
> -                       limit = (u64)drv->states[i].target_residency * NSEC_PER_USEC;
> -                       break;
> -               }
> +               limit = cpuidle_get_poll_time(drv, dev);
>
>                 while (!need_resched()) {
>                         cpu_relax();
> Index: linux-2.6.git/include/linux/cpuidle.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/cpuidle.h  2019-06-13 17:57:33.111185824 -0400
> +++ linux-2.6.git/include/linux/cpuidle.h       2019-06-13 18:01:19.846944820 -0400
> @@ -132,6 +132,8 @@
>  extern int cpuidle_enter(struct cpuidle_driver *drv,
>                          struct cpuidle_device *dev, int index);
>  extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
> +extern u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
> +                                struct cpuidle_device *dev);
>
>  extern int cpuidle_register_driver(struct cpuidle_driver *drv);
>  extern struct cpuidle_driver *cpuidle_get_driver(void);
> @@ -166,6 +168,9 @@
>                                 struct cpuidle_device *dev, int index)
>  {return -ENODEV; }
>  static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
> +extern u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
> +                                struct cpuidle_device *dev)
> +{return 0; }
>  static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
>  {return -ENODEV; }
>  static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
> @@ -246,6 +251,9 @@
>                                         struct cpuidle_device *dev,
>                                         bool *stop_tick);
>         void (*reflect)         (struct cpuidle_device *dev, int index);
> +
> +       u64 (*get_poll_time)    (struct cpuidle_driver *drv,
> +                                       struct cpuidle_device *dev);
>  };
>
>  #ifdef CONFIG_CPU_IDLE
>
>
