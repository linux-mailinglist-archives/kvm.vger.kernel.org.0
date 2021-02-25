Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C4D32529E
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 16:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhBYPnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 10:43:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232077AbhBYPn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 10:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614267719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBWCL9s9v1m/Sg/mod1ds/RaG6oBBDEPB2yklkE8Mjg=;
        b=jSZAESJ+qFTAFyb1IlzMVRqfCcVwOOHdAS8p7SCQr06yB5Y/jcmpANeMZoAdgfrvAPPyDO
        OFcK5n2xyLwI+hJGqFTCi0z3i24SxXSaePf+x5UO7VvLi5sqFVH1TvbnEfkejzGAh8+Uzq
        Ksm5HGxCSQQRXVJdMg/WyctnCbzCX3E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-GDord8FfObKQ033Oj7PtGA-1; Thu, 25 Feb 2021 10:41:54 -0500
X-MC-Unique: GDord8FfObKQ033Oj7PtGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3310BBEE4;
        Thu, 25 Feb 2021 15:41:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F7AB5B4A0;
        Thu, 25 Feb 2021 15:41:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/4] KVM: x86: pending exception must be be injected even with an injected event
Date:   Thu, 25 Feb 2021 17:41:34 +0200
Message-Id: <20210225154135.405125-4-mlevitsk@redhat.com>
In-Reply-To: <20210225154135.405125-1-mlevitsk@redhat.com>
References: <20210225154135.405125-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Injected events should not block a pending exception, but rather,
should either be lost or be delivered to the nested hypervisor as part of
exitintinfo/IDT_VECTORING_INFO
(if nested hypervisor intercepts the pending exception)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 7 ++++++-
 arch/x86/kvm/vmx/nested.c | 9 +++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 881e3954d753b..4c82abce0ea0c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1024,7 +1024,12 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		if (block_nested_events)
+		/*
+		 * Only pending nested run can block an pending exception
+		 * Otherwise an injected NMI/interrupt should either be
+		 * lost or delivered to the nested hypervisor in EXITINTINFO
+		 * */
+		if (svm->nested.nested_run_pending)
                         return -EBUSY;
 		if (!nested_exit_on_exception(svm))
 			return 0;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b34e284bfa62a..20ed1a351b2d9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3810,9 +3810,14 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Process any exceptions that are not debug traps before MTF.
+	 *
+	 * Note that only pending nested run can block an pending exception
+	 * Otherwise an injected NMI/interrupt should either be
+	 * lost or delivered to the nested hypervisor in EXITINTINFO
 	 */
+
 	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
-		if (block_nested_events)
+		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
@@ -3829,7 +3834,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.exception.pending) {
-		if (block_nested_events)
+		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
 			goto no_vmexit;
-- 
2.26.2

