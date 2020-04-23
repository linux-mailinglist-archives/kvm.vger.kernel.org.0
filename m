Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9DE1B5266
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgDWC0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:33065 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgDWCZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:59 -0400
IronPort-SDR: REO5yVs0shxwcwZlDnWQB6Bc3qxgbwrXiDpp5iIFTtearGmtFxPBo3fH5I40+cpdQHb7hVyocw
 vhT8E0xUwH3Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:55 -0700
IronPort-SDR: 2Z/0fy1Rj0mpp5HFgJpPAkSaA7HUQoMV89zmGJqKByl/vjrCA/CzdXYCq+JEjbLy8gSDNGasTb
 0NBw3t7FIu0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273964"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 11/13] KVM: VMX: Use vmx_interrupt_blocked() directly from vmx_handle_exit()
Date:   Wed, 22 Apr 2020 19:25:48 -0700
Message-Id: <20200423022550.15113-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vmx_interrupt_blocked() instead of bouncing through
vmx_interrupt_allowed() when handling edge cases in vmx_handle_exit().
The nested_run_pending check in vmx_interrupt_allowed() should never
evaluate true in the VM-Exit path.

Hoist the WARN in handle_invalid_guest_state() up to vmx_handle_exit()
to enforce the above assumption for the !enable_vnmi case, and to detect
any other potential bugs with nested VM-Enter.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50c726a21feb..2f8cacb3aa9b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5268,18 +5268,11 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	bool intr_window_requested;
 	unsigned count = 130;
 
-	/*
-	 * We should never reach the point where we are emulating L2
-	 * due to invalid guest state as that means we incorrectly
-	 * allowed a nested VMEntry with an invalid vmcs12.
-	 */
-	WARN_ON_ONCE(vmx->emulation_required && vmx->nested.nested_run_pending);
-
 	intr_window_requested = exec_controls_get(vmx) &
 				CPU_BASED_INTR_WINDOW_EXITING;
 
 	while (vmx->emulation_required && count-- != 0) {
-		if (intr_window_requested && vmx_interrupt_allowed(vcpu))
+		if (intr_window_requested && !vmx_interrupt_blocked(vcpu))
 			return handle_interrupt_window(&vmx->vcpu);
 
 		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
@@ -5896,6 +5889,14 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	if (enable_pml)
 		vmx_flush_pml_buffer(vcpu);
 
+	/*
+	 * We should never reach this point with a pending nested VM-Enter, and
+	 * more specifically emulation of L2 due to invalid guest state (see
+	 * below) should never happen as that means we incorrectly allowed a
+	 * nested VM-Enter with an invalid vmcs12.
+	 */
+	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+
 	/* If guest state is invalid, start emulating */
 	if (vmx->emulation_required)
 		return handle_invalid_guest_state(vcpu);
@@ -5962,7 +5963,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 
 	if (unlikely(!enable_vnmi &&
 		     vmx->loaded_vmcs->soft_vnmi_blocked)) {
-		if (vmx_interrupt_allowed(vcpu)) {
+		if (!vmx_interrupt_blocked(vcpu)) {
 			vmx->loaded_vmcs->soft_vnmi_blocked = 0;
 		} else if (vmx->loaded_vmcs->vnmi_blocked_time > 1000000000LL &&
 			   vcpu->arch.nmi_pending) {
-- 
2.26.0

