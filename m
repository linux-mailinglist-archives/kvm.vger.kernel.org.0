Return-Path: <kvm+bounces-5211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB4281E096
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43E751F2225D
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E67754671;
	Mon, 25 Dec 2023 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJnjrJAi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11CE5465D;
	Mon, 25 Dec 2023 12:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94ABC433C8;
	Mon, 25 Dec 2023 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703509172;
	bh=kkru5AupVKU3hs+mHvoEPpuFyMHQbRxJfVqf8K9xzVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJnjrJAiZ46+IrPi0Dz6h/4rTawxuxsmPbGG3tcxHca6WTYI84WE4GAMRqAK0/aI7
	 bOhDDW4aKfBQMwy1EyqqWPwFCuhAgIn+Vp83lPqVDrZsLyJeXiksZmw9gmLzYdekuQ
	 Zl39fCj7OjskSf/RDjetyikMzAE6/3ApQo1sL4132NqL4ozLk2UpaRGiZu+9Rc16w9
	 Mr4CtgFHIX+KrK9bq1pqrjbTSjZIkkz1XnTauv+v8C8vOEpu6GQSM6efS8ctLtGGAb
	 x8LZDFHZ9HrxtLiph3qzXbNlU5IyAc3oYXTnSvFdVZ4QxiuHBnzMRgowV3Y+r5dz+B
	 X+PhEY6ayHBhw==
From: guoren@kernel.org
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	guoren@kernel.org,
	panqinglin2020@iscas.ac.cn,
	bjorn@rivosinc.com,
	conor.dooley@microchip.com,
	leobras@redhat.com,
	peterz@infradead.org,
	anup@brainfault.org,
	keescook@chromium.org,
	wuwei2016@iscas.ac.cn,
	xiaoguang.xing@sophgo.com,
	chao.wei@sophgo.com,
	unicorn_wang@outlook.com,
	uwu@icenowy.me,
	jszhang@kernel.org,
	wefu@redhat.com,
	atishp@atishpatra.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH V12 06/14] riscv: qspinlock: Introduce combo spinlock
Date: Mon, 25 Dec 2023 07:58:39 -0500
Message-Id: <20231225125847.2778638-7-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231225125847.2778638-1-guoren@kernel.org>
References: <20231225125847.2778638-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

Combo spinlock could support queued and ticket in one Linux Image and
select them during boot time via command line. Here is the func
size (Bytes) comparison table below:

TYPE			: COMBO | TICKET | QUEUED
arch_spin_lock		: 106	| 60     | 50
arch_spin_unlock	: 54    | 36     | 26
arch_spin_trylock	: 110   | 72     | 54
arch_spin_is_locked	: 48    | 34     | 20
arch_spin_is_contended	: 56    | 40     | 24
rch_spin_value_unlocked	: 48    | 34     | 24

One example of disassemble combo arch_spin_unlock:
  <+14>:    nop                # detour slot
  <+18>:    fence   rw,w       --+-> queued_spin_unlock
  <+22>:    sb      zero,0(a4) --+   (2 instructions)
  <+26>:    ld      s0,8(sp)
  <+28>:    addi    sp,sp,16
  <+30>:    ret
  <+32>:    lw      a5,0(a4)   --+-> ticket_spin_unlock
  <+34>:    sext.w  a5,a5        |   (7 instructions)
  <+36>:    fence   rw,w         |
  <+40>:    addiw   a5,a5,1      |
  <+42>:    slli    a5,a5,0x30   |
  <+44>:    srli    a5,a5,0x30   |
  <+46>:    sh      a5,0(a4)   --+
  <+50>:    ld      s0,8(sp)
  <+52>:    addi    sp,sp,16
  <+54>:    ret
The qspinlock is smaller and faster than ticket-lock when all are in a
fast path.

The combo spinlock could provide a compatible Linux Image for different
micro-arch designs that have/haven't forward progress guarantee. Use
command line options to select between qspinlock and ticket-lock, and
the default is ticket-lock.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  2 +
 arch/riscv/Kconfig                            |  9 +++-
 arch/riscv/include/asm/spinlock.h             | 48 +++++++++++++++++++
 arch/riscv/kernel/setup.c                     | 34 +++++++++++++
 include/asm-generic/qspinlock.h               |  2 +
 include/asm-generic/ticket_spinlock.h         |  2 +
 6 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 65731b060e3f..2ac9f1511774 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4753,6 +4753,8 @@
 			[KNL] Number of legacy pty's. Overwrites compiled-in
 			default number.
 
+	qspinlock	[RISCV] Use native qspinlock.
+
 	quiet		[KNL] Disable most log messages
 
 	r128=		[HW,DRM]
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index f345df0763b2..b7673c5c0997 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -434,7 +434,7 @@ config NODES_SHIFT
 
 choice
 	prompt "RISC-V spinlock type"
-	default RISCV_TICKET_SPINLOCKS
+	default RISCV_COMBO_SPINLOCKS
 
 config RISCV_TICKET_SPINLOCKS
 	bool "Using ticket spinlock"
@@ -446,6 +446,13 @@ config RISCV_QUEUED_SPINLOCKS
 	help
 	  Make sure your micro arch give cmpxchg/xchg forward progress
 	  guarantee. Otherwise, stay at ticket-lock.
+
+config RISCV_COMBO_SPINLOCKS
+	bool "Using combo spinlock"
+	depends on SMP && MMU
+	select ARCH_USE_QUEUED_SPINLOCKS
+	help
+	  Select queued spinlock or ticket-lock by cmdline.
 endchoice
 
 config RISCV_ALTERNATIVE
diff --git a/arch/riscv/include/asm/spinlock.h b/arch/riscv/include/asm/spinlock.h
index 98a3da4b1056..d07643c07aae 100644
--- a/arch/riscv/include/asm/spinlock.h
+++ b/arch/riscv/include/asm/spinlock.h
@@ -7,12 +7,60 @@
 #define _Q_PENDING_LOOPS	(1 << 9)
 #endif
 
+#ifdef CONFIG_RISCV_COMBO_SPINLOCKS
+#define __no_arch_spinlock_redefine
+#include <asm/ticket_spinlock.h>
+#include <asm/qspinlock.h>
+#include <linux/jump_label.h>
+
+DECLARE_STATIC_KEY_TRUE(combo_qspinlock_key);
+
+#define COMBO_SPINLOCK_BASE_DECLARE(op)					\
+static __always_inline void arch_spin_##op(arch_spinlock_t *lock)	\
+{									\
+	if (static_branch_likely(&combo_qspinlock_key))			\
+		queued_spin_##op(lock);					\
+	else								\
+		ticket_spin_##op(lock);					\
+}
+COMBO_SPINLOCK_BASE_DECLARE(lock)
+COMBO_SPINLOCK_BASE_DECLARE(unlock)
+
+#define COMBO_SPINLOCK_IS_DECLARE(op)					\
+static __always_inline int arch_spin_##op(arch_spinlock_t *lock)	\
+{									\
+	if (static_branch_likely(&combo_qspinlock_key))			\
+		return queued_spin_##op(lock);				\
+	else								\
+		return ticket_spin_##op(lock);				\
+}
+COMBO_SPINLOCK_IS_DECLARE(is_locked)
+COMBO_SPINLOCK_IS_DECLARE(is_contended)
+
+static __always_inline bool arch_spin_trylock(arch_spinlock_t *lock)
+{
+	if (static_branch_likely(&combo_qspinlock_key))
+		return queued_spin_trylock(lock);
+	else
+		return ticket_spin_trylock(lock);
+}
+
+static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
+{
+	if (static_branch_likely(&combo_qspinlock_key))
+		return queued_spin_value_unlocked(lock);
+	else
+		return ticket_spin_value_unlocked(lock);
+}
+
+#else /* CONFIG_RISCV_COMBO_SPINLOCKS */
 #ifdef CONFIG_QUEUED_SPINLOCKS
 #include <asm/qspinlock.h>
 #else
 #include <asm/ticket_spinlock.h>
 #endif
 
+#endif /* CONFIG_RISCV_COMBO_SPINLOCKS */
 #include <asm/qrwlock.h>
 
 #endif /* __ASM_RISCV_SPINLOCK_H */
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 535a837de55d..d9072a59831c 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -246,6 +246,37 @@ static void __init parse_dtb(void)
 #endif
 }
 
+#ifdef CONFIG_RISCV_COMBO_SPINLOCKS
+static bool enable_qspinlock __ro_after_init;
+static int __init queued_spinlock_setup(char *p)
+{
+	enable_qspinlock = true;
+
+	return 0;
+}
+early_param("qspinlock", queued_spinlock_setup);
+
+/*
+ * Ticket-lock would dirty the lock value, so force qspinlock at
+ * first and switch to ticket-lock later.
+ *  - key is true : qspinlock -> qspinlock (no change)
+ *  - key is false: qspinlock -> ticket-lock
+ *    (No ticket-lock -> qspinlock)
+ */
+DEFINE_STATIC_KEY_TRUE(combo_qspinlock_key);
+EXPORT_SYMBOL(combo_qspinlock_key);
+
+static void __init riscv_spinlock_init(void)
+{
+	if (!enable_qspinlock) {
+		static_branch_disable(&combo_qspinlock_key);
+		pr_info("Ticket spinlock: enabled\n");
+	} else {
+		pr_info("Queued spinlock: enabled\n");
+	}
+}
+#endif
+
 extern void __init init_rt_signal_env(void);
 
 void __init setup_arch(char **cmdline_p)
@@ -297,6 +328,9 @@ void __init setup_arch(char **cmdline_p)
 	riscv_set_dma_cache_alignment();
 
 	riscv_user_isa_enable();
+#ifdef CONFIG_RISCV_COMBO_SPINLOCKS
+	riscv_spinlock_init();
+#endif
 }
 
 static int __init topology_init(void)
diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index 0655aa5b57b2..bf47cca2c375 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -136,6 +136,7 @@ static __always_inline bool virt_spin_lock(struct qspinlock *lock)
 }
 #endif
 
+#ifndef __no_arch_spinlock_redefine
 /*
  * Remapping spinlock architecture specific functions to the corresponding
  * queued spinlock functions.
@@ -146,5 +147,6 @@ static __always_inline bool virt_spin_lock(struct qspinlock *lock)
 #define arch_spin_lock(l)		queued_spin_lock(l)
 #define arch_spin_trylock(l)		queued_spin_trylock(l)
 #define arch_spin_unlock(l)		queued_spin_unlock(l)
+#endif
 
 #endif /* __ASM_GENERIC_QSPINLOCK_H */
diff --git a/include/asm-generic/ticket_spinlock.h b/include/asm-generic/ticket_spinlock.h
index cfcff22b37b3..325779970d8a 100644
--- a/include/asm-generic/ticket_spinlock.h
+++ b/include/asm-generic/ticket_spinlock.h
@@ -89,6 +89,7 @@ static __always_inline int ticket_spin_is_contended(arch_spinlock_t *lock)
 	return (s16)((val >> 16) - (val & 0xffff)) > 1;
 }
 
+#ifndef __no_arch_spinlock_redefine
 /*
  * Remapping spinlock architecture specific functions to the corresponding
  * ticket spinlock functions.
@@ -99,5 +100,6 @@ static __always_inline int ticket_spin_is_contended(arch_spinlock_t *lock)
 #define arch_spin_lock(l)		ticket_spin_lock(l)
 #define arch_spin_trylock(l)		ticket_spin_trylock(l)
 #define arch_spin_unlock(l)		ticket_spin_unlock(l)
+#endif
 
 #endif /* __ASM_GENERIC_TICKET_SPINLOCK_H */
-- 
2.40.1


