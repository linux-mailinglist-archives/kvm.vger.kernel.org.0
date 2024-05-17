Return-Path: <kvm+bounces-17682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE90A8C8B89
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1CEC1C210B4
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B711A154BE7;
	Fri, 17 May 2024 17:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DMXK/W9X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F82153BF0
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967642; cv=none; b=AdJZroRXu+IMcklL+rR3A1lN4+LZ69dAFksB8O7C4beDZz4phIqwSOcl1TF6NMWmADMTS6fenM6ZJCWb8hxkin1xlodt5pxhPLRNgb6tlq4mfAsT/dsOYiupHSR3ftm1KsEznNz5bRYVfWAiGmarY/HouUdQuChqsSp76hNUOiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967642; c=relaxed/simple;
	bh=A5FRGvpuzsyeP14Uaje+klYFBxWUtYQam8SwUwXc6VI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jsp+XCgzrWWcD4nPNK9+718sMi04thGwNuM3tJDSpUyQZhsnEFHEvXa15BS4v50xhIE1QhTWZJ/2WEt/QXhC0CKdgVmaZgEDbHSQqDOdISaAKqMsSmcayErjm7AbGrXdrvOytJkP0O42aaCHo6LMBdduFOgbaWb5CAngyS2km3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DMXK/W9X; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b33fb417f3so7755068a91.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967641; x=1716572441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ivnAB20VOSqBPI9o5zTTF/rU6QHfDJXFqsEL37jROe0=;
        b=DMXK/W9Xqx/I/f/L+F/y4FZJ2kOS54GVTdVjlxpiVkoWZG5PhCUU76707T2zKh4M6S
         gdRC+rZb0Els/+jnsyUYz324ajcWpPku8RAlg/y6qX9eg0Z55oggxcdKnpFVGd9wqwb0
         BPGNkMeU/45GiXnEOprZaluf/2PzbChhvnCRvSPyXJImJ1XC+cSVvs4opg4MQAHclEqw
         xi9YY06aXrP4C+2CK9E0O7DxbTRXXGHP13lWzoTcxTHVijgZk3TW+cL6Ndu8PUN8F6mF
         zPStlxXNBa/Gf5WjIUuRQ1KWt/kRP3cRz5DmDtXEMT88qwBNZw3HTJQ0vVUCBF+xVlaU
         eOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967641; x=1716572441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ivnAB20VOSqBPI9o5zTTF/rU6QHfDJXFqsEL37jROe0=;
        b=ma+y8vmHAY+vRCN6rKrs2mFlwVa8OYKXb+FieJMThJNo4nskJB/X7xDfBBbA0SDjcV
         k5vOIQwgHXTVXZND3MYLcTidpZBQ42tPznFqzsP8qq42sGXanUbyMsMo4lRlybWZPTVf
         eB5hBdtxgawYmVl6XeWGUlkmUAc0DhjCRzh63l37aCcNWvvClG4sKKJHTT+OT7ihYgqx
         bXLDtYhGKERLx9TuR31iQmV2GpDbMMNaarSx+L53Uo5MAN/MPv+n3Cpbo5DArRrAuxgG
         5zwu+A99ShwtnEX0Fp7lHmSm9VxiQzhOdnVIHcMGRpqnXzMFuHbEKDSsJZsIa+nsX9HO
         CPCQ==
X-Gm-Message-State: AOJu0YxAtZDY58eSP5CnBSa1pWAi38cJgOTdyPsvs6PYptEh4VUyPiIF
	NqgOIbE9Yj0ApkHkl/1zsapo2UP6KITxTI4fczNwfP5IqPZvm3XwWZV/r3nY7S02nHFJM6vSQ5G
	0BQ==
X-Google-Smtp-Source: AGHT+IFtPMSRH1z0nXpStytibhCtqzIq5W7oStYR9o3jNFwgC0xDIqSB9xn0qUngmwfTyG9A36bt74k+s30=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e00d:b0:2b4:346f:9a75 with SMTP id
 98e67ed59e1d1-2b6cceb662fmr60945a91.6.1715967640639; Fri, 17 May 2024
 10:40:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:07 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-31-seanjc@google.com>
Subject: [PATCH v2 30/49] KVM: x86: Always operate on kvm_vcpu data in cpuid_entry2_find()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM sets vcpu->arch.cpuid_{entries,nent} before processing the
incoming CPUID entries during KVM_SET_CPUID{,2}, drop the @entries and
@nent params from cpuid_entry2_find() and unconditionally operate on the
vCPU state.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 62 +++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7290f91c422c..0526f25a7c80 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -124,8 +124,8 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
  */
 #define KVM_CPUID_INDEX_NOT_SIGNIFICANT -1ull
 
-static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
-	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
+static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
+						  u32 function, u64 index)
 {
 	struct kvm_cpuid_entry2 *e;
 	int i;
@@ -142,8 +142,8 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	 */
 	lockdep_assert_irqs_enabled();
 
-	for (i = 0; i < nent; i++) {
-		e = &entries[i];
+	for (i = 0; i < vcpu->arch.cpuid_nent; i++) {
+		e = &vcpu->arch.cpuid_entries[i];
 
 		if (e->function != function)
 			continue;
@@ -177,8 +177,6 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *entries = vcpu->arch.cpuid_entries;
-	int nent = vcpu->arch.cpuid_nent;
 	struct kvm_cpuid_entry2 *best;
 	u64 xfeatures;
 
@@ -186,7 +184,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
-	best = cpuid_entry2_find(entries, nent, 0x80000008,
+	best = cpuid_entry2_find(vcpu, 0x80000008,
 				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
 		int vaddr_bits = (best->eax & 0xff00) >> 8;
@@ -199,7 +197,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * Exposing dynamic xfeatures to the guest requires additional
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
 	 */
-	best = cpuid_entry2_find(entries, nent, 0xd, 0);
+	best = cpuid_entry2_find(vcpu, 0xd, 0);
 	if (!best)
 		return 0;
 
@@ -234,15 +232,15 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	return 0;
 }
 
-static struct kvm_hypervisor_cpuid __kvm_get_hypervisor_cpuid(struct kvm_cpuid_entry2 *entries,
-							      int nent, const char *sig)
+static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
+							    const char *sig)
 {
 	struct kvm_hypervisor_cpuid cpuid = {};
 	struct kvm_cpuid_entry2 *entry;
 	u32 base;
 
 	for_each_possible_hypervisor_cpuid_base(base) {
-		entry = cpuid_entry2_find(entries, nent, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+		entry = cpuid_entry2_find(vcpu, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 
 		if (entry) {
 			u32 signature[3];
@@ -262,13 +260,6 @@ static struct kvm_hypervisor_cpuid __kvm_get_hypervisor_cpuid(struct kvm_cpuid_e
 	return cpuid;
 }
 
-static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
-							    const char *sig)
-{
-	return __kvm_get_hypervisor_cpuid(vcpu->arch.cpuid_entries,
-					  vcpu->arch.cpuid_nent, sig);
-}
-
 static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
 {
 	struct kvm_hypervisor_cpuid kvm_cpuid;
@@ -292,23 +283,22 @@ static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
  * Calculate guest's supported XCR0 taking into account guest CPUID data and
  * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
  */
-static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
+static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = cpuid_entry2_find(entries, nent, 0xd, 0);
+	best = cpuid_entry2_find(vcpu, 0xd, 0);
 	if (!best)
 		return 0;
 
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
-static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
-				       int nent)
+void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	best = cpuid_entry2_find(vcpu, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -319,43 +309,36 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	best = cpuid_entry2_find(entries, nent, 7, 0);
+	best = cpuid_entry2_find(vcpu, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-	best = cpuid_entry2_find(entries, nent, 0xD, 0);
+	best = cpuid_entry2_find(vcpu, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
-	best = cpuid_entry2_find(entries, nent, 0xD, 1);
+	best = cpuid_entry2_find(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+		best = cpuid_entry2_find(vcpu, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 }
-
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
-{
-	__kvm_update_cpuid_runtime(vcpu, vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
-}
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_KVM_HYPERV
-	struct kvm_cpuid_entry2 *entries = vcpu->arch.cpuid_entries;
-	int nent = vcpu->arch.cpuid_nent;
 	struct kvm_cpuid_entry2 *entry;
 
-	entry = cpuid_entry2_find(entries, nent, HYPERV_CPUID_INTERFACE,
+	entry = cpuid_entry2_find(vcpu, HYPERV_CPUID_INTERFACE,
 				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
 #else
@@ -401,8 +384,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	vcpu->arch.guest_supported_xcr0 =
-		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
 
 	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
 
@@ -1532,16 +1514,14 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index)
 {
-	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
-				 function, index);
+	return cpuid_entry2_find(vcpu, function, index);
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
 
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function)
 {
-	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
-				 function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
-- 
2.45.0.215.g3402c0e53f-goog


