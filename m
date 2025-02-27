Return-Path: <kvm+bounces-39470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC88A47170
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1AAA169AC9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6942C197A76;
	Thu, 27 Feb 2025 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Su615WOE"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925B5187FEC
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619654; cv=none; b=AbYNu2Ts6InEsovYDeQFEGjXst+OOLFDmRztfoTPqQhZuoFstbRDi9tQ54QdIiQZ0ootkG0kDP2yA3KHm73LMfrgSqOKkovliowWcZOVef8mTGUCKx6oSJNUkKljaqSp9fCtKEFfz+KR797KLQHYLQSM7S0qcsnYeG0ygO4WdSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619654; c=relaxed/simple;
	bh=H2bpdruzg/EBVjdVmIrlMUnaIbKXfOPnMB/1jyeS2fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpGkUcQ6mQM3NeB+FUPC3MxwRdbBsHk6kI6bVIKD+nTY1R/CNdOwYsADL1Tszg+PbuGwutynX5Q+5xusn/pAdLh2u/Fj0ZP15sBcyez7SCGA/4Ou8tDYI2y+AMBomk5gzRSK5UbfyZIKs1c5QmiKEwU6CjPCqX1rETEDhu22K0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Su615WOE; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740619650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2/rfCNSW+6bre2lfwWT68fKgkLnX8sDUsb4ruuQm2Wc=;
	b=Su615WOEArZE8X3+Uc3YRp+6CVuhiTh8ZFc9bisiURu1l0R/wkFy/0sXHXKGVuCBJrjNEy
	dHAJNVe/oJOQ1V4vb3Nl1jDT/asVU9nLG/NQryvWnB3zspfMBqWHJ93sETFl3SyTYAd4jO
	+ijf3RDMUvoCqe5S5vS6jXLCSPhnx5o=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 1/6] x86/bugs: Move the X86_FEATURE_USE_IBPB check into callers
Date: Thu, 27 Feb 2025 01:27:07 +0000
Message-ID: <20250227012712.3193063-2-yosry.ahmed@linux.dev>
In-Reply-To: <20250227012712.3193063-1-yosry.ahmed@linux.dev>
References: <20250227012712.3193063-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

indirect_branch_prediction_barrier() only performs the MSR write if
X86_FEATURE_USE_IBPB is set, using alternative_msr_write(). In
preparation for removing X86_FEATURE_USE_IBPB, move the feature check
into the callers so that they can be addressed one-by-one, and use
X86_FEATURE_IBPB instead to guard the MSR write.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h | 2 +-
 arch/x86/kernel/cpu/bugs.c           | 2 +-
 arch/x86/kvm/svm/svm.c               | 3 ++-
 arch/x86/kvm/vmx/nested.c            | 3 ++-
 arch/x86/kvm/vmx/vmx.c               | 3 ++-
 arch/x86/mm/tlb.c                    | 7 ++++---
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 7e8bf78c03d5d..7cbb76a2434b9 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -515,7 +515,7 @@ extern u64 x86_pred_cmd;
 
 static inline void indirect_branch_prediction_barrier(void)
 {
-	alternative_msr_write(MSR_IA32_PRED_CMD, x86_pred_cmd, X86_FEATURE_USE_IBPB);
+	alternative_msr_write(MSR_IA32_PRED_CMD, x86_pred_cmd, X86_FEATURE_IBPB);
 }
 
 /* The Intel SPEC CTRL MSR base value cache */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1d7afc40f2272..754150fc05784 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2272,7 +2272,7 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
 		task_update_spec_tif(task);
-		if (task == current)
+		if (task == current && cpu_feature_enabled(X86_FEATURE_USE_IBPB))
 			indirect_branch_prediction_barrier();
 		break;
 	default:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 77ab66c5bb962..57222c3b56592 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1565,7 +1565,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
 
-		if (!cpu_feature_enabled(X86_FEATURE_IBPB_ON_VMEXIT))
+		if (!cpu_feature_enabled(X86_FEATURE_IBPB_ON_VMEXIT) &&
+		    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
 			indirect_branch_prediction_barrier();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ca18c3eec76d8..504f328907ad4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5026,7 +5026,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
 	 * separate modes for L2 vs L1.
 	 */
-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+	    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
 		indirect_branch_prediction_barrier();
 
 	/* Update any VMCS fields that might have changed while L2 ran */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6c56d5235f0f3..042b7a88157b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1477,7 +1477,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		 * performs IBPB on nested VM-Exit (a single nested transition
 		 * may switch the active VMCS multiple times).
 		 */
-		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
+		if (cpu_feature_enabled(X86_FEATURE_USE_IBPB) &&
+		    (!buddy || WARN_ON_ONCE(buddy->vmcs != prev)))
 			indirect_branch_prediction_barrier();
 	}
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index ffc25b3480415..be0c1a509869c 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -437,7 +437,8 @@ static void cond_mitigation(struct task_struct *next)
 		 * both have the IBPB bit set.
 		 */
 		if (next_mm != prev_mm &&
-		    (next_mm | prev_mm) & LAST_USER_MM_IBPB)
+		    (next_mm | prev_mm) & LAST_USER_MM_IBPB &&
+		    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
 			indirect_branch_prediction_barrier();
 	}
 
@@ -447,8 +448,8 @@ static void cond_mitigation(struct task_struct *next)
 		 * different context than the user space task which ran
 		 * last on this CPU.
 		 */
-		if ((prev_mm & ~LAST_USER_MM_SPEC_MASK) !=
-					(unsigned long)next->mm)
+		if ((prev_mm & ~LAST_USER_MM_SPEC_MASK) != (unsigned long)next->mm &&
+		    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
 			indirect_branch_prediction_barrier();
 	}
 
-- 
2.48.1.658.g4767266eb4-goog


