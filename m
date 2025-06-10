Return-Path: <kvm+bounces-48898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4356EAD4644
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FFB03A7352
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840102D1930;
	Tue, 10 Jun 2025 22:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uwh8UfA9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67F62D321E
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596286; cv=none; b=X6K1H1gtMngFxhX0gmVe90Z+ucyhYlYCl5L3rfJA6PSU7+bI4EoZFpqPspdEDhwItm+tYVOl4NfLvws2aRv/pSRr+0aQJ7mGvXsYuoJpNN0nIl6BwQVs1o8bYZIr85QuY+i8n0N8oF3yuyP2KqPpkm2AXtEyfHkhHDSijy5W2Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596286; c=relaxed/simple;
	bh=N7h+A7D556/1VTlpmcJMLpYRql2HnNSQ8Sjk17RLkcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uq90h6DcW3+mdObSTWElltRQWxVP1H6So0noRi7eUuep5JCPA3yVMPDwRYwSNp4/3ZHpRVdtlkYKT/dgrVD3QlVR1jUPjMNILHZOroJt0a/HkWEC9hnwsaRcR6hDAaNNy3EChwg+LLM7DJYhySy4rVHuaPLk3tLiECqBE5OPKzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uwh8UfA9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2358430be61so53689025ad.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596284; x=1750201084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DzbFvdj10j5BJCBLru7m8eiqLfdpYCuLPbQOkmNv8cA=;
        b=Uwh8UfA94Igyu7YU5uvU/RgfJ2mrIA/bYb6nGU88Cob96l5nyKowAw7EnOEh/F80zt
         VnrDwfdSaRYz/Iz2wRMDe4T8+GTImHasflvLammVN1DiCoCvYMkNOHQ5R8Zu/l6KKzW/
         CAbpPyYNCDZXpsM2TB2DLUiVY6+3PoYB3nK+fxDF+yioMmtmmX+G6xdA0Q8YCglGL8vN
         KFyW7bp2xs9fVF1PZptmwRfSq/WqNRO0LGnZxoe9sr11A+Bkb78GuWyfLtFvZfkCEHrh
         v0YX+Tzk8RORbGQLDAZZZfeEhZVQsJIV6p2JAzXeV/yKdODTL709hHJs7FpaUWaxjJKF
         vArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596284; x=1750201084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DzbFvdj10j5BJCBLru7m8eiqLfdpYCuLPbQOkmNv8cA=;
        b=VYw+qHOQC+8bZ3TIn13VsSTAd1bN6XYX6wGqXvGEqnMS9Q2VgM0J7dmQc+6wOU3EeA
         iek2y2CgOqD/0ozG33dgxIu6F+q5FnIUN4+kpkbCDU7Gc7JD3BkFgBYOlvkN4zQ7Zu9k
         y8Of56ncsbT6g/5hl6001iQXAj6aWukls6l9j0NbCCj604gXgJ2SKBpCWdscz3u+lB/3
         NuSyiwOO7EXBxRWnCKIUBOHEdSOKnqyvTbyIgFzFPgZJmMeOjHp6MGQNT0DE/U9lhYKF
         F/BAwwYf4wDT3HGBcvBO4boSeeYAb46qZAQLOGUCzCAs1LwJNFPdKu8rDlApgiM3PP1K
         mP6w==
X-Gm-Message-State: AOJu0YzgHkjlrAZ56Ysy8QYFy1ZP9Ev3Lzx3aOl3medW2UyGZsSZbQkL
	b2RVWktJI9keyOFVPoN8RZ1N3yak+Z+nnAjCKY8vQKfrl2AsZ7a7pnJUCwPXgVO7lzPNTslTDFZ
	o2frCXA==
X-Google-Smtp-Source: AGHT+IFXA/JRLPUgGSkQhSU10/RA1tHURIrVbKSy0OG3M3Wcsi5hCzmlt7zZFZy04Rc9qMvsMNOyYzOQDSs=
X-Received: from pllo12.prod.google.com ([2002:a17:902:778c:b0:235:e734:e93e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf46:b0:235:e1e4:ec5e
 with SMTP id d9443c01a7336-236426d5bd2mr4658765ad.49.1749596284299; Tue, 10
 Jun 2025 15:58:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:19 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-15-seanjc@google.com>
Subject: [PATCH v2 14/32] KVM: SVM: Implement and adopt VMX style MSR
 intercepts APIs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add and use SVM MSR interception APIs (in most paths) to match VMX's
APIs and nomenclature.  Specifically, add SVM variants of:

        vmx_disable_intercept_for_msr(vcpu, msr, type)
        vmx_enable_intercept_for_msr(vcpu, msr, type)
        vmx_set_intercept_for_msr(vcpu, msr, type, intercept)

to eventually replace SVM's single helper:

        set_msr_interception(vcpu, msrpm, msr, allow_read, allow_write)

which is awkward to use (in all cases, KVM either applies the same logic
for both reads and writes, or intercepts one of read or write), and is
unintuitive due to using '0' to indicate interception should be *set*.

Keep the guts of the old API for the moment to avoid churning the MSR
filter code, as that mess will be overhauled in the near future.  Leave
behind a temporary comment to call out that the shadow bitmaps have
inverted polarity relative to the bitmaps consumed by hardware.

No functional change intended.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 18 ++++----
 arch/x86/kvm/svm/svm.c | 99 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h | 12 +++++
 3 files changed, 90 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6c2f840a0171..74dab69fb69e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4351,12 +4351,10 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
-		bool v_tsc_aux = guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) ||
-				 guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID);
-
-		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
-	}
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX))
+		svm_set_intercept_for_msr(vcpu, MSR_TSC_AUX, MSR_TYPE_RW,
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID));
 
 	/*
 	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
@@ -4372,9 +4370,9 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 	 */
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
 	else
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 0, 0);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
 }
 
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
@@ -4451,8 +4449,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
 	/* Clear intercepts on selected MSRs */
-	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+	svm_disable_intercept_for_msr(vcpu, MSR_EFER, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_CR_PAT, MSR_TYPE_RW);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd1e0ca964b0..93d66109f495 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -865,11 +865,53 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	svm->nested.force_msr_bitmap_recalc = true;
 }
 
-void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
-			  int read, int write)
+void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
-	set_shadow_msr_intercept(vcpu, msr, read, write);
-	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	void *msrpm = svm->msrpm;
+
+	/* Note, the shadow intercept bitmaps have inverted polarity. */
+	set_shadow_msr_intercept(vcpu, msr, type & MSR_TYPE_R, type & MSR_TYPE_W);
+
+	/* Don't disable interception for MSRs userspace wants to handle. */
+	if ((type & MSR_TYPE_R) &&
+	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
+		svm_set_msr_bitmap_read(msrpm, msr);
+		type &= ~MSR_TYPE_R;
+	}
+
+	if ((type & MSR_TYPE_W) &&
+	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
+		svm_set_msr_bitmap_write(msrpm, msr);
+		type &= ~MSR_TYPE_W;
+	}
+
+	if (type & MSR_TYPE_R)
+		svm_clear_msr_bitmap_read(msrpm, msr);
+
+	if (type & MSR_TYPE_W)
+		svm_clear_msr_bitmap_write(msrpm, msr);
+
+	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
+	svm->nested.force_msr_bitmap_recalc = true;
+}
+
+void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	void *msrpm = svm->msrpm;
+
+	set_shadow_msr_intercept(vcpu, msr,
+				 !(type & MSR_TYPE_R), !(type & MSR_TYPE_W));
+
+	if (type & MSR_TYPE_R)
+		svm_set_msr_bitmap_read(msrpm, msr);
+
+	if (type & MSR_TYPE_W)
+		svm_set_msr_bitmap_write(msrpm, msr);
+
+	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
+	svm->nested.force_msr_bitmap_recalc = true;
 }
 
 u32 *svm_vcpu_alloc_msrpm(void)
@@ -889,13 +931,13 @@ u32 *svm_vcpu_alloc_msrpm(void)
 
 static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu)
 {
-	u32 *msrpm = to_svm(vcpu)->msrpm;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		if (!direct_access_msrs[i].always)
 			continue;
-		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, direct_access_msrs[i].index,
+					      MSR_TYPE_RW);
 	}
 }
 
@@ -915,8 +957,8 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		if ((index < APIC_BASE_MSR) ||
 		    (index > APIC_BASE_MSR + 0xff))
 			continue;
-		set_msr_interception(&svm->vcpu, svm->msrpm, index,
-				     !intercept, !intercept);
+
+		svm_set_intercept_for_msr(&svm->vcpu, index, MSR_TYPE_RW, intercept);
 	}
 
 	svm->x2avic_msrs_intercepted = intercept;
@@ -1004,13 +1046,13 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW);
 
 	if (sev_es_guest(vcpu->kvm))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
 	if (is_guest_mode(vcpu))
@@ -1024,10 +1066,10 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW);
+	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW);
+	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW);
+	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW);
 
 	/*
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them
@@ -1219,8 +1261,8 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1232,8 +1274,8 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 		/* No need to intercept these MSRs */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	}
 }
 
@@ -1367,9 +1409,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * of SPEC_CTRL, without waiting for the guest to access the MSR.
 	 */
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
-				     guest_has_spec_ctrl_msr(vcpu),
-				     guest_has_spec_ctrl_msr(vcpu));
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
+					  !guest_has_spec_ctrl_msr(vcpu));
 
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
@@ -3136,7 +3177,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -4640,12 +4681,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	if (boot_cpu_has(X86_FEATURE_IBPB))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0,
-				     !!guest_has_pred_cmd_msr(vcpu));
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
+					  !guest_has_pred_cmd_msr(vcpu));
 
 	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
-				     !!guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a2be18579e09..5d5805ab59a7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -697,6 +697,18 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 
+void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
+void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
+
+static inline void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
+					     int type, bool enable_intercept)
+{
+	if (enable_intercept)
+		svm_enable_intercept_for_msr(vcpu, msr, type);
+	else
+		svm_disable_intercept_for_msr(vcpu, msr, type);
+}
+
 /* nested.c */
 
 #define NESTED_EXIT_HOST	0	/* Exit handled on host level */
-- 
2.50.0.rc0.642.g800a2b2222-goog


