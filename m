Return-Path: <kvm+bounces-51463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC6FAF715F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95A4D7AAA53
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992EB2E4261;
	Thu,  3 Jul 2025 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dbSEjHbc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9AF2F872
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540461; cv=none; b=L3ipvDjwOkW6FgZuUTwwAuukM2CpLtJ5GoPjvRvNJtCtYQHDC6rkUzit0n+0surxyGvNyeJ6hlTFz5+7dB0KW7XcbahocAe+Ehk6HmVONr9QuctDUe3mNwKNaqCB1N4FqiF96DtDuhXCuCF0vHAirj41FfO/xMzNzhy6sDhjhRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540461; c=relaxed/simple;
	bh=aHWfWpiktsTFx1luR6uxWcU+bXr3Prb9Yd6EkIUGkWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Es/rsnW9+J1jplKXOikfHmauU3Vyo1VcYIT8rOp0YMwU7T0qZoEVyeMgx+gp5oEz9sWnl+99GJc4UqcNUmt5hRJde6llf2fUtrwJ4VW3Jl0L9VNwDFyEQKPd/CnaTP4VG8SdsDXEg/4dm0pvoFGQFkpBEYOuDFIvrup8Skkke9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dbSEjHbc; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a531fcaa05so3320427f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540458; x=1752145258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kv+3eABLjDWkuIjt/EEQUuT2EYyux5ATDXpfAYp2as0=;
        b=dbSEjHbcgXaAvZx0YKvXRxJA6q3bBQAtGbNGYmLSFc9aiS67nyg5LJycDEUsdbWtPF
         322HIAugyp1dwc3NlNL5zva/9Bfhz7vRt/Fwk84zvy5quQ7FNDkyEdejfGA1ywWv5WyX
         e1aBFG1Tx6/dkUg5IHmZ1caKLIMk8KmTeQ74KmEuJZV5xtwSEvvROq0N+cddFwsZ2pWp
         9BxAVL+9cP3+vmHhfrOBsbyX07Ds4N1ACq+ig1TNgUeIIk/sPV/wJCCMs3+H5NgIBCpS
         jNpY1GPn/I6wyvYZ2UeTqyQ8U41m0lp6RRz1Yzpk/TxpqzrZcqZ7h6sRW6ojMDC+jofu
         cy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540458; x=1752145258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kv+3eABLjDWkuIjt/EEQUuT2EYyux5ATDXpfAYp2as0=;
        b=KUyylj4nLXWXVMtYb8B5rikfhrZ1Ct1tn4rwVFQUVtC88y5Bbu2Qx4ayXY7tn3jOVs
         jwOFQqflSGpOLmnPacijF4+9ISMMN+QDOJuxsmnSo2JrGFgllikTjSwR7Z75lvL/5jM2
         JYUAPUh+584wPNPd/2bPjZn8cd/HFedEkqBUjWw7Pp0B2MsqyZZ3UuqJVjYGr22HjozN
         lvTTj/QirC8NB8DR8Oad+R/oovPV2nvA0ZoozffRHrmALOTyEwToPRFJO2QIrET5EHKI
         cDD6NHykmUAC+RRpAgP6Wt1M3APQ+K++qQk4ll22yRAwjlb9A7in0qR+WzTqtZoGOKjx
         /Chw==
X-Forwarded-Encrypted: i=1; AJvYcCXBY03XQmo2i5XiXmZRvyHhLFufQy+ugRp7MoWjTWThPlV7qQHhh7CqbKcr8tVOZsDj1og=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0wm0v69xlLTkgvSUoaSFj4zhGwR67Cmg7KnFsHs8luaUq8De8
	iHxkiQ7ovIL/ehMxABm8mP91gPegGCfOfCAXZIhLNkaIaw0+vV1cWGNUg2x7cyR15dIDyJ61zJp
	oHWtIAtg=
X-Gm-Gg: ASbGnct9GDOwrMKmyWsm4GQswXvOrEDJHcbc5v/mBuSY0DvStqaPNJSoCqpGjyzu5Fx
	j9nlLg0eQMXWtzgM+1/+XhAfFN11UXy/5B2ylOVVmNrGVaGYRaU+IDd/kajJ8P/e9JLC4NF8vnR
	frAMUU9jk77JozD1SUIy2FDbVOr6En+ZPqWXoAYpdwE/zTgxqTzBbvU1PVPy670Ekue1rjzQcTW
	waXZkRU1A0JkJ7UeoElbfRJvbEsmIq9nXQ69sjvDIJez+R2DkcEzJjJ5zBIyoafZ2Wnulsu164K
	Zu4z7BZQZI6ciLH6eb7am7ZMC7jMwjP94AH85/ZZVeo8vXwvbIzVo+54VSi17rl8S7pfQS6lkge
	43LjB4vUITvM=
X-Google-Smtp-Source: AGHT+IEP9TKLC5P5AJ7QlKmZqQqcoj8rqfBj8NMgA0J1sYsb5B4zEW1QkyCXHPH+BN/0leJGYauyFg==
X-Received: by 2002:a05:6000:26d1:b0:3a4:f52d:8b05 with SMTP id ffacd0b85a97d-3b32db892femr2530477f8f.35.1751540458218;
        Thu, 03 Jul 2025 04:00:58 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52ca4sm18489948f8f.58.2025.07.03.04.00.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:57 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 60/69] accel: Pass old/new interrupt mask to handle_interrupt() handler
Date: Thu,  3 Jul 2025 12:55:26 +0200
Message-ID: <20250703105540.67664-61-philmd@linaro.org>
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

Update CPUState::interrupt_request once in cpu_interrupt().
Pass the old and new masks along.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops-icount.h |  2 +-
 accel/tcg/tcg-accel-ops.h        |  2 +-
 include/system/accel-ops.h       |  2 +-
 accel/tcg/tcg-accel-ops-icount.c |  8 +++-----
 accel/tcg/tcg-accel-ops.c        |  4 +---
 system/cpus.c                    | 12 +++++++-----
 6 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops-icount.h b/accel/tcg/tcg-accel-ops-icount.h
index 16a301b6dc0..1d9d66f0707 100644
--- a/accel/tcg/tcg-accel-ops-icount.h
+++ b/accel/tcg/tcg-accel-ops-icount.h
@@ -15,6 +15,6 @@ void icount_prepare_for_run(CPUState *cpu, int64_t cpu_budget);
 int64_t icount_percpu_budget(int cpu_count);
 void icount_process_data(CPUState *cpu);
 
-void icount_handle_interrupt(CPUState *cpu, int mask);
+void icount_handle_interrupt(CPUState *cpu, int old_mask, int new_mask);
 
 #endif /* TCG_ACCEL_OPS_ICOUNT_H */
diff --git a/accel/tcg/tcg-accel-ops.h b/accel/tcg/tcg-accel-ops.h
index 129af89c3e7..3f8eccb7a7f 100644
--- a/accel/tcg/tcg-accel-ops.h
+++ b/accel/tcg/tcg-accel-ops.h
@@ -17,7 +17,7 @@
 void tcg_vcpu_thread_precreate(CPUState *cpu);
 void tcg_cpu_destroy(CPUState *cpu);
 int tcg_cpu_exec(CPUState *cpu);
-void tcg_handle_interrupt(CPUState *cpu, int mask);
+void tcg_handle_interrupt(CPUState *cpu, int old_mask, int new_mask);
 void tcg_cpu_init_cflags(CPUState *cpu, bool parallel);
 
 #endif /* TCG_ACCEL_OPS_H */
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index d4bd9c02d14..6d0791d73a4 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -67,7 +67,7 @@ struct AccelOpsClass {
     void (*synchronize_state)(CPUState *cpu);
     void (*synchronize_pre_loadvm)(CPUState *cpu);
 
-    void (*handle_interrupt)(CPUState *cpu, int mask);
+    void (*handle_interrupt)(CPUState *cpu, int old_mask, int new_mask);
 
     /* get_vcpu_stats: Append statistics of this @cpu to @buf */
     void (*get_vcpu_stats)(CPUState *cpu, GString *buf);
diff --git a/accel/tcg/tcg-accel-ops-icount.c b/accel/tcg/tcg-accel-ops-icount.c
index d0f7b410fab..500b5dd4942 100644
--- a/accel/tcg/tcg-accel-ops-icount.c
+++ b/accel/tcg/tcg-accel-ops-icount.c
@@ -147,14 +147,12 @@ void icount_process_data(CPUState *cpu)
     replay_mutex_unlock();
 }
 
-void icount_handle_interrupt(CPUState *cpu, int mask)
+void icount_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
 {
-    int old_mask = cpu->interrupt_request;
-
-    tcg_handle_interrupt(cpu, mask);
+    tcg_handle_interrupt(cpu, old_mask, new_mask);
     if (qemu_cpu_is_self(cpu) &&
         !cpu->neg.can_do_io
-        && (mask & ~old_mask) != 0) {
+        && (new_mask & ~old_mask) != 0) {
         cpu_abort(cpu, "Raised interrupt while not in I/O function");
     }
 }
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 4931e536beb..a8c24cf8a4c 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -99,10 +99,8 @@ static void tcg_cpu_reset_hold(CPUState *cpu)
 }
 
 /* mask must never be zero, except for A20 change call */
-void tcg_handle_interrupt(CPUState *cpu, int mask)
+void tcg_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
 {
-    cpu->interrupt_request |= mask;
-
     /*
      * If called from iothread context, wake the target cpu in
      * case its halted.
diff --git a/system/cpus.c b/system/cpus.c
index c2ad640980c..8c2647f5f19 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -246,10 +246,8 @@ int64_t cpus_get_elapsed_ticks(void)
     return cpu_get_ticks();
 }
 
-static void generic_handle_interrupt(CPUState *cpu, int mask)
+static void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
 {
-    cpu->interrupt_request |= mask;
-
     if (!qemu_cpu_is_self(cpu)) {
         qemu_cpu_kick(cpu);
     }
@@ -257,12 +255,16 @@ static void generic_handle_interrupt(CPUState *cpu, int mask)
 
 void cpu_interrupt(CPUState *cpu, int mask)
 {
+    int old_mask = cpu->interrupt_request;
+
     g_assert(bql_locked());
 
+    cpu->interrupt_request |= mask;
+
     if (cpus_accel->handle_interrupt) {
-        cpus_accel->handle_interrupt(cpu, mask);
+        cpus_accel->handle_interrupt(cpu, old_mask, cpu->interrupt_request);
     } else {
-        generic_handle_interrupt(cpu, mask);
+        generic_handle_interrupt(cpu, old_mask, cpu->interrupt_request);
     }
 }
 
-- 
2.49.0


