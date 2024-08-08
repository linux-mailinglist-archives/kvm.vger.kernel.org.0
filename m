Return-Path: <kvm+bounces-23607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B285D94B91D
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 10:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE21C1C20B6F
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA2818953D;
	Thu,  8 Aug 2024 08:36:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2551465B3;
	Thu,  8 Aug 2024 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723106205; cv=none; b=EhekOB9MzcqdvoGuDxnGbFoEgBpoVI8CgwUnfwhJDjwYh4fqf08vKW/3aurmbyc9d4PR4SsF3crQuIubMxsI/KRrRS9Eowetw0SSbcm6oLgTO6jqN9wRCqGVuQ1XxTE593VrBEWmn8mMtPJROoOG+OL7RTRFHyDnEHL2nMv9HvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723106205; c=relaxed/simple;
	bh=5zQkurv4VdW0h3BdhXp17zysHzZ2zWbjCvbCFY+zLBM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IROozYbXVPe8oyJ/Rnsu7NNUlGvgsGvazLgFKWjH6m3gQNXY5qoK8Ix6wvLfVFqQtZULztpsb24Z/eEh2vDAVoPESu6cwyoE18kjjMUZLegWHxZZbyR5G+eZV/crbmt4NC2RTzsW5wYzQmWyI/FR8gv2cW3su5SgtDAMGs7EuSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxHuuYg7RmP5gLAA--.35108S3;
	Thu, 08 Aug 2024 16:36:40 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDx0uGWg7RmUXkJAA--.47562S2;
	Thu, 08 Aug 2024 16:36:39 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add haltpoll control feature in kvm side
Date: Thu,  8 Aug 2024 16:36:38 +0800
Message-Id: <20240808083638.205659-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDx0uGWg7RmUXkJAA--.47562S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

The cpuidle-haltpoll driver with haltpoll governor allows the guest
vcpus to poll for a specified amount of time before halting. This
provides some benefits such as avoid sending IPI to perform a wakeup
and avoid VM-exit cost.

When guest VM uses cpuidle-halt poll method, haltpoll need be disabled
at host hypervisor side to avoid double haltpoll in both guest VM and
host hypervisor. Here KVM_FEATURE_POLL_CONTROL feature is added in KVM
and guest can detect this feature and disable haltpoll in host side.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h  |  1 +
 arch/loongarch/include/asm/loongarch.h |  1 +
 arch/loongarch/include/uapi/asm/kvm.h  |  3 +
 arch/loongarch/kvm/Kconfig             |  1 +
 arch/loongarch/kvm/exit.c              |  9 ++-
 arch/loongarch/kvm/vcpu.c              | 85 ++++++++++++++++++++------
 6 files changed, 81 insertions(+), 19 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 44b54965f5b4..a972f70ccdfc 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -214,6 +214,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		struct gfn_to_hva_cache cache;
 	} st;
+	unsigned long kvm_poll_control;
 };
 
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 04a78010fc72..e4fc30cf3572 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -170,6 +170,7 @@
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
 #define  KVM_FEATURE_IPI		BIT(1)
 #define  KVM_FEATURE_STEAL_TIME		BIT(2)
+#define  KVM_FEATURE_POLL_CONTROL	BIT(3)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ddc5cab0ffd0..191f10c2b6c2 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -85,7 +85,10 @@ struct kvm_fpu {
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
 #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
+/* Alias of KVM_LOONGARCH_VCPU_PVTIME_CTRL for wider use */
+#define KVM_LOONGARCH_VCPU_PV_CTRL	1
 #define  KVM_LOONGARCH_VCPU_PVTIME_GPA	0
+#define  KVM_LOONGARCH_VCPU_POLL_CTRL	1
 
 struct kvm_debug_exit_arch {
 };
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index 248744b4d086..c5cc4dd2fb90 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -21,6 +21,7 @@ config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on AS_HAS_LVZ_EXTENSION
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select HAVE_KVM_NO_POLL
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea73f9dc2cc6..ebd578251388 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -50,7 +50,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 		vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
 		break;
 	case CPUCFG_KVM_FEATURE:
-		ret = KVM_FEATURE_IPI;
+		ret = KVM_FEATURE_IPI | KVM_FEATURE_POLL_CONTROL;
 		if (kvm_pvtime_supported())
 			ret |= KVM_FEATURE_STEAL_TIME;
 		vcpu->arch.gprs[rd] = ret;
@@ -711,6 +711,13 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
 		vcpu->arch.st.last_steal = current->sched_info.run_delay;
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 		break;
+	case KVM_FEATURE_POLL_CONTROL:
+		/* Only enable bit supported */
+		if (data & (-1ULL << 1))
+			return KVM_HCALL_INVALID_PARAMETER;
+
+		vcpu->arch.kvm_poll_control = data;
+		break;
 	default:
 		break;
 	};
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 16756ffb55e8..6e5c58cef90f 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -233,6 +233,11 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->arch.kvm_poll_control & 1) == 0;
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return false;
@@ -650,6 +655,7 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
 			kvm_reset_timer(vcpu);
 			memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
 			memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
+			vcpu->arch.kvm_poll_control = 1;
 			break;
 		default:
 			ret = -EINVAL;
@@ -737,14 +743,21 @@ static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
 	return -ENXIO;
 }
 
-static int kvm_loongarch_pvtime_has_attr(struct kvm_vcpu *vcpu,
+static int kvm_loongarch_pv_has_attr(struct kvm_vcpu *vcpu,
 					 struct kvm_device_attr *attr)
 {
-	if (!kvm_pvtime_supported() ||
-			attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VCPU_PVTIME_GPA:
+		if (!kvm_pvtime_supported())
+			return -ENXIO;
+		return 0;
+	case KVM_LOONGARCH_VCPU_POLL_CTRL:
+		return 0;
+	default:
 		return -ENXIO;
+	}
 
-	return 0;
+	return -ENXIO;
 }
 
 static int kvm_loongarch_vcpu_has_attr(struct kvm_vcpu *vcpu,
@@ -756,8 +769,8 @@ static int kvm_loongarch_vcpu_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_cpucfg_has_attr(vcpu, attr);
 		break;
-	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
-		ret = kvm_loongarch_pvtime_has_attr(vcpu, attr);
+	case KVM_LOONGARCH_VCPU_PV_CTRL:
+		ret = kvm_loongarch_pv_has_attr(vcpu, attr);
 		break;
 	default:
 		break;
@@ -782,18 +795,26 @@ static int kvm_loongarch_cpucfg_get_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static int kvm_loongarch_pvtime_get_attr(struct kvm_vcpu *vcpu,
+static int kvm_loongarch_pv_get_attr(struct kvm_vcpu *vcpu,
 					 struct kvm_device_attr *attr)
 {
-	u64 gpa;
+	u64 val;
 	u64 __user *user = (u64 __user *)attr->addr;
 
-	if (!kvm_pvtime_supported() ||
-			attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VCPU_PVTIME_GPA:
+		if (!kvm_pvtime_supported())
+			return -ENXIO;
+		val = vcpu->arch.st.guest_addr;
+		break;
+	case KVM_LOONGARCH_VCPU_POLL_CTRL:
+		val = vcpu->arch.kvm_poll_control;
+		break;
+	default:
 		return -ENXIO;
+	}
 
-	gpa = vcpu->arch.st.guest_addr;
-	if (put_user(gpa, user))
+	if (put_user(val, user))
 		return -EFAULT;
 
 	return 0;
@@ -808,8 +829,8 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_cpucfg_get_attr(vcpu, attr);
 		break;
-	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
-		ret = kvm_loongarch_pvtime_get_attr(vcpu, attr);
+	case KVM_LOONGARCH_VCPU_PV_CTRL:
+		ret = kvm_loongarch_pv_get_attr(vcpu, attr);
 		break;
 	default:
 		break;
@@ -831,8 +852,7 @@ static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
 	u64 gpa, __user *user = (u64 __user *)attr->addr;
 	struct kvm *kvm = vcpu->kvm;
 
-	if (!kvm_pvtime_supported() ||
-			attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
+	if (!kvm_pvtime_supported())
 		return -ENXIO;
 
 	if (get_user(gpa, user))
@@ -861,6 +881,33 @@ static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int kvm_loongarch_pv_set_attr(struct kvm_vcpu *vcpu,
+					struct kvm_device_attr *attr)
+{
+	u64 val,  __user *user = (u64 __user *)attr->addr;
+
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VCPU_PVTIME_GPA:
+		return kvm_loongarch_pvtime_set_attr(vcpu, attr);
+
+	case KVM_LOONGARCH_VCPU_POLL_CTRL:
+		if (get_user(val, user))
+			return -EFAULT;
+
+		/* Only enable bit supported */
+		if (val & (-1ULL << 1))
+			return -EINVAL;
+
+		vcpu->arch.kvm_poll_control = val;
+		break;
+
+	default:
+		return -ENXIO;
+	}
+
+	return -ENXIO;
+}
+
 static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
 				       struct kvm_device_attr *attr)
 {
@@ -870,8 +917,8 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_cpucfg_set_attr(vcpu, attr);
 		break;
-	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
-		ret = kvm_loongarch_pvtime_set_attr(vcpu, attr);
+	case KVM_LOONGARCH_VCPU_PV_CTRL:
+		ret = kvm_loongarch_pv_set_attr(vcpu, attr);
 		break;
 	default:
 		break;
@@ -1179,6 +1226,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Start with no pending virtual guest interrupts */
 	csr->csrs[LOONGARCH_CSR_GINTC] = 0;
 
+	/* poll control enabled by default */
+	vcpu->arch.kvm_poll_control = 1;
 	return 0;
 }
 

base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
-- 
2.39.3


