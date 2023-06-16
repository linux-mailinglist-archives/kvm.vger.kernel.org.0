Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5630E7328F9
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 09:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjFPHfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 03:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245368AbjFPHfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 03:35:13 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11018DF
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 00:35:12 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b4420a8c44so4209461fa.2
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 00:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686900910; x=1689492910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H1j80AwpMkKggqs8JmwcVb7r4+TSqY0M2+PEoCgbGaQ=;
        b=n0rkyQFpCrFkjxi0k33DMxWY76a+6oC/tXuVgF+FlA8I0dNziZl/JDIpP2nnqsZYdY
         l0JOGFvRuH2bjtBD97WxDf5ULr8yVdelWn4de0sZZWAZhLhdoXIWFBpicP5sznM4mZ1m
         kE49OQ06Briwnh2HhBWzThEXw4wIo9O2nRZrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686900910; x=1689492910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1j80AwpMkKggqs8JmwcVb7r4+TSqY0M2+PEoCgbGaQ=;
        b=jEdUI4avK1F+D9egXXZUTgBsKyuYF5RlXkPVxxcOsI9VaEpWHEgSs+oFWTZaTB6YKm
         H1BFLpbIc7EI/9DsrjplJ/HV5RwTxfQmf4XyvyiLJe6Xc5YjlXeh3Ve8gf6yh4MeRnE/
         bkxj+cdWId9dZ1J7N+gmc4cszeYDUHB/hzFqkKYDhovthYg+6KJ4tGKRzfQihC370nSy
         y1ul89xTAMSR+G2xNzw0gCyRWN1IFIXWDzUl+3aXinMfent4NEUed3zHjm2BSt1/WtdN
         qQCeRsPphuzshmti1vAwTWLrN3q0IKi+VnIsve6bsQSkKMDqNQ5B03nGuXt4Hqgp6QRe
         spTw==
X-Gm-Message-State: AC+VfDydwV9RUeGXubWEb/2sMM10AjLHg/mckH1Ixo6bEWvLu4kirVrc
        MLTH6u7T3FITcJduVjd5bJAGtx0ovKuIu2a3kbW+
X-Google-Smtp-Source: ACHHUZ43YpdHWcjr24UbBiPB5GuakeWk8t7eRVinOjbsCz7rlcDmqcSVxsPDNZRIG096Z8PlRx7m8GYC/NTB/4nDBSA=
X-Received: by 2002:a2e:980a:0:b0:2b3:356c:94d6 with SMTP id
 a10-20020a2e980a000000b002b3356c94d6mr888795ljj.16.1686900910233; Fri, 16 Jun
 2023 00:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230615073353.85435-1-apatel@ventanamicro.com> <20230615073353.85435-9-apatel@ventanamicro.com>
In-Reply-To: <20230615073353.85435-9-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 16 Jun 2023 00:34:58 -0700
Message-ID: <CAOnJCUJG9ewVvFP7H+6++m0x=Mkc5RLMnBTdiSvcu61vZSvapw@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] RISC-V: KVM: Expose APLIC registers as
 attributes of AIA irqchip
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 12:34=E2=80=AFAM Anup Patel <apatel@ventanamicro.co=
m> wrote:
>
> We expose APLIC registers as KVM device attributes of the in-kernel
> AIA irqchip device. This will allow KVM user-space to save/restore
> APLIC state using KVM device ioctls().
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  |  3 +++
>  arch/riscv/include/uapi/asm/kvm.h |  6 +++++
>  arch/riscv/kvm/aia_aplic.c        | 43 +++++++++++++++++++++++++++++++
>  arch/riscv/kvm/aia_device.c       | 25 ++++++++++++++++++
>  4 files changed, 77 insertions(+)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index f6bd8523395f..ba939c0054aa 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -129,6 +129,9 @@ static inline void kvm_riscv_vcpu_aia_imsic_cleanup(s=
truct kvm_vcpu *vcpu)
>  {
>  }
>
> +int kvm_riscv_aia_aplic_set_attr(struct kvm *kvm, unsigned long type, u3=
2 v);
> +int kvm_riscv_aia_aplic_get_attr(struct kvm *kvm, unsigned long type, u3=
2 *v);
> +int kvm_riscv_aia_aplic_has_attr(struct kvm *kvm, unsigned long type);
>  int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level);
>  int kvm_riscv_aia_aplic_init(struct kvm *kvm);
>  void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm);
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 047c8fc5bd71..9ed822fc5589 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -249,6 +249,12 @@ enum KVM_RISCV_SBI_EXT_ID {
>  #define KVM_DEV_RISCV_AIA_GRP_CTRL             2
>  #define KVM_DEV_RISCV_AIA_CTRL_INIT            0
>
> +/*
> + * The device attribute type contains the memory mapped offset of the
> + * APLIC register (range 0x0000-0x3FFF) and it must be 4-byte aligned.
> + */
> +#define KVM_DEV_RISCV_AIA_GRP_APLIC            3
> +
>  /* One single KVM irqchip, ie. the AIA */
>  #define KVM_NR_IRQCHIPS                        1
>
> diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
> index eecd8f4abe21..39e72aa016a4 100644
> --- a/arch/riscv/kvm/aia_aplic.c
> +++ b/arch/riscv/kvm/aia_aplic.c
> @@ -501,6 +501,49 @@ static struct kvm_io_device_ops aplic_iodoev_ops =3D=
 {
>         .write =3D aplic_mmio_write,
>  };
>
> +int kvm_riscv_aia_aplic_set_attr(struct kvm *kvm, unsigned long type, u3=
2 v)
> +{
> +       int rc;
> +
> +       if (!kvm->arch.aia.aplic_state)
> +               return -ENODEV;
> +
> +       rc =3D aplic_mmio_write_offset(kvm, type, v);
> +       if (rc)
> +               return rc;
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_aia_aplic_get_attr(struct kvm *kvm, unsigned long type, u3=
2 *v)
> +{
> +       int rc;
> +
> +       if (!kvm->arch.aia.aplic_state)
> +               return -ENODEV;
> +
> +       rc =3D aplic_mmio_read_offset(kvm, type, v);
> +       if (rc)
> +               return rc;
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_aia_aplic_has_attr(struct kvm *kvm, unsigned long type)
> +{
> +       int rc;
> +       u32 val;
> +
> +       if (!kvm->arch.aia.aplic_state)
> +               return -ENODEV;
> +
> +       rc =3D aplic_mmio_read_offset(kvm, type, &val);
> +       if (rc)
> +               return rc;
> +
> +       return 0;
> +}
> +
>  int kvm_riscv_aia_aplic_init(struct kvm *kvm)
>  {
>         int i, ret =3D 0;
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 7ab555121872..c649ad6e8e0a 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -365,6 +365,15 @@ static int aia_set_attr(struct kvm_device *dev, stru=
ct kvm_device_attr *attr)
>                         break;
>                 }
>
> +               break;
> +       case KVM_DEV_RISCV_AIA_GRP_APLIC:
> +               if (copy_from_user(&nr, uaddr, sizeof(nr)))
> +                       return -EFAULT;
> +
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D kvm_riscv_aia_aplic_set_attr(dev->kvm, type, nr);
> +               mutex_unlock(&dev->kvm->lock);
> +
>                 break;
>         }
>
> @@ -412,6 +421,20 @@ static int aia_get_attr(struct kvm_device *dev, stru=
ct kvm_device_attr *attr)
>                 if (copy_to_user(uaddr, &addr, sizeof(addr)))
>                         return -EFAULT;
>
> +               break;
> +       case KVM_DEV_RISCV_AIA_GRP_APLIC:
> +               if (copy_from_user(&nr, uaddr, sizeof(nr)))
> +                       return -EFAULT;
> +
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D kvm_riscv_aia_aplic_get_attr(dev->kvm, type, &nr);
> +               mutex_unlock(&dev->kvm->lock);
> +               if (r)
> +                       return r;
> +
> +               if (copy_to_user(uaddr, &nr, sizeof(nr)))
> +                       return -EFAULT;
> +
>                 break;
>         }
>
> @@ -448,6 +471,8 @@ static int aia_has_attr(struct kvm_device *dev, struc=
t kvm_device_attr *attr)
>                         return 0;
>                 }
>                 break;
> +       case KVM_DEV_RISCV_AIA_GRP_APLIC:
> +               return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr)=
;
>         }
>
>         return -ENXIO;
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish
