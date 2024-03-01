Return-Path: <kvm+bounces-10605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C7286DDA7
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B2E1B25262
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7366469E18;
	Fri,  1 Mar 2024 08:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="tMWxlL2M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF374596C
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 08:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709283156; cv=none; b=WFBHet2Fomu75bMDdGW1fQtMMbBuX0aY5s7SD2C9xi+/VHPdsjieicIZo3gL0AImz8ccRd9Sbqd6ubE84ra8XTj/tvoxCEWO1sL46PXBVBcn7Rvx5f9wpupl3Kyzm+q3N4tU6xs+/vS2UN4BSsQQqMDbQ6L/Ftn4C+iKew7XXyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709283156; c=relaxed/simple;
	bh=G0pNEV2PHYGNXLJmp0lI8c0tbZk6gn5HWd0EvA1/b8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxSdIcKV/Mk7eLWUCCkGvjxh9B94ztyVmmvpIbYdkosxg6UwVdI8AArGavXwM4UEpAKswFt4b3H1Qldl8G0Y8I2V/LWTxXIGtZaz9YgvsN7zLjl/G+5yc0AuBEiG1wrIitw12kD2igMeTfv0PN3BxxJuk0CiJ4GotT4t5o2LbcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=tMWxlL2M; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-365c773ae6cso6702835ab.2
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 00:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709283153; x=1709887953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XsTbMjceJYEZyIuotoEHLyWYmD+zv+CeAn7d1dHgFk=;
        b=tMWxlL2MSFQWXEihfbHucxH3GKUCZsip5Bg+pvNcnrHMbbAplyk7VeLOCC+HCf8HgU
         qoB/v6GVhi2cLju5xjdFqXUmcNxfGoyjVMwhQ2RCQ+RrgDu+oCrnyTAULp6Fa7S/qkSB
         loiB6EkRPWuoqOMg0ZeDQ9kf9fowJxVR6bOwZiz3s/9Mf27JGh9RTmHePdiF3e18aQVh
         maM/fZI2eFqCbELLA7Ab0ybV5yKqUxmiP3M9rN1GUt3igE68ZD67RD0r8V3u+o7M+3/u
         QakBQJsOTJrxrPwI0ZXEowQGTrrQFA0qcDUplgnYPnVZe45BoCYTXbhX+BHYnvkUwwic
         kmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709283153; x=1709887953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XsTbMjceJYEZyIuotoEHLyWYmD+zv+CeAn7d1dHgFk=;
        b=OEEEpZIHcvsLiyFqfquwBT0T6wCAAD7J8Pqv0i8YtVnxTurqkGlYnXHOqEajiR/k2Q
         BVRkvkpMpmZm58z9XT76WKVuG1wOjZxVT5ZboR1hxJzR2t7oWSaEfg+L6JO0eT0v2ENc
         Tv/D65KII9JTnCVRx0ZhaLuH8SjG1XwQoNuCilLH9v0bSKoX9fMPV7XPELHJThEyhN+U
         U8/VGLUPX1yxlkbb8F/UUnmWay29XlTjnqicZW0Nng8IOHnBhbw6mUthwQlHYWCRnMfK
         uDe9uWOKbf3W281c4/yLA/1ah8APbU8EbL2Sr0yixCMdFV5qfUnpk8yM/Ux11WC2pNKz
         jDnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwltn0Xtpco0EmOH6svjQEGhKp1kK11/EltfOtisnYgbncoDUU4HmXdJCyoWInteQVKnG7BU89fNiqgKQegBDz0PF6
X-Gm-Message-State: AOJu0Yw7QFT8zeGNlu5Uo/HJ7yWWM0koMlqVgFvC2G0K5xYaP9uIkUGS
	FGlHrPi0yFOsYRE+mCwt7URNMR0h9dg1WY9/Oqbv/F/uiDUPTkA97i4iGVK9bl9ofOyj8GInS7v
	31IXXKwFZgyXag/mSzRe97Ov9Qktmgrsdm/mORg==
X-Google-Smtp-Source: AGHT+IG4mfMuVeudjDZ3oiRSQPj7HucHLicVMFtLeJEKG2+Lmnxo7iiT8SoPXcL7Ur20W1iDGGp6TweJQQTOxMEL9i8=
X-Received: by 2002:a05:6e02:1aa4:b0:364:279c:4a08 with SMTP id
 l4-20020a056e021aa400b00364279c4a08mr1169836ilv.23.1709283153589; Fri, 01 Mar
 2024 00:52:33 -0800 (PST)
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
 <CAK9=C2Wz6ZHjsxPMkMnRBT+maE2qLuy+zi4wCRJ+1nkssCX5FA@mail.gmail.com> <1d6d446.14cc.18df9162000.Coremail.duchao@eswincomputing.com>
In-Reply-To: <1d6d446.14cc.18df9162000.Coremail.duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 1 Mar 2024 14:22:22 +0530
Message-ID: <CAAhSdy37RzfXcCT5S=MYMqSbXDii=J+nHPL3nof-Oa_P6QrCqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: Anup Patel <apatel@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, atishp@atishpatra.org, pbonzini@redhat.com, 
	shuah@kernel.org, dbarboza@ventanamicro.com, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 1:46=E2=80=AFPM Chao Du <duchao@eswincomputing.com> =
wrote:
>
> Thanks Anup.
> Let me try to summarize the changes in next revision:
>
> 1. Use BIT().
> 2. In kvm_arch_vcpu_ioctl_set_guest_debug(), do below things:
>        if (dbg->control & KVM_GUESTDBG_ENABLE) {
>                vcpu->guest_debug =3D dbg->control;
>        } else {
>                vcpu->guest_debug =3D 0;
>        }

Since, kvm_arch_vcpu_ioctl_set_guest_debug() is called multiple times
at runtime, this should be:

        if (dbg->control & KVM_GUESTDBG_ENABLE) {
                vcpu->guest_debug =3D dbg->control;
                vcpu->arch.cfg.hedeleg &=3D ~BIT(EXC_BREAKPOINT);
        } else {
                vcpu->guest_debug =3D 0;
                vcpu->arch.cfg.hedeleg |=3D BIT(EXC_BREAKPOINT);
        }

> 3. In kvm_riscv_vcpu_setup_config(), do below things:
>        cfg->hedeleg =3D KVM_HEDELEG_DEFAULT; // with BIT(EXC_BREAKPOINT)
>        if (vcpu->guest_debug)
>                cfg->hedeleg &=3D ~BIT(EXC_BREAKPOINT);
>
> Will prepare a PATCH v3 accordingly.

Yes, please send v3.

Thanks,
Anup

> On 2024-03-01 16:11, Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > On Fri, Mar 1, 2024 at 12:57=E2=80=AFPM Chao Du <duchao@eswincomputing.=
com> wrote:
> > >
> > > On 2024-03-01 15:29, Anup Patel <anup@brainfault.org> wrote:
> > > >
> > > > On Fri, Mar 1, 2024 at 12:05=E2=80=AFPM Chao Du <duchao@eswincomput=
ing.com> wrote:
> > > > >
> > > > > On 2024-03-01 13:00, Anup Patel <anup@brainfault.org> wrote:
> > > > > >
> > > > > > On Fri, Mar 1, 2024 at 7:08=E2=80=AFAM Chao Du <duchao@eswincom=
puting.com> wrote:
> > > > > > >
> > > > > > > kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST=
_DEBUG is
> > > > > > > been checked.
> > > > > > >
> > > > > > > kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug=
 flags
> > > > > > > from userspace accordingly. Route the breakpoint exceptions t=
o HS mode
> > > > > > > if the VCPU is being debugged by userspace, by clearing the
> > > > > > > corresponding bit in hedeleg. Write the actual CSR in
> > > > > > > kvm_arch_vcpu_load().
> > > > > > >
> > > > > > > Signed-off-by: Chao Du <duchao@eswincomputing.com>
> > > > > > > ---
> > > > > > >  arch/riscv/include/asm/kvm_host.h | 17 +++++++++++++++++
> > > > > > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > > > > > >  arch/riscv/kvm/main.c             | 18 ++----------------
> > > > > > >  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
> > > > > > >  arch/riscv/kvm/vm.c               |  1 +
> > > > > > >  5 files changed, 34 insertions(+), 18 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/i=
nclude/asm/kvm_host.h
> > > > > > > index 484d04a92fa6..9ee3f03ba5d1 100644
> > > > > > > --- a/arch/riscv/include/asm/kvm_host.h
> > > > > > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > > > > > @@ -43,6 +43,22 @@
> > > > > > >         KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_=
NO_WAKEUP)
> > > > > > >  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
> > > > > > >
> > > > > > > +#define KVM_HEDELEG_DEFAULT            ((_AC(1, UL) << EXC_I=
NST_MISALIGNED) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_B=
REAKPOINT) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_S=
YSCALL) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_I=
NST_PAGE_FAULT) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_L=
OAD_PAGE_FAULT) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_S=
TORE_PAGE_FAULT))
> > > > > >
> > > > > > Use BIT(xyz) here. For example: BIT(EXC_INST_MISALIGNED)
> > > > >
> > > > > Thanks, I will use BIT() instead in next revision.
> > > > >
> > > > > >
> > > > >
> > > > > > Also, BIT(EXC_BREAKPOINT) should not be part of KVM_HEDELEG_DEF=
AULT.
> > > > >
> > > > > I think the bit EXC_BREAKPOINT should be set by default, like wha=
t you
> > > > > already did in kvm_arch_hardware_enable(). Then the VS could get =
the ebreak
> > > > > and handle it accordingly.
> > > > >
> > > > > If the guest_debug is enabled, ebreak instructions are inserted b=
y the
> > > > > userspace(QEMU). So KVM should 'intercept' the ebreak and exit to=
 QEMU.
> > > > > Bit EXC_BREAKPOINT should be cleared in this case.
> > > >
> > > > If EXC_BREAKPOINT is delegated by default then it is not consistent=
 with
> > > > vcpu->guest_debug which is not enabled by default.
> > >
> > > To enable the guest_debug corresponding to NOT delegate the EXC_BREAK=
POINT.
> > > They are somehow 'opposite'.
> > >
> > > This 'kvm_guest_debug' feature is different from "debug in the guest"=
.
> > > The later requires the delegation of EXC_BREAKPOINT.
> > > The former does not.
> >
> > In which case your below code is totally misleading.
> >
> > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > +               vcpu->guest_debug =3D dbg->control;
> > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GUEST_DEBUG;
> > +       } else {
> > +               vcpu->guest_debug =3D 0;
> > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT;
> > +       }
> >
> > This should have been:
> >
> > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > +               vcpu->guest_debug =3D dbg->control;
> > +               vcpu->arch.cfg.hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> > +       } else {
> > +               vcpu->guest_debug =3D 0;
> > +               vcpu->arch.cfg.hedeleg |=3D BIT(EXC_BREAKPOINT);
> > +       }
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > > +#define KVM_HEDELEG_GUEST_DEBUG                ((_AC(1, UL) =
<< EXC_INST_MISALIGNED) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_S=
YSCALL) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_I=
NST_PAGE_FAULT) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_L=
OAD_PAGE_FAULT) | \
> > > > > > > +                                        (_AC(1, UL) << EXC_S=
TORE_PAGE_FAULT))
> > > > > >
> > > > > > No need for KVM_HEDELEG_GUEST_DEBUG, see below.
> > > > > >
> > > > > > > +
> > > > > > > +#define KVM_HIDELEG_DEFAULT            ((_AC(1, UL) << IRQ_V=
S_SOFT) | \
> > > > > > > +                                        (_AC(1, UL) << IRQ_V=
S_TIMER) | \
> > > > > > > +                                        (_AC(1, UL) << IRQ_V=
S_EXT))
> > > > > > > +
> > > > > >
> > > > > > Same as above, use BIT(xyz) here.
> > > > > >
> > > > > > >  enum kvm_riscv_hfence_type {
> > > > > > >         KVM_RISCV_HFENCE_UNKNOWN =3D 0,
> > > > > > >         KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> > > > > > > @@ -169,6 +185,7 @@ struct kvm_vcpu_csr {
> > > > > > >  struct kvm_vcpu_config {
> > > > > > >         u64 henvcfg;
> > > > > > >         u64 hstateen0;
> > > > > > > +       unsigned long hedeleg;
> > > > > > >  };
> > > > > > >
> > > > > > >  struct kvm_vcpu_smstateen_csr {
> > > > > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/i=
nclude/uapi/asm/kvm.h
> > > > > > > index 7499e88a947c..39f4f4b9dede 100644
> > > > > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > > > > @@ -17,6 +17,7 @@
> > > > > > >
> > > > > > >  #define __KVM_HAVE_IRQ_LINE
> > > > > > >  #define __KVM_HAVE_READONLY_MEM
> > > > > > > +#define __KVM_HAVE_GUEST_DEBUG
> > > > > > >
> > > > > > >  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> > > > > > >
> > > > > > > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > > > > > > index 225a435d9c9a..bab2ec34cd87 100644
> > > > > > > --- a/arch/riscv/kvm/main.c
> > > > > > > +++ b/arch/riscv/kvm/main.c
> > > > > > > @@ -22,22 +22,8 @@ long kvm_arch_dev_ioctl(struct file *filp,
> > > > > > >
> > > > > > >  int kvm_arch_hardware_enable(void)
> > > > > > >  {
> > > > > > > -       unsigned long hideleg, hedeleg;
> > > > > > > -
> > > > > > > -       hedeleg =3D 0;
> > > > > > > -       hedeleg |=3D (1UL << EXC_INST_MISALIGNED);
> > > > > > > -       hedeleg |=3D (1UL << EXC_BREAKPOINT);
> > > > > > > -       hedeleg |=3D (1UL << EXC_SYSCALL);
> > > > > > > -       hedeleg |=3D (1UL << EXC_INST_PAGE_FAULT);
> > > > > > > -       hedeleg |=3D (1UL << EXC_LOAD_PAGE_FAULT);
> > > > > > > -       hedeleg |=3D (1UL << EXC_STORE_PAGE_FAULT);
> > > > > > > -       csr_write(CSR_HEDELEG, hedeleg);
> > > > > > > -
> > > > > > > -       hideleg =3D 0;
> > > > > > > -       hideleg |=3D (1UL << IRQ_VS_SOFT);
> > > > > > > -       hideleg |=3D (1UL << IRQ_VS_TIMER);
> > > > > > > -       hideleg |=3D (1UL << IRQ_VS_EXT);
> > > > > > > -       csr_write(CSR_HIDELEG, hideleg);
> > > > > > > +       csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
> > > > > > > +       csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
> > > > > > >
> > > > > > >         /* VS should access only the time counter directly. E=
verything else should trap */
> > > > > > >         csr_write(CSR_HCOUNTEREN, 0x02);
> > > > > > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > > > > > index b5ca9f2e98ac..242076c2227f 100644
> > > > > > > --- a/arch/riscv/kvm/vcpu.c
> > > > > > > +++ b/arch/riscv/kvm/vcpu.c
> > > > > > > @@ -475,8 +475,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru=
ct kvm_vcpu *vcpu,
> > > > > > >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcp=
u,
> > > > > > >                                         struct kvm_guest_debu=
g *dbg)
> > > > > > >  {
> > > > > > > -       /* TODO; To be implemented later. */
> > > > > > > -       return -EINVAL;
> > > > > >
> > > > > > if (vcpu->arch.ran_atleast_once)
> > > > > >         return -EBUSY;
> > > > >
> > > > > If we enabled the guest_debug in QEMU side, then the KVM_SET_GUES=
T_DEBUG ioctl
> > > > > will come before the first KVM_RUN. This will always cause an ERR=
OR.
> > > >
> > > > The check ensures that KVM user space can only enable/disable
> > > > guest debug before the VCPU is run. I don't see why this would
> > > > fail for QEMU.
> > >
> > > In the current implementation of GDB and QEMU, the userspace will ena=
ble/disable
> > > guest_debug frequently during the debugging (almost every step).
> > > The sequence should like:
> > >
> > > KVM_SET_GUEST_DEBUG enable
> > > KVM_RUN
> > > KVM_SET_GUEST_DEBUG disable
> > > KVM_SET_GUEST_DEBUG enable
> > > KVM_RUN
> > > KVM_SET_GUEST_DEBUG disable
> > > KVM_SET_GUEST_DEBUG enable
> > > KVM_RUN
> > > KVM_SET_GUEST_DEBUG disable
> > > ...
> >
> > Fair enough, no need to check "ran_atleast_once"
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > >
> > > > > > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > > > > > +               vcpu->guest_debug =3D dbg->control;
> > > > > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GUEST_=
DEBUG;
> > > > > > > +       } else {
> > > > > > > +               vcpu->guest_debug =3D 0;
> > > > > > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAUL=
T;
> > > > > > > +       }
> > > > > >
> > > > > > Don't update vcpu->arch.cfg.hedeleg here since it should be onl=
y done
> > > > > > in kvm_riscv_vcpu_setup_config().
> > > > > >
> > > > > > > +
> > > > > > > +       return 0;
> > > > > > >  }
> > > > > > >
> > > > > > >  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcp=
u)
> > > > > > > @@ -505,6 +512,9 @@ static void kvm_riscv_vcpu_setup_config(s=
truct kvm_vcpu *vcpu)
> > > > > > >                 if (riscv_isa_extension_available(isa, SMSTAT=
EEN))
> > > > > > >                         cfg->hstateen0 |=3D SMSTATEEN0_SSTATE=
EN0;
> > > > > > >         }
> > > > > > > +
> > > > > > > +       if (!vcpu->guest_debug)
> > > > > > > +               cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > > > >
> > > > > > This should be:
> > > > > >
> > > > > > cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > > > > if (vcpu->guest_debug)
> > > > > >         cfg->hedeleg |=3D BIT(EXC_BREAKPOINT);
> > > > >
> > > > > Like above, here the logic should be:
> > > > >
> > > > > cfg->hedeleg =3D KVM_HEDELEG_DEFAULT; // with BIT(EXC_BREAKPOINT)
> > > > > if (vcpu->guest_debug)
> > > > >         cfg->hedeleg &=3D ~BIT(EXC_BREAKPOINT);
> > > > >
> > > > > Another approach is:
> > > > > initialize the cfg->hedeleg as KVM_HEDELEG_DEFAULT during kvm_arc=
h_vcpu_create().
> > > > > Besides that, only update the cfg->hedeleg in kvm_arch_vcpu_ioctl=
_set_guest_debug().
> > > >
> > > > I disagree. We should handle hedeleg just like we handle henvcfg.
> > >
> > > OK, let's only update the cfg->hedeleg in kvm_riscv_vcpu_setup_config=
().
> > >
> > > >
> > > > >
> > > > > >
> > > > > > >  }
> > > > > > >
> > > > > > >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > > > > > > @@ -519,6 +529,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *=
vcpu, int cpu)
> > > > > > >         csr_write(CSR_VSEPC, csr->vsepc);
> > > > > > >         csr_write(CSR_VSCAUSE, csr->vscause);
> > > > > > >         csr_write(CSR_VSTVAL, csr->vstval);
> > > > > > > +       csr_write(CSR_HEDELEG, cfg->hedeleg);
> > > > > > >         csr_write(CSR_HVIP, csr->hvip);
> > > > > > >         csr_write(CSR_VSATP, csr->vsatp);
> > > > > > >         csr_write(CSR_HENVCFG, cfg->henvcfg);
> > > > > > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > > > > > index ce58bc48e5b8..7396b8654f45 100644
> > > > > > > --- a/arch/riscv/kvm/vm.c
> > > > > > > +++ b/arch/riscv/kvm/vm.c
> > > > > > > @@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct k=
vm *kvm, long ext)
> > > > > > >         case KVM_CAP_READONLY_MEM:
> > > > > > >         case KVM_CAP_MP_STATE:
> > > > > > >         case KVM_CAP_IMMEDIATE_EXIT:
> > > > > > > +       case KVM_CAP_SET_GUEST_DEBUG:
> > > > > > >                 r =3D 1;
> > > > > > >                 break;
> > > > > > >         case KVM_CAP_NR_VCPUS:
> > > > > > > --
> > > > > > > 2.17.1
> > > > > > >
> > > > > >
> > > > > > Regards,
> > > > > > Anup
> > > > >
> > > > > Thanks,
> > > > > Chao
> > > >
> > > > Regards,
> > > > Anup
> > >
> > > Thanks,
> > > Chao
> > > --
> > > kvm-riscv mailing list
> > > kvm-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/kvm-riscv
> >
> > Regards,
> > Anup

