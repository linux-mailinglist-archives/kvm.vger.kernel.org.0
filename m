Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7D959B696
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 00:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiHUWHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Aug 2022 18:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiHUWHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Aug 2022 18:07:37 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310D613F6D
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 15:07:36 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oPt6S-008mtx-Tu; Mon, 22 Aug 2022 00:07:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=RK1s0taGO++nplANa92qIki8dRPuyqqvr7YTRkDdbNs=; b=0wKtA/7Rqii11V1CKU/FtPgPBe
        ThqzJ87fiQe26RQRpCWtjyzm+9cQljGlPpQ5lalFtshpi15bH9UjJhHvI7mgwFc0H2jH6YQEpfbI2
        1liYjuU7TDAU+s9UKqzsTZ/xEsJv1swaYwAnIbCbD+g/dfmHhnu4MYMTXjs0ZBc6oa5yt6MxFqwbY
        Tep8MYMAN0ymSse5mn7ki7pOvQFew7V9swCCltgdoCeLiLhxcQVDehzMKpq54ghzGaDQszYJdrhVx
        QdCwRkAajrHDieR60L7B2pbdk4Do1WqkzKYVMF28oWKvH2xIULStctQwcqW2FSRti+el3ri4jUr4q
        B1PSG6Fg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oPt6S-0004tI-GC; Mon, 22 Aug 2022 00:07:32 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oPt6J-0005we-2G; Mon, 22 Aug 2022 00:07:23 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Date:   Mon, 22 Aug 2022 00:06:47 +0200
Message-Id: <20220821220647.1420411-1-mhal@rbox.co>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220821215900.1419215-1-mhal@rbox.co>
References: <20220821215900.1419215-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that CPU interruptibility due to POP SS is set correctly (and #DB
is suppressed).

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Initially I wanted to test #DB suppression with EFLAGS.TF=1, but it
turned out that making the emulator set ctxt->interruptibility like this

	asm volatile("pushf\n\t"
		     "push %[flags]\n\t"
		     "popf\n\t"
		     KVM_FEP "mov %[ss], %%ss\n\t"
		     "popf"
		     :
		     : [ss] "r" (read_ss()),
		       [flags] "r" (read_rflags() | X86_EFLAGS_TF)
		     : "memory");

results in "KVM: entry failed, hardware error 0x80000021".
kvm_intel.dump_invalid_vmcs=1 tells me at that moment

Interruptibility = 00000002
DebugExceptions = 0x0000000000000000

so perhaps it's related to the problem described in
https://lkml.kernel.org/kvm/20220120000624.655815-1-seanjc@google.com/ ?
That said, I don't know if combining FEP+blocking+TF+DB is a misuse on
my side, a bug, or a detail that happens to be unimplemented.

Anyway, the POP-SS blocking test avoids touching EFLAGS.TF by using
DR0/7.

Note that doing this the ASM_TRY() way would require extending
setup_idt() (to handle #DB) and introducing another ASM_TRY() variant
(one without the initial `movl $0, %%gs:4`).

 x86/Makefile.i386 |  3 ++-
 x86/popss.c       | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg |  4 ++++
 3 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 x86/popss.c

diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index 0a845e6..b570ae2 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -9,6 +9,7 @@ arch_LDFLAGS = -m elf_i386
 cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o
 
 tests = $(TEST_DIR)/taskswitch.$(exe) $(TEST_DIR)/taskswitch2.$(exe) \
-	$(TEST_DIR)/cmpxchg8b.$(exe) $(TEST_DIR)/la57.$(exe)
+	$(TEST_DIR)/cmpxchg8b.$(exe) $(TEST_DIR)/la57.$(exe) \
+	$(TEST_DIR)/popss.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
diff --git a/x86/popss.c b/x86/popss.c
new file mode 100644
index 0000000..7201f1e
--- /dev/null
+++ b/x86/popss.c
@@ -0,0 +1,59 @@
+#include <asm/debugreg.h>
+
+#include "processor.h"
+#include "libcflat.h"
+#include "vmalloc.h"
+#include "desc.h"
+
+static void test_pop_ss_blocking_handler(struct ex_regs *regs)
+{
+	extern char test_pop_ss_blocking_cont;
+
+	regs->rip = (ulong)&test_pop_ss_blocking_cont;
+}
+
+static void test_pop_ss_blocking(void)
+{
+	extern char db_blocked;
+	int success = 0;
+	handler old;
+
+	old = handle_exception(DB_VECTOR, test_pop_ss_blocking_handler);
+
+	write_dr0(&db_blocked);
+	write_dr7(DR7_FIXED_1 |
+		  DR7_GLOBAL_ENABLE_DRx(0) |
+		  DR7_EXECUTE_DRx(0) |
+		  DR7_LEN_1_DRx(0));
+
+	/*
+	 * The idea is that #DB on the instruction following POP SS should be
+	 * suppressed. If the exception is actually suppressed, `success` gets
+	 * set to 1, otherwise exception handler advances RIP away.
+	 */
+	asm volatile("push %[ss]\n\t"
+		     KVM_FEP "pop %%ss\n\t"
+		     "db_blocked: mov $1, %[success]\n\t"
+		     "test_pop_ss_blocking_cont:"
+		     : [success] "+g" (success)
+		     : [ss] "r" (read_ss())
+		     : "memory");
+
+	write_dr7(DR7_FIXED_1);
+	handle_exception(DB_VECTOR, old);
+
+	report(success, "#DB suppressed after POP SS");
+}
+
+int main(void)
+{
+	setup_vm();
+
+	if (is_fep_available())
+		test_pop_ss_blocking();
+	else
+		report_skip("skipping POP-SS blocking test, "
+			    "use kvm.force_emulation_prefix=1 to enable");
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed65185..8d4e917 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -305,6 +305,10 @@ extra_params = -cpu qemu64,+umip
 file = la57.flat
 arch = i386
 
+[popss]
+file = popss.flat
+arch = i386
+
 [vmx]
 file = vmx.flat
 extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test"
-- 
2.37.2

