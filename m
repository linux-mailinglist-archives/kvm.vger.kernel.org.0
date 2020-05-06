Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BBA1C75E3
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgEFQK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:10:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27730 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729688AbgEFQK5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=kZPPxriWZX6GKqib57CUR0KHurjWMqJXVQoLVEPp5t4=;
        b=f1zstsF2BwvoIVYFb+z+mQqgKv0mbca5HQ4uU7U5WS8cQ+tjqPxBm9Ap/XjWhbnlvo2WN6
        habu9FoIJf3zomYkByzK9JLuy70p4stMiZIXznWXCqJZC8JvTlinlGf/Z9CHhCue4+IR57
        4CQoEb4Q6DHxC/H2pSgMnZMSlaS1mXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-Pk5GFsTpPHCClfx87srNYQ-1; Wed, 06 May 2020 12:10:53 -0400
X-MC-Unique: Pk5GFsTpPHCClfx87srNYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFB2880058A;
        Wed,  6 May 2020 16:10:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81A2527C39;
        Wed,  6 May 2020 16:10:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 1/7] KVM: VMX: Introduce generic fastpath handler
Date:   Wed,  6 May 2020 12:10:42 -0400
Message-Id: <20200506161048.28840-2-pbonzini@redhat.com>
In-Reply-To: <20200506161048.28840-1-pbonzini@redhat.com>
References: <20200506161048.28840-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption
timer fastpath etc; move it after vmx_complete_interrupts() in order to
catch events delivered to the guest, and abort the fast path in later
patches.  While at it, move the kvm_exit tracepoint so that it is printed
for fastpath vmexits as well.

There is no observed performance effect for the IPI fastpath after this patch.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <1588055009-12677-2-git-send-email-wanpengli@tencent.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13cdb8469848..ad57c4744b99 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5907,8 +5907,6 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	u32 exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
-	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
-
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
 	 * updated. Another good is, in kvm_vm_ioctl_get_dirty_log, before
@@ -6604,6 +6602,16 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	switch (to_vmx(vcpu)->exit_reason) {
+	case EXIT_REASON_MSR_WRITE:
+		return handle_fastpath_set_msr_irqoff(vcpu);
+	default:
+		return EXIT_FASTPATH_NONE;
+	}
+}
+
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
@@ -6778,17 +6786,18 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return EXIT_FASTPATH_NONE;
 
-	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
-		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
-	else
-		exit_fastpath = EXIT_FASTPATH_NONE;
-
 	vmx->loaded_vmcs->launched = 1;
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
+	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
+
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
+	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
 	return exit_fastpath;
 }
 
-- 
2.18.2


