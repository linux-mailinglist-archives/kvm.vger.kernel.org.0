Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010FF5A71AA
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiH3XTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiH3XSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:25 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A37FA2D9C
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:53 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id n30-20020a17090a5aa100b001fb0c492d5eso5461709pji.3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=M+49WH3sEd/2PdxOVwFHjnmxDrEr5JWuSUi6kMBXc8Q=;
        b=mxT3oIQrls92stnAnba2/OMlkAm2tr5sb/hhFCXR1wyCXFOwlTOIoWukytdqN9lcpq
         4m9I/NUsBNHwsIG9/qCWEgax9UK/yRP/VHU/pojMaPt6Y5+iI7y25DX6HncLVhknvBJj
         hJxFH2aUuHBRmZopPIXzaMD4I6vo9Cb+boYDhsu9rIa18lF5S1yxdihG7x/LO82zIc3l
         +qnaEta8wnxue8E4a0RjakIQSR97I5kQe7i1fkiKGsEyRf1ksmBLrVF7nNE4Jaed16Xo
         h2h3j64Xq82zEuiYwmQ9lV9U/a70GUUTlO4LIwE+8Ur9zDMJ8qQ+sew0vFtQTe9pJQD/
         OyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=M+49WH3sEd/2PdxOVwFHjnmxDrEr5JWuSUi6kMBXc8Q=;
        b=2k2MWthYIP34d4pFCdkz9rgzvVLA//MFP2/FyCo6b96q3RE4UjgA8k7FuzdH5dNc2e
         I5/9dkflo138K/idd5sWcfNsjc20laXMGFkllpA+9PkL0uRl+w5NurOyNF0MjWOt0ekL
         avYHiErkGEhIIOrxNYPsCQ479xvnROFaW8Z2GSpVwUgVmqo1AtRHaFxYNeso1eROBxjb
         gYbmW+PDHgZrlio4L/XU+peNv8SVPOXi0vYJeYts2cxZ1Byg1Ukf/rFF44CWUeNl3M18
         gYtkWESMC0ITIS+GfXUT5xFEFtVKgWTjsV25ATtUMgSyJkVeBC9rcHtkv3WmEc2mF7+7
         ImzA==
X-Gm-Message-State: ACgBeo1REGugUNnhzugmFgLpI79rlw9nLFFyOzBjy439EaBdJkJTa5dv
        3imrwBDhh8/VX3sdyV9rrPmoj+/bwMk=
X-Google-Smtp-Source: AA6agR7nCcR0wFG7ce5E6vslWoKjuIL5XHNBcixZEQDZXyoPkKpTHRt8Df5VUkjT390Zp+GEzQwCoXOGo+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:86d0:0:b0:538:16db:4561 with SMTP id
 h16-20020aa786d0000000b0053816db4561mr14868024pfo.85.1661901405681; Tue, 30
 Aug 2022 16:16:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:04 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-18-seanjc@google.com>
Subject: [PATCH v5 17/27] KVM: x86: Hoist nested event checks above event
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index c19658b7be23..534484318d52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9711,53 +9711,70 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
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
2.37.2.672.g94769d06f0-goog

