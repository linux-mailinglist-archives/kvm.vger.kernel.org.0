Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A455B60FD72
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiJ0QuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbiJ0Qtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:49:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4182339120
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666889390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IG7RoSwTbh4XkVF3g7VEhn0b4tnvYokb/Hy8R5iEPaY=;
        b=ddzc7AuzJ284qMe+mX49KrMwJXv/dYghk43qSaFwIZUglPXa6ylzruDEGJNEi66x00IUz8
        ue+hF9T8UEhrvcN/d6943vHuUKldYZmiK4J2bEKpbQgwOmAl7lLz2wmbspLrqs4ScjivhG
        Z/lhOLhx94rEUfaTWBqUA9ysoXjPTnI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-RnoFx3soM5q0oX6jTPeSQw-1; Thu, 27 Oct 2022 12:49:47 -0400
X-MC-Unique: RnoFx3soM5q0oX6jTPeSQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8DCA185A7A8;
        Thu, 27 Oct 2022 16:49:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A76B61121320;
        Thu, 27 Oct 2022 16:49:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 09/10] KVM: zero output of KVM_GET_VCPU_EVENTS before filling in the struct
Date:   Thu, 27 Oct 2022 12:49:43 -0400
Message-Id: <20221027164944.3031588-10-pbonzini@redhat.com>
In-Reply-To: <20221027164944.3031588-1-pbonzini@redhat.com>
References: <20221027164944.3031588-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows making some fields optional, as will be the case soon
for SMM-related data.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f6adb4145759..5959f74c5a0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5056,16 +5056,15 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	    ex->pending && ex->has_payload)
 		kvm_deliver_exception_payload(vcpu, ex);
 
+	memset(events, 0, sizeof(events));
+
 	/*
 	 * The API doesn't provide the instruction length for software
 	 * exceptions, so don't report them. As long as the guest RIP
 	 * isn't advanced, we should expect to encounter the exception
 	 * again.
 	 */
-	if (kvm_exception_is_soft(ex->vector)) {
-		events->exception.injected = 0;
-		events->exception.pending = 0;
-	} else {
+	if (!kvm_exception_is_soft(ex->vector)) {
 		events->exception.injected = ex->injected;
 		events->exception.pending = ex->pending;
 		/*
@@ -5085,15 +5084,13 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
 	events->interrupt.nr = vcpu->arch.interrupt.nr;
-	events->interrupt.soft = 0;
 	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
 	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
-	events->nmi.pad = 0;
 
-	events->sipi_vector = 0; /* never valid when reporting to user space */
+	/* events->sipi_vector is never valid when reporting to user space */
 
 	events->smi.smm = is_smm(vcpu);
 	events->smi.pending = vcpu->arch.smi_pending;
@@ -5110,8 +5107,6 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		events->triple_fault.pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		events->flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
 	}
-
-	memset(&events->reserved, 0, sizeof(events->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
-- 
2.31.1


