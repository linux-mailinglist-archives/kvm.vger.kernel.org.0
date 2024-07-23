Return-Path: <kvm+bounces-22095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9688C939BD3
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 09:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 123F21F225D6
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 07:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B91814C5AE;
	Tue, 23 Jul 2024 07:38:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF4B14A4EF;
	Tue, 23 Jul 2024 07:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721720313; cv=none; b=SLiZrceIGfmkIxML78l3XG5g09HBKgHJEufb8AVTx5MGIkUBvBRmv9k0+lrU0xqeNmTfwfEtBobkHBhLXQ/A10by8d7lA0FsR2u5qevLRXlDJyslEksaimtoijkCbL5vaRkTMAaTyUrQToc+Ys1pwrMYZLKjFkux+/ir1YKh/yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721720313; c=relaxed/simple;
	bh=2QBpHT0ze2oXtG0u7q1lbwjm7BGMngAeMpX/dwQ+BnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fXgCyxqd3bmWUIq0nqGP04KF+axEeJKjErpZX0BgyQiYDoOJ+mtJMNAFL+Ct+DyW54vz7OfrTd38TgF2S3nQXX5XCTdQ/FaSeOmPlW/odvl6/VVFgSypY+bw3xIEM7LVud1ml/hBOxgncRAU18Y/KcDKGDwi21GpVnVNDEdgimo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxGur0XZ9m8mAAAA--.1436S3;
	Tue, 23 Jul 2024 15:38:28 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxusbxXZ9m+l9VAA--.59486S4;
	Tue, 23 Jul 2024 15:38:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 2/2] LoongArch: KVM: Add paravirt qspinlock in guest side
Date: Tue, 23 Jul 2024 15:38:25 +0800
Message-Id: <20240723073825.1811600-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240723073825.1811600-1-maobibo@loongson.cn>
References: <20240723073825.1811600-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxusbxXZ9m+l9VAA--.59486S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Option PARAVIRT_SPINLOCKS is added on LoongArch system, and
pv_lock_ops template is added here. If option PARAVIRT_SPINLOCKS
is enabled, the native ops works on host machine.

Two functions kvm_wait() and kvm_kick_cpu() are added specicial for
VM, if VM detects hypervisor supports pv spinlock. With kvm_wait()
vCPU thread will exit to hypervisor and give up scheduleing on pCPU,
and with function kvm_kick_cpu() one hypercall function is used
to notify hypervisor to wakeup previously waited vCPU.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/Kconfig                        | 14 +++
 arch/loongarch/include/asm/Kbuild             |  1 -
 arch/loongarch/include/asm/paravirt.h         | 47 ++++++++++
 arch/loongarch/include/asm/qspinlock.h        | 39 ++++++++
 .../include/asm/qspinlock_paravirt.h          |  6 ++
 arch/loongarch/kernel/paravirt.c              | 88 +++++++++++++++++++
 arch/loongarch/kernel/smp.c                   |  4 +-
 7 files changed, 197 insertions(+), 2 deletions(-)
 create mode 100644 arch/loongarch/include/asm/qspinlock.h
 create mode 100644 arch/loongarch/include/asm/qspinlock_paravirt.h

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index b81d0eba5c7e..7ad63db2fafd 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -660,6 +660,20 @@ config PARAVIRT_TIME_ACCOUNTING
 
 	  If in doubt, say N here.
 
+config PARAVIRT_SPINLOCKS
+	bool "Paravirtual queued spinlocks"
+	select PARAVIRT
+	depends on SMP
+	help
+	  Paravirtualized spinlocks allow a pvops backend to replace the
+	  spinlock implementation with something virtualization-friendly
+	  (for example, block the virtual CPU rather than spinning).
+
+	  It has a minimal impact on native kernels and gives a nice performance
+	  benefit on paravirtualized kernels.
+
+	  If you are unsure how to answer this question, answer Y.
+
 endmenu
 
 config ARCH_SELECT_MEMORY_MODEL
diff --git a/arch/loongarch/include/asm/Kbuild b/arch/loongarch/include/asm/Kbuild
index 2bb3676429c0..4635b755b2b4 100644
--- a/arch/loongarch/include/asm/Kbuild
+++ b/arch/loongarch/include/asm/Kbuild
@@ -6,7 +6,6 @@ generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += early_ioremap.h
 generic-y += qrwlock.h
-generic-y += qspinlock.h
 generic-y += user.h
 generic-y += ioctl.h
 generic-y += statfs.h
diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
index dddec49671ae..2617d635171b 100644
--- a/arch/loongarch/include/asm/paravirt.h
+++ b/arch/loongarch/include/asm/paravirt.h
@@ -20,6 +20,47 @@ static inline u64 paravirt_steal_clock(int cpu)
 int __init pv_ipi_init(void);
 int __init pv_time_init(void);
 
+#if defined(CONFIG_PARAVIRT_SPINLOCKS)
+struct qspinlock;
+struct pv_lock_ops {
+	void (*queued_spin_lock_slowpath)(struct qspinlock *lock, u32 val);
+	void (*queued_spin_unlock)(struct qspinlock *lock);
+	void (*wait)(u8 *ptr, u8 val);
+	void (*kick)(int cpu);
+	bool (*vcpu_is_preempted)(int cpu);
+};
+
+extern struct pv_lock_ops pv_lock_ops;
+
+void __init kvm_spinlock_init(void);
+bool pv_is_native_spin_unlock(void);
+
+static __always_inline void pv_queued_spin_lock_slowpath(struct qspinlock *lock,
+		u32 val)
+{
+	pv_lock_ops.queued_spin_lock_slowpath(lock, val);
+}
+
+static __always_inline void pv_queued_spin_unlock(struct qspinlock *lock)
+{
+	pv_lock_ops.queued_spin_unlock(lock);
+}
+
+static __always_inline void pv_wait(u8 *ptr, u8 val)
+{
+	pv_lock_ops.wait(ptr, val);
+}
+
+static __always_inline void pv_kick(int cpu)
+{
+	pv_lock_ops.kick(cpu);
+}
+
+static __always_inline bool pv_vcpu_is_preempted(long cpu)
+{
+	return pv_lock_ops.vcpu_is_preempted(cpu);
+}
+#endif /* PARAVIRT_SPINLOCKS */
 #else
 
 static inline int pv_ipi_init(void)
@@ -32,4 +73,10 @@ static inline int pv_time_init(void)
 	return 0;
 }
 #endif // CONFIG_PARAVIRT
+
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
+static inline void kvm_spinlock_init(void)
+{
+}
+#endif
 #endif
diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/include/asm/qspinlock.h
new file mode 100644
index 000000000000..8e1b14c9e906
--- /dev/null
+++ b/arch/loongarch/include/asm/qspinlock.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_LOONGARCH_QSPINLOCK_H
+#define _ASM_LOONGARCH_QSPINLOCK_H
+
+#include <asm/paravirt.h>
+
+#define _Q_PENDING_LOOPS       (1 << 9)
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+/* How long a lock should spin before we consider blocking */
+#define SPIN_THRESHOLD  (1 << 15)
+
+extern void native_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+extern void __pv_init_lock_hash(void);
+extern void __pv_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+extern void __pv_queued_spin_unlock(struct qspinlock *lock);
+extern bool nopvspin;
+
+static inline void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
+{
+	pv_queued_spin_lock_slowpath(lock, val);
+}
+
+#define queued_spin_unlock queued_spin_unlock
+static inline void queued_spin_unlock(struct qspinlock *lock)
+{
+	pv_queued_spin_unlock(lock);
+}
+
+#define vcpu_is_preempted vcpu_is_preempted
+static inline bool vcpu_is_preempted(long cpu)
+{
+	return pv_vcpu_is_preempted(cpu);
+}
+#endif
+
+#include <asm-generic/qspinlock.h>
+
+#endif // _ASM_LOONGARCH_QSPINLOCK_H
diff --git a/arch/loongarch/include/asm/qspinlock_paravirt.h b/arch/loongarch/include/asm/qspinlock_paravirt.h
new file mode 100644
index 000000000000..d6d7f487daea
--- /dev/null
+++ b/arch/loongarch/include/asm/qspinlock_paravirt.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_QSPINLOCK_PARAVIRT_H
+#define __ASM_QSPINLOCK_PARAVIRT_H
+
+void __lockfunc __pv_queued_spin_unlock_slowpath(struct qspinlock *lock, u8 locked);
+#endif
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index aee44610007d..758039eabdde 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -298,3 +298,91 @@ int __init pv_time_init(void)
 
 	return 0;
 }
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+static  bool native_vcpu_is_preempted(int cpu)
+{
+	return false;
+}
+
+/**
+ * queued_spin_unlock - release a queued spinlock
+ * @lock : Pointer to queued spinlock structure
+ */
+static void native_queued_spin_unlock(struct qspinlock *lock)
+{
+	/*
+	 * unlock() needs release semantics:
+	 */
+	smp_store_release(&lock->locked, 0);
+}
+
+static void paravirt_nop_kick(int cpu)
+{
+}
+
+static void paravirt_nop_wait(u8 *ptr, u8 val)
+{
+}
+
+static void kvm_wait(u8 *ptr, u8 val)
+{
+	if (READ_ONCE(*ptr) != val)
+		return;
+
+	__asm__ __volatile__("idle 0\n\t" : : : "memory");
+}
+
+/* Kick a cpu. Used to wake up a halted vcpu */
+static void kvm_kick_cpu(int cpu)
+{
+	kvm_hypercall1(KVM_HCALL_FUNC_KICK, cpu_logical_map(cpu));
+}
+
+bool pv_is_native_spin_unlock(void)
+{
+	return pv_lock_ops.queued_spin_unlock == native_queued_spin_unlock;
+}
+
+/*
+ * Setup pv_lock_ops for guest kernel.
+ */
+void __init kvm_spinlock_init(void)
+{
+	int feature;
+
+	/*
+	 * pv_hash()/pv_unhas() need it whatever pv spinlock is
+	 * enabled or not
+	 */
+	__pv_init_lock_hash();
+
+	if (!kvm_para_available())
+		return;
+
+	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
+	if (num_possible_cpus() == 1)
+		return;
+
+	feature = kvm_arch_para_features();
+	if (!(feature & KVM_FEATURE_PARAVIRT_SPINLOCK))
+		return;
+
+	if (nopvspin)
+		return;
+
+	pr_info("Using paravirt qspinlock\n");
+	pv_lock_ops.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
+	pv_lock_ops.queued_spin_unlock = __pv_queued_spin_unlock;
+	pv_lock_ops.wait = kvm_wait;
+	pv_lock_ops.kick = kvm_kick_cpu;
+}
+
+struct pv_lock_ops pv_lock_ops = {
+	.queued_spin_lock_slowpath = native_queued_spin_lock_slowpath,
+	.queued_spin_unlock = native_queued_spin_unlock,
+	.wait = paravirt_nop_wait,
+	.kick = paravirt_nop_kick,
+	.vcpu_is_preempted = native_vcpu_is_preempted,
+};
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index 1436d2465939..6bc0b182a2ce 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -463,7 +463,7 @@ core_initcall(ipi_pm_init);
 #endif
 
 /* Preload SMP state for boot cpu */
-void smp_prepare_boot_cpu(void)
+void __init smp_prepare_boot_cpu(void)
 {
 	unsigned int cpu, node, rr_node;
 
@@ -496,6 +496,8 @@ void smp_prepare_boot_cpu(void)
 			rr_node = next_node_in(rr_node, node_online_map);
 		}
 	}
+
+	kvm_spinlock_init();
 }
 
 /* called from main before smp_init() */
-- 
2.39.3


