Return-Path: <kvm+bounces-72190-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDmEBw/PoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72190-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC6A1BB30B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 830F331C1626
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB4335A39C;
	Fri, 27 Feb 2026 17:00:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66BC93570C1
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211601; cv=none; b=bkxGPPLVYuZ7HiI+6UooWQf8gZsfeoPYSWoQEvwKyhTZ5+Cp8/jxL0GTHktrGe9e6EyOpnCAq+dxpFVnDAjq1j8C1eb5MjHM7k414us9TnJV2UEPq/OQiO6XzaldtGb1QDidxkInzBZagiy64/3+F0VljuuGhkcENuIvGqFY/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211601; c=relaxed/simple;
	bh=buXKF6E8KWZCWobkkDmt7c176g0HkmhdztV5Okvm7jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK3A7MEg4mWIT81Kw4FMhT1CHHyUZUTxI+EdGgIUZ9lZ07PeKZKnrxvOl1yFq/vx0tm5LfZGUmKVhS9oqDfm9/utm2cdMTEwbQ1kLcApOVWKxUPBQYanIk4NA7tFQorTtIFa6mda3Tj+oCc6JCced8q7vGuPZMKjAkphYD9V4vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7B8014BF;
	Fri, 27 Feb 2026 08:59:53 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C09973F73B;
	Fri, 27 Feb 2026 08:59:58 -0800 (PST)
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
Subject: [kvmtool PATCH v6 14/17] arm64: psci: Implement AFFINITY_INFO
Date: Fri, 27 Feb 2026 16:56:21 +0000
Message-ID: <20260227165624.1519865-15-suzuki.poulose@arm.com>
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
	TAGGED_FROM(0.00)[bounces-72190-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.960];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email,linux.dev:email]
X-Rspamd-Queue-Id: 7BC6A1BB30B
X-Rspamd-Action: no action

From: Oliver Upton <oliver.upton@linux.dev>

Implement support for PSCI AFFINITY_INFO by iteratively searching all of
the vCPUs in a VM for those that match the specified affinity. Pause the
VM to avoid racing against other PSCI calls in the system that might
change the power state of the vCPUs.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h | 12 ++++++-
 arm64/psci.c                     | 59 ++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index dbd90647..d9eb5f0e 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -7,7 +7,6 @@
 #include <pthread.h>
 #include <stdbool.h>
 
-#define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 #define ARM_CPU_CTRL		3, 0, 1, 0
@@ -67,6 +66,17 @@ unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu);
 int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
 int kvm_cpu__teardown_pvtime(struct kvm *kvm);
 
+#define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
+#define ARM_MPIDR_LEVEL_BITS_SHIFT	3
+#define ARM_MPIDR_LEVEL_BITS	(1 << ARM_MPIDR_LEVEL_BITS_SHIFT)
+#define ARM_MPIDR_LEVEL_MASK	((1 << ARM_MPIDR_LEVEL_BITS) - 1)
+
+#define ARM_MPIDR_LEVEL_SHIFT(level) \
+	(((1 << level) >> 1) << ARM_MPIDR_LEVEL_BITS_SHIFT)
+
+#define ARM_MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> ARM_MPIDR_LEVEL_SHIFT(level)) & ARM_MPIDR_LEVEL_MASK)
+
 static inline __u64 __core_reg_id(__u64 offset)
 {
 	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
diff --git a/arm64/psci.c b/arm64/psci.c
index 14c98639..94e39d40 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -6,6 +6,16 @@
 #include <linux/psci.h>
 #include <linux/types.h>
 
+#define AFFINITY_MASK(level)	~((0x1UL << ((level) * ARM_MPIDR_LEVEL_BITS)) - 1)
+
+static unsigned long psci_affinity_mask(unsigned long affinity_level)
+{
+	if (affinity_level <= 3)
+		return ARM_MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
+
+	return 0;
+}
+
 static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	u32 arg = smccc_get_arg(vcpu, 1);
@@ -20,6 +30,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_CPU_OFF:
 	case PSCI_0_2_FN_CPU_ON:
 	case PSCI_0_2_FN64_CPU_ON:
+	case PSCI_0_2_FN_AFFINITY_INFO:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -111,6 +123,49 @@ out_continue:
 	kvm__continue(vcpu->kvm);
 }
 
+static void affinity_info(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u64 target_affinity = smccc_get_arg(vcpu, 1);
+	u64 lowest_level = smccc_get_arg(vcpu, 2);
+	u64 mpidr_mask = psci_affinity_mask(lowest_level);
+	struct kvm *kvm = vcpu->kvm;
+	bool matched = false;
+	int i;
+
+	if (!psci_valid_affinity(target_affinity) || lowest_level > 3) {
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+		return;
+	}
+
+	kvm__pause(vcpu->kvm);
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_cpu *tmp = kvm->cpus[i];
+		u64 mpidr = kvm_cpu__get_vcpu_mpidr(tmp);
+		struct kvm_mp_state mp_state;
+
+		if ((mpidr & mpidr_mask) != target_affinity)
+			continue;
+
+		if (ioctl(tmp->vcpu_fd, KVM_GET_MP_STATE, &mp_state))
+			die_perror("KVM_GET_MP_STATE failed");
+
+		if (mp_state.mp_state != KVM_MP_STATE_STOPPED) {
+			res->a0 = PSCI_0_2_AFFINITY_LEVEL_ON;
+			goto out_continue;
+		}
+
+		matched = true;
+	}
+
+	if (matched)
+		res->a0 = PSCI_0_2_AFFINITY_LEVEL_OFF;
+	else
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+out_continue:
+	kvm__continue(vcpu->kvm);
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -131,6 +186,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_ON:
 		cpu_on(vcpu, res);
 		break;
+	case PSCI_0_2_FN_AFFINITY_INFO:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+		affinity_info(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0


