Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F4C2EBCD4
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbhAFKyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:54:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727214AbhAFKyq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:54:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4ueySyqGVeSAb89GWtUcgfgaOdq5moM0rQARjz9DME=;
        b=U9LSBARwezH1wyts7mSDSrlw/CzOcVc75t5f1uOzdiG8qxvXVxDHGAwNxqVSjyO+juDBa5
        AlYyCIoVA6DJIfV2potCCqw28eGi3/iqVS865BHsUa2Xta2zDsPVJErIvJsPfDTTUsVLuH
        X/6NMIaX+t6TO64LrCkAMTCSld8aEIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-7ffn7EJ9PRmCG3wWACufMQ-1; Wed, 06 Jan 2021 05:53:18 -0500
X-MC-Unique: 7ffn7EJ9PRmCG3wWACufMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4709D1926DA2;
        Wed,  6 Jan 2021 10:53:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 998715B4A9;
        Wed,  6 Jan 2021 10:53:12 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] KVM: VMX: create vmx_process_injected_event
Date:   Wed,  6 Jan 2021 12:53:05 +0200
Message-Id: <20210106105306.450602-2-mlevitsk@redhat.com>
In-Reply-To: <20210106105306.450602-1-mlevitsk@redhat.com>
References: <20210106105306.450602-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the logic that is dealing with parsing of an injected event to a
separate function.

This will be used in the next patch to deal with the events that L1 wants to
inject to L2 in a way that survives migration.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 60 ++++++++++++++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h |  4 +++
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a45..dec6bc94a56b4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6442,29 +6442,16 @@ static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
 					      vmx->loaded_vmcs->entry_time));
 }
 
-static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
-				      u32 idt_vectoring_info,
-				      int instr_len_field,
-				      int error_code_field)
+void vmx_process_injected_event(struct kvm_vcpu *vcpu,
+				u32 idt_vectoring_info,
+				u32 instr_len,
+				u32 error_code)
 {
-	u8 vector;
-	int type;
-	bool idtv_info_valid;
-
-	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
-
-	vcpu->arch.nmi_injected = false;
-	kvm_clear_exception_queue(vcpu);
-	kvm_clear_interrupt_queue(vcpu);
-
-	if (!idtv_info_valid)
-		return;
+	u8 vector = idt_vectoring_info & VECTORING_INFO_VECTOR_MASK;
+	u32 type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
-	vector = idt_vectoring_info & VECTORING_INFO_VECTOR_MASK;
-	type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
-
 	switch (type) {
 	case INTR_TYPE_NMI_INTR:
 		vcpu->arch.nmi_injected = true;
@@ -6476,17 +6463,16 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 		vmx_set_nmi_mask(vcpu, false);
 		break;
 	case INTR_TYPE_SOFT_EXCEPTION:
-		vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
+		vcpu->arch.event_exit_inst_len = instr_len;
 		fallthrough;
 	case INTR_TYPE_HARD_EXCEPTION:
 		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
-			u32 err = vmcs_read32(error_code_field);
-			kvm_requeue_exception_e(vcpu, vector, err);
+			kvm_requeue_exception_e(vcpu, vector, error_code);
 		} else
 			kvm_requeue_exception(vcpu, vector);
 		break;
 	case INTR_TYPE_SOFT_INTR:
-		vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
+		vcpu->arch.event_exit_inst_len = instr_len;
 		fallthrough;
 	case INTR_TYPE_EXT_INTR:
 		kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);
@@ -6496,6 +6482,34 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 	}
 }
 
+static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
+				      u32 idt_vectoring_info,
+				      int instr_len_field,
+				      int error_code_field)
+{
+	u32 instr_len = 0, err_code = 0;
+	u32 type;
+
+	vcpu->arch.nmi_injected = false;
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
+
+	if (!(idt_vectoring_info & VECTORING_INFO_VALID_MASK))
+		return;
+
+	type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
+
+	if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK)
+		err_code = vmcs_read32(error_code_field);
+
+	if (type == INTR_TYPE_SOFT_EXCEPTION || type == INTR_TYPE_SOFT_INTR)
+		instr_len = vmcs_read32(instr_len_field);
+
+	vmx_process_injected_event(vcpu, idt_vectoring_info, instr_len,
+				   err_code);
+}
+
+
 static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 {
 	__vmx_complete_interrupts(&vmx->vcpu, vmx->idt_vectoring_info,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d3a557949ac2..0c9ecada11025 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -336,6 +336,10 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void vmx_process_injected_event(struct kvm_vcpu *vcpu,
+				u32 idt_vectoring_info,
+				u32 instr_len,
+				u32 error_code);
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-- 
2.26.2

