Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6B6BAF05
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 12:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjCOLSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 07:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbjCOLRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 07:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A681515D
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 04:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678878861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kuHE2AeRI9e/mGOy+BIcsuR8/WqXmEdwe7t+2hC5Uig=;
        b=DOuD8WajrtdhyTW582LPvJ+63uCsztc/nXSW8AJ7jcojP0UwTKi2XS8BtIkVmv42G1DpRt
        oACdN/a9rPYywKC88mWavdqZ0KXLUHQfL3lIX98cPuOTjn6A8W2mooGo0HItF60Hnizimw
        hB3WgFIZpjGP0Ud19lPdukGXWwx1zQs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-17xLadpmMaa72CvrG-fNwg-1; Wed, 15 Mar 2023 07:07:46 -0400
X-MC-Unique: 17xLadpmMaa72CvrG-fNwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72C86382C967;
        Wed, 15 Mar 2023 11:07:45 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79680202701E;
        Wed, 15 Mar 2023 11:07:43 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 5/6] arm: pmu: Add pmu-memaccess-reliability test
Date:   Wed, 15 Mar 2023 12:07:24 +0100
Message-Id: <20230315110725.1215523-6-eric.auger@redhat.com>
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

Add a new basic test that runs MEM_ACCESS loop over
100 iterations and make sure the number of measured
MEM_ACCESS never overflows the margin. Some other
pmu tests rely on this pattern and if the MEM_ACCESS
measurement is not reliable, it is better to report
it beforehand and not confuse the user any further.

Without the subsequent patch, this typically fails on
ThunderXv2 with the following logs:

INFO: pmu: pmu-memaccess-reliability: 32-bit overflows:
overflow=1 min=21 max=41 COUNT=20 MARGIN=15
FAIL: pmu: pmu-memaccess-reliability: 32-bit overflows:
memaccess is reliable

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  6 ++++++
 2 files changed, 58 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index af679667..c3d2a428 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -56,6 +56,7 @@
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
 #define ALL_SET_32		0x00000000FFFFFFFFULL
+#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
 #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
@@ -67,6 +68,10 @@
  * for some observed variability we take into account a given @MARGIN
  */
 #define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
+#define PRE_OVERFLOW2_64		(ALL_SET_64 - COUNT - MARGIN)
+
+#define PRE_OVERFLOW2(__overflow_at_64bits)				\
+	(__overflow_at_64bits ? PRE_OVERFLOW2_64 : PRE_OVERFLOW2_32)
 
 #define PRE_OVERFLOW(__overflow_at_64bits)				\
 	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
@@ -746,6 +751,50 @@ static void disable_chain_counter(int even)
 	isb();
 }
 
+static void test_memaccess_reliability(bool overflow_at_64bits)
+{
+	uint32_t events[] = {MEM_ACCESS};
+	void *addr = malloc(PAGE_SIZE);
+	uint64_t count, max = 0, min = pmevcntr_mask();
+	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
+	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
+	bool overflow = false;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
+	    !check_overflow_prerequisites(overflow_at_64bits))
+		return;
+
+	pmu_reset();
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	for (int i = 0; i < 100; i++) {
+		pmu_reset();
+		write_regn_el0(pmevcntr, 0, pre_overflow2);
+		write_sysreg_s(0x1, PMCNTENSET_EL0);
+		isb();
+		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+		count = read_regn_el0(pmevcntr, 0);
+		if (count < pre_overflow2) {
+			count += COUNT + MARGIN;
+			if (count > max)
+				max = count;
+			if (count < min)
+				min = count;
+			overflow = true;
+			report_info("iter=%d count=%ld min=%ld max=%ld overflow!!!",
+				    i, count, min, max);
+			continue;
+		}
+		count -= pre_overflow2;
+		if (count > max)
+			max = count;
+		if (count < min)
+			min = count;
+	}
+	report_info("overflow=%d min=%ld max=%ld COUNT=%d MARGIN=%d",
+		    overflow, min, max, COUNT, MARGIN);
+	report(!overflow, "memaccess is reliable");
+}
+
 static void test_chain_promotion(bool unused)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
@@ -1203,6 +1252,9 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
 		run_event_test(argv[1], test_basic_event_count, false);
 		run_event_test(argv[1], test_basic_event_count, true);
+	} else if (strcmp(argv[1], "pmu-memaccess-reliability") == 0) {
+		run_event_test(argv[1], test_memaccess_reliability, false);
+		run_event_test(argv[1], test_memaccess_reliability, true);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
 		run_event_test(argv[1], test_mem_access, false);
 		run_event_test(argv[1], test_mem_access, true);
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b558..301261aa 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -90,6 +90,12 @@ groups = pmu
 arch = arm64
 extra_params = -append 'pmu-mem-access'
 
+[pmu-memaccess-reliability]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'pmu-memaccess-reliability'
+
 [pmu-sw-incr]
 file = pmu.flat
 groups = pmu
-- 
2.38.1

