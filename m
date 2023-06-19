Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E96735E24
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 22:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjFSUFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 16:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjFSUFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 16:05:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92443137
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 13:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687205052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HOP3j9GhnE1/CcRWevSWFyG95Au2p+0j6upUhVgBVtU=;
        b=NaVzTLi3abi2+vB8T3R3b+k0wLaM+S4LbOARWt1F7R7Sg0R0BIPRJ/zDQ2jUwRZ2LxOuOi
        D0Nf4zCAwLWP2xIMpPtT0ZyfpDoRUKXlUnEU/Cyht7uTgADh0L7ibArux5a06DLjepVJDN
        ONSJjhQCQkW3u90NztNpYmoXeddd7g8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-a8zJjUu1P3uatMvcYlNqCQ-1; Mon, 19 Jun 2023 16:04:08 -0400
X-MC-Unique: a8zJjUu1P3uatMvcYlNqCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C468C800A15;
        Mon, 19 Jun 2023 20:04:07 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAE85C1603B;
        Mon, 19 Jun 2023 20:04:05 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 1/6] arm: pmu: pmu-chain-promotion: Improve debug messages
Date:   Mon, 19 Jun 2023 22:03:56 +0200
Message-Id: <20230619200401.1963751-2-eric.auger@redhat.com>
In-Reply-To: <20230619200401.1963751-1-eric.auger@redhat.com>
References: <20230619200401.1963751-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pmu-chain-promotion test is composed of several subtests.
In case of failures, the current logs are really dificult to
analyze since they look very similar and sometimes duplicated
for each subtest. Add prefixes for each subtest and introduce
a macro that prints the registers we are mostly interested in,
namerly the 2 first counters and the overflow counter.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

---

v1 -> v2:
- Added Alexandru's R-b
- s/2d/2nd
---
 arm/pmu.c | 63 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index f6e95012..cc2e733e 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -715,6 +715,11 @@ static void test_chained_sw_incr(bool unused)
 	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
+#define PRINT_REGS(__s) \
+	report_info("%s #1=0x%lx #0=0x%lx overflow=0x%lx", __s, \
+		    read_regn_el0(pmevcntr, 1), \
+		    read_regn_el0(pmevcntr, 0), \
+		    read_sysreg(pmovsclr_el0))
 
 static void test_chain_promotion(bool unused)
 {
@@ -725,6 +730,7 @@ static void test_chain_promotion(bool unused)
 		return;
 
 	/* Only enable CHAIN counter */
+	report_prefix_push("subtest1");
 	pmu_reset();
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
@@ -732,83 +738,81 @@ static void test_chain_promotion(bool unused)
 	isb();
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	PRINT_REGS("post");
 	report(!read_regn_el0(pmevcntr, 0),
 		"chain counter not counting if even counter is disabled");
+	report_prefix_pop();
 
 	/* Only enable even counter */
+	report_prefix_push("subtest2");
 	pmu_reset();
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	write_sysreg_s(0x1, PMCNTENSET_EL0);
 	isb();
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	PRINT_REGS("post");
 	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
 		"odd counter did not increment on overflow if disabled");
-	report_info("MEM_ACCESS counter #0 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 0));
-	report_info("CHAIN counter #1 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 1));
-	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
+	report_prefix_pop();
 
 	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
+	report_prefix_push("subtest3");
 	pmu_reset();
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
 	isb();
+	PRINT_REGS("init");
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
-	report_info("MEM_ACCESS counter #0 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 0));
+	PRINT_REGS("After 1st loop");
 
 	/* disable the CHAIN event */
 	write_sysreg_s(0x2, PMCNTENCLR_EL0);
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
-	report_info("MEM_ACCESS counter #0 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 0));
+	PRINT_REGS("After 2nd loop");
 	report(read_sysreg(pmovsclr_el0) == 0x1,
 		"should have triggered an overflow on #0");
 	report(!read_regn_el0(pmevcntr, 1),
 		"CHAIN counter #1 shouldn't have incremented");
+	report_prefix_pop();
 
 	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
 
+	report_prefix_push("subtest4");
 	pmu_reset();
 	write_sysreg_s(0x1, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
 	isb();
-	report_info("counter #0 = 0x%lx, counter #1 = 0x%lx overflow=0x%lx",
-		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
-		    read_sysreg(pmovsclr_el0));
+	PRINT_REGS("init");
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
-	report_info("MEM_ACCESS counter #0 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 0));
+	PRINT_REGS("After 1st loop");
 
 	/* enable the CHAIN event */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
-	report_info("MEM_ACCESS counter #0 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 0));
+
+	PRINT_REGS("After 2nd loop");
 
 	report((read_regn_el0(pmevcntr, 1) == 1) &&
 		(read_sysreg(pmovsclr_el0) == 0x1),
 		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
-
-	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
-		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+	report_prefix_pop();
 
 	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
+	report_prefix_push("subtest5");
 	pmu_reset();
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
 	isb();
+	PRINT_REGS("init");
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
-	report_info("MEM_ACCESS counter #0 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 0));
+	PRINT_REGS("After 1st loop");
 
 	/* 0 becomes CHAINED */
 	write_sysreg_s(0x0, PMCNTENSET_EL0);
@@ -817,37 +821,34 @@ static void test_chain_promotion(bool unused)
 	write_regn_el0(pmevcntr, 1, 0x0);
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
-	report_info("MEM_ACCESS counter #0 has value 0x%lx",
-		    read_regn_el0(pmevcntr, 0));
+	PRINT_REGS("After 2nd loop");
 
 	report((read_regn_el0(pmevcntr, 1) == 1) &&
 		(read_sysreg(pmovsclr_el0) == 0x1),
 		"32b->64b: CHAIN counter incremented and overflow");
-
-	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
-		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+	report_prefix_pop();
 
 	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
+	report_prefix_push("subtest6");
 	pmu_reset();
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	PRINT_REGS("init");
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
-	report_info("counter #0=0x%lx, counter #1=0x%lx",
-			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
+	PRINT_REGS("After 1st loop");
 
 	write_sysreg_s(0x0, PMCNTENSET_EL0);
 	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	PRINT_REGS("After 2nd loop");
 	report(read_sysreg(pmovsclr_el0) == 1,
 		"overflow is expected on counter 0");
-	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
-			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
-			read_sysreg(pmovsclr_el0));
+	report_prefix_pop();
 }
 
 static bool expect_interrupts(uint32_t bitmap)
-- 
2.38.1

