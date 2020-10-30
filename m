Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A29629FC5A
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 04:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgJ3D4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 23:56:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:4238 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3D4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 23:56:40 -0400
IronPort-SDR: DNDlacXL2VS4RFJZ50Ngw+icid+V5IwIvgjKug3z4/kWW9kopNt6CFPwuL+1s2dzQ/hKPyy32a
 C8TvSHw/OA0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168685725"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="168685725"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 20:56:39 -0700
IronPort-SDR: Fd42gcGrJKxz9F3FkhPrRZTMExA3gHXJ3sGlRNmPOc2nQO9jQPviiZnFYuwR/mWVYidTTeo5fe
 bEMUd9GyTY0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525770385"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 20:56:36 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v13 01/10] KVM: x86: Move common set/get handler of MSR_IA32_DEBUGCTLMSR to VMX
Date:   Fri, 30 Oct 2020 11:52:11 +0800
Message-Id: <20201030035220.102403-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201030035220.102403-1-like.xu@linux.intel.com>
References: <20201030035220.102403-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM already has specific handlers of MSR_IA32_DEBUGCTLMSR in the
svm_get/set_msr, so the x86 common part can be safely moved to VMX.

Add vmx_supported_debugctl() to refactor the throwing logic of #GP.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 19 ++++++++++++++++---
 arch/x86/kvm/x86.c              | 13 -------------
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3a1861403d73..a58cf3655351 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -378,4 +378,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 	return PMU_CAP_FW_WRITES;
 }
 
+static inline u64 vmx_supported_debugctl(void)
+{
+	return DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 281c405c7ea3..c12faeebd390 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1925,6 +1925,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			return 1;
 		goto find_uret_msr;
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = 0;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2003,9 +2006,19 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
-		ret = kvm_set_msr_common(vcpu, msr_info);
-		break;
-
+		if (!data) {
+			/* We support the non-activated case already */
+			return 0;
+		} else if (data & ~vmx_supported_debugctl()) {
+			/*
+			 * Values other than LBR and BTF are vendor-specific,
+			 * thus reserved and should throw a #GP.
+			 */
+			return 1;
+		}
+		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
+			    __func__, data);
+		return 0;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..021791991e05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3055,18 +3055,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
-		}
-		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-			    __func__, data);
-		break;
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
@@ -3339,7 +3327,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr_info->index) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
-	case MSR_IA32_DEBUGCTLMSR:
 	case MSR_IA32_LASTBRANCHFROMIP:
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
-- 
2.21.3

