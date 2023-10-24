Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423FC7D43FB
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbjJXA1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjJXA1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:27:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910711727
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:56 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5b87150242cso2409658a12.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107215; x=1698712015; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iY/ybdzlTO573Vp4ngFbRoGUgka/mobzIHiA6krmWYs=;
        b=aEKVFk3N/H5E+o4007jXxqL/1Cp5rVStABXX7rWvMw1ngAaIJpJYDUZ5esW7Obisdw
         GoOAKZ1Yb/o/rOY4apwP2opyU51Z74G03IQ1cnaXmgqsj3PFS38DW4Oq8T9KZbgj8UHh
         ZZlwR9bUFwkjhBQx+yMNpAfsop7ZPyZsyAKedLF1Bc+YCRGokjQP5gIB5ERM2jBbD19K
         bdvzrNCsLucA06MhGyRjMZtwngNGu3Jj9AtSf7iC5l6ncHHJzqQfiLB3hbdSSVAkgVvP
         wv0AquTx+tnvDfgBCsEn3uxmrGEeF3W27hZSlBN0vBgMJUwngKs9qMkXxOhwsr/9SvRA
         dGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107215; x=1698712015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iY/ybdzlTO573Vp4ngFbRoGUgka/mobzIHiA6krmWYs=;
        b=erQ5ghsAgA3bpeCo4yOpjt7MEoRVBY5Z69sRDkasoFVb+QvKRfhVOPA1sDeoowxA7a
         sqNoR/KHMra8HjsuWuSChWho9ShLqD6Un/70LTsLoUTpgeQsqrI4DsOOZK7N4Ry7l5VH
         KrzwbmYyrDHd3rTuj3go9LQXtNUF0xC1rkfzRJbMAkFr1rQrWbTBFGRyKy/+exrp6wcT
         zezsTdYfkEocOW4dtrZzKHLV08qrao6ebi77s1evPMx9YF8WmJ5kkJvELRKJpAdR3Io1
         QzasAUI8ennXIpagJA59KApjruKvj/YDfM+KBCvtCMr6Jn9puJf+8+UQaD1TndovSTGv
         eRkg==
X-Gm-Message-State: AOJu0YzImqoBF3M+7/OSqJIrckjfASDfvQDYztK+WCdZX32qaFkJZ5mM
        cKnIDZGOZDylwBkF6rav8oY74v8GLIc=
X-Google-Smtp-Source: AGHT+IFMCR8B4hXbRfR7AOaKKIgWLCz070mAba3562Hx7aepoJ96sEmIvcJlV+rnz1jQdIAqRyS+XuWppsg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ee53:b0:1ca:8c48:736e with SMTP id
 19-20020a170902ee5300b001ca8c48736emr174043plo.9.1698107215022; Mon, 23 Oct
 2023 17:26:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:30 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-11-seanjc@google.com>
Subject: [PATCH v5 10/13] KVM: selftests: Test consistency of CPUID with num
 of gp counters
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

Add a test to verify that KVM correctly emulates MSR-based accesses to
general purpose counters based on guest CPUID, e.g. that accesses to
non-existent counters #GP and accesses to existent counters succeed.

Note, for compatibility reasons, KVM does not emulate #GP when
MSR_P6_PERFCTR[0|1] is not present (writes should be dropped).

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 410d09f788ef..274b7f4d4b53 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -212,6 +212,103 @@ static void test_intel_arch_events(void)
 	}
 }
 
+/*
+ * Limit testing to MSRs that are actually defined by Intel (in the SDM).  MSRs
+ * that aren't defined counter MSRs *probably* don't exist, but there's no
+ * guarantee that currently undefined MSR indices won't be used for something
+ * other than PMCs in the future.
+ */
+#define MAX_NR_GP_COUNTERS	8
+#define MAX_NR_FIXED_COUNTERS	3
+
+#define GUEST_ASSERT_PMC_MSR_ACCESS(insn, msr, expect_gp, vector)		\
+__GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
+	       "Expected %s on " #insn "(0x%x), got vector %u",			\
+	       expect_gp ? "#GP" : "no fault", msr, vector)			\
+
+static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
+				 uint8_t nr_counters)
+{
+	uint8_t i;
+
+	for (i = 0; i < nr_possible_counters; i++) {
+		const uint32_t msr = base_msr + i;
+		const bool expect_success = i < nr_counters;
+
+		/*
+		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
+		 * unsupported, i.e. doesn't #GP and reads back '0'.
+		 */
+		const uint64_t expected_val = expect_success ? 0xffff : 0;
+		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
+				       msr != MSR_P6_PERFCTR1;
+		uint8_t vector;
+		uint64_t val;
+
+		vector = wrmsr_safe(msr, 0xffff);
+		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
+
+		vector = rdmsr_safe(msr, &val);
+		GUEST_ASSERT_PMC_MSR_ACCESS(RDMSR, msr, expect_gp, vector);
+
+		/* On #GP, the result of RDMSR is undefined. */
+		if (!expect_gp)
+			__GUEST_ASSERT(val == expected_val,
+				       "Expected RDMSR(0x%x) to yield 0x%lx, got 0x%lx",
+				       msr, expected_val, val);
+
+		vector = wrmsr_safe(msr, 0);
+		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
+	}
+	GUEST_DONE();
+}
+
+static void guest_test_gp_counters(void)
+{
+	uint8_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint32_t base_msr;
+
+	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		base_msr = MSR_IA32_PMC0;
+	else
+		base_msr = MSR_IA32_PERFCTR0;
+
+	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
+}
+
+static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_gp_counters);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
+				nr_gp_counters);
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+static void test_intel_counters(void)
+{
+	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	unsigned int i;
+	uint8_t j;
+
+	const uint64_t perf_caps[] = {
+		0,
+		PMU_CAP_FW_WRITES,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
+		for (j = 0; j <= nr_gp_counters; j++)
+			test_gp_counters(j, perf_caps[i]);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
@@ -222,6 +319,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	test_intel_arch_events();
+	test_intel_counters();
 
 	return 0;
 }
-- 
2.42.0.758.gaed0368e0e-goog

