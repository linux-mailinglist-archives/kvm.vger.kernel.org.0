Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294EE3765CB
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 15:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhEGNLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 09:11:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236480AbhEGNLV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 09:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620393021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=0FISU66+bSzKWpxBjhGrO1Tlhi9U0QwtDOlzrc6O7DQ=;
        b=CNABv+0g3KaGtuL62LCbV6WFzQHgonfCeYHGciRH90bO0QRgUnro1Anmtlcg4SOpEdKdim
        stl9XiiVyRBXSz+I+GpOtupval/Aap8UwQSjHJmckVZmlE8fwNKZUZvq8owXY64ak4uaJc
        x296V2+D/JUndBXCJXXG6dp9n//FPGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-ZErEkDUlNwqGgWd_f8nj1g-1; Fri, 07 May 2021 09:10:17 -0400
X-MC-Unique: ZErEkDUlNwqGgWd_f8nj1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4DAF10066E6;
        Fri,  7 May 2021 13:10:16 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E6595100164A;
        Fri,  7 May 2021 13:10:12 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id A776F40B1EB1; Fri,  7 May 2021 10:10:07 -0300 (-03)
Message-ID: <20210507130923.498207045@redhat.com>
User-Agent: quilt/0.66
Date:   Fri, 07 May 2021 10:06:12 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 3/4] KVM: x86: implement kvm_arch_vcpu_check_block callback
References: <20210507130609.269153197@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 	void (*start_assignment)(struct kvm *kvm, int device_count);
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


