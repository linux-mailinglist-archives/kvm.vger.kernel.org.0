Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD041E8247
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgE2PmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:42:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23402 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727787AbgE2Pjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z2xVwPB85hJsiNEVYE5s27qjV3b58ufMtg3MGaV8NEw=;
        b=ayySkbdlcl7tiENKtAY6HnTO7La/fH9Cl0SwRvt/WRPMrn71nvQyIASBAF3H4LryB3Ebx9
        5ahS8exOoWEtz6iNKazy3+DpxZ0VlTktrQIceQzoBwKfRQSy1aaS2f4g1d7LsnxG/dSJlL
        qd/LLXxgFfIRikiqq62vgEXRcwveuf8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-P-Obl6QDOselFKZDoi3Tcw-1; Fri, 29 May 2020 11:39:39 -0400
X-MC-Unique: P-Obl6QDOselFKZDoi3Tcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 300E2461;
        Fri, 29 May 2020 15:39:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB8F65D9D5;
        Fri, 29 May 2020 15:39:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 05/30] KVM: nSVM: correctly inject INIT vmexits
Date:   Fri, 29 May 2020 11:39:09 -0400
Message-Id: <20200529153934.11694-6-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The usual drill at this point, except there is no code to remove because this
case was not handled at all.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3d17c62a84a3..dcac4c3510ab 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -25,6 +25,7 @@
 #include "trace.h"
 #include "mmu.h"
 #include "x86.h"
+#include "lapic.h"
 #include "svm.h"
 
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
@@ -788,11 +789,37 @@ static void nested_svm_intr(struct vcpu_svm *svm)
 	nested_svm_vmexit(svm);
 }
 
+static inline bool nested_exit_on_init(struct vcpu_svm *svm)
+{
+	return (svm->nested.intercept & (1ULL << INTERCEPT_INIT));
+}
+
+static void nested_svm_init(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.exit_code   = SVM_EXIT_INIT;
+	svm->vmcb->control.exit_info_1 = 0;
+	svm->vmcb->control.exit_info_2 = 0;
+
+	nested_svm_vmexit(svm);
+}
+
+
 static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool block_nested_events =
 		kvm_event_needs_reinjection(vcpu) || svm->nested.nested_run_pending;
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (lapic_in_kernel(vcpu) &&
+	    test_bit(KVM_APIC_INIT, &apic->pending_events)) {
+		if (block_nested_events)
+			return -EBUSY;
+		if (!nested_exit_on_init(svm))
+			return 0;
+		nested_svm_init(svm);
+		return 0;
+	}
 
 	if (vcpu->arch.exception.pending) {
 		if (block_nested_events)
-- 
2.26.2


