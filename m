Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E34E44CB46
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhKJVXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbhKJVXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:36 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B402DC061230
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:39 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id v63-20020a632f42000000b002cc65837088so2157447pgv.1
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NlDToowUudOyKNakNM8rv9+vrJ6Y0uZ/gFEZLkAMb+4=;
        b=DGbTCaCzcdaTHYDKXNqd7IPLM0VycaoyhS/YNg48aoCd06J7rw+iti0RviugRo2NVS
         3jRaHEOJ/BSVFyS7JWHosRYyk6mt6aOIbrGgvhE8zlewlxgg+Tk2+MTtn9By9zrstyEJ
         SRCA0IDvysR1axUP/BZIJmIHohwMQ3xGXgQzcOScZZx1MiLnddIyuuYHUGZgWk62fFgi
         vCI+VQGTO6Km8VzfFGeM4T0nYeVHBEi/mEriqYrxCTVhaIGh84zU3yb/ZZ59YhMjcs/k
         oksmOYfORlZmAgAgvGS3O3Fkzxxaa/bFJc/mmdUOPesGzsg+PsQK4etknn9cV0dUwx65
         mGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NlDToowUudOyKNakNM8rv9+vrJ6Y0uZ/gFEZLkAMb+4=;
        b=UZZJETX/eRWdcRjnxaIJDkapp4eV9ZUBGq1458JdHmrRoM/6pqQORFhhjYXHfVjmsY
         +qVM2dCyuHcC+5G5Ggq9ccnTzz06e60jBLOA5i//BkpUb9CQAEySihzIZMtJhkiTm8Dw
         y/AWeuBLWq5MoX9fKUujmYET+iQWm85vtVXb389XCz/y1AWr9x44A/3wBqJ5zE7zIbnR
         kwpvrfiKk4oHxPBYWzFe4SkAvnzydvtTgkwGAU3b1zjA974eXUqTRJDDvnrBYLPZVN4u
         RaPY4f4I3UV+txsXoDR018/nV1cja0LhsfaQUkbVMJXT+mgWvLsP+dDaS3H0yPGNlqvX
         2hnQ==
X-Gm-Message-State: AOAM5302yAdhSLqQdLGX/+cgtsMd+axinzW8O0cWY+UKhSYqTSW+xQXs
        BdQGfVo8rzc0g3sRaHxgoEfXiNgmg5ddhbYLfl1wsUCZ25Q13HHTemXTFQQhO0oBKznVt+LfR9j
        UFKuS1UYYLaDNlHfzxBTn/iWPPWKbUuOXz5NLqsulzZa9RDcS0S9eqjw8Omqhw2jZmn76
X-Google-Smtp-Source: ABdhPJwn5FfpSg5rHKgry9E8WnfpM8Q0GPpMgxAeNxO7U1ss+7p+s9TBfpO1efTfgksAJX/zqpR/tcjBOITe+7A0
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:350c:: with SMTP id
 ls12mr2317718pjb.197.1636579239141; Wed, 10 Nov 2021 13:20:39 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:20:01 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-15-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 14/14] x86: Add tests that run ac_test_run() in
 an L2 guest
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests vmx_pf_exception_test and vmx_pf_exception_test_reduced_maxphyaddr
to vmx_tests.c.

The purpose of these tests are to test the reflection logic in KVM to
ensure exceptions are being routed to were they are intended to go.  For
example, it will test that we are not accidentally reflecting exceptions
into L1 when L1 isn't expecting them.  Commit 18712c13709d ("KVM: nVMX:
Use vmx_need_pf_intercept() when deciding if L0 wants a #PF") fixed an
issue related to this which went undetected because there was no testing
in place.  This adds testing to ensure there is coverage for such
issues.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/Makefile.common |  2 ++
 x86/unittests.cfg   | 13 ++++++++++++
 x86/vmx_tests.c     | 49 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index a665854..461de51 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -74,6 +74,8 @@ $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
 $(TEST_DIR)/access_test.elf: $(TEST_DIR)/access.o
 
+$(TEST_DIR)/vmx.elf: $(TEST_DIR)/access.o
+
 $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
 
 $(TEST_DIR)/hyperv_synic.elf: $(TEST_DIR)/hyperv.o
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index dbeb8a2..4069e4c 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -347,6 +347,19 @@ extra_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
 arch = x86_64
 groups = vmx
 
+[vmx_pf_exception_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append vmx_pf_exception_test
+arch = x86_64
+groups = vmx nested_exception
+
+[vmx_pf_exception_test_reduced_maxphyaddr]
+file = vmx.flat
+extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append vmx_pf_exception_test
+arch = x86_64
+groups = vmx nested_exception
+check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
+
 [debug]
 file = debug.flat
 arch = x86_64
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9ee6653..8cf3543 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -20,6 +20,7 @@
 #include "alloc_page.h"
 #include "smp.h"
 #include "delay.h"
+#include "access.h"
 
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
 
@@ -10658,6 +10659,53 @@ static void atomic_switch_overflow_msrs_test(void)
 		test_skip("Test is only supported on KVM");
 }
 
+static void vmx_pf_exception_test_guest(void)
+{
+	ac_test_run(PT_LEVEL_PML4);
+}
+
+static void vmx_pf_exception_test(void)
+{
+	u64 efer;
+	struct cpuid cpuid;
+
+	test_set_guest(vmx_pf_exception_test_guest);
+
+	enter_guest();
+
+	while (vmcs_read(EXI_REASON) != VMX_VMCALL) {
+		switch (vmcs_read(EXI_REASON)) {
+		case VMX_RDMSR:
+			assert(regs.rcx == MSR_EFER);
+			efer = vmcs_read(GUEST_EFER);
+			regs.rdx = efer >> 32;
+			regs.rax = efer & 0xffffffff;
+			break;
+		case VMX_WRMSR:
+			assert(regs.rcx == MSR_EFER);
+			efer = regs.rdx << 32 | (regs.rax & 0xffffffff);
+			vmcs_write(GUEST_EFER, efer);
+			break;
+		case VMX_CPUID:
+			cpuid = (struct cpuid) {0, 0, 0, 0};
+			cpuid = raw_cpuid(regs.rax, regs.rcx);
+			regs.rax = cpuid.a;
+			regs.rbx = cpuid.b;
+			regs.rcx = cpuid.c;
+			regs.rdx = cpuid.d;
+			break;
+		default:
+			assert_msg(false,
+				"Unexpected exit to L1, exit_reason: %s (0x%lx)",
+				exit_reason_description(vmcs_read(EXI_REASON)),
+				vmcs_read(EXI_REASON));
+		}
+		skip_exit_insn();
+		enter_guest();
+	}
+
+	assert_exit_reason(VMX_VMCALL);
+}
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -10763,5 +10811,6 @@ struct vmx_test vmx_tests[] = {
 	TEST(rdtsc_vmexit_diff_test),
 	TEST(vmx_mtf_test),
 	TEST(vmx_mtf_pdpte_test),
+	TEST(vmx_pf_exception_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.34.0.rc1.387.gb447b232ab-goog

