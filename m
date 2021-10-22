Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8F436EBE
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 02:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhJVAW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 20:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJVAW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 20:22:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE28CC061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:20:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z2-20020a254c02000000b005b68ef4fe24so2126814yba.11
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=A6Jnze4MTAg0ovONeUWLDhYk4u37CED5mxV7WENrbvM=;
        b=MWNfw02a9TeTU7a/N5DtC86J0AWkEG5m9YYwMXiEgthWxmqjMEyBDD6Cx6xIwrMFk3
         0VhPAySBSJNHVAilBMCzOcaC9tBhiycXU00DzAAesV2Opp96xLnYymO6CgWkUBF6Eery
         41iEkZMItiyY/8vSfp5kVlTO5WJhiNAAp+hrjn0stDzahN3g5+F3GWNcWqAvRhKZSNPZ
         pCiBn8t1hUwmwTSAxPp4uwE6OgjvmenBTGSE70RbfG4mb5CM5GOXNw+m0sXScbyZX8BS
         EC8t+51/T+HcYL1So+xeC4D+AqKYMxJqZwoGroM5z8Mi5SeIti8czZ5+xe9wbbZhfBOM
         LgZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=A6Jnze4MTAg0ovONeUWLDhYk4u37CED5mxV7WENrbvM=;
        b=4ptHSGzEOp7JH/sAhFwlfMojxXPnM9UTEuPlafmpH4hcH0wTsB//Pb62ldOny46uUL
         mGH3AnQAeALOr13GON49kAtGlOfX7eylZcAxebnf6jFy7VwPfrnZ4CTdHFH0dEFVuzWs
         QSeeSA+3LQI0G8dG1I20GljtJ4Y2nuPIfroq1abMSnMv6j7l2yfFzFg/7Vy0rTuajyJZ
         tnU5VmCPj9WhkkSrI3u5mYwJAq7xOgYrXMkDVEg8gDX52YeBbH+CK7jXRVKPNRlWOn6H
         TFBnOXLrOIofPjg2B0ERK1miBJyFn6tBQIghaKmVeVkDCsvVs327VnN2LT19nYp1sEZZ
         oUuQ==
X-Gm-Message-State: AOAM532f/Ili0N8NVFpVT1IXLNLc7ESKiOAcd73LfhLn0xvIbzZDw4z9
        EZL31ySBjb5grR5IugdinO2nS4Vjf64=
X-Google-Smtp-Source: ABdhPJzYKBzZo/jNQnYWqbHzuuvjfbmtRXbQpb9JSQ0SRXT0qUSx+IWJs7szXDR1ztkMM/JcklbD3MsEc9g=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a25:9d86:: with SMTP id v6mr9730956ybp.179.1634862009107;
 Thu, 21 Oct 2021 17:20:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 17:20:06 -0700
Message-Id: <20211022002006.1425701-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH] KVM: x86: Add dedicated helper to get CPUID entry with
 significant index
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a second CPUID helper, kvm_find_cpuid_entry_index(), to handle KVM
queries for CPUID leaves whose index _may_ be significant, and drop the
index param from the existing kvm_find_cpuid_entry().  Add a WARN in the
inner helper, cpuid_entry2_find(), to detect attempts to retrieve a CPUID
entry whose index is significant without explicitly providing an index.

Using an explicit magic number and letting callers omit the index avoids
confusion by eliminating the myriad cases where KVM specifies '0' as a
dummy value.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c         | 80 +++++++++++++++++++++++++-----------
 arch/x86/kvm/cpuid.h         | 16 ++++----
 arch/x86/kvm/hyperv.c        |  8 ++--
 arch/x86/kvm/svm/svm.c       |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c |  4 +-
 arch/x86/kvm/vmx/sgx.c       |  8 ++--
 arch/x86/kvm/vmx/vmx.c       |  6 +--
 arch/x86/kvm/x86.c           |  2 +-
 8 files changed, 79 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d70edb0f323..00c7bb13d92d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -62,9 +62,17 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 #define F feature_bit
 #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
 
+/*
+ * Magic value used by KVM when querying userspace-provided CPUID entries and
+ * doesn't care about the CPIUD index because the index of the function in
+ * question is not significant.  Note, this magic value must have at least one
+ * bit set in bits[63:32] and must be consumed as a u64 by cpuid_entry2_find()
+ * to avoid false positives when processing guest CPUID input.
+ */
+#define KVM_CPUID_INDEX_NOT_SIGNIFICANT -1ull
 
 static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
-	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
+	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
 {
 	struct kvm_cpuid_entry2 *e;
 	int i;
@@ -72,9 +80,22 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	for (i = 0; i < nent; i++) {
 		e = &entries[i];
 
-		if (e->function == function &&
-		    (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
+		if (e->function != function)
+			continue;
+
+		/*
+		 * If the index isn't significant, use the first entry with a
+		 * matching function.  It's userspace's responsibilty to not
+		 * provide "duplicate" entries in all cases.
+		 */
+		if (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index)
 			return e;
+
+		/*
+		 * Function matches and index is significant; not specifying an
+		 * exact index in this case is a KVM bug.
+		 */
+		WARN_ON_ONCE(index == KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	}
 
 	return NULL;
@@ -88,7 +109,8 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
-	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
+	best = cpuid_entry2_find(entries, nent, 0x80000008,
+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
 		int vaddr_bits = (best->eax & 0xff00) >> 8;
 
@@ -103,7 +125,7 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
 
 	/*
 	 * save the feature bitmap to avoid cpuid lookup for every PV
@@ -117,7 +139,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -128,27 +150,27 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	best = kvm_find_cpuid_entry(vcpu, 7, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+		best = kvm_find_cpuid_entry(vcpu, 0x1);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
@@ -162,7 +184,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
 			apic->lapic_timer.timer_mode_mask = 3 << 17;
@@ -172,7 +194,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
 	if (!best)
 		vcpu->arch.guest_supported_xcr0 = 0;
 	else
@@ -187,7 +209,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * supported XCR0.  Similar to XCR0 handling, FP and SSE are forced to
 	 * '1' even on CPUs that don't support XSAVE.
 	 */
-	best = kvm_find_cpuid_entry(vcpu, 0x12, 0x1);
+	best = kvm_find_cpuid_entry_index(vcpu, 0x12, 0x1);
 	if (best) {
 		best->ecx &= vcpu->arch.guest_supported_xcr0 & 0xffffffff;
 		best->edx &= vcpu->arch.guest_supported_xcr0 >> 32;
@@ -219,10 +241,10 @@ int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x80000000, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x80000000);
 	if (!best || best->eax < 0x80000008)
 		goto not_found;
-	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x80000008);
 	if (best)
 		return best->eax & 0xff;
 not_found:
@@ -1105,12 +1127,20 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	return r;
 }
 
-struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
-					      u32 function, u32 index)
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
+						    u32 function, u32 index)
 {
 	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
 				 function, index);
 }
+EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
+
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
+					      u32 function)
+{
+	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
+				 function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+}
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 /*
@@ -1147,7 +1177,7 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 	struct kvm_cpuid_entry2 *basic, *class;
 	u32 function = *fn_ptr;
 
-	basic = kvm_find_cpuid_entry(vcpu, 0, 0);
+	basic = kvm_find_cpuid_entry(vcpu, 0);
 	if (!basic)
 		return NULL;
 
@@ -1156,11 +1186,11 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 		return NULL;
 
 	if (function >= 0x40000000 && function <= 0x4fffffff)
-		class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
+		class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00);
 	else if (function >= 0xc0000000)
-		class = kvm_find_cpuid_entry(vcpu, 0xc0000000, 0);
+		class = kvm_find_cpuid_entry(vcpu, 0xc0000000);
 	else
-		class = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
+		class = kvm_find_cpuid_entry(vcpu, function & 0x80000000);
 
 	if (class && function <= class->eax)
 		return NULL;
@@ -1178,7 +1208,7 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 	 * the effective CPUID entry is the max basic leaf.  Note, the index of
 	 * the original requested leaf is observed!
 	 */
-	return kvm_find_cpuid_entry(vcpu, basic->eax, index);
+	return kvm_find_cpuid_entry_index(vcpu, basic->eax, index);
 }
 
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
@@ -1188,7 +1218,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	struct kvm_cpuid_entry2 *entry;
 	bool exact, used_max_basic = false;
 
-	entry = kvm_find_cpuid_entry(vcpu, function, index);
+	entry = kvm_find_cpuid_entry_index(vcpu, function, index);
 	exact = !!entry;
 
 	if (!entry && !exact_only) {
@@ -1217,7 +1247,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		 * exists. EDX can be copied from any existing index.
 		 */
 		if (function == 0xb || function == 0x1f) {
-			entry = kvm_find_cpuid_entry(vcpu, function, 1);
+			entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
 			if (entry) {
 				*ecx = index & 0xff;
 				*edx = entry->edx;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index c99edfff7f82..39e83eaea53c 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,8 +13,10 @@ void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
+						    u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
-					      u32 function, u32 index);
+					      u32 function);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 			    struct kvm_cpuid_entry2 __user *entries,
 			    unsigned int type);
@@ -74,7 +76,7 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
 	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
 	struct kvm_cpuid_entry2 *entry;
 
-	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
+	entry = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
 	if (!entry)
 		return NULL;
 
@@ -107,7 +109,7 @@ static inline bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0);
 	return best &&
 	       (is_guest_vendor_amd(best->ebx, best->ecx, best->edx) ||
 		is_guest_vendor_hygon(best->ebx, best->ecx, best->edx));
@@ -117,7 +119,7 @@ static inline bool guest_cpuid_is_intel(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0);
 	return best && is_guest_vendor_intel(best->ebx, best->ecx, best->edx);
 }
 
@@ -125,7 +127,7 @@ static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x1);
 	if (!best)
 		return -1;
 
@@ -136,7 +138,7 @@ static inline int guest_cpuid_model(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x1);
 	if (!best)
 		return -1;
 
@@ -147,7 +149,7 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x1);
 	if (!best)
 		return -1;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6f11cda2bfa4..9502be65847b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1952,7 +1952,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_vcpu_hv *hv_vcpu;
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE);
 	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX) {
 		vcpu->arch.hyperv_enabled = true;
 	} else {
@@ -1965,7 +1965,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 
 	hv_vcpu = to_hv_vcpu(vcpu);
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
 	if (entry) {
 		hv_vcpu->cpuid_cache.features_eax = entry->eax;
 		hv_vcpu->cpuid_cache.features_ebx = entry->ebx;
@@ -1976,7 +1976,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		hv_vcpu->cpuid_cache.features_edx = 0;
 	}
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
 	if (entry) {
 		hv_vcpu->cpuid_cache.enlightenments_eax = entry->eax;
 		hv_vcpu->cpuid_cache.enlightenments_ebx = entry->ebx;
@@ -1985,7 +1985,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		hv_vcpu->cpuid_cache.enlightenments_ebx = 0;
 	}
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 	if (entry)
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
 	else
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cee4915d2ce3..4b920dfc68fc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4091,7 +4091,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
 	if (sev_guest(vcpu->kvm)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
+		best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
 		if (best)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b8e0d21b7c8a..56fe46cd8786 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -477,7 +477,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
-	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
+	entry = kvm_find_cpuid_entry(vcpu, 0xa);
 	if (!entry)
 		return;
 	eax.full = entry->eax;
@@ -519,7 +519,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
-	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
+	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
 	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6693ebdc0770..25f42c300b4d 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -152,8 +152,8 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 	u8 max_size_log2;
 	int trapnr, ret;
 
-	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
-	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
+	sgx_12_0 = kvm_find_cpuid_entry_index(vcpu, 0x12, 0);
+	sgx_12_1 = kvm_find_cpuid_entry_index(vcpu, 0x12, 1);
 	if (!sgx_12_0 || !sgx_12_1) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
@@ -437,7 +437,7 @@ static bool sgx_intercept_encls_ecreate(struct kvm_vcpu *vcpu)
 	if (!vcpu->kvm->arch.sgx_provisioning_allowed)
 		return true;
 
-	guest_cpuid = kvm_find_cpuid_entry(vcpu, 0x12, 0);
+	guest_cpuid = kvm_find_cpuid_entry_index(vcpu, 0x12, 0);
 	if (!guest_cpuid)
 		return true;
 
@@ -445,7 +445,7 @@ static bool sgx_intercept_encls_ecreate(struct kvm_vcpu *vcpu)
 	if (guest_cpuid->ebx != ebx || guest_cpuid->edx != edx)
 		return true;
 
-	guest_cpuid = kvm_find_cpuid_entry(vcpu, 0x12, 1);
+	guest_cpuid = kvm_find_cpuid_entry_index(vcpu, 0x12, 1);
 	if (!guest_cpuid)
 		return true;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2f677e72d864..690ab2d253d4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7070,7 +7070,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 		vmx->nested.msrs.cr4_fixed1 |= (_cr4_mask);	\
 } while (0)
 
-	entry = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	entry = kvm_find_cpuid_entry(vcpu, 0x1);
 	cr4_fixed1_update(X86_CR4_VME,        edx, feature_bit(VME));
 	cr4_fixed1_update(X86_CR4_PVI,        edx, feature_bit(VME));
 	cr4_fixed1_update(X86_CR4_TSD,        edx, feature_bit(TSC));
@@ -7086,7 +7086,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PCIDE,      ecx, feature_bit(PCID));
 	cr4_fixed1_update(X86_CR4_OSXSAVE,    ecx, feature_bit(XSAVE));
 
-	entry = kvm_find_cpuid_entry(vcpu, 0x7, 0);
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 0);
 	cr4_fixed1_update(X86_CR4_FSGSBASE,   ebx, feature_bit(FSGSBASE));
 	cr4_fixed1_update(X86_CR4_SMEP,       ebx, feature_bit(SMEP));
 	cr4_fixed1_update(X86_CR4_SMAP,       ebx, feature_bit(SMAP));
@@ -7121,7 +7121,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 	int i;
 
 	for (i = 0; i < PT_CPUID_LEAVES; i++) {
-		best = kvm_find_cpuid_entry(vcpu, 0x14, i);
+		best = kvm_find_cpuid_entry_index(vcpu, 0x14, i);
 		if (!best)
 			return;
 		vmx->pt_desc.caps[CPUID_EAX + i*PT_CPUID_REGS_NUM] = best->eax;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f55654158836..3aa6d016a803 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11032,7 +11032,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 * i.e. it's impossible for kvm_find_cpuid_entry() to find a valid entry
 	 * on RESET.  But, go through the motions in case that's ever remedied.
 	 */
-	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
+	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1);
 	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
 
 	vcpu->arch.ia32_xss = 0;
-- 
2.33.0.1079.g6e70778dc9-goog

