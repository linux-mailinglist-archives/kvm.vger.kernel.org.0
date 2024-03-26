Return-Path: <kvm+bounces-12670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2CD88BC96
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:36:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 679BC1F3B48C
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924FD40879;
	Tue, 26 Mar 2024 08:35:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B342B1B948;
	Tue, 26 Mar 2024 08:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711442134; cv=none; b=EZcuWOUfeawUynxc/XiL9yrYHjsSng2rqJ7PnRDwLINp5E8ZNJKfeaJ0CflvlXNO9eu+CSMQhJu72wBB6KnoTz4ui4J3gbv9OFxnLyCa/VajEMM5nH2IUfG53DyjuNncRJ6YmSYhMKW1+zzg5wj8ptvByBY16NNdMqh/D2Xi2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711442134; c=relaxed/simple;
	bh=2GIXjbCzNeDWpQsOaIK0hhFHXZOOSzld/T5q5PGZYJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z5xSmBTdppkibWbsY3XUy+OJvpr5fdj+KYGqf25JF8ILWS35BeCELVVB17UFAlI15jZdqRnupMgecxYN1c9Db23pVTfTV3lQW8Y0nxV8igXm00LGhW2rR6I7mb5KjHf+k1N22BbIJ2AGQzrlHe35fWTqAZESXX2HEbVoHO4XYEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxifAFggJmDkoeAA--.6080S3;
	Tue, 26 Mar 2024 16:06:29 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxbRMBggJmhaRoAA--.9600S3;
	Tue, 26 Mar 2024 16:06:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Juergen Gross <jgross@suse.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH 1/2] LoongArch: KVM: Add steal time support in kvm side
Date: Tue, 26 Mar 2024 16:06:24 +0800
Message-Id: <20240326080625.898051-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240326080625.898051-1-maobibo@loongson.cn>
References: <20240326080625.898051-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxbRMBggJmhaRoAA--.9600S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Gw-Check: e5acd0b5fd9bcff5

Steal time feature is added here in kvm side, VM can search supported
features provided by KVM hypervisor, feature KVM_FEATURE_STEAL_TIME
is added here. Like x86, steal time structure is saved in guest memory,
one hypercall function KVM_HCALL_FUNC_NOTIFY is added to notify KVM to
enable the feature.

One cpu attr ioctl command KVM_LOONGARCH_VCPU_PVTIME_CTRL is added to
save and restore base address of steal time structure when VM is migrated.

Since it needs hypercall instruction emulation handling, and it is
dependent on this patchset:
https://lore.kernel.org/all/20240201031950.3225626-1-maobibo@loongson.cn/

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h  |   7 ++
 arch/loongarch/include/asm/kvm_para.h  |  10 +++
 arch/loongarch/include/asm/loongarch.h |   1 +
 arch/loongarch/include/uapi/asm/kvm.h  |   4 +
 arch/loongarch/kvm/exit.c              |  35 ++++++--
 arch/loongarch/kvm/vcpu.c              | 120 +++++++++++++++++++++++++
 6 files changed, 172 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index c53946f8ef9f..1d1eaa124349 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #define KVM_PRIVATE_MEM_SLOTS		0
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
+#define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(1)
 
 #define KVM_GUESTDBG_VALID_MASK		(KVM_GUESTDBG_ENABLE | \
 			KVM_GUESTDBG_USE_SW_BP | KVM_GUESTDBG_SINGLESTEP)
@@ -199,6 +200,12 @@ struct kvm_vcpu_arch {
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
index d71172e2568e..c774e5803f7f 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -209,7 +209,7 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
 static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 {
 	int rd, rj;
-	unsigned int index;
+	unsigned int index, ret;
 	unsigned long plv;
 
 	rd = inst.reg2_format.rd;
@@ -240,10 +240,13 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 			vcpu->arch.gprs[rd] = 0;
 		break;
 	case CPUCFG_KVM_FEATURE:
-		if ((plv & CSR_CRMD_PLV) == PLV_KERN)
-			vcpu->arch.gprs[rd] = KVM_FEATURE_PV_IPI;
-		else
-			vcpu->arch.gprs[rd] = 0;
+		ret = 0;
+		if ((plv & CSR_CRMD_PLV) == PLV_KERN) {
+			ret = KVM_FEATURE_PV_IPI;
+			if (sched_info_on())
+				ret |= KVM_FEATURE_STEAL_TIME;
+		}
+		vcpu->arch.gprs[rd] = ret;
 		break;
 	default:
 		vcpu->arch.gprs[rd] = 0;
@@ -749,6 +752,25 @@ static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu)
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
@@ -762,6 +784,9 @@ static void kvm_handle_pv_service(struct kvm_vcpu *vcpu)
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
index f22d10228cd2..ccfb9c899ec9 100644
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
 
@@ -672,6 +782,9 @@ static int kvm_loongarch_vcpu_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_cpucfg_has_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
+		ret = kvm_loongarch_pvtime_has_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -704,6 +817,9 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_get_cpucfg_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
+		ret = kvm_loongarch_pvtime_get_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -726,6 +842,9 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_CPUCFG:
 		ret = kvm_loongarch_cpucfg_set_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
+		ret = kvm_loongarch_pvtime_set_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -1084,6 +1203,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Control guest page CCA attribute */
 	change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
+	kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	/* Don't bother restoring registers multiple times unless necessary */
 	if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
-- 
2.39.3


