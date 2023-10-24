Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB277D43FD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjJXA1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjJXA1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:27:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8059310DA
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:27:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9cfec5e73dso3839596276.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107217; x=1698712017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+RoABScHftr6hc85optkCJ7nhZ5E1OiZawbS1myLt1k=;
        b=eMGZGAZkRO4INJO88zyNeJLn+DRIDaKftvYeybrSWKHr04FRGR3jYgdBGqt5xkFHAD
         ZJjgaEpzztwtuFxLc8DHNz/fQKIDWajon8LfcNUtDN2cGQHb8tKsW2w5VnAzKty5YLve
         67yAnoTlwuDLkRiqxHaQdcKZHeSFty1ErgaxUDLNS0FHnuDnblobFoNXqR4ujyALWXBP
         Jf42k1TVteAhtajErQva3jngeJY6IriDmnmKnQtTXZrcOPp8KQN0YfYeUQqA/yR3bien
         IUzPyo8f3PYVNBCTm2QnM4IiI5Z07YFtvy5D0XKvEKJFESxELcxqM/iIf6ZmCqPcn9LY
         Wrow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107217; x=1698712017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+RoABScHftr6hc85optkCJ7nhZ5E1OiZawbS1myLt1k=;
        b=RhhLmlxltq2CGBrGt75VPa6e+oacHEFczICMNGUPhFgN1UVvNnihfWdDqLM+mEsMbb
         VTT6PqVHnpuQVnZZYKfF7wQXR8egmAIYtsBEWj7pbs+EyzDNBI4xt1BzEOaT1qPyAj8I
         CN2GO1wZoGhCFDi8Ed5MTG/bTcCHVAij8DphbDBfmlrkbMBHh9Fg8Eej40pC7njfoPrI
         hs4JoPZd+KhKZDYxoZrx6TyhyF4iREMgtdQyp4bISJXioO8kFH6+MxjgcExY3pB6f2hb
         oxV164uwGPBqhaysdo1aqRFP8NBe8FcF09rhs2BlHFlbRdCE4mfG5g9FjqIjvTFdtOni
         /c/g==
X-Gm-Message-State: AOJu0YzJKGCISHKIslPKalJn+FwFJ1aYFd5AVlTpwxkxvSOZLMkx0dbs
        Rt3gCfa4yW0JcM+oKVa8QSinWNQ1HZ0=
X-Google-Smtp-Source: AGHT+IHnZB9VUP/AjDxRMoLdyognF9OR6mpTMbnZtDIBdpMUAztz6mgWts0jTKuU6zplFlh/CTfPSmJAMx8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:47ea:69a5 with SMTP id
 v3-20020a056902108300b00d9a47ea69a5mr291702ybu.1.1698107216905; Mon, 23 Oct
 2023 17:26:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:31 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-12-seanjc@google.com>
Subject: [PATCH v5 11/13] KVM: selftests: Test consistency of CPUID with num
 of fixed counters
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Extend the PMU counters test to verify KVM emulation of fixed counters in
addition to general purpose counters.  Fixed counters add an extra wrinkle
in the form of an extra supported bitmask.  Thus quoth the SDM:

  fixed-function performance counter 'i' is supported if ECX[i] || (EDX[4:0] > i)

Test that KVM handles a counter being available through either method.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 58 ++++++++++++++++++-
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 274b7f4d4b53..f1d9cdd69a17 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -227,13 +227,19 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 	       expect_gp ? "#GP" : "no fault", msr, vector)			\
 
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
-				 uint8_t nr_counters)
+				 uint8_t nr_counters, uint32_t or_mask)
 {
 	uint8_t i;
 
 	for (i = 0; i < nr_possible_counters; i++) {
 		const uint32_t msr = base_msr + i;
-		const bool expect_success = i < nr_counters;
+
+		/*
+		 * Fixed counters are supported if the counter is less than the
+		 * number of enumerated contiguous counters *or* the counter is
+		 * explicitly enumerated in the supported counters mask.
+		 */
+		const bool expect_success = i < nr_counters || (or_mask & BIT(i));
 
 		/*
 		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
@@ -273,7 +279,7 @@ static void guest_test_gp_counters(void)
 	else
 		base_msr = MSR_IA32_PERFCTR0;
 
-	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
+	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
 }
 
 static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
@@ -292,10 +298,51 @@ static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
 	kvm_vm_free(vm);
 }
 
+static void guest_test_fixed_counters(void)
+{
+	uint64_t supported_bitmask = 0;
+	uint8_t nr_fixed_counters = 0;
+
+	/* KVM provides fixed counters iff the vPMU version is 2+. */
+	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 2)
+		nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+
+	/*
+	 * The supported bitmask for fixed counters was introduced in PMU
+	 * version 5.
+	 */
+	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 5)
+		supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
+
+	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
+			     nr_fixed_counters, supported_bitmask);
+}
+
+static void test_fixed_counters(uint8_t nr_fixed_counters,
+				uint32_t supported_bitmask, uint64_t perf_cap)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
+				supported_bitmask);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				nr_fixed_counters);
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
 static void test_intel_counters(void)
 {
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	unsigned int i;
+	uint32_t k;
 	uint8_t j;
 
 	const uint64_t perf_caps[] = {
@@ -306,6 +353,11 @@ static void test_intel_counters(void)
 	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
 		for (j = 0; j <= nr_gp_counters; j++)
 			test_gp_counters(j, perf_caps[i]);
+
+		for (j = 0; j <= nr_fixed_counters; j++) {
+			for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
+				test_fixed_counters(j, k, perf_caps[i]);
+		}
 	}
 }
 
-- 
2.42.0.758.gaed0368e0e-goog

