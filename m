Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D127D43F8
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjJXA1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjJXA1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:27:05 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CDA1707
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cbe08af374so6023875ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107213; x=1698712013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9PRm2qPI6Hb9eDZmaLCMIjwG1XEncicGFs+ftKdyMw0=;
        b=GeXm48usbyMoKFGdJEwQhQDL9/O9HJeRxfbvPhBBb1X52Twog2iuZNPGRwm7iSyWdM
         sO0ZTWxrEGzzaAGMEEChkCfv8CDlpo82tpYElzaooxFKkFy26Y72SQHlvFLnj1WtxraZ
         6taImWgIfq8Q8pqOpHD1n73cqwikfXNzSUe1JKbkN2MV25TVCwBHUWlrl9v+ysJnWuy+
         YYJJY3Q5AAAGPuQDVqWyqGj1apgDtP3gKItyKway2+y2mcduhcSL4AMK+jio3ve2NZ+E
         PxuND/AqDrvQ+bjLYzTEGOad+1UJ89KBBhOws3ACJJ0DaBIbO49g9h81GQDCBDusyf/d
         RZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107213; x=1698712013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9PRm2qPI6Hb9eDZmaLCMIjwG1XEncicGFs+ftKdyMw0=;
        b=s1NciPcyxYPdga6TNqj/60EGzItFMlOO2hITfNc3FvGS73fRD3hn9cEDG0TihSGcFP
         nRGymU+XVkdrtVLpeWE5xEk87qABh2IBKhCNegDNJsl9xS8mH+TjptPrVUdZs0cZeXhs
         q+GUjWYUbmUWOKuPWHq0bkOsuodAq59igVJAAEbIvA6ZI8Cq0qOes+S/IxO81KJ18eWw
         TVCOJx9ZISgJuwkzJDQehEkFmh00vwb9atko8J1pMblm2U8yzU/aeqwc8x6tMRnrdexq
         V+XB4yt+ycHgFbKqNOR/yoeSntrXOmWjoKSYc+i8YEvk538rScCiHhkVOSDuQsbq0/Kq
         a9/A==
X-Gm-Message-State: AOJu0YzFjj2B9tyCSlqmh2u/0lXADqqrU97i5JU2eEyIuMXU5JF3o9rV
        WZVagIPa/ldUQ4XZI19TxcsOwBIzrho=
X-Google-Smtp-Source: AGHT+IGr/Ltfu/OlTtvWVK+MrFF2S+e43S2CPrXujZtJlpcEbSKWXqMzh5K491VXBI+wesKAWcCTfWmzOsE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:8c:b0:1ca:8629:82a3 with SMTP id
 o12-20020a170903008c00b001ca862982a3mr170488pld.6.1698107213086; Mon, 23 Oct
 2023 17:26:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:29 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-10-seanjc@google.com>
Subject: [PATCH v5 09/13] KVM: selftests: Test Intel PMU architectural events
 on fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Update test to cover Intel PMU architectural events on fixed counters.
Per Intel SDM, PMU users can also count architecture performance events
on fixed counters (specifically, FIXED_CTR0 for the retired instructions
and FIXED_CTR1 for cpu core cycles event). Therefore, if guest's CPUID
indicates that an architecture event is not available, the corresponding
fixed counter will also not count that event.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 54 ++++++++++++++++---
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 2a6336b994d5..410d09f788ef 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -85,23 +85,44 @@ static void guest_measure_pmu_v1(struct kvm_x86_pmu_feature event,
 	GUEST_DONE();
 }
 
+#define X86_PMU_FEATURE_NULL						\
+({									\
+	struct kvm_x86_pmu_feature feature = {};			\
+									\
+	feature;							\
+})
+
+static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
+{
+	return !(*(u64 *)&event);
+}
+
 static void guest_measure_loop(uint8_t idx)
 {
 	const struct {
 		struct kvm_x86_pmu_feature gp_event;
+		struct kvm_x86_pmu_feature fixed_event;
 	} intel_event_to_feature[] = {
-		[INTEL_ARCH_CPU_CYCLES]		   = { X86_PMU_FEATURE_CPU_CYCLES },
-		[INTEL_ARCH_INSTRUCTIONS_RETIRED]  = { X86_PMU_FEATURE_INSNS_RETIRED },
-		[INTEL_ARCH_REFERENCE_CYCLES]	   = { X86_PMU_FEATURE_REFERENCE_CYCLES },
-		[INTEL_ARCH_LLC_REFERENCES]	   = { X86_PMU_FEATURE_LLC_REFERENCES },
-		[INTEL_ARCH_LLC_MISSES]		   = { X86_PMU_FEATURE_LLC_MISSES },
-		[INTEL_ARCH_BRANCHES_RETIRED]	   = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
-		[INTEL_ARCH_BRANCHES_MISPREDICTED] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
+		[INTEL_ARCH_CPU_CYCLES]		   = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED]  = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
+		/*
+		 * Note, the fixed counter for reference cycles is NOT the same
+		 * as the general purpose architectural event (because the GP
+		 * event is garbage).  The fixed counter explicitly counts at
+		 * the same frequency as the TSC, whereas the GP event counts
+		 * at a fixed, but uarch specific, frequency.  Bundle them here
+		 * for simplicity.
+		 */
+		[INTEL_ARCH_REFERENCE_CYCLES]	   = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_CYCLES_FIXED },
+		[INTEL_ARCH_LLC_REFERENCES]	   = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_LLC_MISSES]		   = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_RETIRED]	   = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
 	};
 
 	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
-	struct kvm_x86_pmu_feature gp_event;
+	struct kvm_x86_pmu_feature gp_event, fixed_event;
 	uint32_t counter_msr;
 	unsigned int i;
 
@@ -132,6 +153,23 @@ static void guest_measure_loop(uint8_t idx)
 			GUEST_ASSERT_EQ(this_pmu_has(gp_event), !!_rdpmc(i));
 	}
 
+	fixed_event = intel_event_to_feature[idx].fixed_event;
+	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
+		goto done;
+
+	i = fixed_event.f.bit;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	if (pmu_is_intel_event_stable(idx))
+		GUEST_ASSERT_NE(_rdpmc(PMC_FIXED_RDPMC_BASE | i), 0);
+
+done:
 	GUEST_DONE();
 }
 
-- 
2.42.0.758.gaed0368e0e-goog

