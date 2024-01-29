Return-Path: <kvm+bounces-7361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A964840C10
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:47:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00526283890
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6392157028;
	Mon, 29 Jan 2024 16:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qtU8vnch"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2354F153BCE
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546816; cv=none; b=O0/AbkVr+lNcfTGTaOr8VEyfY5YAwh9OZ9YCpXGIVdDkftaZ4oihJIz9f+VXNkzv3CjMBYs1q8RsfWjnUJLTj73v6Dfkoukg2NfU06gDl3g9VWR/l6o3m9PNGBPjZG1PwBS5KX9odYa+hgrt+u7xZDcHC0lHQFPIVfzePSHCl6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546816; c=relaxed/simple;
	bh=E0lq5HDrgcO9BPm9UCqsmp6kEsEyVobAtoeZPpAfCUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NT3pfJUkFwwvj2A6Tq5w4hLP6pFxUACB7MZCwQt0/HJSfIR7f/1Z7g2cOFCS1egM8AL0Cz1W86H3ZDigcPdP2NousbMDZcIx2Ev/RN+R/Qew0YsZK9VuhgsfzKGctKiNK8uKNPvc3g6nLIXPW9qONv+D15pIljMMi6MQDT/Qf7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qtU8vnch; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40ef6c471d5so10103635e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546812; x=1707151612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5eD6rKTwh3BPZg727azmGQxnUXfJqHRnwiaNdsPFdAo=;
        b=qtU8vnchFoNC/Do1QKYzN4EuGnPpzNPfQDF0w4IwOoLnfiWiHk2TL3HLveYJ7Cteu0
         MlaS3nLUJZ8TQI8phNzsuRBkD44rlmFqlhs3ufRhOWgVSsOPVY78+O/ymGMCdVrg9X3n
         n78y6D765l3cLwgD5ZhM5udXpAphgCYEilYsdND+yuwSBv1tkfmyku+W4LNTEOnSKcYM
         A7ymFXhzd82PiTUkh/pCg+I+1fVtauT9jFgXmdagli/ad0FvTAJ27CHPeObh+A71D6b5
         AcK9bSmxUZ2N8P9LTsCDrpnT/ja/EK/WfA3kIcSvO2fgfbRPj5kXCr2RQqz4oOaEpQPS
         xy7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546812; x=1707151612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5eD6rKTwh3BPZg727azmGQxnUXfJqHRnwiaNdsPFdAo=;
        b=AXsPnbyoQhmbxi+g1LKbE8LguvYA4jO0qBIvNZLFcnS4W/9A+n2JOh5DeEhQOvgEbY
         1WRz+pg3cOuamEOE5/RCHiUP83e7q8k55dzwpHLJucL+7RUs9BEnEuWX4FOKbqY2WdTa
         XZHUE868dhr9ox0kP8IncjYeQ7XWOGBg8VtNU+NOPUVBP8wBESr+1uFlLblaCPDRSDVk
         5zwhD7AfuH9xWJzsHloqRPKLRR+qp/1bp3BJ+ysvBcBJ81CGenakAhQqlur09Z7SkXaB
         7hNKt8YbpMUwPAxe7YvM8c9qCxS/G/OizvoWCmXu9uJwjePFn8lGcRCzNFT8uV+XeJCX
         5SMw==
X-Gm-Message-State: AOJu0YwIpjGaYM9LRUPeohtnQSLEhKuqwIxMOD2LIhjreWhivEpTxc9s
	BoFo9gZ7H/W51nY/TbXGmyF2qytmaR4lUcX12FP7eIJ3/aiXdv931o4u8ysM+GY=
X-Google-Smtp-Source: AGHT+IHBLDlJBXdJdBjv54vRycwUyR6fXctiBoUoT2EH8P3suLNCBO+YYLhkJyYaixVb8cTSMM0ujw==
X-Received: by 2002:a5d:4988:0:b0:33a:e544:eccb with SMTP id r8-20020a5d4988000000b0033ae544eccbmr3934226wrq.1.1706546812465;
        Mon, 29 Jan 2024 08:46:52 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d5291000000b00337d980a68asm6158372wrv.106.2024.01.29.08.46.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:46:51 -0800 (PST)
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
	Song Gao <gaosong@loongson.cn>
Subject: [PATCH v3 15/29] target/loongarch: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:57 +0100
Message-ID: <20240129164514.73104-16-philmd@linaro.org>
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
 target/loongarch/cpu.c            | 39 ++++++++---------------------
 target/loongarch/gdbstub.c        |  6 ++---
 target/loongarch/kvm/kvm.c        | 41 +++++++++----------------------
 target/loongarch/tcg/tlb_helper.c |  6 ++---
 4 files changed, 26 insertions(+), 66 deletions(-)

diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index 3094bbc0d9..d1c907b2a7 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -91,18 +91,12 @@ void G_NORETURN do_raise_exception(CPULoongArchState *env,
 
 static void loongarch_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
-
-    set_pc(env, value);
+    set_pc(cpu_env(cs), value);
 }
 
 static vaddr loongarch_cpu_get_pc(CPUState *cs)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
-
-    return env->pc;
+    return cpu_env(cs)->pc;
 }
 
 #ifndef CONFIG_USER_ONLY
@@ -157,8 +151,7 @@ static inline bool cpu_loongarch_hw_interrupts_pending(CPULoongArchState *env)
 #ifndef CONFIG_USER_ONLY
 static void loongarch_cpu_do_interrupt(CPUState *cs)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     bool update_badinstr = 1;
     int cause = -1;
     const char *name;
@@ -308,8 +301,7 @@ static void loongarch_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
                                                 MemTxResult response,
                                                 uintptr_t retaddr)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     if (access_type == MMU_INST_FETCH) {
         do_raise_exception(env, EXCCODE_ADEF, retaddr);
@@ -321,8 +313,7 @@ static void loongarch_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
 static bool loongarch_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-        CPULoongArchState *env = &cpu->env;
+        CPULoongArchState *env = cpu_env(cs);
 
         if (cpu_loongarch_hw_interrupts_enabled(env) &&
             cpu_loongarch_hw_interrupts_pending(env)) {
@@ -339,21 +330,15 @@ static bool loongarch_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 static void loongarch_cpu_synchronize_from_tb(CPUState *cs,
                                               const TranslationBlock *tb)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
-
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
-    set_pc(env, tb->pc);
+    set_pc(cpu_env(cs), tb->pc);
 }
 
 static void loongarch_restore_state_to_opc(CPUState *cs,
                                            const TranslationBlock *tb,
                                            const uint64_t *data)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
-
-    set_pc(env, data[0]);
+    set_pc(cpu_env(cs), data[0]);
 }
 #endif /* CONFIG_TCG */
 
@@ -362,12 +347,10 @@ static bool loongarch_cpu_has_work(CPUState *cs)
 #ifdef CONFIG_USER_ONLY
     return true;
 #else
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
     bool has_work = false;
 
     if ((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
-        cpu_loongarch_hw_interrupts_pending(env)) {
+        cpu_loongarch_hw_interrupts_pending(cpu_env(cs))) {
         has_work = true;
     }
 
@@ -499,9 +482,8 @@ static void loongarch_max_initfn(Object *obj)
 static void loongarch_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
     LoongArchCPUClass *lacc = LOONGARCH_CPU_GET_CLASS(obj);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     if (lacc->parent_phases.hold) {
         lacc->parent_phases.hold(obj);
@@ -684,8 +666,7 @@ static ObjectClass *loongarch_cpu_class_by_name(const char *cpu_model)
 
 void loongarch_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, " PC=%016" PRIx64 " ", env->pc);
diff --git a/target/loongarch/gdbstub.c b/target/loongarch/gdbstub.c
index 5fc2f19e96..91a16183b0 100644
--- a/target/loongarch/gdbstub.c
+++ b/target/loongarch/gdbstub.c
@@ -33,8 +33,7 @@ void write_fcc(CPULoongArchState *env, uint64_t val)
 
 int loongarch_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     uint64_t val;
 
     if (0 <= n && n < 32) {
@@ -60,8 +59,7 @@ int loongarch_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int loongarch_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     target_ulong tmp;
     int read_length;
     int length = 0;
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index c19978a970..df5e199860 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -38,8 +38,7 @@ static int kvm_loongarch_get_regs_core(CPUState *cs)
     int ret = 0;
     int i;
     struct kvm_regs regs;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     /* Get the current register set as KVM seems it */
     ret = kvm_vcpu_ioctl(cs, KVM_GET_REGS, &regs);
@@ -62,8 +61,7 @@ static int kvm_loongarch_put_regs_core(CPUState *cs)
     int ret = 0;
     int i;
     struct kvm_regs regs;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     /* Set the registers based on QEMU's view of things */
     for (i = 0; i < 32; i++) {
@@ -82,8 +80,7 @@ static int kvm_loongarch_put_regs_core(CPUState *cs)
 static int kvm_loongarch_get_csr(CPUState *cs)
 {
     int ret = 0;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     ret |= kvm_get_one_reg(cs, KVM_IOC_CSRID(LOONGARCH_CSR_CRMD),
                            &env->CSR_CRMD);
@@ -253,8 +250,7 @@ static int kvm_loongarch_get_csr(CPUState *cs)
 static int kvm_loongarch_put_csr(CPUState *cs, int level)
 {
     int ret = 0;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     ret |= kvm_set_one_reg(cs, KVM_IOC_CSRID(LOONGARCH_CSR_CRMD),
                            &env->CSR_CRMD);
@@ -430,9 +426,7 @@ static int kvm_loongarch_get_regs_fp(CPUState *cs)
 {
     int ret, i;
     struct kvm_fpu fpu;
-
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     ret = kvm_vcpu_ioctl(cs, KVM_GET_FPU, &fpu);
     if (ret < 0) {
@@ -456,9 +450,7 @@ static int kvm_loongarch_put_regs_fp(CPUState *cs)
 {
     int ret, i;
     struct kvm_fpu fpu;
-
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     fpu.fcsr = env->fcsr0;
     fpu.fcc = 0;
@@ -487,8 +479,7 @@ static int kvm_loongarch_get_mpstate(CPUState *cs)
 {
     int ret = 0;
     struct kvm_mp_state mp_state;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     if (cap_has_mp_state) {
         ret = kvm_vcpu_ioctl(cs, KVM_GET_MP_STATE, &mp_state);
@@ -505,12 +496,8 @@ static int kvm_loongarch_get_mpstate(CPUState *cs)
 static int kvm_loongarch_put_mpstate(CPUState *cs)
 {
     int ret = 0;
-
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
-
     struct kvm_mp_state mp_state = {
-        .mp_state = env->mp_state
+        .mp_state = cpu_env(cs)->mp_state
     };
 
     if (cap_has_mp_state) {
@@ -527,8 +514,7 @@ static int kvm_loongarch_get_cpucfg(CPUState *cs)
 {
     int i, ret = 0;
     uint64_t val;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     for (i = 0; i < 21; i++) {
         ret = kvm_get_one_reg(cs, KVM_IOC_CPUCFG(i), &val);
@@ -549,8 +535,7 @@ static int kvm_check_cpucfg2(CPUState *cs)
         .attr = 2,
         .addr = (uint64_t)&val,
     };
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
 
     ret = kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, &attr);
 
@@ -575,8 +560,7 @@ static int kvm_check_cpucfg2(CPUState *cs)
 static int kvm_loongarch_put_cpucfg(CPUState *cs)
 {
     int i, ret = 0;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     uint64_t val;
 
     for (i = 0; i < 21; i++) {
@@ -758,8 +742,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 {
     int ret = 0;
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     MemTxAttrs attrs = {};
 
     attrs.requester_id = env_cpu(env)->cpu_index;
diff --git a/target/loongarch/tcg/tlb_helper.c b/target/loongarch/tcg/tlb_helper.c
index 449043c68b..2df0bced4c 100644
--- a/target/loongarch/tcg/tlb_helper.c
+++ b/target/loongarch/tcg/tlb_helper.c
@@ -235,8 +235,7 @@ static int get_physical_address(CPULoongArchState *env, hwaddr *physical,
 
 hwaddr loongarch_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     hwaddr phys_addr;
     int prot;
 
@@ -679,8 +678,7 @@ bool loongarch_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                             MMUAccessType access_type, int mmu_idx,
                             bool probe, uintptr_t retaddr)
 {
-    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
-    CPULoongArchState *env = &cpu->env;
+    CPULoongArchState *env = cpu_env(cs);
     hwaddr physical;
     int prot;
     int ret;
-- 
2.41.0


