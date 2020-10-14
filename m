Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6554728D843
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 04:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgJNCKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 22:10:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:51174 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbgJNCKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 22:10:01 -0400
IronPort-SDR: BZblanSwME/7jTFl6Tz/igQzS20lgiAUFEJvRipXk7uKteZjRaTnQ1fyGeAkwIbmhEHtlNkwNB
 mEK4dbpIPzCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="227659807"
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="227659807"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 19:10:00 -0700
IronPort-SDR: +aJTM1QzuTVvNMJY54TL+nNVgfHrDtg4oMMsDW6FFLVP9/QQzMUBgtcAuaeWU50YfdvIObwFgV
 pMy2Q3u4yWbg==
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="530645177"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 19:09:58 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 6/7] KVM: X86: Expose PKS to guest and userspace
Date:   Wed, 14 Oct 2020 10:11:55 +0800
Message-Id: <20201014021157.18022-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201014021157.18022-1-chenyi.qiang@intel.com>
References: <20201014021157.18022-1-chenyi.qiang@intel.com>
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
 arch/x86/kvm/x86.c              |  9 +++++++--
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d5f0c3a71a41..d798433a2117 100644
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
index 3fd6eec202d7..6b725a3e84ec 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -354,7 +354,8 @@ void kvm_set_cpu_caps(void)
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
index e5da5dbe19d4..ce24226e1aa3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3228,7 +3228,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 
 		/*
-		 * SMEP/SMAP/PKU is disabled if CPU is in non-paging mode in
+		 * SMEP/SMAP/PKU/PKS is disabled if CPU is in non-paging mode in
 		 * hardware.  To emulate this behavior, SMEP/SMAP/PKU needs
 		 * to be manually disabled when guest switches to non-paging
 		 * mode.
@@ -3236,10 +3236,11 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
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
@@ -7430,6 +7431,14 @@ static __init void vmx_set_cpu_caps(void)
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
index ce856e0ece84..93ac708e951d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -976,7 +976,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP;
-	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE;
+	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE |
+				      X86_CR4_PKS;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
@@ -1207,7 +1208,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
-	MSR_IA32_UMWAIT_CONTROL,
+	MSR_IA32_UMWAIT_CONTROL, MSR_IA32_PKRS,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
@@ -5426,6 +5427,10 @@ static void kvm_init_msr_list(void)
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
+		case MSR_IA32_PKRS:
+			if (!kvm_cpu_cap_has(X86_FEATURE_PKS))
+				continue;
+			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
-- 
2.17.1

