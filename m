Return-Path: <kvm+bounces-17602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED798C875A
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 15:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A8B4B22EFC
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B59B54FAF;
	Fri, 17 May 2024 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lILT4crh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAB61E507
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715953216; cv=none; b=Ba2LKNj8nVc/9x26RMdNWlSpEpxYuEgD83hnmW2m1fkLLfJM942x7cfyi4jWuxfbVEeGN9ndPKBqleqPdjrbDmp0Xd+SPdFGIQSicDDJ/IYtGcYSjqfKDtnEVVm7Vt61cRfZRgEolH+H9Kl/+KzfY6W4BMWhn+2YB5IHlp9Xj3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715953216; c=relaxed/simple;
	bh=6ujubs7v5yCnGZc5e/QR6dN2R1rJdBpfT9oeaW4arro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XdTDcoEOF5duetcGsME58IklIhfve0fx7kXi1TFvRNek/JIEn30YnRlYPuE8fPqJt8kNydYwaG3ICoWTY287yHZwD2SU9Znzp++dgl2aZT/KxbqqEr6h3b+i8O3IxDnluMm4RyMf60Zh7DO0pXqk6zjv5WWuvBojljJN81xgubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lILT4crh; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2e2554b8cdfso587221fa.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 06:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715953212; x=1716558012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiPUoWXGycjCV4H2caLI8wPFwzPpr4ZyRJjWUc3GD0E=;
        b=lILT4crhwh/ZQKP9Z5+5LQtJaRpPUhLoEMSNH2lsNfqQQgeSxnji46h0QBD34vNRiZ
         WlktItd6GRKVR5PG4M/RZSV7KqHXQoqDBxqgYiP3oQ563wpK/L92uicrZKzQv1WSIIRv
         KsTU5h1D+u/7zzyM4cocPpX/ysrNFkssJptNUFgnfgkRhFfu2CwHSlHCfm91jc7/J2Hl
         uKXipzLMrP/Bh8eaIsO63fnU+CteXPMvZSDkiFL7ELhXaPTPdTJRzTekO2NHWS+/84Aq
         OKbfxfSq/mO8Qfcgc8k8QUvC1+svgYiNIByoXrmprXYiQAEB+a/tqRv6gw26noF9gsnJ
         /QuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715953212; x=1716558012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiPUoWXGycjCV4H2caLI8wPFwzPpr4ZyRJjWUc3GD0E=;
        b=kaRsBAP6z4/v1gJLbrVYD520p4GaQhmgasb25f47MDUwxqC4p3SKmRoBTdJGBVC4IY
         AeyOotcVt+EHHEcgIEwbojH48TOaF3YOFZ6BAywbPYmrUEmc6gwQG+09x4Mq5/pH2312
         kzULRtjNVZE2ezWtmHqIo3n9c8tDYErR1hheszvUsTvzQ2v6f8gV/NO5fRThGfBkdVje
         FTDo3+DXq2MnLfNH5Ti2lXZgRthuJHhqV5fj7d8BylM0d+/N0l4Flit22hq36sTxwx5O
         0XgSblOFMuvOYwy3uhXaMtBxOiGKXohGeV2k/nTgyKFDCO87FK31qCCzS3HggL8GChhW
         KHrA==
X-Gm-Message-State: AOJu0YxSEBZdHaJuQuMHwKOET0+3+FvSFsn+sJTN179pjU6JwZb3QmZc
	JVW9NuRtYKETV/SKOjOqW9X/BrISCOXplwY+stxb3APGFq4nM4dUEZU9YYCxhiB8tFkOBJ9eHop
	kQDM=
X-Google-Smtp-Source: AGHT+IGQ4yU5OfslFvHrmaaNBWzo/A4qApS0K4KT/T9TcNj9oj4eile615E5VVCVv+D0M7SFfiGcxQ==
X-Received: by 2002:a05:651c:19ac:b0:2e2:18c2:9c8b with SMTP id 38308e7fff4ca-2e51f262c65mr153598271fa.0.1715953212229;
        Fri, 17 May 2024 06:40:12 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:46f0:3724:aa77:c1f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4200e518984sm240669275e9.23.2024.05.17.06.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 06:40:11 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v1 1/4] riscv: move REG_L/REG_W in a dedicated asm.h file
Date: Fri, 17 May 2024 15:40:02 +0200
Message-ID: <20240517134007.928539-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517134007.928539-1-cleger@rivosinc.com>
References: <20240517134007.928539-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These assembly macros will be used as part of the SSE entry assembly
code, export them in asm.h header.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/asm.h | 19 +++++++++++++++++++
 riscv/cstart.S      | 14 +-------------
 2 files changed, 20 insertions(+), 13 deletions(-)
 create mode 100644 lib/riscv/asm/asm.h

diff --git a/lib/riscv/asm/asm.h b/lib/riscv/asm/asm.h
new file mode 100644
index 00000000..763b28e6
--- /dev/null
+++ b/lib/riscv/asm/asm.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_ASM_H_
+#define _ASMRISCV_ASM_H_
+
+#if __riscv_xlen == 64
+#define __REG_SEL(a, b) a
+#elif __riscv_xlen == 32
+#define __REG_SEL(a, b) b
+#else
+#error "Unexpected __riscv_xlen"
+#endif
+
+#define REG_L	__REG_SEL(ld, lw)
+#define REG_S	__REG_SEL(sd, sw)
+#define SZREG	__REG_SEL(8, 4)
+
+#define FP_SIZE 16
+
+#endif /* _ASMRISCV_ASM_H_ */
diff --git a/riscv/cstart.S b/riscv/cstart.S
index 10b5da57..d5d8ad25 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -4,22 +4,10 @@
  *
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
+#include <asm/asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/csr.h>
 
-#if __riscv_xlen == 64
-#define __REG_SEL(a, b) a
-#elif __riscv_xlen == 32
-#define __REG_SEL(a, b) b
-#else
-#error "Unexpected __riscv_xlen"
-#endif
-
-#define REG_L	__REG_SEL(ld, lw)
-#define REG_S	__REG_SEL(sd, sw)
-#define SZREG	__REG_SEL(8, 4)
-
-#define FP_SIZE 16
 
 .macro push_fp, ra=ra
 	addi	sp, sp, -FP_SIZE
-- 
2.43.0


