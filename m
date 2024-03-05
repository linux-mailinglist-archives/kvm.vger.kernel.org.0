Return-Path: <kvm+bounces-11048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8614872552
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EDFC1F26840
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBC018C38;
	Tue,  5 Mar 2024 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mmdEf9Oh"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F063518AE0
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658562; cv=none; b=HSySKoA4GCPoAA91D3/sK6G4hNEo8ZEhqyTXhF7XVzSBENDn4myoGzdiB/KqyHsVtgwu+9LrDo74/Vx7JTZf1SDD6Z2AAfCwFb+lv1cR5br/cfObPLI3XlCMdz4kbrI7fbO33oPqtZ4CDjQF5m3ZNBQmMh0hIPi+Za6CnMxULRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658562; c=relaxed/simple;
	bh=842kSUfw/J9tfpz6xFdzxL2dTFMWqeK2nUCShuyT1CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jFDeePhAb2uRBm1FDOjatRLlG2oWucX5H7ZAZ8u7yTFJ2EZl0mTwOatPEkxsmaGoF6Th0Atvc0KN8TAfzwWlaavJw11PJNU04LuCoukAPvG4K5peSaqjQhwssfoy2xK+onoqOORm+eD2nnD55XpKyfSRwJ6KsiJklMEukALl7ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mmdEf9Oh; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mC+XlKr2wuD4Jt3JyCwAi5RF7Z+b/5X3cQTUHW9SzKY=;
	b=mmdEf9Ohm5Zj75UQXFhHhL8tuq/0CWD1Tj69IAgaSEmQpDL435NcE16VzjfGsuaHMAXze+
	vkOwv5dK+PxGu7C6BS98TYCzWlfQKlp4k9CWgR8LaRCYZVPqJQkc63ZdWU0SiXHQjFfKL4
	rCGL2Gs/mRSUcW2EdaYNIA3OrlCos58=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 07/13] riscv: Enable building for EFI
Date: Tue,  5 Mar 2024 18:09:06 +0100
Message-ID: <20240305170858.395836-22-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Mimicking arm64 support, add configure and makefile changes to build
for EFI. Since the linker script is replaced also replace the initial
cstart code (also done like arm64). Finally, provide a stub for
setup_efi() in order to allow compiling to complete (even though
tests can't yet run).

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure             |  3 ++-
 lib/riscv/asm/setup.h |  5 +++++
 riscv/Makefile        | 27 +++++++++++++++++++++++++--
 riscv/cstart.S        |  4 ++++
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 51edee8cd21b..c1d0fe4adbb0 100755
--- a/configure
+++ b/configure
@@ -231,7 +231,8 @@ else
     fi
 fi
 
-if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
+if [ "$efi" ] && [ "$arch" != "x86_64" ] &&
+   [ "$arch" != "arm64" ] && [ "$arch" != "riscv64" ]; then
     echo "--[enable|disable]-efi is not supported for $arch"
     usage
 fi
diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index e58dd53071ae..dfc8875fbb3b 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -12,4 +12,9 @@ int hartid_to_cpu(unsigned long hartid);
 void io_init(void);
 void setup(const void *fdt, phys_addr_t freemem_start);
 
+#ifdef CONFIG_EFI
+#include <efi.h>
+static inline efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo) { return 0; }
+#endif
+
 #endif /* _ASMRISCV_SETUP_H_ */
diff --git a/riscv/Makefile b/riscv/Makefile
index 85bbca151739..919a3ebb5211 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -17,7 +17,8 @@ tests += $(TEST_DIR)/sieve.$(exe)
 
 all: $(tests)
 
-$(TEST_DIR)/sieve.elf: AUXFLAGS = 0x1
+# When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
+$(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
 
 cstart.o = $(TEST_DIR)/cstart.o
 
@@ -85,7 +86,29 @@ include $(SRCDIR)/scripts/asm-offsets.mak
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
 
 ifeq ($(CONFIG_EFI),y)
-	# TODO
+# avoid jump tables before all relocations have been processed
+riscv/efi/reloc_riscv64.o: CFLAGS += -fno-jump-tables
+cflatobjs += riscv/efi/reloc_riscv64.o
+cflatobjs += lib/acpi.o
+cflatobjs += lib/efi.o
+
+.PRECIOUS: %.so
+
+%.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
+%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o
+	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
+		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
+
+%.efi: %.so
+	$(call arch_elf_check, $^)
+	$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(OBJCOPY) --strip-debug $^
+	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
+	$(OBJCOPY) \
+		-j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym \
+		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
+		-j .reloc \
+		-O binary $^ $@
 else
 %.elf: LDFLAGS += -pie -n -z notext
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o
diff --git a/riscv/cstart.S b/riscv/cstart.S
index c935467ff6a1..10b5da5779b0 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -42,6 +42,9 @@
 9997:
 .endm
 
+#ifdef CONFIG_EFI
+#include "efi/crt0-efi-riscv64.S"
+#else
 	.section .init
 
 /*
@@ -109,6 +112,7 @@ start:
 	call	exit
 	j	halt
 
+#endif /* !CONFIG_EFI */
 	.text
 
 .balign 4
-- 
2.44.0


