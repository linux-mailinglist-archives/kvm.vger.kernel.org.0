Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2AE472A97
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbhLMKry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:47:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236542AbhLMKrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 05:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639392473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59HMtpTMQ9i7eUmXBrMB6oGvSjYwRln+nBm30V7CKiY=;
        b=cvDfVlRkkCuLsouYzfGS0RKpeN53G7baRdkUcoii0cLPVQBtKF59WLgF7eb65zUueNCihD
        OxkmnozQchzJfOMGgmKVbuYieTlDUU/MCsG8FQMxG6WffI5okYsOJsXLhN4LYBUj0kMESV
        /NP6qyIoTvNWN3XmzEqD0ZAfWkIhJMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-ELnzw9ZaOCeLXC2pEKNjHw-1; Mon, 13 Dec 2021 05:47:50 -0500
X-MC-Unique: ELnzw9ZaOCeLXC2pEKNjHw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB1B5802921;
        Mon, 13 Dec 2021 10:47:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FF595F70B;
        Mon, 13 Dec 2021 10:47:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/5] KVM: nSVM: deal with L1 hypervisor that intercepts interrupts but lets L2 control EFLAGS.IF
Date:   Mon, 13 Dec 2021 12:46:30 +0200
Message-Id: <20211213104634.199141-2-mlevitsk@redhat.com>
In-Reply-To: <20211213104634.199141-1-mlevitsk@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a corner case in which L1 hypervisor intercepts interrupts (INTERCEPT_INTR)
and either doesn't use virtual interrupt masking (V_INTR_MASKING) or
enters a nested guest with EFLAGS.IF disabled prior to the entry.

In this case, despite the fact that L1 intercepts the interrupts,
KVM still needs to set up an interrupt window to wait before it
can deliver INTR vmexit.

Currently instead, the KVM enters an endless loop of 'req_immediate_exit'.

Note that on VMX this case is impossible as there is only
'vmexit on external interrupts' execution control which either set,
in which case both host and guest's EFLAGS.IF
is ignored, or clear, in which case no VMexit is delivered.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e57e6857e0630..c9668a3b51011 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3372,17 +3372,21 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool blocked;
+
 	if (svm->nested.nested_run_pending)
 		return -EBUSY;
 
+	blocked = svm_interrupt_blocked(vcpu);
+
 	/*
 	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
 	 * e.g. if the IRQ arrived asynchronously after checking nested events.
 	 */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
-		return -EBUSY;
-
-	return !svm_interrupt_blocked(vcpu);
+		return !blocked ? -EBUSY : 0;
+	else
+		return !blocked;
 }
 
 static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
-- 
2.26.3

