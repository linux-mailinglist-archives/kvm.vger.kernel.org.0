Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDD34E02C
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 08:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfFUGA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 02:00:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:51060 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfFUGA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 02:00:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 23:00:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,399,1557212400"; 
   d="scan'208";a="165563319"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2019 23:00:23 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com, tao3.xu@intel.com
Subject: [PATCH v6 1/3] KVM: x86: add support for user wait instructions
Date:   Fri, 21 Jun 2019 13:57:45 +0800
Message-Id: <20190621055747.17060-2-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621055747.17060-1-tao3.xu@intel.com>
References: <20190621055747.17060-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
This patch adds support for user wait instructions in KVM. Availability
of the user wait instructions is indicated by the presence of the CPUID
feature flag WAITPKG CPUID.0x07.0x0:ECX[5]. User wait instructions may
be executed at any privilege level, and use IA32_UMWAIT_CONTROL MSR to
set the maximum time.

The behavior of user wait instructions in VMX non-root operation is
determined first by the setting of the "enable user wait and pause"
secondary processor-based VM-execution control bit 26.
	If the VM-execution control is 0, UMONITOR/UMWAIT/TPAUSE cause
an invalid-opcode exception (#UD).
	If the VM-execution control is 1, treatment is based on the
setting of the “RDTSC exiting” VM-execution control. Because KVM never
enables RDTSC exiting, if the instruction causes a delay, the amount of
time delayed is called here the physical delay. The physical delay is
first computed by determining the virtual delay. If
IA32_UMWAIT_CONTROL[31:2] is zero, the virtual delay is the value in
EDX:EAX minus the value that RDTSC would return; if
IA32_UMWAIT_CONTROL[31:2] is not zero, the virtual delay is the minimum
of that difference and AND(IA32_UMWAIT_CONTROL,FFFFFFFCH).

Because umwait and tpause can put a (psysical) CPU into a power saving
state, by default we dont't expose it to kvm and enable it only when
guest CPUID has it.

Detailed information about user wait instructions can be found in the
latest Intel 64 and IA-32 Architectures Software Developer's Manual.

Reviewed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---

No changes in v6
---
 arch/x86/include/asm/vmx.h | 1 +
 arch/x86/kvm/cpuid.c       | 2 +-
 arch/x86/kvm/vmx/vmx.c     | 4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a39136b0d509..8f00882664d3 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -69,6 +69,7 @@
 #define SECONDARY_EXEC_PT_USE_GPA		0x01000000
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	0x00400000
 #define SECONDARY_EXEC_TSC_SCALING              0x02000000
+#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	0x04000000
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
 #define PIN_BASED_NMI_EXITING                   0x00000008
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9f65b5..48bd851a6ae5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -405,7 +405,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b93e36ddee5e..b35bfac30a34 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2250,6 +2250,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_RDRAND_EXITING |
 			SECONDARY_EXEC_ENABLE_PML |
 			SECONDARY_EXEC_TSC_SCALING |
+			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
 			SECONDARY_EXEC_ENABLE_VMFUNC |
@@ -3987,6 +3988,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
+		exec_control &= ~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
+
 	vmx->secondary_exec_control = exec_control;
 }
 
-- 
2.20.1

