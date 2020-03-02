Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9B71768BD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgCBX6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:25519 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgCBX53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384704"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 27/66] KVM: x86: Introduce cpuid_entry_{get,has}() accessors
Date:   Mon,  2 Mar 2020 15:56:30 -0800
Message-Id: <20200302235709.27467-28-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c |  9 +++++----
 arch/x86/kvm/cpuid.h | 48 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ffcf647b8fb4..81bf6555987f 100644
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
@@ -387,7 +388,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 		entry->ebx |= F(TSC_ADJUST);
 
 		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
-		f_la57 = entry->ecx & F(LA57);
+		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
 		cpuid_mask(&entry->ecx, CPUID_7_ECX);
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 46b4b61b6cf8..bf95428ddf4e 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -95,17 +95,10 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
 	return reverse_cpuid[x86_leaf];
 }
 
-static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
-						     unsigned int x86_feature)
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
@@ -120,6 +113,41 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
 	}
 }
 
+static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
+						unsigned int x86_feature)
+{
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+
+	return __cpuid_entry_get_reg(entry, &cpuid);
+}
+
+static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
+					   unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	return *reg & __feature_bit(x86_feature);
+}
+
+static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
+					    unsigned int x86_feature)
+{
+	return cpuid_entry_get(entry, x86_feature);
+}
+
+static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
+						     unsigned int x86_feature)
+{
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
+	if (!entry)
+		return NULL;
+
+	return __cpuid_entry_get_reg(entry, &cpuid);
+}
+
 static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
 					    unsigned int x86_feature)
 {
-- 
2.24.1

