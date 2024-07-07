Return-Path: <kvm+bounces-21070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26428929760
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 12:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 737F3B210D8
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 10:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B2618E28;
	Sun,  7 Jul 2024 10:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzvVby60"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFAE18046
	for <kvm@vger.kernel.org>; Sun,  7 Jul 2024 10:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720347093; cv=none; b=MvQVJiDRc7eua+pfnVzVnXKppzYmPWFo43MtN031DOjy6sBJBqZRbPTdVyUI05YMx0jv0KNJMuEpA4CfGQcygu6p2OfgkD3zu1qPQ+tujlSqPVlncfvpf+RFJDzdcZbfC3p8APnXlZdFCuvyQ81jRsjcEg6MzQ7kQbT6uqiDZb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720347093; c=relaxed/simple;
	bh=Qogls816cd0Tv53VgYejA6+L3RDe17CCmGQ0+3vemKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+VOozIymfCIrByCDcbPrC1PE+YkS4H04+KawPq0SRR4Dp54zOD1PJgoguBIwYxkLQ6nhqXozC8ZxN5Y4RXbfipq0PMdpuepDbSz81iNyGv9JEEt18cMwTiABi7MJTsdZSbQ1P+iLsNWQ835Paz4b/ZeCcxQvlbD5w10+Es+Fb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzvVby60; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fb3cf78fa6so16566035ad.1
        for <kvm@vger.kernel.org>; Sun, 07 Jul 2024 03:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720347090; x=1720951890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=YzvVby60iyh0wLgp7YqjfhgVcVYNQMGQNH+VUe5e0jgOnFyzJ5DXfQrHkkcOmXZngC
         O3yg8Fb/B+3+l5Y5NXpNHqcFZWAcloMjceITTl08vUu9VPYhSpROcH16IgAXV0ERCqGV
         B/nSreXRgWec2IL0rGmhC3dF0g37+fWyFhe9NjAunteu8bC8l4QR/QECqKmoRULm/iM3
         vxvBWAALv7c7jswTflrCHBS50VnGglsqF/Ie1xhY+IhvMVtf4FYst6d6os2JE6WNtGjr
         GSZyVZfxuRvFrttJrH64F4l+HuvftgWNa2hePkET8JXTzdpXxRkM+0/V4SQg0FiZFvpV
         PRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720347090; x=1720951890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joTVeUit/9PHPnwE5WAgfkXToAh6iydIyxEEP0jrhcY=;
        b=Ka5TRj9DPfYrGTTCgl6yxv8tH8oqbHP+jPbmyAcJp7xwshpv9WkeG+92Eae9fVw4vs
         FWjWFPXGWR/ShsZxrc1PLS9zErTkdDxcwrlrrDjlMsqxaP62RiveyyAiA0gX68gFtt1D
         qgG5deFxEe++cCeotc2ZzxDZUT0U28gpy6e5rYYvplVs1w+ZSBg3ffO8G5BmEeHcYwlB
         nhK4pCARqy1Wku/ZlkJ5Hgkyw4bMm2gpY1Am1CaTJb20WOKpdCTMv3KHvtS+O+bsPwHU
         yKuh530x8SwVvysU56Kx7q4MmN0NyPnpHISzlmw5JLNzH4vpIm3idMz+upIdIn/ebr9/
         uaPA==
X-Gm-Message-State: AOJu0YwGb4IlhzKkN5OCILew7qeqDL36cUjgOCjqF4mYQFBvimYt1t94
	XNzCFk16+9RRuV5w4UsTTsED5IGZYtLGDIcMzQ7yROYy4ZBWNegrMbWtzdh9
X-Google-Smtp-Source: AGHT+IHYIaU3c2NbgNdq2XGF206O1KBpARLyUtDv3MsFZawL4qL/tdeDxDEJOZC9mlck+yNQ3miVMA==
X-Received: by 2002:a17:902:eccb:b0:1fa:a03e:349a with SMTP id d9443c01a7336-1fb33f13347mr85572215ad.52.1720347089938;
        Sun, 07 Jul 2024 03:11:29 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1596818sm166648085ad.270.2024.07.07.03.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jul 2024 03:11:29 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 1/3] riscv: Extend exception handling support for interrupts
Date: Sun,  7 Jul 2024 18:10:50 +0800
Message-ID: <20240707101053.74386-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240707101053.74386-1-jamestiotio@gmail.com>
References: <20240707101053.74386-1-jamestiotio@gmail.com>
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


