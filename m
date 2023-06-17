Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8474733D7A
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjFQBuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjFQBuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:50:01 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E58C3AB5
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:00 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-39e86b3da59so1070392b6e.3
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966599; x=1689558599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msyuOti/CozgvkpbVkRJ50tzoO+GnBuZ6muiTQwlE4U=;
        b=Eov3QvfL8eEH9AMH5MXpTqNVRTgHh4XYMwxFyRdJhwvY1NfU4nG+G1k77gA1zM2iTH
         S6CnuaEmg2K/O6d0KlN0LAwHW/u5djltGbRWNUiGRQI3mPG+n8qvG6Vx984U4s4HVbAX
         DcNQ+iRKP3o4MK5d38zFQzd//kJBxojdn3e4dXHmDHRWNxLHjxKqTW/yeqfenKPjjtXx
         Otzl6KFZp1pFx2RYaFOWInMCWUIZewpNOrx1mUFvF4RVY6Bv513EEm1sV1Wb1n9iGT/7
         fkS3iYjcqIi7TQjg/fmeNcgkycvRH3tGkkxCZ0nef6S0T8lSPfwzhOKS1Tf3mdW7qRYl
         cuzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966599; x=1689558599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=msyuOti/CozgvkpbVkRJ50tzoO+GnBuZ6muiTQwlE4U=;
        b=hZtJ4jLCIfFSgjf3wxdttKPOHxqEoeJk0+fInbIpaeUs3nXcKlzPUmLPqsZG0DEFaB
         vfLq91PbdqZt2PbqMpCC29nLeCPfC5/rtsQ8VNAqb5EMnh6AtMmj/77Zx0INvNWs7kEI
         ZzBfIH02XGKfQHSdq33gyTR1dz5mbdUlSywkdWQRgKW0Nl9reggcT0UDnvT3iPCRhWm4
         +g3StJX6r4j6AJVP0a/2GPV633n3YC8F1Q9SL9sb/7rZhqwbWsznmwyQ17VC8jdz976m
         olFfov7YzeuMJxIG0KvAfAvxbb6f8R8iLJbdNzlt2NjgzTlLkc6eldlqihCi4Twq9B3u
         AlzQ==
X-Gm-Message-State: AC+VfDxT3/RzstVnFs9Vv+5U9jdSxHZX8p37mu+MNr2kuPgm4iPzeKUS
        XK7Tqq1VJg6wzWSBOB9xhis=
X-Google-Smtp-Source: ACHHUZ6B1gQl2bNzZdnQ+S0DdF+igcH9OZLDupUNPPwtyO60iMRuTFdM/JX9fJ6pGvghSYsxOLAfPg==
X-Received: by 2002:a05:6808:57:b0:39a:bef9:72cd with SMTP id v23-20020a056808005700b0039abef972cdmr3529704oic.47.1686966599200;
        Fri, 16 Jun 2023 18:49:59 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:49:58 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 3/6] arm64: enable frame pointer and support stack unwinding
Date:   Sat, 17 Jun 2023 01:49:27 +0000
Message-Id: <20230617014930.2070-4-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617014930.2070-1-namit@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
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
 arm/Makefile.arm      |  3 ---
 arm/Makefile.arm64    |  1 +
 arm/Makefile.common   |  3 +++
 lib/arm64/asm/stack.h |  3 +++
 lib/arm64/stack.c     | 37 +++++++++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 3 deletions(-)
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
index eada7f9..60385e2 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -21,6 +21,7 @@ define arch_elf_check =
 endef
 
 cstart.o = $(TEST_DIR)/cstart64.o
+cflatobjs += lib/arm64/stack.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
diff --git a/arm/Makefile.common b/arm/Makefile.common
index f904702..7fecfb3 100644
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
index 0000000..1e2568a
--- /dev/null
+++ b/lib/arm64/stack.c
@@ -0,0 +1,37 @@
+/*
+ * backtrace support (this is a modified lib/x86/stack.c)
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <stack.h>
+
+extern char vector_stub_start, vector_stub_end;
+
+int backtrace_frame(const void *frame, const void **return_addrs, int max_depth) {
+	const void *fp = frame;
+	void *lr;
+	int depth;
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

