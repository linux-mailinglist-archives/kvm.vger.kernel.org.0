Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D81B18C5FF
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 04:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgCTDlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 23:41:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:27908 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgCTDk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 23:40:58 -0400
IronPort-SDR: C8fOYa9/pSrTcR9FxR6dQw7+eqGsrCh+oo3Wct3yKLpBL+22sSdOh5a3iUEbj1ihY/3FQezBT4
 ulwjQwk3AyhQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 20:40:57 -0700
IronPort-SDR: W5ZstaUtz9maRJDfTqM6VJdpg6BetG4lmAq+nuI1GkdcH+I+YVx08Xm0bxJkb599L2/8GxUelu
 r/QYBLjoHNgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="263945619"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 19 Mar 2020 20:40:55 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 7/8] KVM: VMX: Enable CET support for nested VM
Date:   Fri, 20 Mar 2020 11:43:40 +0800
Message-Id: <20200320034342.26610-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200320034342.26610-1-weijiang.yang@intel.com>
References: <20200320034342.26610-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET MSRs are passed to guests for performance consideration.
Configure the MSRs to match L0/L1 settings so that nested VM
is able to run with CET.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 41 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
 arch/x86/kvm/vmx/vmcs12.h | 14 ++++++++++++-
 arch/x86/kvm/vmx/vmx.c    |  1 +
 4 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e47eb7c0fbae..a71ef33de55f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -627,6 +627,41 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
 					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
 
+	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_U_CET))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_U_CET, MSR_TYPE_RW);
+
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL3_SSP))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_PL3_SSP, MSR_TYPE_RW);
+
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_S_CET))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_S_CET, MSR_TYPE_RW);
+
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL0_SSP))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_PL0_SSP, MSR_TYPE_RW);
+
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL1_SSP))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_PL1_SSP, MSR_TYPE_RW);
+
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PL2_SSP))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_PL2_SSP, MSR_TYPE_RW);
+
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_INT_SSP_TAB))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
 	/*
 	 * Checking the L0->L1 bitmap is trying to verify two things:
 	 *
@@ -6040,7 +6075,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
-		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT;
+		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT |
+		VM_EXIT_LOAD_HOST_CET_STATE;
 
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
@@ -6057,7 +6093,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 #endif
 		VM_ENTRY_LOAD_IA32_PAT;
 	msrs->entry_ctls_high |=
-		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
+		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
+		 VM_ENTRY_LOAD_GUEST_CET_STATE);
 
 	/* We support free control of debug control loading. */
 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 53dfb401316d..82b82bebeee0 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -141,6 +141,9 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
+	FIELD(GUEST_S_CET, guest_s_cet),
+	FIELD(GUEST_SSP, guest_ssp),
+	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
 	FIELD(HOST_CR0, host_cr0),
 	FIELD(HOST_CR3, host_cr3),
 	FIELD(HOST_CR4, host_cr4),
@@ -153,5 +156,8 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
+	FIELD(HOST_S_CET, host_s_cet),
+	FIELD(HOST_SSP, host_ssp),
+	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index d0c6df373f67..62b7be68f05c 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -118,7 +118,13 @@ struct __packed vmcs12 {
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
@@ -301,6 +307,12 @@ static inline void vmx_check_vmcs12_offsets(void)
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
index 2654bd099fe6..1de03da2bda6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7141,6 +7141,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
 
 #undef cr4_fixed1_update
 }
-- 
2.17.2

