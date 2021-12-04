Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5846E468128
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 01:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383740AbhLDAYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 19:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383709AbhLDAYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 19:24:20 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DBBC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 16:20:55 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b13so3203001plg.2
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 16:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7u6cD3eNj3Nkz8bLxeT8gXWEPzrZ4rsNyC+UwyU7rX8=;
        b=HtWNX3NIjismwcfV3/6U6eycTiG77Gg/c59ukN5EkaAmDSnfrtXmyyuQ1hXtS08qGt
         OU0IzlvEOWrW5blZbay633YznjVgLOXlswB6l17YD3XneWQQgbzwFXBRStqaQH1/ZmPM
         naNSIO6zEJIInS8dDaxkdABynCJE62dzhIUGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7u6cD3eNj3Nkz8bLxeT8gXWEPzrZ4rsNyC+UwyU7rX8=;
        b=AAdmRdaXf5+WCz93d6/XNT3WrK2Al4jMllG8Ex2vq9D2MMDiFOhMCdrvorI/vnR7tG
         FCzaeddCSvIxC4xCtkgwt6p+JzVQ5+9RaFuvFIG/j9E7sFBJKT3VsU1sxi9aE7rrfjyt
         +oES9m8jqjhdZMJ+RxOm5gzYdObxInNKWTTbyAnNeeqKgdnhHNOU23NbHmss9ukSdSCP
         kR55DdEkrLMbFglcLpC7Pa1ucMcusvF9XUCjJHGLjW/G4Y95zrMy3qKema4v6l7OSfdX
         TILll0RwL+3BFMlwHsev96c4Mw/pKStpzFZ7PYTxZ/T1x9Zz6mfTu5Uf34tSZHOQjq+G
         x8Bw==
X-Gm-Message-State: AOAM530Q1aD9NYI2rXA6+JEHdodeM3n/RjZYjwDmODkrDisInGb+SbaU
        BPbXbYakCoQNTuV7J+YJOGK9
X-Google-Smtp-Source: ABdhPJzKp/tA+vtP8sQx/u94F7a3amr0c187EQ3qwQTlVnU49o2PFuDEg8ylYHVWzgY7vyaJcLC54A==
X-Received: by 2002:a17:90a:657:: with SMTP id q23mr17992099pje.21.1638577255185;
        Fri, 03 Dec 2021 16:20:55 -0800 (PST)
Received: from fedora.ba.rivosinc.com (99-13-229-45.lightspeed.snjsca.sbcglobal.net. [99.13.229.45])
        by smtp.gmail.com with ESMTPSA id r6sm3272402pjg.21.2021.12.03.16.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:20:54 -0800 (PST)
From:   Atish Patra <atishp@atishpatra.org>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: [RFC 3/6] RISC-V: Use __cpu_up_stack/task_pointer only for spinwait method
Date:   Fri,  3 Dec 2021 16:20:35 -0800
Message-Id: <20211204002038.113653-4-atishp@atishpatra.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211204002038.113653-1-atishp@atishpatra.org>
References: <20211204002038.113653-1-atishp@atishpatra.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atishp@rivosinc.com>

The __cpu_up_stack/task_pointer array is only used for spinwait method
now. The per cpu array based lookup is also fragile for platforms with
discontiguous/sparse hartids. The spinwait method is only used for
M-mode Linux or older firmwares without SBI HSM extension. For general
Linux systems, ordered booting method is preferred anyways to support
cpu hotplug and kexec.

Make sure that __cpu_up_stack/task_pointer is only used for spinwait
method. Take this opportunity to rename it to
__cpu_spinwait_stack/task_pointer to emphasize the purpose as well.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/cpu_ops.h     |  2 --
 arch/riscv/kernel/cpu_ops.c          | 16 ----------------
 arch/riscv/kernel/cpu_ops_spinwait.c | 27 ++++++++++++++++++++++++++-
 arch/riscv/kernel/head.S             |  4 ++--
 arch/riscv/kernel/head.h             |  4 ++--
 5 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/arch/riscv/include/asm/cpu_ops.h b/arch/riscv/include/asm/cpu_ops.h
index a8ec3c5c1bd2..134590f1b843 100644
--- a/arch/riscv/include/asm/cpu_ops.h
+++ b/arch/riscv/include/asm/cpu_ops.h
@@ -40,7 +40,5 @@ struct cpu_operations {
 
 extern const struct cpu_operations *cpu_ops[NR_CPUS];
 void __init cpu_set_ops(int cpu);
-void cpu_update_secondary_bootdata(unsigned int cpuid,
-				   struct task_struct *tidle);
 
 #endif /* ifndef __ASM_CPU_OPS_H */
diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
index 3f5a38b03044..c1e30f403c3b 100644
--- a/arch/riscv/kernel/cpu_ops.c
+++ b/arch/riscv/kernel/cpu_ops.c
@@ -8,31 +8,15 @@
 #include <linux/of.h>
 #include <linux/string.h>
 #include <linux/sched.h>
-#include <linux/sched/task_stack.h>
 #include <asm/cpu_ops.h>
 #include <asm/sbi.h>
 #include <asm/smp.h>
 
 const struct cpu_operations *cpu_ops[NR_CPUS] __ro_after_init;
 
-void *__cpu_up_stack_pointer[NR_CPUS] __section(".data");
-void *__cpu_up_task_pointer[NR_CPUS] __section(".data");
-
 extern const struct cpu_operations cpu_ops_sbi;
 extern const struct cpu_operations cpu_ops_spinwait;
 
-void cpu_update_secondary_bootdata(unsigned int cpuid,
-				   struct task_struct *tidle)
-{
-	int hartid = cpuid_to_hartid_map(cpuid);
-
-	/* Make sure tidle is updated */
-	smp_mb();
-	WRITE_ONCE(__cpu_up_stack_pointer[hartid],
-		   task_stack_page(tidle) + THREAD_SIZE);
-	WRITE_ONCE(__cpu_up_task_pointer[hartid], tidle);
-}
-
 void __init cpu_set_ops(int cpuid)
 {
 #if IS_ENABLED(CONFIG_RISCV_SBI)
diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c b/arch/riscv/kernel/cpu_ops_spinwait.c
index b2c957bb68c1..9f398eb94f7a 100644
--- a/arch/riscv/kernel/cpu_ops_spinwait.c
+++ b/arch/riscv/kernel/cpu_ops_spinwait.c
@@ -6,11 +6,36 @@
 #include <linux/errno.h>
 #include <linux/of.h>
 #include <linux/string.h>
+#include <linux/sched/task_stack.h>
 #include <asm/cpu_ops.h>
 #include <asm/sbi.h>
 #include <asm/smp.h>
 
 const struct cpu_operations cpu_ops_spinwait;
+void *__cpu_spinwait_stack_pointer[NR_CPUS] __section(".data");
+void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
+
+static void cpu_update_secondary_bootdata(unsigned int cpuid,
+				   struct task_struct *tidle)
+{
+	int hartid = cpuid_to_hartid_map(cpuid);
+
+	/*
+	 * The hartid must be less than NR_CPUS to avoid out-of-bound access
+	 * errors for __cpu_spinwait_stack/task_pointer. That is not always possible
+	 * for platforms with discontiguous hartid numbering scheme. That's why
+	 * spinwait booting is not the recommended approach for any platforms
+	 * and will be removed in future.
+	 */
+	if (hartid == INVALID_HARTID || hartid >= NR_CPUS)
+		return;
+
+	/* Make sure tidle is updated */
+	smp_mb();
+	WRITE_ONCE(__cpu_spinwait_stack_pointer[hartid],
+		   task_stack_page(tidle) + THREAD_SIZE);
+	WRITE_ONCE(__cpu_spinwait_task_pointer[hartid], tidle);
+}
 
 static int spinwait_cpu_prepare(unsigned int cpuid)
 {
@@ -28,7 +53,7 @@ static int spinwait_cpu_start(unsigned int cpuid, struct task_struct *tidle)
 	 * selects the first cpu to boot the kernel and causes the remainder
 	 * of the cpus to spin in a loop waiting for their stack pointer to be
 	 * setup by that main cpu.  Writing to bootdata
-	 * (i.e __cpu_up_stack_pointer) signals to the spinning cpus that they
+	 * (i.e __cpu_spinwait_stack_pointer) signals to the spinning cpus that they
 	 * can continue the boot process.
 	 */
 	cpu_update_secondary_bootdata(cpuid, tidle);
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 40d4c625513c..6f8e99eac6a1 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -347,9 +347,9 @@ clear_bss_done:
 	csrw CSR_TVEC, a3
 
 	slli a3, a0, LGREG
-	la a1, __cpu_up_stack_pointer
+	la a1, __cpu_spinwait_stack_pointer
 	XIP_FIXUP_OFFSET a1
-	la a2, __cpu_up_task_pointer
+	la a2, __cpu_spinwait_task_pointer
 	XIP_FIXUP_OFFSET a2
 	add a1, a3, a1
 	add a2, a3, a2
diff --git a/arch/riscv/kernel/head.h b/arch/riscv/kernel/head.h
index aabbc3ac3e48..5393cca77790 100644
--- a/arch/riscv/kernel/head.h
+++ b/arch/riscv/kernel/head.h
@@ -16,7 +16,7 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa);
 asmlinkage void __init __copy_data(void);
 #endif
 
-extern void *__cpu_up_stack_pointer[];
-extern void *__cpu_up_task_pointer[];
+extern void *__cpu_spinwait_stack_pointer[];
+extern void *__cpu_spinwait_task_pointer[];
 
 #endif /* __ASM_HEAD_H */
-- 
2.33.1

