Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54193325297
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 16:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhBYPnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 10:43:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232203AbhBYPnQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 10:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614267709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45FSWo+t/kzijJoT0ABe1FplAFBSy0hQPH4KIv9auEg=;
        b=hR9ma4AN4Er6FXZL/w1ulOaJkbUtyC67Xnu0ldJ81AxXuDslVKWsjpIb0Ftpr1BIZVcg1s
        D0965Bp2Zl03/qWgd7leFsRn0HrOwPeiGJbazpjqtcUppC/zqcZhXeAz9vCXZzzjoIcywL
        2xMGg2Hb39/xo8AVjGgJJMV75eMe9RE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-J0wYP-EOPeCLEsmUMCiDqA-1; Thu, 25 Feb 2021 10:41:47 -0500
X-MC-Unique: J0wYP-EOPeCLEsmUMCiDqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17E0119611A2;
        Thu, 25 Feb 2021 15:41:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 766D350DD2;
        Thu, 25 Feb 2021 15:41:41 +0000 (UTC)
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
Subject: [PATCH 1/4] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Thu, 25 Feb 2021 17:41:32 +0200
Message-Id: <20210225154135.405125-2-mlevitsk@redhat.com>
In-Reply-To: <20210225154135.405125-1-mlevitsk@redhat.com>
References: <20210225154135.405125-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A page fault can be queued while vCPU is in real paged mode on AMD, and
AMD manual asks the user to always intercept it
(otherwise result is undefined).
The resulting VM exit, does have an error code.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9fa0c7ff6e2fb..a9d814a0b5e4f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -544,8 +544,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -8345,6 +8343,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_update_cr8_intercept)(vcpu, tpr, max_irr);
 }
 
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
+		vcpu->arch.exception.error_code = false;
+	static_call(kvm_x86_queue_exception)(vcpu);
+}
+
 static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
@@ -8353,7 +8358,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected) {
-		static_call(kvm_x86_queue_exception)(vcpu);
+		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
 	/*
@@ -8416,7 +8421,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			}
 		}
 
-		static_call(kvm_x86_queue_exception)(vcpu);
+		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
 
-- 
2.26.2

