Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963AC610F7C
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 13:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJ1LQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 07:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJ1LQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 07:16:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3741D0D7E
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 04:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52FC3B803F6
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 11:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9ECC433D6;
        Fri, 28 Oct 2022 11:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666955793;
        bh=pMK0VXNhD7ycsvN+xi1LZVqmI2jIAvm0ksqg3FfwXh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3o+gJ/Sr4Fz08PNNXvuVxHSV3rWn5kspn3dBz3HNX6dCoOmIxs1QgHz3tMYbc6f7
         rDz9kkIxhQCBNuHPenfV2dSyciHSD40dn2fHKeyyyMrLS6mZkbaAxYpbxVzu32hHXI
         oj52p06rTWsYpbO+tTeUi4/5x8XiXV0VGYB07ppVHYjCRq1XQZg0cHioQvSvjGdruO
         qJBZP20CsSsTyJiyGZ9K/CwrlFjWvNyfSn474FbM/DwuUqfzMA+CVqXVTWmoq4v3cT
         LI683DvHnlNR2Mbe1/g6Vzo+NtJzGz0H/HuCfTWHY54pwgkhoxIIDE1YWakG3E+qUV
         l89mealSXP7iA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ooN0A-002E4C-CL;
        Fri, 28 Oct 2022 11:54:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v2 13/14] KVM: arm64: PMU: Implement PMUv3p5 long counter support
Date:   Fri, 28 Oct 2022 11:54:01 +0100
Message-Id: <20221028105402.2030192-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028105402.2030192-1-maz@kernel.org>
References: <20221028105402.2030192-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
features:

- All counters are 64bit

- The overflow point is controlled by the PMCR_EL0.LP bit

Add the required checks in the helpers that control counter
width and overflow, as well as the sysreg handling for the LP
bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
PMUv3p5 specific handling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 8 +++++---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 include/kvm/arm_pmu.h     | 7 +++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f126b45aa6c6..dc163e1a1fcf 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -52,13 +52,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
  */
 static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	return (select_idx == ARMV8_PMU_CYCLE_IDX);
+	return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
 }
 
 static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
-		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
+	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+
+	return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
+	       (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
 }
 
 static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 603d2b43e8ce..8f4412cd4bf6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
 	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
+	if (!kvm_pmu_is_3p5(vcpu))
+		val &= ~ARMV8_PMU_PMCR_LP;
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
@@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
+		if (!kvm_pmu_is_3p5(vcpu))
+			val &= ~ARMV8_PMU_PMCR_LP;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
 		kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 812f729c9108..3d526df9f3c5 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -89,6 +89,12 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
+/*
+ * Evaluates as true when emulating PMUv3p5, and false otherwise.
+ */
+#define kvm_pmu_is_3p5(vcpu)						\
+	(vcpu->kvm->arch.dfr0_pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
 #else
@@ -153,6 +159,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 }
 
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
+#define kvm_pmu_is_3p5(vcpu)		({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
-- 
2.34.1

