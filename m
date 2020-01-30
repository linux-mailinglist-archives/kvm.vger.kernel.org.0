Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5220A14DBDB
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgA3N3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbgA3N3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:29:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059B52082E;
        Thu, 30 Jan 2020 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580390973;
        bh=DN06G2dxpWAOycuHcToJdfweyv7/48x5W6dsO8UhqvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQzxAZN+DSlzh5Pyn6V3qxDXg1htLfX1eSIgVCkP1elAgIfOHESy8t3hLjKoo0YT9
         df+AjaNOagBmLkRwa6mE8GeSs3+rImLTGfuMZG1EHns+8H73sy3GrHJhzkO/Z+ITM+
         sLkf43+2546Rrk1gmjSOBdyZ7w2VwoV6s7YxYcfc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ix9q5-002BmW-5P; Thu, 30 Jan 2020 13:26:33 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Beata Michalska <beata.michalska@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Haibin Wang <wanghaibin.wang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 21/23] KVM: arm64: pmu: Fix chained SW_INCR counters
Date:   Thu, 30 Jan 2020 13:25:56 +0000
Message-Id: <20200130132558.10201-22-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com, wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org, mark.rutland@arm.com, rmk+kernel@armlinux.org.uk, shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org, yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

At the moment a SW_INCR counter always overflows on 32-bit
boundary, independently on whether the n+1th counter is
programmed as CHAIN.

Check whether the SW_INCR counter is a 64b counter and if so,
implement the 64b logic.

Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200124142535.29386-4-eric.auger@redhat.com
---
 virt/kvm/arm/pmu.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 9f605e0b8dd7..560db6282137 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -477,28 +477,45 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
  */
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 {
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	int i;
-	u64 type, enable, reg;
-
-	if (val == 0)
-		return;
 
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
 		return;
 
-	enable = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	/* Weed out disabled counters */
+	val &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+
 	for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
+		u64 type, reg;
+
 		if (!(val & BIT(i)))
 			continue;
-		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
-		       & ARMV8_PMU_EVTYPE_EVENT;
-		if ((type == ARMV8_PMUV3_PERFCTR_SW_INCR)
-		    && (enable & BIT(i))) {
-			reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+
+		/* PMSWINC only applies to ... SW_INC! */
+		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+		type &= ARMV8_PMU_EVTYPE_EVENT;
+		if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
+			continue;
+
+		/* increment this even SW_INC counter */
+		reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+		reg = lower_32_bits(reg);
+		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
+
+		if (reg) /* no overflow on the low part */
+			continue;
+
+		if (kvm_pmu_pmc_is_chained(&pmu->pmc[i])) {
+			/* increment the high counter */
+			reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) + 1;
 			reg = lower_32_bits(reg);
-			__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
-			if (!reg)
-				__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
+			__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) = reg;
+			if (!reg) /* mark overflow on the high counter */
+				__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i + 1);
+		} else {
+			/* mark overflow on low counter */
+			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
 		}
 	}
 }
-- 
2.20.1

