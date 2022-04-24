Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD47A50D118
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbiDXKTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbiDXKTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:19:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBD3140A5;
        Sun, 24 Apr 2022 03:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795362; x=1682331362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y7Qa/RTMtrNvcVvyMDQP5HKRtGLkqkD84LwqpgUU1FI=;
  b=ZSGblX3uuTLwUKJI8o/iBRSXkFLcoMsTA/He0O60tCwrza35evwEiqcC
   IKU0VHJNfbajIj9rE+1pXC9O+goV/zlmtCPqG1x4KI4zPutZ/UWbeAWza
   zoFLywI9JV3weAV4lUf/5RWYM+C8qNQpmuwyRcw8HP2ukY1oWvG5bVWuE
   xWp6C/ufCsM+7hyVz/w7Pbr/Xl7uj9bOVobDaV9UHXofldb7/qvatz3v/
   Xm9JIyijAAYB6s9iXPe+LVpkZeRouFA7VQqVb2TqMnCQ3zpni9gVFPTkf
   K1BxKZPZqQ3r5xVyA220zFbPWonowbYCRszdyV9FD7SDzd4Lk3I8eCwQo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813949"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813949"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:16:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086730"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:16:01 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 8/8] KVM: VMX: Enable PKS for nested VM
Date:   Sun, 24 Apr 2022 03:15:57 -0700
Message-Id: <20220424101557.134102-9-lei4.wang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220424101557.134102-1-lei4.wang@intel.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

PKS MSR passes through guest directly. Configure the MSR to match the
L0/L1 settings so that nested VM runs PKS properly.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Co-developed-by: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Lei Wang <lei4.wang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 36 ++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.c |  2 ++
 arch/x86/kvm/vmx/vmcs12.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c    |  1 +
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 5 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 58a1fa7defc9..dde359dacfcb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -252,6 +252,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 	dest->ds_sel = src->ds_sel;
 	dest->es_sel = src->es_sel;
 #endif
+	vmx_set_host_pkrs(dest, src->pkrs);
 }
 
 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
@@ -685,6 +686,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PKRS, MSR_TYPE_RW);
+
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
@@ -2433,6 +2437,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
+
+		if (vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2521,6 +2529,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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
@@ -2897,6 +2910,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 					   vmcs12->host_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
+		return -EINVAL;
+
 #ifdef CONFIG_X86_64
 	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 #else
@@ -3049,6 +3066,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3384,6 +3405,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	    (!from_vmentry ||
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) && 
+	    (!from_vmentry ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
+		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -4029,6 +4054,7 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_IA32_PKRS:
 		return true;
 	default:
 		break;
@@ -4080,6 +4106,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (vmx->nested.msrs.entry_ctls_high & VM_ENTRY_LOAD_IA32_PKRS)
+		vmcs12->guest_ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
@@ -4317,6 +4345,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS)
+		vmcs_write64(GUEST_IA32_PKRS, vmcs12->host_ia32_pkrs);
+
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
 	seg = (struct kvm_segment) {
@@ -6559,7 +6590,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+		VM_EXIT_LOAD_IA32_PKRS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6579,7 +6611,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_PKRS;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
 
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 2251b60920f8..7aad1b2f1d81 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -62,9 +62,11 @@ const unsigned short vmcs12_field_offsets[] = {
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
index 746129ddd5ae..4f41be3c351c 100644
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
 
 extern const unsigned short vmcs12_field_offsets[];
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbcb0d7b47a4..a62dc65299d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7294,6 +7294,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_PKS,        ecx, feature_bit(PKS));
 
 #undef cr4_fixed1_update
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 91723a226bf3..82f79ac46d7b 100644
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
2.25.1

