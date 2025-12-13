Return-Path: <kvm+bounces-65930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 68187CBB0B2
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 16:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3767E30AEC82
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 15:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B8D25F7BF;
	Sat, 13 Dec 2025 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZvJfbADG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933D261B96
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765638558; cv=none; b=e1HEUIZ24l03tSk2eJueSUc/bc4CHpy0XaUeokGFezJKReZmtflTzIvFlQphTEO0ECMDuEq+sYamK53o7cNPUItNXneRsXoTdk5687q53rKe3URo53UHtNxz1eP8Shljk+cyVHu6UslV7t7z1144l6fi8s2QZbDLvIo2z1GL2sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765638558; c=relaxed/simple;
	bh=5oiICEmyTxrf0lDNRcpwyF5m//Biojf21ey//VfpTKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8IBvqc79LapE6fyXfNJMnLrUihXoWrTPGDqxOj+gRijZnsmmnLNrZSp+9lK8++BTv7RiKsuiFI75ir44hpee6nv3Tx6jlng7U42hRkZM9EHvXw2oqSIqbWgxg4aqYI4Qr4qaJOLFIUCgPM+8anZTRS0GV65KrYnR1owETzAeS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZvJfbADG; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29845b06dd2so25954865ad.2
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 07:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765638554; x=1766243354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmDAR6Bn9JvT49nuZwllh+G0QriEIJ4NSotf6lGYgHk=;
        b=ZvJfbADGWBwoyYoyHpgBn1YRZpuxSjQkMJpdjonczcXnELBglQbjgmPTHYBKXr1uZV
         5iZzH40DZWbDEEVD1lieJAbIurcHTKtTNfq7Kw3US9UAYfP6NBuCmYozuatcoHxv/CDI
         xxRuF8AtoCVAkrJ6wBOJJ6m1OjxZnvm0Ju5ND8dSnD/Nwm3+XxHppbJ5MClOxZvQqlic
         nyHmFwtfC3Fnf0B9LzwwKdq+Yc67qUWk9ljJnPtRnvQY2lc6E2xWj1cPei5hdwzrmGgv
         TY69aMflog6YzmkMhFC6LbWyukOmipuhPaTNDuOISR+Ekm+Sg2Gs9G48O7Hnbop/U+y4
         B4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765638554; x=1766243354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AmDAR6Bn9JvT49nuZwllh+G0QriEIJ4NSotf6lGYgHk=;
        b=nl6cQLx4nJS2o3akg4FbQB5dOR6CJh2pkjbSBzD7V5cb/5jbmzP/i29Aqhcw5OUcRo
         dfcLaQ8h7+QWPYZkM6HLs5osGuTKJfUoKJNwapElTjopjCD/SSFOZl24zhtPNPE/Pm0+
         jYMT5t23ICK64gj1YFyM9qtn6VDptN51L0EqzeJRYYIDxYm7bsPDk3DVeAelK1+BH2sv
         ZzUvi/72PA5QoA8O3YEoX7H/vsq3lPm7zOquoX7nDT0tWwngEJPlwEC/STpccULwMn9x
         U3ReOwzKWJqjay744BfzDjJPy1QrrtXMNgLEWxfkJbShDbrvoSurA3QmvfvSvdNDR480
         lzqw==
X-Gm-Message-State: AOJu0Yw7EbfJG9DFZPF80F/TqV4JZHYTGRkQ0hAE0PiWxZtmStCiUbSM
	3JVFQ4w6mbY6ZBQNSGAeCdY0lH/3Z72cd28Fe0hR+w8vbtQmvuJyHihcnv8jsCeDIzhZUg==
X-Gm-Gg: AY/fxX53dHLzccJXWlhs4xg3n1GzW1DaPZdkj+0OMtuLTHqJWACJZa/zJv4R6OYd3z1
	tMR3klp90gRcKPh9wu4LQdCK+H1wRt5JJWoxz2d8STsZzFkXTrJP2w9Gp/0xbLv8sp2k3Hw2t6q
	UUQ0DO6WLQe1wBWhEUfLqpOxG/aA8hyzXDeLpP7TY6IFBkUfb8DUaWFWkSlSQTLQPdSaMBWCj0d
	RWdlwDQS7s3VF5VQD1zsPvMKf+rb2+YT/Bfl8/t/VVilTDr1L8+RzRXshRvaHvh3ZWXL+HWimuW
	eaybPoptPXyrgj8uIT4rn/0folHu/1GdM20LcLs6zZuqet/2/7OkJaRQ00pbVftdkFpK4UL55xd
	O4yFtdTKJ3Xz1a5t0QdZg1w4+5oeUWw+BdrUoSvFpPV7MGLmSJRC7rU8e0trvaMmvNbHqCUoxPa
	0Iyx6zn40hbWLWxpcQ
X-Google-Smtp-Source: AGHT+IFRYLtmyJngjzSbWKBjUVfP4Wi/Qy+oiDqp2kwr34xj2mRB5StpR9CMC0oxckv+BkwV32PM5w==
X-Received: by 2002:a17:902:c94a:b0:298:648a:f96a with SMTP id d9443c01a7336-29f23d409ffmr50790565ad.61.1765638554178;
        Sat, 13 Dec 2025 07:09:14 -0800 (PST)
Received: from JRT-PC.. ([111.94.32.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016c6esm85494715ad.59.2025.12.13.07.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 07:09:13 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 3/4] lib: riscv: Add SBI PMU helper functions
Date: Sat, 13 Dec 2025 23:08:47 +0800
Message-ID: <20251213150848.149729-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251213150848.149729-1-jamestiotio@gmail.com>
References: <20251213150848.149729-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some helper macros to handle event types and codes and some helper
functions to access the FDT. These will be used by the SBI tests.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/Makefile      |   1 +
 lib/riscv/asm/pmu.h | 167 +++++++++++++++++++++++++++++++++++++++++++
 lib/riscv/pmu.c     | 169 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 337 insertions(+)
 create mode 100644 lib/riscv/asm/pmu.h
 create mode 100644 lib/riscv/pmu.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 64720c38..c0dd5465 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -42,6 +42,7 @@ cflatobjs += lib/riscv/delay.o
 cflatobjs += lib/riscv/io.o
 cflatobjs += lib/riscv/isa.o
 cflatobjs += lib/riscv/mmu.o
+cflatobjs += lib/riscv/pmu.o
 cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setjmp.o
diff --git a/lib/riscv/asm/pmu.h b/lib/riscv/asm/pmu.h
new file mode 100644
index 00000000..8bb5e3e9
--- /dev/null
+++ b/lib/riscv/asm/pmu.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_PMU_H_
+#define _ASMRISCV_PMU_H_
+
+#include <libcflat.h>
+#include <asm/csr.h>
+
+#define SBI_PMU_HW_CTR_MAX				32
+
+#define SBI_EXT_PMU_EVENT_IDX_TYPE_OFFSET		16
+#define SBI_EXT_PMU_EVENT_IDX_TYPE_MASK			(0xF << SBI_EXT_PMU_EVENT_IDX_TYPE_OFFSET)
+#define SBI_EXT_PMU_EVENT_IDX_CODE_MASK			0xFFFF
+
+#define SBI_EXT_PMU_EVENT_HW_CACHE_OPS_RESULT		0x1
+#define SBI_EXT_PMU_EVENT_HW_CACHE_OPS_ID_MASK		0x6
+#define SBI_EXT_PMU_EVENT_HW_CACHE_OPS_ID_OFFSET	1
+#define SBI_EXT_PMU_EVENT_HW_CACHE_ID_MASK		0xFFF8
+#define SBI_EXT_PMU_EVENT_HW_CACHE_ID_OFFSET		3
+
+#define SBI_EXT_PMU_CFG_FLAG_SKIP_MATCH			(1 << 0)
+#define SBI_EXT_PMU_CFG_FLAG_CLEAR_VALUE		(1 << 1)
+#define SBI_EXT_PMU_CFG_FLAG_AUTO_START			(1 << 2)
+#define SBI_EXT_PMU_CFG_FLAG_SET_VUINH			(1 << 3)
+#define SBI_EXT_PMU_CFG_FLAG_SET_VSINH			(1 << 4)
+#define SBI_EXT_PMU_CFG_FLAG_SET_UINH			(1 << 5)
+#define SBI_EXT_PMU_CFG_FLAG_SET_SINH			(1 << 6)
+#define SBI_EXT_PMU_CFG_FLAG_SET_MINH			(1 << 7)
+
+#define SBI_EXT_PMU_START_SET_INIT_VALUE		(1 << 0)
+#define SBI_EXT_PMU_START_FLAG_INIT_SNAPSHOT		(1 << 1)
+
+#define SBI_EXT_PMU_STOP_FLAG_RESET			(1 << 0)
+#define SBI_EXT_PMU_STOP_FLAG_TAKE_SNAPSHOT		(1 << 1)
+
+#define SBI_EXT_PMU_HPM_COUNTER_CASE(n)			\
+	case CSR_HPMCOUNTER##n:				\
+		return csr_read(CSR_HPMCOUNTER##n)
+
+enum sbi_ext_pmu_ctr_type {
+	SBI_EXT_PMU_CTR_TYPE_HW = 0,
+	SBI_EXT_PMU_CTR_TYPE_FW,
+};
+
+union sbi_ext_pmu_ctr_info {
+	unsigned long value;
+	struct {
+		unsigned long csr:12;
+		unsigned long width:6;
+#if __riscv_xlen == 32
+		unsigned long reserved:13;
+#else
+		unsigned long reserved:45;
+#endif
+		unsigned long type:1;
+	};
+};
+
+#define get_cidx_type(x) \
+	(((x) & SBI_EXT_PMU_EVENT_IDX_TYPE_MASK) >> SBI_EXT_PMU_EVENT_IDX_TYPE_OFFSET)
+
+#define get_cidx_code(x) (x & SBI_EXT_PMU_EVENT_IDX_CODE_MASK)
+
+#define get_cidx_cache_id(x) \
+	(((get_cidx_code(x)) & SBI_EXT_PMU_EVENT_HW_CACHE_ID_MASK) >> SBI_EXT_PMU_EVENT_HW_CACHE_ID_OFFSET)
+
+#define get_cidx_op_id(x) \
+	(((get_cidx_code(x)) & SBI_EXT_PMU_EVENT_HW_CACHE_OPS_ID_MASK) >> SBI_EXT_PMU_EVENT_HW_CACHE_OPS_ID_OFFSET)
+
+#define get_cidx_result_id(x) \
+	((get_cidx_code(x)) & SBI_EXT_PMU_EVENT_HW_CACHE_OPS_RESULT)
+
+#define set_cidx_type(x, t) \
+	((x) = ((((x) & ~SBI_EXT_PMU_EVENT_IDX_TYPE_MASK) | \
+		((((unsigned long)(t)) << SBI_EXT_PMU_EVENT_IDX_TYPE_OFFSET) \
+		& SBI_EXT_PMU_EVENT_IDX_TYPE_MASK))))
+
+#define set_cidx_code(x, c) \
+	((x) = ((((x) & ~SBI_EXT_PMU_EVENT_IDX_CODE_MASK) | \
+		(((unsigned long)(c)) & SBI_EXT_PMU_EVENT_IDX_CODE_MASK))))
+
+#define set_cidx_cache_id(x, id) \
+	(set_cidx_code((x), (((get_cidx_code(x)) & ~SBI_EXT_PMU_EVENT_HW_CACHE_ID_MASK) | \
+		((((unsigned long)(id)) << SBI_EXT_PMU_EVENT_HW_CACHE_ID_OFFSET) \
+		& SBI_EXT_PMU_EVENT_HW_CACHE_ID_MASK))))
+
+#define set_cidx_op_id(x, op) \
+	(set_cidx_code((x), (((get_cidx_code(x)) & ~SBI_EXT_PMU_EVENT_HW_CACHE_OPS_ID_MASK) | \
+		((((unsigned long)(op)) << SBI_EXT_PMU_EVENT_HW_CACHE_OPS_ID_OFFSET) \
+		& SBI_EXT_PMU_EVENT_HW_CACHE_OPS_ID_MASK))))
+
+#define set_cidx_result_id(x, res) \
+	(set_cidx_code((x), (((get_cidx_code(x)) & ~SBI_EXT_PMU_EVENT_HW_CACHE_OPS_RESULT) | \
+		(((unsigned long)(res)) & SBI_EXT_PMU_EVENT_HW_CACHE_OPS_RESULT))))
+
+static inline uint64_t pmu_get_cycles(void)
+{
+	return csr_read(CSR_CYCLE);
+}
+
+static inline uint64_t pmu_get_instret(void)
+{
+	return csr_read(CSR_INSTRET);
+}
+
+static inline uint64_t pmu_get_counter(unsigned long csr)
+{
+	switch (csr) {
+	case CSR_CYCLE:
+		return pmu_get_cycles();
+	case CSR_INSTRET:
+		return pmu_get_instret();
+
+	SBI_EXT_PMU_HPM_COUNTER_CASE(3);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(4);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(5);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(6);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(7);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(8);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(9);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(10);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(11);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(12);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(13);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(14);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(15);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(16);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(17);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(18);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(19);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(20);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(21);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(22);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(23);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(24);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(25);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(26);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(27);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(28);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(29);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(30);
+	SBI_EXT_PMU_HPM_COUNTER_CASE(31);
+
+	default:
+		__builtin_unreachable();
+	}
+}
+
+struct sbi_ext_pmu_hw_event {
+	uint32_t counters;
+	unsigned long start_idx;
+	unsigned long end_idx;
+};
+
+struct sbi_ext_pmu_test_ctr {
+	int ctr_idx;
+	unsigned long eid;
+};
+
+int sbi_ext_pmu_get_counters_for_hw_event(unsigned long event_idx);
+int sbi_ext_pmu_get_first_counter_for_hw_event(unsigned long event_idx);
+int sbi_ext_pmu_get_first_unsupported_hw_event(int ctr_idx);
+struct sbi_ext_pmu_test_ctr sbi_ext_pmu_get_candidate_hw_counter_for_test(void);
+void sbi_ext_pmu_add_hw_event_counter_map(u32 event_idx_start, u32 event_idx_end, u32 ctr_map, int i);
+void fdt_pmu_setup(void);
+void fdt_pmu_free(void);
+
+#endif /* _ASMRISCV_PMU_H_ */
diff --git a/lib/riscv/pmu.c b/lib/riscv/pmu.c
new file mode 100644
index 00000000..7bbd8221
--- /dev/null
+++ b/lib/riscv/pmu.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#include <alloc.h>
+#include <libcflat.h>
+#include <devicetree.h>
+#include <asm/sbi.h>
+#include <asm/pmu.h>
+
+static struct sbi_ext_pmu_hw_event *hw_event_map;
+
+int sbi_ext_pmu_get_counters_for_hw_event(unsigned long event_idx)
+{
+	int i;
+
+	if (!hw_event_map)
+		return -1;
+
+	for (i = 0; i < SBI_PMU_HW_CTR_MAX; i++) {
+		if (hw_event_map[i].start_idx <= event_idx &&
+		    hw_event_map[i].end_idx >= event_idx) {
+			return hw_event_map[i].counters;
+		}
+	}
+
+	return -1;
+}
+
+int sbi_ext_pmu_get_first_counter_for_hw_event(unsigned long event_idx)
+{
+	int i, counters = sbi_ext_pmu_get_counters_for_hw_event(event_idx);
+
+	if (!hw_event_map || counters < 0)
+		return -1;
+
+	for (i = CSR_HPMCOUNTER3 - CSR_CYCLE; i < SBI_PMU_HW_CTR_MAX; i++) {
+		if (counters & (1U << i))
+			return i;
+	}
+
+	return -1;
+}
+
+void sbi_ext_pmu_add_hw_event_counter_map(u32 event_idx_start, u32 event_idx_end, u32 ctr_map, int i)
+{
+	assert(event_idx_start <= event_idx_end);
+
+	hw_event_map[i].counters = ctr_map;
+	hw_event_map[i].start_idx = event_idx_start;
+	hw_event_map[i].end_idx = event_idx_end;
+
+	assert(get_cidx_type(hw_event_map[i].start_idx) == SBI_EXT_PMU_EVENT_HW_GENERAL
+	       || get_cidx_type(hw_event_map[i].start_idx) == SBI_EXT_PMU_EVENT_HW_CACHE);
+	assert(get_cidx_type(hw_event_map[i].end_idx) == SBI_EXT_PMU_EVENT_HW_GENERAL
+	       || get_cidx_type(hw_event_map[i].end_idx) == SBI_EXT_PMU_EVENT_HW_CACHE);
+}
+
+int sbi_ext_pmu_get_first_unsupported_hw_event(int ctr_idx)
+{
+	int i, j, k;
+	unsigned long candidate_eid = {0};
+
+	if (!hw_event_map)
+		return -1;
+
+	for (i = SBI_EXT_PMU_HW_CPU_CYCLES; i <= SBI_EXT_PMU_HW_REF_CPU_CYCLES; i++) {
+		set_cidx_type(candidate_eid, SBI_EXT_PMU_EVENT_HW_GENERAL);
+		set_cidx_code(candidate_eid, i);
+
+		if (sbi_ext_pmu_get_counters_for_hw_event(candidate_eid) < 0)
+			return candidate_eid;
+	}
+
+	for (i = SBI_EXT_PMU_HW_CACHE_L1D; i <= SBI_EXT_PMU_HW_CACHE_NODE; i++) {
+		for (j = SBI_EXT_PMU_HW_CACHE_OP_READ; j <= SBI_EXT_PMU_HW_CACHE_OP_PREFETCH; j++) {
+			for (k = SBI_EXT_PMU_HW_CACHE_RESULT_ACCESS; k <= SBI_EXT_PMU_HW_CACHE_RESULT_MISS; k++) {
+				set_cidx_type(candidate_eid, SBI_EXT_PMU_EVENT_HW_CACHE);
+				set_cidx_cache_id(candidate_eid, i);
+				set_cidx_op_id(candidate_eid, j);
+				set_cidx_result_id(candidate_eid, k);
+
+				if (sbi_ext_pmu_get_counters_for_hw_event(candidate_eid) < 0)
+					return candidate_eid;
+			}
+		}
+	}
+
+	return -1;
+}
+
+struct sbi_ext_pmu_test_ctr sbi_ext_pmu_get_candidate_hw_counter_for_test(void)
+{
+	struct sbi_ext_pmu_test_ctr test_ctr = {0};
+	int i, j, k, ctr_idx;
+
+	if (!hw_event_map)
+		return test_ctr;
+
+	unsigned long candidate_eid = {0};
+
+	for (i = SBI_EXT_PMU_HW_CPU_CYCLES; i <= SBI_EXT_PMU_HW_REF_CPU_CYCLES; i++) {
+		set_cidx_type(candidate_eid, SBI_EXT_PMU_EVENT_HW_GENERAL);
+		set_cidx_code(candidate_eid, i);
+		ctr_idx = sbi_ext_pmu_get_first_counter_for_hw_event(candidate_eid);
+
+		if (ctr_idx >= 0) {
+			test_ctr.ctr_idx = ctr_idx;
+			test_ctr.eid = candidate_eid;
+			return test_ctr;
+		}
+	}
+
+	for (i = SBI_EXT_PMU_HW_CACHE_L1D; i <= SBI_EXT_PMU_HW_CACHE_NODE; i++) {
+		for (j = SBI_EXT_PMU_HW_CACHE_OP_READ; j <= SBI_EXT_PMU_HW_CACHE_OP_PREFETCH; j++) {
+			for (k = SBI_EXT_PMU_HW_CACHE_RESULT_ACCESS; k <= SBI_EXT_PMU_HW_CACHE_RESULT_MISS; k++) {
+				set_cidx_type(candidate_eid, SBI_EXT_PMU_EVENT_HW_CACHE);
+				set_cidx_cache_id(candidate_eid, i);
+				set_cidx_op_id(candidate_eid, j);
+				set_cidx_result_id(candidate_eid, k);
+				ctr_idx = sbi_ext_pmu_get_first_counter_for_hw_event(candidate_eid);
+
+				if (ctr_idx >= 0) {
+					test_ctr.ctr_idx = ctr_idx;
+					test_ctr.eid = candidate_eid;
+					return test_ctr;
+				}
+			}
+		}
+	}
+
+	return test_ctr;
+}
+
+void fdt_pmu_setup(void)
+{
+	const void *fdt;
+	int i, pmu_offset, len;
+	const u32 *event_ctr_map;
+	u32 event_idx_start, event_idx_end, ctr_map;
+
+	assert_msg(dt_available(), "ACPI not yet supported");
+
+	fdt = dt_fdt();
+
+	pmu_offset = fdt_node_offset_by_compatible(fdt, -1, "riscv,pmu");
+	assert(pmu_offset >= 0);
+
+	event_ctr_map = fdt_getprop(fdt, pmu_offset, "riscv,event-to-mhpmcounters", &len);
+	if (event_ctr_map) {
+		len = len / (sizeof(u32) * 3);
+		hw_event_map = calloc(len, sizeof(struct sbi_ext_pmu_hw_event));
+		for (i = 0; i < len; i++) {
+			event_idx_start = fdt32_to_cpu(event_ctr_map[3 * i]);
+			event_idx_end = fdt32_to_cpu(event_ctr_map[3 * i + 1]);
+			ctr_map = fdt32_to_cpu(event_ctr_map[3 * i + 2]);
+			sbi_ext_pmu_add_hw_event_counter_map(event_idx_start, event_idx_end, ctr_map, i);
+		}
+		report_info("added %d hw event counter mappings", len);
+	}
+}
+
+void fdt_pmu_free(void)
+{
+	if (hw_event_map) {
+		free(hw_event_map);
+		hw_event_map = NULL;
+	}
+}
-- 
2.43.0


