Return-Path: <kvm+bounces-32692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCCBE9DB118
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D768A164310
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB01F1C5792;
	Thu, 28 Nov 2024 01:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1aPKCnRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032A51C1F2A
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757745; cv=none; b=hsuD3Ueb1/aG0hkwflmLy1jF4se8TKzSB/nQIZuJNDXMRWl60G/Il1TOYo/OoiRPT0ePMUI1a4J4dG1Y24lr+oaVw47Ao2DP2zcySGAE10n7upHqWTN1yD9q4bprnOr82Gz+omlzJQJlEEAV7tLNprRajjz/x5AJx2Rwyltewkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757745; c=relaxed/simple;
	bh=92keq9rYVnfI72Sl5mEjMVDS+yT2LY6IoXcHRK65XJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSuZd5MowOQFyWvsgNbUrXy8CsvEcDz62QixsBk/BTvx8+MvULMVhZFdvZrGN2lmBvZN5vl/qK6Cq2fS1obOBSXsdMuR/1ntyqL6L7nTI44RwlH4T+FAKFmdyHxPP0WhKU3u0FitsOwjyCE3oo38qL/4DWsNLJtsdVfDYxD6HjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1aPKCnRp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea5447561bso338392a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757743; x=1733362543; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u3faRSI22z3et+y5MURj5HjuZ7x9Q7bUTGIwT0EzhTI=;
        b=1aPKCnRp3J4tPis1iTU60GNjeMWJn7cpgLTLW5aklajNxzamX9F7php368JKHB/KS2
         eAVyulxc00vlyXXDtw5yUFuNsCRSr+IsuMKxs52yRR1rBYrz2S8hecFVIUs/kWwGcQO5
         isQJMZ0UTnpNGBu41/MmXGbewn+kz2lCsNVBCzGFHm+Lfl3IMU/fFruOvfaRyiwF/QK7
         u8O9KibRTx+adkFLxKi9CD2PXydw76qI74IvNrgsB7cgudXZue2RkKdgvcZFeUGdYNHZ
         lCSpVTlnsN153060UUZvJTM9cL/Xu7itmGfuhnAUB20TZD4ESMFq6TPWQ0nZqHgdlxzZ
         6iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757743; x=1733362543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u3faRSI22z3et+y5MURj5HjuZ7x9Q7bUTGIwT0EzhTI=;
        b=aU9A1T9kL7TIaYw7/JrThJeRvKFh6/hwecqI6OwYM4wccQ7sF+Xdz+IsWcHnh9kcsT
         urwYd0PSLhb6LRYPGHEWG4LwnWjrzMVkLDip87nvwr5FOpGi8PBdMQyNMy00uJrQjQYw
         AUorkeLZRMqSmoFG7MvkFURRKas4ksjwByr8fp1s9VuhyV+XnRwVDGseUNeRMc9Fh6Cq
         IYQ1fZoApyuuCXhLFtVOZUjBBDGLoImC2fNSIKSAX1eHOU1sirSVmad662sQo0HdkitA
         lcQtxiHFDxq/6Ub5lztkTNkXVCpWxRLgDMvRf6dKWjudl7TayaUJyR01V/HfEP9Jl/Bx
         RfIg==
X-Gm-Message-State: AOJu0Yx9WFbV6fgQV6wlif5q/JknhOlNIiLnl0jMX/IZNIJLhYQQ55y4
	A+MYKZe8W2AGnsvN9FyIpKbP6oMLZ7araJLzO6iWokO54Ahvn3tXyBOz8AdNW80FK13eSqGdE4p
	LZg==
X-Google-Smtp-Source: AGHT+IHkLD1IxGMjy6XNlloNCtxNSt5vSskTN6pRS/Udiozse6OwFa4oFe1yyMOUO29n6zTQXarZYRytAm8=
X-Received: from pjbnd10.prod.google.com ([2002:a17:90b:4cca:b0:2ea:8715:5c92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4a:b0:2ea:4578:46de
 with SMTP id 98e67ed59e1d1-2ee08ecf99emr6851103a91.20.1732757743531; Wed, 27
 Nov 2024 17:35:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:08 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-42-seanjc@google.com>
Subject: [PATCH v3 41/57] KVM: x86: Initialize guest cpu_caps based on guest CPUID
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

Initialize a vCPU's capabilities based on the guest CPUID provided by
userspace instead of simply zeroing the entire array.  This is the first
step toward using cpu_caps to query *all* CPUID-based guest capabilities,
i.e. will allow converting all usage of guest_cpuid_has() to
guest_cpu_cap_has().

Zeroing the array was the logical choice when using cpu_caps was opt-in,
e.g. "unsupported" was generally a safer default, and the whole point of
governed features is that KVM would need to check host and guest support,
i.e. making everything unsupported by default didn't require more code.

But requiring KVM to manually "enable" every CPUID-based feature in
cpu_caps would require an absurd amount of boilerplate code.

Follow existing CPUID/kvm_cpu_caps nomenclature where possible, e.g. for
the change() and clear() APIs.  Replace check_and_set() with constrain()
to try and capture that KVM is constraining userspace's desired guest
feature set based on KVM's capabilities.

This is intended to be gigantic nop, i.e. should not have any impact on
guest or KVM functionality.

This is also an intermediate step; a future commit will also incorporate
KVM support into the vCPU's cpu_caps before converting guest_cpuid_has()
to guest_cpu_cap_has().

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 46 ++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/cpuid.h   | 24 +++++++++++++++++++---
 arch/x86/kvm/svm/svm.c | 28 +++++++++++++------------
 arch/x86/kvm/vmx/vmx.c |  8 +++++---
 4 files changed, 85 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f0721ad84a18..803d89577e6f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -333,13 +333,56 @@ static bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
 	       is_guest_vendor_hygon(entry->ebx, entry->ecx, entry->edx);
 }
 
+/*
+ * This isn't truly "unsafe", but except for the cpu_caps initialization code,
+ * all register lookups should use __cpuid_entry_get_reg(), which provides
+ * compile-time validation of the input.
+ */
+static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
+{
+	switch (reg) {
+	case CPUID_EAX:
+		return entry->eax;
+	case CPUID_EBX:
+		return entry->ebx;
+	case CPUID_ECX:
+		return entry->ecx;
+	case CPUID_EDX:
+		return entry->edx;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
+	struct kvm_cpuid_entry2 *entry;
 	bool allow_gbpages;
+	int i;
 
 	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
+	BUILD_BUG_ON(ARRAY_SIZE(reverse_cpuid) != NR_KVM_CPU_CAPS);
+
+	/*
+	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
+	 * honor userspace's definition for features that don't require KVM or
+	 * hardware management/support (or that KVM simply doesn't care about).
+	 */
+	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
+		const struct cpuid_reg cpuid = reverse_cpuid[i];
+
+		if (!cpuid.function)
+			continue;
+
+		entry = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
+		if (!entry)
+			continue;
+
+		vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(entry, cpuid.reg);
+	}
 
 	kvm_update_cpuid_runtime(vcpu);
 
@@ -356,8 +399,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 */
 	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
 				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
-	if (allow_gbpages)
-		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
+	guest_cpu_cap_change(vcpu, X86_FEATURE_GBPAGES, allow_gbpages);
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 0a9c3086539b..8c9d6be8cb58 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -245,11 +245,29 @@ static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
 	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
-static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
-							unsigned int x86_feature)
+static __always_inline void guest_cpu_cap_clear(struct kvm_vcpu *vcpu,
+						unsigned int x86_feature)
 {
-	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
+
+	vcpu->arch.cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
+}
+
+static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
+						 unsigned int x86_feature,
+						 bool guest_has_cap)
+{
+	if (guest_has_cap)
 		guest_cpu_cap_set(vcpu, x86_feature);
+	else
+		guest_cpu_cap_clear(vcpu, x86_feature);
+}
+
+static __always_inline void guest_cpu_cap_constrain(struct kvm_vcpu *vcpu,
+						    unsigned int x86_feature)
+{
+	if (!kvm_cpu_cap_has(x86_feature))
+		guest_cpu_cap_clear(vcpu, x86_feature);
 }
 
 static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f96c62a9d2c2..3b94cb6c2b7a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4401,27 +4401,29 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
 	 * the guest read/write access to the host's XSS.
 	 */
-	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
-	    boot_cpu_has(X86_FEATURE_XSAVES) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
-		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
+	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
+			     boot_cpu_has(X86_FEATURE_XSAVE) &&
+			     boot_cpu_has(X86_FEATURE_XSAVES) &&
+			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
 
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_NRIPS);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_TSCRATEMSR);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LBRV);
 
 	/*
 	 * Intercept VMLOAD if the vCPU model is Intel in order to emulate that
 	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
 	 * SVM on Intel is bonkers and extremely unlikely to work).
 	 */
-	if (!guest_cpuid_is_intel_compatible(vcpu))
-		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
+	if (guest_cpuid_is_intel_compatible(vcpu))
+		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
+	else
+		guest_cpu_cap_constrain(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VGIF);
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VNMI);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PAUSEFILTER);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PFTHRESHOLD);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VGIF);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VNMI);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ccba522246c3..8b95ba323a17 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7830,10 +7830,12 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 */
 	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
-		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_XSAVES);
+		guest_cpu_cap_constrain(vcpu, X86_FEATURE_XSAVES);
+	else
+		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
 
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VMX);
-	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LAM);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VMX);
+	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LAM);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.47.0.338.g60cca15819-goog


