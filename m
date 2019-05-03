Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB17512E68
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfECMr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:56 -0400
Received: from foss.arm.com ([217.140.101.70]:32962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbfECMr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B596B169E;
        Fri,  3 May 2019 05:47:55 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DF413F220;
        Fri,  3 May 2019 05:47:52 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 55/56] arm64: KVM: Fix perf cycle counter support for VHE
Date:   Fri,  3 May 2019 13:44:26 +0100
Message-Id: <20190503124427.190206-56-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

The kvm_vcpu_pmu_{read,write}_evtype_direct functions do not handle
the cycle counter use-case, this leads to inaccurate counts and a
WARN message when using perf with the cycle counter (-e cycle).

Let's fix this by adding a use case for pmccfiltr_el0.

Fixes: 39e3406a090a ("arm64: KVM: Avoid isb's by using direct pmxevtyper sysreg")
Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/pmu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index cd49db845ef4..3da94a5bb6b7 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -134,12 +134,15 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 	PMEVTYPER_##readwrite##_CASE(30)
 
 /*
- * Read a value direct from PMEVTYPER<idx>
+ * Read a value direct from PMEVTYPER<idx> where idx is 0-30
+ * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
  */
 static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
 {
 	switch (idx) {
 	PMEVTYPER_CASES(READ);
+	case ARMV8_PMU_CYCLE_IDX:
+		return read_sysreg(pmccfiltr_el0);
 	default:
 		WARN_ON(1);
 	}
@@ -148,12 +151,16 @@ static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
 }
 
 /*
- * Write a value direct to PMEVTYPER<idx>
+ * Write a value direct to PMEVTYPER<idx> where idx is 0-30
+ * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
  */
 static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
 {
 	switch (idx) {
 	PMEVTYPER_CASES(WRITE);
+	case ARMV8_PMU_CYCLE_IDX:
+		write_sysreg(val, pmccfiltr_el0);
+		break;
 	default:
 		WARN_ON(1);
 	}
-- 
2.20.1

