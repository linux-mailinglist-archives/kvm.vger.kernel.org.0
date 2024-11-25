Return-Path: <kvm+bounces-32465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C66F9D8B04
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 18:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43290B3810C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E291B4152;
	Mon, 25 Nov 2024 16:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rgGqzC56"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3990E4A1A
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551751; cv=none; b=G1kXU41KJoj/MpKR5MPMimmykAXG+sYPtOlqP56zGnG3nmgbK+daWEFUsAQig7MvfnRzv6toqFeU5xxslxmpl8qKy9tNH3KSQa3P5r8Unq9Bx77BZTDKTKbT7ZK8udCNYsxRuBa/oWxpWntkuQury4iuMbVfY6X0LxYOhXcz0hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551751; c=relaxed/simple;
	bh=KlzLwGc/HH/bsttdmyDm1uOlYiW6r9YeOcm2FEDpDRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ILzfO+9I1X5AAWavXxjPAZf7ehHPHB1XmO56nCmcXxJNbDJfPKZkfEk91Yu428ICVd8tU+clk4xTxVFdzJWom4nzfXQLM/9XngPLRBmOm/NXWjfYoSjjHKjDl/p8w6Nnno5HOVoiaXN0uD11YdBZ2aqCFMyEQFqdFop5/PYZg10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rgGqzC56; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7fbc1ca1046so3685215a12.0
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732551749; x=1733156549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45jJ/KI9oyZrSSm4+nzlJZ5QhCmWjzIkg7Hsb1EN4Vg=;
        b=rgGqzC56Uz6Hzsd9REDp3rjf1j1pIHQ6uPz+GfcdwK0ooYufHwfJ2O/R1N+6LdurKj
         V7UGFQ0l284mauQAHRd3vC1bhb/G4ODn2HlUTl4UhGu+7SdpxhVTk30iNp0XHLUKBbO9
         Urp2085k1ef7zgmC/mmlyN2JSMwnKpPOtGWXTgTdPwhi7RJIWGQ0hc2qdy0eVXLRMnEp
         4Cvz59pnvqfxaooDf5c49mcgD2XZbpr0HI2zfQYqfcnOsTb7Y1ESSyJAkB/J05BJJEjN
         quk/frmmw2KLMGLrX9C9bwkrhCZYorUcx+lPYE+Nw5IMyOWDwMfb4GBnMAuasG+adQP5
         6rYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732551749; x=1733156549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45jJ/KI9oyZrSSm4+nzlJZ5QhCmWjzIkg7Hsb1EN4Vg=;
        b=MR3qK5POpDiFdb8wQzZszKyIyEzR5RsvOPb4OeKYqL8nP5n9eSQfI6Z69vmSEy9cI0
         +AQA34vtfEV9ECHfGTf9QhTL/WxSWYDBzsPfZCJLss5Ko7pN8/Uq8mZRkquu1J7sUO1m
         jKK9o3NkCjsS4HhzTduzTXYu7MMOpWY3M3GYikGJsDT3XROoPDoR9ASWx2H3FZiIfqX0
         fJ4fkE1BnbX5bFsuNdNO2euqKF57wvas0aNGlJrHAl6crgjxOaLF9KgmwjD54tL3TXpV
         6LCrgE4vqI5cNKIKAka7gAuUb49M973H14whsh3106PDrXlFQbiqBWWHyqNcWfUd+/gu
         XHww==
X-Gm-Message-State: AOJu0YwDh/XrdkbST+9BzJOJpj/4/ASvo3lxax25CcKz4bPnmb8K+tJR
	7l57qERz+6sAz7Vj6FVRkNP0XPQeFppJehHgKhGhJPuoBwwJUwsZ5cHZi+u90UMEvEyNTRdBbtW
	4
X-Gm-Gg: ASbGnctON06sqFihu61TJWpml2+AFeircDe5EBqsoh7T409IQq2sEC3MWUdTuD+5uTp
	J01Ien1zersTy3LAm7DE1MC34F9NxpOWU8vQQQRZzu7UitMkgv4o0MkHT6V8tYbOUTTB2+iC6BL
	qup4Hy5VazuzgMiFK2zhfmwv12NJIA40jp7fZZfhUOmjOOdUGGeg1p0/Oy0uhJBYMb//pzJ4VTX
	lCFQyb8F4YIwEa1se8LWMNyk67jkJgsLROJjde/6N9ymGgvSu8=
X-Google-Smtp-Source: AGHT+IGouua6zlA5ob/J3I6+2t9WrTaLjIJnWF4inTG+BZmxNbTGLD2IxbsiKQQ0AWTXq745i2Oz/w==
X-Received: by 2002:a05:6a20:4303:b0:1db:92be:1276 with SMTP id adf61e73a8af0-1e09e406444mr19201503637.6.1732551749173;
        Mon, 25 Nov 2024 08:22:29 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc1e3fdbsm5831803a12.30.2024.11.25.08.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 08:22:28 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v4 2/5] riscv: use asm-offsets to generate SBI_EXT_HSM values
Date: Mon, 25 Nov 2024 17:21:51 +0100
Message-ID: <20241125162200.1630845-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125162200.1630845-1-cleger@rivosinc.com>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace hardcoded values with generated ones using asm-offset. This
allows to directly use ASM_SBI_EXT_HSM and ASM_SBI_EXT_HSM_START in
assembly.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile           |  2 +-
 riscv/sbi-asm.S          |  6 ++++--
 riscv/asm-offsets-test.c | 12 ++++++++++++
 riscv/.gitignore         |  1 +
 4 files changed, 18 insertions(+), 3 deletions(-)
 create mode 100644 riscv/asm-offsets-test.c
 create mode 100644 riscv/.gitignore

diff --git a/riscv/Makefile b/riscv/Makefile
index 28b04156..a01ff8a3 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -86,7 +86,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -O2
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 
-asm-offsets = lib/riscv/asm-offsets.h
+asm-offsets = lib/riscv/asm-offsets.h riscv/asm-offsets-test.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
index 923c2cec..193d9606 100644
--- a/riscv/sbi-asm.S
+++ b/riscv/sbi-asm.S
@@ -7,6 +7,8 @@
 #define __ASSEMBLY__
 #include <asm/asm.h>
 #include <asm/csr.h>
+#include <asm/asm-offsets.h>
+#include <generated/asm-offsets-test.h>
 
 #include "sbi-tests.h"
 
@@ -58,8 +60,8 @@ sbi_hsm_check:
 7:	lb	t0, 0(t1)
 	pause
 	beqz	t0, 7b
-	li	a7, 0x48534d	/* SBI_EXT_HSM */
-	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
+	li	a7, ASM_SBI_EXT_HSM
+	li	a6, ASM_SBI_EXT_HSM_HART_STOP
 	ecall
 8:	pause
 	j	8b
diff --git a/riscv/asm-offsets-test.c b/riscv/asm-offsets-test.c
new file mode 100644
index 00000000..116fe497
--- /dev/null
+++ b/riscv/asm-offsets-test.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kbuild.h>
+#include <asm/sbi.h>
+#include "sbi-tests.h"
+
+int main(void)
+{
+	DEFINE(ASM_SBI_EXT_HSM, SBI_EXT_HSM);
+	DEFINE(ASM_SBI_EXT_HSM_HART_STOP, SBI_EXT_HSM_HART_STOP);
+
+	return 0;
+}
diff --git a/riscv/.gitignore b/riscv/.gitignore
new file mode 100644
index 00000000..91713581
--- /dev/null
+++ b/riscv/.gitignore
@@ -0,0 +1 @@
+/asm-offsets-test.[hs]
-- 
2.45.2


