Return-Path: <kvm+bounces-36769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB19EA20BD5
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 380D9163F44
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902991A9B3E;
	Tue, 28 Jan 2025 14:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="J5v2nEo4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A169E8634F
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738073788; cv=none; b=G0RMzS0n1KBDSw4I/Tc4aQ9NPsYV4Vf9ZLlp7j4Pxb/kB6nppa55UqNCk1TZz79i1tO3vdqvvaPhPsob/TLDomhbhZ34otHW8IfHdw2usOTH8+dlyEZmOZ5Rp8btddPhnQfvqkO/Ydij8KTBMEX5odDSLy9shrBtBFRmD80lkrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738073788; c=relaxed/simple;
	bh=sjFLyabBDgZlsc3lyCvmXRf/d4+M+iAIhC5ZjieuXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cg/w+Cxq1/ra+687um0zK2YelOXurteXqmbKr+QhYcc06svV+OlPbbPSe2eyam15TE5UGfhuqEOtq+mGjzsqy7uYnN/HCcNYx+m/gD4GrRLye7WuoquM8QAIwwZIjvzpyyXtSD4Qr8EIbJ2md1LNh01rTjPI0Aq6Zoy2/OD8ZBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=J5v2nEo4; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43618283dedso60297855e9.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738073784; x=1738678584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXZJcyGHTstiDftWq4K40v7tOXTPcWP1rruCYNo4KRY=;
        b=J5v2nEo47g/HpkRu6vFtWJ4SheW7pJWSxP5ojgeaH39IPATkp2CV30ZwmF14+DhjxL
         zW/Q/pDP0X+u3BuoTXlbUvdONuXQ2gNDVE0wVk3MuJvMPFhW9MVhI6qNt9tkOZPHtuee
         l4erim4ZTcUrZ9k/0ZFfDlfGugMww/G5zZVefUbWTXGZX07sTJXpBw4l3ytH6tHplfTv
         MYcfFW8jDCwxYGkU1p70P0cE7jZRKUozA/ZsRug1eXKD22cfeyi+sifTI9XxY1Ql/est
         ZCN1Kxp9LENc3wWZ1VGlL14sfLpcYShJrP0JcLNNPM/3IlAUa7lTPQrrogCUsGIo5sfz
         5Y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738073784; x=1738678584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXZJcyGHTstiDftWq4K40v7tOXTPcWP1rruCYNo4KRY=;
        b=bEPHZ00FUwr5tUQ/kFJmw88zkDM1b7r2yeqHcanO9zkdIY0/H/b4hY05ffRuIckqtJ
         1q8P4+wMgjk4mmzKG/AkeoIYCXT5P4rcC2Iy0U/UbjPl7OMsBqu55oY0MZwSYrgOOpQu
         MWiX0qKRs2MpBaKxG2BdXIjUFl7YZ/GsTYRVMez94F5APvUqdt/BKMk5vw9U6JHWDMuX
         UDTRnWaQ3SqVzXVqc8x2gnfSTPS8rU6uuKui9/tZdDLF3bgcIKUqwoWzaCYVUA/j94XQ
         UfsHFgcVlcbiL2lOaK3RXrTY7jFCrRrYBbkfOB62zr1oHiJtfg/3uEg2KdfA1ZX1ISDA
         UGBw==
X-Gm-Message-State: AOJu0YzfqzcmXVzAYJ0sFFThsIymJpYtGEAyrjRIQQhxi3bhtc43N4ax
	CsHQmzu19M4aZ8RsVnzGs7bRcpaDmFxp27iTYfy7i4BnpHLb2abunLBaiXlztdK1Ww6Pci4r81w
	fYS4=
X-Gm-Gg: ASbGncsSaEPyXGbqJIWJNVYyqFFLPvmm2XifHAjer+vmfYqoBLzUYhOy6X6snIBorzz
	3fFkiM2+m+/gEU4EE/4l3OhBEmqF3LyBzFzXk1HTaUKZyreMLPukiRTXR12WBXh5jCKf0J4fFQ1
	HuI3Sut8M4hRVzEncm3m9Hp8MEmnSrqyfGzlzLWAfevlegVwMPf/Rv7OKZ15u6QwirD9BXXwppb
	wAxR54bkmPOLIiz4+x2IBpc7ClwR06sqKXfKZ7vGMDAupPxy0QUyngkcqIpOvAHYx++30tpoqkn
	F6Y+RnKkYIMayL3m
X-Google-Smtp-Source: AGHT+IExkAsT35CibNqnfvFyENC5hhiY7L+ALKdkPXj3RJlFXYg67HOTL5u/M3wiW36Bk+dA5lPp/g==
X-Received: by 2002:a5d:5989:0:b0:385:f6de:6266 with SMTP id ffacd0b85a97d-38bf566f72cmr41616295f8f.24.1738073784041;
        Tue, 28 Jan 2025 06:16:24 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c402esm14435772f8f.97.2025.01.28.06.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 06:16:23 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v3 1/2] riscv: Add "-deps" handling for tests
Date: Tue, 28 Jan 2025 15:15:41 +0100
Message-ID: <20250128141543.1338677-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128141543.1338677-1-cleger@rivosinc.com>
References: <20250128141543.1338677-1-cleger@rivosinc.com>
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


