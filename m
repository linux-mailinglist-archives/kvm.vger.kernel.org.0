Return-Path: <kvm+bounces-66105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F0ECC5EDD
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 04:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D446730221A6
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 03:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405FE2D6401;
	Wed, 17 Dec 2025 03:49:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1731EDA2C;
	Wed, 17 Dec 2025 03:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765943384; cv=none; b=X6QiKV37YacrnFDrX9Koff5vsMVa9rn9oLfB34ZmvqnSlHvUmlOC/DGErTLC4xLGXWQMlDQFpMQM/xjX5lD1FeTQ1oar6XmgJXovi+oqu6FNY1LXgLQxL7kUQoUqcL6wOLx2w0GE8V7vBgi/CdFh0xeH16iPTnBYxXuSoWyT5w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765943384; c=relaxed/simple;
	bh=Wv0vfXgbERAhOsD6r93ZE1zOzlSN/9LFQMTNh54kg70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GMi7kHBUJJkdESPiSDvtt3KPDkN2RA/BX9t83toVpVRNUeeoYksykiypMuEpWLCwtxKMsHg8hLvU4UOOst5rdzlrRh+KIf7554UfGkGdOelgzJFaRunuVGE/NeRm1ivhW8PIqs+F2SMlhCtyixKESFs+zy+JER2znehg/a+TZEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxcfBKKEJpygAAAA--.49S3;
	Wed, 17 Dec 2025 11:49:30 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCxPMJFKEJpksAAAA--.913S3;
	Wed, 17 Dec 2025 11:49:27 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	lixianglai@loongson.cn
Cc: stable@vger.kernel.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] LoongArch: KVM: Compile the switch.S file directly into the kernel
Date: Wed, 17 Dec 2025 11:24:49 +0800
Message-Id: <20251217032450.954344-2-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251217032450.954344-1-lixianglai@loongson.cn>
References: <20251217032450.954344-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxPMJFKEJpksAAAA--.913S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

If we directly compile the switch.S file into the kernel, the address of
the kvm_exc_entry function will definitely be within the DMW memory area.
Therefore, we will no longer need to perform a copy relocation of
kvm_exc_entry.

Based on the above description, compile switch.S directly into the kernel,
and then remove the copy relocation execution logic for the kvm_exc_entry
function.

Cc: stable@vger.kernel.org
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Xianglai Li <lixianglai@loongson.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>

 arch/loongarch/Kbuild                       |  2 +-
 arch/loongarch/include/asm/asm-prototypes.h | 16 ++++++++++
 arch/loongarch/include/asm/kvm_host.h       |  5 +--
 arch/loongarch/include/asm/kvm_vcpu.h       | 20 ++++++------
 arch/loongarch/kvm/Makefile                 |  2 +-
 arch/loongarch/kvm/main.c                   | 35 ++-------------------
 arch/loongarch/kvm/switch.S                 | 22 ++++++++++---
 7 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
index beb8499dd8ed..1c7a0dbe5e72 100644
--- a/arch/loongarch/Kbuild
+++ b/arch/loongarch/Kbuild
@@ -3,7 +3,7 @@ obj-y += mm/
 obj-y += net/
 obj-y += vdso/
 
-obj-$(CONFIG_KVM) += kvm/
+obj-$(subst m,y,$(CONFIG_KVM)) += kvm/
 
 # for cleaning
 subdir- += boot
diff --git a/arch/loongarch/include/asm/asm-prototypes.h b/arch/loongarch/include/asm/asm-prototypes.h
index 704066b4f736..eb591276d191 100644
--- a/arch/loongarch/include/asm/asm-prototypes.h
+++ b/arch/loongarch/include/asm/asm-prototypes.h
@@ -20,3 +20,19 @@ asmlinkage void noinstr __no_stack_protector ret_from_kernel_thread(struct task_
 								    struct pt_regs *regs,
 								    int (*fn)(void *),
 								    void *fn_arg);
+
+void kvm_exc_entry(void);
+int  kvm_enter_guest(void *run, void *vcpu);
+
+#ifdef CONFIG_CPU_HAS_LSX
+void kvm_save_lsx(void *fpu);
+void kvm_restore_lsx(void *fpu);
+#endif
+
+#ifdef CONFIG_CPU_HAS_LASX
+void kvm_save_lasx(void *fpu);
+void kvm_restore_lasx(void *fpu);
+#endif
+
+void kvm_save_fpu(void *fpu);
+void kvm_restore_fpu(void *fpu);
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index e4fe5b8e8149..0aa7679536cc 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -85,7 +85,6 @@ struct kvm_context {
 struct kvm_world_switch {
 	int (*exc_entry)(void);
 	int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
-	unsigned long page_order;
 };
 
 #define MAX_PGTABLE_LEVELS	4
@@ -344,11 +343,9 @@ enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer);
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm, const struct kvm_memory_slot *memslot);
 void kvm_init_vmcs(struct kvm *kvm);
 void kvm_exc_entry(void);
-int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
+int  kvm_enter_guest(void *run, void *vcpu);
 
 extern unsigned long vpid_mask;
-extern const unsigned long kvm_exception_size;
-extern const unsigned long kvm_enter_guest_size;
 extern struct kvm_world_switch *kvm_loongarch_ops;
 
 #define SW_GCSR		(1 << 0)
diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index 3784ab4ccdb5..8af98a3d7b0c 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -53,28 +53,28 @@ void kvm_deliver_exception(struct kvm_vcpu *vcpu);
 
 void kvm_own_fpu(struct kvm_vcpu *vcpu);
 void kvm_lose_fpu(struct kvm_vcpu *vcpu);
-void kvm_save_fpu(struct loongarch_fpu *fpu);
-void kvm_restore_fpu(struct loongarch_fpu *fpu);
+void kvm_save_fpu(void *fpu);
+void kvm_restore_fpu(void *fpu);
 void kvm_restore_fcsr(struct loongarch_fpu *fpu);
 
 #ifdef CONFIG_CPU_HAS_LSX
 int kvm_own_lsx(struct kvm_vcpu *vcpu);
-void kvm_save_lsx(struct loongarch_fpu *fpu);
-void kvm_restore_lsx(struct loongarch_fpu *fpu);
+void kvm_save_lsx(void *fpu);
+void kvm_restore_lsx(void *fpu);
 #else
 static inline int kvm_own_lsx(struct kvm_vcpu *vcpu) { return -EINVAL; }
-static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
-static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
+static inline void kvm_save_lsx(void *fpu) { }
+static inline void kvm_restore_lsx(void *fpu) { }
 #endif
 
 #ifdef CONFIG_CPU_HAS_LASX
 int kvm_own_lasx(struct kvm_vcpu *vcpu);
-void kvm_save_lasx(struct loongarch_fpu *fpu);
-void kvm_restore_lasx(struct loongarch_fpu *fpu);
+void kvm_save_lasx(void *fpu);
+void kvm_restore_lasx(void *fpu);
 #else
 static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { return -EINVAL; }
-static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
-static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
+static inline void kvm_save_lasx(void *fpu) { }
+static inline void kvm_restore_lasx(void *fpu) { }
 #endif
 
 #ifdef CONFIG_CPU_HAS_LBT
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index cb41d9265662..fe665054f824 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -11,7 +11,7 @@ kvm-y += exit.o
 kvm-y += interrupt.o
 kvm-y += main.o
 kvm-y += mmu.o
-kvm-y += switch.o
+obj-y += switch.o
 kvm-y += timer.o
 kvm-y += tlb.o
 kvm-y += vcpu.o
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 80ea63d465b8..67d234540ed4 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -340,8 +340,7 @@ void kvm_arch_disable_virtualization_cpu(void)
 
 static int kvm_loongarch_env_init(void)
 {
-	int cpu, order, ret;
-	void *addr;
+	int cpu, ret;
 	struct kvm_context *context;
 
 	vmcs = alloc_percpu(struct kvm_context);
@@ -357,30 +356,8 @@ static int kvm_loongarch_env_init(void)
 		return -ENOMEM;
 	}
 
-	/*
-	 * PGD register is shared between root kernel and kvm hypervisor.
-	 * So world switch entry should be in DMW area rather than TLB area
-	 * to avoid page fault reenter.
-	 *
-	 * In future if hardware pagetable walking is supported, we won't
-	 * need to copy world switch code to DMW area.
-	 */
-	order = get_order(kvm_exception_size + kvm_enter_guest_size);
-	addr = (void *)__get_free_pages(GFP_KERNEL, order);
-	if (!addr) {
-		free_percpu(vmcs);
-		vmcs = NULL;
-		kfree(kvm_loongarch_ops);
-		kvm_loongarch_ops = NULL;
-		return -ENOMEM;
-	}
-
-	memcpy(addr, kvm_exc_entry, kvm_exception_size);
-	memcpy(addr + kvm_exception_size, kvm_enter_guest, kvm_enter_guest_size);
-	flush_icache_range((unsigned long)addr, (unsigned long)addr + kvm_exception_size + kvm_enter_guest_size);
-	kvm_loongarch_ops->exc_entry = addr;
-	kvm_loongarch_ops->enter_guest = addr + kvm_exception_size;
-	kvm_loongarch_ops->page_order = order;
+	kvm_loongarch_ops->exc_entry = (void *)kvm_exc_entry;
+	kvm_loongarch_ops->enter_guest = (void *)kvm_enter_guest;
 
 	vpid_mask = read_csr_gstat();
 	vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
@@ -414,16 +391,10 @@ static int kvm_loongarch_env_init(void)
 
 static void kvm_loongarch_env_exit(void)
 {
-	unsigned long addr;
-
 	if (vmcs)
 		free_percpu(vmcs);
 
 	if (kvm_loongarch_ops) {
-		if (kvm_loongarch_ops->exc_entry) {
-			addr = (unsigned long)kvm_loongarch_ops->exc_entry;
-			free_pages(addr, kvm_loongarch_ops->page_order);
-		}
 		kfree(kvm_loongarch_ops);
 	}
 
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index f1768b7a6194..93845ce53651 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -5,6 +5,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm.h>
+#include <asm/page.h>
 #include <asm/asmmacro.h>
 #include <asm/loongarch.h>
 #include <asm/regdef.h>
@@ -100,10 +101,18 @@
 	 *  -        is still in guest mode, such as pgd table/vmid registers etc,
 	 *  -        will fix with hw page walk enabled in future
 	 * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KVM_TEMP_KS
+	 *
+	 * PGD register is shared between root kernel and kvm hypervisor.
+	 * So world switch entry should be in DMW area rather than TLB area
+	 * to avoid page fault reenter.
+	 *
+	 * In future if hardware pagetable walking is supported, we won't
+	 * need to copy world switch code to DMW area.
 	 */
 	.text
 	.cfi_sections	.debug_frame
 SYM_CODE_START(kvm_exc_entry)
+	.p2align PAGE_SHIFT
 	UNWIND_HINT_UNDEFINED
 	csrwr	a2,   KVM_TEMP_KS
 	csrrd	a2,   KVM_VCPU_KS
@@ -190,8 +199,8 @@ ret_to_host:
 	kvm_restore_host_gpr    a2
 	jr      ra
 
-SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
 SYM_CODE_END(kvm_exc_entry)
+EXPORT_SYMBOL(kvm_exc_entry)
 
 /*
  * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
@@ -215,8 +224,8 @@ SYM_FUNC_START(kvm_enter_guest)
 	/* Save kvm_vcpu to kscratch */
 	csrwr	a1, KVM_VCPU_KS
 	kvm_switch_to_guest
-SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
 SYM_FUNC_END(kvm_enter_guest)
+EXPORT_SYMBOL(kvm_enter_guest)
 
 SYM_FUNC_START(kvm_save_fpu)
 	fpu_save_csr	a0 t1
@@ -224,6 +233,7 @@ SYM_FUNC_START(kvm_save_fpu)
 	fpu_save_cc	a0 t1 t2
 	jr              ra
 SYM_FUNC_END(kvm_save_fpu)
+EXPORT_SYMBOL(kvm_save_fpu)
 
 SYM_FUNC_START(kvm_restore_fpu)
 	fpu_restore_double a0 t1
@@ -231,6 +241,7 @@ SYM_FUNC_START(kvm_restore_fpu)
 	fpu_restore_cc	   a0 t1 t2
 	jr                 ra
 SYM_FUNC_END(kvm_restore_fpu)
+EXPORT_SYMBOL(kvm_restore_fpu)
 
 #ifdef CONFIG_CPU_HAS_LSX
 SYM_FUNC_START(kvm_save_lsx)
@@ -239,6 +250,7 @@ SYM_FUNC_START(kvm_save_lsx)
 	lsx_save_data   a0 t1
 	jr              ra
 SYM_FUNC_END(kvm_save_lsx)
+EXPORT_SYMBOL(kvm_save_lsx)
 
 SYM_FUNC_START(kvm_restore_lsx)
 	lsx_restore_data a0 t1
@@ -246,6 +258,7 @@ SYM_FUNC_START(kvm_restore_lsx)
 	fpu_restore_csr  a0 t1 t2
 	jr               ra
 SYM_FUNC_END(kvm_restore_lsx)
+EXPORT_SYMBOL(kvm_restore_lsx)
 #endif
 
 #ifdef CONFIG_CPU_HAS_LASX
@@ -255,6 +268,7 @@ SYM_FUNC_START(kvm_save_lasx)
 	lasx_save_data  a0 t1
 	jr              ra
 SYM_FUNC_END(kvm_save_lasx)
+EXPORT_SYMBOL(kvm_save_lasx)
 
 SYM_FUNC_START(kvm_restore_lasx)
 	lasx_restore_data a0 t1
@@ -262,10 +276,8 @@ SYM_FUNC_START(kvm_restore_lasx)
 	fpu_restore_csr   a0 t1 t2
 	jr                ra
 SYM_FUNC_END(kvm_restore_lasx)
+EXPORT_SYMBOL(kvm_restore_lasx)
 #endif
-	.section ".rodata"
-SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
-SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
 
 #ifdef CONFIG_CPU_HAS_LBT
 STACK_FRAME_NON_STANDARD kvm_restore_fpu
-- 
2.39.1


