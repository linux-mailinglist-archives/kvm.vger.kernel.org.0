Return-Path: <kvm+bounces-48048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83922AC852A
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AC934E3803
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52186262FD5;
	Thu, 29 May 2025 23:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQRuEkwy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428C525F992
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562040; cv=none; b=vGZVHjF94+VpHbT+lg/UqNo6tUOugQR1x+4yiFXkfgX1ZzkLd0EVmkGfuEkvIWk0PCI8o2s0JJR+kOhY389Iu3QRLiNUrfWsYvo2SwPS6LsKB2DntVC+rJwy7gqVrKMZ5w+K1dUA9ep23DHiyB6FSX9ndC+PtlhdLF7R2Wlb388=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562040; c=relaxed/simple;
	bh=94/cIo0ZaNeNMrTuBNRj2fEw9iK5U5ZqG1f99RggVRw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GskDjqZHakE/Gf57HBF/YNkjb3cjAxcX2AM9Pl3PEOxt5+p7L3Pyt6OjBrw6fGZxERmTLTYUcBsQ4Gsc4BH1s6SSTLhkDqQCUO72/F5ACwYRZfw2nx1Cu/BzwiLO98Xi/pgBZ9csF0vUi+daPH2OjF0rSOu/gILsxrScxqxVlQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kQRuEkwy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26db9af463so1629637a12.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562036; x=1749166836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1alTOvB6/OgwjfECeMNZmm+TY5Agjn31jw7ghlo20NU=;
        b=kQRuEkwyH7KMJpDmm77rF55FhFr3jHkxF/d7BkiRoJimEqPKCMXfyUkBRtay5TFdn4
         Nml4SJC6cEuzOSiuOhTv4VyFdvxrKk0DlYebIK3n7wLOrM5a2lojNpi0CuaF2cWwbDyz
         0ygCi310gWPcgAqN5zWD/tysAdi4P97Lw7YCKWpcyE2IpuiyRowpE+2gdrjZHzys88lF
         m5uhGbpzvjoKp0hX9Va2yEibVo3Jh3mHFd9jXwm4WkcLHepkQWNBF8EArlIqItCVGVf5
         LG22T0xALDSShOZj3Z/fdimR6lVckV9fjP8cr+fb44OLcivhYvVjGb5O7XGkOZ54793i
         I0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562036; x=1749166836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1alTOvB6/OgwjfECeMNZmm+TY5Agjn31jw7ghlo20NU=;
        b=cJtO7E7uDxCORnVME1MH893xE6husmgJ+zUZV3wq5OYV9tuRzXTJCFpsLxAi/7amCJ
         r23ndg25BtLylc58NJ6Sd6o0Qm2BtCT0ZpVRwDPvDvYG4x+6MCf8idPlSbU2Pgx/UeVC
         ChDG6Wg15mxVciba1HdLRUsZK6jZHlB8rPCpg5tmP3qSeL55yE+PvxrQ76tF76FLXVRU
         d0NuGL6qZhCjzVkjo5awB3CS+IvgnCqXja39N00hHxbNdW29MqprXW7mm+DEsXw5PO0U
         pUzTuxtYqldcWjTbSDCNfdX/fRXxfl/+eLxkhVlMMhoTuxHdwjIK10PJSVfU0O6Fx41Y
         Hj6Q==
X-Gm-Message-State: AOJu0YyCck8HFFtSGAKL1+3497pCwInPMOBxiU0zXaiMqqKCfKr7lP3w
	IWnijCODgnRS4rIwl/0CqKkhAkIXyYRkdV/gEobVvjfAPI/qey4liJXxYMOWZCuGWFHVUYXqY97
	scL5oLQ==
X-Google-Smtp-Source: AGHT+IFtU7P7UEpwBoLNgYVBS/XLCpMgv6DLTf4/K+/UW1m+eAyE3ysz+wZwzzGG0pE7inrk9oz0oNkkmdU=
X-Received: from pjtq15.prod.google.com ([2002:a17:90a:c10f:b0:311:e9bb:f8d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec1:b0:311:b07f:1b86
 with SMTP id 98e67ed59e1d1-31241e725cfmr1858664a91.29.1748562036544; Thu, 29
 May 2025 16:40:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:57 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-13-seanjc@google.com>
Subject: [PATCH 12/28] KVM: SVM: Implement and adopt VMX style MSR intercepts APIs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c |  18 ++++----
 arch/x86/kvm/svm/svm.c | 100 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h |  12 +++++
 3 files changed, 93 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 978a0088a3f1..bb0ec029b3d4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4415,12 +4415,10 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
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
@@ -4436,9 +4434,9 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
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
@@ -4515,8 +4513,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
 	/* Clear intercepts on selected MSRs */
-	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+	svm_disable_intercept_for_msr(vcpu, MSR_EFER, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_CR_PAT, MSR_TYPE_RW);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 76d074440bcc..56460413eca6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -869,11 +869,57 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
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
+	/*
+	 * Don't disabled interception for the MSR if userspace wants to
+	 * handle it.
+	 */
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
@@ -893,13 +939,13 @@ u32 *svm_vcpu_alloc_msrpm(void)
 
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
 
@@ -919,8 +965,8 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		if ((index < APIC_BASE_MSR) ||
 		    (index > APIC_BASE_MSR + 0xff))
 			continue;
-		set_msr_interception(&svm->vcpu, svm->msrpm, index,
-				     !intercept, !intercept);
+
+		svm_set_intercept_for_msr(&svm->vcpu, index, MSR_TYPE_RW, intercept);
 	}
 
 	svm->x2avic_msrs_intercepted = intercept;
@@ -1008,13 +1054,13 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
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
@@ -1028,10 +1074,10 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
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
@@ -1223,8 +1269,8 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1236,8 +1282,8 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 		/* No need to intercept these MSRs */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	}
 }
 
@@ -1370,7 +1416,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * of MSR_IA32_SPEC_CTRL.
 	 */
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
 
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
@@ -3137,7 +3183,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -4641,12 +4687,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
index e432cd7a7889..32bb1e536dce 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -701,6 +701,18 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
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
2.49.0.1204.g71687c7c1d-goog


