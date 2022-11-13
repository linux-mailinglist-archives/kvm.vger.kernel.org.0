Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB136270D7
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbiKMQjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiKMQix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:38:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6A210FDD
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:38:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEDAE60C40
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 16:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5CEC43148;
        Sun, 13 Nov 2022 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668357531;
        bh=48fsaGqAMfL5ZHCFsJbttKfUDmoQwQleUQL6Ng5eK84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/B75BoyCCHEzSCxX0EEHHgs6BcBePQIBcMwoAfdDKSiu5V+CTrNdoOfV2B+Gh9ye
         6zRXDGLOfnnPwpzvj4OVn4qp716J5w0DW1yb71LNy3zYu0j7k4NEflUtiGTJAIxavZ
         Jpdx4z9ZaU6fJ7YdL8/2JnE4+oF8Ju+tCawL2srhYCFk0lHgXW9xIGbhM9kE85RWzO
         8Rdsc2VkKm9Nu302C1GqC2OZbEqOeEQd1Biis4MUv2acsU/uqQVMdz/QM2NxXTYAv1
         UofSyUUFEEuodKm30Z7APi4WlrVTlQw2IYj7ZpL3iJHnd0g3TBCRU7GTnc1sywhRiu
         LaSX/SWG2uLxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouG0P-005oYZ-JB;
        Sun, 13 Nov 2022 16:38:49 +0000
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
Subject: [PATCH v4 09/16] KVM: arm64: PMU: Do not let AArch32 change the counters' top 32 bits
Date:   Sun, 13 Nov 2022 16:38:25 +0000
Message-Id: <20221113163832.3154370-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when using PMUv3p5 (which implies 64bit counters), there is
no way for AArch32 to write to the top 32 bits of the counters.
The only way to influence these bits (other than by counting
events) is by writing PMCR.P==1.

Make sure we obey the architecture and preserve the top 32 bits
on a counter update.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ea0c8411641f..419e5e0a13d0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -119,13 +119,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	return counter;
 }
 
-/**
- * kvm_pmu_set_counter_value - set PMU counter value
- * @vcpu: The vcpu pointer
- * @select_idx: The counter index
- * @val: The counter value
- */
-void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
+static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 select_idx, u64 val,
+				bool force)
 {
 	u64 reg;
 
@@ -135,12 +130,36 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
 
 	reg = counter_index_to_reg(select_idx);
+
+	if (vcpu_mode_is_32bit(vcpu) && select_idx != ARMV8_PMU_CYCLE_IDX &&
+	    !force) {
+		/*
+		 * Even with PMUv3p5, AArch32 cannot write to the top
+		 * 32bit of the counters. The only possible course of
+		 * action is to use PMCR.P, which will reset them to
+		 * 0 (the only use of the 'force' parameter).
+		 */
+		val  = lower_32_bits(val);
+		val |= upper_32_bits(__vcpu_sys_reg(vcpu, reg));
+	}
+
 	__vcpu_sys_reg(vcpu, reg) = val;
 
 	/* Recreate the perf event to reflect the updated sample_period */
 	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
+/**
+ * kvm_pmu_set_counter_value - set PMU counter value
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ * @val: The counter value
+ */
+void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
+{
+	kvm_pmu_set_counter(vcpu, select_idx, val, false);
+}
+
 /**
  * kvm_pmu_release_perf_event - remove the perf event
  * @pmc: The PMU counter pointer
@@ -533,7 +552,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
-			kvm_pmu_set_counter_value(vcpu, i, 0);
+			kvm_pmu_set_counter(vcpu, i, 0, true);
 	}
 }
 
-- 
2.34.1

