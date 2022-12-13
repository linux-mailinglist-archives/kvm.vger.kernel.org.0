Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD17064AFA2
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbiLMGJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiLMGJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:09:26 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3934F1ADA2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:25 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m13-20020a170902f64d00b001899a70c8f1so12437882plg.14
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3ygtdZJHpe2jAbhrmEODv8rggvGUoguv5qPo3aQqhPM=;
        b=pcmVTu4JD8o5BzVbE5RqsAHQF4iTjRKXTPoe+Wr1AmHVQrlVOOLTREcGLzBdX+CoDo
         X5MOObPom/RmvwSbNsO6KyVsAm0XRd0voNAY0/brtLjD+YSWb/xEvQB+xHexbwoeoPei
         9jdk3IzS747RceXkfVCGzDvhLBGFC74oZOJdMmE48mLLaRx/wH091RT6FwBPkS/zbRf9
         Oyb4HYwaW1FIGfBTJJj30F7YXbKC/w0okF46x5P04R3+nRZpvXvjuTWHfIssZ5QAoX7I
         6ex6l/Gs54L1I9eeJHSnhDUtkWvSF4Whla4N2HvTnwSewDlW82hqZ8zQ+QeeiOZJ0UkE
         4cag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ygtdZJHpe2jAbhrmEODv8rggvGUoguv5qPo3aQqhPM=;
        b=zCkDBid6TZ3Rn8IgPi6B3GPG35nyk+AWirax5xdvHrDUf0awFs6rCxp0rZsYDQJOCQ
         4HSALOJ8bZwOcQFC5RYKoBbIKOs4hEarc3FwbYtuSShyq4nQrillkFnGVwZuI4JS2fr3
         CPchxsD13UlGpr2XAMIXn1W7cB6xHsfwGjwspL1JwEjKczXWJtaXzXi4n8VRLywHU7Lk
         vwTFr74JLqGAXAvABo0WecqFuSMoMvnJvNaFI4IY6sVhJnrokIZWWBwQcbF8lZm+JUm1
         hN5seGONsGCDxfn8APK8L/i79BbbqMmJJMhAXmqGzfJmuKgCUZm55J+VFFrt1iI9LqEZ
         h0dQ==
X-Gm-Message-State: ANoB5pmBxXqVMXR12V4PO9QTI6zkwbR8chA1UXjgiXy3hIg9P2a4MMse
        lBVok0Z8FhEgsn/2so3C87wxqQ8Fu54=
X-Google-Smtp-Source: AA0mqf5qUYpkTbaxWjOo5zAYsTVPsJWj4HukpB0jjDg+TpR/x3X6VGRcXqTYdfccQRGJk7CJ8Xrm8cfONws=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f14b:b0:18f:5a3:6069 with SMTP id
 d11-20020a170902f14b00b0018f05a36069mr706521plb.46.1670911764799; Mon, 12 Dec
 2022 22:09:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:09:10 +0000
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213060912.654668-6-seanjc@google.com>
Subject: [PATCH 5/7] x86/entry: KVM: Use dedicated VMX NMI entry for 32-bit
 kernels too
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
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

Use a dedicated entry for invoking the NMI handler from KVM VMX's VM-Exit
path for 32-bit even though using a dedicated entry for 32-bit isn't
strictly necessary.  Exposing a single symbol will allow KVM to reference
the entry point in assembly code without having to resort to more #ifdefs
(or #defines).  identry.h is intended to be included from asm files only
once, and so simply including idtentry.h in KVM assembly isn't an option.

Bypassing the ESP fixup and CR3 switching in the standard NMI entry code
is safe as KVM always handles NMIs that occur in the guest on a kernel
stack, with a kernel CR3.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/idtentry.h | 16 ++++++----------
 arch/x86/kernel/nmi.c           |  8 ++++----
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 72184b0b2219..b241af4ce9b4 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -582,18 +582,14 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 
 /* NMI */
 
-#if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_KVM_INTEL)
 /*
- * Special NOIST entry point for VMX which invokes this on the kernel
- * stack. asm_exc_nmi() requires an IST to work correctly vs. the NMI
- * 'executing' marker.
- *
- * On 32bit this just uses the regular NMI entry point because 32-bit does
- * not have ISTs.
+ * Special entry point for VMX which invokes this on the kernel stack, even for
+ * 64-bit, i.e. without using an IST.  asm_exc_nmi() requires an IST to work
+ * correctly vs. the NMI 'executing' marker.  Used for 32-bit kernels as well
+ * to avoid more ifdeffery.
  */
-DECLARE_IDTENTRY(X86_TRAP_NMI,		exc_nmi_noist);
-#else
-#define asm_exc_nmi_noist		asm_exc_nmi
+DECLARE_IDTENTRY(X86_TRAP_NMI,		exc_nmi_kvm_vmx);
 #endif
 
 DECLARE_IDTENTRY_NMI(X86_TRAP_NMI,	exc_nmi);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index cec0bfa3bc04..e37faba95bb5 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -527,14 +527,14 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 		mds_user_clear_cpu_buffers();
 }
 
-#if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
-DEFINE_IDTENTRY_RAW(exc_nmi_noist)
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+DEFINE_IDTENTRY_RAW(exc_nmi_kvm_vmx)
 {
 	exc_nmi(regs);
 }
-#endif
 #if IS_MODULE(CONFIG_KVM_INTEL)
-EXPORT_SYMBOL_GPL(asm_exc_nmi_noist);
+EXPORT_SYMBOL_GPL(asm_exc_nmi_kvm_vmx);
+#endif
 #endif
 
 void stop_nmi(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e2c96f204b82..7ace22ee240d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6791,7 +6791,7 @@ void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 					unsigned long entry)
 {
-	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
+	bool is_nmi = entry == (unsigned long)asm_exc_nmi_kvm_vmx;
 
 	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
 	vmx_do_interrupt_nmi_irqoff(entry);
@@ -6820,7 +6820,7 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
-	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
+	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_kvm_vmx;
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

