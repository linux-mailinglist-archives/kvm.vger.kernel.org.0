Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0CC4092ED
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344713AbhIMOQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344638AbhIMOLl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J2Qnlh4N8F/uVUfHWBRpl9v1JN3+oJO0AAEp+XVVMvk=;
        b=MAsMPv3QYF0DtsI6Dk32S4FwqBKtDY+pIWKFOlMhqhXFH2VIGcVAP6kq/P1ahURGL/BGTA
        50YeZLvFePMhLHtCaK33T+LL1tFO+OWsPLSGsB+/L1xnwZjH1WqOsAor7MoCT8RfpfO5Y2
        8lHK9wdaJjTy1oHNL5Ynk0vVlECVaEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-giSAjGNVNNOdde94NFnKYQ-1; Mon, 13 Sep 2021 10:10:23 -0400
X-MC-Unique: giSAjGNVNNOdde94NFnKYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B150FA40CA;
        Mon, 13 Sep 2021 14:10:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66FAA1972D;
        Mon, 13 Sep 2021 14:10:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 5/7] KVM: x86: VMX: synthesize invalid VM exit when emulating invalid guest state
Date:   Mon, 13 Sep 2021 17:09:52 +0300
Message-Id: <20210913140954.165665-6-mlevitsk@redhat.com>
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since no actual VM entry happened, the VM exit information is stale.
To avoid this, synthesize an invalid VM guest state VM exit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..57609dda1bbc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6618,10 +6618,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
 		vmx->loaded_vmcs->entry_time = ktime_get();
 
-	/* Don't enter VMX if guest state is invalid, let the exit handler
-	   start emulation until we arrive back to a valid state */
-	if (vmx->emulation_required)
+	/*
+	 * Don't enter VMX if guest state is invalid, let the exit handler
+	 * start emulation until we arrive back to a valid state.  Synthesize a
+	 * consistency check VM-Exit due to invalid guest state and bail.
+	 */
+	if (unlikely(vmx->emulation_required)) {
+		vmx->fail = 0;
+		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
+		vmx->exit_reason.failed_vmentry = 1;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
+		vmx->exit_qualification = ENTRY_FAIL_DEFAULT;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
+		vmx->exit_intr_info = 0;
 		return EXIT_FASTPATH_NONE;
+	}
 
 	trace_kvm_entry(vcpu);
 
-- 
2.26.3

