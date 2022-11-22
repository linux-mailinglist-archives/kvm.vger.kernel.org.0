Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D438634123
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiKVQPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiKVQOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE4F78D68
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CEbcUAQV8Gn/dXkPfrNgqa/xPwEYTyRZVVcqOMT6FGg=;
        b=KNm1MXiFVUeLUMC1V93JCqu2qaS0XtShPx6p17UBBIrJQu95efSJcjPd3RmL5nKVXTxEVl
        pYFEl8V2TdXkAYhhV5opLWnGQxMahnABUoHlpp4yrlC7GB+/3fmfA44FUxMGOsxiWlRL+5
        TM5rJyb8hh4tKoRximK+1YGKCMWrjYs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-l-ziev3RP6ODcF22X6QuYA-1; Tue, 22 Nov 2022 11:12:01 -0500
X-MC-Unique: l-ziev3RP6ODcF22X6QuYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E88E29ABA24;
        Tue, 22 Nov 2022 16:12:00 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7286B1121314;
        Tue, 22 Nov 2022 16:11:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 02/27] x86: introduce sti_nop() and sti_nop_cli()
Date:   Tue, 22 Nov 2022 18:11:27 +0200
Message-Id: <20221122161152.293072-3-mlevitsk@redhat.com>
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add functions that shorten the common usage of sti

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/processor.h | 20 +++++++++++++++++++
 x86/apic.c          |  4 ++--
 x86/eventinj.c      | 12 +++---------
 x86/ioapic.c        |  3 +--
 x86/svm_tests.c     | 48 ++++++++++++---------------------------------
 x86/vmx_tests.c     | 23 +++++++---------------
 6 files changed, 46 insertions(+), 64 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b89f6a7c..29689d21 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -669,6 +669,26 @@ static inline void sti(void)
 	asm volatile ("sti");
 }
 
+
+/*
+ * Enable interrupts and ensure that interrupts are evaluated upon
+ * return from this function.
+ */
+static inline void sti_nop(void)
+{
+	asm volatile ("sti; nop");
+}
+
+
+/*
+ * Enable interrupts for one cpu cycle, allowing the CPU
+ * to process all interrupts that are already pending.
+ */
+static inline void sti_nop_cli(void)
+{
+	asm volatile ("sti; nop; cli");
+}
+
 static inline unsigned long long rdrand(void)
 {
 	long long r;
diff --git a/x86/apic.c b/x86/apic.c
index 66c1c58a..dd7e7834 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -313,7 +313,7 @@ static void test_self_ipi_x2apic(void)
 
 volatile int nmi_counter_private, nmi_counter, nmi_hlt_counter, sti_loop_active;
 
-static void sti_nop(char *p)
+static void test_sti_nop(char *p)
 {
 	asm volatile (
 		  ".globl post_sti \n\t"
@@ -335,7 +335,7 @@ static void sti_loop(void *ignore)
 	unsigned k = 0;
 
 	while (sti_loop_active)
-		sti_nop((char *)(ulong)((k++ * 4096) % (128 * 1024 * 1024)));
+		test_sti_nop((char *)(ulong)((k++ * 4096) % (128 * 1024 * 1024)));
 }
 
 static void nmi_handler(isr_regs_t *regs)
diff --git a/x86/eventinj.c b/x86/eventinj.c
index 147838ce..6fbb2d0f 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -294,9 +294,7 @@ int main(void)
 	apic_self_ipi(32);
 	apic_self_ipi(33);
 	io_delay();
-	sti();
-	asm volatile("nop");
-	cli();
+	sti_nop_cli();
 	printf("After vec 32 and 33 to self\n");
 	report(test_count == 2, "vec 32/33");
 
@@ -353,9 +351,7 @@ int main(void)
 	/* this is needed on VMX without NMI window notification.
 	   Interrupt windows is used instead, so let pending NMI
 	   to be injected */
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 	report(test_count == 2, "NMI");
 
 	/* generate NMI that will fault on IRET */
@@ -367,9 +363,7 @@ int main(void)
 	/* this is needed on VMX without NMI window notification.
 	   Interrupt windows is used instead, so let pending NMI
 	   to be injected */
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 	printf("After NMI to self\n");
 	report(test_count == 2, "NMI");
 	stack_phys = (ulong)virt_to_phys(alloc_page());
diff --git a/x86/ioapic.c b/x86/ioapic.c
index cce8add1..7d3e37cc 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -128,8 +128,7 @@ static void test_ioapic_simultaneous(void)
 	cli();
 	toggle_irq_line(0x0f);
 	toggle_irq_line(0x0e);
-	sti();
-	asm volatile ("nop");
+	sti_nop();
 	report(g_66 && g_78 && g_66_after_78 && g_66_rip == g_78_rip,
 	       "ioapic simultaneous edge interrupts");
 }
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 15e781af..02583236 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1000,9 +1000,7 @@ static bool pending_event_finished(struct svm_test *test)
 			return true;
 		}
 
-		sti();
-		asm volatile ("nop");
-		cli();
+		sti_nop_cli();
 
 		if (!pending_event_ipi_fired) {
 			report_fail("Pending interrupt not dispatched after IRQ enabled\n");
@@ -1056,9 +1054,7 @@ static void pending_event_cli_test(struct svm_test *test)
 	}
 
 	/* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 
 	if (pending_event_ipi_fired != true) {
 		set_test_stage(test, -1);
@@ -1072,9 +1068,7 @@ static void pending_event_cli_test(struct svm_test *test)
 	 * the VINTR interception should be clear in VMCB02.  Check
 	 * that L0 did not leave a stale VINTR in the VMCB.
 	 */
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 }
 
 static bool pending_event_cli_finished(struct svm_test *test)
@@ -1105,9 +1099,7 @@ static bool pending_event_cli_finished(struct svm_test *test)
 			return true;
 		}
 
-		sti();
-		asm volatile ("nop");
-		cli();
+		sti_nop_cli();
 
 		if (pending_event_ipi_fired != true) {
 			report_fail("Interrupt not triggered by host");
@@ -1243,9 +1235,7 @@ static bool interrupt_finished(struct svm_test *test)
 			return true;
 		}
 
-		sti();
-		asm volatile ("nop");
-		cli();
+		sti_nop_cli();
 
 		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
 		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
@@ -1540,9 +1530,7 @@ static void virq_inject_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 
 	if (!virq_fired) {
 		report_fail("virtual interrupt not fired after L2 sti");
@@ -1557,9 +1545,7 @@ static void virq_inject_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 
 	if (!virq_fired) {
 		report_fail("virtual interrupt not fired after return from VINTR intercept");
@@ -1568,9 +1554,7 @@ static void virq_inject_test(struct svm_test *test)
 
 	vmmcall();
 
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 
 	if (virq_fired) {
 		report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
@@ -1739,9 +1723,7 @@ static bool reg_corruption_finished(struct svm_test *test)
 
 		void* guest_rip = (void*)vmcb->save.rip;
 
-		sti();
-		asm volatile ("nop");
-		cli();
+		sti_nop_cli();
 
 		if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
 			report_fail("RIP corruption detected after %d timer interrupts",
@@ -3049,8 +3031,7 @@ static void svm_intr_intercept_mix_if_guest(struct svm_test *test)
 {
 	asm volatile("nop;nop;nop;nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
-	sti();
-	asm volatile("nop");
+	sti_nop();
 	report(0, "must not reach here");
 }
 
@@ -3080,8 +3061,7 @@ static void svm_intr_intercept_mix_gif_guest(struct svm_test *test)
 	// clear GIF and enable IF
 	// that should still not cause VM exit
 	clgi();
-	sti();
-	asm volatile("nop");
+	sti_nop();
 	report(!dummy_isr_recevied, "No interrupt expected");
 
 	stgi();
@@ -3142,8 +3122,7 @@ static void svm_intr_intercept_mix_nmi_guest(struct svm_test *test)
 	clgi();
 	asm volatile("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
-	sti(); // should have no effect
-	asm volatile("nop");
+	sti_nop(); // should have no effect
 	report(!nmi_recevied, "No NMI expected");
 
 	stgi();
@@ -3173,8 +3152,7 @@ static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
 	clgi();
 	asm volatile("nop");
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_SMI, 0);
-	sti(); // should have no effect
-	asm volatile("nop");
+	sti_nop(); // should have no effect
 	stgi();
 	asm volatile("nop");
 	report(0, "must not reach here");
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c556af28..a252529a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1625,8 +1625,7 @@ static void interrupt_main(void)
 	start = rdtsc();
 	apic_write(APIC_TMICT, 1000000);
 
-	sti();
-	asm volatile ("nop");
+	sti_nop();
 	vmcall();
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1639,8 +1638,7 @@ static void interrupt_main(void)
 	start = rdtsc();
 	apic_write(APIC_TMICT, 1000000);
 
-	sti();
-	asm volatile ("nop");
+	sti_nop();
 	vmcall();
 
 	report(rdtsc() - start > 10000 && timer_fired,
@@ -1709,9 +1707,7 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 			int vector = vmcs_read(EXI_INTR_INFO) & 0xff;
 			handle_external_interrupt(vector);
 		} else {
-			sti();
-			asm volatile ("nop");
-			cli();
+			sti_nop_cli();
 		}
 		if (vmx_get_test_stage() >= 2)
 			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
@@ -6716,9 +6712,7 @@ static void test_x2apic_wr(
 		assert_exit_reason(exit_reason_want);
 
 		/* Clear the external interrupt. */
-		sti();
-		asm volatile ("nop");
-		cli();
+		sti_nop_cli();
 		report(handle_x2apic_ipi_ran,
 		       "Got pending interrupt after IRQ enabled.");
 
@@ -8414,9 +8408,7 @@ static void vmx_pending_event_test_core(bool guest_hlt)
 	report(!vmx_pending_event_guest_run,
 	       "Guest did not run before host received IPI");
 
-	sti();
-	asm volatile ("nop");
-	cli();
+	sti_nop_cli();
 	report(vmx_pending_event_ipi_fired,
 	       "Got pending interrupt after IRQ enabled");
 
@@ -9397,7 +9389,7 @@ static void vmx_hlt_with_rvi_guest(void)
 {
 	handle_irq(HLT_WITH_RVI_VECTOR, vmx_hlt_with_rvi_guest_isr);
 
-	sti();
+	sti_nop();
 	asm volatile ("nop");
 
 	vmcall();
@@ -9557,8 +9549,7 @@ static void vmx_apic_passthrough_tpr_threshold_test(void)
 	/* Clean pending self-IPI */
 	vmx_apic_passthrough_tpr_threshold_ipi_isr_fired = false;
 	handle_irq(ipi_vector, vmx_apic_passthrough_tpr_threshold_ipi_isr);
-	sti();
-	asm volatile ("nop");
+	sti_nop();
 	report(vmx_apic_passthrough_tpr_threshold_ipi_isr_fired, "self-IPI fired");
 
 	report_pass(__func__);
-- 
2.34.3

