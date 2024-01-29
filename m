Return-Path: <kvm+bounces-7353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B071840C03
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C73B1F24886
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA05156997;
	Mon, 29 Jan 2024 16:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xGFqlDgE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FFD153BCE
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546767; cv=none; b=nLaksHHlk7zfte1cmu/Kjt4YC2cuCB1pJjeNvc9FhHI9h7ogcf/5Yfu9F2fE6+V7nLlKipm8xA8AFtCek/IJxtwldM4nbaWrJKkDhtFZqB7aIyF2JENhjcPt/GdG/MRxR3k1iZ7gf1tbziGmgHqZg3skoGkM5o3oUFQl4blY1n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546767; c=relaxed/simple;
	bh=nuNLJVO/OJe0a2/jT/vIwWvFlo0Bw0yZphZv1D+GS1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RKr0FeP5Pul1AYa7Ym0JF9kFrO758CDsI7fuRBxam7BORqJejmIICYd5AongYb2DHIcrMCM74SjE/Z0dhwiEC8YUwvmEBXfGUgYpf5ZWA/aRvUqiO84sbwCUSyBensk+DQI+1jQuEV1b/pOLeLTvpdei6bEDTZFTCELSmkVnKeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xGFqlDgE; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33af40493f4so479628f8f.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546764; x=1707151564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGNKA1+F8sOT+wzzeFuDW0MVJl/ad3LJJb3kfzi1Tuw=;
        b=xGFqlDgEFeieSi0rSFMVwd/+6MX6AnMIDZ3Xul6nomCFN3JTLx8lnDcs8wrGBFOmPk
         jOc3ekYkw9tZqkqbLznUsmbf/b/V0/FM9KEqbuIUFYDcSdVX2gKcKKIL4Xp/up/6DOYg
         exiL2N1hS7YDleW5iTFE32kVVCSiKJDBATgXC6LZE1j8ELjtNXgUgF8Yov48q1R8TAbw
         /97+a6ORj/Dd0jYRq8HVKvJtjcNhfubuBMQ1eYJKAv9J/Re/GgGnxa+n06+YfnDSa9QE
         RKJTURi8HaLy8PstFhgh3kghZoVyI7zCsQeBhlLMP/089lr2ufVF5HxDJPYHbbKoZ3mJ
         b9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546764; x=1707151564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGNKA1+F8sOT+wzzeFuDW0MVJl/ad3LJJb3kfzi1Tuw=;
        b=GKZ93IO6/wM2rXw7HIqkZ/kZSvPvhC9dB6FnIM2F1WJjA2IePibBD2J1/SiUXf4uTc
         yzHCevAih7PdOSgVrJZNKREa2VB5aK98Aprl4mkE3tP3BLWpANHaz0I9ii/L0hTjUUoU
         pQlfM/DeoSyX+T3Y+GcBKUTpmom2tq4w194oQdbMECpvr/ohPXXuRS7vtuFfbjRtfsWL
         P/YOzEJUMGWUVUjf/KBZiDvdQTGU0qBJKA9kInR7Ra8BK3I9HaO6qzJXPpcugxKC82bA
         S41PtTlA7vVnmjBjHKZPNW3Y7Bq7wEXcHA1Q9vWtv1fTSeB2PX/ocaSNpx5He+ahLUVk
         j3hQ==
X-Gm-Message-State: AOJu0YyQDAV8xHAONcib4A7Dm1/1eAEcrnS+JSvAkFGN6iTcTcc9mOmt
	xvncgKV6IwFcKgu8gwKNpyPcgcBsrY/2CL1XsSsLoeKprTyym1Z3tb8YtmZgAx4VrqdHPIoVL6U
	z
X-Google-Smtp-Source: AGHT+IEXV3Ki5IWCz4nhNivs20Xtm4D5RCIZtFll/A9SeJ2KRGM2dIq81Jsin9IhV9P3C8GFjfF1yg==
X-Received: by 2002:a5d:5f96:0:b0:33a:e724:63fb with SMTP id dr22-20020a5d5f96000000b0033ae72463fbmr3905171wrb.20.1706546763809;
        Mon, 29 Jan 2024 08:46:03 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id v7-20020a5d4a47000000b0033aef37ec94sm2523940wrs.113.2024.01.29.08.46.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:46:03 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 07/29] target/alpha: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:49 +0100
Message-ID: <20240129164514.73104-8-philmd@linaro.org>
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
 target/alpha/cpu.c        | 31 +++++++------------------------
 target/alpha/gdbstub.c    |  6 ++----
 target/alpha/helper.c     | 15 +++++----------
 target/alpha/mem_helper.c | 11 +++--------
 target/alpha/translate.c  |  4 ++--
 5 files changed, 19 insertions(+), 48 deletions(-)

diff --git a/target/alpha/cpu.c b/target/alpha/cpu.c
index b8ed29e343..e21a8936c7 100644
--- a/target/alpha/cpu.c
+++ b/target/alpha/cpu.c
@@ -130,40 +130,27 @@ static ObjectClass *alpha_cpu_class_by_name(const char *cpu_model)
 
 static void ev4_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
-
-    env->implver = IMPLVER_2106x;
+    cpu_env(CPU(obj))->implver = IMPLVER_2106x;
 }
 
 static void ev5_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
-
-    env->implver = IMPLVER_21164;
+    cpu_env(CPU(obj))->implver = IMPLVER_21164;
 }
 
 static void ev56_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
-
-    env->amask |= AMASK_BWX;
+    cpu_env(CPU(obj))->amask |= AMASK_BWX;
 }
 
 static void pca56_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
-
-    env->amask |= AMASK_MVI;
+    cpu_env(CPU(obj))->amask |= AMASK_MVI;
 }
 
 static void ev6_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->implver = IMPLVER_21264;
     env->amask = AMASK_BWX | AMASK_FIX | AMASK_MVI | AMASK_TRAP;
@@ -171,16 +158,12 @@ static void ev6_cpu_initfn(Object *obj)
 
 static void ev67_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
-
-    env->amask |= AMASK_CIX | AMASK_PREFETCH;
+    cpu_env(CPU(obj))->amask |= AMASK_CIX | AMASK_PREFETCH;
 }
 
 static void alpha_cpu_initfn(Object *obj)
 {
-    AlphaCPU *cpu = ALPHA_CPU(obj);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(CPU(obj));
 
     env->lock_addr = -1;
 #if defined(CONFIG_USER_ONLY)
diff --git a/target/alpha/gdbstub.c b/target/alpha/gdbstub.c
index 0f8fa150f8..13694fd321 100644
--- a/target/alpha/gdbstub.c
+++ b/target/alpha/gdbstub.c
@@ -23,8 +23,7 @@
 
 int alpha_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     uint64_t val;
     CPU_DoubleU d;
 
@@ -59,8 +58,7 @@ int alpha_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int alpha_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     target_ulong tmp = ldtul_p(mem_buf);
     CPU_DoubleU d;
 
diff --git a/target/alpha/helper.c b/target/alpha/helper.c
index 970c869771..d6d4353edd 100644
--- a/target/alpha/helper.c
+++ b/target/alpha/helper.c
@@ -286,11 +286,10 @@ static int get_physical_address(CPUAlphaState *env, target_ulong addr,
 
 hwaddr alpha_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
     target_ulong phys;
     int prot, fail;
 
-    fail = get_physical_address(&cpu->env, addr, 0, 0, &phys, &prot);
+    fail = get_physical_address(cpu_env(cs), addr, 0, 0, &phys, &prot);
     return (fail >= 0 ? -1 : phys);
 }
 
@@ -298,8 +297,7 @@ bool alpha_cpu_tlb_fill(CPUState *cs, vaddr addr, int size,
                         MMUAccessType access_type, int mmu_idx,
                         bool probe, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     target_ulong phys;
     int prot, fail;
 
@@ -325,8 +323,7 @@ bool alpha_cpu_tlb_fill(CPUState *cs, vaddr addr, int size,
 
 void alpha_cpu_do_interrupt(CPUState *cs)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     int i = cs->exception_index;
 
     if (qemu_loglevel_mask(CPU_LOG_INT)) {
@@ -435,8 +432,7 @@ void alpha_cpu_do_interrupt(CPUState *cs)
 
 bool alpha_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     int idx = -1;
 
     /* We never take interrupts while in PALmode.  */
@@ -487,8 +483,7 @@ void alpha_cpu_dump_state(CPUState *cs, FILE *f, int flags)
         "a0",  "a1",  "a2", "a3",  "a4", "a5", "t8", "t9",
         "t10", "t11", "ra", "t12", "at", "gp", "sp"
     };
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "PC      " TARGET_FMT_lx " PS      %02x\n",
diff --git a/target/alpha/mem_helper.c b/target/alpha/mem_helper.c
index a39b52c5dd..872955f5e7 100644
--- a/target/alpha/mem_helper.c
+++ b/target/alpha/mem_helper.c
@@ -42,18 +42,14 @@ static void do_unaligned_access(CPUAlphaState *env, vaddr addr, uintptr_t retadd
 void alpha_cpu_record_sigbus(CPUState *cs, vaddr addr,
                              MMUAccessType access_type, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
-
-    do_unaligned_access(env, addr, retaddr);
+    do_unaligned_access(cpu_env(cs), addr, retaddr);
 }
 #else
 void alpha_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type,
                                    int mmu_idx, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
 
     do_unaligned_access(env, addr, retaddr);
     cs->exception_index = EXCP_UNALIGN;
@@ -67,8 +63,7 @@ void alpha_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                      int mmu_idx, MemTxAttrs attrs,
                                      MemTxResult response, uintptr_t retaddr)
 {
-    AlphaCPU *cpu = ALPHA_CPU(cs);
-    CPUAlphaState *env = &cpu->env;
+    CPUAlphaState *env = cpu_env(cs);
 
     env->trap_arg0 = addr;
     env->trap_arg1 = access_type == MMU_DATA_STORE ? 1 : 0;
diff --git a/target/alpha/translate.c b/target/alpha/translate.c
index 32333081d8..d1188194ba 100644
--- a/target/alpha/translate.c
+++ b/target/alpha/translate.c
@@ -2917,8 +2917,8 @@ static void alpha_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
 static void alpha_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
-    CPUAlphaState *env = cpu_env(cpu);
-    uint32_t insn = translator_ldl(env, &ctx->base, ctx->base.pc_next);
+    uint32_t insn = translator_ldl(cpu_env(cpu), &ctx->base,
+                                   ctx->base.pc_next);
 
     ctx->base.pc_next += 4;
     ctx->base.is_jmp = translate_one(ctx, insn);
-- 
2.41.0


