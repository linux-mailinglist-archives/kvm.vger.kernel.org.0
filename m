Return-Path: <kvm+bounces-17689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B9FA8C8B97
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ED611C215AE
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B92315688F;
	Fri, 17 May 2024 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wkxz8MPB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFA415574F
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967655; cv=none; b=RwoDxFWcODjt9njcZerLtWpitFUqj9HYYtQw45/2mRgaHaKUr1Vof7EFjBtniuaFhvPsR+hDhySChYc9j8kc8yf/2uSpLRQEOGI9S5OwVKkNcLqhAuzp9OWhyE8GJf94boE8X0wVw3U411t0B6Y7w/JV6e5zAk3Nu+LiPbBuX2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967655; c=relaxed/simple;
	bh=bGgf+Xy8iNYJGOACxP0wPPLQPxHi5ZfUIWYv1ZbupZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Du/btSApHuaUyqNb8XPurVOI64M2Mjh3ysFyCNdglPmqbUcFlN0IG5k0Oi8MmFfl3PzbsXmjbpX9OVwhtxSjI+kBnqWCcl9a9jK/32RTjML+Z3N6dbOoOj7qsKW82momhKhyYk+RVZJ03uu4ezcr0qh79oZQS396dR+dT0R+RCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wkxz8MPB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-65cc1422681so1567542a12.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967653; x=1716572453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=faa0ex8J36/VI9iCCBnU+WDgLJ2hfOfCLrrAR+qNAQs=;
        b=Wkxz8MPBRVSNYJzyFF4FStUeSV/nrlSOVI7qX4pDl2TLLRmjXJYtnMF5rM/c5M5XXr
         z4xPMH+joHGOmsMyMIFHRxvYjTUGkVWWVGwIZkO1PkZRnJVgQFCAA0DCqYSOnmPawvSB
         nFtbXEBwcmqb6WLW/73KPUj8dtGAv16/MDyBE/3xlvD+KI2OelwjwaX5K0ox6Cvq2SLc
         CqJmUq6pEfpbLrOLpCY4p4Y0t//d/bHvcUwAw0VjqVn+HechHD/+YmOs6cBg4B7fIvGU
         sEkT5eC77WT+T1CEtjzNydplG98nKxkhgQmBpqhzqU/2puqTM6e4l+dv+v005I1gfkd0
         OO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967653; x=1716572453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=faa0ex8J36/VI9iCCBnU+WDgLJ2hfOfCLrrAR+qNAQs=;
        b=DrkAY1PMRQGhFLb/9jktCjQsp4/T/WmckXNkvFOI5wiSMXS63uQnYxsNwPHrcHRt4+
         FzFiOmbalayDbAaJUs0USYHxAN0CTdsEIa64KIjM7wnQq8SvqibKctggPwfA83oec29d
         GxMcDUU5z4Q1GtjvbWLt7TZlRbc5dvzgILcGq5g1Q/B0MLQJXi5wlkyMwEDMazOC+fAk
         FsKv5Yk6/vNRd804ihTnALj///pQDBurJQzZtSd2NFnHbM5l72t/N5n4DYm7GvrcFj8R
         bfzw0B13YKAWI6Czrtjy1vlcoPnmw84GI0StCo69uuQ5r7o+dmJ0m808ZX2Nr5IBBZax
         uF9g==
X-Gm-Message-State: AOJu0YztU5JlBXYPWuQBhicYjurPKONW1Vs9g4RKqFQuNqHp/lgUiNhV
	tIleMmLxfSz59P3Z4d8CM+UYEXOdRCbKNya0sXHVKkzTKQ29wtDsMWjVNAsKF4oHWHB+Sp0Ge+e
	9gA==
X-Google-Smtp-Source: AGHT+IE7UMWWzKOfobS1L64VsofzXSvLI+CHSvOl5ah4GH46niZNhi/NeVUc+YfsKzIx8VRPRBO+pSUJDmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:485:b0:65d:326a:73f4 with SMTP id
 41be03b00d2f7-65d326a7483mr11608a12.5.1715967653506; Fri, 17 May 2024
 10:40:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:14 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-38-seanjc@google.com>
Subject: [PATCH v2 37/49] KVM: x86: Replace guts of "governed" features with
 comprehensive cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 45 +++++++++++++++++++++------------
 arch/x86/kvm/cpuid.c            | 14 +++++++---
 arch/x86/kvm/cpuid.h            | 12 ++++-----
 arch/x86/kvm/reverse_cpuid.h    | 16 ------------
 4 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3003e99155e7..8840d21ee0b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -743,6 +743,22 @@ struct kvm_queued_exception {
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
+	NR_KVM_CPU_CAPS,
+
+	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -861,23 +877,20 @@ struct kvm_vcpu_arch {
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
index 286abefc93d5..89c506cf649b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -387,9 +387,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *best;
 	bool allow_gbpages;
 
-	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
-	bitmap_zero(vcpu->arch.governed_features.enabled,
-		    KVM_MAX_NR_GOVERNED_FEATURES);
+	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
 
 	kvm_update_cpuid_runtime(vcpu);
 
@@ -473,6 +471,7 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
+	u32 vcpu_caps[NR_KVM_CPU_CAPS];
 	int r;
 
 	/*
@@ -480,10 +479,18 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
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
@@ -527,6 +534,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	return 0;
 
 err:
+	memcpy(vcpu->arch.cpu_caps, vcpu_caps, sizeof(vcpu_caps));
 	swap(vcpu->arch.cpuid_entries, e2);
 	swap(vcpu->arch.cpuid_nent, nent);
 	return r;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index e021681f34ac..ad0168d3aec5 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -259,10 +259,10 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
 static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {
-	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	__set_bit(kvm_governed_feature_index(x86_feature),
-		  vcpu->arch.governed_features.enabled);
+	reverse_cpuid_check(x86_leaf);
+	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
 static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
@@ -275,10 +275,10 @@ static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
 static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {
-	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	return test_bit(kvm_governed_feature_index(x86_feature),
-			vcpu->arch.governed_features.enabled);
+	reverse_cpuid_check(x86_leaf);
+	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
 static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 245f71c16272..63d5735fbc8a 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -6,22 +6,6 @@
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
-	NR_KVM_CPU_CAPS,
-
-	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
-};
-
 /*
  * Define a KVM-only feature flag.
  *
-- 
2.45.0.215.g3402c0e53f-goog


