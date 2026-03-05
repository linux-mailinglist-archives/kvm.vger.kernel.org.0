Return-Path: <kvm+bounces-72796-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPZkD48xqWnM2wAAu9opvQ
	(envelope-from <kvm+bounces-72796-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:32:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABE320CB06
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A43283034DF5
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 07:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C13321F5E;
	Thu,  5 Mar 2026 07:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvM2rJle"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923A51A681D
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772695911; cv=none; b=jDact4KjXEImrMba3GXitQmrfO9WCtkRgII26tRqC0OgsWlh2iUT3yPU2HcDWzDyQyr4dc13ht4SEIV3uAL9tqcva0flphIzVxKAie77zwAEct567OgEtvRNgLH9iggZ1YgGieUvJpVs0qt2RNX4x55rmt5GvWGBjUJUH2F0QgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772695911; c=relaxed/simple;
	bh=OOVdnqUkof+IrrHcPOaoLzBFW1cUsJdzoFbPVtuBdnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LIIMdxbpv541VbdRKNNiQmG/n3tNGnpLtarh4+8CtjZgmiOMmVgMbzH0XPAzwsClr3qey5OmPGuHgt2Eoyjf0JQ8M4Z88ttQYdXRY6KG/+ot0ocOph+oWbke3VQbvgURWc3scJhBvc25YL3V8SRYniDQT2n3lfsgyzDpmPe4nxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvM2rJle; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CF4C4AF09
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 07:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772695911;
	bh=OOVdnqUkof+IrrHcPOaoLzBFW1cUsJdzoFbPVtuBdnc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fvM2rJler7qE8J17wObpcbsvmLWUowKJzY4NGIN6yMOsdM0+iQzSk9QFtntUjLDfx
	 nGxzDVa4QCDT+FG2Ix4jAGWjAEC921XKc0VVGT1/jlUEoJV6nCgCJXQzBRjrOMADf5
	 /qJ+y30JabslSU+gjG2bqYfrW47E+2qpOJprYv23jf29UnGqJeYM4qJxmftR3DR2zp
	 i7YBPpM040tifCwE9qT7KJIg5aG4X1e9D/WV5TWs17208JRQxoQRhZqhgABsvCy01l
	 na15KijQ39A9iwjIk12KhyNTHUOpt8YubgmFsZhkZ3/Jv3+WEDR9HrKunCsjXb1TAE
	 MFGpKKKHHrQDw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-660b497adaaso3863266a12.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 23:31:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWSM8JbYZ45gw4HG7MHq8ouB4vNsD7r+ObUlku76KA3BuWv+AuIaYx+KT9Vn4gl2pKMK3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhKrhQzOj4+bpEq1Fl1U2sSrzDjTwsAQdeZjqSCeg1+ocuxQDv
	/CcYkpS8T128QsH5K8QZuceKWyK4pq8Vm+fxGTWkkr9VniDSIOJ8CgI9Yti4aJHQ0jNgWhR8wKG
	FHCiXS4GtV9G90Qp9sNoMckG47qd0BJY=
X-Received: by 2002:a05:6402:4403:b0:65c:6d0:d9f6 with SMTP id
 4fb4d7f45d1cf-660ef778f9amr3029226a12.6.1772695909561; Wed, 04 Mar 2026
 23:31:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206012028.3318291-1-gaosong@loongson.cn> <20260206012028.3318291-2-gaosong@loongson.cn>
In-Reply-To: <20260206012028.3318291-2-gaosong@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 5 Mar 2026 15:31:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4a=c7CmwtK95rF-3hwq=6c2DYv1dvEdrHKM_+MKFPK-g@mail.gmail.com>
X-Gm-Features: AaiRm527IyVlDJ7X0PUWaCD7VF4hxch865Q7QiZW48cUawDL7Ix54hh_zFPJXuQ
Message-ID: <CAAhV-H4a=c7CmwtK95rF-3hwq=6c2DYv1dvEdrHKM_+MKFPK-g@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] LongArch: KVM: Add DMSINTC device support
To: Song Gao <gaosong@loongson.cn>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9ABE320CB06
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72796-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,loongson.cn:email,mail.gmail.com:mid]
X-Rspamd-Action: no action

Hi, Song,

On Fri, Feb 6, 2026 at 9:45=E2=80=AFAM Song Gao <gaosong@loongson.cn> wrote=
:
>
> Add device model for DMSINTC interrupt controller, implement basic
> create/destroy/set_attr interfaces, and register device model to kvm
> device table.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_dmsintc.h |  21 +++++
>  arch/loongarch/include/asm/kvm_host.h    |   3 +
>  arch/loongarch/include/uapi/asm/kvm.h    |   4 +
>  arch/loongarch/kvm/Makefile              |   1 +
>  arch/loongarch/kvm/intc/dmsintc.c        | 111 +++++++++++++++++++++++
>  arch/loongarch/kvm/main.c                |   6 ++
>  include/uapi/linux/kvm.h                 |   2 +
>  7 files changed, 148 insertions(+)
>  create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
>  create mode 100644 arch/loongarch/kvm/intc/dmsintc.c
>
> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/in=
clude/asm/kvm_dmsintc.h
> new file mode 100644
> index 000000000000..1d4f66996f3c
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_KVM_DMSINTC_H
> +#define __ASM_KVM_DMSINTC_H
> +
> +
> +struct loongarch_dmsintc  {
Here is an extra space.

> +       struct kvm *kvm;
> +       uint64_t msg_addr_base;
> +       uint64_t msg_addr_size;
> +};
> +
> +struct dmsintc_state {
> +       atomic64_t  vector_map[4];
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void);
> +#endif
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index e4fe5b8e8149..5e9e2af7312f 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -22,6 +22,7 @@
>  #include <asm/kvm_ipi.h>
>  #include <asm/kvm_eiointc.h>
>  #include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_dmsintc.h>
>  #include <asm/loongarch.h>
>
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -134,6 +135,7 @@ struct kvm_arch {
>         struct loongarch_ipi *ipi;
>         struct loongarch_eiointc *eiointc;
>         struct loongarch_pch_pic *pch_pic;
> +       struct loongarch_dmsintc *dmsintc;
>  };
>
>  #define CSR_MAX_NUMS           0x800
> @@ -244,6 +246,7 @@ struct kvm_vcpu_arch {
>         struct kvm_mp_state mp_state;
>         /* ipi state */
>         struct ipi_state ipi_state;
> +       struct dmsintc_state dmsintc_state;
>         /* cpucfg */
>         u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index de6c3f18e40a..0a370d018b08 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
>  #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL             0x40000006
>  #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT            0
>
> +#define KVM_DEV_LOONGARCH_DMSINTC_CTRL                 0x40000007
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE                0x0
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE                0x1
> +
>  #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..6e184e24443c 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -19,6 +19,7 @@ kvm-y +=3D vm.o
>  kvm-y +=3D intc/ipi.o
>  kvm-y +=3D intc/eiointc.o
>  kvm-y +=3D intc/pch_pic.o
> +kvm-y +=3D intc/dmsintc.o
>  kvm-y +=3D irqfd.o
>
>  CFLAGS_exit.o  +=3D $(call cc-disable-warning, override-init)
> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/=
dmsintc.c
> new file mode 100644
> index 000000000000..00e401de0464
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/dmsintc.c
> @@ -0,0 +1,111 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_dmsintc.h>
> +#include <asm/kvm_vcpu.h>
> +
> +static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
> +                               struct kvm_device_attr *attr,
> +                               bool is_write)
> +{
> +       int addr =3D attr->attr;
> +       void __user *data;
> +       struct loongarch_dmsintc *s =3D dev->kvm->arch.dmsintc;
> +       u64 tmp;
> +
> +       data =3D (void __user *)attr->addr;
> +       switch (addr) {
> +       case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE:
> +               if (is_write) {
> +                       if (copy_from_user(&tmp, data, sizeof(s->msg_addr=
_base)))
> +                               return -EFAULT;
> +                       if (s->msg_addr_base) {
> +                               /* Duplicate setting are not allowed. */
> +                               return -EFAULT;
> +                       }
> +                       if ((tmp & (BIT(AVEC_CPU_SHIFT) - 1)) =3D=3D 0)
> +                               s->msg_addr_base =3D tmp;
> +                       else
> +                               return  -EFAULT;
> +               }
> +               break;
> +       case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
> +               if (is_write) {
> +                       if (copy_from_user(&tmp, data, sizeof(s->msg_addr=
_size)))
> +                               return -EFAULT;
> +                       if (s->msg_addr_size) {
> +                               /*Duplicate setting are not allowed. */
> +                               return -EFAULT;
> +                       }
> +                       s->msg_addr_size =3D tmp;
> +               }
> +               break;
> +       default:
> +               kvm_err("%s: unknown dmsintc register, addr =3D %d\n", __=
func__, addr);
> +               return -ENXIO;
> +       }
> +
> +       return 0;
> +}
> +
> +static int kvm_dmsintc_set_attr(struct kvm_device *dev,
> +                       struct kvm_device_attr *attr)
> +{
> +       switch (attr->group) {
> +       case KVM_DEV_LOONGARCH_DMSINTC_CTRL:
> +               return kvm_dmsintc_ctrl_access(dev, attr, true);
> +       default:
> +               kvm_err("%s: unknown group (%d)\n", __func__, attr->group=
);
> +               return -EINVAL;
> +       }
> +}
> +
> +static int kvm_dmsintc_create(struct kvm_device *dev, u32 type)
> +{
> +       struct kvm *kvm;
> +       struct loongarch_dmsintc *s;
> +
> +       if (!dev) {
> +               kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       kvm =3D dev->kvm;
> +       if (kvm->arch.dmsintc) {
> +               kvm_err("%s: LoongArch DMSINTC has already been created!\=
n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       s =3D kzalloc(sizeof(struct loongarch_dmsintc), GFP_KERNEL);
> +       if (!s)
> +               return -ENOMEM;
> +
> +       s->kvm =3D kvm;
> +       kvm->arch.dmsintc =3D s;
> +       return 0;
> +}
> +
> +static void kvm_dmsintc_destroy(struct kvm_device *dev)
> +{
> +
> +       if (!dev || !dev->kvm || !dev->kvm->arch.dmsintc)
> +               return;
> +
> +       kfree(dev->kvm->arch.dmsintc);
> +       kfree(dev);
> +}
> +
> +static struct kvm_device_ops kvm_dmsintc_dev_ops =3D {
> +       .name =3D "kvm-loongarch-dmsintc",
> +       .create =3D kvm_dmsintc_create,
> +       .destroy =3D kvm_dmsintc_destroy,
> +       .set_attr =3D kvm_dmsintc_set_attr,
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void)
> +{
> +       return kvm_register_device_ops(&kvm_dmsintc_dev_ops, KVM_DEV_TYPE=
_LOONGARCH_DMSINTC);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..f363a3b24903 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -408,6 +408,12 @@ static int kvm_loongarch_env_init(void)
>
>         /* Register LoongArch PCH-PIC interrupt controller interface. */
>         ret =3D kvm_loongarch_register_pch_pic_device();
> +       if (ret)
> +               return ret;
> +
> +       /* Register LoongArch DMSINTC interrupt contrroller interface */
> +       if (cpu_has_msgint)
I'm not sure, but there is kvm_guest_has_msgint(), I don't know which
one is really needed.


Huacai

> +               ret =3D kvm_loongarch_register_dmsintc_device();
>
>         return ret;
>  }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..7c56e7e36265 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1209,6 +1209,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_LOONGARCH_EIOINTC KVM_DEV_TYPE_LOONGARCH_EIOINTC
>         KVM_DEV_TYPE_LOONGARCH_PCHPIC,
>  #define KVM_DEV_TYPE_LOONGARCH_PCHPIC  KVM_DEV_TYPE_LOONGARCH_PCHPIC
> +       KVM_DEV_TYPE_LOONGARCH_DMSINTC,
> +#define KVM_DEV_TYPE_LOONGARCH_DMSINTC   KVM_DEV_TYPE_LOONGARCH_DMSINTC
>
>         KVM_DEV_TYPE_MAX,
>
> --
> 2.39.3
>
>

