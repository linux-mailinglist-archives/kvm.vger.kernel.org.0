Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ABD6DAC5D
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjDGLwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 07:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjDGLwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 07:52:21 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81E07AB9
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 04:52:18 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lj25so7853200ejb.11
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 04:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680868337; x=1683460337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdfn4AG0v98kMFfWXlNvJoHdyetRuMoKcxcIOMaSanI=;
        b=ONq4wtVzRUgn6dq4M1SbIGAd32aIqzJXZK5tVU26F+7Qfgks43K67ur6LN/EhWVOkn
         ojpbFRFfS+oStL5oR2ycq/CN7VaodX1SNfrqdygXTuysNGzCS5o54LmNwB4YE2TxnA/K
         iH8WTKYjszlANYrRP1+6A8Ah6HSLjb4D/CEhGY6Op9a8rn+z11NEKAzmFuqQu++T4Red
         5YjidrrOITyWwCQ2DhWO2WeZ1TqaCtbK9xhdVDpueqLeuw6UoZfD7KPSTpnczWKHI298
         LEZNi/F8jHeUi4YSbRsTWZX/xsw5nmhrn+MCgwv3XXQAYdfQtV6GhcXE0d71/pfasXy7
         V0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680868337; x=1683460337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdfn4AG0v98kMFfWXlNvJoHdyetRuMoKcxcIOMaSanI=;
        b=TJmkrCYnyNqIkJ1hT+ibZzvdI835UQtNYfW9uUG7E8MCiImfMH5APPr4Ji5fM7hGTS
         KHQGMWZ9Bv5VRfp+nVh6r0Y/1IMQu4MVpFkz8CFGP6HtwxB8+gQVc0NI7P3wGu2bzBJ4
         Ku+ooNgXWPgsdv6ol25vwgdpOffEdaX8jgjpHlHpN6qixPTJtDGMaUeTy7loYoIXfYPq
         deKmtWYIqyBAEyTRcgWXtYSsPzrJhK/qKfTWwhqtF2hae4c0MeGvZnShTLe0OQiQdIMs
         1U1AavnxbMUFijC5D9J769Koy2Te99ZbjJAIOeb08QuSVE4YhfPO2Es38Kib3bjw//68
         Wxfg==
X-Gm-Message-State: AAQBX9dkTqkqX/Gl/N/TMHMCnViDjNBb+W1faS+oyrhTlBB7xO+et3bi
        iSC5IQXL/bLDS+6QmmR4XhzKkVgto9JWA4s+gXe1Ig==
X-Google-Smtp-Source: AKy350bhg08fEo8JbhIMSLNZD1NSvxn7AskudFcp4pAXsSWUP1mdi1lUDAJvY4xsnQ5PagcA/kh/+y4N/SO2pfCtTg8=
X-Received: by 2002:a17:906:ac1:b0:949:2293:1d1a with SMTP id
 z1-20020a1709060ac100b0094922931d1amr1009244ejf.13.1680868337230; Fri, 07 Apr
 2023 04:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230403121527.2286489-1-apatel@ventanamicro.com> <20230403121527.2286489-2-apatel@ventanamicro.com>
In-Reply-To: <20230403121527.2286489-2-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 7 Apr 2023 17:22:06 +0530
Message-ID: <CAAhSdy355T-=vC2d5mr8KpA418ynO9ETdxO7fO8CH0ba=9mYmg@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] RISC-V: KVM: Add ONE_REG interface to
 enable/disable SBI extensions
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
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

On Mon, Apr 3, 2023 at 5:45=E2=80=AFPM Anup Patel <apatel@ventanamicro.com>=
 wrote:
>
> We add ONE_REG interface to enable/disable SBI extensions (just
> like the ONE_REG interface for ISA extensions). This allows KVM
> user-space to decide the set of SBI extension enabled for a Guest
> and by default all SBI extensions are enabled.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Queued this patch for Linux-6.4

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
>  arch/riscv/include/uapi/asm/kvm.h     |  32 ++++
>  arch/riscv/kvm/vcpu.c                 |   4 +
>  arch/riscv/kvm/vcpu_sbi.c             | 247 ++++++++++++++++++++++++--
>  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
>  5 files changed, 274 insertions(+), 19 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index 8425556af7d1..4278125a38a5 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -16,6 +16,7 @@
>
>  struct kvm_vcpu_sbi_context {
>         int return_handled;
> +       bool extension_disabled[KVM_RISCV_SBI_EXT_MAX];
>  };
>
>  struct kvm_vcpu_sbi_return {
> @@ -45,7 +46,12 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *=
vcpu,
>                                      struct kvm_run *run,
>                                      u32 type, u64 flags);
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run=
);
> -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long=
 extid);
> +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +                                  const struct kvm_one_reg *reg);
> +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +                                  const struct kvm_one_reg *reg);
> +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> +                               struct kvm_vcpu *vcpu, unsigned long exti=
d);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)=
;
>
>  #ifdef CONFIG_RISCV_SBI_V01
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 92af6f3f057c..d8ead5952ed9 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -12,6 +12,7 @@
>  #ifndef __ASSEMBLY__
>
>  #include <linux/types.h>
> +#include <asm/bitsperlong.h>
>  #include <asm/ptrace.h>
>
>  #define __KVM_HAVE_READONLY_MEM
> @@ -108,6 +109,23 @@ enum KVM_RISCV_ISA_EXT_ID {
>         KVM_RISCV_ISA_EXT_MAX,
>  };
>
> +/*
> + * SBI extension IDs specific to KVM. This is not the same as the SBI
> + * extension IDs defined by the RISC-V SBI specification.
> + */
> +enum KVM_RISCV_SBI_EXT_ID {
> +       KVM_RISCV_SBI_EXT_V01 =3D 0,
> +       KVM_RISCV_SBI_EXT_TIME,
> +       KVM_RISCV_SBI_EXT_IPI,
> +       KVM_RISCV_SBI_EXT_RFENCE,
> +       KVM_RISCV_SBI_EXT_SRST,
> +       KVM_RISCV_SBI_EXT_HSM,
> +       KVM_RISCV_SBI_EXT_PMU,
> +       KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> +       KVM_RISCV_SBI_EXT_VENDOR,
> +       KVM_RISCV_SBI_EXT_MAX,
> +};
> +
>  /* Possible states for kvm_riscv_timer */
>  #define KVM_RISCV_TIMER_STATE_OFF      0
>  #define KVM_RISCV_TIMER_STATE_ON       1
> @@ -118,6 +136,8 @@ enum KVM_RISCV_ISA_EXT_ID {
>  /* If you need to interpret the index values, here is the key: */
>  #define KVM_REG_RISCV_TYPE_MASK                0x00000000FF000000
>  #define KVM_REG_RISCV_TYPE_SHIFT       24
> +#define KVM_REG_RISCV_SUBTYPE_MASK     0x0000000000FF0000
> +#define KVM_REG_RISCV_SUBTYPE_SHIFT    16
>
>  /* Config registers are mapped as type 1 */
>  #define KVM_REG_RISCV_CONFIG           (0x01 << KVM_REG_RISCV_TYPE_SHIFT=
)
> @@ -152,6 +172,18 @@ enum KVM_RISCV_ISA_EXT_ID {
>  /* ISA Extension registers are mapped as type 7 */
>  #define KVM_REG_RISCV_ISA_EXT          (0x07 << KVM_REG_RISCV_TYPE_SHIFT=
)
>
> +/* SBI extension registers are mapped as type 8 */
> +#define KVM_REG_RISCV_SBI_EXT          (0x08 << KVM_REG_RISCV_TYPE_SHIFT=
)
> +#define KVM_REG_RISCV_SBI_SINGLE       (0x0 << KVM_REG_RISCV_SUBTYPE_SHI=
FT)
> +#define KVM_REG_RISCV_SBI_MULTI_EN     (0x1 << KVM_REG_RISCV_SUBTYPE_SHI=
FT)
> +#define KVM_REG_RISCV_SBI_MULTI_DIS    (0x2 << KVM_REG_RISCV_SUBTYPE_SHI=
FT)
> +#define KVM_REG_RISCV_SBI_MULTI_REG(__ext_id)  \
> +               ((__ext_id) / __BITS_PER_LONG)
> +#define KVM_REG_RISCV_SBI_MULTI_MASK(__ext_id) \
> +               (1UL << ((__ext_id) % __BITS_PER_LONG))
> +#define KVM_REG_RISCV_SBI_MULTI_REG_LAST       \
> +               KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
> +
>  #endif
>
>  #endif /* __LINUX_KVM_RISCV_H */
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7d010b0be54e..3112697cb12d 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -601,6 +601,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vc=
pu,
>                                                  KVM_REG_RISCV_FP_D);
>         case KVM_REG_RISCV_ISA_EXT:
>                 return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
> +       case KVM_REG_RISCV_SBI_EXT:
> +               return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
>         default:
>                 break;
>         }
> @@ -628,6 +630,8 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vc=
pu,
>                                                  KVM_REG_RISCV_FP_D);
>         case KVM_REG_RISCV_ISA_EXT:
>                 return kvm_riscv_vcpu_get_reg_isa_ext(vcpu, reg);
> +       case KVM_REG_RISCV_SBI_EXT:
> +               return kvm_riscv_vcpu_get_reg_sbi_ext(vcpu, reg);
>         default:
>                 break;
>         }
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 15fde15f9fb8..e52fde504433 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -30,17 +30,52 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_e=
xt_pmu =3D {
>  };
>  #endif
>
> -static const struct kvm_vcpu_sbi_extension *sbi_ext[] =3D {
> -       &vcpu_sbi_ext_v01,
> -       &vcpu_sbi_ext_base,
> -       &vcpu_sbi_ext_time,
> -       &vcpu_sbi_ext_ipi,
> -       &vcpu_sbi_ext_rfence,
> -       &vcpu_sbi_ext_srst,
> -       &vcpu_sbi_ext_hsm,
> -       &vcpu_sbi_ext_pmu,
> -       &vcpu_sbi_ext_experimental,
> -       &vcpu_sbi_ext_vendor,
> +struct kvm_riscv_sbi_extension_entry {
> +       enum KVM_RISCV_SBI_EXT_ID dis_idx;
> +       const struct kvm_vcpu_sbi_extension *ext_ptr;
> +};
> +
> +static const struct kvm_riscv_sbi_extension_entry sbi_ext[] =3D {
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_V01,
> +               .ext_ptr =3D &vcpu_sbi_ext_v01,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled =
*/
> +               .ext_ptr =3D &vcpu_sbi_ext_base,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_TIME,
> +               .ext_ptr =3D &vcpu_sbi_ext_time,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_IPI,
> +               .ext_ptr =3D &vcpu_sbi_ext_ipi,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_RFENCE,
> +               .ext_ptr =3D &vcpu_sbi_ext_rfence,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_SRST,
> +               .ext_ptr =3D &vcpu_sbi_ext_srst,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_HSM,
> +               .ext_ptr =3D &vcpu_sbi_ext_hsm,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_PMU,
> +               .ext_ptr =3D &vcpu_sbi_ext_pmu,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> +               .ext_ptr =3D &vcpu_sbi_ext_experimental,
> +       },
> +       {
> +               .dis_idx =3D KVM_RISCV_SBI_EXT_VENDOR,
> +               .ext_ptr =3D &vcpu_sbi_ext_vendor,
> +       },
>  };
>
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *r=
un)
> @@ -99,14 +134,192 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
>         return 0;
>  }
>
> -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long=
 extid)
> +static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
> +                                        unsigned long reg_num,
> +                                        unsigned long reg_val)
> +{
> +       unsigned long i;
> +       const struct kvm_riscv_sbi_extension_entry *sext =3D NULL;
> +       struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> +
> +       if (reg_num >=3D KVM_RISCV_SBI_EXT_MAX ||
> +           (reg_val !=3D 1 && reg_val !=3D 0))
> +               return -EINVAL;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +               if (sbi_ext[i].dis_idx =3D=3D reg_num) {
> +                       sext =3D &sbi_ext[i];
> +                       break;
> +               }
> +       }
> +       if (!sext)
> +               return -ENOENT;
> +
> +       scontext->extension_disabled[sext->dis_idx] =3D !reg_val;
> +
> +       return 0;
> +}
> +
> +static int riscv_vcpu_get_sbi_ext_single(struct kvm_vcpu *vcpu,
> +                                        unsigned long reg_num,
> +                                        unsigned long *reg_val)
> +{
> +       unsigned long i;
> +       const struct kvm_riscv_sbi_extension_entry *sext =3D NULL;
> +       struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> +
> +       if (reg_num >=3D KVM_RISCV_SBI_EXT_MAX)
> +               return -EINVAL;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +               if (sbi_ext[i].dis_idx =3D=3D reg_num) {
> +                       sext =3D &sbi_ext[i];
> +                       break;
> +               }
> +       }
> +       if (!sext)
> +               return -ENOENT;
> +
> +       *reg_val =3D !scontext->extension_disabled[sext->dis_idx];
> +
> +       return 0;
> +}
> +
> +static int riscv_vcpu_set_sbi_ext_multi(struct kvm_vcpu *vcpu,
> +                                       unsigned long reg_num,
> +                                       unsigned long reg_val, bool enabl=
e)
> +{
> +       unsigned long i, ext_id;
> +
> +       if (reg_num > KVM_REG_RISCV_SBI_MULTI_REG_LAST)
> +               return -EINVAL;
> +
> +       for_each_set_bit(i, &reg_val, BITS_PER_LONG) {
> +               ext_id =3D i + reg_num * BITS_PER_LONG;
> +               if (ext_id >=3D KVM_RISCV_SBI_EXT_MAX)
> +                       break;
> +
> +               riscv_vcpu_set_sbi_ext_single(vcpu, ext_id, enable);
> +       }
> +
> +       return 0;
> +}
> +
> +static int riscv_vcpu_get_sbi_ext_multi(struct kvm_vcpu *vcpu,
> +                                       unsigned long reg_num,
> +                                       unsigned long *reg_val)
> +{
> +       unsigned long i, ext_id, ext_val;
> +
> +       if (reg_num > KVM_REG_RISCV_SBI_MULTI_REG_LAST)
> +               return -EINVAL;
> +
> +       for (i =3D 0; i < BITS_PER_LONG; i++) {
> +               ext_id =3D i + reg_num * BITS_PER_LONG;
> +               if (ext_id >=3D KVM_RISCV_SBI_EXT_MAX)
> +                       break;
> +
> +               ext_val =3D 0;
> +               riscv_vcpu_get_sbi_ext_single(vcpu, ext_id, &ext_val);
> +               if (ext_val)
> +                       *reg_val |=3D KVM_REG_RISCV_SBI_MULTI_MASK(ext_id=
);
> +       }
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +                                  const struct kvm_one_reg *reg)
> +{
> +       unsigned long __user *uaddr =3D
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_SBI_EXT);
> +       unsigned long reg_val, reg_subtype;
> +
> +       if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       if (vcpu->arch.ran_atleast_once)
> +               return -EBUSY;
> +
> +       reg_subtype =3D reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> +       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> +
> +       if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       switch (reg_subtype) {
> +       case KVM_REG_RISCV_SBI_SINGLE:
> +               return riscv_vcpu_set_sbi_ext_single(vcpu, reg_num, reg_v=
al);
> +       case KVM_REG_RISCV_SBI_MULTI_EN:
> +               return riscv_vcpu_set_sbi_ext_multi(vcpu, reg_num, reg_va=
l, true);
> +       case KVM_REG_RISCV_SBI_MULTI_DIS:
> +               return riscv_vcpu_set_sbi_ext_multi(vcpu, reg_num, reg_va=
l, false);
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +                                  const struct kvm_one_reg *reg)
> +{
> +       int rc;
> +       unsigned long __user *uaddr =3D
> +                       (unsigned long __user *)(unsigned long)reg->addr;
> +       unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> +                                           KVM_REG_SIZE_MASK |
> +                                           KVM_REG_RISCV_SBI_EXT);
> +       unsigned long reg_val, reg_subtype;
> +
> +       if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> +               return -EINVAL;
> +
> +       reg_subtype =3D reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> +       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> +
> +       reg_val =3D 0;
> +       switch (reg_subtype) {
> +       case KVM_REG_RISCV_SBI_SINGLE:
> +               rc =3D riscv_vcpu_get_sbi_ext_single(vcpu, reg_num, &reg_=
val);
> +               break;
> +       case KVM_REG_RISCV_SBI_MULTI_EN:
> +       case KVM_REG_RISCV_SBI_MULTI_DIS:
> +               rc =3D riscv_vcpu_get_sbi_ext_multi(vcpu, reg_num, &reg_v=
al);
> +               if (!rc && reg_subtype =3D=3D KVM_REG_RISCV_SBI_MULTI_DIS=
)
> +                       reg_val =3D ~reg_val;
> +               break;
> +       default:
> +               rc =3D -EINVAL;
> +       }
> +       if (rc)
> +               return rc;
> +
> +       if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> +                               struct kvm_vcpu *vcpu, unsigned long exti=
d)
>  {
> -       int i =3D 0;
> +       int i;
> +       const struct kvm_riscv_sbi_extension_entry *sext;
> +       struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
>
>         for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> -               if (sbi_ext[i]->extid_start <=3D extid &&
> -                   sbi_ext[i]->extid_end >=3D extid)
> -                       return sbi_ext[i];
> +               sext =3D &sbi_ext[i];
> +               if (sext->ext_ptr->extid_start <=3D extid &&
> +                   sext->ext_ptr->extid_end >=3D extid) {
> +                       if (sext->dis_idx < KVM_RISCV_SBI_EXT_MAX &&
> +                           scontext->extension_disabled[sext->dis_idx])
> +                               return NULL;
> +                       return sbi_ext[i].ext_ptr;
> +               }
>         }
>
>         return NULL;
> @@ -126,7 +339,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, s=
truct kvm_run *run)
>         };
>         bool ext_is_v01 =3D false;
>
> -       sbi_ext =3D kvm_vcpu_sbi_find_ext(cp->a7);
> +       sbi_ext =3D kvm_vcpu_sbi_find_ext(vcpu, cp->a7);
>         if (sbi_ext && sbi_ext->handler) {
>  #ifdef CONFIG_RISCV_SBI_V01
>                 if (cp->a7 >=3D SBI_EXT_0_1_SET_TIMER &&
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_bas=
e.c
> index 9945aff34c14..5bc570b984f4 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -44,7 +44,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>                         kvm_riscv_vcpu_sbi_forward(vcpu, run);
>                         retdata->uexit =3D true;
>                 } else {
> -                       sbi_ext =3D kvm_vcpu_sbi_find_ext(cp->a0);
> +                       sbi_ext =3D kvm_vcpu_sbi_find_ext(vcpu, cp->a0);
>                         *out_val =3D sbi_ext && sbi_ext->probe ?
>                                            sbi_ext->probe(vcpu) : !!sbi_e=
xt;
>                 }
> --
> 2.34.1
>
