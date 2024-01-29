Return-Path: <kvm+bounces-7364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 294FA840C1C
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D70B1C22D03
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D8C15703F;
	Mon, 29 Jan 2024 16:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ohwannSk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09689156989
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546834; cv=none; b=kBl344BvJdbzqbVacIIEA4zDLYRPWATl9eZItENR4j3PXDCZMAl530xMNm99Mt2opqIh//KTrK6nhTix2GRZW6SSTN6+VsbgWOUofI7WGNLivSLETtfb2XhNTQ3g5lj/R8ZbMZtIl10KKQC8p4NvM8Hy5vJ8Jh0r4/SyWzZIxu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546834; c=relaxed/simple;
	bh=L03amIvNw1iPWvJsVfUiQyyFoidgYwInBD5pbA/d8NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MF6aPd1w6o/FHtnW19KDZSP1w+8qtbe6CZDxwrjLxj607GibMKSEkFyxuWM/Ecir9e9827js3ndu7tqwlonLaNyqZBnK68Pms/0aCQ0ZvcpYoZNgg5+8IsDtXt1Du+G8t/mSOvPkaYJRZ3IJrDPYyBTZTsz94FV91kpZIU0V+Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ohwannSk; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40e7e2e04f0so36475035e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546830; x=1707151630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a1GRxsPkPoYM/j9b9XVxD2Uv8+2XdiDkavqzy6v+eQw=;
        b=ohwannSkYR+jACfc8KaNMF1IIWIMFdN8YAwoS6xQ7tGPu/BsV2v8XRD4Y4N1mXOkzy
         cXh5+JMt3dwtRKlb2UPyQU9pmregFPTLg624B1xDaUe27Upbct+pWvnlUkFZR1xKEAfe
         hmcN5Bmgx3YOs7po8VePa2NXQs2vew+FJmR1iSug7cUBnkj533PbT8z1Xi4Ohvd5KG2w
         8ARhc0qDFXjp9nI4TvBg4fCOBZPzAbqC3G9uCFq0zEQPpZqtQdUm1D03surAyuOZksVZ
         Z/J4cgbykOGO2k+ezLF9EVoxnZFT/FrAhJZeCMoQGJtuEynBlje5TPwkYTvO7JpD+QR0
         ynfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546830; x=1707151630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1GRxsPkPoYM/j9b9XVxD2Uv8+2XdiDkavqzy6v+eQw=;
        b=KM3jXY1w/f9sSTVF6d6Y4pk8CgkQpwTmfJE7vKIDJhz7ZoAwCUr/Iq8HS68HwmqG8H
         CwVUsj1bNVM/gDkQscPX49Sz34nAJqTtYRuC9GMO99NhETKuiaH6d3KFn4Ad7GIQpmK/
         SMe4ZVNjJATqAFAvtFe6vHqgWP1b8nUtsBFjqvAZhPLDplzo2aZK4/HHV69LhjJMJAT2
         RC6bxZETehStj5SY8djWWDwLtr/wgvyUVZ1KMmEAhajFADmpqULXEfbo+pRIR+lV0CW2
         /mn2ZWPI49939NPYhswqXI7VrMWyeKc/HEEoV+62kV5gwja5lxiCcNeBJTpOU69M25wv
         6S3Q==
X-Gm-Message-State: AOJu0Yygy3OsvkC/ORkIlbBCBM/3oB3hignL88dqkc7mPtvcIPPPysnl
	KnqipUqdcn9+XmJEUGLU0mlApsnXfycyUyqNyrzzUcGm46VVbkTYdf28AGeTWw0=
X-Google-Smtp-Source: AGHT+IEpEpjILUE8/G6pqPee5gIH5YxC8wNTBQ4S47nuLxugvg/Jof6ItSCTwlZoBEcJKZyXSOwA2g==
X-Received: by 2002:adf:f5c7:0:b0:33a:f505:c0f3 with SMTP id k7-20020adff5c7000000b0033af505c0f3mr1122952wrp.2.1706546830355;
        Mon, 29 Jan 2024 08:47:10 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id k14-20020adff28e000000b003392172fd60sm8453319wro.51.2024.01.29.08.47.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:47:09 -0800 (PST)
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
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v3 18/29] target/mips: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:45:00 +0100
Message-ID: <20240129164514.73104-19-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/mips/cpu.c                       | 15 ++++----------
 target/mips/gdbstub.c                   |  6 ++----
 target/mips/kvm.c                       | 27 +++++++++----------------
 target/mips/sysemu/physaddr.c           |  3 +--
 target/mips/tcg/exception.c             |  3 +--
 target/mips/tcg/op_helper.c             |  8 +++-----
 target/mips/tcg/sysemu/special_helper.c |  3 +--
 target/mips/tcg/sysemu/tlb_helper.c     |  6 ++----
 target/mips/tcg/translate.c             |  3 +--
 9 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 6ced52f985..1bea76e40a 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -80,8 +80,7 @@ static void fpu_dump_state(CPUMIPSState *env, FILE *f, int flags)
 
 static void mips_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "pc=0x" TARGET_FMT_lx " HI=0x" TARGET_FMT_lx
@@ -123,9 +122,7 @@ void cpu_set_exception_base(int vp_index, target_ulong address)
 
 static void mips_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-
-    mips_env_set_pc(&cpu->env, value);
+    mips_env_set_pc(cpu_env(cs), value);
 }
 
 static vaddr mips_cpu_get_pc(CPUState *cs)
@@ -137,8 +134,7 @@ static vaddr mips_cpu_get_pc(CPUState *cs)
 
 static bool mips_cpu_has_work(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     bool has_work = false;
 
     /*
@@ -428,10 +424,7 @@ static void mips_cpu_reset_hold(Object *obj)
 
 static void mips_cpu_disas_set_info(CPUState *s, disassemble_info *info)
 {
-    MIPSCPU *cpu = MIPS_CPU(s);
-    CPUMIPSState *env = &cpu->env;
-
-    if (!(env->insn_flags & ISA_NANOMIPS32)) {
+    if (!(cpu_env(s)->insn_flags & ISA_NANOMIPS32)) {
 #if TARGET_BIG_ENDIAN
         info->print_insn = print_insn_big_mips;
 #else
diff --git a/target/mips/gdbstub.c b/target/mips/gdbstub.c
index 62d7b72407..169d47416a 100644
--- a/target/mips/gdbstub.c
+++ b/target/mips/gdbstub.c
@@ -25,8 +25,7 @@
 
 int mips_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     if (n < 32) {
         return gdb_get_regl(mem_buf, env->active_tc.gpr[n]);
@@ -78,8 +77,7 @@ int mips_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int mips_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     target_ulong tmp;
 
     tmp = ldtul_p(mem_buf);
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 15d0cf9adb..6c52e59f55 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -63,8 +63,7 @@ int kvm_arch_irqchip_create(KVMState *s)
 
 int kvm_arch_init_vcpu(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int ret = 0;
 
     qemu_add_vm_change_state_handler(kvm_mips_update_state, cs);
@@ -460,8 +459,7 @@ static inline int kvm_mips_change_one_reg(CPUState *cs, uint64_t reg_id,
  */
 static int kvm_mips_save_count(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     uint64_t count_ctl;
     int err, ret = 0;
 
@@ -502,8 +500,7 @@ static int kvm_mips_save_count(CPUState *cs)
  */
 static int kvm_mips_restore_count(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     uint64_t count_ctl;
     int err_dc, err, ret = 0;
 
@@ -590,8 +587,7 @@ static void kvm_mips_update_state(void *opaque, bool running, RunState state)
 
 static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
     unsigned int i;
 
@@ -670,8 +666,7 @@ static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
 
 static int kvm_mips_get_fpu_registers(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
     unsigned int i;
 
@@ -751,8 +746,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
 
 static int kvm_mips_put_cp0_registers(CPUState *cs, int level)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
 
     (void)level;
@@ -974,8 +968,7 @@ static int kvm_mips_put_cp0_registers(CPUState *cs, int level)
 
 static int kvm_mips_get_cp0_registers(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int err, ret = 0;
 
     err = kvm_mips_get_one_reg(cs, KVM_REG_MIPS_CP0_INDEX, &env->CP0_Index);
@@ -1181,8 +1174,7 @@ static int kvm_mips_get_cp0_registers(CPUState *cs)
 
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     struct kvm_regs regs;
     int ret;
     int i;
@@ -1217,8 +1209,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 
 int kvm_arch_get_registers(CPUState *cs)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int ret = 0;
     struct kvm_regs regs;
     int i;
diff --git a/target/mips/sysemu/physaddr.c b/target/mips/sysemu/physaddr.c
index 05990aa5bb..56380dfe6c 100644
--- a/target/mips/sysemu/physaddr.c
+++ b/target/mips/sysemu/physaddr.c
@@ -230,8 +230,7 @@ int get_physical_address(CPUMIPSState *env, hwaddr *physical,
 
 hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     hwaddr phys_addr;
     int prot;
 
diff --git a/target/mips/tcg/exception.c b/target/mips/tcg/exception.c
index da49a93912..13275d1ded 100644
--- a/target/mips/tcg/exception.c
+++ b/target/mips/tcg/exception.c
@@ -79,8 +79,7 @@ void helper_wait(CPUMIPSState *env)
 
 void mips_cpu_synchronize_from_tb(CPUState *cs, const TranslationBlock *tb)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
     env->active_tc.PC = tb->pc;
diff --git a/target/mips/tcg/op_helper.c b/target/mips/tcg/op_helper.c
index 98935b5e64..65403f1a87 100644
--- a/target/mips/tcg/op_helper.c
+++ b/target/mips/tcg/op_helper.c
@@ -279,8 +279,7 @@ void mips_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                   MMUAccessType access_type,
                                   int mmu_idx, uintptr_t retaddr)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     int error_code = 0;
     int excp;
 
@@ -306,9 +305,8 @@ void mips_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                     int mmu_idx, MemTxAttrs attrs,
                                     MemTxResult response, uintptr_t retaddr)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(cpu);
-    CPUMIPSState *env = &cpu->env;
+    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(cs);
+    CPUMIPSState *env = cpu_env(cs);
 
     if (access_type == MMU_INST_FETCH) {
         do_raise_exception(env, EXCP_IBE, retaddr);
diff --git a/target/mips/tcg/sysemu/special_helper.c b/target/mips/tcg/sysemu/special_helper.c
index 93276f789d..7934f2ea41 100644
--- a/target/mips/tcg/sysemu/special_helper.c
+++ b/target/mips/tcg/sysemu/special_helper.c
@@ -90,8 +90,7 @@ static void debug_post_eret(CPUMIPSState *env)
 
 bool mips_io_recompile_replay_branch(CPUState *cs, const TranslationBlock *tb)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     if ((env->hflags & MIPS_HFLAG_BMASK) != 0
         && !(cs->tcg_cflags & CF_PCREL) && env->active_tc.PC != tb->pc) {
diff --git a/target/mips/tcg/sysemu/tlb_helper.c b/target/mips/tcg/sysemu/tlb_helper.c
index 4ede904800..6c48c4fa80 100644
--- a/target/mips/tcg/sysemu/tlb_helper.c
+++ b/target/mips/tcg/sysemu/tlb_helper.c
@@ -910,8 +910,7 @@ bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
     hwaddr physical;
     int prot;
     int ret = TLBRET_BADADDR;
@@ -1346,8 +1345,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
 bool mips_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        MIPSCPU *cpu = MIPS_CPU(cs);
-        CPUMIPSState *env = &cpu->env;
+        CPUMIPSState *env = cpu_env(cs);
 
         if (cpu_mips_hw_interrupts_enabled(env) &&
             cpu_mips_hw_interrupts_pending(env)) {
diff --git a/target/mips/tcg/translate.c b/target/mips/tcg/translate.c
index 13e43fa3b6..e74b98de1c 100644
--- a/target/mips/tcg/translate.c
+++ b/target/mips/tcg/translate.c
@@ -15628,8 +15628,7 @@ void mips_restore_state_to_opc(CPUState *cs,
                                const TranslationBlock *tb,
                                const uint64_t *data)
 {
-    MIPSCPU *cpu = MIPS_CPU(cs);
-    CPUMIPSState *env = &cpu->env;
+    CPUMIPSState *env = cpu_env(cs);
 
     env->active_tc.PC = data[0];
     env->hflags &= ~MIPS_HFLAG_BMASK;
-- 
2.41.0


