Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA6242748C
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244016AbhJIANQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 20:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244007AbhJIANO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 20:13:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F553C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 17:11:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso14876900ybj.1
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 17:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XhfDVnt1beDya8hVZyf7CTBukIbNlfCHrkpgQCH938o=;
        b=TRPXxZj4iqlwsifNPPr5NQYrh0m9NndJIcDL/e//ZaHWWqTcWAE83hNZmBtkdKIOqm
         ru8XS0uQ8OLgq7kE2FmDEH5Toem+oOnJtuXSUv/9M9/KeA2hcyd+OSkcDHL/prriBcq0
         Gs2ydI4KAEaZRLM2yz8QQp/QXqzzu8r2z8NmmkgFOjk4JD/6+iTVU/34yGIVrFg7DOty
         6I0pCtv4RHANaLD5Zi76klyVsHKh69PD+pT57BPgGn3e8pyJN1Kt4jZkLELBQHVhDBxH
         XMhyN2U1l5PeNqeypfS6qluZnJulwo5Q1DgXZAEre5NijdEqMo/kcUmlnHknBuZUt27d
         5/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XhfDVnt1beDya8hVZyf7CTBukIbNlfCHrkpgQCH938o=;
        b=1sLOzYY93zQqncNTJZnNrao7RZgJ8m68qFtascVOAMl1Z1Wy5Z2ObXYjTKmPN2DRMm
         4+GeCRtd9XCjgY4eE035PNmm13SZw1gQIUbcripksTK7+w+DuezuWIwFZ5Eyplwe1gV4
         O91iTrN2DKo+gRInv03Of0pDVGsYP1HCgIGcTXiUvhNSa7Dx3UP2Ea5yhzrEgOWL9oT8
         hTKfW2WjoqALuZOEwuK0hLpVVM/zCplLMy/KKdU79ktQxQ6pGGgCAAioyJ9C8b64dP7Q
         SVG8mxTVuC/4DDZSx79OxIXI5/BFeX1B652k/hTEdHhclBKwUAlttCLX9Q5AXq/uE7oz
         ihfw==
X-Gm-Message-State: AOAM533HLlmglTuL8Qr3Fni4vtSWV2JEUMXCVTHb4UDqS3YaOch+e+Bi
        XO6X67+Ap60QAbCgikzkg7WRVyeSRBk=
X-Google-Smtp-Source: ABdhPJxvoC0RVW5CYS2eGcmMKc5glkCde6sHEUyfLdTt66CAgiPbCwoMRfD3El8+WoTYw0/nrSQeKEA2mBc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:5b83:: with SMTP id p125mr6827386ybb.277.1633738277403;
 Fri, 08 Oct 2021 17:11:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 17:11:06 -0700
In-Reply-To: <20211009001107.3936588-1-seanjc@google.com>
Message-Id: <20211009001107.3936588-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211009001107.3936588-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 3/4] x86/irq: KVM: Harden posted interrupt (un)registration paths
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the register and unregister paths for the posted interrupt wakeup
handler, and WARN on conditions that are blatant bugs, e.g. attempting to
overwrite an existing handler, unregistering the wrong handler, etc...
This is very much a "low hanging fruit" hardening, e.g. a broken module
could foul things up by doing concurrent registration from multiple CPUs.

Drop the use of a dummy handler so that the rejection logic can use a
simple NULL check.  There is zero benefit to blindly calling into a dummy
handler.

Note, the registration path doesn't require synchronization, as it's the
caller's responsibility to not generate interrupts it cares about until
after its handler is registered, i.e. there can't be a relevant in-flight
interrupt.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/irq.h |  3 ++-
 arch/x86/kernel/irq.c      | 29 ++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c     |  4 ++--
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 768aa234cbb4..c79014c2443d 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -30,7 +30,8 @@ struct irq_desc;
 extern void fixup_irqs(void);
 
 #ifdef CONFIG_HAVE_KVM
-extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
+extern void kvm_register_posted_intr_wakeup_handler(void (*handler)(void));
+extern void kvm_unregister_posted_intr_wakeup_handler(void (*handler)(void));
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 20773d315308..97f452cc84be 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -284,18 +284,26 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 #endif
 
 #ifdef CONFIG_HAVE_KVM
-static void dummy_handler(void) {}
-static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
+static void (*kvm_posted_intr_wakeup_handler)(void);
 
-void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
+void kvm_register_posted_intr_wakeup_handler(void (*handler)(void))
 {
-	if (handler)
-		kvm_posted_intr_wakeup_handler = handler;
-	else
-		kvm_posted_intr_wakeup_handler = dummy_handler;
+	if (WARN_ON_ONCE(!handler || kvm_posted_intr_wakeup_handler))
+		return;
+
+	WRITE_ONCE(kvm_posted_intr_wakeup_handler, handler);
+}
+EXPORT_SYMBOL_GPL(kvm_register_posted_intr_wakeup_handler);
+
+void kvm_unregister_posted_intr_wakeup_handler(void (*handler)(void))
+{
+	if (WARN_ON_ONCE(!handler || handler != kvm_posted_intr_wakeup_handler))
+		return;
+
+	WRITE_ONCE(kvm_posted_intr_wakeup_handler, NULL);
 	synchronize_rcu();
 }
-EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
+EXPORT_SYMBOL_GPL(kvm_unregister_posted_intr_wakeup_handler);
 
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
@@ -311,9 +319,12 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_ipi)
  */
 DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_posted_intr_wakeup_ipi)
 {
+	void (*handler)(void) = READ_ONCE(kvm_posted_intr_wakeup_handler);
+
 	ack_APIC_irq();
 	inc_irq_stat(kvm_posted_intr_wakeup_ipis);
-	kvm_posted_intr_wakeup_handler();
+	if (handler)
+		handler();
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bfdcdb399212..9164f1870d49 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7553,7 +7553,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 static void hardware_unsetup(void)
 {
-	kvm_set_posted_intr_wakeup_handler(NULL);
+	kvm_unregister_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
@@ -7907,7 +7907,7 @@ static __init int hardware_setup(void)
 	if (r)
 		nested_vmx_hardware_unsetup();
 
-	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
+	kvm_register_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	return r;
 }
-- 
2.33.0.882.g93a45727a2-goog

