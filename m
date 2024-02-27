Return-Path: <kvm+bounces-10164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C18F686A3D7
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDF43B2E706
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8795B5B0;
	Tue, 27 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VoUkwouT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA8658129
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076073; cv=none; b=lI/zxLUDHmC3d8CmTaWGstTrt0jZv7jHwHg+7EdelDT9AA1YAOJ/R4VnrqkZFDTJ6BGvrS6e8BX7u2XG/7lseoavyU95UQUvJnGGI8J/XB6f7+DdCwCHrBrj+zrx1BurDZmtuiyYJ8khGQBXTrZP4feW8JBkgedmQHwQg/Enq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076073; c=relaxed/simple;
	bh=AJ+B0FrHSNRu31IBbfmm1tYsIiofE/NifalgqPDy/Ng=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKLNsGQiCFvr9fgBHKxveGXJWRhqv8Xx/F6WqEZtmLEMlc7FSwHGSkLtdVlIdQaq7NPhm5uSfnS0fMq9Y+tfimwYOJFbxXekQ1LEDd1Jfs3YIVcXSN8LwRLZXPpOgcw4r7Llpqjr2LoPvyHGwYkMENiCTuVOCv9yJ6R4I8XfuI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VoUkwouT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fGS3MxnywIk2P3LLbijhge2gtItFefuPKT0i/X1AVBM=;
	b=VoUkwouT04EvfpLQ49Q0wQw3Z4b2TSR1b7pLJjmoeBie6ipR8fUndDsyEbbReMDCTnj/Ul
	mtW20C/ws9YHVoyS/YudaBvAyItPM/OfgYu6d2gM1vxhsSlFXsUSifK5pLS+wXFOpl08PX
	Eu9wsUmoaAACv0SuAajJ7ZhtEF9gASM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-gpFf_sLQNOebo87RdrLyXA-1; Tue,
 27 Feb 2024 18:21:03 -0500
X-MC-Unique: gpFf_sLQNOebo87RdrLyXA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F33C13C13A87;
	Tue, 27 Feb 2024 23:21:02 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C65294EA55;
	Tue, 27 Feb 2024 23:21:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 09/21] KVM: VMX: Modify NMI and INTR handlers to take intr_info as function argument
Date: Tue, 27 Feb 2024 18:20:48 -0500
Message-Id: <20240227232100.478238-10-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Sean Christopherson <seanjc@google.com>

TDX uses different ABI to get information about VM exit.  Pass intr_info to
the NMI and INTR handlers instead of pulling it from vcpu_vmx in
preparation for sharing the bulk of the handlers with TDX.

When the guest TD exits to VMM, RAX holds status and exit reason, RCX holds
exit qualification etc rather than the VMCS fields because VMM doesn't have
access to the VMCS.  The eventual code will be

VMX:
  - get exit reason, intr_info, exit_qualification, and etc from VMCS
  - call NMI/INTR handlers (common code)

TDX:
  - get exit reason, intr_info, exit_qualification, and etc from guest
    registers
  - call NMI/INTR handlers (common code)

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <0396a9ae70d293c9d0b060349dae385a8a4fbcec.1705965635.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3d8a7e4c8e37..8aedfe0fd78c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7000,24 +7000,22 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-static void handle_exception_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
-
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
-		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
 	/* if exit due to NM, handle before interrupts are enabled */
 	else if (is_nm_fault(intr_info))
-		handle_nm_fault_irqoff(&vmx->vcpu);
+		handle_nm_fault_irqoff(vcpu);
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
 }
 
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
+static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
+					     u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
 	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
@@ -7040,9 +7038,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu);
+		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_irqoff(vmx);
+		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
 /*
-- 
2.39.0



