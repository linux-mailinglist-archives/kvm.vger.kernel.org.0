Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34563727957
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbjFHH6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjFHH6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:58:49 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7BE212E
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:58:48 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f6c6020cfbso2191101cf.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211127; x=1688803127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmEhHDXqBF9dQ1veYws/GnTEIhu9OPeqy9gy1d4w4DM=;
        b=FSas9QUg0UpdaLQcAcrgO+WSq/ocmCN8xKJ4KaAPW84Dm1aS8VCARaSFulSe1vWHVS
         nrK/ONUP3MvBx+ePiWqriKeg3gwanhQv3yghafty8pF3wexJAcWqGSlsqHNN/hYxpbVx
         iohdAGMELlqbyrR8sZX40mSSF9+OkqzutNEnwViW3tAxDM8+cMxIRyESG1ZQY1Z7ocn8
         OZI+QSIJBk912zU93j7b1fGjUwsDG0aMnGmnLHF2+05BG+doiwRs2jNYDntLYaymX6fm
         8v1+3JtWuBZQC7NCSDy5QB7RXn/DXmu1VRb2dSD20bZBPHiVMbW3y1esS9kEa82tK/DM
         k8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211127; x=1688803127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mmEhHDXqBF9dQ1veYws/GnTEIhu9OPeqy9gy1d4w4DM=;
        b=eZqVwbOcXC+9y34lUaRCbMtd1fc3wDMLd7dujIEv9t5DmWsQ+6aeJyhkJNMfkCZUnP
         F9cbQDK5CdJ1vgj2AhTPzdQuKAC+s9sCrgOxRaouiqnspTl5j49PYodMa0JKDR4bKtE0
         u2nOQyI9mB157I6L97TaPeJBI3AC1kTzEJHlChID3HydbS9rDqXapA/UI8uWlXNFDgmD
         RFGyf6+he1mMlr37BtO4Zqhatqwr9THx1Rdh4M2RXlm8s36me4q76eH9QRjeaDrCGoeh
         aRdrCrIF92az4sJ82wni7uanMUmY4NdXzxxuO3vVzUlmiMO5UP0xO1SprIcZzcwj2EAf
         ALKA==
X-Gm-Message-State: AC+VfDyeur2c6ySmXLGrT/psoWYBmiBbXHYgo/qS8uXXBOkq/IZ+/oYS
        hfWO038V+kuKlA7t9VIOFlK9T8CBapw=
X-Google-Smtp-Source: ACHHUZ5pZcO+N3Su+GOBU3WMg4D9ivP4jx6OqrrOSe/69gNNpjrbL1hXdwcvJQzjzuzgsPF6UNMhWw==
X-Received: by 2002:a05:622a:180a:b0:3f8:6b32:480d with SMTP id t10-20020a05622a180a00b003f86b32480dmr6247042qtc.46.1686211126897;
        Thu, 08 Jun 2023 00:58:46 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:58:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 03/12] powerpc: Abstract H_CEDE calls into a sleep functions
Date:   Thu,  8 Jun 2023 17:58:17 +1000
Message-Id: <20230608075826.86217-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 lib/powerpc/asm/handlers.h  |  2 +-
 lib/powerpc/asm/ppc_asm.h   |  1 +
 lib/powerpc/asm/processor.h |  7 ++++++
 lib/powerpc/handlers.c      | 10 ++++-----
 lib/powerpc/processor.c     | 43 +++++++++++++++++++++++++++++++++++++
 powerpc/sprs.c              |  6 +-----
 powerpc/tm.c                | 20 +----------------
 7 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/lib/powerpc/asm/handlers.h b/lib/powerpc/asm/handlers.h
index 64ba727a..e4a0cd45 100644
--- a/lib/powerpc/asm/handlers.h
+++ b/lib/powerpc/asm/handlers.h
@@ -3,6 +3,6 @@
 
 #include <asm/ptrace.h>
 
-void dec_except_handler(struct pt_regs *regs, void *data);
+void dec_handler_oneshot(struct pt_regs *regs, void *data);
 
 #endif /* _ASMPOWERPC_HANDLERS_H_ */
diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 1b85f6bb..6299ff53 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -36,6 +36,7 @@
 #endif /* __BYTE_ORDER__ */
 
 /* Machine State Register definitions: */
+#define MSR_EE_BIT	15			/* External Interrupts Enable */
 #define MSR_SF_BIT	63			/* 64-bit mode */
 
 #endif /* _ASMPOWERPC_PPC_ASM_H */
diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index ac001e18..ebfeff2b 100644
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
index c8721e0a..296f14ff 100644
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
index 0550e4fc..aaf45b68 100644
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
@@ -58,3 +60,44 @@ void udelay(uint64_t us)
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
index 5cc1cd16..ba4ddee4 100644
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
index 65cacdf5..7fa91636 100644
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
2.40.1

