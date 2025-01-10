Return-Path: <kvm+bounces-35006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC19FA08ABA
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADA5F188BEDA
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168DE20896B;
	Fri, 10 Jan 2025 08:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="NUmXVVG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865FD209689
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499246; cv=none; b=VQCVPSZl50lZlAU1nmI0Z6lIL5tAvZXwFLYaW5HhDw05uN/VGT1gZaN9XhNYAku7JtCaxnoDraATKSJfkJKCuGjm42YQ5otL6ZJpkE+Si2CxG2s5Fg5AeDn7ihg1PVU4T8qnFxQiVIgfHDaDdSge9eCP14BQ3K47Xb4VqbY6tCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499246; c=relaxed/simple;
	bh=Sa9dHP7tI/RR+RDxtPW8kDcgOv1H2iSykIF8FlbsYs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B3pm7hebyv/SQ2wEZfd2ZXiucxwN9H06ckstiFFQeKi6lAW8K/Ri5Hq3sDFIu50SlWBC0f7d/HZ9tXSKYAf61F3PaGY8ArQEZ/DJMLj6AB38BuL1a2MxXaRMs4HIYBj4INIy9CBHaPpB0sb2CS6znvfcmag/z3AA4VqCz87pwec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=NUmXVVG8; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4361b0ec57aso18189035e9.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736499242; x=1737104042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eo2c3Kmn1NpBbL7JEgarZYwtdAct+NbwdDVbie/BNhQ=;
        b=NUmXVVG8W5WDRh3kYQokRdjBHgkzqXt82TAkfUOfLiQGgZJ4JGKwfaoIB30pHEIWck
         6oZTLQaJ1mxjEOiAuw7CI4SPiNMLKRwhw6k4wr8jTnidPycy7cFSWUgNcq8Z5b+CYBDA
         czVnuBl0XGcW5G/Q2m3+ZyGIpfbwZeRVtElOS7ZpViLlaDzb1fXhZtqwB7Ipw6SrRfSQ
         wefXJlNxHJPr71aMQL5yGQz4UdTcK2g2ADPiJPB1MSEdrbC0pPJDeUIXRZyAQ3TPeBZv
         sh2AcavWV+oAHM7VGrFtHEVo1X15gnhkP9SWncPDoYetTuX4hgf9ltHOfn2TxGI2KZ9/
         qEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499242; x=1737104042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eo2c3Kmn1NpBbL7JEgarZYwtdAct+NbwdDVbie/BNhQ=;
        b=CP/lJjZ3b/TlSjexGHKjm3xIG6WeprmzrO+YCr29+G4QOCXSECez7tZjc9cXmhYSJi
         jxS1FHR7IK8YSvSKcpRlcwO32yueNsJu4kN/bu1F75+dxxFLpQT2sauEZPON1SnTGLg0
         D2XNAIT2m/2FEgm840BEnv38NwutS3oqFQs2o31I28+Hxk+0Db1YVmM4bIcezP7a7sDe
         BIAeuGblFlniGz4gjy7pEksgelvWsjymbMMmIg0xCLZJwsX4+aKy/cWKmjWff5IpKYF1
         w5LyFlPwuoJYHVHt/l6SaVE3QlQ2TYeZcK2CdJrdSPHzNGhtQgK33IqtdP/3HpB56LAL
         nhrg==
X-Gm-Message-State: AOJu0Yz8ji0ki9O+ukv8H65UYfD/6GryXM83UzGjQT1dEJzZbJ7uzAf2
	5SSI87CdpFlRFeR7lb5wB8rmISuJegUX+g6g0IoFuK7WzV97Fw0osZetuZMTDsEdV0VJGuJD3Az
	p
X-Gm-Gg: ASbGnct7hsoSq0RnAgxm+GqimNnKm4tx/WFdXX4YtBWrlEUwlraOJpZUiiegMXqtQ8g
	dj4wwgq/gZf7oHNhC9Fz7ZB+yALHE79fmhxNH33MrempB+0xD0n6FqtH4Uh9zv47rxQ08NHBp9c
	wOMv0Pz1+hESK97wnLOZeOMuZIc8FIBfMiUIK3ys0lG9JiuB+CV75v3a2wBsi94xOGEQAwOIyu6
	0WKP7Fg5HvZJ84APffnVMQD6I+lvp61wOg3ORfkAtE3R7FPpDKKLnJgGg==
X-Google-Smtp-Source: AGHT+IELiLUe9pIM01/duXyEhp8KpplnlsSsnZH1U69fLHxCZ1KJhYpExjgHw6icQ4CFPxg8upfmOA==
X-Received: by 2002:a05:600c:a07:b0:434:a815:2b57 with SMTP id 5b1f17b1804b1-436e27082e1mr86774845e9.20.1736499242527;
        Fri, 10 Jan 2025 00:54:02 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1ce5sm4009283f8f.94.2025.01.10.00.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:54:01 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v5 3/5] riscv: Add "-deps" handling for tests
Date: Fri, 10 Jan 2025 09:51:16 +0100
Message-ID: <20250110085120.2643853-4-cleger@rivosinc.com>
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

Some tests uses additional files that needs to be linked in the final
binary. This is the case for asm-sbi.S which is only used by the sbi
test. Add a "-deps" per test variable that allows to designate
additional .o files.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/riscv/Makefile b/riscv/Makefile
index af5ee495..40ba1198 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -17,6 +17,8 @@ tests += $(TEST_DIR)/sieve.$(exe)
 
 all: $(tests)
 
+$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o
+
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
 
@@ -44,7 +46,6 @@ cflatobjs += lib/riscv/timer.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
-cflatobjs += riscv/sbi-asm.o
 
 ########################################
 
@@ -93,6 +94,7 @@ include $(SRCDIR)/scripts/asm-offsets.mak
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
 
+.SECONDEXPANSION:
 ifeq ($(CONFIG_EFI),y)
 # avoid jump tables before all relocations have been processed
 riscv/efi/reloc_riscv64.o: CFLAGS += -fno-jump-tables
@@ -103,7 +105,7 @@ cflatobjs += lib/efi.o
 .PRECIOUS: %.so
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o
+%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $$($$*-deps)
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
@@ -119,7 +121,7 @@ cflatobjs += lib/efi.o
 		-O binary $^ $@
 else
 %.elf: LDFLAGS += -pie -n -z notext
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $$($$*-deps)
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
-- 
2.47.1


