Return-Path: <kvm+bounces-22468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA51693E8AC
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 18:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77E8D281760
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 16:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0426F31C;
	Sun, 28 Jul 2024 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aoal+dkx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81D26F303
	for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722185441; cv=none; b=MvwEMLZvAelfShOlLnQ790U6fJ6jHOAfmmTVBcCqoB8WS8hfWfiRTbw6eS6VzqapkYzNtJeHuLDoj9IBFxV8HwyjK69FCJoThGDFiTXOIomUgrDLjeptKcHfwJncf7MpcgrfEwD/ykmoy+GuV5/r7bk7OyycmWnpDPz4pE1U4cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722185441; c=relaxed/simple;
	bh=+agld4zlqbig1ojMy8W/4esTTSShlDdWhqY4xkhgWBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDfcc19xq5EHHh5ARr2AXtCjhSDc4bbU9Re9a5asoJ0fSGWrUPmBkkIx3Z6aYmM9oN2LwhnWiNvBLZJAiNLK8FMQ/0pNRwlXQlNFTboqJYjceqsDvVLQKwTynVElBbfosCP+rTKYRQX7y0SGZAplPA8SJJlC3UUbLuisy61vS5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aoal+dkx; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-396db51d140so15699905ab.0
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 09:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722185438; x=1722790238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwRnLnxZnIX7jpw6TVepgUUISRg5HGFY1cuRHhUH+u4=;
        b=aoal+dkxaOwPT5Vv4XRLH3d5M0/fzywkjkMIwWCP1+ILlSovwArC8xBo5n/NOaV6sX
         SGIhxtfcHB7Ww1sKU8zVAZmDP8DI1pToNJV3MPiL1v2/MKftzYRZaNWqAOG3amCvJGce
         zAxvEY1iqUaJpjqS+SHf/0av8h9PUp8tSRMWfqdwOMeYGfJhaS3SiGIq0Kj6+QTbqWIS
         qfSaUYsGpcwJ5fEWtQqb+JIMcm5QnLnt7WLFu8281stQJESNFcXdTrUOUKLcGPCEzfuS
         XZ/ANgS/eEzcbjnuP4Mtz/mbGZPzzj1SYdmaiwOnQL3mI+iibE4ogRDXq5rauHNDqO+r
         7LMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722185438; x=1722790238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwRnLnxZnIX7jpw6TVepgUUISRg5HGFY1cuRHhUH+u4=;
        b=HFe5LM9i/N3j1Npyb67LWovV3WOO/pv9AO+9tR/+KtoWm9GNiYgvVejZpZTKuFvfT/
         iwngAFowUQUAervOXWohU2V7dW9o9g/mqEhwdHctfi4B94eLp6pxeNtL1JqrdqNyid9m
         q17yDIANZky0S9yUmVxn4awspTPwFTrcLileANewns6gENZFE0xAsIauZig6fmzREyrc
         QFtxNFCg1jY/NzXB7yFfsrnjnX+Lsti9sczanDqT45YzNnfOkpsGejw4lPQh/EfGpHwD
         ZWThDmE8qIvFYBx7k4vsYa3OKPG1DzmGfSDTo19ah+q8K8eqS00VCPn8SJzL8iGYxete
         6o0A==
X-Gm-Message-State: AOJu0YzqC34KwdqcMQoaRRuzIcLZZ78B9Wa32U2o7HZDxbyRyRR4FWNa
	Djfzcr7Oqv3wP0RJVEpZllUBjVv7uthnTjkWmMI2yGHcI9MMn59o0n/X76OE3Fk=
X-Google-Smtp-Source: AGHT+IGDbgR1fW8w1fF/wiQe2wYgOqO26bcBkZACY1CmOXNlqWChY8wo2q1ubKE51A9uHwlZ5v7MLw==
X-Received: by 2002:a05:6e02:1a4e:b0:383:873c:e2a4 with SMTP id e9e14a558f8ab-39aec400f39mr54849855ab.18.1722185438296;
        Sun, 28 Jul 2024 09:50:38 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c7b0besm6969413a91.14.2024.07.28.09.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 09:50:37 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 4/5] riscv: Add some delay and timer routines
Date: Mon, 29 Jul 2024 00:50:21 +0800
Message-ID: <20240728165022.30075-5-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728165022.30075-1-jamestiotio@gmail.com>
References: <20240728165022.30075-1-jamestiotio@gmail.com>
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


