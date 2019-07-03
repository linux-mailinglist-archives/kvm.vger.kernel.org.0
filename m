Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86595E176
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 11:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGCJyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 05:54:54 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34197 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfGCJyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 05:54:54 -0400
Received: by mail-ot1-f65.google.com with SMTP id n5so1739164otk.1;
        Wed, 03 Jul 2019 02:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VaTxAIN0pDHUzuzL+NSP80OSIfX+XiV7VjvWB84HnSM=;
        b=d1DrVrKmy8NZUd31P7C4cEv/l7shpXlV4s3l1LIdV3rBH/V3vEZXpts6FUKnEBQr+o
         K71z9Nl8pIypwBYxy8Uq/b9+Ev9FKG3yMcoYTiL24Co3cu31fUnVFJYBtwAG87wIWYYy
         pHNEKi5kX12NYnuWm4XbTurxVmivsLWugVP5JQxQawVXT7tCnGjWhJxRAwHgtSLSjvK/
         +I9q1VpVLiWk0rjH20SJQXjB6T3DufMwgf6FGBUcUEyQum0m2LJF0J/MCUjH//X4DBfF
         PfWS//uI4UYgdYurPEROy/06t8QD/btzpJ2hzbffwdzcNCzb91z+GMo7B7dVsSkH7buB
         d1Qw==
X-Gm-Message-State: APjAAAXlTwk3DZfFtPmdfvsqPhx7gygzQHfKwPAFmrpsha4hX98spXVe
        OlVQQJzsTI7PLSxXuuIHmBRkb1cYudHZwXnVDMk=
X-Google-Smtp-Source: APXvYqxSMGBc9GvsapfI+f6+YWH7rqqjRbHUNO8qO6Fmw0BKpBQ0N7qVphlZ8aT04uFN9XSO+AV67jip+4faOjM7EgE=
X-Received: by 2002:a05:6830:8a:: with SMTP id a10mr10589100oto.167.1562147693136;
 Wed, 03 Jul 2019 02:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190701185310.540706841@asus.localdomain> <20190701185528.078114514@asus.localdomain>
In-Reply-To: <20190701185528.078114514@asus.localdomain>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 3 Jul 2019 11:54:42 +0200
Message-ID: <CAJZ5v0h30V5pvZoUHuC8Ct7RNLGV8u-CEFSgwfa0_A3kqsRC_A@mail.gmail.com>
Subject: Re: [patch 1/5] add cpuidle-haltpoll driver
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
> Add a cpuidle driver that calls the architecture default_idle routine.
>
> To be used in conjunction with the haltpoll governor.
>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

>
> ---
>  arch/x86/kernel/process.c          |    2 -
>  drivers/cpuidle/Kconfig            |    9 +++++
>  drivers/cpuidle/Makefile           |    1
>  drivers/cpuidle/cpuidle-haltpoll.c |   65 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 76 insertions(+), 1 deletion(-)
>
> Index: linux-2.6-newcpuidle.git/arch/x86/kernel/process.c
> ===================================================================
> --- linux-2.6-newcpuidle.git.orig/arch/x86/kernel/process.c
> +++ linux-2.6-newcpuidle.git/arch/x86/kernel/process.c
> @@ -580,7 +580,7 @@ void __cpuidle default_idle(void)
>         safe_halt();
>         trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>  }
> -#ifdef CONFIG_APM_MODULE
> +#if defined(CONFIG_APM_MODULE) || defined(CONFIG_HALTPOLL_CPUIDLE_MODULE)
>  EXPORT_SYMBOL(default_idle);
>  #endif
>
> Index: linux-2.6-newcpuidle.git/drivers/cpuidle/Kconfig
> ===================================================================
> --- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/Kconfig
> +++ linux-2.6-newcpuidle.git/drivers/cpuidle/Kconfig
> @@ -51,6 +51,15 @@ depends on PPC
>  source "drivers/cpuidle/Kconfig.powerpc"
>  endmenu
>
> +config HALTPOLL_CPUIDLE
> +       tristate "Halt poll cpuidle driver"
> +       depends on X86 && KVM_GUEST
> +       default y
> +       help
> +         This option enables halt poll cpuidle driver, which allows to poll
> +         before halting in the guest (more efficient than polling in the
> +         host via halt_poll_ns for some scenarios).
> +
>  endif
>
>  config ARCH_NEEDS_CPU_IDLE_COUPLED
> Index: linux-2.6-newcpuidle.git/drivers/cpuidle/Makefile
> ===================================================================
> --- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/Makefile
> +++ linux-2.6-newcpuidle.git/drivers/cpuidle/Makefile
> @@ -7,6 +7,7 @@ obj-y += cpuidle.o driver.o governor.o s
>  obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
>  obj-$(CONFIG_DT_IDLE_STATES)             += dt_idle_states.o
>  obj-$(CONFIG_ARCH_HAS_CPU_RELAX)         += poll_state.o
> +obj-$(CONFIG_HALTPOLL_CPUIDLE)           += cpuidle-haltpoll.o
>
>  ##################################################################################
>  # ARM SoC drivers
> Index: linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -0,0 +1,69 @@
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
> +#include <linux/kvm_para.h>
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
> +                       .exit_latency           = 1,
> +                       .target_residency       = 1,
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
> +       if (!kvm_para_available())
> +               return 0;
> +
> +       return cpuidle_register(&haltpoll_driver, NULL);
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
>
>
