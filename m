Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9D54BC37
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358262AbiFNUsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358330AbiFNUsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0952C4F9DD
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 10-20020a250d0a000000b0065ca0e7be90so8523232ybn.17
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iqv4+Lwd07qSh4P8HKRWQr9blRzWX3z9Tw+H35YUqtM=;
        b=JfYP9tgmlXPT+59MiTL2dMou5OicLp9Bb0k7qtwKpQF1T4ekEBeazR8kh2efSeUgMl
         jKbAP5kQTaNZAMprtkK0dSVfnzJeURvvviTX1vqS0aG4ngW/J5rFxzHhADpUkHeNgKPg
         BJ2uPMxurwVGDRv6+wkoLOyrneQhjgDiafPVh1BsXWxmlM6tE9QxT3ZOgWxVr0HmAjoY
         EMV5cWaxi/WdByzOvK8b0wWuJ4hvB6PagaKhR0l0QcutL7OeH6s2Jz+NYt0GMXSFukma
         YAeOfv6hVmiVBdlKeNSPzMifeBeEQvDuWdZHRssEbStrKKVrAlNKKR9rVyPQUWSM+YUF
         5DpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iqv4+Lwd07qSh4P8HKRWQr9blRzWX3z9Tw+H35YUqtM=;
        b=YjdQevDdjLh/Wp+VlzNGZvtcm0U0Zid9K2VL6PonTcAKRWYkPlpH7NArMaoCqiJWPc
         o/Exy5c+JQ70oTU1Swl3M4mzFH0oshEj8S6he9dU+/8AKrPSD3rUuknSQNECqDWz1Cja
         vbTxFuZWgDQ02MXFrNZLrIloys4WerfMTX7V0bp56SxyRVSY5fQMy6XYpP1ucgFy1tMZ
         JXFGOBSSOxhqfmlrSuL6/BsGW0AwwYEPb4voe7lnWxlq8cpLcp0kD4rJcQK5JeUKvpVl
         46Ud2i5X+wcFsl6xRPFCTF2nIo5zYfeeAhK3dPaq9wAsDfYPJxveR+z/J3+JhycW/BiP
         //eA==
X-Gm-Message-State: AJIora9SVisN694lJxCH0FPENDA2pPFh5qA/WabHQnQXZu2TQNlXulQw
        TYK8GlhwnNIduFZ4W+8w9scPtYDuTGo=
X-Google-Smtp-Source: AGRyM1ug7KMkcC/J7mqr+mnxuOoM2UziB6qTreQGsxxfAyflk5d7t7TRAanHTTeNtMxZf4N1BGHvT4qmERA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:9b48:0:b0:664:b4d0:83ca with SMTP id
 u8-20020a259b48000000b00664b4d083camr7210021ybo.277.1655239683573; Tue, 14
 Jun 2022 13:48:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:24 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-16-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 15/21] KVM: x86: Hoist nested event checks above event
 injection logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
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
---
 arch/x86/kvm/x86.c | 89 +++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e45465075005..930de833aa2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9502,53 +9502,70 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
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
2.36.1.476.g0c4daa206d-goog

