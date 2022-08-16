Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959F559631C
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 21:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiHPT0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 15:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiHPT0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 15:26:11 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F27E659EB
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 12:26:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660677969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCCaUkqGTfSOC9Q7jycETJL5i/VHIINjDkTfwGnQnIE=;
        b=wFvE44s/1zjD8BxtwFuYMS01bGyTRQJ+XIqx/lctvnjMxLrFvFE6CcY1055RYbE2wXdwk2
        DmjV75mcLMOOcqo03Sd1mWud6JOmCXehWH0BI1bQNH6bnDorKfWKZAyD+WUs3Lr+bNv1rU
        Pdkyrc51m5gzNVnBQtQ1XJqiek9UTk8=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/2] KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
Date:   Tue, 16 Aug 2022 19:25:53 +0000
Message-Id: <20220816192554.1455559-2-oliver.upton@linux.dev>
In-Reply-To: <20220816192554.1455559-1-oliver.upton@linux.dev>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM does not support AArch32 on asymmetric systems. To that end, enforce
AArch64-only behavior on PMCR_EL1.LC when on an asymmetric system.

Fixes: 2122a833316f ("arm64: Allow mismatched 32-bit EL0 support")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f38ef299f13b..e9c9388ccc02 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -929,6 +929,10 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
 
+#define kvm_supports_32bit_el0()				\
+	(system_supports_32bit_el0() &&				\
+	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 986cee6fbc7f..2ff0ef62abad 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -757,8 +757,7 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 	if (likely(!vcpu_mode_is_32bit(vcpu)))
 		return false;
 
-	return !system_supports_32bit_el0() ||
-		static_branch_unlikely(&arm64_mismatched_32bit_el0);
+	return !kvm_supports_32bit_el0();
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c059b259aea6..3234f50b8c4b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -652,7 +652,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 */
 	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
-	if (!system_supports_32bit_el0())
+	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
@@ -701,7 +701,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
-		if (!system_supports_32bit_el0())
+		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
-- 
2.37.1.595.g718a3a8f04-goog

