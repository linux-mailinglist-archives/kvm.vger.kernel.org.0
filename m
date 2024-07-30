Return-Path: <kvm+bounces-22587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D84E1940831
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45B47B226DD
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 06:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B6318FC80;
	Tue, 30 Jul 2024 06:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j9Uv0Zyg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8976416B75D
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 06:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722320319; cv=none; b=IIG+Yb5r+yoRQzhpsjJFsQ9dWIU/AI1uEfNawM3nOaUN2MZ9n5PlyXwuuRpqh2ZSLHzN72r/DQG7cVLYZHwDuZtUp4EuyWYhqjZUGAUTUmJI3wrpNL/cJaqc5yzq3vdFs4GKLEI57+g4ZtIBdZC4n6CtAJYyDRA2lNGqT3eFjn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722320319; c=relaxed/simple;
	bh=+agld4zlqbig1ojMy8W/4esTTSShlDdWhqY4xkhgWBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNAltyDfqrv+gGfYGvMJHcMsuKqAw5bbpdscrpt1pDkyFsyzay0rO2eRemruNFX51PS8RrYIVoEi4FX83/wrM1bg3VCtZ4PzgllPVicZ9yY8DNKn72YchfKDp0hT6Tjv97tONw4KSdZ3Abj0HBFlZU5EW/lGRTWWwZBtRtfViOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j9Uv0Zyg; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70d19c525b5so2656526b3a.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 23:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722320316; x=1722925116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwRnLnxZnIX7jpw6TVepgUUISRg5HGFY1cuRHhUH+u4=;
        b=j9Uv0Zyg0LYZLh0cB7CXhvozlO1+k3U/sDksdtOqutOB0joa259i6RggO0gKSKLI85
         qd6l3yp/IZORxD0WwgbQn3p9PVUHIwcL/a08iFNQGhWzMAJQdWJraeSB5NvjGkyM8J/W
         5vJL+Ql0FrvF9OMGJht+uQO5n03XrJsDVRk++a27dWKoqb3mAa8On8Qieq/zwb1rZdjn
         1LjNklDNJxX+oCQM+EQijSIz1ib4KuqKv4P7DYV1lFIf6o0zchZzid214FH1klHoBq04
         VXaIKTwvzFUHOTa1ZL6T2AXXeRhNlMvwUzkgDOJQi9Jp9b/uQNOxhwW/WDkA7qZQVzbI
         Xrug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722320316; x=1722925116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwRnLnxZnIX7jpw6TVepgUUISRg5HGFY1cuRHhUH+u4=;
        b=tGQsRkHCOVTQwD1hrJEjw52b1aXb6I3DaEuswMrzeGbrLs1pB9ZR3YVer3PYHUsN8x
         tkBj0DppQLGZ4JulNS0DGQF+bNW91SzMsEVaJxIPSkMHmEOnjryyBDabJrAn6kJTPOpB
         CyHO9ISiWWvXIMtiyT6gTqOJoBqcdDUGV6BK7QeJxH0se33Ul7/dR6izqeW+7GqPpf/z
         +GSEirLD1hRIJvM0F4FYIv7vBPkDeQn1j3mode9ycozAFUUKNSESXyrDkvPTLhB3ROBF
         h/K+9Uj7DLEPXWSHn0FcSjoyEQYM/2Oz7dCy07+tAZluF8b33mYe1BlsiOMkwMTMaoFr
         LCMw==
X-Gm-Message-State: AOJu0Yw8WXgsRBPB9+hKIyfdkCNOtmBIIlZCydOrImubsKein6Rd5F8/
	2f1pEAk+AfU7v2NXBHxL+u5Efr38lmqjTSXCwOIo6EZ9CPGekExY9WROF1Z+XWU=
X-Google-Smtp-Source: AGHT+IEOe21GzPpIFL9RJlKO9WKXPkc5wU/dA9Yimqtc6/HmISTe4cOgbk2Kf7vwcHA2NB7i87ed8A==
X-Received: by 2002:a05:6a21:789f:b0:1bd:7559:1710 with SMTP id adf61e73a8af0-1c4a12a2e50mr9193595637.14.1722320316245;
        Mon, 29 Jul 2024 23:18:36 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead6e161dsm7732781b3a.42.2024.07.29.23.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 23:18:35 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 4/5] riscv: Add some delay and timer routines
Date: Tue, 30 Jul 2024 14:18:19 +0800
Message-ID: <20240730061821.43811-5-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240730061821.43811-1-jamestiotio@gmail.com>
References: <20240730061821.43811-1-jamestiotio@gmail.com>
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


