Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DFC5C7EE
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 05:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfGBDn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 23:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfGBDnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 23:43:25 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4223C2183F;
        Tue,  2 Jul 2019 03:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562039004;
        bh=0YIrxv9I7RI0x/7wdAUptcwM2tZFC1S4qN00UgGW3+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKDpMMVWIMdPIaEtKarV9tNj73I+0UAgbPw9YuAVoGSqATzGYKOmHm3Xt2SVI1bAP
         QhEhHAzN/dNyRfjbz3jNc6CTAErhMWDPawtj9yi0qIu35+9OCW269Z7U3zLT0WGtP8
         ashaCYHbeqKE6/q8hMaxb/itHbPh6q5XCBBHGK+I=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 1/3] selftests/x86: Test SYSCALL and SYSENTER manually with TF set
Date:   Mon,  1 Jul 2019 20:43:19 -0700
Message-Id: <5f5de10441ab2e3005538b4c33be9b1965d1bb63.1562035429.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1562035429.git.luto@kernel.org>
References: <cover.1562035429.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make sure that we exercise both variants of the nasty
TF-in-compat-syscall regardless of what vendor's CPU is running the
tests.

Also change the intentional signal after SYSCALL to use ud2, which
is a lot more comprehensible.

This crashes the kernel due to an FSGSBASE bug right now.

This test *also* detects a bug in KVM when run on an Intel host.
KVM people, feel free to use it to help debug.  There's a bunch of
code in this test to warn instead of infinite looping when the bug
gets triggered.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 tools/testing/selftests/x86/Makefile          |   5 +-
 .../testing/selftests/x86/syscall_arg_fault.c | 112 +++++++++++++++++-
 2 files changed, 110 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 186520198de7..fa07d526fe39 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -12,8 +12,9 @@ CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) trivial_program.c -no-pie)
 
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
 			check_initial_reg_state sigreturn iopl mpx-mini-test ioperm \
-			protection_keys test_vdso test_vsyscall mov_ss_trap
-TARGETS_C_32BIT_ONLY := entry_from_vm86 syscall_arg_fault test_syscall_vdso unwind_vdso \
+			protection_keys test_vdso test_vsyscall mov_ss_trap \
+			syscall_arg_fault
+TARGETS_C_32BIT_ONLY := entry_from_vm86 test_syscall_vdso unwind_vdso \
 			test_FCMOV test_FCOMI test_FISTTP \
 			vdso_restorer
 TARGETS_C_64BIT_ONLY := fsgsbase sysret_rip
diff --git a/tools/testing/selftests/x86/syscall_arg_fault.c b/tools/testing/selftests/x86/syscall_arg_fault.c
index 4e25d38c8bbd..bc0ecc2e862e 100644
--- a/tools/testing/selftests/x86/syscall_arg_fault.c
+++ b/tools/testing/selftests/x86/syscall_arg_fault.c
@@ -15,9 +15,30 @@
 #include <setjmp.h>
 #include <errno.h>
 
+#ifdef __x86_64__
+# define WIDTH "q"
+#else
+# define WIDTH "l"
+#endif
+
 /* Our sigaltstack scratch space. */
 static unsigned char altstack_data[SIGSTKSZ];
 
+static unsigned long get_eflags(void)
+{
+	unsigned long eflags;
+	asm volatile ("pushf" WIDTH "\n\tpop" WIDTH " %0" : "=rm" (eflags));
+	return eflags;
+}
+
+static void set_eflags(unsigned long eflags)
+{
+	asm volatile ("push" WIDTH " %0\n\tpopf" WIDTH
+		      : : "rm" (eflags) : "flags");
+}
+
+#define X86_EFLAGS_TF (1UL << 8)
+
 static void sethandler(int sig, void (*handler)(int, siginfo_t *, void *),
 		       int flags)
 {
@@ -35,13 +56,22 @@ static sigjmp_buf jmpbuf;
 
 static volatile sig_atomic_t n_errs;
 
+#ifdef __x86_64__
+#define REG_AX REG_RAX
+#define REG_IP REG_RIP
+#else
+#define REG_AX REG_EAX
+#define REG_IP REG_EIP
+#endif
+
 static void sigsegv_or_sigbus(int sig, siginfo_t *info, void *ctx_void)
 {
 	ucontext_t *ctx = (ucontext_t*)ctx_void;
+	long ax = (long)ctx->uc_mcontext.gregs[REG_AX];
 
-	if (ctx->uc_mcontext.gregs[REG_EAX] != -EFAULT) {
-		printf("[FAIL]\tAX had the wrong value: 0x%x\n",
-		       ctx->uc_mcontext.gregs[REG_EAX]);
+	if (ax != -EFAULT && ax != -ENOSYS) {
+		printf("[FAIL]\tAX had the wrong value: 0x%lx\n",
+		       (unsigned long)ax);
 		n_errs++;
 	} else {
 		printf("[OK]\tSeems okay\n");
@@ -50,9 +80,42 @@ static void sigsegv_or_sigbus(int sig, siginfo_t *info, void *ctx_void)
 	siglongjmp(jmpbuf, 1);
 }
 
+static volatile sig_atomic_t sigtrap_consecutive_syscalls;
+
+static void sigtrap(int sig, siginfo_t *info, void *ctx_void)
+{
+	/*
+	 * KVM has some bugs that can cause us to stop making progress.
+	 * detect them and complain, but don't infinite loop or fail the
+	 * test.
+	 */
+
+	ucontext_t *ctx = (ucontext_t*)ctx_void;
+	unsigned short *ip = (unsigned short *)ctx->uc_mcontext.gregs[REG_IP];
+
+	if (*ip == 0x340f || *ip == 0x050f) {
+		/* The trap was on SYSCALL or SYSENTER */
+		sigtrap_consecutive_syscalls++;
+		if (sigtrap_consecutive_syscalls > 3) {
+			printf("[WARN]\tGot stuck single-stepping -- you probably have a KVM bug\n");
+			siglongjmp(jmpbuf, 1);
+		}
+	} else {
+		sigtrap_consecutive_syscalls = 0;
+	}
+}
+
 static void sigill(int sig, siginfo_t *info, void *ctx_void)
 {
-	printf("[SKIP]\tIllegal instruction\n");
+	ucontext_t *ctx = (ucontext_t*)ctx_void;
+	unsigned short *ip = (unsigned short *)ctx->uc_mcontext.gregs[REG_IP];
+
+	if (*ip == 0x0b0f) {
+		/* one of the ud2 instructions faulted */
+		printf("[OK]\tSYSCALL returned normally\n");
+	} else {
+		printf("[SKIP]\tIllegal instruction\n");
+	}
 	siglongjmp(jmpbuf, 1);
 }
 
@@ -120,9 +183,48 @@ int main()
 			"movl $-1, %%ebp\n\t"
 			"movl $-1, %%esp\n\t"
 			"syscall\n\t"
-			"pushl $0"	/* make sure we segfault cleanly */
+			"ud2"		/* make sure we recover cleanly */
+			: : : "memory", "flags");
+	}
+
+	printf("[RUN]\tSYSENTER with TF and invalid state\n");
+	sethandler(SIGTRAP, sigtrap, SA_ONSTACK);
+
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		sigtrap_consecutive_syscalls = 0;
+		set_eflags(get_eflags() | X86_EFLAGS_TF);
+		asm volatile (
+			"movl $-1, %%eax\n\t"
+			"movl $-1, %%ebx\n\t"
+			"movl $-1, %%ecx\n\t"
+			"movl $-1, %%edx\n\t"
+			"movl $-1, %%esi\n\t"
+			"movl $-1, %%edi\n\t"
+			"movl $-1, %%ebp\n\t"
+			"movl $-1, %%esp\n\t"
+			"sysenter"
+			: : : "memory", "flags");
+	}
+	set_eflags(get_eflags() & ~X86_EFLAGS_TF);
+
+	printf("[RUN]\tSYSCALL with TF and invalid state\n");
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		sigtrap_consecutive_syscalls = 0;
+		set_eflags(get_eflags() | X86_EFLAGS_TF);
+		asm volatile (
+			"movl $-1, %%eax\n\t"
+			"movl $-1, %%ebx\n\t"
+			"movl $-1, %%ecx\n\t"
+			"movl $-1, %%edx\n\t"
+			"movl $-1, %%esi\n\t"
+			"movl $-1, %%edi\n\t"
+			"movl $-1, %%ebp\n\t"
+			"movl $-1, %%esp\n\t"
+			"syscall\n\t"
+			"ud2"		/* make sure we recover cleanly */
 			: : : "memory", "flags");
 	}
+	set_eflags(get_eflags() & ~X86_EFLAGS_TF);
 
 	return 0;
 }
-- 
2.21.0

