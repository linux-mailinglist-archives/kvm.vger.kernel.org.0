Return-Path: <kvm+bounces-54841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9416B292E7
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ADD61897F99
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504B7244688;
	Sun, 17 Aug 2025 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cXV1PbBc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2395C207A20
	for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 12:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755432302; cv=none; b=kKNg0t3RoXZ3ZiTL6ymO1fHCsZ9GYgk48M9maSjehlbtZ4cPoaT1r2WOyScqk6puoswnXb3XVVyu5dYxYVtZbLcPZShOgHJzh58ti5W6xGo/YVs0NUwaVnEcdPbHRiyC3A88EivZVAwmhymFL+CzT5XzllPH4jqyixsc1fGPCJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755432302; c=relaxed/simple;
	bh=dWihTbVY0V0yeOIQdxcalr/Zo4MNTwyiN2GsVjBKFrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=upgakph3mjXyPeAI27BYCWS0qaZY7cNYs6raDEV3093gLLK0FMe1wxM7bkMbwZIzjJD692tj/tD29E6xK3q6lzWzBrJeTj325jBVPkXDFHWv+4s729qwaKJhEkbOtnhIC2MwDAgDG1em0bNzFzYpcHWlFHZrYYOlwZZfIOylmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cXV1PbBc; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55ce510b4ceso3788878e87.1
        for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 05:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755432298; x=1756037098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyUaERXKOonlJ9f+CKZUq1mf2VPLsVOlKnPBhX4zOQc=;
        b=cXV1PbBc5fE6yvjDbZpjKdwtIGkePQVgF0NhZiGOwnbD/bvMIIzOKUxM038dU7gygS
         rHc7M8R72MMcLdxLteL4t39eib7nG+sfw8u5IT5FL/zhPb5fucMoJmTx3kjmyuHdJba2
         mv/gU10zHkw6Pvg+mltXWcQidr9lWiRF/fGjoBhbhlNeo+l7wpmZIG4YlG3d5Zbz9d7y
         4YOe7HsE5bQhRGMzNL4J1SWpCQ7yDIVO3z95LHcyEhxFbZ0qvdkrvn5CA4hzNbK53lUv
         289o9ZCAxjAoZXM41Vi/YSIEwOl4x8lJf8dIP/S1rWXtzdOrRpbavONtl6vkBGkC27qW
         /17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755432298; x=1756037098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FyUaERXKOonlJ9f+CKZUq1mf2VPLsVOlKnPBhX4zOQc=;
        b=WQD3CGy7w10oLv7Zp/h2DQW92GY1HRArTr24llDslNvedyypKoRUWbDNLkmvoBCmcE
         sE2kYNro7tfxPfsfOpNbBJzNHINZRjFyoXIYpaYqIiQcXQICbVZzDVZfAOQrQQnEz2U4
         gln+4Az8PMi0RY7pZVFmeMT42/T6OFpuFePHb7P48o5dfTf3w11Sk2/jSxReOcU+jory
         vldAQF9aOaZfVimFn2VXhvBPi55nbwU8wDtlEHhpa9F/y3ZSPBHnF3lIDMivuNbBGqkJ
         IrN0VSVYXmiiqzeX+dpY4pAF0nMQJqdG4DAHFKnvDAhpa5KMZvAj32y8FfVQN30hv4lc
         V52Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7T06Fypkk655ZesDx5fBFL+CHEjBD8dGZsvhmTSQJGW1pO5pkSA0pKEYSaoM3cS3AIpU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzVn47mDi4Ru4GUFbZzrPhEYlAI0656f9q6t8nhD9VqZUPzBHp
	OHVLAJnwHjSazjR81eQZHQq4tvtwW/YXaFgxgZtlqJCU19ANG7jfAY0/a1lqYVJtBEXWGyVhIVL
	hWhmZqVFY4ge0y2GHnLs9LW2JzQKWHxJ1UheJrM71FXc8RL1xXxTNDv8=
X-Gm-Gg: ASbGncs8rFx/vwaiD8oaGK1ROV6y7GygFC767CKbLYgxYbw7aEAWOlNR0whvHdbyyMk
	I385Ky+xmbmLWLfaaJdpM9WjLznU2bELHci0vkSGhL4J21D0HCUzfBTGkRsL5DSaDQJxdoRodLZ
	pZGqNsXJYmvJNF18pOxc2UFSeOY+iAnQGSb0HnxKYCeX8TF8u0FcJHP5PA7ILBqXXenjuas+Hgw
	CHciM7a
X-Google-Smtp-Source: AGHT+IEyNzfbZhdXQ7rb6f0VG54rzMaji03iQdx8UEqo7AKyxfgoFlptD/0gBrTKiojFcrB8xOzt0NjKyuvNNt6KEhQ=
X-Received: by 2002:a05:6512:2618:b0:553:3a0a:1892 with SMTP id
 2adb3069b0e04-55cf2c70df9mr1095099e87.15.1755432298026; Sun, 17 Aug 2025
 05:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814155548.457172-1-apatel@ventanamicro.com>
 <20250814155548.457172-4-apatel@ventanamicro.com> <20250815-4414a697ab004422374f4d56@orel>
In-Reply-To: <20250815-4414a697ab004422374f4d56@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sun, 17 Aug 2025 17:34:46 +0530
X-Gm-Features: Ac12FXy9K3IiBRuzz5MfSv8Ut3SrrEaBKWAywKXdNkBJETyoz1rlXn7Ct5T0myY
Message-ID: <CAK9=C2X7iNd+tXaj+V3jeeBFw2dDavhf69VNtiK49tn7hYDa=g@mail.gmail.com>
Subject: Re: [PATCH 3/6] RISC-V: KVM: Introduce optional ONE_REG callbacks for
 SBI extensions
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 16, 2025 at 2:30=E2=80=AFAM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Aug 14, 2025 at 09:25:45PM +0530, Anup Patel wrote:
> > SBI extensions can have per-VCPU state which needs to be saved/restored
> > through ONE_REG interface for Guest/VM migration. Introduce optional
> > ONE_REG callbacks for SBI extensions so that ONE_REG implementation
> > for an SBI extenion is part of the extension sources.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  21 ++--
> >  arch/riscv/kvm/vcpu_onereg.c          |  31 +-----
> >  arch/riscv/kvm/vcpu_sbi.c             | 145 ++++++++++++++++++++++----
> >  arch/riscv/kvm/vcpu_sbi_sta.c         |  64 ++++++++----
> >  4 files changed, 178 insertions(+), 83 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include=
/asm/kvm_vcpu_sbi.h
> > index 766031e80960..144c3f6d5eb9 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > @@ -59,6 +59,15 @@ struct kvm_vcpu_sbi_extension {
> >       void (*deinit)(struct kvm_vcpu *vcpu);
> >
> >       void (*reset)(struct kvm_vcpu *vcpu);
> > +
> > +     bool have_state;
> > +     unsigned long state_reg_subtype;
> > +     unsigned long (*get_state_reg_count)(struct kvm_vcpu *vcpu);
>
> I think we can drop 'have_state'. When 'get_state_reg_count' is NULL, the=
n
> the state reg count must be zero (i.e. have_state =3D=3D false).

Good suggestion. I will update in the next revision.

>
> > +     int (*get_state_reg_id)(struct kvm_vcpu *vcpu, int index, u64 *re=
g_id);
> > +     int (*get_state_reg)(struct kvm_vcpu *vcpu, unsigned long reg_num=
,
> > +                          unsigned long reg_size, void *reg_val);
> > +     int (*set_state_reg)(struct kvm_vcpu *vcpu, unsigned long reg_num=
,
> > +                          unsigned long reg_size, const void *reg_val)=
;
> >  };
> >
> >  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run =
*run);
> > @@ -73,10 +82,9 @@ int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *=
vcpu,
> >                                  const struct kvm_one_reg *reg);
> >  int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> >                                  const struct kvm_one_reg *reg);
> > -int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu,
> > -                            const struct kvm_one_reg *reg);
> > -int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu,
> > -                            const struct kvm_one_reg *reg);
> > +int kvm_riscv_vcpu_reg_indices_sbi(struct kvm_vcpu *vcpu, u64 __user *=
uindices);
> > +int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm=
_one_reg *reg);
> > +int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm=
_one_reg *reg);
> >  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> >                               struct kvm_vcpu *vcpu, unsigned long exti=
d);
> >  bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
> > @@ -85,11 +93,6 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
> >  void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu);
> >
> > -int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned lon=
g reg_num,
> > -                                unsigned long *reg_val);
> > -int kvm_riscv_vcpu_set_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned lon=
g reg_num,
> > -                                unsigned long reg_val);
> > -
> >  #ifdef CONFIG_RISCV_SBI_V01
> >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> >  #endif
> > diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.=
c
> > index b77748a56a59..5843b0519224 100644
> > --- a/arch/riscv/kvm/vcpu_onereg.c
> > +++ b/arch/riscv/kvm/vcpu_onereg.c
> > @@ -1090,36 +1090,9 @@ static unsigned long num_sbi_ext_regs(struct kvm=
_vcpu *vcpu)
> >       return copy_sbi_ext_reg_indices(vcpu, NULL);
> >  }
> >
> > -static int copy_sbi_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uin=
dices)
> > -{
> > -     struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> > -     int total =3D 0;
> > -
> > -     if (scontext->ext_status[KVM_RISCV_SBI_EXT_STA] =3D=3D KVM_RISCV_=
SBI_EXT_STATUS_ENABLED) {
> > -             u64 size =3D IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 =
: KVM_REG_SIZE_U64;
> > -             int n =3D sizeof(struct kvm_riscv_sbi_sta) / sizeof(unsig=
ned long);
> > -
> > -             for (int i =3D 0; i < n; i++) {
> > -                     u64 reg =3D KVM_REG_RISCV | size |
> > -                               KVM_REG_RISCV_SBI_STATE |
> > -                               KVM_REG_RISCV_SBI_STA | i;
> > -
> > -                     if (uindices) {
> > -                             if (put_user(reg, uindices))
> > -                                     return -EFAULT;
> > -                             uindices++;
> > -                     }
> > -             }
> > -
> > -             total +=3D n;
> > -     }
> > -
> > -     return total;
> > -}
> > -
> >  static inline unsigned long num_sbi_regs(struct kvm_vcpu *vcpu)
> >  {
> > -     return copy_sbi_reg_indices(vcpu, NULL);
> > +     return kvm_riscv_vcpu_reg_indices_sbi(vcpu, NULL);
> >  }
> >
> >  static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcp=
u)
> > @@ -1247,7 +1220,7 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vc=
pu *vcpu,
> >               return ret;
> >       uindices +=3D ret;
> >
> > -     ret =3D copy_sbi_reg_indices(vcpu, uindices);
> > +     ret =3D kvm_riscv_vcpu_reg_indices_sbi(vcpu, uindices);
> >       if (ret < 0)
> >               return ret;
> >       uindices +=3D ret;
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index 01a93f4fdb16..8b3c393e0c83 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -364,64 +364,163 @@ int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vc=
pu *vcpu,
> >       return 0;
> >  }
> >
> > -int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu,
> > -                            const struct kvm_one_reg *reg)
> > +int kvm_riscv_vcpu_reg_indices_sbi(struct kvm_vcpu *vcpu, u64 __user *=
uindices)
> > +{
> > +     struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> > +     const struct kvm_riscv_sbi_extension_entry *entry;
> > +     const struct kvm_vcpu_sbi_extension *ext;
> > +     unsigned long state_reg_count;
> > +     int i, j, rc, count =3D 0;
> > +     u64 reg;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > +             entry =3D &sbi_ext[i];
> > +             ext =3D entry->ext_ptr;
> > +
> > +             if (!ext->have_state ||
> > +                 scontext->ext_status[entry->ext_idx] !=3D KVM_RISCV_S=
BI_EXT_STATUS_ENABLED)
> > +                     continue;
> > +
> > +             state_reg_count =3D ext->get_state_reg_count(vcpu);
> > +             if (!uindices)
> > +                     goto skip_put_user;
> > +
> > +             for (j =3D 0; j < state_reg_count; j++) {
> > +                     if (ext->get_state_reg_id) {
> > +                             rc =3D ext->get_state_reg_id(vcpu, j, &re=
g);
> > +                             if (rc)
> > +                                     return rc;
> > +                     } else {
> > +                             reg =3D KVM_REG_RISCV |
> > +                                   (IS_ENABLED(CONFIG_32BIT) ?
> > +                                    KVM_REG_SIZE_U32 : KVM_REG_SIZE_U6=
4) |
> > +                                   KVM_REG_RISCV_SBI_STATE |
> > +                                   ext->state_reg_subtype | j;
> > +                     }
> > +
> > +                     if (put_user(reg, uindices))
> > +                             return -EFAULT;
> > +                     uindices++;
> > +             }
> > +
> > +skip_put_user:
> > +             count +=3D state_reg_count;
> > +     }
> > +
> > +     return count;
> > +}
> > +
> > +static const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext_with=
state(struct kvm_vcpu *vcpu,
> > +                                                                      =
   unsigned long subtype)
> > +{
> > +     struct kvm_vcpu_sbi_context *scontext =3D &vcpu->arch.sbi_context=
;
> > +     const struct kvm_riscv_sbi_extension_entry *entry;
> > +     const struct kvm_vcpu_sbi_extension *ext;
> > +     int i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
> > +             entry =3D &sbi_ext[i];
> > +             ext =3D entry->ext_ptr;
> > +
> > +             if (ext->have_state &&
> > +                 ext->state_reg_subtype =3D=3D subtype &&
> > +                 scontext->ext_status[entry->ext_idx] =3D=3D KVM_RISCV=
_SBI_EXT_STATUS_ENABLED)
> > +                     return ext;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm=
_one_reg *reg)
> >  {
> >       unsigned long __user *uaddr =3D
> >                       (unsigned long __user *)(unsigned long)reg->addr;
> >       unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> >                                           KVM_REG_SIZE_MASK |
> >                                           KVM_REG_RISCV_SBI_STATE);
> > -     unsigned long reg_subtype, reg_val;
> > -
> > -     if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> > +     const struct kvm_vcpu_sbi_extension *ext;
> > +     unsigned long reg_subtype;
> > +     void *reg_val;
> > +     u64 data64;
> > +     u32 data32;
> > +     u16 data16;
> > +     u8 data8;
> > +
> > +     switch (KVM_REG_SIZE(reg->id)) {
> > +     case 1:
> > +             reg_val =3D &data8;
> > +             break;
> > +     case 2:
> > +             reg_val =3D &data16;
> > +             break;
> > +     case 4:
> > +             reg_val =3D &data32;
> > +             break;
> > +     case 8:
> > +             reg_val =3D &data64;
> > +             break;
> > +     default:
> >               return -EINVAL;
> > +     };
>
> superfluous ';'

Okay, I will update in the next revision.

>
> >
> > -     if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> > +     if (copy_from_user(reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> >               return -EFAULT;
> >
> >       reg_subtype =3D reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> >       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> >
> > -     switch (reg_subtype) {
> > -     case KVM_REG_RISCV_SBI_STA:
> > -             return kvm_riscv_vcpu_set_reg_sbi_sta(vcpu, reg_num, reg_=
val);
> > -     default:
> > +     ext =3D kvm_vcpu_sbi_find_ext_withstate(vcpu, reg_subtype);
> > +     if (!ext || !ext->set_state_reg)
> >               return -EINVAL;
> > -     }
> >
> > -     return 0;
> > +     return ext->set_state_reg(vcpu, reg_num, KVM_REG_SIZE(reg->id), r=
eg_val);
> >  }
> >
> > -int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu,
> > -                            const struct kvm_one_reg *reg)
> > +int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm=
_one_reg *reg)
> >  {
> >       unsigned long __user *uaddr =3D
> >                       (unsigned long __user *)(unsigned long)reg->addr;
> >       unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
> >                                           KVM_REG_SIZE_MASK |
> >                                           KVM_REG_RISCV_SBI_STATE);
> > -     unsigned long reg_subtype, reg_val;
> > +     const struct kvm_vcpu_sbi_extension *ext;
> > +     unsigned long reg_subtype;
> > +     void *reg_val;
> > +     u64 data64;
> > +     u32 data32;
> > +     u16 data16;
> > +     u8 data8;
> >       int ret;
> >
> > -     if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
> > +     switch (KVM_REG_SIZE(reg->id)) {
> > +     case 1:
> > +             reg_val =3D &data8;
> > +             break;
> > +     case 2:
> > +             reg_val =3D &data16;
> > +             break;
> > +     case 4:
> > +             reg_val =3D &data32;
> > +             break;
> > +     case 8:
> > +             reg_val =3D &data64;
> > +             break;
> > +     default:
> >               return -EINVAL;
> > +     };
>
> superfluous ';'

Okay, I will update in the next revision.

>
> >
> >       reg_subtype =3D reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> >       reg_num &=3D ~KVM_REG_RISCV_SUBTYPE_MASK;
> >
> > -     switch (reg_subtype) {
> > -     case KVM_REG_RISCV_SBI_STA:
> > -             ret =3D kvm_riscv_vcpu_get_reg_sbi_sta(vcpu, reg_num, &re=
g_val);
> > -             break;
> > -     default:
> > +     ext =3D kvm_vcpu_sbi_find_ext_withstate(vcpu, reg_subtype);
> > +     if (!ext || !ext->get_state_reg)
> >               return -EINVAL;
> > -     }
> >
> > +     ret =3D ext->get_state_reg(vcpu, reg_num, KVM_REG_SIZE(reg->id), =
reg_val);
> >       if (ret)
> >               return ret;
> >
> > -     if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> > +     if (copy_to_user(uaddr, reg_val, KVM_REG_SIZE(reg->id)))
> >               return -EFAULT;
> >
> >       return 0;
> > diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_st=
a.c
> > index cc6cb7c8f0e4..d14cf6255d83 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> > @@ -151,63 +151,83 @@ static unsigned long kvm_sbi_ext_sta_probe(struct=
 kvm_vcpu *vcpu)
> >       return !!sched_info_on();
> >  }
> >
> > -const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta =3D {
> > -     .extid_start =3D SBI_EXT_STA,
> > -     .extid_end =3D SBI_EXT_STA,
> > -     .handler =3D kvm_sbi_ext_sta_handler,
> > -     .probe =3D kvm_sbi_ext_sta_probe,
> > -     .reset =3D kvm_riscv_vcpu_sbi_sta_reset,
> > -};
> > +static unsigned long kvm_sbi_ext_sta_get_state_reg_count(struct kvm_vc=
pu *vcpu)
> > +{
> > +     return sizeof(struct kvm_riscv_sbi_sta) / sizeof(unsigned long);
> > +}
> >
> > -int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu,
> > -                                unsigned long reg_num,
> > -                                unsigned long *reg_val)
> > +static int kvm_sbi_ext_sta_get_reg(struct kvm_vcpu *vcpu, unsigned lon=
g reg_num,
> > +                                unsigned long reg_size, void *reg_val)
> >  {
> > +     unsigned long *value;
> > +
> > +     if (reg_size !=3D sizeof(unsigned long))
> > +             return -EINVAL;
> > +     value =3D reg_val;
> > +
> >       switch (reg_num) {
> >       case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
> > -             *reg_val =3D (unsigned long)vcpu->arch.sta.shmem;
> > +             *value =3D (unsigned long)vcpu->arch.sta.shmem;
> >               break;
> >       case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
> >               if (IS_ENABLED(CONFIG_32BIT))
> > -                     *reg_val =3D upper_32_bits(vcpu->arch.sta.shmem);
> > +                     *value =3D upper_32_bits(vcpu->arch.sta.shmem);
> >               else
> > -                     *reg_val =3D 0;
> > +                     *value =3D 0;
> >               break;
> >       default:
> > -             return -EINVAL;
> > +             return -ENOENT;
> >       }
> >
> >       return 0;
> >  }
> >
> > -int kvm_riscv_vcpu_set_reg_sbi_sta(struct kvm_vcpu *vcpu,
> > -                                unsigned long reg_num,
> > -                                unsigned long reg_val)
> > +static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned lon=
g reg_num,
> > +                                unsigned long reg_size, const void *re=
g_val)
> >  {
> > +     unsigned long value;
> > +
> > +     if (reg_size !=3D sizeof(unsigned long))
> > +             return -EINVAL;
> > +     value =3D *(const unsigned long *)reg_val;
> > +
> >       switch (reg_num) {
> >       case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
> >               if (IS_ENABLED(CONFIG_32BIT)) {
> >                       gpa_t hi =3D upper_32_bits(vcpu->arch.sta.shmem);
> >
> > -                     vcpu->arch.sta.shmem =3D reg_val;
> > +                     vcpu->arch.sta.shmem =3D value;
> >                       vcpu->arch.sta.shmem |=3D hi << 32;
> >               } else {
> > -                     vcpu->arch.sta.shmem =3D reg_val;
> > +                     vcpu->arch.sta.shmem =3D value;
> >               }
> >               break;
> >       case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
> >               if (IS_ENABLED(CONFIG_32BIT)) {
> >                       gpa_t lo =3D lower_32_bits(vcpu->arch.sta.shmem);
> >
> > -                     vcpu->arch.sta.shmem =3D ((gpa_t)reg_val << 32);
> > +                     vcpu->arch.sta.shmem =3D ((gpa_t)value << 32);
> >                       vcpu->arch.sta.shmem |=3D lo;
> > -             } else if (reg_val !=3D 0) {
> > +             } else if (value !=3D 0) {
> >                       return -EINVAL;
> >               }
> >               break;
> >       default:
> > -             return -EINVAL;
> > +             return -ENOENT;
> >       }
> >
> >       return 0;
> >  }
> > +
> > +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta =3D {
> > +     .extid_start =3D SBI_EXT_STA,
> > +     .extid_end =3D SBI_EXT_STA,
> > +     .handler =3D kvm_sbi_ext_sta_handler,
> > +     .probe =3D kvm_sbi_ext_sta_probe,
> > +     .reset =3D kvm_riscv_vcpu_sbi_sta_reset,
> > +     .have_state =3D true,
> > +     .state_reg_subtype =3D KVM_REG_RISCV_SBI_STA,
> > +     .get_state_reg_count =3D kvm_sbi_ext_sta_get_state_reg_count,
> > +     .get_state_reg =3D kvm_sbi_ext_sta_get_reg,
> > +     .set_state_reg =3D kvm_sbi_ext_sta_set_reg,
> > +};
> > --
> > 2.43.0
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>

Thanks,
Anup

