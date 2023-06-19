Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56ED5735E28
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 22:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjFSUFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 16:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjFSUFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 16:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4F7E65
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 13:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687205060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+qf1a+VgjPuvHu//QonjTW6u5bwlPFey212v/LxOuA=;
        b=ZdMYn3pTHkVL0y1jV8BrUefFKiAEqNL5my+qtz3XhK1lUpMJrwkXSGs1pIipfcbDn3tQrY
        TZPgOaj8HjUUnxHH5dcHNwGz2eYMXeFu0DyEsTAWuoYMo6UVPcb/FmGYPRLGjcEVVt+WGd
        Up9Aap+KLYtFFBY9NY2i/PSxK4ikGK8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-oKvPbwtEOISJg-syfA3cJg-1; Mon, 19 Jun 2023 16:04:16 -0400
X-MC-Unique: oKvPbwtEOISJg-syfA3cJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E083180120F;
        Mon, 19 Jun 2023 20:04:15 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB409C1603B;
        Mon, 19 Jun 2023 20:04:13 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 4/6] arm: pmu: Fix chain counter enable/disable sequences
Date:   Mon, 19 Jun 2023 22:03:59 +0200
Message-Id: <20230619200401.1963751-5-eric.auger@redhat.com>
In-Reply-To: <20230619200401.1963751-1-eric.auger@redhat.com>
References: <20230619200401.1963751-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some ARM ARM ddi0487 revisions it is said that
disabling/enabling a pair of counters that are paired
by a CHAIN event should follow a given sequence:

Enable the high counter first, isb, enable low counter
Disable the low counter first, isb, disable the high counter

This was the case in Fc. However this is not written anymore
in subsequent revions such as Ia.

Anyway, just in case, and because it also makes the code a
little bit simpler, introduce 2 helpers to enable/disable chain
counters that execute those sequences and replace the existing
PMCNTENCLR/ENSET calls (at least this cannot do any harm).

Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
and replace them by PMCNTENCLR writes since writing 0 in
PMCNTENSET_EL0 has no effect. While at it, aslo removes a useless
pmevtyper setting in test_chained_sw_incr() since the type of the
counter is not reset by pmu_reset()

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v2 -> v3:
- use enable_chain_counter() in test_chain_promotion() and
  test_chained_sw_incr() as well. This also fix the missing
  ISB reported by Alexandru.
- Also removes a useless pmevtyper setting in
  test_chained_sw_incr()

v1 -> v2:
- fix the enable_chain_counter()/disable_chain_counter()
  sequence, ie. swap n + 1 / n as reported by Alexandru.
- fix an other comment using the 'low' terminology
---
 arm/pmu.c | 48 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 74dd4c10..0995a249 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -631,6 +631,22 @@ static void test_sw_incr(bool overflow_at_64bits)
 		"overflow on counter #0 after 100 SW_INCR");
 }
 
+static void enable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the high counter first */
+	isb();
+	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the low counter */
+	isb();
+}
+
+static void disable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the low counter first*/
+	isb();
+	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the high counter */
+	isb();
+}
+
 static void test_chained_counters(bool unused)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
@@ -643,9 +659,8 @@ static void test_chained_counters(bool unused)
 
 	write_regn_el0(pmevtyper, 0, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	/* enable counters #0 and #1 */
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
+	enable_chain_counter(0);
 
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 
@@ -655,10 +670,10 @@ static void test_chained_counters(bool unused)
 	/* test 64b overflow */
 
 	pmu_reset();
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	write_regn_el0(pmevcntr, 1, 0x1);
+	enable_chain_counter(0);
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
@@ -687,8 +702,7 @@ static void test_chained_sw_incr(bool unused)
 
 	write_regn_el0(pmevtyper, 0, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	/* enable counters #0 and #1 */
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	enable_chain_counter(0);
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
@@ -707,10 +721,9 @@ static void test_chained_sw_incr(bool unused)
 	/* 64b SW_INCR and overflow on CHAIN counter*/
 	pmu_reset();
 
-	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
 	write_regn_el0(pmevcntr, 1, ALL_SET_32);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	enable_chain_counter(0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
 	isb();
 
@@ -769,16 +782,17 @@ static void test_chain_promotion(bool unused)
 	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
 	report_prefix_push("subtest3");
 	pmu_reset();
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
-	isb();
+	enable_chain_counter(0);
 	PRINT_REGS("init");
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
 	/* disable the CHAIN event */
-	write_sysreg_s(0x2, PMCNTENCLR_EL0);
+	disable_chain_counter(0);
+	write_sysreg_s(0x1, PMCNTENSET_EL0); /* Enable the low counter */
+	isb();
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -799,9 +813,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
-	/* enable the CHAIN event */
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	/* Disable the low counter first and enable the chain counter */
+	write_sysreg_s(0x1, PMCNTENCLR_EL0);
 	isb();
+	enable_chain_counter(0);
+
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 
 	PRINT_REGS("After 2nd loop");
@@ -825,10 +841,10 @@ static void test_chain_promotion(bool unused)
 	PRINT_REGS("After 1st loop");
 
 	/* 0 becomes CHAINED */
-	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_sysreg_s(0x3, PMCNTENCLR_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 1, 0x0);
+	enable_chain_counter(0);
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
@@ -844,13 +860,13 @@ static void test_chain_promotion(bool unused)
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	enable_chain_counter(0);
 	PRINT_REGS("init");
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
-	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	disable_chain_counter(0);
 	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-- 
2.38.1

