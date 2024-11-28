Return-Path: <kvm+bounces-32691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEAF39DB117
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F21AB2674A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082401C4A1B;
	Thu, 28 Nov 2024 01:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YtHBAkpo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65208139566
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757744; cv=none; b=Dts944/pcww+VQ3Au53HBbdUX1SVDEwBU4E7Qs0oiU7Y8bjGwrGPwAtnG7AKK/OUVjms9JmR+5gj2jU0QJlV2eKSRPrM+0GZ/DjhjXT5YlL7MJYVfYGthZ2k153ZxuTeb0Ccj2Wj8KnpNl1m6qJSKmkOC376t9XA/UX2kBeKIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757744; c=relaxed/simple;
	bh=7yVlsOTBLAkkQo4xOwkrBuGMo/VmEwmdVE8Il7w9k+c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g46F3N2ncGGARXTJJURxGhK1SowfXlraZDg7hvUbTo78gGWVRxN/qwXx0cZhEGgXNNQ/ndnEVhYGbk+l9EvYTUU1y2ygdiHY07yBOakBy9E8O/l4IrgmDoQuU/MQdgmgINvQBy4GQQ856cEM4hYQP1JYUevyCQdtgIMPZV0Xnu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YtHBAkpo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea5447561bso338378a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757741; x=1733362541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Nb7G2zzp6/3qSRphNpLLt0E1AVgfUo5XQwnH4lz1CDQ=;
        b=YtHBAkpoy2S2AkYhbKSWrmEk23vcNjrKuc0DPrdok6opNpicScycbt9KWywvQF9x6p
         poMnjsoCAxYoBko9lPT/ylpFVciIblu4Jxfhbu+xe/+hbQkzqdSAZz4ekS82APRV1yo6
         7pr0Xek36l0t4HMfXdHEN7ombom6ZqAEb77x99Zv/M6VjISUIBBU3NA4K4omUgWDOMIe
         1h92i8DRb+jzr5ZUKwuZmYuP7pg3xQWT9D16umDqvFSYXANSJ/L6jLx/94WKldx19MkC
         Zh+nZZ73E6A6Tu8dICDBxv58G7di4kCcDKhlQPICo9/6tt7jWkDATuY4GQnZLbnW5rkC
         Dmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757741; x=1733362541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nb7G2zzp6/3qSRphNpLLt0E1AVgfUo5XQwnH4lz1CDQ=;
        b=Iun0t5lMbrLDASN8qaKo9rELdHz4DT2C9i7N9rpPEu5iPPejIEuzhVXTP+lfA3h1Hb
         tyEyNM34Vd1AbSp+zAjcoYu3K6TUnJ/gEoYAlag0zmD5ddGpEVcf9jKEnlsis4YfAkeK
         LpZt5qUptCyo5HABLBDtM1gVdwERtwY9/vDYNdM7vyQIZAsK5ayxSdFKyc+09pCJwar1
         bA0LqyIgV7rqBW//58Eq1XcmRSsedAt6/9IQAHZGNBvq3QjAAQw1XlCmACddtFVfKjjb
         Yi9uyZABdIO6YKbkKEjyJ1c44rtVrYAJPAm/IhELOeaYuTlmsl9siKdzUnSPy/9TvEF4
         mQdQ==
X-Gm-Message-State: AOJu0Yyuuio7/7f3XFFauU4XsSYU2InAudeGsH1ycdkXIhMzPWL/d28d
	SF8R3wZTLBr8setXRaH1I1fTptfsgxqUW9gNzLSJ2GyZg+ZaKxJBIj4D2eV/0pLpz+az7LnGT4j
	LMQ==
X-Google-Smtp-Source: AGHT+IGSK7PbzdmQInzCnCBfifncNzfRI/Vyxv4K61WgkCjrM2hP/H3pxBFwKPVAVI2qFkB00qSkp7Lr8QU=
X-Received: from pjbpt13.prod.google.com ([2002:a17:90b:3d0d:b0:2ea:6b84:3849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e85:b0:2ea:b564:4b35
 with SMTP id 98e67ed59e1d1-2ee08eb2211mr6934255a91.9.1732757741638; Wed, 27
 Nov 2024 17:35:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:07 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-41-seanjc@google.com>
Subject: [PATCH v3 40/57] KVM: x86: Replace guts of "governed" features with
 comprehensive cpu_caps
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

Replace the internals of the governed features framework with a more
comprehensive "guest CPU capabilities" implementation, i.e. with a guest
version of kvm_cpu_caps.  Keep the skeleton of governed features around
for now as vmx_adjust_sec_exec_control() relies on detecting governed
features to do the right thing for XSAVES, and switching all guest feature
queries to guest_cpu_cap_has() requires subtle and non-trivial changes,
i.e. is best done as a standalone change.

Tracking *all* guest capabilities that KVM cares will allow excising the
poorly named "governed features" framework, and effectively optimizes all
KVM queries of guest capabilities, i.e. doesn't require making a
subjective decision as to whether or not a feature is worth "governing",
and doesn't require adding the code to do so.

The cost of tracking all features is currently 92 bytes per vCPU on 64-bit
kernels: 100 bytes for cpu_caps versus 8 bytes for governed_features.
That cost is well worth paying even if the only benefit was eliminating
the "governed features" terminology.  And practically speaking, the real
cost is zero unless those 92 bytes pushes the size of vcpu_vmx or vcpu_svm
into a new order-N allocation, and if that happens there are better ways
to reduce the footprint of kvm_vcpu_arch, e.g. making the PMU and/or MTRR
state separate allocations.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 46 +++++++++++++++++++++------------
 arch/x86/kvm/cpuid.c            | 14 +++++++---
 arch/x86/kvm/cpuid.h            | 10 +++----
 arch/x86/kvm/reverse_cpuid.h    | 17 ------------
 4 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f076df9f18be..81ce8cd5814a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -739,6 +739,23 @@ struct kvm_queued_exception {
 	bool has_payload;
 };
 
+/*
+ * Hardware-defined CPUID leafs that are either scattered by the kernel or are
+ * unknown to the kernel, but need to be directly used by KVM.  Note, these
+ * word values conflict with the kernel's "bug" caps, but KVM doesn't use those.
+ */
+enum kvm_only_cpuid_leafs {
+	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_7_1_EDX,
+	CPUID_8000_0007_EDX,
+	CPUID_8000_0022_EAX,
+	CPUID_7_2_EDX,
+	CPUID_24_0_EBX,
+	NR_KVM_CPU_CAPS,
+
+	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -857,23 +874,20 @@ struct kvm_vcpu_arch {
 	bool is_amd_compatible;
 
 	/*
-	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
-	 * when "struct kvm_vcpu_arch" is no longer defined in an
-	 * arch/x86/include/asm header.  The max is mostly arbitrary, i.e.
-	 * can be increased as necessary.
+	 * cpu_caps holds the effective guest capabilities, i.e. the features
+	 * the vCPU is allowed to use.  Typically, but not always, features can
+	 * be used by the guest if and only if both KVM and userspace want to
+	 * expose the feature to the guest.
+	 *
+	 * A common exception is for virtualization holes, i.e. when KVM can't
+	 * prevent the guest from using a feature, in which case the vCPU "has"
+	 * the feature regardless of what KVM or userspace desires.
+	 *
+	 * Note, features that don't require KVM involvement in any way are
+	 * NOT enforced/sanitized by KVM, i.e. are taken verbatim from the
+	 * guest CPUID provided by userspace.
 	 */
-#define KVM_MAX_NR_GOVERNED_FEATURES BITS_PER_LONG
-
-	/*
-	 * Track whether or not the guest is allowed to use features that are
-	 * governed by KVM, where "governed" means KVM needs to manage state
-	 * and/or explicitly enable the feature in hardware.  Typically, but
-	 * not always, governed features can be used by the guest if and only
-	 * if both KVM and userspace want to expose the feature to the guest.
-	 */
-	struct {
-		DECLARE_BITMAP(enabled, KVM_MAX_NR_GOVERNED_FEATURES);
-	} governed_features;
+	u32 cpu_caps[NR_KVM_CPU_CAPS];
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7b2fbb148661..f0721ad84a18 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -339,9 +339,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *best;
 	bool allow_gbpages;
 
-	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
-	bitmap_zero(vcpu->arch.governed_features.enabled,
-		    KVM_MAX_NR_GOVERNED_FEATURES);
+	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
 
 	kvm_update_cpuid_runtime(vcpu);
 
@@ -425,6 +423,7 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
+	u32 vcpu_caps[NR_KVM_CPU_CAPS];
 	int r;
 
 	/*
@@ -432,10 +431,18 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	 * order to massage the new entries, e.g. to account for dynamic bits
 	 * that KVM controls, without clobbering the current guest CPUID, which
 	 * KVM needs to preserve in order to unwind on failure.
+	 *
+	 * Similarly, save the vCPU's current cpu_caps so that the capabilities
+	 * can be updated alongside the CPUID entries when performing runtime
+	 * updates.  Full initialization is done if and only if the vCPU hasn't
+	 * run, i.e. only if userspace is potentially changing CPUID features.
 	 */
 	swap(vcpu->arch.cpuid_entries, e2);
 	swap(vcpu->arch.cpuid_nent, nent);
 
+	memcpy(vcpu_caps, vcpu->arch.cpu_caps, sizeof(vcpu_caps));
+	BUILD_BUG_ON(sizeof(vcpu_caps) != sizeof(vcpu->arch.cpu_caps));
+
 	/*
 	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
 	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
@@ -476,6 +483,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	return 0;
 
 err:
+	memcpy(vcpu->arch.cpu_caps, vcpu_caps, sizeof(vcpu_caps));
 	swap(vcpu->arch.cpuid_entries, e2);
 	swap(vcpu->arch.cpuid_nent, nent);
 	return r;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index e1b05da23cf2..0a9c3086539b 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -240,10 +240,9 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
 static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {
-	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	__set_bit(kvm_governed_feature_index(x86_feature),
-		  vcpu->arch.governed_features.enabled);
+	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
 static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
@@ -256,10 +255,9 @@ static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
 static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {
-	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	return test_bit(kvm_governed_feature_index(x86_feature),
-			vcpu->arch.governed_features.enabled);
+	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
 static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 1d2db9d529ff..fde0ae986003 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -6,23 +6,6 @@
 #include <asm/cpufeature.h>
 #include <asm/cpufeatures.h>
 
-/*
- * Hardware-defined CPUID leafs that are either scattered by the kernel or are
- * unknown to the kernel, but need to be directly used by KVM.  Note, these
- * word values conflict with the kernel's "bug" caps, but KVM doesn't use those.
- */
-enum kvm_only_cpuid_leafs {
-	CPUID_12_EAX	 = NCAPINTS,
-	CPUID_7_1_EDX,
-	CPUID_8000_0007_EDX,
-	CPUID_8000_0022_EAX,
-	CPUID_7_2_EDX,
-	CPUID_24_0_EBX,
-	NR_KVM_CPU_CAPS,
-
-	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
-};
-
 /*
  * Define a KVM-only feature flag.
  *
-- 
2.47.0.338.g60cca15819-goog


