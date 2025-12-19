Return-Path: <kvm+bounces-66418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C61CD2283
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE99C303E03A
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604632EBB98;
	Fri, 19 Dec 2025 22:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S9QW3I5+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD762DF13F
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185163; cv=none; b=T8IsKH8lBLXN7GL8YuXHpvNoc/RIGAPDiwchl1JyKujKjEEb4dY+nNwFwcHX8ypxqaE2Pt50AnNj9dS62eNkl8Y/YabBs1oGYG9QC8MLJMzQOXVDXYOYo+E//Wz9ZVqtp/bTGVzUr2wYQ9RoHlITmpHXdUHnNNVqHsbelYpi1UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185163; c=relaxed/simple;
	bh=Gquyz1BN7RBF96y+AE0j2dwa3pFRKQQzn9DoYtxFQ5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RP/MCr3FI/+KABHPLN4TGia+XAtzNl6YwUnapVhKeAmh/JO2ypN3O3mRSDjLY8AK7Uhxrj+aTqgFYWeUk8nU7zY7d1uSZB6PsebJTM+NasA/kP8HAaVlxNRg/RAJVfKzsUhoDDURsB5CKtW/obsTG5O25pIjLRXwpjYdDbEs6RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S9QW3I5+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b82c2c2ca2so3947178b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185160; x=1766789960; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hBtzkN+46Hi8Mrb4B9JxMA666NzljoiVzTRhh937Gcw=;
        b=S9QW3I5+7kLX2aH/pSdCAOcFgx+ugVfsiAgTolaYRcqXLxaTnccsKSYlaFxm7rS8GE
         Tho+SNQMyc149rDhzleY5sMHU/QHb9a9h0VIcehqhflxDt1AfyMXYg8nS9BOI2ofRc2W
         pd+/NziqRSLWDT0R8j764Gn/zXJXSD6ADgB60d75d95AxIkEOEuo1kOz7KosOgmh4ub4
         xC03MCIDtCL70vzPG1YREN2ja9luO5rqlN8Ht/g5kaIVEybiSEstIdu7Eqic9ttbWpu3
         UCVkTy98HHLBtPlJ/yiVpYDphJFqNLvNBzdzMPArGC2fNtYKk1I0W/1GewCw4PPV81cf
         5eHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185160; x=1766789960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hBtzkN+46Hi8Mrb4B9JxMA666NzljoiVzTRhh937Gcw=;
        b=f6uTJToz5tYjg5pzqjRyNm98QmE5sLKadZ1ket4NnEyTdez9WRG++GWa1OnrGz2L0t
         9imyqO2lQY2xLD7VnbtRi/F+sRMU78AadzYbpnWzhVfE257mYm46sNgfdaM2WqKw3C4D
         j8wMKV+sOGYztjZUI37OZQnVPaFHWFgrWq6bjvv0StoBWbbM8KwkttlM5zMpb0kBMpng
         5L5+tvFryMeo8i4Dpuxy4LAXgBMrDRxIEasZm3da27DRwXPhYG40ybL9NSJ+jot4jFBq
         +8iSVVSzEGD0WRbsCVi2cEEH6NehSj/HIPW6FOV6pP/o9Jj3Kl2kVBi3wcYUh9wLgCgH
         GNoA==
X-Gm-Message-State: AOJu0YybgEGcV1yHBK4l3ZdmgRaf6c/MM0LJ2aAl7+Nps5/Z9zP43A/l
	jw1tQIEKV0YkZxdZVte7ijh0Iirl4kVMFwR7K/As6DRbVGKbGsNeNQlHG1xqXDXXFBIp7o4QrjD
	W1/LB1t7z88BUH71bi/PIpvRR72av9xtO8ZnDbMM6mLqzifi+H0F5pVIjXWGbvnOYGhvNAp+yF9
	2oIlAgn6I79GP7IXEA5/1Hdmh2MXxk8vcOQUG2hoSSx5s=
X-Google-Smtp-Source: AGHT+IGmjED91eaP+RDVSiRTQyVEOYg8T2uhfnwoym71eqB3ZPT7Qp1QpIkHCftMptLuivafxn7tl2c4BBs4Vw==
X-Received: from pjbsd12.prod.google.com ([2002:a17:90b:514c:b0:339:ae3b:2bc7])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:12cb:b0:350:2251:59f with SMTP id adf61e73a8af0-376aa6eadb2mr4292717637.38.1766185159709;
 Fri, 19 Dec 2025 14:59:19 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:02 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-4-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 3/9] x86/svm: Add tests for APIC passthrough
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
2.52.0.322.g1dd061c0dc-goog


