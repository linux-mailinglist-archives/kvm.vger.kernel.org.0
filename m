Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8C758A440
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 02:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiHEAls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 20:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiHEAlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 20:41:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86A36FA03
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 17:41:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e15-20020a17090301cf00b0016dc94ddcc5so709585plh.3
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 17:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=IkUE99B0TchNS4vqhItmmclxhXXwJ9wxAc8kOQ5+evM=;
        b=iVfcJW8RlHTsp+7/8Ai9Ar6TcPX/EvMkfx9Ea9osF8B/WeFcKJTGR5MvNNv1C9aR3D
         dPpsi/u/rJgjH15v3faO9zC5EdKesI2rs6biTyr0ayp3x4Opjln4sViOrhtDPkYsZN7/
         zHVUvjuftQKLseSsX4XYZlVEgF6fOEz2Xj8E/EaEbrafUJIVz6AUoLSnACjkTHbWvkHQ
         f5aJ8ht6Mq6aHZvmE4wyLtd09SO09NWmoNiCvYnmZXQotuzZoZUKbZu3Hn0r4aDZvoYI
         UXPhVBkqEinpEnZKG2rptUcvNeJS4pVhflPwPB9WGEvk98udF50S2IvLo9GRJhqGi9GH
         BhQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=IkUE99B0TchNS4vqhItmmclxhXXwJ9wxAc8kOQ5+evM=;
        b=Z+7i+mBtDSNsxZBcyff+3xi1eFe0Q2njgy6x2U8VC5Niw5+q86IdZSmkufw+sf0WZA
         sYIqeQ9If9U62eQo6eTWqu3nEgfiiKWx6tivebr0/vkmUDaWncU1Cqc6fJi65J2AHTlS
         peCc+czppBHpeG79DryVsAxlyoU2KlDWdJOifrAGGGpsFfzh6SywljWG6euAJrGEU351
         9whUi2pURA9/GQ8TkXapDHvmSS9bP2kFCLtx2QD9BarKADaiBXUMEC8+NkKmJU01vy89
         JLDk95rAGUvmNBMfYQSItT4s0fqGvxfFZ7V/JmP0WTyAHNCXlfV15jjiDB+Fq3kN1huj
         Ws6Q==
X-Gm-Message-State: ACgBeo1Cntd2zWEz5JIXfcYlKPFitrzIW3FWKsRgvvnppkAaqBcMydCF
        97ExFChOmtaZ5cVi1vSoIsL5SDD06b+rWfxTjaJXzQiOVjPooP86/CLelGNnKAKdSc2PYMhqpux
        +oQB9SLSo/6soNuQL6j5NtdUH5vkVkKiDDL49Lls5nktE81gHbfqmw8s4xxZJi+k=
X-Google-Smtp-Source: AA6agR4TcLN6Lga7RRZ0+dyIKf0ldH3fBJqtB88WLNxRgIPNyZKd3Bc+sF7uqhYAz2fvChCj+ulwcPDPdw6XaQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:a616:b0:16d:b3cf:9fe3 with SMTP
 id u22-20020a170902a61600b0016db3cf9fe3mr4127366plq.99.1659660105374; Thu, 04
 Aug 2022 17:41:45 -0700 (PDT)
Date:   Thu,  4 Aug 2022 17:41:38 -0700
In-Reply-To: <20220805004139.990531-1-ricarkol@google.com>
Message-Id: <20220805004139.990531-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220805004139.990531-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 2/3] arm: pmu: Reset the pmu registers
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 4c601b05..12e7d84e 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
 	isb();
 
-	/* interrupts are disabled */
+	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
@@ -842,7 +842,7 @@ static void test_overflow_interrupt(void)
 	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
-	/* enable interrupts */
+	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
 
 	pmu_reset_stats();
 
@@ -890,6 +890,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -944,6 +945,7 @@ static bool check_cpi(int cpi)
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
-- 
2.37.1.559.g78731f0fdb-goog

