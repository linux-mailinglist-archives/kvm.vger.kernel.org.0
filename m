Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FCF58289E
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiG0O32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiG0O31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540392BB2F
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:29:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E781061835
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 14:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD4BC43470;
        Wed, 27 Jul 2022 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658932165;
        bh=pwK8t3ZhZifpcL8U+bccSl4iVePkt7Udv7l8kQynp5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyht/bnuXjZeWoVDBLvttogFHIxBY58sqnMhrCU2JhZHkdQBr4H9t2MBmsnq0MbgN
         DOmHviZ00xYwvOdC38UT4Fjg2CiXPc2ymjlTtJL7VyD8UPEUii08QAFRwvIgCIJ/HQ
         FZgcTDL5mq63Z6H6NviXPnCsK3oNCwU25Ln4qfI4ZZLzOxC9P0Em+v4OQniWrrfBDd
         qo7x7MJrZOOfF6Uj7gEwP+qUfgkeWa/AgeCE86Ohlb03wRmfnLUU0/CmsYt/XlETr3
         vgozJKfTmpsS7gFiOnZFV4Z3ulrHtPG0e9+JJ3RNScSuKnXcNy31hXsxOt6gYPkgID
         jPdpfqtFkzUkw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oGi2N-00APjL-DX;
        Wed, 27 Jul 2022 15:29:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, broonie@kernel.org,
        madvenka@linux.microsoft.com, tabba@google.com,
        oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
        elver@google.com, keirf@google.com, yuzenghui@huawei.com,
        ardb@kernel.org, oupton@google.com, kernel-team@android.com
Subject: [PATCH 2/6] KVM: arm64: Move nVHE stacktrace unwinding into its own compilation unit
Date:   Wed, 27 Jul 2022 15:29:02 +0100
Message-Id: <20220727142906.1856759-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com, mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com, elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The unwinding code doesn't really belong to the exit handling
code. Instead, move it to a file (conveniently named stacktrace.c
to confuse the reviewer), and move all the stacktrace-related
stuff there.

It will be joined by more code very soon.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stacktrace/nvhe.h |   2 +
 arch/arm64/kvm/Makefile                  |   2 +-
 arch/arm64/kvm/handle_exit.c             |  98 ------------------
 arch/arm64/kvm/stacktrace.c              | 120 +++++++++++++++++++++++
 4 files changed, 123 insertions(+), 99 deletions(-)
 create mode 100644 arch/arm64/kvm/stacktrace.c

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 600dbc2220b6..8a5cb96d7143 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -172,5 +172,7 @@ static inline int notrace unwind_next(struct unwind_state *state)
 }
 NOKPROBE_SYMBOL(unwind_next);
 
+void kvm_nvhe_dump_backtrace(unsigned long hyp_offset);
+
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
 #endif	/* __ASM_STACKTRACE_NVHE_H */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index aa127ae9f675..5e33c2d4645a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_KVM) += hyp/
 
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
-	 guest.o debug.o reset.o sys_regs.o \
+	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
 	 arch_timer.o trng.o vmid.o \
 	 vgic/vgic.o vgic/vgic-init.o \
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index c14fc4ba4422..ef8b57953aa2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -319,104 +319,6 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
-/*
- * kvm_nvhe_dump_backtrace_entry - Symbolize and print an nVHE backtrace entry
- *
- * @arg    : the hypervisor offset, used for address translation
- * @where  : the program counter corresponding to the stack frame
- */
-static bool kvm_nvhe_dump_backtrace_entry(void *arg, unsigned long where)
-{
-	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
-	unsigned long hyp_offset = (unsigned long)arg;
-
-	/* Mask tags and convert to kern addr */
-	where = (where & va_mask) + hyp_offset;
-	kvm_err(" [<%016lx>] %pB\n", where, (void *)(where + kaslr_offset()));
-
-	return true;
-}
-
-static inline void kvm_nvhe_dump_backtrace_start(void)
-{
-	kvm_err("nVHE call trace:\n");
-}
-
-static inline void kvm_nvhe_dump_backtrace_end(void)
-{
-	kvm_err("---[ end nVHE call trace ]---\n");
-}
-
-/*
- * hyp_dump_backtrace - Dump the non-protected nVHE backtrace.
- *
- * @hyp_offset: hypervisor offset, used for address translation.
- *
- * The host can directly access HYP stack pages in non-protected
- * mode, so the unwinding is done directly from EL1. This removes
- * the need for shared buffers between host and hypervisor for
- * the stacktrace.
- */
-static void hyp_dump_backtrace(unsigned long hyp_offset)
-{
-	struct kvm_nvhe_stacktrace_info *stacktrace_info;
-	struct unwind_state state;
-
-	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
-
-	kvm_nvhe_unwind_init(&state, stacktrace_info->fp, stacktrace_info->pc);
-
-	kvm_nvhe_dump_backtrace_start();
-	unwind(&state, kvm_nvhe_dump_backtrace_entry, (void *)hyp_offset);
-	kvm_nvhe_dump_backtrace_end();
-}
-
-#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
-DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
-			 pkvm_stacktrace);
-
-/*
- * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
- *
- * @hyp_offset: hypervisor offset, used for address translation.
- *
- * Dumping of the pKVM HYP backtrace is done by reading the
- * stack addresses from the shared stacktrace buffer, since the
- * host cannot directly access hypervisor memory in protected
- * mode.
- */
-static void pkvm_dump_backtrace(unsigned long hyp_offset)
-{
-	unsigned long *stacktrace
-		= (unsigned long *) this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
-	int i, size = NVHE_STACKTRACE_SIZE / sizeof(long);
-
-	kvm_nvhe_dump_backtrace_start();
-	/* The saved stacktrace is terminated by a null entry */
-	for (i = 0; i < size && stacktrace[i]; i++)
-		kvm_nvhe_dump_backtrace_entry((void *)hyp_offset, stacktrace[i]);
-	kvm_nvhe_dump_backtrace_end();
-}
-#else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
-static void pkvm_dump_backtrace(unsigned long hyp_offset)
-{
-	kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE\n");
-}
-#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
-
-/*
- * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
- *
- * @hyp_offset: hypervisor offset, used for address translation.
- */
-static void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
-{
-	if (is_protected_kvm_enabled())
-		pkvm_dump_backtrace(hyp_offset);
-	else
-		hyp_dump_backtrace(hyp_offset);
-}
-
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
new file mode 100644
index 000000000000..9812aefdcfb4
--- /dev/null
+++ b/arch/arm64/kvm/stacktrace.c
@@ -0,0 +1,120 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * KVM nVHE hypervisor stack tracing support.
+ *
+ * The unwinder implementation depends on the nVHE mode:
+ *
+ *   1) Non-protected nVHE mode - the host can directly access the
+ *      HYP stack pages and unwind the HYP stack in EL1. This saves having
+ *      to allocate shared buffers for the host to read the unwinded
+ *      stacktrace.
+ *
+ *   2) pKVM (protected nVHE) mode - the host cannot directly access
+ *      the HYP memory. The stack is unwinded in EL2 and dumped to a shared
+ *      buffer where the host can read and print the stacktrace.
+ *
+ * Copyright (C) 2022 Google LLC
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include <asm/stacktrace/nvhe.h>
+
+/*
+ * kvm_nvhe_dump_backtrace_entry - Symbolize and print an nVHE backtrace entry
+ *
+ * @arg    : the hypervisor offset, used for address translation
+ * @where  : the program counter corresponding to the stack frame
+ */
+static bool kvm_nvhe_dump_backtrace_entry(void *arg, unsigned long where)
+{
+	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+	unsigned long hyp_offset = (unsigned long)arg;
+
+	/* Mask tags and convert to kern addr */
+	where = (where & va_mask) + hyp_offset;
+	kvm_err(" [<%016lx>] %pB\n", where, (void *)(where + kaslr_offset()));
+
+	return true;
+}
+
+static void kvm_nvhe_dump_backtrace_start(void)
+{
+	kvm_err("nVHE call trace:\n");
+}
+
+static void kvm_nvhe_dump_backtrace_end(void)
+{
+	kvm_err("---[ end nVHE call trace ]---\n");
+}
+
+/*
+ * hyp_dump_backtrace - Dump the non-protected nVHE backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ *
+ * The host can directly access HYP stack pages in non-protected
+ * mode, so the unwinding is done directly from EL1. This removes
+ * the need for shared buffers between host and hypervisor for
+ * the stacktrace.
+ */
+static void hyp_dump_backtrace(unsigned long hyp_offset)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info;
+	struct unwind_state state;
+
+	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+
+	kvm_nvhe_unwind_init(&state, stacktrace_info->fp, stacktrace_info->pc);
+
+	kvm_nvhe_dump_backtrace_start();
+	unwind(&state, kvm_nvhe_dump_backtrace_entry, (void *)hyp_offset);
+	kvm_nvhe_dump_backtrace_end();
+}
+
+#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
+			 pkvm_stacktrace);
+
+/*
+ * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ *
+ * Dumping of the pKVM HYP backtrace is done by reading the
+ * stack addresses from the shared stacktrace buffer, since the
+ * host cannot directly access hypervisor memory in protected
+ * mode.
+ */
+static void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	unsigned long *stacktrace
+		= (unsigned long *) this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
+	int i, size = NVHE_STACKTRACE_SIZE / sizeof(long);
+
+	kvm_nvhe_dump_backtrace_start();
+	/* The saved stacktrace is terminated by a null entry */
+	for (i = 0; i < size && stacktrace[i]; i++)
+		kvm_nvhe_dump_backtrace_entry((void *)hyp_offset, stacktrace[i]);
+	kvm_nvhe_dump_backtrace_end();
+}
+#else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE\n");
+}
+#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+
+/*
+ * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ */
+void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
+{
+	if (is_protected_kvm_enabled())
+		pkvm_dump_backtrace(hyp_offset);
+	else
+		hyp_dump_backtrace(hyp_offset);
+}
-- 
2.34.1

