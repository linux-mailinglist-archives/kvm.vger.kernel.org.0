Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C343E5E160
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 11:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfGCJuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 05:50:15 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39886 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGCJuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 05:50:15 -0400
Received: by mail-ot1-f65.google.com with SMTP id r21so1242145otq.6;
        Wed, 03 Jul 2019 02:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eVDpZqNVKfDH81FMIhW5D5AvZcKedRrg5UD+AQd2js4=;
        b=n0iwR7qQKCZQOXFT1su42mWvFa0xvs6cJoM4B0gIs77H753iO6Jyp2guypCsvCBhpx
         9cKNCM1GYFdbOuEpeVB6oa0CwE0OjCv79YKFtR18Il6YyKR8lHjXFOC3bzZ3T8EvM/1I
         iB3DTxUamyyvDZ3C2QHNI/YYAox4faZXJJaxH2SIATTVwumlOitISWZcZFdWK3G2OPHW
         2UPsV3H1J1P+cdWPpXKO4SIQmmTu6ftktyCFXFxjqFWpMgvIaZUQVtw27oBVFCLr7vNv
         XZ1Y8dM/TLq9/3rmgawxlTXt1N/Gp2Ohaz22Y50cczQ8FapRk5Mbrts7+XMuCzuIibTz
         9DrA==
X-Gm-Message-State: APjAAAVjcQ55hk5BBSItXp1jyWrFV4Q+JbM9uXITirxvB/ctj1ygnAhP
        haQV+3oUhIwIKTaOWNSjVCKsuktQzuy6TR+bOyQ=
X-Google-Smtp-Source: APXvYqxc0AuWra/GtSKsZAsOnVyRRHpZMhfhRYbQ4kKlbG/fZZNfGz2iEM31aB897pMUJbc4ahWriMkAX7n0J4ADoKA=
X-Received: by 2002:a9d:6a4b:: with SMTP id h11mr13574308otn.266.1562147414257;
 Wed, 03 Jul 2019 02:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190701185310.540706841@asus.localdomain> <20190701185528.115106953@asus.localdomain>
In-Reply-To: <20190701185528.115106953@asus.localdomain>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 3 Jul 2019 11:50:03 +0200
Message-ID: <CAJZ5v0gAKpFZRFB2HNZwshpk8jW-EO2uTNo5fk69vRZbm_Bv-A@mail.gmail.com>
Subject: Re: [patch 2/5] cpuidle: add get_poll_time callback
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
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
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 1, 2019 at 8:57 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> Add a "get_poll_time" callback to the cpuidle_governor structure,
> and change poll state to poll for that amount of time.
>
> Provide a default method for it, while allowing individual governors
> to override it.
>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

I had ACKed this before, but then it occurred to me that it would be
less intrusive to use a new field, say poll_limit_ns (equal to 0 by
default), in struct cpuidle_device.

>
> ---
>  drivers/cpuidle/cpuidle.c    |   40 ++++++++++++++++++++++++++++++++++++++++
>  drivers/cpuidle/poll_state.c |   11 ++---------
>  include/linux/cpuidle.h      |    8 ++++++++
>  3 files changed, 50 insertions(+), 9 deletions(-)
>
> Index: linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/cpuidle.c
> +++ linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle.c
> @@ -362,6 +362,46 @@ void cpuidle_reflect(struct cpuidle_devi
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

With this new field in place this could be called cpuidle_poll_time() and ->

> +{
> +       int i;

-> do something like this here:

if (dev->poll_limit_ns)
        return dev->poll_limit_ns;

and the governor changes below wouldn't be necessary any more.

Then, the governor could update poll_limit_ns if it wanted to override
the default.

It also would be possible to use poll_limit_ns as a sort of poll limit
cache to store the last value in it and clear it on state
disable/enable to avoid the search through the states every time even
without haltpoll.

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
> Index: linux-2.6-newcpuidle.git/drivers/cpuidle/poll_state.c
> ===================================================================
> --- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/poll_state.c
> +++ linux-2.6-newcpuidle.git/drivers/cpuidle/poll_state.c
> @@ -20,16 +20,9 @@ static int __cpuidle poll_idle(struct cp
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
> Index: linux-2.6-newcpuidle.git/include/linux/cpuidle.h
> ===================================================================
> --- linux-2.6-newcpuidle.git.orig/include/linux/cpuidle.h
> +++ linux-2.6-newcpuidle.git/include/linux/cpuidle.h
> @@ -132,6 +132,8 @@ extern int cpuidle_select(struct cpuidle
>  extern int cpuidle_enter(struct cpuidle_driver *drv,
>                          struct cpuidle_device *dev, int index);
>  extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
> +extern u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
> +                                struct cpuidle_device *dev);
>
>  extern int cpuidle_register_driver(struct cpuidle_driver *drv);
>  extern struct cpuidle_driver *cpuidle_get_driver(void);
> @@ -166,6 +168,9 @@ static inline int cpuidle_enter(struct c
>                                 struct cpuidle_device *dev, int index)
>  {return -ENODEV; }
>  static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
> +extern u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
> +                                struct cpuidle_device *dev)
> +{return 0; }
>  static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
>  {return -ENODEV; }
>  static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
> @@ -246,6 +251,9 @@ struct cpuidle_governor {
>                                         struct cpuidle_device *dev,
>                                         bool *stop_tick);
>         void (*reflect)         (struct cpuidle_device *dev, int index);
> +
> +       u64 (*get_poll_time)    (struct cpuidle_driver *drv,
> +                                struct cpuidle_device *dev);
>  };
>
>  #ifdef CONFIG_CPU_IDLE
>
>
