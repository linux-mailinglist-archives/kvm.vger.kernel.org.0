Return-Path: <kvm+bounces-38154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 796A9A35CCD
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74BB41890E75
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E511D263C72;
	Fri, 14 Feb 2025 11:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="l60BvZV5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852D3263C69
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739533507; cv=none; b=ILzS11aWHXw3mlrc0uJ3zkCsb05H8HtVjgkiyYkJ8OqKLQYumDwwC7toBYko2+UqGewTLraEU32cRO16GCtUGk8AZNd2v2xIXCNzVQ0VWiHGK5FpnDFFtMx7X9ESgpL7krIuGgv33m3plk7l9p4vQxGXRgmZ+OUKigiESTiGLUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739533507; c=relaxed/simple;
	bh=jESUoIiVf+aXvOQ83cPVki38FdHCDe2Q8h6/NUQd72M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlwfbf0DuUE5iXM9D6oRH3JIOAt9QMWzvmOrFRHyZMAk6+pmJu28pBWLMufFnhnLyYFe5P93dAMLMX/T6gRtUA4fhPzRrpi5ueN9bL5Rmc3eciuXA7tnmQl4W1bWvG4qDXClc0vblPBIi8B0NFfjFUlh3X2pay0wigJeo79GHIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=l60BvZV5; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fc1f410186so2238993a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 03:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739533504; x=1740138304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nnpsu3rpbhtzK9fRBX2NuscB3adm2w2G1CT7Bnabr1k=;
        b=l60BvZV5cwN4mTI2b7FYJJI3E9PKlSkg7gxWtbOec0mrroAIHreoxyX4RxDP4XB49r
         6DkNLfQ8TJX2qBNHUmRM74tkhyjVLbdevXYqOVKqekqPzVJmxmyJ0bGUgubWyGXJo9fS
         IGuXi93iImGYuDVFWHFA++I7YaOGnteOWetBr+z8S1VFTdtdSfZ8BjNRgTiAvY/85Eec
         Y6N8tApJwVIhvR4D8Wkou8LrK+4zhQVRkvZB33DJAGLPFw5/u3OccOVZArY43prRn2HG
         6h9OCJtCWf85Bgfk/UB8fpQDaO1xtzcmauzoZSKH0NWv/OPk+7soeH7e9QZAI9VFKGyf
         KNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739533504; x=1740138304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nnpsu3rpbhtzK9fRBX2NuscB3adm2w2G1CT7Bnabr1k=;
        b=L3vnf6WJesmO0nLF+MkKq5wcwrNPncs4x8gFv5SIP8qgOLeeQyp/EtgyxYaAp61TIx
         qhjOThtIAT9i/j/UlwmI0x4uYQwPxkYKsrqFfApFdn4vkjT8J+PVBrkMKaMmHKwuRagG
         6GXSZTSe76u1vxfnE/NmKt+Ogfs88alYxalPeqizhbZ1SyISGN0qw/9w97Yn+yuQOu4R
         VUKxTV8q1jrJ5xLqhoAb78chsK2xhYQdptT60iXSEcYD28+rSbg8pcur3pP16KiIevYb
         sU1jw/57ufNdUJLu/45d3XEUpUR85dQd8bGj318IAWrebngha0M8mkoAF6ioQ1nGWanS
         /Uew==
X-Gm-Message-State: AOJu0Yy67lIwB2q2cpGIv6DQUGe5hncfgNglnqNC7i1VP2Nt0LgHLWhM
	XeY4z/t048Oqtf86wVrARyWhqtILQhMw++Nj4OCTPnwsMe64Yd+y4VYJ3TBvFV96iXURUvSJbOb
	lLzw=
X-Gm-Gg: ASbGncu8EhjuHY+ywNOMLDBSFJ1V1mebqrfF4XDauxZBWcLPG0NVPz5rC6l+CP5TSyn
	/KkJeR+eKv/ZXQx3qMUn6abESjzk10raX+CEh53KOyLzehgcv3tUx6G50Vmy86HHeWVzScz0aKr
	pa4Jy4bb1P+qdroKzCKXGv5oQWAYEa5mGAjcWzgC2Uumj9xJOQVAkm0T7PRlQieBuBEfvhxyHlJ
	GFM5Q9HD2zX+3VYil4HTeGflS2dE3rWoT5rqHGAVSus4n+jTynNtCrbXoWNocSKeNLnZcHn3fQU
	qJK9Q1XYYUe1/ZUb
X-Google-Smtp-Source: AGHT+IHYqW+LJNTSPKwDmeiUyv2ngUOWTNa0uKhxLL7k8MS4eH7mOePBRxvn5882RLh1iBoh21bgZQ==
X-Received: by 2002:a17:90b:4a42:b0:2e2:c2b0:d03e with SMTP id 98e67ed59e1d1-2fc0fbf8185mr10461571a91.5.1739533503377;
        Fri, 14 Feb 2025 03:45:03 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98f6965sm4948862a91.29.2025.02.14.03.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 03:45:02 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v7 3/6] riscv: Use asm-offsets to generate SBI_EXT_HSM values
Date: Fri, 14 Feb 2025 12:44:16 +0100
Message-ID: <20250214114423.1071621-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250214114423.1071621-1-cleger@rivosinc.com>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
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


