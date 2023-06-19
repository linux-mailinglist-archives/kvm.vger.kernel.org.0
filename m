Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E620735E25
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 22:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjFSUFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 16:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjFSUFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 16:05:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB42183
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 13:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687205055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jbPR7rzMfEXUzkGvuOyQ+Kf7ghmQ72DxloMHa8LZzA4=;
        b=NIl7gGUU00QlvUFgfqhES08AczKYD19FeL0W0/jsEGWtDgerPLX3ZqUG1oTqqmyktCdyOT
        ONBhol5oZRW03415Jd2cnwgFNng5Fi8/c0sMkgQCnjO+mq5+2qPo4/lNUQHs10c2bs7zeZ
        VoTV3EDOLRWNoq3U62w/HxeAF2+b2Ow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-nLbYMQPyN9SXjO8NyHpptg-1; Mon, 19 Jun 2023 16:04:11 -0400
X-MC-Unique: nLbYMQPyN9SXjO8NyHpptg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2ED9D29AA2CE;
        Mon, 19 Jun 2023 20:04:11 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 189D2C1603B;
        Mon, 19 Jun 2023 20:04:07 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 2/6] arm: pmu: pmu-chain-promotion: Introduce defines for count and margin values
Date:   Mon, 19 Jun 2023 22:03:57 +0200
Message-Id: <20230619200401.1963751-3-eric.auger@redhat.com>
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

The pmu-chain-promotion test is composed of separate subtests.

Some of them apply some settings on a first MEM_ACCESS loop
iterations, change the settings and run another MEM_ACCESS loop.

The PRE_OVERFLOW2 MEM_ACCESS counter init value is defined so that
the first loop does not overflow and the second loop overflows.

At the moment the MEM_ACCESS count number is hardcoded to 20 and
PRE_OVERFLOW2 is set to UINT32_MAX - 20 - 15 where 15 acts as a
margin.

Introduce defines for the count number and the margin so that it
becomes easier to change them.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

---

v1 -> v2:
- 2d -> 2nd and use @COUNT in comment
- Added Alexandru's R-b
---
 arm/pmu.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cc2e733e..51c0fe80 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -55,11 +55,18 @@
 #define EXT_COMMON_EVENTS_LOW	0x4000
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
-#define ALL_SET_32			0x00000000FFFFFFFFULL
+#define ALL_SET_32		0x00000000FFFFFFFFULL
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
-#define PRE_OVERFLOW2_32	0x00000000FFFFFFDCULL
 #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
+#define COUNT 20
+#define MARGIN 15
+/*
+ * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
+ * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
+ * for some observed variability we take into account a given @MARGIN
+ */
+#define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
 
 #define PRE_OVERFLOW(__overflow_at_64bits)				\
 	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
@@ -737,7 +744,7 @@ static void test_chain_promotion(bool unused)
 	write_sysreg_s(0x2, PMCNTENSET_EL0);
 	isb();
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("post");
 	report(!read_regn_el0(pmevcntr, 0),
 		"chain counter not counting if even counter is disabled");
@@ -750,13 +757,13 @@ static void test_chain_promotion(bool unused)
 	write_sysreg_s(0x1, PMCNTENSET_EL0);
 	isb();
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("post");
 	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
 		"odd counter did not increment on overflow if disabled");
 	report_prefix_pop();
 
-	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
+	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
 	report_prefix_push("subtest3");
 	pmu_reset();
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
@@ -764,12 +771,12 @@ static void test_chain_promotion(bool unused)
 	isb();
 	PRINT_REGS("init");
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
 	/* disable the CHAIN event */
 	write_sysreg_s(0x2, PMCNTENCLR_EL0);
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
 	report(read_sysreg(pmovsclr_el0) == 0x1,
 		"should have triggered an overflow on #0");
@@ -777,7 +784,7 @@ static void test_chain_promotion(bool unused)
 		"CHAIN counter #1 shouldn't have incremented");
 	report_prefix_pop();
 
-	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
+	/* 1st COUNT with CHAIN disabled, next COUNT with CHAIN enabled */
 
 	report_prefix_push("subtest4");
 	pmu_reset();
@@ -786,13 +793,13 @@ static void test_chain_promotion(bool unused)
 	isb();
 	PRINT_REGS("init");
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
 	/* enable the CHAIN event */
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 
 	PRINT_REGS("After 2nd loop");
 
@@ -811,7 +818,7 @@ static void test_chain_promotion(bool unused)
 	isb();
 	PRINT_REGS("init");
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
 	/* 0 becomes CHAINED */
@@ -820,7 +827,7 @@ static void test_chain_promotion(bool unused)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 1, 0x0);
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
 
 	report((read_regn_el0(pmevcntr, 1) == 1) &&
@@ -837,14 +844,14 @@ static void test_chain_promotion(bool unused)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	PRINT_REGS("init");
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
 	write_sysreg_s(0x0, PMCNTENSET_EL0);
 	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
 	report(read_sysreg(pmovsclr_el0) == 1,
 		"overflow is expected on counter 0");
-- 
2.38.1

