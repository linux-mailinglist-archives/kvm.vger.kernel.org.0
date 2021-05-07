Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431893765C9
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbhEGNLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 09:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236434AbhEGNLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 09:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620393019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=yZmXVCCtQd+G9YWj0HVU+KdVOSHrhwSnoYMJJQ0B04w=;
        b=BUWYgA7sTe5A+ytt2V2DA2EspZ4ierxMWWeOklolacJrE+Sa54J6XAqJ08pofUVjOg61oT
        eKOLbbOLQ967FGr6NXr/PHzQxXIlqymNCEOfE9jWMBZTgFwQYYyGCoOZ2dgw4Jf6NPEO7R
        te1HDVzFq00rIXR+w2Gr+QE74vqatFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-nqxt_hWAMvKorCU_9QPP1Q-1; Fri, 07 May 2021 09:10:17 -0400
X-MC-Unique: nqxt_hWAMvKorCU_9QPP1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF4A3107ACC7;
        Fri,  7 May 2021 13:10:16 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8EE536E0;
        Fri,  7 May 2021 13:10:12 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id A01B941486FD; Fri,  7 May 2021 10:10:07 -0300 (-03)
Message-ID: <20210507130923.438255076@redhat.com>
User-Agent: quilt/0.66
Date:   Fri, 07 May 2021 10:06:10 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 1/4] KVM: x86: add start_assignment hook to kvm_x86_ops
References: <20210507130609.269153197@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a start_assignment hook to kvm_x86_ops, which is called when 
kvm_arch_start_assignment is done.

The hook is required to update the wakeup vector of a sleeping vCPU
when a device is assigned to the guest.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: kvm/arch/x86/include/asm/kvm_host.h
===================================================================
--- kvm.orig/arch/x86/include/asm/kvm_host.h
+++ kvm/arch/x86/include/asm/kvm_host.h
@@ -1322,6 +1322,7 @@ struct kvm_x86_ops {
 
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
+	void (*start_assignment)(struct kvm *kvm, int device_count);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
 
Index: kvm/arch/x86/kvm/svm/svm.c
===================================================================
--- kvm.orig/arch/x86/kvm/svm/svm.c
+++ kvm/arch/x86/kvm/svm/svm.c
@@ -4601,6 +4601,7 @@ static struct kvm_x86_ops svm_x86_ops __
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
 	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = svm_update_pi_irte,
+	.start_assignment = NULL,
 	.setup_mce = svm_setup_mce,
 
 	.smi_allowed = svm_smi_allowed,
Index: kvm/arch/x86/kvm/vmx/vmx.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/vmx.c
+++ kvm/arch/x86/kvm/vmx/vmx.c
@@ -7732,6 +7732,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 	.nested_ops = &vmx_nested_ops,
 
 	.update_pi_irte = pi_update_irte,
+	.start_assignment = NULL,
 
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,
Index: kvm/arch/x86/kvm/x86.c
===================================================================
--- kvm.orig/arch/x86/kvm/x86.c
+++ kvm/arch/x86/kvm/x86.c
@@ -11295,7 +11295,10 @@ bool kvm_arch_can_dequeue_async_page_pre
 
 void kvm_arch_start_assignment(struct kvm *kvm)
 {
-	atomic_inc(&kvm->arch.assigned_device_count);
+	int ret;
+
+	ret = atomic_inc_return(&kvm->arch.assigned_device_count);
+	static_call_cond(kvm_x86_start_assignment)(kvm, ret);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
 
Index: kvm/arch/x86/include/asm/kvm-x86-ops.h
===================================================================
--- kvm.orig/arch/x86/include/asm/kvm-x86-ops.h
+++ kvm/arch/x86/include/asm/kvm-x86-ops.h
@@ -99,6 +99,7 @@ KVM_X86_OP_NULL(post_block)
 KVM_X86_OP_NULL(vcpu_blocking)
 KVM_X86_OP_NULL(vcpu_unblocking)
 KVM_X86_OP_NULL(update_pi_irte)
+KVM_X86_OP_NULL(start_assignment)
 KVM_X86_OP_NULL(apicv_post_state_restore)
 KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_NULL(set_hv_timer)


