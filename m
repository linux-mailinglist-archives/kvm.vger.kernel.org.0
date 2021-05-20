Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC73538B9F7
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhETXFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbhETXFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFE7C061761
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d64-20020a6368430000b02902104a07607cso11252628pgc.1
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pqJ9r0w3yO8BRgD+OaCI5cpEj+XpER34J0dTKBLscnU=;
        b=m0lTEoAoXq8s9zbbMvM/Rp30znBPNMGz6P6NcoJXKFvEN5Ky6+NsfAsFbrs10YGf75
         OXOYS4mXYM0nREQnX7qB0g7KOji6NcdU8NdjTc/rZ/1ZzeN9J55NkYrDe+2/QMgMKrVv
         rv2UiRiN/kiKZwzVzG1ghBqQyrIqIneCFMBPkxFYCeT0FO6fE0fCkXn2ZKSifCqza4z5
         wu9tBBnI2oCENKsXcnj3HTfd1VAXlTWdSzLB7lgoY+AFMKN+FVLFHFtrwyJ+L2mUR1Qo
         v+P0JDwkh8ySJd4GAWwiaUvbBV/tiwcqxQ+EiX817TfKSz+p6sU5BvDpSdv5KX4N7FX8
         +mlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pqJ9r0w3yO8BRgD+OaCI5cpEj+XpER34J0dTKBLscnU=;
        b=hqXB/my5OPY2roXzG3xUjO+4IY1vcU+OEdWMFN/ytMGXAjNzYfFnzFAuktIRQraGLo
         2FVp9k7YoYhZt+4k/YvGgBRkHu5jtaD607sNiKORzGm38tedI9b2hOKpTwxKv7Ckvr1N
         p4wDvyfBXAmIipQ+Uz36UPCTpJCKIGKkJBx0bd1+XxDCGWfv+C1cvUixCOJSw2IlNW+W
         nARVEixvnNz8DWtUlgkXPMqzPBxwBnmdrxpgW6CPEeR7SkQbSdxtQ69RHaWFtU80nGyf
         in8FXKFpjGBDckMsCsFpEIH9dDNOa9kf2Mhf+PKwahWFxLJ3pEOpemihNWAaZP7UfaEf
         fvNQ==
X-Gm-Message-State: AOAM533wHwg+G+XCkc55V8lDuneKNN/7ZlVgMP7295yigy+y/lPPIN79
        RBa+Z+Eb51xPtZ0BZ+03Ud9zSazQ46djHZpt2DC9IaQDEzX9KdInKKiqMbBYcpVE/G0xVH2POn6
        rZOw1rukyUJdX+gXE5Vov/COY97LTdoTUVytmN7C4TzMIHIpOpQ4MIlcMfFC02bI=
X-Google-Smtp-Source: ABdhPJwySGcZbFHPWZN1PoR/+sAVVnXUeYVbBxHqCpBJ/kdsxEjhWBQDX+IuydI77aLHCYbJHePeU8r7IIb/LQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a62:90:0:b029:2db:90a5:74dc with SMTP id
 138-20020a6200900000b02902db90a574dcmr6735711pfa.27.1621551838619; Thu, 20
 May 2021 16:03:58 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:31 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-5-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 04/12] KVM: x86: Add a return code to inject_pending_event
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended. At present, 'r' will always be -EBUSY
on a control transfer to the 'out' label.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3fea8ea3628..eb35536f8d06 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8547,7 +8547,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_queue_exception)(vcpu);
 }
 
-static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
+static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
 	bool can_inject = true;
@@ -8594,7 +8594,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (is_guest_mode(vcpu)) {
 		r = kvm_check_nested_events(vcpu);
 		if (r < 0)
-			goto busy;
+			goto out;
 	}
 
 	/* try to inject new event if pending */
@@ -8636,7 +8636,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (vcpu->arch.smi_pending) {
 		r = can_inject ? static_call(kvm_x86_smi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
-			goto busy;
+			goto out;
 		if (r) {
 			vcpu->arch.smi_pending = false;
 			++vcpu->arch.smi_count;
@@ -8649,7 +8649,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (vcpu->arch.nmi_pending) {
 		r = can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
-			goto busy;
+			goto out;
 		if (r) {
 			--vcpu->arch.nmi_pending;
 			vcpu->arch.nmi_injected = true;
@@ -8664,7 +8664,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (kvm_cpu_has_injectable_intr(vcpu)) {
 		r = can_inject ? static_call(kvm_x86_interrupt_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
-			goto busy;
+			goto out;
 		if (r) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
 			static_call(kvm_x86_set_irq)(vcpu);
@@ -8680,11 +8680,14 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		*req_immediate_exit = true;
 
 	WARN_ON(vcpu->arch.exception.pending);
-	return;
+	return 0;
 
-busy:
-	*req_immediate_exit = true;
-	return;
+out:
+	if (r == -EBUSY) {
+		*req_immediate_exit = true;
+		r = 0;
+	}
+	return r;
 }
 
 static void process_nmi(struct kvm_vcpu *vcpu)
@@ -9245,7 +9248,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		inject_pending_event(vcpu, &req_immediate_exit);
+		r = inject_pending_event(vcpu, &req_immediate_exit);
+		if (r < 0) {
+			r = 0;
+			goto out;
+		}
 		if (req_int_win)
 			static_call(kvm_x86_enable_irq_window)(vcpu);
 
-- 
2.31.1.818.g46aad6cb9e-goog

