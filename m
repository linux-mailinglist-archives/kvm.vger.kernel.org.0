Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571CE708604
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjERQXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjERQXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:23:12 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737F41991
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:55 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2ca9ef0cso107644b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426967; x=1687018967;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DUVXHBR1wkNxT0wOTAVxttFccgUOF7kcLoBjUYXBqWs=;
        b=RmsyqDtixA9d40WGB2+ewkRJXbAbmcHiHrmnFjYIMoX+1KRp80VKc0jE5HvbCUSlNW
         9lTkR+2iciWcmwwNHsatLkcSL5hNX/EkOHX8ZGg1KnizuOkrYwY5JUj8N3RTl+vthVx5
         tWsBWx+fEqnRkswV4Wc32lwdc3rvsZpqeBkUZrQOI6Fdye6keuC7GoLZXgpGxsvJOxnN
         XHNqvkwRGAoZRPGIQo6mskRfyvn9uQ4zOUubbEO+9RMUn2vQTVvxJOor7YRpaYdiugKg
         iiCmL6prpazWZr8FEGNblwtWY8Fsk3aMb2zhpqrwagoLnCK6FIQZcMJ7w2+3y5kGrks2
         SZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426967; x=1687018967;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DUVXHBR1wkNxT0wOTAVxttFccgUOF7kcLoBjUYXBqWs=;
        b=dQTuitnLu2Y/gS5fBylVE2M/OuQc0RqUyoYWR54ZgL5lAaF0vv0amsrPnI+ItM2d+N
         OXtXAr/TvPnYJ93c9GbDrenq5+kBKDWXGMDvbiUfQP4CE9ab1EpQ4EnioRKxlLjeRPsB
         eeH645P0MEJHfGA0ZwT1IC1FmKEPFlIw2Q0+/0iJ5uTYrs6iny9xKJ8tOkxJdoiHNkMm
         tnkoeLfIt8/PnJ1PDZy9uwGMSdmPghu2GrY3ZEPkUqhiTdfB3cZV66V5pBM+/AhNuDFQ
         pnPkBnnpABLInadQjb1pS6pAui6lKXxYf1zLbBOU7OiH9W5hwOufHh5SX4vTBZojJ8Jf
         xF3Q==
X-Gm-Message-State: AC+VfDykclZKvy96XsitghbWnmN5NDEw8yiZUgAQqgOmc5jO02IIQH8c
        hKiE8INltVXB7uldmxffbne68Q==
X-Google-Smtp-Source: ACHHUZ6vyYtlBdSkdSHYeVzI3iXRymDGrAOwy7m6x8IxaET2P8QNIPLM/BTxFuOyugdPDEK2hFApwQ==
X-Received: by 2002:a05:6a00:2ea4:b0:64a:f8c9:a421 with SMTP id fd36-20020a056a002ea400b0064af8c9a421mr5461304pfb.32.1684426966909;
        Thu, 18 May 2023 09:22:46 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:22:46 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Shuah Khan <shuah@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Evan Green <evan@rivosinc.com>
Subject: [PATCH -next v20 25/26] selftests: Test RISC-V Vector prctl interface
Date:   Thu, 18 May 2023 16:19:48 +0000
Message-Id: <20230518161949.11203-26-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This add a test for prctl interface that controls the use of userspace
Vector.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 tools/testing/selftests/riscv/Makefile        |   2 +-
 .../testing/selftests/riscv/vector/.gitignore |   2 +
 tools/testing/selftests/riscv/vector/Makefile |  15 ++
 .../riscv/vector/vstate_exec_nolibc.c         | 111 ++++++++++
 .../selftests/riscv/vector/vstate_prctl.c     | 189 ++++++++++++++++++
 5 files changed, 318 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/riscv/vector/.gitignore
 create mode 100644 tools/testing/selftests/riscv/vector/Makefile
 create mode 100644 tools/testing/selftests/riscv/vector/vstate_exec_nolibc.c
 create mode 100644 tools/testing/selftests/riscv/vector/vstate_prctl.c

diff --git a/tools/testing/selftests/riscv/Makefile b/tools/testing/selftests/riscv/Makefile
index 32a72902d045..9dd629cc86aa 100644
--- a/tools/testing/selftests/riscv/Makefile
+++ b/tools/testing/selftests/riscv/Makefile
@@ -5,7 +5,7 @@
 ARCH ?= $(shell uname -m 2>/dev/null || echo not)
 
 ifneq (,$(filter $(ARCH),riscv))
-RISCV_SUBTARGETS ?= hwprobe
+RISCV_SUBTARGETS ?= hwprobe vector
 else
 RISCV_SUBTARGETS :=
 endif
diff --git a/tools/testing/selftests/riscv/vector/.gitignore b/tools/testing/selftests/riscv/vector/.gitignore
new file mode 100644
index 000000000000..4f2b4e8a3b08
--- /dev/null
+++ b/tools/testing/selftests/riscv/vector/.gitignore
@@ -0,0 +1,2 @@
+vstate_exec_nolibc
+vstate_prctl
diff --git a/tools/testing/selftests/riscv/vector/Makefile b/tools/testing/selftests/riscv/vector/Makefile
new file mode 100644
index 000000000000..cd6e80bf995d
--- /dev/null
+++ b/tools/testing/selftests/riscv/vector/Makefile
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 ARM Limited
+# Originally tools/testing/arm64/abi/Makefile
+
+TEST_GEN_PROGS := vstate_prctl
+TEST_GEN_PROGS_EXTENDED := vstate_exec_nolibc
+
+include ../../lib.mk
+
+$(OUTPUT)/vstate_prctl: vstate_prctl.c ../hwprobe/sys_hwprobe.S
+	$(CC) -static -o$@ $(CFLAGS) $(LDFLAGS) $^
+
+$(OUTPUT)/vstate_exec_nolibc: vstate_exec_nolibc.c
+	$(CC) -nostdlib -static -include ../../../../include/nolibc/nolibc.h \
+		-Wall $(CFLAGS) $(LDFLAGS) $^ -o $@ -lgcc
diff --git a/tools/testing/selftests/riscv/vector/vstate_exec_nolibc.c b/tools/testing/selftests/riscv/vector/vstate_exec_nolibc.c
new file mode 100644
index 000000000000..5cbc392944a6
--- /dev/null
+++ b/tools/testing/selftests/riscv/vector/vstate_exec_nolibc.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <sys/prctl.h>
+
+#define THIS_PROGRAM "./vstate_exec_nolibc"
+
+int main(int argc, char **argv)
+{
+	int rc, pid, status, test_inherit = 0;
+	long ctrl, ctrl_c;
+	char *exec_argv[2], *exec_envp[2];
+
+	if (argc > 1)
+		test_inherit = 1;
+
+	ctrl = my_syscall1(__NR_prctl, PR_RISCV_V_GET_CONTROL);
+	if (ctrl < 0) {
+		puts("PR_RISCV_V_GET_CONTROL is not supported\n");
+		return ctrl;
+	}
+
+	if (test_inherit) {
+		pid = fork();
+		if (pid == -1) {
+			puts("fork failed\n");
+			exit(-1);
+		}
+
+		/* child  */
+		if (!pid) {
+			exec_argv[0] = THIS_PROGRAM;
+			exec_argv[1] = NULL;
+			exec_envp[0] = NULL;
+			exec_envp[1] = NULL;
+			/* launch the program again to check inherit */
+			rc = execve(THIS_PROGRAM, exec_argv, exec_envp);
+			if (rc) {
+				puts("child execve failed\n");
+				exit(-1);
+			}
+		}
+
+	} else {
+		pid = fork();
+		if (pid == -1) {
+			puts("fork failed\n");
+			exit(-1);
+		}
+
+		if (!pid) {
+			rc = my_syscall1(__NR_prctl, PR_RISCV_V_GET_CONTROL);
+			if (rc != ctrl) {
+				puts("child's vstate_ctrl not equal to parent's\n");
+				exit(-1);
+			}
+			asm volatile (".option push\n\t"
+				      ".option arch, +v\n\t"
+				      "vsetvli x0, x0, e32, m8, ta, ma\n\t"
+				      ".option pop\n\t"
+				      );
+			exit(ctrl);
+		}
+	}
+
+	rc = waitpid(-1, &status, 0);
+
+	if (WIFEXITED(status) && WEXITSTATUS(status) == -1) {
+		puts("child exited abnormally\n");
+		exit(-1);
+	}
+
+	if (WIFSIGNALED(status)) {
+		if (WTERMSIG(status) != SIGILL) {
+			puts("child was terminated by unexpected signal\n");
+			exit(-1);
+		}
+
+		if ((ctrl & PR_RISCV_V_VSTATE_CTRL_CUR_MASK) != PR_RISCV_V_VSTATE_CTRL_OFF) {
+			puts("child signaled by illegal V access but vstate_ctrl is not off\n");
+			exit(-1);
+		}
+
+		/* child terminated, and its vstate_ctrl is off */
+		exit(ctrl);
+	}
+
+	ctrl_c = WEXITSTATUS(status);
+	if (test_inherit) {
+		if (ctrl & PR_RISCV_V_VSTATE_CTRL_INHERIT) {
+			if (!(ctrl_c & PR_RISCV_V_VSTATE_CTRL_INHERIT)) {
+				puts("parent has inherit bit, but child has not\n");
+				exit(-1);
+			}
+		}
+		rc = (ctrl & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK) >> 2;
+		if (rc != PR_RISCV_V_VSTATE_CTRL_DEFAULT) {
+			if (rc != (ctrl_c & PR_RISCV_V_VSTATE_CTRL_CUR_MASK)) {
+				puts("parent's next setting does not equal to child's\n");
+				exit(-1);
+			}
+
+			if (!(ctrl & PR_RISCV_V_VSTATE_CTRL_INHERIT)) {
+				if ((ctrl_c & PR_RISCV_V_VSTATE_CTRL_NEXT_MASK) !=
+				    PR_RISCV_V_VSTATE_CTRL_DEFAULT) {
+					puts("must clear child's next vstate_ctrl if !inherit\n");
+					exit(-1);
+				}
+			}
+		}
+	}
+	return ctrl;
+}
diff --git a/tools/testing/selftests/riscv/vector/vstate_prctl.c b/tools/testing/selftests/riscv/vector/vstate_prctl.c
new file mode 100644
index 000000000000..b348b475be57
--- /dev/null
+++ b/tools/testing/selftests/riscv/vector/vstate_prctl.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <sys/prctl.h>
+#include <unistd.h>
+#include <asm/hwprobe.h>
+#include <errno.h>
+#include <sys/wait.h>
+
+#include "../../kselftest.h"
+
+/*
+ * Rather than relying on having a new enough libc to define this, just do it
+ * ourselves.  This way we don't need to be coupled to a new-enough libc to
+ * contain the call.
+ */
+long riscv_hwprobe(struct riscv_hwprobe *pairs, size_t pair_count,
+		   size_t cpu_count, unsigned long *cpus, unsigned int flags);
+
+#define NEXT_PROGRAM "./vstate_exec_nolibc"
+static int launch_test(int test_inherit)
+{
+	char *exec_argv[3], *exec_envp[1];
+	int rc, pid, status;
+
+	pid = fork();
+	if (pid < 0) {
+		ksft_test_result_fail("fork failed %d", pid);
+		return -1;
+	}
+
+	if (!pid) {
+		exec_argv[0] = NEXT_PROGRAM;
+		exec_argv[1] = test_inherit != 0 ? "x" : NULL;
+		exec_argv[2] = NULL;
+		exec_envp[0] = NULL;
+		/* launch the program again to check inherit */
+		rc = execve(NEXT_PROGRAM, exec_argv, exec_envp);
+		if (rc) {
+			perror("execve");
+			ksft_test_result_fail("child execve failed %d\n", rc);
+			exit(-1);
+		}
+	}
+
+	rc = waitpid(-1, &status, 0);
+	if (rc < 0) {
+		ksft_test_result_fail("waitpid failed\n");
+		return -3;
+	}
+
+	if ((WIFEXITED(status) && WEXITSTATUS(status) == -1) ||
+	    WIFSIGNALED(status)) {
+		ksft_test_result_fail("child exited abnormally\n");
+		return -4;
+	}
+
+	return WEXITSTATUS(status);
+}
+
+int test_and_compare_child(long provided, long expected, int inherit)
+{
+	int rc;
+
+	rc = prctl(PR_RISCV_V_SET_CONTROL, provided);
+	if (rc != 0) {
+		ksft_test_result_fail("prctl with provided arg %lx failed with code %d\n",
+				      provided, rc);
+		return -1;
+	}
+	rc = launch_test(inherit);
+	if (rc != expected) {
+		ksft_test_result_fail("Test failed, check %d != %d\n", rc,
+				      expected);
+		return -2;
+	}
+	return 0;
+}
+
+#define PR_RISCV_V_VSTATE_CTRL_CUR_SHIFT	0
+#define PR_RISCV_V_VSTATE_CTRL_NEXT_SHIFT	2
+
+int main(void)
+{
+	struct riscv_hwprobe pair;
+	long flag, expected;
+	long rc;
+
+	pair.key = RISCV_HWPROBE_KEY_IMA_EXT_0;
+	rc = riscv_hwprobe(&pair, 1, 0, NULL, 0);
+	if (rc < 0) {
+		ksft_test_result_fail("hwprobe() failed with %d\n", rc);
+		return -1;
+	}
+
+	if (pair.key != RISCV_HWPROBE_KEY_IMA_EXT_0) {
+		ksft_test_result_fail("hwprobe cannot probe RISCV_HWPROBE_KEY_IMA_EXT_0\n");
+		return -2;
+	}
+
+	if (!(pair.value & RISCV_HWPROBE_IMA_V)) {
+		rc = prctl(PR_RISCV_V_GET_CONTROL);
+		if (rc != -1 || errno != EINVAL) {
+			ksft_test_result_fail("GET_CONTROL should fail on kernel/hw without V\n");
+			return -3;
+		}
+
+		rc = prctl(PR_RISCV_V_SET_CONTROL, PR_RISCV_V_VSTATE_CTRL_ON);
+		if (rc != -1 || errno != EINVAL) {
+			ksft_test_result_fail("GET_CONTROL should fail on kernel/hw without V\n");
+			return -4;
+		}
+
+		ksft_test_result_skip("Vector not supported\n");
+		return 0;
+	}
+
+	flag = PR_RISCV_V_VSTATE_CTRL_ON;
+	rc = prctl(PR_RISCV_V_SET_CONTROL, flag);
+	if (rc != 0) {
+		ksft_test_result_fail("Enabling V for current should always success\n");
+		return -5;
+	}
+
+	flag = PR_RISCV_V_VSTATE_CTRL_OFF;
+	rc = prctl(PR_RISCV_V_SET_CONTROL, flag);
+	if (rc != -1 || errno != EPERM) {
+		ksft_test_result_fail("Disabling current's V alive must fail with EPERM(%d)\n",
+				      errno);
+		return -5;
+	}
+
+	/* Turn on next's vector explicitly and test */
+	flag = PR_RISCV_V_VSTATE_CTRL_ON << PR_RISCV_V_VSTATE_CTRL_NEXT_SHIFT;
+	if (test_and_compare_child(flag, PR_RISCV_V_VSTATE_CTRL_ON, 0))
+		return -6;
+
+	/* Turn off next's vector explicitly and test */
+	flag = PR_RISCV_V_VSTATE_CTRL_OFF << PR_RISCV_V_VSTATE_CTRL_NEXT_SHIFT;
+	if (test_and_compare_child(flag, PR_RISCV_V_VSTATE_CTRL_OFF, 0))
+		return -7;
+
+	/* Turn on next's vector explicitly and test inherit */
+	flag = PR_RISCV_V_VSTATE_CTRL_ON << PR_RISCV_V_VSTATE_CTRL_NEXT_SHIFT;
+	flag |= PR_RISCV_V_VSTATE_CTRL_INHERIT;
+	expected = flag | PR_RISCV_V_VSTATE_CTRL_ON;
+	if (test_and_compare_child(flag, expected, 0))
+		return -8;
+
+	if (test_and_compare_child(flag, expected, 1))
+		return -9;
+
+	/* Turn off next's vector explicitly and test inherit */
+	flag = PR_RISCV_V_VSTATE_CTRL_OFF << PR_RISCV_V_VSTATE_CTRL_NEXT_SHIFT;
+	flag |= PR_RISCV_V_VSTATE_CTRL_INHERIT;
+	expected = flag | PR_RISCV_V_VSTATE_CTRL_OFF;
+	if (test_and_compare_child(flag, expected, 0))
+		return -10;
+
+	if (test_and_compare_child(flag, expected, 1))
+		return -11;
+
+	/* arguments should fail with EINVAL */
+	rc = prctl(PR_RISCV_V_SET_CONTROL, 0xff0);
+	if (rc != -1 || errno != EINVAL) {
+		ksft_test_result_fail("Undefined control argument should return EINVAL\n");
+		return -12;
+	}
+
+	rc = prctl(PR_RISCV_V_SET_CONTROL, 0x3);
+	if (rc != -1 || errno != EINVAL) {
+		ksft_test_result_fail("Undefined control argument should return EINVAL\n");
+		return -12;
+	}
+
+	rc = prctl(PR_RISCV_V_SET_CONTROL, 0xc);
+	if (rc != -1 || errno != EINVAL) {
+		ksft_test_result_fail("Undefined control argument should return EINVAL\n");
+		return -12;
+	}
+
+	rc = prctl(PR_RISCV_V_SET_CONTROL, 0xc);
+	if (rc != -1 || errno != EINVAL) {
+		ksft_test_result_fail("Undefined control argument should return EINVAL\n");
+		return -12;
+	}
+
+	ksft_test_result_pass("tests for riscv_v_vstate_ctrl pass\n");
+	ksft_exit_pass();
+	return 0;
+}
-- 
2.17.1

