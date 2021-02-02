Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDE30BA87
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 10:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhBBJC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 04:02:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:41952 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232865AbhBBJCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 04:02:24 -0500
IronPort-SDR: x454s37T8T9F6Pnyy1ZbZlh3G3vTWFYWh/34mRC3ETRnrdjuUGHuXJxJ4hiYWXEnhs+G0oP06X
 D+8f8AH0bXeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167929259"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="167929259"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:30 -0800
IronPort-SDR: kwcEYLKFwPjBtqXR8uk8B7RFBisPG9WX+3szRx4T/IPFtHLSg9X+tQdPG9U22w6OkYrl2FgYtN
 EtwvKqngfG9w==
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="479491983"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:01:28 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: X86: Expose bus lock debug exception to guest
Date:   Tue,  2 Feb 2021 17:04:33 +0800
Message-Id: <20210202090433.13441-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202090433.13441-1-chenyi.qiang@intel.com>
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
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
index 13036cf0b912..ea7c593794d2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -402,7 +402,8 @@ void kvm_set_cpu_caps(void)
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
index ae79284e6199..e1d2b5db1179 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -147,6 +147,9 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
 	RTIT_STATUS_BYTECNT))
 
+#define MSR_VMX_SUPPORTED_DEBUGCTL (DEBUGCTLMSR_LBR | \
+	DEBUGCTLMSR_BTF | DEBUGCTLMSR_BUS_LOCK_DETECT)
+
 /*
  * List of MSRs that can be directly passed to the guest.
  * In addition to these x2apic and PT MSRs are handled specially.
@@ -1924,6 +1927,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			return 1;
 		goto find_uret_msr;
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2002,9 +2008,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
+				vcpu_unimpl(vcpu, "%s: BTF|LBR in IA32_DEBUGCTLMSR 0x%llx, nop\n",
+					    __func__, data);
+			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
+		}
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		return 0;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e149cb2c921c..0e66acffa2e9 100644
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
@@ -3071,18 +3072,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3355,7 +3344,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr_info->index) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
-	case MSR_IA32_DEBUGCTLMSR:
 	case MSR_IA32_LASTBRANCHFROMIP:
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5ce0f1..f13aa386e536 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -296,6 +296,8 @@ extern int pi_inject_timer;
 
 extern struct static_key kvm_no_apic_vcpu;
 
+extern bool report_ignored_msrs;
+
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,
-- 
2.17.1

