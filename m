Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDDE390324
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhEYNz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 09:55:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233426AbhEYNzr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 09:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621950857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=xrhUqBJUijGQwgB+DReNzr5ztKeOOykMqFsLk66ZLKY=;
        b=SbKPMTbYKt+9PsLzEbynwPah/UIWtG6cbITKegkWMtg5SYWMYPcrgJZqR1YILNvRRBzybQ
        h4FsI6OQyt1mejSxulER525GhOOW4iOJWQ2FDM6jBzhZn16Sp6V4dNnOmRTBC+EqEJtKTl
        dH4sIiF11rZlCYommX9azi8PPdpvFnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-MRm9T_1pP02Xb4YmpUoz_g-1; Tue, 25 May 2021 09:54:15 -0400
X-MC-Unique: MRm9T_1pP02Xb4YmpUoz_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52EE0803622;
        Tue, 25 May 2021 13:54:14 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B59618B39;
        Tue, 25 May 2021 13:54:07 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id B2E9C4172EDB; Tue, 25 May 2021 10:44:35 -0300 (-03)
Message-ID: <20210525134321.254128742@redhat.com>
User-Agent: quilt/0.66
Date:   Tue, 25 May 2021 10:41:16 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 1/3] KVM: x86: add start_assignment hook to kvm_x86_ops
References: <20210525134115.135966361@redhat.com>
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
+	void (*start_assignment)(struct kvm *kvm);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
 
Index: kvm/arch/x86/kvm/x86.c
===================================================================
--- kvm.orig/arch/x86/kvm/x86.c
+++ kvm/arch/x86/kvm/x86.c
@@ -11295,7 +11295,8 @@ bool kvm_arch_can_dequeue_async_page_pre
 
 void kvm_arch_start_assignment(struct kvm *kvm)
 {
-	atomic_inc(&kvm->arch.assigned_device_count);
+	if (atomic_inc_return(&kvm->arch.assigned_device_count) == 1)
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


