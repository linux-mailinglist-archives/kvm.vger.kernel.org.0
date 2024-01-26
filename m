Return-Path: <kvm+bounces-7231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6BE83E4A6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A05D1C22E5A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371595B20C;
	Fri, 26 Jan 2024 22:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gJFm3ySv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673625B1FE
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306758; cv=none; b=rz9Fxo7p5dr/GMRqAm7ZV1p1mPdIztl0Zza7euKj6Bfr7wM4ZjGNWsr4+XUxfABpnSjoefGPZ7lDMrIBUVT44UF+NzeKTqgcwDMcBCESy6lAB8+1nnLZReAQ0qZMV6c+4tjM/NGJfM/QyWWn48DRFgV5GA28YZ1MolKzboDtNtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306758; c=relaxed/simple;
	bh=rCfzyPukYrVt31k19Mleg+jUytppS5FO01WW6akC+Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EcI5zDEYJ+nrTCdNfTsXJJG/LI7L6c3+RpAsjUijIy+qh1MIlLNGr+Fbv2OEoOJXCrMg0g7n4s8TKf51ZpnfQ6ZfjZZd9aNq3NnnqokvXlyzbyNK9dYGoBdTqGnhD3qYqWNxCma2cA8qqnoFwNpBHpg3uht8e9MomugbFJbQMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gJFm3ySv; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-337d32cd9c1so1032029f8f.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306754; x=1706911554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipuZgxKSSCMYmTN9a5G0hBoTJ6asRo/3tdnGFrqh5Uo=;
        b=gJFm3ySvn4BeEHSqGxajaFK//qgMaPvb60te63IvQbpN0G1C04WOO0QiS19+xX1MDw
         oV+8CKrgjAPRrmcQMQxN26ZbnIIaIgihma2ob3251OBo4WO/Rhj3xXKVjdrjOdIgLpiB
         balg6ArIY0Epe2nh4RIqdXIBiTkRIHzgumUjqjhryUUpRg2BwumJqp3WBdGpG23Duljz
         5jhoO2WiHvqcnsNyk7uTRYk2A4ZsPayiomhzq3h2lufWmNpen/AztOKdiYU9q9xozapJ
         5trz//nArcqZzg+SpXjiubqXuMOpOFWnqwKGq2y5FXHnLgVQeC8t0iIymczqyUUqeCoO
         dt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306754; x=1706911554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipuZgxKSSCMYmTN9a5G0hBoTJ6asRo/3tdnGFrqh5Uo=;
        b=TMJuZaY2CA4PsrlwX+bpojPJbkYRB3YEQ7T5vmDFSuPRROCy/fes8MwZYULG1vsSBh
         umwOPoxb/F8cN65S8mhR9yQjMTj1NJ3BBvg/yWJxmB6AOHmdrGI6Zl/6bkt1yzqCSQWZ
         fy13DhQaEFKFkXGXkdW3k2EEF1KvCgxRUCTdD8bwxEIonpe6TUs65pOoSmiB2U6uAQu8
         8Dv4slvTVo3JkJMw3aW8lU8FqXQ8JjYnGTyNCtNF/bvn+q8H5f26UI4pdB2Uw8TBOecI
         g0tFWyfmEbZ2mMqUzvcQONHQ30wYlcTw0C9AJwyZUHOxSSmB7YUQubSZ4DTm8UvWcwow
         Ydcw==
X-Gm-Message-State: AOJu0Yw2XZ0YPLWe22Iqnz42f8KMq0V6mEjLGYHsnbX2jVDZ2oB5+xcL
	jE6JUxO1tjekXH5hvNe/k9GkndMRrk5z+Lc6nv/pt6rZSYg0yp1PW/dNd5zdgZc=
X-Google-Smtp-Source: AGHT+IEAl28x1dyPShH70d/SA3nkIDuAjWPco84DFuULLTSGJ98Z+IDB95EM7ahjOqBvaXpvAe5ViA==
X-Received: by 2002:adf:a388:0:b0:337:7086:b6c3 with SMTP id l8-20020adfa388000000b003377086b6c3mr232598wrb.19.1706306754727;
        Fri, 26 Jan 2024 14:05:54 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id cc8-20020a5d5c08000000b003392af92996sm1018857wrb.101.2024.01.26.14.05.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:05:54 -0800 (PST)
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
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
Subject: [PATCH v2 17/23] target/riscv: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:59 +0100
Message-ID: <20240126220407.95022-18-philmd@linaro.org>
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
 target/riscv/arch_dump.c   |  6 ++----
 target/riscv/cpu.c         | 17 +++++------------
 target/riscv/cpu_helper.c  | 14 ++++----------
 target/riscv/debug.c       |  9 +++------
 target/riscv/gdbstub.c     |  6 ++----
 target/riscv/kvm/kvm-cpu.c |  6 ++----
 target/riscv/tcg/tcg-cpu.c |  9 +++------
 target/riscv/translate.c   |  3 +--
 8 files changed, 22 insertions(+), 48 deletions(-)

diff --git a/target/riscv/arch_dump.c b/target/riscv/arch_dump.c
index 434c8a3dbb..994709647f 100644
--- a/target/riscv/arch_dump.c
+++ b/target/riscv/arch_dump.c
@@ -68,8 +68,7 @@ int riscv_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
                                int cpuid, DumpState *s)
 {
     struct riscv64_note note;
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     int ret, i = 0;
     const char name[] = "CORE";
 
@@ -137,8 +136,7 @@ int riscv_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
                                int cpuid, DumpState *s)
 {
     struct riscv32_note note;
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     int ret, i;
     const char name[] = "CORE";
 
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 8cbfc7e781..fe21393655 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -419,8 +419,7 @@ static void riscv_any_cpu_init(Object *obj)
 
 static void riscv_max_cpu_init(Object *obj)
 {
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     RISCVMXL mlx = MXL_RV64;
 
 #ifdef TARGET_RISCV32
@@ -828,8 +827,7 @@ static void riscv_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 
 static void riscv_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     if (env->xl == MXL_RV32) {
         env->pc = (int32_t)value;
@@ -840,8 +838,7 @@ static void riscv_cpu_set_pc(CPUState *cs, vaddr value)
 
 static vaddr riscv_cpu_get_pc(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     /* Match cpu_get_tb_cpu_state. */
     if (env->xl == MXL_RV32) {
@@ -853,8 +850,7 @@ static vaddr riscv_cpu_get_pc(CPUState *cs)
 static bool riscv_cpu_has_work(CPUState *cs)
 {
 #ifndef CONFIG_USER_ONLY
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     /*
      * Definition of the WFI instruction requires it to ignore the privilege
      * mode and delegation registers, but respect individual enables
@@ -1642,10 +1638,7 @@ static void rva22s64_profile_cpu_init(Object *obj)
 
 static const gchar *riscv_gdb_arch_name(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
-
-    switch (riscv_cpu_mxl(env)) {
+    switch (riscv_cpu_mxl(cpu_env(cs))) {
     case MXL_RV32:
         return "riscv:rv32";
     case MXL_RV64:
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index c7cc7eb423..9d4798b841 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -493,9 +493,7 @@ static int riscv_cpu_local_irq_pending(CPURISCVState *env)
 bool riscv_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        RISCVCPU *cpu = RISCV_CPU(cs);
-        CPURISCVState *env = &cpu->env;
-        int interruptno = riscv_cpu_local_irq_pending(env);
+        int interruptno = riscv_cpu_local_irq_pending(cpu_env(cs));
         if (interruptno >= 0) {
             cs->exception_index = RISCV_EXCP_INT_FLAG | interruptno;
             riscv_cpu_do_interrupt(cs);
@@ -1223,8 +1221,7 @@ void riscv_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                      int mmu_idx, MemTxAttrs attrs,
                                      MemTxResult response, uintptr_t retaddr)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     if (access_type == MMU_DATA_STORE) {
         cs->exception_index = RISCV_EXCP_STORE_AMO_ACCESS_FAULT;
@@ -1244,8 +1241,7 @@ void riscv_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type, int mmu_idx,
                                    uintptr_t retaddr)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     switch (access_type) {
     case MMU_INST_FETCH:
         cs->exception_index = RISCV_EXCP_INST_ADDR_MIS;
@@ -1631,9 +1627,7 @@ static target_ulong riscv_transformed_insn(CPURISCVState *env,
 void riscv_cpu_do_interrupt(CPUState *cs)
 {
 #if !defined(CONFIG_USER_ONLY)
-
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     bool write_gva = false;
     uint64_t s;
 
diff --git a/target/riscv/debug.c b/target/riscv/debug.c
index 4945d1a1f2..c8df9812be 100644
--- a/target/riscv/debug.c
+++ b/target/riscv/debug.c
@@ -757,8 +757,7 @@ target_ulong tinfo_csr_read(CPURISCVState *env)
 
 void riscv_cpu_debug_excp_handler(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     if (cs->watchpoint_hit) {
         if (cs->watchpoint_hit->flags & BP_CPU) {
@@ -773,8 +772,7 @@ void riscv_cpu_debug_excp_handler(CPUState *cs)
 
 bool riscv_cpu_debug_check_breakpoint(CPUState *cs)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     CPUBreakpoint *bp;
     target_ulong ctrl;
     target_ulong pc;
@@ -832,8 +830,7 @@ bool riscv_cpu_debug_check_breakpoint(CPUState *cs)
 
 bool riscv_cpu_debug_check_watchpoint(CPUState *cs, CPUWatchpoint *wp)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     target_ulong ctrl;
     target_ulong addr;
     int trigger_type;
diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
index 58b3ace0fe..999d815b34 100644
--- a/target/riscv/gdbstub.c
+++ b/target/riscv/gdbstub.c
@@ -49,8 +49,7 @@ static const struct TypeSize vec_lanes[] = {
 
 int riscv_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     target_ulong tmp;
 
     if (n < 32) {
@@ -75,8 +74,7 @@ int riscv_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int riscv_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     int length = 0;
     target_ulong tmp;
 
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 680a729cd8..cf0cae813b 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -171,8 +171,7 @@ static void kvm_cpu_get_misa_ext_cfg(Object *obj, Visitor *v,
 {
     KVMCPUConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->offset;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     bool value = env->misa_ext_mask & misa_bit;
 
     visit_type_bool(v, name, &value, errp);
@@ -184,8 +183,7 @@ static void kvm_cpu_set_misa_ext_cfg(Object *obj, Visitor *v,
 {
     KVMCPUConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->offset;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     bool value, host_bit;
 
     if (!visit_type_bool(v, name, &value, errp)) {
diff --git a/target/riscv/tcg/tcg-cpu.c b/target/riscv/tcg/tcg-cpu.c
index 994ca1cdf9..c7c4d9ac92 100644
--- a/target/riscv/tcg/tcg-cpu.c
+++ b/target/riscv/tcg/tcg-cpu.c
@@ -92,8 +92,7 @@ static void riscv_cpu_synchronize_from_tb(CPUState *cs,
                                           const TranslationBlock *tb)
 {
     if (!(tb_cflags(tb) & CF_PCREL)) {
-        RISCVCPU *cpu = RISCV_CPU(cs);
-        CPURISCVState *env = &cpu->env;
+        CPURISCVState *env = cpu_env(cs);
         RISCVMXL xl = FIELD_EX32(tb->flags, TB_FLAGS, XL);
 
         tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
@@ -110,8 +109,7 @@ static void riscv_restore_state_to_opc(CPUState *cs,
                                        const TranslationBlock *tb,
                                        const uint64_t *data)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     RISCVMXL xl = FIELD_EX32(tb->flags, TB_FLAGS, XL);
     target_ulong pc;
 
@@ -1030,8 +1028,7 @@ static void cpu_get_misa_ext_cfg(Object *obj, Visitor *v, const char *name,
 {
     const RISCVCPUMisaExtConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->misa_bit;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(CPU(obj));
     bool value;
 
     value = env->misa_ext & misa_bit;
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 071fbad7ef..e94fb107e0 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1265,8 +1265,7 @@ static void riscv_tr_disas_log(const DisasContextBase *dcbase,
                                CPUState *cpu, FILE *logfile)
 {
 #ifndef CONFIG_USER_ONLY
-    RISCVCPU *rvcpu = RISCV_CPU(cpu);
-    CPURISCVState *env = &rvcpu->env;
+    CPURISCVState *env = cpu_env(cpu);
 #endif
 
     fprintf(logfile, "IN: %s\n", lookup_symbol(dcbase->pc_first));
-- 
2.41.0


