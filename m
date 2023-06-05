Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76592722B8B
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbjFEPmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbjFEPmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BDC10FB
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:41:59 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-653fcd58880so1421077b3a.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979715; x=1688571715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9bujJ7N1UFjifnLB5UKivr77scgVbFfCLxMXVtnvRk=;
        b=RNEwRUGeyVtDJkZ4XDefPZDmAd3JluYqniGwyF2/7I6IIBndBe1rJ6MpEseAE4yFWR
         awqM37LzP4xW4F6WPLVWOphMJ4tcQvbYHdknw7xx5pF4VD0Fo5KnmZejApf6YdPGZ+RG
         /mlHl9S68wXrvUQ5tUnn2RdKeHRvXtudh5G+ttd155GTAWXFrrUgMAfhaYKBD84/YXH2
         BplKQFytXe6BzwAfnBXCcBSg9wagOCYPO41WmDEarebujcu0SgwLhTSRglWK/vJ1gCnE
         2JjJ5gwZKzeNiZgQLnl9Jf8x/fTtkLrjD1husoPqzgsKFa1PWA2GoULGrXgxKzr6zBaH
         +/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979715; x=1688571715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9bujJ7N1UFjifnLB5UKivr77scgVbFfCLxMXVtnvRk=;
        b=UN8ul+IcmME4I2YmAgWMllclVkwazz3B/Oa4xDq1BfwTvhGReED/f8aB3N68YUDBXo
         i7rYta7uytgbmRfN8vuhxc2pgo0qLPl+Dl27agf3QdH1b9f+6ONy+9orZ+Ab3K+A5MLa
         m4ZP+x7eL0s2z9q30rwLeFmBaUFNe8kEgA51BRxxlyS3lujmkieMDxLy74wFMs2XQiNa
         RjGRBRSfXJ0Sc8lZCVc7qGrif4DzH/eNJ1W64U4q5cwG4vi4a/pYCzDzlYaPZ6Qsp4Lu
         wZbvf4fR0chvg+U4Cnsujxlk0NfBsvZgbTEAVUAN9Td5Dp+xik1CoWf/KYVAxYs3JQHr
         VRNA==
X-Gm-Message-State: AC+VfDzu2JAwJ/3eOvzuf8+5hEt7pL/7Ijw9C8NX85zKjbJ9qp6DU9UO
        ClcWtNO1A/4nw+JVxacqljsn7A==
X-Google-Smtp-Source: ACHHUZ5WzGqVJ/jAXvFY7sfjpnI9ESq5k6PdlASqY0y6wiA/69ciZyWliPxAeAFdqHn5yRJtLErltA==
X-Received: by 2002:a17:902:be17:b0:1b0:7c3c:31ed with SMTP id r23-20020a170902be1700b001b07c3c31edmr3306578pls.25.1685979714903;
        Mon, 05 Jun 2023 08:41:54 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:41:54 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Stefan Roesch <shr@devkernel.io>,
        Jordy Zomer <jordyzomer@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH -next v21 21/27] riscv: Add prctl controls for userspace vector management
Date:   Mon,  5 Jun 2023 11:07:18 +0000
Message-Id: <20230605110724.21391-22-andy.chiu@sifive.com>
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

This patch add two riscv-specific prctls, to allow usespace control the
use of vector unit:

 * PR_RISCV_V_SET_CONTROL: control the permission to use Vector at next,
   or all following execve for a thread. Turning off a thread's Vector
   live is not possible since libraries may have registered ifunc that
   may execute Vector instructions.
 * PR_RISCV_V_GET_CONTROL: get the same permission setting for the
   current thread, and the setting for following execve(s).

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
---
Changelog v21:
 - Remove the check in riscv_v_first_use_handler() because it is checked
   in ELF_HWCAP.
 - Mask off COMPAT_HWCAP_ISA_V in ELF_HWCAP when the user process is not
   allowed to use it.
 - properly define RISCV_V_{GET,SET}_CONTROL and remove unecessary #else
   clause. (Björn)
Changelog v20:
 - address build issue when KVM is compile as a module (Heiko)
 - s/RISCV_V_DISABLE/RISCV_ISA_V_DEFAULT_ENABLE/ (Conor)
 - change function names to have better scoping
 - check has_vector() before accessing vstate_ctrl
 - use proper return type for prctl calls (long instead of uint)
---
 arch/riscv/include/asm/processor.h |  10 +++
 arch/riscv/include/asm/vector.h    |   4 +
 arch/riscv/kernel/cpufeature.c     |   9 ++-
 arch/riscv/kernel/process.c        |   1 +
 arch/riscv/kernel/vector.c         | 114 +++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c              |   2 +
 include/uapi/linux/prctl.h         |  11 +++
 kernel/sys.c                       |  12 +++
 8 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 38ded8c5f207..e82af1097e26 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -40,6 +40,7 @@ struct thread_struct {
 	unsigned long s[12];	/* s[0]: frame pointer */
 	struct __riscv_d_ext_state fstate;
 	unsigned long bad_cause;
+	unsigned long vstate_ctrl;
 	struct __riscv_v_ext_state vstate;
 };
 
@@ -83,6 +84,15 @@ extern void riscv_fill_hwcap(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 
 extern unsigned long signal_minsigstksz __ro_after_init;
+
+#ifdef CONFIG_RISCV_ISA_V
+/* Userspace interface for PR_RISCV_V_{SET,GET}_VS prctl()s: */
+#define RISCV_V_SET_CONTROL(arg)	riscv_v_vstate_ctrl_set_current(arg)
+#define RISCV_V_GET_CONTROL()		riscv_v_vstate_ctrl_get_current()
+extern long riscv_v_vstate_ctrl_set_current(unsigned long arg);
+extern long riscv_v_vstate_ctrl_get_current(void);
+#endif /* CONFIG_RISCV_ISA_V */
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_PROCESSOR_H */
diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 8e56da67b5cf..04c0b07bf6cd 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -160,6 +160,9 @@ static inline void __switch_to_vector(struct task_struct *prev,
 	riscv_v_vstate_restore(next, task_pt_regs(next));
 }
 
+void riscv_v_vstate_ctrl_init(struct task_struct *tsk);
+bool riscv_v_vstate_ctrl_user_allowed(void);
+
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 struct pt_regs;
@@ -168,6 +171,7 @@ static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
 static __always_inline bool has_vector(void) { return false; }
 static inline bool riscv_v_first_use_handler(struct pt_regs *regs) { return false; }
 static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
+static inline bool riscv_v_vstate_ctrl_user_allowed(void) { return false; }
 #define riscv_v_vsize (0)
 #define riscv_v_vstate_save(task, regs)		do {} while (0)
 #define riscv_v_vstate_restore(task, regs)	do {} while (0)
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 29c0680652a0..8ae43e40fffc 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -295,7 +295,14 @@ void __init riscv_fill_hwcap(void)
 
 unsigned long riscv_get_elf_hwcap(void)
 {
-	return (elf_hwcap & ((1UL << RISCV_ISA_EXT_BASE) - 1));
+	unsigned long hwcap;
+
+	hwcap = (elf_hwcap & ((1UL << RISCV_ISA_EXT_BASE) - 1));
+
+	if (!riscv_v_vstate_ctrl_user_allowed())
+		hwcap &= ~COMPAT_HWCAP_ISA_V;
+
+	return hwcap;
 }
 
 #ifdef CONFIG_RISCV_ALTERNATIVE
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 78eb5ac45888..e32d737e039f 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -149,6 +149,7 @@ void flush_thread(void)
 #endif
 #ifdef CONFIG_RISCV_ISA_V
 	/* Reset vector state */
+	riscv_v_vstate_ctrl_init(current);
 	riscv_v_vstate_off(task_pt_regs(current));
 	kfree(current->thread.vstate.datap);
 	memset(&current->thread.vstate, 0, sizeof(struct __riscv_v_ext_state));
diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 9d81d1b2a7f3..a7dec9230164 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
+#include <linux/prctl.h>
 
 #include <asm/thread_info.h>
 #include <asm/processor.h>
@@ -19,6 +20,8 @@
 #include <asm/ptrace.h>
 #include <asm/bug.h>
 
+static bool riscv_v_implicit_uacc = IS_ENABLED(CONFIG_RISCV_ISA_V_DEFAULT_ENABLE);
+
 unsigned long riscv_v_vsize __read_mostly;
 EXPORT_SYMBOL_GPL(riscv_v_vsize);
 
@@ -91,6 +94,43 @@ static int riscv_v_thread_zalloc(void)
 	return 0;
 }
 
+#define VSTATE_CTRL_GET_CUR(x) ((x) & PR_RISCV_V_VSTATE_CTRL_CUR_MASK)
+#define VSTATE_CTRL_GET_NEXT(x) (((x) & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK) >> 2)
+#define VSTATE_CTRL_MAKE_NEXT(x) (((x) << 2) & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK)
+#define VSTATE_CTRL_GET_INHERIT(x) (!!((x) & PR_RISCV_V_VSTATE_CTRL_INHERIT))
+static inline int riscv_v_ctrl_get_cur(struct task_struct *tsk)
+{
+	return VSTATE_CTRL_GET_CUR(tsk->thread.vstate_ctrl);
+}
+
+static inline int riscv_v_ctrl_get_next(struct task_struct *tsk)
+{
+	return VSTATE_CTRL_GET_NEXT(tsk->thread.vstate_ctrl);
+}
+
+static inline bool riscv_v_ctrl_test_inherit(struct task_struct *tsk)
+{
+	return VSTATE_CTRL_GET_INHERIT(tsk->thread.vstate_ctrl);
+}
+
+static inline void riscv_v_ctrl_set(struct task_struct *tsk, int cur, int nxt,
+				    bool inherit)
+{
+	unsigned long ctrl;
+
+	ctrl = cur & PR_RISCV_V_VSTATE_CTRL_CUR_MASK;
+	ctrl |= VSTATE_CTRL_MAKE_NEXT(nxt);
+	if (inherit)
+		ctrl |= PR_RISCV_V_VSTATE_CTRL_INHERIT;
+	tsk->thread.vstate_ctrl = ctrl;
+}
+
+bool riscv_v_vstate_ctrl_user_allowed(void)
+{
+	return riscv_v_ctrl_get_cur(current) == PR_RISCV_V_VSTATE_CTRL_ON;
+}
+EXPORT_SYMBOL_GPL(riscv_v_vstate_ctrl_user_allowed);
+
 bool riscv_v_first_use_handler(struct pt_regs *regs)
 {
 	u32 __user *epc = (u32 __user *)regs->epc;
@@ -129,3 +169,77 @@ bool riscv_v_first_use_handler(struct pt_regs *regs)
 	riscv_v_vstate_on(regs);
 	return true;
 }
+
+void riscv_v_vstate_ctrl_init(struct task_struct *tsk)
+{
+	bool inherit;
+	int cur, next;
+
+	if (!has_vector())
+		return;
+
+	next = riscv_v_ctrl_get_next(tsk);
+	if (!next) {
+		if (riscv_v_implicit_uacc)
+			cur = PR_RISCV_V_VSTATE_CTRL_ON;
+		else
+			cur = PR_RISCV_V_VSTATE_CTRL_OFF;
+	} else {
+		cur = next;
+	}
+	/* Clear next mask if inherit-bit is not set */
+	inherit = riscv_v_ctrl_test_inherit(tsk);
+	if (!inherit)
+		next = PR_RISCV_V_VSTATE_CTRL_DEFAULT;
+
+	riscv_v_ctrl_set(tsk, cur, next, inherit);
+}
+
+long riscv_v_vstate_ctrl_get_current(void)
+{
+	if (!has_vector())
+		return -EINVAL;
+
+	return current->thread.vstate_ctrl & PR_RISCV_V_VSTATE_CTRL_MASK;
+}
+
+long riscv_v_vstate_ctrl_set_current(unsigned long arg)
+{
+	bool inherit;
+	int cur, next;
+
+	if (!has_vector())
+		return -EINVAL;
+
+	if (arg & ~PR_RISCV_V_VSTATE_CTRL_MASK)
+		return -EINVAL;
+
+	cur = VSTATE_CTRL_GET_CUR(arg);
+	switch (cur) {
+	case PR_RISCV_V_VSTATE_CTRL_OFF:
+		/* Do not allow user to turn off V if current is not off */
+		if (riscv_v_ctrl_get_cur(current) != PR_RISCV_V_VSTATE_CTRL_OFF)
+			return -EPERM;
+
+		break;
+	case PR_RISCV_V_VSTATE_CTRL_ON:
+		break;
+	case PR_RISCV_V_VSTATE_CTRL_DEFAULT:
+		cur = riscv_v_ctrl_get_cur(current);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	next = VSTATE_CTRL_GET_NEXT(arg);
+	inherit = VSTATE_CTRL_GET_INHERIT(arg);
+	switch (next) {
+	case PR_RISCV_V_VSTATE_CTRL_DEFAULT:
+	case PR_RISCV_V_VSTATE_CTRL_OFF:
+	case PR_RISCV_V_VSTATE_CTRL_ON:
+		riscv_v_ctrl_set(current, cur, next, inherit);
+		return 0;
+	}
+
+	return -EINVAL;
+}
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e5e045852e6a..de24127e7e93 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -88,6 +88,8 @@ static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
 	switch (ext) {
 	case KVM_RISCV_ISA_EXT_H:
 		return false;
+	case KVM_RISCV_ISA_EXT_V:
+		return riscv_v_vstate_ctrl_user_allowed();
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index f23d9a16507f..3c36aeade991 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -294,4 +294,15 @@ struct prctl_mm_map {
 
 #define PR_SET_MEMORY_MERGE		67
 #define PR_GET_MEMORY_MERGE		68
+
+#define PR_RISCV_V_SET_CONTROL		69
+#define PR_RISCV_V_GET_CONTROL		70
+# define PR_RISCV_V_VSTATE_CTRL_DEFAULT		0
+# define PR_RISCV_V_VSTATE_CTRL_OFF		1
+# define PR_RISCV_V_VSTATE_CTRL_ON		2
+# define PR_RISCV_V_VSTATE_CTRL_INHERIT		(1 << 4)
+# define PR_RISCV_V_VSTATE_CTRL_CUR_MASK	0x3
+# define PR_RISCV_V_VSTATE_CTRL_NEXT_MASK	0xc
+# define PR_RISCV_V_VSTATE_CTRL_MASK		0x1f
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 339fee3eff6a..05f838929e72 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -140,6 +140,12 @@
 #ifndef GET_TAGGED_ADDR_CTRL
 # define GET_TAGGED_ADDR_CTRL()		(-EINVAL)
 #endif
+#ifndef RISCV_V_SET_CONTROL
+# define RISCV_V_SET_CONTROL(a)		(-EINVAL)
+#endif
+#ifndef RISCV_V_GET_CONTROL
+# define RISCV_V_GET_CONTROL()		(-EINVAL)
+#endif
 
 /*
  * this is where the system-wide overflow UID and GID are defined, for
@@ -2708,6 +2714,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		error = !!test_bit(MMF_VM_MERGE_ANY, &me->mm->flags);
 		break;
 #endif
+	case PR_RISCV_V_SET_CONTROL:
+		error = RISCV_V_SET_CONTROL(arg2);
+		break;
+	case PR_RISCV_V_GET_CONTROL:
+		error = RISCV_V_GET_CONTROL();
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
2.17.1

