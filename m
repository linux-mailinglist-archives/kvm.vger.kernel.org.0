Return-Path: <kvm+bounces-17684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 223E88C8B8D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE1C228A334
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF98715530A;
	Fri, 17 May 2024 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZW+E+lH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EDB154C05
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967646; cv=none; b=Dkm45S0cvnsLI2pnW73VvH8c/cDcTEu+nDsSFCCFUhr4K/VRYq5ib/V4PvK4b9wb3t7hfjcoBz3P1v4Zz2ywy7dIb9h+8rU+CXR/PUsTTy1Q8vX0FjEgjO91vXPWShQDaTgXNOwqLMNnsB6VW0ghzEjB1sIoeihkgqURc+UFWbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967646; c=relaxed/simple;
	bh=6Dt+MxOGDC5wlIbKTzeRf27sPKU687dJMwO1PVr3xto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CHNhevkTFI/8L5VMbJziEwbXMZG/N0HrJryCGm5JTV70ETi1paLmmln7kAiiDsNi84T2TkmDcK/g86kIMg6Trus2i8Pf/aDTvbe6eIKZUhAPT8IPQBo/AJ3qFmzhIRNhMkfYo5cYBqzsxiY2F2cmKEfk2d9uE/vXsXGZ3u+98ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZW+E+lH; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f468ae6a5eso8057519b3a.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967644; x=1716572444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1NujG6NvUiX0lFKfo4m/02wMUR0vQQY9gkTAwGMIoMI=;
        b=AZW+E+lHN1PGWMa++vy2Z2wlMkH9w7mg/J7bzcXWUEBCgz3qsPyfQelc5a3BOCVb4m
         tB7DkM4xesWUhmQtqIUoledrjPmtX1AIge2ceStr4UgaZgu1vo1Gsxr96y9s7YLAnUmn
         dTYJAdzAYZQmkW3mrVOqv+zD706PAtQJ95dD9Y24IVZ75SkLu6BVBuiA8WXadBi6Je2N
         WqNBrbX1yiXaQ3UjpETHhfHxWPNEnnGecrVRy5iNjY/lZhi/D9mJlv0OwOF+r5+ab6ag
         +Ex0MxN/4gUamJajxpYjedteZmBPvPG4ogrwR5PFWlLAto/xR4D9rR851ZzKOCmQTsji
         +p8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967644; x=1716572444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1NujG6NvUiX0lFKfo4m/02wMUR0vQQY9gkTAwGMIoMI=;
        b=Zw6Wc4LnPt1u6NahFyzPUhcUUy2196Grlpq6Ofsm6SKeSNlU0uGyZc8lWqrLGPYWpM
         H7YmX7lxDBX2x1Rar5XrlU7sMP1ci4E+KXbDe2eDB29J8ewBICMftON0CinolDrGhvWe
         RP0BVIHrqWTQs0RdXlYuG/8UyFiAnXgzIGypLzqQ7RJLvDm5/pP7pH4akVEHQlfZZ9zU
         AAG71VwfcsOJC2jLvovZ2pdH2quepSbZ56DIB6zjdfFq0oD7vgZ4Ii043Pc3VZh8Laq7
         IeuHFt+dIMm9MIlPask4+LjDK6OYqsqa9fd7Y3qfbEqIEbu2YYURBawBomuqstVk3luT
         VeVQ==
X-Gm-Message-State: AOJu0YzKohxJl/VkesSO/iDGPqFQ0ObhVYoea8VU4g5OhQEr+FWEtTeR
	+FVDC6eXjI6DC7xIx5bwiI6LXVDVI/CogGVYkPVrAsOQy1yEJ65553jLVgas8uUU/SLqhYyDs7M
	ByQ==
X-Google-Smtp-Source: AGHT+IFAKfspfPzXOTarzDppOrvsqBsdFiY3Ve3zqr6SbtDfkD29+pdLZvvROltXLBM4mpjG82ewjhooO+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1d26:b0:6ed:d215:9c30 with SMTP id
 d2e1a72fcca58-6f4e0415f96mr1433980b3a.6.1715967644067; Fri, 17 May 2024
 10:40:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:09 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-33-seanjc@google.com>
Subject: [PATCH v2 32/49] KVM: x86: Remove all direct usage of cpuid_entry2_find()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Convert all use of cpuid_entry2_find() to kvm_find_cpuid_entry{,index}()
now that cpuid_entry2_find() operates on the vCPU state, i.e. now that
there is no need to use cpuid_entry2_find() directly in order to pass in
non-vCPU state.

To help prevent unwanted usage of cpuid_entry2_find(), #undef
KVM_CPUID_INDEX_NOT_SIGNIFICANT, i.e. force KVM to use
kvm_find_cpuid_entry().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d7390ade1c29..699ce4261e9c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -189,6 +189,12 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
+/*
+ * cpuid_entry2_find() and KVM_CPUID_INDEX_NOT_SIGNIFICANT should never be used
+ * directly outside of kvm_find_cpuid_entry() and kvm_find_cpuid_entry_index().
+ */
+#undef KVM_CPUID_INDEX_NOT_SIGNIFICANT
+
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -198,8 +204,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
-	best = cpuid_entry2_find(vcpu, 0x80000008,
-				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	best = kvm_find_cpuid_entry(vcpu, 0x80000008);
 	if (best) {
 		int vaddr_bits = (best->eax & 0xff00) >> 8;
 
@@ -211,7 +216,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * Exposing dynamic xfeatures to the guest requires additional
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
 	 */
-	best = cpuid_entry2_find(vcpu, 0xd, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
 	if (!best)
 		return 0;
 
@@ -254,7 +259,7 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
 	u32 base;
 
 	for_each_possible_hypervisor_cpuid_base(base) {
-		entry = cpuid_entry2_find(vcpu, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+		entry = kvm_find_cpuid_entry(vcpu, base);
 
 		if (entry) {
 			u32 signature[3];
@@ -301,7 +306,7 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = cpuid_entry2_find(vcpu, 0xd, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
 	if (!best)
 		return 0;
 
@@ -312,7 +317,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = cpuid_entry2_find(vcpu, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -323,22 +328,22 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	best = cpuid_entry2_find(vcpu, 7, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-	best = cpuid_entry2_find(vcpu, 0xD, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
-	best = cpuid_entry2_find(vcpu, 0xD, 1);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = cpuid_entry2_find(vcpu, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+		best = kvm_find_cpuid_entry(vcpu, 0x1);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
@@ -352,8 +357,7 @@ static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_KVM_HYPERV
 	struct kvm_cpuid_entry2 *entry;
 
-	entry = cpuid_entry2_find(vcpu, HYPERV_CPUID_INTERFACE,
-				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE);
 	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
 #else
 	return false;
-- 
2.45.0.215.g3402c0e53f-goog


