Return-Path: <kvm+bounces-39474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B0DFA47162
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 493357AD2B3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA461B07AE;
	Thu, 27 Feb 2025 01:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ncq2TKQZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695BA1AF0C7
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619665; cv=none; b=l6FsKmPWUcSyaOWaCMHJDZr7hX6eQb/vvghLOm0Fd2xcrpgevhyYvrEon9e2mmdoEtO/tOLVg4PANfPZDVIW7sAip8NkVHZygJny41hQjq8YveQE9CX6kdT0rbjm0xhsQIo+7UDG012Pw0YsmzV2w5NUNpm+aZZWC6Q6GGR3XKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619665; c=relaxed/simple;
	bh=MJUfF7p26znqsRd71QkxiKuEqw5hwNIYx869VTuAzqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5Z7pf8gjw2A9VQSF05Boi/eWQXoKTz6xnkte2RHf7BGmg4Ap6DgGwQlxrNTOKjKm+WyzBkwuhqx4jbdF3BQyZi75QQoB+zmdVyXbFK7IKc5BMET6HYCK6+GP7zdryumV7QVp2FpGb4hxAHcqwfXfYctMwzQBlrZhS7PiTEkb14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ncq2TKQZ; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740619660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=inZTcE9vZsNLhguAg/kTgyLxoDkWmzTqzRa3pZ8DdDU=;
	b=Ncq2TKQZ/IJ4xbucbqtQ7Beux11X1pjvnfVY+U0kCSVGvTO2fh6RYFffg9vO0ewt4tRLi7
	pgezoU0Ggb5KW42/8wnJJMfkfgXr2F/F0jVX46IoKddNU1yg6y2WTURBQSoS0u5UAfhJMh
	2MmYTEqBrhiJOL3niq/CfB5xAx0L/es=
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
Subject: [PATCH v2 4/6] x86/bugs: Use a static branch to guard IBPB on vCPU switch
Date: Thu, 27 Feb 2025 01:27:10 +0000
Message-ID: <20250227012712.3193063-5-yosry.ahmed@linux.dev>
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

Instead of using X86_FEATURE_USE_IBPB to guard the IBPB execution in KVM
when a new vCPU is loaded, introduce a static branch, similar to
switch_mm_*_ibpb.

This makes it obvious in spectre_v2_user_select_mitigation() what
exactly is being toggled, instead of the unclear X86_FEATURE_USE_IBPB
(which will be shortly removed). It also provides more fine-grained
control, making it simpler to change/add paths that control the IBPB in
the vCPU switch path without affecting other IBPBs.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h | 2 ++
 arch/x86/kernel/cpu/bugs.c           | 5 +++++
 arch/x86/kvm/svm/svm.c               | 2 +-
 arch/x86/kvm/vmx/vmx.c               | 2 +-
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 7cbb76a2434b9..36bc395bdef32 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -552,6 +552,8 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+DECLARE_STATIC_KEY_FALSE(switch_vcpu_ibpb);
+
 DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1d7afc40f2272..7f904d0b0b04f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -113,6 +113,10 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 /* Control unconditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+/* Control IBPB on vCPU load */
+DEFINE_STATIC_KEY_FALSE(switch_vcpu_ibpb);
+EXPORT_SYMBOL_GPL(switch_vcpu_ibpb);
+
 /* Control MDS CPU buffer clear before idling (halt, mwait) */
 DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
 EXPORT_SYMBOL_GPL(mds_idle_clear);
@@ -1365,6 +1369,7 @@ spectre_v2_user_select_mitigation(void)
 	/* Initialize Indirect Branch Prediction Barrier */
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
+		static_branch_enable(&switch_vcpu_ibpb);
 
 		spectre_v2_user_ibpb = mode;
 		switch (cmd) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 57222c3b56592..a73875ffbc3df 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1566,7 +1566,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		sd->current_vmcb = svm->vmcb;
 
 		if (!cpu_feature_enabled(X86_FEATURE_IBPB_ON_VMEXIT) &&
-		    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
+		    static_branch_likely(&switch_vcpu_ibpb))
 			indirect_branch_prediction_barrier();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 042b7a88157b0..956f9143a3c4c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1477,7 +1477,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		 * performs IBPB on nested VM-Exit (a single nested transition
 		 * may switch the active VMCS multiple times).
 		 */
-		if (cpu_feature_enabled(X86_FEATURE_USE_IBPB) &&
+		if (static_branch_likely(&switch_vcpu_ibpb) &&
 		    (!buddy || WARN_ON_ONCE(buddy->vmcs != prev)))
 			indirect_branch_prediction_barrier();
 	}
-- 
2.48.1.658.g4767266eb4-goog


