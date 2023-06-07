Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700D77272C5
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbjFGXQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjFGXQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:16:32 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C77B1BD4
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:16:27 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b1b92845e1so59297611fa.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686179786; x=1688771786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bie/vDMqvtGJ9KUFdn4S3+rln+43JzXBguUUjbJWDf0=;
        b=Zmv3JYo41Cars8zSPA2vqRVCzBkNtMHFBVkB7CHEkWZNj4Fe6amEbyS5MNAtPfEzSR
         E3Hpzf7dtlAVszpGiO2S21iqv4W0mcko6nrrQqrfEsMwKngSdj6ZL+DFgxDsnKM9KbCj
         /zDyQjJu3PLvzsYH9gzKSiR3jtk6RTPkY6RY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686179786; x=1688771786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bie/vDMqvtGJ9KUFdn4S3+rln+43JzXBguUUjbJWDf0=;
        b=RADH7miRJAE0u2na6LT1MExl+8bWKj5V/sYTgKSWnweyVQTHfJu/dyk08COhxSe8ta
         +xDdSFjK+SYfOztFTrRvAkrB3L5zfTjjZS/QpciKgbjthEgGgwzWyaU0FkQDQw860RK0
         +fF+6NniZ5tffxlSI53N7ytUpMmpyw4fS8ARJrprIp3Bx/J+Ql6+OTyWop1UsAJX6jFK
         rWpHDx5IwK55L2peQZBgZys5Vdddu5Dy75rPoe1OiuoFGA8z5uGQ3F6dDnax1+rUNpu4
         KEXvSvsKMAdGbtrw5dfqhHSDfZJkTOJpk55Ip2TlBbHeCKYLFnCPRsDNYDlxHBR1yRoX
         Rrow==
X-Gm-Message-State: AC+VfDweDDds8PX0DjgT9zaHMsSXe6rqyfosruK0MAEe5OGTZ60e9wUe
        WxzG8E1G8VXZgNxa4q4A1a9nQ6R4Z2Gl2t5b1Mx8
X-Google-Smtp-Source: ACHHUZ6hlcFbP/2pAo0yUv+Rxd1mZOkQwPVJHfoctBEZXxs1YBhoJen6QqktnVueE5WKwnIGAMn0rWk7JwmRW2ACgX8=
X-Received: by 2002:a2e:9792:0:b0:2b1:eb6f:df73 with SMTP id
 y18-20020a2e9792000000b002b1eb6fdf73mr2939288lji.35.1686179785604; Wed, 07
 Jun 2023 16:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230517105135.1871868-1-apatel@ventanamicro.com> <20230517105135.1871868-10-apatel@ventanamicro.com>
In-Reply-To: <20230517105135.1871868-10-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 7 Jun 2023 16:16:14 -0700
Message-ID: <CAOnJCU+jq-oZCpZcLQ-KWgWXzwiaswdouLrwYGXDGGNJ3yyG8g@mail.gmail.com>
Subject: Re: [PATCH 09/10] RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
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

On Wed, May 17, 2023 at 3:52=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> We can have AIA IMSIC support for both HS-level and VS-level but
> the VS-level IMSICs are optional. We use the VS-level IMSICs for
> Guest/VM whenever available otherwise we fallback to software
> emulation of AIA IMSIC.
>
> This patch adds in-kernel virtualization of AIA IMSIC.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h |  46 +-
>  arch/riscv/kvm/Makefile          |   1 +
>  arch/riscv/kvm/aia_imsic.c       | 913 +++++++++++++++++++++++++++++++
>  3 files changed, 924 insertions(+), 36 deletions(-)
>  create mode 100644 arch/riscv/kvm/aia_imsic.c
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index ba939c0054aa..a4f6ebf90e31 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -90,44 +90,18 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>
>  extern struct kvm_device_ops kvm_riscv_aia_device_ops;
>
> -static inline void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcp=
u)
> -{
> -}
> -
> -static inline int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
> -{
> -       return 1;
> -}
> +void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu);
>
>  #define KVM_RISCV_AIA_IMSIC_TOPEI      (ISELECT_MASK + 1)
> -static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
> -                                              unsigned long isel,
> -                                              unsigned long *val,
> -                                              unsigned long new_val,
> -                                              unsigned long wr_mask)
> -{
> -       return 0;
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu)
> -{
> -}
> -
> -static inline int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
> -                                                 u32 guest_index, u32 of=
fset,
> -                                                 u32 iid)
> -{
> -       return 0;
> -}
> -
> -static inline int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
> -{
> -       return 0;
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcp=
u)
> -{
> -}
> +int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu, unsigned long is=
el,
> +                                unsigned long *val, unsigned long new_va=
l,
> +                                unsigned long wr_mask);
> +void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
> +                                   u32 guest_index, u32 offset, u32 iid)=
;
> +int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcpu);
>
>  int kvm_riscv_aia_aplic_set_attr(struct kvm *kvm, unsigned long type, u3=
2 v);
>  int kvm_riscv_aia_aplic_get_attr(struct kvm *kvm, unsigned long type, u3=
2 *v);
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 94c43702c765..c1d1356387ff 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -29,3 +29,4 @@ kvm-$(CONFIG_RISCV_PMU_SBI) +=3D vcpu_pmu.o vcpu_sbi_pm=
u.o
>  kvm-y +=3D aia.o
>  kvm-y +=3D aia_device.o
>  kvm-y +=3D aia_aplic.o
> +kvm-y +=3D aia_imsic.o
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> new file mode 100644
> index 000000000000..2dc09dcb8ab5
> --- /dev/null
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -0,0 +1,913 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Western Digital Corporation or its affiliates.
> + * Copyright (C) 2022 Ventana Micro Systems Inc.
> + *
> + * Authors:
> + *     Anup Patel <apatel@ventanamicro.com>
> + */
> +
> +#include <linux/bitmap.h>
> +#include <linux/kvm_host.h>
> +#include <linux/math.h>
> +#include <linux/spinlock.h>
> +#include <linux/swab.h>
> +#include <kvm/iodev.h>
> +#include <asm/csr.h>
> +#include <asm/kvm_aia_imsic.h>
> +
> +#define IMSIC_MAX_EIX  (IMSIC_MAX_ID / BITS_PER_TYPE(u64))
> +
> +struct imsic_mrif_eix {
> +       unsigned long eip[BITS_PER_TYPE(u64) / BITS_PER_LONG];
> +       unsigned long eie[BITS_PER_TYPE(u64) / BITS_PER_LONG];
> +};
> +
> +struct imsic_mrif {
> +       struct imsic_mrif_eix eix[IMSIC_MAX_EIX];
> +       unsigned long eithreshold;
> +       unsigned long eidelivery;
> +};
> +
> +struct imsic {
> +       struct kvm_io_device iodev;
> +
> +       u32 nr_msis;
> +       u32 nr_eix;
> +       u32 nr_hw_eix;
> +
> +       /*
> +        * At any point in time, the register state is in
> +        * one of the following places:
> +        *
> +        * 1) Hardware: IMSIC VS-file (vsfile_cpu >=3D 0)
> +        * 2) Software: IMSIC SW-file (vsfile_cpu < 0)
> +        */
> +
> +       /* IMSIC VS-file */
> +       rwlock_t vsfile_lock;
> +       int vsfile_cpu;
> +       int vsfile_hgei;
> +       void __iomem *vsfile_va;
> +       phys_addr_t vsfile_pa;
> +
> +       /* IMSIC SW-file */
> +       struct imsic_mrif *swfile;
> +       phys_addr_t swfile_pa;
> +};
> +
> +#define imsic_vs_csr_read(__c)                 \
> +({                                             \
> +       unsigned long __r;                      \
> +       csr_write(CSR_VSISELECT, __c);          \
> +       __r =3D csr_read(CSR_VSIREG);             \
> +       __r;                                    \
> +})
> +
> +#define imsic_read_switchcase(__ireg)                  \
> +       case __ireg:                                    \
> +               return imsic_vs_csr_read(__ireg);
> +#define imsic_read_switchcase_2(__ireg)                        \
> +       imsic_read_switchcase(__ireg + 0)               \
> +       imsic_read_switchcase(__ireg + 1)
> +#define imsic_read_switchcase_4(__ireg)                        \
> +       imsic_read_switchcase_2(__ireg + 0)             \
> +       imsic_read_switchcase_2(__ireg + 2)
> +#define imsic_read_switchcase_8(__ireg)                        \
> +       imsic_read_switchcase_4(__ireg + 0)             \
> +       imsic_read_switchcase_4(__ireg + 4)
> +#define imsic_read_switchcase_16(__ireg)               \
> +       imsic_read_switchcase_8(__ireg + 0)             \
> +       imsic_read_switchcase_8(__ireg + 8)
> +#define imsic_read_switchcase_32(__ireg)               \
> +       imsic_read_switchcase_16(__ireg + 0)            \
> +       imsic_read_switchcase_16(__ireg + 16)
> +#define imsic_read_switchcase_64(__ireg)               \
> +       imsic_read_switchcase_32(__ireg + 0)            \
> +       imsic_read_switchcase_32(__ireg + 32)
> +
> +static unsigned long imsic_eix_read(int ireg)
> +{
> +       switch (ireg) {
> +       imsic_read_switchcase_64(IMSIC_EIP0)
> +       imsic_read_switchcase_64(IMSIC_EIE0)
> +       };
> +
> +       return 0;
> +}
> +
> +#define imsic_vs_csr_swap(__c, __v)            \
> +({                                             \
> +       unsigned long __r;                      \
> +       csr_write(CSR_VSISELECT, __c);          \
> +       __r =3D csr_swap(CSR_VSIREG, __v);        \
> +       __r;                                    \
> +})
> +
> +#define imsic_swap_switchcase(__ireg, __v)             \
> +       case __ireg:                                    \
> +               return imsic_vs_csr_swap(__ireg, __v);
> +#define imsic_swap_switchcase_2(__ireg, __v)           \
> +       imsic_swap_switchcase(__ireg + 0, __v)          \
> +       imsic_swap_switchcase(__ireg + 1, __v)
> +#define imsic_swap_switchcase_4(__ireg, __v)           \
> +       imsic_swap_switchcase_2(__ireg + 0, __v)        \
> +       imsic_swap_switchcase_2(__ireg + 2, __v)
> +#define imsic_swap_switchcase_8(__ireg, __v)           \
> +       imsic_swap_switchcase_4(__ireg + 0, __v)        \
> +       imsic_swap_switchcase_4(__ireg + 4, __v)
> +#define imsic_swap_switchcase_16(__ireg, __v)          \
> +       imsic_swap_switchcase_8(__ireg + 0, __v)        \
> +       imsic_swap_switchcase_8(__ireg + 8, __v)
> +#define imsic_swap_switchcase_32(__ireg, __v)          \
> +       imsic_swap_switchcase_16(__ireg + 0, __v)       \
> +       imsic_swap_switchcase_16(__ireg + 16, __v)
> +#define imsic_swap_switchcase_64(__ireg, __v)          \
> +       imsic_swap_switchcase_32(__ireg + 0, __v)       \
> +       imsic_swap_switchcase_32(__ireg + 32, __v)
> +
> +static unsigned long imsic_eix_swap(int ireg, unsigned long val)
> +{
> +       switch (ireg) {
> +       imsic_swap_switchcase_64(IMSIC_EIP0, val)
> +       imsic_swap_switchcase_64(IMSIC_EIE0, val)
> +       };
> +
> +       return 0;
> +}
> +
> +#define imsic_vs_csr_write(__c, __v)           \
> +do {                                           \
> +       csr_write(CSR_VSISELECT, __c);          \
> +       csr_write(CSR_VSIREG, __v);             \
> +} while (0)
> +
> +#define imsic_write_switchcase(__ireg, __v)            \
> +       case __ireg:                                    \
> +               imsic_vs_csr_write(__ireg, __v);        \
> +               break;
> +#define imsic_write_switchcase_2(__ireg, __v)          \
> +       imsic_write_switchcase(__ireg + 0, __v)         \
> +       imsic_write_switchcase(__ireg + 1, __v)
> +#define imsic_write_switchcase_4(__ireg, __v)          \
> +       imsic_write_switchcase_2(__ireg + 0, __v)       \
> +       imsic_write_switchcase_2(__ireg + 2, __v)
> +#define imsic_write_switchcase_8(__ireg, __v)          \
> +       imsic_write_switchcase_4(__ireg + 0, __v)       \
> +       imsic_write_switchcase_4(__ireg + 4, __v)
> +#define imsic_write_switchcase_16(__ireg, __v)         \
> +       imsic_write_switchcase_8(__ireg + 0, __v)       \
> +       imsic_write_switchcase_8(__ireg + 8, __v)
> +#define imsic_write_switchcase_32(__ireg, __v)         \
> +       imsic_write_switchcase_16(__ireg + 0, __v)      \
> +       imsic_write_switchcase_16(__ireg + 16, __v)
> +#define imsic_write_switchcase_64(__ireg, __v)         \
> +       imsic_write_switchcase_32(__ireg + 0, __v)      \
> +       imsic_write_switchcase_32(__ireg + 32, __v)
> +
> +static void imsic_eix_write(int ireg, unsigned long val)
> +{
> +       switch (ireg) {
> +       imsic_write_switchcase_64(IMSIC_EIP0, val)
> +       imsic_write_switchcase_64(IMSIC_EIE0, val)
> +       };
> +}
> +
> +#define imsic_vs_csr_set(__c, __v)             \
> +do {                                           \
> +       csr_write(CSR_VSISELECT, __c);          \
> +       csr_set(CSR_VSIREG, __v);               \
> +} while (0)
> +
> +#define imsic_set_switchcase(__ireg, __v)              \
> +       case __ireg:                                    \
> +               imsic_vs_csr_set(__ireg, __v);          \
> +               break;
> +#define imsic_set_switchcase_2(__ireg, __v)            \
> +       imsic_set_switchcase(__ireg + 0, __v)           \
> +       imsic_set_switchcase(__ireg + 1, __v)
> +#define imsic_set_switchcase_4(__ireg, __v)            \
> +       imsic_set_switchcase_2(__ireg + 0, __v)         \
> +       imsic_set_switchcase_2(__ireg + 2, __v)
> +#define imsic_set_switchcase_8(__ireg, __v)            \
> +       imsic_set_switchcase_4(__ireg + 0, __v)         \
> +       imsic_set_switchcase_4(__ireg + 4, __v)
> +#define imsic_set_switchcase_16(__ireg, __v)           \
> +       imsic_set_switchcase_8(__ireg + 0, __v)         \
> +       imsic_set_switchcase_8(__ireg + 8, __v)
> +#define imsic_set_switchcase_32(__ireg, __v)           \
> +       imsic_set_switchcase_16(__ireg + 0, __v)        \
> +       imsic_set_switchcase_16(__ireg + 16, __v)
> +#define imsic_set_switchcase_64(__ireg, __v)           \
> +       imsic_set_switchcase_32(__ireg + 0, __v)        \
> +       imsic_set_switchcase_32(__ireg + 32, __v)
> +
> +static void imsic_eix_set(int ireg, unsigned long val)
> +{
> +       switch (ireg) {
> +       imsic_set_switchcase_64(IMSIC_EIP0, val)
> +       imsic_set_switchcase_64(IMSIC_EIE0, val)
> +       };
> +}
> +
> +static unsigned long imsic_mrif_atomic_rmw(struct imsic_mrif *mrif,
> +                                          unsigned long *ptr,
> +                                          unsigned long new_val,
> +                                          unsigned long wr_mask)
> +{
> +       unsigned long old_val =3D 0, tmp =3D 0;
> +
> +       __asm__ __volatile__ (
> +               "0:     lr.w.aq   %1, %0\n"
> +               "       and       %2, %1, %3\n"
> +               "       or        %2, %2, %4\n"
> +               "       sc.w.rl   %2, %2, %0\n"
> +               "       bnez      %2, 0b"
> +               : "+A" (*ptr), "+r" (old_val), "+r" (tmp)
> +               : "r" (~wr_mask), "r" (new_val & wr_mask)
> +               : "memory");
> +
> +       return old_val;
> +}
> +
> +static unsigned long imsic_mrif_atomic_or(struct imsic_mrif *mrif,
> +                                         unsigned long *ptr,
> +                                         unsigned long val)
> +{
> +       return arch_atomic_long_fetch_or(val, (atomic_long_t *)ptr);
> +}
> +
> +#define imsic_mrif_atomic_write(__mrif, __ptr, __new_val)      \
> +               imsic_mrif_atomic_rmw(__mrif, __ptr, __new_val, -1UL)
> +#define imsic_mrif_atomic_read(__mrif, __ptr)                  \
> +               imsic_mrif_atomic_or(__mrif, __ptr, 0)
> +
> +static u32 imsic_mrif_topei(struct imsic_mrif *mrif, u32 nr_eix, u32 nr_=
msis)
> +{
> +       struct imsic_mrif_eix *eix;
> +       u32 i, imin, imax, ei, max_msi;
> +       unsigned long eipend[BITS_PER_TYPE(u64) / BITS_PER_LONG];
> +       unsigned long eithreshold =3D imsic_mrif_atomic_read(mrif,
> +                                                       &mrif->eithreshol=
d);
> +
> +       max_msi =3D (eithreshold && (eithreshold <=3D nr_msis)) ?
> +                  eithreshold : nr_msis;
> +       for (ei =3D 0; ei < nr_eix; ei++) {
> +               eix =3D &mrif->eix[ei];
> +               eipend[0] =3D imsic_mrif_atomic_read(mrif, &eix->eie[0]) =
&
> +                           imsic_mrif_atomic_read(mrif, &eix->eip[0]);
> +#ifdef CONFIG_32BIT
> +               eipend[1] =3D imsic_mrif_atomic_read(mrif, &eix->eie[1]) =
&
> +                           imsic_mrif_atomic_read(mrif, &eix->eip[1]);
> +               if (!eipend[0] && !eipend[1])
> +#else
> +               if (!eipend[0])
> +#endif
> +                       continue;
> +
> +               imin =3D ei * BITS_PER_TYPE(u64);
> +               imax =3D ((imin + BITS_PER_TYPE(u64)) < max_msi) ?
> +                       imin + BITS_PER_TYPE(u64) : max_msi;
> +               for (i =3D (!imin) ? 1 : imin; i < imax; i++) {
> +                       if (test_bit(i - imin, eipend))
> +                               return (i << TOPEI_ID_SHIFT) | i;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int imsic_mrif_rmw(struct imsic_mrif *mrif, u32 nr_eix,
> +                         unsigned long isel, unsigned long *val,
> +                         unsigned long new_val, unsigned long wr_mask)
> +{
> +       bool pend;
> +       struct imsic_mrif_eix *eix;
> +       unsigned long *ei, num, old_val =3D 0;
> +
> +       switch (isel) {
> +       case IMSIC_EIDELIVERY:
> +               old_val =3D imsic_mrif_atomic_rmw(mrif, &mrif->eidelivery=
,
> +                                               new_val, wr_mask & 0x1);
> +               break;
> +       case IMSIC_EITHRESHOLD:
> +               old_val =3D imsic_mrif_atomic_rmw(mrif, &mrif->eithreshol=
d,
> +                               new_val, wr_mask & (IMSIC_MAX_ID - 1));
> +               break;
> +       case IMSIC_EIP0 ... IMSIC_EIP63:
> +       case IMSIC_EIE0 ... IMSIC_EIE63:
> +               if (isel >=3D IMSIC_EIP0 && isel <=3D IMSIC_EIP63) {
> +                       pend =3D true;
> +                       num =3D isel - IMSIC_EIP0;
> +               } else {
> +                       pend =3D false;
> +                       num =3D isel - IMSIC_EIE0;
> +               }
> +
> +               if ((num / 2) >=3D nr_eix)
> +                       return -EINVAL;
> +               eix =3D &mrif->eix[num / 2];
> +
> +#ifndef CONFIG_32BIT
> +               if (num & 0x1)
> +                       return -EINVAL;
> +               ei =3D (pend) ? &eix->eip[0] : &eix->eie[0];
> +#else
> +               ei =3D (pend) ? &eix->eip[num & 0x1] : &eix->eie[num & 0x=
1];
> +#endif
> +
> +               /* Bit0 of EIP0 or EIE0 is read-only */
> +               if (!num)
> +                       wr_mask &=3D ~BIT(0);
> +
> +               old_val =3D imsic_mrif_atomic_rmw(mrif, ei, new_val, wr_m=
ask);
> +               break;
> +       default:
> +               return -ENOENT;
> +       };
> +
> +       if (val)
> +               *val =3D old_val;
> +
> +       return 0;
> +}
> +
> +struct imsic_vsfile_read_data {
> +       int hgei;
> +       u32 nr_eix;
> +       bool clear;
> +       struct imsic_mrif *mrif;
> +};
> +
> +static void imsic_vsfile_local_read(void *data)
> +{
> +       u32 i;
> +       struct imsic_mrif_eix *eix;
> +       struct imsic_vsfile_read_data *idata =3D data;
> +       struct imsic_mrif *mrif =3D idata->mrif;
> +       unsigned long new_hstatus, old_hstatus, old_vsiselect;
> +
> +       old_vsiselect =3D csr_read(CSR_VSISELECT);
> +       old_hstatus =3D csr_read(CSR_HSTATUS);
> +       new_hstatus =3D old_hstatus & ~HSTATUS_VGEIN;
> +       new_hstatus |=3D ((unsigned long)idata->hgei) << HSTATUS_VGEIN_SH=
IFT;
> +       csr_write(CSR_HSTATUS, new_hstatus);
> +
> +       /*
> +        * We don't use imsic_mrif_atomic_xyz() functions to store
> +        * values in MRIF because imsic_vsfile_read() is always called
> +        * with pointer to temporary MRIF on stack.
> +        */
> +
> +       if (idata->clear) {
> +               mrif->eidelivery =3D imsic_vs_csr_swap(IMSIC_EIDELIVERY, =
0);
> +               mrif->eithreshold =3D imsic_vs_csr_swap(IMSIC_EITHRESHOLD=
, 0);
> +               for (i =3D 0; i < idata->nr_eix; i++) {
> +                       eix =3D &mrif->eix[i];
> +                       eix->eip[0] =3D imsic_eix_swap(IMSIC_EIP0 + i * 2=
, 0);
> +                       eix->eie[0] =3D imsic_eix_swap(IMSIC_EIE0 + i * 2=
, 0);
> +#ifdef CONFIG_32BIT
> +                       eix->eip[1] =3D imsic_eix_swap(IMSIC_EIP0 + i * 2=
 + 1, 0);
> +                       eix->eie[1] =3D imsic_eix_swap(IMSIC_EIE0 + i * 2=
 + 1, 0);
> +#endif
> +               }
> +       } else {
> +               mrif->eidelivery =3D imsic_vs_csr_read(IMSIC_EIDELIVERY);
> +               mrif->eithreshold =3D imsic_vs_csr_read(IMSIC_EITHRESHOLD=
);
> +               for (i =3D 0; i < idata->nr_eix; i++) {
> +                       eix =3D &mrif->eix[i];
> +                       eix->eip[0] =3D imsic_eix_read(IMSIC_EIP0 + i * 2=
);
> +                       eix->eie[0] =3D imsic_eix_read(IMSIC_EIE0 + i * 2=
);
> +#ifdef CONFIG_32BIT
> +                       eix->eip[1] =3D imsic_eix_read(IMSIC_EIP0 + i * 2=
 + 1);
> +                       eix->eie[1] =3D imsic_eix_read(IMSIC_EIE0 + i * 2=
 + 1);
> +#endif
> +               }
> +       }
> +
> +       csr_write(CSR_HSTATUS, old_hstatus);
> +       csr_write(CSR_VSISELECT, old_vsiselect);
> +}
> +
> +static void imsic_vsfile_read(int vsfile_hgei, int vsfile_cpu, u32 nr_ei=
x,
> +                             bool clear, struct imsic_mrif *mrif)
> +{
> +       struct imsic_vsfile_read_data idata;
> +
> +       /* We can only read clear if we have a IMSIC VS-file */
> +       if (vsfile_cpu < 0 || vsfile_hgei <=3D 0)
> +               return;
> +
> +       /* We can only read clear on local CPU */
> +       idata.hgei =3D vsfile_hgei;
> +       idata.nr_eix =3D nr_eix;
> +       idata.clear =3D clear;
> +       idata.mrif =3D mrif;
> +       on_each_cpu_mask(cpumask_of(vsfile_cpu),
> +                        imsic_vsfile_local_read, &idata, 1);
> +}
> +
> +static void imsic_vsfile_local_clear(int vsfile_hgei, u32 nr_eix)
> +{
> +       u32 i;
> +       unsigned long new_hstatus, old_hstatus, old_vsiselect;
> +
> +       /* We can only zero-out if we have a IMSIC VS-file */
> +       if (vsfile_hgei <=3D 0)
> +               return;
> +
> +       old_vsiselect =3D csr_read(CSR_VSISELECT);
> +       old_hstatus =3D csr_read(CSR_HSTATUS);
> +       new_hstatus =3D old_hstatus & ~HSTATUS_VGEIN;
> +       new_hstatus |=3D ((unsigned long)vsfile_hgei) << HSTATUS_VGEIN_SH=
IFT;
> +       csr_write(CSR_HSTATUS, new_hstatus);
> +
> +       imsic_vs_csr_write(IMSIC_EIDELIVERY, 0);
> +       imsic_vs_csr_write(IMSIC_EITHRESHOLD, 0);
> +       for (i =3D 0; i < nr_eix; i++) {
> +               imsic_eix_write(IMSIC_EIP0 + i * 2, 0);
> +               imsic_eix_write(IMSIC_EIE0 + i * 2, 0);
> +#ifdef CONFIG_32BIT
> +               imsic_eix_write(IMSIC_EIP0 + i * 2 + 1, 0);
> +               imsic_eix_write(IMSIC_EIE0 + i * 2 + 1, 0);
> +#endif
> +       }
> +
> +       csr_write(CSR_HSTATUS, old_hstatus);
> +       csr_write(CSR_VSISELECT, old_vsiselect);
> +}
> +
> +static void imsic_vsfile_local_update(int vsfile_hgei, u32 nr_eix,
> +                                     struct imsic_mrif *mrif)
> +{
> +       u32 i;
> +       struct imsic_mrif_eix *eix;
> +       unsigned long new_hstatus, old_hstatus, old_vsiselect;
> +
> +       /* We can only update if we have a HW IMSIC context */
> +       if (vsfile_hgei <=3D 0)
> +               return;
> +
> +       /*
> +        * We don't use imsic_mrif_atomic_xyz() functions to read values
> +        * from MRIF in this function because it is always called with
> +        * pointer to temporary MRIF on stack.
> +        */
> +
> +       old_vsiselect =3D csr_read(CSR_VSISELECT);
> +       old_hstatus =3D csr_read(CSR_HSTATUS);
> +       new_hstatus =3D old_hstatus & ~HSTATUS_VGEIN;
> +       new_hstatus |=3D ((unsigned long)vsfile_hgei) << HSTATUS_VGEIN_SH=
IFT;
> +       csr_write(CSR_HSTATUS, new_hstatus);
> +
> +       for (i =3D 0; i < nr_eix; i++) {
> +               eix =3D &mrif->eix[i];
> +               imsic_eix_set(IMSIC_EIP0 + i * 2, eix->eip[0]);
> +               imsic_eix_set(IMSIC_EIE0 + i * 2, eix->eie[0]);
> +#ifdef CONFIG_32BIT
> +               imsic_eix_set(IMSIC_EIP0 + i * 2 + 1, eix->eip[1]);
> +               imsic_eix_set(IMSIC_EIE0 + i * 2 + 1, eix->eie[1]);
> +#endif
> +       }
> +       imsic_vs_csr_write(IMSIC_EITHRESHOLD, mrif->eithreshold);
> +       imsic_vs_csr_write(IMSIC_EIDELIVERY, mrif->eidelivery);
> +
> +       csr_write(CSR_HSTATUS, old_hstatus);
> +       csr_write(CSR_VSISELECT, old_vsiselect);
> +}
> +
> +static void imsic_vsfile_cleanup(struct imsic *imsic)
> +{
> +       int old_vsfile_hgei, old_vsfile_cpu;
> +       unsigned long flags;
> +
> +       /*
> +        * We don't use imsic_mrif_atomic_xyz() functions to clear the
> +        * SW-file in this function because it is always called when the
> +        * VCPU is being destroyed.
> +        */
> +
> +       write_lock_irqsave(&imsic->vsfile_lock, flags);
> +       old_vsfile_hgei =3D imsic->vsfile_hgei;
> +       old_vsfile_cpu =3D imsic->vsfile_cpu;
> +       imsic->vsfile_cpu =3D imsic->vsfile_hgei =3D -1;
> +       imsic->vsfile_va =3D NULL;
> +       imsic->vsfile_pa =3D 0;
> +       write_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +       memset(imsic->swfile, 0, sizeof(*imsic->swfile));
> +
> +       if (old_vsfile_cpu >=3D 0)
> +               kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
> +}
> +
> +static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
> +{
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +       struct imsic_mrif *mrif =3D imsic->swfile;
> +
> +       if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
> +           imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
> +               kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
> +       else
> +               kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
> +}
> +
> +static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
> +                             struct imsic_mrif *mrif)
> +{
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +
> +       /*
> +        * We don't use imsic_mrif_atomic_xyz() functions to read and
> +        * write SW-file and MRIF in this function because it is always
> +        * called when VCPU is not using SW-file and the MRIF points to
> +        * a temporary MRIF on stack.
> +        */
> +
> +       memcpy(mrif, imsic->swfile, sizeof(*mrif));
> +       if (clear) {
> +               memset(imsic->swfile, 0, sizeof(*imsic->swfile));
> +               kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
> +       }
> +}
> +
> +static void imsic_swfile_update(struct kvm_vcpu *vcpu,
> +                               struct imsic_mrif *mrif)
> +{
> +       u32 i;
> +       struct imsic_mrif_eix *seix, *eix;
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +       struct imsic_mrif *smrif =3D imsic->swfile;
> +
> +       imsic_mrif_atomic_write(smrif, &smrif->eidelivery, mrif->eidelive=
ry);
> +       imsic_mrif_atomic_write(smrif, &smrif->eithreshold, mrif->eithres=
hold);
> +       for (i =3D 0; i < imsic->nr_eix; i++) {
> +               seix =3D &smrif->eix[i];
> +               eix =3D &mrif->eix[i];
> +               imsic_mrif_atomic_or(smrif, &seix->eip[0], eix->eip[0]);
> +               imsic_mrif_atomic_or(smrif, &seix->eie[0], eix->eie[0]);
> +#ifdef CONFIG_32BIT
> +               imsic_mrif_atomic_or(smrif, &seix->eip[1], eix->eip[1]);
> +               imsic_mrif_atomic_or(smrif, &seix->eie[1], eix->eie[1]);
> +#endif
> +       }
> +
> +       imsic_swfile_extirq_update(vcpu);
> +}
> +
> +void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long flags;
> +       struct imsic_mrif tmrif;
> +       int old_vsfile_hgei, old_vsfile_cpu;
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +
> +       /* Read and clear IMSIC VS-file details */
> +       write_lock_irqsave(&imsic->vsfile_lock, flags);
> +       old_vsfile_hgei =3D imsic->vsfile_hgei;
> +       old_vsfile_cpu =3D imsic->vsfile_cpu;
> +       imsic->vsfile_cpu =3D imsic->vsfile_hgei =3D -1;
> +       imsic->vsfile_va =3D NULL;
> +       imsic->vsfile_pa =3D 0;
> +       write_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +       /* Do nothing, if no IMSIC VS-file to release */
> +       if (old_vsfile_cpu < 0)
> +               return;
> +
> +       /*
> +        * At this point, all interrupt producers are still using
> +        * the old IMSIC VS-file so we first re-direct all interrupt
> +        * producers.
> +        */
> +
> +       /* Purge the G-stage mapping */
> +       kvm_riscv_gstage_iounmap(vcpu->kvm,
> +                                vcpu->arch.aia_context.imsic_addr,
> +                                IMSIC_MMIO_PAGE_SZ);
> +
> +       /* TODO: Purge the IOMMU mapping ??? */
> +
> +       /*
> +        * At this point, all interrupt producers have been re-directed
> +        * to somewhere else so we move register state from the old IMSIC
> +        * VS-file to the IMSIC SW-file.
> +        */
> +
> +       /* Read and clear register state from old IMSIC VS-file */
> +       memset(&tmrif, 0, sizeof(tmrif));
> +       imsic_vsfile_read(old_vsfile_hgei, old_vsfile_cpu, imsic->nr_hw_e=
ix,
> +                         true, &tmrif);
> +
> +       /* Update register state in IMSIC SW-file */
> +       imsic_swfile_update(vcpu, &tmrif);
> +
> +       /* Free-up old IMSIC VS-file */
> +       kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
> +}
> +
> +int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long flags;
> +       phys_addr_t new_vsfile_pa;
> +       struct imsic_mrif tmrif;
> +       void __iomem *new_vsfile_va;
> +       struct kvm *kvm =3D vcpu->kvm;
> +       struct kvm_run *run =3D vcpu->run;
> +       struct kvm_vcpu_aia *vaia =3D &vcpu->arch.aia_context;
> +       struct imsic *imsic =3D vaia->imsic_state;
> +       int ret =3D 0, new_vsfile_hgei =3D -1, old_vsfile_hgei, old_vsfil=
e_cpu;
> +
> +       /* Do nothing for emulation mode */
> +       if (kvm->arch.aia.mode =3D=3D KVM_DEV_RISCV_AIA_MODE_EMUL)
> +               return 1;
> +
> +       /* Read old IMSIC VS-file details */
> +       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +       old_vsfile_hgei =3D imsic->vsfile_hgei;
> +       old_vsfile_cpu =3D imsic->vsfile_cpu;
> +       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +       /* Do nothing if we are continuing on same CPU */
> +       if (old_vsfile_cpu =3D=3D vcpu->cpu)
> +               return 1;
> +
> +       /* Allocate new IMSIC VS-file */
> +       ret =3D kvm_riscv_aia_alloc_hgei(vcpu->cpu, vcpu,
> +                                      &new_vsfile_va, &new_vsfile_pa);
> +       if (ret <=3D 0) {
> +               /* For HW acceleration mode, we can't continue */
> +               if (kvm->arch.aia.mode =3D=3D KVM_DEV_RISCV_AIA_MODE_HWAC=
CEL) {
> +                       run->fail_entry.hardware_entry_failure_reason =3D
> +                                                               CSR_HSTAT=
US;
> +                       run->fail_entry.cpu =3D vcpu->cpu;
> +                       run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> +                       return 0;
> +               }
> +
> +               /* Release old IMSIC VS-file */
> +               if (old_vsfile_cpu >=3D 0)
> +                       kvm_riscv_vcpu_aia_imsic_release(vcpu);
> +
> +               /* For automatic mode, we continue */
> +               goto done;
> +       }
> +       new_vsfile_hgei =3D ret;
> +
> +       /*
> +        * At this point, all interrupt producers are still using
> +        * to the old IMSIC VS-file so we first move all interrupt
> +        * producers to the new IMSIC VS-file.
> +        */
> +
> +       /* Zero-out new IMSIC VS-file */
> +       imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
> +
> +       /* Update G-stage mapping for the new IMSIC VS-file */
> +       ret =3D kvm_riscv_gstage_ioremap(kvm, vcpu->arch.aia_context.imsi=
c_addr,
> +                                      new_vsfile_pa, IMSIC_MMIO_PAGE_SZ,
> +                                      true, true);
> +       if (ret)
> +               goto fail_free_vsfile_hgei;
> +
> +       /* TODO: Update the IOMMU mapping ??? */
> +
> +       /* Update new IMSIC VS-file details in IMSIC context */
> +       write_lock_irqsave(&imsic->vsfile_lock, flags);
> +       imsic->vsfile_hgei =3D new_vsfile_hgei;
> +       imsic->vsfile_cpu =3D vcpu->cpu;
> +       imsic->vsfile_va =3D new_vsfile_va;
> +       imsic->vsfile_pa =3D new_vsfile_pa;
> +       write_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +       /*
> +        * At this point, all interrupt producers have been moved
> +        * to the new IMSIC VS-file so we move register state from
> +        * the old IMSIC VS/SW-file to the new IMSIC VS-file.
> +        */
> +
> +       memset(&tmrif, 0, sizeof(tmrif));
> +       if (old_vsfile_cpu >=3D 0) {
> +               /* Read and clear register state from old IMSIC VS-file *=
/
> +               imsic_vsfile_read(old_vsfile_hgei, old_vsfile_cpu,
> +                                 imsic->nr_hw_eix, true, &tmrif);
> +
> +               /* Free-up old IMSIC VS-file */
> +               kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
> +       } else {
> +               /* Read and clear register state from IMSIC SW-file */
> +               imsic_swfile_read(vcpu, true, &tmrif);
> +       }
> +
> +       /* Restore register state in the new IMSIC VS-file */
> +       imsic_vsfile_local_update(new_vsfile_hgei, imsic->nr_hw_eix, &tmr=
if);
> +
> +done:
> +       /* Set VCPU HSTATUS.VGEIN to new IMSIC VS-file */
> +       vcpu->arch.guest_context.hstatus &=3D ~HSTATUS_VGEIN;
> +       if (new_vsfile_hgei > 0)
> +               vcpu->arch.guest_context.hstatus |=3D
> +                       ((unsigned long)new_vsfile_hgei) << HSTATUS_VGEIN=
_SHIFT;
> +
> +       /* Continue run-loop */
> +       return 1;
> +
> +fail_free_vsfile_hgei:
> +       kvm_riscv_aia_free_hgei(vcpu->cpu, new_vsfile_hgei);
> +       return ret;
> +}
> +
> +int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu, unsigned long is=
el,
> +                                unsigned long *val, unsigned long new_va=
l,
> +                                unsigned long wr_mask)
> +{
> +       u32 topei;
> +       struct imsic_mrif_eix *eix;
> +       int r, rc =3D KVM_INSN_CONTINUE_NEXT_SEPC;
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +
> +       if (isel =3D=3D KVM_RISCV_AIA_IMSIC_TOPEI) {
> +               /* Read pending and enabled interrupt with highest priori=
ty */
> +               topei =3D imsic_mrif_topei(imsic->swfile, imsic->nr_eix,
> +                                        imsic->nr_msis);
> +               if (val)
> +                       *val =3D topei;
> +
> +               /* Writes ignore value and clear top pending interrupt */
> +               if (topei && wr_mask) {
> +                       topei >>=3D TOPEI_ID_SHIFT;
> +                       if (topei) {
> +                               eix =3D &imsic->swfile->eix[topei /
> +                                                         BITS_PER_TYPE(u=
64)];
> +                               clear_bit(topei & (BITS_PER_TYPE(u64) - 1=
),
> +                                         eix->eip);
> +                       }
> +               }
> +       } else {
> +               r =3D imsic_mrif_rmw(imsic->swfile, imsic->nr_eix, isel,
> +                                  val, new_val, wr_mask);
> +               /* Forward unknown IMSIC register to user-space */
> +               if (r)
> +                       rc =3D (r =3D=3D -ENOENT) ? 0 : KVM_INSN_ILLEGAL_=
TRAP;
> +       }
> +
> +       if (wr_mask)
> +               imsic_swfile_extirq_update(vcpu);
> +
> +       return rc;
> +}
> +
> +void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu)
> +{
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +
> +       if (!imsic)
> +               return;
> +
> +       kvm_riscv_vcpu_aia_imsic_release(vcpu);
> +
> +       memset(imsic->swfile, 0, sizeof(*imsic->swfile));
> +}
> +
> +int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
> +                                   u32 guest_index, u32 offset, u32 iid)
> +{
> +       unsigned long flags;
> +       struct imsic_mrif_eix *eix;
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +
> +       /* We only emulate one IMSIC MMIO page for each Guest VCPU */
> +       if (!imsic || !iid || guest_index ||
> +           (offset !=3D IMSIC_MMIO_SETIPNUM_LE &&
> +            offset !=3D IMSIC_MMIO_SETIPNUM_BE))
> +               return -ENODEV;
> +
> +       iid =3D (offset =3D=3D IMSIC_MMIO_SETIPNUM_BE) ? __swab32(iid) : =
iid;
> +       if (imsic->nr_msis <=3D iid)
> +               return -EINVAL;
> +
> +       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +
> +       if (imsic->vsfile_cpu >=3D 0) {
> +               writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
> +               kvm_vcpu_kick(vcpu);
> +       } else {
> +               eix =3D &imsic->swfile->eix[iid / BITS_PER_TYPE(u64)];
> +               set_bit(iid & (BITS_PER_TYPE(u64) - 1), eix->eip);
> +               imsic_swfile_extirq_update(vcpu);
> +       }
> +
> +       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +       return 0;
> +}
> +
> +static int imsic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *=
dev,
> +                          gpa_t addr, int len, void *val)
> +{
> +       if (len !=3D 4 || (addr & 0x3) !=3D 0)
> +               return -EOPNOTSUPP;
> +
> +       *((u32 *)val) =3D 0;
> +
> +       return 0;
> +}
> +
> +static int imsic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device =
*dev,
> +                           gpa_t addr, int len, const void *val)
> +{
> +       struct kvm_msi msi =3D { 0 };
> +
> +       if (len !=3D 4 || (addr & 0x3) !=3D 0)
> +               return -EOPNOTSUPP;
> +
> +       msi.address_hi =3D addr >> 32;
> +       msi.address_lo =3D (u32)addr;
> +       msi.data =3D *((const u32 *)val);
> +       kvm_riscv_aia_inject_msi(vcpu->kvm, &msi);
> +
> +       return 0;
> +};
> +
> +static struct kvm_io_device_ops imsic_iodoev_ops =3D {
> +       .read =3D imsic_mmio_read,
> +       .write =3D imsic_mmio_write,
> +};
> +
> +int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
> +{
> +       int ret =3D 0;
> +       struct imsic *imsic;
> +       struct page *swfile_page;
> +       struct kvm *kvm =3D vcpu->kvm;
> +
> +       /* Fail if we have zero IDs */
> +       if (!kvm->arch.aia.nr_ids)
> +               return -EINVAL;
> +
> +       /* Allocate IMSIC context */
> +       imsic =3D kzalloc(sizeof(*imsic), GFP_KERNEL);
> +       if (!imsic)
> +               return -ENOMEM;
> +       vcpu->arch.aia_context.imsic_state =3D imsic;
> +
> +       /* Setup IMSIC context  */
> +       imsic->nr_msis =3D kvm->arch.aia.nr_ids + 1;
> +       rwlock_init(&imsic->vsfile_lock);
> +       imsic->nr_eix =3D BITS_TO_U64(imsic->nr_msis);
> +       imsic->nr_hw_eix =3D BITS_TO_U64(kvm_riscv_aia_max_ids);
> +       imsic->vsfile_hgei =3D imsic->vsfile_cpu =3D -1;
> +
> +       /* Setup IMSIC SW-file */
> +       swfile_page =3D alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +                                 get_order(sizeof(*imsic->swfile)));
> +       if (!swfile_page) {
> +               ret =3D -ENOMEM;
> +               goto fail_free_imsic;
> +       }
> +       imsic->swfile =3D page_to_virt(swfile_page);
> +       imsic->swfile_pa =3D page_to_phys(swfile_page);
> +
> +       /* Setup IO device */
> +       kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
> +       mutex_lock(&kvm->slots_lock);
> +       ret =3D kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
> +                                     vcpu->arch.aia_context.imsic_addr,
> +                                     KVM_DEV_RISCV_IMSIC_SIZE,
> +                                     &imsic->iodev);
> +       mutex_unlock(&kvm->slots_lock);
> +       if (ret)
> +               goto fail_free_swfile;
> +
> +       return 0;
> +
> +fail_free_swfile:
> +       free_pages((unsigned long)imsic->swfile,
> +                  get_order(sizeof(*imsic->swfile)));
> +fail_free_imsic:
> +       vcpu->arch.aia_context.imsic_state =3D NULL;
> +       kfree(imsic);
> +       return ret;
> +}
> +
> +void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm *kvm =3D vcpu->kvm;
> +       struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> +
> +       if (!imsic)
> +               return;
> +
> +       imsic_vsfile_cleanup(imsic);
> +
> +       mutex_lock(&kvm->slots_lock);
> +       kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &imsic->iodev);
> +       mutex_unlock(&kvm->slots_lock);
> +
> +       free_pages((unsigned long)imsic->swfile,
> +                  get_order(sizeof(*imsic->swfile)));
> +
> +       vcpu->arch.aia_context.imsic_state =3D NULL;
> +       kfree(imsic);
> +}
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish
