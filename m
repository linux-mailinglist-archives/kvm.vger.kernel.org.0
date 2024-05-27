Return-Path: <kvm+bounces-18170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D33C8CFA63
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7E9EB217C9
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 07:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA8844C9E;
	Mon, 27 May 2024 07:46:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58543224D6;
	Mon, 27 May 2024 07:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796015; cv=none; b=lM4LEQcBj1dq9JELlPbRfjn12hAtDefPEKBCEGw8+pcy3A2E67P+ioVaHXSjhL37Kysxn63iakRAkHHstufMPvvML6czG3P38cm/3WG30eoxf/xU1D8wRIcwQnsguGauQyXG3ckPh4SRr5I+xllaeWyxKE5huSXyodDMAoH91GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796015; c=relaxed/simple;
	bh=hnPXkXovhQtuBN4lgW8sVpDTOhYEjimUzHMOPsPomuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xn3QsMNET5kJI7gZa/XP1hzcIea1+U3PGqA6I0xKv9irEBN4Bn/yxKFHnKqpDdZpsHMEZYxe8HU5TSOzLlYboOw3wt2qvvU9qmedasyviuK0gX/1lLBqthsocpjanDqKIwqIPoe+0+3nIF2Tt0MfXwSI35hTotW3Z35dEH1vZ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxHutlOlRmsB4AAA--.396S3;
	Mon, 27 May 2024 15:46:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxTcdlOlRmHuIKAA--.28594S3;
	Mon, 27 May 2024 15:46:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] LoongArch: KVM: Add HW Binary Translation extension support
Date: Mon, 27 May 2024 15:46:41 +0800
Message-Id: <20240527074644.836699-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240527074644.836699-1-maobibo@loongson.cn>
References: <20240527074644.836699-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxTcdlOlRmHuIKAA--.28594S3
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
 arch/loongarch/include/asm/kvm_vcpu.h | 10 +++++
 arch/loongarch/kvm/exit.c             |  9 ++++
 arch/loongarch/kvm/vcpu.c             | 59 ++++++++++++++++++++++++++-
 4 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 2eb2f7572023..88023ab59486 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -133,6 +133,7 @@ enum emulation_result {
 #define KVM_LARCH_LASX		(0x1 << 2)
 #define KVM_LARCH_SWCSR_LATEST	(0x1 << 3)
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 4)
+#define KVM_LARCH_LBT		(0x1 << 5)
 
 struct kvm_vcpu_arch {
 	/*
@@ -166,6 +167,7 @@ struct kvm_vcpu_arch {
 
 	/* FPU state */
 	struct loongarch_fpu fpu FPU_ALIGN;
+	struct loongarch_lbt lbt;
 
 	/* CSR state */
 	struct loongarch_csrs *csr;
@@ -235,6 +237,12 @@ static inline bool kvm_guest_has_lasx(struct kvm_vcpu_arch *arch)
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
index d7e51300a89f..ec46009be29b 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -75,6 +75,16 @@ static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
 static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
 #endif
 
+#ifdef CONFIG_CPU_HAS_LBT
+int kvm_own_lbt(struct kvm_vcpu *vcpu);
+#else
+static inline int kvm_own_lbt(struct kvm_vcpu *vcpu) { return -EINVAL; }
+static inline void kvm_lose_lbt(struct kvm_vcpu *vcpu) { }
+static inline void kvm_enable_lbt_fpu(struct kvm_vcpu *vcpu,
+					unsigned long fcsr) { }
+static inline void kvm_check_fcsr(struct kvm_vcpu *vcpu) { }
+#endif
+
 void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
 void kvm_reset_timer(struct kvm_vcpu *vcpu);
 void kvm_save_timer(struct kvm_vcpu *vcpu);
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index e2abd97fb13f..e1bd81d27fd8 100644
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
index 382796f1d3e6..8f80d1a2dcbb 100644
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
@@ -952,12 +953,64 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
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
@@ -977,6 +1030,7 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 	preempt_disable();
 
 	/* Enable LSX for guest */
+	kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
 	switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
 	case KVM_LARCH_FPU:
@@ -1011,6 +1065,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
 	switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
 	case KVM_LARCH_LSX:
@@ -1042,6 +1097,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
+	kvm_check_fcsr(vcpu);
 	if (vcpu->arch.aux_inuse & KVM_LARCH_LASX) {
 		kvm_save_lasx(&vcpu->arch.fpu);
 		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU | KVM_LARCH_LASX);
@@ -1064,6 +1120,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 		/* Disable FPU */
 		clear_csr_euen(CSR_EUEN_FPEN);
 	}
+	kvm_lose_lbt(vcpu);
 
 	preempt_enable();
 }
-- 
2.39.3


