Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F369B379686
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhEJRzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233202AbhEJRzg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 13:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620669271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+SqBR60U/QBsCk2Imhxb5S4zSqBj0ElVA682Wmxx+xQ=;
        b=QHdMz47wzf7bx2clKfNMf/m/BXge0XiA+Iyj9HnxvA4ua3tm3FjLseVoBidzaaTv6u1s2A
        QI8KpzS3rTMm4+xEODrFb8xX3aGLb0l3CtdUi5Mb4xlNwNyC4YQ8ZEM95nj56ZuXyYkrwG
        rI6qfc3Dsr+F6a+1HVt2pLcgPlNNj04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-nCcLRB3rPvWfxIhzkyfdeQ-1; Mon, 10 May 2021 13:54:27 -0400
X-MC-Unique: nCcLRB3rPvWfxIhzkyfdeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A404F107ACC7;
        Mon, 10 May 2021 17:54:26 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BD2119C45;
        Mon, 10 May 2021 17:54:20 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8022B4401881; Mon, 10 May 2021 14:54:15 -0300 (-03)
Message-ID: <20210510172817.994523393@redhat.com>
User-Agent: quilt/0.66
Date:   Mon, 10 May 2021 14:26:49 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 3/4] KVM: x86: implement kvm_arch_vcpu_check_block callback
References: <20210510172646.930550753@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm_arch_vcpu_check_block for x86. Next patch will add
implementation of kvm_x86_ops.vcpu_check_block for VMX.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: kvm/arch/x86/include/asm/kvm_host.h
===================================================================
--- kvm.orig/arch/x86/include/asm/kvm_host.h
+++ kvm/arch/x86/include/asm/kvm_host.h
@@ -1320,6 +1320,8 @@ struct kvm_x86_ops {
 	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
 	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
 
+	int (*vcpu_check_block)(struct kvm_vcpu *vcpu);
+
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
 	void (*start_assignment)(struct kvm *kvm);
@@ -1801,6 +1803,15 @@ static inline bool kvm_irq_is_postable(s
 		irq->delivery_mode == APIC_DM_LOWEST);
 }
 
+#define __KVM_HAVE_ARCH_VCPU_CHECK_BLOCK
+static inline int kvm_arch_vcpu_check_block(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops.vcpu_check_block)
+		return static_call(kvm_x86_vcpu_check_block)(vcpu);
+
+	return 0;
+}
+
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	static_call_cond(kvm_x86_vcpu_blocking)(vcpu);
Index: kvm/arch/x86/kvm/vmx/vmx.c
===================================================================
--- kvm.orig/arch/x86/kvm/vmx/vmx.c
+++ kvm/arch/x86/kvm/vmx/vmx.c
@@ -7727,6 +7727,7 @@ static struct kvm_x86_ops vmx_x86_ops __
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
+	.vcpu_check_block = NULL,
 
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
Index: kvm/arch/x86/include/asm/kvm-x86-ops.h
===================================================================
--- kvm.orig/arch/x86/include/asm/kvm-x86-ops.h
+++ kvm/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,6 +98,7 @@ KVM_X86_OP_NULL(pre_block)
 KVM_X86_OP_NULL(post_block)
 KVM_X86_OP_NULL(vcpu_blocking)
 KVM_X86_OP_NULL(vcpu_unblocking)
+KVM_X86_OP_NULL(vcpu_check_block)
 KVM_X86_OP_NULL(update_pi_irte)
 KVM_X86_OP_NULL(start_assignment)
 KVM_X86_OP_NULL(apicv_post_state_restore)
Index: kvm/arch/x86/kvm/svm/svm.c
===================================================================
--- kvm.orig/arch/x86/kvm/svm/svm.c
+++ kvm/arch/x86/kvm/svm/svm.c
@@ -4517,6 +4517,7 @@ static struct kvm_x86_ops svm_x86_ops __
 	.vcpu_put = svm_vcpu_put,
 	.vcpu_blocking = svm_vcpu_blocking,
 	.vcpu_unblocking = svm_vcpu_unblocking,
+	.vcpu_check_block = NULL,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,


