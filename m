Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA574D58FC
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346282AbiCKDaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346171AbiCKD3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:51 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75BFF4610
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:31 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mt1-20020a17090b230100b001beef010919so7074103pjb.7
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=i+4VKT/T0igK4H6nIL8Gfamr1MyWuYg2mmUZ99jzwkY=;
        b=hwmPG6QQd/bcIwGYLJ4bWXMayKyuFTxlx4Y872OX386vf6n4mWQITftMTJ701ufphg
         WXitE3WSt0Yit1dYeolSLwidjXqLSFhcPg8M7Tc3SkigjcUnSDOhRpxBdHza2RQg9X/V
         uGaV6XZjtoI5JPi+WVmo79QEtfM7sghplCMR+OJTG9C9z4RDvU29IA0d5ikyzYJkZ7DU
         2sB7Fw9wdNUtCm25OGxkXLs9Pk+zw7tiuoC1IjKr2UO6rgREHEJdwr+nejCw+1AN+o3Q
         Htn0FaAXoCGRm6wmdYxSqXzHVmwxTrh2b0KBhhJMTajRVrTTKYJS2rFTDffDWN94gZ0+
         okZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=i+4VKT/T0igK4H6nIL8Gfamr1MyWuYg2mmUZ99jzwkY=;
        b=J0+Sq2WNmyZnXJzJj9x8sb+Ym5JX2suBnBOzFUYWI4Gjkqv0tr8ox3v47HigGxFcDc
         +SEaBAaMPwicDBAkA+WghozSI5h3RBiy641zlmv+iV2QzoyXjO6DdzcGJiTlb206Pd2p
         +9lZG1gCkFtOODhWV1/NcnbDS7GZcOqbY3kVOd4RW5YJNQwzUZG9//IRtHN7BGfYya4B
         O66uOcSXctFx7U3z8eP2iuL8Mv6XZb2oeVkXHkngx/FX/mthAcNjYoeF1OLDKHea+sDh
         JkmHPSx2beZ4E6hH5oeKucBNuEZ50vcjXS9SQxLSgOi2L0DKXXudD/xRNkjH1u4J71Fo
         swsA==
X-Gm-Message-State: AOAM530m3l9j2DFhBPQHho9Xo92GZyIc4/Z7i/VLZRUI+00f4HnK3DMc
        R2MV9h3ArBVz4T8i2ccXDSt7nUEeNS0=
X-Google-Smtp-Source: ABdhPJwP3kPk0WzwJcRj8UYWr/Hbf4nQuNWxLQglFe71shnkQamqtXcMQveMwcydk+qVemlF9uPbs253KKA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9681:b0:150:288:7440 with SMTP id
 n1-20020a170902968100b0015002887440mr8268721plp.166.1646969311239; Thu, 10
 Mar 2022 19:28:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:56 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 16/21] KVM: x86: Hoist nested event checks above event
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
index d6fbff896263..c1cd2166fe22 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9310,53 +9310,70 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 
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
+		static_call(kvm_x86_inject_irq)(vcpu);
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
-			static_call(kvm_x86_inject_irq)(vcpu);
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
2.35.1.723.g4982287a31-goog

