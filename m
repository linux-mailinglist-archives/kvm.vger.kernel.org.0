Return-Path: <kvm+bounces-2179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765577F2C33
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E4F4282512
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D10495F4;
	Tue, 21 Nov 2023 11:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PT/gl12Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5C8116;
	Tue, 21 Nov 2023 03:55:38 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-6bd0e1b1890so4384470b3a.3;
        Tue, 21 Nov 2023 03:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700567737; x=1701172537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NdPghiL9K6QA47Pxcq2G4ErG+ikAld/yu/1jk1hRwMc=;
        b=PT/gl12QjIsaVNXRWx3p8YqIOxOWfvcNZz7oIHk2bdHpm/AXxbUoBMualryO5AxbbA
         6nhgJjyiINZjkfLL/ysVF4ssYE2SNzLED3jo5TAOsyA3rtp3q7h9zb5jMZjeXxbvl5IF
         n9RfJel5IMbu0/ui3EU7nJPJfimrQjbShUrDZ4bv47/5uGRzmWp/77hyEMhHXME/i82o
         fIp8z/+ThHBKqbdIIiv9v8ZZFUjOqSajFjVff4ASGYSOutwjApefyle83DJwOEFd2t9Y
         4pldOu1wJVZdmjRoV2cCo1oAk5Ku92fnU8/VApMMggGemFijqzVhVPdyLs0xG6hUy4xK
         IRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700567737; x=1701172537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NdPghiL9K6QA47Pxcq2G4ErG+ikAld/yu/1jk1hRwMc=;
        b=XZlQF2r7B/isGVFcTAlTL+lHe369lbRCvY/uf2V7dSjaSjDTVzBs0SdQipbFuc6pd2
         dmNXG8m9VhFir+pY6VwftfCN9/wOu3bSRiSl1BdS/sOWwzSYe2qkxAuW1/WNJ/qaQdn6
         fxMtnEBvArwHjOp09qO8nMk6+Pkv+7LILHz6PCWjgXp5G+eQ3HHGxWBYE8PmG1+qg7yy
         oxUkQnn8ZnMLJ88F1n8F9d3p9V9DudnQ1+7MLhXlSyTctk0WLSq1GryzroBonAIZyhYm
         nu1aKgP/+ysHAAOSCgZpDPoPqTIx19HCB6/KJheZAJutA2NUtKKnsFx08kgh8fSeBhVA
         ensA==
X-Gm-Message-State: AOJu0YxdkuMaUms0P8kZY8DndVxE6W4SHkG2WSXWSWr01BwGd9xdRk61
	BiJcRkzYaT5tlW0TyfMinTM=
X-Google-Smtp-Source: AGHT+IE9+ef5/HZ7sSKpFx+zV20Tz7IILIM+TDJnvhMchjip3+17OxcZHbWQ+MhmFWsBy6kl0AWCMw==
X-Received: by 2002:a05:6a20:7351:b0:180:f9c4:a796 with SMTP id v17-20020a056a20735100b00180f9c4a796mr9007721pzc.54.1700567737414;
        Tue, 21 Nov 2023 03:55:37 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902740a00b001cc1dff5b86sm7685431pll.244.2023.11.21.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 03:55:37 -0800 (PST)
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
Subject: [PATCH 2/9] KVM: selftests: Test gp counters overflow interrupt handling
Date: Tue, 21 Nov 2023 19:54:50 +0800
Message-Id: <20231121115457.76269-3-cloudliang@tencent.com>
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

Add tests to verify that gp counters overflow interrupt handling
works as expected and clean up.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 121 ++++++++++++++----
 1 file changed, 98 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 7d8094a27209..1b108e6718fc 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -6,6 +6,7 @@
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <x86intrin.h>
 
+#include "apic.h"
 #include "pmu.h"
 #include "processor.h"
 
@@ -19,14 +20,15 @@
 #define NUM_EXTRA_INSNS		7
 #define NUM_INSNS_RETIRED	(NUM_BRANCHES + NUM_EXTRA_INSNS)
 
+#define PMI_VECTOR		0x20
+
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
 static bool is_forced_emulation_enabled;
+static bool pmi_irq_called;
 
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
-						  void *guest_code,
-						  uint8_t pmu_version,
-						  uint64_t perf_capabilities)
+						  void *guest_code)
 {
 	struct kvm_vm *vm;
 
@@ -34,6 +36,17 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(*vcpu);
 
+	return vm;
+}
+
+static struct kvm_vm *intel_pmu_vm_create(struct kvm_vcpu **vcpu,
+					  void *guest_code, uint8_t pmu_version,
+					  uint64_t perf_capabilities)
+{
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(vcpu, guest_code);
+
 	sync_global_to_guest(vm, kvm_pmu_version);
 	sync_global_to_guest(vm, is_forced_emulation_enabled);
 
@@ -45,6 +58,7 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 		vcpu_set_msr(*vcpu, MSR_IA32_PERF_CAPABILITIES, perf_capabilities);
 
 	vcpu_set_cpuid_property(*vcpu, X86_PROPERTY_PMU_VERSION, pmu_version);
+
 	return vm;
 }
 
@@ -198,6 +212,15 @@ static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
 	return !(*(u64 *)&event);
 }
 
+static uint32_t get_pmc_msr(void)
+{
+	if (this_cpu_has(X86_FEATURE_PDCM) &&
+	    rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		return MSR_IA32_PMC0;
+	else
+		return MSR_IA32_PERFCTR0;
+}
+
 static void guest_test_arch_event(uint8_t idx)
 {
 	const struct {
@@ -226,18 +249,12 @@ static void guest_test_arch_event(uint8_t idx)
 	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
 	bool guest_has_perf_global_ctrl = pmu_version >= 2;
 	struct kvm_x86_pmu_feature gp_event, fixed_event;
-	uint32_t base_pmc_msr;
+	uint32_t base_pmc_msr = get_pmc_msr();
 	unsigned int i;
 
 	/* The host side shouldn't invoke this without a guest PMU. */
 	GUEST_ASSERT(pmu_version);
 
-	if (this_cpu_has(X86_FEATURE_PDCM) &&
-	    rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
-		base_pmc_msr = MSR_IA32_PMC0;
-	else
-		base_pmc_msr = MSR_IA32_PERFCTR0;
-
 	gp_event = intel_event_to_feature[idx].gp_event;
 	GUEST_ASSERT_EQ(idx, gp_event.f.bit);
 
@@ -293,8 +310,8 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 	if (!pmu_version)
 		return;
 
-	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
-					 pmu_version, perf_capabilities);
+	vm = intel_pmu_vm_create(&vcpu, guest_test_arch_events, pmu_version,
+				 perf_capabilities);
 
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
 				length);
@@ -414,18 +431,12 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 
 static void guest_test_gp_counters(void)
 {
+	uint32_t base_msr = get_pmc_msr();
 	uint8_t nr_gp_counters = 0;
-	uint32_t base_msr;
 
 	if (guest_get_pmu_version())
 		nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 
-	if (this_cpu_has(X86_FEATURE_PDCM) &&
-	    rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
-		base_msr = MSR_IA32_PMC0;
-	else
-		base_msr = MSR_IA32_PERFCTR0;
-
 	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
 	GUEST_DONE();
 }
@@ -436,8 +447,8 @@ static void test_gp_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_gp_counters,
-					 pmu_version, perf_capabilities);
+	vm = intel_pmu_vm_create(&vcpu, guest_test_gp_counters, pmu_version,
+				 perf_capabilities);
 
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_GP_COUNTERS,
 				nr_gp_counters);
@@ -503,8 +514,8 @@ static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters,
-					 pmu_version, perf_capabilities);
+	vm = intel_pmu_vm_create(&vcpu, guest_test_fixed_counters, pmu_version,
+				 perf_capabilities);
 
 	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
 				supported_bitmask);
@@ -516,6 +527,68 @@ static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 	kvm_vm_free(vm);
 }
 
+static void pmi_irq_handler(struct ex_regs *regs)
+{
+	pmi_irq_called = true;
+	x2apic_write_reg(APIC_EOI, 0);
+}
+
+static void guest_test_counters_pmi_workload(void)
+{
+	__asm__ __volatile__
+	("sti\n"
+	 "loop .\n"
+	 "cli\n"
+	 : "+c"((int){NUM_BRANCHES})
+	);
+}
+
+static void test_pmi_init_x2apic(void)
+{
+	x2apic_enable();
+	x2apic_write_reg(APIC_ICR, APIC_DEST_SELF | APIC_INT_ASSERT |
+			 APIC_DM_FIXED | PMI_VECTOR);
+	pmi_irq_called = false;
+}
+
+static void guest_test_gp_counter_pmi(void)
+{
+	uint8_t guest_pmu_version = guest_get_pmu_version();
+	uint32_t base_msr = get_pmc_msr();
+
+	test_pmi_init_x2apic();
+
+	wrmsr(base_msr,
+	      (1ULL << this_cpu_property(X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH)) - 2);
+	wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_OS |
+	      ARCH_PERFMON_EVENTSEL_ENABLE | ARCH_PERFMON_EVENTSEL_INT |
+	      INTEL_ARCH_CPU_CYCLES);
+
+	if (guest_pmu_version >= 2)
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(0));
+	guest_test_counters_pmi_workload();
+
+	GUEST_ASSERT(pmi_irq_called);
+	GUEST_DONE();
+}
+
+static void test_intel_ovf_pmi(uint8_t pmu_version, uint64_t perf_capabilities)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	if (!pmu_version)
+		return;
+
+	vm = intel_pmu_vm_create(&vcpu, guest_test_gp_counter_pmi, pmu_version,
+				 perf_capabilities);
+
+	vm_install_exception_handler(vm, PMI_VECTOR, pmi_irq_handler);
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
 static void test_intel_counters(void)
 {
 	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
@@ -596,6 +669,8 @@ static void test_intel_counters(void)
 				for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
 					test_fixed_counters(v, perf_caps[i], j, k);
 			}
+
+			test_intel_ovf_pmi(v, perf_caps[i]);
 		}
 	}
 }
-- 
2.39.3


