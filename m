Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443396DB736
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjDGXdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjDGXdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:33:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C87E180
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:33:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54bf8af4063so85533837b3.7
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LjYQi0+v1Gz3bnNu0ej5VXIh69X5CJjJWC5nav17cUU=;
        b=tLWkBtqU7eXFk3IWVSj+vF5W2EMxUvN0O93ECEFffu0DjOJq8QI03R1Djfx5xUtiBs
         6eR8jx3EpY9ditBySK/apDVrJ4rxBBFZDOfGqCijsurno0CzuK4JBQ1aNPWuXTLuGHnG
         nmxmKtSoKXMmz9pFXxSIu4N6Y06A/8GqIzjeo19AOEkhukjkt9MRVh8Islta60ImPhUE
         f/cPq8FKg1ki91AXJ6JQw/y2qVVo3jinOrLXZi3/Ai4ghEkaMy/1a9YE2K5ZNoBQkb/b
         2niLpe7IvL/laZMt1SNE1l0hc3jggzp+LMevymcgugam8b3aHEo5sRU1P+nnDEYR6J+t
         YOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjYQi0+v1Gz3bnNu0ej5VXIh69X5CJjJWC5nav17cUU=;
        b=ZiRZK2wWXQW0cJbfXzm8noHBJZD6iXBZ02IQB/CW76G2mtVBTKz84mJGfmKVfumMAc
         yfVZ0idwaFNlfdmRDqagFYKV0fIUqieP9RIaC4hEoIStLOCo6OEOicg8ZSqWktiiUjiH
         bBfMr+rdtxhirRrSDiULv3Bx73iBJjvZNriLwkYrFK459wL0r1kPz/4RGV06Ia4rvPZk
         x8Ioh5nRB+b7k18OcsfPIV2NtJs14DTiKurmU3/TlUUudwypBfHVSpbXN2RfhAfmWkqR
         5nQoBDOhAwmD9WCpBTPXP0ELyj9ivTf1XgIVGi+0aVY882EvOB18qoeYbnZSDiAYAf3p
         0h5w==
X-Gm-Message-State: AAQBX9cqhfhSBrnkXlJtaUAYk5cPpPiG8HFegUkAb9wVUenTkyoWQ9U9
        fODbiolZWmYyQZbtWcU0PNcBwa/VguU=
X-Google-Smtp-Source: AKy350ZGIgvvzPtmg5NGdNmrgppTBIcVWejRFYC/Vp/S+jdoW6dCFo3d557DTiyaJ6BwtZEEUMFAvk3oBNs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cf49:0:b0:b8b:fca4:7454 with SMTP id
 f70-20020a25cf49000000b00b8bfca47454mr2051230ybg.4.1680910388316; Fri, 07 Apr
 2023 16:33:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 Apr 2023 16:32:54 -0700
In-Reply-To: <20230407233254.957013-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230407233254.957013-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407233254.957013-7-seanjc@google.com>
Subject: [PATCH v4 6/6] KVM: selftests: Test the PMU event "Instructions retired"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

Add testing for the event "Instructions retired" (0xc0) in the PMU
event filter on both Intel and AMD to ensure that the event doesn't
count when it is disallowed.  Unlike most of the other events, the
event "Instructions retired" will be incremented by KVM when an
instruction is emulated.  Test that this case is being properly handled
and that KVM doesn't increment the counter when that event is
disallowed.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Link: https://lore.kernel.org/r/20230307141400.1486314-6-aaronlewis@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 34 +++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 5112aece3f95..40507ed9fe8a 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -54,6 +54,21 @@
 
 #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
 
+
+/*
+ * "Retired instructions", from Processor Programming Reference
+ * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
+ * Preliminary Processor Programming Reference (PPR) for AMD Family
+ * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
+ * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
+ * B1 Processors Volume 1 of 2.
+ *                      --- and ---
+ * "Instructions retired", from the Intel SDM, volume 3,
+ * "Pre-defined Architectural Performance Events."
+ */
+
+#define INST_RETIRED EVENT(0xc0, 0)
+
 /*
  * This event list comprises Intel's eight architectural events plus
  * AMD's "retired branch instructions" for Zen[123] (and possibly
@@ -61,7 +76,7 @@
  */
 static const uint64_t event_list[] = {
 	EVENT(0x3c, 0),
-	EVENT(0xc0, 0),
+	INST_RETIRED,
 	EVENT(0x3c, 1),
 	EVENT(0x2e, 0x4f),
 	EVENT(0x2e, 0x41),
@@ -76,6 +91,7 @@ struct {
 	uint64_t stores;
 	uint64_t loads_stores;
 	uint64_t branches_retired;
+	uint64_t instructions_retired;
 } pmc_results;
 
 /*
@@ -110,10 +126,12 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 static void run_and_measure_loop(uint32_t msr_base)
 {
 	const uint64_t branches_retired = rdmsr(msr_base + 0);
+	const uint64_t insn_retired = rdmsr(msr_base + 1);
 
 	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
 
 	pmc_results.branches_retired = rdmsr(msr_base + 0) - branches_retired;
+	pmc_results.instructions_retired = rdmsr(msr_base + 1) - insn_retired;
 }
 
 static void intel_guest_code(void)
@@ -127,7 +145,9 @@ static void intel_guest_code(void)
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
-		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x1);
+		wrmsr(MSR_P6_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | INST_RETIRED);
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
 
 		run_and_measure_loop(MSR_IA32_PMC0);
 		GUEST_SYNC(0);
@@ -149,6 +169,8 @@ static void amd_guest_code(void)
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
+		wrmsr(MSR_K7_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | INST_RETIRED);
 
 		run_and_measure_loop(MSR_K7_PERFCTR0);
 		GUEST_SYNC(0);
@@ -263,20 +285,26 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 #define ASSERT_PMC_COUNTING_INSTRUCTIONS()						\
 do {											\
 	uint64_t br = pmc_results.branches_retired;					\
+	uint64_t ir = pmc_results.instructions_retired;					\
 											\
 	if (br && br != NUM_BRANCHES)							\
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
 			__func__, br, NUM_BRANCHES);					\
 	TEST_ASSERT(br, "%s: Branch instructions retired = %lu (expected > 0)",		\
 		    __func__, br);							\
+	TEST_ASSERT(ir,	"%s: Instructions retired = %lu (expected > 0)",		\
+		    __func__, ir);							\
 } while (0)
 
 #define ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS()						\
 do {											\
 	uint64_t br = pmc_results.branches_retired;					\
+	uint64_t ir = pmc_results.instructions_retired;					\
 											\
 	TEST_ASSERT(!br, "%s: Branch instructions retired = %lu (expected 0)",		\
 		    __func__, br);							\
+	TEST_ASSERT(!ir, "%s: Instructions retired = %lu (expected 0)",			\
+		    __func__, ir);							\
 } while (0)
 
 static void test_without_filter(struct kvm_vcpu *vcpu)
@@ -329,6 +357,7 @@ static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
 
+	remove_event(f, INST_RETIRED);
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
 	test_with_filter(vcpu, f);
@@ -341,6 +370,7 @@ static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
 
+	remove_event(f, INST_RETIRED);
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
 	test_with_filter(vcpu, f);
-- 
2.40.0.577.gac1e443424-goog

