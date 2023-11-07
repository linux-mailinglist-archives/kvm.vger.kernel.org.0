Return-Path: <kvm+bounces-929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F607E427A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44E7D1C20BAE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5372B31A92;
	Tue,  7 Nov 2023 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GBQ6sKkA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3270C31A84
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:58:56 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA632126;
	Tue,  7 Nov 2023 06:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369114; x=1730905114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ROQoGG5oGrBPVYtYQUqh5JxGSbc6y7zPGRu3i0tFLFE=;
  b=GBQ6sKkAfM1El6AB0qtL2wOZbCZbYPEQvw6LvUXViXDlNt6txuyjCzIf
   aAtPbubc+dCAx/6rWYNCevPOOgVqWcPAzfAcyxAIpDpI5tN8oJdXaCSU2
   +qrkoRJ2QZGe2kBYPzt2jGLEuJGTFNTEwBROkuKjKbiPssv7ro3WaZ5Uf
   bH116l6dU4IKS5/5g+B+KT1t5EXjcc4uUNIlJwKt7fvrbH0R5Lhl7AUFk
   PZO3I+JZyDqPsGpqlCcXLk5VYmc4UX2/9fibYT6kcD6Ccr37+xfa/DMMy
   dL4zGHMQjrOEgev2rjsxo5ECDfx9R1J0JBmOemefmjJoAfzTo3XZ4kM4l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462252"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462252"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851341"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:09 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 038/116] KVM: VMX: Introduce test mode related to EPT violation VE
Date: Tue,  7 Nov 2023 06:56:04 -0800
Message-Id: <d8f1ddd8e2a1a9aa00dedde5c95679d9a3e3c0ae.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM programs
to inject #VE conditionally and set #VE suppress bit in EPT entry.  For VMX
case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
defensive (test that VMX case isn't broken), introduce option
ept_violation_ve_test and when it's set, set error.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/vmx.h | 12 +++++++
 arch/x86/kvm/vmx/vmcs.h    |  5 +++
 arch/x86/kvm/vmx/vmx.c     | 69 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h     |  6 +++-
 4 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 76ed39541a52..f703bae0c4ac 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -70,6 +70,7 @@
 #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
 #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
 #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
+#define SECONDARY_EXEC_EPT_VIOLATION_VE		VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
 #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
 #define SECONDARY_EXEC_ENABLE_XSAVES		VMCS_CONTROL_BIT(XSAVES)
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
@@ -225,6 +226,8 @@ enum vmcs_field {
 	VMREAD_BITMAP_HIGH              = 0x00002027,
 	VMWRITE_BITMAP                  = 0x00002028,
 	VMWRITE_BITMAP_HIGH             = 0x00002029,
+	VE_INFORMATION_ADDRESS		= 0x0000202A,
+	VE_INFORMATION_ADDRESS_HIGH	= 0x0000202B,
 	XSS_EXIT_BITMAP                 = 0x0000202C,
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
@@ -630,4 +633,13 @@ enum vmx_l1d_flush_state {
 
 extern enum vmx_l1d_flush_state l1tf_vmx_mitigation;
 
+struct vmx_ve_information {
+	u32 exit_reason;
+	u32 delivery;
+	u64 exit_qualification;
+	u64 guest_linear_address;
+	u64 guest_physical_address;
+	u16 eptp_index;
+};
+
 #endif
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 7c1996b433e2..b25625314658 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -140,6 +140,11 @@ static inline bool is_nm_fault(u32 intr_info)
 	return is_exception_n(intr_info, NM_VECTOR);
 }
 
+static inline bool is_ve_fault(u32 intr_info)
+{
+	return is_exception_n(intr_info, VE_VECTOR);
+}
+
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c36db04998aa..b239684425b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -126,6 +126,9 @@ module_param(error_on_inconsistent_vmcs_config, bool, 0444);
 static bool __read_mostly dump_invalid_vmcs = 0;
 module_param(dump_invalid_vmcs, bool, 0644);
 
+static bool __read_mostly ept_violation_ve_test;
+module_param(ept_violation_ve_test, bool, 0444);
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -869,6 +872,13 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 
 	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR) |
 	     (1u << DB_VECTOR) | (1u << AC_VECTOR);
+	/*
+	 * #VE isn't used for VMX, but for TDX.  To test against unexpected
+	 * change related to #VE for VMX, intercept unexpected #VE and warn on
+	 * it.
+	 */
+	if (ept_violation_ve_test)
+		eb |= 1u << VE_VECTOR;
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -2602,6 +2612,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 					&_cpu_based_2nd_exec_control))
 			return -EIO;
 	}
+	if (!ept_violation_ve_test)
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
+
 #ifndef CONFIG_X86_64
 	if (!(_cpu_based_2nd_exec_control &
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
@@ -2626,6 +2639,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			return -EIO;
 
 		vmx_cap->ept = 0;
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 	}
 	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
 	    vmx_cap->vpid) {
@@ -4588,6 +4602,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 		enable_unrestricted_guest = 0;
 	}
 	if (!enable_unrestricted_guest)
@@ -4711,8 +4726,40 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 	exec_controls_set(vmx, vmx_exec_control(vmx));
 
-	if (cpu_has_secondary_exec_ctrls())
+	if (cpu_has_secondary_exec_ctrls()) {
 		secondary_exec_controls_set(vmx, vmx_secondary_exec_control(vmx));
+		if (secondary_exec_controls_get(vmx) &
+		    SECONDARY_EXEC_EPT_VIOLATION_VE) {
+			if (!vmx->ve_info) {
+				/* ve_info must be page aligned. */
+				struct page *page;
+
+				BUILD_BUG_ON(sizeof(*vmx->ve_info) > PAGE_SIZE);
+				page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+				if (page)
+					vmx->ve_info = page_to_virt(page);
+			}
+			if (vmx->ve_info) {
+				/*
+				 * Allow #VE delivery. CPU sets this field to
+				 * 0xFFFFFFFF on #VE delivery.  Another #VE can
+				 * occur only if software clears the field.
+				 */
+				vmx->ve_info->delivery = 0;
+				vmcs_write64(VE_INFORMATION_ADDRESS,
+					     __pa(vmx->ve_info));
+			} else {
+				/*
+				 * Because SECONDARY_EXEC_EPT_VIOLATION_VE is
+				 * used only when ept_violation_ve_test is true,
+				 * it's okay to go with the bit disabled.
+				 */
+				pr_err("Failed to allocate ve_info. disabling EPT_VIOLATION_VE.\n");
+				secondary_exec_controls_clearbit(vmx,
+								 SECONDARY_EXEC_EPT_VIOLATION_VE);
+			}
+		}
+	}
 
 	if (cpu_has_tertiary_exec_ctrls())
 		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
@@ -5197,6 +5244,12 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
 
+	/*
+	 * #VE isn't supposed to happen.  Although vcpu can send
+	 */
+	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
+		return -EIO;
+
 	error_code = 0;
 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
@@ -6384,6 +6437,18 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
+	if (secondary_exec_control & SECONDARY_EXEC_EPT_VIOLATION_VE) {
+		struct vmx_ve_information *ve_info;
+
+		pr_err("VE info address = 0x%016llx\n",
+		       vmcs_read64(VE_INFORMATION_ADDRESS));
+		ve_info = __va(vmcs_read64(VE_INFORMATION_ADDRESS));
+		pr_err("ve_info: 0x%08x 0x%08x 0x%016llx 0x%016llx 0x%016llx 0x%04x\n",
+		       ve_info->exit_reason, ve_info->delivery,
+		       ve_info->exit_qualification,
+		       ve_info->guest_linear_address,
+		       ve_info->guest_physical_address, ve_info->eptp_index);
+	}
 }
 
 /*
@@ -7424,6 +7489,8 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	if (vmx->ve_info)
+		free_page((unsigned long)vmx->ve_info);
 }
 
 int vmx_vcpu_create(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 41ad0e7a25fd..2847e368c8e6 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -347,6 +347,9 @@ struct vcpu_vmx {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	} shadow_msr_intercept;
+
+	/* ve_info must be page aligned. */
+	struct vmx_ve_information *ve_info;
 };
 
 struct kvm_vmx {
@@ -557,7 +560,8 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
-	 SECONDARY_EXEC_ENCLS_EXITING)
+	 SECONDARY_EXEC_ENCLS_EXITING |					\
+	 SECONDARY_EXEC_EPT_VIOLATION_VE)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
-- 
2.25.1


