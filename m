Return-Path: <kvm+bounces-16208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9288B67A3
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 03:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 450051C20E42
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 01:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE85FBEF;
	Tue, 30 Apr 2024 01:45:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004976AD7;
	Tue, 30 Apr 2024 01:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714441517; cv=none; b=CeOPaNfRnxq2KTf5kxLGdddsgH+055kJM3EHs10VV3BxdUkoC9ArObAeLxY2KH0oxuiKRScWIZjTE5fdWTmUCxHaqBtRwPcRjp1S4Ik241okzfjO3iyutYBw8qE+hVVG5ku5EQMR80MwZSv8UrIyM9VAX6fZ6IPvtmJyW8CX8Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714441517; c=relaxed/simple;
	bh=/FZK7ecJ+Bj4dQhWYqJr70eSPYycDOzmF+xluMxFT6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CTr7bm6EMslYUMiiscI9yDh07FF1XOMIMN1pqavFdlhvLF+4JCw3lHj5Ap+y/gBTnLG6hkXB5BcISj3bvSULRgfi5UbvIunhaE4HBRfRYFR9bLmaCIKYlzu4BWVlrtvRPMo1VDpHd7MXjuJ9Wm5ahjuiSWj7GDN5IhoErDi5s8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxN+koTTBmtzoFAA--.5167S3;
	Tue, 30 Apr 2024 09:45:12 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxyt0hTTBmfrwKAA--.25728S3;
	Tue, 30 Apr 2024 09:45:09 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Juergen Gross <jgross@suse.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v2 1/2] LoongArch: KVM: Add steal time support in kvm side
Date: Tue, 30 Apr 2024 09:45:04 +0800
Message-Id: <20240430014505.2102631-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240430014505.2102631-1-maobibo@loongson.cn>
References: <20240430014505.2102631-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cxyt0hTTBmfrwKAA--.25728S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Steal time feature is added here in kvm side, VM can search supported
features provided by KVM hypervisor, feature KVM_FEATURE_STEAL_TIME
is added here. Like x86, steal time structure is saved in guest memory,
one hypercall function KVM_HCALL_FUNC_NOTIFY is added to notify KVM to
enable the feature.

One cpu attr ioctl command KVM_LOONGARCH_VCPU_PVTIME_CTRL is added to
save and restore base address of steal time structure when VM is migrated.

Since it needs hypercall instruction emulation handling, and it is
dependent on this patchset:
https://lore.kernel.org/all/20240428100518.1642324-1-maobibo@loongson.cn/

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h  |   7 ++
 arch/loongarch/include/asm/kvm_para.h  |  10 +++
 arch/loongarch/include/asm/loongarch.h |   1 +
 arch/loongarch/include/uapi/asm/kvm.h  |   4 +
 arch/loongarch/kvm/exit.c              |  29 +++++-
 arch/loongarch/kvm/vcpu.c              | 120 +++++++++++++++++++++++++
 6 files changed, 169 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 1921750d4b4c..30bda553c54d 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #define KVM_PRIVATE_MEM_SLOTS		0
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
+#define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(1)
 
 #define KVM_GUESTDBG_VALID_MASK		(KVM_GUESTDBG_ENABLE | \
 			KVM_GUESTDBG_USE_SW_BP | KVM_GUESTDBG_SINGLESTEP)
@@ -198,6 +199,12 @@ struct kvm_vcpu_arch {
 	struct kvm_mp_state mp_state;
 	/* cpucfg */
 	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
+	/* paravirt steal time */
+	struct {
+		u64 guest_addr;
+		u64 last_steal;
+		struct gfn_to_hva_cache cache;
+	} st;
 };
 
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 56775554402a..5fb89e20432d 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -12,6 +12,7 @@
 #define KVM_HCALL_CODE_SWDBG		1
 #define KVM_HCALL_PV_SERVICE		HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HCALL_CODE_PV_SERVICE)
 #define  KVM_HCALL_FUNC_PV_IPI		1
+#define  KVM_HCALL_FUNC_NOTIFY		2
 #define KVM_HCALL_SWDBG			HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
 
 /*
@@ -21,6 +22,15 @@
 #define KVM_HCALL_INVALID_CODE		-1UL
 #define KVM_HCALL_INVALID_PARAMETER	-2UL
 
+#define KVM_STEAL_PHYS_VALID		BIT_ULL(0)
+#define KVM_STEAL_PHYS_MASK		GENMASK_ULL(63, 6)
+struct kvm_steal_time {
+	__u64 steal;
+	__u32 version;
+	__u32 flags;
+	__u32 pad[12];
+};
+
 /*
  * Hypercall interface for KVM hypervisor
  *
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 0ad36704cb4b..ab6a5e93c280 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -168,6 +168,7 @@
 #define  KVM_SIGNATURE			"KVM\0"
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
 #define  KVM_FEATURE_PV_IPI		BIT(1)
+#define  KVM_FEATURE_STEAL_TIME		BIT(2)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 8f78b23672ac..286b5ce93a57 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -80,7 +80,11 @@ struct kvm_fpu {
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
 #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
+
+/* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
+#define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
+#define  KVM_LOONGARCH_VCPU_PVTIME_GPA	0
 
 struct kvm_debug_exit_arch {
 };
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 680aeaa4aeeb..af0f1c46e4eb 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -209,7 +209,7 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
 static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 {
 	int rd, rj;
-	unsigned int index;
+	unsigned int index, ret;
 
 	rd = inst.reg2_format.rd;
 	rj = inst.reg2_format.rj;
@@ -232,7 +232,10 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 		vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
 		break;
 	case CPUCFG_KVM_FEATURE:
-		vcpu->arch.gprs[rd] = KVM_FEATURE_PV_IPI;
+		ret = KVM_FEATURE_PV_IPI;
+		if (sched_info_on())
+			ret |= KVM_FEATURE_STEAL_TIME;
+		vcpu->arch.gprs[rd] = ret;
 		break;
 	default:
 		vcpu->arch.gprs[rd] = 0;
@@ -738,6 +741,25 @@ static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_save_notify(struct kvm_vcpu *vcpu)
+{
+	unsigned long id, data;
+
+	id   = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
+	data = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
+	switch (id) {
+	case KVM_FEATURE_STEAL_TIME:
+		vcpu->arch.st.guest_addr = data;
+		vcpu->arch.st.last_steal = current->sched_info.run_delay;
+		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
+		break;
+	default:
+		break;
+	};
+
+	return 0;
+};
+
 /*
  * hypercall emulation always return to guest, Caller should check retval.
  */
@@ -751,6 +773,9 @@ static void kvm_handle_pv_service(struct kvm_vcpu *vcpu)
 		kvm_pv_send_ipi(vcpu);
 		ret = KVM_HCALL_STATUS_SUCCESS;
 		break;
+	case KVM_HCALL_FUNC_NOTIFY:
+		ret = kvm_save_notify(vcpu);
+		break;
 	default:
 		ret = KVM_HCALL_INVALID_CODE;
 		break;
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 71a4d10b3ff6..4289a0f545fe 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -31,6 +31,113 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
+static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+{
+	struct kvm_steal_time __user *st;
+	struct gfn_to_hva_cache *ghc;
+	struct kvm_memslots *slots;
+	gpa_t gpa;
+	u64 steal;
+	u32 version;
+
+	ghc = &vcpu->arch.st.cache;
+	gpa = vcpu->arch.st.guest_addr;
+	if (!(gpa & KVM_STEAL_PHYS_VALID))
+		return;
+
+	gpa &= KVM_STEAL_PHYS_MASK;
+	slots = kvm_memslots(vcpu->kvm);
+	if (slots->generation != ghc->generation || gpa != ghc->gpa) {
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa,
+					sizeof(*st))) {
+			ghc->gpa = INVALID_GPA;
+			return;
+		}
+	}
+
+	st = (struct kvm_steal_time __user *)ghc->hva;
+	unsafe_get_user(version, &st->version, out);
+	if (version & 1)
+		version += 1;
+	version += 1;
+	unsafe_put_user(version, &st->version, out);
+	smp_wmb();
+
+	unsafe_get_user(steal, &st->steal, out);
+	steal += current->sched_info.run_delay -
+		vcpu->arch.st.last_steal;
+	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	unsafe_put_user(steal, &st->steal, out);
+
+	smp_wmb();
+	version += 1;
+	unsafe_put_user(version, &st->version, out);
+out:
+	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+}
+
+static bool kvm_pvtime_supported(void)
+{
+	return !!sched_info_on();
+}
+
+static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
+					struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	struct kvm *kvm = vcpu->kvm;
+	u64 gpa;
+	int ret = 0;
+	int idx;
+
+	if (!kvm_pvtime_supported() ||
+			attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
+		return -ENXIO;
+
+	if (get_user(gpa, user))
+		return -EFAULT;
+
+	/* Check the address is in a valid memslot */
+	idx = srcu_read_lock(&kvm->srcu);
+	if (kvm_is_error_hva(gfn_to_hva(kvm, gpa >> PAGE_SHIFT)))
+		ret = -EINVAL;
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (!ret)
+		vcpu->arch.st.guest_addr = gpa;
+
+	return ret;
+}
+
+static int kvm_loongarch_pvtime_get_attr(struct kvm_vcpu *vcpu,
+					struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 gpa;
+
+	if (!kvm_pvtime_supported() ||
+			attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
+		return -ENXIO;
+
+	gpa = vcpu->arch.st.guest_addr;
+	if (put_user(gpa, user))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_loongarch_pvtime_has_attr(struct kvm_vcpu *vcpu,
+					struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VCPU_PVTIME_GPA:
+		if (kvm_pvtime_supported())
+			return 0;
+	}
+
+	return -ENXIO;
+}
+
 /*
  * kvm_check_requests - check and handle pending vCPU requests
  *
@@ -48,6 +155,9 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
 	if (kvm_dirty_ring_check_request(vcpu))
 		return RESUME_HOST;
 
+	if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
+		kvm_update_stolen_time(vcpu);
+
 	return RESUME_GUEST;
 }
 
@@ -670,6 +780,9 @@ static int kvm_loongarch_vcpu_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_cpucfg_has_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
+		ret = kvm_loongarch_pvtime_has_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -702,6 +815,9 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_get_cpucfg_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
+		ret = kvm_loongarch_pvtime_get_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -724,6 +840,9 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_cpucfg_set_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
+		ret = kvm_loongarch_pvtime_set_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -1082,6 +1201,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Control guest page CCA attribute */
 	change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
+	kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	/* Don't bother restoring registers multiple times unless necessary */
 	if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
-- 
2.39.3


