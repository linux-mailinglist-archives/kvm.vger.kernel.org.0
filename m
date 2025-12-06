Return-Path: <kvm+bounces-65437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C83ABCA9BA6
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5761D30389F4
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DE43101B4;
	Sat,  6 Dec 2025 00:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e2+Lh9NO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C9930DD38
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980338; cv=none; b=oUtfhCn+DWW4YZmNItG/VF7nrpUASfc7o/RgTgjFtCabzAYVAz+XZ79kpcvi5/kwIKpnJtBjwAlPaPB6sO4F01KHCRjsTX6O1eGGBQp0UQcByRceKOaRWVBDg1gpvcXW50HfyXbDlK8lIc5ktK0FZ7URhKA7gif1Vv5mV1Hj43I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980338; c=relaxed/simple;
	bh=gvtfcjIXj//cuiiuL7vddv/r8HozbH4yy9UU+z+mReQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lc/DUndgP00GL/qVFq+W5hNUlg0FXlP4UsqoZ13VUuAPaac517M2e2xEXMW13WGmMjDHE2lBkT864X2qkqA+lmynouQSt07y1f34P//nYi72vVVPQ9+zuyXKo0Ri+QKZe1elWT/98c1enNtnngfHqjkpv+IwrFmuQGtNtPHkuJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e2+Lh9NO; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2982b47ce35so36760515ad.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980335; x=1765585135; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dghHZC8C4J94U5X0EsLhdqx+qyyu5Gw9y0a71sLAgMI=;
        b=e2+Lh9NOV9oFxAhcihvtwuvlpFFYgrPpkFtzJewouyhZ6KGw00QMqmtMYDJMA/FfOj
         PhL1kr6BCAxP7KJOGMuUY8Dz2cjGh1FRNRytpgYyypj0Fc9JGbidyZzu5vjBZcnC0BSC
         P6D7V11GpTo+aCtf8XAGrjz9h8+RJaytrUwHJ40sh0l2jUsP0banmYi/qXd5O5SF0mO6
         ZJOBmMk1zwy8U6Lifpm0B7UBtn9beUaQg9bvdmOb1LBGwGUGgRfE0BPPeer5nQidkRm0
         tZzi+VMzi3Lh7izG7kpYYmgnIAgFTAEPRCmi8GhmTbetHugS/ZFwSXs3lmb06aRQwC73
         j2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980335; x=1765585135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dghHZC8C4J94U5X0EsLhdqx+qyyu5Gw9y0a71sLAgMI=;
        b=pp1SSzRGJgS+Gs+Dn6WNUHBYOS2HD5HuALA8VJRGunHydXrHfKx8IUZEZupNEGsfGo
         FeFSMCsUl8m8CKOLL8TFGAH5mbrd47VGMfeMaSI3dIHR7RZ0BAO1tHoLw0rZSmZQzqA1
         u6RmLwbnouE1QrbpZaIF1ElkVLvFeLfPJ+naIsl2kSvzUFxXTUIBxgOqkBjdRbtHannM
         AlNZHbyTagx2EcytSmosjnyiks9n+4uUu5RCtfDgAokzueyXSSR4H0gzf11EvJzQCBNN
         OAeJv4BHMEJH0uhy0NYK0BRZOLoMQpBHX/Qe7fJE5ZTUtUkmIcLOCk773jJT++yQUUYJ
         VZYg==
X-Forwarded-Encrypted: i=1; AJvYcCVoZbhs94/FzU5JKPQOHZMTVTa74+XHozVoF2iXulXfvMmUT52fhSz4Ui89VjXD0ZMuahQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdVIr035TOi+nuScUcR9HSq64qyUwlB8bRl1P9BAGp4C/0cErg
	qkjHjxpsFk8Vwg1WSoT8Cufdw/T45dU3j0FyrA9yTuiB/zrSqcEPEebgXA4Jzbn6m8qATMtfIld
	8ukAnMg==
X-Google-Smtp-Source: AGHT+IGiF/KlyKw3jh5Mhte5oVO+4hAY3tNIkOZ4DdyLYn/+Z0r5Rwc99w3eHOaoOE5Aq4b+oO/Y2gl+Kqw=
X-Received: from pgbcp9.prod.google.com ([2002:a05:6a02:4009:b0:b99:9560:3dc9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e290:b0:35b:c84f:c7b0
 with SMTP id adf61e73a8af0-36617e37e14mr1031726637.8.1764980334861; Fri, 05
 Dec 2025 16:18:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:20 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-45-seanjc@google.com>
Subject: [PATCH v6 44/44] KVM: VMX: Add mediated PMU support for CPUs without
 "save perf global ctrl"
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

Extend mediated PMU support for Intel CPUs without support for saving
PERF_GLOBAL_CONTROL into the guest VMCS field on VM-Exit, e.g. for Skylake
and its derivatives, as well as Icelake.  While supporting CPUs without
VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL isn't completely trivial, it's not that
complex either.  And not supporting such CPUs would mean not supporting 7+
years of Intel CPUs released in the past 10 years.

On VM-Exit, immediately propagate the saved PERF_GLOBAL_CTRL to the VMCS
as well as KVM's software cache so that KVM doesn't need to add full EXREG
tracking of PERF_GLOBAL_CTRL.  In practice, the vast majority of VM-Exits
won't trigger software writes to guest PERF_GLOBAL_CTRL, so deferring the
VMWRITE to the next VM-Enter would only delay the inevitable without
batching/avoiding VMWRITEs.

Note!  Take care to refresh VM_EXIT_MSR_STORE_COUNT on nested VM-Exit, as
it's unfortunately possible that KVM could recalculate MSR intercepts
while L2 is active, e.g. if userspace loads nested state and _then_ sets
PERF_CAPABILITIES.  Eating the VMWRITE on every nested VM-Exit is
unfortunate, but that's a pre-existing problem and can/should be solved
separately, e.g. modifying the number of auto-load entries while L2 is
active is also uncommon on modern CPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c    |  6 ++++-
 arch/x86/kvm/vmx/pmu_intel.c |  7 -----
 arch/x86/kvm/vmx/vmx.c       | 52 ++++++++++++++++++++++++++++++++----
 3 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 614b789ecf16..1ee1edc8419d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5142,7 +5142,11 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	kvm_nested_vmexit_handle_ibrs(vcpu);
 
-	/* Update any VMCS fields that might have changed while L2 ran */
+	/*
+	 * Update any VMCS fields that might have changed while vmcs02 was the
+	 * active VMCS.  The tracking is per-vCPU, not per-VMCS.
+	 */
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.nr);
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 55249fa4db95..27eb76e6b6a0 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -777,13 +777,6 @@ static bool intel_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_
 	if (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl()))
 		return false;
 
-	/*
-	 * KVM doesn't yet support mediated PMU on CPUs without support for
-	 * saving PERF_GLOBAL_CTRL via a dedicated VMCS field.
-	 */
-	if (!cpu_has_save_perf_global_ctrl())
-		return false;
-
 	return true;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6a17cb90eaf4..ba1262c3e3ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1204,6 +1204,17 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
 	return true;
 }
 
+static void vmx_add_autostore_msr(struct vcpu_vmx *vmx, u32 msr)
+{
+	vmx_add_auto_msr(&vmx->msr_autostore, msr, 0, VM_EXIT_MSR_STORE_COUNT,
+			 vmx->vcpu.kvm);
+}
+
+static void vmx_remove_autostore_msr(struct vcpu_vmx *vmx, u32 msr)
+{
+	vmx_remove_auto_msr(&vmx->msr_autostore, msr, VM_EXIT_MSR_STORE_COUNT);
+}
+
 #ifdef CONFIG_X86_32
 /*
  * On 32-bit kernels, VM exits still load the FS and GS bases from the
@@ -4225,6 +4236,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 
 static void vmx_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
 {
+	u64 vm_exit_controls_bits = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+				    VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
 	bool has_mediated_pmu = kvm_vcpu_has_mediated_pmu(vcpu);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4234,12 +4247,19 @@ static void vmx_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
 	if (!enable_mediated_pmu)
 		return;
 
+	if (!cpu_has_save_perf_global_ctrl()) {
+		vm_exit_controls_bits &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
+
+		if (has_mediated_pmu)
+			vmx_add_autostore_msr(vmx, MSR_CORE_PERF_GLOBAL_CTRL);
+		else
+			vmx_remove_autostore_msr(vmx, MSR_CORE_PERF_GLOBAL_CTRL);
+	}
+
 	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
 				    has_mediated_pmu);
 
-	vm_exit_controls_changebit(vmx, VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
-					VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
-				   has_mediated_pmu);
+	vm_exit_controls_changebit(vmx, vm_exit_controls_bits, has_mediated_pmu);
 
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i,
@@ -7346,6 +7366,29 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					      msrs[i].host);
 }
 
+static void vmx_refresh_guest_perf_global_control(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (msr_write_intercepted(vmx, MSR_CORE_PERF_GLOBAL_CTRL))
+		return;
+
+	if (!cpu_has_save_perf_global_ctrl()) {
+		int slot = vmx_find_loadstore_msr_slot(&vmx->msr_autostore,
+						       MSR_CORE_PERF_GLOBAL_CTRL);
+
+		if (WARN_ON_ONCE(slot < 0))
+			return;
+
+		pmu->global_ctrl = vmx->msr_autostore.val[slot].value;
+		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, pmu->global_ctrl);
+		return;
+	}
+
+	pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
+}
+
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7631,8 +7674,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	vmx->loaded_vmcs->launched = 1;
 
-	if (!msr_write_intercepted(vmx, MSR_CORE_PERF_GLOBAL_CTRL))
-		vcpu_to_pmu(vcpu)->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
+	vmx_refresh_guest_perf_global_control(vcpu);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
-- 
2.52.0.223.gf5cc29aaa4-goog


