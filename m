Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E16F2EBCBB
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbhAFKvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:51:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbhAFKvq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:51:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cew2nN5LaqQ1dIbD7PrYU2tGalbkV5b+eR0TWx4Pijw=;
        b=UddBNjjbM27knvI2kD4D0XifRW72dGtqTq1g0J9rAmO1GLGnDqmzpCLomfwKYUiP7ty77j
        EXQ4sAmGWzNX9EXIUoxdgsC4GYO2ceuYIjFWu6WY1h1EaSp7ySY1XVFHxfnnK6qwAKAfhl
        T50dSstrnBjXyL1ItkNXSj1jDeEgcAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-goXAmI6qNyWaY5RMsqMOTQ-1; Wed, 06 Jan 2021 05:50:18 -0500
X-MC-Unique: goXAmI6qNyWaY5RMsqMOTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F14181926DA0;
        Wed,  6 Jan 2021 10:50:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76F36669FC;
        Wed,  6 Jan 2021 10:50:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/6] KVM: nSVM: fix for disappearing L1->L2 event injection on L1 migration
Date:   Wed,  6 Jan 2021 12:49:57 +0200
Message-Id: <20210106105001.449974-3-mlevitsk@redhat.com>
In-Reply-To: <20210106105001.449974-1-mlevitsk@redhat.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If migration happens while L2 entry with an injected event to L2 is pending,
we weren't including the event in the migration state and it would be
lost leading to L2 hang.

Fix this by queueing the injected event in similar manner to how we queue
interrupted injections.

This can be reproduced by running an IO intense task in L2,
and repeatedly migrating the L1.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b0b667456b2e7..18b71e73a9935 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -416,8 +416,11 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
 	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
-	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
-	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
+
+	svm_process_injected_event(svm, svm->nested.ctl.event_inj,
+				   svm->nested.ctl.event_inj_err);
+
+	WARN_ON_ONCE(svm->vmcb->control.event_inj);
 
 	svm->vmcb->control.pause_filter_count  = svm->nested.ctl.pause_filter_count;
 	svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
-- 
2.26.2

