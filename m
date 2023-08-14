Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8DB77B7D6
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjHNLwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjHNLvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:54 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C45EA;
        Mon, 14 Aug 2023 04:51:53 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id 5614622812f47-3a7e68f4214so2310527b6e.1;
        Mon, 14 Aug 2023 04:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013912; x=1692618712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAnTwD22KZ81y7xJz7a0vclcrgGfIXcxvg6CFL8Xcrc=;
        b=OW1tTsUjYIgnFTNASqTQDFsgvjuoaSG2rvlkNdz2D8EOyZ67O442FuAupOitQo4IiX
         ajBK8WT0PsSkYSvZklnsp4Ak2tEdrYx6jGrqWhusqLxgxf0+VfWBNISmyuFEEywssiLq
         hnv4Ddz5SLUElA1yNX/N5lzgLYufJNHwm5FoNv8HwkuoPp/9wYXEGisfLgJZUU2rQsyL
         AxgxpvoEMojMSDVew0Wr1kgtcNWhKIsm5GYHHDrSirJIVDvpxL8oRsbVdAa3RdQDU9ip
         5HYJz5nIP48gDa3JZpb//RvLiQ1uzDUwbh8AhXAZLHRDG9E9tw7aaT2sRXoOe8NSekb4
         pdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013912; x=1692618712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAnTwD22KZ81y7xJz7a0vclcrgGfIXcxvg6CFL8Xcrc=;
        b=jDhpBRVYk4YrgwcbJT+EVKta70jb3UrBs3VLpQe1+oIxih9N4ckLG+AV9zSwSy8MLa
         sQCbGbFO+EF/uo7UFiu8o7q/f6y0RFRTC2nCDYKsPYIxgoTm0B+aB+N+lBiCrDQXFZPk
         4BCD9eUKx1jEPeF/NyDtzAtE+zIQySiNy5BHJvjbU1EQ+jShGJT3qvjo0DY39Fk2Yc4o
         Yd2BNhYOp0EObXTXKR7gKx7Gs1iDkld8KMpUDyLu1E+bmW4sYDq/MR29w+BAp+py5IdN
         YRHDnP5Nf8qFvOM82N88sTfF8Q+Lm06XLO0Ba9ClnFTygWj+S1pgpii9+ZRy2/4AH72B
         bnhg==
X-Gm-Message-State: AOJu0YyttzKugaq0o29P/qUJtIbJ5L+bjPa2CmvFhOIHZ//Vk/3jiVLo
        FRMoc5IHyuN1s6sgfYb3X5o=
X-Google-Smtp-Source: AGHT+IFaui22yNQmJ36TxGx1GYH5YcA89QCYxtfaD2QJjR15nNI3dc3oluMwDtwi6gKJzFBoMMwLjA==
X-Received: by 2002:a05:6808:2124:b0:3a7:82e8:8fd1 with SMTP id r36-20020a056808212400b003a782e88fd1mr12131771oiw.20.1692013912628;
        Mon, 14 Aug 2023 04:51:52 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:52 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/11] KVM: selftests: Test AMD PMU events on legacy four performance counters
Date:   Mon, 14 Aug 2023 19:51:07 +0800
Message-Id: <20230814115108.45741-11-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
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

From: Jinrong Liang <cloudliang@tencent.com>

Add tests to check AMD PMU legacy four performance counters.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 72 ++++++++++++++-----
 1 file changed, 54 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index 70adfad45010..cb2a7ad5c504 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -58,20 +58,29 @@ static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
 
 static void guest_measure_loop(uint64_t event_code)
 {
-	uint32_t nr_fixed_counter = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
-	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
-	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
+	uint8_t nr_gp_counters, pmu_version = 1;
+	uint64_t event_sel_msr;
 	uint32_t counter_msr;
 	unsigned int i;
 
-	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
-		counter_msr = MSR_IA32_PMC0;
-	else
-		counter_msr = MSR_IA32_PERFCTR0;
+	if (host_cpu_is_intel) {
+		nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+		pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
+		event_sel_msr = MSR_P6_EVNTSEL0;
+
+		if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+			counter_msr = MSR_IA32_PMC0;
+		else
+			counter_msr = MSR_IA32_PERFCTR0;
+	} else {
+		nr_gp_counters = AMD64_NR_COUNTERS;
+		event_sel_msr = MSR_K7_EVNTSEL0;
+		counter_msr = MSR_K7_PERFCTR0;
+	}
 
 	for (i = 0; i < nr_gp_counters; i++) {
 		wrmsr(counter_msr + i, 0);
-		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
+		wrmsr(event_sel_msr + i, ARCH_PERFMON_EVENTSEL_OS |
 		      ARCH_PERFMON_EVENTSEL_ENABLE | event_code);
 
 		if (pmu_version > 1) {
@@ -85,7 +94,12 @@ static void guest_measure_loop(uint64_t event_code)
 		}
 	}
 
-	if (pmu_version < 2 || nr_fixed_counter < 1)
+	if (host_cpu_is_amd || pmu_version < 2)
+		goto done;
+
+	uint32_t nr_fixed_counter = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+
+	if (nr_fixed_counter < 1)
 		goto done;
 
 	if (event_code == intel_arch_events[INTEL_ARCH_INSTRUCTIONS_RETIRED])
@@ -407,19 +421,41 @@ static void intel_test_pmu_version(void)
 	}
 }
 
+static void amd_test_pmu_counters(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	unsigned int i;
+	uint64_t msr_val;
+
+	for (i = 0; i < ARRAY_SIZE(amd_arch_events); i++) {
+		vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_measure_loop);
+		vcpu_args_set(vcpu, 1, amd_arch_events[i]);
+		while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
+			TEST_ASSERT(msr_val, "Unexpected AMD counter values");
+
+		kvm_vm_free(vm);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
 
-	TEST_REQUIRE(host_cpu_is_intel);
-	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
-	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
-
-	intel_test_arch_events();
-	intel_test_counters_num();
-	intel_test_fixed_counters();
-	intel_test_pmu_version();
+	if (host_cpu_is_intel) {
+		TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
+		TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
+
+		intel_test_arch_events();
+		intel_test_counters_num();
+		intel_test_fixed_counters();
+		intel_test_pmu_version();
+	} else if (host_cpu_is_amd) {
+		amd_test_pmu_counters();
+	} else {
+		TEST_FAIL("Unknown CPU vendor");
+	}
 
 	return 0;
 }
-- 
2.39.3

