Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2A15786B4
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiGRPtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiGRPtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:49:20 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FC0B48C
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:20 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c18-20020a17090a8d1200b001ef85196fb4so9687535pjo.4
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rfoG4qLeZytJWA1isKua1kICmPqasbDSZhpe1qk8ong=;
        b=S+txijMRAXsBEVF7o8XsVyUv2tIUOax/KO6CSpJ80iRzhpiZRWO8usijOfOPrCy45O
         MbwjIf6ZVRbYe9T8gT4X7+jJw9vFIWJ6Bki8/H5Q/gynvSxzqSc/d1jdeQsxE5e4vojs
         ikHteJAq2Klks/JcFubdBFyXdyLskvGIAzz5eG3NQgr4BE/TMcqDu6gocB9DRXR1BIbw
         tR7JctWQbwx6QgAi4wV3XL97XXWRvgF8rqQjOR7XFZ3u/c3kg0m0V5sKTl3UufwkkkwF
         TuzJDgPsxwwKCD17R3XPjcQce2oaQGh/P7T3GHco8mZU4Ba+9J8oT9OAVpEmtsonwVa3
         upwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rfoG4qLeZytJWA1isKua1kICmPqasbDSZhpe1qk8ong=;
        b=u2Rul+BhYrA/q4y6mQclGqq3W7tes4q8Uul+TyPliArRyUzaea0kiAjkQIWES9DnW+
         fb14qjV5Il83jXodL9V3WgzLX/lk2fPrZOJGVi10dWj5y1hMO85kr1ZHSxCrbo+tfKCv
         9CLgR1oZ639+478uNO6Oy4MB0/ofY712hsD7OLzCSSDKrvMiUKfmxfPxvHjvZRj78xFA
         idL+qCAyRSCh1DR7+HvTs/PYhsxpyYvWyrY/C6rWD9u8Uo/i2v4xVvshDQt7Y9Of30vZ
         4ioJyjGYapQzx9Xrj0oX2EMwnPLHJmJ6bdt/QVbGn8bBkMyJEyVD2SQblkbSkPm5O/1J
         UNvA==
X-Gm-Message-State: AJIora8NlP9EzeEGA0anJUf6o7IGTnnUGPugQvaSQghJCs7bkjOLf/xB
        iGJg1kmqV+xJyb2ls7fw5Ex7W/1JEOE2E+suqA7Brfbxbqlfzw4CB4X0aTsQsRj5av/iNYqYdQV
        IkRrwzI93zcs6A358gH9V3KVBzJVB5Qu6XBR6iEiqVK7ca8EgrrOr9tVmrkNpwGg=
X-Google-Smtp-Source: AGRyM1sd98nCGMNOituotgp5UUesMEtGF7CPQtTVuIgTG5IhZZNqSEF6WTSMMTCYQ0EWauFX0K+i44bds9ZdIQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:8c0a:b0:1ef:7c95:3f00 with SMTP
 id a10-20020a17090a8c0a00b001ef7c953f00mr32345198pjo.180.1658159359484; Mon,
 18 Jul 2022 08:49:19 -0700 (PDT)
Date:   Mon, 18 Jul 2022 08:49:10 -0700
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
Message-Id: <20220718154910.3923412-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220718154910.3923412-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow in
 chained counters tests
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
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

A chained event overflowing on the low counter can set the overflow flag
in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
(DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
overflow.

The pmu chain tests fail on bare metal when checking the overflow flag
of the low counter _not_ being set on overflow.  Fix by removing the
checks.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index a7899c3c..4f2c5096 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -581,7 +581,6 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 
 	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
 
 	/* test 64b overflow */
 
@@ -593,7 +592,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
+	report((read_sysreg(pmovsclr_el0) & 0x2) == 0, "no overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_regn_el0(pmevcntr, 1, ALL_SET);
@@ -601,7 +600,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
-	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
+	report(read_sysreg(pmovsclr_el0) & 0x2, "overflow on chain counter");
 }
 
 static void test_chained_sw_incr(void)
@@ -626,10 +625,10 @@ static void test_chained_sw_incr(void)
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
-	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
-		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
+	report(read_regn_el0(pmevcntr, 1) == 1,
+			"no chain counter incremented after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
-		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
+			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
 	/* 64b SW_INCR and overflow on CHAIN counter*/
 	pmu_reset();
@@ -644,7 +643,7 @@ static void test_chained_sw_incr(void)
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
-	report((read_sysreg(pmovsclr_el0) == 0x2) &&
+	report((read_sysreg(pmovsclr_el0) & 0x2) &&
 		(read_regn_el0(pmevcntr, 1) == 0) &&
 		(read_regn_el0(pmevcntr, 0) == 84),
 		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
@@ -727,8 +726,8 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1),
+		"CHAIN counter enabled: CHAIN counter was incremented");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -755,8 +754,8 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"32b->64b: CHAIN counter incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1),
+		"32b->64b: CHAIN counter incremented");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
-- 
2.37.0.170.g444d1eabd0-goog

