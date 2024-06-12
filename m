Return-Path: <kvm+bounces-19476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F4C905705
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 597451C21AC8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0401C181B92;
	Wed, 12 Jun 2024 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CwMUsQ81"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472B5181325
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206519; cv=none; b=DlpJIUsmS1MxrvG/L++IhGFbBhR7EXreLtsqNkCZxjkty0XhqUpxEywp19syoZEMlNELqhnSxNwKmQusxjd/6znlT1McLnhqA++JynGtcktCqBeeS3gvW33SGhOZv7PSMjd7hThP38/WIpvpWQoUp/pv1SdC+7nS3DDdywtcF6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206519; c=relaxed/simple;
	bh=dAq+XGoEWIdnTHhnse9t/vW94PT5uWWsO13g7DXWTdU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QSaQq2BOkxZ0eBp745xXYswOUefsnOVwaM+vT59thFN3qz9fxfZ6glnt+Ixlt2sYIZxco99XBXnwrtHI9A9v9kjAg60iURc0EHZNEk7ogzww/NHCgisxS8Sdx7DZmsUTgoqC6mMucLdmlggzgGANCRoMgtA28uWnjifs1cWLU2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CwMUsQ81; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57a4d7ba501so9302732a12.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718206515; x=1718811315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1uUeWcMjIB2TOUOcX1m/U9+CVF8niC1GNFEpyvssPNQ=;
        b=CwMUsQ81Sl2rb9sCJ/7LC7IzE0jCJGurgByvoW7RMybfHTZRtlPPofElD4TzSJ/PQY
         4GsXxKjG5ltm630jEgtglfblwwZDkZSAlf95sIlxlNKuYJuggnxWgOuM/z1yypVu31S1
         KSA0uCgx8yYINX2U2oJTXFBR/mkIDYaVnWgEvEiveCtdQN1YLlF1PgQlDsk9BUKl7tHY
         hOx4VYagH2tz+dnmfnt3Ps1FK+NdbphzCEPP/xAGG2cSIi7l+BsuOSb2SOHChQiONTtW
         3GPa9jy9MLsYTpsSLBOlwaf0lltuZicxkKbtxmThE34yvRnOL+Zn+E53jnk40a0j+AYr
         +jBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206515; x=1718811315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1uUeWcMjIB2TOUOcX1m/U9+CVF8niC1GNFEpyvssPNQ=;
        b=jbFWh3CyKX4mXf94gHSx1/SD8y6bnTWiWxXVz3n5TbeynifgiGVW20blNuMt9A745L
         tAyQxdqnsLPSYDj0Daupa6lb0bHsMG8RomA0Kj/4PC0DAOGJS7i0+FJTS+txk/Q/rgsu
         Yo82vTSyfqnuzhQi7fCvfc4nUYocMGHriL7WFaGIi4sGDTiHL8SKcI2i5Z104mY5TGxb
         nwNpr+e8zYRAFXTYAeT5WTtRQzfZ2lPqLN4NbSV7/41W2YCZwhdNtgbZCMIeybdXwcsb
         WyCUy29ceLRueIPj27/JcBBZzst08dIHUFyFRyIGPDBmm+mxyIZpIpuZbWVP9P60kAR5
         2N7A==
X-Forwarded-Encrypted: i=1; AJvYcCWsnW9dTgUV3uf6zfOiEVskCcQO+fMzs7mYrD/K0INeq1Be+xrBFcKO/BkUIVTBekudnA0BIiu7O6h6Rp/wX0/pxUlJ
X-Gm-Message-State: AOJu0Yx8eZQTUhvE36q9ckrYxevxro6WzGDqUaeWIgaFPCPLe9KUKYls
	nV8QQXYGzb7wdQGrQa16smOG9M4reBayY0HIP9SA8fQckeF3wnjhpSXC7ZfcHTU=
X-Google-Smtp-Source: AGHT+IHCKOhkKIwUqM/1JrODiuK3xcF5lUTmN2FQB+h+HF6PKdLXYsyPDFJZr5Tf8JQXEgGtsWhV2w==
X-Received: by 2002:a17:906:bfc9:b0:a68:a843:9014 with SMTP id a640c23a62f3a-a6f47f88b59mr143131866b.18.1718206515475;
        Wed, 12 Jun 2024 08:35:15 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f1c49e682sm434788566b.205.2024.06.12.08.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:35:11 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1FC305F893;
	Wed, 12 Jun 2024 16:35:09 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	qemu-s390x@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	Alexander Graf <agraf@csgraf.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	qemu-ppc@nongnu.org,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 9/9] contrib/plugins: add ips plugin example for cost modeling
Date: Wed, 12 Jun 2024 16:35:08 +0100
Message-Id: <20240612153508.1532940-10-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240612153508.1532940-1-alex.bennee@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

This plugin uses the new time control interface to make decisions
about the state of time during the emulation. The algorithm is
currently very simple. The user specifies an ips rate which applies
per core. If the core runs ahead of its allocated execution time the
plugin sleeps for a bit to let real time catch up. Either way time is
updated for the emulation as a function of total executed instructions
with some adjustments for cores that idle.

Examples
--------

Slow down execution of /bin/true:
$ num_insn=$(./build/qemu-x86_64 -plugin ./build/tests/plugin/libinsn.so -d plugin /bin/true |& grep total | sed -e 's/.*: //')
$ time ./build/qemu-x86_64 -plugin ./build/contrib/plugins/libips.so,ips=$(($num_insn/4)) /bin/true
real 4.000s

Boot a Linux kernel simulating a 250MHz cpu:
$ /build/qemu-system-x86_64 -kernel /boot/vmlinuz-6.1.0-21-amd64 -append "console=ttyS0" -plugin ./build/contrib/plugins/libips.so,ips=$((250*1000*1000)) -smp 1 -m 512
check time until kernel panic on serial0

Tested in system mode by booting a full debian system, and using:
$ sysbench cpu run
Performance decrease linearly with the given number of ips.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20240530220610.1245424-7-pierrick.bouvier@linaro.org>
---
 contrib/plugins/ips.c    | 164 +++++++++++++++++++++++++++++++++++++++
 contrib/plugins/Makefile |   1 +
 2 files changed, 165 insertions(+)
 create mode 100644 contrib/plugins/ips.c

diff --git a/contrib/plugins/ips.c b/contrib/plugins/ips.c
new file mode 100644
index 0000000000..db77729264
--- /dev/null
+++ b/contrib/plugins/ips.c
@@ -0,0 +1,164 @@
+/*
+ * ips rate limiting plugin.
+ *
+ * This plugin can be used to restrict the execution of a system to a
+ * particular number of Instructions Per Second (ips). This controls
+ * time as seen by the guest so while wall-clock time may be longer
+ * from the guests point of view time will pass at the normal rate.
+ *
+ * This uses the new plugin API which allows the plugin to control
+ * system time.
+ *
+ * Copyright (c) 2023 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include <stdio.h>
+#include <glib.h>
+#include <qemu-plugin.h>
+
+QEMU_PLUGIN_EXPORT int qemu_plugin_version = QEMU_PLUGIN_VERSION;
+
+/* how many times do we update time per sec */
+#define NUM_TIME_UPDATE_PER_SEC 10
+#define NSEC_IN_ONE_SEC (1000 * 1000 * 1000)
+
+static GMutex global_state_lock;
+
+static uint64_t max_insn_per_second = 1000 * 1000 * 1000; /* ips per core, per second */
+static uint64_t max_insn_per_quantum; /* trap every N instructions */
+static int64_t virtual_time_ns; /* last set virtual time */
+
+static const void *time_handle;
+
+typedef struct {
+    uint64_t total_insn;
+    uint64_t quantum_insn; /* insn in last quantum */
+    int64_t last_quantum_time; /* time when last quantum started */
+} vCPUTime;
+
+struct qemu_plugin_scoreboard *vcpus;
+
+/* return epoch time in ns */
+static int64_t now_ns(void)
+{
+    return g_get_real_time() * 1000;
+}
+
+static uint64_t num_insn_during(int64_t elapsed_ns)
+{
+    double num_secs = elapsed_ns / (double) NSEC_IN_ONE_SEC;
+    return num_secs * (double) max_insn_per_second;
+}
+
+static int64_t time_for_insn(uint64_t num_insn)
+{
+    double num_secs = (double) num_insn / (double) max_insn_per_second;
+    return num_secs * (double) NSEC_IN_ONE_SEC;
+}
+
+static void update_system_time(vCPUTime *vcpu)
+{
+    int64_t elapsed_ns = now_ns() - vcpu->last_quantum_time;
+    uint64_t max_insn = num_insn_during(elapsed_ns);
+
+    if (vcpu->quantum_insn >= max_insn) {
+        /* this vcpu ran faster than expected, so it has to sleep */
+        uint64_t insn_advance = vcpu->quantum_insn - max_insn;
+        uint64_t time_advance_ns = time_for_insn(insn_advance);
+        int64_t sleep_us = time_advance_ns / 1000;
+        g_usleep(sleep_us);
+    }
+
+    vcpu->total_insn += vcpu->quantum_insn;
+    vcpu->quantum_insn = 0;
+    vcpu->last_quantum_time = now_ns();
+
+    /* based on total number of instructions, what should be the new time? */
+    int64_t new_virtual_time = time_for_insn(vcpu->total_insn);
+
+    g_mutex_lock(&global_state_lock);
+
+    /* Time only moves forward. Another vcpu might have updated it already. */
+    if (new_virtual_time > virtual_time_ns) {
+        qemu_plugin_update_ns(time_handle, new_virtual_time);
+        virtual_time_ns = new_virtual_time;
+    }
+
+    g_mutex_unlock(&global_state_lock);
+}
+
+static void vcpu_init(qemu_plugin_id_t id, unsigned int cpu_index)
+{
+    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
+    vcpu->total_insn = 0;
+    vcpu->quantum_insn = 0;
+    vcpu->last_quantum_time = now_ns();
+}
+
+static void vcpu_exit(qemu_plugin_id_t id, unsigned int cpu_index)
+{
+    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
+    update_system_time(vcpu);
+}
+
+static void every_quantum_insn(unsigned int cpu_index, void *udata)
+{
+    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
+    g_assert(vcpu->quantum_insn >= max_insn_per_quantum);
+    update_system_time(vcpu);
+}
+
+static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
+{
+    size_t n_insns = qemu_plugin_tb_n_insns(tb);
+    qemu_plugin_u64 quantum_insn =
+        qemu_plugin_scoreboard_u64_in_struct(vcpus, vCPUTime, quantum_insn);
+    /* count (and eventually trap) once per tb */
+    qemu_plugin_register_vcpu_tb_exec_inline_per_vcpu(
+        tb, QEMU_PLUGIN_INLINE_ADD_U64, quantum_insn, n_insns);
+    qemu_plugin_register_vcpu_tb_exec_cond_cb(
+        tb, every_quantum_insn,
+        QEMU_PLUGIN_CB_NO_REGS, QEMU_PLUGIN_COND_GE,
+        quantum_insn, max_insn_per_quantum, NULL);
+}
+
+static void plugin_exit(qemu_plugin_id_t id, void *udata)
+{
+    qemu_plugin_scoreboard_free(vcpus);
+}
+
+QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
+                                           const qemu_info_t *info, int argc,
+                                           char **argv)
+{
+    for (int i = 0; i < argc; i++) {
+        char *opt = argv[i];
+        g_auto(GStrv) tokens = g_strsplit(opt, "=", 2);
+        if (g_strcmp0(tokens[0], "ips") == 0) {
+            max_insn_per_second = g_ascii_strtoull(tokens[1], NULL, 10);
+            if (!max_insn_per_second && errno) {
+                fprintf(stderr, "%s: couldn't parse %s (%s)\n",
+                        __func__, tokens[1], g_strerror(errno));
+                return -1;
+            }
+        } else {
+            fprintf(stderr, "option parsing failed: %s\n", opt);
+            return -1;
+        }
+    }
+
+    vcpus = qemu_plugin_scoreboard_new(sizeof(vCPUTime));
+    max_insn_per_quantum = max_insn_per_second / NUM_TIME_UPDATE_PER_SEC;
+
+    time_handle = qemu_plugin_request_time_control();
+    g_assert(time_handle);
+
+    qemu_plugin_register_vcpu_tb_trans_cb(id, vcpu_tb_trans);
+    qemu_plugin_register_vcpu_init_cb(id, vcpu_init);
+    qemu_plugin_register_vcpu_exit_cb(id, vcpu_exit);
+    qemu_plugin_register_atexit_cb(id, plugin_exit, NULL);
+
+    return 0;
+}
diff --git a/contrib/plugins/Makefile b/contrib/plugins/Makefile
index 0b64d2c1e3..449ead1130 100644
--- a/contrib/plugins/Makefile
+++ b/contrib/plugins/Makefile
@@ -27,6 +27,7 @@ endif
 NAMES += hwprofile
 NAMES += cache
 NAMES += drcov
+NAMES += ips
 
 ifeq ($(CONFIG_WIN32),y)
 SO_SUFFIX := .dll
-- 
2.39.2


