Return-Path: <kvm+bounces-54043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1A8B1BAAA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AD796275CF
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E186A2BE03C;
	Tue,  5 Aug 2025 19:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3wcsUuup"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D26E2BD5B6
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420749; cv=none; b=B4ftU/Y+bSDXi9MVVL0kg5X6ijz60KAnHBu3kpCwjCmWCJaSV6BmYydtDalOGXWzbysuQin6lL9NY90+CujT1Q/GfpDaP9VsmetpawdWrki4p9OYyijFxyFu1OSEo6JOv5mItD52EFtm1tmWAzOJQPOt2aj4oayFD+Y+veXncJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420749; c=relaxed/simple;
	bh=fQdHBwN4VEt+pvYyDup9bjJdFXgdWHQSPp8w7ovATOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DC+93h0cfyKyaITHqKNeRSvygmgz0Cx8woi+24OWZqfXPNUDubGkCUPCfYwN6Z2SxttDxCyVQEip2QD8ApOqFIrcJ0b4huhIAPZPQAZM8TRcFPF39QnjvoFBkzy8B1fDz6kLUkO7MsuGvGUr4SvDFDnWiEUaIvfBQxDbNbYB4ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3wcsUuup; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ea430d543so4874345a91.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420747; x=1755025547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+L4JanujMoX8MoOBANSSIqbWu9pkFvKE1OPkqsOcNNY=;
        b=3wcsUuup94S3siCWcSAJRg62bzsdrFmuvyu3NGhxOaE9YhkizxrHAmfc5LRYjujQgx
         nO7ImQgitEIJ03aBajd+GCRGdbB533TnVEMmwcIDEIMI4IYmWjf2pnVmHS3rU6Ivl1cA
         LeOEW6HgiZWjwxHIgjb2O3B4uUEYKDhKSKxcvIQICHmQuGr0kzqi9ZZwdkJbn9ABP9EF
         OR1IDpwEIem4/EiYWIpUFGI2y0sCS0FdFEdN9pGvG08k1spIh/vXejNpK1Xjx1eCISlV
         elgZZvk56lId4BSDnV5q+Qc+g/b3V57yh7/yrMkyopj8gmg5OTjsiIok81BWDWppVvkt
         djkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420747; x=1755025547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+L4JanujMoX8MoOBANSSIqbWu9pkFvKE1OPkqsOcNNY=;
        b=tNS4KdDoT5hMwfOdLap+HL+6KiRSuNwMyPa3hC3Nd97srV4iVd3jjCo2eegOHrTBfq
         l7E8crvuBQUYXQqi/q8GPHDkttYfyTId9xTDeOC6coRLpptxOcVgA1hCxTRpclLLHDSN
         A0kQ2KbMXNyEG9dCImkOqaLd7MFfSNrvtiYrT5YAp9kQdpxji8lAhQAzrRRMevrtvTTa
         A5USvUPo9QZm+ifQGHeB+sId5bM5xOHDH3UIceT43bY1Eg+lSRRyW+cwNemdbZ6Bpw+N
         C5sccvdOSHB0RVEPNIAg8WGxzQD8o+560Dwamxk+huqBeIQ8dBPT1xD17dSI3kCDEi9t
         imrg==
X-Gm-Message-State: AOJu0YycwpC9MaUuYRhXmMhGGvtTYWqQQmg+wt4S2UDMgYLc6EjBPHcl
	ZXJiVT47/x3SxSK76lb4/EVuLtbosJHfUy4WPabfr58NlCvp7t2hHI6alCoc0DPcGjk4dogidqJ
	IOE7NWQ==
X-Google-Smtp-Source: AGHT+IFskUMxmRr7Bj7HjcQz9vGA7uoUEXtiOjCozXPo6XWYD6hnHLqJur4fscHNQZMzgjvF5+H0EbT8TBg=
X-Received: from pjbnd10.prod.google.com ([2002:a17:90b:4cca:b0:311:f699:df0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcc:b0:312:f650:c795
 with SMTP id 98e67ed59e1d1-321162bb980mr18647574a91.21.1754420747170; Tue, 05
 Aug 2025 12:05:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:18 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-11-seanjc@google.com>
Subject: [PATCH 10/18] KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add wrappers for triggering instruction retired and branch retired PMU
events in anticipation of reworking the internal mechanisms to track
which PMCs need to be evaluated, e.g. to avoid having to walk and check
every PMC.

Opportunistically bury "struct kvm_pmu_emulated_event_selectors" in pmu.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c        | 22 ++++++++++++++++++----
 arch/x86/kvm/pmu.h        |  9 ++-------
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/x86.c        |  6 +++---
 4 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eb17d90916ea..e1911b366c43 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -29,8 +29,11 @@
 struct x86_pmu_capability __read_mostly kvm_pmu_cap;
 EXPORT_SYMBOL_GPL(kvm_pmu_cap);
 
-struct kvm_pmu_emulated_event_selectors __read_mostly kvm_pmu_eventsel;
-EXPORT_SYMBOL_GPL(kvm_pmu_eventsel);
+struct kvm_pmu_emulated_event_selectors {
+	u64 INSTRUCTIONS_RETIRED;
+	u64 BRANCH_INSTRUCTIONS_RETIRED;
+};
+static struct kvm_pmu_emulated_event_selectors __read_mostly kvm_pmu_eventsel;
 
 /* Precise Distribution of Instructions Retired (PDIR) */
 static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
@@ -907,7 +910,7 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 							 select_user;
 }
 
-void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
+static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -944,7 +947,18 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 		kvm_pmu_incr_counter(pmc);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
+
+void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
+}
+EXPORT_SYMBOL_GPL(kvm_pmu_instruction_retired);
+
+void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
+}
+EXPORT_SYMBOL_GPL(kvm_pmu_branch_retired);
 
 static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 13477066eb40..740af816af37 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -23,11 +23,6 @@
 
 #define KVM_FIXED_PMC_BASE_IDX INTEL_PMC_IDX_FIXED
 
-struct kvm_pmu_emulated_event_selectors {
-	u64 INSTRUCTIONS_RETIRED;
-	u64 BRANCH_INSTRUCTIONS_RETIRED;
-};
-
 struct kvm_pmu_ops {
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
@@ -178,7 +173,6 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 }
 
 extern struct x86_pmu_capability kvm_pmu_cap;
-extern struct kvm_pmu_emulated_event_selectors kvm_pmu_eventsel;
 
 void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops);
 
@@ -227,7 +221,8 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
-void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel);
+void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu);
+void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b8ea1969113d..db2fd4eedc90 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3690,7 +3690,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return 1;
 	}
 
-	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
+	kvm_pmu_branch_retired(vcpu);
 
 	if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
 		return nested_vmx_failInvalid(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4441f036929..f2b2eaaec6f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8824,7 +8824,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	if (unlikely(!r))
 		return 0;
 
-	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
+	kvm_pmu_instruction_retired(vcpu);
 
 	/*
 	 * rflags is the old, "raw" value of the flags.  The new value has
@@ -9158,9 +9158,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 */
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
-			kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
+			kvm_pmu_instruction_retired(vcpu);
 			if (ctxt->is_branch)
-				kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
+				kvm_pmu_branch_retired(vcpu);
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
-- 
2.50.1.565.gc32cd1483b-goog


