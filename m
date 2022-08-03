Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B1358922E
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 20:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbiHCSXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 14:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbiHCSXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 14:23:37 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1F36402
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 11:23:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a17-20020a17090abe1100b001f320df2e97so1497566pjs.0
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 11:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=NCd9pZ1nHReYqpUxat1aRffhr9vnDsLXOgqhJFAxey4=;
        b=llw0yKtpNQpehkZ+QVXavGRSEMpGWCvk1V9rOY5p84zXQGCRh6aQK15QyIrz5fRQYV
         ksahlTxNw7rqH0KRxKGXwXS96EGD+yah7tZeI/ct+R/DdMRNGSg+FdmU7E5sYsy+JG83
         9mcTe5poTVEoB0PKjZePir/IDp8WBUPJJNmIZpzLeGA214xtAefmg8ZZenL+cI3KEgar
         ASOnLz344uqMuVY9bfA6e+s8b5I1QHmff5jNqpeShQMXEr3jprDSfi4gbDqk50KvPNqM
         BRwue+UlTPA1Z5h2X1RlWRJRThjGTPo+sHGsWYZOtk2iGvPk72aQcADalmF45dBqk2HK
         Zmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=NCd9pZ1nHReYqpUxat1aRffhr9vnDsLXOgqhJFAxey4=;
        b=aDauTpk0Vg3Di0uyc0t2bvsx+UZ3QzBDWkNF1S5zkp+vxePK5O1XLcKb5PYffiLDbH
         JGVE63UqgbtNJLgYHiUCoLR775OQ5Vxjd87+3MDHFVpBPnQF7oCPfTmZUIqEdMHwRtTE
         dAhtwEcXrUtb6JgCAgIQNxr+nR/ezQZFpSR/SAJC802etsCEFGssI/1b45TEEf8gFfng
         PKOeM6kt6RWfTosY5fbb1CCPaMlZAeqAcwwNtDGx8dT7BlpNpQ30B1oczsEAXzICvC7r
         dfoAWreLelEKYal9G+1O9lYV9ev8RDyh90LpQCwKm9FmEBV6dsY2+4OFvfHGhsmuafhA
         pp3g==
X-Gm-Message-State: ACgBeo3N6phXVueFjkdLF8C7+po3ccWXkAWaqGrzrDV3Le8JVGVIguYq
        tbAfA+2kjYt0p3b1pBy1ggRDPkfk0417NyV2LVLJmcO8hJCXyWLhMCD4DwnnrGXDj+h4tMR9DCz
        2AQcXylLCUz46f7W7bt5ssi5BHq8KxXMHVWiLo9JltOstUENPEmf/eyJFdszkJDQ=
X-Google-Smtp-Source: AA6agR46+fS5xqb633nq44y0Z/Fa4yZf37XU33PssxOX+2ZsgstmTBevMRPV9uxYjBsBsCd1m35M1FfY2MCy0g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:df03:b0:1f3:396c:dd94 with SMTP
 id gp3-20020a17090adf0300b001f3396cdd94mr435102pjb.1.1659551015065; Wed, 03
 Aug 2022 11:23:35 -0700 (PDT)
Date:   Wed,  3 Aug 2022 11:23:27 -0700
In-Reply-To: <20220803182328.2438598-1-ricarkol@google.com>
Message-Id: <20220803182328.2438598-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220803182328.2438598-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [kvm-unit-tests PATCH v2 2/3] arm: pmu: Reset the pmu registers
 before starting some tests
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

Some registers like the PMOVS reset to an architecturally UNKNOWN value.
Most tests expect them to be reset (mostly zeroed) using pmu_reset().
Add a pmu_reset() on all the tests that need one.

As a bonus, fix a couple of comments related to the register state
before a sub-test.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 76156f78..7c5bc259 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
 	isb();
 
-	/* interrupts are disabled */
+	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
@@ -841,7 +841,7 @@ static void test_overflow_interrupt(void)
 	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
-	/* enable interrupts */
+	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
 
 	pmu_reset_stats();
 
@@ -889,6 +889,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -943,6 +944,7 @@ static bool check_cpi(int cpi)
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
-- 
2.37.1.455.g008518b4e5-goog

