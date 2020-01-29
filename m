Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF85014D3CF
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgA2Xqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:46:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:46688 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbgA2Xqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551734"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/26] KVM: x86: Introduce cpuid_entry_{get,has}() accessors
Date:   Wed, 29 Jan 2020 15:46:28 -0800
Message-Id: <20200129234640.8147-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce accessors to retrieve feature bits from CPUID entries and use
the new accessors where applicable.  Using the accessors eliminates the
need to manually specify the register to be queried at no extra cost
(binary output is identical) and will allow adding runtime consistency
checks on the function and index in a future patch.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c |  9 +++++----
 arch/x86/kvm/cpuid.h | 46 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c12cd8218f47..99e02b468c7c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -68,7 +68,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		best->edx |= F(APIC);
 
 	if (apic) {
-		if (best->ecx & F(TSC_DEADLINE_TIMER))
+		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
 			apic->lapic_timer.timer_mode_mask = 3 << 17;
 		else
 			apic->lapic_timer.timer_mode_mask = 1 << 17;
@@ -96,7 +96,8 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
+	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
+		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	/*
@@ -155,7 +156,7 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 			break;
 		}
 	}
-	if (entry && (entry->edx & F(NX)) && !is_efer_nx()) {
+	if (entry && cpuid_entry_has(entry, X86_FEATURE_NX) && !is_efer_nx()) {
 		entry->edx &= ~F(NX);
 		printk(KERN_INFO "kvm: guest NX capability removed\n");
 	}
@@ -371,7 +372,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		entry->ebx |= F(TSC_ADJUST);
 
 		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
-		f_la57 = entry->ecx & F(LA57);
+		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
 		cpuid_mask(&entry->ecx, CPUID_7_ECX);
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 72a79bdfed6b..64e96e4086e2 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -95,16 +95,10 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
 	return reverse_cpuid[x86_leaf];
 }
 
-static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
+static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
+						  const struct cpuid_reg *cpuid)
 {
-	struct kvm_cpuid_entry2 *entry;
-	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
-
-	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
-	if (!entry)
-		return NULL;
-
-	switch (cpuid.reg) {
+	switch (cpuid->reg) {
 	case CPUID_EAX:
 		return &entry->eax;
 	case CPUID_EBX:
@@ -119,6 +113,40 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
 	}
 }
 
+static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
+						unsigned x86_feature)
+{
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+
+	return __cpuid_entry_get_reg(entry, &cpuid);
+}
+
+static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
+					   unsigned x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	return *reg & __feature_bit(x86_feature);
+}
+
+static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
+					    unsigned x86_feature)
+{
+	return cpuid_entry_get(entry, x86_feature);
+}
+
+static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
+{
+	struct kvm_cpuid_entry2 *entry;
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+
+	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
+	if (!entry)
+		return NULL;
+
+	return __cpuid_entry_get_reg(entry, &cpuid);
+}
+
 static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
 {
 	u32 *reg;
-- 
2.24.1

