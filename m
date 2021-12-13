Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3DF472C9C
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 13:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhLMMvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 07:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhLMMvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 07:51:06 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC58C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 04:51:06 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id o13so26793165wrs.12
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 04:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0iqENYZSp6tSgjjC4SuN/3Acy/dnviQPfcQyyNgDGRk=;
        b=n1t7NoZcSyyBr1W5m5qXqOdFkLF/67CvHxuHX1IpWxjF4nNPS3Avg1h2fCPjIh0tsa
         tOO69+ufgkWt5i6NZLQyjAqqaf4sh+/VCo8tThM9rhuZ0UaBYooiuw/3m+UsFyonZgJZ
         9cmVmxvJCTmxkS662qY9NQMmx2dpk4i5mo+G5U1ZVIapKBhB/vcU8cnkViH5+WSeycbt
         pnjieEOIedzWgcXNpqX9LTmMDfj7R7yATOnzFkiYWcWkV1pTkUR39LVnqdAd5bsK07Nf
         5pIEAfdCgdwerzLNlW3mJHgj1Rb1jPDo0AyaAz0zIf0EgjJONPeBw8L0+pyXQfejCS6h
         uPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0iqENYZSp6tSgjjC4SuN/3Acy/dnviQPfcQyyNgDGRk=;
        b=2TzMItEhC10KxLcRMQYfnQvRJE+RiqEvndqZegMh7OzT1+n7pczBrHlbDSXDwrPhHo
         r+fjB6F/OYEbOFnjyjUgymS8oJFlFrZgNZrjGgGpqXCb/HvrEemouUUOdy6a2nWTFNK1
         TVZ5uhJxR7RI2aXVZl/4CKmnzqe1sqZbE/XOcy9YVEljw+ToSG7QqAxyDdu+lJpgsXah
         KOmgJCGPjx7P++KEI2wqzrPQ8/Gcvr2fDXTokDOc830AUnRtWIpachEnZ33yQQYrIz+B
         wy63zPgcTra7rQHa0/747lZSKCVCJEWt/2AiURTa7gCpW6goYrsZ+F18Jnx/ju3cH2Dh
         hgJw==
X-Gm-Message-State: AOAM532blpZL1qMMz82rPn+vMBBB+qCrC3T6CIQ8FWTwqgof1gdo8IKf
        5PwBSWTHa3qlaS62/2F2zQ5F1Y8wHyjXcb0MHOuleQ==
X-Google-Smtp-Source: ABdhPJwhRBxzcU2sZmpZJ76xIFNOAwnPDA8amkxOz894Oz6Kb/RYU/lWrmTV7IbTIqzN/Tp1V+wjLU/loVeixDuqYU8=
X-Received: by 2002:a5d:4909:: with SMTP id x9mr32773413wrq.313.1639399864386;
 Mon, 13 Dec 2021 04:51:04 -0800 (PST)
MIME-Version: 1.0
References: <20211204002038.113653-1-atishp@atishpatra.org> <20211204002038.113653-4-atishp@atishpatra.org>
In-Reply-To: <20211204002038.113653-4-atishp@atishpatra.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 18:20:52 +0530
Message-ID: <CAAhSdy2BqJseXoNRQJ7d69ExDFu=DfRW-Q_inZoDcPzAWDTToQ@mail.gmail.com>
Subject: Re: [RFC 3/6] RISC-V: Use __cpu_up_stack/task_pointer only for
 spinwait method
To:     Atish Patra <atishp@atishpatra.org>
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

On Sat, Dec 4, 2021 at 5:51 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> From: Atish Patra <atishp@rivosinc.com>
>
> The __cpu_up_stack/task_pointer array is only used for spinwait method
> now. The per cpu array based lookup is also fragile for platforms with
> discontiguous/sparse hartids. The spinwait method is only used for
> M-mode Linux or older firmwares without SBI HSM extension. For general
> Linux systems, ordered booting method is preferred anyways to support
> cpu hotplug and kexec.
>
> Make sure that __cpu_up_stack/task_pointer is only used for spinwait
> method. Take this opportunity to rename it to
> __cpu_spinwait_stack/task_pointer to emphasize the purpose as well.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/cpu_ops.h     |  2 --
>  arch/riscv/kernel/cpu_ops.c          | 16 ----------------
>  arch/riscv/kernel/cpu_ops_spinwait.c | 27 ++++++++++++++++++++++++++-
>  arch/riscv/kernel/head.S             |  4 ++--
>  arch/riscv/kernel/head.h             |  4 ++--
>  5 files changed, 30 insertions(+), 23 deletions(-)
>
> diff --git a/arch/riscv/include/asm/cpu_ops.h b/arch/riscv/include/asm/cpu_ops.h
> index a8ec3c5c1bd2..134590f1b843 100644
> --- a/arch/riscv/include/asm/cpu_ops.h
> +++ b/arch/riscv/include/asm/cpu_ops.h
> @@ -40,7 +40,5 @@ struct cpu_operations {
>
>  extern const struct cpu_operations *cpu_ops[NR_CPUS];
>  void __init cpu_set_ops(int cpu);
> -void cpu_update_secondary_bootdata(unsigned int cpuid,
> -                                  struct task_struct *tidle);
>
>  #endif /* ifndef __ASM_CPU_OPS_H */
> diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
> index 3f5a38b03044..c1e30f403c3b 100644
> --- a/arch/riscv/kernel/cpu_ops.c
> +++ b/arch/riscv/kernel/cpu_ops.c
> @@ -8,31 +8,15 @@
>  #include <linux/of.h>
>  #include <linux/string.h>
>  #include <linux/sched.h>
> -#include <linux/sched/task_stack.h>
>  #include <asm/cpu_ops.h>
>  #include <asm/sbi.h>
>  #include <asm/smp.h>
>
>  const struct cpu_operations *cpu_ops[NR_CPUS] __ro_after_init;
>
> -void *__cpu_up_stack_pointer[NR_CPUS] __section(".data");
> -void *__cpu_up_task_pointer[NR_CPUS] __section(".data");
> -
>  extern const struct cpu_operations cpu_ops_sbi;
>  extern const struct cpu_operations cpu_ops_spinwait;
>
> -void cpu_update_secondary_bootdata(unsigned int cpuid,
> -                                  struct task_struct *tidle)
> -{
> -       int hartid = cpuid_to_hartid_map(cpuid);
> -
> -       /* Make sure tidle is updated */
> -       smp_mb();
> -       WRITE_ONCE(__cpu_up_stack_pointer[hartid],
> -                  task_stack_page(tidle) + THREAD_SIZE);
> -       WRITE_ONCE(__cpu_up_task_pointer[hartid], tidle);
> -}
> -
>  void __init cpu_set_ops(int cpuid)
>  {
>  #if IS_ENABLED(CONFIG_RISCV_SBI)
> diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c b/arch/riscv/kernel/cpu_ops_spinwait.c
> index b2c957bb68c1..9f398eb94f7a 100644
> --- a/arch/riscv/kernel/cpu_ops_spinwait.c
> +++ b/arch/riscv/kernel/cpu_ops_spinwait.c
> @@ -6,11 +6,36 @@
>  #include <linux/errno.h>
>  #include <linux/of.h>
>  #include <linux/string.h>
> +#include <linux/sched/task_stack.h>
>  #include <asm/cpu_ops.h>
>  #include <asm/sbi.h>
>  #include <asm/smp.h>
>
>  const struct cpu_operations cpu_ops_spinwait;
> +void *__cpu_spinwait_stack_pointer[NR_CPUS] __section(".data");
> +void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
> +
> +static void cpu_update_secondary_bootdata(unsigned int cpuid,
> +                                  struct task_struct *tidle)
> +{
> +       int hartid = cpuid_to_hartid_map(cpuid);
> +
> +       /*
> +        * The hartid must be less than NR_CPUS to avoid out-of-bound access
> +        * errors for __cpu_spinwait_stack/task_pointer. That is not always possible
> +        * for platforms with discontiguous hartid numbering scheme. That's why
> +        * spinwait booting is not the recommended approach for any platforms
> +        * and will be removed in future.
> +        */
> +       if (hartid == INVALID_HARTID || hartid >= NR_CPUS)
> +               return;
> +
> +       /* Make sure tidle is updated */
> +       smp_mb();
> +       WRITE_ONCE(__cpu_spinwait_stack_pointer[hartid],
> +                  task_stack_page(tidle) + THREAD_SIZE);
> +       WRITE_ONCE(__cpu_spinwait_task_pointer[hartid], tidle);
> +}
>
>  static int spinwait_cpu_prepare(unsigned int cpuid)
>  {
> @@ -28,7 +53,7 @@ static int spinwait_cpu_start(unsigned int cpuid, struct task_struct *tidle)
>          * selects the first cpu to boot the kernel and causes the remainder
>          * of the cpus to spin in a loop waiting for their stack pointer to be
>          * setup by that main cpu.  Writing to bootdata
> -        * (i.e __cpu_up_stack_pointer) signals to the spinning cpus that they
> +        * (i.e __cpu_spinwait_stack_pointer) signals to the spinning cpus that they
>          * can continue the boot process.
>          */
>         cpu_update_secondary_bootdata(cpuid, tidle);
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 40d4c625513c..6f8e99eac6a1 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -347,9 +347,9 @@ clear_bss_done:
>         csrw CSR_TVEC, a3
>
>         slli a3, a0, LGREG
> -       la a1, __cpu_up_stack_pointer
> +       la a1, __cpu_spinwait_stack_pointer
>         XIP_FIXUP_OFFSET a1
> -       la a2, __cpu_up_task_pointer
> +       la a2, __cpu_spinwait_task_pointer
>         XIP_FIXUP_OFFSET a2
>         add a1, a3, a1
>         add a2, a3, a2
> diff --git a/arch/riscv/kernel/head.h b/arch/riscv/kernel/head.h
> index aabbc3ac3e48..5393cca77790 100644
> --- a/arch/riscv/kernel/head.h
> +++ b/arch/riscv/kernel/head.h
> @@ -16,7 +16,7 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa);
>  asmlinkage void __init __copy_data(void);
>  #endif
>
> -extern void *__cpu_up_stack_pointer[];
> -extern void *__cpu_up_task_pointer[];
> +extern void *__cpu_spinwait_stack_pointer[];
> +extern void *__cpu_spinwait_task_pointer[];
>
>  #endif /* __ASM_HEAD_H */
> --
> 2.33.1
>
