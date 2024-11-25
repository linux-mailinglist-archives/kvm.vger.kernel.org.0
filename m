Return-Path: <kvm+bounces-32466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD5B9D8A31
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:22:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02B63281BEB
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E2C1B4F08;
	Mon, 25 Nov 2024 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="H7g4eWFF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E345C1B4139
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551757; cv=none; b=jsrOC4Yz5WUNcfMnCXzMzs3QE5aCXZ+pCCd2lnQoGJ7xD0nlJrYhobKSo+7ODOB6dyNahmSzkuVXIfiEXDPk9Wczq3fgbiK0NQJfRJ7m53bkK5cRRS/H+B51g2dpkFUjrf9F3sNuohqwdBE5JLShmY1qN9X+Cuod3r6WHRaTx0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551757; c=relaxed/simple;
	bh=V2N4v1erFv59UCmjGtI2cRd4djSgUnTHCFMHBOicz98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igVxqFOuSvCYfIkSEAkmQekGgVTYTOg5h+jScBEIvVAYJV+c5rxSzoUB/yC+Y5oEGSiDEujYAfBBRSXMP7mHl6bQ10QNbIJssCYiPtYndcCvjggRIKLta18lE0VRXY7FBv/gzOqL/NBNVdd4/yJgzhisINZLcxeitRT7Q9FRo8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=H7g4eWFF; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-724e1b08fc7so2877155b3a.0
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732551754; x=1733156554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cecPyFFtTZey4YiLBonJP0TEn3OjwI9DdlqduZM2h6c=;
        b=H7g4eWFFOu9vWoGrm5iFBGvLpqwDAMhrBvli625xb8GeQTzeMvD3YcCW8hingeh3iB
         Y1idldp0cdUY2/44Byk7R++G8rVRwoazlOF9WGD42Vih81ESazLCL88b+hycMKX2kWwa
         1Vs7LynmO4n29bWPWDYGAn4RgHF9hMn/xkpkr7KOro9TkRX6MTeygyx7lU3y5lD4sSnJ
         vjDvwru3z4OufxsLmJJukicU7/B480do0q27g0EaNW2BqhVNxIXaISXxSehQT5vnkiRq
         S3BiaX+8c3pm06qyissfqdS3Mkm/vYqCvJJac27RXbPC/OCFWydSXml3vJqDPMQkrduR
         dJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732551754; x=1733156554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cecPyFFtTZey4YiLBonJP0TEn3OjwI9DdlqduZM2h6c=;
        b=W4zFciLy1JgZcjlkxD5JWi/BgvLz36wv7RbgtuU2kVOH4YqN2/7RRoLTSp6rNsk8B5
         rpD1KoXYh2yeJG+EtKU+5H89GPhKvMJE7wvJMAcTkwVKJ+1rZzSH1yjXHeLQ69h08ppl
         NidB9Q/nmGQB547ze2/YxysS+6iQgv7XpEbVnUQ0GYHORHXPTK47JRb+5MeGBO72WYAR
         sJ2/2jcWOpqdnyQ8YcOf3z7Z6HMz/OsnpLo+7SVuNrhSeHzHe+uLcfqrh/BcmpTlvmHy
         UkQTroojnHknI79BbMQgdJ12NShoYzfZTXBz3wDjYazfdldH9jlJH/pZGwcPV3i/eSZ3
         +88g==
X-Gm-Message-State: AOJu0Ywp6AjgKxIL4h7jmj8M740Y/9cCYkELOvhnr/9wyOGUFGznSnph
	fAbsbnMNSwy8wMfrn5HLH4dKywZZMnHR1Fd311oQdTq52WrD8iRw6so+6x5ceQz2JL0oSAf1ZQl
	r
X-Gm-Gg: ASbGnctWfahPu4ZcjQLiOIzFkOEXlVNK18OWlUGWPgaQf9tHlE0vDskouYxBuQycGiw
	VbEDFRwLzJRgFOnOV3e3COpiSnfLEcLB3ru7L3wbqueB0VSmbiw2wBrQGaLAhhI6rqeo5/kWitC
	QlS8skFdYn0BTT+k3Pw+q9PbAMBR/oXsfltSss4+LvQKHZOE6AxZ6lHLOTsEy/aquex1iE+PkJ5
	o6Z2wbjMqSCHcm17G8MHqIUQD2LhReXGgmwsGKBDBgMSdngT60=
X-Google-Smtp-Source: AGHT+IHWF+1YLe1QaF/fuMaGhpAbbfOm1ufCfvzNoECpB4acJW9Cne/s5pijH0x9OM/gw31wfuXVbg==
X-Received: by 2002:a05:6a00:1820:b0:724:ee8b:b99a with SMTP id d2e1a72fcca58-724ee8bb9a9mr14083119b3a.4.1732551754454;
        Mon, 25 Nov 2024 08:22:34 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc1e3fdbsm5831803a12.30.2024.11.25.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 08:22:33 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v4 3/5] riscv: Add "-deps" handling for tests
Date: Mon, 25 Nov 2024 17:21:52 +0100
Message-ID: <20241125162200.1630845-4-cleger@rivosinc.com>
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
index a01ff8a3..05e41d0c 100644
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
2.45.2


