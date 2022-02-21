Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE384BD7B8
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346875AbiBUIGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:06:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346838AbiBUIGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:06:23 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B500F26D3;
        Mon, 21 Feb 2022 00:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645430760; x=1676966760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=IlJxguNqHIPQjnVJydclxws1pKkJJZKKKyO9YoSyEk8=;
  b=GX8hEG6rFuSldShmPB+AYkBPdBC/PFn0+bsJvIDtbtZoyT36rkoHQq07
   Mc+jwAWUn8RrUi7oAzi4lSNO/ULoCGXtU89M9ZoZrmhlQoPZvZuDHOl2o
   Oi+hp3Q2evuHBMfRrR21D7XRKj8gG6H/aorAl1cYdSc9jky1hHuotP5WE
   8EDuCToeP++2EieJKc1uyaIm4BP9rbdqwcZPX68euab/QEtGlMeGRRI2v
   7EZAhzxf85x7pF9smSLQlPg/KULYqnYfeu+JQ/35RMRii2L2hL8ZCXXyD
   2WGY1z+JabAYTJMTLHiS9/FILy+nnO+gSaGd1F0ntn6K46bMj6kF/yEoc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="250277894"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="250277894"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="638472359"
Received: from unknown (HELO chenyi-pc.sh.intel.com) ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:53 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 6/7] KVM: VMX: Expose PKS to guest
Date:   Mon, 21 Feb 2022 16:08:39 +0800
Message-Id: <20220221080840.7369-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221080840.7369-1-chenyi.qiang@intel.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Existence of PKS is enumerated via CPUID.(EAX=7,ECX=0):ECX[31]. It is
enabled by setting CR4.PKS when long mode is active. PKS is only
implemented when EPT is enabled and requires the support of
VM_{ENTRY,EXIT}_LOAD_IA32_PKRS VMCS controls currently.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 13 +++++++++----
 arch/x86/kvm/vmx/capabilities.h |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          | 14 +++++++++++---
 arch/x86/kvm/x86.h              |  2 ++
 5 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c53efe0012e..4de4b9c617e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -114,7 +114,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_PKS))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28fb6cb..2457dadad7ef 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -547,18 +547,23 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-		F(SGX_LC) | F(BUS_LOCK_DETECT)
+		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(PKS)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
 		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
 	/*
-	 * PKU not yet implemented for shadow paging and requires OSPKE
-	 * to be set on the host. Clear it if that is not the case
+	 * Protection Keys are not supported for shadow paging.  PKU further
+	 * requires OSPKE to be set on the host in order to use {RD,WR}PKRU to
+	 * save/restore the guests PKRU.
 	 */
-	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
+	if (!tdp_enabled) {
 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
+		kvm_cpu_cap_clear(X86_FEATURE_PKS);
+	} else if (!boot_cpu_has(X86_FEATURE_OSPKE)) {
+		kvm_cpu_cap_clear(X86_FEATURE_PKU);
+	}
 
 	kvm_cpu_cap_mask(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 959b59d13b5a..ab1868a9c177 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -105,6 +105,12 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
+static inline bool cpu_has_load_ia32_pkrs(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PKRS) &&
+	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PKRS);
+}
+
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3d5412b9481..6fc70ddeff5a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3270,7 +3270,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 
 		/*
-		 * SMEP/SMAP/PKU is disabled if CPU is in non-paging mode in
+		 * SMEP/SMAP/PKU/PKS is disabled if CPU is in non-paging mode in
 		 * hardware.  To emulate this behavior, SMEP/SMAP/PKU needs
 		 * to be manually disabled when guest switches to non-paging
 		 * mode.
@@ -3278,10 +3278,11 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		 * If !enable_unrestricted_guest, the CPU is always running
 		 * with CR0.PG=1 and CR4 needs to be modified.
 		 * If enable_unrestricted_guest, the CPU automatically
-		 * disables SMEP/SMAP/PKU when the guest sets CR0.PG=0.
+		 * disables SMEP/SMAP/PKU/PKS when the guest sets CR0.PG=0.
 		 */
 		if (!is_paging(vcpu))
-			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
+			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE |
+				    X86_CR4_PKS);
 	}
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
@@ -7454,6 +7455,13 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	/*
+	 * If not support VM_{ENTRY, EXIT}_LOAD_IA32_PKRS,
+	 * don't expose the PKS as well.
+	 */
+	if (cpu_has_load_ia32_pkrs())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PKS);
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8b752cebbefc..8de5ea9f8e25 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -497,6 +497,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_PKS))		\
+		__reserved_bits |= X86_CR4_PKS;		\
 	__reserved_bits;                                \
 })
 
-- 
2.17.1

