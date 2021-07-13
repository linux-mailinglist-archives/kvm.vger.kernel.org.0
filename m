Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DCC3C7203
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhGMOXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236866AbhGMOXh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IsGkdcLUVDDRGPEUG9SeEQfNq5iOGQYqs/SNmiCeXhc=;
        b=SZqyYjfVFYmEnNaZwukUyUg9xByuNfAm6GZGC/USjvwsAUI15JucndcLyuYr4xgJCQ9Tud
        4/rnwdyWAxJliHg1+hMsJe/v8QrWRKvHu6p0gcnJfQmLc36+N+/H044Seknors9dVt7Ww8
        /LMFr7DJnzqxRHs0kqR4853R1cuvccQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-81pWtNMCMBOCCSxgkTumGw-1; Tue, 13 Jul 2021 10:20:45 -0400
X-MC-Unique: 81pWtNMCMBOCCSxgkTumGw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8197101F000;
        Tue, 13 Jul 2021 14:20:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF2BC5D6AB;
        Tue, 13 Jul 2021 14:20:39 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/8] KVM: SVM: use vmcb01 in svm_refresh_apicv_exec_ctrl
Date:   Tue, 13 Jul 2021 17:20:18 +0300
Message-Id: <20210713142023.106183-4-mlevitsk@redhat.com>
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently when SVM is enabled in guest CPUID, AVIC is inhibited as soon
as the guest CPUID is set.

AVIC happens to be fully disabled on all vCPUs by the time any guest
entry starts (if after migration the entry can be nested).

The reason is that currently we disable avic right away on vCPU from which
the kvm_request_apicv_update was called and for this case, it happens to be
called on all vCPUs (by svm_vcpu_after_set_cpuid).

After we stop doing this, AVIC will end up being disabled only when
KVM_REQ_APICV_UPDATE is processed which is after we done switching to the
nested guest.

Fix this by just using vmcb01 in svm_refresh_apicv_exec_ctrl for avic
(which is a right thing to do anyway).

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a9abed054cd5..64d1e1b6a305 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -646,7 +646,7 @@ static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb = svm->vmcb;
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 	bool activated = kvm_vcpu_apicv_active(vcpu);
 
 	if (!enable_apicv)
-- 
2.26.3

