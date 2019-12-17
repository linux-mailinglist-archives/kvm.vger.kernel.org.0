Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FFE1238B6
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 22:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfLQVcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 16:32:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:35299 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfLQVcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 16:32:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:32:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="227639458"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2019 13:32:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] KVM: x86: Refactor and rename bit() to feature_bit() macro
Date:   Tue, 17 Dec 2019 13:32:42 -0800
Message-Id: <20191217213242.11712-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217213242.11712-1-sean.j.christopherson@intel.com>
References: <20191217213242.11712-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename bit() to __feature_bit() to give it a more descriptive name, and
add a macro, feature_bit(), to stuff the X68_FEATURE_ prefix to keep
line lengths manageable for code that hardcodes the bit to be retrieved.

No functional change intended.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   |  2 +-
 arch/x86/kvm/cpuid.h   |  8 +++++---
 arch/x86/kvm/svm.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c | 42 +++++++++++++++++++++---------------------
 4 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a3b41e87e810..390dff4beb07 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -62,7 +62,7 @@ u64 kvm_supported_xcr0(void)
 	return xcr0;
 }
 
-#define F(x) bit(X86_FEATURE_##x)
+#define F feature_bit
 
 int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index fc5a4cde260b..5d0bede5fc80 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -80,12 +80,14 @@ static __always_inline void reverse_cpuid_check(unsigned x86_leaf)
  * "word" (stored in bits 31:5).  The word is used to index into arrays of
  * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
  */
-static __always_inline u32 bit(int x86_feature)
+static __always_inline u32 __feature_bit(int x86_feature)
 {
 	reverse_cpuid_check(x86_feature / 32);
 	return 1 << (x86_feature & 31);
 }
 
+#define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
+
 static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
 {
 	unsigned x86_leaf = x86_feature / 32;
@@ -130,7 +132,7 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_
 	if (!reg)
 		return false;
 
-	return *reg & bit(x86_feature);
+	return *reg & __feature_bit(x86_feature);
 }
 
 static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x86_feature)
@@ -139,7 +141,7 @@ static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x8
 
 	reg = guest_cpuid_get_register(vcpu, x86_feature);
 	if (reg)
-		*reg &= ~bit(x86_feature);
+		*reg &= ~__feature_bit(x86_feature);
 }
 
 static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8f1b715dfde8..832b8ad5a178 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5924,14 +5924,14 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
 }
 
-#define F(x) bit(X86_FEATURE_##x)
+#define F feature_bit
 
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
 	case 0x1:
 		if (avic)
-			entry->ecx &= ~bit(X86_FEATURE_X2APIC);
+			entry->ecx &= ~F(X2APIC);
 		break;
 	case 0x80000001:
 		if (nested)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51e3b27f90ed..3608de5649f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6979,28 +6979,28 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 } while (0)
 
 	entry = kvm_find_cpuid_entry(vcpu, 0x1, 0);
-	cr4_fixed1_update(X86_CR4_VME,        edx, bit(X86_FEATURE_VME));
-	cr4_fixed1_update(X86_CR4_PVI,        edx, bit(X86_FEATURE_VME));
-	cr4_fixed1_update(X86_CR4_TSD,        edx, bit(X86_FEATURE_TSC));
-	cr4_fixed1_update(X86_CR4_DE,         edx, bit(X86_FEATURE_DE));
-	cr4_fixed1_update(X86_CR4_PSE,        edx, bit(X86_FEATURE_PSE));
-	cr4_fixed1_update(X86_CR4_PAE,        edx, bit(X86_FEATURE_PAE));
-	cr4_fixed1_update(X86_CR4_MCE,        edx, bit(X86_FEATURE_MCE));
-	cr4_fixed1_update(X86_CR4_PGE,        edx, bit(X86_FEATURE_PGE));
-	cr4_fixed1_update(X86_CR4_OSFXSR,     edx, bit(X86_FEATURE_FXSR));
-	cr4_fixed1_update(X86_CR4_OSXMMEXCPT, edx, bit(X86_FEATURE_XMM));
-	cr4_fixed1_update(X86_CR4_VMXE,       ecx, bit(X86_FEATURE_VMX));
-	cr4_fixed1_update(X86_CR4_SMXE,       ecx, bit(X86_FEATURE_SMX));
-	cr4_fixed1_update(X86_CR4_PCIDE,      ecx, bit(X86_FEATURE_PCID));
-	cr4_fixed1_update(X86_CR4_OSXSAVE,    ecx, bit(X86_FEATURE_XSAVE));
+	cr4_fixed1_update(X86_CR4_VME,        edx, feature_bit(VME));
+	cr4_fixed1_update(X86_CR4_PVI,        edx, feature_bit(VME));
+	cr4_fixed1_update(X86_CR4_TSD,        edx, feature_bit(TSC));
+	cr4_fixed1_update(X86_CR4_DE,         edx, feature_bit(DE));
+	cr4_fixed1_update(X86_CR4_PSE,        edx, feature_bit(PSE));
+	cr4_fixed1_update(X86_CR4_PAE,        edx, feature_bit(PAE));
+	cr4_fixed1_update(X86_CR4_MCE,        edx, feature_bit(MCE));
+	cr4_fixed1_update(X86_CR4_PGE,        edx, feature_bit(PGE));
+	cr4_fixed1_update(X86_CR4_OSFXSR,     edx, feature_bit(FXSR));
+	cr4_fixed1_update(X86_CR4_OSXMMEXCPT, edx, feature_bit(XMM));
+	cr4_fixed1_update(X86_CR4_VMXE,       ecx, feature_bit(VMX));
+	cr4_fixed1_update(X86_CR4_SMXE,       ecx, feature_bit(SMX));
+	cr4_fixed1_update(X86_CR4_PCIDE,      ecx, feature_bit(PCID));
+	cr4_fixed1_update(X86_CR4_OSXSAVE,    ecx, feature_bit(XSAVE));
 
 	entry = kvm_find_cpuid_entry(vcpu, 0x7, 0);
-	cr4_fixed1_update(X86_CR4_FSGSBASE,   ebx, bit(X86_FEATURE_FSGSBASE));
-	cr4_fixed1_update(X86_CR4_SMEP,       ebx, bit(X86_FEATURE_SMEP));
-	cr4_fixed1_update(X86_CR4_SMAP,       ebx, bit(X86_FEATURE_SMAP));
-	cr4_fixed1_update(X86_CR4_PKE,        ecx, bit(X86_FEATURE_PKU));
-	cr4_fixed1_update(X86_CR4_UMIP,       ecx, bit(X86_FEATURE_UMIP));
-	cr4_fixed1_update(X86_CR4_LA57,       ecx, bit(X86_FEATURE_LA57));
+	cr4_fixed1_update(X86_CR4_FSGSBASE,   ebx, feature_bit(FSGSBASE));
+	cr4_fixed1_update(X86_CR4_SMEP,       ebx, feature_bit(SMEP));
+	cr4_fixed1_update(X86_CR4_SMAP,       ebx, feature_bit(SMAP));
+	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
+	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
+	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 
 #undef cr4_fixed1_update
 }
@@ -7134,7 +7134,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	if (func == 1 && nested)
-		entry->ecx |= bit(X86_FEATURE_VMX);
+		entry->ecx |= feature_bit(VMX);
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
-- 
2.24.1

