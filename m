Return-Path: <kvm+bounces-34612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB54A02CA2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED803A74FD
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624C781728;
	Mon,  6 Jan 2025 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="AQEIi2da"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A813C3D6
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178826; cv=none; b=i7jPNVLzMQ85QWxcRSUAUQc1CFFTCDldPSVZkSo7F/VH0S6x2TJreLDiSi0tzLQJMhqlQ8qThahP3xFDwraJZhS5W0DlA+37q1HfqZs9AqplWKjbWvr0Xcfrn6FDhwA6+1wQ1zWhLdX1jNWGx4BW573jXFMA7A2eZ+ZzrbHW7qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178826; c=relaxed/simple;
	bh=sjFLyabBDgZlsc3lyCvmXRf/d4+M+iAIhC5ZjieuXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bPXNGM7+tR6ZpCqRbTjoe+ZxCXiOuiHoYeDmhyED5PHXOcroA3TsbPStOM1YRTtaD1YG+ZtboaMrJ0ZHLtO54hl28rixSXdaR/rqilOsXSZzjvzekg+j6aG+lN82AvXiRcAhTKIXg2AV7xXlNJqUtzuabBlSIt64Ca0fje0joa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=AQEIi2da; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21680814d42so178018035ad.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178824; x=1736783624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXZJcyGHTstiDftWq4K40v7tOXTPcWP1rruCYNo4KRY=;
        b=AQEIi2dak+HULePg8rx2tKx2iqiOiGqgD6duadMGPfnfeUPHf1bdoxbodcN80LHh73
         9TZGHUxA5DlcPc5nY/QUlepagIddkLAh8lCk4HK9oqdvR0GgEVrbBitdtIXr6x097aWe
         Mr9ajs4Ma4MASe8st/0IulDwWcWKnENcoZeZb5pV0nsMJ9je43zWq2m3Rf95pO7kQj/k
         0vQ+GBAIapxqw1/VxOO/XhRQ9mfhuk960ZLt7pM3klnwatoE7pqCQekQdmXDszyyM2r1
         qfjMro1DoboFiM2W/iiAY3wz6UwKV538iJc+CBiJwoIr9I/NGgfYlFk5fQEL68ah5xNs
         JTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178824; x=1736783624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXZJcyGHTstiDftWq4K40v7tOXTPcWP1rruCYNo4KRY=;
        b=IC3ucpHvLE2C/Rr1uu5rFO62uvegXi+1UC2/dm/2IDqilxXxEiCuNgnL6BC9cuKWE+
         EOVWjB8aSm/IVdfYY1ap9vOjC87QmO0NQ8T5O+pV8CODhyvi4zxh7ZRdgy+FYHKzv7PU
         nIUHmYzrqqxXiUm7sNWyatSxMv0NfRe9vrlzTuzhCA7FwntyMVkubb+NANsGe8mDdLWY
         mFApGCEtLiAPx9T1g1rJmee6O31PAF5jNDCnPyrU3toCughpnCN6zQBaAGUlnCl/nipi
         JoMoozqVwsYW8zXVdcBPV2JMat8nDLmxGwlJRZxs86+nEhP67WBQPO/qesjVojJUxIAz
         /ngQ==
X-Gm-Message-State: AOJu0YxytFTjMqAnJI/KDCkF8VRiEeLWmqup2QN+GlG8Dv4i1S38ivYd
	d+oO62vqQpRzwNzA1I7YD8oY7/s/k1abx1XjT4CXLYKMa8IIRQkGUwbC7T4O6YCtN/7phkiw3Ac
	O
X-Gm-Gg: ASbGnctna6EEiL2sfpCYfYIRhEOMKr5gfhE19btSCwwCxhqvTNK5eYU8Qdoz+9mnh5U
	VNUJuccFAxun4XMm3beLV4U/SobcL0NHq7rN6srbADa73KMF68OqSk33Sg9zv3twd8DWI+G/iKq
	CtP/2wnLQCuLRLtf9BMmXFVLU/Tfuvt6HYDHtJSpzu4IkkgqdTA/aBH/sEDouA6W0eRJ/tPs4vs
	2UVmcCCZufou3QaRhg5qem9b4WK5DjeFCiF0RxncDtbpGd5ZzkmWZYlHw==
X-Google-Smtp-Source: AGHT+IHNABQXG7BbQsU6/mtXz/rJrBzDCcciLJwgtCAhPVN4QvCcVK4iGblc8oRSLMAfda2RSAnCzQ==
X-Received: by 2002:a05:6a21:3994:b0:1db:d932:ddcc with SMTP id adf61e73a8af0-1e5e049f462mr86158615637.19.1736178823896;
        Mon, 06 Jan 2025 07:53:43 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b8e867ccsm28950200a12.47.2025.01.06.07.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:53:43 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH 1/2] riscv: Add "-deps" handling for tests
Date: Mon,  6 Jan 2025 16:53:19 +0100
Message-ID: <20250106155321.1109586-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106155321.1109586-1-cleger@rivosinc.com>
References: <20250106155321.1109586-1-cleger@rivosinc.com>
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
index 28b04156..5b5e157c 100644
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


