Return-Path: <kvm+bounces-41252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74667A6593E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CB5319A39AE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B442C1FDA69;
	Mon, 17 Mar 2025 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="i50Mov0/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B871F892E
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230186; cv=none; b=W8jIPMute7w08Wmsl3ziS4U1C7ZMpAW5jYQ+fTGjCbWT/2C/zw1JvII1fJERivcPTD5dolkI6rzo8YDLTParB2JS0VKrgZg5UZ957a8gZx0YZyZiLHGBcA5DpLVVo75lAYHgBnuqb9Co4+M4a37Y+DtCKi7iOVywS4nm8pn8td4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230186; c=relaxed/simple;
	bh=WMcAeqgXkwwkH48gxSeCvtz99ZLpGt6R2M4eU1o5O9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkmXkLzpk5aM20hHeC/0HiebtRC5MEl0l6PT272mBJQDlegrAOWKHY7AFaoQduQCtKg6KZnH53yOZus8qY9uZTIwck7hFdJho0Pzf2LduZkEVI/dZzfK0Q7Z9ytF8YcI18Q4OixOX+4IQW4nOZsRt8f2G3QtJDnp4lZoHiI6fcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=i50Mov0/; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso16594875e9.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230182; x=1742834982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=i50Mov0/zowrFdZQ6CBZ6KR1pl57LizA2tZxIfG7fmnrnUv/swXcC5jyfeAXYRetXS
         DhhlWEoFrhJxFJSugYQyDKk40Sz0g5X+O5kOBwOKE3PnHacxUdr/XNnL14E/zeU6qXAs
         K9YTDtigZlKyBZQgRpbUKMq4iailoN+R7l8OA4hyNPSvcEDx4IYgprqzLJulQZhl7W/t
         EXcQOzYNy4fXYux0Hc24lkzTi2hlQT7rR6KULmCD8q3wQP7fMhuMIwyp/lA78Vo7OXff
         DofPwj4A0HOKzJkHCaMPLV6tc1QRyQ5JviM9U73APrPlyPHk3oYq5eC2nrVIv5B8vvVP
         m6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230182; x=1742834982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6xs0cTjWqrdDwyk7E4bpCxTQMeqygyQS+ITTTaO07U=;
        b=JBJ+qygBnDuapBKF2KLAgZCXRUlhVGUyabVb38sLT5js6/BuKSA2VR0tHE0i+ebpQe
         gJKgruun8ytCBGSPrcIKu263DyqELfvdXuvmTm7B07QiAA6xrtIiRcUCXkwn+OJJwUgl
         29nzDcyuhmmqgKPrTg/qNc87wXEJYhAeEfAHCjMJwo6SmpQhDo+p44KDjxpXvWPSYcvt
         ZAkGpYiWss7ifmLhb13fYunICMDB+YVRMk9ZKll/5bErUQPuARB2OIs0cBqjA9Scy65V
         /T8mq+WVl8MUU+Gf188LI4EVWMtx8NZSrkwLHTMajWRd6DIA1aAuXEBk/LXZZ/8BBV2b
         C+Pg==
X-Gm-Message-State: AOJu0Yyk9iH3VL5opWjIxv6ic6X7T+To5y8OL4LMhqaluiBWDRZjnumI
	f5B00kTLmbclXSiDcbYiyaVQmpRoKPjqrYV1X493E9NPalkQ207pZHV2yQmlW+43RDVILYTVjbs
	8dJw=
X-Gm-Gg: ASbGncuQbHiow/eyH7rq66sHeGdTorof7ghegm81kVngefPAHssembclGBJ6QSD+lPk
	athFCw2+YeQ0pJn66YKbfmyoEupNcD1P4w2c5/hUtDCqUViR5QzZpsPMESQcmJwCjhEIxUEGqn/
	qznynHDSi0IAyBms6Sy/5I4PO1CxUMM8PGdjbiW46zrSG9fUs/kKDIzyNrgN+oR9VR/HVkN20td
	hRdFqICQXtbSgAozSkMgwu6Y1TdhusO1OwXfowDMZeDHGsNZkwT2AvPIdIp36Ay6n6wXxkcwVM1
	UyvrsUiyWN2c8x3jJjTIJlYV92fhBlVShwNwzbd0CfRYw1PWUYKrK46v
X-Google-Smtp-Source: AGHT+IEAxLxzcY52gpupthD5Y5Q/p40zCmUKAOB8WbkcvABnVkxA7cVybicWHwMktPXdkOmQxbzVxw==
X-Received: by 2002:a5d:64a9:0:b0:390:fd7c:98be with SMTP id ffacd0b85a97d-3971d9f0df7mr17970539f8f.19.1742230181810;
        Mon, 17 Mar 2025 09:49:41 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:40 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v11 3/8] riscv: Use asm-offsets to generate SBI_EXT_HSM values
Date: Mon, 17 Mar 2025 17:46:48 +0100
Message-ID: <20250317164655.1120015-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
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


