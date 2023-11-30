Return-Path: <kvm+bounces-2868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD227FEB75
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AED31C20D8B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362C13B29B;
	Thu, 30 Nov 2023 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dV5oWHZW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966EED66
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T6J7bOOJIC05jXn22tMXTnBYzc47O0oKVIyQdp1yMck=;
	b=dV5oWHZW8Ghe5bIte0UY6mF2JK7ZwvQXz4LDw0XiE06Ex323LTXakCbeQJNQCTpmrJ0KmA
	x21VgIg0DB/ztnMSSIYsNt5/StsJC6nXOU1z/74D7xmx+um6iD+4rR44JIWrgf41w2PToK
	2u3pkU9TuschH9XNMzqrZFwIifHOBug=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-Ih6SkI_kMnCC2nG1jrks1g-1; Thu, 30 Nov 2023 04:07:57 -0500
X-MC-Unique: Ih6SkI_kMnCC2nG1jrks1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F96E84ACA8;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6FAFF1C060AE;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 12/18] arm/arm64: Add C functions for doing cache maintenance
Date: Thu, 30 Nov 2023 04:07:14 -0500
Message-Id: <20231130090722.2897974-13-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

Add C functions for doing cache maintenance, which will be used for
implementing the necessary maintenance when kvm-unit-tests boots.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/Makefile.arm           |  4 +-
 arm/Makefile.arm64         |  4 +-
 arm/Makefile.common        |  6 +--
 lib/arm/asm/assembler.h    |  4 +-
 lib/arm/asm/cacheflush.h   |  1 +
 lib/arm/asm/mmu.h          |  6 ---
 lib/arm/cache.S            | 89 ++++++++++++++++++++++++++++++++++++++
 lib/arm64/asm/cacheflush.h | 37 ++++++++++++++++
 lib/arm64/asm/mmu.h        |  5 ---
 lib/arm64/cache.S          | 85 ++++++++++++++++++++++++++++++++++++
 10 files changed, 224 insertions(+), 17 deletions(-)
 create mode 100644 lib/arm/asm/cacheflush.h
 create mode 100644 lib/arm/cache.S
 create mode 100644 lib/arm64/asm/cacheflush.h
 create mode 100644 lib/arm64/cache.S

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 7fd39f3a..0489aa92 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -26,7 +26,9 @@ endif
 define arch_elf_check =
 endef
 
-cstart.o = $(TEST_DIR)/cstart.o
+asmobjs  = $(TEST_DIR)/cstart.o
+asmobjs += lib/arm/cache.o
+
 cflatobjs += lib/arm/spinlock.o
 cflatobjs += lib/arm/processor.o
 cflatobjs += lib/arm/stack.o
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 960880f1..10561f34 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -21,8 +21,10 @@ define arch_elf_check =
 		$(error $(1) has unsupported reloc types))
 endef
 
-cstart.o = $(TEST_DIR)/cstart64.o
+asmobjs  = $(TEST_DIR)/cstart64.o
+asmobjs += lib/arm64/cache.o
 cflatobjs += lib/arm64/stack.o
+
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 5214c8ac..10aa13f4 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -71,7 +71,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 
 ifeq ($(CONFIG_EFI),y)
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
+%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(asmobjs)
 	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
 		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
@@ -91,7 +91,7 @@ ifeq ($(CONFIG_EFI),y)
 		-O binary $^ $@
 else
 %.elf: LDFLAGS += $(arch_LDFLAGS)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(asmobjs)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
 		-DPROGNAME=\"$(@:.elf=.flat)\" -DAUXFLAGS=$(AUXFLAGS)
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/arm/flat.lds \
@@ -113,4 +113,4 @@ arm_clean: asm_offsets_clean
 	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
 
 generated-files = $(asm-offsets)
-$(tests-all:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests-all:.$(exe)=.o) $(asmobjs) $(cflatobjs): $(generated-files)
diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
index db5f0f55..e728bb21 100644
--- a/lib/arm/asm/assembler.h
+++ b/lib/arm/asm/assembler.h
@@ -41,7 +41,9 @@
 	.ifc	\op, dccimvac
 	mcr	p15, 0, \addr, c7, c14, 1
 	.else
-	.err
+	.ifc	\op, dccmvac
+	mcr	p15, 0, \addr, c7, c10, 1
+	.endif
 	.endif
 	add	\addr, \addr, \tmp1
 	cmp	\addr, \end
diff --git a/lib/arm/asm/cacheflush.h b/lib/arm/asm/cacheflush.h
new file mode 100644
index 00000000..42dc88a4
--- /dev/null
+++ b/lib/arm/asm/cacheflush.h
@@ -0,0 +1 @@
+#include "../../arm64/asm/cacheflush.h"
diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index b24b97e5..6359ba64 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -45,12 +45,6 @@ static inline void flush_tlb_page(unsigned long vaddr)
 	isb();
 }
 
-static inline void flush_dcache_addr(unsigned long vaddr)
-{
-	/* DCCIMVAC */
-	asm volatile("mcr p15, 0, %0, c7, c14, 1" :: "r" (vaddr));
-}
-
 #include <asm/mmu-api.h>
 
 #endif /* _ASMARM_MMU_H_ */
diff --git a/lib/arm/cache.S b/lib/arm/cache.S
new file mode 100644
index 00000000..cdb6c168
--- /dev/null
+++ b/lib/arm/cache.S
@@ -0,0 +1,89 @@
+/*
+ * Based on arch/arm64/mm/cache.S
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ * Copyright (C) 2012, 2022 ARM Ltd.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+
+#include <asm/assembler.h>
+
+/*
+ *      dcache_inval_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end) are
+ *      invalidated. Any partial lines at the ends of the interval are cleaned
+ *      and invalidated to PoC instead to prevent data loss.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_inval_poc
+dcache_inval_poc:
+	dmb	sy
+	dcache_line_size r2, r3
+	sub 	r3, r2, #1
+	tst	r1, r3			// end cache line aligned?
+	bic	r1, r1, r3
+	beq 	1f
+	// DCCIMVAC
+	mcr	p15, 0, r1, c7, c14, 1	// clean + invalidate end cache line
+1:	tst	r0, r3			// start cache line aligned?
+	bic	r0, r0, r3
+	beq	2f
+	mcr	p15, 0, r0, c7, c14, 1	// clean + invalidate start cache line
+	b	3f
+	// DCIMVAC
+2:	mcr	p15, 0, r0, c7, c6, 1	// invalidate current cache line
+3:	add	r0, r0, r2
+	cmp	r0, r1
+	blo	2b
+	dsb	sy
+	mov	pc, lr
+
+/*
+ *      dcache_clean_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end)
+ *      are cleaned to the PoC.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_clean_poc
+dcache_clean_poc:
+	dmb	sy
+	dcache_by_line_op dccmvac, sy, r0, r1, r2, r3
+	mov	pc, lr
+
+/*
+ *      dcache_clean_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_addr_poc
+dcache_clean_addr_poc:
+	dmb	sy
+	// DCCMVAC
+	mcr 	p15, 0, r0, c7, c10, 1
+	dsb	sy
+	mov	pc, lr
+
+/*
+ *      dcache_clean_inval_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned and invalidated
+ *      to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_inval_addr_poc
+dcache_clean_inval_addr_poc:
+	dmb	sy
+	// DCCIMVAC
+	mcr 	p15, 0, r0, c7, c14, 1
+	dsb	sy
+	mov	pc, lr
diff --git a/lib/arm64/asm/cacheflush.h b/lib/arm64/asm/cacheflush.h
new file mode 100644
index 00000000..53a57820
--- /dev/null
+++ b/lib/arm64/asm/cacheflush.h
@@ -0,0 +1,37 @@
+#ifndef _ASMARM64_CACHEFLUSH_H_
+#define _ASMARM64_CACHEFLUSH_H_
+/*
+ * Based on arch/arm64/asm/include/cacheflush.h
+ *
+ * Copyright (C) 1999-2002 Russell King.
+ * Copyright (C) 2012,2022 ARM Ltd.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+
+#include <asm/page.h>
+
+extern void dcache_clean_addr_poc(unsigned long addr);
+/*
+ * Invalidating a specific address is dangerous, because it means invalidating
+ * everything that shares the same cache line. Do clean and invalidate instead,
+ * as the clean is harmless.
+ */
+extern void dcache_clean_inval_addr_poc(unsigned long addr);
+
+extern void dcache_inval_poc(unsigned long start, unsigned long end);
+extern void dcache_clean_poc(unsigned long start, unsigned long end);
+
+static inline void dcache_inval_page_poc(unsigned long page_addr)
+{
+	assert(PAGE_ALIGN(page_addr) == page_addr);
+	dcache_inval_poc(page_addr, page_addr + PAGE_SIZE);
+}
+
+static inline void dcache_clean_page_poc(unsigned long page_addr)
+{
+	assert(PAGE_ALIGN(page_addr) == page_addr);
+	dcache_clean_poc(page_addr, page_addr + PAGE_SIZE);
+}
+
+#endif /* _ASMARM64_CACHEFLUSH_H_ */
diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 5c27edb2..2ebbe925 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -28,11 +28,6 @@ static inline void flush_tlb_page(unsigned long vaddr)
 	isb();
 }
 
-static inline void flush_dcache_addr(unsigned long vaddr)
-{
-	asm volatile("dc civac, %0" :: "r" (vaddr));
-}
-
 #include <asm/mmu-api.h>
 
 #endif /* _ASMARM64_MMU_H_ */
diff --git a/lib/arm64/cache.S b/lib/arm64/cache.S
new file mode 100644
index 00000000..595b6d9a
--- /dev/null
+++ b/lib/arm64/cache.S
@@ -0,0 +1,85 @@
+/*
+ * Based on arch/arm64/mm/cache.S
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ * Copyright (C) 2012, 2022 ARM Ltd.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+
+#include <asm/assembler.h>
+
+/*
+ *      dcache_inval_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end) are
+ *      invalidated. Any partial lines at the ends of the interval are cleaned
+ *      and invalidated to PoC instead to prevent data loss.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_inval_poc
+dcache_inval_poc:
+	dmb	sy
+	raw_dcache_line_size x2, x3
+	sub 	x3, x2, #1
+	tst	x1, x3			// end cache line aligned?
+	bic	x1, x1, x3
+	b.eq 	1f
+	dc	civac, x1		// clean + invalidate end cache line
+1:	tst	x0, x3			// start cache line aligned?
+	bic	x0, x0, x3
+	b.eq	2f
+	dc 	civac, x0		// clean + invalidate start cache line
+	b	3f
+2:	dc	ivac, x0		// invalidate current cache line
+3:	add	x0, x0, x2
+	cmp	x0, x1
+	b.lo	2b
+	dsb	sy
+	ret
+
+/*
+ *      dcache_clean_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end)
+ *      are cleaned to the PoC.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_clean_poc
+dcache_clean_poc:
+	dmb	sy
+	dcache_by_line_op cvac, sy, x0, x1, x2, x3
+	ret
+
+/*
+ *      dcache_clean_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_addr_poc
+dcache_clean_addr_poc:
+	dmb	sy
+	dc	cvac, x0
+	dsb	sy
+	ret
+
+/*
+ *      dcache_clean_inval_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned and invalidated
+ *      to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_inval_addr_poc
+dcache_clean_inval_addr_poc:
+	dmb	sy
+	dc	civac, x0
+	dsb	sy
+	ret
-- 
2.40.1


