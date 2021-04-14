Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37DD35F551
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 15:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351622AbhDNNos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 09:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351611AbhDNNor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 09:44:47 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BEFC611C9;
        Wed, 14 Apr 2021 13:44:25 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lWfod-007RSZ-Vw; Wed, 14 Apr 2021 14:44:24 +0100
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
Subject: [PATCH 3/5] s390: Get rid of oprofile leftovers
Date:   Wed, 14 Apr 2021 14:44:07 +0100
Message-Id: <20210414134409.1266357-4-maz@kernel.org>
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

perf_pmu_name() and perf_num_counters() are unused. Drop them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/s390/kernel/perf_event.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
index 1e75cc983546..ea7729bebaa0 100644
--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -23,27 +23,6 @@
 #include <asm/sysinfo.h>
 #include <asm/unwind.h>
 
-const char *perf_pmu_name(void)
-{
-	if (cpum_cf_avail() || cpum_sf_avail())
-		return "CPU-Measurement Facilities (CPU-MF)";
-	return "pmu";
-}
-EXPORT_SYMBOL(perf_pmu_name);
-
-int perf_num_counters(void)
-{
-	int num = 0;
-
-	if (cpum_cf_avail())
-		num += PERF_CPUM_CF_MAX_CTR;
-	if (cpum_sf_avail())
-		num += PERF_CPUM_SF_MAX_CTR;
-
-	return num;
-}
-EXPORT_SYMBOL(perf_num_counters);
-
 static struct kvm_s390_sie_block *sie_block(struct pt_regs *regs)
 {
 	struct stack_frame *stack = (struct stack_frame *) regs->gprs[15];
-- 
2.29.2

