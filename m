Return-Path: <kvm+bounces-22019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A4D9383AA
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 09:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75BF71C20AC4
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 07:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EC28F66;
	Sun, 21 Jul 2024 07:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MB6w8jw0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D59D79CF
	for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 07:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545574; cv=none; b=YLoEPBuks0Ur2LLeBvbIzp8lNwj57cX4FMldyLpBAlxELMUeegsEbzJerHvU2wWxuQCwrps199IcXe6dJ/oIkhuk4lmpr3LbgyEtKpPsKytlPOULiW811uryG0HJzMoDhUHuq1Hj26jR8n+pqGcSozX7lB3tFAZGSQorsmGPJ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545574; c=relaxed/simple;
	bh=Qogls816cd0Tv53VgYejA6+L3RDe17CCmGQ0+3vemKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGIL1VJWkvzwHfCatWE2NUCaU3WAqpABEaYnWFtZ19Cx5yP1zK/4jljMGrUw2ReZfOrpTt+92QfmdxfBcbfnK/VJAHHrl5Ou80bNELU1uCSkRK8HQz2oOsQtAAcQMC77ogAXrx7Hv6cuI4CPfBC5JqBBZeHXZ2Vi1JN3bd0cTKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MB6w8jw0; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2cb576db1c5so1596767a91.1
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 00:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721545571; x=1722150371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=MB6w8jw0vXWOgcSCkEkcL9ebl4Djh8Xgby938FJXCdPrXpMbBfo1xUYL9ccoU7PKVY
         watZPBFf4WTwjXzo02mrwOp+YywL83kfnVfctgBcPGMrm2dUL8BhNTlQ90ZE7DYGQNP3
         l0c440C6P1eRyQwlYPd3YCLlPW6zIfj3uuwihMv20/spH++Kw4n3y+r0nSp+yjsQKYaH
         fNSD6bUG3KSjlxBOYCB7Tzfji65/zhXRJHGG9KPBJRW5Nm+ibAMc3OiYGhUr+NFwoe3v
         KA+HvJ7VvZpGKmnJIwmHZUm5eC9bjVmagDa+XN4Byz6KdkcSnS2LseNm9YMXjsMl9XAv
         YaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721545571; x=1722150371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=g2B3oGHNjHIXwLnZOtpbZfkETH+Mqb4AP6GhvOHfVKH59e49TFgttVd2QtyuwbUYKb
         J4B85CXVXg3i8pUSSvMNzMk9tx/LBBssHQBG6JFh7+Mss1JX0w8lSntv3Zkk00Z1RljF
         pqy9btRJ6aj2qW+oUz7MM/QqUDZokOOXgM6PxTamrcrRDLD5+qWzMLJnJONCNpnii+fJ
         zpKuOWc5Qq8KLLZVgcwYIxOJKo73/ciWqoYLcRKjinvFzUoQkEGa/xAte7X7B8ZdXzI6
         W5lypwq1MhorTaYIugjt9jvVjREjhjArqS+ksMdaNUZ/0+98gF3IXEmr8iABl1Yl47UF
         Mkdg==
X-Gm-Message-State: AOJu0YxDqOa/Y3IbimX+/i6IoxeDFt6S6wKMiBhGcsF521VJqg51ToBB
	8qRnBGC3yOWpLywQUIVddTy0FGY28VuHyac4+CsCVMgqfDPU73Sc6KnDLF9i
X-Google-Smtp-Source: AGHT+IEqI9cCP4Pdc2FIOcmfu9rOjcP9n3Yr6xF4YtyKrxt83JH/A9bxv3jEpP6oIW60powen0eVng==
X-Received: by 2002:a05:6a21:3a86:b0:1c2:8d16:c681 with SMTP id adf61e73a8af0-1c4285f2e45mr2064832637.34.1721545571314;
        Sun, 21 Jul 2024 00:06:11 -0700 (PDT)
Received: from JRT-PC.. ([180.255.73.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77492bc6sm4891461a91.1.2024.07.21.00.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 00:06:10 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 1/5] riscv: Extend exception handling support for interrupts
Date: Sun, 21 Jul 2024 15:05:56 +0800
Message-ID: <20240721070601.88639-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240721070601.88639-1-jamestiotio@gmail.com>
References: <20240721070601.88639-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <andrew.jones@linux.dev>

Add install_irq_handler() to enable tests to install interrupt handlers.
Also add local_irq_enable() and local_irq_disable() to respectively
enable and disable IRQs via the sstatus.SIE bit.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h       |  2 ++
 lib/riscv/asm/processor.h | 13 +++++++++++++
 lib/riscv/processor.c     | 27 +++++++++++++++++++++++----
 3 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 52608512..d6909d93 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -11,6 +11,8 @@
 #define CSR_STVAL		0x143
 #define CSR_SATP		0x180
 
+#define SR_SIE			_AC(0x00000002, UL)
+
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
 
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 32c499d0..6451adb5 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -5,6 +5,7 @@
 #include <asm/ptrace.h>
 
 #define EXCEPTION_CAUSE_MAX	16
+#define INTERRUPT_CAUSE_MAX	16
 
 typedef void (*exception_fn)(struct pt_regs *);
 
@@ -13,6 +14,7 @@ struct thread_info {
 	unsigned long hartid;
 	unsigned long isa[1];
 	exception_fn exception_handlers[EXCEPTION_CAUSE_MAX];
+	exception_fn interrupt_handlers[INTERRUPT_CAUSE_MAX];
 };
 
 static inline struct thread_info *current_thread_info(void)
@@ -20,7 +22,18 @@ static inline struct thread_info *current_thread_info(void)
 	return (struct thread_info *)csr_read(CSR_SSCRATCH);
 }
 
+static inline void local_irq_enable(void)
+{
+	csr_set(CSR_SSTATUS, SR_SIE);
+}
+
+static inline void local_irq_disable(void)
+{
+	csr_clear(CSR_SSTATUS, SR_SIE);
+}
+
 void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *));
+void install_irq_handler(unsigned long cause, void (*handler)(struct pt_regs *));
 void do_handle_exception(struct pt_regs *regs);
 void thread_info_init(void);
 
diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
index ece7cbff..0dffadc7 100644
--- a/lib/riscv/processor.c
+++ b/lib/riscv/processor.c
@@ -36,10 +36,21 @@ void do_handle_exception(struct pt_regs *regs)
 {
 	struct thread_info *info = current_thread_info();
 
-	assert(regs->cause < EXCEPTION_CAUSE_MAX);
-	if (info->exception_handlers[regs->cause]) {
-		info->exception_handlers[regs->cause](regs);
-		return;
+	if (regs->cause & CAUSE_IRQ_FLAG) {
+		unsigned long irq_cause = regs->cause & ~CAUSE_IRQ_FLAG;
+
+		assert(irq_cause < INTERRUPT_CAUSE_MAX);
+		if (info->interrupt_handlers[irq_cause]) {
+			info->interrupt_handlers[irq_cause](regs);
+			return;
+		}
+	} else {
+		assert(regs->cause < EXCEPTION_CAUSE_MAX);
+
+		if (info->exception_handlers[regs->cause]) {
+			info->exception_handlers[regs->cause](regs);
+			return;
+		}
 	}
 
 	show_regs(regs);
@@ -47,6 +58,14 @@ void do_handle_exception(struct pt_regs *regs)
 	abort();
 }
 
+void install_irq_handler(unsigned long cause, void (*handler)(struct pt_regs *))
+{
+	struct thread_info *info = current_thread_info();
+
+	assert(cause < INTERRUPT_CAUSE_MAX);
+	info->interrupt_handlers[cause] = handler;
+}
+
 void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *))
 {
 	struct thread_info *info = current_thread_info();
-- 
2.43.0


