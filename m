Return-Path: <kvm+bounces-57938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9669DB81EF2
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37CCE4A4300
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8112130147D;
	Wed, 17 Sep 2025 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C+9i/VCs"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DA830AD1A
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144102; cv=none; b=WfKP/ed1b9pzMfdsfSWZIWFfLFmh7jFNNOHNEWrhapZ0gyr5Bk4BR1SEAcFoF3WLSsW7DD8wLVnYhQGkToKQvfe8VN9ZMD5uJ5WqjfXOhkTpYFVzn+u0FDZ9rNy9XHAWC9pdzo3VMbWYvurIeIM+lItcpL3AnF3mbKFY+hD6nS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144102; c=relaxed/simple;
	bh=zyDL8cpkBb5/eWK95k21DDwRPtzFV3U7jYgMacBjpvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFg0YEfW5oVLcVCSv6TzSTPeSwdMmnjCY/xmAf4a9RXAjKemJTQMq2DWtGsFLXYq+TKKnOXNkYI5TkZDfpDdSwxUaT9DE7E5dz5RGKqlYv9Z8QOXc7LvI8wDFBEDBzcA1seaHaZKRoujcEHsDCsEJ60EwcUjk35O6IiMoczXh4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C+9i/VCs; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V7mQY3qdCR3hvy95CDRctskrJV5Xhnq7AFeZGsJQX4o=;
	b=C+9i/VCsWpAwC29BijvaMaRZY8BDN8RoD1Jf0fHZrKGgoUW/G4mz5nTbMmdXIBFgh835/5
	7csE2vGh4ValXeKKYVLM/68mC7ERszZ8/6Z/yGJh/04csuS+kdGczT9ugnDJc23YoIEGXK
	Ase1WRq/DBJu+TCfjNhRJwC2fg3Ib/8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 08/13] KVM: arm64: selftests: Select SMCCC conduit based on current EL
Date: Wed, 17 Sep 2025 14:20:38 -0700
Message-ID: <20250917212044.294760-9-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

HVCs are taken within the VM when EL2 is in use. Ensure tests use the
SMC instruction when running at EL2 to interact with the host.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/hypercalls.c      |  2 +-
 tools/testing/selftests/kvm/arm64/kvm-uuid.c        |  2 +-
 tools/testing/selftests/kvm/arm64/psci_test.c       | 10 +++++-----
 .../testing/selftests/kvm/include/arm64/processor.h | 13 +++++++++++++
 tools/testing/selftests/kvm/steal_time.c            |  2 +-
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index 44cfcf8a7f46..bf038a0371f4 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -108,7 +108,7 @@ static void guest_test_hvc(const struct test_hvc_info *hc_info)
 
 	for (i = 0; i < hvc_info_arr_sz; i++, hc_info++) {
 		memset(&res, 0, sizeof(res));
-		smccc_hvc(hc_info->func_id, hc_info->arg1, 0, 0, 0, 0, 0, 0, &res);
+		do_smccc(hc_info->func_id, hc_info->arg1, 0, 0, 0, 0, 0, 0, &res);
 
 		switch (stage) {
 		case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
diff --git a/tools/testing/selftests/kvm/arm64/kvm-uuid.c b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
index af9581b860f1..b5be9133535a 100644
--- a/tools/testing/selftests/kvm/arm64/kvm-uuid.c
+++ b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
@@ -25,7 +25,7 @@ static void guest_code(void)
 {
 	struct arm_smccc_res res = {};
 
-	smccc_hvc(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
+	do_smccc(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
 
 	__GUEST_ASSERT(res.a0 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 &&
 		       res.a1 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 &&
diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
index 0d4680da66d1..98e49f710aef 100644
--- a/tools/testing/selftests/kvm/arm64/psci_test.c
+++ b/tools/testing/selftests/kvm/arm64/psci_test.c
@@ -27,7 +27,7 @@ static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
 {
 	struct arm_smccc_res res;
 
-	smccc_hvc(PSCI_0_2_FN64_CPU_ON, target_cpu, entry_addr, context_id,
+	do_smccc(PSCI_0_2_FN64_CPU_ON, target_cpu, entry_addr, context_id,
 		  0, 0, 0, 0, &res);
 
 	return res.a0;
@@ -38,7 +38,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 {
 	struct arm_smccc_res res;
 
-	smccc_hvc(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level,
+	do_smccc(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level,
 		  0, 0, 0, 0, 0, &res);
 
 	return res.a0;
@@ -48,7 +48,7 @@ static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
 {
 	struct arm_smccc_res res;
 
-	smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
+	do_smccc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
 		  0, 0, 0, 0, 0, &res);
 
 	return res.a0;
@@ -58,7 +58,7 @@ static uint64_t psci_system_off2(uint64_t type, uint64_t cookie)
 {
 	struct arm_smccc_res res;
 
-	smccc_hvc(PSCI_1_3_FN64_SYSTEM_OFF2, type, cookie, 0, 0, 0, 0, 0, &res);
+	do_smccc(PSCI_1_3_FN64_SYSTEM_OFF2, type, cookie, 0, 0, 0, 0, 0, &res);
 
 	return res.a0;
 }
@@ -67,7 +67,7 @@ static uint64_t psci_features(uint32_t func_id)
 {
 	struct arm_smccc_res res;
 
-	smccc_hvc(PSCI_1_0_FN_PSCI_FEATURES, func_id, 0, 0, 0, 0, 0, 0, &res);
+	do_smccc(PSCI_1_0_FN_PSCI_FEATURES, func_id, 0, 0, 0, 0, 0, 0, &res);
 
 	return res.a0;
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 87f50efed720..f037c1bb8e63 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -359,4 +359,17 @@ static __always_inline u64 ctxt_reg_alias(struct kvm_vcpu *vcpu, u32 encoding)
 
 void kvm_get_default_vcpu_target(struct kvm_vm *vm, struct kvm_vcpu_init *init);
 
+static inline unsigned int get_current_el(void)
+{
+	return (read_sysreg(CurrentEL) >> 2) & 0x3;
+}
+
+#define do_smccc(...)				\
+do {						\
+	if (get_current_el() == 2)		\
+		smccc_smc(__VA_ARGS__);		\
+	else					\
+		smccc_hvc(__VA_ARGS__);		\
+} while (0)
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index cce2520af720..8edc1fca345b 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -118,7 +118,7 @@ static int64_t smccc(uint32_t func, uint64_t arg)
 {
 	struct arm_smccc_res res;
 
-	smccc_hvc(func, arg, 0, 0, 0, 0, 0, 0, &res);
+	do_smccc(func, arg, 0, 0, 0, 0, 0, 0, &res);
 	return res.a0;
 }
 
-- 
2.47.3


