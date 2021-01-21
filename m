Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5F2FF18C
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 18:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388660AbhAUROt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 12:14:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388484AbhAURMt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 12:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611249060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5rKUNjt01VoES9GlPh1WMo1aTJXvhTfji5QKEBauJY=;
        b=S5oBDeHaI8L36ju8jdgsp8XnidfBgxfe6wzpaWIb3YYs7TeDhvxYE7l+WuDvHb22PHN34Q
        VbdPvA+OJTkHfOau6MsLFZvpTrB9Ct33pEOmH9yKBWHLnXWRW7kCx5fHHgAbFviTB9YuvL
        QKFNfODNFLOWliCu2KHjLjbEaqvXWC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-loOPaVgAOvKY3MyGNfQODg-1; Thu, 21 Jan 2021 12:10:58 -0500
X-MC-Unique: loOPaVgAOvKY3MyGNfQODg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47C73802B42;
        Thu, 21 Jan 2021 17:10:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3E2E6E41C;
        Thu, 21 Jan 2021 17:10:52 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] KVM: nSVM: move nested vmrun tracepoint to enter_svm_guest_mode
Date:   Thu, 21 Jan 2021 19:10:42 +0200
Message-Id: <20210121171043.946761-2-mlevitsk@redhat.com>
In-Reply-To: <20210121171043.946761-1-mlevitsk@redhat.com>
References: <20210121171043.946761-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This way trace will capture all the nested mode entries
(including entries after migration, and from smm)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cb4c6ee10029c..a6a14f7b56278 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -440,6 +440,20 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
 {
 	int ret;
 
+	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
+			       vmcb12->save.rip,
+			       vmcb12->control.int_ctl,
+			       vmcb12->control.event_inj,
+			       vmcb12->control.nested_ctl);
+
+	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
+				    vmcb12->control.intercepts[INTERCEPT_CR] >> 16,
+				    vmcb12->control.intercepts[INTERCEPT_EXCEPTION],
+				    vmcb12->control.intercepts[INTERCEPT_WORD3],
+				    vmcb12->control.intercepts[INTERCEPT_WORD4],
+				    vmcb12->control.intercepts[INTERCEPT_WORD5]);
+
+
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
 	load_nested_vmcb_control(svm, &vmcb12->control);
 	nested_prepare_vmcb_save(svm, vmcb12);
@@ -493,18 +507,6 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		goto out;
 	}
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
-			       vmcb12->save.rip,
-			       vmcb12->control.int_ctl,
-			       vmcb12->control.event_inj,
-			       vmcb12->control.nested_ctl);
-
-	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
-				    vmcb12->control.intercepts[INTERCEPT_CR] >> 16,
-				    vmcb12->control.intercepts[INTERCEPT_EXCEPTION],
-				    vmcb12->control.intercepts[INTERCEPT_WORD3],
-				    vmcb12->control.intercepts[INTERCEPT_WORD4],
-				    vmcb12->control.intercepts[INTERCEPT_WORD5]);
 
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
-- 
2.26.2

