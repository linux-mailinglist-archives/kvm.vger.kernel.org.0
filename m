Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8446CABEB
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 19:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjC0Rgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 13:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjC0Rgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 13:36:38 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA42E40CB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 10:36:36 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so39374154ede.8
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 10:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1679938595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSATOuP6ZP1FqSuSN1CJjKHXrNE2Dfr3DEmtzL0kCY0=;
        b=S8kBf4Pt4yB1UwMWzqtsnZduMf/zvjP88S1Wrr93lVPoEL7SA98e4ZqosqKNTtafl+
         QIiqCWYHLqJS9Ekqznsjl9eRnc1ZJgtUu0Mh87ChYPXrRB0IzSi8P2aMEfPA8fXaXdQv
         iK183TYbtqwO3XmqOGLEXjr4cUj4mrafIK4QDoeO2uY5sY6oOf7Sj9POD849SB5CjlaB
         2k92fHmhH/wyHNYY7wsJPXsVv1jha9Kgu8sTMXslNK9qtoDo7WHxpvStFoe0SdAopdnt
         oAvvvpBFMsjQKxw4ba9qWNjNITskTlXFNa5Nubw+xXwdm1ZsVk8jHMusHLbIEO6wNto2
         gY0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679938595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSATOuP6ZP1FqSuSN1CJjKHXrNE2Dfr3DEmtzL0kCY0=;
        b=oVwjJ4CV9KqGPsNM5tgAfNveSkD1BVq4tVVSZXsKZ3CjvTiZM3aow021BJVVLPffwY
         4+UExamiLecqPaliJUiBFRrwPK1Dr3NNMCFwRMPLgp0VMJjK37aImU6BOfAyn+JQGQAc
         hQrXKBCtD56tIhgZRyYGXjyulAn0UHOkihBdwfxmNUbaT5ZTc61pXBJqqUbBVqzBCsnu
         cDtiUIcFbzm2kRxZZWK05VqRVwsRDHhuiOIo+ZAAr5phaw2LMAtFPms7iOhYKgoNz6ZX
         TVDBXdQjgC+nLD+hXJH2QlECydxY1Dn1s8bAw2O5/hfSx0G2C9B2iqW5mb/8Gy555pcy
         R1jw==
X-Gm-Message-State: AAQBX9f36O56uxd25V9cBjGulYBF9rQpRY+IRSfHo8LKPg6YvAW8i+5s
        9mbxSkph3J3aaJPRbNNqq9D/1llvdGn/GRQkKhnkkg==
X-Google-Smtp-Source: AKy350byGQHmMsV9vJeUEUR1vOuaVeVo1Sk3VSzkZxBeXa2swRjBFsoX7eDh4HisUplPH29tmGfbOLwZMalOBMeThTA=
X-Received: by 2002:a17:906:524a:b0:933:3fba:b978 with SMTP id
 y10-20020a170906524a00b009333fbab978mr5387796ejm.13.1679938595076; Mon, 27
 Mar 2023 10:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230327164941.20491-1-andy.chiu@sifive.com> <20230327164941.20491-19-andy.chiu@sifive.com>
In-Reply-To: <20230327164941.20491-19-andy.chiu@sifive.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 27 Mar 2023 23:06:23 +0530
Message-ID: <CAAhSdy3xq_yK-_GXFcw_OVkhpqz==guYQkDo3u7Wzf7+Gd_tGQ@mail.gmail.com>
Subject: Re: [PATCH -next v17 18/20] riscv: KVM: Add vector lazy save/restore support
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 10:21=E2=80=AFPM Andy Chiu <andy.chiu@sifive.com> w=
rote:
>
> From: Vincent Chen <vincent.chen@sifive.com>
>
> This patch adds vector context save/restore for guest VCPUs. To reduce th=
e
> impact on KVM performance, the implementation imitates the FP context
> switch mechanism to lazily store and restore the vector context only when
> the kernel enters/exits the in-kernel run loop and not during the KVM
> world switch.
>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h        |   2 +
>  arch/riscv/include/asm/kvm_vcpu_vector.h |  82 ++++++++++
>  arch/riscv/include/uapi/asm/kvm.h        |   7 +
>  arch/riscv/kvm/Makefile                  |   1 +
>  arch/riscv/kvm/vcpu.c                    |  22 +++
>  arch/riscv/kvm/vcpu_vector.c             | 186 +++++++++++++++++++++++
>  6 files changed, 300 insertions(+)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_vector.h
>  create mode 100644 arch/riscv/kvm/vcpu_vector.c
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index cc7da66ee0c0..7e7e23272d32 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -14,6 +14,7 @@
>  #include <linux/kvm_types.h>
>  #include <linux/spinlock.h>
>  #include <asm/hwcap.h>
> +#include <asm/ptrace.h>
>  #include <asm/kvm_vcpu_fp.h>
>  #include <asm/kvm_vcpu_insn.h>
>  #include <asm/kvm_vcpu_sbi.h>
> @@ -141,6 +142,7 @@ struct kvm_cpu_context {
>         unsigned long sstatus;
>         unsigned long hstatus;
>         union __riscv_fp_state fp;
> +       struct __riscv_v_ext_state vector;
>  };
>
>  struct kvm_vcpu_csr {
> diff --git a/arch/riscv/include/asm/kvm_vcpu_vector.h b/arch/riscv/includ=
e/asm/kvm_vcpu_vector.h
> new file mode 100644
> index 000000000000..ff994fdd6d0d
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_vector.h
> @@ -0,0 +1,82 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2022 SiFive
> + *
> + * Authors:
> + *     Vincent Chen <vincent.chen@sifive.com>
> + *     Greentime Hu <greentime.hu@sifive.com>
> + */
> +
> +#ifndef __KVM_VCPU_RISCV_VECTOR_H
> +#define __KVM_VCPU_RISCV_VECTOR_H
> +
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_RISCV_ISA_V
> +#include <asm/vector.h>
> +#include <asm/kvm_host.h>
> +
> +static __always_inline void __kvm_riscv_vector_save(struct kvm_cpu_conte=
xt *context)
> +{
> +       __riscv_v_vstate_save(&context->vector, context->vector.datap);
> +}
> +
> +static __always_inline void __kvm_riscv_vector_restore(struct kvm_cpu_co=
ntext *context)
> +{
> +       __riscv_v_vstate_restore(&context->vector, context->vector.datap)=
;
> +}
> +
> +void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
> +                                     unsigned long *isa);
> +void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
> +                                        unsigned long *isa);
> +void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx);
> +void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx);
> +int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
> +                                       struct kvm_cpu_context *cntx);
> +void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu);
> +#else
> +
> +struct kvm_cpu_context;
> +
> +static inline void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_conte=
xt *cntx,
> +                                                   unsigned long *isa)
> +{
> +}
> +
> +static inline void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_co=
ntext *cntx,
> +                                                      unsigned long *isa=
)
> +{
> +}
> +
> +static inline void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_contex=
t *cntx)
> +{
> +}
> +
> +static inline void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_con=
text *cntx)
> +{
> +}
> +
> +static inline int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *v=
cpu,
> +                                                     struct kvm_cpu_cont=
ext *cntx)
> +{
> +       return 0;
> +}
> +
> +static inline void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *v=
cpu)
> +{
> +}
> +#endif
> +
> +int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
> +                                 const struct kvm_one_reg *reg,
> +                                 unsigned long rtype);
> +int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
> +                                 const struct kvm_one_reg *reg,
> +                                 unsigned long rtype);
> +#endif
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index d562dcb929ea..0955f9460447 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -155,6 +155,13 @@ enum KVM_RISCV_ISA_EXT_ID {
>  /* ISA Extension registers are mapped as type 7 */
>  #define KVM_REG_RISCV_ISA_EXT          (0x07 << KVM_REG_RISCV_TYPE_SHIFT=
)
>
> +/* V extension registers are mapped as type 8 */
> +#define KVM_REG_RISCV_VECTOR           (0x08 << KVM_REG_RISCV_TYPE_SHIFT=
)
> +#define KVM_REG_RISCV_VECTOR_CSR_REG(name)     \
> +               (offsetof(struct __riscv_v_ext_state, name) / sizeof(unsi=
gned long))
> +#define KVM_REG_RISCV_VECTOR_REG(n)    \
> +               ((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsign=
ed long))
> +
>  #endif
>
>  #endif /* __LINUX_KVM_RISCV_H */
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 278e97c06e0a..f29854333cf2 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -17,6 +17,7 @@ kvm-y +=3D mmu.o
>  kvm-y +=3D vcpu.o
>  kvm-y +=3D vcpu_exit.o
>  kvm-y +=3D vcpu_fp.o
> +kvm-y +=3D vcpu_vector.o
>  kvm-y +=3D vcpu_insn.o
>  kvm-y +=3D vcpu_switch.o
>  kvm-y +=3D vcpu_sbi.o
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index bfdd5b73d462..c495ae1a8091 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -22,6 +22,8 @@
>  #include <asm/cacheflush.h>
>  #include <asm/hwcap.h>
>  #include <asm/sbi.h>
> +#include <asm/vector.h>
> +#include <asm/kvm_vcpu_vector.h>
>
>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D {
>         KVM_GENERIC_VCPU_STATS(),
> @@ -135,6 +137,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcp=
u)
>
>         kvm_riscv_vcpu_fp_reset(vcpu);
>
> +       kvm_riscv_vcpu_vector_reset(vcpu);
> +
>         kvm_riscv_vcpu_timer_reset(vcpu);
>
>         WRITE_ONCE(vcpu->arch.irqs_pending, 0);
> @@ -192,6 +196,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         cntx->hstatus |=3D HSTATUS_SPVP;
>         cntx->hstatus |=3D HSTATUS_SPV;
>
> +       if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
> +               return -ENOMEM;
> +
>         /* By default, make CY, TM, and IR counters accessible in VU mode=
 */
>         reset_csr->scounteren =3D 0x7;
>
> @@ -227,6 +234,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>
>         /* Free unused pages pre-allocated for G-stage page table mapping=
s */
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +
> +       /* Free vector context space for host and guest kernel */
> +       kvm_riscv_vcpu_free_vector_context(vcpu);
>  }
>
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> @@ -610,6 +620,9 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vc=
pu,
>                                                  KVM_REG_RISCV_FP_D);
>         case KVM_REG_RISCV_ISA_EXT:
>                 return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
> +       case KVM_REG_RISCV_VECTOR:
> +               return kvm_riscv_vcpu_set_reg_vector(vcpu, reg,
> +                                                KVM_REG_RISCV_VECTOR);
>         default:
>                 break;
>         }
> @@ -637,6 +650,9 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vc=
pu,
>                                                  KVM_REG_RISCV_FP_D);
>         case KVM_REG_RISCV_ISA_EXT:
>                 return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
> +       case KVM_REG_RISCV_VECTOR:
> +               return kvm_riscv_vcpu_get_reg_vector(vcpu, reg,
> +                                                KVM_REG_RISCV_VECTOR);
>         default:
>                 break;
>         }
> @@ -906,6 +922,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cp=
u)
>         kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
>         kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
>                                         vcpu->arch.isa);
> +       kvm_riscv_vcpu_host_vector_save(&vcpu->arch.host_context);
> +       kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
> +                                           vcpu->arch.isa);
>
>         vcpu->cpu =3D cpu;
>  }
> @@ -921,6 +940,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
>
>         kvm_riscv_vcpu_timer_save(vcpu);
> +       kvm_riscv_vcpu_guest_vector_save(&vcpu->arch.guest_context,
> +                                        vcpu->arch.isa);
> +       kvm_riscv_vcpu_host_vector_restore(&vcpu->arch.host_context);
>
>         csr->vsstatus =3D csr_read(CSR_VSSTATUS);
>         csr->vsie =3D csr_read(CSR_VSIE);
> diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
> new file mode 100644
> index 000000000000..edd2eecbddc2
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_vector.c
> @@ -0,0 +1,186 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 SiFive
> + *
> + * Authors:
> + *     Vincent Chen <vincent.chen@sifive.com>
> + *     Greentime Hu <greentime.hu@sifive.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <linux/uaccess.h>
> +#include <asm/hwcap.h>
> +#include <asm/kvm_vcpu_vector.h>
> +#include <asm/vector.h>
> +
> +#ifdef CONFIG_RISCV_ISA_V
> +void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long *isa =3D vcpu->arch.isa;
> +       struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
> +
> +       cntx->sstatus &=3D ~SR_VS;
> +       if (riscv_isa_extension_available(isa, v)) {
> +               cntx->sstatus |=3D SR_VS_INITIAL;
> +               WARN_ON(!cntx->vector.datap);
> +               memset(cntx->vector.datap, 0, riscv_v_vsize);
> +       } else {
> +               cntx->sstatus |=3D SR_VS_OFF;
> +       }
> +}
> +
> +static void kvm_riscv_vcpu_vector_clean(struct kvm_cpu_context *cntx)
> +{
> +       cntx->sstatus &=3D ~SR_VS;
> +       cntx->sstatus |=3D SR_VS_CLEAN;
> +}
> +
> +void kvm_riscv_vcpu_guest_vector_save(struct kvm_cpu_context *cntx,
> +                                     unsigned long *isa)
> +{
> +       if ((cntx->sstatus & SR_VS) =3D=3D SR_VS_DIRTY) {
> +               if (riscv_isa_extension_available(isa, v))
> +                       __kvm_riscv_vector_save(cntx);
> +               kvm_riscv_vcpu_vector_clean(cntx);
> +       }
> +}
> +
> +void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
> +                                        unsigned long *isa)
> +{
> +       if ((cntx->sstatus & SR_VS) !=3D SR_VS_OFF) {
> +               if (riscv_isa_extension_available(isa, v))
> +                       __kvm_riscv_vector_restore(cntx);
> +               kvm_riscv_vcpu_vector_clean(cntx);
> +       }
> +}
> +
> +void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx)
> +{
> +       /* No need to check host sstatus as it can be modified outside */
> +       if (riscv_isa_extension_available(NULL, v))
> +               __kvm_riscv_vector_save(cntx);
> +}
> +
> +void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx)
> +{
> +       if (riscv_isa_extension_available(NULL, v))
> +               __kvm_riscv_vector_restore(cntx);
> +}
> +
> +int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
> +                                       struct kvm_cpu_context *cntx)
> +{
> +       cntx->vector.datap =3D kmalloc(riscv_v_vsize, GFP_KERNEL);
> +       if (!cntx->vector.datap)
> +               return -ENOMEM;
> +
> +       vcpu->arch.host_context.vector.datap =3D kzalloc(riscv_v_vsize, G=
FP_KERNEL);
> +       if (!vcpu->arch.host_context.vector.datap)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
> +{
> +       kfree(vcpu->arch.guest_reset_context.vector.datap);
> +       kfree(vcpu->arch.host_context.vector.datap);
> +}
> +#endif
> +
> +static void *kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
> +                                     unsigned long reg_num,
> +                                     size_t reg_size)
> +{
> +       struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
> +       void *reg_val;
> +       size_t vlenb =3D riscv_v_vsize / 32;
> +
> +       if (reg_num < KVM_REG_RISCV_VECTOR_REG(0)) {
> +               if (reg_size !=3D sizeof(unsigned long))
> +                       return NULL;
> +               switch (reg_num) {
> +               case KVM_REG_RISCV_VECTOR_CSR_REG(vstart):
> +                       reg_val =3D &cntx->vector.vstart;
> +                       break;
> +               case KVM_REG_RISCV_VECTOR_CSR_REG(vl):
> +                       reg_val =3D &cntx->vector.vl;
> +                       break;
> +               case KVM_REG_RISCV_VECTOR_CSR_REG(vtype):
> +                       reg_val =3D &cntx->vector.vtype;
> +                       break;
> +               case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
> +                       reg_val =3D &cntx->vector.vcsr;
> +                       break;
> +               case KVM_REG_RISCV_VECTOR_CSR_REG(datap):
> +               default:
> +                       return NULL;
> +               }
> +       } else if (reg_num <=3D KVM_REG_RISCV_VECTOR_REG(31)) {
> +               if (reg_size !=3D vlenb)
> +                       return NULL;
> +               reg_val =3D cntx->vector.datap
> +                         + (reg_num - KVM_REG_RISCV_VECTOR_REG(0)) * vle=
nb;
> +       } else {
> +               return NULL;
> +       }
> +
> +       return reg_val;
> +}
> +
> +int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
> +                                 const struct kvm_one_reg *reg,
> +                                 unsigned long rtype)
> +{
> +       unsigned long *isa =3D vcpu->arch.isa;
> +       unsigned long __user *uaddr =3D
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           rtype);
> +       void *reg_val =3D NULL;
> +       size_t reg_size =3D KVM_REG_SIZE(reg->id);
> +
> +       if (rtype =3D=3D KVM_REG_RISCV_VECTOR &&
> +           riscv_isa_extension_available(isa, v)) {
> +               reg_val =3D kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_s=
ize);
> +       }
> +
> +       if (!reg_val)
> +               return -EINVAL;
> +
> +       if (copy_to_user(uaddr, reg_val, reg_size))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
> +                                 const struct kvm_one_reg *reg,
> +                                 unsigned long rtype)
> +{
> +       unsigned long *isa =3D vcpu->arch.isa;
> +       unsigned long __user *uaddr =3D
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           rtype);
> +       void *reg_val =3D NULL;
> +       size_t reg_size =3D KVM_REG_SIZE(reg->id);
> +
> +       if (rtype =3D=3D KVM_REG_RISCV_VECTOR &&
> +           riscv_isa_extension_available(isa, v)) {
> +               reg_val =3D kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_s=
ize);
> +       }
> +
> +       if (!reg_val)
> +               return -EINVAL;
> +
> +       if (copy_from_user(reg_val, uaddr, reg_size))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> --
> 2.17.1
>
