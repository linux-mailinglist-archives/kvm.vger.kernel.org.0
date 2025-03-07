Return-Path: <kvm+bounces-40345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C77FDA56D52
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B4D03A3E15
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E264423A9A0;
	Fri,  7 Mar 2025 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="H6VEoWKb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E5423A990
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364158; cv=none; b=Ioy3+B1rdJm6toshzu8Wyfh/cUa4JE+cT3DpK91VeL4+1i/PhEiHrFTL3xzJ1m3SbZT72C/RakWKgZ92Iz7HeE78lZtyGBeEuXLitnmfuosuJG087oxCNw8zKrrvFhvgVTg0QQXSjSNHSBsPlkIeXinrqDzY2loTKP0xf/Rp4+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364158; c=relaxed/simple;
	bh=WMcAeqgXkwwkH48gxSeCvtz99ZLpGt6R2M4eU1o5O9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+w4yvPMV8V2rz/MgmySqX1SMTUevjYGDuf/YCVnJA3+0m76cWmnhH6rN9f7oVuXGawxwyk3kwyQQQyke99L2M8e41u6DlY3WeLIJo8b20AgC2rUDDh2arWzbLwYlz3UZFaHOitChSuMJt0cDij9w5uFhSweBiv43rZv95J1u1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=H6VEoWKb; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39104c1cbbdso1071105f8f.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 08:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741364155; x=1741968955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=H6VEoWKbyBGR3mbJbTedqDQuE1kioyz9t2yZG2gNryY8KQJHhl04t6Ut5u3gYKU6t1
         GtY9lfQY+y4Dj0E3mDHmhTe11c9MuLFUHvBKQuLxWvR55JvURQpOuUlZx/miWEX9J9Mo
         WDODeYYN728nUIz8cWvfpaZT2WYzjteAdjI5WGuhXMIeU5g2dZ3Z8dtjV19SCtmOaqOk
         IJ0RTUq/TQW7/1lS30mbh0VVacbdGtNdNZWFIo298vYWlqjQbAeciyHj8+WfnRi1+O4P
         IpSqWW2xy1r/sAMDPYxZ181/XYpbrqJj6SU8po/y3za/ux/zaCE3dLrrkqOflgq2hOcE
         fDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364155; x=1741968955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=bv9lWtCWR09f8VINDtUSLkh3uDk2CoT8ZCV2As8OOj2OJBLfFGgIeTINNfRfO4v+K1
         Vhj2ynlNQTc4JC31KEAhZ7cWnL3X3PbjsNlpKcFjM6KiqU00ig5vTw+Vw1DGurVtCMsO
         zh2ybqvXpTQ2oggDtYI+rnkjV5gDNHu3e5kWIMbYRGZw8vZS+/M/k077t3Hj35F9OpbS
         YnWDcBz78tm7ldE4FbRqwdqiPr2aNsNGoutZZBR9+WAY+ejQhw5dWiNGVjyRB6CV1NMa
         yUJpbCFuEPfHdDUflixZD6F8lRWX03wRnYIUQibZkXgsjnEjdfi0TFdfCK6T0v+yy8p5
         Md5Q==
X-Gm-Message-State: AOJu0YzcuOrKPzuwnRuKdELm81cxjI6Zol2XzrUXAJ70zfFU0CnEg6tG
	dZl2uSwGOo0VGG87FOkuG/29e6zMc4Gj/Jd4gNqao1mEdX5fZRWS7lsCkXgEGQlUqoTlQjvkCF1
	G
X-Gm-Gg: ASbGncua7K2eAA1Eyjn8JsDBC0ssRiouP23M2DfIZx1OouM8RMIpexQ6/9ezDyzU6MT
	xj/X7ptIo8E8puZYF0kBtPUcB6EczfeyirIdkXMwzVTFfe2Z4M9+ErEZHJMWzpaVB5hfrnM8QLE
	RxXFGFYi4V2mU0t5Afev1LOOMvIIpz4fTGrluyuC8VSQ0XGXlwfJEF8y75zuXsi8hMOAEZfvIO2
	v373Rw+lR5UsWfmpjuCYEZRFuWOTz0qVeNFWq2g0Ecx11bp1pouVd1H8Yhts4VdmsfTqy81bXQq
	GW/XzMEn3LCoBTZVrBk9rfrl5lN635Kb1pJk5sI+7vtGyw==
X-Google-Smtp-Source: AGHT+IHcCwpTjyAXPFIzNs53K4MT0tBUVdvPSgrXuPHtlFQbJxcUjhD9AItXnHJoW1cpUE6dZm8oGQ==
X-Received: by 2002:a05:6000:178d:b0:390:df02:47f0 with SMTP id ffacd0b85a97d-39132dd6b75mr2305650f8f.42.1741364154679;
        Fri, 07 Mar 2025 08:15:54 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8daadbsm55496245e9.21.2025.03.07.08.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:15:54 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v8 3/6] riscv: Use asm-offsets to generate SBI_EXT_HSM values
Date: Fri,  7 Mar 2025 17:15:45 +0100
Message-ID: <20250307161549.1873770-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250307161549.1873770-1-cleger@rivosinc.com>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace hardcoded values with generated ones using sbi-asm-offset. This
allows to directly use ASM_SBI_EXT_HSM and ASM_SBI_EXT_HSM_STOP in
assembly.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile          |  2 +-
 riscv/sbi-asm.S         |  6 ++++--
 riscv/sbi-asm-offsets.c | 11 +++++++++++
 riscv/.gitignore        |  1 +
 4 files changed, 17 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/.gitignore

diff --git a/riscv/Makefile b/riscv/Makefile
index ae9cf02a..02d2ac39 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -87,7 +87,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -O2
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 
-asm-offsets = lib/riscv/asm-offsets.h
+asm-offsets = lib/riscv/asm-offsets.h riscv/sbi-asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
 .PRECIOUS: %.aux.o
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
index f4185496..51f46efd 100644
--- a/riscv/sbi-asm.S
+++ b/riscv/sbi-asm.S
@@ -6,6 +6,8 @@
  */
 #include <asm/asm.h>
 #include <asm/csr.h>
+#include <asm/asm-offsets.h>
+#include <generated/sbi-asm-offsets.h>
 
 #include "sbi-tests.h"
 
@@ -57,8 +59,8 @@ sbi_hsm_check:
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
diff --git a/riscv/sbi-asm-offsets.c b/riscv/sbi-asm-offsets.c
new file mode 100644
index 00000000..bd37b6a2
--- /dev/null
+++ b/riscv/sbi-asm-offsets.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kbuild.h>
+#include <asm/sbi.h>
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
index 00000000..0a8c5a36
--- /dev/null
+++ b/riscv/.gitignore
@@ -0,0 +1 @@
+/*-asm-offsets.[hs]
-- 
2.47.2


