Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4662ECCFB
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbhAGJkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:40:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727610AbhAGJks (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 04:40:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610012362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QpH2fjiVtXz9ckPRo6YT7XYAC/uU1d0touoV4p4Y/5U=;
        b=MQc5cWy1ts4tnUzn5bqjWjuAgeKo0PxXMt5HYgD0d8zQGherXtrE6J9NIHE6EJaG8Tx8Rr
        C/Nj/csznwM5HwQYFIfZifqTCqizE0HcyqxHRro5cJjZBAOFGIJZI5pylVrgS5SGtN9gVi
        Q/Re9JFxupU0Rhmc4Bkh8/xYin2qIro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-KXA1ZzSDMxGau1ymw8qfVQ-1; Thu, 07 Jan 2021 04:39:20 -0500
X-MC-Unique: KXA1ZzSDMxGau1ymw8qfVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADD4D801817;
        Thu,  7 Jan 2021 09:39:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 126E019714;
        Thu,  7 Jan 2021 09:39:14 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/4] KVM: nSVM: always leave the nested state first on KVM_SET_NESTED_STATE
Date:   Thu,  7 Jan 2021 11:38:53 +0200
Message-Id: <20210107093854.882483-4-mlevitsk@redhat.com>
In-Reply-To: <20210107093854.882483-1-mlevitsk@redhat.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This should prevent bad things from happening if the user calls the
KVM_SET_NESTED_STATE twice.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cc3130ab612e5..e91d40c8d8c91 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1200,6 +1200,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * in the registers, the save area of the nested state instead
 	 * contains saved L1 state.
 	 */
+	svm_leave_nested(svm);
 
 	svm->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
-- 
2.26.2

