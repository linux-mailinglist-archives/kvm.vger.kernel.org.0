Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0CF60644C
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJTPYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiJTPYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318D81AA275
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dx2E7sPLESwonoFAMg5INqFxw5o9qcR71GQwym3CftU=;
        b=fyYjYuXdXyvv6pnnxdoLfqncsYsZyO8Xe8TyS10bvtVOroIMZ1XJgTUa23O+4XvTiEZM8x
        i/NvJQenv8Faq3aYZHbjM52NP/F0ESdWPBPziP2Y7rONgucbQtl0osw2ZQNUHQSKfTQ0VW
        GSTTXS5EcWyBxhByvFSwmUbH6cj5q8M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-vV3kBQqdNQyWNMFfDjmuYg-1; Thu, 20 Oct 2022 11:24:10 -0400
X-MC-Unique: vV3kBQqdNQyWNMFfDjmuYg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4D8A18E0A65
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 835782024CBE;
        Thu, 20 Oct 2022 15:24:08 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 01/16] x86: make irq_enable avoid the interrupt shadow
Date:   Thu, 20 Oct 2022 18:23:49 +0300
Message-Id: <20221020152404.283980-2-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tests that need interrupt shadow can't rely on irq_enable function anyway,
as its comment states,  and it is useful to know for sure that interrupts
are enabled after the call to this function.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/processor.h       | 9 ++++-----
 x86/apic.c                | 1 -
 x86/ioapic.c              | 1 -
 x86/svm_tests.c           | 9 ---------
 x86/tscdeadline_latency.c | 1 -
 x86/vmx_tests.c           | 7 -------
 6 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 03242206..9db07346 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -720,13 +720,12 @@ static inline void irq_disable(void)
 	asm volatile("cli");
 }
 
-/* Note that irq_enable() does not ensure an interrupt shadow due
- * to the vagaries of compiler optimizations.  If you need the
- * shadow, use a single asm with "sti" and the instruction after it.
- */
 static inline void irq_enable(void)
 {
-	asm volatile("sti");
+	asm volatile(
+			"sti \n\t"
+			"nop\n\t"
+	);
 }
 
 static inline void invlpg(volatile void *va)
diff --git a/x86/apic.c b/x86/apic.c
index 23508ad5..a8964d88 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -36,7 +36,6 @@ static void __test_tsc_deadline_timer(void)
     irq_enable();
 
     wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
-    asm volatile ("nop");
     report(tdt_count == 1, "tsc deadline timer");
     report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
 }
diff --git a/x86/ioapic.c b/x86/ioapic.c
index 4f578ce4..2e460a6d 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -129,7 +129,6 @@ static void test_ioapic_simultaneous(void)
 	toggle_irq_line(0x0f);
 	toggle_irq_line(0x0e);
 	irq_enable();
-	asm volatile ("nop");
 	report(g_66 && g_78 && g_66_after_78 && g_66_rip == g_78_rip,
 	       "ioapic simultaneous edge interrupts");
 }
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e2ec9541..a6397821 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1000,7 +1000,6 @@ static bool pending_event_finished(struct svm_test *test)
 		}
 
 		irq_enable();
-		asm volatile ("nop");
 		irq_disable();
 
 		if (!pending_event_ipi_fired) {
@@ -1056,7 +1055,6 @@ static void pending_event_cli_test(struct svm_test *test)
 
 	/* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
 	irq_enable();
-	asm volatile ("nop");
 	irq_disable();
 
 	if (pending_event_ipi_fired != true) {
@@ -1072,7 +1070,6 @@ static void pending_event_cli_test(struct svm_test *test)
 	 * that L0 did not leave a stale VINTR in the VMCB.
 	 */
 	irq_enable();
-	asm volatile ("nop");
 	irq_disable();
 }
 
@@ -1105,7 +1102,6 @@ static bool pending_event_cli_finished(struct svm_test *test)
 		}
 
 		irq_enable();
-		asm volatile ("nop");
 		irq_disable();
 
 		if (pending_event_ipi_fired != true) {
@@ -1243,7 +1239,6 @@ static bool interrupt_finished(struct svm_test *test)
 		}
 
 		irq_enable();
-		asm volatile ("nop");
 		irq_disable();
 
 		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
@@ -1540,7 +1535,6 @@ static void virq_inject_test(struct svm_test *test)
 	}
 
 	irq_enable();
-	asm volatile ("nop");
 	irq_disable();
 
 	if (!virq_fired) {
@@ -1557,7 +1551,6 @@ static void virq_inject_test(struct svm_test *test)
 	}
 
 	irq_enable();
-	asm volatile ("nop");
 	irq_disable();
 
 	if (!virq_fired) {
@@ -1568,7 +1561,6 @@ static void virq_inject_test(struct svm_test *test)
 	vmmcall();
 
 	irq_enable();
-	asm volatile ("nop");
 	irq_disable();
 
 	if (virq_fired) {
@@ -1739,7 +1731,6 @@ static bool reg_corruption_finished(struct svm_test *test)
 		void* guest_rip = (void*)vmcb->save.rip;
 
 		irq_enable();
-		asm volatile ("nop");
 		irq_disable();
 
 		if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index a3bc4ea4..c54530dd 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -73,7 +73,6 @@ static void start_tsc_deadline_timer(void)
     irq_enable();
 
     wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC)+delta);
-    asm volatile ("nop");
 }
 
 static int enable_tsc_deadline_timer(void)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index aa2ecbbc..c8e68931 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1625,7 +1625,6 @@ static void interrupt_main(void)
 	apic_write(APIC_TMICT, 1000000);
 
 	irq_enable();
-	asm volatile ("nop");
 	vmcall();
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1639,7 +1638,6 @@ static void interrupt_main(void)
 	apic_write(APIC_TMICT, 1000000);
 
 	irq_enable();
-	asm volatile ("nop");
 	vmcall();
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1709,7 +1707,6 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 			handle_external_interrupt(vector);
 		} else {
 			irq_enable();
-			asm volatile ("nop");
 			irq_disable();
 		}
 		if (vmx_get_test_stage() >= 2)
@@ -6792,7 +6789,6 @@ static void test_x2apic_wr(
 
 		/* Clear the external interrupt. */
 		irq_enable();
-		asm volatile ("nop");
 		irq_disable();
 		report(handle_x2apic_ipi_ran,
 		       "Got pending interrupt after IRQ enabled.");
@@ -8543,7 +8539,6 @@ static void vmx_pending_event_test_core(bool guest_hlt)
 	       "Guest did not run before host received IPI");
 
 	irq_enable();
-	asm volatile ("nop");
 	irq_disable();
 	report(vmx_pending_event_ipi_fired,
 	       "Got pending interrupt after IRQ enabled");
@@ -9526,8 +9521,6 @@ static void vmx_hlt_with_rvi_guest(void)
 	handle_irq(HLT_WITH_RVI_VECTOR, vmx_hlt_with_rvi_guest_isr);
 
 	irq_enable();
-	asm volatile ("nop");
-
 	vmcall();
 }
 
-- 
2.26.3

