Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B207D12B070
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 03:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfL0CHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 21:07:35 -0500
Received: from mga17.intel.com ([192.55.52.151]:38924 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbfL0CHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 21:07:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 18:07:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,361,1571727600"; 
   d="scan'208";a="223675053"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 26 Dec 2019 18:07:34 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 7/7] KVM: X86: Add user-space access interface for CET MSRs
Date:   Fri, 27 Dec 2019 10:11:33 +0800
Message-Id: <20191227021133.11993-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191227021133.11993-1-weijiang.yang@intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There're two different places storing Guest CET states, states
managed with XSAVES/XRSTORS, as restored/saved
in previous patch, can be read/write directly from/to the MSRs.
For those stored in VMCS fields, they're access via vmcs_read/
vmcs_write.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/cpuid.c            |   5 +-
 arch/x86/kvm/vmx/vmx.c          | 138 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  11 +++
 4 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 64bf379381e4..34140462084f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -90,7 +90,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 126a31b99823..4414bd110f3c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -385,13 +385,14 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SHSTK) |
+		0 /*WAITPKG*/;
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR);
+		F(MD_CLEAR) | F(IBT);
 
 	/* cpuid 7.1.eax */
 	const u32 kvm_cpuid_7_1_eax_x86_features =
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0a75b65d03f0..52ac67604026 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1763,6 +1763,96 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	return 0;
 }
 
+#define CET_MSR_RSVD_BITS_1    0x3
+#define CET_MSR_RSVD_BITS_2   (0xF << 6)
+
+static bool cet_ssp_write_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	u64 data = msr->data;
+	u32 high_word = data >> 32;
+
+	if (is_64_bit_mode(vcpu)) {
+		if (data & CET_MSR_RSVD_BITS_1)
+			return false;
+	} else if (high_word) {
+		return false;
+	}
+
+	return true;
+}
+
+static bool cet_ctl_write_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	u64 data = msr->data;
+	u32 high_word = data >> 32;
+
+	if (data & CET_MSR_RSVD_BITS_2)
+		return false;
+
+	if (!is_64_bit_mode(vcpu) && high_word)
+		return false;
+
+	return true;
+}
+
+static bool cet_ssp_access_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	u64 kvm_xss;
+	u32 index = msr->index;
+
+	if (is_guest_mode(vcpu))
+		return false;
+
+	if (!boot_cpu_has(X86_FEATURE_SHSTK))
+		return false;
+
+	if (!msr->host_initiated &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+		return false;
+
+	if (index == MSR_IA32_INT_SSP_TAB)
+		return true;
+
+	kvm_xss = kvm_supported_xss();
+
+	if (index == MSR_IA32_PL3_SSP) {
+		if (!(kvm_xss & XFEATURE_MASK_CET_USER))
+			return false;
+	} else if (!(kvm_xss & XFEATURE_MASK_CET_KERNEL)) {
+		return false;
+	}
+
+	return true;
+}
+
+static bool cet_ctl_access_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	u64 kvm_xss;
+	u32 index = msr->index;
+
+	if (is_guest_mode(vcpu))
+		return false;
+
+	kvm_xss = kvm_supported_xss();
+
+	if (!boot_cpu_has(X86_FEATURE_SHSTK) &&
+	    !boot_cpu_has(X86_FEATURE_IBT))
+		return false;
+
+	if (!msr->host_initiated &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+		return false;
+
+	if (index == MSR_IA32_U_CET) {
+		if (!(kvm_xss & XFEATURE_MASK_CET_USER))
+			return false;
+	} else if (!(kvm_xss & XFEATURE_MASK_CET_KERNEL)) {
+		return false;
+	}
+
+	return true;
+}
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1886,6 +1976,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+		if (!cet_ctl_access_allowed(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_ssp_access_allowed(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
+	case MSR_IA32_U_CET:
+		if (!cet_ctl_access_allowed(vcpu, msr_info))
+			return 1;
+		rdmsrl(MSR_IA32_U_CET, msr_info->data);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_ssp_access_allowed(vcpu, msr_info))
+			return 1;
+		rdmsrl(msr_info->index, msr_info->data);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2147,6 +2257,34 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+		if (!cet_ctl_access_allowed(vcpu, msr_info))
+			return 1;
+		if (!cet_ctl_write_allowed(vcpu, msr_info))
+			return 1;
+		vmcs_writel(GUEST_S_CET, data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_ctl_access_allowed(vcpu, msr_info))
+			return 1;
+		if (!is_64_bit_mode(vcpu))
+			return 1;
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
+	case MSR_IA32_U_CET:
+		if (!cet_ctl_access_allowed(vcpu, msr_info))
+			return 1;
+		if (!cet_ctl_write_allowed(vcpu, msr_info))
+			return 1;
+		wrmsrl(MSR_IA32_U_CET, data);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_ssp_access_allowed(vcpu, msr_info))
+			return 1;
+		if (!cet_ssp_write_allowed(vcpu, msr_info))
+			return 1;
+		wrmsrl(msr_info->index, data);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6dbe77365b22..7de6faa6aa51 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1186,6 +1186,10 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_IA32_XSS, MSR_IA32_U_CET, MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -1468,6 +1472,13 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * invokes 64-bit SYSENTER.
 		 */
 		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_IA32_INT_SSP_TAB:
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
 	}
 
 	msr.data = data;
-- 
2.17.2

