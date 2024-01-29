Return-Path: <kvm+bounces-7365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 718CC840C1D
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF4611F20933
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3020B15698D;
	Mon, 29 Jan 2024 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xE/WKl0k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13CB156985
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546839; cv=none; b=gdAnzwa+FDN4ZOpJYR1+u8FJEKmA5hXFI3I/W8By6BX8RGyN2OBYzHnpSoXggkxjN9ztbiKo+vylAgtYhrn6tAUFiiU7LnUGygKUXHP4TUbnLWX+Ve3+p9Y2AtdsxMdatdJEqhXqj1p1UQw5vlNs17iHUNVS7TErK3fHJ2yEWjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546839; c=relaxed/simple;
	bh=ylNnxRFMpN9DqWlW/A5LGAGoiXngFYhklsimJg6JN60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/Lnwp+wdBTWrsPP0EPGtA1MJKtVQIkivTNqyDAq3s2CTmfG6pmsSahiR+HDepRqTBrTcPupBGYHTqSYP5vHkIZyMec73bWOjdL5cXkK0u8CjcZaQqHHN1Cq+U8G+4H2bUVcEkrhYxT+PueVVFil6G1cP/s4y6FKqnTs204FcYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xE/WKl0k; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40eacb4bfa0so35015075e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546836; x=1707151636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+WHgRt8aoFwU9PH4yyhsDxrOBo9TuwHJWddMcT5sv4=;
        b=xE/WKl0kK4lbFfzgvOGvfp57Y1vZw684ku6W1NQ+Fv1jPz/XkVZCCRzUGNvi17astA
         BaGKxQCANLSdBvLYe4r6y3OuC9OtqjlXIta9L1nnycTlQ3jTvsaR7h8JK88JzIBqr846
         nl9+H4nSacJTBTU0ZEtaxkf2m3JdFX2b4iuQKAYgC0gNeFTPIGXrl0f6gT7Iuwx6VqJV
         lOfRphbeaWmbJemDi7I8GWaiDvMIIKGECtju4vQATYvkAMf/aEEoBF+MHQxxRSBunZsC
         3BWLz3PM7Ka1KLBJYAO4jPOMhRj33eSVBLePkMMUtR6FYf0v8kAgFkBPKDDDHFMbl1jz
         LQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546836; x=1707151636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+WHgRt8aoFwU9PH4yyhsDxrOBo9TuwHJWddMcT5sv4=;
        b=tSJRumc87+XyPPNLOQFLGNjtihIo1itqX0H2APZzsOCc0vXX4gknHmMjQzqBlbftNq
         0lZUbnT0rKmsZIgeQ9Z8Yb5c+el976onrq21FRuoADTdWioOhe+d3jSNYpXxnclMyACB
         hhiNetm0hEkTKjzf5ex8vabH6rIIKh3FNd8N20LX5E6Ckyga8Gv09w9IVmSSK/uV3Pwb
         r3bidJDJM0wbAAN7Jtuz/rrterJCC/RA7/11HNuGe+cKMWBhFG+1I8A0eMMIodjHqI2I
         Ms514xlUSFrRnn5v1rql1ytflpVCI8RAX63OT9txyBJ7FVRe6LoT55Zxq4lJtcSM447N
         Grdg==
X-Gm-Message-State: AOJu0Yw+HgHYh8BKwvp82BuJ89fxqZQzVg5Smhgymw1O7Qhr8KB5GBQ1
	znka+yTpnpKfk7Z+qLxNuLK5Jdci8kta9Q09BDad3G87jWkC3cn5NYvi0dD0iws=
X-Google-Smtp-Source: AGHT+IGYhnGe776oZg8Nf+XW6qyKWUfG5CSd+AahADH4rgW9WuZbEKC9nCTJSkL02Ck+OeTkF8tuTg==
X-Received: by 2002:a05:600c:4689:b0:40d:5575:a197 with SMTP id p9-20020a05600c468900b0040d5575a197mr5396356wmo.12.1706546836062;
        Mon, 29 Jan 2024 08:47:16 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id l29-20020a05600c1d1d00b0040ef8aa4822sm2704220wms.38.2024.01.29.08.47.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:47:15 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Chris Wulff <crwulff@gmail.com>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH v3 19/29] target/nios2: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:45:01 +0100
Message-ID: <20240129164514.73104-20-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240129164514.73104-1-philmd@linaro.org>
References: <20240129164514.73104-1-philmd@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/nios2/cpu.c        | 15 +++------------
 target/nios2/helper.c     |  3 +--
 target/nios2/nios2-semi.c |  6 ++----
 target/nios2/translate.c  |  3 +--
 4 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index 09b122e24d..b5b3773fb8 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -28,28 +28,19 @@
 
 static void nios2_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
-
-    env->pc = value;
+    cpu_env(cs)->pc = value;
 }
 
 static vaddr nios2_cpu_get_pc(CPUState *cs)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
-
-    return env->pc;
+    return cpu_env(cs)->pc;
 }
 
 static void nios2_restore_state_to_opc(CPUState *cs,
                                        const TranslationBlock *tb,
                                        const uint64_t *data)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
-
-    env->pc = data[0];
+    cpu_env(cs)->pc = data[0];
 }
 
 static bool nios2_cpu_has_work(CPUState *cs)
diff --git a/target/nios2/helper.c b/target/nios2/helper.c
index bb3b09e5a7..ac57121afc 100644
--- a/target/nios2/helper.c
+++ b/target/nios2/helper.c
@@ -287,8 +287,7 @@ void nios2_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type,
                                    int mmu_idx, uintptr_t retaddr)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
 
     env->ctrl[CR_BADADDR] = addr;
     cs->exception_index = EXCP_UNALIGN;
diff --git a/target/nios2/nios2-semi.c b/target/nios2/nios2-semi.c
index 0b84fcb6b6..420702e293 100644
--- a/target/nios2/nios2-semi.c
+++ b/target/nios2/nios2-semi.c
@@ -75,8 +75,7 @@ static int host_to_gdb_errno(int err)
 
 static void nios2_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
     target_ulong args = env->regs[R_ARG1];
 
     if (put_user_u32(ret, args) ||
@@ -93,8 +92,7 @@ static void nios2_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 
 static void nios2_semi_u64_cb(CPUState *cs, uint64_t ret, int err)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
     target_ulong args = env->regs[R_ARG1];
 
     if (put_user_u32(ret >> 32, args) ||
diff --git a/target/nios2/translate.c b/target/nios2/translate.c
index e806623594..30beb303f9 100644
--- a/target/nios2/translate.c
+++ b/target/nios2/translate.c
@@ -970,7 +970,6 @@ static void nios2_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
 static void nios2_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
 {
     DisasContext *dc = container_of(dcbase, DisasContext, base);
-    CPUNios2State *env = cpu_env(cs);
     const Nios2Instruction *instr;
     uint32_t code, pc;
     uint8_t op;
@@ -980,7 +979,7 @@ static void nios2_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
     dc->base.pc_next = pc + 4;
 
     /* Decode an instruction */
-    code = cpu_ldl_code(env, pc);
+    code = cpu_ldl_code(cpu_env(cs), pc);
     op = get_opcode(code);
 
     if (unlikely(op >= ARRAY_SIZE(i_type_instructions))) {
-- 
2.41.0


