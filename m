Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3E47366A
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 22:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243086AbhLMVMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 16:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242733AbhLMVMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 16:12:18 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF95C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 13:12:17 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id j2so41370478ybg.9
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 13:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=My/OmXhiq7OcGWJQkiyFCdd+Kv9m1hhBpvsAaIS748A=;
        b=sY0boUSc1kTXk72pj3AYCRHIOA8Z6v1zNg5f88fHXl3fc5dDyTD5tq09jKOUVmGhPK
         CItGWETFsRFeAZEYlBFXT9SNE6uCVO24zMKr5NFAubzN/HM0eTO+j6Q+4WrFA00zhBMy
         Lzi/fevPTDecqL4v1GIYSjkUz14rZmPCcu4nw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=My/OmXhiq7OcGWJQkiyFCdd+Kv9m1hhBpvsAaIS748A=;
        b=6+9Ofvr3slchwnf08cFUrUjJPxSC0GZ000wbX0TjA65eC05TFslvwxlNlztD+xYZeT
         qK/ApHC10xz22l0Fjv5RYZ+gRLJHipioXeSIPmIcygba4VZ0FO0kR0V+RkcMAzHeIFqB
         akkLbo+80jKWZJH+otk7LGK0SDKuvYh+3toONcug7QJ2rAzMF97UDrQj0nriIoVLEegW
         m/9JBay120xn/REaI3AdPAnL2BDLiHCfcasr+kYyTyMD4uX0rtCLu0aK9K/G0kzmyCzG
         Ff4Ieor96hFHnYc0tLbB7ROOuhA+8BUoVwS9s7oNxhGWggBGKLDK7tHi2/q8dyB4D1Dk
         2f7w==
X-Gm-Message-State: AOAM531DYrTuGdvuBtgVl2ICKdiQrViutGlWBRiM8AqDZrod8nj7dX9m
        JyIWEp3kjzLQN51EM/3XpoLrYb/u8ZoKi0XqBnM4
X-Google-Smtp-Source: ABdhPJyXbSLGCxibT4a70SEhm5mStRU/zPOS5amju8xNPK1f0j5SugkLU631wl+AaxrsP+OLo83bRKYQEBu7AaRlO50=
X-Received: by 2002:a25:bf8d:: with SMTP id l13mr1054805ybk.713.1639429937040;
 Mon, 13 Dec 2021 13:12:17 -0800 (PST)
MIME-Version: 1.0
References: <20211204002038.113653-1-atishp@atishpatra.org>
 <20211204002038.113653-4-atishp@atishpatra.org> <48012a35c4f66340547ff50525792a29@kernel.org>
In-Reply-To: <48012a35c4f66340547ff50525792a29@kernel.org>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 13 Dec 2021 13:12:06 -0800
Message-ID: <CAOnJCUJQrOqEX94Zcv_rfZj3ja0mrM-3NSWwgxj_sn_Q+aHTmQ@mail.gmail.com>
Subject: Re: [RFC 3/6] RISC-V: Use __cpu_up_stack/task_pointer only for
 spinwait method
To:     Marc Zyngier <maz@kernel.org>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 4:59 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2021-12-04 00:20, Atish Patra wrote:
> > From: Atish Patra <atishp@rivosinc.com>
> >
> > The __cpu_up_stack/task_pointer array is only used for spinwait method
> > now. The per cpu array based lookup is also fragile for platforms with
> > discontiguous/sparse hartids. The spinwait method is only used for
> > M-mode Linux or older firmwares without SBI HSM extension. For general
> > Linux systems, ordered booting method is preferred anyways to support
> > cpu hotplug and kexec.
> >
> > Make sure that __cpu_up_stack/task_pointer is only used for spinwait
> > method. Take this opportunity to rename it to
> > __cpu_spinwait_stack/task_pointer to emphasize the purpose as well.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/cpu_ops.h     |  2 --
> >  arch/riscv/kernel/cpu_ops.c          | 16 ----------------
> >  arch/riscv/kernel/cpu_ops_spinwait.c | 27 ++++++++++++++++++++++++++-
> >  arch/riscv/kernel/head.S             |  4 ++--
> >  arch/riscv/kernel/head.h             |  4 ++--
> >  5 files changed, 30 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/cpu_ops.h
> > b/arch/riscv/include/asm/cpu_ops.h
> > index a8ec3c5c1bd2..134590f1b843 100644
> > --- a/arch/riscv/include/asm/cpu_ops.h
> > +++ b/arch/riscv/include/asm/cpu_ops.h
> > @@ -40,7 +40,5 @@ struct cpu_operations {
> >
> >  extern const struct cpu_operations *cpu_ops[NR_CPUS];
> >  void __init cpu_set_ops(int cpu);
> > -void cpu_update_secondary_bootdata(unsigned int cpuid,
> > -                                struct task_struct *tidle);
> >
> >  #endif /* ifndef __ASM_CPU_OPS_H */
> > diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
> > index 3f5a38b03044..c1e30f403c3b 100644
> > --- a/arch/riscv/kernel/cpu_ops.c
> > +++ b/arch/riscv/kernel/cpu_ops.c
> > @@ -8,31 +8,15 @@
> >  #include <linux/of.h>
> >  #include <linux/string.h>
> >  #include <linux/sched.h>
> > -#include <linux/sched/task_stack.h>
> >  #include <asm/cpu_ops.h>
> >  #include <asm/sbi.h>
> >  #include <asm/smp.h>
> >
> >  const struct cpu_operations *cpu_ops[NR_CPUS] __ro_after_init;
> >
> > -void *__cpu_up_stack_pointer[NR_CPUS] __section(".data");
> > -void *__cpu_up_task_pointer[NR_CPUS] __section(".data");
> > -
> >  extern const struct cpu_operations cpu_ops_sbi;
> >  extern const struct cpu_operations cpu_ops_spinwait;
> >
> > -void cpu_update_secondary_bootdata(unsigned int cpuid,
> > -                                struct task_struct *tidle)
> > -{
> > -     int hartid = cpuid_to_hartid_map(cpuid);
> > -
> > -     /* Make sure tidle is updated */
> > -     smp_mb();
> > -     WRITE_ONCE(__cpu_up_stack_pointer[hartid],
> > -                task_stack_page(tidle) + THREAD_SIZE);
> > -     WRITE_ONCE(__cpu_up_task_pointer[hartid], tidle);
> > -}
> > -
> >  void __init cpu_set_ops(int cpuid)
> >  {
> >  #if IS_ENABLED(CONFIG_RISCV_SBI)
> > diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c
> > b/arch/riscv/kernel/cpu_ops_spinwait.c
> > index b2c957bb68c1..9f398eb94f7a 100644
> > --- a/arch/riscv/kernel/cpu_ops_spinwait.c
> > +++ b/arch/riscv/kernel/cpu_ops_spinwait.c
> > @@ -6,11 +6,36 @@
> >  #include <linux/errno.h>
> >  #include <linux/of.h>
> >  #include <linux/string.h>
> > +#include <linux/sched/task_stack.h>
> >  #include <asm/cpu_ops.h>
> >  #include <asm/sbi.h>
> >  #include <asm/smp.h>
> >
> >  const struct cpu_operations cpu_ops_spinwait;
> > +void *__cpu_spinwait_stack_pointer[NR_CPUS] __section(".data");
> > +void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
> > +
> > +static void cpu_update_secondary_bootdata(unsigned int cpuid,
> > +                                struct task_struct *tidle)
> > +{
> > +     int hartid = cpuid_to_hartid_map(cpuid);
> > +
> > +     /*
> > +      * The hartid must be less than NR_CPUS to avoid out-of-bound access
> > +      * errors for __cpu_spinwait_stack/task_pointer. That is not always
> > possible
> > +      * for platforms with discontiguous hartid numbering scheme. That's
> > why
> > +      * spinwait booting is not the recommended approach for any platforms
> > +      * and will be removed in future.
>
> How can you do that? Yes, spinning schemes are terrible.
> However, once you started supporting them, you are stuck.
>

This was a typo. It is supposed to say "disabled" in the future based
on other configs.
For now, it is enabled by default. Any platform with sparse hartid
needs to disable it in their own config.

In the future, we may be able to make it only available to M-mode
Linux if we can ensure that nobody is running
older firmware without SBI HSM extension.

> Best case, you can have an allow-list and only allow some
> older platforms to use them. You can also make some features
> dependent on non-spin schemes (kexec being one).
>
> But dropping support isn't a valid option, I'm afraid.
>
> Thanks,
>
>           M.
> --
> Jazz is not dead. It just smells funny...



-- 
Regards,
Atish
