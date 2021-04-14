Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36C435F54F
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351634AbhDNNos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 09:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351602AbhDNNoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 09:44:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E341A6120E;
        Wed, 14 Apr 2021 13:44:24 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lWfod-007RSZ-5a; Wed, 14 Apr 2021 14:44:23 +0100
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
Subject: [PATCH 2/5] arm64: Get rid of oprofile leftovers
Date:   Wed, 14 Apr 2021 14:44:06 +0100
Message-Id: <20210414134409.1266357-3-maz@kernel.org>
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

perf_pmu_name() and perf_num_counters() are now unused. Drop them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/perf/arm_pmu.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 2d10d84fb79c..d4f7f1f9cc77 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -581,33 +581,6 @@ static const struct attribute_group armpmu_common_attr_group = {
 	.attrs = armpmu_common_attrs,
 };
 
-/* Set at runtime when we know what CPU type we are. */
-static struct arm_pmu *__oprofile_cpu_pmu;
-
-/*
- * Despite the names, these two functions are CPU-specific and are used
- * by the OProfile/perf code.
- */
-const char *perf_pmu_name(void)
-{
-	if (!__oprofile_cpu_pmu)
-		return NULL;
-
-	return __oprofile_cpu_pmu->name;
-}
-EXPORT_SYMBOL_GPL(perf_pmu_name);
-
-int perf_num_counters(void)
-{
-	int max_events = 0;
-
-	if (__oprofile_cpu_pmu != NULL)
-		max_events = __oprofile_cpu_pmu->num_events;
-
-	return max_events;
-}
-EXPORT_SYMBOL_GPL(perf_num_counters);
-
 static int armpmu_count_irq_users(const int irq)
 {
 	int cpu, count = 0;
@@ -979,9 +952,6 @@ int armpmu_register(struct arm_pmu *pmu)
 	if (ret)
 		goto out_destroy;
 
-	if (!__oprofile_cpu_pmu)
-		__oprofile_cpu_pmu = pmu;
-
 	pr_info("enabled with %s PMU driver, %d counters available%s\n",
 		pmu->name, pmu->num_events,
 		has_nmi ? ", using NMIs" : "");
-- 
2.29.2

