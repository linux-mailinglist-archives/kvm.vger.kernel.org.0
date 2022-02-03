Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369144A8B59
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 19:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353327AbiBCSQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 13:16:03 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:12263 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353310AbiBCSQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 13:16:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1643912160; x=1675448160;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P04UnRBV76MpDpOOK6q6643kAlnLXt09lfQX/PkSX+E=;
  b=b5GAs4ypYj4piUVQuEYQ01A1DKTQs3KFxSBReYuERvIvozHkvwLILs28
   RUn82lsA9zDrVIa7mV/Jnouj0mbbaJtHgv72gIUH64ovMHuhC05PvxAZx
   gjTYAWJYDhaAj5fLJHg3mVOiYcR6DsLXDLP77uvbXqs+eEdXxIaBJQAig
   s=;
X-IronPort-AV: E=Sophos;i="5.88,340,1635206400"; 
   d="scan'208";a="175354490"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 03 Feb 2022 18:15:49 +0000
Received: from EX13D07EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id 75E19A28C2;
        Thu,  3 Feb 2022 18:15:45 +0000 (UTC)
Received: from dev-dsk-faresx-1b-818bcd8f.eu-west-1.amazon.com (10.43.160.132)
 by EX13D07EUA003.ant.amazon.com (10.43.165.176) with Microsoft SMTP Server
 (TLS) id 15.0.1497.28; Thu, 3 Feb 2022 18:15:39 +0000
From:   Fares Mehanna <faresx@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
        Fares Mehanna <faresx@amazon.de>
Subject: [PATCH] KVM: VMX: pass TME information to guests
Date:   Thu, 3 Feb 2022 18:14:32 +0000
Message-ID: <20220203181432.34911-1-faresx@amazon.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Originating-IP: [10.43.160.132]
X-ClientProxiedBy: EX13D11UWB001.ant.amazon.com (10.43.161.53) To
 EX13D07EUA003.ant.amazon.com (10.43.165.176)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guests running on IceLake have TME-EN disabled in CPUID, and they can't read TME
related MSRs [IA32_TME_CAPABILITY, IA32_TME_ACTIVATE, IA32_TME_EXCLUDE_MASK,
IA32_TME_EXCLUDE_BASE].

So guests don't know if they are running with TME enabled or not.

In this patch, TME information is passed to the guest if the host has `TME-EN`
enabled in CPUID and TME MSRs are locked and the exclusion range is disabled.

This will guarantee that hardware supports TME, MSRs are locked, so host can't
change them and exclusion range is disabled, so TME rules apply on all host
memory.

In IA32_TME_CAPABILITY and IA32_TME_ACTIVATE we mask out the reserved bits and
MKTME related bits.

So in IA32_TME_CAPABILITY, we are passing:
Bit[0]:  Support for AES-XTS 128-bit encryption algorithm
Bit[2]:  Support for AES-XTS 256-bit encryption algorithm
Bit[31]: TME encryption bypass supported

And in IA32_TME_ACTIVATE, we are passing:
Bit[0]:   Lock RO
Bit[1]:   TME Enable RWL
Bit[2]:   Key select
Bit[3]:   Save TME key for Standby
Bit[4:7]: Encryption Algorithm
Bit[31]:  TME Encryption Bypass Enable

However IA32_TME_EXCLUDE_MASK and IA32_TME_EXCLUDE_BASE are read by the guest as
zero, since we will only pass TME information if the exclusion range is
disabled.

Those information are helpful for the guest to determine if TME is enabled by
the BIOS or not.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
---
 arch/x86/include/asm/msr-index.h |  6 ++++++
 arch/x86/include/asm/processor.h | 14 ++++++++++++++
 arch/x86/kernel/cpu/intel.c      | 15 +--------------
 arch/x86/kvm/cpuid.c             | 19 ++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c           | 20 ++++++++++++++++++++
 5 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3faf0f97edb1..908aad1a7cad 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -438,6 +438,12 @@
 #define MSR_RELOAD_PMC0			0x000014c1
 #define MSR_RELOAD_FIXED_CTR0		0x00001309
 
+/* Memory encryption MSRs */
+#define MSR_IA32_TME_CAPABILITY		0x981
+#define MSR_IA32_TME_ACTIVATE		0x982
+#define MSR_IA32_TME_EXCLUDE_MASK	0x983
+#define MSR_IA32_TME_EXCLUDE_BASE	0x984
+
 /*
  * AMD64 MSRs. Not complete. See the architecture manual for a more
  * complete list.
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2c5f12ae7d04..28387ae7277b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -863,4 +863,18 @@ bool arch_is_platform_page(u64 paddr);
 #define arch_is_platform_page arch_is_platform_page
 #endif
 
+/* Helpers to access TME_ACTIVATE MSR */
+#define TME_ACTIVATE_LOCKED(x)		((x) & 0x1)
+#define TME_ACTIVATE_ENABLED(x)		((x) & 0x2)
+
+#define TME_ACTIVATE_POLICY(x)		(((x) >> 4) & 0xf)        /* Bits 7:4 */
+#define TME_ACTIVATE_POLICY_AES_XTS_128	0
+
+#define TME_ACTIVATE_KEYID_BITS(x)	(((x) >> 32) & 0xf)     /* Bits 35:32 */
+
+#define TME_ACTIVATE_CRYPTO_ALGS(x)	(((x) >> 48) & 0xffff)    /* Bits 63:48 */
+#define TME_ACTIVATE_CRYPTO_AES_XTS_128	1
+
+#define TME_EXCLUSION_ENABLED(x)	((x) & 0x800) /* Bit 11 */
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8321c43554a1..46ad006089a3 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -14,6 +14,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
+#include <asm/processor.h>
 #include <asm/bugs.h>
 #include <asm/cpu.h>
 #include <asm/intel-family.h>
@@ -492,20 +493,6 @@ static void srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
 
-#define MSR_IA32_TME_ACTIVATE		0x982
-
-/* Helpers to access TME_ACTIVATE MSR */
-#define TME_ACTIVATE_LOCKED(x)		(x & 0x1)
-#define TME_ACTIVATE_ENABLED(x)		(x & 0x2)
-
-#define TME_ACTIVATE_POLICY(x)		((x >> 4) & 0xf)	/* Bits 7:4 */
-#define TME_ACTIVATE_POLICY_AES_XTS_128	0
-
-#define TME_ACTIVATE_KEYID_BITS(x)	((x >> 32) & 0xf)	/* Bits 35:32 */
-
-#define TME_ACTIVATE_CRYPTO_ALGS(x)	((x >> 48) & 0xffff)	/* Bits 63:48 */
-#define TME_ACTIVATE_CRYPTO_AES_XTS_128	1
-
 /* Values for mktme_status (SW only construct) */
 #define MKTME_ENABLED			0
 #define MKTME_DISABLED			1
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 28be02adc669..c5a18527f099 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -84,6 +84,22 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
+static bool kvm_tme_supported(void)
+{
+	u64 tme_activation, tme_exclusion;
+
+	if (!feature_bit(TME))
+		return false;
+
+	if (rdmsrl_safe(MSR_IA32_TME_EXCLUDE_MASK, &tme_exclusion))
+		return false;
+	if (rdmsrl_safe(MSR_IA32_TME_ACTIVATE, &tme_activation))
+		return false;
+
+	return TME_ACTIVATE_LOCKED(tme_activation) &&
+		!TME_EXCLUSION_ENABLED(tme_exclusion);
+}
+
 static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 			   struct kvm_cpuid_entry2 *entries,
 			   int nent)
@@ -508,6 +524,7 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 
 void kvm_set_cpu_caps(void)
 {
+	unsigned int f_tme = kvm_tme_supported() ? F(TME) : 0;
 #ifdef CONFIG_X86_64
 	unsigned int f_gbpages = F(GBPAGES);
 	unsigned int f_lm = F(LM);
@@ -565,7 +582,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		f_tme | F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
 		F(SGX_LC) | F(BUS_LOCK_DETECT)
 	);
 	/* Set LA57 based on hardware capability. */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aca3ae2a02f3..f8cbf935cfe0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1913,6 +1913,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_IA32_TME_CAPABILITY:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_TME))
+			return 1;
+		if (rdmsrl_safe(MSR_IA32_TME_CAPABILITY, &msr_info->data))
+			return 1;
+		msr_info->data &= 0x80000005; /* Bit 0, 2, 31 */
+		break;
+	case MSR_IA32_TME_ACTIVATE:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_TME))
+			return 1;
+		if (rdmsrl_safe(MSR_IA32_TME_ACTIVATE, &msr_info->data))
+			return 1;
+		msr_info->data &= 0x800000FF; /* Bits [0-7] and Bit 31 */
+		break;
+	case MSR_IA32_TME_EXCLUDE_MASK:
+	case MSR_IA32_TME_EXCLUDE_BASE:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_TME))
+			return 1;
+		msr_info->data = 0x0;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



