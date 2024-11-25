Return-Path: <kvm+bounces-32425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E279D84E1
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:55:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE422285C0B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBBC376E0;
	Mon, 25 Nov 2024 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="KEg+WLjg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E72156F5D
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535748; cv=none; b=vCZhBctoJ1vCGPdHTxH4EaRYk7ftFyTYOCsMAo3lgStFp8a5NqwHuRjsGvOcZIODJIr0J8RlRpumZYrRbswEkE02J4EG/ycCDIFlJ2SVgDpFGWK3WjbwC1jeE3EEHULQGENf7rh4LWj0UAAYFdtI1QP5jvwt5ncgpNfggA3UixM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535748; c=relaxed/simple;
	bh=KV/51auJCFapSG2Ic286+IDPPaazJPQ2HvY2PqrYnyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjLAn5b5yB3Za++ymFbJG270G5/m6Xzx7dxClVMozA4SvmPfA9cdB4cQls0H47RXREZWSxsz2kNakn7dHbF55E+yuTOzOaTgQLeVgj/wlay21sHHwv40gyrRE+wP+otumm4VAszoEab4XWo/6ZBTh4XHJ48ta9H8jwwIynmxo3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=KEg+WLjg; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38241435528so2819039f8f.2
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 03:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732535744; x=1733140544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uJ+65G9O42b/6yem9iWeoXL7YcTuQmTGptgwDH4wnk=;
        b=KEg+WLjgwXWphidcCfTH5U24jfMDas9LIKl7LiV9riUG4SeqsQtqURrzNx4ElxL9Lw
         000yXS0pfopMMFy8WS1z7xi+BNokylXjPPWXAb2AgNLODkSNtmEO673jcOxNJ8nuVpW/
         dJ/Pa0zXy02otu7utEO/s32btcUmdIol4bvUu75aJFZDLxY9QR2/StVwwa5UC0C+z5/R
         Y8QpGMwDl1MhTuQwYy1YLoPGy2zKZshQ3TVA4ozmg2orswbD5SDVCZchC0z4H3sMs3t1
         JVRc9Cp4wymHeEixdSivvRy1eW/8OqoHE5o+9WgHgojp0NwTDfHvcXgNbX7va8CG4X9V
         nBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732535744; x=1733140544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uJ+65G9O42b/6yem9iWeoXL7YcTuQmTGptgwDH4wnk=;
        b=l2r3a4smUip1KTXiVNrHEAUGF17IJPvcDxITEucTeiIGJeZsbdHzuHr0ykIhMeMUKM
         bGMYOJr7ePnmIhNnwO6EBSVuLC224GpA7KgsCZV3m4aMKTuSVaGx2KGg/R6wXOAnyfvc
         7YswhGS8Zb3Tc9o6uWkc3n+bJkjJsNB4KTxWmqtirywkHEm89yobqHlW0igAQnZ0cwR1
         sJEUHIPrflBsBSo6NJAX4u0TmD2V6KUd9f+JtaVDhMKEp7khhUwj4AKP4NjFLcXkT17H
         Bwe0aoWTkv1OfZHTtcRANPJrpiiW9QoQM25TzLbRynYKkxF1hv1fXnBqzv/Wo+JNEHYe
         3zOg==
X-Gm-Message-State: AOJu0Yy8S+dbDzzoPM1KYbHNWXygjIKFu2Yf2pqfAOhWuEotZYbykF/A
	AbQOtWwN/DLkE36eR6CL/amY7ljYBFWbiqGZohRTsTFTUf7VjLgrn7yU8gjMVHOgE38q0Tx3lg1
	u
X-Gm-Gg: ASbGncu7zwy6Rm8WcyD4d53a++VMtp2nA9XVZAdQV6SDkuR77LDB+MdMDf7fE+JWMj7
	kHiN0dAMmE5XoTPt5PuQ0y1pU/gLgC6qA+6zuslKTrCF+AVoexM+3/jTHSrY7Cz1yjjhijfEIQ2
	lu+4S406xPsQsj5eUoKfEFX8mXd+K4nzlggQC3umiRQ0XcWAh077ty6ryizw56q8wj24mp3YEP7
	lhgUTw30mo+R4BshyzJVwkyIC+gvTcTGmk6hpWEcG5HcfdnCnk=
X-Google-Smtp-Source: AGHT+IHq9nkVUYHFUa2cVzM/5Vw8THIZONe3O1roMJEpi9xQNFJUTULt16tV+Ag1+T536/tnQdoGrA==
X-Received: by 2002:a05:6000:4901:b0:382:32ec:f5b4 with SMTP id ffacd0b85a97d-38260bd07eamr11875439f8f.47.1732535744145;
        Mon, 25 Nov 2024 03:55:44 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc3dfasm10546938f8f.76.2024.11.25.03.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 03:55:43 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v3 1/4] riscv: Add "-deps" handling for tests
Date: Mon, 25 Nov 2024 12:54:45 +0100
Message-ID: <20241125115452.1255745-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125115452.1255745-1-cleger@rivosinc.com>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
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
2.45.2


