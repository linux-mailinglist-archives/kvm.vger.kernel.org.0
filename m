Return-Path: <kvm+bounces-7368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 034C9840C22
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC86A284552
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2169A15705E;
	Mon, 29 Jan 2024 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SUyIXUcZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D7115698A
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546858; cv=none; b=FSrqFqrgkm1GSkB81YSX8DInr9AbAvRPvZILlO7LlUSx/nJCzipSA3eDmSc/o+GjDuy3FS0+fVAnA3iFoa6wNAoyjMrFRX6vdv8CreDM6HDUjG3si734IaN0Y7sec4uQ4kgV4ARGiwYyz17HPGlWka2oQVujYfG9lsC35RFaooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546858; c=relaxed/simple;
	bh=Iha+utO5KWPV74A+JBHZex2E1bgdnpQWgyhIxCyOi1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkTSzHSF5elyXQEQBjCXtC+et7bNjBZwPv+FE3DVNIW0bFVlmaJnwuR9xRrTMzvjez+YZFywmtUKTr+WMfv0SZj3gLLI0yG2wRJDDkvboR0m+yzG5TCV16HXESlA+zX/SbU+qLwbbWjpBGIAmhsrMANX1bIOYIqVrLNlTxFiej0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SUyIXUcZ; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51030ce36fbso2617533e87.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546854; x=1707151654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtM2UKcDWa3bUjKa1/TxolhJdfA7b3J+7xND4L75JJU=;
        b=SUyIXUcZ93LFYdjCV4CwBADIGZ85S+vxoMlHw4J54JfXftdoJARUxwZSbncR9PF1iJ
         nAHE/H7HqDzqvwKBgxlyp1J4doHGSN/8PiODe5igpGrLfzjZE1vjwNtIPNTgWhax5C+G
         aYgF0aASSdfq5/ZxKWvlEw81NSSvPsYcOzYE3or13D7SMNQDzJhg2mhyW4QbuZ4+IWmw
         5DXTIkMhgGUQFjKmJ5nNrXo95yuijN3HkJO2BwJlqZUDJOv5plX04wklEtFPa7rM6jXe
         Fe351QtPnT6+S4d04xgFe9pUCBWMYs+Ijw0viFWVWBpUKP/3zwxNDmsPht6Mw8ZMcb7i
         2J4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546854; x=1707151654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtM2UKcDWa3bUjKa1/TxolhJdfA7b3J+7xND4L75JJU=;
        b=GSyjDv/6oL0aaAQGVbSelQ1it92kme3XTgby8AZ8Nngl4xGSxbMbFGCRNz6VeBPkTi
         7NjTxPrDvT+yU6xq1SNlLsuxROEkIoPBYbibp/GdT+yLjuzhVIY4Pkdae9GRyl20JOOT
         Fkx/6SzlD2/NHnZJ6R8Pk5mUFIH8FFUuvxoElFyyEDQqOErAHO1yFwbrzUACxE5jV6rv
         UEi6ss3wgW8Jk3odH4H0gf/FOA/VVblVBae17nlMpaP0FOYTsK9D4J2Pp4RWCca7zD18
         xPBp5FCY7Mqax8HIbaejQj9Ur2aZhJ/5x4WhrBp3NJvH7gvHfhBbsurjNmzGGWMHoMEQ
         QvZQ==
X-Gm-Message-State: AOJu0Yw4NXNOmZ62xhWVcjLcCtXnLcy/lvOZr4s3tQmZbU+H6BSBilVW
	wZLkhopiwXqSGMExCJO8zuKV/TunuXwI21TPenSaFImfmqK7wbDzzSEdNzYlDpw=
X-Google-Smtp-Source: AGHT+IE4Nnk8wqzhVhVlw4BFmmswb5N1RNhtVzZSau56BJMoLs5xZ8Yk0RvTuatP0vg2jweuAnzoYQ==
X-Received: by 2002:a05:6512:3e19:b0:510:8cd:231b with SMTP id i25-20020a0565123e1900b0051008cd231bmr4524213lfv.21.1706546854392;
        Mon, 29 Jan 2024 08:47:34 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id he9-20020a05600c540900b0040ed1df542bsm10583977wmb.20.2024.01.29.08.47.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:47:34 -0800 (PST)
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
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
Subject: [PATCH v3 22/29] target/riscv: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:45:04 +0100
Message-ID: <20240129164514.73104-23-philmd@linaro.org>
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
 target/riscv/arch_dump.c   |  6 ++----
 target/riscv/cpu.c         | 17 +++++------------
 target/riscv/cpu_helper.c  | 17 +++++------------
 target/riscv/debug.c       |  9 +++------
 target/riscv/gdbstub.c     |  6 ++----
 target/riscv/kvm/kvm-cpu.c | 11 +++--------
 target/riscv/tcg/tcg-cpu.c | 10 +++-------
 target/riscv/translate.c   |  6 ++----
 8 files changed, 25 insertions(+), 57 deletions(-)

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
index 1bd99bc5c6..8af4f7a088 100644
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
index 791435d628..01b32a3f83 100644
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
@@ -1196,8 +1194,7 @@ static void raise_mmu_exception(CPURISCVState *env, target_ulong address,
 
 hwaddr riscv_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     hwaddr phys_addr;
     int prot;
     int mmu_idx = cpu_mmu_index(env, false);
@@ -1223,8 +1220,7 @@ void riscv_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                      int mmu_idx, MemTxAttrs attrs,
                                      MemTxResult response, uintptr_t retaddr)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
 
     if (access_type == MMU_DATA_STORE) {
         cs->exception_index = RISCV_EXCP_STORE_AMO_ACCESS_FAULT;
@@ -1244,8 +1240,7 @@ void riscv_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type, int mmu_idx,
                                    uintptr_t retaddr)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
-    CPURISCVState *env = &cpu->env;
+    CPURISCVState *env = cpu_env(cs);
     switch (access_type) {
     case MMU_INST_FETCH:
         cs->exception_index = RISCV_EXCP_INST_ADDR_MIS;
@@ -1631,9 +1626,7 @@ static target_ulong riscv_transformed_insn(CPURISCVState *env,
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
index 680a729cd8..563b371ec9 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -171,9 +171,7 @@ static void kvm_cpu_get_misa_ext_cfg(Object *obj, Visitor *v,
 {
     KVMCPUConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->offset;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
-    bool value = env->misa_ext_mask & misa_bit;
+    bool value = cpu_env(CPU(obj))->misa_ext_mask & misa_bit;
 
     visit_type_bool(v, name, &value, errp);
 }
@@ -184,15 +182,13 @@ static void kvm_cpu_set_misa_ext_cfg(Object *obj, Visitor *v,
 {
     KVMCPUConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->offset;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
     bool value, host_bit;
 
     if (!visit_type_bool(v, name, &value, errp)) {
         return;
     }
 
-    host_bit = env->misa_ext_mask & misa_bit;
+    host_bit = cpu_env(CPU(obj))->misa_ext_mask & misa_bit;
 
     if (value == host_bit) {
         return;
@@ -1583,10 +1579,9 @@ static void kvm_cpu_instance_init(CPUState *cs)
  */
 static bool kvm_cpu_realize(CPUState *cs, Error **errp)
 {
-    RISCVCPU *cpu = RISCV_CPU(cs);
     int ret;
 
-    if (riscv_has_ext(&cpu->env, RVV)) {
+    if (riscv_has_ext(cpu_env(cs), RVV)) {
         ret = prctl(PR_RISCV_V_SET_CONTROL, PR_RISCV_V_VSTATE_CTRL_ON);
         if (ret) {
             error_setg(errp, "Error in prctl PR_RISCV_V_SET_CONTROL, code: %s",
diff --git a/target/riscv/tcg/tcg-cpu.c b/target/riscv/tcg/tcg-cpu.c
index 994ca1cdf9..e0f05d898c 100644
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
 
@@ -1030,11 +1028,9 @@ static void cpu_get_misa_ext_cfg(Object *obj, Visitor *v, const char *name,
 {
     const RISCVCPUMisaExtConfig *misa_ext_cfg = opaque;
     target_ulong misa_bit = misa_ext_cfg->misa_bit;
-    RISCVCPU *cpu = RISCV_CPU(obj);
-    CPURISCVState *env = &cpu->env;
     bool value;
 
-    value = env->misa_ext & misa_bit;
+    value = cpu_env(CPU(obj))->misa_ext & misa_bit;
 
     visit_type_bool(v, name, &value, errp);
 }
diff --git a/target/riscv/translate.c b/target/riscv/translate.c
index 071fbad7ef..24db9f3882 100644
--- a/target/riscv/translate.c
+++ b/target/riscv/translate.c
@@ -1074,9 +1074,8 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
     CPUState *cpu = ctx->cs;
-    CPURISCVState *env = cpu_env(cpu);
 
-    return cpu_ldl_code(env, pc);
+    return cpu_ldl_code(cpu_env(cpu), pc);
 }
 
 /* Include insn module translation function */
@@ -1265,8 +1264,7 @@ static void riscv_tr_disas_log(const DisasContextBase *dcbase,
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


