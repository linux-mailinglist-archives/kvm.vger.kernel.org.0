Return-Path: <kvm+bounces-7237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1707883E4B1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C331E2869C1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392B93B1A9;
	Fri, 26 Jan 2024 22:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dhitYyLo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742AD249EC
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306798; cv=none; b=sNb+E3tcrwQt+UngWB7D9tQn0VUmrNIm/oesmRsVdfd6cAPpvJmta4EU+YB1NXIsaXpqh4OANh543vZc50YSiTJbKZDTP5bQd0zG4nvn8H+1MS2BNbiHnyyplDAY4DPLjxBFio5eShRYNEPkcVRAlk8p/T/ssLatmoLYZ+dvjds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306798; c=relaxed/simple;
	bh=Uh7QAG/HtQUsIUU24UODDO19+1gtcCEvAL7xPkfK4IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AlgDwoE6K7M2pkmcB0qIM63jNhRMF7ERKcd+y1DXXdEjwm59wVrRMMs7sR4D93aILwu5fu1VBbaFu2m5lZ0s4ue1+wS7RWgiKqvWnPb28ndsyHmRREhXV/iEVyzCrWVgegqxiazq23FskYyuR9ysp/bfSDwodfGX3rGLHo3wTzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dhitYyLo; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33ae2d80b70so30256f8f.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306795; x=1706911595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fYY/rLuA2hauAuBtrudFqwtHsgwmB3pc71dc5VwoGs=;
        b=dhitYyLoETHDWk+it+/9evOMdAjGE+9ucSMmz1QrbhwWH6z5QanizxaFBJ71C2xmD3
         sQ2fv5j/Rf1j6Inh6Brf6F6loc6BowZSG1EOBvDxSBbsEomf4kGy32RD5YORvdBiTtxL
         ie5g1UVc7tEhPye2WIyE/tj+4xGrBKhY6pBvOKJl37GqUHrJkZYI4q1DdH8i1U6ZQP19
         5BGHby7YTvmr6C/dEvcnFK0TzSod1UOSOVvSibm0CTLxbvYKefbJDiTxwh4PG2xBbqJv
         JVQebZZhYRLutQ0uPngbvrj/sqvDuk+AiY1E2ePP2uETxOp4OhrutWcoKDYy+KY6NP9H
         nxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306795; x=1706911595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fYY/rLuA2hauAuBtrudFqwtHsgwmB3pc71dc5VwoGs=;
        b=GHh9wvDU3VyOeesWP0g6cy4c00Cx1RwhhEPmG4Pn5Hfxe58ZoWgMHlen1YkZpEfhKH
         0llzW4ZBRSSspNP8CDoL3mZuvuIt/a5EQp8gCIScIGp9HZ5nyEXhh9dCCGMSUFwDEBLA
         SgS7OLlmDU4gZGrs08MqZGajpbcYt1R7waJ3keeLfald1s/nhesrZMkWj1S/KJixuhDm
         5BxBsig6yvucY94y0GUiaGoCVoyz5+5MaCybzOSKFG7ZWGW7ocp85MxtrKXJL/+hQmDN
         zx/8miulGW0sgN7o7kFmv5uRlhpZ150FQlZ+YBZ2LYgJrHvZDPCAcgWVFOMtCHj4itOD
         qhDA==
X-Gm-Message-State: AOJu0YySgBBiJVA1u6JRxNwSJq2IikABwqqGBeJJ4Z3xZjSpEtXFnewg
	Q05NnIPJTy2XMJOmzWjebYnegaSjjjX1SlyLJh/AraH9LITB0Jzyk3XP/zLCBlE=
X-Google-Smtp-Source: AGHT+IG7a7xEui69gg0qXrAz5p7Hrr1+TBmeVYWg5uEu5eOY3lm2QMdEghKBG4M/Df8L/t6sj7dohg==
X-Received: by 2002:a5d:4d11:0:b0:337:ca7a:313d with SMTP id z17-20020a5d4d11000000b00337ca7a313dmr228329wrt.10.1706306794747;
        Fri, 26 Jan 2024 14:06:34 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id r18-20020adfce92000000b00337aed83aaasm2064013wrn.92.2024.01.26.14.06.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:06:34 -0800 (PST)
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
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>
Subject: [PATCH v2 23/23] target/sparc: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:04:05 +0100
Message-ID: <20240126220407.95022-24-philmd@linaro.org>
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
 target/sparc/cpu.c          | 14 ++++----------
 target/sparc/gdbstub.c      |  3 +--
 target/sparc/int32_helper.c |  3 +--
 target/sparc/int64_helper.c |  3 +--
 target/sparc/ldst_helper.c  |  6 ++----
 target/sparc/mmu_helper.c   | 15 +++++----------
 target/sparc/translate.c    |  3 +--
 7 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/target/sparc/cpu.c b/target/sparc/cpu.c
index befa7fc4eb..a53c200d8b 100644
--- a/target/sparc/cpu.c
+++ b/target/sparc/cpu.c
@@ -83,8 +83,7 @@ static void sparc_cpu_reset_hold(Object *obj)
 static bool sparc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        SPARCCPU *cpu = SPARC_CPU(cs);
-        CPUSPARCState *env = &cpu->env;
+        CPUSPARCState *env = cpu_env(cs);
 
         if (cpu_interrupts_enabled(env) && env->interrupt_index > 0) {
             int pil = env->interrupt_index & 0xf;
@@ -613,8 +612,7 @@ static void cpu_print_cc(FILE *f, uint32_t cc)
 
 static void sparc_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int i, x;
 
     qemu_fprintf(f, "pc: " TARGET_FMT_lx "  npc: " TARGET_FMT_lx "\n", env->pc,
@@ -711,11 +709,8 @@ static void sparc_cpu_synchronize_from_tb(CPUState *cs,
 
 static bool sparc_cpu_has_work(CPUState *cs)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
-
     return (cs->interrupt_request & CPU_INTERRUPT_HARD) &&
-           cpu_interrupts_enabled(env);
+           cpu_interrupts_enabled(cpu_env(cs));
 }
 
 static char *sparc_cpu_type_name(const char *cpu_model)
@@ -749,8 +744,7 @@ static void sparc_cpu_realizefn(DeviceState *dev, Error **errp)
     CPUState *cs = CPU(dev);
     SPARCCPUClass *scc = SPARC_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
-    SPARCCPU *cpu = SPARC_CPU(dev);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
 #if defined(CONFIG_USER_ONLY)
     /* We are emulating the kernel, which will trap and emulate float128. */
diff --git a/target/sparc/gdbstub.c b/target/sparc/gdbstub.c
index a1c8fdc4d5..5257c49a0d 100644
--- a/target/sparc/gdbstub.c
+++ b/target/sparc/gdbstub.c
@@ -29,8 +29,7 @@
 
 int sparc_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
     if (n < 8) {
         /* g0..g7 */
diff --git a/target/sparc/int32_helper.c b/target/sparc/int32_helper.c
index 058dd712b5..6b7d65b031 100644
--- a/target/sparc/int32_helper.c
+++ b/target/sparc/int32_helper.c
@@ -99,8 +99,7 @@ void cpu_check_irqs(CPUSPARCState *env)
 
 void sparc_cpu_do_interrupt(CPUState *cs)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int cwp, intno = cs->exception_index;
 
     if (qemu_loglevel_mask(CPU_LOG_INT)) {
diff --git a/target/sparc/int64_helper.c b/target/sparc/int64_helper.c
index 27df9dba89..bd14c7a0db 100644
--- a/target/sparc/int64_helper.c
+++ b/target/sparc/int64_helper.c
@@ -130,8 +130,7 @@ void cpu_check_irqs(CPUSPARCState *env)
 
 void sparc_cpu_do_interrupt(CPUState *cs)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int intno = cs->exception_index;
     trap_state *tsptr;
 
diff --git a/target/sparc/ldst_helper.c b/target/sparc/ldst_helper.c
index 09066d5487..203441bfb2 100644
--- a/target/sparc/ldst_helper.c
+++ b/target/sparc/ldst_helper.c
@@ -421,8 +421,7 @@ static void sparc_raise_mmu_fault(CPUState *cs, hwaddr addr,
                                   bool is_write, bool is_exec, int is_asi,
                                   unsigned size, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     int fault_type;
 
 #ifdef DEBUG_UNASSIGNED
@@ -483,8 +482,7 @@ static void sparc_raise_mmu_fault(CPUState *cs, hwaddr addr,
                                   bool is_write, bool is_exec, int is_asi,
                                   unsigned size, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
 #ifdef DEBUG_UNASSIGNED
     printf("Unassigned mem access to " HWADDR_FMT_plx " from " TARGET_FMT_lx
diff --git a/target/sparc/mmu_helper.c b/target/sparc/mmu_helper.c
index 453498c670..a05ee22315 100644
--- a/target/sparc/mmu_helper.c
+++ b/target/sparc/mmu_helper.c
@@ -206,8 +206,7 @@ bool sparc_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                         MMUAccessType access_type, int mmu_idx,
                         bool probe, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     CPUTLBEntryFull full = {};
     target_ulong vaddr;
     int error_code = 0, access_index;
@@ -391,8 +390,7 @@ void dump_mmu(CPUSPARCState *env)
 int sparc_cpu_memory_rw_debug(CPUState *cs, vaddr address,
                               uint8_t *buf, int len, bool is_write)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     target_ulong addr = address;
     int i;
     int len1;
@@ -759,8 +757,7 @@ bool sparc_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                         MMUAccessType access_type, int mmu_idx,
                         bool probe, uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     CPUTLBEntryFull full = {};
     int error_code = 0, access_index;
 
@@ -898,8 +895,7 @@ hwaddr cpu_get_phys_page_nofault(CPUSPARCState *env, target_ulong addr,
 
 hwaddr sparc_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     hwaddr phys_addr;
     int mmu_idx = cpu_mmu_index(env, false);
 
@@ -916,8 +912,7 @@ G_NORETURN void sparc_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                               int mmu_idx,
                                               uintptr_t retaddr)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
 
 #ifdef TARGET_SPARC64
     env->dmmu.sfsr = build_sfsr(env, mmu_idx, access_type);
diff --git a/target/sparc/translate.c b/target/sparc/translate.c
index 9387299559..412b7d1b66 100644
--- a/target/sparc/translate.c
+++ b/target/sparc/translate.c
@@ -5406,8 +5406,7 @@ void sparc_restore_state_to_opc(CPUState *cs,
                                 const TranslationBlock *tb,
                                 const uint64_t *data)
 {
-    SPARCCPU *cpu = SPARC_CPU(cs);
-    CPUSPARCState *env = &cpu->env;
+    CPUSPARCState *env = cpu_env(cs);
     target_ulong pc = data[0];
     target_ulong npc = data[1];
 
-- 
2.41.0


