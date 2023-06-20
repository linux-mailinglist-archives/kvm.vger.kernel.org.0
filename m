Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FBA7371CD
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjFTQfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 12:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjFTQeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 12:34:50 -0400
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42754172C
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 09:34:46 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687278884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCY4vHbFRgfnk7DG64yMIt6XfnO84pyEAW1rfPwVAwA=;
        b=rkBG3eNFn3DzQXeYx+RM1pRXNHyBAFf/0ZsbtguSGp4bpFYbSSYCKIoIzwLU18oxLxQRAL
        THg8qQc8denTzXlOhlJqEetI/f2Y980A5XKsenaZDRmC0zRCJSVZHPgrB9oembLnNGiznZ
        i1JXUbAJbDW7Zt+Y/4XTkmy+vWVwdbM=
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
Subject: [PATCH v2 15/20] aarch64: psci: Implement CPU_OFF
Date:   Tue, 20 Jun 2023 11:33:48 -0500
Message-ID: <20230620163353.2688567-16-oliver.upton@linux.dev>
In-Reply-To: <20230620163353.2688567-1-oliver.upton@linux.dev>
References: <20230620163353.2688567-1-oliver.upton@linux.dev>
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

Add support for PSCI CPU_OFF, relying on KVM emulation of a 'powered
off' vCPU by setting the MP state to KVM_MP_STATE_STOPPED.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/psci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index abfdc76..72429b3 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -17,6 +17,7 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	switch (arg) {
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN_CPU_OFF:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -36,6 +37,16 @@ static void cpu_suspend(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	res->a0 = PSCI_RET_SUCCESS;
 }
 
+static void cpu_off(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_STOPPED,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -49,6 +60,9 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_SUSPEND:
 		cpu_suspend(vcpu, res);
 		break;
+	case PSCI_0_2_FN_CPU_OFF:
+		cpu_off(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.162.gfafddb0af9-goog

