Return-Path: <kvm+bounces-32591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D999DAE72
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E957AB22A6E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1C52036E3;
	Wed, 27 Nov 2024 20:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FfINYrk8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B701202F84
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738796; cv=none; b=qWBBKpTTg8Yq773tFuRLMRAdgi9Z5XPAapLeydL5DnOOYsUgN2KZDNAKh9I5s0KGALzz78QUDPiLym2TEwgONrCkGXHzdQwX8lg6Jwa6ZJlgNBXvgWAr4g+YtZWxwiqsRqveGKTfLZd3wEtX0jB8ihXt9VUhAJVHZlUGYEwQOb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738796; c=relaxed/simple;
	bh=Fa+p86enDaBNNJQcICRz+PBQ5cGaFWmvwyNHovbPbRc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T74/D1AcxvSkrVnJn6fKtpzB//n6NlAq8Zb9eEghKUvR+hUrBjv5WwxjtohcYKKRdaXJVWXnprKfhPCacGf+cLgoN7L70XimG9S0c8piMQHWHxLGGpsieYC6vdFQpd58QollGdG83B7GtXIyHhErPVNu/wJqqS0kMWQuyQSSIJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FfINYrk8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea5a0f7547so152528a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738793; x=1733343593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=85dLC92Z/qdG+ARAKtwvrBosK7GSKlLYsWTsdpGzUqk=;
        b=FfINYrk8sLg97pVn9wFzJc6yrQTJkkjohS8gy7WD3ztz5Hn+PClH5XVgbzAe/31ucg
         nhS0AzRcCdKN8Sk7VGE4hwCN1GIbtT9LlLIXROlV1mJhTStlzgz7ZpyeSS40rF+J/A5U
         F/IFuPhG98VWsktekiMzVIS2Xo2wXDgpoJsWSigDdjf1AMmWO+CWWalNZ5c7+Uwu/+EG
         Ukz3M85D5gGqikN0/8rqmvcok6qHAJiUtu4Wg+go0Ck4K+pZ7h116enovKkmj1XwT9ph
         P+2+3fIBQAOSsytdKOjeK3oQ5lKD6FDvgco8SWd5RerZJOcqDE5ZmCQtBq2AR+Ru6uOc
         yL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738793; x=1733343593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=85dLC92Z/qdG+ARAKtwvrBosK7GSKlLYsWTsdpGzUqk=;
        b=bmFnb25csGy+LXVkoKIIFXDHto0EDxxsQfnKR9kZmQJRTIX9xfH78VE4VCyIBTFvqN
         zAdUG/HB8QBtC7FO9TJb8ifwVjP1Fa7va2ZVwh/rE2zYk2ue7TElZyS3aoGa6YyK9gHy
         i01fwIb6nCetu5tI2NxyMIQSIttOCrEHMvHyns6U0ptGKfwBB0bLTcpbwiLNmRmCJb0w
         c7WGduqX8+JoIaBvXo/XgEIGxFez5m0piny6IRk5qiOotE0fQ4FVnmaeYVgE8rB3uE3I
         KPDdSc/1UXD0xaAZhHfLtr7d0O9Ky7NlLqPpr79IQ7jK1sYr7N99IJ1OLRIvPRDOxz92
         Zgug==
X-Gm-Message-State: AOJu0YxlVNwlppBTLqsnz1/ADqR7gxKR4aGR0K+TkIrBNYMOa9QUeKXm
	GLi6luTGIxRLJkwEVSUZGq/KH9d/HgxQmmfu7+DVFzXyFDdqelEEK+faDShe06jBJclfU9JKbUE
	ll4Is55Bzl72UqfaHrtz7iH6rrxH8y2WDmVNXY82oelaZq203IdGXALIOvaW3sj9GR9lEzD2PYS
	3HwKoo7eDgkGb+bHMmCRPH03qzPlc3WQlMXB6VOTMmJyBoV8GI/Q==
X-Google-Smtp-Source: AGHT+IEAim4YzyVoZxu2nPrB28q2NkQoK1/HtoTOpro2rXrqWvbxZllHGV9NTtK3OMT/ZpqOVEEs0LjGl8Ab83oV
X-Received: from pjbnd10.prod.google.com ([2002:a17:90b:4cca:b0:2ea:8715:5c92])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c09:b0:2ea:7755:a0ff with SMTP id 98e67ed59e1d1-2ee08e5e3d5mr5543391a91.6.1732738793342;
 Wed, 27 Nov 2024 12:19:53 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:19 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-6-aaronlewis@google.com>
Subject: [PATCH 05/15] KVM: x86: SVM: Adopt VMX style MSR intercepts in SVM
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>, Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

VMX MSR interception is done via three functions:

        vmx_disable_intercept_for_msr(vcpu, msr, type)
        vmx_enable_intercept_for_msr(vcpu, msr, type)
        vmx_set_intercept_for_msr(vcpu, msr, type, value)

While SVM uses

        set_msr_interception(vcpu, msrpm, msr, read, write)

The SVM code is not very intuitive (using 0 for enable and 1 for
disable), and forces both read and write changes with each call which
is not always required.

Add helpers functions to SVM to match VMX:

        svm_disable_intercept_for_msr(vcpu, msr, type)
        svm_enable_intercept_for_msr(vcpu, msr, type)
        svm_set_intercept_for_msr(vcpu, msr, type, enable_intercept)

Additionally, update calls to set_msr_interception() to use the new
functions. This update is only made to calls that toggle interception
for both read and write.

Keep the old paths for now, they will be deleted once all code is
converted to the new helpers.

Opportunistically, the function svm_get_msr_bitmap_entries() is added
to abstract the MSR bitmap from the intercept functions.  This will be
needed later in the series when this code is hoisted to common code.

No functional change.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-Developed-by: Anish Ghulati <aghulati@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm/sev.c |  11 ++--
 arch/x86/kvm/svm/svm.c | 144 ++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h |  12 ++++
 3 files changed, 138 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c6c8524859001..cdd3799e71f24 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4448,7 +4448,8 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 		bool v_tsc_aux = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
 				 guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
 
-		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
+		if (v_tsc_aux)
+			svm_disable_intercept_for_msr(vcpu, MSR_TSC_AUX, MSR_TYPE_RW);
 	}
 
 	/*
@@ -4466,9 +4467,9 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 	 */
 	if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
 	else
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 0, 0);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_XSS, MSR_TYPE_RW);
 }
 
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
@@ -4540,8 +4541,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
 	/* Clear intercepts on selected MSRs */
-	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+	svm_disable_intercept_for_msr(vcpu, MSR_EFER, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_CR_PAT, MSR_TYPE_RW);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5dd621f78e474..b982729ef7638 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -868,6 +868,102 @@ void set_msr_interception(struct kvm_vcpu *vcpu, unsigned long *msrpm, u32 msr,
 	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
 }
 
+static void svm_get_msr_bitmap_entries(struct kvm_vcpu *vcpu, u32 msr,
+				       unsigned long **read_map, u8 *read_bit,
+				       unsigned long **write_map, u8 *write_bit)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 offset;
+
+	offset     = svm_msrpm_offset(msr);
+	*read_bit  = 2 * (msr & 0x0f);
+	*write_bit = 2 * (msr & 0x0f) + 1;
+	BUG_ON(offset == MSR_INVALID);
+
+	*read_map = &svm->msrpm[offset];
+	*write_map = &svm->msrpm[offset];
+}
+
+#define BUILD_SVM_MSR_BITMAP_HELPER(fn, bitop, access)			     \
+static inline void fn(struct kvm_vcpu *vcpu, u32 msr)			     \
+{									     \
+	unsigned long *read_map, *write_map;				     \
+	u8 read_bit, write_bit;						     \
+									     \
+	svm_get_msr_bitmap_entries(vcpu, msr, &read_map, &read_bit,	     \
+				   &write_map, &write_bit);		     \
+	bitop(access##_bit, access##_map);				     \
+}
+
+BUILD_SVM_MSR_BITMAP_HELPER(svm_set_msr_bitmap_read, __set_bit, read)
+BUILD_SVM_MSR_BITMAP_HELPER(svm_set_msr_bitmap_write, __set_bit, write)
+BUILD_SVM_MSR_BITMAP_HELPER(svm_clear_msr_bitmap_read, __clear_bit, read)
+BUILD_SVM_MSR_BITMAP_HELPER(svm_clear_msr_bitmap_write, __clear_bit, write)
+
+void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int slot;
+
+	slot = direct_access_msr_slot(msr);
+	WARN_ON(slot == -ENOENT);
+	if (slot >= 0) {
+		/* Set the shadow bitmaps to the desired intercept states */
+		if (type & MSR_TYPE_R)
+			__clear_bit(slot, svm->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			__clear_bit(slot, svm->shadow_msr_intercept.write);
+	}
+
+	/*
+	 * Don't disabled interception for the MSR if userspace wants to
+	 * handle it.
+	 */
+	if ((type & MSR_TYPE_R) && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
+		svm_set_msr_bitmap_read(vcpu, msr);
+		type &= ~MSR_TYPE_R;
+	}
+
+	if ((type & MSR_TYPE_W) && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
+		svm_set_msr_bitmap_write(vcpu, msr);
+		type &= ~MSR_TYPE_W;
+	}
+
+	if (type & MSR_TYPE_R)
+		svm_clear_msr_bitmap_read(vcpu, msr);
+
+	if (type & MSR_TYPE_W)
+		svm_clear_msr_bitmap_write(vcpu, msr);
+
+	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
+	svm->nested.force_msr_bitmap_recalc = true;
+}
+
+void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int slot;
+
+	slot = direct_access_msr_slot(msr);
+	WARN_ON(slot == -ENOENT);
+	if (slot >= 0) {
+		/* Set the shadow bitmaps to the desired intercept states */
+		if (type & MSR_TYPE_R)
+			__set_bit(slot, svm->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			__set_bit(slot, svm->shadow_msr_intercept.write);
+	}
+
+	if (type & MSR_TYPE_R)
+		svm_set_msr_bitmap_read(vcpu, msr);
+
+	if (type & MSR_TYPE_W)
+		svm_set_msr_bitmap_write(vcpu, msr);
+
+	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
+	svm->nested.force_msr_bitmap_recalc = true;
+}
+
 unsigned long *svm_vcpu_alloc_msrpm(void)
 {
 	unsigned int order = get_order(MSRPM_SIZE);
@@ -890,7 +986,8 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
 		if (!direct_access_msrs[i].always)
 			continue;
-		set_msr_interception(vcpu, msrpm, direct_access_msrs[i].index, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, direct_access_msrs[i].index,
+					      MSR_TYPE_RW);
 	}
 }
 
@@ -910,8 +1007,8 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		if ((index < APIC_BASE_MSR) ||
 		    (index > APIC_BASE_MSR + 0xff))
 			continue;
-		set_msr_interception(&svm->vcpu, svm->msrpm, index,
-				     !intercept, !intercept);
+
+		svm_set_intercept_for_msr(&svm->vcpu, index, MSR_TYPE_RW, intercept);
 	}
 
 	svm->x2avic_msrs_intercepted = intercept;
@@ -1001,13 +1098,13 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
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
@@ -1021,10 +1118,10 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
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
@@ -1216,8 +1313,8 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1229,8 +1326,8 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 		/* No need to intercept these MSRs */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	}
 }
 
@@ -1359,7 +1456,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	 * of MSR_IA32_SPEC_CTRL.
 	 */
 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
 
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
@@ -3092,7 +3189,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL,
+					      MSR_TYPE_RW);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -4430,13 +4528,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
-	if (boot_cpu_has(X86_FEATURE_IBPB))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0,
-				     !!guest_has_pred_cmd_msr(vcpu));
+	if (boot_cpu_has(X86_FEATURE_IBPB) && guest_has_pred_cmd_msr(vcpu))
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
 
-	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
-				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D) && guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d73b184675641..b008c190188a2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -618,6 +618,18 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
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
2.47.0.338.g60cca15819-goog


