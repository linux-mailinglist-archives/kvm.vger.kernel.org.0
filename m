Return-Path: <kvm+bounces-63516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C7EC68239
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C0F0D3621B3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50A7308F25;
	Tue, 18 Nov 2025 08:07:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BBC306D3D;
	Tue, 18 Nov 2025 08:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763453233; cv=none; b=GSt7GW3G11nXrlLtXu8LLyhlNC/5bZ47VeThhtiacqvhRZsy5d9o6szZoCVPRnYhu0WBGjNWRYNyUtVmQn43Ha8S+XXDRZqw2z4yPwK3R9NwTa63o0KBErHe1vt84nOb+641GsbJhO6kNghcLuy7e8eHDaHAqFB+oCCml96Qq8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763453233; c=relaxed/simple;
	bh=ib7FKH9NdEy+A99XTbmlI/xTvKgGUUOH0Pew0YjcIpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bA4nShJd8BygrA+qSsZ5FB5o8Qr932+uPvsNw+o0z7cFd5H0ajiEMnqklgWliW2kTb6AyLCDfrA3WhZn5BV/R0+cHCEuNqMvpWdiizTEst1aFWYzG7bvl3ORMMznlXMKiPZwLelYiuZ1QtERtg0xPd3d7rziPh3pS88FsrAn7Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx5tAoKRxp89gkAA--.14111S3;
	Tue, 18 Nov 2025 16:07:04 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxjcEhKRxpUhc3AQ--.33984S3;
	Tue, 18 Nov 2025 16:07:02 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] LoongArch: KVM: Add preempt hint feature in hypervisor side
Date: Tue, 18 Nov 2025 16:06:54 +0800
Message-Id: <20251118080656.2012805-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251118080656.2012805-1-maobibo@loongson.cn>
References: <20251118080656.2012805-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxjcEhKRxpUhc3AQ--.33984S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Feature KVM_FEATURE_PREEMPT_HINT is added to show whether vCPU is
preempted or not. It is to help guest OS scheduling or lock checking
etc. Here add KVM_FEATURE_PREEMPT_HINT feature and use one byte as
preempted flag in steal time structure.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h      |  2 +
 arch/loongarch/include/asm/kvm_para.h      |  5 +-
 arch/loongarch/include/uapi/asm/kvm.h      |  1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kvm/vcpu.c                  | 54 +++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                    |  5 +-
 6 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 0cecbd038bb3..04c6dd171877 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -163,6 +163,7 @@ enum emulation_result {
 #define LOONGARCH_PV_FEAT_UPDATED	BIT_ULL(63)
 #define LOONGARCH_PV_FEAT_MASK		(BIT(KVM_FEATURE_IPI) |		\
 					 BIT(KVM_FEATURE_STEAL_TIME) |	\
+					 BIT(KVM_FEATURE_PREEMPT_HINT) |\
 					 BIT(KVM_FEATURE_USER_HCALL) |	\
 					 BIT(KVM_FEATURE_VIRT_EXTIOI))
 
@@ -250,6 +251,7 @@ struct kvm_vcpu_arch {
 		u64 guest_addr;
 		u64 last_steal;
 		struct gfn_to_hva_cache cache;
+		u8  preempted;
 	} st;
 };
 
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 3e4b397f423f..d8592a7f5922 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -37,8 +37,11 @@ struct kvm_steal_time {
 	__u64 steal;
 	__u32 version;
 	__u32 flags;
-	__u32 pad[12];
+	__u8  preempted;
+	__u8  u8_pad[3];
+	__u32 pad[11];
 };
+#define KVM_VCPU_PREEMPTED		(1 << 0)
 
 /*
  * Hypercall interface for KVM hypervisor
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 57ba1a563bb1..bca7154aa651 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -104,6 +104,7 @@ struct kvm_fpu {
 #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
 #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
 #define  KVM_LOONGARCH_VM_FEAT_PTW		8
+#define KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT	10
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
index 76d802ef01ce..fe4107869ce6 100644
--- a/arch/loongarch/include/uapi/asm/kvm_para.h
+++ b/arch/loongarch/include/uapi/asm/kvm_para.h
@@ -15,6 +15,7 @@
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
 #define  KVM_FEATURE_IPI		1
 #define  KVM_FEATURE_STEAL_TIME		2
+#define  KVM_FEATURE_PREEMPT_HINT	3
 /* BIT 24 - 31 are features configurable by user space vmm */
 #define  KVM_FEATURE_VIRT_EXTIOI	24
 #define  KVM_FEATURE_USER_HCALL		25
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 1245a6b35896..33a94b191b5d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -180,6 +180,11 @@ static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	}
 
 	st = (struct kvm_steal_time __user *)ghc->hva;
+	if (kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT_HINT)) {
+		unsafe_put_user(0, &st->preempted, out);
+		vcpu->arch.st.preempted = 0;
+	}
+
 	unsafe_get_user(version, &st->version, out);
 	if (version & 1)
 		version += 1; /* first time write, random junk */
@@ -1757,11 +1762,58 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 	return 0;
 }
 
+static void _kvm_set_vcpu_preempted(struct kvm_vcpu *vcpu)
+{
+	struct gfn_to_hva_cache *ghc;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	static const u8 preempted = KVM_VCPU_PREEMPTED;
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
+	unsafe_put_user(preempted, &st->preempted, out);
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
 
+	if (vcpu->preempted && kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT_HINT)) {
+		/*
+		 * Take the srcu lock as memslots will be accessed to check the gfn
+		 * cache generation against the memslots generation.
+		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		_kvm_set_vcpu_preempted(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+
 	local_irq_save(flags);
 	cpu = smp_processor_id();
 	vcpu->arch.last_sched_cpu = cpu;
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index a49b1c1a3dd1..b8879110a0a1 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -45,8 +45,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	/* Enable all PV features by default */
 	kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
-	if (kvm_pvtime_supported())
+	if (kvm_pvtime_supported()) {
 		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
+		kvm->arch.pv_features |= BIT(KVM_FEATURE_PREEMPT_HINT);
+	}
 
 	/*
 	 * cpu_vabits means user address space only (a half of total).
@@ -143,6 +145,7 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 	case KVM_LOONGARCH_VM_FEAT_PV_IPI:
 		return 0;
 	case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
+	case KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT:
 		if (kvm_pvtime_supported())
 			return 0;
 		return -ENXIO;
-- 
2.39.3


