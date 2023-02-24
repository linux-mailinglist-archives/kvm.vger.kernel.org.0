Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192FB6A2033
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjBXRCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBXRCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:02:40 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F66A6B16B
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id oe18-20020a17090b395200b00236a0d55d3aso3371226pjb.3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cuVHwM8SAGoISZORc0pFtR8N61ah6dOlzZHoRJOSLIo=;
        b=YLJq0mLp+iQ+Vdr7xn4MIfa4VsG27uMObLT3tuc1EasV5G+NQ+79wengfpOI3VZ4dF
         Vv44pQ46QPD0Eak+Y4kb86nedFZs59tFUeeYY/PBGCGO7u5CgdLwadKz+tYVtgIfuWov
         0o/1rIrBE/tiR8QhoYTv2S3VGGnDpMuW9nvzpBBSI25Fxij+UmvaQhxA66iahVpMDxvx
         WCsntwA2t0dqMAWTLpiL58uVxq2WoT6DSxAb358omCo6owqfL69WuUNliAKUkBrshe8m
         ucbMZair0NvvbcLgG0CwGVddJEnTHHdYOYaZNAUY+2KOaMuX0eFb+4ow/oBB+/ExFz1+
         ggaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cuVHwM8SAGoISZORc0pFtR8N61ah6dOlzZHoRJOSLIo=;
        b=LeO3s26gtA2ql3Jqrhq7nPTmRIFFc4eKiQx6TC4yYbSz6vo3sa77QIDTDceWfl6reR
         JRbDl0SJgXNC+Rfln04iQ+WRZv36Tm8T5i9HJRCzHV3/8U7FqRSKkV2vDXutEG2sT5iC
         CUXbtGBWYlAfvwk2BuUjhZGr2GVkws7Z5Os30yzb0Hx4O25no0ouiTOGakVU1OFTzsID
         P5QhaJ+8RYQnzTuPJN7VKTJNtBCWbKiABu5e7GSGWI7xlUxslDsa5Wtke0ZmGrRZ0DXE
         m66Pla5H/wjbWnVucE8pEiQ3wV6CwOjD/W0k+4YEw1mNv7HhPnFPKgta2ODDZrzleiNR
         3RQQ==
X-Gm-Message-State: AO0yUKVw4xGg7ER2jjvgz6pmdPBW8WChVwUJX5Kget9xuqyVutEZK/oS
        +PFxS1CAPx9DGVMydUh6i0qyPg==
X-Google-Smtp-Source: AK7set/iEoKSIyULmeDYOrjpIv5td8+55ORgojii3FjvyrzjZRbRGpCctznPLg4f2d43QLaRVqysnQ==
X-Received: by 2002:a17:902:e543:b0:19c:d932:f063 with SMTP id n3-20020a170902e54300b0019cd932f063mr2255172plf.67.1677258152778;
        Fri, 24 Feb 2023 09:02:32 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:02:30 -0800 (PST)
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
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH -next v14 09/19] riscv: Add task switch support for vector
Date:   Fri, 24 Feb 2023 17:01:08 +0000
Message-Id: <20230224170118.16766-10-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch adds task switch support for vector. It also supports all
lengths of vlen.

[guoren@linux.alibaba.com: First available porting to support vector
context switching]
[nick.knight@sifive.com: Rewrite vector.S to support dynamic vlen, xlen and
code refine]
[vincent.chen@sifive.com: Fix the might_sleep issue in riscv_v_vstate_save,
riscv_v_vstate_restore]
[andrew@sifive.com: Optimize task switch codes of vector]
[ruinland.tsai@sifive.com: Fix the arch_release_task_struct free wrong
datap issue]
[vineetg: Fixed lkp warning with W=1 build]
[andy.chiu: Use inline asm for task switches]

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
 arch/riscv/include/asm/switch_to.h   |  3 ++
 arch/riscv/include/asm/thread_info.h |  3 ++
 arch/riscv/include/asm/vector.h      | 43 ++++++++++++++++++++++++++--
 arch/riscv/kernel/process.c          | 18 ++++++++++++
 5 files changed, 66 insertions(+), 2 deletions(-)

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
index 9c025f2efdc3..830f9d3c356b 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -10,6 +10,9 @@
 
 #ifdef CONFIG_RISCV_ISA_V
 
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+#include <asm/ptrace.h>
 #include <asm/hwcap.h>
 #include <asm/csr.h>
 #include <asm/asm.h>
@@ -75,7 +78,8 @@ static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_state *src
 		    "r" (src->vcsr) :);
 }
 
-static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *save_to, void *datap)
+static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *save_to,
+					 void *datap)
 {
 	riscv_v_enable();
 	__vstate_csr_save(save_to);
@@ -93,7 +97,7 @@ static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *save_to, vo
 }
 
 static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_from,
-				    void *datap)
+					    void *datap)
 {
 	riscv_v_enable();
 	asm volatile (
@@ -110,6 +114,38 @@ static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_
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
@@ -118,6 +154,9 @@ static __always_inline bool has_vector(void) { return false; }
 static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
 #define riscv_v_vsize (0)
 #define riscv_v_setup_vsize()	 do {} while (0)
+#define riscv_v_vstate_save(task, regs)		do {} while (0)
+#define riscv_v_vstate_restore(task, regs)	do {} while (0)
+#define __switch_to_vector(__prev, __next)	do {} while (0)
 #define riscv_v_vstate_off(regs)		do {} while (0)
 #define riscv_v_vstate_on(regs)			do {} while (0)
 
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 8955f2432c2d..5e9506a32fbe 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -24,6 +24,7 @@
 #include <asm/switch_to.h>
 #include <asm/thread_info.h>
 #include <asm/cpuidle.h>
+#include <asm/vector.h>
 
 register unsigned long gp_in_global __asm__("gp");
 
@@ -148,12 +149,28 @@ void flush_thread(void)
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
+	if (has_vector() && tsk->thread.vstate.datap)
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
 
@@ -186,6 +203,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		childregs->a0 = 0; /* Return value of fork() */
 		p->thread.ra = (unsigned long)ret_from_fork;
 	}
+	riscv_v_vstate_off(childregs);
 	p->thread.sp = (unsigned long)childregs; /* kernel sp */
 	return 0;
 }
-- 
2.17.1

