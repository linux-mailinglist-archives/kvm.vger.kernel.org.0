Return-Path: <kvm+bounces-22465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFA593E8A9
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 18:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5C0A281742
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 16:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7AA6E2BE;
	Sun, 28 Jul 2024 16:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMwCFRf4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD9B57CB1
	for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 16:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722185434; cv=none; b=Xwy5gNV3UAOrnl33LwGiUhwWZ+ZJGsTyt4n1nJy6yvgJfwlk7/Vuh6pE4YBUarKBfprGfzQIa1FwsiA7mhBpynL/JAKWXEcdjRT9CtTd8Z7Oixrr1G5M+56TuYp/iBq5WqEYOtqtAXosOy/X7vJipwZzU4R7L2Yy+HtCN4GG7XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722185434; c=relaxed/simple;
	bh=Qogls816cd0Tv53VgYejA6+L3RDe17CCmGQ0+3vemKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/b/rhiUlXaqie4ipR6GS9LSQ6vumFqQzYt8w1uNcj/WRPxHNM+YYhLS+/8Q/McRqOFMG0y97rS0y+CgKHyO7KakdNaBZhHDBPVYswMouIDIJEtuJjDScin5wT/0jzqjJ7IB3l5c/SYe3BC2z7QI2X9gxBL/a8E4HH82UrYzY3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMwCFRf4; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2cf98ba0559so257378a91.2
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 09:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722185432; x=1722790232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=iMwCFRf4hElMp7u4BwM6eNcJOGA5sSqcg2PhvIRKV5q4/fZRtoJM/47n91Ve3ei0T8
         D5qrtjTiogFHQ0bXOA2nmNRm71Prd/0U+Nho0voKPWzTrrk/e6itiD3r9GAPKQaTGtUP
         bcZZ6UZ8fg8/ps2tGzwEEy7iJDzevElEuyTZaJLFzO+xTNmSpetsda1WioZvJeYBym2l
         M7fnyvY7Ps3knsFsCKhosnuSIezNBgZwNYhJsQS3f4b9yF/0vy2e3Oyf8GPAaxmF66bm
         d5eUzblrp/5DHMHCy+FXc2BB/Rqw/P2n29r02yJaWUlyfhZ1vYL28uKQPRkl/pTtpdtQ
         KCqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722185432; x=1722790232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=pczVQprBXJqu46aYo98gkSTIfF39xjNteV74BdyQbgRCO18J6xqziiZgJJpBw1LS+X
         Kjs4rt4tQBx6yrJbwznF6V5ihi5eOtk3i71nRrhWaYbPjSDex57e3V4AITBWKBw/ZSRH
         D7aCOUulgWM++Kh0AhleBZD/Gu6lJE9nyVKicGf0EsV+Es2bhMoF7M3SN6zWQufN7rgj
         C9ZFzsq5oTLVgBR/QaLEQmJCFtgy7L4bDKrVaMcQDGALZeX/F5y1kzABgbti42BX5G6+
         qhjjhY3xJHIJ3JCYtHTvUaKMXgPxT1HvGQGlJ1lG3cw4Lc7jbOannRK9dgUoG8wbxz1h
         AUbA==
X-Gm-Message-State: AOJu0YxQjQJ6wwV70PcC5cU/+7JvdneSxCevhax/4klRTS2hZTe2oVuf
	7d3SuNG1FH4r4npfzgDZ9jAzFdZY6SULefZla7masIQMsFMWCCTWaByWoRCDjro=
X-Google-Smtp-Source: AGHT+IEJDBZ/ILl91arsRWdVOrvUi1IkAk95+X2hAc9tsD/3+c8iLAyb4IqEO5U5DnAaK7CwZ12yjw==
X-Received: by 2002:a17:90a:1787:b0:2c9:75c6:32dc with SMTP id 98e67ed59e1d1-2cf7e09a8b8mr3830127a91.1.1722185431675;
        Sun, 28 Jul 2024 09:50:31 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c7b0besm6969413a91.14.2024.07.28.09.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 09:50:31 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 1/5] riscv: Extend exception handling support for interrupts
Date: Mon, 29 Jul 2024 00:50:18 +0800
Message-ID: <20240728165022.30075-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728165022.30075-1-jamestiotio@gmail.com>
References: <20240728165022.30075-1-jamestiotio@gmail.com>
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


