Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2169A1838ED
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCLSqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:46:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:23434 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgCLSpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041231"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2020 11:45:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 03/10] KVM: nVMX: Pull exit_reason from vcpu_vmx in nested_vmx_exit_reflected()
Date:   Thu, 12 Mar 2020 11:45:14 -0700
Message-Id: <20200312184521.24579-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312184521.24579-1-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Grab the exit reason from the vcpu struct in nested_vmx_exit_reflected()
instead of having the exit reason explicitly passed from the caller.
This fixes a discrepancy between VM-Fail and VM-Exit handling, as the
VM-Fail case is already handled by checking vcpu_vmx, e.g. the exit
reason previously passed on the stack is bogus if vmx->fail is set.

Not taking the exit reason on the stack also avoids having to document
that nested_vmx_exit_reflected() requires the full exit reason, as
opposed to just the basic exit reason, which is not at all obvious since
the only usage of the full exit reason is for tracing.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 arch/x86/kvm/vmx/nested.h | 9 ++++-----
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 79c7764c77b1..cb05bcbbfc4e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5518,11 +5518,12 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
  * should handle it ourselves in L0 (and then continue L2). Only call this
  * when in is_guest_mode (L2).
  */
-bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
+bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u32 exit_reason = vmx->exit_reason;
 
 	if (vmx->nested.nested_run_pending)
 		return false;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 8f5ff3e259c9..569cb828b6ca 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -24,7 +24,7 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						     bool from_vmentry);
-bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
+bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
@@ -75,12 +75,11 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
  * Conditionally reflect a VM-Exit into L1.  Returns %true if the VM-Exit was
  * reflected into L1.
  */
-static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
-					     u32 exit_reason)
+static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	u32 exit_intr_info;
 
-	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
+	if (!nested_vmx_exit_reflected(vcpu))
 		return false;
 
 	/*
@@ -99,7 +98,7 @@ static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	}
 
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
+	nested_vmx_vmexit(vcpu, to_vmx(vcpu)->exit_reason, exit_intr_info,
 			  vmcs_readl(EXIT_QUALIFICATION));
 	return true;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c1caac7e8f57..c7715c880ea7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5863,7 +5863,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	if (vmx->emulation_required)
 		return handle_invalid_guest_state(vcpu);
 
-	if (is_guest_mode(vcpu) && nested_vmx_reflect_vmexit(vcpu, exit_reason))
+	if (is_guest_mode(vcpu) && nested_vmx_reflect_vmexit(vcpu))
 		return 1;
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
-- 
2.24.1

