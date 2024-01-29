Return-Path: <kvm+bounces-7354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E10BF840C04
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B639B265F7
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D5915698A;
	Mon, 29 Jan 2024 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zom0jWK9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1D715697A
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546774; cv=none; b=mycG3XG3Tko1+tJaE7oQ3vMZQgeXrxoszv4pmHNHXWN+0e6TRTepJLd0Cr45PSasDKGQ8iiVMhJG0lXprsQiNsQ/c9GfrUVOxLRHrH9bgMBjMtWb3dMSLvUHQrP4/tD7QlRJROfWe+TKB6O848aqlteucNU/R/m+ciRH2h+5VCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546774; c=relaxed/simple;
	bh=HU4+i/qYpWKt9chSsXLx3w/NvhlMfr8mM19ogSHMoDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqfB/N0MYFs8LQpCdfY218GNIICPnw889flLipHr+FKhfz3lRVaF7CjLnD4eGHTVCXu/w/1rQo1wLfkRazurh5tKgZoaik6EJcTghheQk7DRq1kUIB6mrmKzWx+3vcj1cjiIbYjz8DJxI7yf+jteHT58SuWUn68sZHUTqFldQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zom0jWK9; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2cf3a0b2355so35983811fa.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546770; x=1707151570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULT/g8UQ/ZTfsw6fPM1iTJdiFqLqeAPLwCS8P07bPHA=;
        b=Zom0jWK9Txff8fGuKOruNtYMy0BU2b8BtNaLC3z/IH6fnbo7Vovox+htnAw1qz4aJG
         WKwrr/7CbhJuS3RSPK1cvbTl/ntUyl78iRpLHqwjbEvZsJxHl6sW5LlRflBavWKuC9Qs
         RP5kR1vKALLViyMQM8oHV8PtjKuKJDDEjuW9MFmrAtgdTo+rfGzcmuF8Qpp6KCnWXlAd
         mb3B0YVYyj5tFanu8b2GwEigURBJJdmTRdWlYZ06gdEJVuOXeO+cW7x8QpGm3nger1QW
         oy+SgfpmzgYJZHvOuMAgiOwZgNw76WcWmnkuDMEA1E2pETQGrAb8wKa2a6W5bXcr1HGU
         uKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546770; x=1707151570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULT/g8UQ/ZTfsw6fPM1iTJdiFqLqeAPLwCS8P07bPHA=;
        b=DBntEOAV3c/FqyHWzOUQVv3yz8EGvZ3pfQeL9AdYw9B2kHlUyAtnonyoj6UhXJPl9V
         EEm+5Mf15mKGF/qNM19WZdDbqPgBvfabCTtrsqhISVYBDKzu/xa8diT0VpJI18xDcWIz
         vGXdgFsoiRU6SxNTSdxoIbZdmOnHxMb0TGSQmsSDVBTdps9gFCq2ae5zxDzU3BScIXJJ
         TgdsvRQvR4AqygoD1Hzo5IFYYHtRU6V3Ct1n+m4l9iEBY279Hmd+ODE7k7kbirwE0eTG
         Zl7uukUCTcj8hVXziraZ+SaUaAU75ViXa+JQkv2XXCfVswTGNaE2HBjuxKn25Zq/kshu
         8NIg==
X-Gm-Message-State: AOJu0Yzjr+rAQu15YCQksNybgrmvx64hFYe/KOMZlllkerdFg/tv3Ma8
	cEbRLs/zTs4138qUNarWCXaM7HD0Bseg+fGou2PyBbyMeBXijPRFfj+IkswE1RA=
X-Google-Smtp-Source: AGHT+IEP4UUSkCYVYnu7yKq5e9HVmSRrLQNLZdSXiqwEcOfMM8lHE3iH5My9oVWcYdTSOti8rn8rZg==
X-Received: by 2002:a2e:b8c2:0:b0:2cf:274c:caaa with SMTP id s2-20020a2eb8c2000000b002cf274ccaaamr5080107ljp.4.1706546769995;
        Mon, 29 Jan 2024 08:46:09 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id eo6-20020a056000428600b0033af5086c2dsm1068171wrb.58.2024.01.29.08.46.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:46:09 -0800 (PST)
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
	Peter Maydell <peter.maydell@linaro.org>,
	Alexander Graf <agraf@csgraf.de>
Subject: [PATCH v3 08/29] target/arm: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:50 +0100
Message-ID: <20240129164514.73104-9-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/intc/arm_gicv3_cpuif.c        |  7 ++-----
 hw/intc/arm_gicv3_cpuif_common.c |  5 +----
 target/arm/cpu.c                 | 19 +++++--------------
 target/arm/debug_helper.c        |  8 ++------
 target/arm/gdbstub.c             |  6 ++----
 target/arm/gdbstub64.c           |  6 ++----
 target/arm/helper.c              |  9 +++------
 target/arm/hvf/hvf.c             | 12 ++++--------
 target/arm/kvm.c                 |  3 +--
 target/arm/ptw.c                 |  3 +--
 target/arm/tcg/cpu32.c           |  4 +---
 target/arm/tcg/translate.c       |  3 +--
 12 files changed, 25 insertions(+), 60 deletions(-)

diff --git a/hw/intc/arm_gicv3_cpuif.c b/hw/intc/arm_gicv3_cpuif.c
index e1a60d8c15..80f64a5154 100644
--- a/hw/intc/arm_gicv3_cpuif.c
+++ b/hw/intc/arm_gicv3_cpuif.c
@@ -182,8 +182,6 @@ static int hppvi_index(GICv3CPUState *cs)
      * priority than the highest priority list register at every
      * callsite of HighestPriorityVirtualInterrupt; we check it here.)
      */
-    ARMCPU *cpu = ARM_CPU(cs->cpu);
-    CPUARMState *env = &cpu->env;
     int idx = -1;
     int i;
     /* Note that a list register entry with a priority of 0xff will
@@ -230,7 +228,7 @@ static int hppvi_index(GICv3CPUState *cs)
      * fails the priority check here. vLPIs are only considered
      * when we are in Non-Secure state.
      */
-    if (cs->hppvlpi.prio < prio && !arm_is_secure(env)) {
+    if (cs->hppvlpi.prio < prio && !arm_is_secure(cpu_env(cs->cpu))) {
         if (cs->hppvlpi.grp == GICV3_G0) {
             if (cs->ich_vmcr_el2 & ICH_VMCR_EL2_VENG0) {
                 return HPPVI_INDEX_VLPI;
@@ -931,8 +929,7 @@ void gicv3_cpuif_update(GICv3CPUState *cs)
     /* Tell the CPU about its highest priority pending interrupt */
     int irqlevel = 0;
     int fiqlevel = 0;
-    ARMCPU *cpu = ARM_CPU(cs->cpu);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs->cpu);
 
     g_assert(bql_locked());
 
diff --git a/hw/intc/arm_gicv3_cpuif_common.c b/hw/intc/arm_gicv3_cpuif_common.c
index ff1239f65d..bab3c3cdbd 100644
--- a/hw/intc/arm_gicv3_cpuif_common.c
+++ b/hw/intc/arm_gicv3_cpuif_common.c
@@ -15,8 +15,5 @@
 
 void gicv3_set_gicv3state(CPUState *cpu, GICv3CPUState *s)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
-
-    env->gicv3state = (void *)s;
+    cpu_env(cpu)->gicv3state = (void *)s;
 };
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index e5deb5195b..23f4de127f 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -53,8 +53,7 @@
 
 static void arm_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (is_a64(env)) {
         env->pc = value;
@@ -67,8 +66,7 @@ static void arm_cpu_set_pc(CPUState *cs, vaddr value)
 
 static vaddr arm_cpu_get_pc(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (is_a64(env)) {
         return env->pc;
@@ -996,19 +994,15 @@ static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
 
 static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
-
     cpu_synchronize_state(cs);
-    return arm_cpu_data_is_big_endian(env);
+    return arm_cpu_data_is_big_endian(cpu_env(cs));
 }
 
 #endif
 
 static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 {
-    ARMCPU *ac = ARM_CPU(cpu);
-    CPUARMState *env = &ac->env;
+    CPUARMState *env = cpu_env(cpu);
     bool sctlr_b;
 
     if (is_a64(env)) {
@@ -2435,10 +2429,7 @@ static Property arm_cpu_properties[] = {
 
 static const gchar *arm_gdb_arch_name(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
-
-    if (arm_feature(env, ARM_FEATURE_IWMMXT)) {
+    if (arm_feature(cpu_env(cs), ARM_FEATURE_IWMMXT)) {
         return "iwmmxt";
     }
     return "arm";
diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 7d856acddf..7bd5467414 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -468,8 +468,7 @@ void arm_debug_excp_handler(CPUState *cs)
      * Called by core code when a watchpoint or breakpoint fires;
      * need to check which one and raise the appropriate exception.
      */
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     CPUWatchpoint *wp_hit = cs->watchpoint_hit;
 
     if (wp_hit) {
@@ -757,9 +756,6 @@ void hw_breakpoint_update_all(ARMCPU *cpu)
 
 vaddr arm_adjust_watchpoint_address(CPUState *cs, vaddr addr, int len)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
-
     /*
      * In BE32 system mode, target memory is stored byteswapped (on a
      * little-endian host system), and by the time we reach here (via an
@@ -767,7 +763,7 @@ vaddr arm_adjust_watchpoint_address(CPUState *cs, vaddr addr, int len)
      * to account for that, which means that watchpoints will not match.
      * Undo the adjustment here.
      */
-    if (arm_sctlr_b(env)) {
+    if (arm_sctlr_b(cpu_env(cs))) {
         if (len == 1) {
             addr ^= 3;
         } else if (len == 2) {
diff --git a/target/arm/gdbstub.c b/target/arm/gdbstub.c
index 28f546a5ff..dc6c29669c 100644
--- a/target/arm/gdbstub.c
+++ b/target/arm/gdbstub.c
@@ -40,8 +40,7 @@ typedef struct RegisterSysregXmlParam {
 
 int arm_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (n < 16) {
         /* Core integer register.  */
@@ -61,8 +60,7 @@ int arm_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int arm_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     uint32_t tmp;
 
     tmp = ldl_p(mem_buf);
diff --git a/target/arm/gdbstub64.c b/target/arm/gdbstub64.c
index d7b79a6589..b9f29b0a60 100644
--- a/target/arm/gdbstub64.c
+++ b/target/arm/gdbstub64.c
@@ -24,8 +24,7 @@
 
 int aarch64_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (n < 31) {
         /* Core integer register.  */
@@ -45,8 +44,7 @@ int aarch64_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int aarch64_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     uint64_t tmp;
 
     tmp = ldq_p(mem_buf);
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 945d8571a6..a9d2c23df2 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10902,8 +10902,7 @@ static void arm_cpu_do_interrupt_aarch32_hyp(CPUState *cs)
      * PSTATE A/I/F masks are set based only on the SCR.EA/IRQ/FIQ values.
      */
     uint32_t addr, mask;
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     switch (cs->exception_index) {
     case EXCP_UDEF:
@@ -10981,8 +10980,7 @@ static void arm_cpu_do_interrupt_aarch32_hyp(CPUState *cs)
 
 static void arm_cpu_do_interrupt_aarch32(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     uint32_t addr;
     uint32_t mask;
     int new_mode;
@@ -11481,8 +11479,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
 #ifdef CONFIG_TCG
 static void tcg_handle_semihosting(CPUState *cs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
 
     if (is_a64(env)) {
         qemu_log_mask(CPU_LOG_INT,
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index e5f0f60093..849f0772e6 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1006,8 +1006,7 @@ void hvf_kick_vcpu_thread(CPUState *cpu)
 static void hvf_raise_exception(CPUState *cpu, uint32_t excp,
                                 uint32_t syndrome)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
 
     cpu->exception_index = excp;
     env->exception.target_el = 1;
@@ -1485,8 +1484,7 @@ static bool hvf_sysreg_write_cp(CPUState *cpu, uint32_t reg, uint64_t val)
 
 static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
 
     trace_hvf_sysreg_write(reg,
                            SYSREG_OP0(reg),
@@ -2152,8 +2150,7 @@ static void hvf_put_gdbstub_debug_registers(CPUState *cpu)
  */
 static void hvf_put_guest_debug_registers(CPUState *cpu)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
     hv_return_t r = HV_SUCCESS;
     int i;
 
@@ -2207,8 +2204,7 @@ static void hvf_arch_set_traps(void)
 
 void hvf_arch_update_guest_debug(CPUState *cpu)
 {
-    ARMCPU *arm_cpu = ARM_CPU(cpu);
-    CPUARMState *env = &arm_cpu->env;
+    CPUARMState *env = cpu_env(cpu);
 
     /* Check whether guest debugging is enabled */
     cpu->accel->guest_debug_enabled = cpu->singlestep_enabled ||
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ab85d628a8..cccb512f23 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1958,8 +1958,7 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
 /* Callers must hold the iothread mutex lock */
 static void kvm_inject_arm_sea(CPUState *c)
 {
-    ARMCPU *cpu = ARM_CPU(c);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(c);
     uint32_t esr;
     bool same_el;
 
diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 5eb3577bcd..57a761ad68 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -3528,8 +3528,7 @@ bool get_phys_addr(CPUARMState *env, target_ulong address,
 hwaddr arm_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
                                          MemTxAttrs *attrs)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
+    CPUARMState *env = cpu_env(cs);
     ARMMMUIdx mmu_idx = arm_mmu_idx(env);
     ARMSecuritySpace ss = arm_security_space(env);
     S1Translate ptw = {
diff --git a/target/arm/tcg/cpu32.c b/target/arm/tcg/cpu32.c
index d9e0e2a4dd..e96f1119c0 100644
--- a/target/arm/tcg/cpu32.c
+++ b/target/arm/tcg/cpu32.c
@@ -102,8 +102,6 @@ void aa32_max_features(ARMCPU *cpu)
 static bool arm_v7m_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     CPUClass *cc = CPU_GET_CLASS(cs);
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
     bool ret = false;
 
     /*
@@ -115,7 +113,7 @@ static bool arm_v7m_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
      * currently active exception).
      */
     if (interrupt_request & CPU_INTERRUPT_HARD
-        && (armv7m_nvic_can_take_pending_exception(env->nvic))) {
+        && (armv7m_nvic_can_take_pending_exception(cpu_env(cs)->nvic))) {
         cs->exception_index = EXCP_IRQ;
         cc->tcg_ops->do_interrupt(cs);
         ret = true;
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index b3660173d1..ab73250f04 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -9326,7 +9326,6 @@ static void arm_post_translate_insn(DisasContext *dc)
 static void arm_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
 {
     DisasContext *dc = container_of(dcbase, DisasContext, base);
-    CPUARMState *env = cpu_env(cpu);
     uint32_t pc = dc->base.pc_next;
     unsigned int insn;
 
@@ -9356,7 +9355,7 @@ static void arm_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
     }
 
     dc->pc_curr = pc;
-    insn = arm_ldl_code(env, &dc->base, pc, dc->sctlr_b);
+    insn = arm_ldl_code(cpu_env(cpu), &dc->base, pc, dc->sctlr_b);
     dc->insn = insn;
     dc->base.pc_next = pc + 4;
     disas_arm_insn(dc, insn);
-- 
2.41.0


