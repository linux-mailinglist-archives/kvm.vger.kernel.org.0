Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F0D6270DA
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbiKMQjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiKMQiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:38:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A741D65A8
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:38:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EC4BB80B8A
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 16:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12461C43147;
        Sun, 13 Nov 2022 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668357531;
        bh=3arBPLxr2n7vEE6t4eMmR9rFDMkxqV7WFOx0zNPdYm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZ0BN6ld7ZMINoOJasHNpBmllhfDjWfETxXc6ToJOsOkIu/Kjq21Xx4PrIJqcQAu6
         P+HR473XqrC067VQBJoPpFWuLyGw44dlq7pSkUr2Zf25RbMpj6uinVTknogg2pGpPJ
         gY9RLRvIy4pJb21AlKVfAwCx0jjsfelLvH62KfgiOW4IQq6Uc4iV1K1kxbHjkXvfiP
         UWrPpLaMaT8hNmXarhCuNzUdblFC+9bYsv53ZWJ+NpUwoqV86eYqwu+9cL/kohJrCJ
         FbLmIdzCgkW4hZgInv6bf9nSnvCMQrsUf0HQBQyg9xOR/WnOgO9c4DPxlbU2TbjnmG
         UH9c6j1ayNe0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouG0O-005oYZ-VY;
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
Subject: [PATCH v4 06/16] KVM: arm64: PMU: Only narrow counters that are not 64bit wide
Date:   Sun, 13 Nov 2022 16:38:22 +0000
Message-Id: <20221113163832.3154370-7-maz@kernel.org>
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

The current PMU emulation sometimes narrows counters to 32bit
if the counter isn't the cycle counter. As this is going to
change with PMUv3p5 where the counters are all 64bit, fix
the couple of cases where this happens unconditionally.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9e6bc7edc4de..1fab889dbc74 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -151,20 +151,17 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
  */
 static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 {
-	u64 counter, reg, val;
+	u64 reg, val;
 
 	if (!pmc->perf_event)
 		return;
 
-	counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
+	val = kvm_pmu_get_counter_value(vcpu, pmc->idx);
 
-	if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
+	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		reg = PMCCNTR_EL0;
-		val = counter;
-	} else {
+	else
 		reg = PMEVCNTR0_EL0 + pmc->idx;
-		val = lower_32_bits(counter);
-	}
 
 	__vcpu_sys_reg(vcpu, reg) = val;
 
@@ -414,7 +411,8 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 
 		/* Increment this counter */
 		reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
-		reg = lower_32_bits(reg);
+		if (!kvm_pmu_idx_is_64bit(vcpu, i))
+			reg = lower_32_bits(reg);
 		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
 
 		/* No overflow? move on */
-- 
2.34.1

