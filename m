Return-Path: <kvm+bounces-6114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B30F582B808
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 00:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FFB9B23ACC
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 23:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549345A0E9;
	Thu, 11 Jan 2024 23:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaCWPECv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664D25A0E1
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4678c4e51a5so1633018137.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 15:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705015722; x=1705620522; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2w/K7qN5lXAxzPqIWzoFGBFThNG2//mKB+/cxZa0O4=;
        b=VaCWPECvUQzEb348oeP35K6gxt8Z+3GZi3Rv9u4A/5BQaOriMbEmV6BKZXatgridJv
         Ro/+bvBYqlYa/YkAWowTNLy7X01tpaNiuePH+mDkUvfxcrggXC6jLA1WbhmoE0BhdJBn
         1gdgquvp6g4VpIfzrGE4WLEfl/ivP5dUDhWcp0Hak/+/hygKRp4KMqx7FTipgBN1GLL5
         ZOg59LLa7+ifBULr7k1dsTMk+cJPWAWI4IL7MwAkrQ7GDGG5kMGmWSd4qEA79c+MeCwI
         yNQLf/mOvNvdGj6RRR2N/57mB/7dHLYY7TSgtEkxG6W18TTlVUinlBa/NuUWh4Q8X1Wf
         hIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705015722; x=1705620522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2w/K7qN5lXAxzPqIWzoFGBFThNG2//mKB+/cxZa0O4=;
        b=aCZQR4KW/MEOyfJrt6CzLsMUUWArWokHrzaG0Ump+Lfl+vCgh60c7KKe0S0TSJDeb4
         G/KxT9W49mL7Y49rl2SQI0e60QbuEZQboiqK9QjZefWqb71p+/g3gd3Gi5HzKjA0fuVY
         hlqeYODAsCTJV5+uBazaHmLIQCOsiK6XuWk6tWW8txugjtNZf817ML6Tyo9d9TTs0/5Y
         0Zj+ZoX0ATtz4vwVdOcQabfIytjTJNnRhAhzu8zJxLJhW+fetoP1kfxOgARN/jDqqlqr
         RqaRTR95WYG7RsD6NUxs3YLeEibSdF4gU834ODR4IKFI2cmlTKlYVlCjAwKMMlDY7j+C
         9EfA==
X-Gm-Message-State: AOJu0Yzcv39K6HdupFQklc2X9MYKuNjzS/U1TqUeAnMKiZJMfBKONt3H
	mi+tIOavtzR6+/8LtNv9/QfW+3Zh+ju2O6gDUBo=
X-Google-Smtp-Source: AGHT+IENCvNO/D4DBkIu2uZLjfU7ziyh5quJFIO5HWWZVco0DaP2KnRKkSkfKTQxYdcDrWXXyj6Yeoo8mYxJo0a4s6M=
X-Received: by 2002:a05:6102:c88:b0:467:cc9a:b31d with SMTP id
 f8-20020a0561020c8800b00467cc9ab31dmr796182vst.26.1705015721878; Thu, 11 Jan
 2024 15:28:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103173349.398526-1-alex.bennee@linaro.org> <20240103173349.398526-25-alex.bennee@linaro.org>
In-Reply-To: <20240103173349.398526-25-alex.bennee@linaro.org>
From: Alistair Francis <alistair23@gmail.com>
Date: Fri, 12 Jan 2024 09:28:15 +1000
Message-ID: <CAKmqyKPUJf7m2nWm2M0pRVvehms0f9iigoY7yUS4psfqox9GwQ@mail.gmail.com>
Subject: Re: [PATCH v2 24/43] target/riscv: Move misa_mxl_max to class
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Song Gao <gaosong@loongson.cn>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Yanan Wang <wangyanan55@huawei.com>, 
	Bin Meng <bin.meng@windriver.com>, Laurent Vivier <lvivier@redhat.com>, 
	Michael Rolnik <mrolnik@gmail.com>, Alexandre Iooss <erdnaxe@crans.org>, 
	David Woodhouse <dwmw2@infradead.org>, Laurent Vivier <laurent@vivier.eu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Brian Cain <bcain@quicinc.com>, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Beraldo Leal <bleal@redhat.com>, Paul Durrant <paul@xen.org>, 
	Mahmoud Mandour <ma.mandourr@gmail.com>, Thomas Huth <thuth@redhat.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org, 
	Peter Maydell <peter.maydell@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, Weiwei Li <liwei1518@gmail.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	John Snow <jsnow@redhat.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-riscv@nongnu.org, 
	Alistair Francis <alistair.francis@wdc.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 3:44=E2=80=AFAM Alex Benn=C3=A9e <alex.bennee@linaro=
.org> wrote:
>
> From: Akihiko Odaki <akihiko.odaki@daynix.com>
>
> misa_mxl_max is common for all instances of a RISC-V CPU class so they
> are better put into class.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Message-Id: <20231213-riscv-v7-3-a760156a337f@daynix.com>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

Acked-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/cpu.h         |   4 +-
>  target/riscv/cpu.c         | 118 +++++++++++++++++++------------------
>  target/riscv/gdbstub.c     |  12 ++--
>  target/riscv/kvm/kvm-cpu.c |  10 ++--
>  target/riscv/machine.c     |   7 +--
>  target/riscv/tcg/tcg-cpu.c |  12 ++--
>  target/riscv/translate.c   |   3 +-
>  7 files changed, 87 insertions(+), 79 deletions(-)
>
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index d74b361be64..060b7f69a74 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -169,7 +169,6 @@ struct CPUArchState {
>
>      /* RISCVMXL, but uint32_t for vmstate migration */
>      uint32_t misa_mxl;      /* current mxl */
> -    uint32_t misa_mxl_max;  /* max mxl for this cpu */
>      uint32_t misa_ext;      /* current extensions */
>      uint32_t misa_ext_mask; /* max ext for this cpu */
>      uint32_t xl;            /* current xlen */
> @@ -450,6 +449,7 @@ struct RISCVCPUClass {
>
>      DeviceRealize parent_realize;
>      ResettablePhases parent_phases;
> +    uint32_t misa_mxl_max;  /* max mxl for this cpu */
>  };
>
>  static inline int riscv_has_ext(CPURISCVState *env, target_ulong ext)
> @@ -756,7 +756,7 @@ enum riscv_pmu_event_idx {
>  /* used by tcg/tcg-cpu.c*/
>  void isa_ext_update_enabled(RISCVCPU *cpu, uint32_t ext_offset, bool en)=
;
>  bool isa_ext_is_enabled(RISCVCPU *cpu, uint32_t ext_offset);
> -void riscv_cpu_set_misa(CPURISCVState *env, RISCVMXL mxl, uint32_t ext);
> +void riscv_cpu_set_misa_ext(CPURISCVState *env, uint32_t ext);
>
>  typedef struct RISCVCPUMultiExtConfig {
>      const char *name;
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 83c7c0cf07b..2ab61df2217 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -274,9 +274,8 @@ const char *riscv_cpu_get_trap_name(target_ulong caus=
e, bool async)
>      }
>  }
>
> -void riscv_cpu_set_misa(CPURISCVState *env, RISCVMXL mxl, uint32_t ext)
> +void riscv_cpu_set_misa_ext(CPURISCVState *env, uint32_t ext)
>  {
> -    env->misa_mxl_max =3D env->misa_mxl =3D mxl;
>      env->misa_ext_mask =3D env->misa_ext =3D ext;
>  }
>
> @@ -378,11 +377,7 @@ static void riscv_any_cpu_init(Object *obj)
>  {
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>      CPURISCVState *env =3D &cpu->env;
> -#if defined(TARGET_RISCV32)
> -    riscv_cpu_set_misa(env, MXL_RV32, RVI | RVM | RVA | RVF | RVD | RVC =
| RVU);
> -#elif defined(TARGET_RISCV64)
> -    riscv_cpu_set_misa(env, MXL_RV64, RVI | RVM | RVA | RVF | RVD | RVC =
| RVU);
> -#endif
> +    riscv_cpu_set_misa_ext(env, RVI | RVM | RVA | RVF | RVD | RVC | RVU)=
;
>
>  #ifndef CONFIG_USER_ONLY
>      set_satp_mode_max_supported(RISCV_CPU(obj),
> @@ -403,16 +398,14 @@ static void riscv_max_cpu_init(Object *obj)
>  {
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>      CPURISCVState *env =3D &cpu->env;
> -    RISCVMXL mlx =3D MXL_RV64;
>
> -#ifdef TARGET_RISCV32
> -    mlx =3D MXL_RV32;
> -#endif
> -    riscv_cpu_set_misa(env, mlx, 0);
>      env->priv_ver =3D PRIV_VERSION_LATEST;
>  #ifndef CONFIG_USER_ONLY
> -    set_satp_mode_max_supported(RISCV_CPU(obj), mlx =3D=3D MXL_RV32 ?
> -                                VM_1_10_SV32 : VM_1_10_SV57);
> +#ifdef TARGET_RISCV32
> +    set_satp_mode_max_supported(cpu, VM_1_10_SV32);
> +#else
> +    set_satp_mode_max_supported(cpu, VM_1_10_SV57);
> +#endif
>  #endif
>  }
>
> @@ -420,8 +413,6 @@ static void riscv_max_cpu_init(Object *obj)
>  static void rv64_base_cpu_init(Object *obj)
>  {
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
> -    /* We set this in the realise function */
> -    riscv_cpu_set_misa(env, MXL_RV64, 0);
>      /* Set latest version of privileged specification */
>      env->priv_ver =3D PRIV_VERSION_LATEST;
>  #ifndef CONFIG_USER_ONLY
> @@ -433,8 +424,7 @@ static void rv64_sifive_u_cpu_init(Object *obj)
>  {
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>      CPURISCVState *env =3D &cpu->env;
> -    riscv_cpu_set_misa(env, MXL_RV64,
> -                       RVI | RVM | RVA | RVF | RVD | RVC | RVS | RVU);
> +    riscv_cpu_set_misa_ext(env, RVI | RVM | RVA | RVF | RVD | RVC | RVS =
| RVU);
>      env->priv_ver =3D PRIV_VERSION_1_10_0;
>  #ifndef CONFIG_USER_ONLY
>      set_satp_mode_max_supported(RISCV_CPU(obj), VM_1_10_SV39);
> @@ -452,7 +442,7 @@ static void rv64_sifive_e_cpu_init(Object *obj)
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>
> -    riscv_cpu_set_misa(env, MXL_RV64, RVI | RVM | RVA | RVC | RVU);
> +    riscv_cpu_set_misa_ext(env, RVI | RVM | RVA | RVC | RVU);
>      env->priv_ver =3D PRIV_VERSION_1_10_0;
>  #ifndef CONFIG_USER_ONLY
>      set_satp_mode_max_supported(cpu, VM_1_10_MBARE);
> @@ -469,7 +459,7 @@ static void rv64_thead_c906_cpu_init(Object *obj)
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>
> -    riscv_cpu_set_misa(env, MXL_RV64, RVG | RVC | RVS | RVU);
> +    riscv_cpu_set_misa_ext(env, RVG | RVC | RVS | RVU);
>      env->priv_ver =3D PRIV_VERSION_1_11_0;
>
>      cpu->cfg.ext_zfa =3D true;
> @@ -500,7 +490,7 @@ static void rv64_veyron_v1_cpu_init(Object *obj)
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>
> -    riscv_cpu_set_misa(env, MXL_RV64, RVG | RVC | RVS | RVU | RVH);
> +    riscv_cpu_set_misa_ext(env, RVG | RVC | RVS | RVU | RVH);
>      env->priv_ver =3D PRIV_VERSION_1_12_0;
>
>      /* Enable ISA extensions */
> @@ -544,8 +534,6 @@ static void rv128_base_cpu_init(Object *obj)
>          exit(EXIT_FAILURE);
>      }
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
> -    /* We set this in the realise function */
> -    riscv_cpu_set_misa(env, MXL_RV128, 0);
>      /* Set latest version of privileged specification */
>      env->priv_ver =3D PRIV_VERSION_LATEST;
>  #ifndef CONFIG_USER_ONLY
> @@ -556,8 +544,6 @@ static void rv128_base_cpu_init(Object *obj)
>  static void rv32_base_cpu_init(Object *obj)
>  {
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
> -    /* We set this in the realise function */
> -    riscv_cpu_set_misa(env, MXL_RV32, 0);
>      /* Set latest version of privileged specification */
>      env->priv_ver =3D PRIV_VERSION_LATEST;
>  #ifndef CONFIG_USER_ONLY
> @@ -569,8 +555,7 @@ static void rv32_sifive_u_cpu_init(Object *obj)
>  {
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>      CPURISCVState *env =3D &cpu->env;
> -    riscv_cpu_set_misa(env, MXL_RV32,
> -                       RVI | RVM | RVA | RVF | RVD | RVC | RVS | RVU);
> +    riscv_cpu_set_misa_ext(env, RVI | RVM | RVA | RVF | RVD | RVC | RVS =
| RVU);
>      env->priv_ver =3D PRIV_VERSION_1_10_0;
>  #ifndef CONFIG_USER_ONLY
>      set_satp_mode_max_supported(RISCV_CPU(obj), VM_1_10_SV32);
> @@ -588,7 +573,7 @@ static void rv32_sifive_e_cpu_init(Object *obj)
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>
> -    riscv_cpu_set_misa(env, MXL_RV32, RVI | RVM | RVA | RVC | RVU);
> +    riscv_cpu_set_misa_ext(env, RVI | RVM | RVA | RVC | RVU);
>      env->priv_ver =3D PRIV_VERSION_1_10_0;
>  #ifndef CONFIG_USER_ONLY
>      set_satp_mode_max_supported(cpu, VM_1_10_MBARE);
> @@ -605,7 +590,7 @@ static void rv32_ibex_cpu_init(Object *obj)
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>
> -    riscv_cpu_set_misa(env, MXL_RV32, RVI | RVM | RVC | RVU);
> +    riscv_cpu_set_misa_ext(env, RVI | RVM | RVC | RVU);
>      env->priv_ver =3D PRIV_VERSION_1_12_0;
>  #ifndef CONFIG_USER_ONLY
>      set_satp_mode_max_supported(cpu, VM_1_10_MBARE);
> @@ -622,7 +607,7 @@ static void rv32_imafcu_nommu_cpu_init(Object *obj)
>      CPURISCVState *env =3D &RISCV_CPU(obj)->env;
>      RISCVCPU *cpu =3D RISCV_CPU(obj);
>
> -    riscv_cpu_set_misa(env, MXL_RV32, RVI | RVM | RVA | RVF | RVC | RVU)=
;
> +    riscv_cpu_set_misa_ext(env, RVI | RVM | RVA | RVF | RVC | RVU);
>      env->priv_ver =3D PRIV_VERSION_1_10_0;
>  #ifndef CONFIG_USER_ONLY
>      set_satp_mode_max_supported(cpu, VM_1_10_MBARE);
> @@ -845,7 +830,7 @@ static void riscv_cpu_reset_hold(Object *obj)
>          mcc->parent_phases.hold(obj);
>      }
>  #ifndef CONFIG_USER_ONLY
> -    env->misa_mxl =3D env->misa_mxl_max;
> +    env->misa_mxl =3D mcc->misa_mxl_max;
>      env->priv =3D PRV_M;
>      env->mstatus &=3D ~(MSTATUS_MIE | MSTATUS_MPRV);
>      if (env->misa_mxl > MXL_RV32) {
> @@ -1213,6 +1198,12 @@ static void riscv_cpu_post_init(Object *obj)
>
>  static void riscv_cpu_init(Object *obj)
>  {
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(obj);
> +    RISCVCPU *cpu =3D RISCV_CPU(obj);
> +    CPURISCVState *env =3D &cpu->env;
> +
> +    env->misa_mxl =3D mcc->misa_mxl_max;
> +
>  #ifndef CONFIG_USER_ONLY
>      qdev_init_gpio_in(DEVICE(obj), riscv_cpu_set_irq,
>                        IRQ_LOCAL_MAX + IRQ_LOCAL_GUEST_MAX);
> @@ -1657,7 +1648,7 @@ static void cpu_get_marchid(Object *obj, Visitor *v=
, const char *name,
>      visit_type_bool(v, name, &value, errp);
>  }
>
> -static void riscv_cpu_class_init(ObjectClass *c, void *data)
> +static void riscv_cpu_common_class_init(ObjectClass *c, void *data)
>  {
>      RISCVCPUClass *mcc =3D RISCV_CPU_CLASS(c);
>      CPUClass *cc =3D CPU_CLASS(c);
> @@ -1699,6 +1690,13 @@ static void riscv_cpu_class_init(ObjectClass *c, v=
oid *data)
>      device_class_set_props(dc, riscv_cpu_properties);
>  }
>
> +static void riscv_cpu_class_init(ObjectClass *c, void *data)
> +{
> +    RISCVCPUClass *mcc =3D RISCV_CPU_CLASS(c);
> +
> +    mcc->misa_mxl_max =3D (uint32_t)(uintptr_t)data;
> +}
> +
>  static void riscv_isa_string_ext(RISCVCPU *cpu, char **isa_str,
>                                   int max_str_len)
>  {
> @@ -1764,18 +1762,22 @@ void riscv_cpu_list(void)
>      g_slist_free(list);
>  }
>
> -#define DEFINE_CPU(type_name, initfn)      \
> -    {                                      \
> -        .name =3D type_name,                 \
> -        .parent =3D TYPE_RISCV_CPU,          \
> -        .instance_init =3D initfn            \
> +#define DEFINE_CPU(type_name, misa_mxl_max, initfn)         \
> +    {                                                       \
> +        .name =3D (type_name),                                \
> +        .parent =3D TYPE_RISCV_CPU,                           \
> +        .instance_init =3D (initfn),                          \
> +        .class_init =3D riscv_cpu_class_init,                 \
> +        .class_data =3D (void *)(misa_mxl_max)                \
>      }
>
> -#define DEFINE_DYNAMIC_CPU(type_name, initfn) \
> -    {                                         \
> -        .name =3D type_name,                    \
> -        .parent =3D TYPE_RISCV_DYNAMIC_CPU,     \
> -        .instance_init =3D initfn               \
> +#define DEFINE_DYNAMIC_CPU(type_name, misa_mxl_max, initfn) \
> +    {                                                       \
> +        .name =3D (type_name),                                \
> +        .parent =3D TYPE_RISCV_DYNAMIC_CPU,                   \
> +        .instance_init =3D (initfn),                          \
> +        .class_init =3D riscv_cpu_class_init,                 \
> +        .class_data =3D (void *)(misa_mxl_max)                \
>      }
>
>  static const TypeInfo riscv_cpu_type_infos[] =3D {
> @@ -1788,29 +1790,31 @@ static const TypeInfo riscv_cpu_type_infos[] =3D =
{
>          .instance_post_init =3D riscv_cpu_post_init,
>          .abstract =3D true,
>          .class_size =3D sizeof(RISCVCPUClass),
> -        .class_init =3D riscv_cpu_class_init,
> +        .class_init =3D riscv_cpu_common_class_init,
>      },
>      {
>          .name =3D TYPE_RISCV_DYNAMIC_CPU,
>          .parent =3D TYPE_RISCV_CPU,
>          .abstract =3D true,
>      },
> -    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_ANY,      riscv_any_cpu_init),
> -    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_MAX,      riscv_max_cpu_init),
>  #if defined(TARGET_RISCV32)
> -    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_BASE32,   rv32_base_cpu_init),
> -    DEFINE_CPU(TYPE_RISCV_CPU_IBEX,             rv32_ibex_cpu_init),
> -    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E31,       rv32_sifive_e_cpu_init),
> -    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E34,       rv32_imafcu_nommu_cpu_in=
it),
> -    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U34,       rv32_sifive_u_cpu_init),
> +    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_ANY,     MXL_RV32,  riscv_any_cpu_=
init),
> +    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_MAX,     MXL_RV32,  riscv_max_cpu_=
init),
> +    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_BASE32,  MXL_RV32,  rv32_base_cpu_=
init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_IBEX,            MXL_RV32,  rv32_ibex_cpu_=
init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E31,      MXL_RV32,  rv32_sifive_e_=
cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E34,      MXL_RV32,  rv32_imafcu_no=
mmu_cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U34,      MXL_RV32,  rv32_sifive_u_=
cpu_init),
>  #elif defined(TARGET_RISCV64)
> -    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_BASE64,   rv64_base_cpu_init),
> -    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E51,       rv64_sifive_e_cpu_init),
> -    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U54,       rv64_sifive_u_cpu_init),
> -    DEFINE_CPU(TYPE_RISCV_CPU_SHAKTI_C,         rv64_sifive_u_cpu_init),
> -    DEFINE_CPU(TYPE_RISCV_CPU_THEAD_C906,       rv64_thead_c906_cpu_init=
),
> -    DEFINE_CPU(TYPE_RISCV_CPU_VEYRON_V1,        rv64_veyron_v1_cpu_init)=
,
> -    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_BASE128,  rv128_base_cpu_init),
> +    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_ANY,     MXL_RV64,  riscv_any_cpu_=
init),
> +    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_MAX,     MXL_RV64,  riscv_max_cpu_=
init),
> +    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_BASE64,  MXL_RV64,  rv64_base_cpu_=
init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E51,      MXL_RV64,  rv64_sifive_e_=
cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U54,      MXL_RV64,  rv64_sifive_u_=
cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_SHAKTI_C,        MXL_RV64,  rv64_sifive_u_=
cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_THEAD_C906,      MXL_RV64,  rv64_thead_c90=
6_cpu_init),
> +    DEFINE_CPU(TYPE_RISCV_CPU_VEYRON_V1,       MXL_RV64,  rv64_veyron_v1=
_cpu_init),
> +    DEFINE_DYNAMIC_CPU(TYPE_RISCV_CPU_BASE128, MXL_RV128, rv128_base_cpu=
_init),
>  #endif
>  };
>
> diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
> index 58b3ace0fe9..365040228a1 100644
> --- a/target/riscv/gdbstub.c
> +++ b/target/riscv/gdbstub.c
> @@ -49,6 +49,7 @@ static const struct TypeSize vec_lanes[] =3D {
>
>  int riscv_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n=
)
>  {
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cs);
>      RISCVCPU *cpu =3D RISCV_CPU(cs);
>      CPURISCVState *env =3D &cpu->env;
>      target_ulong tmp;
> @@ -61,7 +62,7 @@ int riscv_cpu_gdb_read_register(CPUState *cs, GByteArra=
y *mem_buf, int n)
>          return 0;
>      }
>
> -    switch (env->misa_mxl_max) {
> +    switch (mcc->misa_mxl_max) {
>      case MXL_RV32:
>          return gdb_get_reg32(mem_buf, tmp);
>      case MXL_RV64:
> @@ -75,12 +76,13 @@ int riscv_cpu_gdb_read_register(CPUState *cs, GByteAr=
ray *mem_buf, int n)
>
>  int riscv_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
>  {
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cs);
>      RISCVCPU *cpu =3D RISCV_CPU(cs);
>      CPURISCVState *env =3D &cpu->env;
>      int length =3D 0;
>      target_ulong tmp;
>
> -    switch (env->misa_mxl_max) {
> +    switch (mcc->misa_mxl_max) {
>      case MXL_RV32:
>          tmp =3D (int32_t)ldl_p(mem_buf);
>          length =3D 4;
> @@ -214,11 +216,12 @@ static int riscv_gdb_set_virtual(CPURISCVState *cs,=
 uint8_t *mem_buf, int n)
>
>  static int riscv_gen_dynamic_csr_xml(CPUState *cs, int base_reg)
>  {
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cs);
>      RISCVCPU *cpu =3D RISCV_CPU(cs);
>      CPURISCVState *env =3D &cpu->env;
>      GString *s =3D g_string_new(NULL);
>      riscv_csr_predicate_fn predicate;
> -    int bitsize =3D 16 << env->misa_mxl_max;
> +    int bitsize =3D 16 << mcc->misa_mxl_max;
>      int i;
>
>  #if !defined(CONFIG_USER_ONLY)
> @@ -310,6 +313,7 @@ static int ricsv_gen_dynamic_vector_xml(CPUState *cs,=
 int base_reg)
>
>  void riscv_cpu_register_gdb_regs_for_features(CPUState *cs)
>  {
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cs);
>      RISCVCPU *cpu =3D RISCV_CPU(cs);
>      CPURISCVState *env =3D &cpu->env;
>      if (env->misa_ext & RVD) {
> @@ -326,7 +330,7 @@ void riscv_cpu_register_gdb_regs_for_features(CPUStat=
e *cs)
>                                   ricsv_gen_dynamic_vector_xml(cs, base_r=
eg),
>                                   "riscv-vector.xml", 0);
>      }
> -    switch (env->misa_mxl_max) {
> +    switch (mcc->misa_mxl_max) {
>      case MXL_RV32:
>          gdb_register_coprocessor(cs, riscv_gdb_get_virtual,
>                                   riscv_gdb_set_virtual,
> diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
> index 117e33cf90f..ed86f21b8f2 100644
> --- a/target/riscv/kvm/kvm-cpu.c
> +++ b/target/riscv/kvm/kvm-cpu.c
> @@ -1499,14 +1499,14 @@ static void kvm_cpu_accel_register_types(void)
>  }
>  type_init(kvm_cpu_accel_register_types);
>
> -static void riscv_host_cpu_init(Object *obj)
> +static void riscv_host_cpu_class_init(ObjectClass *c, void *data)
>  {
> -    CPURISCVState *env =3D &RISCV_CPU(obj)->env;
> +    RISCVCPUClass *mcc =3D RISCV_CPU_CLASS(c);
>
>  #if defined(TARGET_RISCV32)
> -    env->misa_mxl_max =3D env->misa_mxl =3D MXL_RV32;
> +    mcc->misa_mxl_max =3D MXL_RV32;
>  #elif defined(TARGET_RISCV64)
> -    env->misa_mxl_max =3D env->misa_mxl =3D MXL_RV64;
> +    mcc->misa_mxl_max =3D MXL_RV64;
>  #endif
>  }
>
> @@ -1514,7 +1514,7 @@ static const TypeInfo riscv_kvm_cpu_type_infos[] =
=3D {
>      {
>          .name =3D TYPE_RISCV_CPU_HOST,
>          .parent =3D TYPE_RISCV_CPU,
> -        .instance_init =3D riscv_host_cpu_init,
> +        .class_init =3D riscv_host_cpu_class_init,
>      }
>  };
>
> diff --git a/target/riscv/machine.c b/target/riscv/machine.c
> index fdde243e040..4c8d9a66595 100644
> --- a/target/riscv/machine.c
> +++ b/target/riscv/machine.c
> @@ -178,10 +178,9 @@ static const VMStateDescription vmstate_pointermaski=
ng =3D {
>
>  static bool rv128_needed(void *opaque)
>  {
> -    RISCVCPU *cpu =3D opaque;
> -    CPURISCVState *env =3D &cpu->env;
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(opaque);
>
> -    return env->misa_mxl_max =3D=3D MXL_RV128;
> +    return mcc->misa_mxl_max =3D=3D MXL_RV128;
>  }
>
>  static const VMStateDescription vmstate_rv128 =3D {
> @@ -372,7 +371,7 @@ const VMStateDescription vmstate_riscv_cpu =3D {
>          VMSTATE_UINTTL(env.vext_ver, RISCVCPU),
>          VMSTATE_UINT32(env.misa_mxl, RISCVCPU),
>          VMSTATE_UINT32(env.misa_ext, RISCVCPU),
> -        VMSTATE_UINT32(env.misa_mxl_max, RISCVCPU),
> +        VMSTATE_UNUSED(4),
>          VMSTATE_UINT32(env.misa_ext_mask, RISCVCPU),
>          VMSTATE_UINTTL(env.priv, RISCVCPU),
>          VMSTATE_BOOL(env.virt_enabled, RISCVCPU),
> diff --git a/target/riscv/tcg/tcg-cpu.c b/target/riscv/tcg/tcg-cpu.c
> index ee17f65afb6..7f6712c81a4 100644
> --- a/target/riscv/tcg/tcg-cpu.c
> +++ b/target/riscv/tcg/tcg-cpu.c
> @@ -152,10 +152,9 @@ static void riscv_cpu_validate_misa_mxl(RISCVCPU *cp=
u)
>  {
>      RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cpu);
>      CPUClass *cc =3D CPU_CLASS(mcc);
> -    CPURISCVState *env =3D &cpu->env;
>
>      /* Validate that MISA_MXL is set properly. */
> -    switch (env->misa_mxl_max) {
> +    switch (mcc->misa_mxl_max) {
>  #ifdef TARGET_RISCV64
>      case MXL_RV64:
>      case MXL_RV128:
> @@ -274,6 +273,7 @@ static void riscv_cpu_disable_priv_spec_isa_exts(RISC=
VCPU *cpu)
>   */
>  void riscv_cpu_validate_set_extensions(RISCVCPU *cpu, Error **errp)
>  {
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cpu);
>      CPURISCVState *env =3D &cpu->env;
>      Error *local_err =3D NULL;
>
> @@ -454,7 +454,7 @@ void riscv_cpu_validate_set_extensions(RISCVCPU *cpu,=
 Error **errp)
>          cpu_cfg_ext_auto_update(cpu, CPU_CFG_OFFSET(ext_zcb), true);
>          cpu_cfg_ext_auto_update(cpu, CPU_CFG_OFFSET(ext_zcmp), true);
>          cpu_cfg_ext_auto_update(cpu, CPU_CFG_OFFSET(ext_zcmt), true);
> -        if (riscv_has_ext(env, RVF) && env->misa_mxl_max =3D=3D MXL_RV32=
) {
> +        if (riscv_has_ext(env, RVF) && mcc->misa_mxl_max =3D=3D MXL_RV32=
) {
>              cpu_cfg_ext_auto_update(cpu, CPU_CFG_OFFSET(ext_zcf), true);
>          }
>      }
> @@ -462,7 +462,7 @@ void riscv_cpu_validate_set_extensions(RISCVCPU *cpu,=
 Error **errp)
>      /* zca, zcd and zcf has a PRIV 1.12.0 restriction */
>      if (riscv_has_ext(env, RVC) && env->priv_ver >=3D PRIV_VERSION_1_12_=
0) {
>          cpu_cfg_ext_auto_update(cpu, CPU_CFG_OFFSET(ext_zca), true);
> -        if (riscv_has_ext(env, RVF) && env->misa_mxl_max =3D=3D MXL_RV32=
) {
> +        if (riscv_has_ext(env, RVF) && mcc->misa_mxl_max =3D=3D MXL_RV32=
) {
>              cpu_cfg_ext_auto_update(cpu, CPU_CFG_OFFSET(ext_zcf), true);
>          }
>          if (riscv_has_ext(env, RVD)) {
> @@ -470,7 +470,7 @@ void riscv_cpu_validate_set_extensions(RISCVCPU *cpu,=
 Error **errp)
>          }
>      }
>
> -    if (env->misa_mxl_max !=3D MXL_RV32 && cpu->cfg.ext_zcf) {
> +    if (mcc->misa_mxl_max !=3D MXL_RV32 && cpu->cfg.ext_zcf) {
>          error_setg(errp, "Zcf extension is only relevant to RV32");
>          return;
>      }
> @@ -956,7 +956,7 @@ static void riscv_init_max_cpu_extensions(Object *obj=
)
>      const RISCVCPUMultiExtConfig *prop;
>
>      /* Enable RVG, RVJ and RVV that are disabled by default */
> -    riscv_cpu_set_misa(env, env->misa_mxl, env->misa_ext | RVG | RVJ | R=
VV);
> +    riscv_cpu_set_misa_ext(env, env->misa_ext | RVG | RVJ | RVV);
>
>      for (prop =3D riscv_cpu_extensions; prop && prop->name; prop++) {
>          isa_ext_update_enabled(cpu, prop->offset, true);
> diff --git a/target/riscv/translate.c b/target/riscv/translate.c
> index f0be79bb160..7e383c5eebf 100644
> --- a/target/riscv/translate.c
> +++ b/target/riscv/translate.c
> @@ -1167,6 +1167,7 @@ static void riscv_tr_init_disas_context(DisasContex=
tBase *dcbase, CPUState *cs)
>  {
>      DisasContext *ctx =3D container_of(dcbase, DisasContext, base);
>      CPURISCVState *env =3D cpu_env(cs);
> +    RISCVCPUClass *mcc =3D RISCV_CPU_GET_CLASS(cs);
>      RISCVCPU *cpu =3D RISCV_CPU(cs);
>      uint32_t tb_flags =3D ctx->base.tb->flags;
>
> @@ -1188,7 +1189,7 @@ static void riscv_tr_init_disas_context(DisasContex=
tBase *dcbase, CPUState *cs)
>      ctx->cfg_vta_all_1s =3D cpu->cfg.rvv_ta_all_1s;
>      ctx->vstart_eq_zero =3D FIELD_EX32(tb_flags, TB_FLAGS, VSTART_EQ_ZER=
O);
>      ctx->vl_eq_vlmax =3D FIELD_EX32(tb_flags, TB_FLAGS, VL_EQ_VLMAX);
> -    ctx->misa_mxl_max =3D env->misa_mxl_max;
> +    ctx->misa_mxl_max =3D mcc->misa_mxl_max;
>      ctx->xl =3D FIELD_EX32(tb_flags, TB_FLAGS, XL);
>      ctx->address_xl =3D FIELD_EX32(tb_flags, TB_FLAGS, AXL);
>      ctx->cs =3D cs;
> --
> 2.39.2
>
>

