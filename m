Return-Path: <kvm+bounces-10276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C6086B2A3
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E568B25713
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0177815D5BD;
	Wed, 28 Feb 2024 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V8XTjJWP"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F0415B109
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132687; cv=none; b=Dg/+1tP6SQx308FaghNmJ476gC68DLajn7y0qPERW/s5ieebvb9fNr/Z7RqTyEJaTasws0SWM3i/hCbAbVcn39snkp5dT9aTcJBhrGVKFj83zx3rfG9kX6bn+QFKs9psi4cqJQhs/Zvf1ukRiX9fYi+L8W4nwfOlcKLSwLEVbrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132687; c=relaxed/simple;
	bh=23LcuDbe8UGnXxY7HLwS0UGEmbBuWZKJ7/WKVBmKxn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=UXpwVuxr9m+Hxn8G9Yd6I/dbRSYIGXV+AzcXj2gASLuUvlCNMWlbx8nRTN2jp2YGNIy5yxhrpTWM/5PPKWjc7U9mCdrkJUL15xJ7sszCOglKUeikHGhOGqHDnjLbGR5kcvIN2kJTIPdCRRtVRb7M2JAapWkl/zMTTbt7PhhjvzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V8XTjJWP; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AYwmzv+zq+uo6ql+2N/QzSBu985d6PjX46Z+F4qaYtg=;
	b=V8XTjJWPpn+Bu1fQqB+9uzT1ilr957ADB0MyVnmlK+dpEgWVfqXGmAOtmdC09A80YsryZH
	ta7x6Et7mvopMhwQ3io8WbYzI+mcGDtJqmXcPfHmSAqlqWoMOvwK3KXwvV3jDDvNk/ptcq
	WLuz3MDJuwcGhgcmdpRuYCuSNMMGfsE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 07/13] riscv: Enable building for EFI
Date: Wed, 28 Feb 2024 16:04:23 +0100
Message-ID: <20240228150416.248948-22-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
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
 riscv/Makefile        | 24 +++++++++++++++++++++++-
 riscv/cstart.S        |  4 ++++
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 283c959973fd..cb1718ce12e6 100755
--- a/configure
+++ b/configure
@@ -230,7 +230,8 @@ else
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
index 85bbca151739..e1803c133e71 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -85,7 +85,29 @@ include $(SRCDIR)/scripts/asm-offsets.mak
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
 
 ifeq ($(CONFIG_EFI),y)
-	# TODO
+# avoid jump tables before all relocations have been processed
+riscv/efi/reloc_riscv64.o: CFLAGS += -fno-jump-tables
+cflatobjs += riscv/efi/reloc_riscv64.o
+cflatobjs += lib/acpi.o
+cflatobjs += lib/efi.o
+
+#.PRECIOUS: %.so
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
2.43.0


