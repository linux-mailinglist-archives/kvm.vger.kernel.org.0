Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D272105B5
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgGAIEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:04:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:2458 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728643AbgGAIEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 04:04:37 -0400
IronPort-SDR: zx6TwUhaiKdaLIxfxEZe1mU4TzDmrfkmsq7sRakjMYMna8uw9Lb7alEw/3GVMVOzkO73bGIOsp
 ue5E3EefwiRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="145581978"
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="145581978"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 01:04:36 -0700
IronPort-SDR: Q9FhKmkDmusvJ3qohagPB+NSn5Zy1xo2na6n0+6+Mac5BoRqWSbk7wWMT4+8MHngdC9AofVBA6
 2ME9duFZtpXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="455010371"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 01:04:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v13 11/11] KVM: x86: Enable CET virtualization and advertise CET to userspace
Date:   Wed,  1 Jul 2020 16:04:11 +0800
Message-Id: <20200701080411.5802-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200701080411.5802-1-weijiang.yang@intel.com>
References: <20200701080411.5802-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the feature bits so that CET capabilities can be seen in guest via
CPUID enumeration. Add CR4.CET bit support in order to allow guest set CET
master control bit(CR4.CET).

Disable KVM CET feature once unrestricted_guest is turned off because
KVM cannot emulate guest CET behavior well in this case.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/cpuid.c            | 5 +++--
 arch/x86/kvm/vmx/vmx.c          | 5 +++++
 arch/x86/kvm/x86.c              | 5 +++++
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f68c825e94ad..21f3c89d8c70 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -95,7 +95,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 984ab2b395b3..333a9e0d7cdf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -344,7 +344,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		F(SHSTK)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
@@ -353,7 +354,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
+		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) | F(IBT)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 70cb2d4a1391..7dac5747adc8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7411,6 +7411,11 @@ static __init void vmx_set_cpu_caps(void)
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+
+	if (!enable_unrestricted_guest) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 94ca5b56d233..a4cf5f3211f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9707,6 +9707,11 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = host_xss & KVM_SUPPORTED_XSS;
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		supported_xss &= ~(XFEATURE_MASK_CET_USER |
+				   XFEATURE_MASK_CET_KERNEL);
+
 	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
 
 	if (kvm_has_tsc_control) {
-- 
2.17.2

