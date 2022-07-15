Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADFE57687A
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiGOUo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiGOUoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:44:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20AB88CCE
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j11-20020a05690212cb00b006454988d225so4689744ybu.10
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2grwD2pqg1sxYXcK+HVM+ohwaiXkYZih7UZ5+Lm+UA8=;
        b=mrr793MIN2aX39/3UbyY+w/PEXSu88iSs9Cxa6dG/JSEX4WIP2LwKUStKBOKtpKET0
         DH4uUo9trdchWqAOXlxsa3JT//olYNlF802xtNxcmli4qchJ7CcMnKTGt/0Eqi/ZCRMT
         dJbv6DNg3mj7kpXXZpW0+pRCfq2o8whlQ/uhjN0OFwVi1Y/WPX0vL7R57eaMRXazPmbb
         8WgKZPg/Ho5XayHksDpk/GwmIoBYjBkxVtI9uku6/uobSAY67/w7BqO6xpODx+g4l4XY
         x5hMcmaUTgk3dAVQu3z2VSAdDtr5X2TNDDpvIvClvAoShy1ZxiQgMHsS/mBBIIvLh9E2
         a7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2grwD2pqg1sxYXcK+HVM+ohwaiXkYZih7UZ5+Lm+UA8=;
        b=hABOXdZ8y9CsK5LwJSDyCSh6GvIpLVjelIBKOyhTlcIQoFOSoAWukLeL/XvlQEQldJ
         L9+czbVw/29Cn2ZBlktx24BZKquFvON2Gtc2xfxsapkha1/ps3mKmG8+C/aYsIvy0o/S
         M2wN2l9XLY9A4PUhxMr4MaNuNleJ2Z/woho82GKKqRHH2NQDJmg5f0St5d2KA7NEgf5M
         f+xkRUxmsbzEMzCLZpzXnXI+WSlRXlRY3XWh6skNeOjMhAI2gVuwA6i1l9EdX5JZtPRz
         Q2tVMJ4s18nfC4gjobHjDca/zDTsPQqQ+tudIupVPnak6g+LxnoZA0Q7qa6JEFmdne3b
         9UEA==
X-Gm-Message-State: AJIora90y3P/4qHiH3lu5lJNjtanLP9Y+WkqxgYRUojPKQIJBczRDZjs
        guJrCceAjNl4l2iDND/xDNSwFvEw900=
X-Google-Smtp-Source: AGRyM1uWYV0KoE/V/MAPgGPnRCPIVzJuOf5OC7zQ44OX+HWzdlso/gfxbS/8x/qaUBY5zlVJKopTrsh1JJM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:1148:0:b0:31c:ad1f:774f with SMTP id
 69-20020a811148000000b0031cad1f774fmr17334413ywr.13.1657917791055; Fri, 15
 Jul 2022 13:43:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:24 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-23-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 22/24] KVM: x86: Rename inject_pending_events() to kvm_check_and_inject_events()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename inject_pending_events() to kvm_check_and_inject_events() in order
to capture the fact that it handles more than just pending events, and to
(mostly) align with kvm_check_nested_events(), which omits the "inject"
for brevity.

Add a comment above kvm_check_and_inject_events() to provide a high-level
synopsis, and to document a virtualization hole (KVM erratum if you will)
that exists due to KVM not strictly tracking instruction boundaries with
respect to coincident instruction restarts and asynchronous events.

No functional change inteded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/svm.c    |  2 +-
 arch/x86/kvm/x86.c        | 46 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0a8ee5f28319..028e180a74b6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1310,7 +1310,7 @@ static void nested_svm_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 		else
 			vmcb->control.exit_info_2 = vcpu->arch.cr2;
 	} else if (ex->vector == DB_VECTOR) {
-		/* See inject_pending_event.  */
+		/* See kvm_check_and_inject_events().  */
 		kvm_deliver_exception_payload(vcpu, ex);
 
 		if (vcpu->arch.dr7 & DR7_GD) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a336517b563e..95bdf127d531 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3518,7 +3518,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 
 	/* Note, this is called iff the local APIC is in-kernel. */
 	if (!READ_ONCE(vcpu->arch.apic->apicv_active)) {
-		/* Process the interrupt via inject_pending_event */
+		/* Process the interrupt via kvm_check_and_inject_events(). */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_vcpu_kick(vcpu);
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b924afb76b72..69b9725beff3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9691,7 +9691,47 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_inject_exception)(vcpu);
 }
 
-static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
+/*
+ * Check for any event (interrupt or exception) that is ready to be injected,
+ * and if there is at least one event, inject the event with the highest
+ * priority.  This handles both "pending" events, i.e. events that have never
+ * been injected into the guest, and "injected" events, i.e. events that were
+ * injected as part of a previous VM-Enter, but weren't successfully delivered
+ * and need to be re-injected.
+ *
+ * Note, this is not guaranteed to be invoked on a guest instruction boundary,
+ * i.e. doesn't guarantee that there's an event window in the guest.  KVM must
+ * be able to inject exceptions in the "middle" of an instruction, and so must
+ * also be able to re-inject NMIs and IRQs in the middle of an instruction.
+ * I.e. for exceptions and re-injected events, NOT invoking this on instruction
+ * boundaries is necessary and correct.
+ *
+ * For simplicity, KVM uses a single path to inject all events (except events
+ * that are injected directly from L1 to L2) and doesn't explicitly track
+ * instruction boundaries for asynchronous events.  However, because VM-Exits
+ * that can occur during instruction execution typically result in KVM skipping
+ * the instruction or injecting an exception, e.g. instruction and exception
+ * intercepts, and because pending exceptions have higher priority than pending
+ * interrupts, KVM still honors instruction boundaries in most scenarios.
+ *
+ * But, if a VM-Exit occurs during instruction execution, and KVM does NOT skip
+ * the instruction or inject an exception, then KVM can incorrecty inject a new
+ * asynchrounous event if the event became pending after the CPU fetched the
+ * instruction (in the guest).  E.g. if a page fault (#PF, #NPF, EPT violation)
+ * occurs and is resolved by KVM, a coincident NMI, SMI, IRQ, etc... can be
+ * injected on the restarted instruction instead of being deferred until the
+ * instruction completes.
+ *
+ * In practice, this virtualization hole is unlikely to be observed by the
+ * guest, and even less likely to cause functional problems.  To detect the
+ * hole, the guest would have to trigger an event on a side effect of an early
+ * phase of instruction execution, e.g. on the instruction fetch from memory.
+ * And for it to be a functional problem, the guest would need to depend on the
+ * ordering between that side effect, the instruction completing, _and_ the
+ * delivery of the asynchronous event.
+ */
+static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
+				       bool *req_immediate_exit)
 {
 	bool can_inject;
 	int r;
@@ -10170,7 +10210,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * When APICv gets disabled, we may still have injected interrupts
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
 	 * still active when the interrupt got accepted. Make sure
-	 * inject_pending_event() is called to check for that.
+	 * kvm_check_and_inject_events() is called to check for that.
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
@@ -10467,7 +10507,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		r = inject_pending_event(vcpu, &req_immediate_exit);
+		r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
 		if (r < 0) {
 			r = 0;
 			goto out;
-- 
2.37.0.170.g444d1eabd0-goog

