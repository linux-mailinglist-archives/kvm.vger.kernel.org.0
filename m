Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320B71B840C
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDYHCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40211 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726400AbgDYHCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=F5d2hZyoWLkLFhOgbvoh0l9Xmnu5vZ/wvjbqCedo71Y=;
        b=bGsac07WjK6csCi/CpgUbF+jODT5gSccV5NLXO7PnmpDQjvPbHgexTiV9CEt6TfIZQAkQh
        m246cAqNwPOpBpK9DUqolYsDR5jNJyOD8IXAdtctjPMNSFVLZJE797LNFMcen9pMuSuPa/
        ZKSs/mMwL9hVXI9Oo8+sjaf7MPIqXuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-hhz45wqyOoOewXgRnfFx9g-1; Sat, 25 Apr 2020 03:02:17 -0400
X-MC-Unique: hhz45wqyOoOewXgRnfFx9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1E3C462;
        Sat, 25 Apr 2020 07:02:16 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3918600E8;
        Sat, 25 Apr 2020 07:02:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 20/22] KVM: VMX: Use vmx_interrupt_blocked() directly from vmx_handle_exit()
Date:   Sat, 25 Apr 2020 03:02:13 -0400
Message-Id: <20200425070215.251397-1-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Use vmx_interrupt_blocked() instead of bouncing through
vmx_interrupt_allowed() when handling edge cases in vmx_handle_exit().
The nested_run_pending check in vmx_interrupt_allowed() should never
evaluate true in the VM-Exit path.

Hoist the WARN in handle_invalid_guest_state() up to vmx_handle_exit()
to enforce the above assumption for the !enable_vnmi case, and to detect
any other potential bugs with nested VM-Enter.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200423022550.15113-12-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7fb7dcb3d94d..0e5eacd6f911 100644
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
2.18.2


