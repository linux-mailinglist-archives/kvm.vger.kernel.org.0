Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD31838EB
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgCLSpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:45:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:23434 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgCLSpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041237"
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
Subject: [PATCH 05/10] KVM: VMX: Convert local exit_reason to u16 in vmx_handle_exit()
Date:   Thu, 12 Mar 2020 11:45:16 -0700
Message-Id: <20200312184521.24579-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312184521.24579-1-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the local "exit_reason" in vmx_handle_exit() from a u32 to a u16
as most references expect to encounter only the basic exit reason.  Use
vmx->exit_reason directly for paths that expect the full exit reason,
i.e. to avoid having to figure out a decent name for a second local
variable.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c7715c880ea7..d43e1d28bb58 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5844,10 +5844,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	enum exit_fastpath_completion exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
+	u16 exit_reason;
 
-	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
+	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
 
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
@@ -5866,11 +5866,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	if (is_guest_mode(vcpu) && nested_vmx_reflect_vmexit(vcpu))
 		return 1;
 
-	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
+	if (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
 		dump_vmcs();
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
-			= exit_reason;
+			= vmx->exit_reason;
 		return 0;
 	}
 
@@ -5882,6 +5882,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		return 0;
 	}
 
+	exit_reason = vmx->exit_reason;
+
 	/*
 	 * Note:
 	 * Do not try to fix EXIT_REASON_EPT_MISCONFIG if it caused by
@@ -5898,7 +5900,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
 		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
-		vcpu->run->internal.data[1] = exit_reason;
+		vcpu->run->internal.data[1] = vmx->exit_reason;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
 		if (exit_reason == EXIT_REASON_EPT_MISCONFIG) {
 			vcpu->run->internal.ndata++;
@@ -5957,13 +5959,14 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	return kvm_vmx_exit_handlers[exit_reason](vcpu);
 
 unexpected_vmexit:
-	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
+		    vmx->exit_reason);
 	dump_vmcs();
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
 	vcpu->run->internal.ndata = 1;
-	vcpu->run->internal.data[0] = exit_reason;
+	vcpu->run->internal.data[0] = vmx->exit_reason;
 	return 0;
 }
 
-- 
2.24.1

