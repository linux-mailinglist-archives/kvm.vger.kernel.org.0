Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EECE5786B1
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbiGRPtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiGRPtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:49:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23F46594
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:16 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d185-20020a6236c2000000b0052af7994d56so3485679pfa.16
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tr1adnag8rLEQO6ZSct7qpTF68eGMGiTHDrAuDcnvTM=;
        b=g+86Cpm6aI2ALmntVwxDfmXwwqLRFwWD1mKhCk67HT6khla4fghcvnKWs9icM02IJy
         U69Le5z1MTLibkErj/i9unqF4527hMxkXr2n5TvRF2P0t7gXFBgy8kYzV+yQvtEm6cUk
         fyYYoHCkDBnt1b4MEvzYt9cXlcJm4WabKEDuUzZ6Mw7P/LXDdmVe9UjnbI6mmBM7iTPq
         rPA/h+9SNvzH1wnN2P3OplRyhswr/cilCKwnrkWh8v9fJgswknCKcX4MmOD8+xIbzLr0
         N115nbXVPoCBCUQvCcrIUY1B5/ZjzJmuqt2hiPo7JdKCA/ZzqY54ReAAjWTCZH2WZmEt
         zmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tr1adnag8rLEQO6ZSct7qpTF68eGMGiTHDrAuDcnvTM=;
        b=EAPdfmqOHL8fJDmcSjrCJt2BCdrwP2YFTHjKqKdPi4c7Ie8Ypcbpi+Wu55HyrmMX2U
         rLNMWDHLz8gkH8R6oQzqMPP9dSsS2bzasOXQjiUCwxx+8ILIZD5E7mSR7crTk/DPmRA7
         /d3T4snMVPb81My5bALw6EjUWCGHe8h8raatVM3hIje70tLBWy4vnCpJyh/r9qhpLMWB
         FWxZy4ojmIAMnArciG93GoLyU4ZKNo0ksU+cGSadGR90AQJAVoQeDTivdqXs39AxxUp3
         JXfFKIN9GwxTzMaQZ6ZtZBUGy/sqeQ+Jv3bkXPZu2smROSldbeEPHklQSBpHsYNa9/nU
         aYTA==
X-Gm-Message-State: AJIora+SLPAFKvQwItu7d3zoYArV3EcDNkJ1dpfdPlaO1nX5cTfTxzNx
        X6BNbXON8C35YytQM83TCQoaJFj88TGrPTdGSKiIygGTX542CgrobtQD6Xrtye7GcI0hHOIBt/i
        bPa78H90eGZNA6uYenz1EGQCR3YKhcvLW8VEQsXd+5N2Kucb/HhT+ZG0k8AIfkVc=
X-Google-Smtp-Source: AGRyM1tTNPv7SmG4wK1haaBWjYyP1C1LxeIzT8jVdcAagvhMT9lcJpJDdDaV0QCIUQTmG1L5C/7CE9R6z0NyvQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr107pje.0.1658159355896; Mon, 18 Jul 2022
 08:49:15 -0700 (PDT)
Date:   Mon, 18 Jul 2022 08:49:08 -0700
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
Message-Id: <20220718154910.3923412-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220718154910.3923412-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after sys
 register writing
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

Add the missing isb()'s on all failing tests, plus some others that are
not currently required but might in the future (like an isb() after
clearing the overflow signal in the IRQ handler).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 15c542a2..fd838392 100644
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
@@ -534,6 +535,7 @@ static void test_sw_incr(void)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
@@ -547,6 +549,7 @@ static void test_sw_incr(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
@@ -618,6 +621,8 @@ static void test_chained_sw_incr(void)
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
@@ -634,6 +639,8 @@ static void test_chained_sw_incr(void)
 	write_regn_el0(pmevcntr, 1, ALL_SET);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
@@ -821,6 +828,8 @@ static void test_overflow_interrupt(void)
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x2, pmswinc_el0);
 
@@ -879,6 +888,7 @@ static bool check_cycles_increase(void)
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
 	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
+	isb();
 
 	for (int i = 0; i < NR_SAMPLES; i++) {
 		uint64_t a, b;
@@ -894,6 +904,7 @@ static bool check_cycles_increase(void)
 	}
 
 	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
+	isb();
 
 	return success;
 }
-- 
2.37.0.170.g444d1eabd0-goog

