Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF5C6A892A
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCBTJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCBTJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:15 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D6C35260
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:55 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso2524657wmq.1
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0Kn9OKT1TQEx0v0tI79gonDvUx2BQPcVJJf3idPjHc=;
        b=f4sKtOPmZUsLLUAunpIP+ACCCAT5c/PvN0xxPldEZCgh72Bmo/6Kqp7MglXCKLm91k
         BhjxD/W7ikdNVAJTBuhR4gMv22X37bKUpGoW7NNr9z8MQ1a45J3//2paWOXiJNKGuA3G
         8J+u815bWq9gwUXzrBxgZauPdg5/ghNWoV49/kjSRZZYdPMd1fTf5fmI+kijafutIQiR
         D1NSF0u5QFVdKmd3WJ8p69GqnLHwo+WSp3DM81cH/BURMihIhoKt1QFwKhqSpTap6XwR
         p/ydqTGC3YeAt7ms0NeREQnBtTTNR2WL86/mWMwiLSptiwbJYHSZX2+yfC5Gg+Gm3DZm
         x3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F0Kn9OKT1TQEx0v0tI79gonDvUx2BQPcVJJf3idPjHc=;
        b=zCS7p00sUBYqPdEYa7nb1JtdDEvAfJ+d6Lv7SKOcfGWyP5ZSoH3sun0PH0eUJubTQj
         oyEB4N+6avkDhfTZ887k15fKNfXbeldAbjQMg1N7BJyb+DGlUOEsnVuV1X+QkuqD7rtc
         fa6c/8X00gsqiH4iClqq+W/ctoXkPniLco02hQkvrPkyi/Qibv4myuMovOQiKhCYz+UM
         hJTyQAJZ9m+1QDIxDK8bILc3Z4HytoeEezNz1qBHfs6vBraBjEePfNGIN7gfldP3pHNW
         7iCdlGxGoGbrMbNnXhcuZq0wCEFIiMdA9A19350Wc5/nAQ7NIJb2RFMpdG7bpyDfL+00
         E2sA==
X-Gm-Message-State: AO0yUKXyLD0LDecPAEUF5VR/cdHH8OOhlHfqAWr0uGhCKEyVxn9oz+q6
        q/M5sf539TZXr8r5FIsY3w7ebw==
X-Google-Smtp-Source: AK7set8y6lU0E7o64Ye7NwCcI0Iou6OmUeSSQJO9dVUWmr/nai0yEsprlgubVBj1KYQ9/r9baRjjAQ==
X-Received: by 2002:a05:600c:3b14:b0:3ea:d620:57a7 with SMTP id m20-20020a05600c3b1400b003ead62057a7mr8869099wms.8.1677784133345;
        Thu, 02 Mar 2023 11:08:53 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id c16-20020a5d4cd0000000b002be0b1e556esm141148wrt.59.2023.03.02.11.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:52 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2A47C1FFBA;
        Thu,  2 Mar 2023 19:08:48 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v4 11/26] gdbstub: move chunks of user code into own files
Date:   Thu,  2 Mar 2023 19:08:31 +0000
Message-Id: <20230302190846.2593720-12-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302190846.2593720-1-alex.bennee@linaro.org>
References: <20230302190846.2593720-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The process was pretty similar to the softmmu move except we take the
time to split stuff between user.c and user-target.c to avoid as much
target specific compilation as possible. We also start to make use of
our shiny new header scheme so the user-only helpers can be included
without the rest of the exec/gsbstub.h cruft.

As before we split some functions into user and softmmu versions

Reviewed-by: Fabiano Rosas <farosas@suse.de>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - separate splitting of functions
  - create user.h here
v3
  - rebase cleanups
  - bring forward hunk to ensure all user-mode targets covered
v4
  - checkpatch cleanup
---
 MAINTAINERS            |   1 +
 gdbstub/internals.h    |  18 ++
 include/exec/gdbstub.h |  21 --
 include/gdbstub/user.h |  43 +++
 gdbstub/gdbstub.c      | 678 +----------------------------------------
 gdbstub/softmmu.c      |  90 ++++++
 gdbstub/user-target.c  | 283 +++++++++++++++++
 gdbstub/user.c         | 344 +++++++++++++++++++++
 linux-user/main.c      |   1 +
 linux-user/signal.c    |   2 +-
 gdbstub/meson.build    |   3 +
 11 files changed, 788 insertions(+), 696 deletions(-)
 create mode 100644 include/gdbstub/user.h
 create mode 100644 gdbstub/user-target.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 234800e3dc..c7a8e2307f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2735,6 +2735,7 @@ S: Maintained
 F: docs/system/gdb.rst
 F: gdbstub/*
 F: include/exec/gdbstub.h
+F: include/gdbstub/*
 F: gdb-xml/
 F: tests/tcg/multiarch/gdbstub/
 F: scripts/feature_to_c.sh
diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index 83989af859..6bd6a05657 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -117,6 +117,22 @@ int gdb_get_cpu_index(CPUState *cpu);
 
 void gdb_create_default_process(GDBState *s);
 
+/* signal mapping, common for softmmu, specialised for user-mode */
+int gdb_signal_to_target(int sig);
+int gdb_target_signal_to_gdb(int sig);
+
+int gdb_get_char(void); /* user only */
+
+/**
+ * gdb_continue() - handle continue in mode specific way.
+ */
+void gdb_continue(void);
+
+/**
+ * gdb_continue_partial() - handle partial continue in mode specific way.
+ */
+int gdb_continue_partial(char *newstates);
+
 /*
  * Helpers with separate softmmu and user implementations
  */
@@ -149,6 +165,8 @@ typedef union GdbCmdVariant {
 #define get_param(p, i)    (&g_array_index(p, GdbCmdVariant, i))
 
 void gdb_handle_query_rcmd(GArray *params, void *user_ctx); /* softmmu */
+void gdb_handle_query_offsets(GArray *params, void *user_ctx); /* user */
+void gdb_handle_query_xfer_auxv(GArray *params, void *user_ctx); /*user */
 
 /*
  * Break/Watch point support - there is an implementation for softmmu
diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index 1636fb3841..8fff5450ed 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -103,27 +103,6 @@ void gdb_do_syscall(gdb_syscall_complete_cb cb, const char *fmt, ...);
 void gdb_do_syscallv(gdb_syscall_complete_cb cb, const char *fmt, va_list va);
 int use_gdb_syscalls(void);
 
-#ifdef CONFIG_USER_ONLY
-/**
- * gdb_handlesig: yield control to gdb
- * @cpu: CPU
- * @sig: if non-zero, the signal number which caused us to stop
- *
- * This function yields control to gdb, when a user-mode-only target
- * needs to stop execution. If @sig is non-zero, then we will send a
- * stop packet to tell gdb that we have stopped because of this signal.
- *
- * This function will block (handling protocol requests from gdb)
- * until gdb tells us to continue target execution. When it does
- * return, the return value is a signal to deliver to the target,
- * or 0 if no signal should be delivered, ie the signal that caused
- * us to stop should be ignored.
- */
-int gdb_handlesig(CPUState *, int);
-void gdb_signalled(CPUArchState *, int);
-void gdbserver_fork(CPUState *);
-#endif
-
 /* Get or set a register.  Returns the size of the register.  */
 typedef int (*gdb_get_reg_cb)(CPUArchState *env, GByteArray *buf, int reg);
 typedef int (*gdb_set_reg_cb)(CPUArchState *env, uint8_t *buf, int reg);
diff --git a/include/gdbstub/user.h b/include/gdbstub/user.h
new file mode 100644
index 0000000000..d392e510c5
--- /dev/null
+++ b/include/gdbstub/user.h
@@ -0,0 +1,43 @@
+/*
+ * gdbstub user-mode only APIs
+ *
+ * Copyright (c) 2022 Linaro Ltd
+ *
+ * SPDX-License-Identifier: LGPL-2.0+
+ */
+
+#ifndef GDBSTUB_USER_H
+#define GDBSTUB_USER_H
+
+/**
+ * gdb_handlesig() - yield control to gdb
+ * @cpu: CPU
+ * @sig: if non-zero, the signal number which caused us to stop
+ *
+ * This function yields control to gdb, when a user-mode-only target
+ * needs to stop execution. If @sig is non-zero, then we will send a
+ * stop packet to tell gdb that we have stopped because of this signal.
+ *
+ * This function will block (handling protocol requests from gdb)
+ * until gdb tells us to continue target execution. When it does
+ * return, the return value is a signal to deliver to the target,
+ * or 0 if no signal should be delivered, ie the signal that caused
+ * us to stop should be ignored.
+ */
+int gdb_handlesig(CPUState *, int);
+
+/**
+ * gdb_signalled() - inform remote gdb of sig exit
+ * @as: current CPUArchState
+ * @sig: signal number
+ */
+void gdb_signalled(CPUArchState *as, int sig);
+
+/**
+ * gdbserver_fork() - disable gdb stub for child processes.
+ * @cs: CPU
+ */
+void gdbserver_fork(CPUState *cs);
+
+
+#endif /* GDBSTUB_USER_H */
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 4b939c689c..6907bdc99c 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -30,13 +30,12 @@
 #include "trace.h"
 #include "exec/gdbstub.h"
 #ifdef CONFIG_USER_ONLY
-#include "qemu.h"
+#include "gdbstub/user.h"
 #else
 #include "hw/cpu/cluster.h"
 #include "hw/boards.h"
 #endif
 
-#include "qemu/sockets.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/runstate.h"
 #include "semihosting/semihost.h"
@@ -80,223 +79,6 @@ static inline int target_memory_rw_debug(CPUState *cpu, target_ulong addr,
     return cpu_memory_rw_debug(cpu, addr, buf, len, is_write);
 }
 
-/*
- * Return the GDB index for a given vCPU state.
- *
- * For user mode this is simply the thread id.
- */
-#if defined(CONFIG_USER_ONLY)
-int gdb_get_cpu_index(CPUState *cpu)
-{
-    TaskState *ts = (TaskState *) cpu->opaque;
-    return ts ? ts->ts_tid : -1;
-}
-#endif
-
-#ifdef CONFIG_USER_ONLY
-
-/* Map target signal numbers to GDB protocol signal numbers and vice
- * versa.  For user emulation's currently supported systems, we can
- * assume most signals are defined.
- */
-
-static int gdb_signal_table[] = {
-    0,
-    TARGET_SIGHUP,
-    TARGET_SIGINT,
-    TARGET_SIGQUIT,
-    TARGET_SIGILL,
-    TARGET_SIGTRAP,
-    TARGET_SIGABRT,
-    -1, /* SIGEMT */
-    TARGET_SIGFPE,
-    TARGET_SIGKILL,
-    TARGET_SIGBUS,
-    TARGET_SIGSEGV,
-    TARGET_SIGSYS,
-    TARGET_SIGPIPE,
-    TARGET_SIGALRM,
-    TARGET_SIGTERM,
-    TARGET_SIGURG,
-    TARGET_SIGSTOP,
-    TARGET_SIGTSTP,
-    TARGET_SIGCONT,
-    TARGET_SIGCHLD,
-    TARGET_SIGTTIN,
-    TARGET_SIGTTOU,
-    TARGET_SIGIO,
-    TARGET_SIGXCPU,
-    TARGET_SIGXFSZ,
-    TARGET_SIGVTALRM,
-    TARGET_SIGPROF,
-    TARGET_SIGWINCH,
-    -1, /* SIGLOST */
-    TARGET_SIGUSR1,
-    TARGET_SIGUSR2,
-#ifdef TARGET_SIGPWR
-    TARGET_SIGPWR,
-#else
-    -1,
-#endif
-    -1, /* SIGPOLL */
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-#ifdef __SIGRTMIN
-    __SIGRTMIN + 1,
-    __SIGRTMIN + 2,
-    __SIGRTMIN + 3,
-    __SIGRTMIN + 4,
-    __SIGRTMIN + 5,
-    __SIGRTMIN + 6,
-    __SIGRTMIN + 7,
-    __SIGRTMIN + 8,
-    __SIGRTMIN + 9,
-    __SIGRTMIN + 10,
-    __SIGRTMIN + 11,
-    __SIGRTMIN + 12,
-    __SIGRTMIN + 13,
-    __SIGRTMIN + 14,
-    __SIGRTMIN + 15,
-    __SIGRTMIN + 16,
-    __SIGRTMIN + 17,
-    __SIGRTMIN + 18,
-    __SIGRTMIN + 19,
-    __SIGRTMIN + 20,
-    __SIGRTMIN + 21,
-    __SIGRTMIN + 22,
-    __SIGRTMIN + 23,
-    __SIGRTMIN + 24,
-    __SIGRTMIN + 25,
-    __SIGRTMIN + 26,
-    __SIGRTMIN + 27,
-    __SIGRTMIN + 28,
-    __SIGRTMIN + 29,
-    __SIGRTMIN + 30,
-    __SIGRTMIN + 31,
-    -1, /* SIGCANCEL */
-    __SIGRTMIN,
-    __SIGRTMIN + 32,
-    __SIGRTMIN + 33,
-    __SIGRTMIN + 34,
-    __SIGRTMIN + 35,
-    __SIGRTMIN + 36,
-    __SIGRTMIN + 37,
-    __SIGRTMIN + 38,
-    __SIGRTMIN + 39,
-    __SIGRTMIN + 40,
-    __SIGRTMIN + 41,
-    __SIGRTMIN + 42,
-    __SIGRTMIN + 43,
-    __SIGRTMIN + 44,
-    __SIGRTMIN + 45,
-    __SIGRTMIN + 46,
-    __SIGRTMIN + 47,
-    __SIGRTMIN + 48,
-    __SIGRTMIN + 49,
-    __SIGRTMIN + 50,
-    __SIGRTMIN + 51,
-    __SIGRTMIN + 52,
-    __SIGRTMIN + 53,
-    __SIGRTMIN + 54,
-    __SIGRTMIN + 55,
-    __SIGRTMIN + 56,
-    __SIGRTMIN + 57,
-    __SIGRTMIN + 58,
-    __SIGRTMIN + 59,
-    __SIGRTMIN + 60,
-    __SIGRTMIN + 61,
-    __SIGRTMIN + 62,
-    __SIGRTMIN + 63,
-    __SIGRTMIN + 64,
-    __SIGRTMIN + 65,
-    __SIGRTMIN + 66,
-    __SIGRTMIN + 67,
-    __SIGRTMIN + 68,
-    __SIGRTMIN + 69,
-    __SIGRTMIN + 70,
-    __SIGRTMIN + 71,
-    __SIGRTMIN + 72,
-    __SIGRTMIN + 73,
-    __SIGRTMIN + 74,
-    __SIGRTMIN + 75,
-    __SIGRTMIN + 76,
-    __SIGRTMIN + 77,
-    __SIGRTMIN + 78,
-    __SIGRTMIN + 79,
-    __SIGRTMIN + 80,
-    __SIGRTMIN + 81,
-    __SIGRTMIN + 82,
-    __SIGRTMIN + 83,
-    __SIGRTMIN + 84,
-    __SIGRTMIN + 85,
-    __SIGRTMIN + 86,
-    __SIGRTMIN + 87,
-    __SIGRTMIN + 88,
-    __SIGRTMIN + 89,
-    __SIGRTMIN + 90,
-    __SIGRTMIN + 91,
-    __SIGRTMIN + 92,
-    __SIGRTMIN + 93,
-    __SIGRTMIN + 94,
-    __SIGRTMIN + 95,
-    -1, /* SIGINFO */
-    -1, /* UNKNOWN */
-    -1, /* DEFAULT */
-    -1,
-    -1,
-    -1,
-    -1,
-    -1,
-    -1
-#endif
-};
-#else
-/* In system mode we only need SIGINT and SIGTRAP; other signals
-   are not yet supported.  */
-
-enum {
-    TARGET_SIGINT = 2,
-    TARGET_SIGTRAP = 5
-};
-
-static int gdb_signal_table[] = {
-    -1,
-    -1,
-    TARGET_SIGINT,
-    -1,
-    -1,
-    TARGET_SIGTRAP
-};
-#endif
-
-#ifdef CONFIG_USER_ONLY
-static int target_signal_to_gdb (int sig)
-{
-    int i;
-    for (i = 0; i < ARRAY_SIZE (gdb_signal_table); i++)
-        if (gdb_signal_table[i] == sig)
-            return i;
-    return GDB_SIGNAL_UNKNOWN;
-}
-#endif
-
-static int gdb_signal_to_target (int sig)
-{
-    if (sig < ARRAY_SIZE (gdb_signal_table))
-        return gdb_signal_table[sig];
-    else
-        return -1;
-}
-
 typedef struct GDBRegisterState {
     int base_reg;
     int num_regs;
@@ -306,15 +88,6 @@ typedef struct GDBRegisterState {
     struct GDBRegisterState *next;
 } GDBRegisterState;
 
-#ifdef CONFIG_USER_ONLY
-typedef struct {
-    int fd;
-    char *socket_path;
-    int running_state;
-} GDBUserState;
-static GDBUserState gdbserver_user_state;
-#endif
-
 GDBState gdbserver_state;
 
 void gdb_init_gdbserver_state(void)
@@ -338,34 +111,6 @@ void gdb_init_gdbserver_state(void)
 
 bool gdb_has_xml;
 
-#ifdef CONFIG_USER_ONLY
-
-static int get_char(void)
-{
-    uint8_t ch;
-    int ret;
-
-    for(;;) {
-        ret = recv(gdbserver_user_state.fd, &ch, 1, 0);
-        if (ret < 0) {
-            if (errno == ECONNRESET) {
-                gdbserver_user_state.fd = -1;
-            }
-            if (errno != EINTR) {
-                return -1;
-            }
-        } else if (ret == 0) {
-            close(gdbserver_user_state.fd);
-            gdbserver_user_state.fd = -1;
-            return -1;
-        } else {
-            break;
-        }
-    }
-    return ch;
-}
-#endif
-
 /*
  * Return true if there is a GDB currently connected to the stub
  * and attached to a CPU
@@ -410,104 +155,6 @@ static bool stub_can_reverse(void)
 #endif
 }
 
-/* Resume execution.  */
-static void gdb_continue(void)
-{
-
-#ifdef CONFIG_USER_ONLY
-    gdbserver_user_state.running_state = 1;
-    trace_gdbstub_op_continue();
-#else
-    if (!runstate_needs_reset()) {
-        trace_gdbstub_op_continue();
-        vm_start();
-    }
-#endif
-}
-
-/*
- * Resume execution, per CPU actions. For user-mode emulation it's
- * equivalent to gdb_continue.
- */
-static int gdb_continue_partial(char *newstates)
-{
-    CPUState *cpu;
-    int res = 0;
-#ifdef CONFIG_USER_ONLY
-    /*
-     * This is not exactly accurate, but it's an improvement compared to the
-     * previous situation, where only one CPU would be single-stepped.
-     */
-    CPU_FOREACH(cpu) {
-        if (newstates[cpu->cpu_index] == 's') {
-            trace_gdbstub_op_stepping(cpu->cpu_index);
-            cpu_single_step(cpu, gdbserver_state.sstep_flags);
-        }
-    }
-    gdbserver_user_state.running_state = 1;
-#else
-    int flag = 0;
-
-    if (!runstate_needs_reset()) {
-        bool step_requested = false;
-        CPU_FOREACH(cpu) {
-            if (newstates[cpu->cpu_index] == 's') {
-                step_requested = true;
-                break;
-            }
-        }
-
-        if (vm_prepare_start(step_requested)) {
-            return 0;
-        }
-
-        CPU_FOREACH(cpu) {
-            switch (newstates[cpu->cpu_index]) {
-            case 0:
-            case 1:
-                break; /* nothing to do here */
-            case 's':
-                trace_gdbstub_op_stepping(cpu->cpu_index);
-                cpu_single_step(cpu, gdbserver_state.sstep_flags);
-                cpu_resume(cpu);
-                flag = 1;
-                break;
-            case 'c':
-                trace_gdbstub_op_continue_cpu(cpu->cpu_index);
-                cpu_resume(cpu);
-                flag = 1;
-                break;
-            default:
-                res = -1;
-                break;
-            }
-        }
-    }
-    if (flag) {
-        qemu_clock_enable(QEMU_CLOCK_VIRTUAL, true);
-    }
-#endif
-    return res;
-}
-
-#ifdef CONFIG_USER_ONLY
-void gdb_put_buffer(const uint8_t *buf, int len)
-{
-    int ret;
-
-    while (len > 0) {
-        ret = send(gdbserver_user_state.fd, buf, len, 0);
-        if (ret < 0) {
-            if (errno != EINTR)
-                return;
-        } else {
-            buf += ret;
-            len -= ret;
-        }
-    }
-}
-#endif
-
 /* writes 2*len+1 bytes in buf */
 void gdb_memtohex(GString *buf, const uint8_t *mem, int len)
 {
@@ -593,7 +240,7 @@ int gdb_put_packet_binary(const char *buf, int len, bool dump)
                    gdbserver_state.last_packet->len);
 
 #ifdef CONFIG_USER_ONLY
-        i = get_char();
+        i = gdb_get_char();
         if (i < 0)
             return -1;
         if (i == '+')
@@ -1950,23 +1597,6 @@ static void handle_query_thread_extra(GArray *params, void *user_ctx)
     gdb_put_strbuf();
 }
 
-#ifdef CONFIG_USER_ONLY
-static void handle_query_offsets(GArray *params, void *user_ctx)
-{
-    TaskState *ts;
-
-    ts = gdbserver_state.c_cpu->opaque;
-    g_string_printf(gdbserver_state.str_buf,
-                    "Text=" TARGET_ABI_FMT_lx
-                    ";Data=" TARGET_ABI_FMT_lx
-                    ";Bss=" TARGET_ABI_FMT_lx,
-                    ts->info->code_offset,
-                    ts->info->data_offset,
-                    ts->info->data_offset);
-    gdb_put_strbuf();
-}
-#endif
-
 static void handle_query_supported(GArray *params, void *user_ctx)
 {
     CPUClass *cc;
@@ -2049,53 +1679,6 @@ static void handle_query_xfer_features(GArray *params, void *user_ctx)
                       gdbserver_state.str_buf->len, true);
 }
 
-#if defined(CONFIG_USER_ONLY) && defined(CONFIG_LINUX_USER)
-static void handle_query_xfer_auxv(GArray *params, void *user_ctx)
-{
-    TaskState *ts;
-    unsigned long offset, len, saved_auxv, auxv_len;
-
-    if (params->len < 2) {
-        gdb_put_packet("E22");
-        return;
-    }
-
-    offset = get_param(params, 0)->val_ul;
-    len = get_param(params, 1)->val_ul;
-    ts = gdbserver_state.c_cpu->opaque;
-    saved_auxv = ts->info->saved_auxv;
-    auxv_len = ts->info->auxv_len;
-
-    if (offset >= auxv_len) {
-        gdb_put_packet("E00");
-        return;
-    }
-
-    if (len > (MAX_PACKET_LENGTH - 5) / 2) {
-        len = (MAX_PACKET_LENGTH - 5) / 2;
-    }
-
-    if (len < auxv_len - offset) {
-        g_string_assign(gdbserver_state.str_buf, "m");
-    } else {
-        g_string_assign(gdbserver_state.str_buf, "l");
-        len = auxv_len - offset;
-    }
-
-    g_byte_array_set_size(gdbserver_state.mem_buf, len);
-    if (target_memory_rw_debug(gdbserver_state.g_cpu, saved_auxv + offset,
-                               gdbserver_state.mem_buf->data, len, false)) {
-        gdb_put_packet("E14");
-        return;
-    }
-
-    gdb_memtox(gdbserver_state.str_buf,
-               (const char *)gdbserver_state.mem_buf->data, len);
-    gdb_put_packet_binary(gdbserver_state.str_buf->str,
-                          gdbserver_state.str_buf->len, true);
-}
-#endif
-
 static void handle_query_attached(GArray *params, void *user_ctx)
 {
     gdb_put_packet(GDB_ATTACHED);
@@ -2173,7 +1756,7 @@ static const GdbCmdParseEntry gdb_gen_query_table[] = {
     },
 #ifdef CONFIG_USER_ONLY
     {
-        .handler = handle_query_offsets,
+        .handler = gdb_handle_query_offsets,
         .cmd = "Offsets",
     },
 #else
@@ -2203,7 +1786,7 @@ static const GdbCmdParseEntry gdb_gen_query_table[] = {
     },
 #if defined(CONFIG_USER_ONLY) && defined(CONFIG_LINUX_USER)
     {
-        .handler = handle_query_xfer_auxv,
+        .handler = gdb_handle_query_xfer_auxv,
         .cmd = "Xfer:auxv:read::",
         .cmd_startswith = 1,
         .schema = "l,l0"
@@ -2791,29 +2374,6 @@ void gdb_read_byte(uint8_t ch)
     }
 }
 
-#ifdef CONFIG_USER_ONLY
-/* Tell the remote gdb that the process has exited.  */
-void gdb_exit(int code)
-{
-    char buf[4];
-
-    if (!gdbserver_state.init) {
-        return;
-    }
-    if (gdbserver_user_state.socket_path) {
-        unlink(gdbserver_user_state.socket_path);
-    }
-    if (gdbserver_user_state.fd < 0) {
-        return;
-    }
-
-    trace_gdbstub_op_exiting((uint8_t)code);
-
-    snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
-    gdb_put_packet(buf);
-}
-#endif
-
 /*
  * Create the process that will contain all the "orphan" CPUs (that are not
  * part of a CPU cluster). Note that if this process contains no CPUs, it won't
@@ -2839,233 +2399,3 @@ void gdb_create_default_process(GDBState *s)
     process->target_xml[0] = '\0';
 }
 
-#ifdef CONFIG_USER_ONLY
-int
-gdb_handlesig(CPUState *cpu, int sig)
-{
-    char buf[256];
-    int n;
-
-    if (!gdbserver_state.init || gdbserver_user_state.fd < 0) {
-        return sig;
-    }
-
-    /* disable single step if it was enabled */
-    cpu_single_step(cpu, 0);
-    tb_flush(cpu);
-
-    if (sig != 0) {
-        gdb_set_stop_cpu(cpu);
-        g_string_printf(gdbserver_state.str_buf,
-                        "T%02xthread:", target_signal_to_gdb(sig));
-        gdb_append_thread_id(cpu, gdbserver_state.str_buf);
-        g_string_append_c(gdbserver_state.str_buf, ';');
-        gdb_put_strbuf();
-    }
-    /*
-     * gdb_put_packet() might have detected that the peer terminated the
-     * connection.
-     */
-    if (gdbserver_user_state.fd < 0) {
-        return sig;
-    }
-
-    sig = 0;
-    gdbserver_state.state = RS_IDLE;
-    gdbserver_user_state.running_state = 0;
-    while (gdbserver_user_state.running_state == 0) {
-        n = read(gdbserver_user_state.fd, buf, 256);
-        if (n > 0) {
-            int i;
-
-            for (i = 0; i < n; i++) {
-                gdb_read_byte(buf[i]);
-            }
-        } else {
-            /* XXX: Connection closed.  Should probably wait for another
-               connection before continuing.  */
-            if (n == 0) {
-                close(gdbserver_user_state.fd);
-            }
-            gdbserver_user_state.fd = -1;
-            return sig;
-        }
-    }
-    sig = gdbserver_state.signal;
-    gdbserver_state.signal = 0;
-    return sig;
-}
-
-/* Tell the remote gdb that the process has exited due to SIG.  */
-void gdb_signalled(CPUArchState *env, int sig)
-{
-    char buf[4];
-
-    if (!gdbserver_state.init || gdbserver_user_state.fd < 0) {
-        return;
-    }
-
-    snprintf(buf, sizeof(buf), "X%02x", target_signal_to_gdb(sig));
-    gdb_put_packet(buf);
-}
-
-static void gdb_accept_init(int fd)
-{
-    gdb_init_gdbserver_state();
-    gdb_create_default_process(&gdbserver_state);
-    gdbserver_state.processes[0].attached = true;
-    gdbserver_state.c_cpu = gdb_first_attached_cpu();
-    gdbserver_state.g_cpu = gdbserver_state.c_cpu;
-    gdbserver_user_state.fd = fd;
-    gdb_has_xml = false;
-}
-
-static bool gdb_accept_socket(int gdb_fd)
-{
-    int fd;
-
-    for(;;) {
-        fd = accept(gdb_fd, NULL, NULL);
-        if (fd < 0 && errno != EINTR) {
-            perror("accept socket");
-            return false;
-        } else if (fd >= 0) {
-            qemu_set_cloexec(fd);
-            break;
-        }
-    }
-
-    gdb_accept_init(fd);
-    return true;
-}
-
-static int gdbserver_open_socket(const char *path)
-{
-    struct sockaddr_un sockaddr = {};
-    int fd, ret;
-
-    fd = socket(AF_UNIX, SOCK_STREAM, 0);
-    if (fd < 0) {
-        perror("create socket");
-        return -1;
-    }
-
-    sockaddr.sun_family = AF_UNIX;
-    pstrcpy(sockaddr.sun_path, sizeof(sockaddr.sun_path) - 1, path);
-    ret = bind(fd, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
-    if (ret < 0) {
-        perror("bind socket");
-        close(fd);
-        return -1;
-    }
-    ret = listen(fd, 1);
-    if (ret < 0) {
-        perror("listen socket");
-        close(fd);
-        return -1;
-    }
-
-    return fd;
-}
-
-static bool gdb_accept_tcp(int gdb_fd)
-{
-    struct sockaddr_in sockaddr = {};
-    socklen_t len;
-    int fd;
-
-    for(;;) {
-        len = sizeof(sockaddr);
-        fd = accept(gdb_fd, (struct sockaddr *)&sockaddr, &len);
-        if (fd < 0 && errno != EINTR) {
-            perror("accept");
-            return false;
-        } else if (fd >= 0) {
-            qemu_set_cloexec(fd);
-            break;
-        }
-    }
-
-    /* set short latency */
-    if (socket_set_nodelay(fd)) {
-        perror("setsockopt");
-        close(fd);
-        return false;
-    }
-
-    gdb_accept_init(fd);
-    return true;
-}
-
-static int gdbserver_open_port(int port)
-{
-    struct sockaddr_in sockaddr;
-    int fd, ret;
-
-    fd = socket(PF_INET, SOCK_STREAM, 0);
-    if (fd < 0) {
-        perror("socket");
-        return -1;
-    }
-    qemu_set_cloexec(fd);
-
-    socket_set_fast_reuse(fd);
-
-    sockaddr.sin_family = AF_INET;
-    sockaddr.sin_port = htons(port);
-    sockaddr.sin_addr.s_addr = 0;
-    ret = bind(fd, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
-    if (ret < 0) {
-        perror("bind");
-        close(fd);
-        return -1;
-    }
-    ret = listen(fd, 1);
-    if (ret < 0) {
-        perror("listen");
-        close(fd);
-        return -1;
-    }
-
-    return fd;
-}
-
-int gdbserver_start(const char *port_or_path)
-{
-    int port = g_ascii_strtoull(port_or_path, NULL, 10);
-    int gdb_fd;
-
-    if (port > 0) {
-        gdb_fd = gdbserver_open_port(port);
-    } else {
-        gdb_fd = gdbserver_open_socket(port_or_path);
-    }
-
-    if (gdb_fd < 0) {
-        return -1;
-    }
-
-    if (port > 0 && gdb_accept_tcp(gdb_fd)) {
-        return 0;
-    } else if (gdb_accept_socket(gdb_fd)) {
-        gdbserver_user_state.socket_path = g_strdup(port_or_path);
-        return 0;
-    }
-
-    /* gone wrong */
-    close(gdb_fd);
-    return -1;
-}
-
-/* Disable gdb stub for child processes.  */
-void gdbserver_fork(CPUState *cpu)
-{
-    if (!gdbserver_state.init || gdbserver_user_state.fd < 0) {
-        return;
-    }
-    close(gdbserver_user_state.fd);
-    gdbserver_user_state.fd = -1;
-    cpu_breakpoint_remove_all(cpu, BP_GDB);
-    cpu_watchpoint_remove_all(cpu, BP_GDB);
-}
-#endif
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index 86a94f1519..a6c196ade6 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -434,6 +434,96 @@ void gdb_handle_query_rcmd(GArray *params, void *user_ctx)
     gdb_put_packet("OK");
 }
 
+/*
+ * Execution state helpers
+ */
+
+void gdb_continue(void)
+{
+    if (!runstate_needs_reset()) {
+        trace_gdbstub_op_continue();
+        vm_start();
+    }
+}
+
+/*
+ * Resume execution, per CPU actions.
+ */
+int gdb_continue_partial(char *newstates)
+{
+    CPUState *cpu;
+    int res = 0;
+    int flag = 0;
+
+    if (!runstate_needs_reset()) {
+        bool step_requested = false;
+        CPU_FOREACH(cpu) {
+            if (newstates[cpu->cpu_index] == 's') {
+                step_requested = true;
+                break;
+            }
+        }
+
+        if (vm_prepare_start(step_requested)) {
+            return 0;
+        }
+
+        CPU_FOREACH(cpu) {
+            switch (newstates[cpu->cpu_index]) {
+            case 0:
+            case 1:
+                break; /* nothing to do here */
+            case 's':
+                trace_gdbstub_op_stepping(cpu->cpu_index);
+                cpu_single_step(cpu, gdbserver_state.sstep_flags);
+                cpu_resume(cpu);
+                flag = 1;
+                break;
+            case 'c':
+                trace_gdbstub_op_continue_cpu(cpu->cpu_index);
+                cpu_resume(cpu);
+                flag = 1;
+                break;
+            default:
+                res = -1;
+                break;
+            }
+        }
+    }
+    if (flag) {
+        qemu_clock_enable(QEMU_CLOCK_VIRTUAL, true);
+    }
+    return res;
+}
+
+/*
+ * Signal Handling - in system mode we only need SIGINT and SIGTRAP; other
+ * signals are not yet supported.
+ */
+
+enum {
+    TARGET_SIGINT = 2,
+    TARGET_SIGTRAP = 5
+};
+
+static int gdb_signal_table[] = {
+    -1,
+    -1,
+    TARGET_SIGINT,
+    -1,
+    -1,
+    TARGET_SIGTRAP
+};
+
+int gdb_signal_to_target(int sig)
+{
+    if (sig < ARRAY_SIZE(gdb_signal_table)) {
+        return gdb_signal_table[sig];
+    } else {
+        return -1;
+    }
+}
+
 /*
  * Break/Watch point helpers
  */
diff --git a/gdbstub/user-target.c b/gdbstub/user-target.c
new file mode 100644
index 0000000000..fa0e59ec9a
--- /dev/null
+++ b/gdbstub/user-target.c
@@ -0,0 +1,283 @@
+/*
+ * Target specific user-mode handling
+ *
+ * Copyright (c) 2003-2005 Fabrice Bellard
+ * Copyright (c) 2022 Linaro Ltd
+ *
+ * SPDX-License-Identifier: LGPL-2.0+
+ */
+
+#include "qemu/osdep.h"
+#include "exec/gdbstub.h"
+#include "qemu.h"
+#include "internals.h"
+
+/*
+ * Map target signal numbers to GDB protocol signal numbers and vice
+ * versa.  For user emulation's currently supported systems, we can
+ * assume most signals are defined.
+ */
+
+static int gdb_signal_table[] = {
+    0,
+    TARGET_SIGHUP,
+    TARGET_SIGINT,
+    TARGET_SIGQUIT,
+    TARGET_SIGILL,
+    TARGET_SIGTRAP,
+    TARGET_SIGABRT,
+    -1, /* SIGEMT */
+    TARGET_SIGFPE,
+    TARGET_SIGKILL,
+    TARGET_SIGBUS,
+    TARGET_SIGSEGV,
+    TARGET_SIGSYS,
+    TARGET_SIGPIPE,
+    TARGET_SIGALRM,
+    TARGET_SIGTERM,
+    TARGET_SIGURG,
+    TARGET_SIGSTOP,
+    TARGET_SIGTSTP,
+    TARGET_SIGCONT,
+    TARGET_SIGCHLD,
+    TARGET_SIGTTIN,
+    TARGET_SIGTTOU,
+    TARGET_SIGIO,
+    TARGET_SIGXCPU,
+    TARGET_SIGXFSZ,
+    TARGET_SIGVTALRM,
+    TARGET_SIGPROF,
+    TARGET_SIGWINCH,
+    -1, /* SIGLOST */
+    TARGET_SIGUSR1,
+    TARGET_SIGUSR2,
+#ifdef TARGET_SIGPWR
+    TARGET_SIGPWR,
+#else
+    -1,
+#endif
+    -1, /* SIGPOLL */
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+#ifdef __SIGRTMIN
+    __SIGRTMIN + 1,
+    __SIGRTMIN + 2,
+    __SIGRTMIN + 3,
+    __SIGRTMIN + 4,
+    __SIGRTMIN + 5,
+    __SIGRTMIN + 6,
+    __SIGRTMIN + 7,
+    __SIGRTMIN + 8,
+    __SIGRTMIN + 9,
+    __SIGRTMIN + 10,
+    __SIGRTMIN + 11,
+    __SIGRTMIN + 12,
+    __SIGRTMIN + 13,
+    __SIGRTMIN + 14,
+    __SIGRTMIN + 15,
+    __SIGRTMIN + 16,
+    __SIGRTMIN + 17,
+    __SIGRTMIN + 18,
+    __SIGRTMIN + 19,
+    __SIGRTMIN + 20,
+    __SIGRTMIN + 21,
+    __SIGRTMIN + 22,
+    __SIGRTMIN + 23,
+    __SIGRTMIN + 24,
+    __SIGRTMIN + 25,
+    __SIGRTMIN + 26,
+    __SIGRTMIN + 27,
+    __SIGRTMIN + 28,
+    __SIGRTMIN + 29,
+    __SIGRTMIN + 30,
+    __SIGRTMIN + 31,
+    -1, /* SIGCANCEL */
+    __SIGRTMIN,
+    __SIGRTMIN + 32,
+    __SIGRTMIN + 33,
+    __SIGRTMIN + 34,
+    __SIGRTMIN + 35,
+    __SIGRTMIN + 36,
+    __SIGRTMIN + 37,
+    __SIGRTMIN + 38,
+    __SIGRTMIN + 39,
+    __SIGRTMIN + 40,
+    __SIGRTMIN + 41,
+    __SIGRTMIN + 42,
+    __SIGRTMIN + 43,
+    __SIGRTMIN + 44,
+    __SIGRTMIN + 45,
+    __SIGRTMIN + 46,
+    __SIGRTMIN + 47,
+    __SIGRTMIN + 48,
+    __SIGRTMIN + 49,
+    __SIGRTMIN + 50,
+    __SIGRTMIN + 51,
+    __SIGRTMIN + 52,
+    __SIGRTMIN + 53,
+    __SIGRTMIN + 54,
+    __SIGRTMIN + 55,
+    __SIGRTMIN + 56,
+    __SIGRTMIN + 57,
+    __SIGRTMIN + 58,
+    __SIGRTMIN + 59,
+    __SIGRTMIN + 60,
+    __SIGRTMIN + 61,
+    __SIGRTMIN + 62,
+    __SIGRTMIN + 63,
+    __SIGRTMIN + 64,
+    __SIGRTMIN + 65,
+    __SIGRTMIN + 66,
+    __SIGRTMIN + 67,
+    __SIGRTMIN + 68,
+    __SIGRTMIN + 69,
+    __SIGRTMIN + 70,
+    __SIGRTMIN + 71,
+    __SIGRTMIN + 72,
+    __SIGRTMIN + 73,
+    __SIGRTMIN + 74,
+    __SIGRTMIN + 75,
+    __SIGRTMIN + 76,
+    __SIGRTMIN + 77,
+    __SIGRTMIN + 78,
+    __SIGRTMIN + 79,
+    __SIGRTMIN + 80,
+    __SIGRTMIN + 81,
+    __SIGRTMIN + 82,
+    __SIGRTMIN + 83,
+    __SIGRTMIN + 84,
+    __SIGRTMIN + 85,
+    __SIGRTMIN + 86,
+    __SIGRTMIN + 87,
+    __SIGRTMIN + 88,
+    __SIGRTMIN + 89,
+    __SIGRTMIN + 90,
+    __SIGRTMIN + 91,
+    __SIGRTMIN + 92,
+    __SIGRTMIN + 93,
+    __SIGRTMIN + 94,
+    __SIGRTMIN + 95,
+    -1, /* SIGINFO */
+    -1, /* UNKNOWN */
+    -1, /* DEFAULT */
+    -1,
+    -1,
+    -1,
+    -1,
+    -1,
+    -1
+#endif
+};
+
+int gdb_signal_to_target(int sig)
+{
+    if (sig < ARRAY_SIZE(gdb_signal_table)) {
+        return gdb_signal_table[sig];
+    } else {
+        return -1;
+    }
+}
+
+int gdb_target_signal_to_gdb(int sig)
+{
+    int i;
+    for (i = 0; i < ARRAY_SIZE(gdb_signal_table); i++) {
+        if (gdb_signal_table[i] == sig) {
+            return i;
+        }
+    }
+    return GDB_SIGNAL_UNKNOWN;
+}
+
+int gdb_get_cpu_index(CPUState *cpu)
+{
+    TaskState *ts = (TaskState *) cpu->opaque;
+    return ts ? ts->ts_tid : -1;
+}
+
+/*
+ * User-mode specific command helpers
+ */
+
+void gdb_handle_query_offsets(GArray *params, void *user_ctx)
+{
+    TaskState *ts;
+
+    ts = gdbserver_state.c_cpu->opaque;
+    g_string_printf(gdbserver_state.str_buf,
+                    "Text=" TARGET_ABI_FMT_lx
+                    ";Data=" TARGET_ABI_FMT_lx
+                    ";Bss=" TARGET_ABI_FMT_lx,
+                    ts->info->code_offset,
+                    ts->info->data_offset,
+                    ts->info->data_offset);
+    gdb_put_strbuf();
+}
+
+#if defined(CONFIG_LINUX)
+/* Partial user only duplicate of helper in gdbstub.c */
+static inline int target_memory_rw_debug(CPUState *cpu, target_ulong addr,
+                                         uint8_t *buf, int len, bool is_write)
+{
+    CPUClass *cc;
+    cc = CPU_GET_CLASS(cpu);
+    if (cc->memory_rw_debug) {
+        return cc->memory_rw_debug(cpu, addr, buf, len, is_write);
+    }
+    return cpu_memory_rw_debug(cpu, addr, buf, len, is_write);
+}
+
+void gdb_handle_query_xfer_auxv(GArray *params, void *user_ctx)
+{
+    TaskState *ts;
+    unsigned long offset, len, saved_auxv, auxv_len;
+
+    if (params->len < 2) {
+        gdb_put_packet("E22");
+        return;
+    }
+
+    offset = get_param(params, 0)->val_ul;
+    len = get_param(params, 1)->val_ul;
+    ts = gdbserver_state.c_cpu->opaque;
+    saved_auxv = ts->info->saved_auxv;
+    auxv_len = ts->info->auxv_len;
+
+    if (offset >= auxv_len) {
+        gdb_put_packet("E00");
+        return;
+    }
+
+    if (len > (MAX_PACKET_LENGTH - 5) / 2) {
+        len = (MAX_PACKET_LENGTH - 5) / 2;
+    }
+
+    if (len < auxv_len - offset) {
+        g_string_assign(gdbserver_state.str_buf, "m");
+    } else {
+        g_string_assign(gdbserver_state.str_buf, "l");
+        len = auxv_len - offset;
+    }
+
+    g_byte_array_set_size(gdbserver_state.mem_buf, len);
+    if (target_memory_rw_debug(gdbserver_state.g_cpu, saved_auxv + offset,
+                               gdbserver_state.mem_buf->data, len, false)) {
+        gdb_put_packet("E14");
+        return;
+    }
+
+    gdb_memtox(gdbserver_state.str_buf,
+           (const char *)gdbserver_state.mem_buf->data, len);
+    gdb_put_packet_binary(gdbserver_state.str_buf->str,
+                      gdbserver_state.str_buf->len, true);
+}
+#endif
diff --git a/gdbstub/user.c b/gdbstub/user.c
index 09a18fb23b..23b2e726f6 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -10,10 +10,354 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/cutils.h"
+#include "qemu/sockets.h"
+#include "exec/hwaddr.h"
+#include "exec/tb-flush.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/user.h"
 #include "hw/core/cpu.h"
+#include "trace.h"
 #include "internals.h"
 
+/* User-mode specific state */
+typedef struct {
+    int fd;
+    char *socket_path;
+    int running_state;
+} GDBUserState;
+
+static GDBUserState gdbserver_user_state;
+
+int gdb_get_char(void)
+{
+    uint8_t ch;
+    int ret;
+
+    for (;;) {
+        ret = recv(gdbserver_user_state.fd, &ch, 1, 0);
+        if (ret < 0) {
+            if (errno == ECONNRESET) {
+                gdbserver_user_state.fd = -1;
+            }
+            if (errno != EINTR) {
+                return -1;
+            }
+        } else if (ret == 0) {
+            close(gdbserver_user_state.fd);
+            gdbserver_user_state.fd = -1;
+            return -1;
+        } else {
+            break;
+        }
+    }
+    return ch;
+}
+
+void gdb_put_buffer(const uint8_t *buf, int len)
+{
+    int ret;
+
+    while (len > 0) {
+        ret = send(gdbserver_user_state.fd, buf, len, 0);
+        if (ret < 0) {
+            if (errno != EINTR) {
+                return;
+            }
+        } else {
+            buf += ret;
+            len -= ret;
+        }
+    }
+}
+
+/* Tell the remote gdb that the process has exited.  */
+void gdb_exit(int code)
+{
+    char buf[4];
+
+    if (!gdbserver_state.init) {
+        return;
+    }
+    if (gdbserver_user_state.socket_path) {
+        unlink(gdbserver_user_state.socket_path);
+    }
+    if (gdbserver_user_state.fd < 0) {
+        return;
+    }
+
+    trace_gdbstub_op_exiting((uint8_t)code);
+
+    snprintf(buf, sizeof(buf), "W%02x", (uint8_t)code);
+    gdb_put_packet(buf);
+}
+
+int gdb_handlesig(CPUState *cpu, int sig)
+{
+    char buf[256];
+    int n;
+
+    if (!gdbserver_state.init || gdbserver_user_state.fd < 0) {
+        return sig;
+    }
+
+    /* disable single step if it was enabled */
+    cpu_single_step(cpu, 0);
+    tb_flush(cpu);
+
+    if (sig != 0) {
+        gdb_set_stop_cpu(cpu);
+        g_string_printf(gdbserver_state.str_buf,
+                        "T%02xthread:", gdb_target_signal_to_gdb(sig));
+        gdb_append_thread_id(cpu, gdbserver_state.str_buf);
+        g_string_append_c(gdbserver_state.str_buf, ';');
+        gdb_put_strbuf();
+    }
+    /*
+     * gdb_put_packet() might have detected that the peer terminated the
+     * connection.
+     */
+    if (gdbserver_user_state.fd < 0) {
+        return sig;
+    }
+
+    sig = 0;
+    gdbserver_state.state = RS_IDLE;
+    gdbserver_user_state.running_state = 0;
+    while (gdbserver_user_state.running_state == 0) {
+        n = read(gdbserver_user_state.fd, buf, 256);
+        if (n > 0) {
+            int i;
+
+            for (i = 0; i < n; i++) {
+                gdb_read_byte(buf[i]);
+            }
+        } else {
+            /*
+             * XXX: Connection closed.  Should probably wait for another
+             * connection before continuing.
+             */
+            if (n == 0) {
+                close(gdbserver_user_state.fd);
+            }
+            gdbserver_user_state.fd = -1;
+            return sig;
+        }
+    }
+    sig = gdbserver_state.signal;
+    gdbserver_state.signal = 0;
+    return sig;
+}
+
+/* Tell the remote gdb that the process has exited due to SIG.  */
+void gdb_signalled(CPUArchState *env, int sig)
+{
+    char buf[4];
+
+    if (!gdbserver_state.init || gdbserver_user_state.fd < 0) {
+        return;
+    }
+
+    snprintf(buf, sizeof(buf), "X%02x", gdb_target_signal_to_gdb(sig));
+    gdb_put_packet(buf);
+}
+
+static void gdb_accept_init(int fd)
+{
+    gdb_init_gdbserver_state();
+    gdb_create_default_process(&gdbserver_state);
+    gdbserver_state.processes[0].attached = true;
+    gdbserver_state.c_cpu = gdb_first_attached_cpu();
+    gdbserver_state.g_cpu = gdbserver_state.c_cpu;
+    gdbserver_user_state.fd = fd;
+    gdb_has_xml = false;
+}
+
+static bool gdb_accept_socket(int gdb_fd)
+{
+    int fd;
+
+    for (;;) {
+        fd = accept(gdb_fd, NULL, NULL);
+        if (fd < 0 && errno != EINTR) {
+            perror("accept socket");
+            return false;
+        } else if (fd >= 0) {
+            qemu_set_cloexec(fd);
+            break;
+        }
+    }
+
+    gdb_accept_init(fd);
+    return true;
+}
+
+static int gdbserver_open_socket(const char *path)
+{
+    struct sockaddr_un sockaddr = {};
+    int fd, ret;
+
+    fd = socket(AF_UNIX, SOCK_STREAM, 0);
+    if (fd < 0) {
+        perror("create socket");
+        return -1;
+    }
+
+    sockaddr.sun_family = AF_UNIX;
+    pstrcpy(sockaddr.sun_path, sizeof(sockaddr.sun_path) - 1, path);
+    ret = bind(fd, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
+    if (ret < 0) {
+        perror("bind socket");
+        close(fd);
+        return -1;
+    }
+    ret = listen(fd, 1);
+    if (ret < 0) {
+        perror("listen socket");
+        close(fd);
+        return -1;
+    }
+
+    return fd;
+}
+
+static bool gdb_accept_tcp(int gdb_fd)
+{
+    struct sockaddr_in sockaddr = {};
+    socklen_t len;
+    int fd;
+
+    for (;;) {
+        len = sizeof(sockaddr);
+        fd = accept(gdb_fd, (struct sockaddr *)&sockaddr, &len);
+        if (fd < 0 && errno != EINTR) {
+            perror("accept");
+            return false;
+        } else if (fd >= 0) {
+            qemu_set_cloexec(fd);
+            break;
+        }
+    }
+
+    /* set short latency */
+    if (socket_set_nodelay(fd)) {
+        perror("setsockopt");
+        close(fd);
+        return false;
+    }
+
+    gdb_accept_init(fd);
+    return true;
+}
+
+static int gdbserver_open_port(int port)
+{
+    struct sockaddr_in sockaddr;
+    int fd, ret;
+
+    fd = socket(PF_INET, SOCK_STREAM, 0);
+    if (fd < 0) {
+        perror("socket");
+        return -1;
+    }
+    qemu_set_cloexec(fd);
+
+    socket_set_fast_reuse(fd);
+
+    sockaddr.sin_family = AF_INET;
+    sockaddr.sin_port = htons(port);
+    sockaddr.sin_addr.s_addr = 0;
+    ret = bind(fd, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
+    if (ret < 0) {
+        perror("bind");
+        close(fd);
+        return -1;
+    }
+    ret = listen(fd, 1);
+    if (ret < 0) {
+        perror("listen");
+        close(fd);
+        return -1;
+    }
+
+    return fd;
+}
+
+int gdbserver_start(const char *port_or_path)
+{
+    int port = g_ascii_strtoull(port_or_path, NULL, 10);
+    int gdb_fd;
+
+    if (port > 0) {
+        gdb_fd = gdbserver_open_port(port);
+    } else {
+        gdb_fd = gdbserver_open_socket(port_or_path);
+    }
+
+    if (gdb_fd < 0) {
+        return -1;
+    }
+
+    if (port > 0 && gdb_accept_tcp(gdb_fd)) {
+        return 0;
+    } else if (gdb_accept_socket(gdb_fd)) {
+        gdbserver_user_state.socket_path = g_strdup(port_or_path);
+        return 0;
+    }
+
+    /* gone wrong */
+    close(gdb_fd);
+    return -1;
+}
+
+/* Disable gdb stub for child processes.  */
+void gdbserver_fork(CPUState *cpu)
+{
+    if (!gdbserver_state.init || gdbserver_user_state.fd < 0) {
+        return;
+    }
+    close(gdbserver_user_state.fd);
+    gdbserver_user_state.fd = -1;
+    cpu_breakpoint_remove_all(cpu, BP_GDB);
+    /* no cpu_watchpoint_remove_all for user-mode */
+}
+
+/*
+ * Execution state helpers
+ */
+
+void gdb_continue(void)
+{
+    gdbserver_user_state.running_state = 1;
+    trace_gdbstub_op_continue();
+}
+
+/*
+ * Resume execution, for user-mode emulation it's equivalent to
+ * gdb_continue.
+ */
+int gdb_continue_partial(char *newstates)
+{
+    CPUState *cpu;
+    int res = 0;
+    /*
+     * This is not exactly accurate, but it's an improvement compared to the
+     * previous situation, where only one CPU would be single-stepped.
+     */
+    CPU_FOREACH(cpu) {
+        if (newstates[cpu->cpu_index] == 's') {
+            trace_gdbstub_op_stepping(cpu->cpu_index);
+            cpu_single_step(cpu, gdbserver_state.sstep_flags);
+        }
+    }
+    gdbserver_user_state.running_state = 1;
+    return res;
+}
+
+/*
+ * Break/Watch point helpers
+ */
+
 bool gdb_supports_guest_debug(void)
 {
     /* user-mode == TCG == supported */
diff --git a/linux-user/main.c b/linux-user/main.c
index 4ff30ff980..75dbb52788 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -40,6 +40,7 @@
 #include "qemu/plugin.h"
 #include "exec/exec-all.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/user.h"
 #include "tcg/tcg.h"
 #include "qemu/timer.h"
 #include "qemu/envlist.h"
diff --git a/linux-user/signal.c b/linux-user/signal.c
index 098f3a787d..748a98f3e5 100644
--- a/linux-user/signal.c
+++ b/linux-user/signal.c
@@ -18,7 +18,7 @@
  */
 #include "qemu/osdep.h"
 #include "qemu/bitops.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/user.h"
 #include "hw/core/tcg-cpu-ops.h"
 
 #include <sys/ucontext.h>
diff --git a/gdbstub/meson.build b/gdbstub/meson.build
index fc895a2c39..773bd4b9c9 100644
--- a/gdbstub/meson.build
+++ b/gdbstub/meson.build
@@ -7,3 +7,6 @@
 specific_ss.add(files('gdbstub.c'))
 softmmu_ss.add(files('softmmu.c'))
 user_ss.add(files('user.c'))
+
+# The user-target is specialised by the guest
+specific_ss.add(when: 'CONFIG_USER_ONLY', if_true: files('user-target.c'))
-- 
2.39.2

