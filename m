Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991D41768B9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbgCBX6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:25521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbgCBX53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384707"
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
Subject: [PATCH v2 28/66] KVM: x86: Introduce cpuid_entry_{change,set,clear}() mutators
Date:   Mon,  2 Mar 2020 15:56:31 -0800
Message-Id: <20200302235709.27467-29-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce mutators to modify feature bits in CPUID entries and use the
new mutators where applicable.  Using the mutators eliminates the need
to manually specify the register to modify query at no extra cost and
will allow adding runtime consistency checks on the function/index in a
future patch.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 62 +++++++++++++++++++-------------------------
 arch/x86/kvm/cpuid.h | 32 +++++++++++++++++++++++
 arch/x86/kvm/svm.c   | 13 ++++------
 3 files changed, 63 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 81bf6555987f..14b5fb24c6be 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -57,15 +57,12 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		return 0;
 
 	/* Update OSXSAVE bit */
-	if (boot_cpu_has(X86_FEATURE_XSAVE) && best->function == 0x1) {
-		best->ecx &= ~F(OSXSAVE);
-		if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE))
-			best->ecx |= F(OSXSAVE);
-	}
+	if (boot_cpu_has(X86_FEATURE_XSAVE) && best->function == 0x1)
+		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
+				   kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE));
 
-	best->edx &= ~F(APIC);
-	if (vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE)
-		best->edx |= F(APIC);
+	cpuid_entry_change(best, X86_FEATURE_APIC,
+			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 
 	if (apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
@@ -75,14 +72,9 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 7, 0);
-	if (best) {
-		/* Update OSPKE bit */
-		if (boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7) {
-			best->ecx &= ~F(OSPKE);
-			if (kvm_read_cr4_bits(vcpu, X86_CR4_PKE))
-				best->ecx |= F(OSPKE);
-		}
-	}
+	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
+		cpuid_entry_change(best, X86_FEATURE_OSPKE,
+				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
 	if (!best) {
@@ -119,12 +111,10 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
-		if (best) {
-			if (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT)
-				best->ecx |= F(MWAIT);
-			else
-				best->ecx &= ~F(MWAIT);
-		}
+		if (best)
+			cpuid_entry_change(best, X86_FEATURE_MWAIT,
+					   vcpu->arch.ia32_misc_enable_msr &
+					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
 	/* Update physical-address width */
@@ -157,7 +147,7 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 		}
 	}
 	if (entry && cpuid_entry_has(entry, X86_FEATURE_NX) && !is_efer_nx()) {
-		entry->edx &= ~F(NX);
+		cpuid_entry_clear(entry, X86_FEATURE_NX);
 		printk(KERN_INFO "kvm: guest NX capability removed\n");
 	}
 }
@@ -385,7 +375,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
 		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
 		/* TSC_ADJUST is emulated */
-		entry->ebx |= F(TSC_ADJUST);
+		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
 
 		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
 		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
@@ -396,21 +386,21 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 		entry->ecx |= f_pku;
 		/* PKU is not yet implemented for shadow paging. */
 		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
-			entry->ecx &= ~F(PKU);
+			cpuid_entry_clear(entry, X86_FEATURE_PKU);
 
 		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
 		cpuid_mask(&entry->edx, CPUID_7_EDX);
 		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
-			entry->edx |= F(SPEC_CTRL);
+			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
-			entry->edx |= F(INTEL_STIBP);
+			cpuid_entry_set(entry, X86_FEATURE_INTEL_STIBP);
 		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
-			entry->edx |= F(SPEC_CTRL_SSBD);
+			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
 		/*
 		 * We emulate ARCH_CAPABILITIES in software even
 		 * if the host doesn't support it.
 		 */
-		entry->edx |= F(ARCH_CAPABILITIES);
+		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
 		break;
 	case 1:
 		entry->eax &= kvm_cpuid_7_1_eax_x86_features;
@@ -522,7 +512,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		cpuid_mask(&entry->ecx, CPUID_1_ECX);
 		/* we support x2apic emulation even if host does not support
 		 * it since we emulate x2apic in software */
-		entry->ecx |= F(X2APIC);
+		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
 		break;
 	/* function 2 entries are STATEFUL. That is, repeated cpuid commands
 	 * may return different values. This forces us to get_cpu() before
@@ -737,22 +727,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * record that in cpufeatures so use them.
 		 */
 		if (boot_cpu_has(X86_FEATURE_IBPB))
-			entry->ebx |= F(AMD_IBPB);
+			cpuid_entry_set(entry, X86_FEATURE_AMD_IBPB);
 		if (boot_cpu_has(X86_FEATURE_IBRS))
-			entry->ebx |= F(AMD_IBRS);
+			cpuid_entry_set(entry, X86_FEATURE_AMD_IBRS);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
-			entry->ebx |= F(AMD_STIBP);
+			cpuid_entry_set(entry, X86_FEATURE_AMD_STIBP);
 		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
-			entry->ebx |= F(AMD_SSBD);
+			cpuid_entry_set(entry, X86_FEATURE_AMD_SSBD);
 		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
-			entry->ebx |= F(AMD_SSB_NO);
+			cpuid_entry_set(entry, X86_FEATURE_AMD_SSB_NO);
 		/*
 		 * The preference is to use SPEC CTRL MSR instead of the
 		 * VIRT_SPEC MSR.
 		 */
 		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
 		    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
-			entry->ebx |= F(VIRT_SSBD);
+			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
 		break;
 	}
 	case 0x80000019:
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index bf95428ddf4e..de3c6c365a5a 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -135,6 +135,38 @@ static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
 	return cpuid_entry_get(entry, x86_feature);
 }
 
+static __always_inline void cpuid_entry_clear(struct kvm_cpuid_entry2 *entry,
+					      unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	*reg &= ~__feature_bit(x86_feature);
+}
+
+static __always_inline void cpuid_entry_set(struct kvm_cpuid_entry2 *entry,
+					    unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	*reg |= __feature_bit(x86_feature);
+}
+
+static __always_inline void cpuid_entry_change(struct kvm_cpuid_entry2 *entry,
+					       unsigned int x86_feature,
+					       bool set)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	/*
+	 * Open coded instead of using cpuid_entry_{clear,set}() to coerce the
+	 * compiler into using CMOV instead of Jcc when possible.
+	 */
+	if (set)
+		*reg |= __feature_bit(x86_feature);
+	else
+		*reg &= ~__feature_bit(x86_feature);
+}
+
 static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
 						     unsigned int x86_feature)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0d7bdbb94643..728b90c1a68b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6027,23 +6027,21 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 					 APICV_INHIBIT_REASON_NESTED);
 }
 
-#define F feature_bit
-
 static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
 	switch (entry->function) {
 	case 0x1:
 		if (avic)
-			entry->ecx &= ~F(X2APIC);
+			cpuid_entry_clear(entry, X86_FEATURE_X2APIC);
 		break;
 	case 0x80000001:
 		if (nested)
-			entry->ecx |= (1 << 2); /* Set SVM bit */
+			cpuid_entry_set(entry, X86_FEATURE_SVM);
 		break;
 	case 0x80000008:
 		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 		     boot_cpu_has(X86_FEATURE_AMD_SSBD))
-			entry->ebx |= F(VIRT_SSBD);
+			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
 		break;
 	case 0x8000000A:
 		entry->eax = 1; /* SVM revision 1 */
@@ -6055,12 +6053,11 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 
 		/* Support next_rip if host supports it */
 		if (boot_cpu_has(X86_FEATURE_NRIPS))
-			entry->edx |= F(NRIPS);
+			cpuid_entry_set(entry, X86_FEATURE_NRIPS);
 
 		/* Support NPT for the guest if enabled */
 		if (npt_enabled)
-			entry->edx |= F(NPT);
-
+			cpuid_entry_set(entry, X86_FEATURE_NPT);
 	}
 }
 
-- 
2.24.1

