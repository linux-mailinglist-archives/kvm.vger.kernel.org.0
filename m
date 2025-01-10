Return-Path: <kvm+bounces-35033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB6FA08EEF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:13:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 547723AA096
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76631E32C5;
	Fri, 10 Jan 2025 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2O52mjey"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40C8205AAF
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507585; cv=none; b=PozYLZsHih0ENMZA8K6QIQIpJotyqIngjm1VH3Dvkz4Jnz0t2+vb2yKw5iMND6vBUJq3ILAk30qoILSEnyebagk9fv8gyEJfQ3xJxmncV6Ns33zXSvQ7oLj2PvF7MnVQkysuHCYGL0ELi0oKIX2TK0d3lAiMvLXOLCGY6756Now=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507585; c=relaxed/simple;
	bh=Gb65Ol1imts54+g1VS/AzT2BarihWc8ecEODFGRBN3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjxywo2Yv0yse3pLsdi9yOI5/SDg7kLDi/tpaAdso6TRQdUR0foOxn9+llnxsoRqoWl6ngXQgQEnEP4W2tNuw4qdKOD5YZP73vgvoW3ppxUqV/3RqCuJyPOzi3rnryQ4KOODSSOLbQyHIME1u0LwG3ExzMe2MDFTTPxKHVzPJuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2O52mjey; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3862d161947so1033377f8f.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736507582; x=1737112382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnQmGsKLsnozl47n9RC0c9EPtHIieYibLLb9vAA7tl4=;
        b=2O52mjeyizwvqiDpO604V3/HbjoKU9trYU/PJHccLQttdUJi4PuDtU5ebt3EuSWyC9
         VQGVCVGdThdfOGxqT3LUjZC3s2gNl0IwDKwKDRwtBJrwa4tFFRe2wBiFRWVj2cSegkbG
         R8icRbB/y2ESq8NR5+lUoX8LEKudiWLvukg4tzHtUEBFUrNmYF7NqlFpWSlmQ/+X7MFf
         NeXK3uI0LTqdXQTlce0CINaI1AIrUxTTZG/GGGiljRBO7NmFChQrS0EVQB6KxFB542nl
         2eupqY+NCPhT8lfOSRwfQ/InKsZH+SMWak1z4lVedz24rz4oGCX/Yj69Na6yj6rWhxeQ
         be0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507582; x=1737112382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnQmGsKLsnozl47n9RC0c9EPtHIieYibLLb9vAA7tl4=;
        b=i2KN00RWjDKIGo43i9Wo+JDgwm8l38YkXbVILu1U95LtIb2vaGARjXoXAzvZgL7oHi
         b89PNgQiFY/xayuHvrjor6uj06VU8fEVojzqSsRT7q1IXEyntBwBFMH8YkZhNKth+O//
         cinWY55del0XlwatHTvyhnFCv3KPLRGWCB728h80w2y5MDDHlR+d9RwVq2eULM3VP9T2
         s0SisnxllbzwN2Mil+v3PxlmiYpYY9K/PItE+CxWyzWvJC06Of9Iz8u+4ZRX+MtLBEel
         bmF4bztR3EjM5ImMZK5lTWxWDFJbxsvpPjyf1JPbRCIzr0/EAMrjLL+hstKr9KsJPgwf
         VBMQ==
X-Gm-Message-State: AOJu0YyeUezyU37WxpAvrCKl4Qf+uwc2tF8sdNhLX3EP2gplgEnIntWM
	GilXySJnmL/I+WCBMBwRfortGjyrVrLGC7HH/vjQ8xxaoxV0Yfos2ugoYeqwLWpOvoO/TyhRPXw
	Q
X-Gm-Gg: ASbGnctaBpUNsLniwdSdZw4ONizg7wZfrkuGbQZj08+rGgarDja3LkBSBmbPE9E6D0i
	79DbDUs6jw/AdC3rWPugxWezQOytphsE+YZJCbKr/GppsJSM6xzSYcbITQtnT2COqZts4ehMTqH
	nBGhln42pEBrkInB6Y1+3V+E0uUOw0mwc4bW7t8W5KHdG5NJcdrhAfLv4DZRPdWvQOwae+HgBn3
	ps32RhULTUsK1RMoYVf5tGLBgoyYI4qB20veyQuQfpDD5+JUM7AZnzvfA==
X-Google-Smtp-Source: AGHT+IEkbkFNmBm09O9HVeA7LH4p17JRlfw9wDP8tSTFQSoyf7fVaPj+wmIidUmNeqtb4Qih6vmYAg==
X-Received: by 2002:a5d:5848:0:b0:386:3dad:8147 with SMTP id ffacd0b85a97d-38a8731c975mr8448524f8f.32.1736507581952;
        Fri, 10 Jan 2025 03:13:01 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38c1d6sm4344459f8f.50.2025.01.10.03.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:13:01 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v6 2/5] riscv: use asm-offsets to generate SBI_EXT_HSM values
Date: Fri, 10 Jan 2025 12:12:41 +0100
Message-ID: <20250110111247.2963146-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250110111247.2963146-1-cleger@rivosinc.com>
References: <20250110111247.2963146-1-cleger@rivosinc.com>
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


