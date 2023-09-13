Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FBC79ED77
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjIMPl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjIMPkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10EA2D56;
        Wed, 13 Sep 2023 08:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619623; x=1726155623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lQkspbDuqphHdB9g7gzKe+gyb4W+KAIZCILJpxO1HFE=;
  b=BQSPhvKTgmPt89kHdyw3HObac4U/X5oB9jbu3cccOaUtALowDhRKP39J
   qiYylo1jBcgwq9/UHJU9dBvtwo0VuuELfZW9sTDbJNVrCDg2wBIWyhibB
   QhciT1c8WPP799tDQ4/RFsrkbS4Z2Dwmz+pWIX3wH63s+VdxwRYRiajIB
   +h7WebvObEhMCZKBMiavcZdydfWXtPYp1jCXR3q6FTYAuibrkwQPeggm/
   +92GkXCu2iyS+LSUA/bOdRaC2cmL0fSatanNkKqidwHpc91dLeSxpxiW6
   RxcSYmu4XplZvjJJz1/o0+VAErBMe1+u1VwNNqkxWfiz1V1Cw4H8RrV5Q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030306"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030306"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852272"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852272"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:20 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 15/16] KVM: VMX: Virtualize LASS
Date:   Wed, 13 Sep 2023 20:42:26 +0800
Message-Id: <20230913124227.12574-16-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zeng Guang <guang.zeng@intel.com>

Virtualize CR4.LASS and implement LASS violation check to achieve the
mode-based protection in VMX.

Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
as CR4.LASS generally set once for each vCPU at boot time and won't be
toggled at runtime. Meanwhile only if VM has LASS capability enumerated
with CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to
be able to set CR4.LASS. Updating cr4_fixed1 to set CR4.LASS bit in the
emulated IA32_VMX_CR4_FIXED1 MSR for guests and allow guests to enable
LASS in nested VMX operation. It's noteworthy that setting CR4.LASS bit
enables LASS only in IA-32e mode and won't effectuate in legacy mode.

LASS violation check takes effect in KVM emulation of instruction fetch and
data access including implicit access when vCPU is running in long mode, and
also involved in emulation of VMX instruction and SGX ENCLS instruction to
enforce the mode-based protections before paging.

Linear addresses used for TLB invalidation (INVPLG, INVPCID, and INVVPID) and
branch targets are not subject to LASS enforcement.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       |  5 ++--
 arch/x86/kvm/vmx/sgx.c          |  3 +-
 arch/x86/kvm/vmx/vmx.c          | 50 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  3 ++
 arch/x86/kvm/x86.c              |  2 +-
 arch/x86/kvm/x86.h              |  2 ++
 7 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e73fc45c8e6..2972fde1ad9e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -126,7 +126,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP))
+			  | X86_CR4_LASS | X86_CR4_LAM_SUP))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4ba46e1b29d2..821763335cf6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4985,7 +4985,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 * non-canonical form. This is the only check on the memory
 		 * destination for long mode!
 		 */
-		exn = is_noncanonical_address(*ret, vcpu);
+		exn = is_noncanonical_address(*ret, vcpu) ||
+		      vmx_is_lass_violation(vcpu, *ret, len, 0);
 	} else {
 		/*
 		 * When not in long mode, the virtual/linear address is
@@ -5799,7 +5800,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	switch (type) {
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
 		/*
-		 * LAM doesn't apply to addresses that are inputs to TLB
+		 * LAM  and LASS don't apply to addresses that are inputs to TLB
 		 * invalidation.
 		 */
 		if (!operand.vpid ||
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6fef01e0536e..ac70da799df9 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -38,7 +38,8 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 		fault = true;
 	} else if (likely(is_64_bit_mode(vcpu))) {
 		*gva = vmx_get_untagged_addr(vcpu, *gva, 0);
-		fault = is_noncanonical_address(*gva, vcpu);
+		fault = is_noncanonical_address(*gva, vcpu) ||
+			vmx_is_lass_violation(vcpu, *gva, size, 0);
 	} else {
 		*gva &= 0xffffffff;
 		fault = (s.unusable) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3bdeebee71cc..aa2949cd547b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7680,6 +7680,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
+	cr4_fixed1_update(X86_CR4_LASS,       eax, feature_bit(LASS));
 
 #undef cr4_fixed1_update
 }
@@ -8259,6 +8260,53 @@ gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags
 	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
 }
 
+bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
+			   unsigned int size, unsigned int flags)
+{
+	const bool is_supervisor_address = !!(addr & BIT_ULL(63));
+	const bool implicit_supervisor = !!(flags & X86EMUL_F_IMPLICIT);
+	const bool fetch = !!(flags & X86EMUL_F_FETCH);
+
+	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
+		return false;
+
+	/*
+	 * INVLPG isn't subject to LASS, e.g. to allow invalidating userspace
+	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
+	 * to LASS in order to simplify far control transfers (the subsequent
+	 * fetch will enforce LASS as appropriate).
+	 */
+	if (flags & (X86EMUL_F_BRANCH | X86EMUL_F_INVLPG))
+		return false;
+
+	if (!implicit_supervisor && vmx_get_cpl(vcpu) == 3)
+		return is_supervisor_address;
+
+	/*
+	 * LASS enforcement for supervisor-mode data accesses depends on SMAP
+	 * being enabled, and like SMAP ignores explicit accesses if RFLAGS.AC=1.
+	 */
+	if (!fetch) {
+		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
+			return false;
+
+		if (!implicit_supervisor && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
+			return false;
+	}
+
+	/*
+	 * The entire access must be in the appropriate address space.  Note,
+	 * if LAM is supported, @addr has already been untagged, so barring a
+	 * massive architecture change to expand the canonical address range,
+	 * it's impossible for a user access to straddle user and supervisor
+	 * address spaces.
+	 */
+	if (size && !((addr + size - 1) & BIT_ULL(63)))
+		return true;
+
+	return !is_supervisor_address;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8401,6 +8449,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
+
+	.is_lass_violation = vmx_is_lass_violation,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 45cee1a8bc0a..4cafe99a2d94 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -422,6 +422,9 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
+bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
+			   unsigned int size, unsigned int flags);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58d7a9241630..49fc73205720 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13407,7 +13407,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 	switch (type) {
 	case INVPCID_TYPE_INDIV_ADDR:
 		/*
-		 * LAM doesn't apply to addresses that are inputs to TLB
+		 * LAM  and LASS don't apply to addresses that are inputs to TLB
 		 * invalidation.
 		 */
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 53e883721e71..6c766fe1301c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -531,6 +531,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_PCIDE;       \
 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
 		__reserved_bits |= X86_CR4_LAM_SUP;     \
+	if (!__cpu_has(__c, X86_FEATURE_LASS))          \
+		__reserved_bits |= X86_CR4_LASS;        \
 	__reserved_bits;                                \
 })
 
-- 
2.25.1

