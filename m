Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C685A71B7
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiH3XTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiH3XSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:44 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FB8A3D31
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:17:01 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l16-20020a170902f69000b00175138bcd25so2334963plg.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=ppFRkhG99Lekds01NjhzNIGVVTbKBQGCAaihGiWF468=;
        b=EPrQnz5TZu1DM3Qso0wkPVPEPDWGIYBwKc9otwlVqCzNXXWzBj9zKRq9lA3BDkW6lA
         KN/SH0Jyul5m5uLFWXqKoco8p4r5ChqoOjw4iJjxFpilADDC09XL3Ud9FjnlL+AcHMUi
         fjGRh29o204uIulHCMudGmdUxZAeukPc1mGi3qCVcuAAPH5Bhtj6DOplNW/7HXfNWJzu
         Iy/ccXeuklhzrEdJlLmDANaYUgeZiQX7F79qqik9eBbyUXuG2oqKFr5HNffhVWtXeNwl
         zRAE7qX2QHa27441JdmzjGR4S4y8yjl5oqED0OAoYuynvGx3Nbn5IAe63rnIho1nR2by
         LdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=ppFRkhG99Lekds01NjhzNIGVVTbKBQGCAaihGiWF468=;
        b=NbhOg3xV8GTiZVxlSo23Fc+thkZIElMlzXnB7Q5wTU/g/MMkSZqcFTIBtoVoQPvPoX
         aQOeOkn4EycuwkEOBUeTUognN/8BqFMFkNVolLD1lst+LVz/BCBD9j3Tc8wge/qDBg3I
         TvlqCVgoHi+3RwUMvPyug7s0/EwKnMlJq6iHwpWr9rJ+2ZWQuBZsbWERkXh6VA/PHjUI
         omYsbUIN+zsy1o8f2Zw9ntWqoprwZD8dglBPfViz+ZQsvm6JqGoPlomJxI7GoaSnijYP
         4XprsuTJboHuavYZ4uEVcwOQ9fTLeqP9uETnLRvX0nZC7SCNBdMZUEyM4jceQ0ildnJN
         Owlg==
X-Gm-Message-State: ACgBeo3vpYWNb2kQlphvdj0wdvpaxO95+D5muyJc/JBd9+3Wu3XkgxZ9
        X++sqhQHAgdr4kNZy/YxW8iHHlpeA9I=
X-Google-Smtp-Source: AA6agR6Gw2OIgKEMgtNFmk7jbNSdCA5FuTDIwR93NeBqqGEzHzaWbjNgr4CyfTtDKcOU5iWRTEqQA2vXxCo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:fb05:0:b0:430:268f:f8c9 with SMTP id
 o5-20020a63fb05000000b00430268ff8c9mr398202pgh.559.1661901417187; Tue, 30 Aug
 2022 16:16:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:11 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-25-seanjc@google.com>
Subject: [PATCH v5 24/27] KVM: x86: Rename inject_pending_events() to kvm_check_and_inject_events()
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index dbd10d61f29d..fc6eae94aa61 100644
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
index d004e18c7cdb..45f295d35cc9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9745,7 +9745,47 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
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
@@ -10224,7 +10264,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * When APICv gets disabled, we may still have injected interrupts
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
 	 * still active when the interrupt got accepted. Make sure
-	 * inject_pending_event() is called to check for that.
+	 * kvm_check_and_inject_events() is called to check for that.
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
@@ -10521,7 +10561,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		r = inject_pending_event(vcpu, &req_immediate_exit);
+		r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
 		if (r < 0) {
 			r = 0;
 			goto out;
-- 
2.37.2.672.g94769d06f0-goog

