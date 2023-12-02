Return-Path: <kvm+bounces-3202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D75A801894
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0EA71C20E90
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A6746A4;
	Sat,  2 Dec 2023 00:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IXZudWNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4FB1FEB
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:55 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5c1af03481bso1111221a12.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475495; x=1702080295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9B5cHYHsO/AzGEl7cfGpYxbYZ6NrjTMlAyuJ5Jsh6Yk=;
        b=IXZudWNwhb0tqoh2IqkSANdeC0bd2AN15E9DGOiPY8FdTG7OZL0dS1TWow0LJPKu28
         13bN5F+p7foMzYujYCe7Qy9zzoferUF3iw9lJRuhVYbXZK2yAKckvY5fLK8/6gSPC/SK
         tQjj5UlQx5r9eC71oH782g6oLjb/NwGJmYmVBPzXfMnqM7BgJREL2YDr1RUBRqPOoNJF
         vKoEmXaMoKKpEFxHiR808VM+ETpOhuVTixxQinAskVBXVd+N8ZqZu7a3KiUd3BlQiI8h
         SUqtMIEo2o+eisGZR7I5PdKPnjyLBEKL00g9T9ysAW2cYEHt/O6FsS02GqPS37Bi5SXS
         cuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475495; x=1702080295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9B5cHYHsO/AzGEl7cfGpYxbYZ6NrjTMlAyuJ5Jsh6Yk=;
        b=JvTpUZjr3dyvW0N0otSI45xX+U7VWlqq0NRsW6K6zRMhJCG2rZojrwOynI5H1OgN6F
         XDNdAen9Lxsi0HmnMnE93t6XI8i1I3rePDonoq7oDdP3qBw3WM3Ps/KMx9AWSkHOr3KI
         AdmGLQiBvDrZGh72YjeOONYQ9yTD9zDi7SDxhMhGeszs/pApLbUCm7yeTj/rBDASVnBY
         LRX/eO7PiejEgr3AuzatMWrlt76JkPDnKd6Lp44Gbxa6puT1qv/88Axa8RmvMP6EEPx3
         /9rezs16E7BXFg36F4rkWBDtbwMH1ixFGydBQNB+2rAn0QIh+06KUayjvw8u53zGTFMf
         dpHg==
X-Gm-Message-State: AOJu0YxkiAbopWtxI60jTtB97EZKjVdE+KEcmunB6ZE86o2rsXq38Rob
	FZp2MasWYq6RHTVw6NZl2sUmCFiAq1E=
X-Google-Smtp-Source: AGHT+IEcivIyX0212n9vkEMtVZI9Ts+J4UfitLQGxh5REa77Qq4Qur/zm4h12/CO860MMNMfhQPcLoqexpU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6909:0:b0:5bd:85b1:da18 with SMTP id
 e9-20020a636909000000b005bd85b1da18mr3740401pgc.11.1701475495031; Fri, 01 Dec
 2023 16:04:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:07 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-19-seanjc@google.com>
Subject: [PATCH v9 18/28] KVM: selftests: Test consistency of CPUID with num
 of fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the PMU counters test to verify KVM emulation of fixed counters in
addition to general purpose counters.  Fixed counters add an extra wrinkle
in the form of an extra supported bitmask.  Thus quoth the SDM:

  fixed-function performance counter 'i' is supported if ECX[i] || (EDX[4:0] > i)

Test that KVM handles a counter being available through either method.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 863418842ef8..b07294af71a3 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -290,7 +290,7 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       msr, expected_val, val);
 
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
-				 uint8_t nr_counters)
+				 uint8_t nr_counters, uint32_t or_mask)
 {
 	uint8_t i;
 
@@ -301,7 +301,13 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 */
 		const uint64_t test_val = 0xffff;
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
@@ -343,7 +349,7 @@ static void guest_test_gp_counters(void)
 	else
 		base_msr = MSR_IA32_PERFCTR0;
 
-	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
+	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
 }
 
 static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
@@ -363,9 +369,50 @@ static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	kvm_vm_free(vm);
 }
 
+static void guest_test_fixed_counters(void)
+{
+	uint64_t supported_bitmask = 0;
+	uint8_t nr_fixed_counters = 0;
+
+	/* Fixed counters require Architectural vPMU Version 2+. */
+	if (guest_get_pmu_version() >= 2)
+		nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+
+	/*
+	 * The supported bitmask for fixed counters was introduced in PMU
+	 * version 5.
+	 */
+	if (guest_get_pmu_version() >= 5)
+		supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
+
+	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
+			     nr_fixed_counters, supported_bitmask);
+}
+
+static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
+				uint8_t nr_fixed_counters,
+				uint32_t supported_bitmask)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters,
+					 pmu_version, perf_capabilities);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
+				supported_bitmask);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
+				nr_fixed_counters);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
 static void test_intel_counters(void)
 {
 	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	unsigned int i;
@@ -435,6 +482,13 @@ static void test_intel_counters(void)
 				v, perf_caps[i]);
 			for (j = 0; j <= nr_gp_counters; j++)
 				test_gp_counters(v, perf_caps[i], j);
+
+			pr_info("Testing fixed counters, PMU version %u, perf_caps = %lx\n",
+				v, perf_caps[i]);
+			for (j = 0; j <= nr_fixed_counters; j++) {
+				for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
+					test_fixed_counters(v, perf_caps[i], j, k);
+			}
 		}
 	}
 }
-- 
2.43.0.rc2.451.g8631bc7472-goog


