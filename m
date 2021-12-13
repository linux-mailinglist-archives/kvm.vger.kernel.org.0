Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3304B47365B
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 22:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243062AbhLMVFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 16:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242823AbhLMVFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 16:05:53 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97646C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 13:05:52 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id v64so41422881ybi.5
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 13:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OYjNY84xxrPtnEGblOzPGQWS8v7Li5XOXn2Tp1iLBGY=;
        b=cOQQaWK6nxqOwPzOEkcF+NLdghu46He4GyafQsnxU4kKmr0hWInEIeBcbv4R6HgJuz
         OiPwq7pyhIMZPfD6OiQTXBDQOo1eMI0Q3IIM+6ee/PPR1dYyi2HZfv1rGTEIMcRTd78e
         EtlpvdFuBAAq8hcw6z8iwdDjWK8bm9vvBE9fE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OYjNY84xxrPtnEGblOzPGQWS8v7Li5XOXn2Tp1iLBGY=;
        b=nHCTHCJnMfCCdL7cUEjKCubL1zkdLm0uN6UPxtVOvbLCorbFuRdXodEFLBg1oj99l7
         KcFimjAnQa0T7DqOItrttCo7nNODOewZwjRosl9eGqiUZbmQp0r5QiFKGkIBch0V2S2H
         56on6GzBfYoLH2pc7dbwL3kF+CIDqpmXaHMN4mjjXBmq1se2O4M+zKgGnZQR6IOK3HzK
         DKsIeLPT2m5jm61qfmDXf3SZg4yEJNtiZ3DhFKkuBVIMbSJ87Ke0aWXk2aqCBGWmCyqq
         K+kIHOZinPFfeRPr2FkP+i08a3PIOes/RzPCQXrs1UfSeH3UoGW8qorCw0Gf15mqud1/
         Rszg==
X-Gm-Message-State: AOAM533rUKvgu9cx08UW+QRzGGl5331AEbmV1rp2hRR0RH5gtEg7QOuu
        OvTIVid8dSySo2ncOk+RfvlbUkbfunSiaMArtri1
X-Google-Smtp-Source: ABdhPJwv4zvaS/MXEq/62jU1x4Jh98JJGkhOxuqvK8SRBYpuk/KNwhnQ0QlAbQZppUF4cZbzcOpESNWMSQhiKTdVi8A=
X-Received: by 2002:a5b:b92:: with SMTP id l18mr1124278ybq.10.1639429551777;
 Mon, 13 Dec 2021 13:05:51 -0800 (PST)
MIME-Version: 1.0
References: <20211204002038.113653-1-atishp@atishpatra.org>
 <20211204002038.113653-2-atishp@atishpatra.org> <CAAhSdy2YsrGSk4P41hneNkJJg6je9fMYV9-py6vim=ZEexigOQ@mail.gmail.com>
In-Reply-To: <CAAhSdy2YsrGSk4P41hneNkJJg6je9fMYV9-py6vim=ZEexigOQ@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 13 Dec 2021 13:05:41 -0800
Message-ID: <CAOnJCU+cgrC=uYJjVUQzpONeMJMxW06g5eoPKB_PfDRY5tPSNw@mail.gmail.com>
Subject: Re: [RFC 1/6] RISC-V: Avoid using per cpu array for ordered booting
To:     Anup Patel <anup@brainfault.org>
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
        Marc Zyngier <maz@kernel.org>,
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

On Mon, Dec 13, 2021 at 4:49 AM Anup Patel <anup@brainfault.org> wrote:
>
> On Sat, Dec 4, 2021 at 5:50 AM Atish Patra <atishp@atishpatra.org> wrote:
> >
> > From: Atish Patra <atishp@rivosinc.com>
> >
> > Currently both order booting and spinwait approach uses a per cpu
> > array to update stack & task pointer. This approach will not work for the
> > following cases.
> > 1. If NR_CPUs are configured to be less than highest hart id.
> > 2. A platform has sparse hartid.
> >
> > This issue can be fixed for ordered booting as the booting cpu brings up
> > one cpu at a time using SBI HSM extension which has opaque parameter
> > that is unused until now.
> >
> > Introduce a common secondary boot data structure that can store the stack
> > and task pointer. Secondary harts will use this data while booting up
> > to setup the sp & tp.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/cpu_ops_sbi.h | 28 ++++++++++++++++++++++++++++
> >  arch/riscv/kernel/cpu_ops_sbi.c      | 23 ++++++++++++++++++++---
> >  arch/riscv/kernel/head.S             | 19 ++++++++++---------
> >  3 files changed, 58 insertions(+), 12 deletions(-)
> >  create mode 100644 arch/riscv/include/asm/cpu_ops_sbi.h
> >
> > diff --git a/arch/riscv/include/asm/cpu_ops_sbi.h b/arch/riscv/include/asm/cpu_ops_sbi.h
> > new file mode 100644
> > index 000000000000..ccb9a6d30486
> > --- /dev/null
> > +++ b/arch/riscv/include/asm/cpu_ops_sbi.h
> > @@ -0,0 +1,28 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (c) 2021 by Rivos Inc.
> > + */
> > +#ifndef __ASM_CPU_OPS_SBI_H
> > +#define __ASM_CPU_OPS_SBI_H
> > +
> > +#ifndef __ASSEMBLY__
> > +#include <linux/init.h>
> > +#include <linux/sched.h>
> > +#include <linux/threads.h>
> > +
> > +/**
> > + * struct sbi_hart_boot_data - Hart specific boot used during booting and
> > + *                            cpu hotplug.
> > + * @task_ptr: A pointer to the hart specific tp
> > + * @stack_ptr: A pointer to the hart specific sp
> > + */
> > +struct sbi_hart_boot_data {
> > +       void *task_ptr;
> > +       void *stack_ptr;
> > +};
> > +#endif
> > +
> > +#define SBI_HART_BOOT_TASK_PTR_OFFSET (0x00)
> > +#define SBI_HART_BOOT_STACK_PTR_OFFSET RISCV_SZPTR
>
> Don't manually create these defines instead generate this
> defines at compile time by adding entries in kernel/asm-offsets.c
>

Sure. I will fix this in the next version.

> > +
> > +#endif /* ifndef __ASM_CPU_OPS_H */
> > diff --git a/arch/riscv/kernel/cpu_ops_sbi.c b/arch/riscv/kernel/cpu_ops_sbi.c
> > index 685fae72b7f5..2e7a9dd9c2a7 100644
> > --- a/arch/riscv/kernel/cpu_ops_sbi.c
> > +++ b/arch/riscv/kernel/cpu_ops_sbi.c
> > @@ -7,13 +7,22 @@
> >
> >  #include <linux/init.h>
> >  #include <linux/mm.h>
> > +#include <linux/sched/task_stack.h>
> >  #include <asm/cpu_ops.h>
> > +#include <asm/cpu_ops_sbi.h>
> >  #include <asm/sbi.h>
> >  #include <asm/smp.h>
> >
> >  extern char secondary_start_sbi[];
> >  const struct cpu_operations cpu_ops_sbi;
> >
> > +/*
> > + * Ordered booting via HSM brings one cpu at a time. However, cpu hotplug can
> > + * be invoked from multiple threads in paralle. Define a per cpu data
> > + * to handle that.
> > + */
> > +DEFINE_PER_CPU(struct sbi_hart_boot_data, boot_data);
> > +
> >  static int sbi_hsm_hart_start(unsigned long hartid, unsigned long saddr,
> >                               unsigned long priv)
> >  {
> > @@ -58,9 +67,17 @@ static int sbi_cpu_start(unsigned int cpuid, struct task_struct *tidle)
> >         int rc;
> >         unsigned long boot_addr = __pa_symbol(secondary_start_sbi);
> >         int hartid = cpuid_to_hartid_map(cpuid);
> > -
> > -       cpu_update_secondary_bootdata(cpuid, tidle);
> > -       rc = sbi_hsm_hart_start(hartid, boot_addr, 0);
> > +       unsigned long hsm_data;
> > +       struct sbi_hart_boot_data *bdata = &per_cpu(boot_data, cpuid);
> > +
> > +       /* Make sure tidle is updated */
> > +       smp_mb();
> > +       bdata->task_ptr = tidle;
> > +       bdata->stack_ptr = task_stack_page(tidle) + THREAD_SIZE;
> > +       /* Make sure boot data is updated */
> > +       smp_mb();
> > +       hsm_data = __pa(bdata);
> > +       rc = sbi_hsm_hart_start(hartid, boot_addr, hsm_data);
> >
> >         return rc;
> >  }
> > diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> > index f52f01ecbeea..40d4c625513c 100644
> > --- a/arch/riscv/kernel/head.S
> > +++ b/arch/riscv/kernel/head.S
> > @@ -11,6 +11,7 @@
> >  #include <asm/page.h>
> >  #include <asm/pgtable.h>
> >  #include <asm/csr.h>
> > +#include <asm/cpu_ops_sbi.h>
> >  #include <asm/hwcap.h>
> >  #include <asm/image.h>
> >  #include "efi-header.S"
> > @@ -167,15 +168,15 @@ secondary_start_sbi:
> >         la a3, .Lsecondary_park
> >         csrw CSR_TVEC, a3
> >
> > -       slli a3, a0, LGREG
> > -       la a4, __cpu_up_stack_pointer
> > -       XIP_FIXUP_OFFSET a4
> > -       la a5, __cpu_up_task_pointer
> > -       XIP_FIXUP_OFFSET a5
> > -       add a4, a3, a4
> > -       add a5, a3, a5
> > -       REG_L sp, (a4)
> > -       REG_L tp, (a5)
> > +       /* a0 contains the hartid & a1 contains boot data */
> > +       li a2, SBI_HART_BOOT_TASK_PTR_OFFSET
> > +       XIP_FIXUP_OFFSET a2
> > +       add a2, a2, a1
> > +       REG_L tp, (a2)
> > +       li a3, SBI_HART_BOOT_STACK_PTR_OFFSET
> > +       XIP_FIXUP_OFFSET a3
> > +       add a3, a3, a1
> > +       REG_L sp, (a3)
> >
> >         .global secondary_start_common
> >  secondary_start_common:
> > --
> > 2.33.1
> >
>
> Regards,
> Anup



-- 
Regards,
Atish
