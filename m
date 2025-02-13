Return-Path: <kvm+bounces-38064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17895A349D0
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CC5117288C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1205C28512E;
	Thu, 13 Feb 2025 16:17:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66CB285120;
	Thu, 13 Feb 2025 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463435; cv=none; b=KUuMibFqiDpzK0aJTtx4CIkVG3/TiQMb0hoCKufXkqvyC9ykdlRbKuLYALzQcDhIPtWK11ZGoqCbVLrHDv2Yil7b+tneWMhKzfmHUnIV0iIpf3nDjp66eMklR6BK0LJ/RySv9hHFBZcjSgXWRUEgM9I7h1NPFa4cvhIOMTUZqfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463435; c=relaxed/simple;
	bh=c+UcVRFOOWXTJBy/zbc4vtL6iwYAl2rPOCHem9QndpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWq+b9ziPMoy/MtjKWuBz1qW1s4MivCPhWU9L8rXPxXdW7Ik3uGGT427grtTRrsjWi0f0u8PKw54aYpaRAo1CXb9NLZ06VBWm6RZmQF7M3t6XhiB10NJVLwVI90x8b8dNGQs3GaccRl/jU/37Plh+OEjYb60wrn4hzWFqnUxmYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 332901756;
	Thu, 13 Feb 2025 08:17:34 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4FD83F6A8;
	Thu, 13 Feb 2025 08:17:08 -0800 (PST)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 33/45] arm64: rme: Enable PMU support with a realm guest
Date: Thu, 13 Feb 2025 16:14:13 +0000
Message-ID: <20250213161426.102987-34-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
References: <20250213161426.102987-1-steven.price@arm.com>
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
 arch/arm64/kvm/sys_regs.c |  2 +-
 include/kvm/arm_pmu.h     |  4 ++++
 6 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 25239bf58715..1f3674e95f03 100644
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
@@ -1195,6 +1196,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	run->flags = 0;
 	while (ret > 0) {
+		bool pmu_stopped = false;
+
 		/*
 		 * Check conditions before entering the guest
 		 */
@@ -1226,6 +1229,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_pmu_flush_hwstate(vcpu);
 
+		if (vcpu_is_rec(vcpu) && kvm_pmu_get_irq_level(vcpu)) {
+			pmu_stopped = true;
+			arm_pmu_set_phys_irq(false);
+		}
+
 		local_irq_disable();
 
 		kvm_vgic_flush_hwstate(vcpu);
@@ -1328,6 +1336,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		preempt_enable();
 
+		if (pmu_stopped)
+			arm_pmu_set_phys_irq(true);
+
 		/*
 		 * The ARMv8 architecture doesn't give the hypervisor
 		 * a mechanism to prevent a guest from dropping to AArch32 EL0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d56ac89ca37a..da8961a5d01a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -801,6 +801,8 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
 }
 
+#define KVM_REG_ARM_PMCR_EL0		ARM64_SYS_REG(3, 3, 9, 12, 0)
+
 /*
  * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
  * that are available depends on the Realm state and the reason for the last
@@ -815,6 +817,11 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
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
index 6c5950b9ceac..670e5d15ad92 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -377,6 +377,9 @@ static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
+	if (vcpu_is_rec(vcpu))
+		return vcpu->arch.rec.run->exit.pmu_ovf_status;
+
 	reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 
 	/*
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index e31d86e314dd..f83f34358832 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -370,6 +370,11 @@ static int realm_create_rd(struct kvm *kvm)
 	params->rtt_base = kvm->arch.mmu.pgd_phys;
 	params->vmid = realm->vmid;
 
+	if (kvm->arch.arm_pmu) {
+		params->pmu_num_ctrs = kvm->arch.pmcr_n;
+		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
+	}
+
 	params_phys = virt_to_phys(params);
 
 	if (rmi_realm_create(rd_phys, params_phys)) {
@@ -1489,6 +1494,9 @@ int kvm_create_rec(struct kvm_vcpu *vcpu)
 	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
 		return -EINVAL;
 
+	if (vcpu->kvm->arch.arm_pmu && !kvm_vcpu_has_pmu(vcpu))
+		return -EINVAL;
+
 	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
 	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6cd1ea7fb55..ed881725eb64 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1207,7 +1207,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 * implements. Ignore this error to maintain compatibility
 	 * with the existing KVM behavior.
 	 */
-	if (!kvm_vm_has_ran_once(kvm) &&
+	if (!kvm_vm_has_ran_once(kvm) && !kvm_realm_is_created(kvm) &&
 	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
 		kvm->arch.pmcr_n = new_n;
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 147bd3ee4f7b..46a81f88d0bf 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -76,6 +76,8 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
 
+#define kvm_pmu_get_irq_level(vcpu) ((vcpu)->arch.pmu.irq_level)
+
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
@@ -162,6 +164,8 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return 0;
 }
 
+#define kvm_pmu_get_irq_level(vcpu) (false)
+
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
-- 
2.43.0


