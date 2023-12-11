Return-Path: <kvm+bounces-4097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B86280D9BC
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE59C1C216C2
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2D4524B0;
	Mon, 11 Dec 2023 18:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bUDERcgI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E868CB4
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:15 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5de8c2081d1so39043687b3.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702320975; x=1702925775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PZg3wzXwIVpAxCjY72chHZv0/7M7qr4UWjEusdndgB8=;
        b=bUDERcgIJ2eNEUZ2ueKGuEUucKgF/R9ho3lXJoR/zIHUBMUnNeUPdloW5ADle/+mz2
         a5JliQV3AsSceuUUJTDw7FspfARe/ki3wl/t30anaVgoB7JbDz57nEpMiwBuTPXsaZSb
         8PrOs5byI8yVau3PCgFfGgr0s4JhnfUU4b4ZO0cjiDsp8SIjRK0IfoDQAhVzR9odMHTy
         nJ9uGgfkZo0UA/gZdJpQHb/zEYdHy2bntYMnl4rVhvORFiXA3nigNlL+fmtS7/yagGNZ
         1LsQ2Euc3FCqXt9F8gcNRfjcKxlVhRH1TIBO26W93+bbev9CUuKM+6kzzmvwxx3tVfxC
         4QIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702320975; x=1702925775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PZg3wzXwIVpAxCjY72chHZv0/7M7qr4UWjEusdndgB8=;
        b=OiBQAoILIorRSPwrroTzMsE4yVIdCsLD/OBwVhInXAFF7pTyzRUUnevGdCK+NZBnh/
         SrY+gCEBToILVK+yNzLY9EyEp+IxTZzlZkpHxCN7rOu1aKm8nB60CJomW1S3DZTrFdgX
         x6M0tMKMGfQaEvW90/bbb/X5QkJwxftmEwQ6ospQxjVtfb3jlBdnfFcWKvZXeGSNojGQ
         FHFrN4exo6Bcp7mAxP90sgJaILUt6bvolYsI8YobQOl3TpNt2H7WNdxr6si9igdpbKPR
         LFFIssT4ev8rumY5s11F9R04BI4iw/dH09SQ+BYGvfZaIbjpHvwvW47mkGrxJVyxry3s
         Y8cg==
X-Gm-Message-State: AOJu0Yzbd9QDbO9OZ0KDvDC1byp6fL3HKMB/evCBUKwd4buJvmieOPEn
	dja2VDGsQl8D82xC7yvsAE6Na8ss1wCFfw==
X-Google-Smtp-Source: AGHT+IHM9rv0HL4pX+KEeRFOJe7lfA0zcEgpGxQly75LUQ+hhZOkb4TNRnfPvYWYb/WMjMbaOd51d82Y2/Fd+w==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:690c:b8d:b0:5d4:2ff3:d280 with SMTP
 id ck13-20020a05690c0b8d00b005d42ff3d280mr46785ywb.7.1702320975167; Mon, 11
 Dec 2023 10:56:15 -0800 (PST)
Date: Mon, 11 Dec 2023 10:55:49 -0800
In-Reply-To: <20231211185552.3856862-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211185552.3856862-1-jmattson@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231211185552.3856862-3-jmattson@google.com>
Subject: [kvm-unit-tests PATCH 2/5] nVMX: test nested "virtual-interrupt delivery"
From: Jim Mattson <jmattson@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: "Marc Orr (Google)" <marc.orr@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: "Marc Orr (Google)" <marc.orr@gmail.com>

Add test coverage for recognizing and delivering virtual interrupts via
VMX's "virtual-interrupt delivery" feature, in the following two scenarios:

    1. There's a pending interrupt at VM-entry.
    2. There's a pending interrupt during TPR virtualization.

Signed-off-by: Marc Orr (Google) <marc.orr@gmail.com>
Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 lib/x86/apic.h    |   5 ++
 x86/unittests.cfg |   2 +-
 x86/vmx_tests.c   | 165 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+), 1 deletion(-)

diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index c389d40e169a..8df889b2d1e4 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -81,6 +81,11 @@ static inline bool apic_lvt_entry_supported(int idx)
 	return GET_APIC_MAXLVT(apic_read(APIC_LVR)) >= idx;
 }
 
+static inline u8 task_priority_class(u8 vector)
+{
+	return vector >> 4;
+}
+
 enum x2apic_reg_semantics {
 	X2APIC_INVALID	= 0,
 	X2APIC_READABLE	= BIT(0),
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3fe59449b650..dd086d9e2bf4 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -361,7 +361,7 @@ timeout = 10
 
 [vmx_apicv_test]
 file = vmx.flat
-extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test"
+extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test"
 arch = x86_64
 groups = vmx
 timeout = 10
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index e5ed79b7da4a..0fb7e1466c50 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10711,6 +10711,170 @@ static void vmx_exception_test(void)
 	test_set_guest_finished();
 }
 
+enum Vid_op {
+	VID_OP_SET_ISR,
+	VID_OP_NOP,
+	VID_OP_SET_CR8,
+	VID_OP_TERMINATE,
+};
+
+struct vmx_basic_vid_test_guest_args {
+	enum Vid_op op;
+	u8 nr;
+	bool isr_fired;
+} vmx_basic_vid_test_guest_args;
+
+static void vmx_vid_test_isr(isr_regs_t *regs)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+
+	args->isr_fired = true;
+	barrier();
+	eoi();
+}
+
+static void vmx_basic_vid_test_guest(void)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+
+	sti_nop();
+	for (;;) {
+		enum Vid_op op = args->op;
+		u8 nr = args->nr;
+
+		switch (op) {
+		case VID_OP_TERMINATE:
+			return;
+		case VID_OP_SET_ISR:
+			handle_irq(nr, vmx_vid_test_isr);
+			break;
+		case VID_OP_SET_CR8:
+			write_cr8(nr);
+			break;
+		default:
+			break;
+		}
+
+		vmcall();
+	}
+}
+
+/*
+ * Test virtual interrupt delivery (VID) at VM-entry or TPR virtualization
+ *
+ * Args:
+ *   nr: vector under test
+ *   tpr: task priority under test
+ *   tpr_virt: If true, then test VID during TPR virtualization. Otherwise,
+ *       test VID during VM-entry.
+ */
+static void test_basic_vid(u8 nr, u8 tpr, bool tpr_virt)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+	bool isr_fired_want =
+		task_priority_class(nr) > task_priority_class(tpr);
+	u16 rvi_want = isr_fired_want ? 0 : nr;
+	u16 int_status;
+
+	/*
+	 * From the SDM:
+	 *     IF "interrupt-window exiting" is 0 AND
+	 *     RVI[7:4] > VPPR[7:4] (see Section 29.1.1 for definition of VPPR)
+	 *             THEN recognize a pending virtual interrupt;
+	 *         ELSE
+	 *             do not recognize a pending virtual interrupt;
+	 *     FI;
+	 *
+	 * Thus, VPPR dictates whether a virtual interrupt is recognized.
+	 * However, PPR virtualization, which occurs before virtual interrupt
+	 * delivery, sets VPPR to VTPR, when SVI is 0.
+	 */
+	vmcs_write(GUEST_INT_STATUS, nr);
+	args->isr_fired = false;
+	if (tpr_virt) {
+		args->op = VID_OP_SET_CR8;
+		args->nr = task_priority_class(tpr);
+		set_vtpr(0xff);
+	} else {
+		args->op = VID_OP_NOP;
+		set_vtpr(tpr);
+	}
+
+	enter_guest();
+	skip_exit_vmcall();
+	TEST_ASSERT_EQ(args->isr_fired, isr_fired_want);
+	int_status = vmcs_read(GUEST_INT_STATUS);
+	TEST_ASSERT_EQ(int_status, rvi_want);
+}
+
+/*
+ * Test recognizing and delivering virtual interrupts via "Virtual-interrupt
+ * delivery" for two scenarios:
+ *   1. When there is a pending interrupt at VM-entry.
+ *   2. When there is a pending interrupt during TPR virtualization.
+ */
+static void vmx_basic_vid_test(void)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+	u8 nr_class;
+	u16 nr;
+
+	if (!cpu_has_apicv()) {
+		report_skip("%s : Not all required APICv bits supported", __func__);
+		return;
+	}
+
+	enable_vid();
+	test_set_guest(vmx_basic_vid_test_guest);
+
+	/*
+	 * kvm-unit-tests uses vector 32 for IPIs, so don't install a test ISR
+	 * for that vector.
+	 */
+	for (nr = 0x21; nr < 0x100; nr++) {
+		vmcs_write(GUEST_INT_STATUS, 0);
+		args->op = VID_OP_SET_ISR;
+		args->nr = nr;
+		args->isr_fired = false;
+		enter_guest();
+		skip_exit_vmcall();
+		TEST_ASSERT(!args->isr_fired);
+	}
+	report(true, "Set ISR for vectors 33-255.");
+
+	for (nr_class = 2; nr_class < 16; nr_class++) {
+		u8 nr_sub_class;
+
+		for (nr_sub_class = 0; nr_sub_class < 16; nr_sub_class++) {
+			u16 tpr;
+
+			nr = (nr_class << 4) | nr_sub_class;
+
+			/*
+			 * Don't test the reserved IPI vector, as the test ISR
+			 * was not installed.
+			 */
+			if (nr == 0x20)
+				continue;
+
+			for (tpr = 0; tpr < 256; tpr++) {
+				test_basic_vid(nr, tpr, /*tpr_virt=*/false);
+				test_basic_vid(nr, tpr, /*tpr_virt=*/true);
+			}
+			report(true, "TPR 0-255 for vector 0x%x.", nr);
+		}
+	}
+
+	/* Terminate the guest */
+	args->op = VID_OP_TERMINATE;
+	enter_guest();
+	assert_exit_reason(VMX_VMCALL);
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10765,6 +10929,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_hlt_with_rvi_test),
 	TEST(apic_reg_virt_test),
 	TEST(virt_x2apic_mode_test),
+	TEST(vmx_basic_vid_test),
 	/* APIC pass-through tests */
 	TEST(vmx_apic_passthrough_test),
 	TEST(vmx_apic_passthrough_thread_test),
-- 
2.43.0.472.g3155946c3a-goog


