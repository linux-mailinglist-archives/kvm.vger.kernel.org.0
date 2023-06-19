Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A40F735E27
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 22:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjFSUFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 16:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjFSUFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 16:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD77E4A
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 13:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687205065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=El7ZbFEFYO2h3mXEecy2DkF2h1Jjv/TFBhVrLMkx06Q=;
        b=gvkWtVl398LagnZ8yDMNB0ViRhW4bOcLw1UrP/4h+ovVX4gKN7n307waCXzPQshn5cwzTQ
        T2OLpyUG/CLI4lPQLPghYlgGsS0r0h1TsXj3Y1xv2yPwkhhoiWB3Ulvltvo4Kox2auiW/o
        8M2y9G7bw/9zqu8TFDtE94SBBvxLT5o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-kLXr9zHyPuWivPQiDJS8Rg-1; Mon, 19 Jun 2023 16:04:21 -0400
X-MC-Unique: kLXr9zHyPuWivPQiDJS8Rg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DB00185A78E;
        Mon, 19 Jun 2023 20:04:21 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3346FC1603B;
        Mon, 19 Jun 2023 20:04:16 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 5/6] arm: pmu: Add pmu-mem-access-reliability test
Date:   Mon, 19 Jun 2023 22:04:00 +0200
Message-Id: <20230619200401.1963751-6-eric.auger@redhat.com>
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

Add a new basic test that runs MEM_ACCESS loop over
100 iterations and make sure the number of measured
MEM_ACCESS never overflows the margin. Some other
pmu tests rely on this pattern and if the MEM_ACCESS
measurement is not reliable, it is better to report
it beforehand and not confuse the user any further.

Without the subsequent patch, this typically fails on
ThunderXv2 with the following logs:

INFO: pmu: pmu-mem-access-reliability: 32-bit overflows:
overflow=1 min=21 max=41 COUNT=20 MARGIN=15
FAIL: pmu: pmu-mem-access-reliability: 32-bit overflows:
mem_access count is reliable

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v2 -> v3:
- rename variables as suggested by Alexandru, rework the
  traces accordingly. Use all_set.

v1 -> v2:
- use mem-access instead of memaccess as suggested by Mark
- simplify the logic and add comments in the test loop
---
 arm/pmu.c         | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  6 +++++
 2 files changed, 65 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 0995a249..491d2958 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -56,6 +56,11 @@
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
 #define ALL_SET_32		0x00000000FFFFFFFFULL
+#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
+
+#define ALL_SET(__overflow_at_64bits)				\
+	(__overflow_at_64bits ? ALL_SET_64 : ALL_SET_32)
+
 #define ALL_CLEAR		0x0000000000000000ULL
 #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
 #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
@@ -67,6 +72,10 @@
  * for some observed variability we take into account a given @MARGIN
  */
 #define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
+#define PRE_OVERFLOW2_64		(ALL_SET_64 - COUNT - MARGIN)
+
+#define PRE_OVERFLOW2(__overflow_at_64bits)				\
+	(__overflow_at_64bits ? PRE_OVERFLOW2_64 : PRE_OVERFLOW2_32)
 
 #define PRE_OVERFLOW(__overflow_at_64bits)				\
 	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
@@ -744,6 +753,53 @@ static void test_chained_sw_incr(bool unused)
 		    read_regn_el0(pmevcntr, 0), \
 		    read_sysreg(pmovsclr_el0))
 
+/*
+ * This test checks that a mem access loop featuring COUNT accesses
+ * does not overflow with an init value of PRE_OVERFLOW2. It also
+ * records the min/max access count to see how much the counting
+ * is (un)reliable
+ */
+static void test_mem_access_reliability(bool overflow_at_64bits)
+{
+	uint32_t events[] = {MEM_ACCESS};
+	void *addr = malloc(PAGE_SIZE);
+	uint64_t cntr_val, num_events, max = 0, min = pmevcntr_mask();
+	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
+	uint64_t all_set = ALL_SET(overflow_at_64bits);
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
+		cntr_val = read_regn_el0(pmevcntr, 0);
+		if (cntr_val >= pre_overflow2) {
+			num_events = cntr_val - pre_overflow2;
+		} else {
+			/* unexpected counter overflow */
+			num_events = cntr_val + all_set - pre_overflow2;
+			overflow = true;
+			report_info("iter=%d num_events=%ld min=%ld max=%ld overflow!!!",
+				    i, num_events, min, max);
+		}
+		/* record extreme value */
+		max = MAX(num_events, max);
+		min = MIN(num_events, min);
+	}
+	report_info("overflow=%d min=%ld max=%ld expected=%d acceptable margin=%d",
+		    overflow, min, max, COUNT, MARGIN);
+	report(!overflow, "mem_access count is reliable");
+}
+
 static void test_chain_promotion(bool unused)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
@@ -1201,6 +1257,9 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
 		run_event_test(argv[1], test_basic_event_count, false);
 		run_event_test(argv[1], test_basic_event_count, true);
+	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
+		run_event_test(argv[1], test_mem_access_reliability, false);
+		run_event_test(argv[1], test_mem_access_reliability, true);
 	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
 		run_event_test(argv[1], test_mem_access, false);
 		run_event_test(argv[1], test_mem_access, true);
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b558..fe601cbb 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -90,6 +90,12 @@ groups = pmu
 arch = arm64
 extra_params = -append 'pmu-mem-access'
 
+[pmu-mem-access-reliability]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'pmu-mem-access-reliability'
+
 [pmu-sw-incr]
 file = pmu.flat
 groups = pmu
-- 
2.38.1

