Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D76712FE0
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbjEZWS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244431AbjEZWS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:18:27 -0400
Received: from out-1.mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE2319C
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:18:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JpFLyH8IT44flboYFu+zqZryYdBFcijp7J6b2FkLdSU=;
        b=dEumr27VL75Ab1mNv5cYX+C2+pScbWxyPIs1qioG52w8CsmB8pPzSPuCy7lzp5ukjAnj5X
        iG/kqdaBxa36SymKwpZ+OhKetqA1P2Zwn/nTn/fFK3/0C12G8Pgc6jmsuqYUbrIm/qz8Wa
        vRkyPmTDraqV+SViU+JLAmnIXCeG0DY=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 18/21] aarch64: psci: Implement AFFINITY_INFO
Date:   Fri, 26 May 2023 22:17:09 +0000
Message-ID: <20230526221712.317287-19-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement support for PSCI AFFINITY_INFO by iteratively searching all of
the vCPUs in a VM for those that match the specified affinity. Pause the
VM to avoid racing against other PSCI calls in the system that might
change the power state of the vCPUs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-cpu-arch.h | 12 +++++-
 arm/aarch64/psci.c                     | 59 ++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 264d0016f7db..5dced04d4035 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -5,12 +5,22 @@
 
 #include "arm-common/kvm-cpu-arch.h"
 
-#define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 #define ARM_CPU_CTRL		3, 0, 1, 0
 #define ARM_CPU_CTRL_SCTLR_EL1	0
 
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
diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index 7bd3ba9d9d75..e32c47e6a2c9 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
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
@@ -110,6 +122,49 @@ out_continue:
 	kvm_cpu__continue_vm(vcpu);
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
+	kvm_cpu__pause_vm(vcpu);
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
+	kvm_cpu__continue_vm(vcpu);
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -130,6 +185,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
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
2.41.0.rc0.172.g3f132b7071-goog

