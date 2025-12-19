Return-Path: <kvm+bounces-66307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7087CCEA5C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 07:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 955D530329D6
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 06:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E478C2DA74C;
	Fri, 19 Dec 2025 06:30:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A0F42D8DC2;
	Fri, 19 Dec 2025 06:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766125841; cv=none; b=Y9LiwjClKZNaTyaST76z9u1FHAPGWP/sSUjyDD4oLSzjLEa3fvolFL1bK7ZtS1iv44K/Lx60EysxE5YIiMWLVoQDZIG+uwzw5JRQSx8ARjC3Rn9vpR84U0kKm74r12ARmLALOTK7gwzSS7QYg5sgEfzA7rfemtLEeKcmCnvR6xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766125841; c=relaxed/simple;
	bh=NhfHcRO1N0I5rmf517wXP5Ahnj0gxMrsXFpaGPUjyt8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q7PiiasZP/vljff9Ss2+23Ujv/BMvpTXurfq3dBEBruamom9ZWy3rOMI3G2FB6Hn3ah+gQ5wEG9hPdYrESkRMcCIS+MDSrZOuhTKNqxq5P+L9AtYtn/vKUC2tBULk+hu57tnJtMZ+HJnhg9SbHWnQBv23NzIhYjTydj8sRraFv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxPMMB8URpQMEAAA--.2447S3;
	Fri, 19 Dec 2025 14:30:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBx68H+8ERpt6kBAA--.3572S3;
	Fri, 19 Dec 2025 14:30:22 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] LoongArch: KVM: Add paravirt preempt feature in hypervisor side
Date: Fri, 19 Dec 2025 14:30:20 +0800
Message-Id: <20251219063021.1778659-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251219063021.1778659-1-maobibo@loongson.cn>
References: <20251219063021.1778659-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx68H+8ERpt6kBAA--.3572S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Feature KVM_FEATURE_PREEMPT is added to show whether vCPU is preempted
or not. It is to help guest OS scheduling or lock checking etc. Here
add KVM_FEATURE_PREEMPT feature and use one byte as preempted flag in
steal time structure.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h      |  2 +
 arch/loongarch/include/asm/kvm_para.h      |  4 +-
 arch/loongarch/include/uapi/asm/kvm.h      |  1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kvm/vcpu.c                  | 53 +++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                    |  3 ++
 6 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index e4fe5b8e8149..33f1ed910ae1 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -164,6 +164,7 @@ enum emulation_result {
 
 #define LOONGARCH_PV_FEAT_UPDATED	BIT_ULL(63)
 #define LOONGARCH_PV_FEAT_MASK		(BIT(KVM_FEATURE_IPI) |		\
+					 BIT(KVM_FEATURE_PREEMPT) |	\
 					 BIT(KVM_FEATURE_STEAL_TIME) |	\
 					 BIT(KVM_FEATURE_USER_HCALL) |	\
 					 BIT(KVM_FEATURE_VIRT_EXTIOI))
@@ -252,6 +253,7 @@ struct kvm_vcpu_arch {
 		u64 guest_addr;
 		u64 last_steal;
 		struct gfn_to_hva_cache cache;
+		u8  preempted;
 	} st;
 };
 
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 3e4b397f423f..fb17ba0fa101 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -37,8 +37,10 @@ struct kvm_steal_time {
 	__u64 steal;
 	__u32 version;
 	__u32 flags;
-	__u32 pad[12];
+	__u8  preempted;
+	__u8  pad[47];
 };
+#define KVM_VCPU_PREEMPTED		(1 << 0)
 
 /*
  * Hypercall interface for KVM hypervisor
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index de6c3f18e40a..419647aacdf3 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -105,6 +105,7 @@ struct kvm_fpu {
 #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
 #define  KVM_LOONGARCH_VM_FEAT_PTW		8
 #define  KVM_LOONGARCH_VM_FEAT_MSGINT		9
+#define  KVM_LOONGARCH_VM_FEAT_PV_PREEMPT	10
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
index 76d802ef01ce..d28cbcadd276 100644
--- a/arch/loongarch/include/uapi/asm/kvm_para.h
+++ b/arch/loongarch/include/uapi/asm/kvm_para.h
@@ -15,6 +15,7 @@
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
 #define  KVM_FEATURE_IPI		1
 #define  KVM_FEATURE_STEAL_TIME		2
+#define  KVM_FEATURE_PREEMPT		3
 /* BIT 24 - 31 are features configurable by user space vmm */
 #define  KVM_FEATURE_VIRT_EXTIOI	24
 #define  KVM_FEATURE_USER_HCALL		25
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..7637f472eeaa 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -181,6 +181,11 @@ static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	}
 
 	st = (struct kvm_steal_time __user *)ghc->hva;
+	if (kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT)) {
+		unsafe_put_user(0, &st->preempted, out);
+		vcpu->arch.st.preempted = 0;
+	}
+
 	unsafe_get_user(version, &st->version, out);
 	if (version & 1)
 		version += 1; /* first time write, random junk */
@@ -1773,11 +1778,57 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 	return 0;
 }
 
+static void kvm_vcpu_set_pv_preempted(struct kvm_vcpu *vcpu)
+{
+	struct gfn_to_hva_cache *ghc;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	gpa_t gpa;
+
+	gpa = vcpu->arch.st.guest_addr;
+	if (!(gpa & KVM_STEAL_PHYS_VALID))
+		return;
+
+	/* vCPU may be preempted for many times */
+	if (vcpu->arch.st.preempted)
+		return;
+
+	/* This happens on process exit */
+	if (unlikely(current->mm != vcpu->kvm->mm))
+		return;
+
+	gpa &= KVM_STEAL_PHYS_MASK;
+	ghc = &vcpu->arch.st.cache;
+	slots = kvm_memslots(vcpu->kvm);
+	if (slots->generation != ghc->generation || gpa != ghc->gpa) {
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st))) {
+			ghc->gpa = INVALID_GPA;
+			return;
+		}
+	}
+
+	st = (struct kvm_steal_time __user *)ghc->hva;
+	unsafe_put_user(KVM_VCPU_PREEMPTED, &st->preempted, out);
+	vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+out:
+	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+}
+
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	int cpu;
+	int cpu, idx;
 	unsigned long flags;
 
+	if (vcpu->preempted && kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT)) {
+		/*
+		 * Take the srcu lock as memslots will be accessed to check the gfn
+		 * cache generation against the memslots generation.
+		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_vcpu_set_pv_preempted(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+
 	local_irq_save(flags);
 	cpu = smp_processor_id();
 	vcpu->arch.last_sched_cpu = cpu;
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 194ccbcdc3b3..a60097b8ddcc 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -38,7 +38,9 @@ static void kvm_vm_init_features(struct kvm *kvm)
 	kvm->arch.kvm_features = BIT(KVM_LOONGARCH_VM_FEAT_PV_IPI);
 	if (kvm_pvtime_supported()) {
 		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
+		kvm->arch.pv_features |= BIT(KVM_FEATURE_PREEMPT);
 		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_PV_STEALTIME);
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_PV_PREEMPT);
 	}
 }
 
@@ -161,6 +163,7 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 	case KVM_LOONGARCH_VM_FEAT_PMU:
 	case KVM_LOONGARCH_VM_FEAT_PV_IPI:
 	case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
+	case KVM_LOONGARCH_VM_FEAT_PV_PREEMPT:
 		if (kvm_vm_support(&kvm->arch, attr->attr))
 			return 0;
 		return -ENXIO;
-- 
2.39.3


