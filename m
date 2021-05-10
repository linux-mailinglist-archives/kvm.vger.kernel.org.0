Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB2F379687
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhEJRzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231512AbhEJRzf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 13:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620669270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=T6XQ723YNp2P/eb+4YbFfQ3fMPYItgFEaCDeufUV3/E=;
        b=eqfSEdivSrF7DdfVwntfcuenOlDxLBJdAV1PtqQPH5b3hp+KJhfWoTc1ztw2lSzn2BEDFB
        WPYLOVvbOXOTJCZTxyD3STcSae785lkyU0Y5D/MuvMAt8jYwTf1hetdJ7raHybnIm6pyXq
        wphT6ihHsuCDYZEO7beif916hmbGAlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-aIG9LxA6OPGjAdsL0hnV3w-1; Mon, 10 May 2021 13:54:28 -0400
X-MC-Unique: aIG9LxA6OPGjAdsL0hnV3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5446683DB69;
        Mon, 10 May 2021 17:54:27 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F3EA421F;
        Mon, 10 May 2021 17:54:20 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 7858D440187A; Mon, 10 May 2021 14:54:15 -0300 (-03)
Message-ID: <20210510172817.934490238@redhat.com>
User-Agent: quilt/0.66
Date:   Mon, 10 May 2021 14:26:47 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 1/4] KVM: x86: add start_assignment hook to kvm_x86_ops
References: <20210510172646.930550753@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
+	void (*start_assignment)(struct kvm *kvm);
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
@@ -11295,7 +11295,11 @@ bool kvm_arch_can_dequeue_async_page_pre
 
 void kvm_arch_start_assignment(struct kvm *kvm)
 {
-	atomic_inc(&kvm->arch.assigned_device_count);
+	int ret;
+
+	ret = atomic_inc_return(&kvm->arch.assigned_device_count);
+	if (ret == 1)
+		static_call_cond(kvm_x86_start_assignment)(kvm);
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


