Return-Path: <kvm+bounces-51430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D498AF712D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 981394E5561
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBFE2E2F1C;
	Thu,  3 Jul 2025 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Thd6MvD8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33A122D78F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540289; cv=none; b=PyYOgfHo9gVUKxBTlWqCBe4w0PVewybwC9u9PD5dG7lMcO4mAGpNSPJuY3Ev8+No8+qg66l44F+ck7hzwlxtWY8n3tJAz8rRCmdtzXRrPwdgiBPgWQI1xk1OMuEXMncMOL8kkdUAegCZs+a/tm9tVhBdDeI+1snYRyBZNXGZMxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540289; c=relaxed/simple;
	bh=DAaLo8Um6i1jOAB7EGN62wvxDdBQ6iptBfrjwh0pmgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=muFLdyhBanUaP50TGc75+5NgRp+8Hxxpbb2PKxLtxvlhU9NsIKP2joQc0ijFinkDtn8fpYsPz7CW5hELKLC6cIsv/FdvS7TNcfnBFSUDVDC82WD+QBPyH1C5NGwzHiXBW1TnYfNGJIwA04DX9bX3yqoQOoC8eJXv/QbvkMrUNEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Thd6MvD8; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-450cfb79177so47601595e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540285; x=1752145085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZYD1iVb5yNq60bNwDlmyqD29wMJj8nUcHdsBdsg2to=;
        b=Thd6MvD81NEkA6zehOqAujCSBf1ITe9DQ/T0fpJaAMGQdLgqC3KDZvmkxY+8kGhOhs
         7qAT/Zqn/FrTvLm6dgAqA/sqA0Ofz/8wETbzZ8Z7OHctgApPUgXisvOHGVXuX3kGSEGc
         StEjyD515oo+vjvRZ1uvsWJAYKA0ywoU7kG3MLaoEDiKZHabPeDlvMCFLclQETN6U5NK
         gI7Ep0iNhbWsnqYzuwfvBwU/MYUjItB6QnkP05mIfaiJgZQL79e9qvr6h4VsaZgTxm2v
         4eGUcnbzNc2at4f2DBWBGFohWPDxjH9d+mAh96vg3CtFe3SAr+ldRLncdRAC2Rar3n7s
         jhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540285; x=1752145085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZYD1iVb5yNq60bNwDlmyqD29wMJj8nUcHdsBdsg2to=;
        b=rUSiXqaMp3IP9ACiSn5xU+JTnd/ndLzNW5ynCt0HdSMExb2nLNOM59XYrVQrbGUUrb
         dgbJ6CN360hChZRnA7z5wlV5EN0PlR7By922vaKk56CJBQMKm61i1UcYNFtx9eKsOxa0
         UTk7Isq17/kjPbh7hgrpYOiTVQGM81baMqr9r2WaEA/mga9le+hbx0v76wI6ftOVju3R
         +dLi+GbNq1ksF8wVinCz2/i2rch6QkiN7d4LqBfqUQkbXnsa3DrWDOoeKhRXE5Zlbffv
         C7NA+oDmDbQaB9yKNL2KIXFSePI/cuYBQ07Zc2a7mkfZ6x5PT91LcU9UUpGoylBBwVYg
         ASpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWesxFlzmhLURtCfopyobKxHvbyadNWoI39VkYKwOA+JsfcArS4RZse+gtpXUYykd09uGg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG/DP6WZ64MwccE7exNsQ28QLri9/LcpuRPXnX9siM6BPAZxKr
	e46C5HtWM//S/RZCxeB0/WrVs/WMTxFX/JoNTPqLi0wgwQIYcgMHIt+9Zh0pjc8zSBU=
X-Gm-Gg: ASbGncsTVB9EM7XhHMws0xwjLYz/UZxwvp5a5sBn+HbE04hoUbu37Se+r8nbhoYtaso
	yFlHOLXfHknaW6rrGkwl7+RBMpDaIy/U9fMwEik33fSv/46dsLx3DzObl6jD/ZVlGglYONrIZmw
	HCHLns+hTz7pbrCbjcHpS2+0xsAv7D6Xi/4fQHWfdlIwPy6gDBWuxqPt4VxRTjIDe+ZZcegANZQ
	kXDUstXguz3ntOSTJPQgrn3EfeMd1hIMpj68uUZwrFLIN9V3BMKOHwwhhzWP0fQeebMqZ7EmYTv
	3vPswoBDnYwaQG0XYVE/dq/VN/5QpkyN7xTJEarLX3WScXGpTmK4ggDzEmhXxfZoJZcYbm+mVk5
	h/woyagfHsr/+M6DV9m6R6w==
X-Google-Smtp-Source: AGHT+IEAL5Mwk/Kjdf5FMrbecdZ24UDS0EKLaNk0iJoBp+iJv11hWTkrZkwV8NtF4xPiV2NGD6N9Tg==
X-Received: by 2002:a05:600c:8598:b0:440:9b1a:cd78 with SMTP id 5b1f17b1804b1-454a9efa92cmr22602455e9.10.1751540285307;
        Thu, 03 Jul 2025 03:58:05 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7fa54dsm18070004f8f.23.2025.07.03.03.58.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:04 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 27/69] accel/tcg: Extract statistic related code to tcg-stats.c
Date: Thu,  3 Jul 2025 12:54:53 +0200
Message-ID: <20250703105540.67664-28-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Statistic code is not specific to system emulation (except
cross-page checks) and can be used to analyze user-mode binaries.
Extract statistic related code to its own file: tcg-stats.c.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/monitor.c   | 193 ---------------------------------------
 accel/tcg/tcg-stats.c | 206 ++++++++++++++++++++++++++++++++++++++++++
 accel/tcg/meson.build |   1 +
 3 files changed, 207 insertions(+), 193 deletions(-)
 create mode 100644 accel/tcg/tcg-stats.c

diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index e7ed7281a4b..adb9de5a1c6 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -7,205 +7,12 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu/accel.h"
-#include "qemu/qht.h"
 #include "qapi/error.h"
 #include "qapi/type-helpers.h"
 #include "qapi/qapi-commands-machine.h"
 #include "monitor/monitor.h"
-#include "system/cpu-timers.h"
-#include "exec/icount.h"
 #include "system/tcg.h"
-#include "tcg/tcg.h"
 #include "internal-common.h"
-#include "tb-context.h"
-
-
-static void dump_drift_info(GString *buf)
-{
-    if (!icount_enabled()) {
-        return;
-    }
-
-    g_string_append_printf(buf, "Host - Guest clock  %"PRIi64" ms\n",
-                           (cpu_get_clock() - icount_get()) / SCALE_MS);
-    if (icount_align_option) {
-        g_string_append_printf(buf, "Max guest delay     %"PRIi64" ms\n",
-                               -max_delay / SCALE_MS);
-        g_string_append_printf(buf, "Max guest advance   %"PRIi64" ms\n",
-                               max_advance / SCALE_MS);
-    } else {
-        g_string_append_printf(buf, "Max guest delay     NA\n");
-        g_string_append_printf(buf, "Max guest advance   NA\n");
-    }
-}
-
-static void dump_accel_info(GString *buf)
-{
-    AccelState *accel = current_accel();
-    bool one_insn_per_tb = object_property_get_bool(OBJECT(accel),
-                                                    "one-insn-per-tb",
-                                                    &error_fatal);
-
-    g_string_append_printf(buf, "Accelerator settings:\n");
-    g_string_append_printf(buf, "one-insn-per-tb: %s\n\n",
-                           one_insn_per_tb ? "on" : "off");
-}
-
-static void print_qht_statistics(struct qht_stats hst, GString *buf)
-{
-    uint32_t hgram_opts;
-    size_t hgram_bins;
-    char *hgram;
-
-    if (!hst.head_buckets) {
-        return;
-    }
-    g_string_append_printf(buf, "TB hash buckets     %zu/%zu "
-                           "(%0.2f%% head buckets used)\n",
-                           hst.used_head_buckets, hst.head_buckets,
-                           (double)hst.used_head_buckets /
-                           hst.head_buckets * 100);
-
-    hgram_opts =  QDIST_PR_BORDER | QDIST_PR_LABELS;
-    hgram_opts |= QDIST_PR_100X   | QDIST_PR_PERCENT;
-    if (qdist_xmax(&hst.occupancy) - qdist_xmin(&hst.occupancy) == 1) {
-        hgram_opts |= QDIST_PR_NODECIMAL;
-    }
-    hgram = qdist_pr(&hst.occupancy, 10, hgram_opts);
-    g_string_append_printf(buf, "TB hash occupancy   %0.2f%% avg chain occ. "
-                           "Histogram: %s\n",
-                           qdist_avg(&hst.occupancy) * 100, hgram);
-    g_free(hgram);
-
-    hgram_opts = QDIST_PR_BORDER | QDIST_PR_LABELS;
-    hgram_bins = qdist_xmax(&hst.chain) - qdist_xmin(&hst.chain);
-    if (hgram_bins > 10) {
-        hgram_bins = 10;
-    } else {
-        hgram_bins = 0;
-        hgram_opts |= QDIST_PR_NODECIMAL | QDIST_PR_NOBINRANGE;
-    }
-    hgram = qdist_pr(&hst.chain, hgram_bins, hgram_opts);
-    g_string_append_printf(buf, "TB hash avg chain   %0.3f buckets. "
-                           "Histogram: %s\n",
-                           qdist_avg(&hst.chain), hgram);
-    g_free(hgram);
-}
-
-struct tb_tree_stats {
-    size_t nb_tbs;
-    size_t host_size;
-    size_t target_size;
-    size_t max_target_size;
-    size_t direct_jmp_count;
-    size_t direct_jmp2_count;
-    size_t cross_page;
-};
-
-static gboolean tb_tree_stats_iter(gpointer key, gpointer value, gpointer data)
-{
-    const TranslationBlock *tb = value;
-    struct tb_tree_stats *tst = data;
-
-    tst->nb_tbs++;
-    tst->host_size += tb->tc.size;
-    tst->target_size += tb->size;
-    if (tb->size > tst->max_target_size) {
-        tst->max_target_size = tb->size;
-    }
-    if (tb->page_addr[1] != -1) {
-        tst->cross_page++;
-    }
-    if (tb->jmp_reset_offset[0] != TB_JMP_OFFSET_INVALID) {
-        tst->direct_jmp_count++;
-        if (tb->jmp_reset_offset[1] != TB_JMP_OFFSET_INVALID) {
-            tst->direct_jmp2_count++;
-        }
-    }
-    return false;
-}
-
-static void tlb_flush_counts(size_t *pfull, size_t *ppart, size_t *pelide)
-{
-    CPUState *cpu;
-    size_t full = 0, part = 0, elide = 0;
-
-    CPU_FOREACH(cpu) {
-        full += qatomic_read(&cpu->neg.tlb.c.full_flush_count);
-        part += qatomic_read(&cpu->neg.tlb.c.part_flush_count);
-        elide += qatomic_read(&cpu->neg.tlb.c.elide_flush_count);
-    }
-    *pfull = full;
-    *ppart = part;
-    *pelide = elide;
-}
-
-static void tcg_dump_flush_info(GString *buf)
-{
-    size_t flush_full, flush_part, flush_elide;
-
-    g_string_append_printf(buf, "TB flush count      %u\n",
-                           qatomic_read(&tb_ctx.tb_flush_count));
-    g_string_append_printf(buf, "TB invalidate count %u\n",
-                           qatomic_read(&tb_ctx.tb_phys_invalidate_count));
-
-    tlb_flush_counts(&flush_full, &flush_part, &flush_elide);
-    g_string_append_printf(buf, "TLB full flushes    %zu\n", flush_full);
-    g_string_append_printf(buf, "TLB partial flushes %zu\n", flush_part);
-    g_string_append_printf(buf, "TLB elided flushes  %zu\n", flush_elide);
-}
-
-static void dump_exec_info(GString *buf)
-{
-    struct tb_tree_stats tst = {};
-    struct qht_stats hst;
-    size_t nb_tbs;
-
-    tcg_tb_foreach(tb_tree_stats_iter, &tst);
-    nb_tbs = tst.nb_tbs;
-    /* XXX: avoid using doubles ? */
-    g_string_append_printf(buf, "Translation buffer state:\n");
-    /*
-     * Report total code size including the padding and TB structs;
-     * otherwise users might think "-accel tcg,tb-size" is not honoured.
-     * For avg host size we use the precise numbers from tb_tree_stats though.
-     */
-    g_string_append_printf(buf, "gen code size       %zu/%zu\n",
-                           tcg_code_size(), tcg_code_capacity());
-    g_string_append_printf(buf, "TB count            %zu\n", nb_tbs);
-    g_string_append_printf(buf, "TB avg target size  %zu max=%zu bytes\n",
-                           nb_tbs ? tst.target_size / nb_tbs : 0,
-                           tst.max_target_size);
-    g_string_append_printf(buf, "TB avg host size    %zu bytes "
-                           "(expansion ratio: %0.1f)\n",
-                           nb_tbs ? tst.host_size / nb_tbs : 0,
-                           tst.target_size ?
-                           (double)tst.host_size / tst.target_size : 0);
-    g_string_append_printf(buf, "cross page TB count %zu (%zu%%)\n",
-                           tst.cross_page,
-                           nb_tbs ? (tst.cross_page * 100) / nb_tbs : 0);
-    g_string_append_printf(buf, "direct jump count   %zu (%zu%%) "
-                           "(2 jumps=%zu %zu%%)\n",
-                           tst.direct_jmp_count,
-                           nb_tbs ? (tst.direct_jmp_count * 100) / nb_tbs : 0,
-                           tst.direct_jmp2_count,
-                           nb_tbs ? (tst.direct_jmp2_count * 100) / nb_tbs : 0);
-
-    qht_statistics_init(&tb_ctx.htable, &hst);
-    print_qht_statistics(hst, buf);
-    qht_statistics_destroy(&hst);
-
-    g_string_append_printf(buf, "\nStatistics:\n");
-    tcg_dump_flush_info(buf);
-}
-
-void tcg_dump_stats(GString *buf)
-{
-    dump_accel_info(buf);
-    dump_exec_info(buf);
-    dump_drift_info(buf);
-}
 
 HumanReadableText *qmp_x_query_jit(Error **errp)
 {
diff --git a/accel/tcg/tcg-stats.c b/accel/tcg/tcg-stats.c
new file mode 100644
index 00000000000..284ac435bdb
--- /dev/null
+++ b/accel/tcg/tcg-stats.c
@@ -0,0 +1,206 @@
+/*
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ *
+ *  QEMU TCG statistics
+ *
+ *  Copyright (c) 2003-2005 Fabrice Bellard
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/accel.h"
+#include "qemu/qht.h"
+#include "qapi/error.h"
+#include "system/cpu-timers.h"
+#include "exec/icount.h"
+#include "hw/core/cpu.h"
+#include "tcg/tcg.h"
+#include "internal-common.h"
+#include "tb-context.h"
+
+static void dump_drift_info(GString *buf)
+{
+    if (!icount_enabled()) {
+        return;
+    }
+
+    g_string_append_printf(buf, "Host - Guest clock  %"PRIi64" ms\n",
+                           (cpu_get_clock() - icount_get()) / SCALE_MS);
+    if (icount_align_option) {
+        g_string_append_printf(buf, "Max guest delay     %"PRIi64" ms\n",
+                               -max_delay / SCALE_MS);
+        g_string_append_printf(buf, "Max guest advance   %"PRIi64" ms\n",
+                               max_advance / SCALE_MS);
+    } else {
+        g_string_append_printf(buf, "Max guest delay     NA\n");
+        g_string_append_printf(buf, "Max guest advance   NA\n");
+    }
+}
+
+static void dump_accel_info(GString *buf)
+{
+    AccelState *accel = current_accel();
+    bool one_insn_per_tb = object_property_get_bool(OBJECT(accel),
+                                                    "one-insn-per-tb",
+                                                    &error_fatal);
+
+    g_string_append_printf(buf, "Accelerator settings:\n");
+    g_string_append_printf(buf, "one-insn-per-tb: %s\n\n",
+                           one_insn_per_tb ? "on" : "off");
+}
+
+static void print_qht_statistics(struct qht_stats hst, GString *buf)
+{
+    uint32_t hgram_opts;
+    size_t hgram_bins;
+    char *hgram;
+
+    if (!hst.head_buckets) {
+        return;
+    }
+    g_string_append_printf(buf, "TB hash buckets     %zu/%zu "
+                           "(%0.2f%% head buckets used)\n",
+                           hst.used_head_buckets, hst.head_buckets,
+                           (double)hst.used_head_buckets /
+                           hst.head_buckets * 100);
+
+    hgram_opts =  QDIST_PR_BORDER | QDIST_PR_LABELS;
+    hgram_opts |= QDIST_PR_100X   | QDIST_PR_PERCENT;
+    if (qdist_xmax(&hst.occupancy) - qdist_xmin(&hst.occupancy) == 1) {
+        hgram_opts |= QDIST_PR_NODECIMAL;
+    }
+    hgram = qdist_pr(&hst.occupancy, 10, hgram_opts);
+    g_string_append_printf(buf, "TB hash occupancy   %0.2f%% avg chain occ. "
+                           "Histogram: %s\n",
+                           qdist_avg(&hst.occupancy) * 100, hgram);
+    g_free(hgram);
+
+    hgram_opts = QDIST_PR_BORDER | QDIST_PR_LABELS;
+    hgram_bins = qdist_xmax(&hst.chain) - qdist_xmin(&hst.chain);
+    if (hgram_bins > 10) {
+        hgram_bins = 10;
+    } else {
+        hgram_bins = 0;
+        hgram_opts |= QDIST_PR_NODECIMAL | QDIST_PR_NOBINRANGE;
+    }
+    hgram = qdist_pr(&hst.chain, hgram_bins, hgram_opts);
+    g_string_append_printf(buf, "TB hash avg chain   %0.3f buckets. "
+                           "Histogram: %s\n",
+                           qdist_avg(&hst.chain), hgram);
+    g_free(hgram);
+}
+
+struct tb_tree_stats {
+    size_t nb_tbs;
+    size_t host_size;
+    size_t target_size;
+    size_t max_target_size;
+    size_t direct_jmp_count;
+    size_t direct_jmp2_count;
+    size_t cross_page;
+};
+
+static gboolean tb_tree_stats_iter(gpointer key, gpointer value, gpointer data)
+{
+    const TranslationBlock *tb = value;
+    struct tb_tree_stats *tst = data;
+
+    tst->nb_tbs++;
+    tst->host_size += tb->tc.size;
+    tst->target_size += tb->size;
+    if (tb->size > tst->max_target_size) {
+        tst->max_target_size = tb->size;
+    }
+#ifndef CONFIG_USER_ONLY
+    if (tb->page_addr[1] != -1) {
+        tst->cross_page++;
+    }
+#endif
+    if (tb->jmp_reset_offset[0] != TB_JMP_OFFSET_INVALID) {
+        tst->direct_jmp_count++;
+        if (tb->jmp_reset_offset[1] != TB_JMP_OFFSET_INVALID) {
+            tst->direct_jmp2_count++;
+        }
+    }
+    return false;
+}
+
+static void tlb_flush_counts(size_t *pfull, size_t *ppart, size_t *pelide)
+{
+    CPUState *cpu;
+    size_t full = 0, part = 0, elide = 0;
+
+    CPU_FOREACH(cpu) {
+        full += qatomic_read(&cpu->neg.tlb.c.full_flush_count);
+        part += qatomic_read(&cpu->neg.tlb.c.part_flush_count);
+        elide += qatomic_read(&cpu->neg.tlb.c.elide_flush_count);
+    }
+    *pfull = full;
+    *ppart = part;
+    *pelide = elide;
+}
+
+static void tcg_dump_flush_info(GString *buf)
+{
+    size_t flush_full, flush_part, flush_elide;
+
+    g_string_append_printf(buf, "TB flush count      %u\n",
+                           qatomic_read(&tb_ctx.tb_flush_count));
+    g_string_append_printf(buf, "TB invalidate count %u\n",
+                           qatomic_read(&tb_ctx.tb_phys_invalidate_count));
+
+    tlb_flush_counts(&flush_full, &flush_part, &flush_elide);
+    g_string_append_printf(buf, "TLB full flushes    %zu\n", flush_full);
+    g_string_append_printf(buf, "TLB partial flushes %zu\n", flush_part);
+    g_string_append_printf(buf, "TLB elided flushes  %zu\n", flush_elide);
+}
+
+static void dump_exec_info(GString *buf)
+{
+    struct tb_tree_stats tst = {};
+    struct qht_stats hst;
+    size_t nb_tbs;
+
+    tcg_tb_foreach(tb_tree_stats_iter, &tst);
+    nb_tbs = tst.nb_tbs;
+    /* XXX: avoid using doubles ? */
+    g_string_append_printf(buf, "Translation buffer state:\n");
+    /*
+     * Report total code size including the padding and TB structs;
+     * otherwise users might think "-accel tcg,tb-size" is not honoured.
+     * For avg host size we use the precise numbers from tb_tree_stats though.
+     */
+    g_string_append_printf(buf, "gen code size       %zu/%zu\n",
+                           tcg_code_size(), tcg_code_capacity());
+    g_string_append_printf(buf, "TB count            %zu\n", nb_tbs);
+    g_string_append_printf(buf, "TB avg target size  %zu max=%zu bytes\n",
+                           nb_tbs ? tst.target_size / nb_tbs : 0,
+                           tst.max_target_size);
+    g_string_append_printf(buf, "TB avg host size    %zu bytes "
+                           "(expansion ratio: %0.1f)\n",
+                           nb_tbs ? tst.host_size / nb_tbs : 0,
+                           tst.target_size ?
+                           (double)tst.host_size / tst.target_size : 0);
+    g_string_append_printf(buf, "cross page TB count %zu (%zu%%)\n",
+                           tst.cross_page,
+                           nb_tbs ? (tst.cross_page * 100) / nb_tbs : 0);
+    g_string_append_printf(buf, "direct jump count   %zu (%zu%%) "
+                           "(2 jumps=%zu %zu%%)\n",
+                           tst.direct_jmp_count,
+                           nb_tbs ? (tst.direct_jmp_count * 100) / nb_tbs : 0,
+                           tst.direct_jmp2_count,
+                           nb_tbs ? (tst.direct_jmp2_count * 100) / nb_tbs : 0);
+
+    qht_statistics_init(&tb_ctx.htable, &hst);
+    print_qht_statistics(hst, buf);
+    qht_statistics_destroy(&hst);
+
+    g_string_append_printf(buf, "\nStatistics:\n");
+    tcg_dump_flush_info(buf);
+}
+
+void tcg_dump_stats(GString *buf)
+{
+    dump_accel_info(buf);
+    dump_exec_info(buf);
+    dump_drift_info(buf);
+}
diff --git a/accel/tcg/meson.build b/accel/tcg/meson.build
index 575e92bb9e8..002aa8f4588 100644
--- a/accel/tcg/meson.build
+++ b/accel/tcg/meson.build
@@ -11,6 +11,7 @@ tcg_ss.add(files(
   'tcg-runtime-gvec.c',
   'tb-maint.c',
   'tcg-all.c',
+  'tcg-stats.c',
   'translate-all.c',
   'translator.c',
 ))
-- 
2.49.0


