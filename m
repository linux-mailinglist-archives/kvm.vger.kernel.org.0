Return-Path: <kvm+bounces-35005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B946CA08AB9
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCC833A90D3
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E36209F43;
	Fri, 10 Jan 2025 08:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="sZgfgFKb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD5D20896B
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499245; cv=none; b=HbxqD+j5a8XWaCBqzK/8N+S51MrHu7UTgEsAr3vFyv8L4ZNcJy+/OO6QXpgRNK9+scVrrATAE//u6DBpiHez7ZZwBcfp6mEUYJ/DkzLaQevnK4DSl5KArauWIKacVfDezxF6ikhw2fUDfO3mS+Y/xXPIAj23ih1ergZULyFMWZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499245; c=relaxed/simple;
	bh=Gb65Ol1imts54+g1VS/AzT2BarihWc8ecEODFGRBN3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kEqmF+jusd0U7PIjKD58/XZc62i1ayR4YceBv3MtGvo7Urv0QT/jeHd/IKKQcYeBQ5DTEvvEri7dK5h7nm9bXeBZESMaTKC0aIWx8MPqQp39y8d70ivlzwQJZe1Pip0ZA6am0p/3A0jlIYKs76KL1QmK4bmTsTaA3QdXD8ToNp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=sZgfgFKb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43625c4a50dso13682565e9.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736499241; x=1737104041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnQmGsKLsnozl47n9RC0c9EPtHIieYibLLb9vAA7tl4=;
        b=sZgfgFKbe24xa887y6TS29MmBUmOr3e0Sufrpa5ai+sQfdwCSYyZGtMelPs1a6hnJb
         rsDi49hQN3PxMm3z177D03g9c/NET6AzLK4ccMAHmhZ4NxcTur7c0dHhqOhtegYLnx7g
         Z8bKTnFCyPrxe4bg/6dzKfSu5xNfuAcUfnmb56ZoPXKUTr/u+oZENUdB98lDVIA9OXUu
         dxkmNsb203JmP5C1TimeQgG6U9ZOWOBU0XjuQ+lMnTrlJogzuggG0uOc6aEZ29MBYR9L
         8gPmMjqoHlfeLdQVcmeuaWf785Wwu0B1wkSxK4la5qALwxI+ozhlLjcpynp47bkuN763
         65cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499241; x=1737104041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnQmGsKLsnozl47n9RC0c9EPtHIieYibLLb9vAA7tl4=;
        b=TXHAYEtUhV49YMMuCTTZv6nTp/oQoA5SXS+yz6OI5NcDu3MpVOzLRpAhn8z4P5jllw
         c74bpPXroEX3tHEaNwBgBVCV7Xw5BwOPrkAIJ1LbhfB+fmEd0BrfDjlklEOOkh2xrfnO
         crY+EVi7bn/wuViDq0Ggpwed2YmK0G+ft2cyXQcQlTqSPph3ZWRwSsuYEoEnHnUVoMCt
         S0aQYIfYCV9QmGu5zbfGosb2ikIlBc7wNFUi1shJ9jl9Fn7hZANoIvUGq+5A3Net0X5c
         UME5MPSghgGiENXUTI0DLm4zd4l44PcS84YrSPgxbYLbCjVC2e1bXtznM/rtNhHb5Pzy
         KnSg==
X-Gm-Message-State: AOJu0YyDFCHWa5bs1OUyhc3ienmNFNfXQEh0O/arjtoiQss0vGxMaWz2
	xdjnCoXZCVRXRAhzPlpTDAH5ocRB0O20bI+knED/8DcpqxGvJ8bERJCHIjlBd7LyWmgoH/7Yk54
	K
X-Gm-Gg: ASbGncvUsRoL5ShSdN1rXWzO1UV98GkpSW7UFAI5J5XzZefqENI2Kbl1LMbNiFkydNr
	IvZDzIjnaXyQCOOasfAv1z1jSUpeBkvRgaNuACIP8EKgGPM+Hr4N7nmn/vHUo+kTGklJTQAvGH4
	C64OMx3LbzFfJT4WHX4qu/fGG5/Tn+EsjzbZvyO1wNr2dWKQZQqwnj/fDUha4SxrHqnyKvq3f1F
	rJlvtvr+hFi5CIa7+HjUyBGE5ExpLOPLriz5F02cvp2c3bTbiB2QLqPig==
X-Google-Smtp-Source: AGHT+IHSp7thkaO0ix4+jtdZrrUsOh51aI7hC2kJTrlaApqKho08Ju5UKyE6qqhDE4L/4LmleDyhNw==
X-Received: by 2002:a05:600c:a01:b0:434:9c1b:b36a with SMTP id 5b1f17b1804b1-436e269715amr91208755e9.13.1736499241614;
        Fri, 10 Jan 2025 00:54:01 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1ce5sm4009283f8f.94.2025.01.10.00.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:54:00 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v5 2/5] riscv: use asm-offsets to generate SBI_EXT_HSM values
Date: Fri, 10 Jan 2025 09:51:15 +0100
Message-ID: <20250110085120.2643853-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250110085120.2643853-1-cleger@rivosinc.com>
References: <20250110085120.2643853-1-cleger@rivosinc.com>
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
---
 riscv/Makefile          |  2 +-
 riscv/sbi-asm.S         |  6 ++++--
 riscv/sbi-asm-offsets.c | 12 ++++++++++++
 riscv/.gitignore        |  1 +
 4 files changed, 18 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-asm-offsets.c
 create mode 100644 riscv/.gitignore

diff --git a/riscv/Makefile b/riscv/Makefile
index 28b04156..af5ee495 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -86,7 +86,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -O2
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 
-asm-offsets = lib/riscv/asm-offsets.h
+asm-offsets = lib/riscv/asm-offsets.h riscv/sbi-asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
index 923c2cec..b9c2696f 100644
--- a/riscv/sbi-asm.S
+++ b/riscv/sbi-asm.S
@@ -7,6 +7,8 @@
 #define __ASSEMBLY__
 #include <asm/asm.h>
 #include <asm/csr.h>
+#include <asm/asm-offsets.h>
+#include <generated/sbi-asm-offsets.h>
 
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
diff --git a/riscv/sbi-asm-offsets.c b/riscv/sbi-asm-offsets.c
new file mode 100644
index 00000000..116fe497
--- /dev/null
+++ b/riscv/sbi-asm-offsets.c
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
index 00000000..0a8c5a36
--- /dev/null
+++ b/riscv/.gitignore
@@ -0,0 +1 @@
+/*-asm-offsets.[hs]
-- 
2.47.1


