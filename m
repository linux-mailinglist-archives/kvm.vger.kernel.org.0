Return-Path: <kvm+bounces-41829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D8AA6E118
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10A06173C7E
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC5B264A68;
	Mon, 24 Mar 2025 17:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wdFiMiBl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22EF26770E
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837598; cv=none; b=lbzs4qY8FGp3X4nrW4QDXqxnQ8m/9xC9Lng8ieXdqxysFsQYfXBGxtvg0dNXLrxC9XnQol5p6A/LoKqbos+iqWnSyh9LOExl6Y0vgP4aaqVDJDqnMmni3znyFQpS1ejqXIvmN3XqshfYh3YnG3GUEW38yfmfMYvR6wBbOQ31qa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837598; c=relaxed/simple;
	bh=7DB+Pot4S4YTvYSOXJ71A2ta9CwwBpBvOTGdR4Q5yl8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rU+EnUC6Tm6i61Cjt2mlu970sV7b+aFDd5+3VaLAG36Bv2ycBoYeIbCZKUk2ctJ+YiWPrW8RBlQ/qQUQjGySVmsDtgVX3FUP4vLjQyJ5ljXZsuZoTfY4jizt+MCHeogPH6bA69nwvhhl1Ywx4+RediycqRg0RXV96sg1GBuWnNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wdFiMiBl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6943febeso6438336a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837595; x=1743442395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QEZcrdvDcdB438jq0C+7mJLnHmCqXMR/6Rcp3Tn0Nqk=;
        b=wdFiMiBlpKp4Z6RhkjNuMD1pvjZeW3HRRm3pGdlKtZM9kzt4I57Puby0B+zI7g9nf/
         g7ydZbUGR61/xzTA9UtvN8bYR+81PwwqvyUFYIalos+CL354YdczNBwK9DDcsti/skxS
         +FYNTccARUTrhpqb5350TTKym/g1xhtapm8iU9YZbnbkL/5O9o5boNhOf53k/9M2mHMZ
         vIowWt3QuRHAyuBcrewdQaynE09FhXVYL0SLnGJgBSva9+JV1eNqU0Iro1t/UTwVBPn3
         BVlZ2rb7NooGSZPITp14Sw8I5NNce1i3QMRUtonJwqWSlEQu3C+z9oOU+x6iqFJAcHGR
         GSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837595; x=1743442395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QEZcrdvDcdB438jq0C+7mJLnHmCqXMR/6Rcp3Tn0Nqk=;
        b=icOsR/ecMseOWj/KEQPHwfcg8FqgdcVoPdCsz/aACt7dM8ByvhU5X+1EQqnxFqPj5A
         DJtUYIkK4tZDcJAO9wnZi8WabezLq/+dtgWK248jscM8lgzm7C5oWVZZtoeezn+J8eEx
         FrH6gUTEtgXayRjfS83FDnMsyeIrOW8uqVRuq58GeifI9VRkK2x5WUdBTABfg1GYCNJb
         1d9wGzR/f0fY10nk8L2NLAYe9Y0JHSXx6B9qFAFvpwswaO2JAGlBg3bx8uhlS3wBz75L
         Os7saqOyEsbGRklwi1TJdCnK3iL1hNIyjCuq5sPTsMbG3KUSnyIWWEVAAs+ZkJDhCGiU
         RJlw==
X-Forwarded-Encrypted: i=1; AJvYcCUZHNNrLLJOMRVVlLIklipW94aG3iE3jgtc4QCWn+43UuhfD90oghH7VempflCn2SWK+xE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwsrxelMuNKxYwEsYX5v1PDyyTgTadpPrTnMP1XzEtOFq7RKi1
	4V53peYCAytJIWlxOjesD/TeCXmF/1dvizdcoKSUdtN335uoB4L3Tco+S+sya6F2P93su5OFKTP
	5mCPwdg==
X-Google-Smtp-Source: AGHT+IHVJlsFAJG1/M0zW8PXxbMMRp3WQsNEDZjGK9sn+7Jy4KFkZOOTViFL/FbZWizRdlX7RVil8rLqGVWL
X-Received: from pjh3.prod.google.com ([2002:a17:90b:3f83:b0:2fe:7f7a:74b2])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:544f:b0:2ff:5267:e7da
 with SMTP id 98e67ed59e1d1-3030e5509f2mr22819736a91.3.1742837594906; Mon, 24
 Mar 2025 10:33:14 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:30:54 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-15-mizhang@google.com>
Subject: [PATCH v4 14/38] KVM: x86/pmu: Introduce enable_mediated_pmu global parameter
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Introduce enable_mediated_pmu global parameter to control if mediated
vPMU can be enabled on KVM level. Even enable_mediated_pmu is set to
true in KVM, user space hypervisor still need to enable mediated vPMU
explicitly by calling KVM_CAP_PMU_CAPABILITY ioctl. This gives
hypervisor flexibility to enable or disable mediated vPMU for each VM.

Mediated vPMU depends on some PMU features on higher PMU version, like
PERF_GLOBAL_STATUS_SET MSR in v4+ for Intel PMU. Thus introduce a
pmu_ops variable MIN_MEDIATED_PMU_VERSION to indicates the minimum host
PMU version which mediated vPMU needs.

Currently enable_mediated_pmu is not exposed to user space as a module
parameter until all mediated vPMU code are in place.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c              |  3 ++-
 arch/x86/kvm/pmu.h              | 11 +++++++++
 arch/x86/kvm/svm/pmu.c          |  1 +
 arch/x86/kvm/vmx/capabilities.h |  3 ++-
 arch/x86/kvm/vmx/pmu_intel.c    |  5 ++++
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              | 44 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.h              |  1 +
 8 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 75e9cfc689f8..4f455afe4009 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -775,7 +775,8 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->pebs_data_cfg_rsvd = ~0ull;
 	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
 
-	if (!vcpu->kvm->arch.enable_pmu)
+	if (!vcpu->kvm->arch.enable_pmu ||
+	    (!lapic_in_kernel(vcpu) && enable_mediated_pmu))
 		return;
 
 	kvm_pmu_call(refresh)(vcpu);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ad89d0bd6005..dd45a0c6be74 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -45,6 +45,7 @@ struct kvm_pmu_ops {
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
 	const int MIN_NR_GP_COUNTERS;
+	const int MIN_MEDIATED_PMU_VERSION;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
@@ -63,6 +64,12 @@ static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 	return pmu->version > 1;
 }
 
+static inline bool kvm_mediated_pmu_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.enable_pmu &&
+	       enable_mediated_pmu && vcpu_to_pmu(vcpu)->version;
+}
+
 /*
  * KVM tracks all counters in 64-bit bitmaps, with general purpose counters
  * mapped to bits 31:0 and fixed counters mapped to 63:32, e.g. fixed counter 0
@@ -210,6 +217,10 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 			enable_pmu = false;
 	}
 
+	if (!enable_pmu || !kvm_pmu_cap.mediated ||
+	    pmu_ops->MIN_MEDIATED_PMU_VERSION > kvm_pmu_cap.version)
+		enable_mediated_pmu = false;
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 288f7f2a46f2..c8b9fd9b5350 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -239,4 +239,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_AMD_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
+	.MIN_MEDIATED_PMU_VERSION = 2,
 };
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cb6588238f46..fac2c80ddbab 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -390,7 +390,8 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 
 static inline bool vmx_pebs_supported(void)
 {
-	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
+	return boot_cpu_has(X86_FEATURE_PEBS) &&
+	       !enable_mediated_pmu && kvm_pmu_cap.pebs_ept;
 }
 
 static inline bool cpu_has_notify_vmexit(void)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 77012b2eca0e..425e93d4b1c6 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -739,4 +739,9 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_INTEL_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = 1,
+	/*
+	 * Intel mediated vPMU support depends on
+	 * MSR_CORE_PERF_GLOBAL_STATUS_SET which is supported from 4+.
+	 */
+	.MIN_MEDIATED_PMU_VERSION = 4,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 00ac94535c21..a4b5b6455c7b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7916,7 +7916,8 @@ static __init u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
+	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
+	    !enable_mediated_pmu) {
 		x86_perf_get_lbr(&vmx_lbr_caps);
 
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72995952978a..1ebe169b88b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -188,6 +188,14 @@ bool __read_mostly enable_pmu = true;
 EXPORT_SYMBOL_GPL(enable_pmu);
 module_param(enable_pmu, bool, 0444);
 
+/*
+ * Enable/disable mediated passthrough PMU virtualization.
+ * Don't expose it to userspace as a module paramerter until
+ * all mediated vPMU code is in place.
+ */
+bool __read_mostly enable_mediated_pmu;
+EXPORT_SYMBOL_GPL(enable_mediated_pmu);
+
 bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
@@ -6643,9 +6651,28 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			break;
 
 		mutex_lock(&kvm->lock);
-		if (!kvm->created_vcpus) {
-			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
-			r = 0;
+		/*
+		 * To keep PMU configuration "simple", setting vPMU support is
+		 * disallowed if vCPUs are created, or if mediated PMU support
+		 * was already enabled for the VM.
+		 */
+		if (!kvm->created_vcpus &&
+		    (!enable_mediated_pmu || !kvm->arch.enable_pmu)) {
+			bool pmu_enable = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
+
+			if (enable_mediated_pmu && pmu_enable) {
+				char *err_msg = "Fail to enable mediated vPMU, " \
+					"please disable system wide perf events or nmi_watchdog " \
+					"(echo 0 > /proc/sys/kernel/nmi_watchdog).\n";
+
+				r = perf_get_mediated_pmu();
+				if (r)
+					kvm_err("%s", err_msg);
+			} else
+				r = 0;
+
+			if (!r)
+				kvm->arch.enable_pmu = pmu_enable;
 		}
 		mutex_unlock(&kvm->lock);
 		break;
@@ -12723,7 +12750,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
 	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
 	kvm->arch.guest_can_read_msr_platform_info = true;
-	kvm->arch.enable_pmu = enable_pmu;
+
+	/*
+	 * PMU virtualization is opt-in when mediated PMU support is enabled.
+	 * KVM_CAP_PMU_CAPABILITY ioctl must be called explicitly to enable
+	 * mediated vPMU. For legacy perf-based vPMU, its behavior isn't changed,
+	 * KVM_CAP_PMU_CAPABILITY ioctl is optional.
+	 */
+	kvm->arch.enable_pmu = enable_pmu && !enable_mediated_pmu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
@@ -12876,6 +12910,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
+	if (kvm->arch.enable_pmu && enable_mediated_pmu)
+		perf_put_mediated_pmu();
 	kvm_unload_vcpu_mmus(kvm);
 	kvm_x86_call(vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 91e50a513100..dbf9973b3d09 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -391,6 +391,7 @@ extern struct kvm_caps kvm_caps;
 extern struct kvm_host_values kvm_host;
 
 extern bool enable_pmu;
+extern bool enable_mediated_pmu;
 
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
-- 
2.49.0.395.g12beb8f557-goog


