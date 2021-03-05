Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCF332DF8F
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 03:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCECSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 21:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCECSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 21:18:15 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4ABC061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 18:18:15 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id p32so380251qtd.14
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 18:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=iFsu/EdgzPCi1WqYdYUBcFgRLZpgieXshXK9nnq/e2Q=;
        b=Dm7EqRrQGHwk4GNJMLxWsQTTtpmjMKr5XzzRltH4yF4XLUzdFFiyvsjnp1NTrFqAWD
         CjfRG3hCuW1YFGc6A9Y05LccX7aY94QO+wvrTna8ER7QCPvAqc9cTr+SDbDE7Ldpjw3t
         rgtktSM2aFRd0K33Dqco70ItekgC6OfWuwo0KQ+vkE9LIdkGuecrItyAYNY5IrqvtPnf
         IM5vybBlZZIJb6OQHKcf0RcSJiUJryCWGAhm5Qi0FNJWVncKswsoai/pll1Euh2JIGiA
         gbO6fIcNJdAVjAQtSPfOZWTgAaL5JAINvcWY30PuSr1We+YkowOrraGVXDfiXT9XhhEG
         nq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=iFsu/EdgzPCi1WqYdYUBcFgRLZpgieXshXK9nnq/e2Q=;
        b=XZcRynh44y5qxDNyZXBkBUUa4mi/LzN0Na4dFgFBQfyFqKWQz7CM8CttjNOVikudqF
         JFef39+HDscx/NFx5uqcLq2q9zRlMTmQYABAJeNXBNC91mH2CDPuKZOX/yrQolIMrnNg
         uQ2sIE3r8Psjjxuvnz5dQLfeB2IMMDbeXeD4e+irZBPPWZdZbyKyAS94mrxTL+qudsMu
         Xspydyju9i/jT4t0nl/qZfzPHgK1BYE/lQ3a/h+YPlVjMEtetPctrsC7R9/Hrs2BRJaB
         1tPMl/mg6518VW/nWLau4BMJVhPN/fH1WUpHmhux022zU2e7SCj/WVFEaLDTNYS60Aye
         wKww==
X-Gm-Message-State: AOAM531xUqpeFiFWo07go7MPkuEKjOrt+Gvxypa4lkUqmMK2VtPEPh8P
        KyBHdx7b0lLIxdxebUc+A2bqTB7AEag=
X-Google-Smtp-Source: ABdhPJyfHd60C/yt6/C0Ijkwk9RyVf8bjnYna4ppLSBzVsVQ7VGppNses7R6R1uiC2x3LrH3g3AER8JsCOo=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a0c:fec8:: with SMTP id z8mr7027044qvs.59.1614910691867;
 Thu, 04 Mar 2021 18:18:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 18:18:08 -0800
Message-Id: <20210305021808.3769732-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] KVM: x86: Ensure deadline timer has truly expired before
 posting its IRQ
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When posting a deadline timer interrupt, open code the checks guarding
__kvm_wait_lapic_expire() in order to skip the lapic_timer_int_injected()
check in kvm_wait_lapic_expire().  The injection check will always fail
since the interrupt has not yet be injected.  Moving the call after
injection would also be wrong as that wouldn't actually delay delivery
of the IRQ if it is indeed sent via posted interrupt.

Fixes: 010fd37fddf6 ("KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 45d40bfacb7c..cb8ebfaccfb6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1642,7 +1642,16 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	}
 
 	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
-		kvm_wait_lapic_expire(vcpu);
+		/*
+		 * Ensure the guest's timer has truly expired before posting an
+		 * interrupt.  Open code the relevant checks to avoid querying
+		 * lapic_timer_int_injected(), which will be false since the
+		 * interrupt isn't yet injected.  Waiting until after injecting
+		 * is not an option since that won't help a posted interrupt.
+		 */
+		if (vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
+		    vcpu->arch.apic->lapic_timer.timer_advance_ns)
+			__kvm_wait_lapic_expire(vcpu);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}
-- 
2.30.1.766.gb4fecdf3b7-goog

