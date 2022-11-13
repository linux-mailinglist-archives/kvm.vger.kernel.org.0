Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A826270DD
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiKMQjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiKMQiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:38:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A778710561
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:38:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E8B1B80BED
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 16:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC6C43145;
        Sun, 13 Nov 2022 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668357531;
        bh=gPft3DPvxUWOEFc3v+6Whz4gx4KzMWahijq0FVBWNL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQ5g+3eAJhs0+4XEo+0poOnQG+6QWuro3QRT9wuRVqvpskJktEucqpzNlsUG/Klly
         zrF/FzXu5pgftkdRWY7vIbVq2cW0CgUq89SyQzZWAiGukXM9BH97RHBD9kzTOdtrOj
         dHW2QjM4+AVsz36x/+m0lbKjqzIuSjFQRyIlAkRHGIoWNI7VHgxaUcWJWcGkjmI1e2
         vTgpfZJy9Tz+rfj4ktJ/VtiNiyaXEfe5owXfaEz2TNzMZZUQBl0jBjhYOLgE9fhNH3
         12NpCFfm+fTvLM2Cz9+pSRegcAfmJxH7GXbI5oO+KaMxCi2fIyvE99EH7M8C6ijKwH
         RvMQFJp/uYlDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouG0P-005oYZ-5c;
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
Subject: [PATCH v4 07/16] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
Date:   Sun, 13 Nov 2022 16:38:23 +0000
Message-Id: <20221113163832.3154370-8-maz@kernel.org>
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

In order to reduce the boilerplate code, add two helpers returning
the counter register index (resp. the event register) in the vcpu
register file from the counter index.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 1fab889dbc74..faab0f57a45d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -77,6 +77,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
 	return container_of(vcpu_arch, struct kvm_vcpu, arch);
 }
 
+static u32 counter_index_to_reg(u64 idx)
+{
+	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
+}
+
+static u32 counter_index_to_evtreg(u64 idx)
+{
+	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
+}
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -91,8 +101,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return 0;
 
-	reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-		? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
+	reg = counter_index_to_reg(select_idx);
 	counter = __vcpu_sys_reg(vcpu, reg);
 
 	/*
@@ -122,8 +131,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
+	reg = counter_index_to_reg(select_idx);
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 
 	/* Recreate the perf event to reflect the updated sample_period */
@@ -158,10 +166,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 
 	val = kvm_pmu_get_counter_value(vcpu, pmc->idx);
 
-	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-		reg = PMCCNTR_EL0;
-	else
-		reg = PMEVCNTR0_EL0 + pmc->idx;
+	reg = counter_index_to_reg(pmc->idx);
 
 	__vcpu_sys_reg(vcpu, reg) = val;
 
@@ -404,16 +409,16 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 		u64 type, reg;
 
 		/* Filter on event type */
-		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+		type = __vcpu_sys_reg(vcpu, counter_index_to_evtreg(i));
 		type &= kvm_pmu_event_mask(vcpu->kvm);
 		if (type != event)
 			continue;
 
 		/* Increment this counter */
-		reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+		reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
 		if (!kvm_pmu_idx_is_64bit(vcpu, i))
 			reg = lower_32_bits(reg);
-		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
+		__vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
 
 		/* No overflow? move on */
 		if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
@@ -549,8 +554,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	struct perf_event_attr attr;
 	u64 eventsel, counter, reg, data;
 
-	reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
+	reg = counter_index_to_evtreg(select_idx);
 	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
@@ -632,8 +636,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
+	reg = counter_index_to_evtreg(select_idx);
 
 	__vcpu_sys_reg(vcpu, reg) = data & mask;
 
-- 
2.34.1

