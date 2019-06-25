Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE1555A6D
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 23:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfFYV5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 17:57:13 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34588 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfFYV5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 17:57:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id n5so455652otk.1;
        Tue, 25 Jun 2019 14:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NbAodB/1VL8lKt20fh7vnkYvUp5n7q02e/d0E93MYWg=;
        b=BhJY1n/fsw9Px2n8VuuH2BlPOs7i/AOZMgO7ugO6ISJnlq3IRpY3zNVA5H+owZRtk1
         blAp6V5RDJeaXOz2nUJCWEcwMV5TXKbRPQbDp2TnmnIP/JMgZC9GKw4nmfuM9t+lyQRM
         RW4WWl5Zsyd7PEmcWH6gjGh68G6DZNbb1V4EgNHRfI1inFOOTTZ99KCd96bkj1QeCxMn
         V2H2kIKk1opmx//Xv8qE1CMrzXqKShOVp/R97Wckk+7noio5Q7RjtnYtJfJH25DGnqF1
         Y6zEMscJe6GFmun2BGDq65XhrnwmqW+saULn5myFgHSRKmVl1lSiTY7spnAF5Ca3fH5t
         QRPQ==
X-Gm-Message-State: APjAAAX5ZjzzILjWuPXzYqgjKHaEGdANiZkiYXxAEqaeV4Ewo9DozE98
        nZXqGB0UF7COGz98wAti8O18yrNjEn+k54WbxYk=
X-Google-Smtp-Source: APXvYqyLwbP+NAh2EQLv/aaYnKomoUK7qxCsKPpvhRX1mFCwphOJTvqifFxzSfLALH5at2O9gmr+G9TuKl0hyNp0B7s=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr496140oto.118.1561499832215;
 Tue, 25 Jun 2019 14:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190613224532.949768676@redhat.com> <20190613225023.011025297@redhat.com>
In-Reply-To: <20190613225023.011025297@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 25 Jun 2019 23:57:01 +0200
Message-ID: <CAJZ5v0hZgQ=kQy3Eig+XFX50_1NusDLgW8skOqYBmqHHaTcCTw@mail.gmail.com>
Subject: Re: [patch 3/5] cpuidle: add haltpoll governor
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
> The cpuidle_haltpoll governor, in conjunction with the haltpoll cpuidle
> driver, allows guest vcpus to poll for a specified amount of time before
> halting.
> This provides the following benefits to host side polling:
>
>         1) The POLL flag is set while polling is performed, which allows
>            a remote vCPU to avoid sending an IPI (and the associated
>            cost of handling the IPI) when performing a wakeup.
>
>         2) The VM-exit cost can be avoided.
>
> The downside of guest side polling is that polling is performed
> even with other runnable tasks in the host.
>
> Results comparing halt_poll_ns and server/client application
> where a small packet is ping-ponged:
>
> host                                        --> 31.33
> halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
> halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)
>
> For the SAP HANA benchmarks (where idle_spin is a parameter
> of the previous version of the patch, results should be the
> same):
>
> hpns == halt_poll_ns
>
>                           idle_spin=0/   idle_spin=800/    idle_spin=0/
>                           hpns=200000    hpns=0            hpns=800000
> DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
> InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
> DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)      1.29   (-3.7%)
> UpdateC00T03 (1 thread)   4.72           4.18 (-12%)       4.53   (-5%)
>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>
>
> ---
>  Documentation/virtual/guest-halt-polling.txt |   79 ++++++++++++
>  drivers/cpuidle/Kconfig                      |   11 +
>  drivers/cpuidle/governors/Makefile           |    1
>  drivers/cpuidle/governors/haltpoll.c         |  175 +++++++++++++++++++++++++++
>  4 files changed, 266 insertions(+)
>
> Index: linux-2.6.git/drivers/cpuidle/Kconfig
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/Kconfig  2019-06-13 18:05:46.456294042 -0400
> +++ linux-2.6.git/drivers/cpuidle/Kconfig       2019-06-13 18:14:58.981570277 -0400
> @@ -33,6 +33,17 @@
>           Some workloads benefit from using it and it generally should be safe
>           to use.  Say Y here if you are not happy with the alternatives.
>
> +config CPU_IDLE_GOV_HALTPOLL
> +       bool "Haltpoll governor (for virtualized systems)"
> +       depends on KVM_GUEST
> +       help
> +         This governor implements haltpoll idle state selection, to be
> +         used in conjunction with the haltpoll cpuidle driver, allowing
> +         for polling for a certain amount of time before entering idle
> +         state.
> +
> +         Some virtualized workloads benefit from using it.
> +
>  config DT_IDLE_STATES
>         bool
>
> Index: linux-2.6.git/drivers/cpuidle/governors/Makefile
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/governors/Makefile       2019-06-13 18:05:46.456294042 -0400
> +++ linux-2.6.git/drivers/cpuidle/governors/Makefile    2019-06-13 18:10:53.861444033 -0400
> @@ -6,3 +6,4 @@
>  obj-$(CONFIG_CPU_IDLE_GOV_LADDER) += ladder.o
>  obj-$(CONFIG_CPU_IDLE_GOV_MENU) += menu.o
>  obj-$(CONFIG_CPU_IDLE_GOV_TEO) += teo.o
> +obj-$(CONFIG_CPU_IDLE_GOV_HALTPOLL) += haltpoll.o
> Index: linux-2.6.git/drivers/cpuidle/governors/haltpoll.c
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/drivers/cpuidle/governors/haltpoll.c  2019-06-13 18:12:46.581615748 -0400
> @@ -0,0 +1,175 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * haltpoll.c - haltpoll idle governor
> + *
> + * Copyright 2019 Red Hat, Inc. and/or its affiliates.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + *
> + * Authors: Marcelo Tosatti <mtosatti@redhat.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/cpuidle.h>
> +#include <linux/time.h>
> +#include <linux/ktime.h>
> +#include <linux/hrtimer.h>
> +#include <linux/tick.h>
> +#include <linux/sched.h>
> +#include <linux/module.h>
> +#include <linux/kvm_para.h>
> +
> +static unsigned int guest_halt_poll_us __read_mostly = 200;
> +module_param(guest_halt_poll_us, uint, 0644);
> +
> +/* division factor to shrink halt_poll_us */
> +static unsigned int guest_halt_poll_shrink __read_mostly = 2;
> +module_param(guest_halt_poll_shrink, uint, 0644);
> +
> +/* multiplication factor to grow per-cpu halt_poll_us */
> +static unsigned int guest_halt_poll_grow __read_mostly = 2;
> +module_param(guest_halt_poll_grow, uint, 0644);
> +
> +/* value in us to start growing per-cpu halt_poll_us */
> +static unsigned int guest_halt_poll_grow_start __read_mostly = 50;
> +module_param(guest_halt_poll_grow_start, uint, 0644);
> +
> +/* allow shrinking guest halt poll */
> +static bool guest_halt_poll_allow_shrink __read_mostly = true;
> +module_param(guest_halt_poll_allow_shrink, bool, 0644);
> +
> +struct haltpoll_device {
> +       int             last_state_idx;
> +       unsigned int    halt_poll_us;
> +};
> +
> +static DEFINE_PER_CPU_ALIGNED(struct haltpoll_device, hpoll_devices);
> +
> +/**
> + * haltpoll_select - selects the next idle state to enter
> + * @drv: cpuidle driver containing state data
> + * @dev: the CPU
> + * @stop_tick: indication on whether or not to stop the tick
> + */
> +static int haltpoll_select(struct cpuidle_driver *drv,
> +                          struct cpuidle_device *dev,
> +                          bool *stop_tick)
> +{
> +       struct haltpoll_device *hdev = this_cpu_ptr(&hpoll_devices);

What about PM QoS constraints?

Especially if the resume latency limit is set to 0?

> +
> +       if (!drv->state_count) {
> +               *stop_tick = false;
> +               return 0;
> +       }
> +
> +       if (hdev->halt_poll_us == 0)
> +               return 1;
> +
> +       /* Last state was poll? */
> +       if (hdev->last_state_idx == 0) {
> +               /* Halt if no event occurred on poll window */
> +               if (dev->poll_time_limit == true)
> +                       return 1;
> +
> +               *stop_tick = false;
> +               /* Otherwise, poll again */
> +               return 0;
> +       }
> +
> +       *stop_tick = false;
> +       /* Last state was halt: poll */
> +       return 0;
> +}
> +
> +static void adjust_haltpoll_us(unsigned int block_us,
> +                              struct haltpoll_device *dev)
> +{
> +       unsigned int val;
> +
> +       /* Grow cpu_halt_poll_us if
> +        * cpu_halt_poll_us < block_ns < guest_halt_poll_us
> +        */
> +       if (block_us > dev->halt_poll_us && block_us <= guest_halt_poll_us) {
> +               val = dev->halt_poll_us * guest_halt_poll_grow;
> +
> +               if (val < guest_halt_poll_grow_start)
> +                       val = guest_halt_poll_grow_start;
> +               if (val > guest_halt_poll_us)
> +                       val = guest_halt_poll_us;
> +
> +               dev->halt_poll_us = val;
> +       } else if (block_us > guest_halt_poll_us &&
> +                  guest_halt_poll_allow_shrink) {
> +               unsigned int shrink = guest_halt_poll_shrink;
> +
> +               val = dev->halt_poll_us;
> +               if (shrink == 0)
> +                       val = 0;
> +               else
> +                       val /= shrink;
> +               dev->halt_poll_us = val;
> +       }
> +}
> +
> +/**
> + * haltpoll_reflect - update variables and update poll time
> + * @dev: the CPU
> + * @index: the index of actual entered state
> + */
> +static void haltpoll_reflect(struct cpuidle_device *dev, int index)
> +{
> +       struct haltpoll_device *hdev = this_cpu_ptr(&hpoll_devices);
> +
> +       hdev->last_state_idx = index;
> +
> +       if (index != 0)
> +               adjust_haltpoll_us(dev->last_residency, hdev);
> +}
> +
> +/**
> + * haltpoll_enable_device - scans a CPU's states and does setup
> + * @drv: cpuidle driver
> + * @dev: the CPU
> + */
> +static int haltpoll_enable_device(struct cpuidle_driver *drv,
> +                                 struct cpuidle_device *dev)
> +{
> +       struct haltpoll_device *hdev = &per_cpu(hpoll_devices, dev->cpu);
> +
> +       memset(hdev, 0, sizeof(struct haltpoll_device));
> +
> +       return 0;
> +}
> +
> +/**
> + * haltpoll_get_poll_time - return amount of poll time
> + * @drv: cpuidle driver
> + * @dev: the CPU
> + */
> +static u64 haltpoll_get_poll_time(struct cpuidle_driver *drv,
> +                               struct cpuidle_device *dev)
> +{
> +       struct haltpoll_device *hdev = &per_cpu(hpoll_devices, dev->cpu);
> +
> +       return hdev->halt_poll_us * NSEC_PER_USEC;
> +}
> +
> +static struct cpuidle_governor haltpoll_governor = {
> +       .name =                 "haltpoll",
> +       .rating =               21,
> +       .enable =               haltpoll_enable_device,
> +       .select =               haltpoll_select,
> +       .reflect =              haltpoll_reflect,
> +       .get_poll_time =        haltpoll_get_poll_time,
> +};
> +
> +static int __init init_haltpoll(void)
> +{
> +       if (kvm_para_available())
> +               return cpuidle_register_governor(&haltpoll_governor);
> +
> +       return 0;
> +}
> +
> +postcore_initcall(init_haltpoll);
> Index: linux-2.6.git/Documentation/virtual/guest-halt-polling.txt
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/Documentation/virtual/guest-halt-polling.txt  2019-06-13 18:16:22.414262777 -0400
> @@ -0,0 +1,79 @@
> +Guest halt polling
> +==================
> +
> +The cpuidle_haltpoll driver, with the haltpoll governor, allows
> +the guest vcpus to poll for a specified amount of time before
> +halting.
> +This provides the following benefits to host side polling:
> +
> +       1) The POLL flag is set while polling is performed, which allows
> +          a remote vCPU to avoid sending an IPI (and the associated
> +          cost of handling the IPI) when performing a wakeup.
> +
> +       2) The VM-exit cost can be avoided.
> +
> +The downside of guest side polling is that polling is performed
> +even with other runnable tasks in the host.
> +
> +The basic logic as follows: A global value, guest_halt_poll_us,
> +is configured by the user, indicating the maximum amount of
> +time polling is allowed. This value is fixed.
> +
> +Each vcpu has an adjustable guest_halt_poll_us
> +("per-cpu guest_halt_poll_us"), which is adjusted by the algorithm
> +in response to events (explained below).
> +
> +Module Parameters
> +=================
> +
> +The haltpoll governor has 5 tunable module parameters:
> +
> +1) guest_halt_poll_us:
> +Maximum amount of time, in microseconds, that polling is
> +performed before halting.
> +
> +Default: 200
> +
> +2) guest_halt_poll_shrink:
> +Division factor used to shrink per-cpu guest_halt_poll_us when
> +wakeup event occurs after the global guest_halt_poll_us.
> +
> +Default: 2
> +
> +3) guest_halt_poll_grow:
> +Multiplication factor used to grow per-cpu guest_halt_poll_us
> +when event occurs after per-cpu guest_halt_poll_us
> +but before global guest_halt_poll_us.
> +
> +Default: 2
> +
> +4) guest_halt_poll_grow_start:
> +The per-cpu guest_halt_poll_us eventually reaches zero
> +in case of an idle system. This value sets the initial
> +per-cpu guest_halt_poll_us when growing. This can
> +be increased from 10, to avoid misses during the initial
> +growth stage:
> +
> +10, 20, 40, ... (example assumes guest_halt_poll_grow=2).
> +
> +Default: 50
> +
> +5) guest_halt_poll_allow_shrink:
> +
> +Bool parameter which allows shrinking. Set to N
> +to avoid it (per-cpu guest_halt_poll_us will remain
> +high once achieves global guest_halt_poll_us value).
> +
> +Default: Y
> +
> +The module parameters can be set from the debugfs files in:
> +
> +       /sys/module/haltpoll/parameters/
> +
> +Further Notes
> +=============
> +
> +- Care should be taken when setting the guest_halt_poll_us parameter as a
> +large value has the potential to drive the cpu usage to 100% on a machine which
> +would be almost entirely idle otherwise.
> +
>
>
