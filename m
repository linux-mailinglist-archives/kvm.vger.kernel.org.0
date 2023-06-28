Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C346B74071A
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjF1AOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjF1AOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:35 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C54BE6C
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:34 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-39ca48cd4c6so3788640b6e.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911273; x=1690503273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UmFmTC8bnHNv1WPEh/RUIDJe8hKI7ahTcZbLkHpBtH0=;
        b=g3zgrX61eFuJp69fuI0Ao+RDcinE9QFo5sdIt1ZdjknZaZtihV6AcQCzZzSzGDJtEN
         EcLd8Eyc6tp/4QD9ezhuuZE+n9tc1P5d7VKpTpSDguNvT8A6iFLah162s7rWgAWP/82a
         +es/72/tj6bygzYVGwr2e6+FfhkwBbt3OWkiKlB4NNpOz5iQxmB91malsMMrMw+qVpYv
         r0+6u8FUxH/QuYjKwTpsiqrSQ3sCYkOLsds9p9LIU2oPKTvZVVXSGf7fXgBw8oOBH1O7
         /SB7/n67x1+nzn9WX/8EKyFphftrlpdoJFpJRCmJDGY2TNH7sCXEe11jA3iuJSVIvWrM
         vv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911273; x=1690503273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UmFmTC8bnHNv1WPEh/RUIDJe8hKI7ahTcZbLkHpBtH0=;
        b=NoxinPgxoItW8oVBfUqF5wg8+qSfWh/CgUhMmdI6WMCYvziz/q7xns7efr7EjDSo/y
         7n0uj/hSThvIrvP4WOV7YwqoRMzXX2F2QMkHAhHFuDoDiZNvAm5gt+pwfwA3Q/dgwzws
         xwH6AGBxNHpPZ+vhupvSuqzsHczImjl9EyowCT5QZsCmnnmUZRMm5kUVVDEDM2nuryRr
         WHPll8E+4Cd90QrijhGPqEWmsVravHboS4WyQZ/q0XUrUfzdZsPrzHiCJ+JJEfCd5xtu
         jlh+OREsoV9ikwQftMV97jK58F/ibDx9mW0QR1oNnX3fqTansuKOoqnSco8oQFYHqLp1
         sFNA==
X-Gm-Message-State: AC+VfDx1eBhUfmf3kdP84V+A+sWIWGnaAaR3eG1G/QJZ4sjOUGr8xEPL
        vMqZLbpfticjNpWw9Uox+M6YnlFSMjY=
X-Google-Smtp-Source: ACHHUZ7z956FrGM3Nc0mQJn20xFdonGjPggrED2mxicUWJ6uoWGGtr3daHFYVfaE6vzCQi9/Oz4JvQ==
X-Received: by 2002:a05:6808:5c3:b0:3a1:e18a:2402 with SMTP id d3-20020a05680805c300b003a1e18a2402mr6284134oij.4.1687911273087;
        Tue, 27 Jun 2023 17:14:33 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:32 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 3/6] arm64: enable frame pointer and support stack unwinding
Date:   Wed, 28 Jun 2023 00:13:52 +0000
Message-Id: <20230628001356.2706-5-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Enable frame pointers for arm64 and perform stack unwinding based on
arm64 convention.

Signed-off-by: Nadav Amit <namit@vmware.com>

---
v1->v2:
* Adding SPDX [checkpatch]
* Moving some unused declarations to next patch [Andrew]
* Adding recursion prevention
---
 arm/Makefile.arm      |  3 ---
 arm/Makefile.arm64    |  1 +
 arm/Makefile.common   |  3 +++
 lib/arm64/asm/stack.h |  3 +++
 lib/arm64/stack.c     | 44 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 51 insertions(+), 3 deletions(-)
 create mode 100644 lib/arm64/stack.c

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 2ce00f5..7fd39f3 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -11,9 +11,6 @@ ifeq ($(CONFIG_EFI),y)
 $(error Cannot build arm32 tests as EFI apps)
 endif
 
-# stack.o relies on frame pointers.
-KEEP_FRAME_POINTER := y
-
 CFLAGS += $(machine)
 CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -mno-unaligned-access
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 85b3348..960880f 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -22,6 +22,7 @@ define arch_elf_check =
 endef
 
 cstart.o = $(TEST_DIR)/cstart64.o
+cflatobjs += lib/arm64/stack.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 9b45a8f..bc86e44 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -22,6 +22,9 @@ $(TEST_DIR)/sieve.elf: AUXFLAGS = 0x1
 ##################################################################
 AUXFLAGS ?= 0x0
 
+# stack.o relies on frame pointers.
+KEEP_FRAME_POINTER := y
+
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
diff --git a/lib/arm64/asm/stack.h b/lib/arm64/asm/stack.h
index d000624..be486cf 100644
--- a/lib/arm64/asm/stack.h
+++ b/lib/arm64/asm/stack.h
@@ -5,4 +5,7 @@
 #error Do not directly include <asm/stack.h>. Just use <stack.h>.
 #endif
 
+#define HAVE_ARCH_BACKTRACE_FRAME
+#define HAVE_ARCH_BACKTRACE
+
 #endif
diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
new file mode 100644
index 0000000..a2024e8
--- /dev/null
+++ b/lib/arm64/stack.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Backtrace support.
+ */
+#include <libcflat.h>
+#include <stdbool.h>
+#include <stack.h>
+
+int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+{
+	const void *fp = frame;
+	static bool walking;
+	void *lr;
+	int depth;
+
+	if (walking) {
+		printf("RECURSIVE STACK WALK!!!\n");
+		return 0;
+	}
+	walking = true;
+
+	/*
+	 * ARM64 stack grows down. fp points to the previous fp on the stack,
+	 * and lr is just above it
+	 */
+	for (depth = 0; fp && depth < max_depth; ++depth) {
+
+		asm volatile ("ldp %0, %1, [%2]"
+				  : "=r" (fp), "=r" (lr)
+				  : "r" (fp)
+				  : );
+
+		return_addrs[depth] = lr;
+	}
+
+	walking = false;
+	return depth;
+}
+
+int backtrace(const void **return_addrs, int max_depth)
+{
+	return backtrace_frame(__builtin_frame_address(0),
+			       return_addrs, max_depth);
+}
-- 
2.34.1

