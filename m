Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D158922D
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 20:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbiHCSXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 14:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbiHCSXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 14:23:35 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E101A384
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 11:23:33 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d66-20020a636845000000b0040a88edd9c1so7133419pgc.13
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 11:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=2RN8WdnxLDMPgrvxgN2wYqtVPlMrXXuTUXGTj1+65DM=;
        b=QVEFwIOwZt8R5Z8q4bkJEMoWSqkNWKnjuIBWbf0GrikPC5oX3OYokBN2IGEJTf3jPp
         04MHsJwDP2SRwknw+mZhprV/X1CXzPU/tjMvofFVcAi3FpOObNVpYGp0pkToIfT74V3b
         JphBTOGpWSXb2HoI2JAMa1IW6z+06u8Y3HrVtdd7KQcosMRdUJ1mJrH9E8gIY6PT0lTW
         sdQDndeGmazVzrCop1YXz7QfRTaCuc74vOf02BJXDlhBlPEq5QQvpygPa4tWihsBnhgr
         F0OeUdv8OmmAXdxrC2vCNje08dpzKltX7zc7KoU5NS3zRmGU4A3e7PB6IsBNrFX3iVpQ
         uKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=2RN8WdnxLDMPgrvxgN2wYqtVPlMrXXuTUXGTj1+65DM=;
        b=lJr5XzLJwMdIBZBOrw/6aFeuLzUY4HBgkWIiv+wq0Ytd8hGFlax2vIdsJnHsVfs73f
         VpgT6kuwLzMN7iMZdg94coDrPBJb+ucO3QXyJYxLtHkac+SCxPpmB56hVql5TztmJvTF
         WrHgwCz+Ra2ccEW+4acGL4c1Eod8COZ0E47kYkrwCYHVSWPmuipOYjqrmXIyZzmeN5OR
         ZVgjvIHEHridelUnHSO9HDxK5hdERFWFXgLxsfqwo47FtkQBPZF4FbxeZnnpD5SNIgXQ
         5WKeLTbDWqtrVS4X4U13f+Ru/22fKbxayjrV+1hNXgCYO9lTXV8/jjoZa7Kh2s1Svdgv
         7Jaw==
X-Gm-Message-State: ACgBeo2dz1QuB1BqyYcPmIQCuSMwDfuJJG0JFfE88xpH5gZ/2eUhq84u
        JrOUQzVPuszHAvxCrET06ugztgUMs2Fs2jrrqCTQ4JFR35P2rnP+F2KyrCUJ0tiiVrgRyBOTEAH
        fAp/JHP+SziCVFh6GjjPIaXVHWqIqNkct3Aq8QiOWd6VW65iEmUACSCMru2cStjU=
X-Google-Smtp-Source: AA6agR6dgkGBDlh0rvSP6cHQDe4O2i9+BqdkG6d3wGniU9eAQv65BzuHTVRI5h1dCXl855yekQ7KvJtk8rs5+Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:8892:0:b0:52e:14cb:7e67 with SMTP id
 z18-20020aa78892000000b0052e14cb7e67mr5053053pfe.35.1659551013353; Wed, 03
 Aug 2022 11:23:33 -0700 (PDT)
Date:   Wed,  3 Aug 2022 11:23:26 -0700
In-Reply-To: <20220803182328.2438598-1-ricarkol@google.com>
Message-Id: <20220803182328.2438598-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220803182328.2438598-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [kvm-unit-tests PATCH v2 1/3] arm: pmu: Add missing isb()'s after sys
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

Add the missing isb()'s on all failing tests, plus some others that seem
required:
- after clearing the overflow signal in the IRQ handler to avoid
  spurious interrupts.
- after direct writes to PMSWINC_EL0 for software to read the correct
  value for PMEVNCTR0_EL0 (from ARM DDI 0487H.a, page D13-5237).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 15c542a2..76156f78 100644
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
@@ -821,10 +832,13 @@ static void test_overflow_interrupt(void)
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x2, pmswinc_el0);
 
 	set_pmcr(pmu.pmcr_ro);
+	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
 	/* enable interrupts */
@@ -879,6 +893,7 @@ static bool check_cycles_increase(void)
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
 	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
+	isb();
 
 	for (int i = 0; i < NR_SAMPLES; i++) {
 		uint64_t a, b;
@@ -894,6 +909,7 @@ static bool check_cycles_increase(void)
 	}
 
 	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
+	isb();
 
 	return success;
 }
-- 
2.37.1.455.g008518b4e5-goog

