Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF278600739
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJQHFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiJQHF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:05:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ADD2E6A6
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665990326; x=1697526326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JZ0Wik+LCEwumjlrsLRjoMFh4E/OTHqRJyHJYoqp/Ug=;
  b=XKpB+hLt2A7sn0bjsuw5yxNPz+qYc6Gfs+h9SFAq/U95VTs+lT/6Zr4V
   kWy8XC9aol6WrPPo6iGFSsjaiHShGLdAFchOk5of1SAAApxiD35cqGdmW
   Rew228xF3VFCDH3LtoXTv5ttsQ6PrpBFJ0KaGO1+RWuswiH4Qm0DidwAo
   DqDui7gaKjN2u4BD6SwCC4BsxqTV/Pw5xKTTMJos0KjC29ni/NdGuw4fm
   iiIy2Neyl9qLUK0y5P/UNT3aA6NcwFcxhuxYxaY09VQHytoHucJ0neVSx
   hcqAQ3DqjI+WkrQw2d4qgZXl5ZA11uob6KyN5mllvN40iSVX1fHDPB3DT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="306805985"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="306805985"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 00:05:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="579271366"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="579271366"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 17 Oct 2022 00:05:14 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables to be more readable
Date:   Mon, 17 Oct 2022 15:04:42 +0800
Message-Id: <20221017070450.23031-2-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017070450.23031-1-robert.hu@linux.intel.com>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vcpu_arch::cr4_guest_owned_bits and kvm_vcpu_arch::cr4_guest_rsvd_bits
looks confusing. Rename latter to cr4_host_rsvd_bits, because it in fact
decribes the effective host reserved cr4 bits from the vcpu's perspective.

Meanwhile, rename other related variables/macros to be better descriptive:
* CR4_RESERVED_BITS --> CR4_HOST_RESERVED_BITS, which describes host bare
metal CR4 reserved bits.

* cr4_reserved_bits --> cr4_kvm_reserved_bits, which describes
CR4_HOST_RESERVED_BITS + !kvm_cap_has() = kvm level cr4 reserved bits.

* __cr4_reserved_bits() --> __cr4_calc_reserved_bits(), which to calc
effective cr4 reserved bits for kvm or vm level, by corresponding
x_cpu_has() input.

Thus, by these renames, the hierarchical relations of those reserved CR4
bits is more clear.

Just renames, no functional changes intended.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/cpuid.c            |  4 ++--
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              | 12 ++++++------
 arch/x86/kvm/x86.h              |  4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ffa578cafe1..4858436c64ef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -114,7 +114,7 @@
 			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
 			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
 
-#define CR4_RESERVED_BITS                                               \
+#define CR4_HOST_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
 			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE     \
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
@@ -654,7 +654,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr3;
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
-	unsigned long cr4_guest_rsvd_bits;
+	unsigned long cr4_host_rsvd_bits;
 	unsigned long cr8;
 	u32 host_pkru;
 	u32 pkru;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..b935b3b04a7e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -338,8 +338,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	kvm_pmu_refresh(vcpu);
-	vcpu->arch.cr4_guest_rsvd_bits =
-	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
+	vcpu->arch.cr4_host_rsvd_bits =
+	    __cr4_calc_reserved_bits(guest_cpuid_has, vcpu);
 
 	kvm_hv_set_cpuid(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..97a2b8759ce8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4294,7 +4294,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 	struct kvm_vcpu *vcpu = &vmx->vcpu;
 
 	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
-					  ~vcpu->arch.cr4_guest_rsvd_bits;
+					  ~vcpu->arch.cr4_host_rsvd_bits;
 	if (!enable_ept) {
 		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_TLBFLUSH_BITS;
 		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PDPTR_BITS;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..05a40ab7cda2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -108,7 +108,7 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+static u64 __read_mostly cr4_kvm_reserved_bits = CR4_HOST_RESERVED_BITS;
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -1082,10 +1082,10 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	if (cr4 & cr4_reserved_bits)
+	if (cr4 & cr4_kvm_reserved_bits)
 		return false;
 
-	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
+	if (cr4 & vcpu->arch.cr4_host_rsvd_bits)
 		return false;
 
 	return true;
@@ -11965,7 +11965,7 @@ int kvm_arch_hardware_setup(void *opaque)
 		kvm_caps.supported_xss = 0;
 
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
-	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
+	cr4_kvm_reserved_bits = __cr4_calc_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has
 
 	if (kvm_caps.has_tsc_control) {
@@ -11998,8 +11998,8 @@ int kvm_arch_check_processor_compat(void *opaque)
 
 	WARN_ON(!irqs_disabled());
 
-	if (__cr4_reserved_bits(cpu_has, c) !=
-	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
+	if (__cr4_calc_reserved_bits(cpu_has, c) !=
+	    __cr4_calc_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
 	return ops->check_processor_compatibility();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1926d2cb8e79..4473bc0ba0f1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -448,9 +448,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 #define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
 #define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
 
-#define __cr4_reserved_bits(__cpu_has, __c)             \
+#define __cr4_calc_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
-	u64 __reserved_bits = CR4_RESERVED_BITS;        \
+	u64 __reserved_bits = CR4_HOST_RESERVED_BITS;        \
                                                         \
 	if (!__cpu_has(__c, X86_FEATURE_XSAVE))         \
 		__reserved_bits |= X86_CR4_OSXSAVE;     \
-- 
2.31.1

