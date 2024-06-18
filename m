Return-Path: <kvm+bounces-19879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3FC90DAB2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5C9A1F22F2A
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FC3145A1F;
	Tue, 18 Jun 2024 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoelQ6o5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D1813EFEE
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731940; cv=none; b=KRhRCmvAIjQjDjppRMrQtqrtAJeN5FiOGrdOhTGaTTtzYDkmwRtx+a/y7Oe0XoNFssBbBgN0O3r7gOAKW8Fd+rsXq7TKWd6Pkoau4Zslcs7sr/uYkSePRO4nmHermQVHlz/7i2slrv1PNzknhcaZTG206Ob6RDSgEH+xihOfYWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731940; c=relaxed/simple;
	bh=MeWzciPrDjbJv1TM3RG75iFaQAzDIO7TS+r94PXSuTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7WxMjNHFRz29nXGdJnOq0dlFAEHpPvM41qPX2m1jv2bckjeH3Ze5O/uGL1jJKJuSe61140uuT17BZuXuSbhTm5Nef7MWIRPZ8CENVFFkN6+YozhToRnutNAqzqAFajStC615aREZqsFqDa6JQhr4/t+BYrMBbmOuPDDW8dZAuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OoelQ6o5; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7042882e741so4706230b3a.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 10:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718731938; x=1719336738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ypkPbGYy/TpBDV9TrPXgJvZPqdy0Vxo2bZrG/RprffY=;
        b=OoelQ6o5SG8mtl2ziM2Z6DD4xIJxSDrYjKkaT0QSdYJKaYXq0WDhuafVeXwhr0Y715
         vHsIskrHBPB6eq33y36s76t3gGDZ2/JzgPJ7NL88h49Trb3X0M2rDBzumEElv7hB7DOm
         RlPyT2lKNesG/bJEK0AWC/Q4ofR1Kz1iqrDq0pnU+oKdFTYgdBx+lKB6tu9vF4KrI8Qa
         3UeopBkh6rUlMyMEsTLAfK/YXs0MNgOZ5wXL8fp3cvRFivlxwuRjAhKPrAEUHveFX9Cf
         r7e1lLyAks6laCts1x+SWsOhpOSVfV0QnPPdqYyINk4JXDrw1PDPsZMMvkI1CVu6yYNX
         jG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731938; x=1719336738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ypkPbGYy/TpBDV9TrPXgJvZPqdy0Vxo2bZrG/RprffY=;
        b=POaSVQFDBI0dFrUN0du9LlTR8VvXSXPhFVpV7994Zdri+d0Zf13MBoVHAsh5XOOkc3
         T/4IP4HX5/Htb6Ke/lsH+HZhdNWwc18rE/AFigaEP2TsHX3ri3vm6ab8bgf19hvXq70p
         T+S2h1fvvBkrYkL5+P0J27y3DLk6EPVIZ5RDo/fDadF40GAXS6ALpVUbqXUPflaoqiJa
         3FDOxpeX7nBXKmH3SbmF4u9kKNBHGH+Qm+mdRuprvu5X61AgiW+aatFcTv6eHVaebN/A
         pmUmLxqFc2X38gPuPEX/cyAopWxjFK0o7h1mRKdPyoZ6jy+L+9iE2SjyrjU6Eu4l4sZC
         d3uw==
X-Gm-Message-State: AOJu0YwNEkM8i7ZXI7pabtj0JI3ozqqn6iWdzcyf3K+ViJVigmMi4Tcx
	YD/h5CBnzybQTE8SO0TryIrHdzzTfDOP+cOmJcG9x6e0s5m6cwblHApPmVdM
X-Google-Smtp-Source: AGHT+IEmDKZRwJWnZ4x8OKOuCT3HIiVjDep+N0dF149o+YWdExxKftpxAeLEZ49bfDbdiA9ETiWUJQ==
X-Received: by 2002:a17:90b:3104:b0:2c2:dd1d:ce6a with SMTP id 98e67ed59e1d1-2c7b5dca8ccmr365401a91.45.1718731937685;
        Tue, 18 Jun 2024 10:32:17 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75ee5a5sm13529305a91.17.2024.06.18.10.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 10:32:17 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 1/4] riscv: Extend exception handling support for interrupts
Date: Wed, 19 Jun 2024 01:30:50 +0800
Message-ID: <20240618173053.364776-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618173053.364776-1-jamestiotio@gmail.com>
References: <20240618173053.364776-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 52608512..d5879d2a 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -11,6 +11,8 @@
 #define CSR_STVAL		0x143
 #define CSR_SATP		0x180
 
+#define SSTATUS_SIE		(_AC(1, UL) << 1)
+
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
 
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 32c499d0..767b1caa 100644
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
+	csr_set(CSR_SSTATUS, SSTATUS_SIE);
+}
+
+static inline void local_irq_disable(void)
+{
+	csr_clear(CSR_SSTATUS, SSTATUS_SIE);
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


