Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE624117A
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 22:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgHJUMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 16:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgHJUMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 16:12:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6004CC061756
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:12:05 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e4so7262720pgv.7
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZxFFFXrx2tGXqpsPuWsQeJ3BtZLBxHQDGl2m77pFjXs=;
        b=RqFCi1IOB8UTNhQN6jXDkkSUjhwQE0VNUfAnS9LehubhtSIUIbEUF1t6ymY2xpx5vv
         uKz8tucfXV66jT2esNjgZGZkZyowR1UOYPkbx8X6/MNd5zPJkRahHPeLzl3Qd/nuMvlB
         zngzei6HygIPYFLfIdLnBbvQowQ4aG6cYykuuvVUgSVDQ+5XFpdwCemUsPotDJKYOF/2
         dAeMK1AJwgiMVjGjw4agPdbFEu5LMiegaYB1SIhKUVXd9pRXc2tJIICsWDaV1nRcqpkT
         QKkg+v7u3RYrE3xFMB7G3DI6w8EsUYB+KKNaKxigc8nDQgPJtTKl+UmWetfhcQsV7rWL
         4t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZxFFFXrx2tGXqpsPuWsQeJ3BtZLBxHQDGl2m77pFjXs=;
        b=SXmkJX9QRHI9f+uRbub564BOCLsMDpepeO3QuB8jUMf1xkJIiewLSivWsyk4U0f02d
         uq29KwdgKircWp922HC5mBL87pzW0xYo5JXNwtUd1pvpkNba5urKA2Pq4AGQuj9P90J8
         237AZA+42OVYOXk024jwit9YTNsRPBOsKtQafrKsAHHQ6EkZwOjfi9uzsRHroYy1lYuS
         SCqATitopmPdstSOOIZD99B8tw4M21bC7jqfsSEXmm9PWa2O2PzTVlHk3CL/gwLqTgA6
         Ev8DO6VHVCEsWw5CvjCDhjM1FzDM3J8tzeHRkAzpqoRzbn1fxwdKFX2ITkrXo5vjmJXz
         3OAw==
X-Gm-Message-State: AOAM533/yM+vH7nkH8D0DLpNxg8kPaRp/5YlvLEFhw7nyB++B3kgAlkQ
        uMi50nTsx1ARS+12Rv2JgzBd4TRRf9hv07zZ
X-Google-Smtp-Source: ABdhPJwBGAMRlnABY04i2CCAKtXgQtShM7VWlRBKeyP7LmIY9P9OeAcJLi7g1zlhT5sQg1PtzEL/SdvVRK29GKnU
X-Received: by 2002:a65:668e:: with SMTP id b14mr23265134pgw.153.1597090324653;
 Mon, 10 Aug 2020 13:12:04 -0700 (PDT)
Date:   Mon, 10 Aug 2020 13:11:34 -0700
In-Reply-To: <20200810201134.2031613-1-aaronlewis@google.com>
Message-Id: <20200810201134.2031613-9-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200810201134.2031613-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 8/8] selftests: kvm: Add emulated rdmsr, wrmsr tests
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests to exercise the code paths for em_{rdmsr,wrmsr} and
emulator_{get,set}_msr.  For the generic instruction emulator to work
the module parameter kvm.force_emulation_prefix=1 has to be enabled.  If
it isn't the tests will be skipped.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/x86_64/userspace_msr_exit.c | 158 +++++++++++++++++-
 1 file changed, 150 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
index 44ddcd53a583..ae96022b6ae8 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
@@ -12,8 +12,12 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define VCPU_ID	      1
+/* Forced emulation prefix, used to invoke the emulator unconditionally. */
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+#define KVM_FEP_LENGTH 5
+static int fep_available = 1;
 
+#define VCPU_ID	      1
 #define MSR_NON_EXISTENT 0x474f4f00
 
 uint32_t msrs[] = {
@@ -63,6 +67,39 @@ static noinline void test_wrmsr(uint32_t msr, uint64_t value)
 extern char rdmsr_start, rdmsr_end;
 extern char wrmsr_start, wrmsr_end;
 
+/*
+ * Note: Force test_em_rdmsr() to not be inlined to prevent the labels,
+ * rdmsr_start and rdmsr_end, from being defined multiple times.
+ */
+static noinline uint64_t test_em_rdmsr(uint32_t msr)
+{
+	uint32_t a, d;
+
+	guest_exception_count = 0;
+
+	__asm__ __volatile__(KVM_FEP "em_rdmsr_start: rdmsr; em_rdmsr_end:" :
+			"=a"(a), "=d"(d) : "c"(msr) : "memory");
+
+	return a | ((uint64_t) d << 32);
+}
+
+/*
+ * Note: Force test_em_wrmsr() to not be inlined to prevent the labels,
+ * wrmsr_start and wrmsr_end, from being defined multiple times.
+ */
+static noinline void test_em_wrmsr(uint32_t msr, uint64_t value)
+{
+	uint32_t a = value;
+	uint32_t d = value >> 32;
+
+	guest_exception_count = 0;
+
+	__asm__ __volatile__(KVM_FEP "em_wrmsr_start: wrmsr; em_wrmsr_end:" ::
+			"a"(a), "d"(d), "c"(msr) : "memory");
+}
+
+extern char em_rdmsr_start, em_rdmsr_end;
+extern char em_wrmsr_start, em_wrmsr_end;
 
 static void guest_code(void)
 {
@@ -112,17 +149,55 @@ static void guest_code(void)
 	GUEST_ASSERT(data == 2);
 	GUEST_ASSERT(guest_exception_count == 0);
 
+	/*
+	 * Test to see if the instruction emulator is available (ie: the module
+	 * parameter 'kvm.force_emulation_prefix=1' is set).  This instruction
+	 * will #UD if it isn't available.
+	 */
+	__asm__ __volatile__(KVM_FEP "nop");
+
+	if (fep_available) {
+		/* Let userspace know we aren't done. */
+		GUEST_SYNC(0);
+
+		/*
+		 * Now run the same tests with the instruction emulator.
+		 */
+		data = test_em_rdmsr(MSR_IA32_XSS);
+		GUEST_ASSERT(data == 0);
+		GUEST_ASSERT(guest_exception_count == 0);
+		test_em_wrmsr(MSR_IA32_XSS, 0);
+		GUEST_ASSERT(guest_exception_count == 0);
+		test_em_wrmsr(MSR_IA32_XSS, 1);
+		GUEST_ASSERT(guest_exception_count == 1);
+
+		test_em_rdmsr(MSR_IA32_FLUSH_CMD);
+		GUEST_ASSERT(guest_exception_count == 1);
+		test_em_wrmsr(MSR_IA32_FLUSH_CMD, 0);
+		GUEST_ASSERT(guest_exception_count == 1);
+		test_em_wrmsr(MSR_IA32_FLUSH_CMD, 1);
+		GUEST_ASSERT(guest_exception_count == 0);
+
+		test_em_wrmsr(MSR_NON_EXISTENT, 2);
+		GUEST_ASSERT(guest_exception_count == 0);
+		data = test_em_rdmsr(MSR_NON_EXISTENT);
+		GUEST_ASSERT(data == 2);
+		GUEST_ASSERT(guest_exception_count == 0);
+	}
+
 	GUEST_DONE();
 }
 
-static void guest_gp_handler(struct ex_regs *regs)
+static void __guest_gp_handler(struct ex_regs *regs,
+			       char *r_start, char *r_end,
+			       char *w_start, char *w_end)
 {
-	if (regs->rip == (uintptr_t)&rdmsr_start) {
-		regs->rip = (uintptr_t)&rdmsr_end;
+	if (regs->rip == (uintptr_t)r_start) {
+		regs->rip = (uintptr_t)r_end;
 		regs->rax = 0;
 		regs->rdx = 0;
-	} else if (regs->rip == (uintptr_t)&wrmsr_start) {
-		regs->rip = (uintptr_t)&wrmsr_end;
+	} else if (regs->rip == (uintptr_t)w_start) {
+		regs->rip = (uintptr_t)w_end;
 	} else {
 		GUEST_ASSERT(!"RIP is at an unknown location!");
 	}
@@ -130,6 +205,24 @@ static void guest_gp_handler(struct ex_regs *regs)
 	++guest_exception_count;
 }
 
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	__guest_gp_handler(regs, &rdmsr_start, &rdmsr_end,
+			   &wrmsr_start, &wrmsr_end);
+}
+
+static void guest_fep_gp_handler(struct ex_regs *regs)
+{
+	__guest_gp_handler(regs, &em_rdmsr_start, &em_rdmsr_end,
+			   &em_wrmsr_start, &em_wrmsr_end);
+}
+
+static void guest_ud_handler(struct ex_regs *regs)
+{
+	fep_available = 0;
+	regs->rip += KVM_FEP_LENGTH;
+}
+
 static void run_guest(struct kvm_vm *vm)
 {
 	int rc;
@@ -225,6 +318,32 @@ static void process_ucall_done(struct kvm_vm *vm)
 		    uc.cmd, UCALL_DONE);
 }
 
+static uint64_t process_ucall(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc = {};
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Unexpected exit reason: %u (%s)",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_SYNC:
+		break;
+	case UCALL_ABORT:
+		check_for_guest_assert(vm);
+		break;
+	case UCALL_DONE:
+		process_ucall_done(vm);
+		break;
+	default:
+		TEST_ASSERT(false, "Unexpected ucall");
+	}
+
+	return uc.cmd;
+}
+
 static void run_guest_then_process_rdmsr(struct kvm_vm *vm, uint32_t msr_index)
 {
 	run_guest(vm);
@@ -260,7 +379,7 @@ int main(int argc, char *argv[])
 
 	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
 
-	/* Process guest code userspace exits */
+	/* Process guest code userspace exits. */
 	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
 	run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
 	run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
@@ -272,7 +391,30 @@ int main(int argc, char *argv[])
 	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
 	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
 
-	run_guest_then_process_ucall_done(vm);
+	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+	run_guest(vm);
+	vm_handle_exception(vm, UD_VECTOR, NULL);
+
+	if (process_ucall(vm) != UCALL_DONE) {
+		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
+
+		/* Process emulated rdmsr and wrmsr instructions. */
+		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+
+		run_guest_then_process_rdmsr(vm, MSR_IA32_FLUSH_CMD);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+
+		run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
+		run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
+
+		/* Confirm the guest completed without issues. */
+		run_guest_then_process_ucall_done(vm);
+	} else {
+		printf("To run the instruction emulated tests set the module parameter 'kvm.force_emulation_prefix=1'\n");
+	}
 
 	kvm_vm_free(vm);
 	return 0;
-- 
2.28.0.236.gb10cc79966-goog

