Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B2F472CBD
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 14:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhLMNCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 08:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbhLMNCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 08:02:07 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D0CC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 05:02:07 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j3so26962666wrp.1
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 05:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lZVF2oyg56K2eXdYGD9l8O6KjfCMEpIT69R3sA9KD0E=;
        b=2s3ik6I9r6hO6Koe0XyQpBO4uF6+LEpZ8E8a4XPO5uyNO7BHQaf1Esfy0gR5rh27vJ
         QVUUkRTsI8VuSxmP26qtyf0ct/akSX22bwlYOY+HX+l5zbF7em7JTABRo0YVgfjCl7tL
         ooBkO9DP/O8wFEDDAi+iDoFXByKiDtKxoh1EK7KTzJWPfPUVYFXj9MDBX9Vxo65oguKq
         u0lQiCxQBlgzroL5EG9GX68wjGsgO4gee2H9265KeJQNwK2dPY/z/H61Vw8oAva0bF0R
         ESEWtL0uXi8AjlgTKLKbNtFb5fx2/49j5h7Ojz5PVa5b2TTgm/J+uk5wTL5VJWwyeHm3
         bQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lZVF2oyg56K2eXdYGD9l8O6KjfCMEpIT69R3sA9KD0E=;
        b=HnbHZ5o/4d8PpWNEBM0Al7RnrzNX23MuDz8ZwLHaP5nYptbGem7Wnnn6YPGdgR8XGx
         M2BGytHvrKkD44h0AKYdg9zBtm1ltKXkfqsazEL51d5zp+V2Mx+/DCitBa7lxx+WFm0u
         BbIJmJLsJdt+1UkcqRNize+xWRC7kD9oBJBKGBVHHj2yr8GFEZcl2P3DYtq/LeTFphIx
         oGmUXd5gC1n4xZdo84kRqdG1JZLA2lurDNrYNx8vvg43dJ42StjAuyWD9bElvyrIeXIh
         tKDO35bvi5FivLbGsLbsCdu3hRA3apzDABJRM3e9FVKC+xNMzImCqwbGQLrrEHt/5bUK
         BA1Q==
X-Gm-Message-State: AOAM530QAQ1EuXaldMOnjIYfp97XHyzBmvrr2IbMkbDfgYv5K2Y6EZaD
        T2XjuoMCkJmoYLgU3iJnUSEwotT/kDgQX/l1SLmgsg==
X-Google-Smtp-Source: ABdhPJzh9ioitLYUUDPnsJ3CIp6AwYVFCGBTgyyI6H5cI/cmcXKBPfaF6TMStgFI+sNsDiw0LSR7KLjxX/aCfJYli6k=
X-Received: by 2002:a5d:4909:: with SMTP id x9mr32836164wrq.313.1639400525484;
 Mon, 13 Dec 2021 05:02:05 -0800 (PST)
MIME-Version: 1.0
References: <20211204002038.113653-1-atishp@atishpatra.org> <20211204002038.113653-6-atishp@atishpatra.org>
In-Reply-To: <20211204002038.113653-6-atishp@atishpatra.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 18:31:53 +0530
Message-ID: <CAAhSdy26i0KiHce_FveXS795WecSJJ3ujbCmOVVVBiSOd8chRw@mail.gmail.com>
Subject: Re: [RFC 5/6] RISC-V: Move spinwait booting method to its own config
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
> The spinwait booting method should only be used for platforms with older
> firmware without SBI HSM extension or M-mode firmware because spinwait
> method can't support cpu hotplug, kexec or sparse hartid. It is better
> to move the entire spinwait implementation to its own config which can
> be disabled if required. It is enabled by default to maintain backward
> compatibility and M-mode Linux.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/Kconfig          | 14 ++++++++++++++
>  arch/riscv/kernel/Makefile  |  3 ++-
>  arch/riscv/kernel/cpu_ops.c |  8 ++++++++
>  arch/riscv/kernel/head.S    |  6 +++---
>  arch/riscv/kernel/head.h    |  2 ++
>  5 files changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 821252b65f89..4afb42d5707d 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -403,6 +403,20 @@ config RISCV_SBI_V01
>           This config allows kernel to use SBI v0.1 APIs. This will be
>           deprecated in future once legacy M-mode software are no longer in use.
>
> +config RISCV_BOOT_SPINWAIT
> +       bool "Spinwait booting method"
> +       depends on SMP
> +       default y
> +       help
> +         This enables support for booting Linux via spinwait method. In the
> +         spinwait method, all cores randomly jump to Linux. One of the core
> +         gets chosen via lottery and all other keeps spinning on a percpu
> +         variable. This method can not support cpu hotplug and sparse hartid
> +         scheme. It should be only enabled for M-mode Linux or platforms relying
> +         on older firmware without SBI HSM extension. All other platform should
> +         rely on ordered booing via SBI HSM extension which gets chosen
> +          dynamically at runtime if the firmware supports it.
> +
>  config KEXEC
>         bool "Kexec system call"
>         select KEXEC_CORE
> diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
> index 3397ddac1a30..612556faa527 100644
> --- a/arch/riscv/kernel/Makefile
> +++ b/arch/riscv/kernel/Makefile
> @@ -43,7 +43,8 @@ obj-$(CONFIG_FPU)             += fpu.o
>  obj-$(CONFIG_SMP)              += smpboot.o
>  obj-$(CONFIG_SMP)              += smp.o
>  obj-$(CONFIG_SMP)              += cpu_ops.o
> -obj-$(CONFIG_SMP)              += cpu_ops_spinwait.o
> +
> +obj-$(CONFIG_RISCV_BOOT_SPINWAIT) += cpu_ops_spinwait.o
>  obj-$(CONFIG_MODULES)          += module.o
>  obj-$(CONFIG_MODULE_SECTIONS)  += module-sections.o
>
> diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
> index c1e30f403c3b..170d07e57721 100644
> --- a/arch/riscv/kernel/cpu_ops.c
> +++ b/arch/riscv/kernel/cpu_ops.c
> @@ -15,7 +15,15 @@
>  const struct cpu_operations *cpu_ops[NR_CPUS] __ro_after_init;
>
>  extern const struct cpu_operations cpu_ops_sbi;
> +#ifdef CONFIG_RISCV_BOOT_SPINWAIT
>  extern const struct cpu_operations cpu_ops_spinwait;
> +#else
> +const struct cpu_operations cpu_ops_spinwait = {
> +       .name           = "",
> +       .cpu_prepare    = NULL,
> +       .cpu_start      = NULL,
> +};
> +#endif
>
>  void __init cpu_set_ops(int cpuid)
>  {
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 9f16bfe9307e..4a694e15b95b 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -259,7 +259,7 @@ pmp_done:
>         li t0, SR_FS
>         csrc CSR_STATUS, t0
>
> -#ifdef CONFIG_SMP
> +#ifdef CONFIG_RISCV_BOOT_SPINWAIT
>         li t0, CONFIG_NR_CPUS
>         blt a0, t0, .Lgood_cores
>         tail .Lsecondary_park
> @@ -285,7 +285,7 @@ pmp_done:
>         beq t0, t1, .Lsecondary_start
>
>  #endif /* CONFIG_XIP */
> -#endif /* CONFIG_SMP */
> +#endif /* CONFIG_RISCV_BOOT_SPINWAIT */
>
>  #ifdef CONFIG_XIP_KERNEL
>         la sp, _end + THREAD_SIZE
> @@ -344,7 +344,7 @@ clear_bss_done:
>         call soc_early_init
>         tail start_kernel
>
> -#ifdef CONFIG_SMP
> +#if defined(CONFIG_SMP) && defined(CONFIG_RISCV_BOOT_SPINWAIT)

The RISCV_BOOT_SPINWAIT option already depends on SMP.

Do you still need to check defined(CONFIG_SMP) here ?

Regards,
Anup

>  .Lsecondary_start:
>         /* Set trap vector to spin forever to help debug */
>         la a3, .Lsecondary_park
> diff --git a/arch/riscv/kernel/head.h b/arch/riscv/kernel/head.h
> index 5393cca77790..726731ada534 100644
> --- a/arch/riscv/kernel/head.h
> +++ b/arch/riscv/kernel/head.h
> @@ -16,7 +16,9 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa);
>  asmlinkage void __init __copy_data(void);
>  #endif
>
> +#ifdef CONFIG_RISCV_BOOT_SPINWAIT
>  extern void *__cpu_spinwait_stack_pointer[];
>  extern void *__cpu_spinwait_task_pointer[];
> +#endif
>
>  #endif /* __ASM_HEAD_H */
> --
> 2.33.1
>
