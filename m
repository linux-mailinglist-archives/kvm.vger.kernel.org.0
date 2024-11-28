Return-Path: <kvm+bounces-32695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B82909DB11F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D9631646BB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD29A1CACC0;
	Thu, 28 Nov 2024 01:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zzjPRRjp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5361C9EA5
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757750; cv=none; b=DVDMKi6c8bCCxzgrM5UUB5ZYPIUtRXfoblbwwJqQFHBVwFtLNGaToY8giBeShqcB+TMsSoWfi2PvwVQ9jPEvL74mvNG1VJlS9QcwuyC7A6dNdyT2Dp3eW9uxLovUn6QaNb4vMqI56p/OMB5N2gequaQDIMv+XBfuk0Y9wn2Jrhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757750; c=relaxed/simple;
	bh=AhzkXtmCCM2uzNkbc1wKogSBqvYhkXQzLU3RFLMop8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E73ouNK4J0w3JtLCyDBsA1r+290M1oHR4Eq/BS5rCREoM8c9+lYoKpqNHRO6VStrm63706Guu7uLrRyCm33B6dKCT7hijuOfX3wDxJTpJKuvvHjBvTNBshWM6FYCMzEF5qXprG3v0Wh6ZNgpJLgNVVzF/m/C5EvCpEeLZte/nEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zzjPRRjp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea3c9178f6so360558a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757749; x=1733362549; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oX4zoA92uX/TiwHEJXa6fKLIdOdEnfDXoZc1BynGc94=;
        b=zzjPRRjpb61nqCznY61COVXXsVjcVN59XMGGDgbHDtP3OeTLyw0KbV9DLWUZNvIAtc
         PxYWagO3mSXqeWxs/8ODv3eUkpI35pzX3EyXg/9nV53WNSdMNXFMzm3POy4VmnGcMN6U
         TU0FtsmRV9Tn6aUxOoaPomdRblcTaDsKbSRENMdKNSPnPuppw1cyR3zBU0Ff7kS41jl8
         4wLGwcGVH1iWFYxW4Kmitj6/yYDVDyBpb3BabwQ9IYknaUbGRt89dfCvCUQAW6RZG09T
         rNVY8fiq/7ZJvGertMVxHM9d6A/BfsvblnOh5W2VpyBT9h+veUgQ4G6pAIrA0v7DwcW9
         qxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757749; x=1733362549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oX4zoA92uX/TiwHEJXa6fKLIdOdEnfDXoZc1BynGc94=;
        b=j03KWPs4ygeJS1kwVeDIpYE/hu05t+ri9GBDW5ahRtuOMr+cJGqbrJEEVtYcwijKFW
         XIovdWDUd1SpJbGIMkY/8vixeX61RFZ/hyQGZ4JYo3cDQbXrj68/qtTXFIdjWlCRSvWD
         aixFIrWmRjfiGPoIu7Tc1TNf7VqnskJttLMFI8RA+Ot4NWYtCnKk9GS2DHTVe3XNMnbl
         s40KgbFg6HJmOQvLOyl70Oekr4FTuSJd6LqI0NLqAE6dzZHwvZXmkB4dOa5SrQnKHsNN
         5zA4MBDQbaLRtRki3H4BTPN4M3Pjn0lLq7pwWqnBKwR44x9+NpdMTqd75zgYAx08pw7H
         lHng==
X-Gm-Message-State: AOJu0YyH5jNDwJRAFzoPBzCA4YlYXY2mJuTeTyB9bpBa5q2MjmQTdcU5
	ZPUqtnNATX3vwDHkTn1wpmN4DFqwV5wNBg8ndqGmURolrf5mXsUP6Gyxz9vu22L2I32YSkVTvj2
	0Yg==
X-Google-Smtp-Source: AGHT+IHqiBW7ylFioQH9r/0FDeS4VWt48HcfPZ5KbrnqgDIhirizajDMmTT+yUaR52RQ2Ssu5wGSCgPDzk0=
X-Received: from pjbqn15.prod.google.com ([2002:a17:90b:3d4f:b0:2e0:aba3:662a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c04:b0:2ea:3a13:4916
 with SMTP id 98e67ed59e1d1-2ee08e9980emr6733033a91.6.1732757748712; Wed, 27
 Nov 2024 17:35:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:11 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-45-seanjc@google.com>
Subject: [PATCH v3 44/57] KVM: x86: Initialize guest cpu_caps based on KVM support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
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
 arch/x86/kvm/cpuid.c   | 15 ++++++++++++++-
 arch/x86/kvm/cpuid.h   |  7 -------
 arch/x86/kvm/svm/svm.c | 11 -----------
 arch/x86/kvm/vmx/vmx.c |  9 ++-------
 4 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c63492f119d..8015d6b52a69 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -355,6 +355,9 @@ static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
 	}
 }
 
+static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func,
+			       bool include_partially_emulated);
+
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -373,6 +376,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 */
 	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
 		const struct cpuid_reg cpuid = reverse_cpuid[i];
+		struct kvm_cpuid_entry2 emulated;
 
 		if (!cpuid.function)
 			continue;
@@ -381,7 +385,16 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		if (!entry)
 			continue;
 
-		vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(entry, cpuid.reg);
+		cpuid_func_emulated(&emulated, cpuid.function, true);
+
+		/*
+		 * A vCPU has a feature if it's supported by KVM and is enabled
+		 * in guest CPUID.  Note, this includes features that are
+		 * supported by KVM but aren't advertised to userspace!
+		 */
+		vcpu->arch.cpu_caps[i] = kvm_cpu_caps[i] |
+					 cpuid_get_reg_unsafe(&emulated, cpuid.reg);
+		vcpu->arch.cpu_caps[i] &= cpuid_get_reg_unsafe(entry, cpuid.reg);
 	}
 
 	kvm_update_cpuid_runtime(vcpu);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8c9d6be8cb58..27da0964355c 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -263,13 +263,6 @@ static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
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
index 3b94cb6c2b7a..0045fe474023 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4406,10 +4406,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			     boot_cpu_has(X86_FEATURE_XSAVES) &&
 			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
 
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_NRIPS);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_TSCRATEMSR);
-	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LBRV);
-
 	/*
 	 * Intercept VMLOAD if the vCPU model is Intel in order to emulate that
 	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
@@ -4417,13 +4413,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 */
 	if (guest_cpuid_is_intel_compatible(vcpu))
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
index 8b95ba323a17..a7c2c36f2a4f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7828,15 +7828,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
2.47.0.338.g60cca15819-goog


