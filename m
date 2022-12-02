Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACB76400BA
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 07:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiLBG4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 01:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiLBG4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 01:56:19 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E5ABC59B
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 22:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669964178; x=1701500178;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LInJB99w88b96dJGMSGwn5B+NNIUcRwF7aAeFsKchhI=;
  b=Pyd0JMJ2Ye1JCDtGmbWRMDnZZIBaQ0LwqffbMpJlq1U7TsUeCjFEk7S5
   XHNwx6CHDeyKZo63LAwihe2ETAQhTINsn9/qDv40e+2GamUt+CJL5wTex
   I8seAesAE12mL4gB+abmOooNLHkFUjZyJ1MSZySC5QFRJ6FJCNcjaUmkU
   dYUj/DO33DXIrnHd4AFAaE9jP6nv3kreyf/PKF+hNUYRbvo770Wct0++g
   ywDiwxaDbFXZZzZZJNaBETau9+rFx+t72DQM/lQmz9iAHiCtORPf0tsEj
   zh26r4lRuiwZl7LYY61ItLEKQMJ18Qwl1b75/Nwk/rhiJCW2HPG7SUlb8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295584316"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295584316"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 22:56:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="769512336"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="769512336"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga004.jf.intel.com with ESMTP; 01 Dec 2022 22:56:15 -0800
Message-ID: <f83c4b94a285dd8b6a9aac6294f3037129d34df5.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/3] accel: introduce accelerator blocker API
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org
Date:   Fri, 02 Dec 2022 14:56:14 +0800
In-Reply-To: <20221111154758.1372674-2-eesposit@redhat.com>
References: <20221111154758.1372674-1-eesposit@redhat.com>
         <20221111154758.1372674-2-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-11-11 at 10:47 -0500, Emanuele Giuseppe Esposito wrote:
> This API allows the accelerators to prevent vcpus from issuing
> new ioctls while execting a critical section marked with the
> accel_ioctl_inhibit_begin/end functions.
> 
> Note that all functions submitting ioctls must mark where the
> ioctl is being called with accel_{cpu_}ioctl_begin/end().
> 
> This API requires the caller to always hold the BQL.
> API documentation is in sysemu/accel-blocker.h
> 
> Internally, it uses a QemuLockCnt together with a per-CPU QemuLockCnt
> (to minimize cache line bouncing) to keep avoid that new ioctls
> run when the critical section starts, and a QemuEvent to wait
> that all running ioctls finish.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  accel/accel-blocker.c          | 154
> +++++++++++++++++++++++++++++++++
>  accel/meson.build              |   2 +-
>  hw/core/cpu-common.c           |   2 +
>  include/hw/core/cpu.h          |   3 +
>  include/sysemu/accel-blocker.h |  56 ++++++++++++
>  5 files changed, 216 insertions(+), 1 deletion(-)
>  create mode 100644 accel/accel-blocker.c
>  create mode 100644 include/sysemu/accel-blocker.h
> 
> diff --git a/accel/accel-blocker.c b/accel/accel-blocker.c
> new file mode 100644
> index 0000000000..1e7f423462
> --- /dev/null
> +++ b/accel/accel-blocker.c
> @@ -0,0 +1,154 @@
> +/*
> + * Lock to inhibit accelerator ioctls
> + *
> + * Copyright (c) 2022 Red Hat Inc.
> + *
> + * Author: Emanuele Giuseppe Esposito       <eesposit@redhat.com>
> + *
> + * Permission is hereby granted, free of charge, to any person
> obtaining a copy
> + * of this software and associated documentation files (the
> "Software"), to deal
> + * in the Software without restriction, including without limitation
> the rights
> + * to use, copy, modify, merge, publish, distribute, sublicense,
> and/or sell
> + * copies of the Software, and to permit persons to whom the
> Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be
> included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
> SHALL
> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
> OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> ARISING FROM,
> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> DEALINGS IN
> + * THE SOFTWARE.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/thread.h"
> +#include "qemu/main-loop.h"
> +#include "hw/core/cpu.h"
> +#include "sysemu/accel-blocker.h"
> +
> +static QemuLockCnt accel_in_ioctl_lock;
> +static QemuEvent accel_in_ioctl_event;
> +
> +void accel_blocker_init(void)
> +{
> +    qemu_lockcnt_init(&accel_in_ioctl_lock);
> +    qemu_event_init(&accel_in_ioctl_event, false);
> +}
> +
> +void accel_ioctl_begin(void)
> +{
> +    if (likely(qemu_mutex_iothread_locked())) {
> +        return;
> +    }
> +
> +    /* block if lock is taken in kvm_ioctl_inhibit_begin() */
> +    qemu_lockcnt_inc(&accel_in_ioctl_lock);
> +}
> +
> +void accel_ioctl_end(void)
> +{
> +    if (likely(qemu_mutex_iothread_locked())) {
> +        return;
> +    }
> +
> +    qemu_lockcnt_dec(&accel_in_ioctl_lock);
> +    /* change event to SET. If event was BUSY, wake up all waiters
> */
> +    qemu_event_set(&accel_in_ioctl_event);
> +}
> +
> +void accel_cpu_ioctl_begin(CPUState *cpu)
> +{
> +    if (unlikely(qemu_mutex_iothread_locked())) {
> +        return;
> +    }
> +
> +    /* block if lock is taken in kvm_ioctl_inhibit_begin() */
> +    qemu_lockcnt_inc(&cpu->in_ioctl_lock);
> +}
> +
> +void accel_cpu_ioctl_end(CPUState *cpu)
> +{
> +    if (unlikely(qemu_mutex_iothread_locked())) {
> +        return;
> +    }
> +
> +    qemu_lockcnt_dec(&cpu->in_ioctl_lock);
> +    /* change event to SET. If event was BUSY, wake up all waiters
> */
> +    qemu_event_set(&accel_in_ioctl_event);
> +}
> +
> +static bool accel_has_to_wait(void)
> +{
> +    CPUState *cpu;
> +    bool needs_to_wait = false;
> +
> +    CPU_FOREACH(cpu) {
> +        if (qemu_lockcnt_count(&cpu->in_ioctl_lock)) {
> +            /* exit the ioctl, if vcpu is running it */
> +            qemu_cpu_kick(cpu);
> +            needs_to_wait = true;
> +        }
> +    }
> +
> +    return needs_to_wait ||
> qemu_lockcnt_count(&accel_in_ioctl_lock);
> +}
> +
> +void accel_ioctl_inhibit_begin(void)
> +{
> +    CPUState *cpu;
> +
> +    /*
> +     * We allow to inhibit only when holding the BQL, so we can
> identify
> +     * when an inhibitor wants to issue an ioctl easily.
> +     */
> +    g_assert(qemu_mutex_iothread_locked());
> +
> +    /* Block further invocations of the ioctls outside the BQL.  */
> +    CPU_FOREACH(cpu) {
> +        qemu_lockcnt_lock(&cpu->in_ioctl_lock);
> +    }
> +    qemu_lockcnt_lock(&accel_in_ioctl_lock);
> +
> +    /* Keep waiting until there are running ioctls */
> +    while (true) {
> +
> +        /* Reset event to FREE. */
> +        qemu_event_reset(&accel_in_ioctl_event);
> +
> +        if (accel_has_to_wait()) {
> +            /*
> +             * If event is still FREE, and there are ioctls still in
> progress,
> +             * wait.
> +             *
> +             *  If an ioctl finishes before qemu_event_wait(), it
> will change
> +             * the event state to SET. This will prevent
> qemu_event_wait() from
> +             * blocking, but it's not a problem because if other
> ioctls are
> +             * still running the loop will iterate once more and
> reset the event
> +             * status to FREE so that it can wait properly.
> +             *
> +             * If an ioctls finishes while qemu_event_wait() is
> blocking, then
> +             * it will be waken up, but also here the while loop
> makes sure
> +             * to re-enter the wait if there are other running
> ioctls.
> +             */
> +            qemu_event_wait(&accel_in_ioctl_event);
> +        } else {
> +            /* No ioctl is running */
> +            return;
> +        }
> +    }
> +}
> +
> +void accel_ioctl_inhibit_end(void)
> +{
> +    CPUState *cpu;
> +
> +    qemu_lockcnt_unlock(&accel_in_ioctl_lock);
> +    CPU_FOREACH(cpu) {
> +        qemu_lockcnt_unlock(&cpu->in_ioctl_lock);
> +    }
> +}
> +
> diff --git a/accel/meson.build b/accel/meson.build
> index b9a963cf80..a0d49c4f31 100644
> --- a/accel/meson.build
> +++ b/accel/meson.build
> @@ -1,4 +1,4 @@
> -specific_ss.add(files('accel-common.c'))
> +specific_ss.add(files('accel-common.c', 'accel-blocker.c'))
>  softmmu_ss.add(files('accel-softmmu.c'))
>  user_ss.add(files('accel-user.c'))
>  
> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
> index f9fdd46b9d..8d6a4b1b65 100644
> --- a/hw/core/cpu-common.c
> +++ b/hw/core/cpu-common.c
> @@ -237,6 +237,7 @@ static void cpu_common_initfn(Object *obj)
>      cpu->nr_threads = 1;
>  
>      qemu_mutex_init(&cpu->work_mutex);
> +    qemu_lockcnt_init(&cpu->in_ioctl_lock);
>      QSIMPLEQ_INIT(&cpu->work_list);
>      QTAILQ_INIT(&cpu->breakpoints);
>      QTAILQ_INIT(&cpu->watchpoints);
> @@ -248,6 +249,7 @@ static void cpu_common_finalize(Object *obj)
>  {
>      CPUState *cpu = CPU(obj);
>  
> +    qemu_lockcnt_destroy(&cpu->in_ioctl_lock);
>      qemu_mutex_destroy(&cpu->work_mutex);
>  }
>  
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index f9b58773f7..15053663bc 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -397,6 +397,9 @@ struct CPUState {
>      uint32_t kvm_fetch_index;
>      uint64_t dirty_pages;
>  
> +    /* Use by accel-block: CPU is executing an ioctl() */
> +    QemuLockCnt in_ioctl_lock;
> +
>      /* Used for events with 'vcpu' and *without* the 'disabled'
> properties */
>      DECLARE_BITMAP(trace_dstate_delayed,
> CPU_TRACE_DSTATE_MAX_EVENTS);
>      DECLARE_BITMAP(trace_dstate, CPU_TRACE_DSTATE_MAX_EVENTS);
> diff --git a/include/sysemu/accel-blocker.h b/include/sysemu/accel-
> blocker.h
> new file mode 100644
> index 0000000000..72020529ef
> --- /dev/null
> +++ b/include/sysemu/accel-blocker.h
> @@ -0,0 +1,56 @@
> +/*
> + * Accelerator blocking API, to prevent new ioctls from starting and
> wait the
> + * running ones finish.
> + * This mechanism differs from pause/resume_all_vcpus() in that it
> does not
> + * release the BQL.
> + *
> + *  Copyright (c) 2022 Red Hat Inc.
> + *
> + * Author: Emanuele Giuseppe Esposito       <eesposit@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2
> or later.
> + * See the COPYING file in the top-level directory.
> + */
> +#ifndef ACCEL_BLOCKER_H
> +#define ACCEL_BLOCKER_H
> +
> +#include "qemu/osdep.h"
> +#include "sysemu/cpus.h"
> +
> +extern void accel_blocker_init(void);
> +
> +/*
> + * accel_{cpu_}ioctl_begin/end:
> + * Mark when ioctl is about to run or just finished.
> + *
> + * accel_{cpu_}ioctl_begin will block after
> accel_ioctl_inhibit_begin() is
> + * called, preventing new ioctls to run. They will continue only
> after
> + * accel_ioctl_inibith_end().

Typo inibith --> inhibit

> + */
> +extern void accel_ioctl_begin(void);
> +extern void accel_ioctl_end(void);
> +extern void accel_cpu_ioctl_begin(CPUState *cpu);
> +extern void accel_cpu_ioctl_end(CPUState *cpu);
> +
> +/*
> + * accel_ioctl_inhibit_begin: start critical section
> + *
> + * This function makes sure that:
> + * 1) incoming accel_{cpu_}ioctl_begin() calls block
> + * 2) wait that all ioctls that were already running reach
> + *    accel_{cpu_}ioctl_end(), kicking vcpus if necessary.
> + *
> + * This allows the caller to access shared data or perform
> operations without
> + * worrying of concurrent vcpus accesses.
> + */
> +extern void accel_ioctl_inhibit_begin(void);
> +
> +/*
> + * accel_ioctl_inhibit_end: end critical section started by
> + * accel_ioctl_inhibit_begin()
> + *
> + * This function allows blocked accel_{cpu_}ioctl_begin() to
> continue.
> + */
> +extern void accel_ioctl_inhibit_end(void);
> +

git am complains ".git/rebase-apply/patch:170: new blank line at EOF."

> +#endif /* ACCEL_BLOCKER_H */

