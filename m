Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84241712FDD
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244430AbjEZWSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjEZWSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:18:11 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F31E5A
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p5ZProBAdzCbDVF65eMfiEsUG7+QyRJw/6R/yjscKH0=;
        b=RAdJpWXfYqV97FeioiCQTbXtEoJCRAOtnnC4o8NgpzUlM4KaObGi2J+h/NlxljagqIINpE
        BljGf94DkyOPB5wgtZM5IJS9wv08oMy/kMz7PMZn5aukgYF5iLxPuvxHUYD/3h5H4o43Qv
        eRyU8dGIJ+gPpoV3HnjcjEDo31qdrs8=
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
Subject: [PATCH kvmtool 15/21] aarch64: psci: Implement CPU_SUSPEND
Date:   Fri, 26 May 2023 22:17:06 +0000
Message-ID: <20230526221712.317287-16-oliver.upton@linux.dev>
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

Implement support for PSCI CPU_SUSPEND, leveraging in-kernel suspend
emulation (i.e. a WFI state). Eagerly resume the vCPU for any wakeup
event.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/kvm-cpu.c | 18 ++++++++++++++++++
 arm/aarch64/psci.c    | 19 +++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 4feed9f41cb0..316e20c7f157 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -263,6 +263,16 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 	dprintf(debug_fd, " LR:    0x%lx\n", data);
 }
 
+static void handle_wakeup(struct kvm_cpu *vcpu)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_RUNNABLE,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 {
 	struct kvm_run *run = vcpu->kvm_run;
@@ -271,6 +281,14 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 	case KVM_EXIT_HYPERCALL:
 		handle_hypercall(vcpu);
 		return true;
+	case KVM_EXIT_SYSTEM_EVENT:
+		switch (run->system_event.type) {
+		case KVM_SYSTEM_EVENT_WAKEUP:
+			handle_wakeup(vcpu);
+			return true;
+		default:
+			return false;
+		}
 	default:
 		return false;
 	}
diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index 482b9a7442c6..abfdc764b7e0 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -15,12 +15,27 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		return;
 
 	switch (arg) {
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
 	}
 }
 
+static void cpu_suspend(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_SUSPENDED,
+	};
+
+	/* Rely on in-kernel emulation of a 'suspended' (i.e. WFI) state. */
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+
+	res->a0 = PSCI_RET_SUCCESS;
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -30,6 +45,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_1_0_FN_PSCI_FEATURES:
 		psci_features(vcpu, res);
 		break;
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		cpu_suspend(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.rc0.172.g3f132b7071-goog

