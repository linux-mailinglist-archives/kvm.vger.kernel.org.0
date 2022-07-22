Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1492457EA1E
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbiGVXC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGVXCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:02:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE87285FAF
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:51 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2eb7d137101so49444257b3.12
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FiHaCQhNDin1qEUasBSBeGavty7GfFuR81E7xhz62HI=;
        b=c1rAayLK7iuzyanIxPd2s407NjMvZS1gAWHbj2TnvKwoSzsJmhT2/rBhCxrzweD5bv
         goe/abBy7tIHD2PSW9W9YnBYWHFtXFPEamWfSvSBZq2LF7vTzdC7PyirE6re1S8KkYnZ
         1AJn7Tt3KERZ2wW11owVtqmqOZlc0m6dMwpkpTXh+j1tK0hRBz29NOXYSq0Ytm9thELs
         gN8CHKC3AqZVebQZ86fJSV7cGNQw6305dLKxSNP9nt7krqnR1itpC6y2U7KVV1R8MlAy
         e73WJF8p/Qw4XVS91CV+aHr0vsi6LVWd59DTfIH6QGon7pVTvQDEz98LU2Oh2LHM2NzL
         fBvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FiHaCQhNDin1qEUasBSBeGavty7GfFuR81E7xhz62HI=;
        b=Te73zh1jTFFdr9Mg/NqGf3WBF377SNL3pUuXM/qRBE0eZeFOxXpH4DYoYgHbJE/qI7
         sO2RS1KJ9zS/z21Qdj0Ng/XI6lEKdnUbkn93eDDFwyL5J+tS+GanMXTm7WpWFmCNvScp
         QZ6IWXwe0zUZ0q5SYcDuPad+hXIFaOXmrOgIyJZWW+vNYsqtvWdChXw7KmzTmN+IKeRS
         TV0Z0XsenY6f7km4jCiwyJn9u15gnlnRkbXJK7MgVxPrIXS17bjm+8I25GJfkm1Qutz8
         zm0YvKfo/vglSMhGdXAIwytPTHghrsk63U68eGI7xz6noVHUAmxahAOMr5lkzlNKGh9g
         vQYQ==
X-Gm-Message-State: AJIora9w+cB9McEPPgyXsnWVufw977hCYm1qw4BG9rLzJ0XKTjKODaLz
        N+ardgqSZMOgDZb0vk4R92ePjN24uuM=
X-Google-Smtp-Source: AGRyM1t+zExx1lMHouATchHS9iV5z5PPTi5UzQWlQv/TLkhoMSChcKNIDdA7jkdLJ9eLFt4X/Rtsejoq1PI=
X-Received: from avagin.kir.corp.google.com ([2620:15c:29:204:5863:d08b:b2f8:4a3e])
 (user=avagin job=sendgmr) by 2002:a25:7e42:0:b0:670:9c92:d1ab with SMTP id
 z63-20020a257e42000000b006709c92d1abmr1933632ybc.638.1658530971110; Fri, 22
 Jul 2022 16:02:51 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:02:37 -0700
In-Reply-To: <20220722230241.1944655-1-avagin@google.com>
Message-Id: <20220722230241.1944655-2-avagin@google.com>
Mime-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 1/5] kernel: add a new helper to execute system calls from
 kernel code
From:   Andrei Vagin <avagin@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrei Vagin <avagin@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helper will be used to implement a kvm hypercall to call host
system calls.

The new helper executes seccomp rules and calls trace_sys_{enter,exit}
hooks. But it intentionally doesn't call ptrace hooks because calling
syscalls are not linked with the current process state.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 arch/x86/entry/common.c        | 50 ++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/syscall.h |  1 +
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 6c2826417b33..7f4c172a9a4e 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -19,6 +19,7 @@
 #include <linux/nospec.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <trace/events/syscalls.h>
 
 #ifdef CONFIG_XEN_PV
 #include <xen/xen-ops.h>
@@ -37,6 +38,55 @@
 
 #ifdef CONFIG_X86_64
 
+/*
+ * do_ksyscall_64 executes a system call. This helper can be used from the
+ * kernel code.
+ */
+bool do_ksyscall_64(int nr, struct pt_regs *regs)
+{
+	struct task_struct *task = current;
+	unsigned long work = READ_ONCE(current_thread_info()->syscall_work);
+	/*
+	 * Convert negative numbers to very high and thus out of range
+	 * numbers for comparisons.
+	 */
+	unsigned int unr = nr;
+
+#ifdef CONFIG_IA32_EMULATION
+	if (task->thread_info.status & TS_COMPAT)
+		return false;
+#endif
+
+	if (work & SYSCALL_WORK_SECCOMP) {
+		struct seccomp_data sd;
+		unsigned long args[6];
+
+		sd.nr = nr;
+		sd.arch = AUDIT_ARCH_X86_64;
+		syscall_get_arguments(task, regs, args);
+		sd.args[0] = args[0];
+		sd.args[1] = args[1];
+		sd.args[2] = args[2];
+		sd.args[3] = args[3];
+		sd.args[4] = args[4];
+		sd.args[5] = args[5];
+		sd.instruction_pointer = regs->ip;
+		if (__secure_computing(&sd) == -1)
+			return false;
+	}
+
+	if (likely(unr >= NR_syscalls))
+		return false;
+
+	unr = array_index_nospec(unr, NR_syscalls);
+
+	trace_sys_enter(regs, unr);
+	regs->ax = sys_call_table[unr](regs);
+	trace_sys_exit(regs, syscall_get_return_value(task, regs));
+	return true;
+}
+EXPORT_SYMBOL_GPL(do_ksyscall_64);
+
 static __always_inline bool do_syscall_x64(struct pt_regs *regs, int nr)
 {
 	/*
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 5b85987a5e97..6cde1ddeb50b 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -126,6 +126,7 @@ static inline int syscall_get_arch(struct task_struct *task)
 		? AUDIT_ARCH_I386 : AUDIT_ARCH_X86_64;
 }
 
+bool do_ksyscall_64(int nr, struct pt_regs *regs);
 void do_syscall_64(struct pt_regs *regs, int nr);
 void do_int80_syscall_32(struct pt_regs *regs);
 long do_fast_syscall_32(struct pt_regs *regs);
-- 
2.37.1.359.gd136c6c3e2-goog

