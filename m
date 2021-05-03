Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0311A371581
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhECM4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233915AbhECM4E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgHIAfyZcsosWkxCDY5UIfxoZLqaCozS1GZ+43tb9D4=;
        b=bFEmZIN2qMsuA8IjfKuBlbkgDdPF9nD9djpYCSClPsbIMcef79aQxVgxGov9wimt4JSbpC
        zGPKl/RmCQc56ClYvhiwgpAmIA0VFldU3WDNf2ZioBKfhoGSrOy7taecRutj9TNu1mvklF
        mRqzWTeZrrANOLN67TOAAqaPSqOuVxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-ks6_srUbNUegKyHX1OlB1Q-1; Mon, 03 May 2021 08:55:07 -0400
X-MC-Unique: ks6_srUbNUegKyHX1OlB1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 494378042C8;
        Mon,  3 May 2021 12:55:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC05070598;
        Mon,  3 May 2021 12:55:01 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/5] KVM: nSVM: leave the guest mode prior to loading a nested state
Date:   Mon,  3 May 2021 15:54:44 +0300
Message-Id: <20210503125446.1353307-4-mlevitsk@redhat.com>
In-Reply-To: <20210503125446.1353307-1-mlevitsk@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows the KVM to load the nested state more than
once without warnings.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a88c64e004c3..32400cba608d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1309,12 +1309,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * L2 registers if needed are moved from the current VMCB to VMCB02.
 	 */
 
+	if (is_guest_mode(vcpu))
+		svm_leave_nested(svm);
+	else
+		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
+
 	svm->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
-	if (svm->current_vmcb == &svm->vmcb01)
-		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
 
 	svm->vmcb01.ptr->save.es = save->es;
 	svm->vmcb01.ptr->save.cs = save->cs;
-- 
2.26.2

