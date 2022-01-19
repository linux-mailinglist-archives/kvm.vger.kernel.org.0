Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3E3493E8B
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356221AbiASQqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356220AbiASQqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 11:46:01 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14358C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:46:01 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i6-20020a626d06000000b004c0abfd53b3so1865709pfc.12
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aQ84rLzeWRy9pgNzzxqSbqP8vcIZNPbwGvo2TNGU7N0=;
        b=l2xqZZqCbiAKGdHrq8v/ofnRrlYdp5At5q08M3yA+IBfLFyog0KxyRsESVBLO7xQ1B
         SJd9q4VnnV33ErFmyw4cexnc3DPrY+ncEXBFidHwJivtYG4dyyRgdwvji3gnry3WfPPY
         BbuqP3mLRUvi5OSjDSdx69j6ygysbhGgRoNv7el8XRY+HtiYA5h5bsSC2198p5+saBQV
         saZCN+LB3/mTNcTVRMv/ee9hhjtEd8a5BVLW8opnanSWhJjt1JmtI0pIlpdID/pG2riP
         GU5m2iPk3WzM5pkMzTFBunZVKtmxctvVO90f5VmpGPoVdBNdCWf0lVEV/7+dN5D92r/2
         xiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aQ84rLzeWRy9pgNzzxqSbqP8vcIZNPbwGvo2TNGU7N0=;
        b=yNaV1K2Hvc/4JMZotTc3+5hxRU7nJh4j3N0yjEqw8ENYfGPWK1LMlkOF5w876rW0kJ
         4qAVUZJazRMsUJrS1XklNPDPnEtpt7crP3aIa04N7AaWNsfpcFeMCSY1XWQUh6iv+4qa
         N5WWcWcgKf6o9Z8Er6kp70cdUwMV+Qsudk/wWDFn6RsTJKbLFfXzAZWRIo+5jGd+aoiG
         aE0eoEAIVLbLSOuH8T3mnceBwkc6qB2K5GsAHdR0dVgIbOW4TkCS5Wzyysc6a6gfk9K+
         20WdVh8lPlqIU4TqjnBXMJDrgurXtZo0xzGvqwrQsX0m+DnT+a/J2YAos/Jfr1btGGzz
         a9gA==
X-Gm-Message-State: AOAM532ZwWXzqcV8yvxcLqkkqJlsApJCD7md9gtvbO0rDIn2Os0IPnnL
        N1ewU5dX5XwcOtiUqQCo61jST8HHx3VBBEhShONjWybtEzDP9Fv1qoeVTPgdwUIMOungx539AkJ
        SJ8aoj3VirHNt+5vSYAj2GLbryqQZFmh1Ymw1uSRoLG+gf1p/IAGKxih5xiU09fxZSo5e
X-Google-Smtp-Source: ABdhPJzdvrRV8vgGMGOmUrWbbiTeXddWfE57CAuIuSY32U2ho4OsdlWku9ifODmGcJ8BTSs08EPwxhXr7nvKe4lr
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a63:6e4e:: with SMTP id
 j75mr28039915pgc.293.1642610760394; Wed, 19 Jan 2022 08:46:00 -0800 (PST)
Date:   Wed, 19 Jan 2022 16:45:41 +0000
In-Reply-To: <20220119164541.3905055-1-aaronlewis@google.com>
Message-Id: <20220119164541.3905055-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220119164541.3905055-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH v3 3/3] x86: Add test coverage for
 nested_vmx_reflect_vmexit() testing
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a framework and test cases to ensure exceptions that occur in L2 are
forwarded to the correct place by nested_vmx_reflect_vmexit().

Add testing for exceptions: #GP, #UD, #DE, #DB, #BP, and #AC.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/unittests.cfg |   7 +++
 x86/vmx_tests.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9a70ba3..8399b05 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -390,6 +390,13 @@ arch = x86_64
 groups = vmx nested_exception
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 
+[vmx_exception_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append vmx_exception_test
+arch = x86_64
+groups = vmx nested_exception
+timeout = 10
+
 [debug]
 file = debug.flat
 arch = x86_64
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6..af6f33b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -21,6 +21,7 @@
 #include "smp.h"
 #include "delay.h"
 #include "access.h"
+#include "x86/usermode.h"
 
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
 
@@ -10701,6 +10702,133 @@ static void vmx_pf_vpid_test(void)
 	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
 }
 
+static void vmx_l2_gp_test(void)
+{
+	*(volatile u64 *)NONCANONICAL = 0;
+}
+
+static void vmx_l2_ud_test(void)
+{
+	asm volatile ("ud2");
+}
+
+static void vmx_l2_de_test(void)
+{
+	asm volatile (
+		"xor %%eax, %%eax\n\t"
+		"xor %%ebx, %%ebx\n\t"
+		"xor %%edx, %%edx\n\t"
+		"idiv %%ebx\n\t"
+		::: "eax", "ebx", "edx");
+}
+
+static void vmx_l2_bp_test(void)
+{
+	asm volatile ("int3");
+}
+
+static void vmx_l2_db_test(void)
+{
+	write_rflags(read_rflags() | X86_EFLAGS_TF);
+}
+
+static uint64_t usermode_callback(void)
+{
+	/* Trigger an #AC by writing 8 bytes to a 4-byte aligned address. */
+	asm volatile(
+		"sub $0x10, %rsp\n\t"
+		"movq $0, 0x4(%rsp)\n\t"
+		"add $0x10, %rsp\n\t");
+
+	return 0;
+}
+
+static void vmx_l2_ac_test(void)
+{
+	bool raised_vector = false;
+
+	write_cr0(read_cr0() | X86_CR0_AM);
+	write_rflags(read_rflags() | X86_EFLAGS_AC);
+
+	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &raised_vector);
+	report(raised_vector, "#AC vector raised from usermode in L2");
+	vmcall();
+}
+
+struct vmx_exception_test {
+	u8 vector;
+	void (*guest_code)(void);
+};
+
+struct vmx_exception_test vmx_exception_tests[] = {
+	{ GP_VECTOR, vmx_l2_gp_test },
+	{ UD_VECTOR, vmx_l2_ud_test },
+	{ DE_VECTOR, vmx_l2_de_test },
+	{ DB_VECTOR, vmx_l2_db_test },
+	{ BP_VECTOR, vmx_l2_bp_test },
+	{ AC_VECTOR, vmx_l2_ac_test },
+};
+
+static u8 vmx_exception_test_vector;
+
+static void vmx_exception_handler(struct ex_regs *regs)
+{
+	report(regs->vector == vmx_exception_test_vector,
+	       "Handling %s in L2's exception handler",
+	       exception_mnemonic(vmx_exception_test_vector));
+	vmcall();
+}
+
+static void handle_exception_in_l2(u8 vector)
+{
+	handler old_handler = handle_exception(vector, vmx_exception_handler);
+
+	vmx_exception_test_vector = vector;
+
+	enter_guest();
+	report(vmcs_read(EXI_REASON) == VMX_VMCALL,
+	       "%s handled by L2", exception_mnemonic(vector));
+
+	handle_exception(vector, old_handler);
+}
+
+static void handle_exception_in_l1(u32 vector)
+{
+	u32 old_eb = vmcs_read(EXC_BITMAP);
+
+	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));
+
+	enter_guest();
+
+	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
+	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
+	       "%s handled by L1", exception_mnemonic(vector));
+
+	vmcs_write(EXC_BITMAP, old_eb);
+}
+
+static void vmx_exception_test(void)
+{
+	struct vmx_exception_test *t;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vmx_exception_tests); i++) {
+		t = &vmx_exception_tests[i];
+
+		/*
+		 * Override the guest code before each run even though it's the
+		 * same code, the VMCS guest state needs to be reinitialized.
+		 */
+		test_override_guest(t->guest_code);
+		handle_exception_in_l2(t->vector);
+
+		test_override_guest(t->guest_code);
+		handle_exception_in_l1(t->vector);
+	}
+
+	test_set_guest_finished();
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10810,5 +10938,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_no_vpid_test),
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
+	TEST(vmx_exception_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.34.1.703.g22d0c6ccf7-goog

