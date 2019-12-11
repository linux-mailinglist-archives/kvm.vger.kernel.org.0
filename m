Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30B411BAD5
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 18:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbfLKR6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 12:58:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:29189 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730923AbfLKR6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 12:58:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 09:58:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,302,1571727600"; 
   d="scan'208";a="203645155"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 11 Dec 2019 09:58:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Refactor and rename bit() to feature_bit() macro
Date:   Wed, 11 Dec 2019 09:58:22 -0800
Message-Id: <20191211175822.1925-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211175822.1925-1-sean.j.christopherson@intel.com>
References: <20191211175822.1925-1-sean.j.christopherson@intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   |  2 +-
 arch/x86/kvm/cpuid.h   |  4 ++--
 arch/x86/kvm/emulate.c |  8 +++-----
 arch/x86/kvm/svm.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c | 42 +++++++++++++++++++++---------------------
 arch/x86/kvm/x86.h     |  5 +++--
 6 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cfafa320a8cf..2b80948f5ddb 100644
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
index d78a61408243..5a96037e8fd7 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -101,7 +101,7 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_
 	if (!reg)
 		return false;
 
-	return *reg & bit(x86_feature);
+	return *reg & __feature_bit(x86_feature);
 }
 
 static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x86_feature)
@@ -110,7 +110,7 @@ static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x8
 
 	reg = guest_cpuid_get_register(vcpu, x86_feature);
 	if (reg)
-		*reg &= ~bit(x86_feature);
+		*reg &= ~__feature_bit(x86_feature);
 }
 
 static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 952d1a4f4d7e..acb21e5b7e61 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2353,7 +2353,7 @@ static int emulator_has_longmode(struct x86_emulate_ctxt *ctxt)
 	eax = 0x80000001;
 	ecx = 0;
 	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
-	return edx & bit(X86_FEATURE_LM);
+	return edx & feature_bit(LM);
 #else
 	return false;
 #endif
@@ -3618,8 +3618,6 @@ static int em_mov(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
-#define FFL(x) bit(X86_FEATURE_##x)
-
 static int em_movbe(struct x86_emulate_ctxt *ctxt)
 {
 	u32 ebx, ecx, edx, eax = 1;
@@ -3629,7 +3627,7 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
 	 * Check MOVBE is set in the guest-visible CPUID leaf.
 	 */
 	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
-	if (!(ecx & FFL(MOVBE)))
+	if (!(ecx & feature_bit(MOVBE)))
 		return emulate_ud(ctxt);
 
 	switch (ctxt->op_bytes) {
@@ -4030,7 +4028,7 @@ static int check_fxsr(struct x86_emulate_ctxt *ctxt)
 	u32 eax = 1, ebx, ecx = 0, edx;
 
 	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
-	if (!(edx & FFL(FXSR)))
+	if (!(edx & feature_bit(FXSR)))
 		return emulate_ud(ctxt);
 
 	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
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
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4ee4175c66a7..d6ea2e0b24f1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -150,10 +150,10 @@ static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
  * "word" (stored in bits 31:5).  The word is used to index into arrays of
  * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
  */
-static __always_inline u32 bit(int feature)
+static __always_inline u32 __feature_bit(u32 feature)
 {
 	/*
-	 * bit() is intended to be used only for hardware-defined
+	 * __feature_bit() is intended to be used only for hardware-defined
 	 * words, i.e. words whose bits directly correspond to a CPUID leaf.
 	 * Retrieving the bit mask from a Linux-defined word is nonsensical
 	 * as the bit number/mask is an arbitrary software-defined value and
@@ -167,6 +167,7 @@ static __always_inline u32 bit(int feature)
 
 	return 1 << (feature & 31);
 }
+#define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
 
 static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 {
-- 
2.24.0

