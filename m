Return-Path: <kvm+bounces-22233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9046393C20C
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B38261C21779
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 12:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B0119AD5C;
	Thu, 25 Jul 2024 12:28:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AF5199E8A;
	Thu, 25 Jul 2024 12:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721910502; cv=none; b=kE8UNLm0Q9w0TFPgLLQfXYkNB78vlRkQ23cZstx0yvaAqYe4ds1GW8PBpmZMGuRbVc5qQ8ETDajQIpbP+YfRE1wMIQLWwVPklG0GVls+bAcxa6rAC/be8CNDgJr73xzaac1R2dRjQ9ygYqH/QBZfn8qlO4/WiZBGh2rIngk1XEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721910502; c=relaxed/simple;
	bh=5mYGuoueAKAJ4zBmY+64eKqJ/F+iEjrU3yJhTfhzb1g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gpb6h92EpgOaybw/Rte8Fe73NgX50SSfl4U3vukGRlwEN5i0Drsvnz4pfC+Nzg8ZUAsP5MGO7engpsNQ1TJQdRgnhm3ekVS1fViUBYkYtyy8Ene0DsAQcmvYz+cRYmlzdh6PfPpIjhd6v8KM22wZb3yQway9y6MV8pYTJhQj5Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.10.34])
	by gateway (Coremail) with SMTP id _____8DxSureRKJmUocBAA--.5849S3;
	Thu, 25 Jul 2024 20:28:14 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.10.34])
	by front1 (Coremail) with SMTP id qMiowMDxIuTcRKJmog8BAA--.7001S3;
	Thu, 25 Jul 2024 20:28:13 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH v3 1/2] LoongArch: KVM: Enable paravirt feature control from VMM
Date: Thu, 25 Jul 2024 20:28:11 +0800
Message-Id: <20240725122812.3296140-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240725122812.3296140-1-maobibo@loongson.cn>
References: <20240725122812.3296140-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxIuTcRKJmog8BAA--.7001S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKrykGw1fuw48KrWDtryfXwc_yoWfXrWfpF
	y7Ars5Gr4rKr1fCF1kt3909r15uFs7Cr12qFy293y5AF429ryUAr1vkrZrAFyDtayrua4I
	g3Wrtw1Yv3WqqwbCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r126r13M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2Z2-UUUUU

Export kernel paravirt features to user space, so that VMM can control
the single paravirt feature. By default paravirt features will the same
with kvm supported features if VMM does not set it.

Also a new feature KVM_FEATURE_VIRT_EXTIOI is added which can be set from
user space. This feature indicates that the virt EXTIOI can route
interrupts to 256 vCPUs, rather than 4 vCPUs like with real HW.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h      |  9 +++++
 arch/loongarch/include/asm/kvm_para.h      |  1 +
 arch/loongarch/include/asm/loongarch.h     | 13 -------
 arch/loongarch/include/uapi/asm/Kbuild     |  2 --
 arch/loongarch/include/uapi/asm/kvm.h      |  2 ++
 arch/loongarch/include/uapi/asm/kvm_para.h | 24 +++++++++++++
 arch/loongarch/kvm/exit.c                  |  4 +--
 arch/loongarch/kvm/vcpu.c                  | 41 +++++++++++++++++++---
 arch/loongarch/kvm/vm.c                    | 12 +++++++
 9 files changed, 86 insertions(+), 22 deletions(-)
 create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index c409ab15bae1..82d2c62416a7 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -109,6 +109,10 @@ struct kvm_arch {
 	unsigned int  root_level;
 	spinlock_t    phyid_map_lock;
 	struct kvm_phyid_map  *phyid_map;
+	/* Supported PV features */
+	unsigned long pv_capability;
+	/* Enabled PV features */
+	unsigned long pv_features;
 
 	s64 time_offset;
 	struct kvm_context __percpu *vmcs;
@@ -139,6 +143,11 @@ enum emulation_result {
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 4)
 #define KVM_LARCH_LBT		(0x1 << 5)
 
+#define LOONGARCH_PV_FEAT_UPDATED		BIT_ULL(63)
+#define LOONGARCH_PV_FEAT_MASK					\
+		(KVM_FEATURE_IPI | KVM_FEATURE_STEAL_TIME |	\
+		 KVM_FEATURE_VIRT_EXTIOI)
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
index 003fb766c93f..4d56ec3777a0 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -98,6 +98,8 @@ struct kvm_fpu {
 #define  KVM_LOONGARCH_VM_FEAT_X86BT	2
 #define  KVM_LOONGARCH_VM_FEAT_ARMBT	3
 #define  KVM_LOONGARCH_VM_FEAT_MIPSBT	4
+#define  KVM_LOONGARCH_VM_FEAT_PV_IPI		5
+#define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	6
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
new file mode 100644
index 000000000000..a63b67c90240
--- /dev/null
+++ b/arch/loongarch/include/uapi/asm/kvm_para.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _UAPI_ASM_LOONGARCH_KVM_PARA_H
+#define _UAPI_ASM_LOONGARCH_KVM_PARA_H
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
+#define  KVM_FEATURE_IPI		BIT(1)
+#define  KVM_FEATURE_STEAL_TIME		BIT(2)
+/*
+ * BIT 24 - 31 is features configurable by user space vmm
+ * With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs
+ */
+#define  KVM_FEATURE_VIRT_EXTIOI	BIT(24)
+
+#endif /* _UAPI_ASM_LOONGARCH_KVM_PARA_H */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index be2c326253a3..e293b95f456a 100644
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
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index b8210442c178..4918bebdf666 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -793,6 +793,8 @@ static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
 	switch (attr->attr) {
 	case 2:
 		return 0;
+	case CPUCFG_KVM_FEATURE:
+		return 0;
 	default:
 		return -ENXIO;
 	}
@@ -836,9 +838,18 @@ static int kvm_loongarch_cpucfg_get_attr(struct kvm_vcpu *vcpu,
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
 
@@ -884,7 +895,29 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
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
index f9604bc2b3ea..855f125a5aaa 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -5,6 +5,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_vcpu.h>
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
@@ -39,6 +40,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	spin_lock_init(&kvm->arch.phyid_map_lock);
 
 	kvm_init_vmcs(kvm);
+	kvm->arch.pv_capability = KVM_FEATURE_IPI;
+	if (kvm_pvtime_supported())
+		kvm->arch.pv_capability |= KVM_FEATURE_STEAL_TIME;
+	/* Enable all pv features by default */
+	kvm->arch.pv_features = kvm->arch.pv_capability;
 	kvm->arch.gpa_size = BIT(cpu_vabits - 1);
 	kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
 	kvm->arch.invalid_ptes[0] = 0;
@@ -122,6 +128,12 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 		if (cpu_has_lbt_mips)
 			return 0;
 		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_PV_IPI:
+		return 0;
+	case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
+		if (kvm_pvtime_supported())
+			return 0;
+		return -ENXIO;
 	default:
 		return -ENXIO;
 	}
-- 
2.39.3


