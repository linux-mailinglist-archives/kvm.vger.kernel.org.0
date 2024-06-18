Return-Path: <kvm+bounces-19881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6081990DAB7
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:32:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D75DE1F234A8
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2C414C58E;
	Tue, 18 Jun 2024 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrhIN+rE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E6C146A88
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731946; cv=none; b=J5OBGQwMKviid67cqRo4m97fMv2EO3XKydixy04QWl8vn1iEZmlg4uRCe7dFc2c4IPPAUnQ2WcZP5g8VIljIEVSV8PNf1/26QrbIGwvVJHptk+qXLOSmy1rsWbSEviIwnQGC3Ndr2+lMgcCofNtBeofOq2Yu1s5y1ubPAYBoXtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731946; c=relaxed/simple;
	bh=nmIMTenljNjLUNMw2DuUzDYXcii4qGa5ncqWWGnRWJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YawaDCrYwrMH1CahGns3GGu+9cfR74D2o19R29ycOyzGB4zX6SSoq8buOf6Ynbj+FHfLbWvVv/chDiMHdQXFR1eBpb2WY8Z5xufMmeXSo37pLlT8rsYdcLGVW9tJiAG0RIWfTexUBA3Y0Bd+YWmec+hIyObhjpH66LI/D9TgtSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JrhIN+rE; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2c4c7eb425fso4621538a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 10:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718731943; x=1719336743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWxGifUK2SvPEf1BO6CmMLPV00mCLKHwlYt6Zz7pgPc=;
        b=JrhIN+rEaPf2RjH5kusyDLGLwSoS8pj6BieSnk8o1DH5vNo//a0cuQ4/Y/oF9tDQrV
         PUETY9my0HS5okc8BuPaziTdbF/0Gi+B3qS+kPF7BSM+CVY02iChNi+S2W78qGlHY+h+
         Jw93yOxlXhqym8nG1En5fsC/NddoEP3Q3E5TsFL0Ojb6oLOzhiFGDnUUacrBwhFelJtR
         3KA9qUlRvQ7ltTmSOAHXxwAbUQoC3EXFlAL9F1Lbv2iG2sWlywKH5hv6qpPe1Ue5YmO6
         saK24C9zPj/YUWAPcWcdnlO6SKGiEMtWDgfF0yKu3G51p7h6mx3kyx87xOxp4Tky/9Ox
         Bpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731943; x=1719336743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWxGifUK2SvPEf1BO6CmMLPV00mCLKHwlYt6Zz7pgPc=;
        b=IJ81dD3wOGlJmStfRrwHGuUwekzUhA+hzM4BbJqo80LOK8i9n/2vXjfNBZWCLJr8pc
         d8ruibWPxzLn3rethpWuoGkpm9oETIIufTap7Co8xH2G47hnjKrUWoKGXOmbL0eEOMww
         gmLTaYQiT29OxQdIgK8d4OTHRueLfazp5VvktKxxN/jI8/szSH4ENmQEu2cbjLMisWgj
         LbBH2MANopp085Y/RzFJkdK916Kgektv0GoRulbDlJYesS1eMQIbwYoa+GdyCRHllmnj
         gwbmGOgo6jftQAicgo43eyBAZ92Z34dMQ8j048OHkfIbyzgWU5oQX4qRSH67mdRqbpOn
         lIvA==
X-Gm-Message-State: AOJu0YyZu4W/hruMJdPoQe5gRtx+LqOuad/v6WFld4yWudmRPVtQ2h8T
	ru6MZztCTSl60856W18qHuD7PoLbSzaLoaIMADI2xKuUlqrm/iTwb2tmN0bR
X-Google-Smtp-Source: AGHT+IG0z7MBG/kZ+UiDHnDdP5GEeh4qij7yknA/KoUMASQ8r7/Z5Ko3g4gmX+10IevrwdjVn4XP2w==
X-Received: by 2002:a17:90a:c908:b0:2c4:b12b:fcc with SMTP id 98e67ed59e1d1-2c7b5cc800fmr359986a91.27.1718731941941;
        Tue, 18 Jun 2024 10:32:21 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75ee5a5sm13529305a91.17.2024.06.18.10.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 10:32:21 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 3/4] riscv: Add methods to toggle interrupt enable bits
Date: Wed, 19 Jun 2024 01:30:52 +0800
Message-ID: <20240618173053.364776-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618173053.364776-1-jamestiotio@gmail.com>
References: <20240618173053.364776-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some helper methods to toggle the interrupt enable bits in the SIE
register.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/Makefile            |  1 +
 lib/riscv/asm/csr.h       |  7 +++++++
 lib/riscv/asm/interrupt.h | 12 ++++++++++++
 lib/riscv/interrupt.c     | 39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)
 create mode 100644 lib/riscv/asm/interrupt.h
 create mode 100644 lib/riscv/interrupt.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 919a3ebb..108d4481 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -30,6 +30,7 @@ cflatobjs += lib/memregions.o
 cflatobjs += lib/on-cpus.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/riscv/bitops.o
+cflatobjs += lib/riscv/interrupt.o
 cflatobjs += lib/riscv/io.o
 cflatobjs += lib/riscv/isa.o
 cflatobjs += lib/riscv/mmu.o
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index c1777744..da58b0ce 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -4,15 +4,22 @@
 #include <linux/const.h>
 
 #define CSR_SSTATUS		0x100
+#define CSR_SIE			0x104
 #define CSR_STVEC		0x105
 #define CSR_SSCRATCH		0x140
 #define CSR_SEPC		0x141
 #define CSR_SCAUSE		0x142
 #define CSR_STVAL		0x143
+#define CSR_SIP			0x144
 #define CSR_SATP		0x180
 
 #define SSTATUS_SIE		(_AC(1, UL) << 1)
 
+#define SIE_SSIE		(_AC(1, UL) << 1)
+#define SIE_STIE		(_AC(1, UL) << 5)
+#define SIE_SEIE		(_AC(1, UL) << 9)
+#define SIE_LCOFIE		(_AC(1, UL) << 13)
+
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
 
diff --git a/lib/riscv/asm/interrupt.h b/lib/riscv/asm/interrupt.h
new file mode 100644
index 00000000..b760afbb
--- /dev/null
+++ b/lib/riscv/asm/interrupt.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_INTERRUPT_H_
+#define _ASMRISCV_INTERRUPT_H_
+
+#include <stdbool.h>
+
+void toggle_software_interrupt(bool enable);
+void toggle_timer_interrupt(bool enable);
+void toggle_external_interrupt(bool enable);
+void toggle_local_cof_interrupt(bool enable);
+
+#endif /* _ASMRISCV_INTERRUPT_H_ */
diff --git a/lib/riscv/interrupt.c b/lib/riscv/interrupt.c
new file mode 100644
index 00000000..bc0e16f1
--- /dev/null
+++ b/lib/riscv/interrupt.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#include <libcflat.h>
+#include <asm/csr.h>
+#include <asm/interrupt.h>
+
+void toggle_software_interrupt(bool enable)
+{
+	if (enable)
+		csr_set(CSR_SIE, SIE_SSIE);
+	else
+		csr_clear(CSR_SIE, SIE_SSIE);
+}
+
+void toggle_timer_interrupt(bool enable)
+{
+	if (enable)
+		csr_set(CSR_SIE, SIE_STIE);
+	else
+		csr_clear(CSR_SIE, SIE_STIE);
+}
+
+void toggle_external_interrupt(bool enable)
+{
+	if (enable)
+		csr_set(CSR_SIE, SIE_SEIE);
+	else
+		csr_clear(CSR_SIE, SIE_SEIE);
+}
+
+void toggle_local_cof_interrupt(bool enable)
+{
+	if (enable)
+		csr_set(CSR_SIE, SIE_LCOFIE);
+	else
+		csr_clear(CSR_SIE, SIE_LCOFIE);
+}
-- 
2.43.0


