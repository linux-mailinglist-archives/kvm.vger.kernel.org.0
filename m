Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01B16632A7
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbjAIVTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbjAIVSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:18:15 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F6E10B5
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:18:06 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s22-20020a17090aad9600b002271d094c82so1781938pjq.7
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fGw/0OCsAgcLKqcxRg8B1wba5pl1dSM4UJ7whQhNus=;
        b=XIHoEXJsLKggrCYm8dMw9CNWMw+6PgaeLRrWr9vnCxdQwaLVhfKERDtO9l2H6EW1Dh
         1nCcgnxRtUxlqUoT74tSTXoy1tdTLSLhk2U6erKXX0uz3126OIqHnG6mZEM7dfBAIdXr
         qyH5Ti18HNXAjpdvVp0SiyLg0ZWJIuu3CrFYWBpJcdUCPCnnwnxDvhkwHzJ5KtlNof3T
         HTAiYKcBq1r5R2lwJcvKHK3N3uBQD+RtrpfzSTDDcTVukREwv51yZd44Wdn0hnFMeiYC
         ME6s84fW5I6gF9F6oevKpf399e+GcuIEZTtF6FttB+Kno5YPnoqigmUj2/aL8sq1/FWH
         PEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1fGw/0OCsAgcLKqcxRg8B1wba5pl1dSM4UJ7whQhNus=;
        b=uogjVnEG6T3I4gmwhpXqKoVS+11IaJM9MYTYmcThFV3rCBwOBC/70FNob4wVW0hR2v
         M/AoZ8Zmoh3frnyICq/4BKpZRsHgxLF1k8ytX9HoGNrGd9yGHyRHGWaX52R0QrW0g0eb
         nGPdXi4SU9sUOITRA5LeUutZ0/iXDyDMiTj4LLXohS+14OyxCLT7HdsJXaLeaPQHxq31
         f0GjLrF1NOqPm4ShzP8uVeq+fiuWyvJdgRvRTLykKDKxOWELecCk1NRUufCxdEE3yvO/
         0uUd211BnPu3mkAi0+ka1B4N/Gw5nxzQSvc3MtUOmKQGHyUH7zBA6kWOoCDC9zrqJCDx
         81IA==
X-Gm-Message-State: AFqh2kqcREgfh9JRhW1l6ac8Kt0xW8jGgLxCESOu08JsxK/1r00swoOx
        Ca4px3c92XxEjOtvEJm4EpWkP+O0Ocmu2PXB+XopZF6eix/bsh1u+QOP1ztgqpb99a+IzDWHEiM
        jTaHWX0tjkIoOetXx3ggomBTT1VIqGN61l5mv9H871i5HsVaYm8rcS/M3tP+TQ7I=
X-Google-Smtp-Source: AMrXdXt5UcDfVynd4OKNMj0k6WlhLXtUrkn7P6bTiWJ+MhnH6xSPLbuWkfTsO35fZsz8XEeqtP3U5Vw9SaKa6Q==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:a588:b0:188:5c52:83e1 with SMTP
 id az8-20020a170902a58800b001885c5283e1mr5417601plb.128.1673299085698; Mon,
 09 Jan 2023 13:18:05 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:17:54 +0000
In-Reply-To: <20230109211754.67144-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109211754.67144-5-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v3 4/4] arm: pmu: Print counter values as hexadecimals
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The arm/pmu test prints the value of counters as %ld.  Most tests start
with counters around 0 or UINT_MAX, so having something like -16 instead of
0xffff_fff0 is not very useful.

Report counter values as hexadecimals.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 72d0f50..77b0a70 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -552,8 +552,8 @@ static void test_mem_access(bool overflow_at_64bits)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
-	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
-	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
+	report_info("counter #0 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
+	report_info("counter #1 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
 	/* We may measure more than 20 mem access depending on the core */
 	report((read_regn_el0(pmevcntr, 0) == read_regn_el0(pmevcntr, 1)) &&
 	       (read_regn_el0(pmevcntr, 0) >= 20) && !read_sysreg(pmovsclr_el0),
@@ -568,7 +568,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(read_sysreg(pmovsclr_el0) == 0x3,
 	       "Ran 20 mem accesses with expected overflows on both counters");
-	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
+	report_info("cnt#0=0x%lx cnt#1=0x%lx overflow=0x%lx",
 			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
 			read_sysreg(pmovsclr_el0));
 }
@@ -599,7 +599,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
+	report_info("SW_INCR counter #0 has value 0x%lx", read_regn_el0(pmevcntr, 0));
 	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"PWSYNC does not increment if PMCR.E is unset");
 
@@ -616,7 +616,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 	isb();
 	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
-	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
+	report_info("counter values after 100 SW_INCR #0=0x%lx #1=0x%lx",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
 		"overflow on counter #0 after 100 SW_INCR");
@@ -692,7 +692,7 @@ static void test_chained_sw_incr(bool unused)
 	report((read_sysreg(pmovsclr_el0) == 0x1) &&
 		(read_regn_el0(pmevcntr, 1) == 1),
 		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
 	/* 64b SW_INCR and overflow on CHAIN counter*/
@@ -713,7 +713,7 @@ static void test_chained_sw_incr(bool unused)
 	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
 	       (read_regn_el0(pmevcntr, 1) == cntr1),
 	       "expected overflows and values after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
@@ -745,11 +745,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
 	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
 		"odd counter did not increment on overflow if disabled");
-	report_info("MEM_ACCESS counter #0 has value %ld",
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
-	report_info("CHAIN counter #1 has value %ld",
+	report_info("CHAIN counter #1 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 1));
-	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
 
 	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
 	pmu_reset();
-- 
2.39.0.314.g84b9a713c41-goog

