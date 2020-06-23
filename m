Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3F204F99
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbgFWKwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:52:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41150 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732375AbgFWKwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MtuBBuxFtTIbU5iSzkSfmj8H1qBI68ds9qLJJkYV0+c=;
        b=RIE/Tnsie/lAzW+H9lO9jYiqJksROONiaVQRhyo8JY+0N3u4pKqw2BFmjDpFMMtIuoy+eK
        DhPKMh56iIMiazKCj88DKqtuDppo1lYRUcxj0usDdv+wS3eiIKIZzykyfeWw7ZIumQq5Oc
        V/+ZYV7Wmtiql/xNJ73iE8fJIhDe3bc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-15iMkhFWNiKhCE6nMtiIiw-1; Tue, 23 Jun 2020 06:52:10 -0400
X-MC-Unique: 15iMkhFWNiKhCE6nMtiIiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D325418FF660
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:52:09 +0000 (UTC)
Received: from starship.redhat.com (unknown [10.35.206.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8869619934;
        Tue, 23 Jun 2020 10:52:08 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2] SVM: add test for nested guest RIP corruption
Date:   Tue, 23 Jun 2020 13:52:07 +0300
Message-Id: <20200623105207.149798-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a unit test for SVM nested register corruption that happened when
L0 was emulating an instruction, but then injecting an interrupt intercept to L1, which
lead it to give L1 vmexit handler stale (pre emulation) values of RAX,RIP and RSP.

This test detects the RIP corruption (situation when RIP is at the start of
the emulated instruction but the instruction, was already executed.

The upstream commit that fixed this bug is b6162e82aef19fee9c32cb3fe9ac30d9116a8c73
  KVM: nSVM: Preserve registers modifications done before nested_svm_vmexit()

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c1abd55..202c829 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1789,6 +1789,105 @@ static bool virq_inject_check(struct svm_test *test)
     return get_test_stage(test) == 5;
 }
 
+/*
+ * Detect nested guest RIP corruption as explained in kernel commit
+ * b6162e82aef19fee9c32cb3fe9ac30d9116a8c73
+ *
+ * In the assembly loop below 'ins' is executed while IO instructions
+ * are not intercepted; the instruction is emulated by L0.
+
+ * At the same time we are getting interrupts from the local APIC timer,
+ * and we do intercept them in L1
+ *
+ * If the interrupt happens on the insb instruction, L0 will VMexit, emulate
+ * the insb instruction and then it will inject the interrupt to L1 through
+ * a nested VMexit.  Due to a bug, it would leave pre-emulation values of RIP,
+ * RAX and RSP in the VMCB.
+ *
+ * In our intercept handler we detect the bug by checking that RIP is that of
+ * the insb instruction, but its memory operand has already been written.
+ * This means that insb was already executed.
+ */
+
+static volatile int isr_cnt = 0;
+static volatile uint8_t io_port_var = 0xAA;
+extern const char insb_instruction_label[];
+
+static void reg_corruption_isr(isr_regs_t *regs)
+{
+    isr_cnt++;
+    apic_write(APIC_EOI, 0);
+}
+
+static void reg_corruption_prepare(struct svm_test *test)
+{
+    default_prepare(test);
+    set_test_stage(test, 0);
+
+    vmcb->control.int_ctl = V_INTR_MASKING_MASK;
+    vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+
+    handle_irq(TIMER_VECTOR, reg_corruption_isr);
+
+    /* set local APIC to inject external interrupts */
+    apic_write(APIC_TMICT, 0);
+    apic_write(APIC_TDCR, 0);
+    apic_write(APIC_LVTT, TIMER_VECTOR | APIC_LVT_TIMER_PERIODIC);
+    apic_write(APIC_TMICT, 1000);
+}
+
+static void reg_corruption_test(struct svm_test *test)
+{
+    /* this is endless loop, which is interrupted by the timer interrupt */
+    asm volatile (
+            "1:\n\t"
+            "movw $0x4d0, %%dx\n\t" // IO port
+            "lea %[_io_port_var], %%rdi\n\t"
+            "movb $0xAA, %[_io_port_var]\n\t"
+            "insb_instruction_label:\n\t"
+            "insb\n\t"
+            "jmp 1b\n\t"
+
+            : [_io_port_var] "=m" (io_port_var)
+            : /* no inputs*/
+            : "rdx", "rdi"
+    );
+}
+
+static bool reg_corruption_finished(struct svm_test *test)
+{
+    if (isr_cnt == 10000) {
+        report(true,
+               "No RIP corruption detected after %d timer interrupts",
+               isr_cnt);
+        set_test_stage(test, 1);
+        return true;
+    }
+
+    if (vmcb->control.exit_code == SVM_EXIT_INTR) {
+
+        void* guest_rip = (void*)vmcb->save.rip;
+
+        irq_enable();
+        asm volatile ("nop");
+        irq_disable();
+
+        if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
+            report(false,
+                   "RIP corruption detected after %d timer interrupts",
+                   isr_cnt);
+            return true;
+        }
+
+    }
+    return false;
+}
+
+static bool reg_corruption_check(struct svm_test *test)
+{
+    return get_test_stage(test) == 1;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -1950,6 +2049,9 @@ struct svm_test svm_tests[] = {
     { "virq_inject", default_supported, virq_inject_prepare,
       default_prepare_gif_clear, virq_inject_test,
       virq_inject_finished, virq_inject_check },
+    { "reg_corruption", default_supported, reg_corruption_prepare,
+      default_prepare_gif_clear, reg_corruption_test,
+      reg_corruption_finished, reg_corruption_check },
     TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.25.4

