Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2A0624333
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiKJN3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiKJN3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:29:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85622B37
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668086943; x=1699622943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=enj4tN9io3koc4YxJUdQESrY3PZRj8EaFGLOmQnT/Ik=;
  b=FQp20qCBcv5Wf89Q5qp7gav5ygc21/iZnaZk/GgN8wy4oU8xjG0NlI4s
   07o/jRte5f94MxO9ZrbvU0ZT2Mp0pku7AJ7Uwwl4ql+mdhw0bkpXY3AGa
   dXajgjNSP/Zh9V2/xOCfG9LSglvgqQv4fQ4VWffgcIA97djquJ5UYaxJU
   BJqqd0xe0eJIOESXyqD6ay1frnDG34AQoYJFEikdH2I4lM2cBEtRhab9y
   11tXRn3Q6Z7OiqoyshU5PfIZW8FP2v/vspFmcz2DwpWb/bOCT/vYHQQhA
   a1D1ULqWrESDhGKEuJDLLNomWFlYAkw1BsTj5ksJ/YEqDVfkaqlf7jbID
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311306314"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="311306314"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 05:29:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="812038305"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="812038305"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2022 05:29:01 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables to be more readable
Date:   Thu, 10 Nov 2022 21:28:40 +0800
Message-Id: <20221110132848.330793-2-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221110132848.330793-1-robert.hu@linux.intel.com>
References: <20221110132848.330793-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 7551b6f9c31c..ebb318433171 100644
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
@@ -666,7 +666,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr3;
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
-	unsigned long cr4_guest_rsvd_bits;
+	unsigned long cr4_host_rsvd_bits;
 	unsigned long cr8;
 	u32 host_pkru;
 	u32 pkru;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7065462378e2..02baeb936974 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -352,8 +352,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	kvm_pmu_refresh(vcpu);
-	vcpu->arch.cr4_guest_rsvd_bits =
-	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
+	vcpu->arch.cr4_host_rsvd_bits =
+	    __cr4_calc_reserved_bits(guest_cpuid_has, vcpu);
 
 	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
 						    vcpu->arch.cpuid_nent));
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..45f887cfbb89 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4246,7 +4246,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 	struct kvm_vcpu *vcpu = &vmx->vcpu;
 
 	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
-					  ~vcpu->arch.cr4_guest_rsvd_bits;
+					  ~vcpu->arch.cr4_host_rsvd_bits;
 	if (!enable_ept) {
 		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_TLBFLUSH_BITS;
 		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PDPTR_BITS;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cf1ba865562..c608df1d1a20 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -108,7 +108,7 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+static u64 __read_mostly cr4_kvm_reserved_bits = CR4_HOST_RESERVED_BITS;
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -1096,10 +1096,10 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	if (cr4 & cr4_reserved_bits)
+	if (cr4 & cr4_kvm_reserved_bits)
 		return false;
 
-	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
+	if (cr4 & vcpu->arch.cr4_host_rsvd_bits)
 		return false;
 
 	return true;
@@ -12260,7 +12260,7 @@ int kvm_arch_hardware_setup(void *opaque)
 		kvm_caps.supported_xss = 0;
 
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
-	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
+	cr4_kvm_reserved_bits = __cr4_calc_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has
 
 	if (kvm_caps.has_tsc_control) {
@@ -12293,8 +12293,8 @@ int kvm_arch_check_processor_compat(void *opaque)
 
 	WARN_ON(!irqs_disabled());
 
-	if (__cr4_reserved_bits(cpu_has, c) !=
-	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
+	if (__cr4_calc_reserved_bits(cpu_has, c) !=
+	    __cr4_calc_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
 	return ops->check_processor_compatibility();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 829d3134c1eb..d92e580768e5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -452,9 +452,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
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

