Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CD2634122
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiKVQPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbiKVQO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C773A786FA
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mbcQdZ8HxEvxG4j+IYzz4OUCg6ff/xhPi1L4xTtIXQ=;
        b=IQvbPsMYguYCXJWCBvmL9RUnTpZzmx2zCOJRf2LEgcLuMlWBpFNyxoJyph3XW2K1XIQjgm
        Z/N/mLjtqdv8+IhtUPcvHWW2Feg/mNx4aPNwkBNBGgyab85awcaWhrLyEmEGWD4nG7Nmd/
        ik7ZQG3C+SIaJ5sj6xfx50jSLRTkhPU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-lQ9AwJTrNb-FU56Z8LrxaA-1; Tue, 22 Nov 2022 11:11:58 -0500
X-MC-Unique: lQ9AwJTrNb-FU56Z8LrxaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29792800B23;
        Tue, 22 Nov 2022 16:11:58 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 095C81121314;
        Tue, 22 Nov 2022 16:11:55 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 01/27] x86: replace irq_{enable|disable}() with sti()/cli()
Date:   Tue, 22 Nov 2022 18:11:26 +0200
Message-Id: <20221122161152.293072-2-mlevitsk@redhat.com>
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

This removes a layer of indirection which is strictly
speaking not needed since its x86 code anyway.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/processor.h       | 19 +++++-----------
 lib/x86/smp.c             |  2 +-
 x86/apic.c                |  2 +-
 x86/asyncpf.c             |  6 ++---
 x86/eventinj.c            | 22 +++++++++---------
 x86/hyperv_connections.c  |  2 +-
 x86/hyperv_stimer.c       |  4 ++--
 x86/hyperv_synic.c        |  6 ++---
 x86/intel-iommu.c         |  2 +-
 x86/ioapic.c              | 14 ++++++------
 x86/pmu.c                 |  4 ++--
 x86/svm.c                 |  4 ++--
 x86/svm_tests.c           | 48 +++++++++++++++++++--------------------
 x86/taskswitch2.c         |  4 ++--
 x86/tscdeadline_latency.c |  4 ++--
 x86/vmexit.c              | 18 +++++++--------
 x86/vmx_tests.c           | 42 +++++++++++++++++-----------------
 17 files changed, 98 insertions(+), 105 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 7a9e8c82..b89f6a7c 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -653,11 +653,17 @@ static inline void pause(void)
 	asm volatile ("pause");
 }
 
+/* Disable interrupts as per x86 spec */
 static inline void cli(void)
 {
 	asm volatile ("cli");
 }
 
+/*
+ * Enable interrupts.
+ * Note that next instruction after sti will not have interrupts
+ * evaluated due to concept of 'interrupt shadow'
+ */
 static inline void sti(void)
 {
 	asm volatile ("sti");
@@ -732,19 +738,6 @@ static inline void wrtsc(u64 tsc)
 	wrmsr(MSR_IA32_TSC, tsc);
 }
 
-static inline void irq_disable(void)
-{
-	asm volatile("cli");
-}
-
-/* Note that irq_enable() does not ensure an interrupt shadow due
- * to the vagaries of compiler optimizations.  If you need the
- * shadow, use a single asm with "sti" and the instruction after it.
- */
-static inline void irq_enable(void)
-{
-	asm volatile("sti");
-}
 
 static inline void invlpg(volatile void *va)
 {
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index b9b91c77..e297016c 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -84,7 +84,7 @@ static void setup_smp_id(void *data)
 
 void ap_online(void)
 {
-	irq_enable();
+	sti();
 
 	printf("setup: CPU %" PRId32 " online\n", apic_id());
 	atomic_inc(&cpu_online_count);
diff --git a/x86/apic.c b/x86/apic.c
index 20c3a1a4..66c1c58a 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -958,7 +958,7 @@ int main(void)
 	setup_vm();
 
 	mask_pic_interrupts();
-	irq_enable();
+	sti();
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		tests[i]();
diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index 9366c293..bc515be9 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -65,7 +65,7 @@ static void pf_isr(struct ex_regs *r)
 				    read_cr2(), virt, phys);
 			while(phys) {
 				safe_halt(); /* enables irq */
-				irq_disable();
+				cli();
 			}
 			break;
 		case KVM_PV_REASON_PAGE_READY:
@@ -97,7 +97,7 @@ int main(int ac, char **av)
 			KVM_ASYNC_PF_SEND_ALWAYS | KVM_ASYNC_PF_ENABLED);
 	printf("alloc memory\n");
 	buf = malloc(MEM);
-	irq_enable();
+	sti();
 	while(loop--) {
 		printf("start loop\n");
 		/* access a lot of memory to make host swap it out */
@@ -105,7 +105,7 @@ int main(int ac, char **av)
 			buf[i] = 1;
 		printf("end loop\n");
 	}
-	irq_disable();
+	cli();
 
 	return report_summary();
 }
diff --git a/x86/eventinj.c b/x86/eventinj.c
index 3031c040..147838ce 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -270,10 +270,10 @@ int main(void)
 	test_count = 0;
 	flush_idt_page();
 	printf("Sending vec 33 to self\n");
-	irq_enable();
+	sti();
 	apic_self_ipi(33);
 	io_delay();
-	irq_disable();
+	cli();
 	printf("After vec 33 to self\n");
 	report(test_count == 1, "vec 33");
 
@@ -294,9 +294,9 @@ int main(void)
 	apic_self_ipi(32);
 	apic_self_ipi(33);
 	io_delay();
-	irq_enable();
+	sti();
 	asm volatile("nop");
-	irq_disable();
+	cli();
 	printf("After vec 32 and 33 to self\n");
 	report(test_count == 2, "vec 32/33");
 
@@ -311,7 +311,7 @@ int main(void)
 	flush_stack();
 	io_delay();
 	asm volatile ("sti; int $33");
-	irq_disable();
+	cli();
 	printf("After vec 32 and int $33\n");
 	report(test_count == 2, "vec 32/int $33");
 
@@ -321,7 +321,7 @@ int main(void)
 	flush_idt_page();
 	printf("Sending vec 33 and 62 and mask one with TPR\n");
 	apic_write(APIC_TASKPRI, 0xf << 4);
-	irq_enable();
+	sti();
 	apic_self_ipi(32);
 	apic_self_ipi(62);
 	io_delay();
@@ -330,7 +330,7 @@ int main(void)
 	report(test_count == 1, "TPR");
 	apic_write(APIC_TASKPRI, 0x0);
 	while(test_count != 2); /* wait for second irq */
-	irq_disable();
+	cli();
 
 	/* test fault durint NP delivery */
 	printf("Before NP test\n");
@@ -353,9 +353,9 @@ int main(void)
 	/* this is needed on VMX without NMI window notification.
 	   Interrupt windows is used instead, so let pending NMI
 	   to be injected */
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 	report(test_count == 2, "NMI");
 
 	/* generate NMI that will fault on IRET */
@@ -367,9 +367,9 @@ int main(void)
 	/* this is needed on VMX without NMI window notification.
 	   Interrupt windows is used instead, so let pending NMI
 	   to be injected */
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 	printf("After NMI to self\n");
 	report(test_count == 2, "NMI");
 	stack_phys = (ulong)virt_to_phys(alloc_page());
diff --git a/x86/hyperv_connections.c b/x86/hyperv_connections.c
index 6e8ac32f..cf043664 100644
--- a/x86/hyperv_connections.c
+++ b/x86/hyperv_connections.c
@@ -94,7 +94,7 @@ static void setup_cpu(void *ctx)
 	struct hv_vcpu *hv;
 
 	write_cr3((ulong)ctx);
-	irq_enable();
+	sti();
 
 	vcpu = smp_id();
 	hv = &hv_vcpus[vcpu];
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 7b7c985c..f7c67916 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -307,7 +307,7 @@ static void stimer_test(void *ctx)
     struct svcpu *svcpu = &g_synic_vcpu[vcpu];
     struct stimer *timer1, *timer2;
 
-    irq_enable();
+    sti();
 
     timer1 = &svcpu->timer[0];
     timer2 = &svcpu->timer[1];
@@ -318,7 +318,7 @@ static void stimer_test(void *ctx)
     stimer_test_auto_enable_periodic(vcpu, timer1);
     stimer_test_one_shot_busy(vcpu, timer1);
 
-    irq_disable();
+    cli();
 }
 
 static void stimer_test_cleanup(void *ctx)
diff --git a/x86/hyperv_synic.c b/x86/hyperv_synic.c
index 5ca593c0..9d61d836 100644
--- a/x86/hyperv_synic.c
+++ b/x86/hyperv_synic.c
@@ -79,7 +79,7 @@ static void synic_test_prepare(void *ctx)
     int i = 0;
 
     write_cr3((ulong)ctx);
-    irq_enable();
+    sti();
 
     rdmsr(HV_X64_MSR_SVERSION);
     rdmsr(HV_X64_MSR_SIMP);
@@ -121,7 +121,7 @@ static void synic_test(void *ctx)
 {
     int dst_vcpu = (ulong)ctx;
 
-    irq_enable();
+    sti();
     synic_sints_test(dst_vcpu);
 }
 
@@ -129,7 +129,7 @@ static void synic_test_cleanup(void *ctx)
 {
     int i;
 
-    irq_enable();
+    sti();
     for (i = 0; i < HV_SYNIC_SINT_COUNT; i++) {
         synic_sint_destroy(i);
     }
diff --git a/x86/intel-iommu.c b/x86/intel-iommu.c
index 4442fe1f..687a43ce 100644
--- a/x86/intel-iommu.c
+++ b/x86/intel-iommu.c
@@ -82,7 +82,7 @@ static void vtd_test_ir(void)
 
 	report_prefix_push("vtd_ir");
 
-	irq_enable();
+	sti();
 
 	/* This will enable INTx */
 	pci_msi_set_enable(pci_dev, false);
diff --git a/x86/ioapic.c b/x86/ioapic.c
index 4f578ce4..cce8add1 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -125,10 +125,10 @@ static void test_ioapic_simultaneous(void)
 	handle_irq(0x66, ioapic_isr_66);
 	ioapic_set_redir(0x0e, 0x78, TRIGGER_EDGE);
 	ioapic_set_redir(0x0f, 0x66, TRIGGER_EDGE);
-	irq_disable();
+	cli();
 	toggle_irq_line(0x0f);
 	toggle_irq_line(0x0e);
-	irq_enable();
+	sti();
 	asm volatile ("nop");
 	report(g_66 && g_78 && g_66_after_78 && g_66_rip == g_78_rip,
 	       "ioapic simultaneous edge interrupts");
@@ -173,10 +173,10 @@ static void test_ioapic_level_tmr(bool expected_tmr_before)
 
 static void toggle_irq_line_0x0e(void *data)
 {
-	irq_disable();
+	cli();
 	delay(IPI_DELAY);
 	toggle_irq_line(0x0e);
-	irq_enable();
+	sti();
 }
 
 static void test_ioapic_edge_tmr_smp(bool expected_tmr_before)
@@ -199,10 +199,10 @@ static void test_ioapic_edge_tmr_smp(bool expected_tmr_before)
 
 static void set_irq_line_0x0e(void *data)
 {
-	irq_disable();
+	cli();
 	delay(IPI_DELAY);
 	set_irq_line(0x0e, 1);
-	irq_enable();
+	sti();
 }
 
 static void test_ioapic_level_tmr_smp(bool expected_tmr_before)
@@ -485,7 +485,7 @@ int main(void)
 	else
 		printf("x2apic not detected\n");
 
-	irq_enable();
+	sti();
 
 	ioapic_reg_version();
 	ioapic_reg_id();
diff --git a/x86/pmu.c b/x86/pmu.c
index 72c2c9cf..328e3c68 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -75,10 +75,10 @@ static bool check_irq(void)
 {
 	int i;
 	irq_received = 0;
-	irq_enable();
+	sti();
 	for (i = 0; i < 100000 && !irq_received; i++)
 		asm volatile("pause");
-	irq_disable();
+	cli();
 	return irq_received;
 }
 
diff --git a/x86/svm.c b/x86/svm.c
index ba435b4a..0b2a1d69 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -240,7 +240,7 @@ static noinline void test_run(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
 
-	irq_disable();
+	cli();
 	vmcb_ident(vmcb);
 
 	test->prepare(test);
@@ -273,7 +273,7 @@ static noinline void test_run(struct svm_test *test)
 				"memory");
 		++test->exits;
 	} while (!test->finished(test));
-	irq_enable();
+	sti();
 
 	report(test->succeeded(test), "%s", test->name);
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 27ce47b4..15e781af 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1000,9 +1000,9 @@ static bool pending_event_finished(struct svm_test *test)
 			return true;
 		}
 
-		irq_enable();
+		sti();
 		asm volatile ("nop");
-		irq_disable();
+		cli();
 
 		if (!pending_event_ipi_fired) {
 			report_fail("Pending interrupt not dispatched after IRQ enabled\n");
@@ -1056,9 +1056,9 @@ static void pending_event_cli_test(struct svm_test *test)
 	}
 
 	/* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 
 	if (pending_event_ipi_fired != true) {
 		set_test_stage(test, -1);
@@ -1072,9 +1072,9 @@ static void pending_event_cli_test(struct svm_test *test)
 	 * the VINTR interception should be clear in VMCB02.  Check
 	 * that L0 did not leave a stale VINTR in the VMCB.
 	 */
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 }
 
 static bool pending_event_cli_finished(struct svm_test *test)
@@ -1105,9 +1105,9 @@ static bool pending_event_cli_finished(struct svm_test *test)
 			return true;
 		}
 
-		irq_enable();
+		sti();
 		asm volatile ("nop");
-		irq_disable();
+		cli();
 
 		if (pending_event_ipi_fired != true) {
 			report_fail("Interrupt not triggered by host");
@@ -1153,7 +1153,7 @@ static void interrupt_test(struct svm_test *test)
 	long long start, loops;
 
 	apic_write(APIC_LVTT, TIMER_VECTOR);
-	irq_enable();
+	sti();
 	apic_write(APIC_TMICT, 1); //Timer Initial Count Register 0x380 one-shot
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
@@ -1166,7 +1166,7 @@ static void interrupt_test(struct svm_test *test)
 	}
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmmcall();
 
 	timer_fired = false;
@@ -1181,9 +1181,9 @@ static void interrupt_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	irq_enable();
+	sti();
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 
 	timer_fired = false;
 	start = rdtsc();
@@ -1199,7 +1199,7 @@ static void interrupt_test(struct svm_test *test)
 	}
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmmcall();
 
 	timer_fired = false;
@@ -1216,7 +1216,7 @@ static void interrupt_test(struct svm_test *test)
 	}
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 }
 
 static bool interrupt_finished(struct svm_test *test)
@@ -1243,9 +1243,9 @@ static bool interrupt_finished(struct svm_test *test)
 			return true;
 		}
 
-		irq_enable();
+		sti();
 		asm volatile ("nop");
-		irq_disable();
+		cli();
 
 		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
 		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
@@ -1540,9 +1540,9 @@ static void virq_inject_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 
 	if (!virq_fired) {
 		report_fail("virtual interrupt not fired after L2 sti");
@@ -1557,9 +1557,9 @@ static void virq_inject_test(struct svm_test *test)
 		vmmcall();
 	}
 
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 
 	if (!virq_fired) {
 		report_fail("virtual interrupt not fired after return from VINTR intercept");
@@ -1568,9 +1568,9 @@ static void virq_inject_test(struct svm_test *test)
 
 	vmmcall();
 
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 
 	if (virq_fired) {
 		report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
@@ -1739,9 +1739,9 @@ static bool reg_corruption_finished(struct svm_test *test)
 
 		void* guest_rip = (void*)vmcb->save.rip;
 
-		irq_enable();
+		sti();
 		asm volatile ("nop");
-		irq_disable();
+		cli();
 
 		if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
 			report_fail("RIP corruption detected after %d timer interrupts",
diff --git a/x86/taskswitch2.c b/x86/taskswitch2.c
index db69f078..2a3b210d 100644
--- a/x86/taskswitch2.c
+++ b/x86/taskswitch2.c
@@ -139,10 +139,10 @@ static void test_kernel_mode_int(void)
 	test_count = 0;
 	printf("Trigger IRQ from APIC\n");
 	set_intr_task_gate(0xf0, irq_tss);
-	irq_enable();
+	sti();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT | 0xf0, 0);
 	io_delay();
-	irq_disable();
+	cli();
 	printf("Return from APIC IRQ\n");
 	report(test_count == 1, "IRQ external");
 
diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index a3bc4ea4..6bf56225 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -70,7 +70,7 @@ static void tsc_deadline_timer_isr(isr_regs_t *regs)
 static void start_tsc_deadline_timer(void)
 {
     handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
-    irq_enable();
+    sti();
 
     wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC)+delta);
     asm volatile ("nop");
@@ -115,7 +115,7 @@ int main(int argc, char **argv)
     breakmax = argc <= 3 ? 0 : atol(argv[3]);
     printf("breakmax=%d\n", breakmax);
     test_tsc_deadline_timer();
-    irq_enable();
+    sti();
 
     /* The condition might have triggered already, so check before HLT. */
     while (!hitmax && table_idx < size)
diff --git a/x86/vmexit.c b/x86/vmexit.c
index b1eed8d1..884ac63a 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -93,7 +93,7 @@ static void apic_self_ipi(int vec)
 static void self_ipi_sti_nop(void)
 {
 	x = 0;
-	irq_disable();
+	cli();
 	apic_self_ipi(IPI_TEST_VECTOR);
 	asm volatile("sti; nop");
 	if (x != 1) printf("%d", x);
@@ -102,7 +102,7 @@ static void self_ipi_sti_nop(void)
 static void self_ipi_sti_hlt(void)
 {
 	x = 0;
-	irq_disable();
+	cli();
 	apic_self_ipi(IPI_TEST_VECTOR);
 	safe_halt();
 	if (x != 1) printf("%d", x);
@@ -121,7 +121,7 @@ static void self_ipi_tpr(void)
 static void self_ipi_tpr_sti_nop(void)
 {
 	x = 0;
-	irq_disable();
+	cli();
 	apic_set_tpr(0x0f);
 	apic_self_ipi(IPI_TEST_VECTOR);
 	apic_set_tpr(0x00);
@@ -132,7 +132,7 @@ static void self_ipi_tpr_sti_nop(void)
 static void self_ipi_tpr_sti_hlt(void)
 {
 	x = 0;
-	irq_disable();
+	cli();
 	apic_set_tpr(0x0f);
 	apic_self_ipi(IPI_TEST_VECTOR);
 	apic_set_tpr(0x00);
@@ -147,14 +147,14 @@ static int is_x2apic(void)
 
 static void x2apic_self_ipi_sti_nop(void)
 {
-	irq_disable();
+	cli();
 	x2apic_self_ipi(IPI_TEST_VECTOR);
 	asm volatile("sti; nop");
 }
 
 static void x2apic_self_ipi_sti_hlt(void)
 {
-	irq_disable();
+	cli();
 	x2apic_self_ipi(IPI_TEST_VECTOR);
 	safe_halt();
 }
@@ -169,7 +169,7 @@ static void x2apic_self_ipi_tpr(void)
 
 static void x2apic_self_ipi_tpr_sti_nop(void)
 {
-	irq_disable();
+	cli();
 	apic_set_tpr(0x0f);
 	x2apic_self_ipi(IPI_TEST_VECTOR);
 	apic_set_tpr(0x00);
@@ -178,7 +178,7 @@ static void x2apic_self_ipi_tpr_sti_nop(void)
 
 static void x2apic_self_ipi_tpr_sti_hlt(void)
 {
-	irq_disable();
+	cli();
 	apic_set_tpr(0x0f);
 	x2apic_self_ipi(IPI_TEST_VECTOR);
 	apic_set_tpr(0x00);
@@ -605,7 +605,7 @@ int main(int ac, char **av)
 	handle_irq(IPI_TEST_VECTOR, self_ipi_isr);
 	nr_cpus = cpu_count();
 
-	irq_enable();
+	sti();
 	on_cpus(enable_nx, NULL);
 
 	ret = pci_find_dev(PCI_VENDOR_ID_REDHAT, PCI_DEVICE_ID_REDHAT_TEST);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7bba8165..c556af28 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1577,7 +1577,7 @@ static void interrupt_main(void)
 	vmx_set_test_stage(0);
 
 	apic_write(APIC_LVTT, TIMER_VECTOR);
-	irq_enable();
+	sti();
 
 	apic_write(APIC_TMICT, 1);
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
@@ -1585,7 +1585,7 @@ static void interrupt_main(void)
 	report(timer_fired, "direct interrupt while running guest");
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmcall();
 	timer_fired = false;
 	apic_write(APIC_TMICT, 1);
@@ -1593,9 +1593,9 @@ static void interrupt_main(void)
 		asm volatile ("nop");
 	report(timer_fired, "intercepted interrupt while running guest");
 
-	irq_enable();
+	sti();
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmcall();
 	timer_fired = false;
 	start = rdtsc();
@@ -1607,7 +1607,7 @@ static void interrupt_main(void)
 	       "direct interrupt + hlt");
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmcall();
 	timer_fired = false;
 	start = rdtsc();
@@ -1619,13 +1619,13 @@ static void interrupt_main(void)
 	       "intercepted interrupt + hlt");
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmcall();
 	timer_fired = false;
 	start = rdtsc();
 	apic_write(APIC_TMICT, 1000000);
 
-	irq_enable();
+	sti();
 	asm volatile ("nop");
 	vmcall();
 
@@ -1633,13 +1633,13 @@ static void interrupt_main(void)
 	       "direct interrupt + activity state hlt");
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmcall();
 	timer_fired = false;
 	start = rdtsc();
 	apic_write(APIC_TMICT, 1000000);
 
-	irq_enable();
+	sti();
 	asm volatile ("nop");
 	vmcall();
 
@@ -1647,7 +1647,7 @@ static void interrupt_main(void)
 	       "intercepted interrupt + activity state hlt");
 
 	apic_write(APIC_TMICT, 0);
-	irq_disable();
+	cli();
 	vmx_set_test_stage(7);
 	vmcall();
 	timer_fired = false;
@@ -1658,7 +1658,7 @@ static void interrupt_main(void)
 	       "running a guest with interrupt acknowledgement set");
 
 	apic_write(APIC_TMICT, 0);
-	irq_enable();
+	sti();
 	timer_fired = false;
 	vmcall();
 	report(timer_fired, "Inject an event to a halted guest");
@@ -1709,9 +1709,9 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 			int vector = vmcs_read(EXI_INTR_INFO) & 0xff;
 			handle_external_interrupt(vector);
 		} else {
-			irq_enable();
+			sti();
 			asm volatile ("nop");
-			irq_disable();
+			cli();
 		}
 		if (vmx_get_test_stage() >= 2)
 			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
@@ -6716,9 +6716,9 @@ static void test_x2apic_wr(
 		assert_exit_reason(exit_reason_want);
 
 		/* Clear the external interrupt. */
-		irq_enable();
+		sti();
 		asm volatile ("nop");
-		irq_disable();
+		cli();
 		report(handle_x2apic_ipi_ran,
 		       "Got pending interrupt after IRQ enabled.");
 
@@ -8403,7 +8403,7 @@ static void vmx_pending_event_test_core(bool guest_hlt)
 	if (guest_hlt)
 		vmcs_write(GUEST_ACTV_STATE, ACTV_HLT);
 
-	irq_disable();
+	cli();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
 				   APIC_DM_FIXED | ipi_vector,
 				   0);
@@ -8414,9 +8414,9 @@ static void vmx_pending_event_test_core(bool guest_hlt)
 	report(!vmx_pending_event_guest_run,
 	       "Guest did not run before host received IPI");
 
-	irq_enable();
+	sti();
 	asm volatile ("nop");
-	irq_disable();
+	cli();
 	report(vmx_pending_event_ipi_fired,
 	       "Got pending interrupt after IRQ enabled");
 
@@ -9340,7 +9340,7 @@ static void irq_79_handler_guest(isr_regs_t *regs)
 static void vmx_eoi_bitmap_ioapic_scan_test_guest(void)
 {
 	handle_irq(0x79, irq_79_handler_guest);
-	irq_enable();
+	sti();
 
 	/* Signal to L1 CPU to trigger ioapic scan */
 	vmx_set_test_stage(1);
@@ -9397,7 +9397,7 @@ static void vmx_hlt_with_rvi_guest(void)
 {
 	handle_irq(HLT_WITH_RVI_VECTOR, vmx_hlt_with_rvi_guest_isr);
 
-	irq_enable();
+	sti();
 	asm volatile ("nop");
 
 	vmcall();
@@ -9449,7 +9449,7 @@ static void irq_78_handler_guest(isr_regs_t *regs)
 static void vmx_apic_passthrough_guest(void)
 {
 	handle_irq(0x78, irq_78_handler_guest);
-	irq_enable();
+	sti();
 
 	/* If requested, wait for other CPU to trigger ioapic scan */
 	if (vmx_get_test_stage() < 1) {
-- 
2.34.3

