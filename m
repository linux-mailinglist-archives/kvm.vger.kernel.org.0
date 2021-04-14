Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06C835F548
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351605AbhDNNoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 09:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351587AbhDNNop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 09:44:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C22611F0;
        Wed, 14 Apr 2021 13:44:24 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lWfoc-007RSZ-Cq; Wed, 14 Apr 2021 14:44:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, nathan@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 1/5] KVM: arm64: Divorce the perf code from oprofile helpers
Date:   Wed, 14 Apr 2021 14:44:05 +0100
Message-Id: <20210414134409.1266357-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414134409.1266357-1-maz@kernel.org>
References: <20210414134409.1266357-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, mark.rutland@arm.com, will@kernel.org, dalias@libc.org, ysato@users.sourceforge.jp, peterz@infradead.org, acme@kernel.org, borntraeger@de.ibm.com, hca@linux.ibm.com, nathan@kernel.org, viresh.kumar@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm64 is the sole user of perf_num_counters(), and really
could do without it. Stop using the obsolete API by relying on
the existing probing code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/perf.c     | 7 +------
 arch/arm64/kvm/pmu-emul.c | 2 +-
 include/kvm/arm_pmu.h     | 4 ++++
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 739164324afe..b8b398670ef2 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -50,12 +50,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 
 int kvm_perf_init(void)
 {
-	/*
-	 * Check if HW_PERF_EVENTS are supported by checking the number of
-	 * hardware performance counters. This could ensure the presence of
-	 * a physical PMU and CONFIG_PERF_EVENT is selected.
-	 */
-	if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0)
+	if (kvm_pmu_probe_pmuver() != 0xf)
 		static_branch_enable(&kvm_arm_pmu_available);
 
 	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e32c6e139a09..fd167d4f4215 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -739,7 +739,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
-static int kvm_pmu_probe_pmuver(void)
+int kvm_pmu_probe_pmuver(void)
 {
 	struct perf_event_attr attr = { };
 	struct perf_event *event;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6fd3cda608e4..864b9997efb2 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -61,6 +61,7 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
+int kvm_pmu_probe_pmuver(void);
 #else
 struct kvm_pmu {
 };
@@ -116,6 +117,9 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 {
 	return 0;
 }
+
+static inline int kvm_pmu_probe_pmuver(void) { return 0xf; }
+
 #endif
 
 #endif
-- 
2.29.2

