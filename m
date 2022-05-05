Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B140A51C74F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbiEESWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383264AbiEESTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D105DA64;
        Thu,  5 May 2022 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774557; x=1683310557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DKO8p1z1u/GRhlWjJ3qX2Z+Q/wRIK2LVWM4LrNFmYpo=;
  b=C7UXcGoHHZdderSQNoOSDd/xVavnmelB+X4fed03zUyQ+Pwkm2At2Fz0
   +zt7EfJuqQiQuWhY8v8wsi1T4pMmZooifSwMyRi0AUvI7cQftTKcyMy3X
   fcQofjobqKkqdn4Q9Gmjnw7sN2l2HfotFLTICKaeX7HfENJjLahpzrPGX
   iTfIDL1+3athvGPJ72gQtl4iy95HBRkxzbd1o/T28QnuYVrD5Mb8AprzP
   80GemcUvPXZN8fV4nSQM8xnlvsMJaC6mvQdG6kvGwCM//EsUdx7mwGkrr
   EAbb20hhX21oM3c47/fNKSpDrdWOIUDjUOoCBSVf2qxXsTk2Jbo2wVW7l
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742027"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742027"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083284"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:46 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 042/104] KVM: VMX: Introduce test mode related to EPT violation VE
Date:   Thu,  5 May 2022 11:14:36 -0700
Message-Id: <055cf7f4120e5dece70552fab1576ace8bb047ee.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/vmx.h | 12 +++++++
 arch/x86/kvm/vmx/vmx.c     | 68 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h     |  3 ++
 3 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 9682f5a02da8..d3c8abcaa35e 100644
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
@@ -222,6 +223,8 @@ enum vmcs_field {
 	VMREAD_BITMAP_HIGH              = 0x00002027,
 	VMWRITE_BITMAP                  = 0x00002028,
 	VMWRITE_BITMAP_HIGH             = 0x00002029,
+	VE_INFORMATION_ADDRESS		= 0x0000202A,
+	VE_INFORMATION_ADDRESS_HIGH	= 0x0000202B,
 	XSS_EXIT_BITMAP                 = 0x0000202C,
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
@@ -621,4 +624,13 @@ enum vmx_l1d_flush_state {
 
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2314389f268..60dedae31426 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -123,6 +123,9 @@ module_param_named(pml, enable_pml, bool, S_IRUGO);
 static bool __read_mostly dump_invalid_vmcs = 0;
 module_param(dump_invalid_vmcs, bool, 0644);
 
+static bool __read_mostly ept_violation_ve_test = 0;
+module_param(ept_violation_ve_test, bool, 0444);
+
 #define MSR_BITMAP_MODE_X2APIC		1
 #define MSR_BITMAP_MODE_X2APIC_APICV	2
 
@@ -721,6 +724,13 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 
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
@@ -2490,6 +2500,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_BUS_LOCK_DETECTION;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
+		if (ept_violation_ve_test)
+			opt2 |= SECONDARY_EXEC_EPT_VIOLATION_VE;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -2518,6 +2530,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 					     CPU_BASED_INVLPG_EXITING);
 	} else if (vmx_cap->ept) {
 		vmx_cap->ept = 0;
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 		pr_warn_once("EPT CAP should not exist if not support "
 				"1-setting enable EPT VM-execution control\n");
 	}
@@ -4331,6 +4344,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 		enable_unrestricted_guest = 0;
 	}
 	if (!enable_unrestricted_guest)
@@ -4455,8 +4469,40 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
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
+				secondary_exec_controls_clearbit(
+					vmx, SECONDARY_EXEC_EPT_VIOLATION_VE);
+			}
+		}
+	}
 
 	if (cpu_has_tertiary_exec_ctrls())
 		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
@@ -5051,7 +5097,14 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		if (handle_guest_split_lock(kvm_rip_read(vcpu)))
 			return 1;
 		fallthrough;
+	case VE_VECTOR:
 	default:
+		if (ept_violation_ve_test && ex_no == VE_VECTOR) {
+			pr_err("VMEXIT due to unexpected #VE.\n");
+			secondary_exec_controls_clearbit(
+				vmx, SECONDARY_EXEC_EPT_VIOLATION_VE);
+			return 1;
+		}
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
 		kvm_run->ex.error_code = error_code;
@@ -6081,6 +6134,17 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
+	if (secondary_exec_control & SECONDARY_EXEC_EPT_VIOLATION_VE) {
+		struct vmx_ve_information *ve_info;
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
@@ -7065,6 +7129,8 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+	if (vmx->ve_info)
+		free_page((unsigned long)vmx->ve_info);
 }
 
 int vmx_vcpu_create(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 36dbaf1add45..f49be71290bd 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -336,6 +336,9 @@ struct vcpu_vmx {
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

