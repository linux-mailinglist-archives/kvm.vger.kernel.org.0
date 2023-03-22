Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD5F6C41C2
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 05:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCVE6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 00:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCVE6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 00:58:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B089F30B20
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 21:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679461112; x=1710997112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pYw+xQfSZLgLR3tAdU6iOXHju26FrDrpwiEh6GAoRnk=;
  b=Pvg/5esVTl+54rIHjzil5Ky3qXmUMAAuudM89IMdvsJwooNqecVFWVxY
   lCj59vHmN/CNiruCK3F8K9PBQXzZ7/wABZV4l0kQiY5691vyaTHMM7vKF
   N8GQXYNBRR+akN1XvD3tJHhHclKhhG+aYo16IyhYSe44yLE2sPHZw5JJu
   FBEIGjuPiwLVPFDhGT4EUZXEQ6Fm24y9kRXqZU8DzacSlNBnf/gxpw7pF
   tQycMguYWTQj8uxU2iLOV7f+irLwTW+4fCiR2QZI0SSjKB+nj+eE359Gr
   9u0IOQ90YFlbnEvye5jWBWokz0IhFiWYGEAknnkjYjvyoZmoAFPBNPbG5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="327507198"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="327507198"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="750908543"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="750908543"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.235])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:30 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, robert.hu@linux.intel.com
Subject: [PATCH 2/4] KVM: x86: Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set()
Date:   Wed, 22 Mar 2023 12:58:22 +0800
Message-Id: <20230322045824.22970-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322045824.22970-1-binbin.wu@linux.intel.com>
References: <20230322045824.22970-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set() when only
one bit is checked and bool is preferred as return value type.
Also change the return value type from int to bool of is_pae(), is_pse() and
is_paging().

vmx_set_cr0() uses kvm_read_cr0_bits() to read X86_CR0_PG and assigned
to unsigned long, keep it as it is.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c      |  4 ++--
 arch/x86/kvm/mmu.h        |  2 +-
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 arch/x86/kvm/x86.c        | 20 ++++++++++----------
 arch/x86/kvm/x86.h        | 16 ++++++++--------
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9583a110cf5f..bc767b0fabea 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -266,7 +266,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
 			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
-				   kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE));
+				   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
@@ -275,7 +275,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 	best = cpuid_entry2_find(entries, nent, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
-				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
+				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
 	best = cpuid_entry2_find(entries, nent, 0xD, 0);
 	if (best)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 168c46fd8dd1..89f532516a45 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -132,7 +132,7 @@ static inline unsigned long kvm_get_pcid(struct kvm_vcpu *vcpu, gpa_t cr3)
 {
 	BUILD_BUG_ON((X86_CR3_PCID_MASK & PAGE_MASK) != 0);
 
-	return kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)
+	return kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)
 	       ? cr3 & X86_CR3_PCID_MASK
 	       : 0;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f63b28f46a71..7ac6bae6ba0c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5154,7 +5154,7 @@ static int handle_vmxon(struct kvm_vcpu *vcpu)
 	 * does force CR0.PE=1, but only to also force VM86 in order to emulate
 	 * Real Mode, and so there's no need to check CR0.PE manually.
 	 */
-	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
+	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_VMXE)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7bf14abdba1..2a29fd6edb30 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5180,7 +5180,7 @@ bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu)
 	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
 		return true;
 
-	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
+	return vmx_get_cpl(vcpu) == 3 && kvm_is_cr0_bit_set(vcpu, X86_CR0_AM) &&
 	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 237c483b1230..324fcf78a4b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -841,7 +841,7 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 {
-	if ((dr != 4 && dr != 5) || !kvm_read_cr4_bits(vcpu, X86_CR4_DE))
+	if ((dr != 4 && dr != 5) || !kvm_is_cr4_bit_set(vcpu, X86_CR4_DE))
 		return true;
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
@@ -965,7 +965,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		return 1;
 
 	if (!(cr0 & X86_CR0_PG) &&
-	    (is_64_bit_mode(vcpu) || kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)))
+	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
@@ -987,7 +987,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_state_protected)
 		return;
 
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
+	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
@@ -1001,7 +1001,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	if (static_cpu_has(X86_FEATURE_PKU) &&
 	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
-	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
+	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
 		write_pkru(vcpu->arch.pkru);
 #endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
 }
@@ -1015,14 +1015,14 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 	if (static_cpu_has(X86_FEATURE_PKU) &&
 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
-	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
+	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
 		vcpu->arch.pkru = rdpkru();
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
 			write_pkru(vcpu->arch.host_pkru);
 	}
 #endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
 
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
+	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
@@ -1227,7 +1227,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	 * PCIDs for them are also 0, because MOV to CR3 always flushes the TLB
 	 * with PCIDE=0.
 	 */
-	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
+	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE))
 		return;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
@@ -1242,7 +1242,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	bool skip_tlb_flush = false;
 	unsigned long pcid = 0;
 #ifdef CONFIG_X86_64
-	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+	bool pcid_enabled = kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE);
 
 	if (pcid_enabled) {
 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
@@ -5033,7 +5033,7 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 		return 0;
 	if (mce->status & MCI_STATUS_UC) {
 		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
-		    !kvm_read_cr4_bits(vcpu, X86_CR4_MCE)) {
+		    !kvm_is_cr4_bit_set(vcpu, X86_CR4_MCE)) {
 			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 			return 0;
 		}
@@ -13236,7 +13236,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		return 1;
 	}
 
-	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+	pcid_enabled = kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE);
 
 	switch (type) {
 	case INVPCID_TYPE_INDIV_ADDR:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8167b47b8c8..577b82358529 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -123,7 +123,7 @@ static inline bool kvm_exception_is_soft(unsigned int nr)
 
 static inline bool is_protmode(struct kvm_vcpu *vcpu)
 {
-	return kvm_read_cr0_bits(vcpu, X86_CR0_PE);
+	return kvm_is_cr0_bit_set(vcpu, X86_CR0_PE);
 }
 
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
@@ -171,19 +171,19 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
 	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
 }
 
-static inline int is_pae(struct kvm_vcpu *vcpu)
+static inline bool is_pae(struct kvm_vcpu *vcpu)
 {
-	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
+	return kvm_is_cr4_bit_set(vcpu, X86_CR4_PAE);
 }
 
-static inline int is_pse(struct kvm_vcpu *vcpu)
+static inline bool is_pse(struct kvm_vcpu *vcpu)
 {
-	return kvm_read_cr4_bits(vcpu, X86_CR4_PSE);
+	return kvm_is_cr4_bit_set(vcpu, X86_CR4_PSE);
 }
 
-static inline int is_paging(struct kvm_vcpu *vcpu)
+static inline bool is_paging(struct kvm_vcpu *vcpu)
 {
-	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
+	return likely(kvm_is_cr0_bit_set(vcpu, X86_CR0_PG));
 }
 
 static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
@@ -193,7 +193,7 @@ static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
 
 static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 {
-	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
+	return kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 57 : 48;
 }
 
 static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
-- 
2.25.1

