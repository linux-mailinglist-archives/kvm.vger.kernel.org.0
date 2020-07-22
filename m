Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044CD229CAF
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgGVQCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:04 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38040 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728692AbgGVQBl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9FCF5305D76B;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 95FE8305FFA7;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 20/34] KVM: x86: vmx: add support for virtualization exceptions
Date:   Wed, 22 Jul 2020 19:01:07 +0300
Message-Id: <20200722160121.9601-21-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marian Rotariu <marian.c.rotariu@gmail.com>

Only the hardware support check function and the #VE info page management
are introduced.

Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/asm/vmx.h      |  3 +++
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  3 +++
 6 files changed, 55 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 086b6e2a2314..a9f225f9dd12 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1435,6 +1435,7 @@ extern u64  kvm_default_tsc_scaling_ratio;
 
 extern u64 kvm_mce_cap_supported;
 extern bool kvm_eptp_switching_supported;
+extern bool kvm_ve_supported;
 
 /*
  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 04487eb38b5c..177500e9e68c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -67,6 +67,7 @@
 #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
 #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
 #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
+#define SECONDARY_EXEC_EPT_VE		        VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
 #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
 #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
@@ -213,6 +214,8 @@ enum vmcs_field {
 	VMREAD_BITMAP_HIGH              = 0x00002027,
 	VMWRITE_BITMAP                  = 0x00002028,
 	VMWRITE_BITMAP_HIGH             = 0x00002029,
+	VE_INFO_ADDRESS			= 0x0000202A,
+	VE_INFO_ADDRESS_HIGH		= 0x0000202B,
 	XSS_EXIT_BITMAP                 = 0x0000202C,
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 92781e2c523e..bc5bbc41ca92 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -257,6 +257,11 @@ static inline bool cpu_has_vmx_pml(void)
 	return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_PML;
 }
 
+static inline bool cpu_has_vmx_ve(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_EPT_VE;
+}
+
 static inline bool vmx_xsaves_supported(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbc943d217e3..1c1dda14d18d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2463,6 +2463,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_RDSEED_EXITING |
 			SECONDARY_EXEC_RDRAND_EXITING |
 			SECONDARY_EXEC_ENABLE_PML |
+			SECONDARY_EXEC_EPT_VE |
 			SECONDARY_EXEC_TSC_SCALING |
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
@@ -4247,6 +4248,12 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	*/
 	exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
 
+	/* #VE must be disabled by default.
+	 * Once enabled, all EPT violations on pages missing the SVE bit
+	 * will be delivered to the guest.
+	 */
+	exec_control &= ~SECONDARY_EXEC_EPT_VE;
+
 	if (!enable_pml)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
@@ -6019,6 +6026,28 @@ static void dump_eptp_list(void)
 		pr_err("%d: %016llx\n", i, *(eptp_list + i));
 }
 
+static void dump_ve_info(void)
+{
+	phys_addr_t ve_info_phys;
+	struct vcpu_ve_info *ve_info = NULL;
+
+	if (!cpu_has_vmx_ve())
+		return;
+
+	ve_info_phys = (phys_addr_t)vmcs_read64(VE_INFO_ADDRESS);
+	if (!ve_info_phys)
+		return;
+
+	ve_info = (struct vcpu_ve_info *)phys_to_virt(ve_info_phys);
+
+	pr_err("*** Virtualization Exception Info ***\n");
+	pr_err("ExitReason: %x\n", ve_info->exit_reason);
+	pr_err("ExitQualification: %llx\n", ve_info->exit_qualification);
+	pr_err("GVA: %llx\n", ve_info->gva);
+	pr_err("GPA: %llx\n", ve_info->gpa);
+	pr_err("EPTPIndex: %x\n", ve_info->eptp_index);
+}
+
 void dump_vmcs(void)
 {
 	u32 vmentry_ctl, vmexit_ctl;
@@ -6169,6 +6198,7 @@ void dump_vmcs(void)
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
 
 	dump_eptp_list();
+	dump_ve_info();
 }
 
 static unsigned int update_ept_view(struct vcpu_vmx *vmx)
@@ -8340,6 +8370,7 @@ static __init int hardware_setup(void)
 		enable_ept = 0;
 
 	kvm_eptp_switching_supported = cpu_has_vmx_eptp_switching();
+	kvm_ve_supported = cpu_has_vmx_ve();
 
 	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
 		enable_ept_ad_bits = 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 38d50fc7357b..49f64be4bbef 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -24,6 +24,18 @@ extern const u32 vmx_msr_index[];
 
 #define NR_LOADSTORE_MSRS 8
 
+struct vcpu_ve_info {
+	u32 exit_reason;
+	u32 unused;
+	u64 exit_qualification;
+	u64 gva;
+	u64 gpa;
+	u16 eptp_index;
+
+	u16 offset1;
+	u32 offset2;
+};
+
 struct vmx_msrs {
 	unsigned int		nr;
 	struct vmx_msr_entry	val[NR_LOADSTORE_MSRS];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 78aacac839bb..9aa646a65967 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -164,6 +164,9 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 bool __read_mostly kvm_eptp_switching_supported;
 EXPORT_SYMBOL_GPL(kvm_eptp_switching_supported);
 
+bool __read_mostly kvm_ve_supported;
+EXPORT_SYMBOL_GPL(kvm_ve_supported);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
