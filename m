Return-Path: <kvm+bounces-18434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 161A48D5277
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9EA22872DF
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 19:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C356E158A30;
	Thu, 30 May 2024 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LRcbljoJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20668158879
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 19:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098177; cv=none; b=Cok84fgntXHFUgLOZIT/t0vV0Zbek1QRFB1V9dMOe8qRM7D3WsSWob65p5GstySHHHDWlPUUFj4P6/GeWebcHum4q3aHCguiudh0WlLA31q3l59fy5NZLTHhWMQDQaNmPL0d3cWa9IfrJDvZmZMUXn4o7Sy4YBqxMBxSjaGO9Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098177; c=relaxed/simple;
	bh=eeFGxNeoZqvUNfJR35inCr7b5ssaRHsTERxVShcPYhQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTpvdJgkmFkVyWqUZ29McTTbyGFsKwsr14UEPERgd+CNxqhHb1lI+9PSOmZ2fb4ZnZbUcWavSJxNaehff45dmjlLHON7eKC0ZUodp5yIc56Q+TfoIM0m5XXGJuQoR0ssHTFjwWbVx3GUW+eYnfu4nLAHQcO62lLfkz4kFuq5sgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LRcbljoJ; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a5dcb5a0db4so133123066b.2
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 12:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717098173; x=1717702973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cnc+k2fYpUESVUzqiNhwI1EEtv65T/mceqpj8jrBceI=;
        b=LRcbljoJQJr1LV7B/H6P4GyitwQ5Q+hK6l8BJX2ZcJziTs20HmqghB8xJGdtVQAgph
         gthBZHAbCdRQLBDAV3vtIfpjQMHKELsa6X4ZZM4kNBampZRstn32LDbj37MHkfhd2vGU
         EuYSyEosqJV0Fbgkuh6LtPXPCESCMe0Sa+qlTDUORhG/mSmpill9BUk3RUOglOiNMLid
         SWSS/kEoJGWgY+ydEksHryCzzqzvkbSavPpHgn76cVBYddh6RlOvhlwR8hhV8TgcU87O
         AfFaFzZNENapAIglbBthduykYBCwo0NU2Zw2z7kRQyDBC0eOyYsKsWOz8OGZ50TNOoMp
         Ut7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717098173; x=1717702973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cnc+k2fYpUESVUzqiNhwI1EEtv65T/mceqpj8jrBceI=;
        b=uUJo5bjze0Z3ZYclJlUO01YHZ+NeBeLqfk8XRKVrIrs6f+NHk8zRcPcwP3WfcKiy9h
         CKJTZixxxLH+GF4yHHZ0n6JZJDwh9AJPGqHinBMJclLG2eDkxk+Wc4Jwt4S25+9UF19C
         i/pdnNHGSFa0zPcDr559IJcZvmeNxe5nPcOC1e5ngKf+hsF9VZkHmnqloJbxsoLiBLap
         Mvz9+iqXWVne3NBlwBceWbXEZMHT6I/vn4isaF21ZJ7/jdgM6srP3mK5vxJLyyNvqURu
         K24QJGP6Yy14SBWH+nIEzENxuMyLsRVDgF+N3zEBLN0cg/+wK4wEemNUBoDVnWTmwAeC
         5XCg==
X-Forwarded-Encrypted: i=1; AJvYcCWvsfwXSaEjpJds3TUn0WWRSo5ZzqoVO3mu1dvYOFD4c3Z+pe81Pi89F/6pt1jXmJZjtABvSsZ7lFUJCksVaYJHRG6p
X-Gm-Message-State: AOJu0Ywn2NoMXPWUxpWIy1n1+ZD4Ys2+yH0fh9sljKVJGXGuxD/WCPoi
	1yivIleiMczQ/gG+eOHsEFW7oT24U9Rpbv3QaHk2xjdnCQq+ZrYR6B8cNEWivxY=
X-Google-Smtp-Source: AGHT+IFVOq8MKMEfrXxp4J5Y6CJd2GA9ZM++5hdN2jPC99fsqqvcLrmD9aX73RbTWxQdJn18BZeDlg==
X-Received: by 2002:a17:906:d1c9:b0:a67:aa2b:1032 with SMTP id a640c23a62f3a-a67aa2b10f1mr32855366b.28.1717098173261;
        Thu, 30 May 2024 12:42:53 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a67ea67b4f8sm7831766b.102.2024.05.30.12.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C35165F8E3;
	Thu, 30 May 2024 20:42:50 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH 2/5] cpu: move Qemu[Thread|Cond] setup into common code
Date: Thu, 30 May 2024 20:42:47 +0100
Message-Id: <20240530194250.1801701-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240530194250.1801701-1-alex.bennee@linaro.org>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Aside from the round robin threads this is all common code. By
moving the halt_cond setup we also no longer need hacks to work around
the race between QOM object creation and thread creation.

It is a little ugly to free stuff up for the round robin thread but
better it deal with its own specialises than making the other
accelerators jump through hoops.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/core/cpu.h             |  4 ++++
 accel/dummy-cpus.c                |  3 ---
 accel/hvf/hvf-accel-ops.c         |  4 ----
 accel/kvm/kvm-accel-ops.c         |  3 ---
 accel/tcg/tcg-accel-ops-mttcg.c   |  4 ----
 accel/tcg/tcg-accel-ops-rr.c      | 14 +++++++-------
 hw/core/cpu-common.c              |  5 +++++
 target/i386/nvmm/nvmm-accel-ops.c |  3 ---
 target/i386/whpx/whpx-accel-ops.c |  3 ---
 9 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 35d345371b..a405119eda 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -404,10 +404,14 @@ struct qemu_work_item;
  * @tcg_cflags: Pre-computed cflags for this cpu.
  * @nr_cores: Number of cores within this CPU package.
  * @nr_threads: Number of threads within this CPU core.
+ * @thread: Host thread details, only live once @created is #true
+ * @sem: WIN32 only semaphore used only for qtest
+ * @thread_id: native thread id of vCPU, only live once @created is #true
  * @running: #true if CPU is currently running (lockless).
  * @has_waiter: #true if a CPU is currently waiting for the cpu_exec_end;
  * valid under cpu_list_lock.
  * @created: Indicates whether the CPU thread has been successfully created.
+ * @halt_cond: condition variable sleeping threads can wait on.
  * @interrupt_request: Indicates a pending interrupt request.
  * @halted: Nonzero if the CPU is in suspended state.
  * @stop: Indicates a pending stop request.
diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
index 20519f1ea4..f32d8c8dc3 100644
--- a/accel/dummy-cpus.c
+++ b/accel/dummy-cpus.c
@@ -68,9 +68,6 @@ void dummy_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    cpu->thread = g_malloc0(sizeof(QemuThread));
-    cpu->halt_cond = g_malloc0(sizeof(QemuCond));
-    qemu_cond_init(cpu->halt_cond);
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/DUMMY",
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, dummy_cpu_thread_fn, cpu,
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 40d4187d9d..6f1e27ef46 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -463,10 +463,6 @@ static void hvf_start_vcpu_thread(CPUState *cpu)
      */
     assert(hvf_enabled());
 
-    cpu->thread = g_malloc0(sizeof(QemuThread));
-    cpu->halt_cond = g_malloc0(sizeof(QemuCond));
-    qemu_cond_init(cpu->halt_cond);
-
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/HVF",
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, hvf_cpu_thread_fn,
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 94c828ac8d..c239dfc87a 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -66,9 +66,6 @@ static void kvm_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    cpu->thread = g_malloc0(sizeof(QemuThread));
-    cpu->halt_cond = g_malloc0(sizeof(QemuCond));
-    qemu_cond_init(cpu->halt_cond);
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/KVM",
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, kvm_vcpu_thread_fn,
diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index c552b45b8e..49814ec4af 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -137,10 +137,6 @@ void mttcg_start_vcpu_thread(CPUState *cpu)
     g_assert(tcg_enabled());
     tcg_cpu_init_cflags(cpu, current_machine->smp.max_cpus > 1);
 
-    cpu->thread = g_new0(QemuThread, 1);
-    cpu->halt_cond = g_malloc0(sizeof(QemuCond));
-    qemu_cond_init(cpu->halt_cond);
-
     /* create a thread per vCPU with TCG (MTTCG) */
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/TCG",
              cpu->cpu_index);
diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index 894e73e52c..84c36c1450 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -317,22 +317,22 @@ void rr_start_vcpu_thread(CPUState *cpu)
     tcg_cpu_init_cflags(cpu, false);
 
     if (!single_tcg_cpu_thread) {
-        cpu->thread = g_new0(QemuThread, 1);
-        cpu->halt_cond = g_new0(QemuCond, 1);
-        qemu_cond_init(cpu->halt_cond);
+        single_tcg_halt_cond = cpu->halt_cond;
+        single_tcg_cpu_thread = cpu->thread;
 
         /* share a single thread for all cpus with TCG */
         snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "ALL CPUs/TCG");
         qemu_thread_create(cpu->thread, thread_name,
                            rr_cpu_thread_fn,
                            cpu, QEMU_THREAD_JOINABLE);
-
-        single_tcg_halt_cond = cpu->halt_cond;
-        single_tcg_cpu_thread = cpu->thread;
     } else {
-        /* we share the thread */
+        /* we share the thread, dump spare data */
+        g_free(cpu->thread);
+        qemu_cond_destroy(cpu->halt_cond);
         cpu->thread = single_tcg_cpu_thread;
         cpu->halt_cond = single_tcg_halt_cond;
+
+        /* copy the stuff done at start of rr_cpu_thread_fn */
         cpu->thread_id = first_cpu->thread_id;
         cpu->neg.can_do_io = 1;
         cpu->created = true;
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 0f0a247f56..6cfc01593a 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -261,6 +261,11 @@ static void cpu_common_initfn(Object *obj)
     cpu->nr_threads = 1;
     cpu->cflags_next_tb = -1;
 
+    /* allocate storage for thread info, initialise condition variables */
+    cpu->thread = g_new0(QemuThread, 1);
+    cpu->halt_cond = g_new0(QemuCond, 1);
+    qemu_cond_init(cpu->halt_cond);
+
     qemu_mutex_init(&cpu->work_mutex);
     qemu_lockcnt_init(&cpu->in_ioctl_lock);
     QSIMPLEQ_INIT(&cpu->work_list);
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index 6b2bfd9b9c..0ba31201e2 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -64,9 +64,6 @@ static void nvmm_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    cpu->thread = g_new0(QemuThread, 1);
-    cpu->halt_cond = g_new0(QemuCond, 1);
-    qemu_cond_init(cpu->halt_cond);
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/NVMM",
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, qemu_nvmm_cpu_thread_fn,
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index 189ae0f140..1a2b4e1c43 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -64,9 +64,6 @@ static void whpx_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    cpu->thread = g_new0(QemuThread, 1);
-    cpu->halt_cond = g_new0(QemuCond, 1);
-    qemu_cond_init(cpu->halt_cond);
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/WHPX",
              cpu->cpu_index);
     qemu_thread_create(cpu->thread, thread_name, whpx_cpu_thread_fn,
-- 
2.39.2


