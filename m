Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D449046F30E
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243315AbhLISa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243257AbhLISa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:30:27 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4060C061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:26:53 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p24-20020a170902a41800b001438d6c7d71so2794637plq.7
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YC62D8F3GoowMSCLhqG0RlUlHOtLOAasPhn3zvFjvU8=;
        b=OiudjfGFZKrWkh9lfoxlNtnU5lPKmA1+/YoQQ8KSHKlJPL4RpbIYKDIxXzZd/QigLn
         2Zj1F3A3r4KvZF4fxdBCKA3GKZ7tvjyaAJJUapf/Jukbf6zrZw/dsc8AoPEtCr263vtz
         YSKqtfXkPqISOoghjkqz07gZF4lNa48H92Q4BDvpPchsKjoPgDfOsdb10HPNVqlGabHy
         th0/Ja/j6WDXxl7lhwnIP6N4gc4Z2ezaB36g4yOlmCE7JEPNmEWYsGHlbkfBaijQR6ZG
         9GgkQ7GP2raDchumFjnTFPU94U8GndxEidf+0YFlSZ2FvlIFBKLxJ5AjDMWjg2JtHPWi
         qsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YC62D8F3GoowMSCLhqG0RlUlHOtLOAasPhn3zvFjvU8=;
        b=Y4AbQPMAj8CVemhgGu1oA4eukbqB5p6SOnGE6gG10WyhMUMSpDqASLKqeaa4Jb/Bze
         RmiiCs6N7Gkr7me9E+7xA10ALd3/0idpnwgNMZMf393UKQ3Zu7/YqdTKPaI6YR3VhFfu
         zgupNypJt3zPEmlOPpvu9Wz7H7wdi+AD+WtgdO+g+RsAFThNBQ5YyC3rtHX2ZD8rT5fe
         ZUCJFfBJDCyeeNkpXjFQ14QQ1+hvFRSISs55dVcsrnZZKuDaVMyuW9yq4cxudTkwJ9J0
         AqPENmdHzn89A/hwhgIQnffKXHImtFOsoXKLa+7a1q1dQv0rfjtAHY452Vxd4Zs1WjbH
         Jktg==
X-Gm-Message-State: AOAM532Erbgoh0qkR9gETi2AMecVvuit5Du4R6BAhlBiJA+2XWhnZy5h
        /uYwjm2C2kxFBgT5BX3hMKRGFfOG4kHGZACxpKQoTailMIuMwwGLoUyAuoiRBEJMh4I7TEW1G5s
        UXPGf5Ghwn0o1GEVSiQ9/c1MQR/bzxkgxanyybl8GyzhA7GCaCsKdhhixSXvLVvbH6fkR
X-Google-Smtp-Source: ABdhPJzhb7enbegZ4quhI9pmNdazUASXDng+rjNJBgBIFJMJhkgc3NNaTnAaE06ps83LHKipLGOc1nLs72zXElYj
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr1024749pjb.0.1639074412892; Thu, 09 Dec 2021 10:26:52 -0800 (PST)
Date:   Thu,  9 Dec 2021 18:26:24 +0000
In-Reply-To: <20211209182624.2316453-1-aaronlewis@google.com>
Message-Id: <20211209182624.2316453-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211209182624.2316453-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 3/3] x86: Add test coverage for the routing
 logic when exceptions occur in L2
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vmx_exception_test to ensure that exceptions that occur in L2 are
forwarded to the correct place.  When an exception occurs in L2, L1 or
L0 may want to get involved.  Test that the exception is routed to the
where it is supposed to go.

The exceptions that are tested are: #GP, #UD, #DE, #DB, #BP, and #AC.
For each of these exceptions there are two main goals:
 1) Test that the exception is handled by L2.
 2) Test that the exception is handled by L1.
To test that this happens, each exception is triggered twice; once with
just an L2 exception handler registered, and again with both an L2
exception handler registered and L1's exception bitmap set.  The
expectation is that the first exception will be handled by L2 and the
second by L1.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/unittests.cfg |   7 ++
 x86/vmx_tests.c   | 211 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 218 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9fcdcae..0353b69 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -368,6 +368,13 @@ arch = x86_64
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
index 3d57ed6..4aafed9 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -21,6 +21,7 @@
 #include "smp.h"
 #include "delay.h"
 #include "access.h"
+#include "x86/usermode.h"
 
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
 
@@ -10701,6 +10702,215 @@ static void vmx_pf_vpid_test(void)
 	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
 }
 
+extern char vmx_exception_test_skip_gp;
+extern char vmx_exception_test_skip_ud;
+extern char vmx_exception_test_skip_ud_from_l1;
+extern char vmx_exception_test_skip_de;
+extern char vmx_exception_test_skip_bp;
+
+static void set_exception_bitmap(u32 vector)
+{
+	vmcs_write(EXC_BITMAP, vmcs_read(EXC_BITMAP) | (1u << vector));
+}
+
+static void vmx_exception_handler_gp(struct ex_regs *regs)
+{
+	report(regs->vector == GP_VECTOR,
+	       "Handling #GP in L2's exception handler.");
+	regs->rip = (uintptr_t)(&vmx_exception_test_skip_gp);
+}
+
+static void vmx_exception_handler_ud(struct ex_regs *regs)
+{
+	report(regs->vector == UD_VECTOR,
+	       "Handling #UD in L2's exception handler.");
+	regs->rip = (uintptr_t)(&vmx_exception_test_skip_ud);
+}
+
+static void vmx_exception_handler_de(struct ex_regs *regs)
+{
+	report(regs->vector == DE_VECTOR,
+	       "Handling #DE in L2's exception handler.");
+	regs->rip = (uintptr_t)(&vmx_exception_test_skip_de);
+}
+
+static void vmx_exception_handler_db(struct ex_regs *regs)
+{
+	report(regs->vector == DB_VECTOR,
+	       "Handling #DB in L2's exception handler.");
+	regs->rflags &= ~X86_EFLAGS_TF;
+}
+
+static void vmx_exception_handler_bp(struct ex_regs *regs)
+{
+	report(regs->vector == BP_VECTOR,
+	       "Handling #BP in L2's exception handler.");
+	regs->rip = (uintptr_t)(&vmx_exception_test_skip_bp);
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
+static void vmx_exception_test_guest(void)
+{
+	handler old_gp = handle_exception(GP_VECTOR, vmx_exception_handler_gp);
+	handler old_ud = handle_exception(UD_VECTOR, vmx_exception_handler_ud);
+	handler old_de = handle_exception(DE_VECTOR, vmx_exception_handler_de);
+	handler old_db = handle_exception(DB_VECTOR, vmx_exception_handler_db);
+	handler old_bp = handle_exception(BP_VECTOR, vmx_exception_handler_bp);
+	bool raised_vector = false;
+	u64 old_cr0, old_rflags;
+
+	asm volatile (
+		/* Return to L1 before starting the tests. */
+		"vmcall\n\t"
+
+		/* #GP handled by L2*/
+		"mov %[val], %%cr0\n\t"
+		"vmx_exception_test_skip_gp:\n\t"
+		"vmcall\n\t"
+
+		/* #GP handled by L1 */
+		"mov %[val], %%cr0\n\t"
+
+	 	/* #UD handled by L2. */
+		"ud2\n\t"
+		"vmx_exception_test_skip_ud:\n\t"
+		"vmcall\n\t"
+
+		/* #UD handled by L1. */
+		"ud2\n\t"
+		"vmx_exception_test_skip_ud_from_l1:\n\t"
+
+		/* #DE handled by L2. */
+		"xor %%eax, %%eax\n\t"
+		"xor %%ebx, %%ebx\n\t"
+		"xor %%edx, %%edx\n\t"
+		"idiv %%ebx\n\t"
+		"vmx_exception_test_skip_de:\n\t"
+		"vmcall\n\t"
+
+		/* #DE handled by L1. */
+	 	"xor %%eax, %%eax\n\t"
+	 	"xor %%ebx, %%ebx\n\t"
+	 	"xor %%edx, %%edx\n\t"
+	 	"idiv %%ebx\n\t"
+
+		/* #DB handled by L2. */
+		"nop\n\t"
+		"vmcall\n\t"
+
+		/* #DB handled by L1. */
+		"nop\n\t"
+
+		/* #BP handled by L2. */
+		"int3\n\t"
+		"vmx_exception_test_skip_bp:\n\t"
+		"vmcall\n\t"
+
+		/* #BP handled by L1. */
+		"int3\n\t"
+		:: [val]"r"(1ul << 32) : "eax", "ebx", "edx");
+
+	/* #AC handled by L2. */
+	old_cr0  = read_cr0();
+	old_rflags = read_rflags();
+	write_cr0(old_cr0 | X86_CR0_AM);
+	write_rflags(old_rflags | X86_EFLAGS_AC);
+
+	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &raised_vector);
+	report(raised_vector, "#AC vector raised from usermode in L2");
+	vmcall();
+
+	/* #AC handled by L1. */
+	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &raised_vector);
+	report(!raised_vector,
+	       "#AC vector not raised from usermode in L2 (L1 handled it)");
+
+	write_cr0(old_cr0);
+	write_rflags(old_rflags);
+
+	/* Clean up */
+	handle_exception(GP_VECTOR, old_gp);
+	handle_exception(UD_VECTOR, old_ud);
+	handle_exception(DE_VECTOR, old_de);
+	handle_exception(DB_VECTOR, old_db);
+	handle_exception(BP_VECTOR, old_bp);
+}
+
+static void handle_exception_in_l2(const char *msg)
+{
+	enter_guest();
+	assert_exit_reason(VMX_VMCALL);
+	report(vmcs_read(EXI_REASON) == VMX_VMCALL, msg);
+	skip_exit_insn();
+}
+
+static void handle_exception_in_l1(u32 vector, const char *msg)
+{
+	set_exception_bitmap(vector);
+	enter_guest();
+	assert_exit_reason(VMX_EXC_NMI);
+	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
+	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
+	       msg);
+	skip_exit_insn();
+}
+
+static void vmx_exception_test(void)
+{
+	u32 old_eb = vmcs_read(EXC_BITMAP);
+
+	test_set_guest(vmx_exception_test_guest);
+
+	/*
+	 * Start L2 so it can register it's exception handlers before the test
+	 * starts.
+	 */
+	enter_guest();
+	assert_exit_reason(VMX_VMCALL);
+	skip_exit_insn();
+
+	/* Run tests. */
+	handle_exception_in_l2("#GP handled by L2");
+	handle_exception_in_l1(GP_VECTOR, "#GP hanlded by L1");
+
+	handle_exception_in_l2("#UD handled by L2");
+	handle_exception_in_l1(UD_VECTOR, "#UD hanlded by L1");
+	vmcs_write(GUEST_RIP, (u64)&vmx_exception_test_skip_ud_from_l1);
+
+	handle_exception_in_l2("#DE handled by L2");
+	handle_exception_in_l1(DE_VECTOR, "#DE hanlded by L1");
+
+	enable_tf();
+	handle_exception_in_l2("#DB handled by L2");
+	report((vmcs_read(GUEST_RFLAGS) & X86_EFLAGS_TF) == 0,
+	       "X86_EFLAGS_TF disabled in L2");
+	enable_tf();
+	handle_exception_in_l1(DB_VECTOR, "#DB hanlded by L1");
+	disable_tf();
+
+	handle_exception_in_l2("#BP handled by L2");
+	handle_exception_in_l1(BP_VECTOR, "#BP hanlded by L1");
+
+	handle_exception_in_l2("#AC handled by L2");
+	handle_exception_in_l1(AC_VECTOR, "#AC hanlded by L1");
+
+	/* Complete running the guest. */
+	enter_guest();
+	assert_exit_reason(VMX_VMCALL);
+
+	vmcs_write(EXC_BITMAP, old_eb);
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10810,5 +11020,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_no_vpid_test),
 	TEST(vmx_pf_invvpid_test),
 	TEST(vmx_pf_vpid_test),
+	TEST(vmx_exception_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.34.1.173.g76aa8bc2d0-goog

