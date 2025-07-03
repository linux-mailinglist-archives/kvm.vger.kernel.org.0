Return-Path: <kvm+bounces-51453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 351A4AF7158
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E11085279B2
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98EA72E1738;
	Thu,  3 Jul 2025 11:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ohf235Nn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF0C2E3B0D
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540409; cv=none; b=HN3rDyLR1PK+2APNYKlNUDbkTEpPw50o6W/JqXsyWUreEaicypcubx1BCgnIzQ5CL+ErGRpiBLzP9Nmf4prx1tW4NEYbhYp2vCHbihyLvT+cpidfY3vDdUtL/5ELIEh931c8zitD9U3rGJLGjNHsguSgMiedbrb4ptBnGbe4Iz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540409; c=relaxed/simple;
	bh=IEJEKs8h0BElrwDfnr5/UDGu+JpYigei5NV27EUEIkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSS4/C2H4HfciFeCAb9u8LcEqduc2CTmVGzHnuuE3WafqDuKKG/4+tQ03+0fxS9sPHuj16jyRQ3XZ1EsM1SAgmJP0ZCwfZ8dYE5m/T2Ak9m4QqH/vwaezJi63Yelu6KFgUhdrBL/FcqPSMMbhmJ/Pc4CVF3N2dsg1E4QUCMJ7lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ohf235Nn; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-450cf214200so45305245e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540406; x=1752145206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kywse2u9MhU8QPCYXPxuKeKrJVPdiRbR+9Ey6S9IQUI=;
        b=ohf235NnNbPeaidg/xOcpJ6qX7gPr0axyW8hVZBjnXW9ybKSjXyhm5PuNBFTvqU/4X
         du0ii++IRP18e7yg5ubY+dfCb8b9pCuECMIK89iVmpCdAsgunEJI8JTUplcFWiFLcbO/
         kCJGMYAbgXjvXv0Rq8tSm49bq7p2KwspTv1Kd4rTfX51OTryB45t6cMqY0h4xnZ4QOIW
         uXE5OLVCiSiYkMtmUCHQpXZ3iqkv6msESggEjKeHYKGJpraFA3nCHA1J26vvKUgeZFTR
         6r/MoPOYmo7Czs9ieJkX5zePpJMH9JyXGVMoyyk2EPHi0lmcijy/eYsoeJBkfT4u1ALH
         DT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540406; x=1752145206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kywse2u9MhU8QPCYXPxuKeKrJVPdiRbR+9Ey6S9IQUI=;
        b=iSfHtdXW6lgTm2KYeliLEW7wC/R2xZ9BQgDZ0cTmokZnrYs0HdB9jxnEwDjy3paxxq
         31QuBQmgZ4CdSXxTzf4YVrvC8BK2JbZu/AqhYily2GXTmUehrUVidprmztlqCK9r2cP0
         bI81NfglZhnYK557HJyUH2IwPBoUaBYZeZQ6lF/qzhVhFGIs7U+xmI35wDRCPnhF1QuT
         b6/ETS2W0xLVvI7gg903XfUlkCXtICbNqZXtCAZxp3paqnB96UKJKJm4kzM3LMZVhXwm
         C8GQnSkRMxD4adjeRmF+LmhGHetCJ6CCcuRKLDTtdAbMV113KIpBO3Fvf8Eog/PrhFGg
         Eoog==
X-Forwarded-Encrypted: i=1; AJvYcCVjQIHpCM6lAoq44+ZZyclhSREnIxIkw/dcKCuiUohgcSKeqdPVmKqaPSdknSL7dihy0FI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6PyxsL43hsuUdYILsTyzSaKRkM0cdjUiteE4rruhAdZTQK+Cy
	8VTTpkzolcCsPcC7hAdz35mDPUvPG+aQA8sl7GTutqlXeRoXrdMn4ZGaasoE9Z4eis0=
X-Gm-Gg: ASbGnctsRPielnbr33wM1ETliEut4/T/F52W7GOnAydtlYGM4RDFJryFl8z3xwtDWFZ
	i1FOTEjU+LOhBMptQJzrY2B1joWugkN12rPufdWlTKLD3TDdBt0Du80mAJ0+KXsbsNXOAD5xPkO
	1dM5FL0ZBRU3ZkCXxubqQh5cNtxWXP8y/C4Qewl9gs8nL91Ojo/Ied0/EwYnXW1qhrUczQ7hcUQ
	rJh9E7aBO/prL25KYUrOTaqmv8Q9PQbFsBVkE/glqgyN3yMugZYkGGLIFDm5qzGILy/aCZzoupj
	pDxcXYeL0e1c0WBSkrH9AiSS/f82tTR4n6vJIc7dmgDreOsMfqVPk+Ar+l+fbpzVVjCwzGMiRi7
	eR5ZtSzC0Vyo=
X-Google-Smtp-Source: AGHT+IFcuVQPSvcB9tMEYZkxIF5efKkb5dETC/UVOZdIIwZuyXL+g/f5Jm/UZvPU76maeI70uQekgg==
X-Received: by 2002:a05:600c:6305:b0:453:6146:1182 with SMTP id 5b1f17b1804b1-454a9cb45afmr25885755e9.32.1751540406328;
        Thu, 03 Jul 2025 04:00:06 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997e24bsm23516035e9.16.2025.07.03.04.00.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:05 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 50/69] accel/tcg: Factor tcg_vcpu_thread_precreate() out
Date: Thu,  3 Jul 2025 12:55:16 +0200
Message-ID: <20250703105540.67664-51-philmd@linaro.org>
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

Factor tcg_vcpu_thread_precreate() out for re-use.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops.h       | 1 +
 accel/tcg/tcg-accel-ops-mttcg.c | 3 +--
 accel/tcg/tcg-accel-ops-rr.c    | 3 +--
 accel/tcg/tcg-accel-ops.c       | 7 +++++++
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops.h b/accel/tcg/tcg-accel-ops.h
index 6feeb3f3e9b..129af89c3e7 100644
--- a/accel/tcg/tcg-accel-ops.h
+++ b/accel/tcg/tcg-accel-ops.h
@@ -14,6 +14,7 @@
 
 #include "system/cpus.h"
 
+void tcg_vcpu_thread_precreate(CPUState *cpu);
 void tcg_cpu_destroy(CPUState *cpu);
 int tcg_cpu_exec(CPUState *cpu);
 void tcg_handle_interrupt(CPUState *cpu, int mask);
diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index dfcee30947e..462be7596b9 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -133,8 +133,7 @@ void mttcg_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    g_assert(tcg_enabled());
-    tcg_cpu_init_cflags(cpu, current_machine->smp.max_cpus > 1);
+    tcg_vcpu_thread_precreate(cpu);
 
     /* create a thread per vCPU with TCG (MTTCG) */
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/TCG",
diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index 6eec5c9eee9..fc33a13e4e8 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -311,8 +311,7 @@ void rr_start_vcpu_thread(CPUState *cpu)
     static QemuCond *single_tcg_halt_cond;
     static QemuThread *single_tcg_cpu_thread;
 
-    g_assert(tcg_enabled());
-    tcg_cpu_init_cflags(cpu, false);
+    tcg_vcpu_thread_precreate(cpu);
 
     if (!single_tcg_cpu_thread) {
         single_tcg_halt_cond = cpu->halt_cond;
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 95ff451c148..861996649b7 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -41,6 +41,7 @@
 #include "gdbstub/enums.h"
 
 #include "hw/core/cpu.h"
+#include "hw/boards.h"
 
 #include "tcg-accel-ops.h"
 #include "tcg-accel-ops-mttcg.h"
@@ -69,6 +70,12 @@ void tcg_cpu_init_cflags(CPUState *cpu, bool parallel)
     tcg_cflags_set(cpu, cflags);
 }
 
+void tcg_vcpu_thread_precreate(CPUState *cpu)
+{
+    g_assert(tcg_enabled());
+    tcg_cpu_init_cflags(cpu, current_machine->smp.max_cpus > 1);
+}
+
 void tcg_cpu_destroy(CPUState *cpu)
 {
     cpu_thread_signal_destroyed(cpu);
-- 
2.49.0


