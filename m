Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AB957EAE4
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiGWAyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbiGWAxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:53:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA97C1DDD
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:29 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id f16-20020a17090a121000b001f22aa2ac88so2600167pja.7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8QUcqYdas0eqDSvXYo4Sqhu3pNlKhGcIVM8bC4z4X4E=;
        b=sjhztStshfGUZjDU7uyDWl8wKUBQr+RDpjo1ZpkTve75pKSWyt00NUhxwC4ubI3hwv
         m0VPkRoleUb5rZXcYoQHOjO0RV6QpchamAIQ9PYcsNmzHtsy5H7oMOvDkwFcGyCmWCKS
         XJoDgXEHuS1V57Toaoc6+lOOPHFdnvMUV/0IFaw8rGfvzRlO2p19Wb0mL7MAUmy5TwgJ
         OkD7RaEqGX8O1AtHLTvxVZ6qRQXzjlRazM+gQZBGH7s/pg0IfIFkEDSXKsW3VLuVrf5b
         26akg/dEbbCI2Iiv26BFVp5C5mWhPWTk6KzOuJOxL9bpiFADJKaNGvAXC6OFjBE0/l7r
         /fJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8QUcqYdas0eqDSvXYo4Sqhu3pNlKhGcIVM8bC4z4X4E=;
        b=e+c1KYLo3N4Z1+sqoijLfdtgIguHtfXfTD3oU93BT6lC24gKliGA7nsa42g8AAfYKG
         oI0enWVc1PCZo7CQJmOFk5m6LJEKgduWFN86dSOeRKCD3qeKooAAEL+SBo+S8XLV8jay
         pRUYk0k73dfJxbjJ6p9ta1Ie+Zwf1K9HAYC5SSStbNSVEQniesnWwm8T+5ce9Yf+TQoF
         HpQ/KLV1DuXQVEznatUQdR3gnCg3mOa8Juw20pEssTaIUn+cJlu4DTFAxwwCKm40We8m
         5B6oFYWYl/EE45uBirVewpzMxdj1y8iSLCrVvc6iS7J51dNUb7XcgqRILM0BMEmAdliE
         KC6g==
X-Gm-Message-State: AJIora/bbuITqYzbCzELhfhVUXvnz10OX2ickvDiyPqAACq477WA1ls3
        3X3BOhonISZImaegkD4oBWBDPeDAVyg=
X-Google-Smtp-Source: AGRyM1sCJo9oUBudZTtbRG/LpT9zWMtTS9RJn5IyNWtkQJ3jRtzL3h6hKBJ6HXK7cUpLqhTRHmLb1/IUYaM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8602:b0:16c:dfae:9afb with SMTP id
 f2-20020a170902860200b0016cdfae9afbmr2430916plo.35.1658537536913; Fri, 22 Jul
 2022 17:52:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:35 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-23-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 22/24] KVM: x86: Rename inject_pending_events() to kvm_check_and_inject_events()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/svm.c    |  2 +-
 arch/x86/kvm/x86.c        | 46 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 405075286965..6b3b18404533 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1312,7 +1312,7 @@ static void nested_svm_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 		else
 			vmcb->control.exit_info_2 = vcpu->arch.cr2;
 	} else if (ex->vector == DB_VECTOR) {
-		/* See inject_pending_event.  */
+		/* See kvm_check_and_inject_events().  */
 		kvm_deliver_exception_payload(vcpu, ex);
 
 		if (vcpu->arch.dr7 & DR7_GD) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 74cbe177e0d1..12e66e2114d1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3520,7 +3520,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 
 	/* Note, this is called iff the local APIC is in-kernel. */
 	if (!READ_ONCE(vcpu->arch.apic->apicv_active)) {
-		/* Process the interrupt via inject_pending_event */
+		/* Process the interrupt via kvm_check_and_inject_events(). */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_vcpu_kick(vcpu);
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d714f335749c..4ed4811a7137 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9704,7 +9704,47 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
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
@@ -10183,7 +10223,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * When APICv gets disabled, we may still have injected interrupts
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
 	 * still active when the interrupt got accepted. Make sure
-	 * inject_pending_event() is called to check for that.
+	 * kvm_check_and_inject_events() is called to check for that.
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
@@ -10480,7 +10520,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		r = inject_pending_event(vcpu, &req_immediate_exit);
+		r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
 		if (r < 0) {
 			r = 0;
 			goto out;
-- 
2.37.1.359.gd136c6c3e2-goog

