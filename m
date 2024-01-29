Return-Path: <kvm+bounces-7352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D4A840C02
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:46:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A78BA28818B
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0624C156989;
	Mon, 29 Jan 2024 16:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pp3Ec0Yh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45B0153BCE
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546763; cv=none; b=BYCnk10Sowdfpo4TEzleyUSpIbl3wG16/loWramX7Bwo3fWxP3Sv/MDJFTxOxAXs1tVplliswTcJN1qVn/UqdKTbQEBlz1sKvZYxYzekz1TvN5+hTtgrMncVN1Jtc1KF3wDkXWUvWbhFjTtlCvMFo6hKuSwtl0gKBEP5Z06stV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546763; c=relaxed/simple;
	bh=e3ZYkRniIS9tVtUi9St71+z2u/FM0q+jPMYsJO6LbTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVHBQyMRLH3U+Lheysdd3qTEFKpJ5CrMNKOsLH4JTscJ9z9UdS4hUwBhaZ1pWgP43gEwzVoCtDuPRN6by/BPmrxp62mtOTLe1TO5n9DYtRBJuKy3/GflP6B6rwXQnLHEILL1rw91ZAPvA/FnmbywnYAjWuWuiwcUkAn/XILm3Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pp3Ec0Yh; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-33ae38df9d2so1708866f8f.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546758; x=1707151558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToHK+HKGdiJp+sEUEXA9pvpmoAbDWVbOtuhkHM5nAUs=;
        b=Pp3Ec0YhhkUlo697Qc4Ov4imDyl2EabKF07+3DuAtpYuCbkpL3zEc7ViDEz616zANV
         G1Jk7WUZoC8EFIvP399JvEdYAcDvaHj2Hioy/2NzIwlNKw5CZoszkJzK7HYR3sG+nwyW
         pC9YLeJR+x/Xc8Ta24SJkkKg6Qexm+zmSCTNNZ3tVl24H4gyqgYJnHIoP9Xb41w4XpVk
         7nNG4tK+JqAfhOVg7F45wHE4ruzhCEuDpyATkeCLjE1cDJwKH/WBdnNzU2C3jvjxzwRG
         jBQ23bKAfbm46Iv54uL3iS30dfS4GGE93ZQbyy48CH/Pi+uzhoDuprn4Ukxy/JO4fLBC
         LE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546758; x=1707151558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToHK+HKGdiJp+sEUEXA9pvpmoAbDWVbOtuhkHM5nAUs=;
        b=Mw69dOsmxLb4VaB9yztI8aXTohlC8dchM9Af2d3eJMa6iEDJ7T8fEEyoCldThe6Tic
         m/HEtKnQnPEuvmDgbYCaXy4BeELyL8HKpvnbstQSM63fppchC3Zj/cQdvP9PSjRZ5olo
         oZUOn0rlr1KfquDo8G1KFicQ3TIM/QeQPPUcLb03z2AykUGEK4xIfTkM7b1C2kMfST87
         zUY8CVRr/B5UztOjSm/LYpTjf1gNpOJkKqImyVEASfxjLV5yAPp7YxtcZFCjDkMmzYdk
         Asaw5EqtW6WpLXbzIapnZqU0tnxrtOIb7FqCjjCTrN0CZCDcdRZ+V2rn3ngKKZ7a8fM+
         EMEg==
X-Gm-Message-State: AOJu0Yw49sYocz2kfR1jXPkvikdvTbDLRoj4J2jvupS9BJLADrGRnTJu
	JkX5nkwI5HLfpYolC1k73Qf8Tk0woobF3x7/FhE4/BVHjHIWmS7I8xuhsZH279I=
X-Google-Smtp-Source: AGHT+IF61qD8G7s4vfL0JnXU60CJz7kqXB9Iq6Bv8jWrWEKI1XEtYhFyxmEQuvkuzF+s/E0uz/WcNg==
X-Received: by 2002:a05:6000:1888:b0:33a:f172:9a43 with SMTP id a8-20020a056000188800b0033af1729a43mr2206152wri.47.1706546758111;
        Mon, 29 Jan 2024 08:45:58 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id fa1-20020a056000258100b0033af5716a7fsm815673wrb.61.2024.01.29.08.45.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:45:57 -0800 (PST)
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
	Michael Rolnik <mrolnik@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Brian Cain <bcain@quicinc.com>,
	Song Gao <gaosong@loongson.cn>,
	Laurent Vivier <laurent@vivier.eu>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	Chris Wulff <crwulff@gmail.com>,
	Marek Vasut <marex@denx.de>,
	Stafford Horne <shorne@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v3 06/29] target: Replace CPU_GET_CLASS(cpu -> obj) in cpu_reset_hold() handler
Date: Mon, 29 Jan 2024 17:44:48 +0100
Message-ID: <20240129164514.73104-7-philmd@linaro.org>
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

Since CPU() macro is a simple cast, the following are equivalent:

  Object *obj;
  CPUState *cs = CPU(obj)

In order to ease static analysis when running
scripts/coccinelle/cpu_env.cocci from the previous commit,
replace:

 - CPU_GET_CLASS(cpu);
 + CPU_GET_CLASS(obj);

Most code use the 'cs' variable name for CPUState handle.
Replace few 's' -> 'cs' to unify cpu_reset_hold() style.

No logical change in this patch.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.c        | 14 +++++++-------
 target/avr/cpu.c        |  2 +-
 target/cris/cpu.c       |  2 +-
 target/hexagon/cpu.c    |  2 +-
 target/i386/cpu.c       | 14 +++++++-------
 target/loongarch/cpu.c  |  2 +-
 target/m68k/cpu.c       |  6 +++---
 target/microblaze/cpu.c |  6 +++---
 target/mips/cpu.c       |  2 +-
 target/nios2/cpu.c      |  2 +-
 target/openrisc/cpu.c   |  8 ++++----
 target/ppc/cpu_init.c   | 12 ++++++------
 target/riscv/cpu.c      |  2 +-
 target/rx/cpu.c         |  2 +-
 target/sh4/cpu.c        |  6 +++---
 target/sparc/cpu.c      |  6 +++---
 target/tricore/cpu.c    |  6 +++---
 target/xtensa/cpu.c     |  8 ++++----
 18 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 60ab8f3242..e5deb5195b 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -209,9 +209,9 @@ static void cp_reg_check_reset(gpointer key, gpointer value,  gpointer opaque)
 
 static void arm_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    ARMCPU *cpu = ARM_CPU(s);
-    ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    ARMCPU *cpu = ARM_CPU(cs);
+    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
     CPUARMState *env = &cpu->env;
 
     if (acc->parent_phases.hold) {
@@ -228,7 +228,7 @@ static void arm_cpu_reset_hold(Object *obj)
     env->vfp.xregs[ARM_VFP_MVFR1] = cpu->isar.mvfr1;
     env->vfp.xregs[ARM_VFP_MVFR2] = cpu->isar.mvfr2;
 
-    cpu->power_state = s->start_powered_off ? PSCI_OFF : PSCI_ON;
+    cpu->power_state = cs->start_powered_off ? PSCI_OFF : PSCI_ON;
 
     if (arm_feature(env, ARM_FEATURE_IWMMXT)) {
         env->iwmmxt.cregs[ARM_IWMMXT_wCID] = 0x69051000 | 'Q';
@@ -433,7 +433,7 @@ static void arm_cpu_reset_hold(Object *obj)
 
         /* Load the initial SP and PC from offset 0 and 4 in the vector table */
         vecbase = env->v7m.vecbase[env->v7m.secure];
-        rom = rom_ptr_for_as(s->as, vecbase, 8);
+        rom = rom_ptr_for_as(cs->as, vecbase, 8);
         if (rom) {
             /* Address zero is covered by ROM which hasn't yet been
              * copied into physical memory.
@@ -446,8 +446,8 @@ static void arm_cpu_reset_hold(Object *obj)
              * it got copied into memory. In the latter case, rom_ptr
              * will return a NULL pointer and we should use ldl_phys instead.
              */
-            initial_msp = ldl_phys(s->as, vecbase);
-            initial_pc = ldl_phys(s->as, vecbase + 4);
+            initial_msp = ldl_phys(cs->as, vecbase);
+            initial_pc = ldl_phys(cs->as, vecbase + 4);
         }
 
         qemu_log_mask(CPU_LOG_INT,
diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index f5cbdc4a8c..0f191a4c9d 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -74,7 +74,7 @@ static void avr_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
     AVRCPU *cpu = AVR_CPU(cs);
-    AVRCPUClass *mcc = AVR_CPU_GET_CLASS(cpu);
+    AVRCPUClass *mcc = AVR_CPU_GET_CLASS(obj);
     CPUAVRState *env = &cpu->env;
 
     if (mcc->parent_phases.hold) {
diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index 9ba08e8b0c..4187e0ef3c 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -60,7 +60,7 @@ static void cris_cpu_reset_hold(Object *obj)
 {
     CPUState *s = CPU(obj);
     CRISCPU *cpu = CRIS_CPU(s);
-    CRISCPUClass *ccc = CRIS_CPU_GET_CLASS(cpu);
+    CRISCPUClass *ccc = CRIS_CPU_GET_CLASS(obj);
     CPUCRISState *env = &cpu->env;
     uint32_t vr;
 
diff --git a/target/hexagon/cpu.c b/target/hexagon/cpu.c
index c0cd739e15..085d6c0115 100644
--- a/target/hexagon/cpu.c
+++ b/target/hexagon/cpu.c
@@ -289,7 +289,7 @@ static void hexagon_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
     HexagonCPU *cpu = HEXAGON_CPU(cs);
-    HexagonCPUClass *mcc = HEXAGON_CPU_GET_CLASS(cpu);
+    HexagonCPUClass *mcc = HEXAGON_CPU_GET_CLASS(obj);
     CPUHexagonState *env = &cpu->env;
 
     if (mcc->parent_phases.hold) {
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 03822d9ba8..66345c204a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6690,9 +6690,9 @@ static void x86_cpu_set_sgxlepubkeyhash(CPUX86State *env)
 
 static void x86_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    X86CPU *cpu = X86_CPU(s);
-    X86CPUClass *xcc = X86_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    X86CPU *cpu = X86_CPU(cs);
+    X86CPUClass *xcc = X86_CPU_GET_CLASS(obj);
     CPUX86State *env = &cpu->env;
     target_ulong cr4;
     uint64_t xcr0;
@@ -6780,8 +6780,8 @@ static void x86_cpu_reset_hold(Object *obj)
     memset(env->dr, 0, sizeof(env->dr));
     env->dr[6] = DR6_FIXED_1;
     env->dr[7] = DR7_FIXED_1;
-    cpu_breakpoint_remove_all(s, BP_CPU);
-    cpu_watchpoint_remove_all(s, BP_CPU);
+    cpu_breakpoint_remove_all(cs, BP_CPU);
+    cpu_watchpoint_remove_all(cs, BP_CPU);
 
     cr4 = 0;
     xcr0 = XSTATE_FP_MASK;
@@ -6832,9 +6832,9 @@ static void x86_cpu_reset_hold(Object *obj)
     env->triple_fault_pending = false;
 #if !defined(CONFIG_USER_ONLY)
     /* We hard-wire the BSP to the first CPU. */
-    apic_designate_bsp(cpu->apic_state, s->cpu_index == 0);
+    apic_designate_bsp(cpu->apic_state, cs->cpu_index == 0);
 
-    s->halted = !cpu_is_bsp(cpu);
+    cs->halted = !cpu_is_bsp(cpu);
 
     if (kvm_enabled()) {
         kvm_arch_reset_vcpu(cpu);
diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index 064540397d..3094bbc0d9 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -500,7 +500,7 @@ static void loongarch_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
     LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    LoongArchCPUClass *lacc = LOONGARCH_CPU_GET_CLASS(cpu);
+    LoongArchCPUClass *lacc = LOONGARCH_CPU_GET_CLASS(obj);
     CPULoongArchState *env = &cpu->env;
 
     if (lacc->parent_phases.hold) {
diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index 1421e77c2c..4d14d04c33 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -68,9 +68,9 @@ static void m68k_unset_feature(CPUM68KState *env, int feature)
 
 static void m68k_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    M68kCPU *cpu = M68K_CPU(s);
-    M68kCPUClass *mcc = M68K_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    M68kCPU *cpu = M68K_CPU(cs);
+    M68kCPUClass *mcc = M68K_CPU_GET_CLASS(obj);
     CPUM68KState *env = &cpu->env;
     floatx80 nan = floatx80_default_nan(NULL);
     int i;
diff --git a/target/microblaze/cpu.c b/target/microblaze/cpu.c
index bbb3335cad..6d4b7c2c8f 100644
--- a/target/microblaze/cpu.c
+++ b/target/microblaze/cpu.c
@@ -167,9 +167,9 @@ static void microblaze_cpu_set_irq(void *opaque, int irq, int level)
 
 static void mb_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    MicroBlazeCPU *cpu = MICROBLAZE_CPU(s);
-    MicroBlazeCPUClass *mcc = MICROBLAZE_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
+    MicroBlazeCPUClass *mcc = MICROBLAZE_CPU_GET_CLASS(obj);
     CPUMBState *env = &cpu->env;
 
     if (mcc->parent_phases.hold) {
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index a0023edd43..6ced52f985 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -188,7 +188,7 @@ static void mips_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
     MIPSCPU *cpu = MIPS_CPU(cs);
-    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(cpu);
+    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(obj);
     CPUMIPSState *env = &cpu->env;
 
     if (mcc->parent_phases.hold) {
diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index a27732bf2b..09b122e24d 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -61,7 +61,7 @@ static void nios2_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
     Nios2CPU *cpu = NIOS2_CPU(cs);
-    Nios2CPUClass *ncc = NIOS2_CPU_GET_CLASS(cpu);
+    Nios2CPUClass *ncc = NIOS2_CPU_GET_CLASS(obj);
     CPUNios2State *env = &cpu->env;
 
     if (ncc->parent_phases.hold) {
diff --git a/target/openrisc/cpu.c b/target/openrisc/cpu.c
index 381ebe00d3..0fdadf9e55 100644
--- a/target/openrisc/cpu.c
+++ b/target/openrisc/cpu.c
@@ -75,9 +75,9 @@ static void openrisc_disas_set_info(CPUState *cpu, disassemble_info *info)
 
 static void openrisc_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    OpenRISCCPU *cpu = OPENRISC_CPU(s);
-    OpenRISCCPUClass *occ = OPENRISC_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
+    OpenRISCCPUClass *occ = OPENRISC_CPU_GET_CLASS(obj);
 
     if (occ->parent_phases.hold) {
         occ->parent_phases.hold(obj);
@@ -88,7 +88,7 @@ static void openrisc_cpu_reset_hold(Object *obj)
     cpu->env.pc = 0x100;
     cpu->env.sr = SR_FO | SR_SM;
     cpu->env.lock_addr = -1;
-    s->exception_index = -1;
+    cs->exception_index = -1;
     cpu_set_fpcsr(&cpu->env, 0);
 
     set_float_detect_tininess(float_tininess_before_rounding,
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 344196a8ce..61b8495a90 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -7107,9 +7107,9 @@ static bool ppc_cpu_has_work(CPUState *cs)
 
 static void ppc_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    PowerPCCPU *cpu = POWERPC_CPU(s);
-    PowerPCCPUClass *pcc = POWERPC_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    PowerPCCPU *cpu = POWERPC_CPU(cs);
+    PowerPCCPUClass *pcc = POWERPC_CPU_GET_CLASS(obj);
     CPUPPCState *env = &cpu->env;
     target_ulong msr;
     int i;
@@ -7158,8 +7158,8 @@ static void ppc_cpu_reset_hold(Object *obj)
     env->nip = env->hreset_vector | env->excp_prefix;
 
     if (tcg_enabled()) {
-        cpu_breakpoint_remove_all(s, BP_CPU);
-        cpu_watchpoint_remove_all(s, BP_CPU);
+        cpu_breakpoint_remove_all(cs, BP_CPU);
+        cpu_watchpoint_remove_all(cs, BP_CPU);
         if (env->mmu_model != POWERPC_MMU_REAL) {
             ppc_tlb_invalidate_all(env);
         }
@@ -7173,7 +7173,7 @@ static void ppc_cpu_reset_hold(Object *obj)
     env->reserve_addr = (target_ulong)-1ULL;
     /* Be sure no exception or interrupt is pending */
     env->pending_interrupts = 0;
-    s->exception_index = POWERPC_EXCP_NONE;
+    cs->exception_index = POWERPC_EXCP_NONE;
     env->error_code = 0;
     ppc_irq_reset(cpu);
 
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 8cbfc7e781..1bd99bc5c6 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -875,7 +875,7 @@ static void riscv_cpu_reset_hold(Object *obj)
 #endif
     CPUState *cs = CPU(obj);
     RISCVCPU *cpu = RISCV_CPU(cs);
-    RISCVCPUClass *mcc = RISCV_CPU_GET_CLASS(cpu);
+    RISCVCPUClass *mcc = RISCV_CPU_GET_CLASS(obj);
     CPURISCVState *env = &cpu->env;
 
     if (mcc->parent_phases.hold) {
diff --git a/target/rx/cpu.c b/target/rx/cpu.c
index c5ffeffe32..58ca26184d 100644
--- a/target/rx/cpu.c
+++ b/target/rx/cpu.c
@@ -67,7 +67,7 @@ static bool rx_cpu_has_work(CPUState *cs)
 static void rx_cpu_reset_hold(Object *obj)
 {
     RXCPU *cpu = RX_CPU(obj);
-    RXCPUClass *rcc = RX_CPU_GET_CLASS(cpu);
+    RXCPUClass *rcc = RX_CPU_GET_CLASS(obj);
     CPURXState *env = &cpu->env;
     uint32_t *resetvec;
 
diff --git a/target/sh4/cpu.c b/target/sh4/cpu.c
index 806a0ef875..1b03c7bcb1 100644
--- a/target/sh4/cpu.c
+++ b/target/sh4/cpu.c
@@ -91,9 +91,9 @@ static bool superh_cpu_has_work(CPUState *cs)
 
 static void superh_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    SuperHCPU *cpu = SUPERH_CPU(s);
-    SuperHCPUClass *scc = SUPERH_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    SuperHCPU *cpu = SUPERH_CPU(cs);
+    SuperHCPUClass *scc = SUPERH_CPU_GET_CLASS(obj);
     CPUSH4State *env = &cpu->env;
 
     if (scc->parent_phases.hold) {
diff --git a/target/sparc/cpu.c b/target/sparc/cpu.c
index befa7fc4eb..152bee4f81 100644
--- a/target/sparc/cpu.c
+++ b/target/sparc/cpu.c
@@ -31,9 +31,9 @@
 
 static void sparc_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    SPARCCPU *cpu = SPARC_CPU(s);
-    SPARCCPUClass *scc = SPARC_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    SPARCCPU *cpu = SPARC_CPU(cs);
+    SPARCCPUClass *scc = SPARC_CPU_GET_CLASS(obj);
     CPUSPARCState *env = &cpu->env;
 
     if (scc->parent_phases.hold) {
diff --git a/target/tricore/cpu.c b/target/tricore/cpu.c
index 8acacdf0c0..9bdaa1593a 100644
--- a/target/tricore/cpu.c
+++ b/target/tricore/cpu.c
@@ -72,9 +72,9 @@ static void tricore_restore_state_to_opc(CPUState *cs,
 
 static void tricore_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    TriCoreCPU *cpu = TRICORE_CPU(s);
-    TriCoreCPUClass *tcc = TRICORE_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    TriCoreCPU *cpu = TRICORE_CPU(cs);
+    TriCoreCPUClass *tcc = TRICORE_CPU_GET_CLASS(obj);
     CPUTriCoreState *env = &cpu->env;
 
     if (tcc->parent_phases.hold) {
diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index 99c0ca130f..ce044466ad 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -90,9 +90,9 @@ bool xtensa_abi_call0(void)
 
 static void xtensa_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    XtensaCPU *cpu = XTENSA_CPU(s);
-    XtensaCPUClass *xcc = XTENSA_CPU_GET_CLASS(cpu);
+    CPUState *cs = CPU(obj);
+    XtensaCPU *cpu = XTENSA_CPU(cs);
+    XtensaCPUClass *xcc = XTENSA_CPU_GET_CLASS(obj);
     CPUXtensaState *env = &cpu->env;
     bool dfpu = xtensa_option_enabled(env->config,
                                       XTENSA_OPTION_DFP_COPROCESSOR);
@@ -127,7 +127,7 @@ static void xtensa_cpu_reset_hold(Object *obj)
 
 #ifndef CONFIG_USER_ONLY
     reset_mmu(env);
-    s->halted = env->runstall;
+    cs->halted = env->runstall;
 #endif
     set_no_signaling_nans(!dfpu, &env->fp_status);
     set_use_first_nan(!dfpu, &env->fp_status);
-- 
2.41.0


