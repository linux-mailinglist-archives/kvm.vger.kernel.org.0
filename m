Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2619635A6
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfGIMZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:41 -0400
Received: from foss.arm.com ([217.140.110.172]:42762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfGIMZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 387F51570;
        Tue,  9 Jul 2019 05:25:40 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BF1D3F59C;
        Tue,  9 Jul 2019 05:25:38 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/18] KVM: arm/arm64: Extract duplicated code to own function
Date:   Tue,  9 Jul 2019 13:24:59 +0100
Message-Id: <20190709122507.214494-11-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709122507.214494-1-marc.zyngier@arm.com>
References: <20190709122507.214494-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

Let's reduce code duplication by extracting common code to its own
function.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/pmu.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 99e51ee8fd9e..efdc7f6db6cd 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -53,6 +53,19 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 }
 
+/**
+ * kvm_pmu_release_perf_event - remove the perf event
+ * @pmc: The PMU counter pointer
+ */
+static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		perf_event_disable(pmc->perf_event);
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+	}
+}
+
 /**
  * kvm_pmu_stop_counter - stop PMU counter
  * @pmc: The PMU counter pointer
@@ -68,9 +81,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
 		__vcpu_sys_reg(vcpu, reg) = counter;
-		perf_event_disable(pmc->perf_event);
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
+		kvm_pmu_release_perf_event(pmc);
 	}
 }
 
@@ -101,15 +112,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
-		struct kvm_pmc *pmc = &pmu->pmc[i];
-
-		if (pmc->perf_event) {
-			perf_event_disable(pmc->perf_event);
-			perf_event_release_kernel(pmc->perf_event);
-			pmc->perf_event = NULL;
-		}
-	}
+	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
+		kvm_pmu_release_perf_event(&pmu->pmc[i]);
 }
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
-- 
2.20.1

