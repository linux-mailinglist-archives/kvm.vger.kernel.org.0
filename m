Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D467F5F0890
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiI3KVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiI3KTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F34816DDFB;
        Fri, 30 Sep 2022 03:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533144; x=1696069144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VNsEassfauCiOCjoXu6Lbz/ViiveLKwAKldsb4tWDIs=;
  b=QnBX2ifrAVR4DAaJPdsYUHB1VzIk8SRlBnqhUN7E36PMjfu3+wc4hRdL
   LXyrL8R249yWGlpG9ecndiRm9q2rWvfaJTUkDT/t/rMfTOOAYBlyjMI6H
   u3fLyKbVloacu7HHITm3GuRsudluYmQh6ibnJWnFxfBALapnduow/Nzij
   2yKmROvPspPXLpm1Pm8QI8a3cAoRE48788KM5XNEcTO0f/epl1rvpVn1n
   xG/yszMFk/XSD6LQzdrpdkuvzxmuqzEAkC0NhX5dVQWBPHl6QPPt1KODr
   rDNmLWES3UvbQ3cQFDQ0OPkqqEot6sTOo5CCF6e2SSrzKi+19D/ekxs2l
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870095"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870095"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807625"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807625"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 038/105] KVM: VMX: Introduce test mode related to EPT violation VE
Date:   Fri, 30 Sep 2022 03:17:32 -0700
Message-Id: <d24eb9c76ee3d09cb1dbfd73762591800885cc57.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 arch/x86/kvm/vmx/vmx.c     | 68 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h     |  3 ++
 4 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 6231ef005a50..f0f8eecf55ac 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -68,6 +68,7 @@
 #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
 #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
 #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
+#define SECONDARY_EXEC_EPT_VIOLATION_VE		VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
 #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
 #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
@@ -223,6 +224,8 @@ enum vmcs_field {
 	VMREAD_BITMAP_HIGH              = 0x00002027,
 	VMWRITE_BITMAP                  = 0x00002028,
 	VMWRITE_BITMAP_HIGH             = 0x00002029,
+	VE_INFORMATION_ADDRESS		= 0x0000202A,
+	VE_INFORMATION_ADDRESS_HIGH	= 0x0000202B,
 	XSS_EXIT_BITMAP                 = 0x0000202C,
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
@@ -628,4 +631,13 @@ enum vmx_l1d_flush_state {
 
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
index ac290a44a693..9277676057a7 100644
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
index b53ffd367f51..f1e25e4097e1 100644
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
 
@@ -783,6 +786,13 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 
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
@@ -2647,6 +2657,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_NOTIFY_VM_EXITING;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
+		if (ept_violation_ve_test)
+			opt2 |= SECONDARY_EXEC_EPT_VIOLATION_VE;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -2681,6 +2693,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			return -EIO;
 
 		vmx_cap->ept = 0;
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 	}
 	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
 	    vmx_cap->vpid) {
@@ -4520,6 +4533,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 		enable_unrestricted_guest = 0;
 	}
 	if (!enable_unrestricted_guest)
@@ -4647,8 +4661,40 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
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
@@ -5128,6 +5174,12 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
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
@@ -6314,6 +6366,18 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -7310,6 +7374,8 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	if (vmx->ve_info)
+		free_page((unsigned long)vmx->ve_info);
 }
 
 int vmx_vcpu_create(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c9fb46e570b0..47240671535a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -359,6 +359,9 @@ struct vcpu_vmx {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	} shadow_msr_intercept;
+
+	/* ve_info must be page aligned. */
+	struct vmx_ve_information *ve_info;
 };
 
 struct kvm_vmx {
-- 
2.25.1

