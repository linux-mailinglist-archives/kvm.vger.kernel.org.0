Return-Path: <kvm+bounces-54174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1D6B1CD08
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C8FF16E1B2
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD022DE6FB;
	Wed,  6 Aug 2025 19:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="01T4XjTZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8362D877E
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510312; cv=none; b=aF6Flut/LyxP1Jsop/it7/xGjJ/ulua747tEhLy/AmXo68G8YHq3elBwrmkfSlrr17LLlZi1Hbjdpz0KOaSfUA9d28nmAfgZja9Kc3TCXcIV4R1+9mvV1vag+5z6/wyNiadC7aTgEwdgBAnDigMMOS7ouwJebXE1OuecHqcUx1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510312; c=relaxed/simple;
	bh=0nGwxtmjwtpfQ3TN4W9/t/0LCqh4Gk+u4uvrKvrw+k4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dhKJM/xpa6DpEjuWIMMUwpVPWnrJGDVbnv43EDOVR3tvsV+vE9i8Dv+5hqkPz9iUcXCm0b7xed3vlXLJ24kZK3TRquxZ/q8R59NqrnIq/wFLaKOaDXKP7Gz7DOKGclcEidlEaJAavKa0abtF3TpUy5NiyZaf1LsO5excDfRlAXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=01T4XjTZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23fd8f85dd2so1791305ad.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510307; x=1755115107; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OFlIqQp7LfOXLtzFAGq5nR1orhSSuVevPR/iGUx1pag=;
        b=01T4XjTZ78YEkDSbYU6EV/t+XZf4XKThEseOBLxvIWbMBWtXuRmORFUNizCcg5osFY
         06b8Uj4RJnry55cr4isNnV972paya22BmykCaHJZHBlLZduBhW7E4HjHWygiNXxNIuXD
         Jc6uDkD+/VknGUwrf91XclnpUiUWq5BZ87bfAGxItolQbT+ixFL2qUzqxBo+uqhaHqaV
         cA4zKwQcxASjF1TdRPDJk6/tPDDPOicNDCJNgw8LKBrQF6HDqxdxXo3F7uBdDAOUhmXC
         MVoR0gfhQiH1ywNnTXP76EqAMRiYemwY1xedz71atMC5WjMDuaLdw7GU1T0A/tFcWDfv
         r6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510307; x=1755115107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OFlIqQp7LfOXLtzFAGq5nR1orhSSuVevPR/iGUx1pag=;
        b=YbKKSCDLmBefAT38N6hotRJizCDYA38hDnPAX8uebIHeCDmPHKnUdGoFcYFOmtLYut
         9NvqXjIKi8zutI2MDpo/ud9afUImxRZ3UNgAIr9Mkgkpa80onEFIfCJMjOlpOfWPBkaN
         Vx9R0DfhYuTpAwWoxt7TATzASiKDd/QgtgTeFsK+BI7TDE6ucNK1+Ry4gsxIkEI+jncl
         MXM3JiP2ImIjhC0y+Db4qLbOeHDo5q0t7W6mD8Ov8uAd7gx+z6w/iZ0PWGc4RW1Bg1ZP
         BVdV+b1780QkIeaYi1EpzOgwQNQ/TlXp9Qrr1vvO06G4vQA1X5byIrmxy3NmJ2GP7t9g
         wXGw==
X-Forwarded-Encrypted: i=1; AJvYcCUbwXAiCUDTQspI6VAoSCs1NkyBweIGr5a/91f6a+L3osfMLZGSQ6+rLPgAhQObOtA+exc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7BArrS/fa+8vbsPqfN/92CfL77fnwUx8cRuyeYk4LxQfU7wrH
	wxtKCIy6CeaUBhCgzYUxRnV4mWxouqElQ7SXWn9k/tofkA5IhjZNMFXAFgcnVJ015TLaW2wM/wZ
	WRc1rjw==
X-Google-Smtp-Source: AGHT+IExoXGbX1n3oux0+ebgASacivEUZvDFKwtmFYuGqpCTA7y0Fiel45h6jynxmc5ok7SFueltFvmebss=
X-Received: from pjbqb13.prod.google.com ([2002:a17:90b:280d:b0:31c:160d:e3be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e810:b0:240:10dc:b7c9
 with SMTP id d9443c01a7336-2429f1e410amr61901265ad.9.1754510307282; Wed, 06
 Aug 2025 12:58:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:54 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-33-seanjc@google.com>
Subject: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

For vCPUs with a mediated vPMU, disable interception of counter MSRs for
PMCs that are exposed to the guest, and for GLOBAL_CTRL and related MSRs
if they are fully supported according to the vCPU model, i.e. if the MSRs
and all bits supported by hardware exist from the guest's point of view.

Do NOT passthrough event selector or fixed counter control MSRs, so that
KVM can enforce userspace-defined event filters, e.g. to prevent use of
AnyThread events (which is unfortunately a setting in the fixed counter
control MSR).

Defer support for nested passthrough of mediated PMU MSRs to the future,
as the logic for nested MSR interception is unfortunately vendor specific.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: squash patches, massage changelog, refresh VMX MSRs on filter change]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/pmu.c               | 34 ++++++++++++------
 arch/x86/kvm/pmu.h               |  1 +
 arch/x86/kvm/svm/svm.c           | 36 +++++++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c     | 13 -------
 arch/x86/kvm/vmx/pmu_intel.h     | 15 ++++++++
 arch/x86/kvm/vmx/vmx.c           | 59 ++++++++++++++++++++++++++------
 7 files changed, 124 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index f19d1ee9a396..06bd7aaae931 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -736,6 +736,7 @@
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
 #define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR	0xc0000302
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET	0xc0000303
 
 /* AMD Last Branch Record MSRs */
 #define MSR_AMD64_LBR_SELECT			0xc000010e
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4246e1d2cfcc..817ef852bdf9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -715,18 +715,14 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	return 0;
 }
 
-bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
+bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	if (!kvm_vcpu_has_mediated_pmu(vcpu))
 		return true;
 
-	/*
-	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
-	 * in Ring3 when CR4.PCE=0.
-	 */
-	if (enable_vmware_backdoor)
+	if (!kvm_pmu_has_perf_global_ctrl(pmu))
 		return true;
 
 	/*
@@ -735,7 +731,22 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
 	 * capabilities themselves may be a subset of hardware capabilities.
 	 */
 	return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
-	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed ||
+	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
+}
+EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
+
+bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	/*
+	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
+	 * in Ring3 when CR4.PCE=0.
+	 */
+	if (enable_vmware_backdoor)
+		return true;
+
+	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
 	       pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
 	       pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
 }
@@ -927,11 +938,12 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	 * in the global controls).  Emulate that behavior when refreshing the
 	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
 	 */
-	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters) {
+	if (pmu->nr_arch_gp_counters &&
+	    (kvm_pmu_has_perf_global_ctrl(pmu) || kvm_vcpu_has_mediated_pmu(vcpu)))
 		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
-		if (kvm_vcpu_has_mediated_pmu(vcpu))
-			kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
-	}
+
+	if (kvm_vcpu_has_mediated_pmu(vcpu))
+		kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
 
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
 	bitmap_set(pmu->all_valid_pmc_idx, KVM_FIXED_PMC_BASE_IDX,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dcf4e2253875..51963a3a167a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -239,6 +239,7 @@ void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu);
 void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
+bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu);
 bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2d42962b47aa..add50b64256c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -790,6 +790,40 @@ void svm_vcpu_free_msrpm(void *msrpm)
 	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
 }
 
+static void svm_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	bool intercept = !kvm_vcpu_has_mediated_pmu(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int i;
+
+	if (!enable_mediated_pmu)
+		return;
+
+	/* Legacy counters are always available for AMD CPUs with a PMU. */
+	for (i = 0; i < min(pmu->nr_arch_gp_counters, AMD64_NUM_COUNTERS); i++)
+		svm_set_intercept_for_msr(vcpu, MSR_K7_PERFCTR0 + i,
+					  MSR_TYPE_RW, intercept);
+
+	intercept |= !guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE);
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
+		svm_set_intercept_for_msr(vcpu, MSR_F15H_PERF_CTR + 2 * i,
+					  MSR_TYPE_RW, intercept);
+
+	for ( ; i < kvm_pmu_cap.num_counters_gp; i++)
+		svm_enable_intercept_for_msr(vcpu, MSR_F15H_PERF_CTR + 2 * i,
+					     MSR_TYPE_RW);
+
+	intercept = kvm_need_perf_global_ctrl_intercept(vcpu);
+	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+				  MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+				  MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+				  MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET,
+				  MSR_TYPE_RW, intercept);
+}
+
 static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -847,6 +881,8 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_recalc_msr_intercepts(vcpu);
 
+	svm_recalc_pmu_msr_intercepts(vcpu);
+
 	/*
 	 * x2APIC intercepts are modified on-demand and cannot be filtered by
 	 * userspace.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 779b4e64acac..2bdddb95816e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -128,19 +128,6 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
-static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
-{
-	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
-		return 0;
-
-	return vcpu->arch.perf_capabilities;
-}
-
-static inline bool fw_writes_is_enabled(struct kvm_vcpu *vcpu)
-{
-	return (vcpu_get_perf_capabilities(vcpu) & PERF_CAP_FW_WRITES) != 0;
-}
-
 static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 {
 	if (!fw_writes_is_enabled(pmu_to_vcpu(pmu)))
diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
index 5620d0882cdc..5d9357640aa1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.h
+++ b/arch/x86/kvm/vmx/pmu_intel.h
@@ -4,6 +4,21 @@
 
 #include <linux/kvm_host.h>
 
+#include "cpuid.h"
+
+static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
+{
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
+		return 0;
+
+	return vcpu->arch.perf_capabilities;
+}
+
+static inline bool fw_writes_is_enabled(struct kvm_vcpu *vcpu)
+{
+	return (vcpu_get_perf_capabilities(vcpu) & PERF_CAP_FW_WRITES) != 0;
+}
+
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1233a0afb31e..85bd82d41f94 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4068,6 +4068,53 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	bool has_mediated_pmu = kvm_vcpu_has_mediated_pmu(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	bool intercept = !has_mediated_pmu;
+	int i;
+
+	if (!enable_mediated_pmu)
+		return;
+
+	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+				    has_mediated_pmu);
+
+	vm_exit_controls_changebit(vmx, VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+					VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
+				   has_mediated_pmu);
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i,
+					  MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW,
+					  intercept || !fw_writes_is_enabled(vcpu));
+	}
+	for ( ; i < kvm_pmu_cap.num_counters_gp; i++) {
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i,
+					  MSR_TYPE_RW, true);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i,
+					  MSR_TYPE_RW, true);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i,
+					  MSR_TYPE_RW, intercept);
+	for ( ; i < kvm_pmu_cap.num_counters_fixed; i++)
+		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i,
+					  MSR_TYPE_RW, true);
+
+	intercept = kvm_need_perf_global_ctrl_intercept(vcpu);
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_STATUS,
+				  MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+				  MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+				  MSR_TYPE_RW, intercept);
+}
+
 static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	if (!cpu_has_vmx_msr_bitmap())
@@ -4115,17 +4162,7 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
-	if (enable_mediated_pmu) {
-		bool is_mediated_pmu = kvm_vcpu_has_mediated_pmu(vcpu);
-		struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-		vm_entry_controls_changebit(vmx,
-					    VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, is_mediated_pmu);
-
-		vm_exit_controls_changebit(vmx,
-					   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
-					   VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, is_mediated_pmu);
-	}
+	vmx_recalc_pmu_msr_intercepts(vcpu);
 
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
-- 
2.50.1.565.gc32cd1483b-goog


