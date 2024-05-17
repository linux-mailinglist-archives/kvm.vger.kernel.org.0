Return-Path: <kvm+bounces-17692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1998C8B9E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E06A61C212CF
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CAE1586C3;
	Fri, 17 May 2024 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HkMQY6Rn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E69015749B
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967661; cv=none; b=KHhsoEedpjaUSSVTtm3o9iOlCkuDUaOrO6+MmylnrinEqEMvXVfS0FwsQJ1adSPPr527AH8/xkJmA6ffvjqMKkk31EwqjgI1kTZrORPWIv3B+K243YOvP8F4/il9OA9tSvG+tdlnQePWWq+l+kVoTiMf+/m1zQd0tbn0Euh8u38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967661; c=relaxed/simple;
	bh=kI1V8iWtDCi3gaGLgIqfWqUEd9o1y7KFkaDu4zsWU9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yqjh6Gzl4fX0nLBNaqvC7dzK5hokZvYtLz3PiR2Pns4YnvUw7Uvkmru9vryO/U1RLqfJgc4FJp7Wosd1Tnrau/uvetBpKlrJyOWaztsPb2YOswpHF0yfkv24O+tWhbjmjyKXJia+Z1SpuNXIZALt01T8f/Mr1av2bsssoI8Zas8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HkMQY6Rn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1edf507b9e4so104351435ad.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967659; x=1716572459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4+vEQpXYFAV6v26K1r1y7x6SNSckikiSt0V6msMx5VQ=;
        b=HkMQY6Rn2Rz/rGsG1MKB2OwzrKjDAddvm83Oy7Gcpk0EQrXDyim0v+ZQjsB/SMtpWA
         4wpAoZyu3e5dqfgVyx2hq7vuD4HfD4xXCd7JkM0Mj58A340XHicA1WtXx5sNu7+rCzi8
         Ny1Coc+M0/F4o5UkF9WFruVSX6LKpwWRTN8kq5gH9BsMELuEX4nPRhWX2bfQaOF3NH3v
         KgsNgN0eu6qUgBEPpxgM/ORyNdVAhEOOCkUbCBJzWfe5OobGDOCy0pRG3VYFQLzbut1P
         4CatV66ZaSGI79Arh6x0nZBoTKIzpDivg/vq0Rz+xwHjvo0TaH46kDtiNTWhx9tFsIPR
         Li2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967659; x=1716572459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+vEQpXYFAV6v26K1r1y7x6SNSckikiSt0V6msMx5VQ=;
        b=MmZyghVYH0AZ5ZefEWVB2MtgpnmR2CrM7anOsOTtVk9oG13+7jggdbQoaH2P3UgTOW
         YbKBpOfpWFcwm4QeIiwNilKT1bJMRpvUklAh76s8/x9uxVDbohQpIEk01j4TXmPKq1t3
         TpbxZw/XU7H4gNg7vePcLEpMTFyxBgAtAuXg0G7w/Nr7WrDk8WP2gia3iIqba7mteJ1R
         iInyQ8RayrsI3QnEBW7EfzFwAmooWPpi0yrlWSp7cgfr1Lrf7r2GvV0RNElOxMj4eIu7
         ZWvqah21miwh7yJajPhMi16YTT5PoaVwyU/sq30xL3O/9DxA2zyGhzyYX3+VtZX7fmyN
         4Jcg==
X-Gm-Message-State: AOJu0YyTtzzn92rpbgSH6wmTZJQaEewAComgr+XmYx9xz3Qeo0Qc4NcD
	COi4hXDe+g5g/IA7f8W5ISH/a37cqGwr35vS9tqa+g4j1+fapRJj2GaR1jIeaJP2R+b22PMUkTF
	e/w==
X-Google-Smtp-Source: AGHT+IGVmngpFAiyErMvUjSPcvd+ZZOiDuP1pjBcsRxsnrKfM6mt8IfEJP2qYQGnfGBKkfzs+fzMKw3EQmI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88d:b0:1e8:a7fb:c1fc with SMTP id
 d9443c01a7336-1ef43d170c0mr16960645ad.5.1715967659453; Fri, 17 May 2024
 10:40:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:17 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-41-seanjc@google.com>
Subject: [PATCH v2 40/49] KVM: x86: Initialize guest cpu_caps based on KVM support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Constrain all guest cpu_caps based on KVM support instead of constraining
only the few features that KVM _currently_ needs to verify are actually
supported by KVM.  The intent of cpu_caps is to track what the guest is
actually capable of using, not the raw, unfiltered CPUID values that the
guest sees.

I.e. KVM should always consult it's only support when making decisions
based on guest CPUID, and the only reason KVM has historically made the
checks opt-in was due to lack of centralized tracking.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 14 +++++++++++++-
 arch/x86/kvm/cpuid.h   |  7 -------
 arch/x86/kvm/svm/svm.c | 11 -----------
 arch/x86/kvm/vmx/vmx.c |  9 ++-------
 4 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d1849fe874ab..8ada1cac8fcb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -403,6 +403,8 @@ static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
 	}
 }
 
+static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func);
+
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -421,6 +423,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 */
 	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
 		const struct cpuid_reg cpuid = reverse_cpuid[i];
+		struct kvm_cpuid_entry2 emulated;
 
 		if (!cpuid.function)
 			continue;
@@ -429,7 +432,16 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		if (!entry)
 			continue;
 
-		vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(entry, cpuid.reg);
+		cpuid_func_emulated(&emulated, cpuid.function);
+
+		/*
+		 * A vCPU has a feature if it's supported by KVM and is enabled
+		 * in guest CPUID.  Note, this includes features that are
+		 * supported by KVM but aren't advertised to userspace!
+		 */
+		vcpu->arch.cpu_caps[i] = kvm_cpu_caps[i] | kvm_vmm_cpu_caps[i] |
+					 cpuid_get_reg_unsafe(&emulated, cpuid.reg);
+		vcpu->arch.cpu_caps[i] &= cpuid_get_reg_unsafe(entry, cpuid.reg);
 	}
 
 	kvm_update_cpuid_runtime(vcpu);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index c2c2b8aa347b..60da304db4e4 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -284,13 +284,6 @@ static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
 		guest_cpu_cap_clear(vcpu, x86_feature);
 }
 
-static __always_inline void guest_cpu_cap_constrain(struct kvm_vcpu *vcpu,
-						    unsigned int x86_feature)
-{
-	if (!kvm_cpu_cap_has(x86_feature))
-		guest_cpu_cap_clear(vcpu, x86_feature);
-}
-
 static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1bc431a7e862..946a75771946 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4344,10 +4344,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			     boot_cpu_has(X86_FEATURE_XSAVES) &&
 			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
 
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_NRIPS);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_TSCRATEMSR);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LBRV);
-
 	/*
 	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
 	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
@@ -4355,13 +4351,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 */
 	if (guest_cpuid_is_intel(vcpu))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
-	else
-		guest_cpu_cap_constrain(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
-
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PAUSEFILTER);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PFTHRESHOLD);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VGIF);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VNMI);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d873386e1473..653c4b68ec7f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7836,15 +7836,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
 	 * set if and only if XSAVE is supported.
 	 */
-	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
-		guest_cpu_cap_constrain(vcpu, X86_FEATURE_XSAVES);
-	else
+	if (!boot_cpu_has(X86_FEATURE_XSAVE) ||
+	    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
 
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VMX);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LAM);
-
 	vmx_setup_uret_msrs(vmx);
 
 	if (cpu_has_secondary_exec_ctrls())
-- 
2.45.0.215.g3402c0e53f-goog


