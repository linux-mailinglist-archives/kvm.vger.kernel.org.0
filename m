Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8335D55A3C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFYVuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 17:50:18 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35994 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFYVuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 17:50:17 -0400
Received: by mail-oi1-f193.google.com with SMTP id w7so334975oic.3;
        Tue, 25 Jun 2019 14:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63ctMGJeD31+Btr223CgvRlIKazM5VvhjqXvwryVEig=;
        b=sxW2SzfXVZdCfUJ6dP1VxPqxT54PN7T8VkPEIED/0ivtxcBTHf5NRSI7ojtrAa9bMo
         mxpTBNW2lmfyTkYRCWqz43VZV//Z9nsDlm7r6uPEC3EgT7yLOpvw1GorkfK+JozIf+wu
         tWKKSbBEEi7eTxK4CqCltPsi5Fu310zNapSyoplirosEB473mxgsNPFdlVfogTjZpidn
         s37mi/TtK/Nx3VvZlRNTKAgXxvKbV91aP0wyg1FZVWZyNva1as64y6b3Dbyn6BETSgKg
         p7if9RaQUoBEMBKJJuovIuJWYlXj9wonLcwp7P2vRmrIgXdnih8hQThCI7GIPF4ksgC9
         kxaA==
X-Gm-Message-State: APjAAAXnrhpTvJNZJrNPu9J806NyL8A7x+Jgbyqn85cfisacDlDx5El0
        xwl7HSDv1ajuDj/LypmyI8m09aKQKt/oFuzdMPs=
X-Google-Smtp-Source: APXvYqzsqA+FE6+lWUuUpexxRcYdb7lD8KSO5PSEpcfyNerv9/QsInosGAdM3VwbdytwHapnVmk+ntMisRa+M157GYk=
X-Received: by 2002:aca:4e89:: with SMTP id c131mr15993167oib.57.1561499416532;
 Tue, 25 Jun 2019 14:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190613224532.949768676@redhat.com> <20190613225022.932697232@redhat.com>
In-Reply-To: <20190613225022.932697232@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 25 Jun 2019 23:50:04 +0200
Message-ID: <CAJZ5v0g2ZnO2ykWXmP6HAcnMxQOsVj4jJkG9UooyU8sf+3UZ=g@mail.gmail.com>
Subject: Re: [patch 1/5] drivers/cpuidle: add cpuidle-haltpoll driver
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
> Add a cpuidle driver that calls the architecture default_idle routine.
>
> To be used in conjunction with the haltpoll governor.
>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>
> ---
>  arch/x86/kernel/process.c          |    2 -
>  drivers/cpuidle/Kconfig            |    9 +++++
>  drivers/cpuidle/Makefile           |    1
>  drivers/cpuidle/cpuidle-haltpoll.c |   65 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 76 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.git/arch/x86/kernel/process.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/process.c        2019-06-13 16:19:27.877064340 -0400
> +++ linux-2.6.git/arch/x86/kernel/process.c     2019-06-13 16:19:48.795544892 -0400
> @@ -580,7 +580,7 @@
>         safe_halt();
>         trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>  }
> -#ifdef CONFIG_APM_MODULE
> +#if defined(CONFIG_APM_MODULE) || defined(CONFIG_HALTPOLL_CPUIDLE_MODULE)
>  EXPORT_SYMBOL(default_idle);
>  #endif
>
> Index: linux-2.6.git/drivers/cpuidle/Kconfig
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/Kconfig  2019-06-13 16:19:27.878064316 -0400
> +++ linux-2.6.git/drivers/cpuidle/Kconfig       2019-06-13 18:41:40.599912671 -0400
> @@ -51,6 +51,15 @@
>  source "drivers/cpuidle/Kconfig.powerpc"
>  endmenu
>
> +config HALTPOLL_CPUIDLE
> +       tristate "Halt poll cpuidle driver"
> +       depends on X86
> +       default y
> +       help
> +         This option enables halt poll cpuidle driver, which allows to poll
> +         before halting in the guest (more efficient than polling in the
> +         host via halt_poll_ns for some scenarios).
> +
>  endif
>
>  config ARCH_NEEDS_CPU_IDLE_COUPLED
> Index: linux-2.6.git/drivers/cpuidle/Makefile
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/Makefile 2019-06-13 16:19:27.878064316 -0400
> +++ linux-2.6.git/drivers/cpuidle/Makefile      2019-06-13 16:19:48.796544867 -0400
> @@ -7,6 +7,7 @@
>  obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
>  obj-$(CONFIG_DT_IDLE_STATES)             += dt_idle_states.o
>  obj-$(CONFIG_ARCH_HAS_CPU_RELAX)         += poll_state.o
> +obj-$(CONFIG_HALTPOLL_CPUIDLE)           += cpuidle-haltpoll.o
>
>  ##################################################################################
>  # ARM SoC drivers
> Index: linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c    2019-06-13 18:41:39.305933413 -0400
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * cpuidle driver for haltpoll governor.
> + *
> + * Copyright 2019 Red Hat, Inc. and/or its affiliates.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + *
> + * Authors: Marcelo Tosatti <mtosatti@redhat.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/cpuidle.h>
> +#include <linux/module.h>
> +#include <linux/sched/idle.h>
> +
> +static int default_enter_idle(struct cpuidle_device *dev,
> +                             struct cpuidle_driver *drv, int index)
> +{
> +       if (current_clr_polling_and_test()) {
> +               local_irq_enable();
> +               return index;
> +       }
> +       default_idle();
> +       return index;
> +}
> +
> +static struct cpuidle_driver haltpoll_driver = {
> +       .name = "haltpoll",
> +       .owner = THIS_MODULE,
> +       .states = {
> +               { /* entry 0 is for polling */ },
> +               {
> +                       .enter                  = default_enter_idle,
> +                       .exit_latency           = 0,
> +                       .target_residency       = 0,
> +                       .power_usage            = -1,
> +                       .name                   = "haltpoll idle",
> +                       .desc                   = "default architecture idle",
> +               },
> +       },
> +       .safe_state_index = 0,
> +       .state_count = 2,
> +};
> +
> +static int __init haltpoll_init(void)
> +{
> +       struct cpuidle_driver *drv = &haltpoll_driver;
> +
> +       cpuidle_poll_state_init(drv);
> +
> +       return cpuidle_register(&haltpoll_driver, NULL);

Would it be practical to prevent this driver from loading on non-virt?

> +}
> +
> +static void __exit haltpoll_exit(void)
> +{
> +       cpuidle_unregister(&haltpoll_driver);
> +}
> +
> +module_init(haltpoll_init);
> +module_exit(haltpoll_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Marcelo Tosatti <mtosatti@redhat.com>");
> +

Apart from the above it is simple enough.
