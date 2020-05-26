Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEBF1E28C7
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388974AbgEZRZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:25:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30157 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388967AbgEZRXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ulAk7D9K90ziZEa7pahAMfwIfO9l0RLz4413qge8DP0=;
        b=Yfl024QV1o+H/5gW9eYIsNw6olpDvv9YLqWbRqYTaTBDSM3JF7kiM50JzZAN9SGbJkzqNv
        XcEg3PdHotKcUnC8MkVLpvSXQrWHS4K7pv3ToWBM2v5Bp+NpE7mpO9kXinlvPe5Q76ROKB
        uPr8LrPX6jskT/SV2aAuIy398vKKCMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-t4OT0t03PGCtSw_HkZpiNg-1; Tue, 26 May 2020 13:23:14 -0400
X-MC-Unique: t4OT0t03PGCtSw_HkZpiNg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03FF78015D2;
        Tue, 26 May 2020 17:23:13 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F83010013DB;
        Tue, 26 May 2020 17:23:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 05/28] KVM: nSVM: correctly inject INIT vmexits
Date:   Tue, 26 May 2020 13:22:45 -0400
Message-Id: <20200526172308.111575-6-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index bbf991cfe24b..166b88fc9509 100644
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


