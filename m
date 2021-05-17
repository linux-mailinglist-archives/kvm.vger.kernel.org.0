Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D648A382DF5
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237581AbhEQNwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237582AbhEQNw2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 09:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621259471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iTSgoi2+p2UUNwQubZgHF3n83bG1asZa0ndPbeBrsBI=;
        b=XTae21BnrJXoTY6cgK0Y9QA/TWoVMWyy8Km2s5y69PVR3LjIesbOpjc2AgMDhPjU99DrMn
        FsjhY+vlYwXzabsCS06d+svJ4b2sSnxSfo9eTqP7Ce0Ct89opZ6GEq8kdKU7XxzTNIg25o
        jTlfu4Ps6sVqzSmSC26VGg9+y39ZZmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-a_cFq6PCNReGCCdWH_GstQ-1; Mon, 17 May 2021 09:51:06 -0400
X-MC-Unique: a_cFq6PCNReGCCdWH_GstQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ACD7107ACC7;
        Mon, 17 May 2021 13:51:05 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 275275C1A1;
        Mon, 17 May 2021 13:51:02 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in vmx_get_nested_state()
Date:   Mon, 17 May 2021 15:50:50 +0200
Message-Id: <20210517135054.1914802-4-vkuznets@redhat.com>
In-Reply-To: <20210517135054.1914802-1-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'Clean fields' data from enlightened VMCS is only valid upon vmentry: L1
hypervisor is not obliged to keep it up-to-date while it is mangling L2's
state, KVM_GET_NESTED_STATE request may come at a wrong moment when actual
eVMCS changes are unsynchronized with 'hv_clean_fields'. As upon migration
VMCS12 is used as a source of ultimate truth, we must make sure we pick all
the changes to eVMCS and thus 'clean fields' data must be ignored.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 49 +++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ea2869d8b823..ec476f64df73 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1607,7 +1607,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	vmcs_load(vmx->loaded_vmcs->vmcs);
 }
 
-static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
+static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
@@ -1616,7 +1616,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 	vmcs12->tpr_threshold = evmcs->tpr_threshold;
 	vmcs12->guest_rip = evmcs->guest_rip;
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC))) {
 		vmcs12->guest_rsp = evmcs->guest_rsp;
 		vmcs12->guest_rflags = evmcs->guest_rflags;
@@ -1624,23 +1624,23 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 			evmcs->guest_interruptibility_info;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC))) {
 		vmcs12->cpu_based_vm_exec_control =
 			evmcs->cpu_based_vm_exec_control;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN))) {
 		vmcs12->exception_bitmap = evmcs->exception_bitmap;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_ENTRY))) {
 		vmcs12->vm_entry_controls = evmcs->vm_entry_controls;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT))) {
 		vmcs12->vm_entry_intr_info_field =
 			evmcs->vm_entry_intr_info_field;
@@ -1650,7 +1650,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 			evmcs->vm_entry_instruction_len;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1))) {
 		vmcs12->host_ia32_pat = evmcs->host_ia32_pat;
 		vmcs12->host_ia32_efer = evmcs->host_ia32_efer;
@@ -1670,7 +1670,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 		vmcs12->host_tr_selector = evmcs->host_tr_selector;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1))) {
 		vmcs12->pin_based_vm_exec_control =
 			evmcs->pin_based_vm_exec_control;
@@ -1679,18 +1679,18 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 			evmcs->secondary_vm_exec_control;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP))) {
 		vmcs12->io_bitmap_a = evmcs->io_bitmap_a;
 		vmcs12->io_bitmap_b = evmcs->io_bitmap_b;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP))) {
 		vmcs12->msr_bitmap = evmcs->msr_bitmap;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2))) {
 		vmcs12->guest_es_base = evmcs->guest_es_base;
 		vmcs12->guest_cs_base = evmcs->guest_cs_base;
@@ -1730,14 +1730,14 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 		vmcs12->guest_tr_selector = evmcs->guest_tr_selector;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2))) {
 		vmcs12->tsc_offset = evmcs->tsc_offset;
 		vmcs12->virtual_apic_page_addr = evmcs->virtual_apic_page_addr;
 		vmcs12->xss_exit_bitmap = evmcs->xss_exit_bitmap;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR))) {
 		vmcs12->cr0_guest_host_mask = evmcs->cr0_guest_host_mask;
 		vmcs12->cr4_guest_host_mask = evmcs->cr4_guest_host_mask;
@@ -1749,7 +1749,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 		vmcs12->guest_dr7 = evmcs->guest_dr7;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER))) {
 		vmcs12->host_fs_base = evmcs->host_fs_base;
 		vmcs12->host_gs_base = evmcs->host_gs_base;
@@ -1759,13 +1759,13 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
 		vmcs12->host_rsp = evmcs->host_rsp;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT))) {
 		vmcs12->ept_pointer = evmcs->ept_pointer;
 		vmcs12->virtual_processor_id = evmcs->virtual_processor_id;
 	}
 
-	if (unlikely(!(evmcs->hv_clean_fields &
+	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1))) {
 		vmcs12->vmcs_link_pointer = evmcs->vmcs_link_pointer;
 		vmcs12->guest_ia32_debugctl = evmcs->guest_ia32_debugctl;
@@ -3473,6 +3473,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	enum nvmx_vmentry_status status;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
+	struct hv_enlightened_vmcs *evmcs;
 	enum nested_evmptrld_status evmptrld_status;
 
 	++vcpu->stat.nested_run;
@@ -3488,7 +3489,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return nested_vmx_failInvalid(vcpu);
 	}
 
-	if (CC(!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull))
+	evmcs = vmx->nested.hv_evmcs;
+	if (CC(!evmcs && vmx->nested.current_vmptr == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
 	vmcs12 = get_vmcs12(vcpu);
@@ -3502,8 +3504,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (CC(vmcs12->hdr.shadow_vmcs))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (vmx->nested.hv_evmcs) {
-		copy_enlightened_to_vmcs12(vmx);
+	if (evmcs) {
+		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
 		/* Enlightened VMCS doesn't have launch state */
 		vmcs12->launch_state = !launch;
 	} else if (enable_shadow_vmcs) {
@@ -6136,7 +6138,14 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
 		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
 			if (vmx->nested.hv_evmcs)
-				copy_enlightened_to_vmcs12(vmx);
+				/*
+				 * L1 hypervisor is not obliged to keep eVMCS
+				 * clean fields data always up-to-date while
+				 * not in guest mode, 'hv_clean_fields' is only
+				 * supposed to be actual upon vmentry so we need
+				 * to ignore it here and do full copy.
+				 */
+				copy_enlightened_to_vmcs12(vmx, 0);
 			else if (enable_shadow_vmcs)
 				copy_shadow_to_vmcs12(vmx);
 		}
-- 
2.31.1

