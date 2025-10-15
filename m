Return-Path: <kvm+bounces-60066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E829CBDCBC1
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 08:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4248C3A7A0E
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 06:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1EA311960;
	Wed, 15 Oct 2025 06:30:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B90305976;
	Wed, 15 Oct 2025 06:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760509824; cv=none; b=sL81StB0ZRc6l1pN4EFZ5f1MtCZJsCbkL4vtx4zfDnRcB1VMwametVuNKXCPpeBh90jNdt6dYsomYTAeqAWAPy15VJ4C+Vjt0unh8bB0EnENAPevGKusDSRFD6FxQkR+LdYw1u4PrbSCvN8b45QOfm3ktztN0aTkNmQ5Xex0uMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760509824; c=relaxed/simple;
	bh=ghyH7Mw21tZMDfsCR/q5qBCvDT8hj65ATGvsufe9qvg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y/jxS1+SKA7FqbP7IKMrZQKuyN4pGyW5bW64wQ5XPQixeYwVbsZhSYRO3VWgJ9zavQK1tBfvaf8Rrx2+/AoNZ/uXMuSA3Pj/KxRwMAV6zSBf63Hjcvx91bdTq3qVDkEfJ6XaZH7nW6AdrIzcYX2aG43R20H9eQfiT28dpCuye0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxF9F4P+9ohE4WAA--.47871S3;
	Wed, 15 Oct 2025 14:30:16 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJDxbMF3P+9ouf3kAA--.57346S2;
	Wed, 15 Oct 2025 14:30:15 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] LoongArch: KVM: Add AVEC support
Date: Wed, 15 Oct 2025 14:06:26 +0800
Message-Id: <20251015060626.3915824-1-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxbMF3P+9ouf3kAA--.57346S2
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add cpu_has_msgint() to check whether the host cpu supported avec,
and restore/save CSR_MSGIS0-CSR_MSGIS3.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  4 ++++
 arch/loongarch/include/asm/kvm_vcpu.h |  1 +
 arch/loongarch/include/uapi/asm/kvm.h |  1 +
 arch/loongarch/kvm/interrupt.c        | 15 +++++++++++++--
 arch/loongarch/kvm/vcpu.c             | 19 +++++++++++++++++--
 arch/loongarch/kvm/vm.c               |  4 ++++
 6 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 0cecbd038bb3..827e204bdeb3 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -283,6 +283,10 @@ static inline bool kvm_guest_has_lbt(struct kvm_vcpu_arch *arch)
 	return arch->cpucfg[2] & (CPUCFG2_X86BT | CPUCFG2_ARMBT | CPUCFG2_MIPSBT);
 }
 
+static inline bool cpu_has_msgint(void)
+{
+	return read_cpucfg(LOONGARCH_CPUCFG1) & CPUCFG1_MSGINT;
+}
 static inline bool kvm_guest_has_pmu(struct kvm_vcpu_arch *arch)
 {
 	return arch->cpucfg[6] & CPUCFG6_PMP;
diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index f1efd7cfbc20..3784ab4ccdb5 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -15,6 +15,7 @@
 #define CPU_PMU				(_ULCAST_(1) << 10)
 #define CPU_TIMER			(_ULCAST_(1) << 11)
 #define CPU_IPI				(_ULCAST_(1) << 12)
+#define CPU_AVEC                        (_ULCAST_(1) << 14)
 
 /* Controlled by 0x52 guest exception VIP aligned to estat bit 5~12 */
 #define CPU_IP0				(_ULCAST_(1))
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 57ba1a563bb1..de6c3f18e40a 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -104,6 +104,7 @@ struct kvm_fpu {
 #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
 #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
 #define  KVM_LOONGARCH_VM_FEAT_PTW		8
+#define  KVM_LOONGARCH_VM_FEAT_MSGINT		9
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
index 8462083f0301..f586f421bc19 100644
--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -21,6 +21,7 @@ static unsigned int priority_to_irq[EXCCODE_INT_NUM] = {
 	[INT_HWI5]	= CPU_IP5,
 	[INT_HWI6]	= CPU_IP6,
 	[INT_HWI7]	= CPU_IP7,
+	[INT_AVEC]	= CPU_AVEC,
 };
 
 static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
@@ -31,6 +32,11 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 	if (priority < EXCCODE_INT_NUM)
 		irq = priority_to_irq[priority];
 
+	if (cpu_has_msgint() && (priority == INT_AVEC)) {
+		set_gcsr_estat(irq);
+		return 1;
+	}
+
 	switch (priority) {
 	case INT_TI:
 	case INT_IPI:
@@ -58,6 +64,11 @@ static int kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
 	if (priority < EXCCODE_INT_NUM)
 		irq = priority_to_irq[priority];
 
+	if (cpu_has_msgint() && (priority == INT_AVEC)) {
+		clear_gcsr_estat(irq);
+		return 1;
+	}
+
 	switch (priority) {
 	case INT_TI:
 	case INT_IPI:
@@ -83,10 +94,10 @@ void kvm_deliver_intr(struct kvm_vcpu *vcpu)
 	unsigned long *pending = &vcpu->arch.irq_pending;
 	unsigned long *pending_clr = &vcpu->arch.irq_clear;
 
-	for_each_set_bit(priority, pending_clr, INT_IPI + 1)
+	for_each_set_bit(priority, pending_clr, EXCCODE_INT_NUM)
 		kvm_irq_clear(vcpu, priority);
 
-	for_each_set_bit(priority, pending, INT_IPI + 1)
+	for_each_set_bit(priority, pending, EXCCODE_INT_NUM)
 		kvm_irq_deliver(vcpu, priority);
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 30e3b089a596..226c735155be 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -657,8 +657,7 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 		*v = GENMASK(31, 0);
 		return 0;
 	case LOONGARCH_CPUCFG1:
-		/* CPUCFG1_MSGINT is not supported by KVM */
-		*v = GENMASK(25, 0);
+		*v = GENMASK(26, 0);
 		return 0;
 	case LOONGARCH_CPUCFG2:
 		/* CPUCFG2 features unconditionally supported by KVM */
@@ -726,6 +725,10 @@ static int kvm_check_cpucfg(int id, u64 val)
 		return -EINVAL;
 
 	switch (id) {
+	case LOONGARCH_CPUCFG1:
+		if ((val & CPUCFG1_MSGINT) && (!cpu_has_msgint()))
+			return -EINVAL;
+		return 0;
 	case LOONGARCH_CPUCFG2:
 		if (!(val & CPUCFG2_LLFTP))
 			/* Guests must have a constant timer */
@@ -1658,6 +1661,12 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
+	if (cpu_has_msgint()) {
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
+	}
 
 	/* Restore Root.GINTC from unused Guest.GINTC register */
 	write_csr_gintc(csr->csrs[LOONGARCH_CSR_GINTC]);
@@ -1747,6 +1756,12 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
+	if (cpu_has_msgint()) {
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
+	}
 
 	vcpu->arch.aux_inuse |= KVM_LARCH_SWCSR_LATEST;
 
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index a49b1c1a3dd1..ec92e6f3cf92 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -150,6 +150,10 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 		if (cpu_has_ptw)
 			return 0;
 		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_MSGINT:
+		if (cpu_has_msgint())
+			return 0;
+		return -ENXIO;
 	default:
 		return -ENXIO;
 	}

base-commit: 9b332cece987ee1790b2ed4c989e28162fa47860
-- 
2.39.3


