Return-Path: <kvm+bounces-7350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD85840BFF
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 379501F23FB4
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE53D15698D;
	Mon, 29 Jan 2024 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vDAvpZ8W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F395D156985
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546748; cv=none; b=OKhsd9esg2M4oOVSWRvv6bB0EnJJlmvdxp+K5p+NS+566Q86U8E9yZPNmA2CpwE9MnCgrXLVFrWH4TPoogg8HGsI42YcLw78OFbfF7BVP3rBwP3HCQfmolfXNHLuqgQZMFeCWWU0wwJuxkjvADBCqgcuaEMgbBMs4g3IW4j13rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546748; c=relaxed/simple;
	bh=3fUVOQdxx73b+56s5qDX3zsDOBg9Su1A+p7RaLby12g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pTq8t2041pmdnCURdBFjDDcU7fLq1JzTkBmcSfoz+sQT2CuliLk0o+p10uGY+41ml3jsyc3tiYsu1jM49QNQ6ORVVKkDkSZYQocewjr+l+zN+xnWhG5SPP3Ih4j8hJKxrfJGmglJ/xk4zQHraHXeZM7lAslhrBJL+Esv2aXs+Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vDAvpZ8W; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33af2823edbso508959f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546744; x=1707151544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8JvjcuG17Z5H/fwKhCgUCDDHXtWs59z4HKxSgYIQak=;
        b=vDAvpZ8WHviVY5enY6ONzs39Mzux2kqxlFlWufxG91ajdGE2Hhvau1cmMUrXewVcMv
         LOXCbcaX7+5sL4cwpadg+zfRp2A9w7pfwmXB8QQYs4FomsV3viIVwrKmLsM0MPWDbdkM
         R3X82GFOGWNBJBpmDQcA/hFblPrqgEe4HW5QImjybKvEQi5x4GY1ivQNrgKOk0iv+ruJ
         LLIdEOe0r66+ZD5+gkb5M5CX8GVkbGIGdnMo3xyuQK6re/JimnAUa2aC8ZWmLesfV2/Y
         KPqLq8I+5/+bNCdwEJCLPDowWZNpllv2mONh9LpqMx1IKkSc6o6dHPn+DwEzNTUgbsBU
         Yz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546744; x=1707151544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8JvjcuG17Z5H/fwKhCgUCDDHXtWs59z4HKxSgYIQak=;
        b=jV/0tDs5n5IpbGVrvqdkOCTsoxiudB70BP+7fCytkqw0UMMkmhgEfMgdwbHglUmDvX
         AWOTNkE5fz+hBEV0qyauhupOkYTYscKk+wp0G07Ss4azFeQyTFJdeSTD2SFwUOwrphPC
         cWKiT6wRu8IYBubqOo73m+1HQ3V/VjPrC4d1sghSKAl1j/R0aW91bZPRaxOuRHJXqfvG
         f1MSKBPZgL0yWeK00WpjTW0n4MdEEgQsaJbuOAFKSEp0aRieVAec+X6wLMspLYA+K3rW
         yP3sj1mCyTdiCnT+vH0nFFOQYlwBP4u4o8/VkF7131K5sowih0YgQT5mhrXRTNkze42x
         pUwQ==
X-Gm-Message-State: AOJu0YyTQS0wP07WccLcziilwvHQn9B7kkCzLRTQf5vDz8MmAz/8ct3F
	ceoEl8XNZ4X06IfBMbG/80tfg6KAOjmRAFNsxhPTl9dUJMlCvjls4RHJGHextw8=
X-Google-Smtp-Source: AGHT+IGsRS3mCrSQqdH7/CVh0bHEjVxZxEE4GjqLYzUtvxEToac4oiSaOtdxXr4oh5vfsiDP3ObnIg==
X-Received: by 2002:adf:ca8d:0:b0:339:2c1a:5d79 with SMTP id r13-20020adfca8d000000b003392c1a5d79mr4032395wrh.6.1706546744013;
        Mon, 29 Jan 2024 08:45:44 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id v8-20020a5d59c8000000b0033af2a91b47sm2057984wry.70.2024.01.29.08.45.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:45:43 -0800 (PST)
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
	Laurent Vivier <laurent@vivier.eu>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Song Gao <gaosong@loongson.cn>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v3 04/29] bulk: Call in place single use cpu_env()
Date: Mon, 29 Jan 2024 17:44:46 +0100
Message-ID: <20240129164514.73104-5-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


