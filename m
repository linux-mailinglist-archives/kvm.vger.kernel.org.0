Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9DC139C35
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 23:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAMWLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 17:11:03 -0500
Received: from mail-qv1-f73.google.com ([209.85.219.73]:57055 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgAMWLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 17:11:03 -0500
Received: by mail-qv1-f73.google.com with SMTP id a14so7344197qvy.23
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 14:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tIDWZSQZq4Ja8lWBVps0YxaVqw+QXFvw/jnBfVCtMmQ=;
        b=rlqd4qDh/pKTZICksZYt+82Ov6dcy8mAI83MtFhOc1Gu/srdwvGkZgVGI7hJw+AxCC
         Khm0tukzbkg88KZoypqPUECVeJIRSFz4853Rb6pCLxp2TnUDyaukrfbP1eLO63CuZqIu
         FQbsdJxxOZK/G6gGqgbjBLTKwUqi4R6uxKav7DtN/2iI0XETpXIEHnFFG6AJY4gMplxl
         ind8EUR1l7JKRbC+k2XIoJlHZq3SDAj7OlgM8hsN19uPaHHkTHvpwa/w/cf+aKeRLHpF
         7aSuU1kPwuy2fcX3ZQPHQ8BZSMfB9jNjFUCgO+gjBpPrEtoa7ON8GYg6JvlQIsvq5VaN
         f0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tIDWZSQZq4Ja8lWBVps0YxaVqw+QXFvw/jnBfVCtMmQ=;
        b=CgbJI9TQcDDwU23qoJbX0i1xY8bX331O3KP6jE+40JdY3HP6jD94zQmkilAJvY4cIY
         lR1CG+wiRRQj9b5BnSfoQvvRyJWybQ/4BZJItBXJseuq+gXid6q2zBVR4FfJqACgaYRA
         7JO+H4CkC26qXUJXifq3DgC4bT/K6tB4A+f/eYN9I49UHZr0IBVJ8bGNIEGdottnoeTe
         6BwX8sHOPT6L77aPXJfnfNyaEX/4e6bk+YQZYMeZq6hlkAAOuzQcm/N13wedBDRSEVQe
         YB7JAigN75+IcNucx16INFdaDAbEFA5kt9s7h3ginV/n0iN6I/aLIVZUPYBJ3UQd6obV
         R7PQ==
X-Gm-Message-State: APjAAAWc7PO3V/HOSFjNF7qw5slce1xxDoVgTJqYmcS+WWRjenw3wpk4
        Fm6qajgVNX8OXbNrF9UHvdGVv1dWcDewVynWM61+SBQVvMuB/kJS+wTnuiaS2NenPJqIaMp8/K1
        oT8RS/8taFxLdsI1nBoY0TN3VwqVVfbpBu5T55y8le/EY3/ErfFHFGJlETg==
X-Google-Smtp-Source: APXvYqwEXFDd0pOxLPZgEYTXZs4O/sOuCBb0xbEwzfAX5+m0uY517NZx9SM7gJUVUJytdUFXLI2/mQkYzus=
X-Received: by 2002:ad4:47ad:: with SMTP id a13mr17874781qvz.29.1578953462182;
 Mon, 13 Jan 2020 14:11:02 -0800 (PST)
Date:   Mon, 13 Jan 2020 14:10:53 -0800
In-Reply-To: <20200113221053.22053-1-oupton@google.com>
Message-Id: <20200113221053.22053-4-oupton@google.com>
Mime-Version: 1.0
References: <20200113221053.22053-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [kvm-unit-tests PATCH 3/3] x86: VMX: Add tests for monitor trap flag
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test to verify that MTF VM-exits into host are synthesized when the
'monitor trap flag' processor-based VM-execution control is set under
various conditions.

Expect an MTF VM-exit if instruction execution produces no events other
than MTF. Should instruction execution produce a concurrent debug-trap
and MTF event, expect an MTF VM-exit with the 'pending debug exceptions'
VMCS field set. Expect an MTF VM-exit to follow event delivery should
instruction execution generate a higher-priority event, such as a
general-protection fault. Lastly, expect an MTF VM-exit to follow
delivery of a debug-trap software exception (INT1/INT3/INTO/INT n).

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx.h       |   1 +
 x86/vmx_tests.c | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index 6214400f2b53..6adf0916564b 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -399,6 +399,7 @@ enum Ctrl0 {
 	CPU_NMI_WINDOW		= 1ul << 22,
 	CPU_IO			= 1ul << 24,
 	CPU_IO_BITMAP		= 1ul << 25,
+	CPU_MTF			= 1ul << 27,
 	CPU_MSR_BITMAP		= 1ul << 28,
 	CPU_MONITOR		= 1ul << 29,
 	CPU_PAUSE		= 1ul << 30,
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index fce773c18b8b..5beed8e29b4b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4952,6 +4952,162 @@ static void test_vmx_preemption_timer(void)
 	vmcs_write(EXI_CONTROLS, saved_exit);
 }
 
+extern unsigned char test_mtf1;
+extern unsigned char test_mtf2;
+extern unsigned char test_mtf3;
+
+__attribute__((noclone)) static void test_mtf_guest(void)
+{
+	asm ("vmcall;\n\t"
+	     "out %al, $0x80;\n\t"
+	     "test_mtf1:\n\t"
+	     "vmcall;\n\t"
+	     "out %al, $0x80;\n\t"
+	     "test_mtf2:\n\t"
+	     /*
+	      * Prepare for the 'MOV CR3' test. Attempt to induce a
+	      * general-protection fault by moving a non-canonical address into
+	      * CR3. The 'MOV CR3' instruction does not take an imm64 operand,
+	      * so we must MOV the desired value into a register first.
+	      *
+	      * MOV RAX is done before the VMCALL such that MTF is only enabled
+	      * for the instruction under test.
+	      */
+	     "mov $0x8000000000000000, %rax;\n\t"
+	     "vmcall;\n\t"
+	     "mov %rax, %cr3;\n\t"
+	     "test_mtf3:\n\t"
+	     "vmcall;\n\t"
+	     /*
+	      * ICEBP/INT1 instruction. Though the instruction is now
+	      * documented, don't rely on assemblers enumerating the
+	      * instruction. Resort to hand assembly.
+	      */
+	     ".byte 0xf1;\n\t");
+}
+
+static void test_mtf_gp_handler(struct ex_regs *regs)
+{
+	regs->rip = (unsigned long) &test_mtf3;
+}
+
+static void test_mtf_db_handler(struct ex_regs *regs)
+{
+}
+
+static void enable_mtf(void)
+{
+	u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
+
+	vmcs_write(CPU_EXEC_CTRL0, ctrl0 | CPU_MTF);
+}
+
+static void disable_mtf(void)
+{
+	u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
+
+	vmcs_write(CPU_EXEC_CTRL0, ctrl0 & ~CPU_MTF);
+}
+
+static void enable_tf(void)
+{
+	unsigned long rflags = vmcs_read(GUEST_RFLAGS);
+
+	vmcs_write(GUEST_RFLAGS, rflags | X86_EFLAGS_TF);
+}
+
+static void disable_tf(void)
+{
+	unsigned long rflags = vmcs_read(GUEST_RFLAGS);
+
+	vmcs_write(GUEST_RFLAGS, rflags & ~X86_EFLAGS_TF);
+}
+
+static void report_mtf(const char *insn_name, unsigned long exp_rip)
+{
+	unsigned long rip = vmcs_read(GUEST_RIP);
+
+	assert_exit_reason(VMX_MTF);
+	report(rip == exp_rip, "MTF VM-exit after %s instruction. RIP: 0x%lx (expected 0x%lx)",
+	       insn_name, rip, exp_rip);
+}
+
+static void vmx_mtf_test(void)
+{
+	unsigned long pending_dbg;
+	handler old_gp, old_db;
+
+	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
+		printf("CPU does not support the 'monitor trap flag' processor-based VM-execution control.\n");
+		return;
+	}
+
+	test_set_guest(test_mtf_guest);
+
+	/* Expect an MTF VM-exit after OUT instruction */
+	enter_guest();
+	skip_exit_vmcall();
+
+	enable_mtf();
+	enter_guest();
+	report_mtf("OUT", (unsigned long) &test_mtf1);
+	disable_mtf();
+
+	/*
+	 * Concurrent #DB trap and MTF on instruction boundary. Expect MTF
+	 * VM-exit with populated 'pending debug exceptions' VMCS field.
+	 */
+	enter_guest();
+	skip_exit_vmcall();
+
+	enable_mtf();
+	enable_tf();
+
+	enter_guest();
+	report_mtf("OUT", (unsigned long) &test_mtf2);
+	pending_dbg = vmcs_read(GUEST_PENDING_DEBUG);
+	report(pending_dbg & DR_STEP,
+	       "'pending debug exceptions' field after MTF VM-exit: 0x%lx (expected 0x%lx)",
+	       pending_dbg, (unsigned long) DR_STEP);
+
+	disable_mtf();
+	disable_tf();
+	vmcs_write(GUEST_PENDING_DEBUG, 0);
+
+	/*
+	 * #GP exception takes priority over MTF. Expect MTF VM-exit with rIP
+	 * advanced to first instruction of #GP handler.
+	 */
+	enter_guest();
+	skip_exit_vmcall();
+
+	old_gp = handle_exception(GP_VECTOR, test_mtf_gp_handler);
+
+	enable_mtf();
+	enter_guest();
+	report_mtf("MOV CR3", (unsigned long) get_idt_addr(&boot_idt[GP_VECTOR]));
+	disable_mtf();
+
+	/*
+	 * Concurrent MTF and privileged software exception (i.e. ICEBP/INT1).
+	 * MTF should follow the delivery of #DB trap, though the SDM doesn't
+	 * provide clear indication of the relative priority.
+	 */
+	enter_guest();
+	skip_exit_vmcall();
+
+	handle_exception(GP_VECTOR, old_gp);
+	old_db = handle_exception(DB_VECTOR, test_mtf_db_handler);
+
+	enable_mtf();
+	enter_guest();
+	report_mtf("INT1", (unsigned long) get_idt_addr(&boot_idt[DB_VECTOR]));
+	disable_mtf();
+
+	enter_guest();
+	handle_exception(DB_VECTOR, old_db);
+}
+
 /*
  * Tests for VM-execution control fields
  */
@@ -9443,5 +9599,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(atomic_switch_max_msrs_test),
 	TEST(atomic_switch_overflow_msrs_test),
 	TEST(rdtsc_vmexit_diff_test),
+	TEST(vmx_mtf_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.25.0.rc1.283.g88dfdc4193-goog

