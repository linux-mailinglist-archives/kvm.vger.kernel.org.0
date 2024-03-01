Return-Path: <kvm+bounces-10634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3AA86E069
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB47C1F229F5
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361126CBEE;
	Fri,  1 Mar 2024 11:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hHRbnQaE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275EB4438E
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292877; cv=none; b=fJxbQzS9p3hUhnbFOkI5Jm59vzTkfR0QvtBuFq/I7A0UShYxhMKp4FM7l65Qc2v2UbP5X8vuBER/Cpjhv+1eQ6wzKWsCvAxRHet+0nAKjBjOpAmTUpegqmJ3JTEjonZDWBlR1+yyMb1JHR3jlQhS/OQrd4s1+qjSoRpyQ93i73o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292877; c=relaxed/simple;
	bh=5Ee7aw4W5uij7uYVTvy1FNaeTPMezZcpFyrHgjv0298=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EzAJTBvXvDNXLqF2WmgkDEKojftsTH5PWnMGUyY216KonjPuVcYXTI+H18JoarzXcBnOJ9ZFGgur2qQudC16vwabpcMmqMBV04dSDy8wZhHLxDg7dCmmer/94jB4jpjEnzpGbpBtTko5TxG4y4tyMRjH/afIzrUA1hV0mwkh79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=hHRbnQaE; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-513353f92a9so192102e87.3
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 03:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709292873; x=1709897673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHO7YlX805z9S9zvrL55dNPpp2CF7V5MtEQQp8j+g/I=;
        b=hHRbnQaEo7gRr5MOsGwQa2CPoXoA8ytItt/BM2TWSDyxS6QxApqVUGoMxGBSQPRnbQ
         BQ1e4p2IjU5QOpJUsIqN88x+zX2JqysoiDZutT9u1gMUGgt3xDU4czTZbPDRtgNCj08N
         OpI0skwtR8DtMFDb1yU+vFkcTo1I4QV0xBVPn7lBnso7+jr2WUsdSQUsb4UMf7P2+0eO
         21P1Uiy9zURb7pc8GtWMB5r5ZqxcVflOrpTMgWhg26VPjKr3Wj7uzYRQ6TIGaaBmpd4s
         ZEpjvVeFo11Y55l8EEy0Qhlo/aXUUV3mvZvjbYN8eB+KvLv6kD4E1eNSiw0dK2qUKBwF
         h3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709292873; x=1709897673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RHO7YlX805z9S9zvrL55dNPpp2CF7V5MtEQQp8j+g/I=;
        b=Ol1FfT1wC/ZOwD5otmDtrD2blFvRRp9g8HZRi+aDkaYrddjRfTsfsiZpGzT9/5PU46
         dlgrw4ja1i7Tcly6fYWSMph1Wh5loMCvKxOcVhvk+pXulgtmIcu7k2ajg8VSJ+d/faIQ
         EsfTgq2BF4u0coSjqhrcUUXb0Z9UncMCwMDHgFIxjNDredr1Og6vqBcJtOPyHsYhHri4
         GguRgQXDR7s7t1GHKpUCDIxtwgM/u8pMR0DIyOogbbNhp3xT2crnPBYrlJtOUU8JNiJ3
         iNl9uwXJsGDJ5wQJv/JjNxzinBDdlt3x/ZIrF3Jm/BoI8L/TKndOutBafCtO2xF4LYIo
         0rBw==
X-Forwarded-Encrypted: i=1; AJvYcCWuAHj4wOThzMoPnMBmWo9BsAaBXw30zJsZo0KTV22wBfF2l1r2cNImavxyaiZmLzMxPmnMON5tnbcfe11F9x/6Cp7f
X-Gm-Message-State: AOJu0YwGIc/ioXfwq2m+NFwsOvfwGeZUpEKubVxNY8cHqWMlZy8hxKis
	gBHgP2InRULAOOsxHBxzQoIl1EZHKn6DcUb/rlyJs4R54tqQIBUvvK+FonxdLzjtuR8omGgaRql
	aHc5+N1XWJ3NrWZXB89lS88Luq3G2B/atP0YnNPt5oj6sXvgXgnM=
X-Google-Smtp-Source: AGHT+IGuVMGnXCLE69h6hEFY7sbvSfEpSYyg+FY3K/FlTbJC6PuQFIRbDBRLwblu19b/fhBO+jA/4qAXBIf0Cz04SzI=
X-Received: by 2002:a05:6512:1384:b0:512:e0a8:39d8 with SMTP id
 fc4-20020a056512138400b00512e0a839d8mr1583579lfb.43.1709292872790; Fri, 01
 Mar 2024 03:34:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301013545.10403-1-duchao@eswincomputing.com>
 <20240301013545.10403-2-duchao@eswincomputing.com> <CAAhSdy2+_+t4L8LHmYcJQZBGJHj6pyFm26_KwFBahFxz7eV1fQ@mail.gmail.com>
 <1f31ec16.1447.18df8b97f73.Coremail.duchao@eswincomputing.com>
 <CAAhSdy0x6bdm3hYk8jeRG_bF-vFXP8eOqYJ5GMY4Eb=bMNkaQw@mail.gmail.com>
 <698f58e.1490.18df8e9084f.Coremail.duchao@eswincomputing.com>
 <CAK9=C2Wz6ZHjsxPMkMnRBT+maE2qLuy+zi4wCRJ+1nkssCX5FA@mail.gmail.com>
 <1d6d446.14cc.18df9162000.Coremail.duchao@eswincomputing.com>
 <CAAhSdy37RzfXcCT5S=MYMqSbXDii=J+nHPL3nof-Oa_P6QrCqw@mail.gmail.com> <31123602.14fa.18df953753c.Coremail.duchao@eswincomputing.com>
In-Reply-To: <31123602.14fa.18df953753c.Coremail.duchao@eswincomputing.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 1 Mar 2024 17:04:21 +0530
Message-ID: <CAK9=C2VwEYswtpsfgD4bdZ95+m8vK7p0riA1RbiYvLjVJX=3rA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 2:53=E2=80=AFPM Chao Du <duchao@eswincomputing.com> =
wrote:
>
> On 2024-03-01 17:22, Anup Patel <anup@brainfault.org> wrote:
> >
> > On Fri, Mar 1, 2024 at 1:46=E2=80=AFPM Chao Du <duchao@eswincomputing.c=
om> wrote:
> > >
> > > Thanks Anup.
> > > Let me try to summarize the changes in next revision:
> > >
> > > 1. Use BIT().
> > > 2. In kvm_arch_vcpu_ioctl_set_guest_debug(), do below things:
> > >        if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > >                vcpu->guest_debug =3D dbg->control;
> > >        } else {
> > >                vcpu->guest_debug =3D 0;
> > >        }
> >
> > Since, kvm_arch_vcpu_ioctl_set_guest_debug() is called multiple times
> > at runtime, this should be:
> >
> >         if (dbg->control & KVM_GUESTDBG_ENABLE) {
> >                 vcpu->guest_debug =3D dbg->control;
> >                 vcpu->arch.cfg.hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> >         } else {
> >                 vcpu->guest_debug =3D 0;
> >                 vcpu->arch.cfg.hedeleg |=3D BIT(EXC_BREAKPOINT);
> >         }
> >
> > > 3. In kvm_riscv_vcpu_setup_config(), do below things:
> > >        cfg->hedeleg =3D KVM_HEDELEG_DEFAULT; // with BIT(EXC_BREAKPOI=
NT)
> > >        if (vcpu->guest_debug)
> > >                cfg->hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> > >
> > > Will prepare a PATCH v3 accordingly.
>
> I thought it over, maybe we should do this:
>
> - In kvm_arch_vcpu_ioctl_set_guest_debug():
>        if (dbg->control & KVM_GUESTDBG_ENABLE) {
>                vcpu->guest_debug =3D dbg->control;
>                vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT & (~BIT(EXC=
_BREAKPOINT));
>        } else {
>                vcpu->guest_debug =3D 0;
>                vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT;
>        }
> - In kvm_riscv_vcpu_setup_config():
>        if (!vcpu->guest_debug)
>                cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
>
> which is similar with my original changes, but clear the bit EXC_BREAKPOI=
NT explicitly.
>
> Could you please confirm ?

I suggest going with my previous suggestion.

Regards,
Anup

>
> >
> > Yes, please send v3.
> >
> > Thanks,
> > Anup
> >
> > > On 2024-03-01 16:11, Anup Patel <apatel@ventanamicro.com> wrote:
> > > >
> > > > On Fri, Mar 1, 2024 at 12:57=E2=80=AFPM Chao Du <duchao@eswincomput=
ing.com> wrote:
> > > > >
> > > > > On 2024-03-01 15:29, Anup Patel <anup@brainfault.org> wrote:
> > > > > >
> > > > > > On Fri, Mar 1, 2024 at 12:05=E2=80=AFPM Chao Du <duchao@eswinco=
mputing.com> wrote:
> > > > > > >
> > > > > > > On 2024-03-01 13:00, Anup Patel <anup@brainfault.org> wrote:
> > > > > > > >
> > > > > > > > On Fri, Mar 1, 2024 at 7:08=E2=80=AFAM Chao Du <duchao@eswi=
ncomputing.com> wrote:
> > > > > > > > >
> > > > > > > > > kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_G=
UEST_DEBUG is
> > > > > > > > > been checked.
> > > > > > > > >
> > > > > > > > > kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_d=
ebug flags
> > > > > > > > > from userspace accordingly. Route the breakpoint exceptio=
ns to HS mode
> > > > > > > > > if the VCPU is being debugged by userspace, by clearing t=
he
> > > > > > > > > corresponding bit in hedeleg. Write the actual CSR in
> > > > > > > > > kvm_arch_vcpu_load().
> > > > > > > > >
> > > > > > > > > Signed-off-by: Chao Du <duchao@eswincomputing.com>
> > > > > > > > > ---
> > > > > > > > >  arch/riscv/include/asm/kvm_host.h | 17 +++++++++++++++++
> > > > > > > > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > > > > > > > >  arch/riscv/kvm/main.c             | 18 ++---------------=
-
> > > > > > > > >  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
> > > > > > > > >  arch/riscv/kvm/vm.c               |  1 +
> > > > > > > > >  5 files changed, 34 insertions(+), 18 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/ris=
cv/include/asm/kvm_host.h
> > > > > > > > > index 484d04a92fa6..9ee3f03ba5d1 100644
> > > > > > > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > > > > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > > > > > > @@ -43,6 +43,22 @@
> > > > > > > > >         KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQU=
EST_NO_WAKEUP)
> > > > > > > > >  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
> > > > > > > > >
> > > > > > > > > +#define KVM_HEDELEG_DEFAULT            ((_AC(1, UL) << E=
XC_INST_MISALIGNED) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_BREAKPOINT) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_SYSCALL) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_INST_PAGE_FAULT) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_LOAD_PAGE_FAULT) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_STORE_PAGE_FAULT))
> > > > > > > >
> > > > > > > > Use BIT(xyz) here. For example: BIT(EXC_INST_MISALIGNED)
> > > > > > >
> > > > > > > Thanks, I will use BIT() instead in next revision.
> > > > > > >
> > > > > > > >
> > > > > > >
> > > > > > > > Also, BIT(EXC_BREAKPOINT) should not be part of KVM_HEDELEG=
_DEFAULT.
> > > > > > >
> > > > > > > I think the bit EXC_BREAKPOINT should be set by default, like=
 what you
> > > > > > > already did in kvm_arch_hardware_enable(). Then the VS could =
get the ebreak
> > > > > > > and handle it accordingly.
> > > > > > >
> > > > > > > If the guest_debug is enabled, ebreak instructions are insert=
ed by the
> > > > > > > userspace(QEMU). So KVM should 'intercept' the ebreak and exi=
t to QEMU.
> > > > > > > Bit EXC_BREAKPOINT should be cleared in this case.
> > > > > >
> > > > > > If EXC_BREAKPOINT is delegated by default then it is not consis=
tent with
> > > > > > vcpu->guest_debug which is not enabled by default.
> > > > >
> > > > > To enable the guest_debug corresponding to NOT delegate the EXC_B=
REAKPOINT.
> > > > > They are somehow 'opposite'.
> > > > >
> > > > > This 'kvm_guest_debug' feature is different from "debug in the gu=
est".
> > > > > The later requires the delegation of EXC_BREAKPOINT.
> > > > > The former does not.
> > > >
> > > > In which case your below code is totally misleading.
> > > >
> > > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > > +               vcpu->guest_debug =3D dbg->control;
> > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GUEST_DEBUG;
> > > > +       } else {
> > > > +               vcpu->guest_debug =3D 0;
> > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > > +       }
> > > >
> > > > This should have been:
> > > >
> > > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > > +               vcpu->guest_debug =3D dbg->control;
> > > > +               vcpu->arch.cfg.hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> > > > +       } else {
> > > > +               vcpu->guest_debug =3D 0;
> > > > +               vcpu->arch.cfg.hedeleg |=3D BIT(EXC_BREAKPOINT);
> > > > +       }
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > > +#define KVM_HEDELEG_GUEST_DEBUG                ((_AC(1, =
UL) << EXC_INST_MISALIGNED) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_SYSCALL) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_INST_PAGE_FAULT) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_LOAD_PAGE_FAULT) | \
> > > > > > > > > +                                        (_AC(1, UL) << E=
XC_STORE_PAGE_FAULT))
> > > > > > > >
> > > > > > > > No need for KVM_HEDELEG_GUEST_DEBUG, see below.
> > > > > > > >
> > > > > > > > > +
> > > > > > > > > +#define KVM_HIDELEG_DEFAULT            ((_AC(1, UL) << I=
RQ_VS_SOFT) | \
> > > > > > > > > +                                        (_AC(1, UL) << I=
RQ_VS_TIMER) | \
> > > > > > > > > +                                        (_AC(1, UL) << I=
RQ_VS_EXT))
> > > > > > > > > +
> > > > > > > >
> > > > > > > > Same as above, use BIT(xyz) here.
> > > > > > > >
> > > > > > > > >  enum kvm_riscv_hfence_type {
> > > > > > > > >         KVM_RISCV_HFENCE_UNKNOWN =3D 0,
> > > > > > > > >         KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> > > > > > > > > @@ -169,6 +185,7 @@ struct kvm_vcpu_csr {
> > > > > > > > >  struct kvm_vcpu_config {
> > > > > > > > >         u64 henvcfg;
> > > > > > > > >         u64 hstateen0;
> > > > > > > > > +       unsigned long hedeleg;
> > > > > > > > >  };
> > > > > > > > >
> > > > > > > > >  struct kvm_vcpu_smstateen_csr {
> > > > > > > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/ris=
cv/include/uapi/asm/kvm.h
> > > > > > > > > index 7499e88a947c..39f4f4b9dede 100644
> > > > > > > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > > > > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > > > > > > @@ -17,6 +17,7 @@
> > > > > > > > >
> > > > > > > > >  #define __KVM_HAVE_IRQ_LINE
> > > > > > > > >  #define __KVM_HAVE_READONLY_MEM
> > > > > > > > > +#define __KVM_HAVE_GUEST_DEBUG
> > > > > > > > >
> > > > > > > > >  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> > > > > > > > >
> > > > > > > > > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.=
c
> > > > > > > > > index 225a435d9c9a..bab2ec34cd87 100644
> > > > > > > > > --- a/arch/riscv/kvm/main.c
> > > > > > > > > +++ b/arch/riscv/kvm/main.c
> > > > > > > > > @@ -22,22 +22,8 @@ long kvm_arch_dev_ioctl(struct file *f=
ilp,
> > > > > > > > >
> > > > > > > > >  int kvm_arch_hardware_enable(void)
> > > > > > > > >  {
> > > > > > > > > -       unsigned long hideleg, hedeleg;
> > > > > > > > > -
> > > > > > > > > -       hedeleg =3D 0;
> > > > > > > > > -       hedeleg |=3D (1UL << EXC_INST_MISALIGNED);
> > > > > > > > > -       hedeleg |=3D (1UL << EXC_BREAKPOINT);
> > > > > > > > > -       hedeleg |=3D (1UL << EXC_SYSCALL);
> > > > > > > > > -       hedeleg |=3D (1UL << EXC_INST_PAGE_FAULT);
> > > > > > > > > -       hedeleg |=3D (1UL << EXC_LOAD_PAGE_FAULT);
> > > > > > > > > -       hedeleg |=3D (1UL << EXC_STORE_PAGE_FAULT);
> > > > > > > > > -       csr_write(CSR_HEDELEG, hedeleg);
> > > > > > > > > -
> > > > > > > > > -       hideleg =3D 0;
> > > > > > > > > -       hideleg |=3D (1UL << IRQ_VS_SOFT);
> > > > > > > > > -       hideleg |=3D (1UL << IRQ_VS_TIMER);
> > > > > > > > > -       hideleg |=3D (1UL << IRQ_VS_EXT);
> > > > > > > > > -       csr_write(CSR_HIDELEG, hideleg);
> > > > > > > > > +       csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
> > > > > > > > > +       csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
> > > > > > > > >
> > > > > > > > >         /* VS should access only the time counter directl=
y. Everything else should trap */
> > > > > > > > >         csr_write(CSR_HCOUNTEREN, 0x02);
> > > > > > > > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.=
c
> > > > > > > > > index b5ca9f2e98ac..242076c2227f 100644
> > > > > > > > > --- a/arch/riscv/kvm/vcpu.c
> > > > > > > > > +++ b/arch/riscv/kvm/vcpu.c
> > > > > > > > > @@ -475,8 +475,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(=
struct kvm_vcpu *vcpu,
> > > > > > > > >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu =
*vcpu,
> > > > > > > > >                                         struct kvm_guest_=
debug *dbg)
> > > > > > > > >  {
> > > > > > > > > -       /* TODO; To be implemented later. */
> > > > > > > > > -       return -EINVAL;
> > > > > > > >
> > > > > > > > if (vcpu->arch.ran_atleast_once)
> > > > > > > >         return -EBUSY;
> > > > > > >
> > > > > > > If we enabled the guest_debug in QEMU side, then the KVM_SET_=
GUEST_DEBUG ioctl
> > > > > > > will come before the first KVM_RUN. This will always cause an=
 ERROR.
> > > > > >
> > > > > > The check ensures that KVM user space can only enable/disable
> > > > > > guest debug before the VCPU is run. I don't see why this would
> > > > > > fail for QEMU.
> > > > >
> > > > > In the current implementation of GDB and QEMU, the userspace will=
 enable/disable
> > > > > guest_debug frequently during the debugging (almost every step).
> > > > > The sequence should like:
> > > > >
> > > > > KVM_SET_GUEST_DEBUG enable
> > > > > KVM_RUN
> > > > > KVM_SET_GUEST_DEBUG disable
> > > > > KVM_SET_GUEST_DEBUG enable
> > > > > KVM_RUN
> > > > > KVM_SET_GUEST_DEBUG disable
> > > > > KVM_SET_GUEST_DEBUG enable
> > > > > KVM_RUN
> > > > > KVM_SET_GUEST_DEBUG disable
> > > > > ...
> > > >
> > > > Fair enough, no need to check "ran_atleast_once"
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > > > > > > > +               vcpu->guest_debug =3D dbg->control;
> > > > > > > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GU=
EST_DEBUG;
> > > > > > > > > +       } else {
> > > > > > > > > +               vcpu->guest_debug =3D 0;
> > > > > > > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DE=
FAULT;
> > > > > > > > > +       }
> > > > > > > >
> > > > > > > > Don't update vcpu->arch.cfg.hedeleg here since it should be=
 only done
> > > > > > > > in kvm_riscv_vcpu_setup_config().
> > > > > > > >
> > > > > > > > > +
> > > > > > > > > +       return 0;
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > >  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu =
*vcpu)
> > > > > > > > > @@ -505,6 +512,9 @@ static void kvm_riscv_vcpu_setup_conf=
ig(struct kvm_vcpu *vcpu)
> > > > > > > > >                 if (riscv_isa_extension_available(isa, SM=
STATEEN))
> > > > > > > > >                         cfg->hstateen0 |=3D SMSTATEEN0_SS=
TATEEN0;
> > > > > > > > >         }
> > > > > > > > > +
> > > > > > > > > +       if (!vcpu->guest_debug)
> > > > > > > > > +               cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > > > > > >
> > > > > > > > This should be:
> > > > > > > >
> > > > > > > > cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > > > > > > if (vcpu->guest_debug)
> > > > > > > >         cfg->hedeleg |=3D BIT(EXC_BREAKPOINT);
> > > > > > >
> > > > > > > Like above, here the logic should be:
> > > > > > >
> > > > > > > cfg->hedeleg =3D KVM_HEDELEG_DEFAULT; // with BIT(EXC_BREAKPO=
INT)
> > > > > > > if (vcpu->guest_debug)
> > > > > > >         cfg->hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> > > > > > >
> > > > > > > Another approach is:
> > > > > > > initialize the cfg->hedeleg as KVM_HEDELEG_DEFAULT during kvm=
_arch_vcpu_create().
> > > > > > > Besides that, only update the cfg->hedeleg in kvm_arch_vcpu_i=
octl_set_guest_debug().
> > > > > >
> > > > > > I disagree. We should handle hedeleg just like we handle henvcf=
g.
> > > > >
> > > > > OK, let's only update the cfg->hedeleg in kvm_riscv_vcpu_setup_co=
nfig().
> > > > >
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > > > > > > > > @@ -519,6 +529,7 @@ void kvm_arch_vcpu_load(struct kvm_vc=
pu *vcpu, int cpu)
> > > > > > > > >         csr_write(CSR_VSEPC, csr->vsepc);
> > > > > > > > >         csr_write(CSR_VSCAUSE, csr->vscause);
> > > > > > > > >         csr_write(CSR_VSTVAL, csr->vstval);
> > > > > > > > > +       csr_write(CSR_HEDELEG, cfg->hedeleg);
> > > > > > > > >         csr_write(CSR_HVIP, csr->hvip);
> > > > > > > > >         csr_write(CSR_VSATP, csr->vsatp);
> > > > > > > > >         csr_write(CSR_HENVCFG, cfg->henvcfg);
> > > > > > > > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > > > > > > > index ce58bc48e5b8..7396b8654f45 100644
> > > > > > > > > --- a/arch/riscv/kvm/vm.c
> > > > > > > > > +++ b/arch/riscv/kvm/vm.c
> > > > > > > > > @@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(stru=
ct kvm *kvm, long ext)
> > > > > > > > >         case KVM_CAP_READONLY_MEM:
> > > > > > > > >         case KVM_CAP_MP_STATE:
> > > > > > > > >         case KVM_CAP_IMMEDIATE_EXIT:
> > > > > > > > > +       case KVM_CAP_SET_GUEST_DEBUG:
> > > > > > > > >                 r =3D 1;
> > > > > > > > >                 break;
> > > > > > > > >         case KVM_CAP_NR_VCPUS:
> > > > > > > > > --
> > > > > > > > > 2.17.1
> > > > > > > > >
> > > > > > > >
> > > > > > > > Regards,
> > > > > > > > Anup
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Chao
> > > > > >
> > > > > > Regards,
> > > > > > Anup
> > > > >
> > > > > Thanks,
> > > > > Chao
> > > > > --
> > > > > kvm-riscv mailing list
> > > > > kvm-riscv@lists.infradead.org
> > > > > http://lists.infradead.org/mailman/listinfo/kvm-riscv
> > > >
> > > > Regards,
> > > > Anup

