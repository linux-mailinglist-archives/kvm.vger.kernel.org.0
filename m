Return-Path: <kvm+bounces-7396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C12841541
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 22:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16A01287FFC
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 21:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F592158D89;
	Mon, 29 Jan 2024 21:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GPl551cD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C943B153BC1
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 21:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706565238; cv=none; b=YXIqYIN2sNaFqQ45Gs5P67T0tWIoSlkquLeAaGwjxWKSoxdVT2Z3ARBtg4QN4vWOGeoKVs9Xo1Om9+eVb+CgCjnC9hz2E55biuruDb+kviQ/iXnJih3YNrKH+Uyk6f6nqnfP0hDaBiCZ4yaaCC5eILqXu27fwlL8XHAFyOA0Zt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706565238; c=relaxed/simple;
	bh=/N/nE4NTyi/bU/xhtC31gRu+OOh/hhRYsiYO3W5J9UQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4W1ciglZwJb4V5xrr4+rDVmDXCYboWBLqKTf77Fhq+aKctv9YBGirrfiOjKyLdm7Fox3PdR4vNLWuCw7owM/uKI0uz0yRNnvTztZ220iSsj40hGx0+DTyMG9BcQ1Vza5ywg/e/tzPkWiklUy1Z2RjUesTjVr4B40O8FEwSjRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GPl551cD; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6de070a4cadso1270712b3a.2
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 13:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1706565236; x=1707170036; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vT/LCBfD/SStU7mQwAr6SlF2BMbRDBjqWwgGqBB0M+s=;
        b=GPl551cDZO3EN8HXZlAgyNo1Dc2/zdAhD6pmC5aXkX3aZRxxfNYqj4S7OV4fkD4gYT
         KDftrkzVDs22VBlV+zquCHsDknlokXBGG3BMCT2QAWqps6flbVaZeix7TZ+SsNUzfIvU
         O6UYmAAx00BUKUNza8447IE9lfj0eCxc/uuaWT2Or4EfKNoBQ269resSZs63/5szF/lS
         kRj6z1No0W1NLqj8llB42U9TEE/EDhl6OXDLXwjFNxORjg4805mmhMylkTUOY6DAbHnW
         x3tMkkYYV1Mr7RDt1Is+aP2goUF/tPvpzz56oatpY2aT6E8N2QI41NSd8UqU2q++Lczq
         ZVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706565236; x=1707170036;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vT/LCBfD/SStU7mQwAr6SlF2BMbRDBjqWwgGqBB0M+s=;
        b=Q1n96WssUPkRfl1DbG6RQ02hW/L4NZY8THVk9lgwY2C4bmZQIvS+seAD3djY0hJYFZ
         tlvhTnGYFS6u/vEdc4ruu5HpUQX8nQlik5AbwwBvXu3RzsnXbRvO7T3q0YfP3cqSo2YJ
         9llsLAOomqCi625r2doEQhrbaFyUKMlfPiytB9qsBG6ivLggcTa80vnSqUt5AGxft4Mu
         Tc3WitKJC+nzQh5VRJ0ZfNn1fNYEPo7pYm6w0NIXcldFje4ZEaLH6t142mUX/wb300ZQ
         whFuYj1Xa2bN89uNr66qJ6JPBsOU2rqWw84Jf4h4I1PqFmydEpAWebvsjGaP8nbNDQeP
         EjBw==
X-Gm-Message-State: AOJu0Yzxwn35TPfgbRTwswuTo/JkyytzQDVnM5Wb5MZekZG87XMKw/ge
	t+nGPZn4uH/lB9EUx3qWNRAPO+u3OHrBRhsJHYogH9gRrcBWRRvp0TjhCr8x05Q=
X-Google-Smtp-Source: AGHT+IG2YNCyL39+d+IUn66nQPZlLHYGsM9u3ZWAcq7d8ZeqiOwJqHW9KSw5ZwqnvLe+ERpzzA+hlg==
X-Received: by 2002:a62:b601:0:b0:6d9:af69:b704 with SMTP id j1-20020a62b601000000b006d9af69b704mr3349943pff.13.1706565236028;
        Mon, 29 Jan 2024 13:53:56 -0800 (PST)
Received: from [192.168.68.110] ([177.94.15.159])
        by smtp.gmail.com with ESMTPSA id y190-20020a6364c7000000b005bd2b3a03eesm6753681pgb.6.2024.01.29.13.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 13:53:55 -0800 (PST)
Message-ID: <c1604184-d470-43ef-9530-cb8c0e5c8901@ventanamicro.com>
Date: Mon, 29 Jan 2024 18:53:50 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/29] target/riscv: Prefer fast cpu_env() over slower
 CPU QOM cast macro
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Bin Meng <bin.meng@windriver.com>, Weiwei Li <liwei1518@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-23-philmd@linaro.org>
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20240129164514.73104-23-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hey Phil,

This patch is giving me a conflict in target/riscv/cpu_helper.c when applying
on top of master. Not sure if I'm missing any dependency.

It's a trivial conflict though, just a FYI. As for the patch:


Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

On 1/29/24 13:45, Philippe Mathieu-Daudé wrote:
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/riscv/arch_dump.c   |  6 ++----
>   target/riscv/cpu.c         | 17 +++++------------
>   target/riscv/cpu_helper.c  | 17 +++++------------
>   target/riscv/debug.c       |  9 +++------
>   target/riscv/gdbstub.c     |  6 ++----
>   target/riscv/kvm/kvm-cpu.c | 11 +++--------
>   target/riscv/tcg/tcg-cpu.c | 10 +++-------
>   target/riscv/translate.c   |  6 ++----
>   8 files changed, 25 insertions(+), 57 deletions(-)
> 
> diff --git a/target/riscv/arch_dump.c b/target/riscv/arch_dump.c
> index 434c8a3dbb..994709647f 100644
> --- a/target/riscv/arch_dump.c
> +++ b/target/riscv/arch_dump.c
> @@ -68,8 +68,7 @@ int riscv_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
>                                  int cpuid, DumpState *s)
>   {
>       struct riscv64_note note;
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       int ret, i = 0;
>       const char name[] = "CORE";
>   
> @@ -137,8 +136,7 @@ int riscv_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
>                                  int cpuid, DumpState *s)
>   {
>       struct riscv32_note note;
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       int ret, i;
>       const char name[] = "CORE";
>   
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 1bd99bc5c6..8af4f7a088 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -419,8 +419,7 @@ static void riscv_any_cpu_init(Object *obj)
>   
>   static void riscv_max_cpu_init(Object *obj)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(obj);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(CPU(obj));
>       RISCVMXL mlx = MXL_RV64;
>   
>   #ifdef TARGET_RISCV32
> @@ -828,8 +827,7 @@ static void riscv_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>   
>   static void riscv_cpu_set_pc(CPUState *cs, vaddr value)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>   
>       if (env->xl == MXL_RV32) {
>           env->pc = (int32_t)value;
> @@ -840,8 +838,7 @@ static void riscv_cpu_set_pc(CPUState *cs, vaddr value)
>   
>   static vaddr riscv_cpu_get_pc(CPUState *cs)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>   
>       /* Match cpu_get_tb_cpu_state. */
>       if (env->xl == MXL_RV32) {
> @@ -853,8 +850,7 @@ static vaddr riscv_cpu_get_pc(CPUState *cs)
>   static bool riscv_cpu_has_work(CPUState *cs)
>   {
>   #ifndef CONFIG_USER_ONLY
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       /*
>        * Definition of the WFI instruction requires it to ignore the privilege
>        * mode and delegation registers, but respect individual enables
> @@ -1642,10 +1638,7 @@ static void rva22s64_profile_cpu_init(Object *obj)
>   
>   static const gchar *riscv_gdb_arch_name(CPUState *cs)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> -
> -    switch (riscv_cpu_mxl(env)) {
> +    switch (riscv_cpu_mxl(cpu_env(cs))) {
>       case MXL_RV32:
>           return "riscv:rv32";
>       case MXL_RV64:
> diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
> index 791435d628..01b32a3f83 100644
> --- a/target/riscv/cpu_helper.c
> +++ b/target/riscv/cpu_helper.c
> @@ -493,9 +493,7 @@ static int riscv_cpu_local_irq_pending(CPURISCVState *env)
>   bool riscv_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
>   {
>       if (interrupt_request & CPU_INTERRUPT_HARD) {
> -        RISCVCPU *cpu = RISCV_CPU(cs);
> -        CPURISCVState *env = &cpu->env;
> -        int interruptno = riscv_cpu_local_irq_pending(env);
> +        int interruptno = riscv_cpu_local_irq_pending(cpu_env(cs));
>           if (interruptno >= 0) {
>               cs->exception_index = RISCV_EXCP_INT_FLAG | interruptno;
>               riscv_cpu_do_interrupt(cs);
> @@ -1196,8 +1194,7 @@ static void raise_mmu_exception(CPURISCVState *env, target_ulong address,
>   
>   hwaddr riscv_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       hwaddr phys_addr;
>       int prot;
>       int mmu_idx = cpu_mmu_index(env, false);
> @@ -1223,8 +1220,7 @@ void riscv_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr,
>                                        int mmu_idx, MemTxAttrs attrs,
>                                        MemTxResult response, uintptr_t retaddr)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>   
>       if (access_type == MMU_DATA_STORE) {
>           cs->exception_index = RISCV_EXCP_STORE_AMO_ACCESS_FAULT;
> @@ -1244,8 +1240,7 @@ void riscv_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
>                                      MMUAccessType access_type, int mmu_idx,
>                                      uintptr_t retaddr)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       switch (access_type) {
>       case MMU_INST_FETCH:
>           cs->exception_index = RISCV_EXCP_INST_ADDR_MIS;
> @@ -1631,9 +1626,7 @@ static target_ulong riscv_transformed_insn(CPURISCVState *env,
>   void riscv_cpu_do_interrupt(CPUState *cs)
>   {
>   #if !defined(CONFIG_USER_ONLY)
> -
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       bool write_gva = false;
>       uint64_t s;
>   
> diff --git a/target/riscv/debug.c b/target/riscv/debug.c
> index 4945d1a1f2..c8df9812be 100644
> --- a/target/riscv/debug.c
> +++ b/target/riscv/debug.c
> @@ -757,8 +757,7 @@ target_ulong tinfo_csr_read(CPURISCVState *env)
>   
>   void riscv_cpu_debug_excp_handler(CPUState *cs)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>   
>       if (cs->watchpoint_hit) {
>           if (cs->watchpoint_hit->flags & BP_CPU) {
> @@ -773,8 +772,7 @@ void riscv_cpu_debug_excp_handler(CPUState *cs)
>   
>   bool riscv_cpu_debug_check_breakpoint(CPUState *cs)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       CPUBreakpoint *bp;
>       target_ulong ctrl;
>       target_ulong pc;
> @@ -832,8 +830,7 @@ bool riscv_cpu_debug_check_breakpoint(CPUState *cs)
>   
>   bool riscv_cpu_debug_check_watchpoint(CPUState *cs, CPUWatchpoint *wp)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       target_ulong ctrl;
>       target_ulong addr;
>       int trigger_type;
> diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
> index 58b3ace0fe..999d815b34 100644
> --- a/target/riscv/gdbstub.c
> +++ b/target/riscv/gdbstub.c
> @@ -49,8 +49,7 @@ static const struct TypeSize vec_lanes[] = {
>   
>   int riscv_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       target_ulong tmp;
>   
>       if (n < 32) {
> @@ -75,8 +74,7 @@ int riscv_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
>   
>   int riscv_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       int length = 0;
>       target_ulong tmp;
>   
> diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
> index 680a729cd8..563b371ec9 100644
> --- a/target/riscv/kvm/kvm-cpu.c
> +++ b/target/riscv/kvm/kvm-cpu.c
> @@ -171,9 +171,7 @@ static void kvm_cpu_get_misa_ext_cfg(Object *obj, Visitor *v,
>   {
>       KVMCPUConfig *misa_ext_cfg = opaque;
>       target_ulong misa_bit = misa_ext_cfg->offset;
> -    RISCVCPU *cpu = RISCV_CPU(obj);
> -    CPURISCVState *env = &cpu->env;
> -    bool value = env->misa_ext_mask & misa_bit;
> +    bool value = cpu_env(CPU(obj))->misa_ext_mask & misa_bit;
>   
>       visit_type_bool(v, name, &value, errp);
>   }
> @@ -184,15 +182,13 @@ static void kvm_cpu_set_misa_ext_cfg(Object *obj, Visitor *v,
>   {
>       KVMCPUConfig *misa_ext_cfg = opaque;
>       target_ulong misa_bit = misa_ext_cfg->offset;
> -    RISCVCPU *cpu = RISCV_CPU(obj);
> -    CPURISCVState *env = &cpu->env;
>       bool value, host_bit;
>   
>       if (!visit_type_bool(v, name, &value, errp)) {
>           return;
>       }
>   
> -    host_bit = env->misa_ext_mask & misa_bit;
> +    host_bit = cpu_env(CPU(obj))->misa_ext_mask & misa_bit;
>   
>       if (value == host_bit) {
>           return;
> @@ -1583,10 +1579,9 @@ static void kvm_cpu_instance_init(CPUState *cs)
>    */
>   static bool kvm_cpu_realize(CPUState *cs, Error **errp)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
>       int ret;
>   
> -    if (riscv_has_ext(&cpu->env, RVV)) {
> +    if (riscv_has_ext(cpu_env(cs), RVV)) {
>           ret = prctl(PR_RISCV_V_SET_CONTROL, PR_RISCV_V_VSTATE_CTRL_ON);
>           if (ret) {
>               error_setg(errp, "Error in prctl PR_RISCV_V_SET_CONTROL, code: %s",
> diff --git a/target/riscv/tcg/tcg-cpu.c b/target/riscv/tcg/tcg-cpu.c
> index 994ca1cdf9..e0f05d898c 100644
> --- a/target/riscv/tcg/tcg-cpu.c
> +++ b/target/riscv/tcg/tcg-cpu.c
> @@ -92,8 +92,7 @@ static void riscv_cpu_synchronize_from_tb(CPUState *cs,
>                                             const TranslationBlock *tb)
>   {
>       if (!(tb_cflags(tb) & CF_PCREL)) {
> -        RISCVCPU *cpu = RISCV_CPU(cs);
> -        CPURISCVState *env = &cpu->env;
> +        CPURISCVState *env = cpu_env(cs);
>           RISCVMXL xl = FIELD_EX32(tb->flags, TB_FLAGS, XL);
>   
>           tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
> @@ -110,8 +109,7 @@ static void riscv_restore_state_to_opc(CPUState *cs,
>                                          const TranslationBlock *tb,
>                                          const uint64_t *data)
>   {
> -    RISCVCPU *cpu = RISCV_CPU(cs);
> -    CPURISCVState *env = &cpu->env;
> +    CPURISCVState *env = cpu_env(cs);
>       RISCVMXL xl = FIELD_EX32(tb->flags, TB_FLAGS, XL);
>       target_ulong pc;
>   
> @@ -1030,11 +1028,9 @@ static void cpu_get_misa_ext_cfg(Object *obj, Visitor *v, const char *name,
>   {
>       const RISCVCPUMisaExtConfig *misa_ext_cfg = opaque;
>       target_ulong misa_bit = misa_ext_cfg->misa_bit;
> -    RISCVCPU *cpu = RISCV_CPU(obj);
> -    CPURISCVState *env = &cpu->env;
>       bool value;
>   
> -    value = env->misa_ext & misa_bit;
> +    value = cpu_env(CPU(obj))->misa_ext & misa_bit;
>   
>       visit_type_bool(v, name, &value, errp);
>   }
> diff --git a/target/riscv/translate.c b/target/riscv/translate.c
> index 071fbad7ef..24db9f3882 100644
> --- a/target/riscv/translate.c
> +++ b/target/riscv/translate.c
> @@ -1074,9 +1074,8 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
>   {
>       DisasContext *ctx = container_of(dcbase, DisasContext, base);
>       CPUState *cpu = ctx->cs;
> -    CPURISCVState *env = cpu_env(cpu);
>   
> -    return cpu_ldl_code(env, pc);
> +    return cpu_ldl_code(cpu_env(cpu), pc);
>   }
>   
>   /* Include insn module translation function */
> @@ -1265,8 +1264,7 @@ static void riscv_tr_disas_log(const DisasContextBase *dcbase,
>                                  CPUState *cpu, FILE *logfile)
>   {
>   #ifndef CONFIG_USER_ONLY
> -    RISCVCPU *rvcpu = RISCV_CPU(cpu);
> -    CPURISCVState *env = &rvcpu->env;
> +    CPURISCVState *env = cpu_env(cpu);
>   #endif
>   
>       fprintf(logfile, "IN: %s\n", lookup_symbol(dcbase->pc_first));

