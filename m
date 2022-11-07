Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE7861EDC4
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 09:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiKGIzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 03:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiKGIy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 03:54:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC6AD138
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 00:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BD7060F5F
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 08:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01294C4347C;
        Mon,  7 Nov 2022 08:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811298;
        bh=kyG/vnN/1STkAGeNbQR0pQg9Qzvo3ZcZrGBKiEYfahw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X865OudT/Wj/ZHaCieW4u7SCVsQX/K3FlAW1fOpeMGwf0OmwfWoTtocf0td164f8c
         356flBVVb7I6DQrZH3LVTKbxFwy4JkRibgMGAxA0J+By4MS6vQ0DzLQsCFFZD4ktIf
         L6OGpCnhK48+17t+BA1rHu8CwPnVdMOEQitDg+D9YGZbqQnUybIIWC84BaQz1tnaSd
         HY+VMuJpqORzu6VXdtGI8Uk4GPZpPZlLbmAph9N7L6GLcLQI967UOpDKF/Rn1W3JHd
         w7jXKF/blCpYWZO/DXw0T/gBYpIBGqoh6RmWIuSo5esgJjWnIPwPhzca9vzV8B2wqA
         zLTpeqm7w2PCg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1orxuC-004KxX-7q;
        Mon, 07 Nov 2022 08:54:56 +0000
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
Subject: [PATCH v3 04/14] KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
Date:   Mon,  7 Nov 2022 08:54:25 +0000
Message-Id: <20221107085435.2581641-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
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

The PMU architecture makes a subtle difference between a 64bit
counter and a counter that has a 64bit overflow. This is for example
the case of the cycle counter, which can generate an overflow on
a 32bit boundary if PMCR_EL0.LC==0 despite the accumulation being
done on 64 bits.

Use this distinction in the few cases where it matters in the code,
as we will reuse this with PMUv3p5 long counters.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 43 ++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e63ed0c71a37..3724acefc07b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -50,6 +50,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
  * @select_idx: The counter index
  */
 static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	return (select_idx == ARMV8_PMU_CYCLE_IDX);
+}
+
+static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
 		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
@@ -57,7 +62,8 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
 
 static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
 {
-	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
+	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
+		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
 }
 
 static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
@@ -97,7 +103,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 		counter += perf_event_read_value(pmc->perf_event, &enabled,
 						 &running);
 
-	if (select_idx != ARMV8_PMU_CYCLE_IDX)
+	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
 		counter = lower_32_bits(counter);
 
 	return counter;
@@ -425,6 +431,23 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 	}
 }
 
+/* Compute the sample period for a given counter value */
+static u64 compute_period(struct kvm_vcpu *vcpu, u64 select_idx, u64 counter)
+{
+	u64 val;
+
+	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
+		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
+			val = -(counter & GENMASK(31, 0));
+		else
+			val = (-counter) & GENMASK(63, 0);
+	} else {
+		val = (-counter) & GENMASK(31, 0);
+	}
+
+	return val;
+}
+
 /**
  * When the perf event overflows, set the overflow status and inform the vcpu.
  */
@@ -444,10 +467,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	 * Reset the sample period to the architectural limit,
 	 * i.e. the point where the counter overflows.
 	 */
-	period = -(local64_read(&perf_event->count));
-
-	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
-		period &= GENMASK(31, 0);
+	period = compute_period(vcpu, idx, local64_read(&perf_event->count));
 
 	local64_set(&perf_event->hw.period_left, 0);
 	perf_event->attr.sample_period = period;
@@ -573,14 +593,13 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 
 	/*
 	 * If counting with a 64bit counter, advertise it to the perf
-	 * code, carefully dealing with the initial sample period.
+	 * code, carefully dealing with the initial sample period
+	 * which also depends on the overflow.
 	 */
-	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
+	if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
 		attr.config1 |= PERF_ATTR_CFG1_COUNTER_64BIT;
-		attr.sample_period = (-counter) & GENMASK(63, 0);
-	} else {
-		attr.sample_period = (-counter) & GENMASK(31, 0);
-	}
+
+	attr.sample_period = compute_period(vcpu, select_idx, counter);
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_pmu_perf_overflow, pmc);
-- 
2.34.1

