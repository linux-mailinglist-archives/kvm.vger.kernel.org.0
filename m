Return-Path: <kvm+bounces-38879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D41DA3FB9B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 669671888CE7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD402213E73;
	Fri, 21 Feb 2025 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cnyBWkd+"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18662212B10
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155656; cv=none; b=DVvwNim5vFjAAIu3u/HKel3SSUWdrs+Jbhl1LjBVlIbhyGTxni/rNjOnzVBN1m3yM6YVXWJVgejwirPe5NFf6XOg9IijBeGEvQic3++hqw8P6mQGjlqmukgVnsJcB5QjqwNEH/lUBCuaXF+j4bn4QuM9Eb8bmVu1QFsaZO3QtJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155656; c=relaxed/simple;
	bh=3/HKHruvaE4GIGU5SloCVdMtixlMfnzkYTXdJPXjiIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nm2MVmkkYXs/NUSIfXpvNbjpB2KIYAhBrpMrh1HfqwwNhHAhxMNNwcLOZiFzx3Ulm239an5VwL36sv9FpIVXe1f+FUBjbfYmpbyZ9R/1PzbIZZJ9AvslAn8bLORJd3jCWTJyvSvF0KnGurUQEP3OyGhO6in9s9F1Jt9MBebN1Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cnyBWkd+; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CpOlmsaxwBv8z/TyEJM+sPdDJ8NinYorBdTwh3llrPI=;
	b=cnyBWkd+RQDE5nc/sQQO+335uBwxpzqlx53qVy8jVDPl26qTLeZVms7/1hr5au5+CNfQMN
	du2P48WUigiLhedBhJ+IMdgdJWXnv5jUAEpR7KouRl9P+JubQHKwXfuWROLzRdE2074NgU
	MyVv7i1KPUY41oexgaVL4i9Up9cThNg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	"Kaplan, David" <David.Kaplan@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 3/3] KVM: x86: Generalize IBRS virtualization on emulated VM-exit
Date: Fri, 21 Feb 2025 16:33:52 +0000
Message-ID: <20250221163352.3818347-4-yosry.ahmed@linux.dev>
In-Reply-To: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit 2e7eab81425a ("KVM: VMX: Execute IBPB on emulated VM-exit when
guest has IBRS") added an IBPB in the emulated VM-exit path on Intel to
properly virtualize IBRS by providing separate predictor modes for L1
and L2.

AMD requires similar handling, except when IbrsSameMode is enumerated by
the host CPU (which is the case on most/all AMD CPUs). With
IbrsSameMode, hardware IBRS is sufficient and no extra handling is
needed from KVM.

Generalize the handling in nested_vmx_vmexit() by moving it into a
generic function, add the AMD handling, and use it in
nested_svm_vmexit() too. The main reason for using a generic function is
to have a single place to park the huge comment about virtualizing IBRS.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |  2 ++
 arch/x86/kvm/vmx/nested.c | 11 +----------
 arch/x86/kvm/x86.h        | 18 ++++++++++++++++++
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d77b094d9a4d6..61b73ff30807e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1041,6 +1041,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
+	kvm_nested_vmexit_handle_spec_ctrl(vcpu);
+
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	/*
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8a7af02d466e9..453d52a6e836a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5018,16 +5018,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
-	/*
-	 * If IBRS is advertised to the vCPU, KVM must flush the indirect
-	 * branch predictors when transitioning from L2 to L1, as L1 expects
-	 * hardware (KVM in this case) to provide separate predictor modes.
-	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
-	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
-	 * separate modes for L2 vs L1.
-	 */
-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
-		indirect_branch_prediction_barrier();
+	kvm_nested_vmexit_handle_spec_ctrl(vcpu);
 
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7a87c5fc57f1b..008c8d381c253 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -116,6 +116,24 @@ static inline void kvm_leave_nested(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.nested_ops->leave_nested(vcpu);
 }
 
+/*
+ * If IBRS is advertised to the vCPU, KVM must flush the indirect branch
+ * predictors when transitioning from L2 to L1, as L1 expects hardware (KVM in
+ * this case) to provide separate predictor modes.  Bare metal isolates the host
+ * from the guest, but doesn't isolate different guests from one another (in
+ * this case L1 and L2). The exception is if bare metal supports same mode IBRS,
+ * which offers protection within the same mode, and hence protects L1 from L2.
+ */
+static inline void kvm_nested_vmexit_handle_spec_ctrl(struct kvm_vcpu *vcpu)
+{
+	if (cpu_feature_enabled(X86_FEATURE_AMD_IBRS_SAME_MODE))
+		return;
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS))
+		indirect_branch_prediction_barrier();
+}
+
 static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.last_vmentry_cpu != -1;
-- 
2.48.1.601.g30ceb7b040-goog


