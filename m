Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E4F576876
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiGOUoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiGOUni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:38 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701B38AB20
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31c9d560435so48254387b3.21
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uHLk8sP9TUeSc2rn7/8IPGb+aPXTg7ugp0ISqgDN96A=;
        b=KeZRj2deakl9NGv9O7J1SKPGb0YlgEbwYWWshX4tKITStFBSy26TO0J/+020rcFQU4
         ATlMzDDM5BzTOQ0yTY7nj8IOZrkiJW8zonaWccNOwHtc6ZQW2ddNHPlWzcO5N5T8j3jZ
         f2zfe+aHgT4HuqyVnyK9dW+UmxzTAPLatI+f3YA5lQMUb7EvIUly4a8dYrbd1vIIJEU0
         AQsgE7Fo5G8gXxyFq2bBCkKYpvbZvWWQHz4Mepbly8aoz3cJM/ruuSVs3hWVHJVqjH5l
         rKIA+ZNrDD0PA85iLH+chdXufGipccXUSF4K2NQhSQpfNJOoI6twD1B+WhYWIDAJjdj4
         xbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uHLk8sP9TUeSc2rn7/8IPGb+aPXTg7ugp0ISqgDN96A=;
        b=jJbQ1jMEiWdDVXNNCxW2WX7GKokCo58CqjzyBzD4u0ebFVfXDV0Say/fFlly3Q+itv
         +T11A3/5lt8PpGH0nkCdwCJBiG5KLn6Rk/RL9jubdCJ9kfHzpH7NSUS9Cq0RqCOrt2im
         ANWHLNKGT3JyRbfgVx74Jmxl2d9VGxPQklMntpLl4uc/TKhuWtz1dylTG0PUynCu+QHq
         HrjzoVOtkS6kYLAaILKOFYd4aApA7fH0CvJYP4puX7G4z2OiEH9aC3ovZIORSRMJukU7
         UzQZRWw/bQKQaGtel7XHCPraf2y56ZYzDW3z02FaC+Ue5oJBs9jEmkDO7ix1YtaaSV1a
         KskQ==
X-Gm-Message-State: AJIora8VHdEgq6kePeHzwKwm/TCztytCws6g/S7rt1HElfpweMjngWkb
        HW9PejL9FWB+1jTP5n9u+ROiwo7Kn6c=
X-Google-Smtp-Source: AGRyM1tuG3QjMI1RKqKnmHGFaRTp34Se2KtLlMTHsC09ZDUJXO9dTYNabG3X9vbIDipMsKW360k5FQBUNyI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:55:0:b0:66f:cdfc:d74 with SMTP id
 82-20020a250055000000b0066fcdfc0d74mr8865821yba.346.1657917779510; Fri, 15
 Jul 2022 13:42:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:17 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 15/24] KVM: x86: Hoist nested event checks above event
 injection logic
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

Perform nested event checks before re-injecting exceptions/events into
L2.  If a pending exception causes VM-Exit to L1, re-injecting events
into vmcs02 is premature and wasted effort.  Take care to ensure events
that need to be re-injected are still re-injected if checking for nested
events "fails", i.e. if KVM needs to force an immediate entry+exit to
complete the to-be-re-injecteed event.

Keep the "can_inject" logic the same for now; it too can be pushed below
the nested checks, but is a slightly riskier change (see past bugs about
events not being properly purged on nested VM-Exit).

Add and/or modify comments to better document the various interactions.
Of note is the comment regarding "blocking" previously injected NMIs and
IRQs if an exception is pending.  The old comment isn't wrong strictly
speaking, but it failed to capture the reason why the logic even exists.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 89 +++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5aaa1d8de0b3..9e20d34d856d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9657,53 +9657,70 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
+	bool can_inject = !kvm_event_needs_reinjection(vcpu);
 	int r;
-	bool can_inject = true;
 
-	/* try to reinject previous events if any */
+	/*
+	 * Process nested events first, as nested VM-Exit supercedes event
+	 * re-injection.  If there's an event queued for re-injection, it will
+	 * be saved into the appropriate vmc{b,s}12 fields on nested VM-Exit.
+	 */
+	if (is_guest_mode(vcpu))
+		r = kvm_check_nested_events(vcpu);
+	else
+		r = 0;
 
-	if (vcpu->arch.exception.injected) {
+	/*
+	 * Re-inject exceptions and events *especially* if immediate entry+exit
+	 * to/from L2 is needed, as any event that has already been injected
+	 * into L2 needs to complete its lifecycle before injecting a new event.
+	 *
+	 * Don't re-inject an NMI or interrupt if there is a pending exception.
+	 * This collision arises if an exception occurred while vectoring the
+	 * injected event, KVM intercepted said exception, and KVM ultimately
+	 * determined the fault belongs to the guest and queues the exception
+	 * for injection back into the guest.
+	 *
+	 * "Injected" interrupts can also collide with pending exceptions if
+	 * userspace ignores the "ready for injection" flag and blindly queues
+	 * an interrupt.  In that case, prioritizing the exception is correct,
+	 * as the exception "occurred" before the exit to userspace.  Trap-like
+	 * exceptions, e.g. most #DBs, have higher priority than interrupts.
+	 * And while fault-like exceptions, e.g. #GP and #PF, are the lowest
+	 * priority, they're only generated (pended) during instruction
+	 * execution, and interrupts are recognized at instruction boundaries.
+	 * Thus a pending fault-like exception means the fault occurred on the
+	 * *previous* instruction and must be serviced prior to recognizing any
+	 * new events in order to fully complete the previous instruction.
+	 */
+	if (vcpu->arch.exception.injected)
 		kvm_inject_exception(vcpu);
-		can_inject = false;
-	}
+	else if (vcpu->arch.exception.pending)
+		; /* see above */
+	else if (vcpu->arch.nmi_injected)
+		static_call(kvm_x86_inject_nmi)(vcpu);
+	else if (vcpu->arch.interrupt.injected)
+		static_call(kvm_x86_inject_irq)(vcpu, true);
+
 	/*
-	 * Do not inject an NMI or interrupt if there is a pending
-	 * exception.  Exceptions and interrupts are recognized at
-	 * instruction boundaries, i.e. the start of an instruction.
-	 * Trap-like exceptions, e.g. #DB, have higher priority than
-	 * NMIs and interrupts, i.e. traps are recognized before an
-	 * NMI/interrupt that's pending on the same instruction.
-	 * Fault-like exceptions, e.g. #GP and #PF, are the lowest
-	 * priority, but are only generated (pended) during instruction
-	 * execution, i.e. a pending fault-like exception means the
-	 * fault occurred on the *previous* instruction and must be
-	 * serviced prior to recognizing any new events in order to
-	 * fully complete the previous instruction.
+	 * Exceptions that morph to VM-Exits are handled above, and pending
+	 * exceptions on top of injected exceptions that do not VM-Exit should
+	 * either morph to #DF or, sadly, override the injected exception.
 	 */
-	else if (!vcpu->arch.exception.pending) {
-		if (vcpu->arch.nmi_injected) {
-			static_call(kvm_x86_inject_nmi)(vcpu);
-			can_inject = false;
-		} else if (vcpu->arch.interrupt.injected) {
-			static_call(kvm_x86_inject_irq)(vcpu, true);
-			can_inject = false;
-		}
-	}
-
 	WARN_ON_ONCE(vcpu->arch.exception.injected &&
 		     vcpu->arch.exception.pending);
 
 	/*
-	 * Call check_nested_events() even if we reinjected a previous event
-	 * in order for caller to determine if it should require immediate-exit
-	 * from L2 to L1 due to pending L1 events which require exit
-	 * from L2 to L1.
+	 * Bail if immediate entry+exit to/from the guest is needed to complete
+	 * nested VM-Enter or event re-injection so that a different pending
+	 * event can be serviced (or if KVM needs to exit to userspace).
+	 *
+	 * Otherwise, continue processing events even if VM-Exit occurred.  The
+	 * VM-Exit will have cleared exceptions that were meant for L2, but
+	 * there may now be events that can be injected into L1.
 	 */
-	if (is_guest_mode(vcpu)) {
-		r = kvm_check_nested_events(vcpu);
-		if (r < 0)
-			goto out;
-	}
+	if (r < 0)
+		goto out;
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
-- 
2.37.0.170.g444d1eabd0-goog

