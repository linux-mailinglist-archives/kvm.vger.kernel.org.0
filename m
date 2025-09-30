Return-Path: <kvm+bounces-59149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D057CBAC826
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7FA0194095D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C7B2FFF91;
	Tue, 30 Sep 2025 10:32:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA952FFDFA;
	Tue, 30 Sep 2025 10:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228340; cv=none; b=nL5f7IcEV/8Db1y8z/+enHPJdRhPsaPoBOg05QzDMqXJSFtJQSMCbssJvZLK1r6MlhN59RAPTcRqJEk07JiSoOVz1sfFWS6kr34fmxCiP/BfeBcIuRP08jJ6Fottyw8wTKDw0HnREPO1Qe7uWLHhcu1bPHsM+RTISKF8bTdHFgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228340; c=relaxed/simple;
	bh=1FA/Ah+2pQ73gkbgETv3FtWerHjKfK0SajNi6gCGPjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkLmX6lmXbQbsDrKjIuu00elMxkYUSqa9cIPfT9qHc60eAfmoXDEHDag1LFHKf0EXWAlkithj09+mxbOsXOHYSRaTiSG2QeXZjq0yY55415Og6cFrfCAtfUZRqXAYLwmjiO4D3NP309WB0FJEQFTLmoXWtHubUhPcgrUNEuE6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3E6F25E0;
	Tue, 30 Sep 2025 03:32:10 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5967A3F66E;
	Tue, 30 Sep 2025 03:32:17 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool v4 11/15] arm64: psci: Implement CPU_ON
Date: Tue, 30 Sep 2025 11:31:26 +0100
Message-ID: <20250930103130.197534-13-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930103130.197534-1-suzuki.poulose@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Add support for the PSCI CPU_ON call, wherein a caller can power on a
targeted CPU and reset it with the provided context (i.e. entrypoint and
context id). Rely on the KVM_ARM_VCPU_INIT ioctl, which has the effect
of an architectural warm reset, to do the heavy lifting.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/psci.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arm64/psci.c b/arm64/psci.c
index 72429b36..14c98639 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -18,6 +18,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
 	case PSCI_0_2_FN_CPU_OFF:
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -47,6 +49,68 @@ static void cpu_off(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		die_perror("KVM_SET_MP_STATE failed");
 }
 
+static void reset_cpu_with_context(struct kvm_cpu *vcpu, u64 entry_addr, u64 ctx_id)
+{
+	struct kvm_one_reg reg;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_INIT, &vcpu->init))
+		die_perror("KVM_ARM_VCPU_INIT failed");
+
+	reg = (struct kvm_one_reg) {
+		.id	= ARM64_CORE_REG(regs.pc),
+		.addr	= (u64)&entry_addr,
+	};
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+		die_perror("KVM_SET_ONE_REG failed");
+
+	reg = (struct kvm_one_reg) {
+		.id	= ARM64_CORE_REG(regs.regs[0]),
+		.addr	= (u64)&ctx_id,
+	};
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+		die_perror("KVM_SET_ONE_REG failed");
+}
+
+static bool psci_valid_affinity(u64 affinity)
+{
+	return !(affinity & ~ARM_MPIDR_HWID_BITMASK);
+}
+
+static void cpu_on(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u64 target_mpidr = smccc_get_arg(vcpu, 1);
+	u64 entry_addr = smccc_get_arg(vcpu, 2);
+	u64 ctx_id = smccc_get_arg(vcpu, 3);
+	struct kvm_mp_state mp_state;
+	struct kvm_cpu *target;
+
+	if (!psci_valid_affinity(target_mpidr)) {
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+		return;
+	}
+
+	kvm__pause(vcpu->kvm);
+
+	target = kvm__arch_mpidr_to_vcpu(vcpu->kvm, target_mpidr);
+	if (!target) {
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+		goto out_continue;
+	}
+
+	if (ioctl(target->vcpu_fd, KVM_GET_MP_STATE, &mp_state))
+		die_perror("KVM_GET_MP_STATE failed");
+
+	if (mp_state.mp_state != KVM_MP_STATE_STOPPED) {
+		res->a0 = PSCI_RET_ALREADY_ON;
+		goto out_continue;
+	}
+
+	reset_cpu_with_context(target, entry_addr, ctx_id);
+	res->a0 = PSCI_RET_SUCCESS;
+out_continue:
+	kvm__continue(vcpu->kvm);
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -63,6 +127,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_CPU_OFF:
 		cpu_off(vcpu, res);
 		break;
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
+		cpu_on(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0


