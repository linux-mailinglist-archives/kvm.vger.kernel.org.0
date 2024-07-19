Return-Path: <kvm+bounces-21909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A2193728A
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 04:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7951C2114C
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 02:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D772315E8B;
	Fri, 19 Jul 2024 02:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LZnBJxte"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D79B657
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 02:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721356801; cv=none; b=aPuzuVUeZPN/IDo2fqOACRFN9jHhdWZfFIVpv1X1c0VIRSCoSaeLpd/veGENKXH6RUqZFDt3iSU1JbRX/4hIVSMlINYTP7kI9VNW9BGjCTzWeTWoPcBHfq40O356z8jocmLqMf8O0z1UxaycT+KGZeypR0KOjJPg14q3ct9BDMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721356801; c=relaxed/simple;
	bh=Qogls816cd0Tv53VgYejA6+L3RDe17CCmGQ0+3vemKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMuTEWy2jCAwlqd71tAUQhTjDCYAbnrX/YKfJLsUg+V1j9cWujPSoOLjHhznVPQCZZgKqn6wP6PU3JeoiDbWjjRK4KuHniS7Eeu8+n6ivTJgI6a2GK+y+EXD4JuS6NmzTuRKDWp7EQtkm/L+bCojaW7TnJ40VStFeNpgV7bVEzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LZnBJxte; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70af0684c2bso373350b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721356799; x=1721961599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=LZnBJxtex3Pgb4WKOWSOSxGwn+w0eFrg9pwH4aozZkywwsqcrUulqKZjttLbPrJTia
         +/BIyjwZP5PCEwyb4QQPM0Scr0LySbYqfvEIVZWeMAVsxGcRBNCkfPyqFOnb112F01fJ
         qpODtmlU1oLGErjJ5uEPGUEI2TAsPfp92PTanAEmpZIub9Wvhph4V7rkKqWQA95gg99J
         1rVb3hkuPhMP7lXRoA3vEH3ikhyc8j/uZ5oV8PMta2wuJ7iCPZE3F8Y/KzJmC6rhaxBl
         kU5dnyeYJMZZnAX2eoM6SZ45iBrWlWkEz80MDiEogsgiWIMnaBenOxhkBPsgrrHIgzz4
         FHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721356799; x=1721961599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=EMnnOlVzZsHKBwvQQ3qEFfxKBptw1JuGz7T9B0QjdlPZ6l9k77lLsmtTtfRBY5TW8d
         4zd+uiEK/mZpDa9A/cAk3ao4IYaMaJi2E991+3pvQbK8HjIAA1DyZzBAWPb1xVfec16y
         5SKa74rKVbQ6iqUd+TUp0I/2NrgqkcDITHeHTVRhr1TQgZcko0TypKoniaHc26dUbpFe
         zVWn/isPq/nXEMHpKZVx5MxlxwawOgRiK3mcs+JNfbf2DQFA6sLOGtPDc8XfFfKWats+
         Nm0TwcXxWtuoqI/IriNrKEuDTBLCbm1zwHGImQgXlIgAUq+RmQUxczRMJmm996WZQG6c
         9DjA==
X-Gm-Message-State: AOJu0Ywpku4HxN+EDHzWwLeUX8Y5CdGqWvRLsDi2AGrg9RZq+fThP/wm
	fAvQ33NkCNSCUhxTgVoE+uWlDRD0FxGrbSeIp6e7m1eIAU+rRAfPtYmDf/Fb
X-Google-Smtp-Source: AGHT+IErZfUrBeFJrx7CimJVlQ6MV5397je4gZjKHd4uVi95nT3XbkkmU1bHIszUt3+pd2ctnNhVYg==
X-Received: by 2002:a05:6a00:3d44:b0:706:6937:cb9d with SMTP id d2e1a72fcca58-70ce4c1c149mr8016906b3a.0.1721356798501;
        Thu, 18 Jul 2024 19:39:58 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff491231sm234930b3a.31.2024.07.18.19.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 19:39:57 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 1/5] riscv: Extend exception handling support for interrupts
Date: Fri, 19 Jul 2024 10:39:43 +0800
Message-ID: <20240719023947.112609-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240719023947.112609-1-jamestiotio@gmail.com>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
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


