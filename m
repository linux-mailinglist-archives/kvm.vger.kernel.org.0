Return-Path: <kvm+bounces-55172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B846CB2E082
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2061658104A
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D87F350843;
	Wed, 20 Aug 2025 14:59:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6628C3277A2;
	Wed, 20 Aug 2025 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701989; cv=none; b=MixcuO+L5Y8UQZdSHRP/hTTxOrLqokpxHV/5OI+4AI0c2Gryqdn8ipY4E8cKtrDJLXr5KIknb5r2a5dTUBRqfLJqBt6Ri01C1GORcPSsBYIIb5x43gALPbuI9KYiRQyT10w828V8HmjGVB2Sl+Dhz5V/iCTc2SZ2LaIfOfUSASc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701989; c=relaxed/simple;
	bh=wK+hYcDcZTNvnC7FmEPX30ZXJXvwI0Gi0lkvT6NXcUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7bJ9SpOow84K5/pDj48JjZzZfSrNLeNYm9uiPwpzc7AnS1o7XAByYzRorIyIWaL3rN5VEZmTauHuSSymllPBX3XZLRPwEZXyQA7ahj7J8utwKjcK9SWWqc1LZtsFXdCN+3rR32DQ7gqXdfoXYtVlK36BoDqDtgkImnwFmKokbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C94A12C3D;
	Wed, 20 Aug 2025 07:59:39 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E05A73F738;
	Wed, 20 Aug 2025 07:59:43 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v10 32/43] arm64: RME: Enable PMU support with a realm guest
Date: Wed, 20 Aug 2025 15:55:52 +0100
Message-ID: <20250820145606.180644-33-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
References: <20250820145606.180644-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the PMU registers from the RmiRecExit structure to identify when an
overflow interrupt is due and inject it into the guest. Also hook up the
configuration option for enabling the PMU within the guest.

When entering a realm guest with a PMU interrupt pending, it is
necessary to disable the physical interrupt. Otherwise when the RMM
restores the PMU state the physical interrupt will trigger causing an
immediate exit back to the host. The guest is expected to acknowledge
the interrupt causing a host exit (to update the GIC state) which gives
the opportunity to re-enable the physical interrupt before the next PMU
event.

Number of PMU counters is configured by the VMM by writing to PMCR.N.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v2:
 * Add a macro kvm_pmu_get_irq_level() to avoid compile issues when PMU
   support is disabled.
---
 arch/arm64/kvm/arm.c      | 11 +++++++++++
 arch/arm64/kvm/guest.c    |  7 +++++++
 arch/arm64/kvm/pmu-emul.c |  3 +++
 arch/arm64/kvm/rme.c      |  8 ++++++++
 arch/arm64/kvm/sys_regs.c |  5 +++--
 include/kvm/arm_pmu.h     |  4 ++++
 6 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0fc76751c034..a090e9a74b46 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -15,6 +15,7 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/mman.h>
+#include <linux/perf/arm_pmu.h>
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
@@ -1234,6 +1235,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	run->flags = 0;
 	while (ret > 0) {
+		bool pmu_stopped = false;
+
 		/*
 		 * Check conditions before entering the guest
 		 */
@@ -1259,6 +1262,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_flush_hwstate(vcpu);
 
+		if (vcpu_is_rec(vcpu) && kvm_pmu_get_irq_level(vcpu)) {
+			pmu_stopped = true;
+			arm_pmu_set_phys_irq(false);
+		}
+
 		local_irq_disable();
 
 		kvm_vgic_flush_hwstate(vcpu);
@@ -1367,6 +1375,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		preempt_enable();
 
+		if (pmu_stopped)
+			arm_pmu_set_phys_irq(true);
+
 		/*
 		 * The ARMv8 architecture doesn't give the hypervisor
 		 * a mechanism to prevent a guest from dropping to AArch32 EL0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 8639a5dfdffd..a6daf6c78383 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -802,6 +802,8 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
 }
 
+#define KVM_REG_ARM_PMCR_EL0		ARM64_SYS_REG(3, 3, 9, 12, 0)
+
 /*
  * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
  * that are available depends on the Realm state and the reason for the last
@@ -816,6 +818,11 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
 		u64 off = core_reg_offset_from_id(reg->id);
 
 		return kvm_realm_validate_core_reg(off);
+	} else {
+		switch (reg->id) {
+		case KVM_REG_ARM_PMCR_EL0:
+			return true;
+		}
 	}
 
 	return false;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab..41331f883780 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -374,6 +374,9 @@ static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
+	if (vcpu_is_rec(vcpu))
+		return vcpu->arch.rec.run->exit.pmu_ovf_status;
+
 	reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 
 	/*
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 4f52bb20c873..e1045a14deca 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -603,6 +603,11 @@ static int realm_create_rd(struct kvm *kvm)
 	params->rtt_base = kvm->arch.mmu.pgd_phys;
 	params->vmid = realm->vmid;
 
+	if (kvm->arch.arm_pmu) {
+		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
+		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
+	}
+
 	params_phys = virt_to_phys(params);
 
 	if (rmi_realm_create(rd_phys, params_phys)) {
@@ -1526,6 +1531,9 @@ int kvm_create_rec(struct kvm_vcpu *vcpu)
 	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
 		return -EINVAL;
 
+	if (vcpu->kvm->arch.arm_pmu && !kvm_vcpu_has_pmu(vcpu))
+		return -EINVAL;
+
 	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
 	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82ffb3b3b3cf..a01a6e06c04d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1220,8 +1220,9 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 * implements. Ignore this error to maintain compatibility
 	 * with the existing KVM behavior.
 	 */
-	if (!kvm_vm_has_ran_once(kvm) &&
-	    !vcpu_has_nv(vcpu)	      &&
+	if (!kvm_vm_has_ran_once(kvm)  &&
+	    !kvm_realm_is_created(kvm) &&
+	    !vcpu_has_nv(vcpu)	       &&
 	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
 		kvm->arch.nr_pmu_counters = new_n;
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b411..da32f1bd9f8c 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -70,6 +70,8 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
 
+#define kvm_pmu_get_irq_level(vcpu) ((vcpu)->arch.pmu.irq_level)
+
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
@@ -157,6 +159,8 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return 0;
 }
 
+#define kvm_pmu_get_irq_level(vcpu) (false)
+
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
-- 
2.43.0


