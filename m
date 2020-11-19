Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9F02B8EBD
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 10:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKSJ1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 04:27:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:20996 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgKSJ1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 04:27:36 -0500
IronPort-SDR: MW4bnOO/fowApGMP2TERTjexBwlcu6Vjtr9r0D39RfokY4/vK0qVzlc7OtQZrUQN1YTQp2Cvsb
 LLxw4Hsd4F6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="168688344"
X-IronPort-AV: E=Sophos;i="5.77,490,1596524400"; 
   d="scan'208";a="168688344"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 01:27:35 -0800
IronPort-SDR: KnF1QdY/oWiW6VSL5ssbuuymr18kICIFN4xQbhSzAh/yU0zbOo1CCSWGjo4+ChU3+mH6S9/+Lz
 BtHHmkdmkBUg==
X-IronPort-AV: E=Sophos;i="5.77,490,1596524400"; 
   d="scan'208";a="544939816"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 01:27:33 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] KVM: X86: Expose bus lock debug exception to guest
Date:   Thu, 19 Nov 2020 17:29:57 +0800
Message-Id: <20201119092957.16940-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119092957.16940-1-chenyi.qiang@intel.com>
References: <20201119092957.16940-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bus lock debug exception is an ability to notify the kernel by an #DB
trap after the instruction acquires a bus lock and is executed when
CPL>0. This allows the kernel to enforce user application throttling or
mitigations.

Existence of bus lock debug exception is enumerated via
CPUID.(EAX=7,ECX=0).ECX[24]. Software can enable these exceptions by
setting bit 2 of the MSR_IA32_DEBUGCTL. Expose the CPUID to guest and
emulate the MSR handling when guest enables it.

Since SVM already has specific handlers of MSR_IA32_DEBUGMSR in the
svm_get/set_msr, move x86 commmon part to VMX and add the bus lock debug
exception support.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/cpuid.c   |  3 ++-
 arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++--
 arch/x86/kvm/x86.c     | 16 ++--------------
 arch/x86/kvm/x86.h     |  2 ++
 4 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 83637a2ff605..af4feb0ec178 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -401,7 +401,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		F(BUS_LOCK_DETECT)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 892340b031cb..9d6deca79345 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -148,6 +148,9 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
 	RTIT_STATUS_BYTECNT))
 
+#define MSR_VMX_SUPPORTED_DEBUGCTL (DEBUGCTLMSR_LBR | \
+	DEBUGCTLMSR_BTF | DEBUGCTLMSR_BUS_LOCK_DETECT)
+
 /*
  * List of MSRs that can be directly passed to the guest.
  * In addition to these x2apic and PT MSRs are handled specially.
@@ -1925,6 +1928,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			return 1;
 		goto find_uret_msr;
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2003,9 +2009,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
-		ret = kvm_set_msr_common(vcpu, msr_info);
-		break;
+		if (data & ~MSR_VMX_SUPPORTED_DEBUGCTL)
+			return 1;
 
+		if (!msr_info->host_initiated &&
+		    (data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+			return 1;
+
+		if (data & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
+			if (report_ignored_msrs)
+				vcpu_unimpl(vcpu, "%s: BTF|LBR in MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
+					    __func__, data);
+			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
+		}
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		return 0;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d506210f1f9..d547b70865b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -116,8 +116,9 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
 static bool __read_mostly ignore_msrs = 0;
 module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
-static bool __read_mostly report_ignored_msrs = true;
+bool __read_mostly report_ignored_msrs = true;
 module_param(report_ignored_msrs, bool, S_IRUGO | S_IWUSR);
+EXPORT_SYMBOL_GPL(report_ignored_msrs);
 
 unsigned int min_timer_period_us = 200;
 module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
@@ -3061,18 +3062,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case MSR_IA32_DEBUGCTLMSR:
-		if (!data) {
-			/* We support the non-activated case already */
-			break;
-		} else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
-			/* Values other than LBR and BTF are vendor-specific,
-			   thus reserved and should throw a #GP */
-			return 1;
-		} else if (report_ignored_msrs)
-			vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-				    __func__, data);
-		break;
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
@@ -3345,7 +3334,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr_info->index) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
-	case MSR_IA32_DEBUGCTLMSR:
 	case MSR_IA32_LASTBRANCHFROMIP:
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e7ca622a468f..6e7fa5b0a216 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -294,6 +294,8 @@ extern int pi_inject_timer;
 
 extern struct static_key kvm_no_apic_vcpu;
 
+extern bool report_ignored_msrs;
+
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,
-- 
2.17.1

