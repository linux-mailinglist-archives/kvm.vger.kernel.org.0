Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1097C6BE85C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjCQLiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjCQLhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:47 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661C6E1FED
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:37:20 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id le6so4965046plb.12
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053034;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NcKTsCTSmNOhC0Xny21sgBkTMqUxDz8AQSzRNkwiV+c=;
        b=LAnYMr8AniVKHebGhBlbV/2nzpRatI7lW9XonCtjrl2kftaZP/1/PiCjWoGUqdEDFW
         MgsnXwJsDEWp+YFA6tceWNzcL/qJ/75pYcJWglJIUL1gRZDqZbDDzkb+LSu4TrHDgMdX
         u/nKZIXYRdisfr7tgm3OTyljtPU4m8v+j4M6h96ikhEC7EEXB2yfnVRawT/RJVvhqRUz
         iYkHLvy76ACzb97ywLtW6gM/acbJRBxvD0uWvdo2tGrp5fT85UjNIES1PomkMrVMdp74
         yjVya0iKKnSz4vo7xTQrlqS1lyLtzokHdm5dm9NqoFQ04k4YPgxKNPecurklk+Ivfmqc
         lOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053034;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NcKTsCTSmNOhC0Xny21sgBkTMqUxDz8AQSzRNkwiV+c=;
        b=6YM1y2G4k6LhHrH1Q0tX/11MR5Hpw12pEHH9TzCOKdAoMawZPTqT1pvnCn14I9nOu2
         cxThyAKJBw2voDtSfj4ti5b/59fx2EqEN1s/KOTkk/7iGXH6gz/nAOxPuMjMrYFNvK3L
         vBMyclXRVEK0BDAB83kzCLtkIKXwGGYYIpV7ow/goiXRlqjWdAnWrZ/HLirkemndzSbx
         vQEKhiTAGvK+NLG5tjpkT6JVzRUsxRsBp0A9nu+1FjfDShFUGBxkdEnJ05Ggfx94yOsW
         LL2+DmtuBjRWWTqgHx+2yHGTnkBaru1O4R5G6C/BYiHdHGu9ro/tVQGy4pUF6NIxLV7W
         ckEA==
X-Gm-Message-State: AO0yUKV8UEHn2rrE95ebvFENTXKICWLAsDxTu/svUvqpRJg5ULxWLetq
        ynPCz6S6BIZM+VO5p2QL35zoYQ==
X-Google-Smtp-Source: AK7set/mxVr12xBwqvn4nHRgAfEiBiEHjZfBQMOzh8WHQXZt2LI3VSTLxV6Al1KQ3YU7Q7p2y7x7cg==
X-Received: by 2002:a17:90b:1e11:b0:23d:1e5f:eea6 with SMTP id pg17-20020a17090b1e1100b0023d1e5feea6mr8134234pjb.24.1679053034131;
        Fri, 17 Mar 2023 04:37:14 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:37:13 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Nick Knight <nick.knight@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -next v15 09/19] riscv: Add task switch support for vector
Date:   Fri, 17 Mar 2023 11:35:28 +0000
Message-Id: <20230317113538.10878-10-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch adds task switch support for vector. It also supports all
lengths of vlen.

Suggested-by: Andrew Waterman <andrew@sifive.com>
Co-developed-by: Nick Knight <nick.knight@sifive.com>
Signed-off-by: Nick Knight <nick.knight@sifive.com>
Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Co-developed-by: Ruinland Tsai <ruinland.tsai@sifive.com>
Signed-off-by: Ruinland Tsai <ruinland.tsai@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/include/asm/processor.h   |  1 +
 arch/riscv/include/asm/switch_to.h   |  3 +++
 arch/riscv/include/asm/thread_info.h |  3 +++
 arch/riscv/include/asm/vector.h      | 38 ++++++++++++++++++++++++++++
 arch/riscv/kernel/process.c          | 18 +++++++++++++
 5 files changed, 63 insertions(+)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 94a0590c6971..f0ddf691ac5e 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -39,6 +39,7 @@ struct thread_struct {
 	unsigned long s[12];	/* s[0]: frame pointer */
 	struct __riscv_d_ext_state fstate;
 	unsigned long bad_cause;
+	struct __riscv_v_ext_state vstate;
 };
 
 /* Whitelist the fstate from the task_struct for hardened usercopy */
diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 4b96b13dee27..a727be723c56 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -8,6 +8,7 @@
 
 #include <linux/jump_label.h>
 #include <linux/sched/task_stack.h>
+#include <asm/vector.h>
 #include <asm/hwcap.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
@@ -78,6 +79,8 @@ do {							\
 	struct task_struct *__next = (next);		\
 	if (has_fpu())					\
 		__switch_to_fpu(__prev, __next);	\
+	if (has_vector())					\
+		__switch_to_vector(__prev, __next);	\
 	((last) = __switch_to(__prev, __next));		\
 } while (0)
 
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index f704c8dd57e0..9e28c0199030 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -80,6 +80,9 @@ struct thread_info {
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 }
 
+void arch_release_task_struct(struct task_struct *tsk);
+int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index c7143b7d64d1..3bfa223facd0 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -11,6 +11,9 @@
 #ifdef CONFIG_RISCV_ISA_V
 
 #include <linux/stringify.h>
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+#include <asm/ptrace.h>
 #include <asm/hwcap.h>
 #include <asm/csr.h>
 #include <asm/asm.h>
@@ -123,6 +126,38 @@ static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_
 	riscv_v_disable();
 }
 
+static inline void riscv_v_vstate_save(struct task_struct *task,
+				       struct pt_regs *regs)
+{
+	if ((regs->status & SR_VS) == SR_VS_DIRTY) {
+		struct __riscv_v_ext_state *vstate = &task->thread.vstate;
+
+		__riscv_v_vstate_save(vstate, vstate->datap);
+		__riscv_v_vstate_clean(regs);
+	}
+}
+
+static inline void riscv_v_vstate_restore(struct task_struct *task,
+					  struct pt_regs *regs)
+{
+	if ((regs->status & SR_VS) != SR_VS_OFF) {
+		struct __riscv_v_ext_state *vstate = &task->thread.vstate;
+
+		__riscv_v_vstate_restore(vstate, vstate->datap);
+		__riscv_v_vstate_clean(regs);
+	}
+}
+
+static inline void __switch_to_vector(struct task_struct *prev,
+				      struct task_struct *next)
+{
+	struct pt_regs *regs;
+
+	regs = task_pt_regs(prev);
+	riscv_v_vstate_save(prev, regs);
+	riscv_v_vstate_restore(next, task_pt_regs(next));
+}
+
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 struct pt_regs;
@@ -131,6 +166,9 @@ static __always_inline bool has_vector(void) { return false; }
 static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
 #define riscv_v_vsize (0)
 #define riscv_v_setup_vsize()	 		do {} while (0)
+#define riscv_v_vstate_save(task, regs)		do {} while (0)
+#define riscv_v_vstate_restore(task, regs)	do {} while (0)
+#define __switch_to_vector(__prev, __next)	do {} while (0)
 #define riscv_v_vstate_off(regs)		do {} while (0)
 #define riscv_v_vstate_on(regs)			do {} while (0)
 
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 774ffde386ab..44ca0be58ce7 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -24,6 +24,7 @@
 #include <asm/switch_to.h>
 #include <asm/thread_info.h>
 #include <asm/cpuidle.h>
+#include <asm/vector.h>
 
 register unsigned long gp_in_global __asm__("gp");
 
@@ -147,12 +148,28 @@ void flush_thread(void)
 	fstate_off(current, task_pt_regs(current));
 	memset(&current->thread.fstate, 0, sizeof(current->thread.fstate));
 #endif
+#ifdef CONFIG_RISCV_ISA_V
+	/* Reset vector state */
+	riscv_v_vstate_off(task_pt_regs(current));
+	kfree(current->thread.vstate.datap);
+	memset(&current->thread.vstate, 0, sizeof(struct __riscv_v_ext_state));
+#endif
+}
+
+void arch_release_task_struct(struct task_struct *tsk)
+{
+	/* Free the vector context of datap. */
+	if (has_vector())
+		kfree(tsk->thread.vstate.datap);
 }
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	fstate_save(src, task_pt_regs(src));
 	*dst = *src;
+	/* clear entire V context, including datap for a new task */
+	memset(&dst->thread.vstate, 0, sizeof(struct __riscv_v_ext_state));
+
 	return 0;
 }
 
@@ -185,6 +202,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		childregs->a0 = 0; /* Return value of fork() */
 		p->thread.ra = (unsigned long)ret_from_fork;
 	}
+	riscv_v_vstate_off(childregs);
 	p->thread.sp = (unsigned long)childregs; /* kernel sp */
 	return 0;
 }
-- 
2.17.1

