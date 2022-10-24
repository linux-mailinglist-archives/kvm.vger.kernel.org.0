Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD652609DA0
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiJXJNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiJXJNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:44 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2374C69BFE
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:28 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g28so8463476pfk.8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDxVmBPiY3G5DtYBGeO+YP21IvKefS3GSWM3I4vd7Lo=;
        b=iW5a1ThUt66QtDBNy2YNm6kq5EfVRDlawHglCEuDZvzncjdEmUmQuRk7STVqBD+RSd
         RMQgDmCPpzk531w+y6WISQGcz/IGiE6yQ7473nJ98CHruQFsO89a/PFCsb8KzqpTmwhc
         mlJj3UB7trCPnIkJbsV7ncqtpt6gZnFYXwKoolvRMv9/l5Av837Rd9C2cci8K7StJSHs
         qdb/bd5AIyRccvVQzl6viBEi6zXhXwynJzF3aX7HpFqrOYjxIGhWGQXQSCbrHZD1jcxb
         CXN43gd4ZF5pnb2XNlqgRE9mdkrQqkuzS7qYWoMlFNc/krD3EBtwkSitGjCGt6Op07eY
         8ZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BDxVmBPiY3G5DtYBGeO+YP21IvKefS3GSWM3I4vd7Lo=;
        b=KempdjZ0KRjrctYQFJ0Im1s4NbtEw2OxO7vtBQF7At2cKNCzUrsft5n/BBnFUxh7qS
         6koKepPiRBBzcDj2FGG/OkXeBfP5PP9YfX6gS1zY0rV3JwVHlnX1G9a/yy02f21QZzG/
         10fSwMJyR+C1/qfAFMwbWjgSuoVaUDs/ZWiyZm4be95iAL9dg9y2kWPn6pMMkU4mGJ7t
         N+CoEOmidX0WWfdqF5NiF3PYlNM17UGrdgO4DifM2vKNWS1JuJkdmCdRohExb6L7qCrb
         w+op3vlxdzhkdxRnElmLFLu0tbRPgCBNMVgt3LMfbF2fJJTi6WFeIRWj6IK0px/m1Puz
         URJw==
X-Gm-Message-State: ACrzQf1JeGrezgW0q1hZ+KNUAb2UKe9mtlT1rU/V9b//a0P7FXR4ipf7
        rNDN6jWEIJ9VDhaa+vhR2Vg=
X-Google-Smtp-Source: AMsMyM66CEvOL3DQgH3BFlJIAHocznhu6f9B+0yMKhylH1zKk6Ai4LQp8Fo+vzFOkKGKYDanwpz7iw==
X-Received: by 2002:aa7:88c4:0:b0:563:9fe9:5da9 with SMTP id k4-20020aa788c4000000b005639fe95da9mr32434577pff.41.1666602806074;
        Mon, 24 Oct 2022 02:13:26 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:25 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 15/24] x86/pmu: Initialize PMU perf_capabilities at pmu_init()
Date:   Mon, 24 Oct 2022 17:12:14 +0800
Message-Id: <20221024091223.42631-16-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Re-reading PERF_CAPABILITIES each time when needed, adding the
overhead of eimulating RDMSR isn't also meaningless in the grand
scheme of the test.

Based on this, more helpers for full_writes and lbr_fmt can also
be added to increase the readability of the test cases.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/pmu.c |  3 +++
 lib/x86/pmu.h | 18 +++++++++++++++---
 x86/pmu.c     |  2 +-
 x86/pmu_lbr.c |  7 ++-----
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index e8b9ae9..35b7efb 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -1,8 +1,11 @@
 #include "pmu.h"
 
 struct cpuid cpuid_10;
+struct pmu_caps pmu;
 
 void pmu_init(void)
 {
     cpuid_10 = cpuid(10);
+    if (this_cpu_has(X86_FEATURE_PDCM))
+        pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 }
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 7f4e797..95b17da 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -33,7 +33,12 @@
 #define EVNTSEL_INT	(1 << EVNTSEL_INT_SHIFT)
 #define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
 
+struct pmu_caps {
+    u64 perf_cap;
+};
+
 extern struct cpuid cpuid_10;
+extern struct pmu_caps pmu;
 
 void pmu_init(void);
 
@@ -91,10 +96,17 @@ static inline bool pmu_gp_counter_is_available(int i)
 
 static inline u64 this_cpu_perf_capabilities(void)
 {
-	if (!this_cpu_has(X86_FEATURE_PDCM))
-		return 0;
+	return pmu.perf_cap;
+}
 
-	return rdmsr(MSR_IA32_PERF_CAPABILITIES);
+static inline u64 pmu_lbr_version(void)
+{
+	return this_cpu_perf_capabilities() & PMU_CAP_LBR_FMT;
+}
+
+static inline bool pmu_has_full_writes(void)
+{
+	return this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES;
 }
 
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index 46e9fca..a6329cd 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -669,7 +669,7 @@ int main(int ac, char **av)
 
 	check_counters();
 
-	if (this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES) {
+	if (pmu_has_full_writes()) {
 		gp_counter_base = MSR_IA32_PMC0;
 		report_prefix_push("full-width writes");
 		check_counters();
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index e6d9823..d013552 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -43,7 +43,6 @@ static bool test_init_lbr_from_exception(u64 index)
 
 int main(int ac, char **av)
 {
-	u64 perf_cap;
 	int max, i;
 
 	setup_vm();
@@ -63,15 +62,13 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
-	perf_cap = this_cpu_perf_capabilities();
-
-	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
+	if (!pmu_lbr_version()) {
 		report_skip("(Architectural) LBR is not supported.");
 		return report_summary();
 	}
 
 	printf("PMU version:		 %d\n", pmu_version());
-	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
+	printf("LBR version:		 %ld\n", pmu_lbr_version());
 
 	/* Look for LBR from and to MSRs */
 	lbr_from = MSR_LBR_CORE_FROM;
-- 
2.38.1

