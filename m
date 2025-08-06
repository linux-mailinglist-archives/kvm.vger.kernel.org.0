Return-Path: <kvm+bounces-54179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02FD0B1CD10
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2937F17EBCF
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B759A2E06E4;
	Wed,  6 Aug 2025 19:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bM1v9mlk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CA92DECB4
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510319; cv=none; b=fmPSgq7LimnojZE5G67NeqyfdbtLgmI/IuGwGmLNMdJkdaPm6A9VuFXwgzaDH1dcR6Jx9fiP6uKdGdtoKusFQ6vKVWAAkHuFBAZECvuyd1TmxoYG+P8h2uLj4cy8VMbmBPUERV+J2qpXkXQOJxrY+znz/ACC7TAsVdK8Y/XOL9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510319; c=relaxed/simple;
	bh=BkM6KVwWoNh4dFmNtuvLOgPAK4SVj00cIniNA7xy18I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GH+3a0pcT/rLlFDCzkN5zUfqAtRXGojTnEPUaPKYJ6EnvcMb8Icp+sJjfGtrw28lbveOwuoi3rsWyA5PTI/klR21bX6zY93Sdd7kpBqyrRLyykGBm/lhPBBH1rkNZcm53VapMCq0slQwACIPVBnAzrEC8EQ3ayYfg+zvamqLyIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bM1v9mlk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3214765a5b9so480301a91.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510316; x=1755115116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zkAAwl8vElfQMpdapHv3m96nWKKm7bgpMF9fVPIUZ/g=;
        b=bM1v9mlkCeouq545OKuhbAEFG8yyzcgjTwAJ2tADtTlIlukqSIRXyhGliAwJyN4OSp
         VfLrQM1ilcY5SVQZ2B23FZf7/I0M4+ASjo3+yjYicu1lKMAl1O6kZHsa4s02tUYX4CoX
         L0rbAAeYbgPPKsbWg8oNFR1cjpZKjCpi9usxg1165wHDssRotaK4lVu0T3U6xkqHOwNr
         aWC2u7V7IUtxGaeg8kHDa9ozqpSTaK9mvc2QPrzO0yyD2ORQnihbJYM7lvLIAmpaxvwK
         noJB8oOqGMEAuOornQx8nSUYrbwd/o9+e3ND2myIJcrsRf9spvryQasb/U/ZUWUczxxW
         ImhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510316; x=1755115116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zkAAwl8vElfQMpdapHv3m96nWKKm7bgpMF9fVPIUZ/g=;
        b=DgPCPTF+YTkFAUuevRqbi4pEWWLevngN9rTJx5vp6eBOEpWgdhHOui/aFZEfktCPlC
         /5Ge3dhUZC68wg8I2LwapRgOSazO5GkOc2AIQRa7SWWSezMtcTiJ7aasZfvg21HYrnN/
         6qWv7aPgevHnmCNza4qJ0hLWcEDlBJi9UFaEoHuU9X11Sk0SlnShebRwPjOXIMvghdJk
         vJsz2sea+2VFNIt7WJRhvNAFCNhuBaf4CCJeW9o4WKM4gXPIdonIyQDe+Yqm8U1iZ5Zg
         8DOPtobAlN1O631hsgn56DNKtb3pzNiEeDKhRBLGyHfTKnpTuK7y0eyoVvWHLJrgmB6J
         jkEA==
X-Forwarded-Encrypted: i=1; AJvYcCV+f41y1kmdKvYT2duG82tusQqbZDlzIjGFrD5XQJqRP6zfcv7Kh7aHcyiyylJXd0NMfDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxavQKsLlVuKajeXCxojWdczVfgo2iWxueOhIV9aToAeRvf5oEH
	VlEC+3OLOsZSAFYFcmqmBnRpX1AFXgQ2S2Ijyu8Qj962j57YjT4KD9kzPBNL4WfDU95oN8Lzzxx
	zYUGqFQ==
X-Google-Smtp-Source: AGHT+IFaZiYR5zJC7+pYfASpXTxuG1epwB6mNpav4wNliQpQcOBcA3rZjhVGTTG4ScmGlrhUBGt34kaYMPo=
X-Received: from pjbqb13.prod.google.com ([2002:a17:90b:280d:b0:31f:61fc:b283])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d87:b0:31e:c630:ec93
 with SMTP id 98e67ed59e1d1-32166ca773bmr5198285a91.16.1754510316148; Wed, 06
 Aug 2025 12:58:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:59 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-38-seanjc@google.com>
Subject: [PATCH v5 37/44] KVM: x86/pmu: Load/put mediated PMU context when
 entering/exiting guest
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
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +
 arch/x86/include/asm/msr-index.h       |   1 +
 arch/x86/kvm/pmu.c                     | 111 +++++++++++++++++++++++++
 arch/x86/kvm/pmu.h                     |  10 +++
 arch/x86/kvm/svm/pmu.c                 |  34 ++++++++
 arch/x86/kvm/svm/svm.c                 |   3 +
 arch/x86/kvm/vmx/pmu_intel.c           |  45 ++++++++++
 arch/x86/kvm/x86.c                     |   4 +
 8 files changed, 210 insertions(+)

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
index 06bd7aaae931..0f50a74797a4 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1171,6 +1171,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET	0x00000391
 
 #define MSR_PERF_METRICS		0x00000329
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b4c6a7704a01..77042cad3155 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1234,3 +1234,114 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
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
+	perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
+
+	/*
+	 * Disable all counters before loading event selectors and PMCs so that
+	 * KVM doesn't enable or load guest counters while host events are
+	 * active.  VMX will enable/disabled counters at VM-Enter/VM-Exit by
+	 * atomically loading PERF_GLOBAL_CONTROL.  SVM effectively performs
+	 * the switch by configuring all events to be GUEST_ONLY.
+	 */
+	wrmsrl(kvm_pmu_ops.PERF_GLOBAL_CTRL, 0);
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
+			wrmsrl(gp_counter_msr(i), 0);
+		if (pmc->eventsel_hw)
+			wrmsrl(gp_eventsel_msr(i), 0);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+
+		pmc->counter = rdpmc(INTEL_PMC_FIXED_RDPMC_BASE | i);
+		if (pmc->counter)
+			wrmsrl(fixed_counter_msr(i), 0);
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
+	perf_put_guest_context();
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1c9d26d60a60..e2e2d8476a3f 100644
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
index a5e70a4e7647..c03720b30785 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -233,6 +233,32 @@ static bool amd_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_pm
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
@@ -244,8 +270,16 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
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
index add50b64256c..ca6f453cc160 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4416,6 +4416,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;
 
+	if (!msr_write_intercepted(vcpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL))
+		rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, vcpu_to_pmu(vcpu)->global_ctrl);
+
 	/*
 	 * We need to handle MC intercepts here before the vcpu has a chance to
 	 * change the physical cpu
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6874c522577e..41a845de789e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -786,6 +786,43 @@ static void intel_pmu_write_global_ctrl(u64 global_ctrl)
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
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
@@ -799,9 +836,17 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
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
index b8014435c988..7fb94ef64e18 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10906,6 +10906,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
 	vcpu->arch.host_debugctl = debug_ctl;
 
+	kvm_mediated_pmu_load(vcpu);
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
@@ -10936,6 +10938,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	kvm_mediated_pmu_put(vcpu);
+
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
-- 
2.50.1.565.gc32cd1483b-goog


