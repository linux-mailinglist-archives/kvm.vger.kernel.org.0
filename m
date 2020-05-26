Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A771E28BF
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389056AbgEZRXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:23:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388944AbgEZRXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zsEdUKbb64cuYor8Oe940GH4M856nl/MDSfp4PY7VdM=;
        b=HjN0IlNb3D57p6MKhmLNP2tEotSWIAcWfxh1cdshQbwbeGNwx3R20oU2cAyJ3SxN8wYlCM
        zDR/tRK7Z980XhPrsGW6XbRjQGGoWaxHxdt5FMgbVUxBcvo7Nm4HjdMUAv+Mc0/gJmQH9k
        1koKNjBiXs6uj1GUNxUtX0nvgnycWSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-tDkVSMwVPNyrTROUAdq4iA-1; Tue, 26 May 2020 13:23:11 -0400
X-MC-Unique: tDkVSMwVPNyrTROUAdq4iA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41CBB835B43;
        Tue, 26 May 2020 17:23:10 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F2441001B07;
        Tue, 26 May 2020 17:23:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 01/28] KVM: x86: track manually whether an event has been injected
Date:   Tue, 26 May 2020 13:22:41 -0400
Message-Id: <20200526172308.111575-2-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index b226fb8abe41..064a7ea0e671 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7713,11 +7713,14 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
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
@@ -7733,10 +7736,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
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
@@ -7786,10 +7792,11 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
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


