Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C7D1DBB4D
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgETRXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:23:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727992AbgETRWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=VMR19ZD8UeRCsHYzV0AWBiEjUYt1N8hlKIv2air0PlU=;
        b=KPavvcHQXIQp3ymNQC9IthRmpl2uCCuUL5tkZRHRwGBVGwyMpc3Ny7FYBMvprJ7AyZfxET
        7oa5IweUHED/xlpZejAbGo43QjN2kYRm8arNQ6piq3BaxUPRU+Vh9s1FQG9ccE0L9IFJsa
        5phWRdJbDZFeBnb58m/A7SQAnUt/G+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-y176hgGONCS36wM9FBOrlQ-1; Wed, 20 May 2020 13:22:00 -0400
X-MC-Unique: y176hgGONCS36wM9FBOrlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6D2D1B18BC1;
        Wed, 20 May 2020 17:21:51 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 363F882A33;
        Wed, 20 May 2020 17:21:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 05/24] KVM: nSVM: correctly inject INIT vmexits
Date:   Wed, 20 May 2020 13:21:26 -0400
Message-Id: <20200520172145.23284-6-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index dd2868dd6129..7efefceb5f2f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -25,6 +25,7 @@
 #include "trace.h"
 #include "mmu.h"
 #include "x86.h"
+#include "lapic.h"
 #include "svm.h"
 
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
@@ -781,11 +782,37 @@ static void nested_svm_intr(struct vcpu_svm *svm)
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


