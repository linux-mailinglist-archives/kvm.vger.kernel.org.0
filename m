Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DE53FB691
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbhH3M45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:56:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236862AbhH3M44 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630328162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Me9h5mBH8D778P8agUtDxGHFJsm2HVepFV6JvmzQ+dg=;
        b=hhMHG9mab4gjywEx2H7lP6o+MJ94ygehtV2nWSJMWJZn9yBRzePkTN+hZ2LXbllitLg6bQ
        J9y1Wj/lJngTQAH5XyB9osV/XyiGXEd3Bb4yVJdWXGFcz+Kwv7OouYuheY4QqskIdcZQMJ
        azq8yOks01ZJ22NjW+EwOLJ/rNJo9kA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-p8oWAbwqMjKHB8BwAmkIeg-1; Mon, 30 Aug 2021 08:56:01 -0400
X-MC-Unique: p8oWAbwqMjKHB8BwAmkIeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 444A3192AB83;
        Mon, 30 Aug 2021 12:55:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0007860854;
        Mon, 30 Aug 2021 12:55:55 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 4/6] KVM: VMX: synthesize invalid VM exit when emulating invalid guest state
Date:   Mon, 30 Aug 2021 15:55:37 +0300
Message-Id: <20210830125539.1768833-5-mlevitsk@redhat.com>
In-Reply-To: <20210830125539.1768833-1-mlevitsk@redhat.com>
References: <20210830125539.1768833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 4194fbf5e5d6..1c113195c846 100644
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

