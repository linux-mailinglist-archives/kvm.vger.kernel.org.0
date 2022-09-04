Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A975AC4E3
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiIDPQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 11:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIDPQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 11:16:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C48D3340C;
        Sun,  4 Sep 2022 08:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 060F0B80D91;
        Sun,  4 Sep 2022 15:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB07C43470;
        Sun,  4 Sep 2022 15:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662304584;
        bh=9SmY9DpW3HYOERkeThenfdvQoPY9NTr/e+0WCeGOlyw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ljWuFJkPzt/h00MO5gwzTaO933VrKuaVUcBcSlIqD3n7v7UJkN4J+f8/Br2WxVQkI
         LIHvvXzL8zRo0OxBqRKDhW38dTGTlHZkiwmf73VRQ8WnF4IBMeIpVwpU3ixajP+/R1
         Li0Vywt41drpqyzyqc8KL186pJaKun2EliazOTSDthNidjkiCCsDTCCPKBtcJtKvI9
         OIhHmVbuHTttigFlIDo9k66T+rVYDW/buTQBfbH6VTWx8WTOR5tKDRVuGJC1EochN6
         NK9rN1ZG3WhCH9AC0Wmu/uo5+VNhgBylOCAq6q9lxKod6NLTYZOMmh8xiJrJYSj2V4
         DrTkDmLtjFL5A==
Received: by mail-ot1-f47.google.com with SMTP id d18-20020a9d72d2000000b0063934f06268so4768838otk.0;
        Sun, 04 Sep 2022 08:16:24 -0700 (PDT)
X-Gm-Message-State: ACgBeo3orTWgAT4IlubPj9ywZd+tXB7zUVFVU3bhuU0KyzW+QL3tG+gR
        35cuA/T+cIT01E6KZp3hkDTVSXTao1xSefkWU6U=
X-Google-Smtp-Source: AA6agR5wIhn8kKCg4VV6TV3mg/U+V9a/5d7xG5du8TuMDdehC+mHSvyBDW01/GiEqgLKSmSU46hNMimGKI7i7bDu83c=
X-Received: by 2002:a05:6830:3482:b0:638:92b7:f09b with SMTP id
 c2-20020a056830348200b0063892b7f09bmr17764650otu.140.1662304583737; Sun, 04
 Sep 2022 08:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220831175920.2806-1-jszhang@kernel.org> <20220831175920.2806-5-jszhang@kernel.org>
In-Reply-To: <20220831175920.2806-5-jszhang@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Sun, 4 Sep 2022 23:16:12 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com>
Message-ID: <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] riscv: add lazy preempt support
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 1, 2022 at 2:08 AM Jisheng Zhang <jszhang@kernel.org> wrote:
>
> Implement the lazy preempt for riscv.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/Kconfig                   | 1 +
>  arch/riscv/include/asm/thread_info.h | 7 +++++--
>  arch/riscv/kernel/asm-offsets.c      | 1 +
>  arch/riscv/kernel/entry.S            | 9 +++++++--
>  4 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 7a8134fd7ec9..9f2f1936b1b5 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -105,6 +105,7 @@ config RISCV
>         select HAVE_PERF_REGS
>         select HAVE_PERF_USER_STACK_DUMP
>         select HAVE_POSIX_CPU_TIMERS_TASK_WORK
> +       select HAVE_PREEMPT_LAZY
>         select HAVE_REGS_AND_STACK_ACCESS_API
>         select HAVE_FUNCTION_ARG_ACCESS_API
>         select HAVE_STACKPROTECTOR
> diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
> index 78933ac04995..471915b179a2 100644
> --- a/arch/riscv/include/asm/thread_info.h
> +++ b/arch/riscv/include/asm/thread_info.h
> @@ -56,6 +56,7 @@
>  struct thread_info {
>         unsigned long           flags;          /* low level flags */
>         int                     preempt_count;  /* 0=>preemptible, <0=>BUG */
> +       int                     preempt_lazy_count;  /* 0=>preemptible, <0=>BUG */
>         /*
>          * These stack pointers are overwritten on every system call or
>          * exception.  SP is also saved to the stack it can be recovered when
> @@ -90,7 +91,7 @@ struct thread_info {
>  #define TIF_NOTIFY_RESUME      1       /* callback before returning to user */
>  #define TIF_SIGPENDING         2       /* signal pending */
>  #define TIF_NEED_RESCHED       3       /* rescheduling necessary */
> -#define TIF_RESTORE_SIGMASK    4       /* restore signal mask in do_signal() */
> +#define TIF_NEED_RESCHED_LAZY  4       /* lazy rescheduling */
>  #define TIF_MEMDIE             5       /* is terminating due to OOM killer */
>  #define TIF_SYSCALL_TRACEPOINT  6       /* syscall tracepoint instrumentation */
>  #define TIF_SYSCALL_AUDIT      7       /* syscall auditing */
> @@ -98,6 +99,7 @@ struct thread_info {
>  #define TIF_NOTIFY_SIGNAL      9       /* signal notifications exist */
>  #define TIF_UPROBE             10      /* uprobe breakpoint or singlestep */
>  #define TIF_32BIT              11      /* compat-mode 32bit process */
> +#define TIF_RESTORE_SIGMASK    12      /* restore signal mask in do_signal() */
>
>  #define _TIF_SYSCALL_TRACE     (1 << TIF_SYSCALL_TRACE)
>  #define _TIF_NOTIFY_RESUME     (1 << TIF_NOTIFY_RESUME)
> @@ -108,10 +110,11 @@ struct thread_info {
>  #define _TIF_SECCOMP           (1 << TIF_SECCOMP)
>  #define _TIF_NOTIFY_SIGNAL     (1 << TIF_NOTIFY_SIGNAL)
>  #define _TIF_UPROBE            (1 << TIF_UPROBE)
> +#define _TIF_NEED_RESCHED_LAZY (1 << TIF_NEED_RESCHED_LAZY)
>
>  #define _TIF_WORK_MASK \
>         (_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_NEED_RESCHED | \
> -        _TIF_NOTIFY_SIGNAL | _TIF_UPROBE)
> +        _TIF_NEED_RESCHED_LAZY | _TIF_NOTIFY_SIGNAL | _TIF_UPROBE)
>
>  #define _TIF_SYSCALL_WORK \
>         (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDIT | \
> diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
> index df9444397908..e38e33822f72 100644
> --- a/arch/riscv/kernel/asm-offsets.c
> +++ b/arch/riscv/kernel/asm-offsets.c
> @@ -35,6 +35,7 @@ void asm_offsets(void)
>         OFFSET(TASK_THREAD_S11, task_struct, thread.s[11]);
>         OFFSET(TASK_TI_FLAGS, task_struct, thread_info.flags);
>         OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);
> +       OFFSET(TASK_TI_PREEMPT_LAZY_COUNT, task_struct, thread_info.preempt_lazy_count);
>         OFFSET(TASK_TI_KERNEL_SP, task_struct, thread_info.kernel_sp);
>         OFFSET(TASK_TI_USER_SP, task_struct, thread_info.user_sp);
>
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index b9eda3fcbd6d..595100a4c2c7 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -361,9 +361,14 @@ restore_all:
>  resume_kernel:
>         REG_L s0, TASK_TI_PREEMPT_COUNT(tp)
>         bnez s0, restore_all
> -       REG_L s0, TASK_TI_FLAGS(tp)
> -       andi s0, s0, _TIF_NEED_RESCHED
> +       REG_L s1, TASK_TI_FLAGS(tp)
> +       andi s0, s1, _TIF_NEED_RESCHED
> +       bnez s0, 1f
> +       REG_L s0, TASK_TI_PREEMPT_LAZY_COUNT(tp)
> +       bnez s0, restore_all
> +       andi s0, s1, _TIF_NEED_RESCHED_LAZY
Can you tell me, who increased/decreased the PREEMPT_LAZY_COUNT? And
who set NEED_RESCHED_LAZY?


>         beqz s0, restore_all
> +1:
>         call preempt_schedule_irq
>         j restore_all
>  #endif
> --
> 2.34.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv



-- 
Best Regards
 Guo Ren
