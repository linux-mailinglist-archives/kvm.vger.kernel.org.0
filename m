Return-Path: <kvm+bounces-12604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5418A88AA95
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89586322BB8
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EEB6F529;
	Mon, 25 Mar 2024 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="nKDuyi/5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907D79460
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380792; cv=none; b=foFlPSfjTxB45GuJMrraWsi/vJxS+/yATbHjrvlOtPSS4PAj5kkRX9G7QjZKLPcntIY5qmTiYQjoPKSU7pgqhG5FY3p2skH757TzRmfTSPEsSYRj/aMofWD2xkOnLAFY9njx9PwP/RGEWFfSzjZy8Lppl87BrBwV4tBnmmHOPKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380792; c=relaxed/simple;
	bh=h4jkc1ZwAwO0sD+QMGnf/yxHn/TbJwMpdRnpyOGs5c4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sK06GqS5RAvn/SnYlYdElzEJkg95zfuakt8Prid2ftNIXxcb6PjIQp7DJ6JbXuTO8ODNuHGWWLlJ/iCIcANJx++7pM+w5slDXnNBTCjqLZ0fe8a1FxreMuOOxTv77km4zn62Is/nhPlgCDTaNyr61OwBwxRh9+yE4H8lPWE+jzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=nKDuyi/5; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-366ad40144fso11936665ab.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1711380789; x=1711985589; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klVqCyD8JK+kklgvc/NbPsWHgkWd7LQwBF4Zb4Y7CRg=;
        b=nKDuyi/5NavnwRL+BN1buCVIFAHsmevKQGOrEdQyIEtaf3h4rxZJEs3Qiw/VKQ1VIQ
         nnWePMG5mrz3esClvj2Zt8eWdIFoA8rYPFQv67ElX3NjHTLwUgMg9KfWXd5G+vdqEjZP
         CKFvnq6kWR/2tWC0pRd53lv79dbAFTfjeoMtKUlGP55Asyr7iUm3O7qAaIbtzoUkd4Gq
         WtlrQDA/pQJUbCExTNgisMTO2LQkZOgMXpRapzJ7c1julOmY3okLi1dz/oaxmowOEcBE
         9OknjO36dJu51FXIrpWWljOHRZ68YRECXC/8FAfSZxHKwWdfv193PfsvPjXp//LuuKWv
         RLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380789; x=1711985589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=klVqCyD8JK+kklgvc/NbPsWHgkWd7LQwBF4Zb4Y7CRg=;
        b=QVg0qhjKrLpMr+WMucXkCmlpyJtJxx4LO+A8H8kG0z1u8GpTPOy6x2s7eElAoOIaNp
         LhSbuVDfyNLHSQuv1CUucnvANtSmMhQJHDEoao9AROgMt/X0f+8Xcwhmtgn56c1mVubS
         UBSJmCzUoiglwDPYHo9hYd9FhkA8zyxNy4rp5BPwBI2aUqNFUbFjWxERRvqr3MfIy8Ay
         Nwcobhwwo5KDJRb5OcjCOolAYNJpZ/2wcP6Y3PTbeh0truvOUDLVvu+rWfNCFhzkxSdJ
         vpL0ljFe+Y5Q5EDHoRO+YRXAKaerB1O4sUrmKdM2uwYLQl0EpFNEB9GVhg6ltOC1Uc4I
         KAEw==
X-Forwarded-Encrypted: i=1; AJvYcCWyuoBTgUNUs3XJ1x6y/y8upaxvCl2M3n3WcqPcLoHjItzzoaIpLyD9wRKC8eEV4T9MLTnT9J0hhujISIDTNtWe4Niy
X-Gm-Message-State: AOJu0Yy/LPLrm7g78i6GJx+u503hzszqCnJpgYn+9+/wzSZY8ny8at/a
	hhKUKSYjpcd4l9efFqpR/IxyvVFW3dLH2xzUyKdhwS6OuhVrlQJUTpiXuM1DjunUEoW+XQc8MDk
	BFUETtsOQ9XADk/NkIDclO3gkpNsX6Gw61xwQZQ==
X-Google-Smtp-Source: AGHT+IEM2ovJq1LcuTp62PcSEFjkj5SD5yGLBmLzga7GzZu8FiUOxfU+LWbI01K5dmlhYRQ66ei8zmGkWMaYk/8ZKzA=
X-Received: by 2002:a92:7f01:0:b0:365:185a:83ed with SMTP id
 a1-20020a927f01000000b00365185a83edmr5105834ild.10.1711380789571; Mon, 25 Mar
 2024 08:33:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-5-apatel@ventanamicro.com> <20240305-76d8a07fc239392a757ba9cf@orel>
In-Reply-To: <20240305-76d8a07fc239392a757ba9cf@orel>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 25 Mar 2024 21:02:58 +0530
Message-ID: <CAAhSdy1AKHbA9kDUNMsjwpXVxhyZY5t-jfnWEGLhL=y8=zS9Rw@mail.gmail.com>
Subject: Re: [kvmtool PATCH 04/10] riscv: Add scalar crypto extensions support
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Anup Patel <apatel@ventanamicro.com>, Will Deacon <will@kernel.org>, 
	julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 5, 2024 at 7:18=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Wed, Feb 14, 2024 at 05:51:35PM +0530, Anup Patel wrote:
> > When the scalar extensions are available expose them to the guest
> > via device tree so that guest can use it. This includes extensions
> > Zbkb, Zbkc, Zbkx, Zknd, Zkne, Zknh, Zkr, Zksed, Zksh, and Zkt.
> >
> > The Zkr extension requires SEED CSR emulation in user space so
> > we also add related KVM_EXIT_RISCV_CSR handling.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  riscv/fdt.c                         | 10 ++++++++++
> >  riscv/include/kvm/csr.h             | 15 ++++++++++++++
> >  riscv/include/kvm/kvm-config-arch.h | 30 ++++++++++++++++++++++++++++
> >  riscv/kvm-cpu.c                     | 31 +++++++++++++++++++++++++++++
> >  4 files changed, 86 insertions(+)
> >  create mode 100644 riscv/include/kvm/csr.h
> >
> > diff --git a/riscv/fdt.c b/riscv/fdt.c
> > index 84b6087..be87e9a 100644
> > --- a/riscv/fdt.c
> > +++ b/riscv/fdt.c
> > @@ -25,6 +25,9 @@ struct isa_ext_info isa_info_arr[] =3D {
> >       {"zba", KVM_RISCV_ISA_EXT_ZBA},
> >       {"zbb", KVM_RISCV_ISA_EXT_ZBB},
> >       {"zbc", KVM_RISCV_ISA_EXT_ZBC},
> > +     {"zbkb", KVM_RISCV_ISA_EXT_ZBKB},
> > +     {"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
> > +     {"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
> >       {"zbs", KVM_RISCV_ISA_EXT_ZBS},
> >       {"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
> >       {"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
> > @@ -34,6 +37,13 @@ struct isa_ext_info isa_info_arr[] =3D {
> >       {"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
> >       {"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
> >       {"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
> > +     {"zknd", KVM_RISCV_ISA_EXT_ZKND},
> > +     {"zkne", KVM_RISCV_ISA_EXT_ZKNE},
> > +     {"zknh", KVM_RISCV_ISA_EXT_ZKNH},
> > +     {"zkr", KVM_RISCV_ISA_EXT_ZKR},
> > +     {"zksed", KVM_RISCV_ISA_EXT_ZKSED},
> > +     {"zksh", KVM_RISCV_ISA_EXT_ZKSH},
> > +     {"zkt", KVM_RISCV_ISA_EXT_ZKT},
> >  };
> >
> >  static void dump_fdt(const char *dtb_file, void *fdt)
> > diff --git a/riscv/include/kvm/csr.h b/riscv/include/kvm/csr.h
> > new file mode 100644
> > index 0000000..2d27f74
> > --- /dev/null
> > +++ b/riscv/include/kvm/csr.h
> > @@ -0,0 +1,15 @@
>
> SPDX header?

Added in v2.

>
> > +#ifndef KVM__KVM_CSR_H
> > +#define KVM__KVM_CSR_H
> > +
> > +#include <linux/const.h>
> > +
> > +/* Scalar Crypto Extension - Entropy */
> > +#define CSR_SEED             0x015
> > +#define SEED_OPST_MASK               _AC(0xC0000000, UL)
> > +#define SEED_OPST_BIST               _AC(0x00000000, UL)
> > +#define SEED_OPST_WAIT               _AC(0x40000000, UL)
> > +#define SEED_OPST_ES16               _AC(0x80000000, UL)
> > +#define SEED_OPST_DEAD               _AC(0xC0000000, UL)
> > +#define SEED_ENTROPY_MASK    _AC(0xFFFF, UL)
> > +
> > +#endif /* KVM__KVM_CSR_H */
> > diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kv=
m-config-arch.h
> > index 6d09eee..3764d7c 100644
> > --- a/riscv/include/kvm/kvm-config-arch.h
> > +++ b/riscv/include/kvm/kvm-config-arch.h
> > @@ -52,6 +52,15 @@ struct kvm_config_arch {
> >       OPT_BOOLEAN('\0', "disable-zbc",                                \
> >                   &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBC],        \
> >                   "Disable Zbc Extension"),                           \
> > +     OPT_BOOLEAN('\0', "disable-zbkb",                               \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKB],       \
> > +                 "Disable Zbkb Extension"),                          \
> > +     OPT_BOOLEAN('\0', "disable-zbkc",                               \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKC],       \
> > +                 "Disable Zbkc Extension"),                          \
> > +     OPT_BOOLEAN('\0', "disable-zbkx",                               \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKX],       \
> > +                 "Disable Zbkx Extension"),                          \
> >       OPT_BOOLEAN('\0', "disable-zbs",                                \
> >                   &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],        \
> >                   "Disable Zbs Extension"),                           \
> > @@ -79,6 +88,27 @@ struct kvm_config_arch {
> >       OPT_BOOLEAN('\0', "disable-zihpm",                              \
> >                   &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHPM],      \
> >                   "Disable Zihpm Extension"),                         \
> > +     OPT_BOOLEAN('\0', "disable-zknd",                               \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKND],       \
> > +                 "Disable Zknd Extension"),                          \
> > +     OPT_BOOLEAN('\0', "disable-zkne",                               \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKNE],       \
> > +                 "Disable Zkne Extension"),                          \
> > +     OPT_BOOLEAN('\0', "disable-zknh",                               \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKNH],       \
> > +                 "Disable Zknh Extension"),                          \
> > +     OPT_BOOLEAN('\0', "disable-zkr",                                \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKR],        \
> > +                 "Disable Zkr Extension"),                           \
> > +     OPT_BOOLEAN('\0', "disable-zksed",                              \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKSED],      \
> > +                 "Disable Zksed Extension"),                         \
> > +     OPT_BOOLEAN('\0', "disable-zksh",                               \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKSH],       \
> > +                 "Disable Zksh Extension"),                          \
> > +     OPT_BOOLEAN('\0', "disable-zkt",                                \
> > +                 &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKT],        \
> > +                 "Disable Zkt Extension"),                           \
> >       OPT_BOOLEAN('\0', "disable-sbi-legacy",                         \
> >                   &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_V01],    \
> >                   "Disable SBI Legacy Extensions"),                   \
> > diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
> > index c4e83c4..3e17c12 100644
> > --- a/riscv/kvm-cpu.c
> > +++ b/riscv/kvm-cpu.c
> > @@ -1,3 +1,4 @@
> > +#include "kvm/csr.h"
> >  #include "kvm/kvm-cpu.h"
> >  #include "kvm/kvm.h"
> >  #include "kvm/virtio.h"
> > @@ -222,11 +223,41 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcp=
u)
> >       return ret;
> >  }
> >
> > +static bool kvm_cpu_riscv_csr(struct kvm_cpu *vcpu)
> > +{
> > +     int dfd =3D kvm_cpu__get_debug_fd();
> > +     bool ret =3D true;
> > +
> > +     switch (vcpu->kvm_run->riscv_csr.csr_num) {
> > +     case CSR_SEED:
> > +             /*
> > +              * We ignore the new_value and write_mask and simply
> > +              * return a random value as SEED.
> > +              */
> > +             vcpu->kvm_run->riscv_csr.ret_value =3D rand() & SEED_ENTR=
OPY_MASK;
>
> Shouldn't this be
>
>  vcpu->kvm_run->riscv_csr.ret_value =3D SEED_OPST_ES16 | (rand() & SEED_E=
NTROPY_MASK);

Good catch. Addressed in v2.

>
> > +             break;
> > +     default:
> > +             dprintf(dfd, "Unhandled CSR access\n");
> > +             dprintf(dfd, "csr_num=3D0x%lx new_value=3D0x%lx\n",
> > +                     vcpu->kvm_run->riscv_csr.csr_num,
> > +                     vcpu->kvm_run->riscv_csr.new_value);
> > +             dprintf(dfd, "write_mask=3D0x%lx ret_value=3D0x%lx\n",
> > +                     vcpu->kvm_run->riscv_csr.write_mask,
> > +                     vcpu->kvm_run->riscv_csr.ret_value);
> > +             ret =3D false;
> > +             break;
> > +     };
>
> Extra ';'

Updated in v2.

>
> > +
> > +     return ret;
> > +}
> > +
> >  bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> >  {
> >       switch (vcpu->kvm_run->exit_reason) {
> >       case KVM_EXIT_RISCV_SBI:
> >               return kvm_cpu_riscv_sbi(vcpu);
> > +     case KVM_EXIT_RISCV_CSR:
> > +             return kvm_cpu_riscv_csr(vcpu);
> >       default:
> >               break;
> >       };
> > --
> > 2.34.1
> >
>
> Thanks,
> drew

Regards,
Anup

