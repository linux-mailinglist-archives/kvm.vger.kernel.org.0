Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD0A6BAEEF
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 12:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjCOLMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 07:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjCOLMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 07:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C508C81F
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 04:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678878467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9JfBxT/tFVlJGKUlXgy73iHpcMp3LqRtX3+KfMtIMo=;
        b=HMeSWSj4GmpbrAy/QG/29UCxdmPmYX7zAGlfu1ddUl6sGygu/zPwFaHNvTTqLadVn3ptwJ
        nMcoG69L2D+bYcVN0A4880iKS3ZaSyUSTHlaSBP5WgGS7ikSpAYcwlRB+8kzNOiOX1KlEB
        NTt/AfWz4J8DtRpf69JmLC1nzUaSgqI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-wRurrxHSMIOjhDTIHdKwkQ-1; Wed, 15 Mar 2023 07:07:44 -0400
X-MC-Unique: wRurrxHSMIOjhDTIHdKwkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 326D78028B3;
        Wed, 15 Mar 2023 11:07:43 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25386202701F;
        Wed, 15 Mar 2023 11:07:41 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 4/6] arm: pmu: Fix chain counter enable/disable sequences
Date:   Wed, 15 Mar 2023 12:07:23 +0100
Message-Id: <20230315110725.1215523-5-eric.auger@redhat.com>
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

In some ARM ARM ddi0487 revisions it is said that
disabling/enabling a pair of counters that are paired
by a CHAIN event should follow a given sequence:

Disable the low counter first, isb, disable the high counter
Enable the high counter first, isb, enable low counter

This was the case in Fc. However this is not written anymore
in Ia revision.

Introduce 2 helpers to execute those sequences and replace
the existing PMCNTENCLR/ENSET calls.

Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
and replace them by PMCNTENCLR writes since writing 0 in
PMCNTENSET_EL0 has no effect.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index dde399e2..af679667 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -730,6 +730,22 @@ static void test_chained_sw_incr(bool unused)
 		    read_regn_el0(pmevcntr, 0), \
 		    read_sysreg(pmovsclr_el0))
 
+static void enable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the high counter first */
+	isb();
+	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the low counter */
+	isb();
+}
+
+static void disable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the low counter first*/
+	isb();
+	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the high counter */
+	isb();
+}
+
 static void test_chain_promotion(bool unused)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
@@ -768,16 +784,17 @@ static void test_chain_promotion(bool unused)
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
 	PRINT_REGS("After 2d loop");
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -798,9 +815,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
-	/* enable the CHAIN event */
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	/* Disable the even counter and enable the chain counter */
+	write_sysreg_s(0x1, PMCNTENCLR_EL0); /* Disable the low counter first */
 	isb();
+	enable_chain_counter(0);
+
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 
 	PRINT_REGS("After 2d loop");
@@ -824,10 +843,10 @@ static void test_chain_promotion(bool unused)
 	PRINT_REGS("After 1st loop");
 
 	/* 0 becomes CHAINED */
-	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_sysreg_s(0x3, PMCNTENCLR_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 1, 0x0);
+	enable_chain_counter(0);
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2d loop");
@@ -843,13 +862,13 @@ static void test_chain_promotion(bool unused)
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

