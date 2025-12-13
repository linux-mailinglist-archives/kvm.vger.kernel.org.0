Return-Path: <kvm+bounces-65931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21042CBB0B5
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 16:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DB5830CD2A2
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 15:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00A22638BC;
	Sat, 13 Dec 2025 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mK9gylmf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C747023EA80
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765638559; cv=none; b=Jz0+VWqLuuE43eyP9lPgN3d94ykmkZuHGZJqOU2J91GHOMiebbXGFqveCHsIArMLT2FzJ7SPQYbYHFPA2eno0k8dBQ1blsNxONvAyQwtemwzGTY+19S3o2D5ZWAyfTSxDkVdjpIFz8MMnXaVTQdSoVlIFqkbA+tHfDM++dJTmy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765638559; c=relaxed/simple;
	bh=U2Y4YyzTVp/DGkS14+HJu9QI9HVo++VB/BC96fMAYtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWmJinzd42eldl1kp/zNJuSpCo8oVSPs50IRDcboPUa1lgL5KdfL3NlQfHe3NzOuVYbwYh2kgoh6XNvc4zvYP+0cN8Dhu3SWtn4+TVNLf9cZAnVHGEZsVNNulK95yoGaMxSeXl7T13rzIGgzZUMwaP4IusNTgE0E5TCCbSMaAx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mK9gylmf; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f1bc40b35so27368695ad.2
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 07:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765638557; x=1766243357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHF+94AX9IsJfwresP4VoZ0BFogumn+V5OleWUNGOrE=;
        b=mK9gylmfml0hofd/oDHz3rxnXbVF00evI+gl14vIPKHUAf8Jn6IWAKgpedXBdK2VAm
         zZ45iZilU4kBq52JxLWn86+yaJUBPLOaxWQtcjTp/GdsF/tTVg7ngx7/Cl8cTTs56yQI
         dw3nSK33T992B68xr5qfECAF+DfN/IanDXPf7QJ4P0k/FEV0+uhSoCnIt54qP5vgYdHu
         E0EEE99tJLy8PU40bXV+qPdrN8MO/70beS5UyJ0bOy8BLtutVY7Mk8jz1LwRoREM21/N
         xXTe1F3fSD7AgKJm98h/zbobjTgSg6utRfj3wjZhVpDr+mawVYoDPaY0nhh+sGsOTwuO
         R8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765638557; x=1766243357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YHF+94AX9IsJfwresP4VoZ0BFogumn+V5OleWUNGOrE=;
        b=haHPPrrQ3XibgfMCmQq6aW8bXHQMMyJX77R1cUY34AohQho1i8SkTFKl+lym50bbk9
         DnBWUuPePQOqZ4zChczj67ZGZsc2N+WA5lump0A/w8HgWJqkRfZaNTbFJk34yh/Uq771
         yszy5NZ60HK9IhPqmnBVQUB1fa1mhx4d9KoMtBvlrLdl7vP7q88j3MwofefJr9scuQQI
         o/ZWi2ES011+qk+tzUm0ZIbyFbm+6fe/JLcipfQAzZrWk902h9Bsrf1zmz7biMt72uIw
         pOh4YsgbMbalI8Jhonv4h3u/CLFhr/bHiPbvyg+wLmDXcj5hmGE9+k96Xt8Z7rW0GYaw
         DlGQ==
X-Gm-Message-State: AOJu0YyhYRL/wU8IyF53O6zmy1T4oZjkFmi7YHGQOY1Lfi3AuoTiAFvr
	qU0O8oFBMeTubRkTL0tSn9sUO64QYHoOr4WkV0fIgO1TNE/HqZfSqGODffjmVuv98w9jcQ==
X-Gm-Gg: AY/fxX6Xq8i78hqUbogdrWX5wvylC0UDevfiM80lLwy1LCpKJRr/utUj9r51QneWM3P
	2ytyBqLs/xYB7BNdAaB1Wd2J1VNQE0o6JoQ8oKFpKi5KqmXPenJCe0ZOf4ox63onOk0/Sy7w5eb
	BACAXB0RqUVMm47WSMS5iXKg2BD4izC2vkK3/q8DHs5Cq8YjYVGO0ak71mL4g+bo4e3volBTb7O
	EPoH2xhpabO/4bbSUY4n/W0t1VxTHEL6GECP5NBUwc5cpZ9/9zmaqyeey0iSso1Q7Omeq2CHsZ4
	32L/qv+xKOTVMnbZQuHph8qxYznpuMfB30oRjpfEheqEVn1nX5BQUdftYEc8VxdZgoH4WIISKvm
	loCD998rlrFPIJ4qF4L0mgnUZk6tMw0rR114UDSjvkEtvh4JgPrgE0s7BlebHn5U3tjMr8Z+aJK
	3oxZqvBdnItukTDtiI
X-Google-Smtp-Source: AGHT+IH5SF9o/7ISeAlP3eC1if6rKolBgvqgtC65K6/yldfspYSFfs0X7lNwOIXNJqG91qWeWDYTkg==
X-Received: by 2002:a17:903:2b10:b0:2a0:9ecc:694a with SMTP id d9443c01a7336-2a09ecc6b3cmr14888095ad.37.1765638556521;
        Sat, 13 Dec 2025 07:09:16 -0800 (PST)
Received: from JRT-PC.. ([111.94.32.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016c6esm85494715ad.59.2025.12.13.07.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 07:09:16 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 4/4] riscv: sbi: Add tests for PMU extension
Date: Sat, 13 Dec 2025 23:08:48 +0800
Message-ID: <20251213150848.149729-5-jamestiotio@gmail.com>
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

Add the actual tests for the SBI PMU extension. Functions related to
shared memory (FID #7 and #8) are untested for now.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/Makefile    |   1 +
 riscv/sbi-tests.h |   1 +
 riscv/sbi-pmu.c   | 461 ++++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c       |   2 +
 4 files changed, 465 insertions(+)
 create mode 100644 riscv/sbi-pmu.c

diff --git a/riscv/Makefile b/riscv/Makefile
index c0dd5465..75a108c1 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -21,6 +21,7 @@ all: $(tests)
 sbi-deps += $(TEST_DIR)/sbi-asm.o
 sbi-deps += $(TEST_DIR)/sbi-dbtr.o
 sbi-deps += $(TEST_DIR)/sbi-fwft.o
+sbi-deps += $(TEST_DIR)/sbi-pmu.o
 sbi-deps += $(TEST_DIR)/sbi-sse.o
 
 all_deps += $(sbi-deps)
diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index c1ebf016..509ec547 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -99,6 +99,7 @@ static inline bool env_enabled(const char *env)
 
 void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo);
 void sbi_bad_fid(int ext);
+void check_pmu(void);
 void check_sse(void);
 void check_dbtr(void);
 
diff --git a/riscv/sbi-pmu.c b/riscv/sbi-pmu.c
new file mode 100644
index 00000000..5d2e034a
--- /dev/null
+++ b/riscv/sbi-pmu.c
@@ -0,0 +1,461 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI PMU test suite
+ *
+ * Copyright (C) 2025, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#include <alloc.h>
+#include <alloc_page.h>
+#include <bitops.h>
+#include <cpumask.h>
+#include <libcflat.h>
+#include <on-cpus.h>
+#include <stdlib.h>
+
+#include <asm/csr.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/sbi.h>
+#include <asm/pmu.h>
+
+#include "sbi-tests.h"
+
+#define SBI_PMU_COUNTER_TEST_INIT_VALUE 0x7FFFFFFF
+
+struct sbi_ext_pmu_ctr_csr_map {
+	bool mapped;
+	bool is_fw_ctr;
+	unsigned long ctr_idx;
+	unsigned long csr;
+};
+
+static unsigned long number_of_counters;
+static struct sbi_ext_pmu_ctr_csr_map *sbi_ext_pmu_ctr_csr_map;
+
+static unsigned long get_counter_idx_from_csr(unsigned long csr);
+struct sbi_ext_pmu_test_ctr sbi_ext_pmu_get_candidate_fw_counter_for_test(void);
+uint64_t sbi_ext_pmu_read_fw_counter(unsigned long ctr_idx);
+
+static unsigned long get_counter_idx_from_csr(unsigned long csr)
+{
+	for (unsigned long i = 0; i < number_of_counters; i++) {
+		if (sbi_ext_pmu_ctr_csr_map[i].mapped &&
+		    sbi_ext_pmu_ctr_csr_map[i].csr == csr) {
+			return sbi_ext_pmu_ctr_csr_map[i].ctr_idx;
+		}
+	}
+
+	assert_msg(false, "CSR %lx not found in the map", csr);
+}
+
+struct sbi_ext_pmu_test_ctr sbi_ext_pmu_get_candidate_fw_counter_for_test(void)
+{
+	struct sbi_ext_pmu_test_ctr test_ctr = {0};
+
+	if (!sbi_probe(SBI_EXT_TIME)) {
+		test_ctr.ctr_idx = -1;
+		return test_ctr;
+	}
+
+	set_cidx_type(test_ctr.eid, SBI_EXT_PMU_EVENT_FW);
+	set_cidx_code(test_ctr.eid, SBI_EXT_PMU_FW_SET_TIMER);
+
+	/* Since any firmware counter can be used for testing, return the first one found */
+	for (unsigned long i = 0; i < number_of_counters; i++) {
+		if (sbi_ext_pmu_ctr_csr_map[i].mapped && sbi_ext_pmu_ctr_csr_map[i].is_fw_ctr) {
+			test_ctr.ctr_idx = sbi_ext_pmu_ctr_csr_map[i].ctr_idx;
+			return test_ctr;
+		}
+	}
+
+	test_ctr.ctr_idx = -1;
+	return test_ctr;
+}
+
+uint64_t sbi_ext_pmu_read_fw_counter(unsigned long ctr_idx)
+{
+	struct sbiret ret;
+	uint64_t ctr_val = 0;
+
+	ret = sbi_pmu_counter_fw_read(ctr_idx);
+	report(ret.error == SBI_SUCCESS,
+	       "expected to read lower bits of firmware counter %ld successfully, got %ld", ctr_idx, ret.error);
+
+	ctr_val = ret.value;
+
+	ret = sbi_pmu_counter_fw_read_hi(ctr_idx);
+	report(ret.error == SBI_SUCCESS,
+	       "expected to read upper bits of firmware counter %ld successfully, got %ld", ctr_idx, ret.error);
+
+	ctr_val += ((uint64_t)ret.value << 32);
+
+	return ctr_val;
+}
+
+void check_pmu(void)
+{
+	struct sbiret ret;
+	unsigned long valid_counter_info = 0, num_of_hw_counters = 0;
+	uint64_t cycle_count, instret_count, test_counter_value;
+	bool timer_counter_found = false;
+	union sbi_ext_pmu_ctr_info info;
+	unsigned long test_eid = 0, set_timer_count = 0;
+	int test_counter_idx;
+	struct sbi_ext_pmu_test_ctr test_ctr = {0};
+
+	report_prefix_push("pmu");
+
+	if (!sbi_probe(SBI_EXT_PMU)) {
+		report_skip("PMU extension unavailable");
+		report_prefix_pop();
+		return;
+	}
+
+	sbi_bad_fid(SBI_EXT_PMU);
+
+	report_prefix_push("pmu_num_counters");
+
+	ret = sbi_pmu_num_counters();
+	if (ret.error) {
+		report_fail("failed to get number of counters (error=%ld)", ret.error);
+		report_prefix_popn(2);
+		return;
+	}
+	number_of_counters = ret.value;
+
+	/* CSR_CYCLE, CSR_TIME, and CSR_INSTRET are mandatory counters */
+	if (number_of_counters < 3) {
+		report_fail("number of counters is %ld, expected at least 3", number_of_counters);
+		report_prefix_popn(2);
+		return;
+	}
+
+	report_info("number of counters is %ld", number_of_counters);
+
+	report_prefix_pop();
+
+	report_prefix_push("sbi_pmu_counter_get_info");
+
+	fdt_pmu_setup();
+
+	sbi_ext_pmu_ctr_csr_map = calloc(number_of_counters,
+					    sizeof(struct sbi_ext_pmu_ctr_csr_map));
+
+	for (unsigned long i = 0; i < number_of_counters; i++) {
+		sbi_ext_pmu_ctr_csr_map[i].mapped = false;
+		sbi_ext_pmu_ctr_csr_map[i].is_fw_ctr = false;
+		sbi_ext_pmu_ctr_csr_map[i].ctr_idx = 0;
+		sbi_ext_pmu_ctr_csr_map[i].csr = 0;
+	}
+
+	for (unsigned long i = 0; i < number_of_counters; i++) {
+		ret = sbi_pmu_counter_get_info(i);
+
+		if (ret.error == SBI_ERR_INVALID_PARAM && !timer_counter_found) {
+			/* Assume that this is the CSR_TIME counter and skip it */
+			timer_counter_found = true;
+			sbi_ext_pmu_ctr_csr_map[i].ctr_idx = i;
+			sbi_ext_pmu_ctr_csr_map[i].csr = CSR_TIME;
+			valid_counter_info++;
+			report_info("skipping CSR_TIME counter with index %ld", i);
+			continue;
+		} else if (ret.error) {
+			free(sbi_ext_pmu_ctr_csr_map);
+			fdt_pmu_free();
+			report_fail("failed to get counter info (error=%ld)", ret.error);
+			report_prefix_popn(2);
+			return;
+		}
+
+		info = *(union sbi_ext_pmu_ctr_info *)&ret.value;
+
+		if (info.type == SBI_EXT_PMU_CTR_TYPE_HW) {
+			sbi_ext_pmu_ctr_csr_map[i].mapped = true;
+			sbi_ext_pmu_ctr_csr_map[i].ctr_idx = i;
+			sbi_ext_pmu_ctr_csr_map[i].csr = info.csr;
+
+			if ((info.csr == CSR_CYCLE) || (info.csr == CSR_INSTRET))
+				valid_counter_info += info.width == 63;
+			else
+				valid_counter_info++;
+
+			num_of_hw_counters++;
+		} else if (info.type == SBI_EXT_PMU_CTR_TYPE_FW) {
+			sbi_ext_pmu_ctr_csr_map[i].mapped = true;
+			sbi_ext_pmu_ctr_csr_map[i].is_fw_ctr = true;
+			sbi_ext_pmu_ctr_csr_map[i].ctr_idx = i;
+			valid_counter_info++;
+		} else {
+			free(sbi_ext_pmu_ctr_csr_map);
+			fdt_pmu_free();
+			report_fail("unknown counter type %d", info.type);
+			report_prefix_popn(2);
+			return;
+		}
+	}
+
+	report(valid_counter_info == number_of_counters,
+	       "number of counters with valid info is %ld", valid_counter_info);
+
+	ret = sbi_pmu_counter_get_info(number_of_counters);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when counter_idx == num_counters, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+
+	report_prefix_pop();
+
+	report_prefix_push("sbi_pmu_counter_config_matching");
+
+	cycle_count = pmu_get_cycles();
+	instret_count = pmu_get_instret();
+
+	set_cidx_type(test_eid, SBI_EXT_PMU_EVENT_HW_GENERAL);
+	set_cidx_code(test_eid, SBI_EXT_PMU_HW_CPU_CYCLES);
+	ret = sbi_pmu_counter_config_matching(get_counter_idx_from_csr(CSR_CYCLE),
+					      1,
+					      SBI_EXT_PMU_CFG_FLAG_CLEAR_VALUE,
+					      test_eid,
+					      0);
+
+	if (ret.error) {
+		free(sbi_ext_pmu_ctr_csr_map);
+		fdt_pmu_free();
+		report_fail("failed to configure counter (error=%ld)", ret.error);
+		report_prefix_popn(2);
+		return;
+	}
+
+	test_counter_value = pmu_get_cycles();
+
+	report(test_counter_value < cycle_count,
+	       "expected cycle count to reset (%ld < %ld)", test_counter_value, cycle_count);
+
+	set_cidx_code(test_eid, SBI_EXT_PMU_HW_INSTRUCTIONS);
+	ret = sbi_pmu_counter_config_matching(get_counter_idx_from_csr(CSR_INSTRET),
+					      1,
+					      SBI_EXT_PMU_CFG_FLAG_CLEAR_VALUE,
+					      test_eid,
+					      0);
+
+	if (ret.error) {
+		free(sbi_ext_pmu_ctr_csr_map);
+		fdt_pmu_free();
+		report_fail("failed to configure counter (error=%ld)", ret.error);
+		report_prefix_popn(2);
+		return;
+	}
+
+	test_counter_value = pmu_get_instret();
+
+	report(test_counter_value < instret_count,
+	       "expected instret count to reset (%ld < %ld)", test_counter_value, instret_count);
+
+	set_cidx_code(test_eid, SBI_EXT_PMU_HW_CPU_CYCLES);
+	test_counter_idx = sbi_ext_pmu_get_first_counter_for_hw_event(test_eid);
+
+	report_info("first counter for test hw event %ld is %d", test_eid, test_counter_idx);
+
+	if (test_counter_idx <= 0) {
+		report_skip("failed to get first counter for test hw event");
+	} else {
+		test_counter_value = pmu_get_cycles();
+		ret = sbi_pmu_counter_config_matching(test_counter_idx, 0, SBI_EXT_PMU_CFG_FLAG_CLEAR_VALUE,
+						      test_eid, 0);
+		report(ret.error == SBI_ERR_INVALID_PARAM,
+		       "expected %d when counter_idx_mask == 0, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+		report(pmu_get_cycles() > test_counter_value,
+		       "expected cycle counter to be unaffected when configuring counter %d", test_counter_idx);
+	}
+
+	test_ctr = sbi_ext_pmu_get_candidate_hw_counter_for_test();
+	test_counter_idx = test_ctr.ctr_idx;
+	test_eid = test_ctr.eid;
+
+	report_info("testing hardware counter %d with event %ld", test_counter_idx, test_eid);
+
+	ret = sbi_pmu_counter_config_matching(test_counter_idx, 1,
+					      SBI_EXT_PMU_CFG_FLAG_SKIP_MATCH,
+					      test_eid, 0);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when skipping match before configuring counter, got %ld",
+	       SBI_ERR_INVALID_PARAM, ret.error);
+
+	ret = sbi_pmu_counter_config_matching(test_counter_idx, 1,
+					      SBI_EXT_PMU_CFG_FLAG_CLEAR_VALUE | SBI_EXT_PMU_CFG_FLAG_AUTO_START,
+					      test_eid, 0);
+	if (ret.error) {
+		free(sbi_ext_pmu_ctr_csr_map);
+		fdt_pmu_free();
+		report_fail("failed to configure counter (error=%ld)", ret.error);
+		report_prefix_popn(2);
+		return;
+	}
+	report(ret.value == test_counter_idx,
+	       "expected counter %d to be configured (%ld == %d)", test_counter_idx, ret.value, test_counter_idx);
+
+	test_counter_value = pmu_get_counter(sbi_ext_pmu_ctr_csr_map[test_counter_idx].csr);
+
+	report(test_counter_value > 0,
+	       "expected counter %d to auto-start (%ld > 0)",
+	       test_counter_idx,
+	       test_counter_value);
+
+	test_eid = sbi_ext_pmu_get_first_unsupported_hw_event(test_counter_idx);
+	ret = sbi_pmu_counter_config_matching(test_counter_idx, 1,
+					      SBI_EXT_PMU_CFG_FLAG_CLEAR_VALUE | SBI_EXT_PMU_CFG_FLAG_AUTO_START,
+					      test_eid, 0);
+	report(ret.error == SBI_ERR_NOT_SUPPORTED,
+	       "expected counter %d to be unable to monitor event %ld, got %ld",
+	       test_counter_idx, test_eid, ret.error);
+
+	test_eid = test_ctr.eid;
+
+	report_prefix_pop();
+
+	report_prefix_push("sbi_pmu_counter_start");
+
+	ret = sbi_pmu_counter_start(test_counter_idx, 0, 0, 0);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when counter_idx_mask == 0, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+
+	ret = sbi_pmu_counter_start(test_counter_idx, 1, 0, 0);
+	report(ret.error == SBI_ERR_ALREADY_STARTED,
+	       "expected counter %d to be already started, got %ld", test_counter_idx, ret.error);
+
+	report_prefix_pop();
+
+	report_prefix_push("sbi_pmu_counter_stop");
+
+	ret = sbi_pmu_counter_stop(test_counter_idx, 0, 0);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when counter_idx_mask == 0, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+
+	ret = sbi_pmu_counter_stop(test_counter_idx, 1, 0);
+	report(ret.error == SBI_SUCCESS,
+	       "expected counter %d to be stopped, got %ld", test_counter_idx, ret.error);
+
+	ret = sbi_pmu_counter_stop(test_counter_idx, 1, 0);
+	report(ret.error == SBI_ERR_ALREADY_STOPPED,
+	       "expected counter %d to be already stopped, got %ld", test_counter_idx, ret.error);
+
+	report_prefix_pop();
+
+	report_prefix_push("sbi_pmu_counter_start");
+
+	ret = sbi_pmu_counter_start(test_counter_idx, 1, SBI_EXT_PMU_START_SET_INIT_VALUE,
+				    SBI_PMU_COUNTER_TEST_INIT_VALUE);
+	report(ret.error == SBI_SUCCESS,
+	       "expected counter %d to be started with initial value, got %ld", test_counter_idx, ret.error);
+
+	test_counter_value = pmu_get_counter(sbi_ext_pmu_ctr_csr_map[test_counter_idx].csr);
+	report(test_counter_value > SBI_PMU_COUNTER_TEST_INIT_VALUE,
+	       "expected counter %d to start with initial value (%ld > %d)",
+	       test_counter_idx, test_counter_value, SBI_PMU_COUNTER_TEST_INIT_VALUE);
+
+	report_prefix_pop();
+
+	report_prefix_push("sbi_pmu_counter_stop");
+
+	ret = sbi_pmu_counter_stop(test_counter_idx, 1, 0);
+	report(ret.error == SBI_SUCCESS,
+	       "expected counter %d to be stopped, got %ld", test_counter_idx, ret.error);
+
+	report_prefix_pop();
+
+	report_prefix_push("sbi_pmu_counter_fw_read");
+
+	ret = sbi_pmu_counter_fw_read(number_of_counters);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when counter_idx == num_counters, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+
+	ret = sbi_pmu_counter_fw_read_hi(number_of_counters);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when counter_idx == num_counters, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+
+	test_ctr = sbi_ext_pmu_get_candidate_fw_counter_for_test();
+	test_counter_idx = test_ctr.ctr_idx;
+	test_eid = test_ctr.eid;
+
+	if (test_counter_idx < 0) {
+		free(sbi_ext_pmu_ctr_csr_map);
+		fdt_pmu_free();
+		report_skip("no firmware counters available for testing");
+		report_prefix_popn(2);
+		return;
+	}
+
+	report_info("testing firmware counter %d with event 0x%lx", test_counter_idx, test_eid);
+
+	ret = sbi_pmu_counter_config_matching(test_counter_idx, 1,
+					      SBI_EXT_PMU_CFG_FLAG_CLEAR_VALUE | SBI_EXT_PMU_CFG_FLAG_AUTO_START,
+					      test_eid, 0);
+	if (ret.error) {
+		free(sbi_ext_pmu_ctr_csr_map);
+		fdt_pmu_free();
+		report_fail("failed to configure counter (error=%ld)", ret.error);
+		report_prefix_popn(2);
+		return;
+	}
+	report(ret.value == test_counter_idx,
+	       "expected counter %d to be configured (%ld == %d)", test_counter_idx, ret.value, test_counter_idx);
+
+	test_counter_value = sbi_ext_pmu_read_fw_counter(test_counter_idx);
+
+	report(test_counter_value == set_timer_count,
+	       "expected counter %d to be cleared (%ld == %ld)",
+	       test_counter_idx,
+	       test_counter_value,
+	       set_timer_count);
+
+	ret = sbi_pmu_counter_start(test_counter_idx, 0, 0, 0);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when counter_idx_mask == 0, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+
+	ret = sbi_pmu_counter_start(test_counter_idx, 1, 0, 0);
+	report(ret.error == SBI_ERR_ALREADY_STARTED,
+	       "expected counter %d to be already started, got %ld", test_counter_idx, ret.error);
+
+	sbi_set_timer(0);
+	set_timer_count++;
+	test_counter_value = sbi_ext_pmu_read_fw_counter(test_counter_idx);
+
+	report(test_counter_value == set_timer_count,
+	       "expected counter %d to have incremented (%ld == %ld)",
+	       test_counter_idx,
+	       test_counter_value,
+	       set_timer_count);
+
+	sbi_set_timer(ULONG_MAX);
+	set_timer_count++;
+	test_counter_value = sbi_ext_pmu_read_fw_counter(test_counter_idx);
+
+	report(test_counter_value == set_timer_count,
+	       "expected counter %d to have incremented (%ld == %ld)",
+	       test_counter_idx,
+	       test_counter_value,
+	       set_timer_count);
+
+	ret = sbi_pmu_counter_stop(test_counter_idx, 0, 0);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "expected %d when counter_idx_mask == 0, got %ld", SBI_ERR_INVALID_PARAM, ret.error);
+
+	ret = sbi_pmu_counter_stop(test_counter_idx, 1, 0);
+	report(ret.error == SBI_SUCCESS,
+	       "expected counter %d to be stopped, got %ld", test_counter_idx, ret.error);
+
+	ret = sbi_pmu_counter_stop(test_counter_idx, 1, 0);
+	report(ret.error == SBI_ERR_ALREADY_STOPPED,
+	       "expected counter %d to be already stopped, got %ld", test_counter_idx, ret.error);
+
+	sbi_set_timer(ULONG_MAX);
+	test_counter_value = sbi_ext_pmu_read_fw_counter(test_counter_idx);
+
+	report(test_counter_value == set_timer_count,
+	       "expected counter %d to be unchanged after stop (%ld == %ld)",
+	       test_counter_idx,
+	       test_counter_value,
+	       set_timer_count);
+
+	free(sbi_ext_pmu_ctr_csr_map);
+	fdt_pmu_free();
+	report_prefix_popn(2);
+}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 3b8aadce..fdb6a38a 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -32,6 +32,7 @@
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
+void check_pmu(void);
 void check_sse(void);
 void check_fwft(void);
 
@@ -1557,6 +1558,7 @@ int main(int argc, char **argv)
 	check_time();
 	check_ipi();
 	check_hsm();
+	check_pmu();
 	check_dbcn();
 	check_susp();
 	check_sse();
-- 
2.43.0


