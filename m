Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B58DCADC4
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 20:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfJCSCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 14:02:04 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:37310 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727793AbfJCSCD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Oct 2019 14:02:03 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iG4ps-0003xB-EA; Thu, 03 Oct 2019 19:24:16 +0200
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Julien Thierry Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH] KVM: arm64: pmu: Fix cycle counter truncation on counter stop
Date:   Thu,  3 Oct 2019 18:24:00 +0100
Message-Id: <20191003172400.21157-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com, andrew.murray@arm.com, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a counter is disabled, its value is sampled before the event
is being disabled, and the value written back in the shadow register.

In that process, the value gets truncated to 32bit, which is adequate
for any counter but the cycle counter, which can be configured to
hold a 64bit value. This obviously results in a corrupted counter,
and things like "perf record -e cycles" not working at all when
run in a guest...

Make the truncation conditional on the counter not being 64bit.

Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
Cc: Andrew Murray <andrew.murray@arm.com>
Reported-by: Julien Thierry Julien Thierry <julien.thierry.kdev@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 362a01886bab..d716aef2bae9 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -206,9 +206,11 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
 		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
 	} else {
+		if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+			counter = lower_32_bits(counter);
 		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
-		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
+		__vcpu_sys_reg(vcpu, reg) = counter;
 	}
 
 	kvm_pmu_release_perf_event(pmc);
-- 
2.20.1

