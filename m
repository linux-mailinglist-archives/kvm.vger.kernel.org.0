Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64948377DD
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbfFFP36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:29:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:53940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbfFFP34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:29:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:29:56 -0700
X-ExtLoop1: 1
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 08:29:55 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 2/9] KVM: VMX: Add control flags for SPP enabling
Date:   Thu,  6 Jun 2019 23:28:05 +0800
Message-Id: <20190606152812.13141-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190606152812.13141-1-weijiang.yang@intel.com>
References: <20190606152812.13141-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check SPP capability in MSR_IA32_VMX_PROCBASED_CTLS2, its 23-bit
indicates SPP support. Mark SPP bit in CPU capabilities bitmap if
it's supported.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/vmx.h         |  1 +
 arch/x86/kernel/cpu/intel.c        |  4 ++++
 arch/x86/kvm/vmx/capabilities.h    |  5 +++++
 arch/x86/kvm/vmx/vmx.c             | 10 ++++++++++
 5 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 981ff9479648..5bcc356741e6 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -228,6 +228,7 @@
 #define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_SPP			( 8*32+ 5) /* Intel EPT-based Sub-Page Write Protection */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4e4133e86484..a2c9e18e0ad7 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -81,6 +81,7 @@
 #define SECONDARY_EXEC_XSAVES			0x00100000
 #define SECONDARY_EXEC_PT_USE_GPA		0x01000000
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	0x00400000
+#define SECONDARY_EXEC_ENABLE_SPP		0x00800000
 #define SECONDARY_EXEC_TSC_SCALING              0x02000000
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3142fd7a9b32..e937a44c8757 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -476,6 +476,7 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
 #define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
 #define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
 #define x86_VMX_FEATURE_EPT_CAP_AD		0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS2_SPP		0x00800000
 
 	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
 	u32 msr_vpid_cap, msr_ept_cap;
@@ -486,6 +487,7 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
 	clear_cpu_cap(c, X86_FEATURE_EPT);
 	clear_cpu_cap(c, X86_FEATURE_VPID);
 	clear_cpu_cap(c, X86_FEATURE_EPT_AD);
+	clear_cpu_cap(c, X86_FEATURE_SPP);
 
 	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
 	msr_ctl = vmx_msr_high | vmx_msr_low;
@@ -509,6 +511,8 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
 		}
 		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
 			set_cpu_cap(c, X86_FEATURE_VPID);
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_SPP)
+			set_cpu_cap(c, X86_FEATURE_SPP);
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 854e144131c6..8221ecbf6516 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -239,6 +239,11 @@ static inline bool cpu_has_vmx_pml(void)
 	return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_PML;
 }
 
+static inline bool cpu_has_vmx_ept_spp(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_SPP;
+}
+
 static inline bool vmx_xsaves_supported(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c955bb286ff..a0753a36155d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -114,6 +114,8 @@ static u64 __read_mostly host_xss;
 bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
+static bool __read_mostly spp_supported = 0;
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -2240,6 +2242,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_RDSEED_EXITING |
 			SECONDARY_EXEC_RDRAND_EXITING |
 			SECONDARY_EXEC_ENABLE_PML |
+			SECONDARY_EXEC_ENABLE_SPP |
 			SECONDARY_EXEC_TSC_SCALING |
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
@@ -3895,6 +3898,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
+	if (!spp_supported)
+		exec_control &= ~SECONDARY_EXEC_ENABLE_SPP;
+
 	if (vmx_xsaves_supported()) {
 		/* Exposing XSAVES only when XSAVE is exposed */
 		bool xsaves_enabled =
@@ -7470,6 +7476,10 @@ static __init int hardware_setup(void)
 	if (!cpu_has_vmx_flexpriority())
 		flexpriority_enabled = 0;
 
+	if (cpu_has_vmx_ept_spp() && enable_ept &&
+	    boot_cpu_has(X86_FEATURE_SPP))
+		spp_supported = 1;
+
 	if (!cpu_has_virtual_nmis())
 		enable_vnmi = 0;
 
-- 
2.17.2

