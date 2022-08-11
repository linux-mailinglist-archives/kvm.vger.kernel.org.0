Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63277590698
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 21:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiHKSwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 14:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbiHKSwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 14:52:21 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC699DB7C
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:20 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-32851d0f8beso157618607b3.22
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=hZ5qGKKiUKkw1fqPsVoeWYEgPkjp69U3hEQvPplzfvk=;
        b=GU5lkgJX69idfN2d8JbckBIkC4aHLRil8U4m/JOxyBQ0FK87bDtii7WCALqoXtsYEu
         8gt3Oi7J6uaZ7e77mig5FNqzNOAEz8h0GA21MH/Qy6x/l7lH1i2Cwj1wfI4cU5Ssjj9q
         xSIUnJyrv7l9JbMaz6NOwDRKQoNGbrRgLmtLx5uVvTyL0SY+SflE9iphBpBO2Zyfg1H0
         4LDMkO4qiSOAqzVLSzqPwPbJTvbqNnm457gBp1yAt4sGcru0y/w3USkBBvk+M39juQ5o
         uaJlabuMoyHSrfc+SIWXoQKDDtfD0GDcwK0gkzyIinHiHXRmF+4ShhXkXZ4orxtUgzuj
         KStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=hZ5qGKKiUKkw1fqPsVoeWYEgPkjp69U3hEQvPplzfvk=;
        b=bANFzQABSLJpyO7kRrb/tzmsLuucBZoos/nPVbMJZO6tlrFeab3uf8hrBrCTeSXxHt
         dlAsTH1LaVeuMOZa/LZvP0qyg2gG5ip7MMTa6GeQLlc/vpn8JbUEvFUPSajL6NGD9DpI
         OWJjQEg46zvkU9LUdp7g8sLAqJLcD8cbDVX24qdVw8yza3xT+ffBg2blP70fUj8MAf+s
         7qKblcAJgl1YCrcJHjY/2EIL89P+IqSA+DhGr52jbjcNE63g8SoN9E2+q64ssl59mc8I
         dzIruXPtiOFGCrshgKUK32z2iUYrwd1qqFBJH/m3Ndk1imPNx5dSXVHtISQBDyJGZHus
         4Zqg==
X-Gm-Message-State: ACgBeo1vzPqbGBuJKlefwnFU07kTdHR/YqbKvi2P2x74c0EA/XPpYXll
        ZfpxPXcHnb3rmyL0CR9fLsxpcPJH9WLUEnZUGSt1MnsNuZoByY3QAFufS7HRvGaScrm0H7tYPfm
        FA5DhxvSZawTmGNdjFhCuTTfzYEF/UYAS56iTKj5xE/lrh6C/FibEd/sdxsNpYBc=
X-Google-Smtp-Source: AA6agR70CWqtzcvuMK/sClY7Dw2wWjBzu7ZjCcMyhILiex8btb4PBZ86HtRsiEPXyfjMX31didUmEKfO3RYZ8g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a81:9b47:0:b0:325:2240:ce5 with SMTP id
 s68-20020a819b47000000b0032522400ce5mr620224ywg.210.1660243939175; Thu, 11
 Aug 2022 11:52:19 -0700 (PDT)
Date:   Thu, 11 Aug 2022 11:52:09 -0700
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
Message-Id: <20220811185210.234711-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220811185210.234711-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 3/4] arm: pmu: Reset the pmu registers
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index a5260178..756e0d26 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -842,7 +842,7 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
 	isb();
 
-	/* interrupts are disabled */
+	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
@@ -858,7 +858,7 @@ static void test_overflow_interrupt(void)
 	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
-	/* enable interrupts */
+	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
 
 	pmu_reset_stats();
 
@@ -906,6 +906,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -960,6 +961,7 @@ static bool check_cpi(int cpi)
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
-- 
2.37.1.559.g78731f0fdb-goog

