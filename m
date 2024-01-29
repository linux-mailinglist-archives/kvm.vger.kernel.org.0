Return-Path: <kvm+bounces-7374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6B4840C3F
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FD4C1C22D43
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6719F157053;
	Mon, 29 Jan 2024 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zVrQzIjA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E6B155A5F
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546893; cv=none; b=m9Lp5U43c4BNfF+7Ht1rfBMesS9moZrafDIt2KyVlRoMZp0sjjS0fVTeSrQSjof552MW+OrbEy1z/36VTelFSYSmjoMAI0l5fIcKAYmVSacIvWBQ1uEYvBvSW9Z/yNpsc8HE26M1pInYyW69b/OzKUqBSbm+fKoMjGwsPhmi7T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546893; c=relaxed/simple;
	bh=G2xYM8OFZLx+ZD/PIm0+f32tiE4FzDqwxRL8NyDKj1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ODZ5Sa8msr4SopA1GQL68rWvnFsbwQf43WV89TCtDptIx7UjC8Ei5mUKnLzw0UXN7IGO5Ve2c7H2NcaCmENKxiGWuD1esXsNFivrWVzC3KX15N9c+zvRfAkwZCgpXgPHUExzPQ9jiBnhxEpsaDqujz7aNwdu4jzQ3bes8TsQbsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zVrQzIjA; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5110ef21c76so2014771e87.1
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546890; x=1707151690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfR8cC6O+BWQhQkWXGdZ7PfclWjDr/hbLCsaxnqdy8k=;
        b=zVrQzIjA5I/eKZ7/SlwqdsOw/0mYkYMzd8/R6L7F060Qnw4FNIm5AyJjAFUAcDQ2a/
         WNRQYZfFPyldMmMWIELBvMK/mnrKZGtWGGNK9Z2F+sh5lPO+mc8vYxc1e16mIcGlVsWc
         ekVH2RmpsBhN0CnirePcNuAAY2DGUa5YbiIgfHu1yKS+6KqKagX1TC55zdXnpOIPocz5
         VBGYjsvDZFIFcwYp9COvtayvssscnlqzFM9YHYfm5NuroAXUWd9k0ri/yT1q5KpepyOi
         Tn3KUnuEj7FyOgigK+ZaiL/PKxKVnQVh5ebzyeT2thaiauBSZU8p1DSi5gNv+3pEEy/H
         GtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546890; x=1707151690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rfR8cC6O+BWQhQkWXGdZ7PfclWjDr/hbLCsaxnqdy8k=;
        b=ZeTx2KzDEm4VTDge6Rbud3Y9XkXc/nHNbtCf6teEdL90XrXMwcxYthPH31ajF+5VCW
         UJKF3+6aduD11C4z6eD3FkCkyvGee2LGiJvchjIZBXK0hlzpMHJ4YX4sLpul7MtXEIb4
         nfBK7vTh4bL+CDVgmWKHpipgsgz45YQ3osX3PMIslzl+EFeVO6CsCw3CLaeyICGWMAzL
         n1KlQWk84P5L0xyj9JA++P3OfqHOlJmRRmpF3gZmegaJGa8/bX85VDcrK5xB9vxKNxgZ
         r7cOq+4u5rxjDONzIbRdAqayoVIEfa7eYXBJd89TeYJYD79cW0mACzA0+cFLfLmIvrR6
         Oo4Q==
X-Gm-Message-State: AOJu0YzkaaL6nyUwsJdK9jCHVTCkM04JBtxURs+SIReNg3F22w6vKBBG
	X2hN3LwTECO/XVJwZuTXlv6z4JJLDuQGCg5I5nQ3lM6GZdopmgAM8ABQ0TdXefE=
X-Google-Smtp-Source: AGHT+IFdYBYX+YhuXRJ5ebXXB5wSuyFUDmegmoCsIRNXBDPunLZRwNY2MqJbCauv7QOv9aYvnOjo7g==
X-Received: by 2002:ac2:4e08:0:b0:510:1b81:ac2f with SMTP id e8-20020ac24e08000000b005101b81ac2fmr4708425lfr.62.1706546890079;
        Mon, 29 Jan 2024 08:48:10 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id u11-20020a056000038b00b0033aed5feea4sm3296936wrf.54.2024.01.29.08.48.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:48:09 -0800 (PST)
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
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v3 28/29] target/xtensa: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:45:10 +0100
Message-ID: <20240129164514.73104-29-philmd@linaro.org>
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
 target/xtensa/cpu.c        | 3 +--
 target/xtensa/dbg_helper.c | 3 +--
 target/xtensa/exc_helper.c | 3 +--
 target/xtensa/gdbstub.c    | 6 ++----
 target/xtensa/helper.c     | 9 +++------
 target/xtensa/translate.c  | 6 ++----
 6 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index ce044466ad..47fd7c7ca9 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -91,9 +91,8 @@ bool xtensa_abi_call0(void)
 static void xtensa_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
-    XtensaCPU *cpu = XTENSA_CPU(cs);
     XtensaCPUClass *xcc = XTENSA_CPU_GET_CLASS(obj);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     bool dfpu = xtensa_option_enabled(env->config,
                                       XTENSA_OPTION_DFP_COPROCESSOR);
 
diff --git a/target/xtensa/dbg_helper.c b/target/xtensa/dbg_helper.c
index 497dafca71..5546c82ecd 100644
--- a/target/xtensa/dbg_helper.c
+++ b/target/xtensa/dbg_helper.c
@@ -66,8 +66,7 @@ void HELPER(wsr_ibreaka)(CPUXtensaState *env, uint32_t i, uint32_t v)
 
 bool xtensa_debug_check_breakpoint(CPUState *cs)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     unsigned int i;
 
     if (xtensa_get_cintlevel(env) >= env->config->debug_level) {
diff --git a/target/xtensa/exc_helper.c b/target/xtensa/exc_helper.c
index 168419a505..0514c2c1f3 100644
--- a/target/xtensa/exc_helper.c
+++ b/target/xtensa/exc_helper.c
@@ -205,8 +205,7 @@ static void handle_interrupt(CPUXtensaState *env)
 /* Called from cpu_handle_interrupt with BQL held */
 void xtensa_cpu_do_interrupt(CPUState *cs)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
 
     if (cs->exception_index == EXC_IRQ) {
         qemu_log_mask(CPU_LOG_INT,
diff --git a/target/xtensa/gdbstub.c b/target/xtensa/gdbstub.c
index 4b3bfb7e59..4748fb6532 100644
--- a/target/xtensa/gdbstub.c
+++ b/target/xtensa/gdbstub.c
@@ -65,8 +65,7 @@ void xtensa_count_regs(const XtensaConfig *config,
 
 int xtensa_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     const XtensaGdbReg *reg = env->config->gdb_regmap.reg + n;
 #ifdef CONFIG_USER_ONLY
     int num_regs = env->config->gdb_regmap.num_core_regs;
@@ -120,8 +119,7 @@ int xtensa_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int xtensa_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     uint32_t tmp;
     const XtensaGdbReg *reg = env->config->gdb_regmap.reg + n;
 #ifdef CONFIG_USER_ONLY
diff --git a/target/xtensa/helper.c b/target/xtensa/helper.c
index a9f8907083..ca214b948a 100644
--- a/target/xtensa/helper.c
+++ b/target/xtensa/helper.c
@@ -217,8 +217,7 @@ static uint32_t check_hw_breakpoints(CPUXtensaState *env)
 
 void xtensa_breakpoint_handler(CPUState *cs)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
 
     if (cs->watchpoint_hit) {
         if (cs->watchpoint_hit->flags & BP_CPU) {
@@ -266,8 +265,7 @@ bool xtensa_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                          MMUAccessType access_type, int mmu_idx,
                          bool probe, uintptr_t retaddr)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     uint32_t paddr;
     uint32_t page_size;
     unsigned access;
@@ -297,8 +295,7 @@ void xtensa_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
                                       int mmu_idx, MemTxAttrs attrs,
                                       MemTxResult response, uintptr_t retaddr)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
 
     cpu_restore_state(cs, retaddr);
     HELPER(exception_cause_vaddr)(env, env->pc,
diff --git a/target/xtensa/translate.c b/target/xtensa/translate.c
index 87947236ca..e646e016df 100644
--- a/target/xtensa/translate.c
+++ b/target/xtensa/translate.c
@@ -1127,10 +1127,9 @@ static void xtensa_tr_init_disas_context(DisasContextBase *dcbase,
                                          CPUState *cpu)
 {
     DisasContext *dc = container_of(dcbase, DisasContext, base);
-    CPUXtensaState *env = cpu_env(cpu);
     uint32_t tb_flags = dc->base.tb->flags;
 
-    dc->config = env->config;
+    dc->config = cpu_env(cpu)->config;
     dc->pc = dc->base.pc_first;
     dc->ring = tb_flags & XTENSA_TBFLAG_RING_MASK;
     dc->cring = (tb_flags & XTENSA_TBFLAG_EXCM) ? 0 : dc->ring;
@@ -1248,8 +1247,7 @@ void gen_intermediate_code(CPUState *cpu, TranslationBlock *tb, int *max_insns,
 
 void xtensa_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    XtensaCPU *cpu = XTENSA_CPU(cs);
-    CPUXtensaState *env = &cpu->env;
+    CPUXtensaState *env = cpu_env(cs);
     xtensa_isa isa = env->config->isa;
     int i, j;
 
-- 
2.41.0


