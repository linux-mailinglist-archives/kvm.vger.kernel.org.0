Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA6A4BD843
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbiBUIGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:06:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346839AbiBUIGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:06:24 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D46635E;
        Mon, 21 Feb 2022 00:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645430761; x=1676966761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=PFcNS4UciWhRjN8ZJIBK1kr9HJnDX0y8EosYXv60Nho=;
  b=BVfBSIw2PUirCRYs5cI7S4NWxAdzKHxQwxFXZfu9ryZnqpfcODhKeH53
   WnjcXi+d/Et+7WDeARVXIcUu3UUTRr3/uA8ONm5wpsWCQgHNOYLVUnlI/
   JfmUAS1a53DsBTiH7Vy7eAf/ew/IJwrBDaZD18Tlb+KJvKXebLTfXncP0
   4YUCGKfaqVLwKoZMoFJdKGhyOuua02AQjjl3sBtMLGCvRSeqOscK4+UBy
   n8R7ViPWris+z+3eUxVObWiU+0AQ/IlgjFmo3fK4BsLyXNUGOgnG/bC8o
   eA/cvUXooDudX88aQL9RZeWhpyl2PRZllsMAtbzydTnBSbuwE/0Gnt4FQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="250277907"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="250277907"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="638472377"
Received: from unknown (HELO chenyi-pc.sh.intel.com) ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:56 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 7/7] KVM: VMX: Enable PKS for nested VM
Date:   Mon, 21 Feb 2022 16:08:40 +0800
Message-Id: <20220221080840.7369-8-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221080840.7369-1-chenyi.qiang@intel.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKS MSR passes through guest directly. Configure the MSR to match the
L0/L1 settings so that nested VM runs PKS properly.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 38 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.c |  2 ++
 arch/x86/kvm/vmx/vmcs12.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c    |  1 +
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 5 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f235f77cbc03..c42a1df385ef 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -252,6 +252,10 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 	dest->ds_sel = src->ds_sel;
 	dest->es_sel = src->es_sel;
 #endif
+	if (unlikely(src->pkrs != dest->pkrs)) {
+		vmcs_write64(HOST_IA32_PKRS, src->pkrs);
+		dest->pkrs = src->pkrs;
+	}
 }
 
 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
@@ -685,6 +689,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PKRS, MSR_TYPE_RW);
+
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
@@ -2433,6 +2440,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
+
+		if (vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2521,6 +2532,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    (!vmx->nested.nested_run_pending ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
+		vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
+
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
@@ -2897,6 +2913,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 					   vmcs12->host_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
+		CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
+		return -EINVAL;
+
 #ifdef CONFIG_X86_64
 	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 #else
@@ -3049,6 +3069,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3377,6 +3401,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported() &&
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -4022,6 +4049,7 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_IA32_PKRS:
 		return true;
 	default:
 		break;
@@ -4073,6 +4101,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PKS))
+		vmcs12->guest_ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
@@ -4310,6 +4340,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS)
+		vmcs_write64(GUEST_IA32_PKRS, vmcs12->host_ia32_pkrs);
+
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
 	seg = (struct kvm_segment) {
@@ -6527,7 +6560,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+		VM_EXIT_LOAD_IA32_PKRS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6547,7 +6581,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_PKRS;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
 
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index cab6ba7a5005..f3b964e1496c 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -62,9 +62,11 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD64(GUEST_PDPTR2, guest_pdptr2),
 	FIELD64(GUEST_PDPTR3, guest_pdptr3),
 	FIELD64(GUEST_BNDCFGS, guest_bndcfgs),
+	FIELD64(GUEST_IA32_PKRS, guest_ia32_pkrs),
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
+	FIELD64(HOST_IA32_PKRS, host_ia32_pkrs),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 2a45f026ee11..42cb4a2b806a 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -185,6 +185,8 @@ struct __packed vmcs12 {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 	u16 guest_pml_index;
+	u64 host_ia32_pkrs;
+	u64 guest_ia32_pkrs;
 };
 
 /*
@@ -359,6 +361,8 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_gs_selector, 992);
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
+	CHECK_OFFSET(host_ia32_pkrs, 998);
+	CHECK_OFFSET(guest_ia32_pkrs, 1006);
 }
 
 extern const unsigned short vmcs_field_to_offset_table[];
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6fc70ddeff5a..978f4a61771f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7248,6 +7248,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_PKS,        ecx, feature_bit(PKS));
 
 #undef cr4_fixed1_update
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d704ba3a4af7..78bca3d14ed4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -222,6 +222,8 @@ struct nested_vmx {
 	u64 vmcs01_debugctl;
 	u64 vmcs01_guest_bndcfgs;
 
+	u64 vmcs01_guest_pkrs;
+
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
 
-- 
2.17.1

