Return-Path: <kvm+bounces-35035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15103A08EF0
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF11F3A16DE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E813720ADCE;
	Fri, 10 Jan 2025 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="M2VF0s5D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6713920A5FB
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507589; cv=none; b=rk2TLiWpQG/rVJ5M7anxOlGgorWiwI1QCuZp2ZrO/1IgsEsTkmQ5PKa1wTsbMdR1SDDf51W/GmeilwLI8Csri3ci1Wr8P1m4ShQbQq5uPw2WaiLqdH0XL5uJq9veBRRbPDMjgVNYsBMtq1KJ5F1c0UbDlN0kySg0Gu++vTJokrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507589; c=relaxed/simple;
	bh=1TEy02OXmpC7JznFLWj+ltyJEqGZ8vnCYpYaBE6fw5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gE7C06esxqhTBMcPQHMzM8GygfMdT4PC/e0Q4Joxt6aoJGC0FbUFW3QHGKV424AmN5ZkytP2h0FkXD4mpJe5svEqMSDRCmNU1ZtDjeuJ3r5I3crSHXBlq5pYxGxFiVWCzj7usbGr8dtUPitztNQWleeXEbymH8Zil5bounl2zVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=M2VF0s5D; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-388cae9eb9fso1038212f8f.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736507584; x=1737112384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjgBZFa/BR8r5Er66LNA94UStT5XF8U8GTLeRsOmkfY=;
        b=M2VF0s5DhMbabFjszmGGvpt5FJWshSPvt+ex1f7O2S8Lr7zotL5pFA0pQkrUNsPPy0
         w+Og2ys47cMs1Bh1KBDy9rXfFULBfC2eRIQdgxikPVARM2K6ThxW1afKqZJXRHLfwk9N
         c7wSluS1loeOK2W45WOQggS31qb8b9Gqosk247pTOPWx3MlJeI3a3esv2HKbRaOGSHuu
         +N1ZoA69YE05h8nO2Lwk6S6tbzcGdLkW1riLcvOJOR7oi0s7QUgW3Cvd1YGObHuaL+Sy
         w9PFC6JsgtBJmeVaAHBUUBDQZs1VkWGyGkdb/wXRwHr3aIkLoehta/kVVESzzeHyYreA
         m2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507584; x=1737112384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjgBZFa/BR8r5Er66LNA94UStT5XF8U8GTLeRsOmkfY=;
        b=MMRSUhWE81s2CI+xJugjCsR3SiiH3tW0RvSoqek2KB0KQKZ7DdTnpCkaGNud1n3lSb
         JsL+MZu+Z77pyXcAzAsOqxvlJzO7ya0Uv8W/TbabexrBuzP0zWgn+BsQdXnx3A2yXnge
         MIXq9ie9ZeosBmZLqud0qV1fDZXFMveKPF9oX0/B5gZB4wepeQ12keyEmVsB2IMyU6bc
         deQgWLehcHrCCuNRE0hL0Rk39tc8J9GrDq7tFfQAiEFb3tluwYlEUKlqwln9tMHIwsgk
         HG/P80BKLW7YdYO7n0pwnJLMpELdqswHguH6Kuc2VPmEgseiTw7davIe27c7SrDULUGK
         SEfQ==
X-Gm-Message-State: AOJu0YynyK//BbpIVaQD4DQgcO7vz303JbBUnuLWFkQEnhEwxbxlvQt2
	nHjuoka7Cl5uvEQq1jVfGqYUSQd0OdQYoJexN/5uBRaPxWuit17mggeZrbPh2NlkC3K/v5GaQgf
	G
X-Gm-Gg: ASbGncudTljNaCvyo9317WE39syvNlNIYEW+1ZnfbGVJq9saHalj3yeMVMqRkAam4zb
	vsYdXmOkhJY4byV5KjC4MByuCx7IKd0lgfNoufvZVU2aSG6yq9Wfta7dOF7n0og8MWJGHBDW5U6
	GnRTcRovMBNqN870YczIvUpECA7VM8EvGi5OY5IMVK2lJYZoWkItnak8hh8hsb8OvIQgdzaYVXk
	Pip4v2eg32Hr1PLXnSdiSMeW+Zp6YR0zLtlZ374ZxpsHRUihgM2lY9UtQ==
X-Google-Smtp-Source: AGHT+IE9GN0aTbpT588uzWry7FfnQXEXjdNpSHyruEGOTIgns0gLO4iWOnowhU2urXFRfbKNdQo5gA==
X-Received: by 2002:a5d:6c68:0:b0:38a:82a3:395f with SMTP id ffacd0b85a97d-38a872c93f9mr7248319f8f.9.1736507582807;
        Fri, 10 Jan 2025 03:13:02 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38c1d6sm4344459f8f.50.2025.01.10.03.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:13:02 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v6 3/5] riscv: Add "-deps" handling for tests
Date: Fri, 10 Jan 2025 12:12:42 +0100
Message-ID: <20250110111247.2963146-4-cleger@rivosinc.com>
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

Some tests uses additional files that needs to be linked in the final
binary. This is the case for asm-sbi.S which is only used by the sbi
test. Add a "-deps" per test variable that allows to designate
additional .o files.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/riscv/Makefile b/riscv/Makefile
index af5ee495..517cb0e5 100644
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
@@ -132,6 +134,7 @@ endif
 
 generated-files = $(asm-offsets)
 $(tests:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(foreach test,$(tests),$($(test:.$(exe)=-deps))): $(generated-files)
 
 arch_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \
-- 
2.47.1


