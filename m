Return-Path: <kvm+bounces-2182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 590B87F2C3B
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:56:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5695B220AA
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB204A99B;
	Tue, 21 Nov 2023 11:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QjzyWU5+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81B0116;
	Tue, 21 Nov 2023 03:55:45 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d9443c01a7336-1cc2fc281cdso37520715ad.0;
        Tue, 21 Nov 2023 03:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700567745; x=1701172545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3a2UvIVQOk+mF3Xt68Og+a1lPhUsU3gq66oL0/Q5kAA=;
        b=QjzyWU5+MxfF4KYTSMxHf5c+ZuFlhh6pPNVn3/c6V7Qwqr7U03APmCXtJ28E7AnlGe
         p+PglQ343HBhq3OFRjc5c5tUu58uKuzFdQ16KLpPcr4ASCzdxiy3IDNlCsPQaq/cmKlS
         HJ5EeC6cdO9BnbIbWn9A3kyzpzGE7MpsTVHlPvV8/J6geEw9m+rJ2E2GvecvLKzFCVr5
         nr8k+IbJM9JhzzDeGnZLGXZDkABBY7KGJtdipwj2bI+dyR4VeBwwQgbRdPITIqXxxZcg
         LWPGnCGq7cHj8WRFeFSouiveSQ7344IYpdwCi7q+N/rnzkejC6QQQdZS7F5F1qw29bYj
         1qdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700567745; x=1701172545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3a2UvIVQOk+mF3Xt68Og+a1lPhUsU3gq66oL0/Q5kAA=;
        b=iO+RnDPIYlqOgt66sWRP7jgE4g/dudvZG3zvFAlQDrZpt4L0wwmT82j4bYDPT6aBuS
         2OPpCQDOOYNvezcfvUKYd4Rk+gmD0RwzqfuluL/tWG3a+qfdrTEU8BO2OqqlpiF5MJUg
         VtFjF0Vn62IrxdC3iRU7tDJc+kGCQqiiMIHmbK4tR93pY00BpXVMUlzvQH4WWQzWBs2C
         OiBlZzm1uGWtRYuCP7bdmJ98kUigMWgwWJBZTNHbcJ5KlcuVoMD30dxcvJvo2NWBVLiV
         T1jxuhJ/7Tdmv8Q0yLZCtjwEreE0sn+jpjRiHbCkDQHjX5q6Bz4j+3JflN64IDJEAfd8
         uVcw==
X-Gm-Message-State: AOJu0YxAXCrPsj7e3lAlYJtnn2Y+y8REtNpFPEHYjv7maBTScpm67WB5
	wMm4FzMDG/B/AqaTiyPqE0I=
X-Google-Smtp-Source: AGHT+IEvjwRCdgy6JMsMIrf6Jl2kRTZG+1NXXxiUW0DHGSnPybpc3msHxuLOBkKWBSZ20tIb83ANqg==
X-Received: by 2002:a17:902:db02:b0:1cf:5cb5:95bf with SMTP id m2-20020a170902db0200b001cf5cb595bfmr6363181plx.45.1700567745403;
        Tue, 21 Nov 2023 03:55:45 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902740a00b001cc1dff5b86sm7685431pll.244.2023.11.21.03.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 03:55:45 -0800 (PST)
From: Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Like Xu <likexu@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Jinrong Liang <ljr.kernel@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] KVM: selftests: Test AMD PMU performance counters basic functions
Date: Tue, 21 Nov 2023 19:54:53 +0800
Message-Id: <20231121115457.76269-6-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231121115457.76269-1-cloudliang@tencent.com>
References: <20231121115457.76269-1-cloudliang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinrong Liang <cloudliang@tencent.com>

Add tests to check AMD PMU performance counters basic functions.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 84 +++++++++++++++++--
 1 file changed, 75 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index efd8c61e1c16..3c4081a508b0 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -21,6 +21,8 @@
 #define NUM_INSNS_RETIRED	(NUM_BRANCHES + NUM_EXTRA_INSNS)
 
 #define PMI_VECTOR		0x20
+#define AMD64_NR_COUNTERS	4
+#define AMD64_NR_COUNTERS_CORE	6
 
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
@@ -411,7 +413,6 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		rdpmc_idx = i;
 		if (base_msr == MSR_CORE_PERF_FIXED_CTR0)
 			rdpmc_idx |= INTEL_RDPMC_FIXED;
-
 		guest_test_rdpmc(rdpmc_idx, expect_success, expected_val);
 
 		/*
@@ -421,7 +422,6 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 */
 		GUEST_ASSERT(!expect_success || !pmu_has_fast_mode);
 		rdpmc_idx |= INTEL_RDPMC_FAST;
-
 		guest_test_rdpmc(rdpmc_idx, false, -1ull);
 
 		vector = wrmsr_safe(msr, 0);
@@ -701,19 +701,85 @@ static void test_intel_counters(void)
 	}
 }
 
+static void set_amd_counters(uint8_t *nr_amd_ounters, uint64_t *ctrl_msr,
+			     uint32_t *pmc_msr, uint8_t *flag)
+{
+	if (this_cpu_has(X86_FEATURE_PERFMON_V2)) {
+		*nr_amd_ounters = this_cpu_property(X86_PROPERTY_PMU_NR_CORE_COUNTERS);
+		*ctrl_msr = MSR_F15H_PERF_CTL0;
+		*pmc_msr = MSR_F15H_PERF_CTR0;
+		*flag = 2;
+	} else if (this_cpu_has(X86_FEATURE_PERFCTR_CORE)) {
+		*nr_amd_ounters = AMD64_NR_COUNTERS_CORE;
+		*ctrl_msr = MSR_F15H_PERF_CTL0;
+		*pmc_msr = MSR_F15H_PERF_CTR0;
+		*flag = 2;
+	} else {
+		*nr_amd_ounters = AMD64_NR_COUNTERS;
+		*ctrl_msr = MSR_K7_EVNTSEL0;
+		*pmc_msr = MSR_K7_PERFCTR0;
+		*flag = 1;
+	}
+}
+
+static void guest_test_amd_counters(void)
+{
+	bool guest_pmu_is_perfmonv2 = this_cpu_has(X86_FEATURE_PERFMON_V2);
+	uint8_t nr_amd_counters, flag;
+	uint64_t ctrl_msr;
+	unsigned int i, j;
+	uint32_t pmc_msr;
+
+	set_amd_counters(&nr_amd_counters, &ctrl_msr, &pmc_msr, &flag);
+
+	for (i = 0; i < nr_amd_counters; i++) {
+		for (j = 0; j < NR_AMD_ZEN_EVENTS; j++) {
+			wrmsr(pmc_msr + i * flag, 0);
+			wrmsr(ctrl_msr + i * flag, ARCH_PERFMON_EVENTSEL_OS |
+			ARCH_PERFMON_EVENTSEL_ENABLE | amd_pmu_zen_events[j]);
+
+			if (guest_pmu_is_perfmonv2)
+				wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, BIT_ULL(i));
+
+			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+			GUEST_ASSERT(rdmsr(pmc_msr + i * flag));
+		}
+	}
+
+	GUEST_DONE();
+}
+
+static void test_amd_zen_events(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_amd_counters);
+
+	run_vcpu(vcpu);
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_is_pmu_enabled());
 
-	TEST_REQUIRE(host_cpu_is_intel);
-	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
-	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+	if (host_cpu_is_intel) {
+		TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
+		TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
-	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
-	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
-	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
+		kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+		kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
+		is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
 
-	test_intel_counters();
+		test_intel_counters();
+	} else if (host_cpu_is_amd) {
+		test_amd_zen_events();
+	} else {
+		TEST_FAIL("Unknown CPU vendor");
+	}
 
 	return 0;
 }
-- 
2.39.3


