Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE4367D22C
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 17:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjAZQyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 11:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjAZQyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 11:54:04 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF47392AC
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:54:02 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id i17-20020a25bc11000000b007b59a5b74aaso2434155ybh.7
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOFFsrMOvyCTg6BeWwNjQP7I8O4rsRpyLcw1dHFSKvQ=;
        b=CLgqeDQXmoncZ2pXfsfJ+wxHgbm1Yc4B/40B7BOtexUUY4XjjyxkE3TCF00T5BUKOJ
         z/+ufWbrQFLAWEyjcfyqLaPKssvj1hAmmobsrK19z/DLUo0JpnPtPBoMpOaBO9Rt5R47
         p0RbMFAr7Iw2azc8+ShwmyYYh5X9GqW0zPt1X67uemPx6OUv9smJFomn87Sp/ymLSB6P
         lFqDds9eZMVp99u4L/3OHkTYMeKs/4aDDJDgdeoxZvoP2SR/W9peLqSvBKnqwy+P3eNm
         ajoSLTufrB+CUI0mkeCEIxHMEYmSiUhOnfWDLTIEiKf3JwQ8hCEJ13wAdniFzqgtJc31
         2Zbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOFFsrMOvyCTg6BeWwNjQP7I8O4rsRpyLcw1dHFSKvQ=;
        b=kJ9iuHZZ/7QRtZ70TyXxNct7P+cBn7uyH6/aRQVsqKV2emfZ4ZW1fv+m089iop+dSB
         5uAQX1Q5cZPTvGowU5qqdLotiacgTXLu4O+XTevFpbB/fYjFPW5B02TSFUa/TLNeTP4X
         EhBdAc+jwueB1a4IOJkvYig/bUf7yukksxCZq337Ab7zWQslXquUZdFrulMz9+5iPSb4
         WXFjDpncVlIi/68GpifUjyk1QXmli7IPLa7rMQAH54ZutWjTt8UkG6Ra0AQVyipUe+ey
         ELctsyJD2oQyGH3wsDp2JH6SZTpxB0mA0YZ0l9QAzghy6gQHVjyBo/4PxVsUH7eRCsYi
         WJjQ==
X-Gm-Message-State: AFqh2koTW+Gjt6gPj4jcxMli/4u8PVXn69ah3HTxwdboNowirQ7jUyhX
        1dl0dug+MhK4tYA9GzrF3TtOa862DX0sU5b7WaRLpY4yT3V1h+8EzNYSW43WziFah9jdj0zsziQ
        5ZN3+l05sUyR/HTpxqD04rQ9yhrkqOh2HSZWjIsAwZPdc+kdjTnS6yRzfLU/srX0=
X-Google-Smtp-Source: AMrXdXtDNv00dKI1COJb6goV4rKTo90bcFMRSqcNiTkW1VPWThNWNyyFGTdeqoIbJMFqeBzphd0+QvwpWlsJqQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:4d54:0:b0:7d4:e9c5:b6cf with SMTP id
 a81-20020a254d54000000b007d4e9c5b6cfmr4202442ybb.311.1674752042076; Thu, 26
 Jan 2023 08:54:02 -0800 (PST)
Date:   Thu, 26 Jan 2023 16:53:50 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-6-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 5/6] arm: pmu: Print counter values as hexadecimals
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/pmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 082fb41..1e93ea2 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -551,8 +551,8 @@ static void test_mem_access(bool overflow_at_64bits)
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
@@ -567,7 +567,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(read_sysreg(pmovsclr_el0) == 0x3,
 	       "Ran 20 mem accesses with expected overflows on both counters");
-	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
+	report_info("cnt#0=0x%lx cnt#1=0x%lx overflow=0x%lx",
 			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
 			read_sysreg(pmovsclr_el0));
 }
@@ -598,7 +598,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
+	report_info("SW_INCR counter #0 has value 0x%lx", read_regn_el0(pmevcntr, 0));
 	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"PWSYNC does not increment if PMCR.E is unset");
 
@@ -615,7 +615,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 	isb();
 	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
-	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
+	report_info("counter values after 100 SW_INCR #0=0x%lx #1=0x%lx",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
 		"overflow on counter #0 after 100 SW_INCR");
@@ -691,7 +691,7 @@ static void test_chained_sw_incr(bool unused)
 	report((read_sysreg(pmovsclr_el0) == 0x1) &&
 		(read_regn_el0(pmevcntr, 1) == 1),
 		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
 	/* 64b SW_INCR and overflow on CHAIN counter*/
@@ -712,7 +712,7 @@ static void test_chained_sw_incr(bool unused)
 	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
 	       (read_regn_el0(pmevcntr, 1) == cntr1),
 	       "expected overflows and values after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
@@ -744,11 +744,11 @@ static void test_chain_promotion(bool unused)
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
2.39.1.456.gfc5497dd1b-goog

