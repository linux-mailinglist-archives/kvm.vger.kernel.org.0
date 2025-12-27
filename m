Return-Path: <kvm+bounces-66715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87BE3CDF371
	for <lists+kvm@lfdr.de>; Sat, 27 Dec 2025 02:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 095D0301C916
	for <lists+kvm@lfdr.de>; Sat, 27 Dec 2025 01:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E87B1DA55;
	Sat, 27 Dec 2025 01:52:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1611DE89A;
	Sat, 27 Dec 2025 01:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766800330; cv=none; b=BinHP9Ecg6qTbCwY+XKJMasC/Kj55TZdptbruWOuyEpx57PSq0CFDVakRZM2xVFS/NqhRaa+plk0p7Kip26Qw6PnEybsQlX0Y8l8jxvNsT0xGx/JSEjcONUd2Znp7zYNL5/LZrQ/WuMm+EVujInNE8YNb4HM68P8FoiK0VFqAGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766800330; c=relaxed/simple;
	bh=zjxDUIblnnYEUf2Z44RpxLUlhrU0yPExQx4aVXDdwAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CGqrPf4o6j92bGWJbxIf8G/qgADO4QZ5gO6KuGoU1PllZWfv622ToxVHIT4Sj1H9I03Fcv3Y3LJrE3kjgMGTJcxFrfYH0sms8ZDx3MbOdGeZmizca59PKlnAQ1ETElyVCE6/FLNW4HMdX1aLaon7bgrv3ZG1sSal7Gznm7koZVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxLMPAO09pjooDAA--.10891S3;
	Sat, 27 Dec 2025 09:52:00 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJBxbcK6O09pu1oFAA--.12398S4;
	Sat, 27 Dec 2025 09:51:57 +0800 (CST)
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
	Thomas Gleixner <tglx@linutronix.de>,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
Date: Sat, 27 Dec 2025 09:27:12 +0800
Message-Id: <20251227012712.2921408-3-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251227012712.2921408-1-lixianglai@loongson.cn>
References: <20251227012712.2921408-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxbcK6O09pu1oFAA--.12398S4
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Insert the appropriate UNWIND macro definition into the kvm_exc_entry in
the assembly function to guide the generation of correct ORC table entries,
thereby solving the timeout problem of loading the livepatch-sample module
on a physical machine running multiple vcpus virtual machines.

While solving the above problems, we have gained an additional benefit,
that is, we can obtain more call stack information

Stack information that can be obtained before the problem is fixed:
[<0>] kvm_vcpu_block+0x88/0x120 [kvm]
[<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
[<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
[<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
[<0>] kvm_handle_exit+0x160/0x270 [kvm]
[<0>] kvm_exc_entry+0x100/0x1e0

Stack information that can be obtained after the problem is fixed:
[<0>] kvm_vcpu_block+0x88/0x120 [kvm]
[<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
[<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
[<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
[<0>] kvm_handle_exit+0x160/0x270 [kvm]
[<0>] kvm_exc_entry+0x104/0x1e4
[<0>] kvm_enter_guest+0x38/0x11c
[<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
[<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
[<0>] sys_ioctl+0x498/0xf00
[<0>] do_syscall+0x98/0x1d0
[<0>] handle_syscall+0xb8/0x158

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
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>

 arch/loongarch/kvm/switch.S | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 93845ce53651..a3ea9567dbe5 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -10,6 +10,7 @@
 #include <asm/loongarch.h>
 #include <asm/regdef.h>
 #include <asm/unwind_hints.h>
+#include <linux/kvm_types.h>
 
 #define HGPR_OFFSET(x)		(PT_R0 + 8*x)
 #define GGPR_OFFSET(x)		(KVM_ARCH_GGPR + 8*x)
@@ -110,9 +111,9 @@
 	 * need to copy world switch code to DMW area.
 	 */
 	.text
+	.p2align PAGE_SHIFT
 	.cfi_sections	.debug_frame
 SYM_CODE_START(kvm_exc_entry)
-	.p2align PAGE_SHIFT
 	UNWIND_HINT_UNDEFINED
 	csrwr	a2,   KVM_TEMP_KS
 	csrrd	a2,   KVM_VCPU_KS
@@ -170,6 +171,7 @@ SYM_CODE_START(kvm_exc_entry)
 	/* restore per cpu register */
 	ld.d	u0, a2, KVM_ARCH_HPERCPU
 	addi.d	sp, sp, -PT_SIZE
+	UNWIND_HINT_REGS
 
 	/* Prepare handle exception */
 	or	a0, s0, zero
@@ -200,7 +202,7 @@ ret_to_host:
 	jr      ra
 
 SYM_CODE_END(kvm_exc_entry)
-EXPORT_SYMBOL(kvm_exc_entry)
+EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
 
 /*
  * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
@@ -215,6 +217,14 @@ SYM_FUNC_START(kvm_enter_guest)
 	/* Save host GPRs */
 	kvm_save_host_gpr a2
 
+	/*
+	 * The csr_era member variable of the pt_regs structure is required
+	 * for unwinding orc to perform stack traceback, so we need to put
+	 * pc into csr_era member variable here.
+	 */
+	pcaddi	t0, 0
+	st.d	t0, a2, PT_ERA
+
 	addi.d	a2, a1, KVM_VCPU_ARCH
 	st.d	sp, a2, KVM_ARCH_HSP
 	st.d	tp, a2, KVM_ARCH_HTP
@@ -225,7 +235,7 @@ SYM_FUNC_START(kvm_enter_guest)
 	csrwr	a1, KVM_VCPU_KS
 	kvm_switch_to_guest
 SYM_FUNC_END(kvm_enter_guest)
-EXPORT_SYMBOL(kvm_enter_guest)
+EXPORT_SYMBOL_FOR_KVM(kvm_enter_guest)
 
 SYM_FUNC_START(kvm_save_fpu)
 	fpu_save_csr	a0 t1
@@ -233,7 +243,7 @@ SYM_FUNC_START(kvm_save_fpu)
 	fpu_save_cc	a0 t1 t2
 	jr              ra
 SYM_FUNC_END(kvm_save_fpu)
-EXPORT_SYMBOL(kvm_save_fpu)
+EXPORT_SYMBOL_FOR_KVM(kvm_save_fpu)
 
 SYM_FUNC_START(kvm_restore_fpu)
 	fpu_restore_double a0 t1
@@ -241,7 +251,7 @@ SYM_FUNC_START(kvm_restore_fpu)
 	fpu_restore_cc	   a0 t1 t2
 	jr                 ra
 SYM_FUNC_END(kvm_restore_fpu)
-EXPORT_SYMBOL(kvm_restore_fpu)
+EXPORT_SYMBOL_FOR_KVM(kvm_restore_fpu)
 
 #ifdef CONFIG_CPU_HAS_LSX
 SYM_FUNC_START(kvm_save_lsx)
@@ -250,7 +260,7 @@ SYM_FUNC_START(kvm_save_lsx)
 	lsx_save_data   a0 t1
 	jr              ra
 SYM_FUNC_END(kvm_save_lsx)
-EXPORT_SYMBOL(kvm_save_lsx)
+EXPORT_SYMBOL_FOR_KVM(kvm_save_lsx)
 
 SYM_FUNC_START(kvm_restore_lsx)
 	lsx_restore_data a0 t1
@@ -258,7 +268,7 @@ SYM_FUNC_START(kvm_restore_lsx)
 	fpu_restore_csr  a0 t1 t2
 	jr               ra
 SYM_FUNC_END(kvm_restore_lsx)
-EXPORT_SYMBOL(kvm_restore_lsx)
+EXPORT_SYMBOL_FOR_KVM(kvm_restore_lsx)
 #endif
 
 #ifdef CONFIG_CPU_HAS_LASX
@@ -268,7 +278,7 @@ SYM_FUNC_START(kvm_save_lasx)
 	lasx_save_data  a0 t1
 	jr              ra
 SYM_FUNC_END(kvm_save_lasx)
-EXPORT_SYMBOL(kvm_save_lasx)
+EXPORT_SYMBOL_FOR_KVM(kvm_save_lasx)
 
 SYM_FUNC_START(kvm_restore_lasx)
 	lasx_restore_data a0 t1
@@ -276,7 +286,7 @@ SYM_FUNC_START(kvm_restore_lasx)
 	fpu_restore_csr   a0 t1 t2
 	jr                ra
 SYM_FUNC_END(kvm_restore_lasx)
-EXPORT_SYMBOL(kvm_restore_lasx)
+EXPORT_SYMBOL_FOR_KVM(kvm_restore_lasx)
 #endif
 
 #ifdef CONFIG_CPU_HAS_LBT
-- 
2.39.1


