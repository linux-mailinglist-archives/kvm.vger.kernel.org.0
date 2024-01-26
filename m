Return-Path: <kvm+bounces-7232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5949A83E4A8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ED941F214B8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3965B5CF;
	Fri, 26 Jan 2024 22:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TWqJZXhE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224B95B1FE
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306765; cv=none; b=pzKEPzWfsRK8XGJEoVmFjiNxdTpalu72bu4GMXME5hDRKSJpczbapOam7NIXGyW8tyev2QOvl0ImXMbPZVCjUOhI0wkwYDwRXrAG+Fh3MMwqwr4sYgiTTJqjttbvQPTXuMTzLREZ3Bhe7s8bpkSnF2L1ycyVUmKPOKRVkZeIIiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306765; c=relaxed/simple;
	bh=ItYA9au/dt+O1e2yo1AQHf5iDgq4VGOSm2btVTvX+X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FE1S2a0KoitxJ1lFWnGMlputvAsL1eTp5DkhS5bDKNYm/2IZRQKQdfAmxWSrXBiJJ326QMco3tUFDZNnxiDJlJGtJk9Ke+Le08rxfTTYoLB7eMLa82tiwDwLoThvjIA7wki0lvkav29iviUHHtcpdS5YXSVrnoWwd6a5GfVOp3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TWqJZXhE; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40eec4984acso921305e9.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306761; x=1706911561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Fp9tWfUnWpTWSY0wSSNV5XB5wPrgNqsnYE0Bp5WmMs=;
        b=TWqJZXhE0WbSS9urKI+/bD2u0iV39J6Z1s1cNOSma52jUNHWu+X71XxiR5IxuJKnvE
         rV6WSSF67MAtLbfvaExLV5pidG0PzfK1b9JPaNjbAL1aR4Py+RJkuHkyvVi7mINQoWYS
         Pc05Mxxplg/eTiCSj7Ppi13NV80dT2llS4ksnKbcPYZtWoy9jL5dC3Goc5+e52pswdlC
         wyk8zuN4Y4w2DvGIj/nZ5wL2PfEJiRoP4CnnVZc4UNS3nT8/30RySErqjmkbvizOMaBv
         fA9gdj5CEXRAflRtWLEhaI3WcCpO56Pp82sBJajGpYYMLyt/w0W1LzZsTAx338Iw6cLy
         V23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306761; x=1706911561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Fp9tWfUnWpTWSY0wSSNV5XB5wPrgNqsnYE0Bp5WmMs=;
        b=F1CF13WCqaXo9kaIgmJ4ge2qzoyS6VIqkx1rK1btgfP2jHm0wGdvzK35bx6zMgqNTm
         3NeBRDAvsWctQETb2X0fUQVixUTW3jzDH5Z49vqOd9kBHeOMQd73tFX0a1OK9askUoCH
         SOAO01jwq1Sm8Zlgihwk/dhstLwbhJjkkeR/dPglUH5c87atRksLYLArS7yB0AAj5Uq7
         hNy9pKM16jzNci1+13LJvNP5yy1grRSJOQ8j+KE9YXV0dwngXMcKFkzqv2lpgyPyMplo
         VWUnLTEzwzRymKwnS/ndJ5p6t1R5GO9MYsUrSVY6xrBwfBr9m+miWqJJcA85k87CVNjr
         vf0Q==
X-Gm-Message-State: AOJu0Yx0V+DkzqZV3QWGkaUp25a9LeW/UFev29kUvYX5zZi9zCElNAh7
	1mtK/n9U7DCHEmT7dfkQjgxplLxXhUKXpCDELv7KMzLMcRmpzlcirjmj9Q0xd9U=
X-Google-Smtp-Source: AGHT+IFd1IbswSIXEXRwvvayIHbXjba/igiz3MLifb8MrBXCEI38IVU61Lu9pQK0loQXCyARtTly0w==
X-Received: by 2002:a05:600c:5187:b0:40e:d44a:ca9c with SMTP id fa7-20020a05600c518700b0040ed44aca9cmr330302wmb.48.1706306761345;
        Fri, 26 Jan 2024 14:06:01 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id bi19-20020a05600c3d9300b0040ee51f1025sm1819887wmb.43.2024.01.26.14.05.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:06:00 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 18/23] target/rx: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:04:00 +0100
Message-ID: <20240126220407.95022-19-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240126220407.95022-1-philmd@linaro.org>
References: <20240126220407.95022-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mechanical patch produced running the command documented
in scripts/coccinelle/cpu_env.cocci_template header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/rx/gdbstub.c   | 6 ++----
 target/rx/helper.c    | 6 ++----
 target/rx/translate.c | 3 +--
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/target/rx/gdbstub.c b/target/rx/gdbstub.c
index d7e0e6689b..f222bf003b 100644
--- a/target/rx/gdbstub.c
+++ b/target/rx/gdbstub.c
@@ -21,8 +21,7 @@
 
 int rx_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
 
     switch (n) {
     case 0 ... 15:
@@ -53,8 +52,7 @@ int rx_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int rx_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     uint32_t psw;
     switch (n) {
     case 0 ... 15:
diff --git a/target/rx/helper.c b/target/rx/helper.c
index dad5fb4976..80912e8dcb 100644
--- a/target/rx/helper.c
+++ b/target/rx/helper.c
@@ -45,8 +45,7 @@ void rx_cpu_unpack_psw(CPURXState *env, uint32_t psw, int rte)
 #define INT_FLAGS (CPU_INTERRUPT_HARD | CPU_INTERRUPT_FIR)
 void rx_cpu_do_interrupt(CPUState *cs)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     int do_irq = cs->interrupt_request & INT_FLAGS;
     uint32_t save_psw;
 
@@ -122,8 +121,7 @@ void rx_cpu_do_interrupt(CPUState *cs)
 
 bool rx_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     int accept = 0;
     /* hardware interrupt (Normal) */
     if ((interrupt_request & CPU_INTERRUPT_HARD) &&
diff --git a/target/rx/translate.c b/target/rx/translate.c
index 1829a0b1cd..26aaf7a6b5 100644
--- a/target/rx/translate.c
+++ b/target/rx/translate.c
@@ -131,8 +131,7 @@ static int bdsp_s(DisasContext *ctx, int d)
 
 void rx_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    RXCPU *cpu = RX_CPU(cs);
-    CPURXState *env = &cpu->env;
+    CPURXState *env = cpu_env(cs);
     int i;
     uint32_t psw;
 
-- 
2.41.0


