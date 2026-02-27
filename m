Return-Path: <kvm+bounces-72189-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPcoLwnPoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72189-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E281BB2FD
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 290E531BFA8B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5B835BDB7;
	Fri, 27 Feb 2026 17:00:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9766135C1BC
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211600; cv=none; b=oUkqG3jWwuuAtxAZyKfGXan0eSV1IX9u4HeMttcjllG3G/cxKCukzgVVhpZnxVdKdtRrPT+5jCzFX2UnAX8y9Y1vIWnShSvnsIkU7FA2K5Uh6I2g6WFAeSX0a+5fZq9XE5TWF5cLNvR2YDxrH1zziP67ByOtjzUQJ7Dg15TlR5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211600; c=relaxed/simple;
	bh=0wb/UP6K5ikFmLshj6PNreIcmQ3EuRsKvxwe6jyPGMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2ecONXfpC3JbbPCnI0gNmR5s8OkChTshaSQ1J/tXBIlt6C+pIqL3uxi2E23geo+JXeNTYNtcuq3mByWdIxWZygCtVFT9ZnJrpf4P9y3W3WjoJDTsoUMTk5UsoDIjdLx7WOBwVrFudQbJVHEaGMjWoFb2/MXsKMGcZ8eYHS5vhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 371C5176B;
	Fri, 27 Feb 2026 08:59:52 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2FAAA3F73B;
	Fri, 27 Feb 2026 08:59:57 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 13/17] arm64: psci: Implement CPU_ON
Date: Fri, 27 Feb 2026 16:56:20 +0000
Message-ID: <20260227165624.1519865-14-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72189-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.964];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email,linux.dev:email]
X-Rspamd-Queue-Id: 64E281BB2FD
X-Rspamd-Action: no action

From: Oliver Upton <oliver.upton@linux.dev>

Add support for the PSCI CPU_ON call, wherein a caller can power on a
targeted CPU and reset it with the provided context (i.e. entrypoint and
context id). Rely on the KVM_ARM_VCPU_INIT ioctl, which has the effect
of an architectural warm reset, to do the heavy lifting.

Reviewed-by: Marc Zyngier <maz@kernel.org>
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


