Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0937169DBEB
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 09:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbjBUI35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 03:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbjBUI3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 03:29:53 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFBE233D1;
        Tue, 21 Feb 2023 00:29:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id e5so5231232plg.8;
        Tue, 21 Feb 2023 00:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkejIJ/ewx23N/WQCdpAyX4kI9mx9e+IZS2vzWc4m3U=;
        b=f3u/AZPdaqSHj0bjil/r9jJ2SsdMj6FISC2s3Ppl84M1SZZtuMPsv+V/I++9Tcclas
         ytcyXb6f2BTNouvI8uTex4Dg1uHfunnPYizf/7nR2OdHpr9PdhV16yCtCve2sLJY/LaB
         aDkRwjJOsdVvbL2OKF3O9Q7V++IEmZhagYs7wpaAbBarEq5ET7Vbv9Y89Af9fSbVpSSN
         BtW6aLRbA8NoTg6RVZH21+TAZJCd/+3aQ4W0Xyrm+y2+DNsNc/Q+k61AoFrmSp/Zf6il
         LaOhBxx/a7eZGNB+hL8eQ0dG6+7pOEk2zJ80dn/uvXkATBxr9ud3CWIuELjYofyw2qQz
         HCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZkejIJ/ewx23N/WQCdpAyX4kI9mx9e+IZS2vzWc4m3U=;
        b=QisnUUvRSzoQpZuZGqi2FEsTRBDnGqlX/Tc58659LpB5DaDWWY4KGe1L12JL4MvdAN
         IMTwe25kemufNOSHjc6q0grgxuPPEY0/7YozyZpy4I+Kedxpu4Q6CMetJ5Ir8SEUXNNF
         CG0WF4hTNq6BUAwazCG2KSOLZKxgvag8kamjhuFF83OrHinGApW7hK1RTbFpZBGB0hu8
         rnwaLWz0tJ9k+c0wMbMXRehQx/bOn7SHcHryglnqdMVNc5m1wfabF1w/Of4/L3xz+Hr4
         4kgGpnV8Y3tdy/abygDwe0LNDo5e4OdRNlyEPOKRRvgI3T3cKoAv7AXN8wmwepq03LT8
         VaXA==
X-Gm-Message-State: AO0yUKXQCSLMlxQP/WH83QI4JWDoDw2SAk9FJXQv/hUadqMadkjGBs+J
        9Wu0HSoFQWJnLNchRHPrxOE=
X-Google-Smtp-Source: AK7set8wrJpFrU5r+5p3/X5A33DTb3ReLnXOpz4cxOIPPAW9QcP3jgErFXYUQuWGI4U6NFtnhDGYBA==
X-Received: by 2002:a17:902:d505:b0:19a:debb:58f7 with SMTP id b5-20020a170902d50500b0019adebb58f7mr3762503plg.13.1676968191912;
        Tue, 21 Feb 2023 00:29:51 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t9-20020a170902a5c900b00196896d6d04sm2988686plq.258.2023.02.21.00.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 00:29:51 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86/pmu: Check counter is working properly before AMD pmu init
Date:   Tue, 21 Feb 2023 16:29:25 +0800
Message-Id: <20230221082925.16014-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
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

Avoid misleading pmu initialisation when vPMU is globally disabled
by performing a read/write consistency test on one of AMD's counters.
Without this check, pmu test will fail rather than be skipped.

Given some historical reasons, the expectation that AMD counter write
values lead to #GP when vPMU is globally disabled is not in line with
the architectural specification (even when not disabled, writing to AMD
reserved bits will likely not result in #GP, but more of a filtered write),
and like many mature guests, KUT can test the consistency of read and
write values against a counter MSR that must be supported to determine
if the PMU is available and continue testing.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Nit:
- A generic "durable" MSRs check could be applied later if need;
- Two more tests: 20221226075412.61167-1-likexu@tencent.com;

 lib/x86/pmu.c | 16 +++++++++++++++-
 x86/pmu.c     |  3 +++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 0f2afd6..1e23a17 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -2,6 +2,20 @@
 
 struct pmu_caps pmu;
 
+/*
+ * All AMD CPUs that support vPMU have MSR_K7_PERFCTRx, but the
+ * values written to it are discarded when vPMU is globally disabled.
+ */
+static inline bool amd_k7_counter_is_durable(void)
+{
+    u64 after, before = (1ull << PMC_DEFAULT_WIDTH) - 1;
+
+    wrmsr_safe(MSR_K7_PERFCTR0, before);
+    rdmsr_safe(MSR_K7_PERFCTR0, &after);
+
+    return before == after;
+}
+
 void pmu_init(void)
 {
 	pmu.is_intel = is_intel();
@@ -38,7 +52,7 @@ void pmu_init(void)
 			pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
 			pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
 		}
-	} else {
+	} else if (amd_k7_counter_is_durable()){
 		if (this_cpu_has(X86_FEATURE_PERFCTR_CORE)) {
 			/* Performance Monitoring Version 2 Supported */
 			if (this_cpu_has(X86_FEATURE_AMD_PMU_V2)) {
diff --git a/x86/pmu.c b/x86/pmu.c
index 72c2c9c..1f041e6 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -684,6 +684,9 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
+	} else if (!pmu.nr_gp_counters) {
+		report_skip("No AMD PMU is detected!");
+		return report_summary();
 	} else {
 		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
 		gp_events = (struct pmu_event *)amd_gp_events;

base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.39.2

