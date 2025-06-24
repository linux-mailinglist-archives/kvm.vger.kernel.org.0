Return-Path: <kvm+bounces-50578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 012CCAE719D
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C97193A8187
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D84725A2A3;
	Tue, 24 Jun 2025 21:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qoxyMshO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1546A487BF
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 21:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750800931; cv=none; b=lcgSr+m2tetj6wBqbwJ0Wv8QjzBFvyMeFwnZ5922zbxdzbjx3PL1pIrvUtIu9wHzLpmtPhUts/Uz+uwUpBQpazBHmcEH/yAZBfWZOIUd/YwX26A7/uEZ40of7+eUCJnp0sbZLgXkOw+tlOUi5uLTH537jNP1QZbHZsJdn0ZckkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750800931; c=relaxed/simple;
	bh=DWlWA/JE8g4pKQk7hfbZ/bulSCCdERWfSO6Gs4/t7LE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mGq0NQvfILa28X7+A1ns3hppuvgVpVFrzbAmKp4coiDlaYox3WHhCyAjfw0A9O/pDsUf+jMot+5DF1guV0HdF8tNXA+GmaUOMZISjsPrOfl6xtSwIRTMggTG9O89DK7XqYDxD3878600UKO0J8ofQwUDh5IheAHD8m4FjLzYDoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qoxyMshO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31366819969so859646a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750800929; x=1751405729; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ysz7xzWYPbJ2rojkQKjld0vXtQ8QGdxQ4Q0JRZ61Mg=;
        b=qoxyMshOwpERTs2tILp7Tej01R4AbprcwqK1FoHcoY0Gj116piuccYl/+SVMAQSBxB
         dTWg7Ze9YviWFqbga9X5r2fReaBzX/EwvC5kldAZp+j6uOhZmxRJtXv72S/ndkN/cqSt
         4oo3c03os7LKpI4RFWcJlME4x24ADtS3iT6uKH1Zwaudb72udzOHwZX4qehijuwpYIZp
         Mg+AwcMv9mG4WcSY1HOTZIgCVR1o9L8Ffq4ctXbBf/+y5SXxjuqGZ6mcl15u4zmkpQtU
         jpn2n1h8br+DqwwatSe7jXV6ttx9la9xviVfkRCEMFCwVJai7tRkjyHbZKtSjBBKlCIE
         Xi0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750800929; x=1751405729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ysz7xzWYPbJ2rojkQKjld0vXtQ8QGdxQ4Q0JRZ61Mg=;
        b=qwnk/cdxyYhDc+LsvjO8WdcccttdUAth6QE2GfhvF6vt9djv5zGNU/pFqKEU81Egiw
         I7iAzQPOCcKLATKlfFcdNAt8kSHWCzDeL5qvq2X0IN7KJgXMtVy1tRjmIsCiinqfwKnX
         Ch6sQZH0KKXNaSt67JvERJz8zqTTRoqqnCnB8kq/A6dvMyJ24Tvkn89ljxU4QJ8ICYAs
         Mcyt3DF/8vogqUXwH15p1zP1g8cqV/jQ9ftciXZblldHsXn11xfXziW/dmFXE3Yz3N70
         o1NNZVToURAj6a6I4AYAIsCiJcXDDwtDnjdDt62F9h95iaitgIB4YcdHgEhiUW0ddhyt
         Ev7A==
X-Forwarded-Encrypted: i=1; AJvYcCU+w/91/YroDa4Qf6LpejGd4jmEazBU6Ih7vYPzJU3p7YgCQisBD9gebeS5h30jOuMmBgY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2rIpobLjIGQyO9qaITVdcQBuX/Lx7w0/5N1Ojn/d8eLBZPXRf
	FdX0gmUH7oBikve6yzPvyjOxZpw1M69nlqT8guMOp+1sTKMD9/fJYbYHeGyOKchEI3yt8IlXDzj
	Pj0ndEg==
X-Google-Smtp-Source: AGHT+IHa9B5m8ThSy/pTSRc8TcQm9rTgS6N+TmrPJ1HHMBMkEVG7l2n0g9L4pqVowM6J+0t4K1z0V+x3kPA=
X-Received: from pjuj6.prod.google.com ([2002:a17:90a:d006:b0:311:4201:4021])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5206:b0:313:27e5:7ff1
 with SMTP id 98e67ed59e1d1-315f25e7231mr577433a91.1.1750800929530; Tue, 24
 Jun 2025 14:35:29 -0700 (PDT)
Date: Tue, 24 Jun 2025 14:35:27 -0700
In-Reply-To: <20250530185239.2335185-3-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-3-jmattson@google.com>
Message-ID: <aFsaH97Qxn7nUA86@google.com>
Subject: Re: [PATCH v4 2/3] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 30, 2025, Jim Mattson wrote:
> Allow a guest to read the physical IA32_APERF and IA32_MPERF MSRs
> without interception.
> 
> The IA32_APERF and IA32_MPERF MSRs are not virtualized. Writes are not
> handled at all. The MSR values are not zeroed on vCPU creation, saved
> on suspend, or restored on resume. No accommodation is made for
> processor migration or for sharing a logical processor with other
> tasks. No adjustments are made for non-unit TSC multipliers. The MSRs
> do not account for time the same way as the comparable PMU events,
> whether the PMU is virtualized by the traditional emulation method or
> the new mediated pass-through approach.
> 
> Nonetheless, in a properly constrained environment, this capability
> can be combined with a guest CPUID table that advertises support for
> CPUID.6:ECX.APERFMPERF[bit 0] to induce a Linux guest to report the
> effective physical CPU frequency in /proc/cpuinfo. Moreover, there is
> no performance cost for this capability.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c         |  7 +++++++
>  arch/x86/kvm/svm/svm.h         |  2 +-
>  arch/x86/kvm/vmx/vmx.c         |  6 ++++++
>  arch/x86/kvm/vmx/vmx.h         |  2 +-
>  arch/x86/kvm/x86.c             |  8 +++++++-
>  arch/x86/kvm/x86.h             |  5 +++++
>  include/uapi/linux/kvm.h       |  1 +
>  tools/include/uapi/linux/kvm.h |  1 +
>  9 files changed, 52 insertions(+), 3 deletions(-)

This needs to be rebased on top of the MSR interception rework, which I've now
pushed to kvm-x86 next.  Luckily, it's quite painless.  Compile tested only at
this point (about to throw it onto metal).

I'd be happy to post a v5 on your behalf (pending your thoughts on my feedback
to patch 1), unless you want the honors.  The fixup is a wee bit more than I'm
comfortable doing on-the-fly.

---
 Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c         |  5 +++++
 arch/x86/kvm/vmx/vmx.c         |  4 ++++
 arch/x86/kvm/x86.c             |  6 +++++-
 arch/x86/kvm/x86.h             |  5 +++++
 include/uapi/linux/kvm.h       |  1 +
 tools/include/uapi/linux/kvm.h |  1 +
 7 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0d961436d0f..13a752b1200f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7844,6 +7844,7 @@ Valid bits in args[0] are::
   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
+  #define KVM_X86_DISABLE_EXITS_APERFMPERF       (1 << 4)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
@@ -7854,6 +7855,28 @@ all such vmexits.
 
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
+Virtualizing the ``IA32_APERF`` and ``IA32_MPERF`` MSRs requires more
+than just disabling APERF/MPERF exits. While both Intel and AMD
+document strict usage conditions for these MSRs--emphasizing that only
+the ratio of their deltas over a time interval (T0 to T1) is
+architecturally defined--simply passing through the MSRs can still
+produce an incorrect ratio.
+
+This erroneous ratio can occur if, between T0 and T1:
+
+1. The vCPU thread migrates between logical processors.
+2. Live migration or suspend/resume operations take place.
+3. Another task shares the vCPU's logical processor.
+4. C-states lower thean C0 are emulated (e.g., via HLT interception).
+5. The guest TSC frequency doesn't match the host TSC frequency.
+
+Due to these complexities, KVM does not automatically associate this
+passthrough capability with the guest CPUID bit,
+``CPUID.6:ECX.APERFMPERF[bit 0]``. Userspace VMMs that deem this
+mechanism adequate for virtualizing the ``IA32_APERF`` and
+``IA32_MPERF`` MSRs must set the guest CPUID bit explicitly.
+
+
 7.14 KVM_CAP_S390_HPAGE_1M
 --------------------------
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce85f4d6f686..079c0a0b0eaa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -854,6 +854,11 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW,
 				  guest_cpuid_is_intel_compatible(vcpu));
 
+	if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
+	}
+
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_recalc_msr_intercepts(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8c16a3aff896..723a22be2514 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4099,6 +4099,10 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
+	if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
+	}
 
 	/* PT MSRs can be passed through iff PT is exposed to the guest. */
 	if (vmx_pt_mode_is_host_guest())
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 56569ac2e9a4..75c0f52d3c44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4580,6 +4580,9 @@ static u64 kvm_get_allowed_disable_exits(void)
 {
 	u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
 
+	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+		r |= KVM_X86_DISABLE_EXITS_APERFMPERF;
+
 	if (!mitigate_smt_rsb) {
 		r |= KVM_X86_DISABLE_EXITS_HLT |
 			KVM_X86_DISABLE_EXITS_CSTATE;
@@ -6478,7 +6481,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 
 		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
 		    cpu_smt_possible() &&
-		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+		    (cap->args[0] & ~(KVM_X86_DISABLE_EXITS_PAUSE |
+				      KVM_X86_DISABLE_EXITS_APERFMPERF)))
 			pr_warn_once(SMT_RSB_MSG);
 
 		kvm_disable_exits(kvm, cap->args[0]);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 31ae58b765f3..bcfd9b719ada 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -546,6 +546,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_CSTATE;
 }
 
+static inline bool kvm_aperfmperf_in_guest(struct kvm *kvm)
+{
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_APERFMPERF;
+}
+
 static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
 {
 	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7a4c35ff03fe..aeb2ca10b190 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -644,6 +644,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index d00b85cb168c..7415a3863891 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -618,6 +618,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
--

