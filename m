Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF57382DED
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbhEQNwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:52:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234049AbhEQNwW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 09:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621259465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/5KkPOa7BDmJ61fDZWG5U+qX0pyk+buTzYClLDRiEU=;
        b=c6Zs9MTBvv89CPGkJ52eWDeyxKDslAz2tZTJMspn2vsGkw+OhXQO15S6LRyri6vcJXIyWy
        QDGUGbqdHarKjxZJF9n/OXCxHEh5ooySR2WjPzETTZ/T7lvvTBkDQeSJgB4IhmJJUnsFhZ
        RC3/OQtVHsgeIDRra23Tzak8UnTFpZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-exbYJMcbPCW3WBQjIQk5Hg-1; Mon, 17 May 2021 09:51:02 -0400
X-MC-Unique: exbYJMcbPCW3WBQjIQk5Hg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C69B8042A9;
        Mon, 17 May 2021 13:51:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36B3F5C1A1;
        Mon, 17 May 2021 13:50:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: nVMX: Introduce nested_evmcs_is_used()
Date:   Mon, 17 May 2021 15:50:48 +0200
Message-Id: <20210517135054.1914802-2-vkuznets@redhat.com>
In-Reply-To: <20210517135054.1914802-1-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unlike regular set_current_vmptr(), nested_vmx_handle_enlightened_vmptrld()
can not be called directly from vmx_set_nested_state() as KVM may not have
all the information yet (e.g. HV_X64_MSR_VP_ASSIST_PAGE MSR may not be
restored yet). Enlightened VMCS is mapped later while getting nested state
pages. In the meantime, vmx->nested.hv_evmcs remains NULL and using it
for various checks is incorrect. In particular, if KVM_GET_NESTED_STATE is
called right after KVM_SET_NESTED_STATE, KVM_STATE_NESTED_EVMCS flag in the
resulting state will be unset (and such state will later fail to load).

Introduce nested_evmcs_is_used() and use 'is_guest_mode(vcpu) &&
vmx->nested.current_vmptr == -1ull' check to detect not-yet-mapped eVMCS
after restore.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..3080e00c8f90 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -141,6 +141,27 @@ static void init_vmcs_shadow_fields(void)
 	max_shadow_read_write_fields = j;
 }
 
+static inline bool nested_evmcs_is_used(struct vcpu_vmx *vmx)
+{
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+
+	if (vmx->nested.hv_evmcs)
+		return true;
+
+	/*
+	 * After KVM_SET_NESTED_STATE, enlightened VMCS is mapped during
+	 * KVM_REQ_GET_NESTED_STATE_PAGES handling and until the request is
+	 * processed vmx->nested.hv_evmcs is NULL. It is, however, possible to
+	 * detect such state by checking 'nested.current_vmptr == -1ull' when
+	 * vCPU is in guest mode, it is only possible with eVMCS.
+	 */
+	if (unlikely(vmx->nested.enlightened_vmcs_enabled && is_guest_mode(vcpu) &&
+		     (vmx->nested.current_vmptr == -1ull)))
+		return true;
+
+	return false;
+}
+
 /*
  * The following 3 functions, nested_vmx_succeed()/failValid()/failInvalid(),
  * set the success or error code of an emulated VMX instruction (as specified
@@ -187,7 +208,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
 	 * failValid writes the error number to the current VMCS, which
 	 * can't be done if there isn't a current VMCS.
 	 */
-	if (vmx->nested.current_vmptr == -1ull && !vmx->nested.hv_evmcs)
+	if (vmx->nested.current_vmptr == -1ull && !nested_evmcs_is_used(vmx))
 		return nested_vmx_failInvalid(vcpu);
 
 	return nested_vmx_failValid(vcpu, vm_instruction_error);
@@ -2208,7 +2229,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	u32 exec_control;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
-	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
+	if (vmx->nested.dirty_vmcs12 || nested_evmcs_is_used(vmx))
 		prepare_vmcs02_early_rare(vmx, vmcs12);
 
 	/*
@@ -3437,7 +3458,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
-	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
+	if (enable_shadow_vmcs || nested_evmcs_is_used(vmx))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return NVMX_VMENTRY_VMEXIT;
 }
@@ -4032,7 +4053,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->nested.hv_evmcs)
+	if (nested_evmcs_is_used(vmx))
 		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = !vmx->nested.hv_evmcs;
@@ -6056,7 +6077,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		if (vmx_has_valid_vmcs12(vcpu)) {
 			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
-			if (vmx->nested.hv_evmcs)
+			if (nested_evmcs_is_used(vmx))
 				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
 
 			if (is_guest_mode(vcpu) &&
-- 
2.31.1

