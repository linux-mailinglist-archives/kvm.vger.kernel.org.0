Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27ABE31DBCB
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhBQO7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:59:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233668AbhBQO7C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:59:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmkGhGo1TINR1mZXpJI2cXfeqHdr+cz1awM+BWv9cag=;
        b=HkzNvVL92wY3KCD/f3GAr88CmY5CJzvRAGNLFECPRXIJUsgk0wg7S5DHErsSA1zK+gk6uK
        tofTfdj4tsC2eXjsAxnWsgSLN2CkNmZiiDLyyEZi98ZFI3cXMGDcNGf0ZvNDBl6PZfTxkF
        O1nfH20UERU6GK57hb4psH5KTzF1jQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-EtJqtWnSOo2hSz8JdOmofg-1; Wed, 17 Feb 2021 09:57:33 -0500
X-MC-Unique: EtJqtWnSOo2hSz8JdOmofg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F001107ACF5;
        Wed, 17 Feb 2021 14:57:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEDB710023AF;
        Wed, 17 Feb 2021 14:57:26 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/7] KVM: nSVM: move nested vmrun tracepoint to enter_svm_guest_mode
Date:   Wed, 17 Feb 2021 16:57:13 +0200
Message-Id: <20210217145718.1217358-3-mlevitsk@redhat.com>
In-Reply-To: <20210217145718.1217358-1-mlevitsk@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 519fe84f2100..1bc31e2e8fe0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -500,6 +500,20 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
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
 
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
@@ -559,18 +573,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
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
 	kvm_clear_exception_queue(vcpu);
-- 
2.26.2

