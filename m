Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C83722B7D
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbjFEPlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjFEPli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:41:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E907510FF
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:41:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b0236ee816so35857045ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979643; x=1688571643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5ABTghwvTI+9r/qQCKwtiC6pFEmv/0ohdPEWRF58vQ=;
        b=LJTknzgh62SsCBHuGzktWmw6QJJSAbz3CWS0rkA7cAh1fMdPCXUD1298oD0xdojFmR
         fPCeO0fbj1uMVI7dOWcbQODQme6Lf/niY+qlbN4SrPriQ9CybIhRcOKLjjQgmMDDrBrE
         kejG0Xyl4InXJVJmxqBOjmzTNok/PHiPj5mFOnVPa9X1b9j8xNpCpJckYcuwELnGniHW
         zjuAB9FCb+/gXXuhDkOCQbWEdMlBCJ+Zy1CUDu/EDJYeZOp+2qrIHudfrXT1dWwT0i4Y
         tYO1MSdrC+hetQVXkTzdowgAs6oFq2mxvr9LbkRFCAgPb8gtqfv9A1q47pk81vcCuAtH
         OFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979643; x=1688571643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H5ABTghwvTI+9r/qQCKwtiC6pFEmv/0ohdPEWRF58vQ=;
        b=kONWXxuVBeZL9Jrbc5EJ0yAcCUpOC5LRx7aGz3dcjFHSdnnvK5PTLBYh73cay/2Hpu
         UPvrXP3hWBtU4wYeDfZQiaDzorYBA0Rx+8dX6PqKfnVNYS+pPRF86N5xohUki6nrkhzl
         CrBMayzhurvkq8lRlVFVQ+DeCky3F34/gf9AsUP0on5iiW7XOX5pF0YziYd15LeabjI8
         apIE4QXC+Y/0tqVei8emm7qkdSt3hm9OWLh6BskgYXaRW+1sil1PkDFRM9KJvwFz8h32
         /WsNfx4ODQDex8HElfjiJ09CMvvrq56oTIfBA6+JQRaa4baS2XC+FRfib6VaomHzzOEX
         aFDA==
X-Gm-Message-State: AC+VfDzlE8ogO7J0ED9C3yT/YokFBDeejTpmVbx+hSMv3PxE/G19OR0T
        LozuAgCFAV3lE/O4gRTWvLUmtA==
X-Google-Smtp-Source: ACHHUZ7uA9bDyWuvzGvUPYr/uB402G/5hp1cVeED86CmlSqKsIuxEz5sfvvR1j388KxSjkBEpf0SuQ==
X-Received: by 2002:a17:902:ec90:b0:1b1:94a8:ab2d with SMTP id x16-20020a170902ec9000b001b194a8ab2dmr9133436plg.29.1685979643627;
        Mon, 05 Jun 2023 08:40:43 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:40:43 -0700 (PDT)
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
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -next v21 10/27] riscv: Add task switch support for vector
Date:   Mon,  5 Jun 2023 11:07:07 +0000
Message-Id: <20230605110724.21391-11-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
Changelog v21:
 - move riscv_v_vstate_off(childregs); to a proper place.
---
 arch/riscv/include/asm/processor.h   |  1 +
 arch/riscv/include/asm/switch_to.h   |  3 +++
 arch/riscv/include/asm/thread_info.h |  3 +++
 arch/riscv/include/asm/vector.h      | 38 ++++++++++++++++++++++++++++
 arch/riscv/kernel/process.c          | 19 ++++++++++++++
 5 files changed, 64 insertions(+)

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
index e0d202134b44..97e6f65ec176 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -81,6 +81,9 @@ struct thread_info {
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 }
 
+void arch_release_task_struct(struct task_struct *tsk);
+int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 3c29f4eb552a..ce6a75e9cf62 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -12,6 +12,9 @@
 #ifdef CONFIG_RISCV_ISA_V
 
 #include <linux/stringify.h>
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+#include <asm/ptrace.h>
 #include <asm/hwcap.h>
 #include <asm/csr.h>
 #include <asm/asm.h>
@@ -124,6 +127,38 @@ static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_
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
@@ -132,6 +167,9 @@ static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
 static __always_inline bool has_vector(void) { return false; }
 static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
 #define riscv_v_vsize (0)
+#define riscv_v_vstate_save(task, regs)		do {} while (0)
+#define riscv_v_vstate_restore(task, regs)	do {} while (0)
+#define __switch_to_vector(__prev, __next)	do {} while (0)
 #define riscv_v_vstate_off(regs)		do {} while (0)
 #define riscv_v_vstate_on(regs)			do {} while (0)
 
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index e2a060066730..78eb5ac45888 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -24,6 +24,7 @@
 #include <asm/switch_to.h>
 #include <asm/thread_info.h>
 #include <asm/cpuidle.h>
+#include <asm/vector.h>
 
 register unsigned long gp_in_global __asm__("gp");
 
@@ -146,12 +147,28 @@ void flush_thread(void)
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
 
@@ -176,6 +193,8 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		p->thread.s[1] = (unsigned long)args->fn_arg;
 	} else {
 		*childregs = *(current_pt_regs());
+		/* Turn off status.VS */
+		riscv_v_vstate_off(childregs);
 		if (usp) /* User fork */
 			childregs->sp = usp;
 		if (clone_flags & CLONE_SETTLS)
-- 
2.17.1

