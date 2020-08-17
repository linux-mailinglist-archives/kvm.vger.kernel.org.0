Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754EF246078
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 10:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHQIlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 04:41:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45206 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726633AbgHQIli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 04:41:38 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 795BABA4CBE70EFE0EF9;
        Mon, 17 Aug 2020 16:41:22 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 16:41:13 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [RFC PATCH 2/5] KVM: arm64: Support Live Physical Time reporting
Date:   Mon, 17 Aug 2020 16:41:07 +0800
Message-ID: <20200817084110.2672-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817084110.2672-1-zhukeqian1@huawei.com>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a method for a guest to derive a paravirtualized counter/timer
which isn't dependent on the host's counter frequency. This allows a
guest to be migrated onto a new host which doesn't have the same
frequency without the virtual counter being disturbed.

The host provides a shared structure which contains coefficients that
can be used to map the real counter from the host (the Arm "virtual
counter") to a paravirtualized view of time. On migration the new host
updates the coefficients to ensure that the guests view of time (after
using the coefficients) doesn't change and that the derived counter
progresses at the same real frequency.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  10 +++
 arch/arm64/kvm/arm.c              |   7 +++
 arch/arm64/kvm/hypercalls.c       |   5 ++
 arch/arm64/kvm/pvtime.c           | 125 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e21d4a0..0c6a564 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -95,6 +95,13 @@ struct kvm_arch {
 	 * supported.
 	 */
 	bool return_nisv_io_abort_to_user;
+
+	/* Guest PV Live Physical Time state */
+	struct {
+		u32 fpv; /* PV frequency */
+		gpa_t base; /* Base IPA of shared structure */
+		bool updated; /* Indicate whether it is updated by KVM */
+	} lpt;
 };
 
 #define KVM_NR_MEM_OBJS     40
@@ -506,6 +513,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
+gpa_t kvm_init_lpt_time(struct kvm *kvm);
+int kvm_update_lpt_time(struct kvm *kvm);
+
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb905..671f1461 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -135,6 +135,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
+	/* Should be setup by userspace before guest run */
+	kvm->arch.lpt.base = GPA_INVALID;
+
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(kvm);
@@ -528,6 +531,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.has_run_once = true;
 
+	ret = kvm_update_lpt_time(kvm);
+	if (ret)
+		return ret;
+
 	if (likely(irqchip_in_kernel(kvm))) {
 		/*
 		 * Map the VGIC hardware resources before running a vcpu the
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 550dfa3..254491b 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -62,6 +62,11 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		if (gpa != GPA_INVALID)
 			val = gpa;
 		break;
+	case ARM_SMCCC_HV_PV_TIME_LPT:
+		gpa = kvm_init_lpt_time(vcpu->kvm);
+		if (gpa != GPA_INVALID)
+			val = gpa;
+		break;
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 2b24e7f..24131ca 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -43,7 +43,9 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 	case ARM_SMCCC_HV_PV_TIME_ST:
-		val = SMCCC_RET_SUCCESS;
+	case ARM_SMCCC_HV_PV_TIME_LPT:
+		if (vcpu->kvm->arch.lpt.updated)
+			val = SMCCC_RET_SUCCESS;
 		break;
 	}
 
@@ -134,3 +136,124 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 	}
 	return -ENXIO;
 }
+
+static int pvclock_lpt_update_vtimer(struct kvm *kvm,
+				     struct pvclock_vm_lpt_time *pvclock)
+{
+	u32 current_freq = arch_timer_get_rate();
+	u64 current_time = kvm_phys_timer_read();
+	u32 previous_freq;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	/* The first run? */
+	if (le64_to_cpu(pvclock->sequence_number) == 0)
+		return 0;
+
+	/* PV frequency must not change! */
+	if (le32_to_cpu(pvclock->pv_freq) != kvm->arch.lpt.fpv)
+		return -EFAULT;
+
+	previous_freq = le32_to_cpu(pvclock->native_freq);
+	if (previous_freq == current_freq)
+		return 0;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+		u64 cntvct, new_cntvct;
+		u32 cnt_tval, new_cnt_tval;
+
+		/* Update cntvoff based on new cntvct */
+		cntvct = current_time - vtimer->cntvoff;
+		new_cntvct = mul_u64_u32_div(cntvct,
+					current_freq,
+					previous_freq);
+		vtimer->cntvoff = current_time - new_cntvct;
+
+		/* Update cnt_cval based on new cnt_tval */
+		cnt_tval = vtimer->cnt_cval - cntvct;
+		new_cnt_tval = mul_u64_u32_div(cnt_tval,
+					current_freq,
+					previous_freq);
+		vtimer->cnt_cval = new_cntvct + new_cnt_tval;
+	}
+
+	return 0;
+}
+
+static void pvclock_lpt_update_structure(struct kvm *kvm,
+					 struct pvclock_vm_lpt_time *pvclock)
+{
+	u64 sequence_number, scale_mult, rscale_mult;
+	u32 native_freq, pv_freq;
+	u32 scale_intbits, fracbits;
+	u32 rscale_intbits, rfracbits;
+
+	sequence_number = le64_to_cpu(pvclock->sequence_number) + 2;
+
+	native_freq = arch_timer_get_rate();
+	pv_freq = kvm->arch.lpt.fpv;
+
+	/* At least one bit for int part */
+	scale_intbits = rscale_intbits = 1;
+	if (pv_freq >= native_freq)
+		scale_intbits = ilog2(pv_freq / native_freq) + 1;
+	else
+		rscale_intbits = ilog2(native_freq / pv_freq) + 1;
+
+	fracbits = 64 - scale_intbits;
+	scale_mult = mul_u64_u32_div(BIT_ULL(fracbits), pv_freq, native_freq);
+	rfracbits = 64 - rscale_intbits;
+	rscale_mult = mul_u64_u32_div(BIT_ULL(rfracbits), native_freq, pv_freq);
+
+	pvclock->sequence_number = cpu_to_le64(sequence_number);
+	pvclock->native_freq = cpu_to_le32(native_freq);
+	pvclock->pv_freq = cpu_to_le32(pv_freq);
+	pvclock->scale_mult = cpu_to_le64(scale_mult);
+	pvclock->rscale_mult = cpu_to_le64(rscale_mult);
+	pvclock->fracbits = cpu_to_le32(fracbits);
+	pvclock->rfracbits = cpu_to_le32(rfracbits);
+}
+
+int kvm_update_lpt_time(struct kvm *kvm)
+{
+	u32 pv_freq = kvm->arch.lpt.fpv;
+	u64 lpt_ipa = kvm->arch.lpt.base;
+	struct pvclock_vm_lpt_time pvclock;
+	int ret = 0;
+
+	/* Userspace does not enable LPT? */
+	if (pv_freq == 0 && lpt_ipa == GPA_INVALID)
+		return 0;
+
+	/* Userspace fault programming? */
+	if (pv_freq == 0 || lpt_ipa == GPA_INVALID)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+	if (kvm->arch.lpt.updated)
+		goto unlock;
+
+	ret = kvm_read_guest_lock(kvm, lpt_ipa, &pvclock, sizeof(pvclock));
+	if (ret < 0)
+		goto unlock;
+
+	ret = pvclock_lpt_update_vtimer(kvm, &pvclock);
+	if (ret < 0)
+		goto unlock;
+
+	pvclock_lpt_update_structure(kvm, &pvclock);
+
+	ret = kvm_write_guest_lock(kvm, lpt_ipa, &pvclock, sizeof(pvclock));
+	if (!ret)
+		kvm->arch.lpt.updated = true;
+
+unlock:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
+gpa_t kvm_init_lpt_time(struct kvm *kvm)
+{
+	return kvm->arch.lpt.base;
+}
-- 
1.8.3.1

