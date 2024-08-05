Return-Path: <kvm+bounces-23186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A3E94763C
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 09:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17C31281E91
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 07:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2419E14AD0A;
	Mon,  5 Aug 2024 07:35:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8C6149E17;
	Mon,  5 Aug 2024 07:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722843351; cv=none; b=Dfh3T+PRJozFISaGmRylfVwarHdTK0RDYdaVxiZa933TyrKsc4oYVf1enBIAePPo1Exm7XxYtTIDfEr/wwz5k00qcvhtjOLo00kJQ69gr6+9W85CMvrxMF+CeluwCE8UgxxcQoLQ6RDY1ITWpC8S2n16cSXN4tE88kn7ks6l6xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722843351; c=relaxed/simple;
	bh=duHPbKeXcO+rwHzIMAVOTDldptG7l4vaAv3ce06AtTI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fW7tN3YwJWilu7TRTmKmjYNF97feAWzTQPmbUX9EGokq6jcEvmiePdJSp9BhfpPpWNk3SjKPOWQY2ebCAcbQ7Qli9qMq4140CsrUhuBVezoKWl+ulK5nl7cs92Su7rY3QpgJ7RpFvbbv6nI5xROsS4QlQf2b7X1GVXgVEKk2saA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxHuvTgLBmKeUHAA--.27260S3;
	Mon, 05 Aug 2024 15:35:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxz2fSgLBmaCgEAA--.11106S3;
	Mon, 05 Aug 2024 15:35:46 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org,
	Song Gao <gaosong@loongson.cn>
Subject: [PATCH v5 1/3] LoongArch: KVM: Enable paravirt feature control from VMM
Date: Mon,  5 Aug 2024 15:35:44 +0800
Message-Id: <20240805073546.668475-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240805073546.668475-1-maobibo@loongson.cn>
References: <20240805073546.668475-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxz2fSgLBmaCgEAA--.11106S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Export kernel paravirt features to user space, so that VMM can control
the single paravirt feature. By default paravirt features will the same
with kvm supported features if VMM does not set it.

Also a new feature KVM_FEATURE_VIRT_EXTIOI is added which can be set from
user space. This feature indicates that the virt EXTIOI can route
interrupts to 256 vCPUs, rather than 4 vCPUs like with real HW.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h      |  7 ++++
 arch/loongarch/include/asm/kvm_para.h      |  1 +
 arch/loongarch/include/asm/loongarch.h     | 13 -------
 arch/loongarch/include/uapi/asm/Kbuild     |  2 -
 arch/loongarch/include/uapi/asm/kvm.h      |  5 +++
 arch/loongarch/include/uapi/asm/kvm_para.h | 24 ++++++++++++
 arch/loongarch/kernel/paravirt.c           |  8 ++--
 arch/loongarch/kvm/exit.c                  |  6 +--
 arch/loongarch/kvm/vcpu.c                  | 41 +++++++++++++++++++--
 arch/loongarch/kvm/vm.c                    | 43 +++++++++++++++++++++-
 10 files changed, 122 insertions(+), 28 deletions(-)
 create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 44b54965f5b4..d5068431afcc 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -109,6 +109,8 @@ struct kvm_arch {
 	unsigned int  root_level;
 	spinlock_t    phyid_map_lock;
 	struct kvm_phyid_map  *phyid_map;
+	/* Enabled PV features */
+	unsigned long pv_features;
 
 	s64 time_offset;
 	struct kvm_context __percpu *vmcs;
@@ -138,6 +140,11 @@ enum emulation_result {
 #define KVM_LARCH_SWCSR_LATEST	(0x1 << 3)
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 4)
 
+#define LOONGARCH_PV_FEAT_UPDATED		BIT_ULL(63)
+#define LOONGARCH_PV_FEAT_MASK						\
+		(BIT(KVM_FEATURE_IPI) | BIT(KVM_FEATURE_STEAL_TIME) |	\
+		 BIT(KVM_FEATURE_VIRT_EXTIOI))
+
 struct kvm_vcpu_arch {
 	/*
 	 * Switch pointer-to-function type to unsigned long
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 335fb86778e2..9814d56b8d0e 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_LOONGARCH_KVM_PARA_H
 #define _ASM_LOONGARCH_KVM_PARA_H
 
+#include <uapi/asm/kvm_para.h>
 /*
  * Hypercall code field
  */
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 04a78010fc72..eb82230f52c3 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -158,19 +158,6 @@
 #define  CPUCFG48_VFPU_CG		BIT(2)
 #define  CPUCFG48_RAM_CG		BIT(3)
 
-/*
- * CPUCFG index area: 0x40000000 -- 0x400000ff
- * SW emulation for KVM hypervirsor
- */
-#define CPUCFG_KVM_BASE			0x40000000
-#define CPUCFG_KVM_SIZE			0x100
-
-#define CPUCFG_KVM_SIG			(CPUCFG_KVM_BASE + 0)
-#define  KVM_SIGNATURE			"KVM\0"
-#define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
-#define  KVM_FEATURE_IPI		BIT(1)
-#define  KVM_FEATURE_STEAL_TIME		BIT(2)
-
 #ifndef __ASSEMBLY__
 
 /* CSR */
diff --git a/arch/loongarch/include/uapi/asm/Kbuild b/arch/loongarch/include/uapi/asm/Kbuild
index c6d141d7b7d7..517761419999 100644
--- a/arch/loongarch/include/uapi/asm/Kbuild
+++ b/arch/loongarch/include/uapi/asm/Kbuild
@@ -1,4 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0
 syscall-y += unistd_64.h
-
-generic-y += kvm_para.h
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ddc5cab0ffd0..719490e64e1c 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -82,6 +82,11 @@ struct kvm_fpu {
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
 #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
 
+/* Device Control API on vm fd */
+#define KVM_LOONGARCH_VM_FEAT_CTRL		0
+#define  KVM_LOONGARCH_VM_FEAT_PV_IPI		5
+#define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	6
+
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
 #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
new file mode 100644
index 000000000000..5dfe675709ab
--- /dev/null
+++ b/arch/loongarch/include/uapi/asm/kvm_para.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_KVM_PARA_H
+#define _UAPI_ASM_KVM_PARA_H
+
+#include <linux/types.h>
+
+/*
+ * CPUCFG index area: 0x40000000 -- 0x400000ff
+ * SW emulation for KVM hypervirsor
+ */
+#define CPUCFG_KVM_BASE			0x40000000
+#define CPUCFG_KVM_SIZE			0x100
+#define CPUCFG_KVM_SIG			(CPUCFG_KVM_BASE + 0)
+#define  KVM_SIGNATURE			"KVM\0"
+#define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
+#define  KVM_FEATURE_IPI		1
+#define  KVM_FEATURE_STEAL_TIME		2
+/*
+ * BIT 24 - 31 is features configurable by user space vmm
+ * With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs
+ */
+#define  KVM_FEATURE_VIRT_EXTIOI	24
+
+#endif /* _UAPI_ASM_KVM_PARA_H */
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index 9c9b75b76f62..cc6bf096cb88 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -175,7 +175,7 @@ int __init pv_ipi_init(void)
 		return 0;
 
 	feature = read_cpucfg(CPUCFG_KVM_FEATURE);
-	if (!(feature & KVM_FEATURE_IPI))
+	if (!(feature & BIT(KVM_FEATURE_IPI)))
 		return 0;
 
 #ifdef CONFIG_SMP
@@ -206,7 +206,7 @@ static int pv_enable_steal_time(void)
 	}
 
 	addr |= KVM_STEAL_PHYS_VALID;
-	kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, addr);
+	kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, BIT(KVM_FEATURE_STEAL_TIME), addr);
 
 	return 0;
 }
@@ -214,7 +214,7 @@ static int pv_enable_steal_time(void)
 static void pv_disable_steal_time(void)
 {
 	if (has_steal_clock)
-		kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, 0);
+		kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, BIT(KVM_FEATURE_STEAL_TIME), 0);
 }
 
 #ifdef CONFIG_SMP
@@ -266,7 +266,7 @@ int __init pv_time_init(void)
 		return 0;
 
 	feature = read_cpucfg(CPUCFG_KVM_FEATURE);
-	if (!(feature & KVM_FEATURE_STEAL_TIME))
+	if (!(feature & BIT(KVM_FEATURE_STEAL_TIME)))
 		return 0;
 
 	has_steal_clock = 1;
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea73f9dc2cc6..08a7a97e0936 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -50,9 +50,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 		vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
 		break;
 	case CPUCFG_KVM_FEATURE:
-		ret = KVM_FEATURE_IPI;
-		if (kvm_pvtime_supported())
-			ret |= KVM_FEATURE_STEAL_TIME;
+		ret = vcpu->kvm->arch.pv_features & LOONGARCH_PV_FEAT_MASK;
 		vcpu->arch.gprs[rd] = ret;
 		break;
 	default:
@@ -697,7 +695,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
 	id   = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
 	data = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
 	switch (id) {
-	case KVM_FEATURE_STEAL_TIME:
+	case BIT(KVM_FEATURE_STEAL_TIME):
 		if (!kvm_pvtime_supported())
 			return KVM_HCALL_INVALID_CODE;
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 16756ffb55e8..ca3dfdd2c47b 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -730,6 +730,8 @@ static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
 	switch (attr->attr) {
 	case 2:
 		return 0;
+	case CPUCFG_KVM_FEATURE:
+		return 0;
 	default:
 		return -ENXIO;
 	}
@@ -773,9 +775,18 @@ static int kvm_loongarch_cpucfg_get_attr(struct kvm_vcpu *vcpu,
 	uint64_t val;
 	uint64_t __user *uaddr = (uint64_t __user *)attr->addr;
 
-	ret = _kvm_get_cpucfg_mask(attr->attr, &val);
-	if (ret)
-		return ret;
+	switch (attr->attr) {
+	case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
+		ret = _kvm_get_cpucfg_mask(attr->attr, &val);
+		if (ret)
+			return ret;
+		break;
+	case CPUCFG_KVM_FEATURE:
+		val = vcpu->kvm->arch.pv_features & LOONGARCH_PV_FEAT_MASK;
+		break;
+	default:
+		return -ENXIO;
+	}
 
 	put_user(val, uaddr);
 
@@ -821,7 +832,29 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
 static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
 					 struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 val, valid;
+	struct kvm *kvm = vcpu->kvm;
+
+	switch (attr->attr) {
+	case CPUCFG_KVM_FEATURE:
+		if (get_user(val, user))
+			return -EFAULT;
+
+		valid = LOONGARCH_PV_FEAT_MASK;
+		if (val & ~valid)
+			return -EINVAL;
+
+		/* All vCPUs need set the same pv features */
+		if ((kvm->arch.pv_features & LOONGARCH_PV_FEAT_UPDATED) &&
+				((kvm->arch.pv_features & valid) != val))
+			return -EINVAL;
+		kvm->arch.pv_features = val | LOONGARCH_PV_FEAT_UPDATED;
+		return 0;
+
+	default:
+		return -ENXIO;
+	}
 }
 
 static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 6b2e4f66ad26..3234f3e85dc0 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -5,6 +5,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_vcpu.h>
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
@@ -39,6 +40,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	spin_lock_init(&kvm->arch.phyid_map_lock);
 
 	kvm_init_vmcs(kvm);
+	/* Enable all pv features by default */
+	kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
+	if (kvm_pvtime_supported())
+		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
 	kvm->arch.gpa_size = BIT(cpu_vabits - 1);
 	kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
 	kvm->arch.invalid_ptes[0] = 0;
@@ -99,7 +104,43 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VM_FEAT_PV_IPI:
+		return 0;
+	case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
+		if (kvm_pvtime_supported())
+			return 0;
+		return -ENXIO;
+	default:
+		return -ENXIO;
+	}
+}
+
+static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_LOONGARCH_VM_FEAT_CTRL:
+		return kvm_vm_feature_has_attr(kvm, attr);
+	default:
+		return -ENXIO;
+	}
+}
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	struct kvm *kvm = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	struct kvm_device_attr attr;
+
+	switch (ioctl) {
+	case KVM_HAS_DEVICE_ATTR:
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+
+		return kvm_vm_has_attr(kvm, &attr);
+	default:
+		return -EINVAL;
+	}
 }
-- 
2.39.3


