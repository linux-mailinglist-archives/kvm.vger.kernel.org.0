Return-Path: <kvm+bounces-7217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C947F83E478
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ADB4B21DB5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F1CF250F6;
	Fri, 26 Jan 2024 22:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GB9eCXke"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5700224A1D
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306672; cv=none; b=iEAfZvvozsB4ydIsyNIpxX0PY76Gtkhu/+eAX/KUWzkQjqeKPGCDc+TDWIQ+Ty0gded6fXQK1y9jwaqBXpaZAFkqRadtmfvTxiiB7jhbOOtrYtPlDPpXROjqhnxPI4AZXWqPLsXBYDy9OFK5SDebpFqYkTlXmhkWYqRjoAEuyUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306672; c=relaxed/simple;
	bh=+V3PX5xwYOZQutW8VfYXggEmuOxuidGpSCJRMvHqEXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=euO4Mh4zrMDS9ZmlGIgeRPvv0BwfzYVOKSjK/YaMcQJjtL2FoJirCiQopECUpLc3X4MEzEYewEVfWPDI3sFgjP54dSZbusxcvFrOscruBSzPDy6QmGt7wOS7N2VoOFgb4T84PVCRXLm1ncdym8ndbAETdBSWBzfgRgWeEUGARdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GB9eCXke; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a28fb463a28so77512166b.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306668; x=1706911468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCbQQLgi9WW85KLAGX/JCbhsNaoCcACzxkgJkt9CV5M=;
        b=GB9eCXkeplza4yzL8B9OwING8fiyL95z3xVdPNdnLuDqRkVVatDlACZytXvoRwptc2
         ze3K0qUhBfp/JErf5tb23UCmFttdCt6gbudPsIM+cOBXt/J/sO8jH5lYI5fCkrdPR0QN
         2qFGl8aeAr/69+7g/tmKyigx52aVMhU5nYfOBS0zK8KZgfGztbA6aQntW63wWuQvcFOg
         iXOm1kyVoJgNywJIf4TqjqxWZJqTpf9yy9sA25sQ6IB/Pqs0eqzZ4yhUQAmcJxJ1yph1
         jDk6bwpWzpkZOP6Fv1PrAN4z+wDhmXmbdXp7C6l74EI9pFbOPc18/lN2PJszJNh/YLwc
         xPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306668; x=1706911468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCbQQLgi9WW85KLAGX/JCbhsNaoCcACzxkgJkt9CV5M=;
        b=rOGEl8lbsxG6+EoZqQOotnnEiTbaSe404kFfr6YZChR8XCbCajJKuAeyQWjQREj8T4
         lrSW59Q2dlMTR3YCaIu/iHq1JPf6r/qmQhNAf41G8aJ5Q8qNbH4q5d0Knrggk9G2Wn5/
         Wvxparx1UCfTgS+KGTmYcB2ySCZt2X93FluO2NfX8o8lFGZ3XQCee0flLXMXdvYSypns
         lvaBoAm03kNrZIMhfX/gSgWqYLc8NKdZG16O0HYy92DvY6k5EmPCuKm0/Zo7CNm2hbqs
         lOLXlN3PLAdWnqRYrjcxEVLlsE+gw30AkNww2jPzZ2pG6AXAq6lHbdBY1T769dVX/d6e
         vkcw==
X-Gm-Message-State: AOJu0YwzHHCVwyvCc7f9JeQ4K5d4ixCbpnasQ2O16fZDDqcppvP7CFBC
	hMDtX3N3uoH8FSPGUb0HrsH3gbuksTIBYZKtgkyOOJYfCy2SrqONfvLdGLuA8M4=
X-Google-Smtp-Source: AGHT+IGN3HDxzBoHLqx3LMmclEgvMHqr8iDo1TTL5LgspPQ/aek2zjtAIt30vwlIWAyc4IXOZ6vHOg==
X-Received: by 2002:a17:906:278f:b0:a31:5e7:b3ef with SMTP id j15-20020a170906278f00b00a3105e7b3efmr235073ejc.47.1706306668578;
        Fri, 26 Jan 2024 14:04:28 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id vh5-20020a170907d38500b00a3517d26918sm508021ejc.107.2024.01.26.14.04.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:04:28 -0800 (PST)
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
	Laurent Vivier <laurent@vivier.eu>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Song Gao <gaosong@loongson.cn>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 03/23] bulk: Call in place single use cpu_env()
Date: Fri, 26 Jan 2024 23:03:45 +0100
Message-ID: <20240126220407.95022-4-philmd@linaro.org>
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

Avoid CPUArchState local variable when cpu_env() is used once.

Mechanical patch using the following Coccinelle spatch script:

 @@
 type CPUArchState;
 identifier env;
 expression cs;
 @@
  {
 -    CPUArchState *env = cpu_env(cs);
      ... when != env
 -     env
 +     cpu_env(cs)
      ... when != env
  }

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/cpu-exec.c             |  3 +--
 linux-user/i386/cpu_loop.c       |  4 ++--
 target/hppa/mem_helper.c         |  3 +--
 target/hppa/translate.c          |  3 +--
 target/i386/nvmm/nvmm-all.c      |  6 ++----
 target/i386/whpx/whpx-all.c      | 18 ++++++------------
 target/loongarch/tcg/translate.c |  3 +--
 target/rx/translate.c            |  3 +--
 target/sh4/op_helper.c           |  4 +---
 9 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index 67eda9865e..86206484f8 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -445,7 +445,6 @@ const void *HELPER(lookup_tb_ptr)(CPUArchState *env)
 static inline TranslationBlock * QEMU_DISABLE_CFI
 cpu_tb_exec(CPUState *cpu, TranslationBlock *itb, int *tb_exit)
 {
-    CPUArchState *env = cpu_env(cpu);
     uintptr_t ret;
     TranslationBlock *last_tb;
     const void *tb_ptr = itb->tc.ptr;
@@ -455,7 +454,7 @@ cpu_tb_exec(CPUState *cpu, TranslationBlock *itb, int *tb_exit)
     }
 
     qemu_thread_jit_execute();
-    ret = tcg_qemu_tb_exec(env, tb_ptr);
+    ret = tcg_qemu_tb_exec(cpu_env(cpu), tb_ptr);
     cpu->neg.can_do_io = true;
     qemu_plugin_disable_mem_helpers(cpu);
     /*
diff --git a/linux-user/i386/cpu_loop.c b/linux-user/i386/cpu_loop.c
index 42ecb4bf0a..92beb6830c 100644
--- a/linux-user/i386/cpu_loop.c
+++ b/linux-user/i386/cpu_loop.c
@@ -323,8 +323,8 @@ void cpu_loop(CPUX86State *env)
 
 static void target_cpu_free(void *obj)
 {
-    CPUArchState *env = cpu_env(obj);
-    target_munmap(env->gdt.base, sizeof(uint64_t) * TARGET_GDT_ENTRIES);
+    target_munmap(cpu_env(obj)->gdt.base,
+                  sizeof(uint64_t) * TARGET_GDT_ENTRIES);
     g_free(obj);
 }
 
diff --git a/target/hppa/mem_helper.c b/target/hppa/mem_helper.c
index 4fcc612754..bb85962d50 100644
--- a/target/hppa/mem_helper.c
+++ b/target/hppa/mem_helper.c
@@ -518,7 +518,6 @@ void HELPER(iitlbt_pa20)(CPUHPPAState *env, target_ulong r1, target_ulong r2)
 /* Purge (Insn/Data) TLB. */
 static void ptlb_work(CPUState *cpu, run_on_cpu_data data)
 {
-    CPUHPPAState *env = cpu_env(cpu);
     vaddr start = data.target_ptr;
     vaddr end;
 
@@ -532,7 +531,7 @@ static void ptlb_work(CPUState *cpu, run_on_cpu_data data)
     end = (vaddr)TARGET_PAGE_SIZE << (2 * end);
     end = start + end - 1;
 
-    hppa_flush_tlb_range(env, start, end);
+    hppa_flush_tlb_range(cpu_env(cpu), start, end);
 }
 
 /* This is local to the current cpu. */
diff --git a/target/hppa/translate.c b/target/hppa/translate.c
index 3ef39b1bd7..5735335254 100644
--- a/target/hppa/translate.c
+++ b/target/hppa/translate.c
@@ -3805,8 +3805,7 @@ static bool trans_b_gate(DisasContext *ctx, arg_b_gate *a)
 
 #ifndef CONFIG_USER_ONLY
     if (ctx->tb_flags & PSW_C) {
-        CPUHPPAState *env = cpu_env(ctx->cs);
-        int type = hppa_artype_for_page(env, ctx->base.pc_next);
+        int type = hppa_artype_for_page(cpu_env(ctx->cs), ctx->base.pc_next);
         /* If we could not find a TLB entry, then we need to generate an
            ITLB miss exception so the kernel will provide it.
            The resulting TLB fill operation will invalidate this TB and
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index cfdca91123..49a3a3b916 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -340,7 +340,6 @@ nvmm_get_registers(CPUState *cpu)
 static bool
 nvmm_can_take_int(CPUState *cpu)
 {
-    CPUX86State *env = cpu_env(cpu);
     AccelCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     struct nvmm_machine *mach = get_nvmm_mach();
@@ -349,7 +348,7 @@ nvmm_can_take_int(CPUState *cpu)
         return false;
     }
 
-    if (qcpu->int_shadow || !(env->eflags & IF_MASK)) {
+    if (qcpu->int_shadow || !(cpu_env(cpu)->eflags & IF_MASK)) {
         struct nvmm_x64_state *state = vcpu->state;
 
         /* Exit on interrupt window. */
@@ -645,13 +644,12 @@ static int
 nvmm_handle_halted(struct nvmm_machine *mach, CPUState *cpu,
     struct nvmm_vcpu_exit *exit)
 {
-    CPUX86State *env = cpu_env(cpu);
     int ret = 0;
 
     bql_lock();
 
     if (!((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
-          (env->eflags & IF_MASK)) &&
+          (cpu_env(cpu)->eflags & IF_MASK)) &&
         !(cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
         cpu->exception_index = EXCP_HLT;
         cpu->halted = true;
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index a7262654ac..31eec7048c 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -300,7 +300,6 @@ static SegmentCache whpx_seg_h2q(const WHV_X64_SEGMENT_REGISTER *hs)
 /* X64 Extended Control Registers */
 static void whpx_set_xcrs(CPUState *cpu)
 {
-    CPUX86State *env = cpu_env(cpu);
     HRESULT hr;
     struct whpx_state *whpx = &whpx_global;
     WHV_REGISTER_VALUE xcr0;
@@ -311,7 +310,7 @@ static void whpx_set_xcrs(CPUState *cpu)
     }
 
     /* Only xcr0 is supported by the hypervisor currently */
-    xcr0.Reg64 = env->xcr0;
+    xcr0.Reg64 = cpu_env(cpu)->xcr0;
     hr = whp_dispatch.WHvSetVirtualProcessorRegisters(
         whpx->partition, cpu->cpu_index, &xcr0_name, 1, &xcr0);
     if (FAILED(hr)) {
@@ -321,7 +320,6 @@ static void whpx_set_xcrs(CPUState *cpu)
 
 static int whpx_set_tsc(CPUState *cpu)
 {
-    CPUX86State *env = cpu_env(cpu);
     WHV_REGISTER_NAME tsc_reg = WHvX64RegisterTsc;
     WHV_REGISTER_VALUE tsc_val;
     HRESULT hr;
@@ -345,7 +343,7 @@ static int whpx_set_tsc(CPUState *cpu)
         }
     }
 
-    tsc_val.Reg64 = env->tsc;
+    tsc_val.Reg64 = cpu_env(cpu)->tsc;
     hr = whp_dispatch.WHvSetVirtualProcessorRegisters(
         whpx->partition, cpu->cpu_index, &tsc_reg, 1, &tsc_val);
     if (FAILED(hr)) {
@@ -556,7 +554,6 @@ static void whpx_set_registers(CPUState *cpu, int level)
 
 static int whpx_get_tsc(CPUState *cpu)
 {
-    CPUX86State *env = cpu_env(cpu);
     WHV_REGISTER_NAME tsc_reg = WHvX64RegisterTsc;
     WHV_REGISTER_VALUE tsc_val;
     HRESULT hr;
@@ -569,14 +566,13 @@ static int whpx_get_tsc(CPUState *cpu)
         return -1;
     }
 
-    env->tsc = tsc_val.Reg64;
+    cpu_env(cpu)->tsc = tsc_val.Reg64;
     return 0;
 }
 
 /* X64 Extended Control Registers */
 static void whpx_get_xcrs(CPUState *cpu)
 {
-    CPUX86State *env = cpu_env(cpu);
     HRESULT hr;
     struct whpx_state *whpx = &whpx_global;
     WHV_REGISTER_VALUE xcr0;
@@ -594,7 +590,7 @@ static void whpx_get_xcrs(CPUState *cpu)
         return;
     }
 
-    env->xcr0 = xcr0.Reg64;
+    cpu_env(cpu)->xcr0 = xcr0.Reg64;
 }
 
 static void whpx_get_registers(CPUState *cpu)
@@ -1400,8 +1396,7 @@ static vaddr whpx_vcpu_get_pc(CPUState *cpu, bool exit_context_valid)
 {
     if (cpu->vcpu_dirty) {
         /* The CPU registers have been modified by other parts of QEMU. */
-        CPUArchState *env = cpu_env(cpu);
-        return env->eip;
+        return cpu_env(cpu)->eip;
     } else if (exit_context_valid) {
         /*
          * The CPU registers have not been modified by neither other parts
@@ -1439,12 +1434,11 @@ static vaddr whpx_vcpu_get_pc(CPUState *cpu, bool exit_context_valid)
 
 static int whpx_handle_halt(CPUState *cpu)
 {
-    CPUX86State *env = cpu_env(cpu);
     int ret = 0;
 
     bql_lock();
     if (!((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
-          (env->eflags & IF_MASK)) &&
+          (cpu_env(cpu)->eflags & IF_MASK)) &&
         !(cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
         cpu->exception_index = EXCP_HLT;
         cpu->halted = true;
diff --git a/target/loongarch/tcg/translate.c b/target/loongarch/tcg/translate.c
index 21f4db6fbd..7bb8cecab3 100644
--- a/target/loongarch/tcg/translate.c
+++ b/target/loongarch/tcg/translate.c
@@ -282,10 +282,9 @@ static uint64_t make_address_pc(DisasContext *ctx, uint64_t addr)
 
 static void loongarch_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
 {
-    CPULoongArchState *env = cpu_env(cs);
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
 
-    ctx->opcode = translator_ldl(env, &ctx->base, ctx->base.pc_next);
+    ctx->opcode = translator_ldl(cpu_env(cs), &ctx->base, ctx->base.pc_next);
 
     if (!decode(ctx, ctx->opcode)) {
         qemu_log_mask(LOG_UNIMP, "Error: unknown opcode. "
diff --git a/target/rx/translate.c b/target/rx/translate.c
index c6ce717a95..1829a0b1cd 100644
--- a/target/rx/translate.c
+++ b/target/rx/translate.c
@@ -2195,9 +2195,8 @@ static bool trans_WAIT(DisasContext *ctx, arg_WAIT *a)
 
 static void rx_tr_init_disas_context(DisasContextBase *dcbase, CPUState *cs)
 {
-    CPURXState *env = cpu_env(cs);
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
-    ctx->env = env;
+    ctx->env = cpu_env(cs);
     ctx->tb_flags = ctx->base.tb->flags;
 }
 
diff --git a/target/sh4/op_helper.c b/target/sh4/op_helper.c
index 54d390fe1f..4559d0d376 100644
--- a/target/sh4/op_helper.c
+++ b/target/sh4/op_helper.c
@@ -29,9 +29,7 @@ void superh_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                     MMUAccessType access_type,
                                     int mmu_idx, uintptr_t retaddr)
 {
-    CPUSH4State *env = cpu_env(cs);
-
-    env->tea = addr;
+    cpu_env(cs)->tea = addr;
     switch (access_type) {
     case MMU_INST_FETCH:
     case MMU_DATA_LOAD:
-- 
2.41.0


