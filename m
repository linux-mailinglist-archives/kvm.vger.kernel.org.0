Return-Path: <kvm+bounces-22584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 854C994082C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E30BDB228E2
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 06:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C44218E772;
	Tue, 30 Jul 2024 06:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbVlL/xj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E018D4AA
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 06:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722320312; cv=none; b=LIiuYDTURrjC+fW9VtXmRrDie5csaBWjK/v5EseOhxX44xY88zRwPZVdFJ6n8N4ail6ViLjd1+gESWnGPn32L2MCvVaDbXR0+9+qJ//EdvLewbl0QdMm9zaeiy7O5rCiY8EIyV2zPU2TJ8QELwI7ojvSrsgtfmmQF9JX8qTE0gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722320312; c=relaxed/simple;
	bh=Qogls816cd0Tv53VgYejA6+L3RDe17CCmGQ0+3vemKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig7KZcpXKEplXGVWDC0PrkTb684FSJnN+L2ZPeJNQw18NQl7mBwJlEo26wdt2F3uEUQnBgOqZc9jqvrh04+FC2Vp9X7e7Am0lQVCwMJirhI4S3RY2562NauUN2pSHkiOvsrKoLkgFsKU0T6yBbVce+z5sWhIyLeg2wLsW3U/8Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbVlL/xj; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-260f863108fso2531355fac.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 23:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722320309; x=1722925109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=nbVlL/xjzs6PPk2sl+ChyMCHZNnq7oB4BVoFC5VJAx4OAONSUidv7Bz1b97op0nNR4
         +GBNF+1eASHj9JEUC3FzzElJ6rlbDfL628jleiYYxbDdp469Rp8PU+0E0peW/Jc29lDV
         mU/PiggNbZFvrCPwZXOl8oet7LlPjlmVUiBkWfI0BpSlIyyYql3qODsGiX245vmX40G3
         5Ne5rN25lPyEzsSFwsO7GWaf1X2TAfUxpFdHvv3PCZaBV/ygi8RGLPkoDl2Um44z66O8
         puYjRVhPmZN8S6WBk3UyHfdiV4ntRtAkE4nYxb0iL/ln7REBpx2iEgVCTd/YejU19i50
         ojiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722320309; x=1722925109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=NCPWVJjeEeww2Dh9cBgSV3sbO62zRlerVYz/4f6U+AjXR6JKzMHcoMpr/oEECfJ3Ux
         XCcCu6LTzNE7gJfUjJUQkV6l5JvSGiyLf6Nve7lyEvUON1/s65qYNNvhGXoRhFedeVeQ
         CA81nnVVSbPFt+zyjHsoihs7JEaEeBAc4mCNKHMVP2Qer5Lx+B2XQZXhgwKA0j/BBPFN
         BC597uTbzeO845vs76ZqSbEOElQi2P1RFsa723WYCl3hWcBoc4crAj/o6dvSkA7bMQpI
         ZrWVwwj3eLeDsD5WxRh6eV4CrV8WySm15B5h5WynN0rt1EPLzC9IGP/NNt8g3vQ/MzF6
         5pnQ==
X-Gm-Message-State: AOJu0YxbRZprck76EzcYknCkw22+uZ80kNU2xVVstS2OjVytrh+z8JvY
	u3ZyUQZfTP1ZE6KI1qRMdf8IvvqzFe+Uz3KgOtAIcQNIaRcMvoGatLTD+qVsK0k=
X-Google-Smtp-Source: AGHT+IFZ3x92GfozCY0gffggNOeUFWskApsLodKhUoHGWGIw8sMwo0kCANfV3FpZC5rDkPZNY+qAPg==
X-Received: by 2002:a05:6870:7192:b0:254:7211:424b with SMTP id 586e51a60fabf-267d4ccc224mr12102963fac.6.1722320309253;
        Mon, 29 Jul 2024 23:18:29 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead6e161dsm7732781b3a.42.2024.07.29.23.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 23:18:28 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 1/5] riscv: Extend exception handling support for interrupts
Date: Tue, 30 Jul 2024 14:18:16 +0800
Message-ID: <20240730061821.43811-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240730061821.43811-1-jamestiotio@gmail.com>
References: <20240730061821.43811-1-jamestiotio@gmail.com>
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


