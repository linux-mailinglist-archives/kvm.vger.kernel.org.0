Return-Path: <kvm+bounces-10593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D32BB86DC3B
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 454711F23214
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB8F69954;
	Fri,  1 Mar 2024 07:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oulFuplw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E36A69952
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 07:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709278924; cv=none; b=deEwVNcr96jWVNoRS3nTuNpp7OdzREeoIos97zTV49jE+daJ+BOiQPjrFNo1DzKu+Z4ocqtQffFpTvlzncDVXVbeEQkQ1Cs0mKUhqWrV6nPE0ViICzlJE8lPF0MCSwhva0z4rPIOjsyQSVOyMC6J3wJZzMvlDEouiuCMNyGJVZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709278924; c=relaxed/simple;
	bh=wFUxx6DzFeuxkKEsvnRW+K0fDd0cYYnaYF6T1+UNmeA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJkGd0hbZ9vz5C5D02Gu9BsHH4i9DZ6jr8OJv2po0yYyCWxblwmqIXI3Ux93SAD5xEWwgKVQhb00ev9GPIReOvd+pCKHIOlB6qyiw8yntNEa4HLAAP6KQbyNvEqUhOS/OtyUV8KT50ROGFOa0P+guIHRtyytxgl+AYf+JD1cCvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oulFuplw; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-512f3e75391so1541783e87.2
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 23:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709278921; x=1709883721; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkccNrWZdoZxP0mrO++NLB3QkLGur0wRvaYkBajMr4o=;
        b=oulFuplw9N1UNnUuvpXO1DfmUZ/k99k19ErpgT+1dmuRurjXoIEJrPxHJ96jdZCAlR
         LnvmCDD+P+QMOB8ltSrxONy3Hh3R4WxTgGNNtZf6aqcsqNI10AXotNQNbU4IUTEfsssl
         0dJuZ88GuH9ULNKx61T5KmZOVt0FCiW6xLAWd2wWRJ0r68yD0tJnSphuWaY7KCgAlbvJ
         78OYWjWRRLDP9300g5ytcjkeLTkI2L8nqhVhfYugqbL4BHI4K+hIHB91r+Jr/KlvLoK8
         XQ8QqnKT79OLDn6GiF/LRL+3FqLHh4d8LhSlbHCdQ6JY9M/vVcH2jocQKlI3LBihFpnM
         7lDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709278921; x=1709883721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkccNrWZdoZxP0mrO++NLB3QkLGur0wRvaYkBajMr4o=;
        b=RD00ta1EvDRhjTtBWBlBI+ybwiP44EnlOlSwZJ0xaOzjWQ73WByTYhUan2KUCB8Gep
         Ctq4uyGHgDNnUsXTPvBK69VFIkKZLDFl5AbwiKqc87i+Y2CZ2cXWzUcPcUVyVAJ3HNy7
         zVKreJl25KE8RTDHe5lPaH/nIUpE8TmqmclLtOlx3hNzpt8zvQPZs+fyx7rDgvA1CmBc
         4/m4/2MX19RcTbalHLDlRcemBdr4f6KsEnQFJw+og1S4c+YqUrY8Mec3+rqnkNoGr9NZ
         V7+tvbi5OgVhMbsRNgfNXRmCePLId8P/MxC6msTzkldQHfdldZnDuNaursXgUbMbrZo9
         KGZg==
X-Forwarded-Encrypted: i=1; AJvYcCUXM6TO2ceaoZrMxVdGUTa+dIv5pyky4TLWo99ciegWnYHSsSSWXGP4650RWgIVS2o5Hn56UVjqgZl1YwNG0s/6UsrP
X-Gm-Message-State: AOJu0YzWivi4gXWG780ghfWj3Ko7u1GAc2mkZG0+ZPZaORLEc5FClvmu
	vwNsHSKhZlppv36S252LMKQRqlHLC81wSCFu50tHNPW7iTBzvXdcnW3a8SSTzI015oWmMrXpB8K
	ZkInSxSW/fgm+34RbJH7EFYk9pVUeJ9AnMWNbog==
X-Google-Smtp-Source: AGHT+IGeZ/e9EPenJSwwtqwfTjZTV3Rs6mTLRjyPlv1sIDYdzZekJE7jaIdzINjO6ztD8gD4yQWzH7HbSNdb7bBEpjo=
X-Received: by 2002:a05:6512:310b:b0:512:e7dd:2532 with SMTP id
 n11-20020a056512310b00b00512e7dd2532mr629291lfb.30.1709278920546; Thu, 29 Feb
 2024 23:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301013545.10403-1-duchao@eswincomputing.com>
 <20240301013545.10403-2-duchao@eswincomputing.com> <CAAhSdy2+_+t4L8LHmYcJQZBGJHj6pyFm26_KwFBahFxz7eV1fQ@mail.gmail.com>
 <1f31ec16.1447.18df8b97f73.Coremail.duchao@eswincomputing.com>
 <CAAhSdy0x6bdm3hYk8jeRG_bF-vFXP8eOqYJ5GMY4Eb=bMNkaQw@mail.gmail.com> <698f58e.1490.18df8e9084f.Coremail.duchao@eswincomputing.com>
In-Reply-To: <698f58e.1490.18df8e9084f.Coremail.duchao@eswincomputing.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 1 Mar 2024 13:11:49 +0530
Message-ID: <CAK9=C2Wz6ZHjsxPMkMnRBT+maE2qLuy+zi4wCRJ+1nkssCX5FA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 12:57=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> On 2024-03-01 15:29, Anup Patel <anup@brainfault.org> wrote:
> >
> > On Fri, Mar 1, 2024 at 12:05=E2=80=AFPM Chao Du <duchao@eswincomputing.=
com> wrote:
> > >
> > > On 2024-03-01 13:00, Anup Patel <anup@brainfault.org> wrote:
> > > >
> > > > On Fri, Mar 1, 2024 at 7:08=E2=80=AFAM Chao Du <duchao@eswincomputi=
ng.com> wrote:
> > > > >
> > > > > kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEB=
UG is
> > > > > been checked.
> > > > >
> > > > > kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug fla=
gs
> > > > > from userspace accordingly. Route the breakpoint exceptions to HS=
 mode
> > > > > if the VCPU is being debugged by userspace, by clearing the
> > > > > corresponding bit in hedeleg. Write the actual CSR in
> > > > > kvm_arch_vcpu_load().
> > > > >
> > > > > Signed-off-by: Chao Du <duchao@eswincomputing.com>
> > > > > ---
> > > > >  arch/riscv/include/asm/kvm_host.h | 17 +++++++++++++++++
> > > > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > > > >  arch/riscv/kvm/main.c             | 18 ++----------------
> > > > >  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
> > > > >  arch/riscv/kvm/vm.c               |  1 +
> > > > >  5 files changed, 34 insertions(+), 18 deletions(-)
> > > > >
> > > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/inclu=
de/asm/kvm_host.h
> > > > > index 484d04a92fa6..9ee3f03ba5d1 100644
> > > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > > @@ -43,6 +43,22 @@
> > > > >         KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_W=
AKEUP)
> > > > >  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
> > > > >
> > > > > +#define KVM_HEDELEG_DEFAULT            ((_AC(1, UL) << EXC_INST_=
MISALIGNED) | \
> > > > > +                                        (_AC(1, UL) << EXC_BREAK=
POINT) | \
> > > > > +                                        (_AC(1, UL) << EXC_SYSCA=
LL) | \
> > > > > +                                        (_AC(1, UL) << EXC_INST_=
PAGE_FAULT) | \
> > > > > +                                        (_AC(1, UL) << EXC_LOAD_=
PAGE_FAULT) | \
> > > > > +                                        (_AC(1, UL) << EXC_STORE=
_PAGE_FAULT))
> > > >
> > > > Use BIT(xyz) here. For example: BIT(EXC_INST_MISALIGNED)
> > >
> > > Thanks, I will use BIT() instead in next revision.
> > >
> > > >
> > >
> > > > Also, BIT(EXC_BREAKPOINT) should not be part of KVM_HEDELEG_DEFAULT=
.
> > >
> > > I think the bit EXC_BREAKPOINT should be set by default, like what yo=
u
> > > already did in kvm_arch_hardware_enable(). Then the VS could get the =
ebreak
> > > and handle it accordingly.
> > >
> > > If the guest_debug is enabled, ebreak instructions are inserted by th=
e
> > > userspace(QEMU). So KVM should 'intercept' the ebreak and exit to QEM=
U.
> > > Bit EXC_BREAKPOINT should be cleared in this case.
> >
> > If EXC_BREAKPOINT is delegated by default then it is not consistent wit=
h
> > vcpu->guest_debug which is not enabled by default.
>
> To enable the guest_debug corresponding to NOT delegate the EXC_BREAKPOIN=
T.
> They are somehow 'opposite'.
>
> This 'kvm_guest_debug' feature is different from "debug in the guest".
> The later requires the delegation of EXC_BREAKPOINT.
> The former does not.

In which case your below code is totally misleading.

+       if (dbg->control & KVM_GUESTDBG_ENABLE) {
+               vcpu->guest_debug =3D dbg->control;
+               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GUEST_DEBUG;
+       } else {
+               vcpu->guest_debug =3D 0;
+               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT;
+       }

This should have been:

+       if (dbg->control & KVM_GUESTDBG_ENABLE) {
+               vcpu->guest_debug =3D dbg->control;
+               vcpu->arch.cfg.hedeleg &=3D ~BIT(EXC_BREAKPOINT);
+       } else {
+               vcpu->guest_debug =3D 0;
+               vcpu->arch.cfg.hedeleg |=3D BIT(EXC_BREAKPOINT);
+       }

>
> >
> > >
> > > >
> > > > > +#define KVM_HEDELEG_GUEST_DEBUG                ((_AC(1, UL) << E=
XC_INST_MISALIGNED) | \
> > > > > +                                        (_AC(1, UL) << EXC_SYSCA=
LL) | \
> > > > > +                                        (_AC(1, UL) << EXC_INST_=
PAGE_FAULT) | \
> > > > > +                                        (_AC(1, UL) << EXC_LOAD_=
PAGE_FAULT) | \
> > > > > +                                        (_AC(1, UL) << EXC_STORE=
_PAGE_FAULT))
> > > >
> > > > No need for KVM_HEDELEG_GUEST_DEBUG, see below.
> > > >
> > > > > +
> > > > > +#define KVM_HIDELEG_DEFAULT            ((_AC(1, UL) << IRQ_VS_SO=
FT) | \
> > > > > +                                        (_AC(1, UL) << IRQ_VS_TI=
MER) | \
> > > > > +                                        (_AC(1, UL) << IRQ_VS_EX=
T))
> > > > > +
> > > >
> > > > Same as above, use BIT(xyz) here.
> > > >
> > > > >  enum kvm_riscv_hfence_type {
> > > > >         KVM_RISCV_HFENCE_UNKNOWN =3D 0,
> > > > >         KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> > > > > @@ -169,6 +185,7 @@ struct kvm_vcpu_csr {
> > > > >  struct kvm_vcpu_config {
> > > > >         u64 henvcfg;
> > > > >         u64 hstateen0;
> > > > > +       unsigned long hedeleg;
> > > > >  };
> > > > >
> > > > >  struct kvm_vcpu_smstateen_csr {
> > > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/inclu=
de/uapi/asm/kvm.h
> > > > > index 7499e88a947c..39f4f4b9dede 100644
> > > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > > @@ -17,6 +17,7 @@
> > > > >
> > > > >  #define __KVM_HAVE_IRQ_LINE
> > > > >  #define __KVM_HAVE_READONLY_MEM
> > > > > +#define __KVM_HAVE_GUEST_DEBUG
> > > > >
> > > > >  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> > > > >
> > > > > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > > > > index 225a435d9c9a..bab2ec34cd87 100644
> > > > > --- a/arch/riscv/kvm/main.c
> > > > > +++ b/arch/riscv/kvm/main.c
> > > > > @@ -22,22 +22,8 @@ long kvm_arch_dev_ioctl(struct file *filp,
> > > > >
> > > > >  int kvm_arch_hardware_enable(void)
> > > > >  {
> > > > > -       unsigned long hideleg, hedeleg;
> > > > > -
> > > > > -       hedeleg =3D 0;
> > > > > -       hedeleg |=3D (1UL << EXC_INST_MISALIGNED);
> > > > > -       hedeleg |=3D (1UL << EXC_BREAKPOINT);
> > > > > -       hedeleg |=3D (1UL << EXC_SYSCALL);
> > > > > -       hedeleg |=3D (1UL << EXC_INST_PAGE_FAULT);
> > > > > -       hedeleg |=3D (1UL << EXC_LOAD_PAGE_FAULT);
> > > > > -       hedeleg |=3D (1UL << EXC_STORE_PAGE_FAULT);
> > > > > -       csr_write(CSR_HEDELEG, hedeleg);
> > > > > -
> > > > > -       hideleg =3D 0;
> > > > > -       hideleg |=3D (1UL << IRQ_VS_SOFT);
> > > > > -       hideleg |=3D (1UL << IRQ_VS_TIMER);
> > > > > -       hideleg |=3D (1UL << IRQ_VS_EXT);
> > > > > -       csr_write(CSR_HIDELEG, hideleg);
> > > > > +       csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
> > > > > +       csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
> > > > >
> > > > >         /* VS should access only the time counter directly. Every=
thing else should trap */
> > > > >         csr_write(CSR_HCOUNTEREN, 0x02);
> > > > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > > > index b5ca9f2e98ac..242076c2227f 100644
> > > > > --- a/arch/riscv/kvm/vcpu.c
> > > > > +++ b/arch/riscv/kvm/vcpu.c
> > > > > @@ -475,8 +475,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct k=
vm_vcpu *vcpu,
> > > > >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> > > > >                                         struct kvm_guest_debug *d=
bg)
> > > > >  {
> > > > > -       /* TODO; To be implemented later. */
> > > > > -       return -EINVAL;
> > > >
> > > > if (vcpu->arch.ran_atleast_once)
> > > >         return -EBUSY;
> > >
> > > If we enabled the guest_debug in QEMU side, then the KVM_SET_GUEST_DE=
BUG ioctl
> > > will come before the first KVM_RUN. This will always cause an ERROR.
> >
> > The check ensures that KVM user space can only enable/disable
> > guest debug before the VCPU is run. I don't see why this would
> > fail for QEMU.
>
> In the current implementation of GDB and QEMU, the userspace will enable/=
disable
> guest_debug frequently during the debugging (almost every step).
> The sequence should like:
>
> KVM_SET_GUEST_DEBUG enable
> KVM_RUN
> KVM_SET_GUEST_DEBUG disable
> KVM_SET_GUEST_DEBUG enable
> KVM_RUN
> KVM_SET_GUEST_DEBUG disable
> KVM_SET_GUEST_DEBUG enable
> KVM_RUN
> KVM_SET_GUEST_DEBUG disable
> ...

Fair enough, no need to check "ran_atleast_once"

>
> >
> > >
> > > >
> > > >
> > > > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > > > +               vcpu->guest_debug =3D dbg->control;
> > > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GUEST_DEBU=
G;
> > > > > +       } else {
> > > > > +               vcpu->guest_debug =3D 0;
> > > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > > > +       }
> > > >
> > > > Don't update vcpu->arch.cfg.hedeleg here since it should be only do=
ne
> > > > in kvm_riscv_vcpu_setup_config().
> > > >
> > > > > +
> > > > > +       return 0;
> > > > >  }
> > > > >
> > > > >  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> > > > > @@ -505,6 +512,9 @@ static void kvm_riscv_vcpu_setup_config(struc=
t kvm_vcpu *vcpu)
> > > > >                 if (riscv_isa_extension_available(isa, SMSTATEEN)=
)
> > > > >                         cfg->hstateen0 |=3D SMSTATEEN0_SSTATEEN0;
> > > > >         }
> > > > > +
> > > > > +       if (!vcpu->guest_debug)
> > > > > +               cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > >
> > > > This should be:
> > > >
> > > > cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > > if (vcpu->guest_debug)
> > > >         cfg->hedeleg |=3D BIT(EXC_BREAKPOINT);
> > >
> > > Like above, here the logic should be:
> > >
> > > cfg->hedeleg =3D KVM_HEDELEG_DEFAULT; // with BIT(EXC_BREAKPOINT)
> > > if (vcpu->guest_debug)
> > >         cfg->hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> > >
> > > Another approach is:
> > > initialize the cfg->hedeleg as KVM_HEDELEG_DEFAULT during kvm_arch_vc=
pu_create().
> > > Besides that, only update the cfg->hedeleg in kvm_arch_vcpu_ioctl_set=
_guest_debug().
> >
> > I disagree. We should handle hedeleg just like we handle henvcfg.
>
> OK, let's only update the cfg->hedeleg in kvm_riscv_vcpu_setup_config().
>
> >
> > >
> > > >
> > > > >  }
> > > > >
> > > > >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > > > > @@ -519,6 +529,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu=
, int cpu)
> > > > >         csr_write(CSR_VSEPC, csr->vsepc);
> > > > >         csr_write(CSR_VSCAUSE, csr->vscause);
> > > > >         csr_write(CSR_VSTVAL, csr->vstval);
> > > > > +       csr_write(CSR_HEDELEG, cfg->hedeleg);
> > > > >         csr_write(CSR_HVIP, csr->hvip);
> > > > >         csr_write(CSR_VSATP, csr->vsatp);
> > > > >         csr_write(CSR_HENVCFG, cfg->henvcfg);
> > > > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > > > index ce58bc48e5b8..7396b8654f45 100644
> > > > > --- a/arch/riscv/kvm/vm.c
> > > > > +++ b/arch/riscv/kvm/vm.c
> > > > > @@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *=
kvm, long ext)
> > > > >         case KVM_CAP_READONLY_MEM:
> > > > >         case KVM_CAP_MP_STATE:
> > > > >         case KVM_CAP_IMMEDIATE_EXIT:
> > > > > +       case KVM_CAP_SET_GUEST_DEBUG:
> > > > >                 r =3D 1;
> > > > >                 break;
> > > > >         case KVM_CAP_NR_VCPUS:
> > > > > --
> > > > > 2.17.1
> > > > >
> > > >
> > > > Regards,
> > > > Anup
> > >
> > > Thanks,
> > > Chao
> >
> > Regards,
> > Anup
>
> Thanks,
> Chao
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

Regards,
Anup

