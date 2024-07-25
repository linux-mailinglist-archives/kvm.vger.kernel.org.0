Return-Path: <kvm+bounces-22210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DAF593BB44
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 05:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B88B11F22E9B
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 03:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FD7208A7;
	Thu, 25 Jul 2024 03:34:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED401C6BE;
	Thu, 25 Jul 2024 03:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721878459; cv=none; b=A4CZaqaM5ylJgibqj+9aB4PQkksoPiaPsRCtHxbcFrX/hoXvG1pQZBBtPAhd2eu7ZpX3I26qzu9kBbJjHEcsyoEq6NqZSogCsrRKHCZmz74+khqryAviRTgQXLmE+jt9yR8eqE043faDcUcisoYBC/gTITkG0SxSPH17fCWd5+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721878459; c=relaxed/simple;
	bh=M1SKQnhoZeocK0mNtkxjcLoo2dwNGAPwoDPauhxc2AQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NnWRQLz1sR6ww2Y0rgb58n839mCWgL//y36ZXSoSeWD8FNF09Q0xkMNsMMxOOHUyijmK7vWenRqo8PdmqD7eS02w28xSLVQ4bUpLIvS0Bt/tygDhMGl9rncxWHTzxPbM9hhuQS+rSndzmw7fa6JWcr8fhzhLIVG5h0ncacLUV6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.10.34])
	by gateway (Coremail) with SMTP id _____8Dxi+qxx6Fm6VUBAA--.5251S3;
	Thu, 25 Jul 2024 11:34:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.10.34])
	by front1 (Coremail) with SMTP id qMiowMBxicWsx6FmppEAAA--.37S3;
	Thu, 25 Jul 2024 11:34:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v5 1/3] LoongArch: KVM: Add HW Binary Translation extension support
Date: Thu, 25 Jul 2024 11:34:02 +0800
Message-Id: <20240725033404.2675204-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240725033404.2675204-1-maobibo@loongson.cn>
References: <20240725033404.2675204-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxicWsx6FmppEAAA--.37S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKrW3KF4UGFW5Ww4rWw4rZwc_yoWxWw4fpF
	97urn5Zw4rWFyxKasrtrn09rs0v3ykKry7Xry2g3y5JF1Utry5JF4kKrWqvFy5Jw4FvF1S
	vF93K3W5AFW8J3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
	WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWU
	XVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x07jYPfQUUUUU=

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
 arch/loongarch/kvm/vcpu.c             | 64 ++++++++++++++++++++++++++-
 4 files changed, 86 insertions(+), 1 deletion(-)

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
index 16756ffb55e8..9c5d2d286607 100644
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
@@ -977,12 +978,69 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
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
+static void kvm_enable_lbt_fpu(struct kvm_vcpu *vcpu, unsigned long fcsr)
+{
+	/*
+	 * if TM is enabled, top register save/restore will
+	 * cause lbt exception, here enable lbt in advance
+	 */
+	if (fcsr & FPU_CSR_TM)
+		kvm_own_lbt(vcpu);
+}
+
+static void kvm_check_fcsr(struct kvm_vcpu *vcpu)
+{
+	unsigned long fcsr;
+
+	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU)
+		if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
+			fcsr = read_fcsr(LOONGARCH_FCSR0);
+			kvm_enable_lbt_fpu(vcpu, fcsr);
+		}
+}
+#else
+static inline void kvm_lose_lbt(struct kvm_vcpu *vcpu) { }
+static inline void kvm_enable_lbt_fpu(struct kvm_vcpu *vcpu,
+				unsigned long fcsr) { }
+static inline void kvm_check_fcsr(struct kvm_vcpu *vcpu) { }
+#endif
+
 /* Enable FPU and restore context */
 void kvm_own_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
-	/* Enable FPU */
+	/*
+	 * Enable FPU for guest
+	 * We set FR and FRE according to guest context
+	 */
+	kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN);
 
 	kvm_restore_fpu(&vcpu->arch.fpu);
@@ -1002,6 +1060,7 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 	preempt_disable();
 
 	/* Enable LSX for guest */
+	kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
 	switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
 	case KVM_LARCH_FPU:
@@ -1036,6 +1095,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
 	switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
 	case KVM_LARCH_LSX:
@@ -1067,6 +1127,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
+	kvm_check_fcsr(vcpu);
 	if (vcpu->arch.aux_inuse & KVM_LARCH_LASX) {
 		kvm_save_lasx(&vcpu->arch.fpu);
 		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU | KVM_LARCH_LASX);
@@ -1089,6 +1150,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 		/* Disable FPU */
 		clear_csr_euen(CSR_EUEN_FPEN);
 	}
+	kvm_lose_lbt(vcpu);
 
 	preempt_enable();
 }
-- 
2.39.3


