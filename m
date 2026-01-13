Return-Path: <kvm+bounces-67885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91804D16059
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CC0CA301E12F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9DF280338;
	Tue, 13 Jan 2026 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JItfb1u5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E75261B8F
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264328; cv=none; b=tWUNFyafrsV6im/S8WfyiLOToLrG6hBrS5+zjA5lpXYR3UUUKf8t8UbrcyFjthDwLlCN77C9U0jXPCF2my+tjG12lv7EBY90aKpxcxjFyjJh63+ocvaxKlZ3d/NaVPBPA5UaUy8b0s5dXyDzDWpGSA8B0hk3RwBcnEy7hF4moZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264328; c=relaxed/simple;
	bh=zuSLgc0KClk1c0EA3ZiSsm1l3j6sFbS2Y2a3HU0cRz8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aEqtBpBJaDi+iKCDaR76GIfjWPxkNE1zHLkRCs/GkE5Noo8nKvRRuKPpVXa4qtkpvJ/viH2t7HlVnFPG6DcZlEAIX0tY1mLODFB0Bq1NbzK78dyRAyWoFFNbMfVC7nW4EEKnHHs0PNSW2GD6qPaNz/SxKRBXRVJE6Wf7yTD8aa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JItfb1u5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab8693a2cso13030940a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264321; x=1768869121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aSPbsX7TDYVJ2tGk5lUim0nw0f5y1n0130g92tQ1Z4Y=;
        b=JItfb1u50u+a6IdhCWWYfWH38PULCvwq8Eidt/qZY8dh05vQRBn0xlQL+oyR8+w1eg
         D7A0isngYb+DXM0GKBXDit9uT4bm9VepbKrQRigf8JmV6MzNSQ9ao4EADGabtpap0Cev
         0gNERIdSF1JI6meLXcCkaoDvJWPd9QaRZQtGe6RrbfLEx4PvEXzH3Xwk9sRTYvnye5iD
         CqTrsdfYk8oUUKhduedS1IJY0Pm8lcmoRWuzZohJqPezFYNH2CTDPg0lvTor6TbF1fe3
         2QD+3Y0OPKU1LxiIHe1wLhPyOE5F3mDA1MvswjmWoUXByw8oKkdibl6qbOb6EM17e1L4
         KHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264321; x=1768869121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSPbsX7TDYVJ2tGk5lUim0nw0f5y1n0130g92tQ1Z4Y=;
        b=puIVRLuM73mQGNmI8HmWSJADwgrzVlHUfXwlpEFxecVxxU2Rrvo7lVYHcRXNXWrn+l
         +y6bZ1SnerKKTdeffcQATx/bORhGw6LcHW1/3OFzHaJuwlCGUt7CK9gbVQu2Uxt//x1F
         hQGiLdKAZkxpXQIbvT3SvRT7DzmZLl4XyMHQONC8rfoAtZJPO2EldJh1Ps6rkPCvlTEQ
         i6hr7syrhuZtGB+THxxNfu0P3SEYDc/9xj8UszkW1/LSFU14qDrkAm+LQNmArL8XXtMF
         E7aw6oLBXknU6RJWNl7J4zpDqGPIddqsdadT5Bjot6fTL0lD9h5ddIIwjYFHup/N14ON
         xobQ==
X-Gm-Message-State: AOJu0Yy3f00u3eyARKbCCCxDTXofvFv3bnRcC2Szccc/yLxS27rK6XkE
	fkynvz5X+hgWXq+4BpSLSnKanFKzdX/ZsmsEAgVhoSr9UfS2HLI36dgEn6QvzyzEsKqb+cTMlOW
	e/AUa5NNDSbCTH+/s/axj3aJ/C4iBtOnUD5FZTBWKklblhiN3H9V1x14rLBOVpgoCVhWDl9tudL
	qZsuoFhSYLgWuAsVPvfyxWt3PbiIC5Gvvs7VvrJXQ+D24=
X-Google-Smtp-Source: AGHT+IEWbYTt1PpTCRGeighJsUy5erRQaMp9RscwXFZxO9DPYW2NOqzB+j/wLafDfZT960S6hMMzGJSuFFXSKA==
X-Received: from pjpy17.prod.google.com ([2002:a17:90a:a411:b0:343:7bc8:fb4e])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3891:b0:34c:f8e6:5ec1 with SMTP id 98e67ed59e1d1-34f68ceaddcmr18978857a91.35.1768264321404;
 Mon, 12 Jan 2026 16:32:01 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:45 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-4-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 03/10] x86/svm: Add tests for APIC passthrough
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Add two tests to SVM test suite to validate APIC passthrough
capabilities.

In the apic_passthrough test, the guest asserts irq-line to trigger a
level-triggered interrupt that should be injected directly in the guest.
Confirm that the remote_irr is set before the guest's EOI and cleared
after guest's EOI. Include a variant that uses a separate thread to
trigger the interrupt to ensure cross CPU delivery is handled correctly.

The svm_apic_passthrough_tpr_threshold_test validates that a guest can
directly modify the host's APIC TPR. The host queues a pending self-IPI
by disabling interrupts and raising the TPR to a high value. The test
then runs a guest that lowers the TPR to 0, and upon returning to the
host, it confirms that the pending interrupt is delivered once
interrupts are enabled.

The nVMX tests already has coverage for APIC passthrough. Add a similar
test for nSVM to improve test parity between nSVM and nVMX.

This test uses the old V1 test framework to utilize the test stage for
specific test event sequencing.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_tests.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 175 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 11d0e3d39f5ba..0eedad6bc3af5 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -12,6 +12,7 @@
 #include "util.h"
 #include "x86/usermode.h"
 #include "vmalloc.h"
+#include "fwcfg.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3575,6 +3576,172 @@ static void svm_shutdown_intercept_test(void)
 	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
 }
 
+
+static void set_irq_line_thread(void *data)
+{
+	/* Wait until other CPU entered L2 */
+	while (get_test_stage(data) != 1)
+		;
+
+	/* Set irq-line 0xf to raise vector 0x78 for vCPU 0 */
+	ioapic_set_redir(0xf, 0x78, TRIGGER_LEVEL);
+	set_test_stage(data, 2);
+}
+
+static void irq_78_handler_guest(isr_regs_t *regs)
+{
+	set_irq_line(0xf, 0);
+	vmmcall();
+	eoi();
+	vmmcall();
+}
+
+static void svm_apic_passthrough_guest(struct svm_test *test)
+{
+	handle_irq(0x78, irq_78_handler_guest);
+	sti();
+
+	/* If requested, wait for other CPU to trigger ioapic scan */
+	if (get_test_stage(test) < 1) {
+		set_test_stage(test, 1);
+		while (get_test_stage(test) != 2)
+			;
+	}
+
+	set_irq_line(0xf, 1);
+}
+
+static void svm_disable_intercept_for_x2apic_msrs(void)
+{
+	for (u32 msr = APIC_BASE_MSR; msr <= (APIC_BASE_MSR+0xff); ++msr) {
+		int bit_nr = get_msrpm_bit_nr(msr);
+
+		__clear_bit(bit_nr, msr_bitmap);
+		__clear_bit(bit_nr + 1, msr_bitmap);
+	}
+}
+
+static void svm_apic_passthrough_prepare(struct svm_test *test,
+					 bool set_irq_line_from_thread)
+{
+	if (set_irq_line_from_thread && (cpu_count() < 2)) {
+		report_skip("%s : CPU count < 2", __func__);
+		return;
+	}
+
+	/* Test device is required for generating IRQs */
+	if (!test_device_enabled()) {
+		report_skip("%s : No test device enabled", __func__);
+		return;
+	}
+
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
+	svm_disable_intercept_for_x2apic_msrs();
+
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
+
+	if (set_irq_line_from_thread) {
+		on_cpu_async(1, set_irq_line_thread, test);
+	} else {
+		ioapic_set_redir(0xf, 0x78, TRIGGER_LEVEL);
+		set_test_stage(test, 2);
+	}
+}
+
+static void svm_apic_passthrough_test_prepare(struct svm_test *test)
+{
+	svm_apic_passthrough_prepare(test, false);
+}
+
+static void svm_apic_passthrough_thread_test_prepare(struct svm_test *test)
+{
+	svm_apic_passthrough_prepare(test, true);
+}
+
+static bool svm_apic_passthrough_test_finished(struct svm_test *test)
+{
+	u32 exit_code = vmcb->control.exit_code;
+
+	report(exit_code == SVM_EXIT_VMMCALL, "Expected VMMCALL VM-Exit, got exit reason 0x%x",
+	       exit_code);
+
+	switch (get_test_stage(test)) {
+	case 2:
+		/* Jump over VMMCALL instruction */
+		vmcb->save.rip += 3;
+
+		/* Before EOI remote_irr should still be set */
+		report(1 == (int)ioapic_read_redir(0xf).remote_irr,
+			"IOAPIC pass-through: remote_irr=1 before EOI");
+		set_test_stage(test, 3);
+		return false;
+	case 3:
+		/* Jump over VMMCALL instruction */
+		vmcb->save.rip += 3;
+
+		/* After EOI remote_irr should be cleared */
+		report(0 == (int)ioapic_read_redir(0xf).remote_irr,
+			"IOAPIC pass-through: remote_irr=0 after EOI");
+		set_test_stage(test, 4);
+		return false;
+	case 4:
+		break;
+	default:
+		report_fail("Unexpected stage %d", get_test_stage(test));
+	}
+
+	return true;
+}
+
+static bool svm_apic_passthrough_test_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 4;
+}
+
+static void svm_apic_passthrough_tpr_threshold_guest(struct svm_test *test)
+{
+	cli();
+	apic_set_tpr(0);
+}
+
+static bool svm_apic_passthrough_tpr_threshold_ipi_isr_fired;
+static void svm_apic_passthrough_tpr_threshold_ipi_isr(isr_regs_t *regs)
+{
+	svm_apic_passthrough_tpr_threshold_ipi_isr_fired = true;
+	eoi();
+}
+
+static void svm_apic_passthrough_tpr_threshold_test(void)
+{
+	int ipi_vector = 0xe1;
+
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
+	svm_disable_intercept_for_x2apic_msrs();
+
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
+	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+
+	/* Raise L0 TPR-threshold by queueing vector in LAPIC IRR */
+	cli();
+	apic_set_tpr((ipi_vector >> 4) + 1);
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
+			APIC_DM_FIXED | ipi_vector,
+			0);
+
+	test_set_guest(svm_apic_passthrough_tpr_threshold_guest);
+	clgi();
+	svm_vmrun();
+	stgi();
+
+	report(apic_get_tpr() == 0, "TPR was zero by guest");
+
+	/* Clean pending self-IPI */
+	svm_apic_passthrough_tpr_threshold_ipi_isr_fired = false;
+	handle_irq(ipi_vector, svm_apic_passthrough_tpr_threshold_ipi_isr);
+	sti_nop();
+	report(svm_apic_passthrough_tpr_threshold_ipi_isr_fired, "self-IPI fired");
+}
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -3694,6 +3861,14 @@ struct svm_test svm_tests[] = {
 	{ "vgif", vgif_supported, prepare_vgif_enabled,
 	  default_prepare_gif_clear, test_vgif, vgif_finished,
 	  vgif_check },
+	{ "apic_passthrough", default_supported, svm_apic_passthrough_test_prepare,
+	  default_prepare_gif_clear, svm_apic_passthrough_guest,
+	  svm_apic_passthrough_test_finished, svm_apic_passthrough_test_check},
+	{ "apic_passthrough_thread", default_supported,
+	  svm_apic_passthrough_thread_test_prepare, default_prepare_gif_clear,
+	  svm_apic_passthrough_guest, svm_apic_passthrough_test_finished,
+	  svm_apic_passthrough_test_check},
+	TEST(svm_apic_passthrough_tpr_threshold_test),
 	TEST(svm_cr4_osxsave_test),
 	TEST(svm_guest_state_test),
 	TEST(svm_vmrun_errata_test),
-- 
2.52.0.457.g6b5491de43-goog


