Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939FC23E982
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgHGIrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:47:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:65145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgHGIrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:47:00 -0400
IronPort-SDR: 0nNg/aw53gbd0EWiDBM7Td/7+PLLkwOee+81LN7SpqCMX/AJntqW1CcsYIY+DDbHjmiQ0ME8vV
 U7R1DrtU2yfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="214565745"
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="214565745"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 01:46:59 -0700
IronPort-SDR: EbP2cn4kDI7hNdvb6jw1cq2EB3jhiRWgFGYYqA/a+Flv6RgFn3ZkEx0SCrx8ZwlojzUs0lQbmP
 fGmGt1eog6LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="307317194"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2020 01:46:56 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 6/7] KVM: X86: Expose PKS to guest and userspace
Date:   Fri,  7 Aug 2020 16:48:40 +0800
Message-Id: <20200807084841.7112-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807084841.7112-1-chenyi.qiang@intel.com>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Existence of PKS is enumerated via CPUID.(EAX=7H,ECX=0):ECX[31]. It is
enabled by setting CR4.PKS when long mode is active. PKS is only
implemented when EPT is enabled and requires the support of VM_{ENTRY,
EXIT}_LOAD_IA32_PKRS currently.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            |  3 ++-
 arch/x86/kvm/vmx/vmx.c          | 15 ++++++++++++---
 arch/x86/kvm/x86.c              |  7 +++++--
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 736e56e023d5..36c7356693c8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -99,7 +99,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_PKS))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9747aa..897749250afd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -325,7 +325,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		0 /*PKS*/
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d91d59fb46fa..5cdf4d3848fb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3216,7 +3216,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 
 		/*
-		 * SMEP/SMAP/PKU is disabled if CPU is in non-paging mode in
+		 * SMEP/SMAP/PKU/PKS is disabled if CPU is in non-paging mode in
 		 * hardware.  To emulate this behavior, SMEP/SMAP/PKU needs
 		 * to be manually disabled when guest switches to non-paging
 		 * mode.
@@ -3224,10 +3224,11 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
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
@@ -7348,6 +7349,14 @@ static __init void vmx_set_cpu_caps(void)
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
 
+	/*
+	 * PKS is not yet implemented for shadow paging.
+	 * If not support VM_{ENTRY, EXIT}_LOAD_IA32_PKRS,
+	 * don't expose the PKS as well.
+	 */
+	if (enable_ept && cpu_has_load_ia32_pkrs())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PKS);
+
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..8ad9622ee2b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -949,6 +949,8 @@ EXPORT_SYMBOL_GPL(kvm_set_xcr);
 		__reserved_bits |= X86_CR4_LA57;	\
 	if (!__cpu_has(__c, X86_FEATURE_UMIP))		\
 		__reserved_bits |= X86_CR4_UMIP;	\
+	if (!__cpu_has(__c, X86_FEATURE_PKS))		\
+		__reserved_bits |= X86_CR4_PKS;		\
 	__reserved_bits;				\
 })
 
@@ -967,7 +969,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
-				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE |
+				   X86_CR4_PKS;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
@@ -1202,7 +1205,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
-	MSR_IA32_UMWAIT_CONTROL,
+	MSR_IA32_UMWAIT_CONTROL, MSR_IA32_PKRS,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
-- 
2.17.1

