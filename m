Return-Path: <kvm+bounces-20106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A199109B1
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 667431F22CBC
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBECD1B1431;
	Thu, 20 Jun 2024 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hDC5VVkb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265281B141B
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896961; cv=none; b=dLlslYMTy2r8q0JyObURWnDWaHhV64BLLdWOfHORNixi/bu4Izfs0phQgulDO6oWIx85orHnknidJ3c99pKyj5xDmyH1XtiHoYO6RsRYxE7fIXOom5PfBpp2u0ZsbpOg1Vt9iwEyp+t4zXCc7BYpw5RAj72wJr9L+pYC3GlwV6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896961; c=relaxed/simple;
	bh=bnbZUiGWMO3J8cFkRW4SklmEhRjzMiu8ev+b7OOO7DY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8F3Pfm5koGzG2OtCa/BIDTj6/jM1WsqzPOVkB+382S9/jO+SIK9h103jVVmRBdrfEqLy0Dd7iAnloXqV/SySDutkx1SZqi64bVebQFfiEYcS9l++Gx6D44yc2AKm7KDaBbb6KtGfHLgRd/KGx0wBzRP96H4bVk7o3lLP6jyvSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hDC5VVkb; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52c9034860dso1263990e87.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896957; x=1719501757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTqVMPQXWo8mkGU1ZZQCTroEdUrbxvLcJ6ei12/57OI=;
        b=hDC5VVkbmeZ9FnuZp8cvuq8yMLPZ36rpKTzhzoUg6mZ3He4d+7+tQRPPobAr2+uuuy
         pT29PqWuzNOWtJAWhfAx15+7Ai0QVL3Sy6hc2OqNqiueil1zvTJx6CMxj504TPl8kjp9
         hbDSyJsWVFXJmOrCCsx1oQF4hvb3cZ+ClcC7oSqSy4nMkvcay/iSNReYUlrtUhTSJMiD
         NH8sKJvv7a6FoPJ++yc3PXa0nLf/bR+3G6I5VotAPkwSHw37+uUCJWHGlNzjwv3WDa37
         0zs2Wop4izIWaeJvyFjKf6cy9VNM8Ndm4FnOVKx9fURdZocUEbdCbC1D9NdOUSM42mpE
         qggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896957; x=1719501757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTqVMPQXWo8mkGU1ZZQCTroEdUrbxvLcJ6ei12/57OI=;
        b=IMYrrMwLakwTMOjWRbD3W9Cak+OD6U/id05ocJX0KmfJqG0DvZEZQ70S6i1VWmdneU
         PY0BZN53mCXl/4MlQLGhQVXHYedeF50knkhTU2CYX4EhQzRKaypKKfxll5Pr3mOdlF/0
         9BAdfJr6AEYF6MZ+adJJtspcwX6YSdJ/BmTIOAM8QPiKxeCAPtMTaU2tu/DQ2IK/jLPS
         ZwA5Y8vm76Hl8WjR3tiVzaL6QIKPJKfsRj4pt4vR2Xf2G5X1zsdL9j5wjVREkpMFX2H6
         nK65xKNtruZPMxZeS6QoPAplqJ6v1DsyQi639v/4P2QCqP7mBFI9RJQUgK8RWSGp2ysy
         o1ig==
X-Forwarded-Encrypted: i=1; AJvYcCWuma226MZDXzxNhMz+Ggd42c/5F279nTTC5uc9sTdOcanM+nZwTwsyo8cz9OhTWZiziaytrNy2u7XwMVM8okqh2zYm
X-Gm-Message-State: AOJu0YxX7L7N3eeKEypxCdQeCLNDfeaS5EsvSzEMJ12ofGv9/gpottAo
	CXEzUxGBqL/TMxrUDCuhrkwOxnY8RkWYugB7xYJjQd/Y6z0ZDNwsQZ/fJatTGag=
X-Google-Smtp-Source: AGHT+IF6+wEHSuI7S/SNc8KgBe4bVoRR9T1WyMx8dtnAy/pGDd8PXI3gNYJwem0B1HteMfPE9Z02lA==
X-Received: by 2002:a05:6512:3994:b0:52c:cb8d:637d with SMTP id 2adb3069b0e04-52ccb8d6426mr5442380e87.5.1718896957381;
        Thu, 20 Jun 2024 08:22:37 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f756ee325sm552818766b.90.2024.06.20.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:34 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 0C60D5FA0A;
	Thu, 20 Jun 2024 16:22:22 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 10/12] contrib/plugins: add Instructions Per Second (IPS) example for cost modeling
Date: Thu, 20 Jun 2024 16:22:18 +0100
Message-Id: <20240620152220.2192768-11-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20240530220610.1245424-7-pierrick.bouvier@linaro.org>

---
v2
  - more explicit Instructions Per Second (IPS)!
---
 contrib/plugins/ips.c    | 164 +++++++++++++++++++++++++++++++++++++++
 contrib/plugins/Makefile |   1 +
 2 files changed, 165 insertions(+)
 create mode 100644 contrib/plugins/ips.c

diff --git a/contrib/plugins/ips.c b/contrib/plugins/ips.c
new file mode 100644
index 0000000000..29fa556d0f
--- /dev/null
+++ b/contrib/plugins/ips.c
@@ -0,0 +1,164 @@
+/*
+ * Instructions Per Second (IPS) rate limiting plugin.
+ *
+ * This plugin can be used to restrict the execution of a system to a
+ * particular number of Instructions Per Second (IPS). This controls
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


