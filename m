Return-Path: <kvm+bounces-44134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A819A9AE21
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62FCA3AEA0A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719F627BF9A;
	Thu, 24 Apr 2025 12:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="N4KldbH4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076E927E1B4
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745499472; cv=none; b=K4582b1BbAdDDpiWZZ5YO0aXKsbh71XbgOGHQWwMWQiQfd1q7uBYqELhJoqZ3/KSZe7Ug0fTuKF85oguSJGIbr/4jsUF1KdQesytil20WVTely/2sWYnVG9m6XYXu1gUKKH5NSi5O7BJ5mic7T/7/VGCA16KnQ6FALIoL5Z65T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745499472; c=relaxed/simple;
	bh=oavouh5n0j38NLG6XYQ0aB79CTa2fcPt03xRvS/prYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eB+ALIuxpHvn/txNZ3924yRESMga5OIzqyBiamOyjH+9gCJveSevhoThT+JRbFfflb23PBjVYQctLXwf4hc7hEE9tJgvJpN7yx9I9f8VwKcomEyMlQ28gnpGTEQ4oPthiXvo7d/6yP78dWcXmJfeEZAYMEmPO54NJRr6OzJK90g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=N4KldbH4; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5499659e669so1059409e87.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 05:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745499468; x=1746104268; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dL7GTduliC71B7Q0JFRK/1bU8NYAd/gRPFZsQ61Wm2Q=;
        b=N4KldbH4HgnMHlXa0gkVz4Jul+UrMoiAwuJVZ9g6ItWjUuIBzRcJt7qdTVjVNsVSuV
         bx2z4FzgzL1NZi3CBHSRm4CtFaoAOxPsRb+EPgpmNkwLCKYkWU5o20SoLik4rhhhHGOg
         SIYaw6WxqargoldEw00mVHKnqggBMzby5buZoUHhHij2DtrIsv5wrbDem+HIz5hY4EZ8
         lHBs2GW0EDzpxPff8EA8vL+o+NFqkov/hEB656GPni8gxUJH8D6/oqnaLg1c7hHAbyC4
         joXY9Tvm0/7Fe+PYB2rd7I5+3NhQx1T3d17XJByWD18hl0MVX1m/mASLOWATS0+RPgSr
         Wxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745499468; x=1746104268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dL7GTduliC71B7Q0JFRK/1bU8NYAd/gRPFZsQ61Wm2Q=;
        b=cb/as2/XVzs19qTUdfciBgfKWVhlw8dvb19eBODT21NkOryevXIl9KHS1gpZv/TVhV
         WGAbaUR+sogD4UGU6v7ZHsTzFeXGMj8Ns0//gVjXE1keP+lAG/3DpEzlEunf/0O8K5im
         l8oG6aBIdtAKm6zFRpS76/oypXo6XUjZhxN2ZWH1nCpFpqOJO02WFrv/4ja2nd7GtGZX
         CJdqGGgi3dvPAb58cDD4TudfVeCTBidxjWufug6QOOyzWuz6w0uXHcPqBL5HavEHeRYs
         VaDnpt2DELguLW+oc0LS4wng3f0LrAJeOyMVaCcRkq50s+4aL0vEuz+5gQZDbJ8ci+HZ
         Z1aQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvyaWtklMSwQS1vRtJqAV4yT9I4EQp6QBgfRJoJXx5+vvAX3aL2g3HA/HAM+CX7H2yKE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpLnVMuSRUOcLVG6mYbUePSMtqU0PFbTSQ5hgItkqK1zXLmfcW
	ul0FjKOV1NiU5wb8g8BpH8WhuSeQhLFlqXou23Le24SsrZsDJ6MF2xqHLvN3bzBLobK1jiLOAnA
	elRXyR80dnl1ojCcmTQjm0cCnPOY5nDOnqxTr7w==
X-Gm-Gg: ASbGncvi0ytGPx1XXIIWCIdMZsj09nvaARf2iNqB9oxpvXlZjG0n7ZS0cJbEUuoxwN1
	thRlFkGvLxp0W1s+e9PgHrzjOTJrQMVlrG78AsRxnxejCbo2JwoNgigHMo/aspd9usQRlr7B4q+
	XtSsv47fEVtw1/ey9Bt56uj0I=
X-Google-Smtp-Source: AGHT+IGM6/oWcwpdDPOaNvNYIzuh0he1GUlKtSMo7QWXR68gIVXnVzSqemN0fY5k86w3aRN8ECo0N92TVMl2KMJl7cg=
X-Received: by 2002:a05:6512:3f11:b0:545:cc2:acd7 with SMTP id
 2adb3069b0e04-54e7c428389mr758680e87.27.1745499467804; Thu, 24 Apr 2025
 05:57:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-10-apatel@ventanamicro.com> <20250412-6eb18b693df1bd8959bcdfc6@orel>
In-Reply-To: <20250412-6eb18b693df1bd8959bcdfc6@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 24 Apr 2025 18:27:35 +0530
X-Gm-Features: ATxdqUEFHK0qY0_sA9WeZMC377q7JmB1Zg16q4WaUy5UYrmToAL7LvLIPQKyKiE
Message-ID: <CAK9=C2XD2Zk98KJrPYqseVQO-m_tFA97r=eXb2XXJ10vpxuk=A@mail.gmail.com>
Subject: Re: [kvmtool PATCH 09/10] riscv: Add cpu-type command-line option
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 12, 2025 at 6:45=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Wed, Mar 26, 2025 at 12:26:43PM +0530, Anup Patel wrote:
> > Currently, the KVMTOOL always creates a VM with all available
> > ISA extensions virtualized by the in-kernel KVM module.
> >
> > For better flexibility, add cpu-type command-line option using
> > which users can select one of the available CPU types for VM.
> >
> > There are two CPU types supported at the moment namely "min"
> > and "max". The "min" CPU type implies VCPU with rv[64|32]imafdc
> > ISA whereas the "max" CPU type implies VCPU with all available
> > ISA extensions.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  riscv/aia.c                         |   2 +-
> >  riscv/fdt.c                         | 220 +++++++++++++++++-----------
> >  riscv/include/kvm/kvm-arch.h        |   2 +
> >  riscv/include/kvm/kvm-config-arch.h |   5 +
> >  riscv/kvm.c                         |   2 +
> >  5 files changed, 143 insertions(+), 88 deletions(-)
> >
> > diff --git a/riscv/aia.c b/riscv/aia.c
> > index 21d9704..cad53d4 100644
> > --- a/riscv/aia.c
> > +++ b/riscv/aia.c
> > @@ -209,7 +209,7 @@ void aia__create(struct kvm *kvm)
> >               .flags =3D 0,
> >       };
> >
> > -     if (kvm->cfg.arch.ext_disabled[KVM_RISCV_ISA_EXT_SSAIA])
> > +     if (riscv__isa_extension_disabled(kvm, KVM_RISCV_ISA_EXT_SSAIA))
> >               return;
> >
> >       err =3D ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &aia_device);
> > diff --git a/riscv/fdt.c b/riscv/fdt.c
> > index 46efb47..4c018c8 100644
> > --- a/riscv/fdt.c
> > +++ b/riscv/fdt.c
> > @@ -13,82 +13,134 @@ struct isa_ext_info {
> >       const char *name;
> >       unsigned long ext_id;
> >       bool multi_letter;
> > +     bool min_cpu_included;
> >  };
> >
> >  struct isa_ext_info isa_info_arr[] =3D {
> > -     /* single-letter */
> > -     {"a", KVM_RISCV_ISA_EXT_A, false},
> > -     {"c", KVM_RISCV_ISA_EXT_C, false},
> > -     {"d", KVM_RISCV_ISA_EXT_D, false},
> > -     {"f", KVM_RISCV_ISA_EXT_F, false},
> > -     {"h", KVM_RISCV_ISA_EXT_H, false},
> > -     {"i", KVM_RISCV_ISA_EXT_I, false},
> > -     {"m", KVM_RISCV_ISA_EXT_M, false},
> > -     {"v", KVM_RISCV_ISA_EXT_V, false},
> > +     /* single-letter ordered canonically as "IEMAFDQCLBJTPVNSUHKORWXY=
ZG" */
>
> The comment change and the tabulation should go in the previous patch.

Okay, I will update.

>
> > +     {"i",           KVM_RISCV_ISA_EXT_I,            false, true},
> > +     {"m",           KVM_RISCV_ISA_EXT_M,            false, true},
> > +     {"a",           KVM_RISCV_ISA_EXT_A,            false, true},
> > +     {"f",           KVM_RISCV_ISA_EXT_F,            false, true},
> > +     {"d",           KVM_RISCV_ISA_EXT_D,            false, true},
> > +     {"c",           KVM_RISCV_ISA_EXT_C,            false, true},
> > +     {"v",           KVM_RISCV_ISA_EXT_V,            false, false},
> > +     {"h",           KVM_RISCV_ISA_EXT_H,            false, false},
>
> To avoid keeping track of which boolean means what (and taking my .misa
> suggestion from the last patch), we can write these as, e.g.
>
>   {"c",         KVM_RISCV_ISA_EXT_C, .misa =3D true, .min_enabled =3D tru=
e  },
>   {"v",         KVM_RISCV_ISA_EXT_V, .misa =3D true,                     =
 },
>
> (Also renamed min_cpu_included to min_enabled since it better matches
>  the enabled/disabled concept we use everywhere else.)
>
> And we don't need to change any of the multi-letter extension entries
> since we're adding something false for them.

Okay, I will update.

>
> >       /* multi-letter sorted alphabetically */
> > -     {"smnpm", KVM_RISCV_ISA_EXT_SMNPM, true},
> ...
> >  };
> >
> > +static bool __isa_ext_disabled(struct kvm *kvm, struct isa_ext_info *i=
nfo)
> > +{
> > +     if (!strncmp(kvm->cfg.arch.cpu_type, "min", 3) &&
>
> kvm->cfg.arch.cpu_type can never be anything other than NULL, "min",
> "max", so we can just use strcmp.

Okay, I will update.

>
> > +         !info->min_cpu_included)
> > +             return true;
>
> If 'min_cpu_included' (or 'min_enabled') is all we plan to check for
> whether or not an extension is enabled for the 'min' cpu type, then
> we should write this as
>
>  if (!strcmp(kvm->cfg.arch.cpu_type, "min"))
>     return !info->min_enabled;
>
> Otherwise when min_enabled is true we'd still check
> kvm->cfg.arch.ext_disabled[info->ext_id].

The extensions part of "min" cpu_type can be disabled using
"--disable-xyz" command-line options hence the current approach.

>
> > +
> > +     return kvm->cfg.arch.ext_disabled[info->ext_id];
> > +}
> > +
> > +static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa=
_ext_info *info)
> > +{
> > +     if (!strncmp(kvm->cfg.arch.cpu_type, "min", 3) &&
>
> same strcmp comment

Okay, I will update.

>
> > +         !info->min_cpu_included)
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> > +bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_=
ext_id)
> > +{
> > +     struct isa_ext_info *info =3D NULL;
> > +     unsigned long i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(isa_info_arr); i++) {
> > +             if (isa_info_arr[i].ext_id =3D=3D isa_ext_id) {
> > +                     info =3D &isa_info_arr[i];
> > +                     break;
> > +             }
> > +     }
> > +     if (!info)
> > +             return true;
> > +
> > +     return __isa_ext_disabled(kvm, info);
> > +}
> > +
> > +int riscv__cpu_type_parser(const struct option *opt, const char *arg, =
int unset)
> > +{
> > +     struct kvm *kvm =3D opt->ptr;
> > +
> > +     if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(=
arg) !=3D 3)
> > +             die("Invalid CPU type %s\n", arg);
> > +
> > +     if (!strncmp(arg, "max", 3))
> > +             kvm->cfg.arch.cpu_type =3D "max";
> > +
> > +     if (!strncmp(arg, "min", 3))
>
> We can use strcmp for these two checks since we already checked strlen
> above. We also already know it's either 'min' or 'max' so we can just
> check one and default to the other.

Okay, I will update.

>
> > +             kvm->cfg.arch.cpu_type =3D "min";
> > +
> > +     return 0;
> > +}
> > +
> >  static void dump_fdt(const char *dtb_file, void *fdt)
> >  {
> >       int count, fd;
> > @@ -108,10 +160,8 @@ static void dump_fdt(const char *dtb_file, void *f=
dt)
> >  #define CPU_NAME_MAX_LEN 15
> >  static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
> >  {
> > -     int cpu, pos, i, index, valid_isa_len;
> > -     const char *valid_isa_order =3D "IEMAFDQCLBJTPVNSUHKORWXYZG";
> > -     int arr_sz =3D ARRAY_SIZE(isa_info_arr);
> >       unsigned long cbom_blksz =3D 0, cboz_blksz =3D 0, satp_mode =3D 0=
;
> > +     int i, cpu, pos, arr_sz =3D ARRAY_SIZE(isa_info_arr);
> >
> >       _FDT(fdt_begin_node(fdt, "cpus"));
> >       _FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
> > @@ -131,18 +181,8 @@ static void generate_cpu_nodes(void *fdt, struct k=
vm *kvm)
> >
> >               snprintf(cpu_isa, CPU_ISA_MAX_LEN, "rv%ld", vcpu->riscv_x=
len);
> >               pos =3D strlen(cpu_isa);
> > -             valid_isa_len =3D strlen(valid_isa_order);
> > -             for (i =3D 0; i < valid_isa_len; i++) {
> > -                     index =3D valid_isa_order[i] - 'A';
> > -                     if (vcpu->riscv_isa & (1 << (index)))
> > -                             cpu_isa[pos++] =3D 'a' + index;
> > -             }
> >
> >               for (i =3D 0; i < arr_sz; i++) {
> > -                     /* Skip single-letter extensions since these are =
taken care */
> > -                     if (!isa_info_arr[i].multi_letter)
> > -                             continue;
> > -
> >                       reg.id =3D RISCV_ISA_EXT_REG(isa_info_arr[i].ext_=
id);
> >                       reg.addr =3D (unsigned long)&isa_ext_out;
> >                       if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) <=
 0)
> > @@ -151,9 +191,10 @@ static void generate_cpu_nodes(void *fdt, struct k=
vm *kvm)
> >                               /* This extension is not available in har=
dware */
> >                               continue;
> >
> > -                     if (kvm->cfg.arch.ext_disabled[isa_info_arr[i].ex=
t_id]) {
> > +                     if (__isa_ext_disabled(kvm, &isa_info_arr[i])) {
> >                               isa_ext_out =3D 0;
> > -                             if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG,=
 &reg) < 0)
> > +                             if ((ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG=
, &reg) < 0) &&
>
> Unnecessary () around the first expression.

Okay, I will update.

>
> > +                                  __isa_ext_warn_disable_failure(kvm, =
&isa_info_arr[i]))
> >                                       pr_warning("Failed to disable %s =
ISA exension\n",
> >                                                  isa_info_arr[i].name);
> >                               continue;
> > @@ -178,8 +219,13 @@ static void generate_cpu_nodes(void *fdt, struct k=
vm *kvm)
> >                                          isa_info_arr[i].name);
> >                               break;
> >                       }
> > -                     pos +=3D snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN =
- pos, "_%s",
> > -                                     isa_info_arr[i].name);
> > +
> > +                     if (isa_info_arr[i].multi_letter)
> > +                             pos +=3D snprintf(cpu_isa + pos, CPU_ISA_=
MAX_LEN - pos, "_%s",
> > +                                             isa_info_arr[i].name);
> > +                     else
> > +                             pos +=3D snprintf(cpu_isa + pos, CPU_ISA_=
MAX_LEN - pos, "%s",
> > +                                             isa_info_arr[i].name);
>
> Can write this as

Okay, I will update.

>
>                         pos +=3D snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN =
- pos, "%s%s",
>                                         isa_info_arr[i].misa ? "" : "_",
>                                         isa_info_arr[i].name);
>
> >               }
> >               cpu_isa[pos] =3D '\0';
> >
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.=
h
> > index f0f469f..1bb2d32 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -90,6 +90,8 @@ enum irqchip_type {
> >       IRQCHIP_AIA
> >  };
> >
> > +bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long ext_=
id);
> > +
> >  extern enum irqchip_type riscv_irqchip;
> >  extern bool riscv_irqchip_inkernel;
> >  extern void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq,
> > diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kv=
m-config-arch.h
> > index 7e54d8a..26b1b50 100644
> > --- a/riscv/include/kvm/kvm-config-arch.h
> > +++ b/riscv/include/kvm/kvm-config-arch.h
> > @@ -4,6 +4,7 @@
> >  #include "kvm/parse-options.h"
> >
> >  struct kvm_config_arch {
> > +     const char      *cpu_type;
> >       const char      *dump_dtb_filename;
> >       u64             suspend_seconds;
> >       u64             custom_mvendorid;
> > @@ -13,8 +14,12 @@ struct kvm_config_arch {
> >       bool            sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
> >  };
> >
> > +int riscv__cpu_type_parser(const struct option *opt, const char *arg, =
int unset);
> > +
> >  #define OPT_ARCH_RUN(pfx, cfg)                                        =
       \
> >       pfx,                                                            \
> > +     OPT_CALLBACK('\0', "cpu-type", kvm, "min or max",               \
> > +                  "Choose the cpu type (default is max).", riscv__cpu_=
type_parser, kvm),\
>
> I had to look ahead at the next patch to understand why we're setting kvm
> as the opt pointer here. I think it should be added in the next patch
> where it's used. Also, we don't use opt->value so we cna set that to NULL=
.

We are indeed using opt->ptr in this patch so we should be passing
kvm as opt-ptr.

We certainly don't need opt->value so we can pass NULL for this.

>
> >       OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,         \
> >                  ".dtb file", "Dump generated .dtb to specified file"),=
\
> >       OPT_U64('\0', "suspend-seconds",                                \
> > diff --git a/riscv/kvm.c b/riscv/kvm.c
> > index 1d49479..6a1b154 100644
> > --- a/riscv/kvm.c
> > +++ b/riscv/kvm.c
> > @@ -20,6 +20,8 @@ u64 kvm__arch_default_ram_address(void)
> >
> >  void kvm__arch_validate_cfg(struct kvm *kvm)
> >  {
> > +     if (!kvm->cfg.arch.cpu_type)
> > +             kvm->cfg.arch.cpu_type =3D "max";
> >  }
>
> Hmm, seems like we're missing the right place for this. A validate
> function shouln't be setting defaults. I think we should rename
> kvm__arch_default_ram_address() to
>
>   void kvm__arch_set_defaults(struct kvm_config *cfg)
>
> and set cfg->ram_addr inside it. Then add the cpu_type default
> setting to riscv's impl.

Renaming kvm__arch_default_ram_address() is certainly not
the right way because it has to be done after parsing options
so that we set the default value of cpu_type only if it is not
set by command-line options. Due to this reason, the
kvm__arch_validate_cfg() is the best place to set default
value of cpu_type.

Although, I do agree that the function name of
kvm__arch_validate_cfg() is misleading.

Maybe kvm__arch_validate_and_init_cfg() is a better name ?

Regards,
Anup

