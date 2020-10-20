Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9D02853D8
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgJFV0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbgJFV0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:26:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BA5C061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 14:26:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b5so4045plk.2
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 14:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=m7ttRV8rxTRBgNYSIiZwVYKNAnTImX3Y55fX7B/kzUI=;
        b=ALiWkA7iJQTTIVU6uDzu/Vdsbxuffb31jdFBEG5EMHztgBWCVSbo+afuYKzdfIpQWQ
         a/6WpG9Zwdp+kC4Js3uX8VJP1ibbKM+49VHj45bV7BHCgWcihg4+Sc9ShfxwHage4ahO
         EjE7VJQzVqZNq0iuK0cWu+MyxSXXJ8Uz15V1S/j4Sri2Ph0FI8MBNab1Z7cgSmpcW5xk
         cTHKmkjfA5GiH2KgdrF0Nnj5JyNpnU+ib80YyaJpFq7l0J6B7dOzx7CjoRakgp+zog2m
         81Kf0BHMzr/vkYl8wPNCZ1aqW3iN6uzAd2C8RgEEmyyQDnh/w4919++P6JW4+XolotO2
         TaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=m7ttRV8rxTRBgNYSIiZwVYKNAnTImX3Y55fX7B/kzUI=;
        b=TsJJR15Y78X3Yx11BgkTVWxGQAknuof7FkVfoWyhSNAf5+zoNHaVfaulIAQqtF8Dq7
         1IOjnelchF8MZa5KtOY3M6nvybLggJMwzhWQvelPgOjdJO7IP4Is1WZgSoerrYYf53Cr
         dTWNnfbL1b6gCXc8EbJFMBsetyHJhOq6C6Pp8G0bpdJFGcUJ6c63JZuLoSbXaUbov5dS
         /8/WSCaeimvj9HaDlq0tZMT2Do+5p+oDuhH4wDqbbWSXqnwOzwZxLt196zxkKGuyj60F
         QiRpbTTuOuYU9y8I07CqfpLsqzLFEUOupSRzic6sk0hjzqgxqN/f323QgNzhOoJbMOPQ
         F/wg==
X-Gm-Message-State: AOAM531Q7nwMpJ1wVA/jAT0sAWE6lnQ2l7QqQWAtzkYEx9dMKjOkMQH6
        2MjpBYrs/uewhiLs8ACd5Fzz2VbBdSiG2KLKjqEEYunG3ZOE3IAOkn0je9hxeMOoBis/uO9lIIT
        ss01nDDgQ0jL+gEMbPxofwngtL0bMoERDYzT2eHuSmD92ZdaAGvSG0MxnAw==
X-Google-Smtp-Source: ABdhPJylZ8fFG2yjs/EezQopTT1eYnCvaEcVFpyYUxDY/BlpHzBRr2kIpLRO5v10ibzhxWcCFJDCsBDCAfg=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a17:90a:1188:: with SMTP id
 e8mr58668pja.61.1602019559785; Tue, 06 Oct 2020 14:25:59 -0700 (PDT)
Date:   Tue,  6 Oct 2020 14:25:56 -0700
Message-Id: <20201006212556.882066-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [kvm-unit-tests PATCH] x86: vmx: add regression test for posted interrupts
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a guest blocks interrupts for the entirety of running in root mode
(RFLAGS.IF=0), a pending interrupt corresponding to the posted-interrupt
vector set in the VMCS should result in an interrupt posting to the vIRR
at VM-entry. However, on KVM this is not the case. The pending interrupt
is not recognized as the posted-interrupt vector and instead results in
an external interrupt VM-exit.

Add a regression test to exercise this issue.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 lib/x86/asm/bitops.h |  8 +++++
 x86/vmx_tests.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/lib/x86/asm/bitops.h b/lib/x86/asm/bitops.h
index 13a25ec9853d..ce5743538f65 100644
--- a/lib/x86/asm/bitops.h
+++ b/lib/x86/asm/bitops.h
@@ -13,4 +13,12 @@
 
 #define HAVE_BUILTIN_FLS 1
 
+static inline void test_and_set_bit(long nr, unsigned long *addr)
+{
+	asm volatile("lock; bts %1, %0"
+		     : "+m" (*addr)
+		     : "Ir" (nr)
+		     : "memory");
+}
+
 #endif
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index d2084ae9e8ce..9ba9a5d452a2 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10430,6 +10430,81 @@ static void atomic_switch_overflow_msrs_test(void)
 		test_skip("Test is only supported on KVM");
 }
 
+#define PI_VECTOR 0xe0
+#define PI_TEST_VECTOR 0x21
+
+static void enable_posted_interrupts(void)
+{
+	void *pi_desc = alloc_page();
+
+	vmcs_set_bits(PIN_CONTROLS, PIN_POST_INTR);
+	vmcs_set_bits(EXI_CONTROLS, EXI_INTA);
+	vmcs_write(PINV, PI_VECTOR);
+	vmcs_write(POSTED_INTR_DESC_ADDR, (u64)pi_desc);
+}
+
+static unsigned long *get_pi_desc(void)
+{
+	return (unsigned long *)vmcs_read(POSTED_INTR_DESC_ADDR);
+}
+
+static void post_interrupt(u8 vector, u32 dest)
+{
+	unsigned long *pi_desc = get_pi_desc();
+
+	test_and_set_bit(vector, pi_desc);
+	test_and_set_bit(256, pi_desc);
+	apic_icr_write(PI_VECTOR, dest);
+}
+
+static struct vmx_posted_interrupt_test_args {
+	bool isr_fired;
+} vmx_posted_interrupt_test_args;
+
+static void vmx_posted_interrupt_test_isr(isr_regs_t *regs)
+{
+	volatile struct vmx_posted_interrupt_test_args *args
+			= &vmx_posted_interrupt_test_args;
+
+	args->isr_fired = true;
+	eoi();
+}
+
+static void vmx_posted_interrupt_test_guest(void)
+{
+	handle_irq(PI_TEST_VECTOR, vmx_posted_interrupt_test_isr);
+	irq_enable();
+	vmcall();
+	asm volatile("nop");
+	vmcall();
+}
+
+static void vmx_posted_interrupt_test(void)
+{
+	volatile struct vmx_posted_interrupt_test_args *args
+			= &vmx_posted_interrupt_test_args;
+
+	if (!cpu_has_apicv()) {
+		report_skip(__func__);
+		return;
+	}
+
+	enable_vid();
+	enable_posted_interrupts();
+	test_set_guest(vmx_posted_interrupt_test_guest);
+
+	enter_guest();
+	skip_exit_vmcall();
+
+	irq_disable();
+	post_interrupt(PI_TEST_VECTOR, apic_id());
+	enter_guest();
+
+	skip_exit_vmcall();
+	TEST_ASSERT(args->isr_fired);
+	enter_guest();
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10533,5 +10608,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(rdtsc_vmexit_diff_test),
 	TEST(vmx_mtf_test),
 	TEST(vmx_mtf_pdpte_test),
+	TEST(vmx_posted_interrupt_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.28.0.806.g8561365e88-goog

