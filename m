Return-Path: <kvm+bounces-66150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F456CC7088
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05ACD304967C
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C96357A28;
	Wed, 17 Dec 2025 10:14:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC0E35772F;
	Wed, 17 Dec 2025 10:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966496; cv=none; b=sAuPbqFpQuDkYJA/lg23ZNdjORdvBS6c5Z7quoeGvzgHry+jzF9AUBwLk99AEZN5BpjiYvJGcPK4JsaS37T2OLwAkM8HlKdNHKoyF4Tguu2yZq14MJin0QHJ3dKWtIUqc0EU2PFi9i8F5nAec4Qkv1CGwDTi8zAaI8JU2+dm/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966496; c=relaxed/simple;
	bh=QlLdh5xCPMhscrttbreirMzgU6Nv45eLDbVxMshR2wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKJ/eRtZnL20kZBvrWG4JMQ4ZWLtfyg5iUFgaEyzsUA0ZpSlx+vwmTaiClDW0voCBPwIsrjYMbBEk481P7FFLXGUEbD6Z4hdQKgRv/86rK+2ruaazcD0AGmyai/TGpaFpcZLekji9fR8J7XCF2q+oGT9ewL+Ww+yehxOzV160Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A7C4168F;
	Wed, 17 Dec 2025 02:14:47 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4C483F73B;
	Wed, 17 Dec 2025 02:14:49 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v12 39/46] arm64: RMI: Set breakpoint parameters through SET_ONE_REG
Date: Wed, 17 Dec 2025 10:11:16 +0000
Message-ID: <20251217101125.91098-40-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Allow userspace to configure the number of breakpoints and watchpoints
of a Realm VM through KVM_SET_ONE_REG ID_AA64DFR0_EL1.

The KVM sys_reg handler checks the user value against the maximum value
given by RMM (arm64_check_features() gets it from the
read_sanitised_id_aa64dfr0_el1() reset handler).

Userspace discovers that it can write these fields by issuing a
KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/guest.c    |  2 ++
 arch/arm64/kvm/rmi.c      |  3 +++
 arch/arm64/kvm/sys_regs.c | 17 +++++++++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 14302130d341..7cf919db1adc 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -736,6 +736,7 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 }
 
 #define KVM_REG_ARM_PMCR_EL0		ARM64_SYS_REG(3, 3, 9, 12, 0)
+#define KVM_REG_ARM_ID_AA64DFR0_EL1	ARM64_SYS_REG(3, 0, 0, 5, 0)
 
 /*
  * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
@@ -754,6 +755,7 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
 	} else {
 		switch (reg->id) {
 		case KVM_REG_ARM_PMCR_EL0:
+		case KVM_REG_ARM_ID_AA64DFR0_EL1:
 			return true;
 		}
 	}
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 1c5257636ef1..5f3164539bfe 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -567,6 +567,7 @@ static int realm_create_rd(struct kvm *kvm)
 	void *rd = NULL;
 	phys_addr_t rd_phys, params_phys;
 	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+	u64 dfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
 	int i, r;
 	int rtt_num_start;
 
@@ -603,6 +604,8 @@ static int realm_create_rd(struct kvm *kvm)
 	params->rtt_num_start = rtt_num_start;
 	params->rtt_base = kvm->arch.mmu.pgd_phys;
 	params->vmid = realm->vmid;
+	params->num_bps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
+	params->num_wps = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
 
 	if (kvm->arch.arm_pmu) {
 		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 70b51b5cdea8..f93e37bc77aa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2072,6 +2072,9 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
+	u8 bps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, val);
+	u8 wps = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, val);
+	u8 ctx_cmps = SYS_FIELD_GET(ID_AA64DFR0_EL1, CTX_CMPs, val);
 
 	/*
 	 * Prior to commit 3d0dba5764b9 ("KVM: arm64: PMU: Move the
@@ -2091,10 +2094,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 
 	/*
-	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
-	 * nonzero minimum safe value.
+	 * ID_AA64DFR0_EL1.DebugVer, BRPs and WRPs all have to be greater than
+	 * zero. CTX_CMPs is never greater than BRPs.
 	 */
-	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
+	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP || !bps || !wps ||
+	    ctx_cmps > bps)
 		return -EINVAL;
 
 	if (ignore_feat_doublelock(vcpu, val)) {
@@ -2329,10 +2333,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	mutex_lock(&vcpu->kvm->arch.config_lock);
 
 	/*
-	 * Once the VM has started the ID registers are immutable. Reject any
-	 * write that does not match the final register value.
+	 * Once the VM has started or the Realm descriptor is created, the ID
+	 * registers are immutable. Reject any write that does not match the
+	 * final register value.
 	 */
-	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+	if (kvm_vm_has_ran_once(vcpu->kvm) || kvm_realm_is_created(vcpu->kvm)) {
 		if (val != read_id_reg(vcpu, rd))
 			ret = -EBUSY;
 		else
-- 
2.43.0


