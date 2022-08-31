Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876515A8511
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiHaSJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiHaSIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:08:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2307E830A;
        Wed, 31 Aug 2022 11:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1166861AE4;
        Wed, 31 Aug 2022 18:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2864CC433B5;
        Wed, 31 Aug 2022 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661969326;
        bh=W2lzpMW/5Jj6EKuKqKd66scyLcYDzCh41GWmaDJ9tOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XE6JJDjFOWnsRMBMoKofgGkso8i/urjEvAUXpgznJfh64blVPBOYTJUWvgERljgGj
         TGPbyTL+ziZ2WVT3KokJtVD1T716DYeOtWWtYc0u1OnMiAYdRJoVwdjs/ffjj+Ob+u
         zKXDlhjM8Lat3rnmgHq6e2wUyOS7m67v2Pr1U9qC9f56dIVvg2R0ZyHLlIvyDoguc4
         lVygxngvjtC1lKlLdY2UKk9E6qXUNypGNmGFTfWRrt46yYXVdEFYxr0db5rAknGC2w
         7XlwC/0MY9nM+e8uFbogsST5RFmgPjJQ57ANWx7/Z4BG8MThBxwl6+bRpHg1Rp/NC4
         7K/+rQ+lk/tPQ==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 4/5] riscv: add lazy preempt support
Date:   Thu,  1 Sep 2022 01:59:19 +0800
Message-Id: <20220831175920.2806-5-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831175920.2806-1-jszhang@kernel.org>
References: <20220831175920.2806-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the lazy preempt for riscv.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/Kconfig                   | 1 +
 arch/riscv/include/asm/thread_info.h | 7 +++++--
 arch/riscv/kernel/asm-offsets.c      | 1 +
 arch/riscv/kernel/entry.S            | 9 +++++++--
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 7a8134fd7ec9..9f2f1936b1b5 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -105,6 +105,7 @@ config RISCV
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
+	select HAVE_PREEMPT_LAZY
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_STACKPROTECTOR
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 78933ac04995..471915b179a2 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -56,6 +56,7 @@
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int                     preempt_count;  /* 0=>preemptible, <0=>BUG */
+	int			preempt_lazy_count;  /* 0=>preemptible, <0=>BUG */
 	/*
 	 * These stack pointers are overwritten on every system call or
 	 * exception.  SP is also saved to the stack it can be recovered when
@@ -90,7 +91,7 @@ struct thread_info {
 #define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+#define TIF_NEED_RESCHED_LAZY	4	/* lazy rescheduling */
 #define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_TRACEPOINT  6       /* syscall tracepoint instrumentation */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing */
@@ -98,6 +99,7 @@ struct thread_info {
 #define TIF_NOTIFY_SIGNAL	9	/* signal notifications exist */
 #define TIF_UPROBE		10	/* uprobe breakpoint or singlestep */
 #define TIF_32BIT		11	/* compat-mode 32bit process */
+#define TIF_RESTORE_SIGMASK	12	/* restore signal mask in do_signal() */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -108,10 +110,11 @@ struct thread_info {
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
+#define _TIF_NEED_RESCHED_LAZY	(1 << TIF_NEED_RESCHED_LAZY)
 
 #define _TIF_WORK_MASK \
 	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_NEED_RESCHED | \
-	 _TIF_NOTIFY_SIGNAL | _TIF_UPROBE)
+	 _TIF_NEED_RESCHED_LAZY | _TIF_NOTIFY_SIGNAL | _TIF_UPROBE)
 
 #define _TIF_SYSCALL_WORK \
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDIT | \
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index df9444397908..e38e33822f72 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -35,6 +35,7 @@ void asm_offsets(void)
 	OFFSET(TASK_THREAD_S11, task_struct, thread.s[11]);
 	OFFSET(TASK_TI_FLAGS, task_struct, thread_info.flags);
 	OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);
+	OFFSET(TASK_TI_PREEMPT_LAZY_COUNT, task_struct, thread_info.preempt_lazy_count);
 	OFFSET(TASK_TI_KERNEL_SP, task_struct, thread_info.kernel_sp);
 	OFFSET(TASK_TI_USER_SP, task_struct, thread_info.user_sp);
 
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index b9eda3fcbd6d..595100a4c2c7 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -361,9 +361,14 @@ restore_all:
 resume_kernel:
 	REG_L s0, TASK_TI_PREEMPT_COUNT(tp)
 	bnez s0, restore_all
-	REG_L s0, TASK_TI_FLAGS(tp)
-	andi s0, s0, _TIF_NEED_RESCHED
+	REG_L s1, TASK_TI_FLAGS(tp)
+	andi s0, s1, _TIF_NEED_RESCHED
+	bnez s0, 1f
+	REG_L s0, TASK_TI_PREEMPT_LAZY_COUNT(tp)
+	bnez s0, restore_all
+	andi s0, s1, _TIF_NEED_RESCHED_LAZY
 	beqz s0, restore_all
+1:
 	call preempt_schedule_irq
 	j restore_all
 #endif
-- 
2.34.1

