Return-Path: <kvm+bounces-54172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A12C2B1CD02
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC8AC7ADA89
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266DF2DBF76;
	Wed,  6 Aug 2025 19:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="daQZ6GZh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572232D9497
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510307; cv=none; b=f8a7IxV+iWD7gUalFt6vVVunrzeCvCSYAOudc9kMuYvc6R5NhZOliFGsolTDKtvSJHSsvdZCMtDAspnn83bbHrYCRp0qTvdeVQJnii69SOhzzxd3eBuFgky0WR/xI+i9lg1pQCV+qJfOrNFFVJ9jGheOe56Op+mm8Xt7TApIm6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510307; c=relaxed/simple;
	bh=R67Joq41yriILvZEu+rt+LOTNRmRT1/PlQ171+4+0JY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F3pvgOk0anPE+d7xBCOxkv3k4lwvUzwF3UYjWEQbFQ8o1+HG0GkYe0N8GUoXsza9sAAfSmLgB/Tp3DOotHzdqXOVxgv6UJ2WHpUN4PYq2V/hbKgVlCBxd/imvvOcajKwW6C7YgUzMAGUkJLTxlAxlJvTt0OAvEO11sOsXysjxls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=daQZ6GZh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-242abac2cb4so2082385ad.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510300; x=1755115100; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gVyp6tgdczT9WqGB/7OEU1lR+4+s9dRJCcTxlTSolzo=;
        b=daQZ6GZhot32S9xdqNMdg9ssTJh+NuuzwZGMoH6fS/jFYMDAxrhRNZ48Zhq7IqXOVy
         Y9xud0IBLdpkLNOupRdM8e43YdYZ1+R6GeTzFEYxXDAe6DAQc4LwJ+xeMlZrgjRjZ2eA
         TfaN0PeZgr/y1mVqRUqWSz3MAgt0uLTVt+seXLj1Q0b5xj7yDgKaRA6J5OwZpZoub3T0
         gnJ1tvSVlLok8y89dcEYKZ7iiNWKXyw1sYOL+B1HqzI0+O22c+LogPqeFex2n+VQ11BC
         YeAxUQWGSXwjMLeiqWJ2GqZNv7qWnxl8Oz9419OlIqWuz86ziwk6Uht7Koe7l+YQ2NjI
         Alhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510300; x=1755115100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gVyp6tgdczT9WqGB/7OEU1lR+4+s9dRJCcTxlTSolzo=;
        b=dG3lXtBobdZLKTNJAToLFw7TCsDsiLe9aDnZsa7ycf6d71E7vp5sWL9+E2zZt9V7tA
         A64sLT0DdjJr4QXcS4qQ6hT98CntGuEhRljPUUNtdbRUmlehtTa8DR2uJ7a2bt0adifN
         gpa17puI2u8oDdsrRZPqymjEZj3A41Xmf0JgPkRr33SNTvdE8kDFWN88UZzRvtgbBnKw
         B3CcnEqvBpXfB/e0pcrFSI3eYdokOFSxG9Pz86CKykje9ZejRVO/KlzyAoiDS/98sdHF
         Yazezuswa00aTQrUezk+9Du59/P77rKCbShpwh+nO2RkCJBlj47alqU4tKVJmhQ+KMjR
         PgWw==
X-Forwarded-Encrypted: i=1; AJvYcCVV2+OB96kmfKPdQUxPL71gNs0HdDOBu/qOM9MtcJPhtIhmAOSx8eNu0gqcc+JKrRxbStw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUDfjk4R232EeWfuuB1EgA/UHcqfw0GoAry8bYdEw+cSYAn7rq
	rbcYhEb2ujVxQ2gzShknc4VrGzonTcPNCbQRgAlLaVvtMlJxqU40bGRXztFhajuROwwTCv8maf3
	nl4SNOQ==
X-Google-Smtp-Source: AGHT+IFl8pLHFeWL64GXKcFZRMj90gXiZ/jioteST4D9/w8WrcLO4Mu0ehBWI7xFV7mdsuh2Epecrrv18JA=
X-Received: from pltf11.prod.google.com ([2002:a17:902:74cb:b0:234:d00c:b347])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc3:b0:23f:f983:5ca1
 with SMTP id d9443c01a7336-242a0ae476bmr50691075ad.12.1754510300477; Wed, 06
 Aug 2025 12:58:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:50 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-29-seanjc@google.com>
Subject: [PATCH v5 28/44] KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit
 fields for mediated PMU
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

When running a guest with a mediated PMU, context switch PERF_GLOBAL_CTRL
via the dedicated VMCS fields for both host and guest.  For the host,
always zero GLOBAL_CTRL on exit as the guest's state will still be loaded
in hardware (KVM will context switch the bulk of PMU state outside of the
inner run loop).  For the guest, use the dedicated fields to atomically
load and save PERF_GLOBAL_CTRL on all entry/exits.

Note, VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL was introduced by Sapphire
Rapids, and is expected to be supported on all CPUs with PMU v4+.  WARN if
that expectation is not met.  Alternatively, KVM could manually save
PERF_GLOBAL_CTRL via the MSR save list, but the associated complexity and
runtime overhead is unjustified given that the feature should always be
available on relevant CPUs.

To minimize VM-Entry latency, propagate IA32_PERF_GLOBAL_CTRL to the VMCS
on-demand.  But to minimize complexity, read IA32_PERF_GLOBAL_CTRL out of
the VMCS on all non-failing VM-Exits.  I.e. partially cache the MSR.
KVM could track GLOBAL_CTRL as an EXREG and defer all reads, but writes
are rare, i.e. the dirty tracking for an EXREG is unnecessary, and it's
not obvious that shaving ~15-20 cycles per exit is meaningful given the
total overhead associated with mediated PMU context switches.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 ++
 arch/x86/include/asm/vmx.h             |  1 +
 arch/x86/kvm/pmu.c                     | 13 +++++++++--
 arch/x86/kvm/pmu.h                     |  3 ++-
 arch/x86/kvm/vmx/capabilities.h        |  5 +++++
 arch/x86/kvm/vmx/pmu_intel.c           | 19 +++++++++++++++-
 arch/x86/kvm/vmx/vmx.c                 | 31 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                 |  3 ++-
 8 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 9159bf1a4730..ad2cc82abf79 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -23,5 +23,7 @@ KVM_X86_PMU_OP_OPTIONAL(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
+KVM_X86_PMU_OP_OPTIONAL(write_global_ctrl)
+
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cca7d6641287..af71666c3a37 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -106,6 +106,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL	0x40000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 674f42d083a9..a4fe0e76df79 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -103,7 +103,7 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 #undef __KVM_X86_PMU_OP
 }
 
-void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
+void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
@@ -137,6 +137,9 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 	    !pmu_ops->is_mediated_pmu_supported(&kvm_host_pmu))
 		enable_mediated_pmu = false;
 
+	if (!enable_mediated_pmu)
+		pmu_ops->write_global_ctrl = NULL;
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
@@ -831,6 +834,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			diff = pmu->global_ctrl ^ data;
 			pmu->global_ctrl = data;
 			reprogram_counters(pmu, diff);
+
+			if (kvm_vcpu_has_mediated_pmu(vcpu))
+				kvm_pmu_call(write_global_ctrl)(data);
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
@@ -921,8 +927,11 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	 * in the global controls).  Emulate that behavior when refreshing the
 	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
 	 */
-	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
+	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters) {
 		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
+		if (kvm_vcpu_has_mediated_pmu(vcpu))
+			kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
+	}
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 6b95e81c078c..dcf4e2253875 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -38,6 +38,7 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 
 	bool (*is_mediated_pmu_supported)(struct x86_pmu_capability *host_pmu);
+	void (*write_global_ctrl)(u64 global_ctrl);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
@@ -183,7 +184,7 @@ static inline bool pmc_is_locally_enabled(struct kvm_pmc *pmc)
 
 extern struct x86_pmu_capability kvm_pmu_cap;
 
-void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops);
+void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops);
 
 void kvm_pmu_recalc_pmc_emulation(struct kvm_pmu *pmu, struct kvm_pmc *pmc);
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 26ff606ff139..874c6dd34665 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -100,6 +100,11 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
+static inline bool cpu_has_save_perf_global_ctrl(void)
+{
+	return vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
+}
+
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7ab35ef4a3b1..98f7b45ea391 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -787,7 +787,23 @@ static bool intel_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_
 	 * Require v4+ for MSR_CORE_PERF_GLOBAL_STATUS_SET, and full-width
 	 * writes so that KVM can precisely load guest counter values.
 	 */
-	return host_pmu->version >= 4 && host_perf_cap & PERF_CAP_FW_WRITES;
+	if (host_pmu->version < 4 || !(host_perf_cap & PERF_CAP_FW_WRITES))
+		return false;
+
+	/*
+	 * All CPUs that support a mediated PMU are expected to support loading
+	 * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
+	 */
+	if (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
+			 !cpu_has_save_perf_global_ctrl()))
+		return false;
+
+	return true;
+}
+
+static void intel_pmu_write_global_ctrl(u64 global_ctrl)
+{
+	vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
@@ -803,6 +819,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.cleanup = intel_pmu_cleanup,
 
 	.is_mediated_pmu_supported = intel_pmu_is_mediated_pmu_supported,
+	.write_global_ctrl = intel_pmu_write_global_ctrl,
 
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_INTEL_GP_COUNTERS,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2f7db32710e3..1233a0afb31e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4115,6 +4115,18 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	if (enable_mediated_pmu) {
+		bool is_mediated_pmu = kvm_vcpu_has_mediated_pmu(vcpu);
+		struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+		vm_entry_controls_changebit(vmx,
+					    VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, is_mediated_pmu);
+
+		vm_exit_controls_changebit(vmx,
+					   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+					   VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, is_mediated_pmu);
+	}
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
@@ -4282,6 +4294,16 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
+
+	/*
+	 * When running a guest with a mediated PMU, guest state is resident in
+	 * hardware after VM-Exit.  Zero PERF_GLOBAL_CTRL on exit so that host
+	 * activity doesn't bleed into the guest counters.  When running with
+	 * an emulated PMU, PERF_GLOBAL_CTRL is dynamically computed on every
+	 * entry/exit to merge guest and host PMU usage.
+	 */
+	if (enable_mediated_pmu)
+		vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
@@ -4349,7 +4371,8 @@ static u32 vmx_get_initial_vmexit_ctrl(void)
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
 	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
 	return vmexit_ctrl &
-		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
+		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER |
+		  VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL);
 }
 
 void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
@@ -7087,6 +7110,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	struct perf_guest_switch_msr *msrs;
 	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
+	if (kvm_vcpu_has_mediated_pmu(&vmx->vcpu))
+		return;
+
 	pmu->host_cross_mapped_mask = 0;
 	if (pmu->pebs_enable & pmu->global_ctrl)
 		intel_pmu_cross_mapped_check(pmu);
@@ -7407,6 +7433,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	vmx->loaded_vmcs->launched = 1;
 
+	if (!msr_write_intercepted(vmx, MSR_CORE_PERF_GLOBAL_CTRL))
+		vcpu_to_pmu(vcpu)->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
+
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a4e5bcd1d023..7eb57f5cb975 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -506,7 +506,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
+	       VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.50.1.565.gc32cd1483b-goog


