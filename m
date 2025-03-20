Return-Path: <kvm+bounces-41534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57670A69DA9
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 02:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B10E7A6430
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 01:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339F21D47A6;
	Thu, 20 Mar 2025 01:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DRrIwM9F"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F962CCA5
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 01:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742434699; cv=none; b=pgif2T3qEaStwUaYPuo/LLK0WBKs8/RXKhb212KC6zqbiLWTytMnjYsvmvUy/a7GHMr+8QCyL7zL82Y883+E60tetLqvtI6ZVFXbVAkWaOnnyDM+Ro8WdSWtZuXCBYu9GWz1WXLS00dF26geQottycv788tkpz3gUZu2dqlkLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742434699; c=relaxed/simple;
	bh=lUxXEkFRHHHNJX99onFBXnUkkJ7DKinzXz1EDIK4+LY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qaGWazMOdt5gulrVzeYDA+VUrS758QuGvOekkPdkffa1zb/7WaUXF66pd41t1AVm3EbTy1acEqWCLzHEdYj4ESEdekg0sSpaI7jquuatBucWVv40v3RC62cYKajKygrsb4g6bDJdEsC54vtMTfViF8sNu4hzAIuIL/+9sbMVJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DRrIwM9F; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742434692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gRMlGyB5XFp7GaH+cooZMXYbRFS0CDGtIS8cCdSLhYY=;
	b=DRrIwM9FHWcbfExOWZBVimSVFCAG4krEwkiFTKsecrOkqg73pHI3U6JaBbv6etFMwc3epR
	6RbFMyF+JdWizDWPVSMTf5lyFEl+OdgEHreDmwQYWQWmnWxv6x9mgpSZjqT72ik+1uGVqz
	FaRFv1lToIvbDjTXZztG3EEV1Sqkp38=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH] KVM: x86: Unify cross-vCPU IBPB
Date: Thu, 20 Mar 2025 01:37:59 +0000
Message-ID: <20250320013759.3965869-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Both SVM and VMX have similar implementation for executing an IBPB
between running different vCPUs on the same CPU to create separate
prediction domains for different vCPUs.

For VMX, when the currently loaded VMCS is changed in
vmx_vcpu_load_vmcs(), an IBPB is executed if there is no 'buddy', which
is the case on vCPU load. The intention is to execute an IBPB when
switching vCPUs, but not when switching the VMCS within the same vCPU.
Executing an IBPB on nested transitions within the same vCPU is handled
separately and conditionally in nested_vmx_vmexit().

For SVM, the current VMCB is tracked on vCPU load and an IBPB is
executed when it is changed. The intention is also to execute an IBPB
when switching vCPUs, although it is possible that in some cases an IBBP
is executed when switching VMCBs for the same vCPU. Executing an IBPB on
nested transitions should be handled separately, and is proposed at [1].

Unify the logic by tracking the last loaded vCPU and execuintg the IBPB
on vCPU change in kvm_arch_vcpu_load() instead. When a vCPU is
destroyed, make sure all references to it are removed from any CPU. This
is similar to how SVM clears the current_vmcb tracking on vCPU
destruction. Remove the current VMCB tracking in SVM as it is no longer
required, as well as the 'buddy' parameter to vmx_vcpu_load_vmcs().

[1]https://lore.kernel.org/lkml/20250221163352.3818347-4-yosry.ahmed@linux.dev/

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c    | 24 ------------------------
 arch/x86/kvm/svm/svm.h    |  2 --
 arch/x86/kvm/vmx/nested.c |  6 +++---
 arch/x86/kvm/vmx/vmx.c    | 15 ++-------------
 arch/x86/kvm/vmx/vmx.h    |  3 +--
 arch/x86/kvm/x86.c        | 19 ++++++++++++++++++-
 6 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329d..89bda9494183e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1484,25 +1484,10 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-static void svm_clear_current_vmcb(struct vmcb *vmcb)
-{
-	int i;
-
-	for_each_online_cpu(i)
-		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
-}
-
 static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * The vmcb page can be recycled, causing a false negative in
-	 * svm_vcpu_load(). So, ensure that no logical CPU has this
-	 * vmcb page recorded as its current vmcb.
-	 */
-	svm_clear_current_vmcb(svm->vmcb);
-
 	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
@@ -1554,18 +1539,9 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
-
 	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 
-	if (sd->current_vmcb != svm->vmcb) {
-		sd->current_vmcb = svm->vmcb;
-
-		if (!cpu_feature_enabled(X86_FEATURE_IBPB_ON_VMEXIT))
-			indirect_branch_prediction_barrier();
-	}
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_vcpu_load(vcpu, cpu);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55dd..c4584cee8f71c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -338,8 +338,6 @@ struct svm_cpu_data {
 	struct vmcb *save_area;
 	unsigned long save_area_pa;
 
-	struct vmcb *current_vmcb;
-
 	/* index = sev_asid, value = vmcb pointer */
 	struct vmcb **sev_vmcbs;
 };
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d06e50d9c0e79..5fd59722f5a2f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -301,7 +301,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	cpu = get_cpu();
 	prev = vmx->loaded_vmcs;
 	vmx->loaded_vmcs = vmcs;
-	vmx_vcpu_load_vmcs(vcpu, cpu, prev);
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
@@ -4520,12 +4520,12 @@ static void copy_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 
 	cpu = get_cpu();
 	vmx->loaded_vmcs = &vmx->nested.vmcs02;
-	vmx_vcpu_load_vmcs(vcpu, cpu, &vmx->vmcs01);
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 
 	sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
-	vmx_vcpu_load_vmcs(vcpu, cpu, &vmx->nested.vmcs02);
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 	put_cpu();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b70ed72c1783d..26b9d48b786f7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1441,8 +1441,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
-			struct loaded_vmcs *buddy)
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
@@ -1469,16 +1468,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 	if (prev != vmx->loaded_vmcs->vmcs) {
 		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
 		vmcs_load(vmx->loaded_vmcs->vmcs);
-
-		/*
-		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a vCPU, unless IBRS is advertised to
-		 * the vCPU.  To minimize the number of IBPBs executed, KVM
-		 * performs IBPB on nested VM-Exit (a single nested transition
-		 * may switch the active VMCS multiple times).
-		 */
-		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
-			indirect_branch_prediction_barrier();
 	}
 
 	if (!already_loaded) {
@@ -1517,7 +1506,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 
-	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 951e44dc9d0ea..aec7ae3a3d4c2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -376,8 +376,7 @@ struct kvm_vmx {
 	u64 *pid_table;
 };
 
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
-			struct loaded_vmcs *buddy);
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69c20a68a3f01..4034190309a61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4961,6 +4961,8 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
 }
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu);
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -4983,6 +4985,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_call(vcpu_load)(vcpu, cpu);
 
+	if (vcpu != per_cpu(last_vcpu, cpu)) {
+		/*
+		 * Flush the branch predictor when switching vCPUs on the same physical
+		 * CPU, as each vCPU should have its own branch prediction domain. No
+		 * IBPB is needed when switching between L1 and L2 on the same vCPU
+		 * unless IBRS is advertised to the vCPU. This is handled on the nested
+		 * VM-Exit path.
+		 */
+		indirect_branch_prediction_barrier();
+		per_cpu(last_vcpu, cpu) = vcpu;
+	}
+
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
 
@@ -12367,10 +12381,13 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	int idx;
+	int idx, cpu;
 
 	kvmclock_reset(vcpu);
 
+	for_each_possible_cpu(cpu)
+		cmpxchg(per_cpu_ptr(&last_vcpu, cpu), vcpu, NULL);
+
 	kvm_x86_call(vcpu_free)(vcpu);
 
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
-- 
2.49.0.395.g12beb8f557-goog


