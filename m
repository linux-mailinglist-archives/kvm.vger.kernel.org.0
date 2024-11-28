Return-Path: <kvm+bounces-32685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 035479DB109
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7BFB281918
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E6E136357;
	Thu, 28 Nov 2024 01:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IezYaAlY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A16C1BBBFE
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757733; cv=none; b=EBnTii/BpzKpMmGYBOZ96GbCa0bqg03LrOkSxwapzm059qfV+ssNqQQnH6yTiyHf9/+Tb8qy31A1HP9+5PdBjwiwpb12BvNO58yYeplKuEF32jMB5qm8PI629uV0jjUC32ToULaO2P1cISjytjgWAKWqXBOe/wiw7UMfE9CPwSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757733; c=relaxed/simple;
	bh=9eO98SZn2mDFLD1a3Lz5wd31zTEPCDCMMncDFhOl7eI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iNMrNshUOyYYKGeJxl9zqr2CQty0YwdmflnX/s/Bwll1Hq8lMQXlW0bJ7/0UTdEIIlLzLuqdwrFeHm1L3Zu8Fl2jlwnfqIrnwbLTES+oIk9Y3VDM/dwY/SXyhVOgPlM4fBWh0UFZBMDQyF8upxNuQAIvwiygmV8ZDd50VxdF0i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IezYaAlY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2122b6cadb1so2445485ad.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757731; x=1733362531; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OqeKjXj1sUTvQY70HXizSZvJm3WZ8z59TPWcZBFHU5k=;
        b=IezYaAlYnPIadFBByKkmzDcKk2oBBtACofkVtDBLBWuZMKKLIYr6Cfqig9KCmRr8JR
         rCPq7DUuhS2PEN6Zw9kEgb+UU5MXB934P659L/HXQkmkLn3x4BP0AmDCR9GfX9NG1dMK
         HcE4IA8IWUPLf/6U443XZAPDJyQTGeWoM6z3Rxd6DA79tA5l2I2bOd4JYvXLRXtOQwa6
         eusEnbvZU/IRkh8e9tEIfkY4eaM82lNEzD5OYPsf//heZFTiaiRhdgf2ZL03p1XyEKlZ
         aD2rSLIRXZfPF1Jx5SfkNI4LZa5s6zN3uNj4jJf3FIeHRH95sMO+MsABo76EIYkT/IY5
         jjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757731; x=1733362531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OqeKjXj1sUTvQY70HXizSZvJm3WZ8z59TPWcZBFHU5k=;
        b=WvTjFI+HcjrkmzePrIeHbGwhP5+zWvsnNB0Yt738VFv2HBtjmJbbcDOGV9dzs1wlps
         Qq3uLnzFHfveB7Jwv8MaBCrzJSF4R7NW3JETDPD3M+Q3KY/CE/mLb5e0WFzQKjgBn3a7
         f+IZ6L5MzOb1C60zUrcIuyvRA/aRBk7FTdYfTLV61VIcPkKRe/Hdp5D3JfgnMyzILTZM
         6R/sl/mzxtqOPKmLUJ4N9t5eUA2wjU28TMmT+7ufzXgXFBy+nn0v57RFevkCJroD9JXl
         5Lqhfi2JOjPyBTRu9yo3UIzd175xONXaMWa3xk2mJgRFfgF1XtySCmZ652N3JjSNElQx
         Qn5g==
X-Gm-Message-State: AOJu0YxDkzAJdu7hJZDUlev58J8lkze7hU/7rSa/jmh78hqtz5cBZJE3
	+pK+9sje0AkHVHQyFsAUwqa/eADRm/LINZXMs4UwR8a9tWTcc0DinHXYp5ONgjWZjvlFqMrezOb
	fqA==
X-Google-Smtp-Source: AGHT+IEPTOpAoWzmwmNnAQ0v/L+7xK9RC0l6auKMFc9n+NhMbuz72rWokNPQIE61N4EBAXYYWy5nTfKjJIY=
X-Received: from pfwz6.prod.google.com ([2002:a05:6a00:1d86:b0:725:301d:d8b3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:990:b0:20c:a19b:8ddd
 with SMTP id d9443c01a7336-21501e68df9mr69619085ad.51.1732757731031; Wed, 27
 Nov 2024 17:35:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:01 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-35-seanjc@google.com>
Subject: [PATCH v3 34/57] KVM: x86: Always operate on kvm_vcpu data in cpuid_entry2_find()
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

Now that KVM sets vcpu->arch.cpuid_{entries,nent} before processing the
incoming CPUID entries during KVM_SET_CPUID{,2}, drop the @entries and
@nent params from cpuid_entry2_find() and unconditionally operate on the
vCPU state.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 62 +++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b402b9f59cbb..af5c66408c78 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -70,8 +70,8 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
  */
 #define KVM_CPUID_INDEX_NOT_SIGNIFICANT -1ull
 
-static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
-	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
+static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
+						  u32 function, u64 index)
 {
 	struct kvm_cpuid_entry2 *e;
 	int i;
@@ -88,8 +88,8 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	 */
 	lockdep_assert_irqs_enabled();
 
-	for (i = 0; i < nent; i++) {
-		e = &entries[i];
+	for (i = 0; i < vcpu->arch.cpuid_nent; i++) {
+		e = &vcpu->arch.cpuid_entries[i];
 
 		if (e->function != function)
 			continue;
@@ -123,8 +123,6 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *entries = vcpu->arch.cpuid_entries;
-	int nent = vcpu->arch.cpuid_nent;
 	struct kvm_cpuid_entry2 *best;
 	u64 xfeatures;
 
@@ -132,7 +130,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
-	best = cpuid_entry2_find(entries, nent, 0x80000008,
+	best = cpuid_entry2_find(vcpu, 0x80000008,
 				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
 		int vaddr_bits = (best->eax & 0xff00) >> 8;
@@ -145,7 +143,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	 * Exposing dynamic xfeatures to the guest requires additional
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
 	 */
-	best = cpuid_entry2_find(entries, nent, 0xd, 0);
+	best = cpuid_entry2_find(vcpu, 0xd, 0);
 	if (!best)
 		return 0;
 
@@ -191,15 +189,15 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
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
@@ -219,13 +217,6 @@ static struct kvm_hypervisor_cpuid __kvm_get_hypervisor_cpuid(struct kvm_cpuid_e
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
@@ -249,23 +240,22 @@ static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
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
@@ -276,43 +266,36 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
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
@@ -370,8 +353,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	vcpu->arch.guest_supported_xcr0 =
-		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
 
 	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
 
@@ -1756,16 +1738,14 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
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
2.47.0.338.g60cca15819-goog


