Return-Path: <kvm+bounces-21912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C07CF93728D
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 04:40:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C7101F21D4F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 02:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05557C144;
	Fri, 19 Jul 2024 02:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bghUbdpg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72BB22094
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 02:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721356808; cv=none; b=BuOJGZrSko0BRacov1/0+Es5A9R2E8p2QPVi3xS/AiNs8anLpYhj+YbaF5SKgTJhhLt+NL+Kxn5DXt8DWZU2xc3W80kjUGlJzePDwG7GvIQMuvyxcQ9ziVCR17mS58t+fQosqZ6MEim3RSZDkvVRnoOVWRiisK+HH2a5AjVg7R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721356808; c=relaxed/simple;
	bh=jecQVlJXe4cgGggLdbAFJT9ADB00vwwpDrqUxrMcSJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQF+TLXPpSON37Nh5BuAXSFjxMKZQlpSJ9TJ4YNPm9hcXXvsolSCaRfoJ+3nGZRMryhEH/w2ISkJwgKZSXpvBfRguEByrd6QwMXJkXPA6BPXW2wBQ+E0smwCsK6Y2RShZy5gdL5DzsdqYcQSRakcU2g9Ous5S+rshcnZE1rcaWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bghUbdpg; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70af0684c2bso373393b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721356806; x=1721961606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOsMqz9z7Oh6nOgISuqIG8CJ1WmrFbXS0QT63MVa3N8=;
        b=bghUbdpgQGHvt1/k/aKj2s+x4DNPpgVse8ojd/b0BJl8RvUYsULGAbug06SLR8gT52
         5NLMKIBrQkh3vxpTy3HXDf0oFziGV0Lx/u62+7QwU+0XerH/dRQx4uNmpX/euCLE+vl4
         unxh9GdZW0D3TJYbhilGIz/XLUxN+SBGPBXRjZ47KJARa/Nw6u/rpg2PL/oueARDKtlA
         Dqn+VeHK72lRrEQqH1vbql/BTi5oBpZeTy5Q4dQMBxOZbiq8ypWJ5fXJ+HaNlqJX/G1o
         8rfEfezTdBtk6qINbIjPextEq+w0v3EM6FWA/10Kn340vhCZOP/HyWYsBrTaVo3MeXrn
         qaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721356806; x=1721961606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOsMqz9z7Oh6nOgISuqIG8CJ1WmrFbXS0QT63MVa3N8=;
        b=UYFGyXDNq/1xPOqWDXdnB2F3QiQNy7l9811cKB8Uz7+i3fai+KMIFvbiKu5NFGLfMe
         jT6VO5buepMqdZQoGTEx2KNNh8mM9hw3HwMzP3iYJnxo0cyXKzW2lZkwtQxjK0k7ZA+r
         oLokaG5n27ItM3cEbrjF1s3LVS21WWlseqI5loaTg/Fz2lixb2CcXBS8mla1MqOy1F6c
         BZAyV2Srq1XNJrKzSN4l5aB/ose1exJ9UHfV/Np7SKQK7yekr4RtbBC7W3RMVX5nXk+l
         hDT3FSWZrMInDmjwL6QLfoGCwzPShBUgn70eNaVnMNExenL1AhgKW242tZIWSE8/ZBE5
         rabA==
X-Gm-Message-State: AOJu0YzE+PwPCf6nLedlmSC3rmkJmSYI7gPfiT0/30dVotCXQcj37ZOh
	EGuX6DYQpNAtgSyZSlQc0tDDpbS4z/CLASQXUze52sn4i2QRhmAzeiwcHqGJ
X-Google-Smtp-Source: AGHT+IHmveWlmRRR9abbnxX8207M4lbpHXpK3hIFLSfirKbPsB5gPB8hMI155QLlcMWCbOkPIReenA==
X-Received: by 2002:a05:6a00:180b:b0:706:7577:c564 with SMTP id d2e1a72fcca58-70ce500d42emr8522056b3a.21.1721356805471;
        Thu, 18 Jul 2024 19:40:05 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff491231sm234930b3a.31.2024.07.18.19.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 19:40:05 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 4/5] riscv: Add some delay and timer routines
Date: Fri, 19 Jul 2024 10:39:46 +0800
Message-ID: <20240719023947.112609-5-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240719023947.112609-1-jamestiotio@gmail.com>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
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

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/Makefile        |  2 ++
 lib/riscv/asm/csr.h   |  1 +
 lib/riscv/asm/delay.h | 15 +++++++++++++++
 lib/riscv/asm/setup.h |  1 +
 lib/riscv/asm/timer.h | 14 ++++++++++++++
 lib/riscv/delay.c     | 16 ++++++++++++++++
 lib/riscv/setup.c     |  4 ++++
 lib/riscv/timer.c     | 26 ++++++++++++++++++++++++++
 8 files changed, 79 insertions(+)
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
index 00000000..ce540f4c
--- /dev/null
+++ b/lib/riscv/asm/delay.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_DELAY_H_
+#define _ASMRISCV_DELAY_H_
+
+#include <libcflat.h>
+#include <asm/setup.h>
+
+extern void delay(u64 cycles);
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
index 00000000..2e319391
--- /dev/null
+++ b/lib/riscv/asm/timer.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_TIMER_H_
+#define _ASMRISCV_TIMER_H_
+
+#include <asm/csr.h>
+
+extern void timer_get_frequency(const void *fdt);
+
+static inline uint64_t timer_get_cycles(void)
+{
+	return csr_read(CSR_TIME);
+}
+
+#endif /* _ASMRISCV_TIMER_H_ */
diff --git a/lib/riscv/delay.c b/lib/riscv/delay.c
new file mode 100644
index 00000000..6b5c78da
--- /dev/null
+++ b/lib/riscv/delay.c
@@ -0,0 +1,16 @@
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
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 50ffb0d0..905ea708 100644
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
+	timer_get_frequency(dt_fdt());
 	thread_info_init();
 	io_init();
 
@@ -264,6 +267,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	}
 
 	cpu_init();
+	timer_get_frequency(dt_fdt());
 	thread_info_init();
 	io_init();
 	initrd_setup();
diff --git a/lib/riscv/timer.c b/lib/riscv/timer.c
new file mode 100644
index 00000000..db8dbb36
--- /dev/null
+++ b/lib/riscv/timer.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#include <libcflat.h>
+#include <devicetree.h>
+#include <asm/setup.h>
+#include <asm/timer.h>
+
+void timer_get_frequency(const void *fdt)
+{
+	const struct fdt_property *prop;
+	u32 *data;
+	int cpus;
+
+	assert_msg(dt_available(), "ACPI not yet supported");
+
+	cpus = fdt_path_offset(fdt, "/cpus");
+	assert(cpus >= 0);
+
+	prop = fdt_get_property(fdt, cpus, "timebase-frequency", NULL);
+	assert(prop != NULL);
+
+	data = (u32 *)prop->data;
+	timebase_frequency = fdt32_to_cpu(*data);
+}
-- 
2.43.0


