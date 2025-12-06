Return-Path: <kvm+bounces-65420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 60551CA9B55
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:28:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10A263012962
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF00B2EBBB2;
	Sat,  6 Dec 2025 00:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UdpsrET7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E52425C818
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980304; cv=none; b=ZyavmVqzIokaB2rbNb2CVy/pjYLe+sW1AXMymcNmqn9wdlUgOCPrmjHK9DE+2fiRHx/Xqr9yFRctRGcNpc8W8tAESJzva7Nwjd/JJS3WnOjdzjoc6I49cWcYytO9ZRvQVJrlghnBw9Ca0HDaDWafns4ZZ4xeNQZi/atJ74S1wSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980304; c=relaxed/simple;
	bh=g6IgwDOr1QTB/U0G/UqEHj7fne6rpUkmt4EyXf4kjNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rsD3PobgRVaNQ0jH0256R6CfGrG8UEFO74bVWO9U74i0l2zYveVnUGQjiJWMkU1Jt3Fr+ue9TaeR7wzZEdSD/6YDvUiL39+RcMBuILCpajshEWH6HtWnRIu9IPp1TgoydKpKzbiBbP0qUpCMSfh3oQWxN8BZJlQUGnWSLdzyyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UdpsrET7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438b1220bcso3062274a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980301; x=1765585101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=woqdwqYc7rQiICol2w1MfYRG1IsQA6G0tPae7LPMVAU=;
        b=UdpsrET78tTHLHOYWxSoSTfKXIL63puqUiXEpzMh8H3zSBpNXHfMLMJfXqh06sSzMR
         Zh7GJWQ53vbP9BJRyVh2be6mZTx8sM+ugZ+/1wSM2XfbAYytuxTLms9r5R0p9725RGDR
         PBpj87AXD2r+BpBmC5dr8ag+or11YKHZmia1YlRWkMPwQOxznHNYzsNYZe408KluSrLj
         iu+bROZM5L0i5aOyb6tTM0xmt8UQnizN93Za9aj99eJEZevqyVr5OL6fOWt2jVm0S2/j
         OdlbAHbpLEtG4f//tQguPg5cSmkuYG0T4EQZ3b8RAQTrJSTH30LIkbHmUXrLs80MQtKu
         lbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980301; x=1765585101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=woqdwqYc7rQiICol2w1MfYRG1IsQA6G0tPae7LPMVAU=;
        b=U6MmLF5qA5GDdk8S+GPsMQJx9z5sJ5QoYx0hhlnlUi+BI2A6HeudTj35BNPeJmGYsh
         tvSsgSC0PwcAR8zEENrJcqakPiNCTOJ+aevLlWfa/PgYO87FZhVElMXB6Mn2q10Fjr7H
         Gl5i2QjGsU64swwZ6hust3CjZXLxZyKFJFqcwKbvT15mwQduH10x9m3g8ho2riBHIQwl
         poJJBcTfwPHDUa0IS/LQFNQD7X6yxAAPprAUNK+FNZ1e3T7k3dr9RZhUbuJ51cD8NUPs
         SsjDRgqWopratx0Lr4XeZTqBqvcugOREmJHj4rx3GCvlUjg0fPJ2Bs4e61xPesaEs8Yd
         Vt1A==
X-Forwarded-Encrypted: i=1; AJvYcCVqJ1cxmY5L8WKXJ+yskYz6w7r8KrfeUB0laFQbErGe8Jl11dQYxZAb9q91xLiAYCPW1A0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3MoGXaD3A8PRYRyn37N+7FSUWOgTFZlfo3m4LQW1EMG9Ey+Hy
	HOZD63nV7EgNkjHcaqXE8o/cmnmDxF5xxXRZVCiZ+scV7NP/sY5qmvLa5H8WP3i/ysgMM8YIeOe
	vDZQHgA==
X-Google-Smtp-Source: AGHT+IFJtzUjMs3EhF2cTLNE2/+KZsTfbuJQ6pRxxJNiALtopWi5CNU9QJ//pu80N197imWodywRwcS+L+M=
X-Received: from pjxx15.prod.google.com ([2002:a17:90b:58cf:b0:340:bb32:f5cf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33d1:b0:341:194:5e7d
 with SMTP id 98e67ed59e1d1-349a2686534mr715053a91.24.1764980300781; Fri, 05
 Dec 2025 16:18:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:03 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-28-seanjc@google.com>
Subject: [PATCH v6 27/44] KVM: x86/pmu: Load/put mediated PMU context when
 entering/exiting guest
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Implement the PMU "world switch" between host perf and guest mediated PMU.
When loading guest state, call into perf to switch from host to guest, and
then load guest state into hardware, and then reverse those actions when
putting guest state.

On the KVM side, when loading guest state, zero PERF_GLOBAL_CTRL to ensure
all counters are disabled, then load selectors and counters, and finally
call into vendor code to load control/status information.  While VMX and
SVM use different mechanisms to avoid counting host activity while guest
controls are loaded, both implementations require PERF_GLOBAL_CTRL to be
zeroed when the event selectors are in flux.

When putting guest state, reverse the order, and save and zero controls
and status prior to saving+zeroing selectors and counters.  Defer clearing
PERF_GLOBAL_CTRL to vendor code, as only SVM needs to manually clear the
MSR; VMX configures PERF_GLOBAL_CTRL to be atomically cleared by the CPU
on VM-Exit.

Handle the difference in MSR layouts between Intel and AMD by communicating
the bases and stride via kvm_pmu_ops.  Because KVM requires Intel v4 (and
full-width writes) and AMD v2, the MSRs to load/save are constant for a
given vendor, i.e. do not vary based on the guest PMU, and do not vary
based on host PMU (because KVM will simply disable mediated PMU support if
the necessary MSRs are unsupported).

Except for retrieving the guest's PERF_GLOBAL_CTRL, which needs to be read
before invoking any fastpath handler (spoiler alert), perform the context
switch around KVM's inner run loop.  State only needs to be synchronized
from hardware before KVM can access the software "caches".

Note, VMX already grabs the guest's PERF_GLOBAL_CTRL immediately after
VM-Exit, as hardware saves value into the VMCS.

Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +
 arch/x86/include/asm/msr-index.h       |   1 +
 arch/x86/kvm/pmu.c                     | 130 ++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h                     |  10 ++
 arch/x86/kvm/svm/pmu.c                 |  34 +++++++
 arch/x86/kvm/svm/svm.c                 |   3 +
 arch/x86/kvm/vmx/pmu_intel.c           |  44 +++++++++
 arch/x86/kvm/x86.c                     |   4 +
 8 files changed, 225 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index ad2cc82abf79..f0aa6996811f 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -24,6 +24,8 @@ KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
 KVM_X86_PMU_OP_OPTIONAL(write_global_ctrl)
+KVM_X86_PMU_OP(mediated_load)
+KVM_X86_PMU_OP(mediated_put)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9e1720d73244..0ba08fd4ac3f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1191,6 +1191,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET	0x00000391
 
 #define MSR_PERF_METRICS		0x00000329
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 39904e6fd227..578bf996bda2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -882,10 +882,13 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			diff = pmu->global_ctrl ^ data;
 			pmu->global_ctrl = data;
 			reprogram_counters(pmu, diff);
-
-			if (kvm_vcpu_has_mediated_pmu(vcpu))
-				kvm_pmu_call(write_global_ctrl)(data);
 		}
+		/*
+		 * Unconditionally forward writes to vendor code, i.e. to the
+		 * VMC{B,S}, as pmu->global_ctrl is per-VCPU, not per-VMC{B,S}.
+		 */
+		if (kvm_vcpu_has_mediated_pmu(vcpu))
+			kvm_pmu_call(write_global_ctrl)(data);
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		/*
@@ -1246,3 +1249,124 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kfree(filter);
 	return r;
 }
+
+static __always_inline u32 fixed_counter_msr(u32 idx)
+{
+	return kvm_pmu_ops.FIXED_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
+}
+
+static __always_inline u32 gp_counter_msr(u32 idx)
+{
+	return kvm_pmu_ops.GP_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
+}
+
+static __always_inline u32 gp_eventsel_msr(u32 idx)
+{
+	return kvm_pmu_ops.GP_EVENTSEL_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
+}
+
+static void kvm_pmu_load_guest_pmcs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u32 i;
+
+	/*
+	 * No need to zero out unexposed GP/fixed counters/selectors since RDPMC
+	 * is intercepted if hardware has counters that aren't visible to the
+	 * guest (KVM will inject #GP as appropriate).
+	 */
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		pmc = &pmu->gp_counters[i];
+
+		wrmsrl(gp_counter_msr(i), pmc->counter);
+		wrmsrl(gp_eventsel_msr(i), pmc->eventsel_hw);
+	}
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+
+		wrmsrl(fixed_counter_msr(i), pmc->counter);
+	}
+}
+
+void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_vcpu_has_mediated_pmu(vcpu) ||
+	    KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return;
+
+	lockdep_assert_irqs_disabled();
+
+	perf_load_guest_context();
+
+	/*
+	 * Explicitly clear PERF_GLOBAL_CTRL, as "loading" the guest's context
+	 * disables all individual counters (if any were enabled), but doesn't
+	 * globally disable the entire PMU.  Loading event selectors and PMCs
+	 * with guest values while PERF_GLOBAL_CTRL is non-zero will generate
+	 * unexpected events and PMIs.
+	 *
+	 * VMX will enable/disable counters at VM-Enter/VM-Exit by atomically
+	 * loading PERF_GLOBAL_CONTROL.  SVM effectively performs the switch by
+	 * configuring all events to be GUEST_ONLY.  Clear PERF_GLOBAL_CONTROL
+	 * even for SVM to minimize the damage if a perf event is left enabled,
+	 * and to ensure a consistent starting state.
+	 */
+	wrmsrq(kvm_pmu_ops.PERF_GLOBAL_CTRL, 0);
+
+	perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
+
+	kvm_pmu_load_guest_pmcs(vcpu);
+
+	kvm_pmu_call(mediated_load)(vcpu);
+}
+
+static void kvm_pmu_put_guest_pmcs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u32 i;
+
+	/*
+	 * Clear selectors and counters to ensure hardware doesn't count using
+	 * guest controls when the host (perf) restores its state.
+	 */
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		pmc = &pmu->gp_counters[i];
+
+		pmc->counter = rdpmc(i);
+		if (pmc->counter)
+			wrmsrq(gp_counter_msr(i), 0);
+		if (pmc->eventsel_hw)
+			wrmsrq(gp_eventsel_msr(i), 0);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+
+		pmc->counter = rdpmc(INTEL_PMC_FIXED_RDPMC_BASE | i);
+		if (pmc->counter)
+			wrmsrq(fixed_counter_msr(i), 0);
+	}
+}
+
+void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_vcpu_has_mediated_pmu(vcpu) ||
+	    KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return;
+
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * Defer handling of PERF_GLOBAL_CTRL to vendor code.  On Intel, it's
+	 * atomically cleared on VM-Exit, i.e. doesn't need to be clear here.
+	 */
+	kvm_pmu_call(mediated_put)(vcpu);
+
+	kvm_pmu_put_guest_pmcs(vcpu);
+
+	perf_put_guest_lvtpc();
+
+	perf_put_guest_context();
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 9a199109d672..25b583da9ee2 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -38,11 +38,19 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 
 	bool (*is_mediated_pmu_supported)(struct x86_pmu_capability *host_pmu);
+	void (*mediated_load)(struct kvm_vcpu *vcpu);
+	void (*mediated_put)(struct kvm_vcpu *vcpu);
 	void (*write_global_ctrl)(u64 global_ctrl);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
 	const int MIN_NR_GP_COUNTERS;
+
+	const u32 PERF_GLOBAL_CTRL;
+	const u32 GP_EVENTSEL_BASE;
+	const u32 GP_COUNTER_BASE;
+	const u32 FIXED_COUNTER_BASE;
+	const u32 MSR_STRIDE;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
@@ -240,6 +248,8 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu);
 void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu);
+void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu);
+void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 6d5f791126b1..7aa298eeb072 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -234,6 +234,32 @@ static bool amd_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_pm
 	return host_pmu->version >= 2;
 }
 
+static void amd_mediated_pmu_load(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u64 global_status;
+
+	rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, global_status);
+	/* Clear host global_status MSR if non-zero. */
+	if (global_status)
+		wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, global_status);
+
+	wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, pmu->global_status);
+	wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, pmu->global_ctrl);
+}
+
+static void amd_mediated_pmu_put(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+	rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, pmu->global_status);
+
+	/* Clear global status bits if non-zero */
+	if (pmu->global_status)
+		wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, pmu->global_status);
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -245,8 +271,16 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.init = amd_pmu_init,
 
 	.is_mediated_pmu_supported = amd_pmu_is_mediated_pmu_supported,
+	.mediated_load = amd_mediated_pmu_load,
+	.mediated_put = amd_mediated_pmu_put,
 
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_AMD_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
+
+	.PERF_GLOBAL_CTRL = MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+	.GP_EVENTSEL_BASE = MSR_F15H_PERF_CTL0,
+	.GP_COUNTER_BASE = MSR_F15H_PERF_CTR0,
+	.FIXED_COUNTER_BASE = 0,
+	.MSR_STRIDE = 2,
 };
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fa04e58ff524..cbebd3a18918 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4368,6 +4368,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;
 
+	if (!msr_write_intercepted(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL))
+		rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, vcpu_to_pmu(vcpu)->global_ctrl);
+
 	trace_kvm_exit(vcpu, KVM_ISA_SVM);
 
 	svm_complete_interrupts(vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 855240678300..55249fa4db95 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -792,6 +792,42 @@ static void intel_pmu_write_global_ctrl(u64 global_ctrl)
 	vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
 }
 
+
+static void intel_mediated_pmu_load(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u64 global_status, toggle;
+
+	rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
+	toggle = pmu->global_status ^ global_status;
+	if (global_status & toggle)
+		wrmsrq(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status & toggle);
+	if (pmu->global_status & toggle)
+		wrmsrq(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status & toggle);
+
+	wrmsrq(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl_hw);
+}
+
+static void intel_mediated_pmu_put(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	/* MSR_CORE_PERF_GLOBAL_CTRL is already saved at VM-exit. */
+	rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
+
+	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
+	if (pmu->global_status)
+		wrmsrq(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
+
+	/*
+	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
+	 * also to avoid accidentally enabling fixed counters (based on guest
+	 * state) while running in the host, e.g. when setting global ctrl.
+	 */
+	if (pmu->fixed_ctr_ctrl_hw)
+		wrmsrq(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
@@ -805,9 +841,17 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.cleanup = intel_pmu_cleanup,
 
 	.is_mediated_pmu_supported = intel_pmu_is_mediated_pmu_supported,
+	.mediated_load = intel_mediated_pmu_load,
+	.mediated_put = intel_mediated_pmu_put,
 	.write_global_ctrl = intel_pmu_write_global_ctrl,
 
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_INTEL_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = 1,
+
+	.PERF_GLOBAL_CTRL = MSR_CORE_PERF_GLOBAL_CTRL,
+	.GP_EVENTSEL_BASE = MSR_P6_EVNTSEL0,
+	.GP_COUNTER_BASE = MSR_IA32_PMC0,
+	.FIXED_COUNTER_BASE = MSR_CORE_PERF_FIXED_CTR0,
+	.MSR_STRIDE = 1,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76e86eb358df..589a309259f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11334,6 +11334,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
 	vcpu->arch.host_debugctl = debug_ctl;
 
+	kvm_mediated_pmu_load(vcpu);
+
 	guest_timing_enter_irqoff();
 
 	/*
@@ -11372,6 +11374,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_load_host_pkru(vcpu);
 
+	kvm_mediated_pmu_put(vcpu);
+
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
-- 
2.52.0.223.gf5cc29aaa4-goog


