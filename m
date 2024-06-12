Return-Path: <kvm+bounces-19475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C93905704
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 636C61C20DC2
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AFD9181B85;
	Wed, 12 Jun 2024 15:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xv0+eCSD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58302181314
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206518; cv=none; b=jKJvwhe8fRgPP07YE7t9KYi8me85FKrPQcnLaKXMZzu63x0kUGsbIIhp06zfpWRYynArZTgRH0jJIFT7+3sp7t2MINQAvl9fFDsLsU2wtHRr0F96ECVscUu6jnrXMFYXrpDAW12dy3BBKhCI50fOB9RrHH8q29UKDbTgBe20LMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206518; c=relaxed/simple;
	bh=v6jTYS7suBdtKFPEcX7pwBI66grzMGWJFDb1+VH63jg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDkCq4m3U7/P5nWx6p/qqKmJTg0LKQ24pzV6RcPNVeI2k99+V4boJcWbczQiDrEw8iGd4e/E+r9TnYrrPKvQWB7UN9+9DcxrilkgHukN93sAZL+ytl6+8OPFw0VzbghXNeyeXXtMVTxTzyAp+/CV3jz7wGXrvF2y8mlz7rUOrIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xv0+eCSD; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6ef8bf500dso2915966b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718206514; x=1718811314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGoQj4qpl5RhrrC1ARvmO5/75amh4ElfKsyRGTMZr6o=;
        b=xv0+eCSDr7fjDdq+tStm9SVdfMCqVkFKbQyC0fk1oEC7gkYvabxhQtwl1jt94hI2eY
         HJOEGGGxEkS3wmpymDqA/81nVZqdQtGDPqN/XDIAyZbUTW1HXNNfDhLesJ9dPhV6POea
         dULPZ67cmR3yyncJvgjKq5g4Hc1gUNnr3e9DE/B/+SY9ppEIzUoQCOmdZjF4CeJrjam7
         RMyaoQ/ea3H0SAqBXbyXkGBjtZ1AY+nqsbs9ZzrB4jz2p1d0+mvfYHEMyejpUD1NtFS9
         aCzcDgNfT3G3jNB5IpfuaRlAc0w1kq4T9zPQ2bNzWrZ7AlDNsC9e7CXeZ+MsFl5GcTaC
         SJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206514; x=1718811314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGoQj4qpl5RhrrC1ARvmO5/75amh4ElfKsyRGTMZr6o=;
        b=MIP9Pkk2cEooV3sXZZFvUZbcDRXgfrH03mqpk7Hw+NwlIeHQAF68acqoSBFEvRIHeR
         PT7rtS550PQaSSfo0l95zvH5orB7yfwNV0XyBV5oSQHALcQot/fA6XrZpHrzYQ1d3+pb
         e/lqWUypjGAeaynYP7Hvs5z1AWAyWBIzHElUvY8NpPP6oY/xMEktK3HogiEcOphKUtYY
         jidFd/BIg+mxCDkZUK6Hf2UNrZCEQilsVBXcS42tydF2ZWOh8G5ejTzUT4cEXPVb1A8/
         tXE0Upn4xLRSnuS9Gj3WX/t3j0+C56VGRogF3MwWmVFkrUzAJzjVrSNPWlH5VjSbYLBQ
         fUoQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7IxJrMZCp7sWAu+CDuYeFAPqd71zBM1s2NqKdwJcmugea9cSCpf1V0IFqaRWmD4HtdHmQTbqHBXQK8EwzG6RX0Q5m
X-Gm-Message-State: AOJu0YwI7ypMVg4YnHHBkuMCjJDkzHqIIMtCYRoSmKR5fAFai4larGx+
	dd0xWROaJJzLXEcO9bKlKFyHwoablhAd7yhq+BIwSDi6khj7mIuYlDvUmm+Ktk0=
X-Google-Smtp-Source: AGHT+IG76EZWKhE5JO485CIAo85rC8bVxkvHDRmTHqUcDo+WGQuLSBgGHbJmn17mBFIkxNNff3ckGA==
X-Received: by 2002:a17:906:7311:b0:a6f:4b46:dbb4 with SMTP id a640c23a62f3a-a6f4b46dd46mr128087966b.62.1718206514616;
        Wed, 12 Jun 2024 08:35:14 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6ef669bea6sm676540366b.153.2024.06.12.08.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:35:11 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 059CA5FA1C;
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
Subject: [PATCH 8/9] plugins: add time control API
Date: Wed, 12 Jun 2024 16:35:07 +0100
Message-Id: <20240612153508.1532940-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240612153508.1532940-1-alex.bennee@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Expose the ability to control time through the plugin API. Only one
plugin can control time so it has to request control when loaded.
There are probably more corner cases to catch here.

From: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
[AJB: tweaked user-mode handling]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20240530220610.1245424-6-pierrick.bouvier@linaro.org>

---
plugins/next
  - make qemu_plugin_update_ns a NOP in user-mode
---
 include/qemu/qemu-plugin.h   | 25 +++++++++++++++++++++++++
 plugins/api.c                | 35 +++++++++++++++++++++++++++++++++++
 plugins/qemu-plugins.symbols |  2 ++
 3 files changed, 62 insertions(+)

diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
index 95703d8fec..db4d67529e 100644
--- a/include/qemu/qemu-plugin.h
+++ b/include/qemu/qemu-plugin.h
@@ -661,6 +661,31 @@ void qemu_plugin_register_vcpu_mem_inline_per_vcpu(
     qemu_plugin_u64 entry,
     uint64_t imm);
 
+/**
+ * qemu_plugin_request_time_control() - request the ability to control time
+ *
+ * This grants the plugin the ability to control system time. Only one
+ * plugin can control time so if multiple plugins request the ability
+ * all but the first will fail.
+ *
+ * Returns an opaque handle or NULL if fails
+ */
+const void *qemu_plugin_request_time_control(void);
+
+/**
+ * qemu_plugin_update_ns() - update system emulation time
+ * @handle: opaque handle returned by qemu_plugin_request_time_control()
+ * @time: time in nanoseconds
+ *
+ * This allows an appropriately authorised plugin (i.e. holding the
+ * time control handle) to move system time forward to @time. For
+ * user-mode emulation the time is not changed by this as all reported
+ * time comes from the host kernel.
+ *
+ * Start time is 0.
+ */
+void qemu_plugin_update_ns(const void *handle, int64_t time);
+
 typedef void
 (*qemu_plugin_vcpu_syscall_cb_t)(qemu_plugin_id_t id, unsigned int vcpu_index,
                                  int64_t num, uint64_t a1, uint64_t a2,
diff --git a/plugins/api.c b/plugins/api.c
index 6bdb26bbe3..4431a0ea7e 100644
--- a/plugins/api.c
+++ b/plugins/api.c
@@ -39,6 +39,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/plugin.h"
 #include "qemu/log.h"
+#include "qemu/timer.h"
 #include "tcg/tcg.h"
 #include "exec/exec-all.h"
 #include "exec/gdbstub.h"
@@ -583,3 +584,37 @@ uint64_t qemu_plugin_u64_sum(qemu_plugin_u64 entry)
     }
     return total;
 }
+
+/*
+ * Time control
+ */
+static bool has_control;
+
+const void *qemu_plugin_request_time_control(void)
+{
+    if (!has_control) {
+        has_control = true;
+        return &has_control;
+    }
+    return NULL;
+}
+
+#ifdef CONFIG_SOFTMMU
+static void advance_virtual_time__async(CPUState *cpu, run_on_cpu_data data)
+{
+    int64_t new_time = data.host_ulong;
+    qemu_clock_advance_virtual_time(new_time);
+}
+#endif
+
+void qemu_plugin_update_ns(const void *handle, int64_t new_time)
+{
+#ifdef CONFIG_SOFTMMU
+    if (handle == &has_control) {
+        /* Need to execute out of cpu_exec, so bql can be locked. */
+        async_run_on_cpu(current_cpu,
+                         advance_virtual_time__async,
+                         RUN_ON_CPU_HOST_ULONG(new_time));
+    }
+#endif
+}
diff --git a/plugins/qemu-plugins.symbols b/plugins/qemu-plugins.symbols
index aa0a77a319..ca773d8d9f 100644
--- a/plugins/qemu-plugins.symbols
+++ b/plugins/qemu-plugins.symbols
@@ -38,6 +38,7 @@
   qemu_plugin_register_vcpu_tb_exec_cond_cb;
   qemu_plugin_register_vcpu_tb_exec_inline_per_vcpu;
   qemu_plugin_register_vcpu_tb_trans_cb;
+  qemu_plugin_request_time_control;
   qemu_plugin_reset;
   qemu_plugin_scoreboard_free;
   qemu_plugin_scoreboard_find;
@@ -51,5 +52,6 @@
   qemu_plugin_u64_set;
   qemu_plugin_u64_sum;
   qemu_plugin_uninstall;
+  qemu_plugin_update_ns;
   qemu_plugin_vcpu_for_each;
 };
-- 
2.39.2


