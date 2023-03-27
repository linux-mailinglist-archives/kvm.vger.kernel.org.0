Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219DF6CA460
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjC0Mpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjC0Mpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:45:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C80F40EB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso10682681pjc.1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuBo+x2YHnWPhUauT+OMrE1vSCydY6P3EiDZifD0z7w=;
        b=Pka55KVd8PwYMAzgh3gVpT8ZTIerLMaZx9hUutYhNJ3MO+tGSUqrqXUz7dasAfXYxI
         1Y2V4XrSt21Gt4AcD9LKjPElf5RyNOJfszj3pYAs5ZdIuj8zCScgxQ/ZA6TjhNmPzbRB
         a5h8DuHWYPd4V/9FLQyDckj4U5l++zXVasV6dgXqrTht0dshD0B9u+69dhv67mhOLgkR
         0iQ2JYIXr7WA6jx+Tep7snER9aKZwz1opm9/8s3GQNyxoa3FLdbeumU21BBNr4vwxWA9
         Qtg8uZDAZg4ZrAIdEwT6GSgSWGGbJHbktjM6gnz3k9Bxcv/ePE/PwekkZzYnQq3EcVtD
         VoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iuBo+x2YHnWPhUauT+OMrE1vSCydY6P3EiDZifD0z7w=;
        b=K1fNnCyGE2LoQZ7O6NolZSyD7IjrdCScKXUVX9s7swNhB11Su2csqiJtEt0toikjNi
         zwrK2+rlXUJ5uBGY0udJxodTlBf7T3pn6Tq4rzgsWS8lS1ahhr+6xErhuTOXP9HyK5O5
         4I12KoNXxAj3eRHxW8RFdv8LEInMd+gbmQInAaHFK56JkrAf/vRtBqQKNh7BPXcQAAGv
         FJzKiKUACFD33N+dQAJP3lkAy0gzqLsAMRNERPmbuAqrJCO9rdmx8tN7YiUEFU4KTr3E
         oCKyFJHx4PKnlwr+Xp0LQEEmuQitOz6sZbffUbD3rQCUp3zEOW8zbH4Sjx32cnaBuX9Y
         fD3w==
X-Gm-Message-State: AAQBX9deK1HjyML5KHsJYPGZp7+sd+WlnC8DNxdBrZeHg+C/UygzclqY
        eEuPke5LR5H9uh2RLjQwy4bx1KRMOQs=
X-Google-Smtp-Source: AKy350ZdOATy9yYz/kSz7FlHqcRr5253n1tvhC5L1T4Jcp5hU5glLcUlUa4KHS6GQbYUl5STWcKvTg==
X-Received: by 2002:a17:902:ec91:b0:19f:3228:ac34 with SMTP id x17-20020a170902ec9100b0019f3228ac34mr15185378plg.61.1679921145496;
        Mon, 27 Mar 2023 05:45:45 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 04/13] powerpc: Abstract H_CEDE calls into a sleep functions
Date:   Mon, 27 Mar 2023 22:45:11 +1000
Message-Id: <20230327124520.2707537-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This consolidates several implementations, and it no longer leaves
MSR[EE] enabled after the decrementer interrupt is handled, but
rather disables it on return.

The handler no longer allows a continuous ticking, but rather dec
has to be re-armed and EE re-enabled (e.g., via H_CEDE hcall) each
time.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v2:
- Comment about DEC interrupt firing [Thomas review]

 lib/powerpc/asm/handlers.h  |  2 +-
 lib/powerpc/asm/ppc_asm.h   |  1 +
 lib/powerpc/asm/processor.h |  7 ++++++
 lib/powerpc/handlers.c      | 10 ++++-----
 lib/powerpc/processor.c     | 43 +++++++++++++++++++++++++++++++++++++
 powerpc/sprs.c              |  6 +-----
 powerpc/tm.c                | 20 +----------------
 7 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/lib/powerpc/asm/handlers.h b/lib/powerpc/asm/handlers.h
index 64ba727..e4a0cd4 100644
--- a/lib/powerpc/asm/handlers.h
+++ b/lib/powerpc/asm/handlers.h
@@ -3,6 +3,6 @@
 
 #include <asm/ptrace.h>
 
-void dec_except_handler(struct pt_regs *regs, void *data);
+void dec_handler_oneshot(struct pt_regs *regs, void *data);
 
 #endif /* _ASMPOWERPC_HANDLERS_H_ */
diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 1b85f6b..6299ff5 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -36,6 +36,7 @@
 #endif /* __BYTE_ORDER__ */
 
 /* Machine State Register definitions: */
+#define MSR_EE_BIT	15			/* External Interrupts Enable */
 #define MSR_SF_BIT	63			/* 64-bit mode */
 
 #endif /* _ASMPOWERPC_PPC_ASM_H */
diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index ac001e1..ebfeff2 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -20,6 +20,8 @@ static inline uint64_t get_tb(void)
 
 extern void delay(uint64_t cycles);
 extern void udelay(uint64_t us);
+extern void sleep_tb(uint64_t cycles);
+extern void usleep(uint64_t us);
 
 static inline void mdelay(uint64_t ms)
 {
@@ -27,4 +29,9 @@ static inline void mdelay(uint64_t ms)
 		udelay(1000);
 }
 
+static inline void msleep(uint64_t ms)
+{
+	usleep(ms * 1000);
+}
+
 #endif /* _ASMPOWERPC_PROCESSOR_H_ */
diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
index c8721e0..296f14f 100644
--- a/lib/powerpc/handlers.c
+++ b/lib/powerpc/handlers.c
@@ -9,15 +9,13 @@
 #include <libcflat.h>
 #include <asm/handlers.h>
 #include <asm/ptrace.h>
+#include <asm/ppc_asm.h>
 
 /*
  * Generic handler for decrementer exceptions (0x900)
- * Just reset the decrementer back to the value specified when registering the
- * handler
+ * Return with MSR[EE] disabled.
  */
-void dec_except_handler(struct pt_regs *regs __unused, void *data)
+void dec_handler_oneshot(struct pt_regs *regs, void *data)
 {
-	uint64_t dec = *((uint64_t *) data);
-
-	asm volatile ("mtdec %0" : : "r" (dec));
+	regs->msr &= ~(1UL << MSR_EE_BIT);
 }
diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index 70391aa..f8b7905 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -10,6 +10,8 @@
 #include <asm/ptrace.h>
 #include <asm/setup.h>
 #include <asm/barrier.h>
+#include <asm/hcall.h>
+#include <asm/handlers.h>
 
 static struct {
 	void (*func)(struct pt_regs *, void *data);
@@ -66,3 +68,44 @@ void udelay(uint64_t us)
 {
 	delay((us * tb_hz) / 1000000);
 }
+
+void sleep_tb(uint64_t cycles)
+{
+	uint64_t start, end, now;
+
+	start = now = get_tb();
+	end = start + cycles;
+
+	while (end > now) {
+		uint64_t left = end - now;
+
+		/* TODO: Could support large decrementer */
+		if (left > 0x7fffffff)
+			left = 0x7fffffff;
+
+		/* DEC won't fire until H_CEDE is called because EE=0 */
+		asm volatile ("mtdec %0" : : "r" (left));
+		handle_exception(0x900, &dec_handler_oneshot, NULL);
+		/*
+		 * H_CEDE is called with MSR[EE] clear and enables it as part
+		 * of the hcall, returning with EE enabled. The dec interrupt
+		 * is then taken immediately and the handler disables EE.
+		 *
+		 * If H_CEDE returned for any other interrupt than dec
+		 * expiring, that is considered an unhandled interrupt and
+		 * the test case would be stopped.
+		 */
+		if (hcall(H_CEDE) != H_SUCCESS) {
+			printf("H_CEDE failed\n");
+			abort();
+		}
+		handle_exception(0x900, NULL, NULL);
+
+		now = get_tb();
+	}
+}
+
+void usleep(uint64_t us)
+{
+	sleep_tb((us * tb_hz) / 1000000);
+}
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 5cc1cd1..ba4ddee 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -254,7 +254,6 @@ int main(int argc, char **argv)
 		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
 		-1ULL,
 	};
-	static uint64_t decr = 0x7FFFFFFF; /* Max value */
 
 	for (i = 1; i < argc; i++) {
 		if (!strcmp(argv[i], "-w")) {
@@ -288,10 +287,7 @@ int main(int argc, char **argv)
 	if (pause) {
 		migrate_once();
 	} else {
-		puts("Sleeping...\n");
-		handle_exception(0x900, &dec_except_handler, &decr);
-		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
-		hcall(H_CEDE);
+		msleep(2000);
 	}
 
 	get_sprs(after);
diff --git a/powerpc/tm.c b/powerpc/tm.c
index 65cacdf..7fa9163 100644
--- a/powerpc/tm.c
+++ b/powerpc/tm.c
@@ -48,17 +48,6 @@ static int count_cpus_with_tm(void)
 	return available;
 }
 
-static int h_cede(void)
-{
-	register uint64_t r3 asm("r3") = H_CEDE;
-
-	asm volatile ("sc 1" : "+r"(r3) :
-			     : "r0", "r4", "r5", "r6", "r7", "r8", "r9",
-			       "r10", "r11", "r12", "xer", "ctr", "cc");
-
-	return r3;
-}
-
 /*
  * Enable transactional memory
  * Returns:	FALSE - Failure
@@ -95,14 +84,10 @@ static bool enable_tm(void)
 static void test_h_cede_tm(int argc, char **argv)
 {
 	int i;
-	static uint64_t decr = 0x3FFFFF; /* ~10ms */
 
 	if (argc > 2)
 		report_abort("Unsupported argument: '%s'", argv[2]);
 
-	handle_exception(0x900, &dec_except_handler, &decr);
-	asm volatile ("mtdec %0" : : "r" (decr));
-
 	if (!start_all_cpus(halt, 0))
 		report_abort("Failed to start secondary cpus");
 
@@ -120,10 +105,7 @@ static void test_h_cede_tm(int argc, char **argv)
 		      "bf 2,1b" : : : "cr0");
 
 	for (i = 0; i < 500; i++) {
-		uint64_t rval = h_cede();
-
-		if (rval != H_SUCCESS)
-			break;
+		msleep(10);
 		mdelay(5);
 	}
 
-- 
2.37.2

