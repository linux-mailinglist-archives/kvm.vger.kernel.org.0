Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6DE5906D0
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 21:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbiHKSwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 14:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbiHKSwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 14:52:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC969DF98
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z5-20020a056a001d8500b0052e691eed53so7916450pfw.13
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=zz99fKzwjwDHJo8VLz/7LS0wHhldAxFtS0b0KytwMEA=;
        b=mMsWaCnsqnOEQ6Bvki66q5wsRB1x/slSTddPfkvkrLtK6Q+LOEU1HNlHVTL8/bp1Iw
         Ji1uYYaunHXFkpuA+lePaCSi8rwJBS/RA8E8gCrGQ7ZZ2s2notMohma6oUFzZeFpK8li
         KE3JiZwdZLer9YdEAbUC0Z09HDEFBLkDSdNDttDL7RjedJGa5GTryHXGXXYyr+Xy+BG8
         kNFXct3+hZh8ApS+9newCGooHT4N9OsiMyyasWVx4OnAvg9mYu77X4T9kUDnmM2Rjfw2
         GA5GNrNJOVXo8I34xra58Kt666Cpz6ss7J0gOLTiPxVIEEok84r+SiqjdTNtSh4SRmcJ
         x/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=zz99fKzwjwDHJo8VLz/7LS0wHhldAxFtS0b0KytwMEA=;
        b=YY2BkSLyI4cG1MQAcIkAF/0u9AQrndP6dXFS19Ykpv00FdxrvligdT63pz/x/Zb9ox
         4MwLCZCcV0e97gPmbrdA/0RLgnHJM1f/+OAK6sdDO58sXZGWwGINq4H9jB/0rDSs7E2n
         0kNb7vdj/D9wvRPurAsz3m3hHKbWo5wf8FXFBnOydUEg+fsoOJNhcaoQfVfyftfE4tkp
         mNuV9dvsK00siFd0wKj/wAexLQL60OQV9L9cpBhAbJknu4tqafyMJ5aA2rh61DgJeKpe
         Ttq+GoxOXCSw8IcQE9nTibPtREZpzh/qjztDhIMDzJd8MzR5hYcmXAFcOG+71OCwuFYD
         Xkow==
X-Gm-Message-State: ACgBeo2kCbXE3OSJuhhjaSaWCZbH+3AU3WWwFCNvZ0ye16bK9QYinRsZ
        Ba+0acINowcGJenM+6oe51mb971M1oFlPOZhQBc0XV9Y9V1elOllH2YtGXEmsL3eKmVYDo1qLXX
        b/Bf74F0y27LCRYAmDnu5vh4L7VUJxqnWH4k15tM5HO4v7XK195pbP1KuLa5Fcdw=
X-Google-Smtp-Source: AA6agR6KCV4zKclcwL7i7wND5hfdvI19kKOD0HMnJIDp9WuoEU90pLaAs38vmeyM2AskMn48YMCmelVVkyiWvw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:9ce:b0:1f3:c90:6e99 with SMTP id
 72-20020a17090a09ce00b001f30c906e99mr10125701pjo.211.1660243935689; Thu, 11
 Aug 2022 11:52:15 -0700 (PDT)
Date:   Thu, 11 Aug 2022 11:52:07 -0700
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
Message-Id: <20220811185210.234711-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220811185210.234711-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 1/4] arm: pmu: Add missing isb()'s after sys
 register writing
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are various pmu tests that require an isb() between enabling
counting and the actual counting. This can lead to count registers
reporting less events than expected; the actual enabling happens after
some events have happened.  For example, some missing isb()'s in the
pmu-sw-incr test lead to the following errors on bare-metal:

	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
	PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
	FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
	FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
	INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
	PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
	SUMMARY: 4 tests, 2 unexpected failures

Add the missing isb()'s on all failing tests, plus some others that seem
required:
- after clearing the overflow signal in the IRQ handler to make spurious
  interrupts less likely.
- after direct writes to PMSWINC_EL0 for software to read the correct
  value for PMEVNCTR0_EL0 (from ARM DDI 0487H.a, page D13-5237).

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 15c542a2..4c601b05 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -307,6 +307,7 @@ static void irq_handler(struct pt_regs *regs)
 			}
 		}
 		write_sysreg(ALL_SET, pmovsclr_el0);
+		isb();
 	} else {
 		pmu_stats.unexpected = true;
 	}
@@ -534,10 +535,12 @@ static void test_sw_incr(void)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
+	isb();
 	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
 	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
 		"PWSYNC does not increment if PMCR.E is unset");
@@ -547,10 +550,12 @@ static void test_sw_incr(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
+	isb();
 	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1)  == 100,
 		"counter #0 after + 100 SW_INCR");
@@ -618,9 +623,12 @@ static void test_chained_sw_incr(void)
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
+	isb();
 	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
 		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
@@ -634,9 +642,12 @@ static void test_chained_sw_incr(void)
 	write_regn_el0(pmevcntr, 1, ALL_SET);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
+	isb();
 	report((read_sysreg(pmovsclr_el0) == 0x2) &&
 		(read_regn_el0(pmevcntr, 1) == 0) &&
 		(read_regn_el0(pmevcntr, 0) == 84),
@@ -821,10 +832,14 @@ static void test_overflow_interrupt(void)
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x2, pmswinc_el0);
 
+	isb();
 	set_pmcr(pmu.pmcr_ro);
+	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
 	/* enable interrupts */
@@ -879,6 +894,7 @@ static bool check_cycles_increase(void)
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
 	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
+	isb();
 
 	for (int i = 0; i < NR_SAMPLES; i++) {
 		uint64_t a, b;
@@ -894,6 +910,7 @@ static bool check_cycles_increase(void)
 	}
 
 	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
+	isb();
 
 	return success;
 }
-- 
2.37.1.559.g78731f0fdb-goog

