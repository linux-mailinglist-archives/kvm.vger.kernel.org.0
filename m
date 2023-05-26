Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4F2712FDF
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244427AbjEZWS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244432AbjEZWSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:18:25 -0400
Received: from out-37.mta0.migadu.com (out-37.mta0.migadu.com [IPv6:2001:41d0:1004:224b::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E222010A
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:58 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gW9BKqPiwrZ9eSvuZAq2r2paaDTsCn/8hO5qeUkvyvc=;
        b=SRUbdgwFO1dCNESWfNK/7gMxj9Db090FuD1N6SpZs1isTubdn3WGkxPobxLwrc4UbsGZS3
        Ktg170LIpIg10WC3zmmqLeG72tU6RtAZa0kiWvsGnOZcCFVlhO1z5qMxhwljib8L0HLt5Z
        OVcZ2383aUfKlfjvlCKyEut2kkcDjto=
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
Subject: [PATCH kvmtool 17/21] aarch64: psci: Implement CPU_ON
Date:   Fri, 26 May 2023 22:17:08 +0000
Message-ID: <20230526221712.317287-18-oliver.upton@linux.dev>
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

Add support for the PSCI CPU_ON call, wherein a caller can power on a
targeted CPU and reset it with the provided context (i.e. entrypoint and
context id). Rely on the KVM_ARM_VCPU_INIT ioctl, which has the effect
of an architectural warm reset, to do the heavy lifting.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/psci.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index 72429b36a835..7bd3ba9d9d75 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -18,6 +18,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
 	case PSCI_0_2_FN_CPU_OFF:
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -47,6 +49,67 @@ static void cpu_off(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		die_perror("KVM_SET_MP_STATE failed");
 }
 
+static void reset_cpu_with_context(struct kvm_cpu *vcpu, u64 entry_addr, u64 ctx_id)
+{
+	struct kvm_one_reg reg;
+
+	kvm_cpu__arm_reset(vcpu);
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
+	kvm_cpu__pause_vm(vcpu);
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
+	kvm_cpu__continue_vm(vcpu);
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -63,6 +126,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
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
2.41.0.rc0.172.g3f132b7071-goog

