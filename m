Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7483570E96
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 02:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiGLAGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 20:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiGLAGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 20:06:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE864357FF
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 17:06:47 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l16-20020a170902f69000b0016bf6a77effso4611399plg.2
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 17:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=S2bxPTwHWsn/Vspi99KpTXy1dXdowoPOiRDMH++FQJM=;
        b=dAumotERqFdq1lKwYGVstlncFc4ZyoO0yCBpT7AE78PalL63smJBz55P6iM3n4rtHi
         qpZQf7NJn8u7XcGTplalTftnOpLxwdxN/98hvid28I5rqTjlh1HOyaj0jV4aZc9YKdY6
         B84KNr592q9odVGB81sowAjZmxV0tKVgnPfnrfldpk5UdAOVsIf0SnNk2BaNEGwtGkik
         PCf8yomPzVhrmocf0f3PNDJwsxUCoFkyHNeqmYXuH7LjLIrUFPLiFOJOeOvDvsXyRsy+
         KjYNEbDyuL1Za+cvdpkPPPnDhRVaaS77ZoNw1sMtP/3zbm8s1NlRGU3iEuFnp0yZQhHX
         M6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=S2bxPTwHWsn/Vspi99KpTXy1dXdowoPOiRDMH++FQJM=;
        b=EnzivrrAFwgiHShraYEnq6a51493WlUQZ5qcE3wvjtZ2EnbTr8AtLl37FYFHECE5MF
         cNMowkdGa9fNp+PEvIlFBm12kJ2beSdGOolqIq54AkVTYlXeQ8zWLQ8BmN7XYVtHSoKo
         m2wrtVtl2yCrzusDVksUkCwOy2Q7nAqXWBHkniAv4nM0CoPDBuJ8dOtJO+vmwDlAAMD6
         BfMionbVFAEd5wHAovq/+cxFeqaXrrzYfHXu8zAdXqUzhNpZ1kXw7qcbZBoI5N7tAZHg
         sct18U+FccMFvaMxCD2MfVjGQSf1F1reRlu2WwP3B4n9JwZ2/WnFJi/6Yw074e/L0/1H
         7oQg==
X-Gm-Message-State: AJIora+94HoVSFxQd42nVSYjadpgrE/T7SMH9hTM5Wm7oV+01yj996iA
        uIlHNBI786mOFR/KANn0QJoY3SFWsjI=
X-Google-Smtp-Source: AGRyM1vYdHp3onTh5LFfdBlznTbhbO2EsdO4Pkw3+AUroSf5ua2IikxUQ4T99tLMfR7AlQE2YPzkXZXHdI4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cccf:b0:168:e13c:5cd9 with SMTP id
 z15-20020a170902cccf00b00168e13c5cd9mr21461286ple.53.1657584407498; Mon, 11
 Jul 2022 17:06:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 00:06:45 +0000
Message-Id: <20220712000645.1144186-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2] KVM: x86: Add dedicated helper to get CPUID entry with
 significant index
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

v2: Rebased to kvm/queue.

v1: https://lore.kernel.org/all/20211022002006.1425701-1-seanjc@google.com

 arch/x86/kvm/cpuid.c         | 71 ++++++++++++++++++++++++++----------
 arch/x86/kvm/cpuid.h         | 16 ++++----
 arch/x86/kvm/hyperv.c        |  8 ++--
 arch/x86/kvm/svm/svm.c       |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c |  4 +-
 arch/x86/kvm/vmx/sgx.c       |  8 ++--
 arch/x86/kvm/vmx/vmx.c       |  6 +--
 arch/x86/kvm/x86.c           |  2 +-
 8 files changed, 75 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d47222ab8e6e..10247528b59b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -67,9 +67,17 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
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
@@ -77,9 +85,22 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
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
@@ -96,7 +117,8 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
-	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
+	best = cpuid_entry2_find(entries, nent, 0x80000008,
+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
 		int vaddr_bits = (best->eax & 0xff00) >> 8;
 
@@ -151,7 +173,7 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvm_cpuid_base = 0;
 
 	for_each_possible_hypervisor_cpuid_base(function) {
-		entry = kvm_find_cpuid_entry(vcpu, function, 0);
+		entry = kvm_find_cpuid_entry(vcpu, function);
 
 		if (entry) {
 			u32 signature[3];
@@ -177,7 +199,8 @@ static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *v
 	if (!base)
 		return NULL;
 
-	return cpuid_entry2_find(entries, nent, base | KVM_CPUID_FEATURES, 0);
+	return cpuid_entry2_find(entries, nent, base | KVM_CPUID_FEATURES,
+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 }
 
 static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
@@ -219,7 +242,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 	struct kvm_cpuid_entry2 *best;
 	u64 guest_supported_xcr0 = cpuid_get_supported_xcr0(entries, nent);
 
-	best = cpuid_entry2_find(entries, nent, 1, 0);
+	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -250,7 +273,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = cpuid_entry2_find(entries, nent, 0x1, 0);
+		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
@@ -285,7 +308,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *best;
 	u64 guest_supported_xcr0;
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
 			apic->lapic_timer.timer_mode_mask = 3 << 17;
@@ -325,10 +348,10 @@ int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
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
@@ -1302,12 +1325,20 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
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
@@ -1344,7 +1375,7 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 	struct kvm_cpuid_entry2 *basic, *class;
 	u32 function = *fn_ptr;
 
-	basic = kvm_find_cpuid_entry(vcpu, 0, 0);
+	basic = kvm_find_cpuid_entry(vcpu, 0);
 	if (!basic)
 		return NULL;
 
@@ -1353,11 +1384,11 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
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
@@ -1375,7 +1406,7 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 	 * the effective CPUID entry is the max basic leaf.  Note, the index of
 	 * the original requested leaf is observed!
 	 */
-	return kvm_find_cpuid_entry(vcpu, basic->eax, index);
+	return kvm_find_cpuid_entry_index(vcpu, basic->eax, index);
 }
 
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
@@ -1385,7 +1416,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	struct kvm_cpuid_entry2 *entry;
 	bool exact, used_max_basic = false;
 
-	entry = kvm_find_cpuid_entry(vcpu, function, index);
+	entry = kvm_find_cpuid_entry_index(vcpu, function, index);
 	exact = !!entry;
 
 	if (!entry && !exact_only) {
@@ -1414,7 +1445,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		 * exists. EDX can be copied from any existing index.
 		 */
 		if (function == 0xb || function == 0x1f) {
-			entry = kvm_find_cpuid_entry(vcpu, function, 1);
+			entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
 			if (entry) {
 				*ecx = index & 0xff;
 				*edx = entry->edx;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index ac72aabba981..b1658c0de847 100644
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
@@ -76,7 +78,7 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
 	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
 	struct kvm_cpuid_entry2 *entry;
 
-	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
+	entry = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
 	if (!entry)
 		return NULL;
 
@@ -109,7 +111,7 @@ static inline bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0);
 	return best &&
 	       (is_guest_vendor_amd(best->ebx, best->ecx, best->edx) ||
 		is_guest_vendor_hygon(best->ebx, best->ecx, best->edx));
@@ -119,7 +121,7 @@ static inline bool guest_cpuid_is_intel(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0);
 	return best && is_guest_vendor_intel(best->ebx, best->ecx, best->edx);
 }
 
@@ -127,7 +129,7 @@ static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x1);
 	if (!best)
 		return -1;
 
@@ -138,7 +140,7 @@ static inline int guest_cpuid_model(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x1);
 	if (!best)
 		return -1;
 
@@ -154,7 +156,7 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	best = kvm_find_cpuid_entry(vcpu, 0x1);
 	if (!best)
 		return -1;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e2e95a6fccfd..ed804447589c 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1992,7 +1992,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_vcpu_hv *hv_vcpu;
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE);
 	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX) {
 		vcpu->arch.hyperv_enabled = true;
 	} else {
@@ -2005,7 +2005,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 
 	hv_vcpu = to_hv_vcpu(vcpu);
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
 	if (entry) {
 		hv_vcpu->cpuid_cache.features_eax = entry->eax;
 		hv_vcpu->cpuid_cache.features_ebx = entry->ebx;
@@ -2016,7 +2016,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		hv_vcpu->cpuid_cache.features_edx = 0;
 	}
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
 	if (entry) {
 		hv_vcpu->cpuid_cache.enlightenments_eax = entry->eax;
 		hv_vcpu->cpuid_cache.enlightenments_ebx = entry->ebx;
@@ -2025,7 +2025,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		hv_vcpu->cpuid_cache.enlightenments_ebx = 0;
 	}
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0);
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 	if (entry)
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
 	else
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 37ce061dfc76..d2fa008b04ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4193,7 +4193,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
 	if (sev_guest(vcpu->kvm)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
+		best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
 		if (best)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 53ccba896e77..4bc098fbec31 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -531,7 +531,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
 
-	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
+	entry = kvm_find_cpuid_entry(vcpu, 0xa);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
 		return;
 	eax.full = entry->eax;
@@ -577,7 +577,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
-	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
+	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
 	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM))) {
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 35e7ec91ae86..d1cc7244bede 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -148,8 +148,8 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 	u8 max_size_log2;
 	int trapnr, ret;
 
-	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
-	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
+	sgx_12_0 = kvm_find_cpuid_entry_index(vcpu, 0x12, 0);
+	sgx_12_1 = kvm_find_cpuid_entry_index(vcpu, 0x12, 1);
 	if (!sgx_12_0 || !sgx_12_1) {
 		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
@@ -431,7 +431,7 @@ static bool sgx_intercept_encls_ecreate(struct kvm_vcpu *vcpu)
 	if (!vcpu->kvm->arch.sgx_provisioning_allowed)
 		return true;
 
-	guest_cpuid = kvm_find_cpuid_entry(vcpu, 0x12, 0);
+	guest_cpuid = kvm_find_cpuid_entry_index(vcpu, 0x12, 0);
 	if (!guest_cpuid)
 		return true;
 
@@ -439,7 +439,7 @@ static bool sgx_intercept_encls_ecreate(struct kvm_vcpu *vcpu)
 	if (guest_cpuid->ebx != ebx || guest_cpuid->edx != edx)
 		return true;
 
-	guest_cpuid = kvm_find_cpuid_entry(vcpu, 0x12, 1);
+	guest_cpuid = kvm_find_cpuid_entry_index(vcpu, 0x12, 1);
 	if (!guest_cpuid)
 		return true;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c30115b9cb33..74ca64e97643 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7428,7 +7428,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 		vmx->nested.msrs.cr4_fixed1 |= (_cr4_mask);	\
 } while (0)
 
-	entry = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+	entry = kvm_find_cpuid_entry(vcpu, 0x1);
 	cr4_fixed1_update(X86_CR4_VME,        edx, feature_bit(VME));
 	cr4_fixed1_update(X86_CR4_PVI,        edx, feature_bit(VME));
 	cr4_fixed1_update(X86_CR4_TSD,        edx, feature_bit(TSC));
@@ -7444,7 +7444,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PCIDE,      ecx, feature_bit(PCID));
 	cr4_fixed1_update(X86_CR4_OSXSAVE,    ecx, feature_bit(XSAVE));
 
-	entry = kvm_find_cpuid_entry(vcpu, 0x7, 0);
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 0);
 	cr4_fixed1_update(X86_CR4_FSGSBASE,   ebx, feature_bit(FSGSBASE));
 	cr4_fixed1_update(X86_CR4_SMEP,       ebx, feature_bit(SMEP));
 	cr4_fixed1_update(X86_CR4_SMAP,       ebx, feature_bit(SMAP));
@@ -7479,7 +7479,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 	int i;
 
 	for (i = 0; i < PT_CPUID_LEAVES; i++) {
-		best = kvm_find_cpuid_entry(vcpu, 0x14, i);
+		best = kvm_find_cpuid_entry_index(vcpu, 0x14, i);
 		if (!best)
 			return;
 		vmx->pt_desc.caps[CPUID_EAX + i*PT_CPUID_REGS_NUM] = best->eax;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 567d13405445..329875d2ccf2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11731,7 +11731,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 * i.e. it's impossible for kvm_find_cpuid_entry() to find a valid entry
 	 * on RESET.  But, go through the motions in case that's ever remedied.
 	 */
-	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
+	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1);
 	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);

base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
-- 
2.37.0.144.g8ac04bfd2-goog

