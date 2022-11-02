Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA84A6170EE
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiKBWwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiKBWv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58B0F038
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:49 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id f186-20020a636ac3000000b0044adaa7d347so52778pgc.14
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=99R5fgXDiNtEBKarKzft5KDCSlUA88/o7ftNdKC/2uw=;
        b=qtW4psJlhV6EQISIdALrZ7XaXEhzEm83nvsYOwqN/K372vSwWVLCaYXPthRYOoaIfa
         ocuh5avicu+w6tKHdU7jTsPbHKkEA5w+SUvEzFh4GoGSsJKGv3n7vDuB5MPCuwMjgvag
         234qxyuknRabduCo7CxcpmwI/oMMgmqEe6KR9jlpl6ZHILiU1odZZA0BGvg0dNHkz16H
         9ZVyjSbkA7nCtmLvtF3TrCX74NS9XwdU+c9e5fGLFC5gOqtZrxxPi/0qBHAX4F9FDca/
         rv9mgKRg5QlxTmM/e0KOvaUN/Vb/vSePAIBBYWoe2DY/fK4N8lpkFMJaK4lgom9Lg8hz
         35Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99R5fgXDiNtEBKarKzft5KDCSlUA88/o7ftNdKC/2uw=;
        b=6cjpNnFDQN+FAmdCenqSWFr1K8Oye9qyHj2APWAXDbKOm253Ag3/OMitVNB8THNpB6
         pIEWm3abnN0XjMm7NuFpltG41UWKWtPABUhZMN6/Nu4GljKHd4RStF3UMlNYBp+faXs9
         vzyeNEtF4PYaHHt5q6822XPn2hyDoKb3BGIUffarqEkW2vG7eo4bPtFQJrAcscSsfyT+
         84u17nhIVOgLEP70q5CtGl9QCLtuReOlOO3r+Ycta0OKueF2Kr+za2bOkfSAdiqmtmOZ
         fa1yFvI9tm9VCPp32iuUBXgK2jglGWbkyFUi1tKUe8KgDs14NC4y6i/dbdO/DTp1SQYZ
         T4GA==
X-Gm-Message-State: ACrzQf2bQECfEn5RkXHYhRq7OiDlTUfCvPG6WqXWiJ/OKZveCQ3Cc3Iz
        ICQzkX/7b+GbbUkvS3YdrsJcvle/+Uw=
X-Google-Smtp-Source: AMsMyM51DpMrDGAmdf1xbS9X3VW3FDGJBGhXHrnGCGvhSCom0zRT111zlhMJ7y3tsPxHLq52UZ5GELR6ooI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1253:b0:56d:8742:a9ff with SMTP id
 u19-20020a056a00125300b0056d8742a9ffmr17045271pfi.5.1667429500798; Wed, 02
 Nov 2022 15:51:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:58 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-16-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 15/27] x86/pmu: Snapshot PMU
 perf_capabilities during BSP initialization
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

Add a global "struct pmu_caps pmu" to snapshot PMU capabilities
during the final stages of BSP initialization.  Use the new hooks to
snapshot PERF_CAPABILITIES instead of re-reading the MSR every time a
test wants to query capabilities.  A software-defined struct will also
simplify extending support to AMD CPUs, as many of the differences
between AMD and Intel can be handled during pmu_init().

Init the PMU caps for all tests so that tests don't need to remember to
call pmu_init() before using any of the PMU helpers, e.g. the nVMX test
uses this_cpu_has_pmu(), which will be converted to rely on the global
struct in a future patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: reword changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c   |  8 ++++++++
 lib/x86/pmu.h   | 21 ++++++++++++++++++---
 lib/x86/setup.c |  2 ++
 x86/pmu.c       |  2 +-
 x86/pmu_lbr.c   |  7 ++-----
 5 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 9d048abc..bb272ab7 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -1 +1,9 @@
 #include "pmu.h"
+
+struct pmu_caps pmu;
+
+void pmu_init(void)
+{
+	if (this_cpu_has(X86_FEATURE_PDCM))
+		pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+}
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 078a9747..4780237c 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -33,6 +33,14 @@
 #define EVNTSEL_INT	(1 << EVNTSEL_INT_SHIFT)
 #define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
 
+struct pmu_caps {
+	u64 perf_cap;
+};
+
+extern struct pmu_caps pmu;
+
+void pmu_init(void);
+
 static inline u8 pmu_version(void)
 {
 	return cpuid(10).a & 0xff;
@@ -91,10 +99,17 @@ static inline bool pmu_gp_counter_is_available(int i)
 
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
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index a7b3edbe..1ebbf58a 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -15,6 +15,7 @@
 #include "apic-defs.h"
 #include "asm/setup.h"
 #include "atomic.h"
+#include "pmu.h"
 #include "processor.h"
 #include "smp.h"
 
@@ -398,4 +399,5 @@ void bsp_rest_init(void)
 	bringup_aps();
 	enable_x2apic();
 	smp_init();
+	pmu_init();
 }
diff --git a/x86/pmu.c b/x86/pmu.c
index 7d67746e..627fd394 100644
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
index e6d98236..d0135520 100644
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
2.38.1.431.g37b22c650d-goog

