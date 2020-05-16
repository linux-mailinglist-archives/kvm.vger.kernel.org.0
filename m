Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB51D6174
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgEPNxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 09:53:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726786AbgEPNxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 May 2020 09:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589637202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=epuIMlu/asRkDz/mw+U2Mz/nCSbM54XOWxXioecXjyE=;
        b=GSkn/XeVCCs5YZrmZ7AEMR8FTKRUgY/ri9lq9CTqgmLoqSj8cWHdiZ34xygX3OkK1g1ESp
        DHKZvRxR5YmMsErnsEbAOY0kRIAt7JaMRe+xDA0nVgPWhpGABCy7l2K4qGvxwI+KS9zWXy
        f17CpSQcLUxPpLLoGqG1vkofnJZeefg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-xj9ondSyMXSoRRfpylr1Hg-1; Sat, 16 May 2020 09:53:18 -0400
X-MC-Unique: xj9ondSyMXSoRRfpylr1Hg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BADA8107ACCA;
        Sat, 16 May 2020 13:53:17 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C8BB5D9D3;
        Sat, 16 May 2020 13:53:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH 4/4] KVM: nSVM: correctly inject INIT vmexits
Date:   Sat, 16 May 2020 09:53:11 -0400
Message-Id: <20200516135311.704878-5-pbonzini@redhat.com>
In-Reply-To: <20200516135311.704878-1-pbonzini@redhat.com>
References: <20200516135311.704878-1-pbonzini@redhat.com>
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
index c1d8a0be752b..8a1e007b745d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -25,6 +25,7 @@
 #include "trace.h"
 #include "mmu.h"
 #include "x86.h"
+#include "lapic.h"
 #include "svm.h"
 
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
@@ -790,11 +791,37 @@ static void nested_svm_intr(struct vcpu_svm *svm)
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
2.18.2

