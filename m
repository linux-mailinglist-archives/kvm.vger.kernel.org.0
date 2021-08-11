Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691903E8E19
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhHKKIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:08:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:49605 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237003AbhHKKHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 06:07:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="215083948"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="215083948"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:26 -0700
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="484785741"
Received: from chenyi-pc.sh.intel.com ([10.239.159.88])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:23 -0700
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
Subject: [PATCH v5 6/7] KVM: VMX: Expose PKS to guest
Date:   Wed, 11 Aug 2021 18:11:25 +0800
Message-Id: <20210811101126.8973-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210811101126.8973-1-chenyi.qiang@intel.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
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
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/vmx/capabilities.h |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          | 15 ++++++++++++---
 arch/x86/kvm/x86.h              |  2 ++
 5 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f31d19e851de..9abd9a4c2174 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -103,7 +103,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_PKS))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..dbee0d639db3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -458,7 +458,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-		F(SGX_LC) | F(BUS_LOCK_DETECT)
+		F(SGX_LC) | F(BUS_LOCK_DETECT) | 0 /*PKS*/
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4705ad55abb5..3f6122fd8f65 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -104,6 +104,12 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
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
index 0f3ca6a07a21..71f2aefd6454 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3218,7 +3218,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 
 		/*
-		 * SMEP/SMAP/PKU is disabled if CPU is in non-paging mode in
+		 * SMEP/SMAP/PKU/PKS is disabled if CPU is in non-paging mode in
 		 * hardware.  To emulate this behavior, SMEP/SMAP/PKU needs
 		 * to be manually disabled when guest switches to non-paging
 		 * mode.
@@ -3226,10 +3226,11 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
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
@@ -7311,6 +7312,14 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	/*
+	 * PKS is not yet implemented for shadow paging.
+	 * If not support VM_{ENTRY, EXIT}_LOAD_IA32_PKRS,
+	 * don't expose the PKS as well.
+	 */
+	if (enable_ept && cpu_has_load_ia32_pkrs())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PKS);
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f8aaf89e6dc5..a7040c6ef524 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -481,6 +481,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_PKS))		\
+		__reserved_bits |= X86_CR4_PKS;		\
 	__reserved_bits;                                \
 })
 
-- 
2.17.1

