Return-Path: <kvm+bounces-38606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CBDFA3CC0B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5351189BCD1
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 22:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CA825A2A0;
	Wed, 19 Feb 2025 22:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GfLjzT/T"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B31F2586D9
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 22:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002924; cv=none; b=jzmzyyV8oRLWDosXsMpy4JG2W0K2fDNsIVkw3MXKkQEVczra5pyFMe5oGyYZwgbVBOdng2j4qmEb4hHICMw+o1XuRGhBGhrgotXQWypnpo3UEwoR0z5ZOMGIqdNJkCfq+PJiY1/op17NrDv6OmCasCgL/3KzRHzNbFwZkzQqPuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002924; c=relaxed/simple;
	bh=N+wvN52ITsI7CMDE2k/f9hrV0NNcD7DcmVrA4imjqhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLW9crMAvVBnuZyCB7QEMF8/7X8hvIL4SfLXKrO8phXHiK0SHMjIbzlYNuD0B+2e2ptQlJ9Yj0WH2p5/6zrRb7Ng2Vp9imqVxtFJytLLSiq8NDQxOKrp6tmSpW6GbM7L5fQW8RRWw1i2CdQnYMGvbVqV9Ul2vLR0vsSvDSRg7EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GfLjzT/T; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740002919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weqJitDx/60lDRQvo2MSzqvgLPX0PVTqW9A9VtT4xlo=;
	b=GfLjzT/TIY4kfkK+jigajvH9YlihUQaHBLAKbK5/q/QirbI+3VmRNWJvd9uLJPMScTl7iQ
	uROFA3eupOKFMLX+NCtglceAAeNPtwgCLEJ8JVOeE9dUmJSa14XLi6jVHBQPmSCdICqArj
	dGrFIbtpgTL5V4TOOwHpH10YYNnnTn4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86/bugs: Move the X86_FEATURE_USE_IBPB check into callers
Date: Wed, 19 Feb 2025 22:08:21 +0000
Message-ID: <20250219220826.2453186-2-yosry.ahmed@linux.dev>
In-Reply-To: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
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
index a5d0998d76049..fc7ce7a2fc495 100644
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
index a713c803a3a37..a4ba5b4e3d682 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1559,7 +1559,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
index 6c56d5235f0f3..729a8ee24037b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1478,7 +1478,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		 * may switch the active VMCS multiple times).
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
-			indirect_branch_prediction_barrier();
+			if (cpu_feature_enabled(X86_FEATURE_USE_IBPB))
+				indirect_branch_prediction_barrier();
 	}
 
 	if (!already_loaded) {
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
2.48.1.601.g30ceb7b040-goog


