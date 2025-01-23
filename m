Return-Path: <kvm+bounces-36407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C71EA1A830
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:54:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE221188C028
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B9215B0F2;
	Thu, 23 Jan 2025 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rUjL//mV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0036014375D
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737651258; cv=none; b=ry1JW1hrGhvXFyuJlOR3jNmeAgNrApEAp6tZ7Bg1duAoRMMm8sufOMyj5YCbwvCq0/mgJvuPHSgXfrtj7/KNUsMnEfUTnPrt7BAJIWOzCwiuVglx16POhHcMzMNC85sQixfu2SM6GB9dEoDSPljluoVMMXllC38xkbGEMVrMmLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737651258; c=relaxed/simple;
	bh=sjFLyabBDgZlsc3lyCvmXRf/d4+M+iAIhC5ZjieuXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvPYfhpdQt4P+Nm9UJf872ikMuYlloxpc8rfwc4lhGkV4q0DPr8V6GO1CArSktVa9L9yCva6HS64eOh+TmRWkXhXth3Cwft3CIAS5c1Noq6z5B8kSrU9+As3AvpHHPvxvPSbZa8iByoDN+3sYkrPz8CXHQcqpba6kSFvg0+fskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rUjL//mV; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385e06af753so592678f8f.2
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 08:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737651253; x=1738256053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXZJcyGHTstiDftWq4K40v7tOXTPcWP1rruCYNo4KRY=;
        b=rUjL//mV2/Su9hziUloSlm6DxHbybzlbG5+bVKFwh6pYYk6/rmM/1jQyczQcGOvs3D
         k+QJNe4rMrSEtcgksaAqnPtbGuCJW2bIieWqHc2NuABBs7GNYPkJSGhR12H8iH2Yb03B
         Gc6Gt3OV34lTJthxMn4EQw84FBOZsxgpdZqp4B5FCewFDVaIXOoRNzmSsh6B0q8pIVXd
         WSV4wFdWAORXFfxDMgRRZjq26YzZjtv4y+/TUi50J87FxEXwz5YUrzj0YFwDr++DCiEa
         2qC1E2ROLSAE0hvjf5tu/eFYaxyE09mz3NVmY5eRTHWbLWcVPO7eiv8VX0fZkJabkBAR
         XEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737651253; x=1738256053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXZJcyGHTstiDftWq4K40v7tOXTPcWP1rruCYNo4KRY=;
        b=ZoqBgRlde/0RLHmHhQxd6obTSIlZKtyLBJiVB6O5A/KPnG7Gd+7exkOF7hiUSSlpRU
         VY4nhwEKoinKmDD+MPRFalLfY9YUpEq/nJH3XPYxjkOQfGy9TFJuVJdQGW68VP1IQx/0
         4v4Jp+2Y4KTYzUDZkHw5c3WDqE4BRV51txTgEk8nSl/btqDFV8BWNFhXflgZ0nTxO3yO
         Zq4JITcHdQhGuGq36EmVpPA0HKiOy3ih31YbPqGwPCwYiyb5i+a46vhfjO5QyGpq78Zu
         +c/gtIGMzr3rk5D+SLz+/zq6vRRCqj4g0UAySJKPCxCcXn01A6yX/11ij0nku9i8U2tk
         5wAA==
X-Gm-Message-State: AOJu0Yz2OhKWl0rse1rwS9vpbqCLlyO1K3F+XqpYOKAB1A3jFSKRjNkf
	HZpXMl1++FmDJCzIVAeqgWdma0oMHxeEE7+C5Z+hi/AwVwC//ebJzJ1PTXfJHicJm/PDS8d3fhL
	5
X-Gm-Gg: ASbGncuIUAYAWfpn6R8mBRuz99y3FjJawHPtfoK4gLa5Hpbv9KVxi9haDDA14uWGFso
	zObg0pDaO5S9pPZ5CuDJZ4a9pf3TGPcw15NGEAdIk9OqTHslVzQ8KPJo62kK/J4KOMFH2PErIDR
	s9mB2iE8ECQXPd9j4g9wY4cOslbMG5uo1tlELSmCoE1wYLlKBS7NbSwsLyiQSDlFjSgEcbNDLFR
	R3VEuJRG85ABinP5ZtI1VXlocRDE478ma0CSlTOk+jeKb63OpbgipE51M0mN3mcsj5fE/RpjmH0
	XDiPrQ==
X-Google-Smtp-Source: AGHT+IHb4p4BsdZddRAzW7ClEpebfRxQ8AzParhFuiFMv/11Hxp3eTNkqo2donhFNcFIFvtCV2pHOA==
X-Received: by 2002:a05:6000:1f85:b0:385:fbb7:672d with SMTP id ffacd0b85a97d-38bf57b6438mr20721730f8f.52.1737651253341;
        Thu, 23 Jan 2025 08:54:13 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bbc8dsm165695f8f.72.2025.01.23.08.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 08:54:12 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v2 1/2] riscv: Add "-deps" handling for tests
Date: Thu, 23 Jan 2025 17:54:03 +0100
Message-ID: <20250123165405.3524478-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123165405.3524478-1-cleger@rivosinc.com>
References: <20250123165405.3524478-1-cleger@rivosinc.com>
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


