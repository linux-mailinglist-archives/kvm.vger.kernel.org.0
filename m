Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EE91838E8
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCLSpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:45:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:23441 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgCLSpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041240"
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
Subject: [PATCH 06/10] KVM: nVMX: Convert local exit_reason to u16 in ...enter_non_root_mode()
Date:   Thu, 12 Mar 2020 11:45:17 -0700
Message-Id: <20200312184521.24579-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312184521.24579-1-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a u16 for nested_vmx_enter_non_root_mode()'s local "exit_reason" to
make it clear the intermediate code is only responsible for setting the
basic exit reason, e.g. FAILED_VMENTRY is unconditionally OR'd in when
emulating a failed VM-Entry.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1848ca0116c0..8fbbe2152ab7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3182,7 +3182,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	bool evaluate_pending_interrupts;
-	u32 exit_reason = EXIT_REASON_INVALID_STATE;
+	u16 exit_reason = EXIT_REASON_INVALID_STATE;
 	u32 exit_qual;
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
@@ -3308,7 +3308,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		return NVMX_VMENTRY_VMEXIT;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
-	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
+	vmcs12->vm_exit_reason = VMX_EXIT_REASONS_FAILED_VMENTRY | exit_reason;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
-- 
2.24.1

