Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1195E30D899
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhBCLZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:25:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:28338 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234262AbhBCLYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:24:24 -0500
IronPort-SDR: 6pl2ObqPRjZbG8LjGATA60coQhboRv53VnKcSnZORQxE480Dmp7Dq5m7LJW+rrl8q/8/uZURHY
 o4gzVUpQI7YQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981326"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981326"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:32 -0800
IronPort-SDR: 8DaEOLdQzijyk+jjnZJaz5kN0M/6/f40+D3FPMwLXkYKH7Xq2/Oiac2+XdDevR8dI3IX2K6qxY
 8SfKLZDxcPiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311242"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:29 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 13/14] KVM: nVMX: Enable CET support for nested VMX
Date:   Wed,  3 Feb 2021 19:34:20 +0800
Message-Id: <20210203113421.5759-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vmcs12 fields for all CET fields, pass-through CET MSRs to L2 when
possible, and enumerate the VMCS controls and CR4 bit as supported.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
 arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++++++-
 arch/x86/kvm/vmx/vmx.c    |  1 +
 4 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3b405ebabb6e..9728efd529a1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -638,6 +638,29 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
 					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
 
+	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_U_CET,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_RW);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_RW);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_S_CET,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_RW);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_RW);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_RW);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_RW);
+	nested_vmx_cond_disable_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
+						  msr_bitmap_l1, msr_bitmap_l0,
+						  MSR_TYPE_RW);
+
 	/*
 	 * Checking the L0->L1 bitmap is trying to verify two things:
 	 *
@@ -6386,7 +6409,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+		VM_EXIT_LOAD_CET_STATE;
+
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6406,7 +6431,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_CET_STATE;
+
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
 
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index c8e51c004f78..8fd8e0beecef 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -137,6 +137,9 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
+	FIELD(GUEST_S_CET, guest_s_cet),
+	FIELD(GUEST_SSP, guest_ssp),
+	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
 	FIELD(HOST_CR0, host_cr0),
 	FIELD(HOST_CR3, host_cr3),
 	FIELD(HOST_CR4, host_cr4),
@@ -149,5 +152,8 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
+	FIELD(HOST_S_CET, host_s_cet),
+	FIELD(HOST_SSP, host_ssp),
+	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 80232daf00ff..016896c9e701 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -115,7 +115,13 @@ struct __packed vmcs12 {
 	natural_width host_ia32_sysenter_eip;
 	natural_width host_rsp;
 	natural_width host_rip;
-	natural_width paddingl[8]; /* room for future expansion */
+	natural_width host_s_cet;
+	natural_width host_ssp;
+	natural_width host_ssp_tbl;
+	natural_width guest_s_cet;
+	natural_width guest_ssp;
+	natural_width guest_ssp_tbl;
+	natural_width paddingl[2]; /* room for future expansion */
 	u32 pin_based_vm_exec_control;
 	u32 cpu_based_vm_exec_control;
 	u32 exception_bitmap;
@@ -295,6 +301,12 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
 	CHECK_OFFSET(host_rsp, 664);
 	CHECK_OFFSET(host_rip, 672);
+	CHECK_OFFSET(host_s_cet, 680);
+	CHECK_OFFSET(host_ssp, 688);
+	CHECK_OFFSET(host_ssp_tbl, 696);
+	CHECK_OFFSET(guest_s_cet, 704);
+	CHECK_OFFSET(guest_ssp, 712);
+	CHECK_OFFSET(guest_ssp_tbl, 720);
 	CHECK_OFFSET(pin_based_vm_exec_control, 744);
 	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
 	CHECK_OFFSET(exception_bitmap, 752);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b6657117191b..5856c5b81084 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7257,6 +7257,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
 
 #undef cr4_fixed1_update
 }
-- 
2.26.2

