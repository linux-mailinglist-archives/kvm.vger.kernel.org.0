Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34216BAF0F
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 12:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjCOLUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 07:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjCOLUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 07:20:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C408536A
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 04:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678879089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUg/lA5dPqAuc9OguXJG4Q0LnI5RxBl9sSCbOrZlfsk=;
        b=RaGgaYXTQiypJFllf0gLmUpiggLIf1k+Wc9Zu6kVTXqhm0C3gxhj1kdLVDw+wEns4bIyOZ
        oTqf0tV7UU2UcHoJ6+Ngphq/9MKR4eyPE8wo1NFRSgCurKzf0QmgBH4q/lo1HM+ccSNImp
        1BzPSSEbKL+yGN/oqQF6uGYn3X0Lk5s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-OiJABwaJMy2BixKYmqf4mg-1; Wed, 15 Mar 2023 07:07:39 -0400
X-MC-Unique: OiJABwaJMy2BixKYmqf4mg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90B0F185A792;
        Wed, 15 Mar 2023 11:07:38 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84B44202701F;
        Wed, 15 Mar 2023 11:07:36 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 2/6] arm: pmu: pmu-chain-promotion: Introduce defines for count and margin values
Date:   Wed, 15 Mar 2023 12:07:21 +0100
Message-Id: <20230315110725.1215523-3-eric.auger@redhat.com>
In-Reply-To: <20230315110725.1215523-1-eric.auger@redhat.com>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 arm/pmu.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index dad7d4b4..b88366a8 100644
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
+ * PRE_OVERFLOW2 is set so that 1st COUNT iterations do not
+ * produce 32b overflow and 2d COUNT iterations do. To accommodate
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
 	PRINT_REGS("After 2d loop");
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
 
 	PRINT_REGS("After 2d loop");
 
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
 	PRINT_REGS("After 2d loop");
 
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
 	PRINT_REGS("After 2d loop");
 	report(read_sysreg(pmovsclr_el0) == 1,
 		"overflow is expected on counter 0");
-- 
2.38.1

