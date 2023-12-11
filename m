Return-Path: <kvm+bounces-4098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D82CE80D9BF
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E9EE281EE2
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A943B52F84;
	Mon, 11 Dec 2023 18:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gmWvikfE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94190B8
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:17 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5df5d595287so14717697b3.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702320977; x=1702925777; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KkpDC5cK3MCsLQsdfJOqTSEJVLLYusM8q6HHUh7HS2Y=;
        b=gmWvikfEsTOxIWuao5oxGI4Xm1XVWLx39e74YjRd6HsS8WKu44Hu4/LFsdIX3r8OV/
         +f9HMajODcilGd0b++k8MuiBMu+EkOOjHUqi2YNKWm509s56qp+OYwlfeVog6+fzgkH+
         viPtyu2raIgo9glccvOByTUh4KIftntxuBIPVAsgyq/byEBUms4b2J/4zUWk6m5dgJxQ
         cDoXwR7/uRGxuV9vVdu3iLO2nFKDVF1216zDSB22aqrlRo1IQ5KkbjMhOyc2IBzsG1UU
         ZL9CYfLPA5PAequW+6HfILK+XgWR9hZWcIK9IQVRuJ6wbHhND/aR5rU00vVT/KQaxcqS
         fdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702320977; x=1702925777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KkpDC5cK3MCsLQsdfJOqTSEJVLLYusM8q6HHUh7HS2Y=;
        b=WUx8mJ229NyH66jugwlPNVGyb9McFOEucK44KPYRAoYYbdqY2ZyurIjSavFp+hYXQe
         vroNO5YouF9CyILRjaEhqedc+VEmf9H5Gl632T/npYys+MABkGbaXoa6NxFXJB5IGchu
         qJbQCm05Cc3OPI5Xow+7rDb6kFT9rBFvfqqIpgWMjp8w4ryCzYzp2yGds4y/lxpsX+dk
         phv3TZFilz0ny+fVQE2nw5LO7yslSpZ5EoHxK+3vLrkt8QS9iUneqTzvYfVj8kwGYKn5
         o7H7CUyRLBTH1ReMBnhfmkdU7ixbsGVDhwTc9sX9p/ZKXZS5Yg3kYG9LkxCsfQMiNsE/
         Kn6g==
X-Gm-Message-State: AOJu0YxUAfG7n8CsTv56H/SnSPTiIVsDoF4kF+N1WF6PSC/sYKb0yk0o
	FYwExYlRSF83gaUJp9LNmV2W9L5N4rARgw==
X-Google-Smtp-Source: AGHT+IFXbQ965HW9sgG9wnyjhatwSKKxs44CcGMAEeE3lxoLQVxYgE0YBnkb+LA7v0SjhCGFaZkRzPmfrstH4Q==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:690c:2901:b0:5e1:90b4:dd9b with SMTP
 id eg1-20020a05690c290100b005e190b4dd9bmr10863ywb.2.1702320976879; Mon, 11
 Dec 2023 10:56:16 -0800 (PST)
Date: Mon, 11 Dec 2023 10:55:50 -0800
In-Reply-To: <20231211185552.3856862-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211185552.3856862-1-jmattson@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231211185552.3856862-4-jmattson@google.com>
Subject: [kvm-unit-tests PATCH 3/5] nVMX: test nested EOI virtualization
From: Jim Mattson <jmattson@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: "Marc Orr (Google)" <marc.orr@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: "Marc Orr (Google)" <marc.orr@gmail.com>

Add a test for nested VMs that invoke EOI virtualization. Specifically,
check that a pending low-priority interrupt, masked by a higher-priority
interrupt, is scheduled via "virtual-interrupt delivery," after the
higher-priority interrupt executes EOI.

Signed-off-by: Marc Orr (Google) <marc.orr@gmail.com>
Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/unittests.cfg |   2 +-
 x86/vmx_tests.c   | 161 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 136 insertions(+), 27 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index dd086d9e2bf4..f307168b0e01 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -361,7 +361,7 @@ timeout = 10
 
 [vmx_apicv_test]
 file = vmx.flat
-extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test"
+extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test vmx_eoi_virt_test"
 arch = x86_64
 groups = vmx
 timeout = 10
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0fb7e1466c50..ce480431bf58 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -60,6 +60,11 @@ static inline void vmcall(void)
 	asm volatile("vmcall");
 }
 
+static u32 *get_vapic_page(void)
+{
+	return (u32 *)phys_to_virt(vmcs_read(APIC_VIRT_ADDR));
+}
+
 static void basic_guest_main(void)
 {
 	report_pass("Basic VMX test");
@@ -10721,15 +10726,36 @@ enum Vid_op {
 struct vmx_basic_vid_test_guest_args {
 	enum Vid_op op;
 	u8 nr;
-	bool isr_fired;
+	u32 isr_exec_cnt;
 } vmx_basic_vid_test_guest_args;
 
+/*
+ * From the SDM, Bit x of the VIRR is
+ *     at bit position (x & 1FH)
+ *     at offset (200H | ((x & E0H) >> 1)).
+ */
+static void set_virr_bit(volatile u32 *virtual_apic_page, u8 nr)
+{
+	u32 page_offset = (0x200 | ((nr & 0xE0) >> 1)) / sizeof(u32);
+	u32 mask = 1 << (nr & 0x1f);
+
+	virtual_apic_page[page_offset] |= mask;
+}
+
+static bool get_virr_bit(volatile u32 *virtual_apic_page, u8 nr)
+{
+	u32 page_offset = (0x200 | ((nr & 0xE0) >> 1)) / sizeof(u32);
+	u32 mask = 1 << (nr & 0x1f);
+
+	return virtual_apic_page[page_offset] & mask;
+}
+
 static void vmx_vid_test_isr(isr_regs_t *regs)
 {
 	volatile struct vmx_basic_vid_test_guest_args *args =
 		&vmx_basic_vid_test_guest_args;
 
-	args->isr_fired = true;
+	args->isr_exec_cnt++;
 	barrier();
 	eoi();
 }
@@ -10761,6 +10787,27 @@ static void vmx_basic_vid_test_guest(void)
 	}
 }
 
+static void set_isrs_for_vmx_basic_vid_test(void)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+	u16 nr;
+
+	/*
+	 * kvm-unit-tests uses vector 32 for IPIs, so don't install a test ISR
+	 * for that vector.
+	 */
+	for (nr = 0x21; nr < 0x100; nr++) {
+		vmcs_write(GUEST_INT_STATUS, 0);
+		args->op = VID_OP_SET_ISR;
+		args->nr = nr;
+		args->isr_exec_cnt = 0;
+		enter_guest();
+		skip_exit_vmcall();
+	}
+	report(true, "Set ISR for vectors 33-255.");
+}
+
 /*
  * Test virtual interrupt delivery (VID) at VM-entry or TPR virtualization
  *
@@ -10770,13 +10817,12 @@ static void vmx_basic_vid_test_guest(void)
  *   tpr_virt: If true, then test VID during TPR virtualization. Otherwise,
  *       test VID during VM-entry.
  */
-static void test_basic_vid(u8 nr, u8 tpr, bool tpr_virt)
+static void test_basic_vid(u8 nr, u8 tpr, bool tpr_virt, u32 isr_exec_cnt_want,
+			   bool eoi_exit_induced)
 {
 	volatile struct vmx_basic_vid_test_guest_args *args =
 		&vmx_basic_vid_test_guest_args;
-	bool isr_fired_want =
-		task_priority_class(nr) > task_priority_class(tpr);
-	u16 rvi_want = isr_fired_want ? 0 : nr;
+	u16 rvi_want = isr_exec_cnt_want ? 0 : nr;
 	u16 int_status;
 
 	/*
@@ -10793,7 +10839,7 @@ static void test_basic_vid(u8 nr, u8 tpr, bool tpr_virt)
 	 * delivery, sets VPPR to VTPR, when SVI is 0.
 	 */
 	vmcs_write(GUEST_INT_STATUS, nr);
-	args->isr_fired = false;
+	args->isr_exec_cnt = 0;
 	if (tpr_virt) {
 		args->op = VID_OP_SET_CR8;
 		args->nr = task_priority_class(tpr);
@@ -10804,8 +10850,18 @@ static void test_basic_vid(u8 nr, u8 tpr, bool tpr_virt)
 	}
 
 	enter_guest();
+	if (eoi_exit_induced) {
+		u32 exit_cnt;
+
+		assert_exit_reason(VMX_EOI_INDUCED);
+		for (exit_cnt = 1; exit_cnt < isr_exec_cnt_want; exit_cnt++) {
+			enter_guest();
+			assert_exit_reason(VMX_EOI_INDUCED);
+		}
+		enter_guest();
+	}
 	skip_exit_vmcall();
-	TEST_ASSERT_EQ(args->isr_fired, isr_fired_want);
+	TEST_ASSERT_EQ(args->isr_exec_cnt, isr_exec_cnt_want);
 	int_status = vmcs_read(GUEST_INT_STATUS);
 	TEST_ASSERT_EQ(int_status, rvi_want);
 }
@@ -10821,7 +10877,6 @@ static void vmx_basic_vid_test(void)
 	volatile struct vmx_basic_vid_test_guest_args *args =
 		&vmx_basic_vid_test_guest_args;
 	u8 nr_class;
-	u16 nr;
 
 	if (!cpu_has_apicv()) {
 		report_skip("%s : Not all required APICv bits supported", __func__);
@@ -10830,23 +10885,10 @@ static void vmx_basic_vid_test(void)
 
 	enable_vid();
 	test_set_guest(vmx_basic_vid_test_guest);
-
-	/*
-	 * kvm-unit-tests uses vector 32 for IPIs, so don't install a test ISR
-	 * for that vector.
-	 */
-	for (nr = 0x21; nr < 0x100; nr++) {
-		vmcs_write(GUEST_INT_STATUS, 0);
-		args->op = VID_OP_SET_ISR;
-		args->nr = nr;
-		args->isr_fired = false;
-		enter_guest();
-		skip_exit_vmcall();
-		TEST_ASSERT(!args->isr_fired);
-	}
-	report(true, "Set ISR for vectors 33-255.");
+	set_isrs_for_vmx_basic_vid_test();
 
 	for (nr_class = 2; nr_class < 16; nr_class++) {
+		u16 nr;
 		u8 nr_sub_class;
 
 		for (nr_sub_class = 0; nr_sub_class < 16; nr_sub_class++) {
@@ -10862,8 +10904,16 @@ static void vmx_basic_vid_test(void)
 				continue;
 
 			for (tpr = 0; tpr < 256; tpr++) {
-				test_basic_vid(nr, tpr, /*tpr_virt=*/false);
-				test_basic_vid(nr, tpr, /*tpr_virt=*/true);
+				u32 isr_exec_cnt_want =
+					task_priority_class(nr) >
+					task_priority_class(tpr) ? 1 : 0;
+
+				test_basic_vid(nr, tpr, /*tpr_virt=*/false,
+					       isr_exec_cnt_want,
+					       /*eoi_exit_induced=*/false);
+				test_basic_vid(nr, tpr, /*tpr_virt=*/true,
+					       isr_exec_cnt_want,
+					       /*eoi_exit_induced=*/false);
 			}
 			report(true, "TPR 0-255 for vector 0x%x.", nr);
 		}
@@ -10875,6 +10925,64 @@ static void vmx_basic_vid_test(void)
 	assert_exit_reason(VMX_VMCALL);
 }
 
+static void test_eoi_virt(u8 nr, u8 lo_pri_nr, bool eoi_exit_induced)
+{
+	u32 *virtual_apic_page = get_vapic_page();
+
+	set_virr_bit(virtual_apic_page, lo_pri_nr);
+	test_basic_vid(nr, /*tpr=*/0, /*tpr_virt=*/false,
+		       /*isr_exec_cnt_want=*/2, eoi_exit_induced);
+	TEST_ASSERT(!get_virr_bit(virtual_apic_page, lo_pri_nr));
+	TEST_ASSERT(!get_virr_bit(virtual_apic_page, nr));
+}
+
+static void vmx_eoi_virt_test(void)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+	u16 nr;
+	u16 lo_pri_nr;
+
+	if (!cpu_has_apicv()) {
+		report_skip("%s : Not all required APICv bits supported", __func__);
+		return;
+	}
+
+	enable_vid();  /* Note, enable_vid sets APIC_VIRT_ADDR field in VMCS. */
+	test_set_guest(vmx_basic_vid_test_guest);
+	set_isrs_for_vmx_basic_vid_test();
+
+	/* Now test EOI virtualization without induced EOI exits. */
+	for (nr = 0x22; nr < 0x100; nr++) {
+		for (lo_pri_nr = 0x21; lo_pri_nr < nr; lo_pri_nr++)
+			test_eoi_virt(nr, lo_pri_nr,
+				      /*eoi_exit_induced=*/false);
+
+		report(true, "Low priority nrs 0x21-0x%x for nr 0x%x.",
+		       nr - 1, nr);
+	}
+
+	/* Finally, test EOI virtualization with induced EOI exits. */
+	vmcs_write(EOI_EXIT_BITMAP0, GENMASK_ULL(63, 0));
+	vmcs_write(EOI_EXIT_BITMAP1, GENMASK_ULL(63, 0));
+	vmcs_write(EOI_EXIT_BITMAP2, GENMASK_ULL(63, 0));
+	vmcs_write(EOI_EXIT_BITMAP3, GENMASK_ULL(63, 0));
+	for (nr = 0x22; nr < 0x100; nr++) {
+		for (lo_pri_nr = 0x21; lo_pri_nr < nr; lo_pri_nr++)
+			test_eoi_virt(nr, lo_pri_nr,
+				      /*eoi_exit_induced=*/true);
+
+		report(true,
+		       "Low priority nrs 0x21-0x%x for nr 0x%x, with induced EOI exits.",
+		       nr - 1, nr);
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
@@ -10930,6 +11038,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(apic_reg_virt_test),
 	TEST(virt_x2apic_mode_test),
 	TEST(vmx_basic_vid_test),
+	TEST(vmx_eoi_virt_test),
 	/* APIC pass-through tests */
 	TEST(vmx_apic_passthrough_test),
 	TEST(vmx_apic_passthrough_thread_test),
-- 
2.43.0.472.g3155946c3a-goog


