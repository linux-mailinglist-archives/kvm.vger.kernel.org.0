Return-Path: <kvm+bounces-41196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 238F6A649C2
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:27:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 138BA3A1E81
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DCD237A3B;
	Mon, 17 Mar 2025 10:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Mkv8kc1n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE354234994
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206816; cv=none; b=AENjzLsqY2/ZWe47Cmo6D/vXcfMLignJCsvzGUUI+yEEnHQqCNQCR+wKHWaQfjtzXFD82U8RcGPEBL3U8TUYR1Y7130ttjkXXmxeuMqoKK03ApI0xlV4xrNAPGKo4kvjjIqTl4+jDhHfyKsOgYR/e3YzPI8JNIIPdcqXH8vpGMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206816; c=relaxed/simple;
	bh=WMcAeqgXkwwkH48gxSeCvtz99ZLpGt6R2M4eU1o5O9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XT3urxwSnpPKYagUQeg9e+Z32wjlYfNkwqAWmdmxe20E7PlT2ESG9/fMdUDY0AIaKrh5dcPiydYtEn+tajf93vdg74XbLcJtxJV4d8Hio6DoEBHqL080b6kLOX9c1lrrG6+6jFzr+L/q1qmUoW4UuPq6p0WtJiO4/g0aV4HVL0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Mkv8kc1n; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39149bccb69so4125178f8f.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206813; x=1742811613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=Mkv8kc1n74TXC2W+KTJppyBJpAjvk2+5+5TwhvXNoa2mWQak7jImcY6Pxzcb0GPZo8
         FBJndRN4xfI4LT1zvXI+CEMsp/rzcjAbqvPx3PXCnGYM0A4Q8sJnKViL5zGirIMpoMP7
         Iw6R60idn8LRzIiLDlonxOi6REjjTyyGp/61hgjHUqhbQB23qTKrwwxH51XHRRvHMp+Y
         vUEaO37K5qI5DUbKT1lOh8Ya1FLDZv/4jVi+h+PZlSPSw8Nh5ZRTsKeyhvlQYUAsSmbM
         lon0lm9OrHbv8LDLJORJo6zZNVWjD/0wTJFSUSLapAZr3A5nV1r+85ZCWLc8ccz48RzX
         A6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206813; x=1742811613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=utas2OATP+yiH28/Rm+TspQabPL9dpIxeywFwxunsLg1/0XgIuCzc2YmuLCUyUiTKU
         dLbdmF3G7ZM9vAl+xXOf/YQTm9fRQ0jjg9CWJ5MNVAjqIFU0R1fY/IdpOTsUUgH5pjEQ
         lQC08rHxKKDf/GMVrdfFgiFql+jEPLjnOfpUJYeo6SKLD/KDb/Kx03RHI5mDTVvQ+V3F
         U+H7PiIMOWbrZGA+TruCAe7gRZd2ZHnHAZtaSFM7uekdSGZ7WovfVIh1JpqYhDwZxpJW
         6dKGYLtHiLfoFtaWxJEr+MiA+8rUjjLBX1SV2QXq0vVZ3HPrQApaQnKeGvtJr8vy/TyC
         e8ig==
X-Gm-Message-State: AOJu0YzCI4FP0AQ95ZlVJ6bv9aLJDNLqvUPV0VcZdXiMP15R3m8WxIlp
	pOYXSepZkNzWagrXsp/2D+lJIh3+6frhbIkAXyKG7o4fRN5YGElMeYTQcGdNuo/h4usPBlp57dS
	23WI=
X-Gm-Gg: ASbGncvj5auSqbPN36bwFqhxy5atSdLQ1PAKx6A6EetST1uwPkamcGkjxDQuSK3W+I5
	5nRu6WEMaM++FNuQKWHVtS8Qr5UcvYg6h26vdXx7svvnwB70sHxnuVdVfAUWbwJdGDjQ3Vk+ySN
	Z0GlDIMTr7skFAoUj4ntZvkal/kVK6ZL3OrqvfJKfbqOaxIsjFosfacMBrrvve1+f3nfebG3+WK
	lRyu2wnb53Ydb7C7+8K1eTj12HydZg4zRcbq70vpwtl3itwonngCNBlnW7xin9IB6hsRC50PGZb
	+S0umV+cWXVfFj1DZG6c4LoKn+DcycFDlkUgf7t8PE5ITw==
X-Google-Smtp-Source: AGHT+IE1tnKk23bs7U1cBOzZ5UV8PPIvISwJJiu/cnj0iy9O6xIhdVEiKXt/ZRtS1QnYe/wW2RNarA==
X-Received: by 2002:a5d:64a1:0:b0:390:e8e4:7e3e with SMTP id ffacd0b85a97d-3971cd573fbmr12375367f8f.6.1742206812782;
        Mon, 17 Mar 2025 03:20:12 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:12 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v10 3/8] riscv: Use asm-offsets to generate SBI_EXT_HSM values
Date: Mon, 17 Mar 2025 11:19:49 +0100
Message-ID: <20250317101956.526834-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317101956.526834-1-cleger@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
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


