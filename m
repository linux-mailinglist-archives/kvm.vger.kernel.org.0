Return-Path: <kvm+bounces-41044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0015DA60FA4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:11:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45DDC3B075D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFBE1FDE0A;
	Fri, 14 Mar 2025 11:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="iqypZvnK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D416316F271
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741950643; cv=none; b=gglupWqhWN/now+AybZzJacCpBt6eXpTHLgm+/YbBULtpmIUa9KFPKn1CncXXHjOkeST0phgtieJriU2jBSOs6/ZsYae8X0q04cvZNiGuJGBM7yqPxnM1r7+baO8zuBQ6vKwuKlsv7QktEy1jC7nNpKVLfOFhM7sHs+GzUP973w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741950643; c=relaxed/simple;
	bh=WMcAeqgXkwwkH48gxSeCvtz99ZLpGt6R2M4eU1o5O9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfTXnwYknvvC+t2S4nHyn3Shn18aEyGczecQqK4YDbTnyeBbRLi9ywai7wKDEhEP8FSblyJwoHgCGvX5/QGPYooWTzthSsWQgCm40D/L4RJnJDs9QOGiBs5K8hnqQ4saHQEICzNGFbUL1xmxHziRyc1Kwb2rEBfIZyqbMYFlfZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=iqypZvnK; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so18245595e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741950640; x=1742555440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=iqypZvnK2fr8dk+qc6/Hkk2X+UZADwrw408oyUduQ9B44P8zbdYWk4O4hytGZ9DQBO
         lb1un6f9aRiZJAI3rFJfgBzhNNzt4lyJIjagnqIUMiD54+ERl/Hr3phL6vUmavfg+BxH
         go17DC76iSc4qJ9yeJf8+J5fyYrghHr+1g67n0Mq3VJP/4bKyLOCbFHliUWpRLaP2Pc9
         FaKmV8ge5ybnhnUrxm+xB6/Yw2B9rAGl+skmw3kmlLdxp4RnypGi09TCgStAp5Xm8H0A
         YXV8ocK8eeiT3nN199pLUKlIGg6nHokyUQl5OgStVhWaLAQQp66ZBBB9b+9MtlODZ8in
         Wrdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741950640; x=1742555440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=JWWSzMbYCmNXTHPoXQggJsEKzMCyMpSNqFJKvMFkcgzSU8k1HsZvXXt0yuTv+4iCnq
         SHLYS1ISFkU6Y8bXxvb7MuLYfKolGLsQZzrGx40rOk4sqb20N6MnFHJVi9Xbau/fiD4l
         PSLqXbKZR/YVxbhznY3izhIEp8twRFwddgBtGen10bFmGARmZEMs3IbM926a80CvJ9Tz
         d7/D0YcBozMKUe6ZFpx118wvGyxN0mjWhhZ2IliLaa8lJHOU5uaNrQ8z6Qv+T6iartlR
         hNruDkUxA08xEc/R6WiTjTjohng6zAw+/bkQYKb89c6GPLX3ULn8UuIQ1MXdkXnIQDpW
         U9lQ==
X-Gm-Message-State: AOJu0Yxy7kybFpIMctSAM0WXS3auD/2oI/zN1u9BcWiTyailUA2CBoIu
	r3VL0UKnp80GOt+YCA/B+sp/mB2yoAaF58rqKV7nP539nTqn52C1SO3OWiOFXkmw5YgGoTYP0wg
	QVQQ=
X-Gm-Gg: ASbGnctP/MMY7qbfmT/5Z1vXi00rS0f8VoTm7TanjjH9aTmrdgmgKuOhlI0p+m/Hwkf
	ia2a3UwZJjHRhwKFQOLPz/OfR9c6VX9akUob9b/rGXNKG9XQcoNNHlZVmrtqsvrpXwAXLic0BHK
	reYOT8SVwDejkihSBm+/jk/W5KmPrC12A6KvVY/WQDpLmDLnxV7PKyc3bzTd9XUBS6hEA5C429k
	04nrF7GZ8NAa6KmFx7F/mEMgmleenanUkgAkBnojuw/Ealk03BPduq1ntmNDfMExkdRyYiVF1yD
	DVBKXn9qCbAEDiow3AWjenQ/KeKuJCO6RNcJh3zgftVZwmxJv21Ra4in
X-Google-Smtp-Source: AGHT+IFLRqD0+GtRah5fmDfiMyZW0TGXXj+pDnCO6vfFUhQoxNlSBVgzIrjuEjHFwzUxpLoxa2qikA==
X-Received: by 2002:a05:6000:1acc:b0:390:f987:26a1 with SMTP id ffacd0b85a97d-3971dbe7ea7mr2951045f8f.29.1741950639774;
        Fri, 14 Mar 2025 04:10:39 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb3188e8sm5299203f8f.65.2025.03.14.04.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 04:10:38 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v9 3/6] riscv: Use asm-offsets to generate SBI_EXT_HSM values
Date: Fri, 14 Mar 2025 12:10:26 +0100
Message-ID: <20250314111030.3728671-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250314111030.3728671-1-cleger@rivosinc.com>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
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


