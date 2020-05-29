Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D778B1E8204
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgE2Pjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:39:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53454 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727793AbgE2Pjk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cL4gMIny1Mbt/Yoi/DuXPhUBvtXU0cRRx4XztCd3qfI=;
        b=IDTBj3uH+sXK8sJJRL+Sm7HaeTUsWijkDL7SvwYmGJBh8kgKNSTkUz/HhNFxw5OqfW8HCg
        fGQjGACSggd3DL3UU0DPQ6Lf6l5L/4kCHMNQAvw+x4hOpBqmgbFIDPZfs32izfrQaRnov7
        l6JqFh/r3kLqL8eGH2o8U6zhzGONaB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-y2VFBXPaMCyz1515G0RGZg-1; Fri, 29 May 2020 11:39:37 -0400
X-MC-Unique: y2VFBXPaMCyz1515G0RGZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19AA7464;
        Fri, 29 May 2020 15:39:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B59F45D9D5;
        Fri, 29 May 2020 15:39:35 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 01/30] KVM: x86: track manually whether an event has been injected
Date:   Fri, 29 May 2020 11:39:05 -0400
Message-Id: <20200529153934.11694-2-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of calling kvm_event_needs_reinjection, track its
future return value in a variable.  This will be useful in
the next patch.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 329bdd2eb2cf..77b9b4e66673 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7717,11 +7717,14 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 static int inject_pending_event(struct kvm_vcpu *vcpu)
 {
 	int r;
+	bool can_inject = true;
 
 	/* try to reinject previous events if any */
 
-	if (vcpu->arch.exception.injected)
+	if (vcpu->arch.exception.injected) {
 		kvm_x86_ops.queue_exception(vcpu);
+		can_inject = false;
+	}
 	/*
 	 * Do not inject an NMI or interrupt if there is a pending
 	 * exception.  Exceptions and interrupts are recognized at
@@ -7737,10 +7740,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	 * fully complete the previous instruction.
 	 */
 	else if (!vcpu->arch.exception.pending) {
-		if (vcpu->arch.nmi_injected)
+		if (vcpu->arch.nmi_injected) {
 			kvm_x86_ops.set_nmi(vcpu);
-		else if (vcpu->arch.interrupt.injected)
+			can_inject = false;
+		} else if (vcpu->arch.interrupt.injected) {
 			kvm_x86_ops.set_irq(vcpu);
+			can_inject = false;
+		}
 	}
 
 	WARN_ON_ONCE(vcpu->arch.exception.injected &&
@@ -7790,10 +7796,11 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 		}
 
 		kvm_x86_ops.queue_exception(vcpu);
+		can_inject = false;
 	}
 
-	/* Don't consider new event if we re-injected an event */
-	if (kvm_event_needs_reinjection(vcpu))
+	/* Finish re-injection before considering new events */
+	if (!can_inject)
 		return 0;
 
 	if (vcpu->arch.smi_pending &&
-- 
2.26.2


