Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5BD2ECCF6
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbhAGJkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:40:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbhAGJko (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 04:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610012358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xewkuyd+yZLUtmmkTpU1BhtOSrSJwLQTvCzDTVejJmI=;
        b=WrMLeQ7gBY9g22HkTWkCa90fy8bVtZHx5X49lwlqzqO1n3YK3Koxhx+wWSqa9w3OCQSB1Q
        OtvKD5rP6VVhUU7VFQOKhcvD5mjvOQdPwgYgU43KKj4ds6ymLGK74QGPzXYWVtnW0pjbPq
        gpxQDNesbo/TZJfzaWTDkreF8pO0gRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-RzMPIdH9Me64Au4ILOhETg-1; Thu, 07 Jan 2021 04:39:17 -0500
X-MC-Unique: RzMPIdH9Me64Au4ILOhETg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E46D809DCD;
        Thu,  7 Jan 2021 09:39:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0842019481;
        Thu,  7 Jan 2021 09:39:10 +0000 (UTC)
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
Subject: [PATCH v2 2/4] KVM: nSVM: correctly restore nested_run_pending on migration
Date:   Thu,  7 Jan 2021 11:38:52 +0200
Message-Id: <20210107093854.882483-3-mlevitsk@redhat.com>
In-Reply-To: <20210107093854.882483-1-mlevitsk@redhat.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code to store it on the migration exists, but no code was restoring it.

One of the side effects of fixing this is that L1->L2 injected events
are no longer lost when migration happens with nested run pending.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ee4f2082ad1bd..cc3130ab612e5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1200,6 +1200,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * in the registers, the save area of the nested state instead
 	 * contains saved L1 state.
 	 */
+
+	svm->nested.nested_run_pending =
+		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
+
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 	hsave->save = *save;
 
-- 
2.26.2

