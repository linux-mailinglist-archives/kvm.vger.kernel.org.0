Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C7E242E65
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 20:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHLSGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 14:06:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:43006 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgHLSGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 14:06:17 -0400
IronPort-SDR: FfZu0VQSB1bRIAF33KH8QyxXMRNMH9v7MGLC5u9oP6iL5MNIItLhN3Vz+lNvcEWq74XwzuayB1
 uxdhB+Fnoatg==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="133569778"
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="133569778"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 11:06:17 -0700
IronPort-SDR: gfBVxQ/FtmJxLpgjUjBFChXbTpXK9Kt0h2RZ4a53+i8J8dUxU2h9rPcImy/kVmVmz2ye9VkHF3
 hqRDBVNsFxUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="277908667"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2020 11:06:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Add VM-Enter failed tracepoints for super early checks
Date:   Wed, 12 Aug 2020 11:06:15 -0700
Message-Id: <20200812180615.22372-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tracepoints for the early consistency checks in nested_vmx_run().
The "VMLAUNCH vs. VMRESUME" check in particular is useful to trace, as
there is no architectural way to check VMCS.LAUNCH_STATE, and subtle
bugs such as VMCLEAR on the wrong HPA can lead to confusing errors in
the L1 VMM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 23b58c28a1c92..fb37f0972e78a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3468,11 +3468,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (evmptrld_status == EVMPTRLD_ERROR) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
-	} else if (evmptrld_status == EVMPTRLD_VMFAIL) {
+	} else if (CC(evmptrld_status == EVMPTRLD_VMFAIL)) {
 		return nested_vmx_failInvalid(vcpu);
 	}
 
-	if (!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull)
+	if (CC(!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
 	vmcs12 = get_vmcs12(vcpu);
@@ -3483,7 +3483,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * rather than RFLAGS.ZF, and no error number is stored to the
 	 * VM-instruction error field.
 	 */
-	if (vmcs12->hdr.shadow_vmcs)
+	if (CC(vmcs12->hdr.shadow_vmcs))
 		return nested_vmx_failInvalid(vcpu);
 
 	if (vmx->nested.hv_evmcs) {
@@ -3504,10 +3504,10 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * for misconfigurations which will anyway be caught by the processor
 	 * when using the merged vmcs02.
 	 */
-	if (interrupt_shadow & KVM_X86_SHADOW_INT_MOV_SS)
+	if (CC(interrupt_shadow & KVM_X86_SHADOW_INT_MOV_SS))
 		return nested_vmx_fail(vcpu, VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS);
 
-	if (vmcs12->launch_state == launch)
+	if (CC(vmcs12->launch_state == launch))
 		return nested_vmx_fail(vcpu,
 			launch ? VMXERR_VMLAUNCH_NONCLEAR_VMCS
 			       : VMXERR_VMRESUME_NONLAUNCHED_VMCS);
-- 
2.28.0

