Return-Path: <kvm+bounces-22020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 945599383AB
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 09:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C3B81C20858
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 07:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344EA944D;
	Sun, 21 Jul 2024 07:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWf2vXFj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC89C8FF
	for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 07:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545581; cv=none; b=FkCHeHjfTlYJJx0MlvZuTfkhhUg8Z533DiA85XltAlUwQzJN7kmG0RIJhIbX9XmePjnqLuafLwtM5bx1knhcYFe6Ms61WjNDYFJiBPAqernFZ/89ZFh7U35hxFWKxGonWZxBz2As/Z3OBmrYb4neqtLkHOYLOdG1TdVdVhCxbuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545581; c=relaxed/simple;
	bh=+agld4zlqbig1ojMy8W/4esTTSShlDdWhqY4xkhgWBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrG+23xRseUNhMz2jz2oF4AvqzFZpxOyK9h+s4hdMc6V6skNvHtDHXbCcxza5zFE2SnBNC/8R9dWlsld/0a75Qv4XlEgDfgUE0T+dPaFI8s13vFAMvw2IMRltSvJ4ivCz4m1ozoEDsJpKhUGuG2b+MkXRm6CJsnjSiTi5xr9dq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UWf2vXFj; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fc66fc35f2so20524435ad.0
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 00:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721545578; x=1722150378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwRnLnxZnIX7jpw6TVepgUUISRg5HGFY1cuRHhUH+u4=;
        b=UWf2vXFj0bowbDRVADYiQRj0/u+Wfm/BUhD4ZcT4VeyHAcaqQ5CgDM5lLJUWnjZaMw
         iLnFGj04TUQf7ifFDOvHRWBbfqkKpF7MA+wayjc2Z3OAS+5mwPg5SjPOgcCxsM0WyBV2
         KiWKJcfICYFRjnh38K9HJjgWrlEyGR5PZW2WC5Jt0txOIxbWVIUT3mMiPt2O/Za6OcXf
         IsORUqk8rWB7D+ZudMD3/3JFhUG2hvDjpNg0S3rPDxx6h3X3yqd/W/iaUMMrmf4LIJkt
         K13W7+/YkuM7xqR5mkmbzvaUZ2p5V2ceSc8dVJQ0KsL/f7S2HZ3vDAUy7RHwGuPMmkwv
         nJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721545578; x=1722150378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwRnLnxZnIX7jpw6TVepgUUISRg5HGFY1cuRHhUH+u4=;
        b=mN0sC7Oh0ZefKJ0KLFIpchSBpppmT7RiRd4h/erhxGTgGk82gPZjKQVi2rfZ9BHJsF
         x4RiQsX8h2SVyRWudMYjej8nzyUV7KklXEjzxm+bGS/UF1rdr214inPkjCGOofcxvO25
         4Zy+Yepdq3eH3qucAUDjzLF6LrT+O22ad7RpfFNQTBkJ/bY6quuTWTX3eQ97p29xE7Jl
         DwZ5hKkhFIuOVnL5NAjjiIPLBY7yhQPcNNn4jHDIoq7PxB+e9gMQLpZxMedBjGhsCz4N
         ox4734mmVK58E715abRJMFt/2/xUUg2yHgUlsN/Qct6edybyARn5v3pZONNdWwbtaG0M
         0+9Q==
X-Gm-Message-State: AOJu0YypikqlWgHz3w1bPR+cc5uzR/1QUJbgpZyaDmHqgvRdg2UoUi3F
	6mP1fzwQ8FRxUgxvPiZSnSm4b9terGLCRd1UVkzAZq/EDnXM0qYT5s4IkBJV
X-Google-Smtp-Source: AGHT+IHgBFqJOIzhFEOebjR+115FyIhkPJsQ4RffTqIopgshibsvhDZ3nKoLtISm4iteJ5Ms2VJGPQ==
X-Received: by 2002:a17:90b:3a85:b0:2c2:d590:808e with SMTP id 98e67ed59e1d1-2cd16d628fdmr6378942a91.13.1721545578121;
        Sun, 21 Jul 2024 00:06:18 -0700 (PDT)
Received: from JRT-PC.. ([180.255.73.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77492bc6sm4891461a91.1.2024.07.21.00.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 00:06:17 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 4/5] riscv: Add some delay and timer routines
Date: Sun, 21 Jul 2024 15:05:59 +0800
Message-ID: <20240721070601.88639-5-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240721070601.88639-1-jamestiotio@gmail.com>
References: <20240721070601.88639-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a delay method that would allow tests to wait for some specified
number of cycles. Also add a conversion helper method between
microseconds and cycles. This conversion is done by using the timebase
frequency, which is obtained during setup via the device tree.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/Makefile        |  2 ++
 lib/riscv/asm/csr.h   |  1 +
 lib/riscv/asm/delay.h | 16 ++++++++++++++++
 lib/riscv/asm/setup.h |  1 +
 lib/riscv/asm/timer.h | 14 ++++++++++++++
 lib/riscv/delay.c     | 21 +++++++++++++++++++++
 lib/riscv/setup.c     |  4 ++++
 lib/riscv/timer.c     | 28 ++++++++++++++++++++++++++++
 8 files changed, 87 insertions(+)
 create mode 100644 lib/riscv/asm/delay.h
 create mode 100644 lib/riscv/asm/timer.h
 create mode 100644 lib/riscv/delay.c
 create mode 100644 lib/riscv/timer.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 919a3ebb..b0cd613f 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -30,6 +30,7 @@ cflatobjs += lib/memregions.o
 cflatobjs += lib/on-cpus.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/riscv/bitops.o
+cflatobjs += lib/riscv/delay.o
 cflatobjs += lib/riscv/io.o
 cflatobjs += lib/riscv/isa.o
 cflatobjs += lib/riscv/mmu.o
@@ -38,6 +39,7 @@ cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
 cflatobjs += lib/riscv/stack.o
+cflatobjs += lib/riscv/timer.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index ba810c9f..a9b1bd42 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -10,6 +10,7 @@
 #define CSR_SCAUSE		0x142
 #define CSR_STVAL		0x143
 #define CSR_SATP		0x180
+#define CSR_TIME		0xc01
 
 #define SR_SIE			_AC(0x00000002, UL)
 
diff --git a/lib/riscv/asm/delay.h b/lib/riscv/asm/delay.h
new file mode 100644
index 00000000..31379eac
--- /dev/null
+++ b/lib/riscv/asm/delay.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_DELAY_H_
+#define _ASMRISCV_DELAY_H_
+
+#include <libcflat.h>
+#include <asm/setup.h>
+
+extern void delay(uint64_t cycles);
+extern void udelay(unsigned long usecs);
+
+static inline uint64_t usec_to_cycles(uint64_t usec)
+{
+	return (timebase_frequency * usec) / 1000000;
+}
+
+#endif /* _ASMRISCV_DELAY_H_ */
diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index 7f81a705..a13159bf 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -7,6 +7,7 @@
 #define NR_CPUS 16
 extern struct thread_info cpus[NR_CPUS];
 extern int nr_cpus;
+extern uint64_t timebase_frequency;
 int hartid_to_cpu(unsigned long hartid);
 
 void io_init(void);
diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
new file mode 100644
index 00000000..f7504f84
--- /dev/null
+++ b/lib/riscv/asm/timer.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_TIMER_H_
+#define _ASMRISCV_TIMER_H_
+
+#include <asm/csr.h>
+
+extern void timer_get_frequency(void);
+
+static inline uint64_t timer_get_cycles(void)
+{
+	return csr_read(CSR_TIME);
+}
+
+#endif /* _ASMRISCV_TIMER_H_ */
diff --git a/lib/riscv/delay.c b/lib/riscv/delay.c
new file mode 100644
index 00000000..d4f76c29
--- /dev/null
+++ b/lib/riscv/delay.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#include <libcflat.h>
+#include <asm/barrier.h>
+#include <asm/delay.h>
+#include <asm/timer.h>
+
+void delay(uint64_t cycles)
+{
+	uint64_t start = timer_get_cycles();
+
+	while ((timer_get_cycles() - start) < cycles)
+		cpu_relax();
+}
+
+void udelay(unsigned long usecs)
+{
+	delay(usec_to_cycles((uint64_t)usecs));
+}
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 50ffb0d0..e0b5f6f7 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -20,6 +20,7 @@
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
+#include <asm/timer.h>
 
 #define VA_BASE			((phys_addr_t)3 * SZ_1G)
 #if __riscv_xlen == 64
@@ -38,6 +39,7 @@ u32 initrd_size;
 
 struct thread_info cpus[NR_CPUS];
 int nr_cpus;
+uint64_t timebase_frequency;
 
 static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
 
@@ -199,6 +201,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 
 	mem_init(PAGE_ALIGN(__pa(freemem)));
 	cpu_init();
+	timer_get_frequency();
 	thread_info_init();
 	io_init();
 
@@ -264,6 +267,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	}
 
 	cpu_init();
+	timer_get_frequency();
 	thread_info_init();
 	io_init();
 	initrd_setup();
diff --git a/lib/riscv/timer.c b/lib/riscv/timer.c
new file mode 100644
index 00000000..d78d254c
--- /dev/null
+++ b/lib/riscv/timer.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#include <libcflat.h>
+#include <devicetree.h>
+#include <asm/setup.h>
+#include <asm/timer.h>
+
+void timer_get_frequency(void)
+{
+	const struct fdt_property *prop;
+	u32 *data;
+	int cpus, len;
+
+	assert_msg(dt_available(), "ACPI not yet supported");
+
+	const void *fdt = dt_fdt();
+
+	cpus = fdt_path_offset(fdt, "/cpus");
+	assert(cpus >= 0);
+
+	prop = fdt_get_property(fdt, cpus, "timebase-frequency", &len);
+	assert(prop != NULL && len == 4);
+
+	data = (u32 *)prop->data;
+	timebase_frequency = fdt32_to_cpu(*data);
+}
-- 
2.43.0


