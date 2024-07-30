Return-Path: <kvm+bounces-22608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5770E940A7F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC0E5B20CB6
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A0E192B65;
	Tue, 30 Jul 2024 07:57:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A81A191F7B;
	Tue, 30 Jul 2024 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722326268; cv=none; b=GkpXZjKb7lkyLr7VAAA0LoKMXf6a/98QQAk4VY35QZPjLtZe8gZdT+GMA/ulJtiMq2+UjIjYPu0m6O2ojEH7IJILufOoAvCQNAXBcQZvENsPKREUYNwkDG72ODfA5QnkBgyY5w0acLvqaZ2DwM2Ll3kdBQyex/jQ3GMKndYry64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722326268; c=relaxed/simple;
	bh=9wMZqdqGzCugtv9QYM7E5DR7ZJHLVgka004bdRgej40=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mZXbPVYQA33H4CbFTXT1c96NGF4aS2dtTkhLxvRbaQSiDJVwbHF7TySlWUg1CekdCJlsk8qxv2G9Fkc6cO7SzzfhN2eYKLqm2esT0HX5sVUXvBNaKOI3beNGREfK8O6INCZfBCsg7LWO/IesqzOB2ULRStN1604uTVfp5qAFPV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx+en5nKhm91EEAA--.14911S3;
	Tue, 30 Jul 2024 15:57:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxX8f4nKhmrTUGAA--.30670S3;
	Tue, 30 Jul 2024 15:57:44 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v6 1/3] LoongArch: KVM: Add HW Binary Translation extension support
Date: Tue, 30 Jul 2024 15:57:41 +0800
Message-Id: <20240730075744.1215856-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240730075744.1215856-1-maobibo@loongson.cn>
References: <20240730075744.1215856-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxX8f4nKhmrTUGAA--.30670S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Loongson Binary Translation (LBT) is used to accelerate binary translation,
which contains 4 scratch registers (scr0 to scr3), x86/ARM eflags (eflags)
and x87 fpu stack pointer (ftop).

Like FPU extension, here late enabling method is used for LBT. LBT context
is saved/restored on vcpu context switch path.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  8 ++++
 arch/loongarch/include/asm/kvm_vcpu.h |  6 +++
 arch/loongarch/kvm/exit.c             |  9 ++++
 arch/loongarch/kvm/vcpu.c             | 66 ++++++++++++++++++++++++++-
 4 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 44b54965f5b4..c409ab15bae1 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -137,6 +137,7 @@ enum emulation_result {
 #define KVM_LARCH_LASX		(0x1 << 2)
 #define KVM_LARCH_SWCSR_LATEST	(0x1 << 3)
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 4)
+#define KVM_LARCH_LBT		(0x1 << 5)
 
 struct kvm_vcpu_arch {
 	/*
@@ -170,6 +171,7 @@ struct kvm_vcpu_arch {
 
 	/* FPU state */
 	struct loongarch_fpu fpu FPU_ALIGN;
+	struct loongarch_lbt lbt;
 
 	/* CSR state */
 	struct loongarch_csrs *csr;
@@ -241,6 +243,12 @@ static inline bool kvm_guest_has_lasx(struct kvm_vcpu_arch *arch)
 	return arch->cpucfg[2] & CPUCFG2_LASX;
 }
 
+static inline bool kvm_guest_has_lbt(struct kvm_vcpu_arch *arch)
+{
+	return arch->cpucfg[2] & (CPUCFG2_X86BT | CPUCFG2_ARMBT
+					| CPUCFG2_MIPSBT);
+}
+
 /* Debug: dump vcpu state */
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index c416cb7125c0..3cc906a0ff54 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -75,6 +75,12 @@ static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
 static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
 #endif
 
+#ifdef CONFIG_CPU_HAS_LBT
+int kvm_own_lbt(struct kvm_vcpu *vcpu);
+#else
+static inline int kvm_own_lbt(struct kvm_vcpu *vcpu) { return -EINVAL; }
+#endif
+
 void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
 void kvm_reset_timer(struct kvm_vcpu *vcpu);
 void kvm_save_timer(struct kvm_vcpu *vcpu);
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea73f9dc2cc6..be2c326253a3 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -835,6 +835,14 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu)
+{
+	if (kvm_own_lbt(vcpu))
+		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+
+	return RESUME_GUEST;
+}
+
 /*
  * LoongArch KVM callback handling for unimplemented guest exiting
  */
@@ -867,6 +875,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
 	[EXCCODE_LASXDIS]		= kvm_handle_lasx_disabled,
 	[EXCCODE_GSPR]			= kvm_handle_gspr,
 	[EXCCODE_HVC]			= kvm_handle_hypercall,
+	[EXCCODE_BTDIS]			= kvm_handle_lbt_disabled,
 };
 
 int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 16756ffb55e8..36db2b257a95 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 #include <linux/entry-kvm.h>
 #include <asm/fpu.h>
+#include <asm/lbt.h>
 #include <asm/loongarch.h>
 #include <asm/setup.h>
 #include <asm/time.h>
@@ -977,12 +978,71 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return 0;
 }
 
+#ifdef CONFIG_CPU_HAS_LBT
+int kvm_own_lbt(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_guest_has_lbt(&vcpu->arch))
+		return -EINVAL;
+
+	preempt_disable();
+	set_csr_euen(CSR_EUEN_LBTEN);
+
+	_restore_lbt(&vcpu->arch.lbt);
+	vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
+	preempt_enable();
+	return 0;
+}
+
+static void kvm_lose_lbt(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	if (vcpu->arch.aux_inuse & KVM_LARCH_LBT) {
+		_save_lbt(&vcpu->arch.lbt);
+		clear_csr_euen(CSR_EUEN_LBTEN);
+		vcpu->arch.aux_inuse &= ~KVM_LARCH_LBT;
+	}
+	preempt_enable();
+}
+
+static void kvm_check_fscr(struct kvm_vcpu *vcpu, unsigned long fcsr)
+{
+	/*
+	 * If TM is enabled, top register save/restore will
+	 * cause lbt exception, here enable lbt in advance
+	 */
+	if (fcsr & FPU_CSR_TM)
+		kvm_own_lbt(vcpu);
+}
+
+static void kvm_check_fcsr_alive(struct kvm_vcpu *vcpu)
+{
+	unsigned long fcsr;
+
+	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
+		if (vcpu->arch.aux_inuse & KVM_LARCH_LBT)
+			return;
+
+		fcsr = read_fcsr(LOONGARCH_FCSR0);
+		kvm_check_fscr(vcpu, fcsr);
+	}
+}
+#else
+static inline void kvm_lose_lbt(struct kvm_vcpu *vcpu) { }
+static inline void kvm_check_fscr(struct kvm_vcpu *vcpu,
+				unsigned long fcsr) { }
+static inline void kvm_check_fcsr_alive(struct kvm_vcpu *vcpu) { }
+#endif
+
 /* Enable FPU and restore context */
 void kvm_own_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
-	/* Enable FPU */
+	/*
+	 * Enable FPU for guest
+	 * Set FR and FRE according to guest context
+	 */
+	kvm_check_fscr(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN);
 
 	kvm_restore_fpu(&vcpu->arch.fpu);
@@ -1002,6 +1062,7 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 	preempt_disable();
 
 	/* Enable LSX for guest */
+	kvm_check_fscr(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
 	switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
 	case KVM_LARCH_FPU:
@@ -1036,6 +1097,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	kvm_check_fscr(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
 	switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
 	case KVM_LARCH_LSX:
@@ -1067,6 +1129,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
+	kvm_check_fcsr_alive(vcpu);
 	if (vcpu->arch.aux_inuse & KVM_LARCH_LASX) {
 		kvm_save_lasx(&vcpu->arch.fpu);
 		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU | KVM_LARCH_LASX);
@@ -1089,6 +1152,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 		/* Disable FPU */
 		clear_csr_euen(CSR_EUEN_FPEN);
 	}
+	kvm_lose_lbt(vcpu);
 
 	preempt_enable();
 }
-- 
2.39.3


