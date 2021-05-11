Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D45537B2E1
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 02:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhELACr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 20:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhELACr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 20:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620777699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=6iQcJfFQ9PAT1toBR712mVEA6YqxpgzftwpN0mudfKw=;
        b=E9XmotiwuIzOCpj6uK4PzST0st3eFxUXtBCt8hLXZus475XxLM40i4CrjW1U3SY1CxhIyt
        EFBQs/FechdvCVCaqMHLrjDMRmwxZvxEUX6KwTiFiiyHgt3fy6ZW2PKIvfVcD7J0qtGsq2
        8OBRoATsEsoReQ+fjvFCniqKPQwwnxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-cZVet68sNzmIDnYxpiIDgA-1; Tue, 11 May 2021 20:01:36 -0400
X-MC-Unique: cZVet68sNzmIDnYxpiIDgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 505091005D51;
        Wed, 12 May 2021 00:01:35 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28D3F101F501;
        Wed, 12 May 2021 00:01:25 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8EDA843F79E8; Tue, 11 May 2021 21:01:20 -0300 (-03)
Message-ID: <20210512000101.954011777@redhat.com>
User-Agent: quilt/0.66
Date:   Tue, 11 May 2021 20:57:41 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 3/4] KVM: x86: implement kvm_arch_vcpu_check_block callback
References: <20210511235738.333950860@redhat.com>
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


