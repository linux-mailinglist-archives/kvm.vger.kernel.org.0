Return-Path: <kvm+bounces-10588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97BD886DBC1
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 273161F26354
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 06:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6F16930F;
	Fri,  1 Mar 2024 06:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="H26VG/6v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C0692FD
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 06:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709276379; cv=none; b=VOVljDF3iKjG6P7YWAHJUlkHSJIKPHYRgfsNG3X+F1A6iFHvvbP+fiuUB1zaotdupMDpQVD0RvQDSCEHDkWT38Ohb6aHhWQk0AMsiMZ4f84ku6xyHGfsQaMx0x5Nxpdz6E2zebgn2uTiHvMBM+0HBKwecBnIZp0O4Dipj5X0aAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709276379; c=relaxed/simple;
	bh=hiH56gFdcEepUnwBW4pFEphS4L51LulJUFkJ+bXJMqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G704Mmj02Ff1xBGTOkz6P/zBMak8MCEKYl3haQA4UiHSv8n2Fo83b6T09DXvaVEwJxQF35vQ5DdTbONaMA6VGFwcToPv9/Zp4qEU9f6zqWsdl3IfSdNNfSm6ZYp3yRbkLLGmfJygJfL5T0XhN21kFopgTy/nflALYtZeCj2+0KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=H26VG/6v; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-365138d9635so6395855ab.3
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 22:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709276376; x=1709881176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RdAudMG1/mp3Q7D9BHGD7XgILqwKFGJPtasWKY7ej5I=;
        b=H26VG/6vy85twvfrtEKTFrzCgbkBiuiNlXe2aElLz9lg+S44EY3OK1Jh6TrPRKW5r+
         ENQLW7/MsBGek7isyJGGJMMwA1J56f9/4HaOT1NlR6u0eqBrHswucVKI/NNHsqpolZEr
         CRcCsDHtrn2JRaOeOF7k4jkoAoYXtvnCdCTlYASKoWriVrKHFlPkAsK5vPxbG77CMQkw
         tRTCEFonmutlbvs3mf/gceh0/o3n4cNTRd3tD67CPG9pzYB1Cv2TQAGbxAdCy4LzXqXv
         szOFweVhoe/gfBOI91CvuF+E7Gh/yRBbq54LHGqYXWRIfm/0pf3GD02K2W+8CJ0fO/m/
         596Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709276376; x=1709881176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdAudMG1/mp3Q7D9BHGD7XgILqwKFGJPtasWKY7ej5I=;
        b=l85V82/7eCLsKUlXCEVjFfZHxDHtUvn0shYtBMPGZf/4e2nf9poS+v1U0jlbJLGLl0
         QSt1jf/TQ61efnM5gaC9d0mXyYi/MF6CIyhSeht6TgTQfnlEZBlQShcYwPsHlnS+jaIR
         IKJpA7g1tS5Lf1KzIaLcJrgyVFMr2sD7MeBiCOHKh7CPMUvLUk6kONqXPUuGnK4LgYnV
         hZviY2mbM5f+i/iHKG1dYIXurp0EAX2Kif9qChGfFkKcnSF6lWJeocUfipcofwAu1Vcr
         dktbtDV0IiX1GUYREJx/RjMCWD0fXuxIXEddnpcfaMTeziFEaujWmUxOZ0QaBDmTOl3D
         q1ag==
X-Gm-Message-State: AOJu0Yz12ELvMY38NayYUmQ08T2Lv66rAd7nwT2kqw99AfbfQEJHE/OR
	/55lcZxW0FinQg3ZUWFRg9TT7LTnq9pEM6s2kCemn6w6huy/l8JQbBvEk8YokoOWpaP3GF0Zus+
	fCB6u9lIut326a4oa7bmJej/6CZUPtjDjL9piZw==
X-Google-Smtp-Source: AGHT+IGODqTItRWYHOZ28Yqmvu0O6Rr+aWUuJBPmZEr6Ki1V5MLerjZPMkfWA5tuJ7o9FCSlViAvHP6db7+YvP0Pyxc=
X-Received: by 2002:a05:6e02:1aaf:b0:365:5fa1:710e with SMTP id
 l15-20020a056e021aaf00b003655fa1710emr1136831ilv.8.1709276376559; Thu, 29 Feb
 2024 22:59:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301013545.10403-1-duchao@eswincomputing.com>
 <20240301013545.10403-2-duchao@eswincomputing.com> <CAAhSdy2+_+t4L8LHmYcJQZBGJHj6pyFm26_KwFBahFxz7eV1fQ@mail.gmail.com>
 <1f31ec16.1447.18df8b97f73.Coremail.duchao@eswincomputing.com>
In-Reply-To: <1f31ec16.1447.18df8b97f73.Coremail.duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 1 Mar 2024 12:29:26 +0530
Message-ID: <CAAhSdy0x6bdm3hYk8jeRG_bF-vFXP8eOqYJ5GMY4Eb=bMNkaQw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 12:05=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> On 2024-03-01 13:00, Anup Patel <anup@brainfault.org> wrote:
> >
> > On Fri, Mar 1, 2024 at 7:08=E2=80=AFAM Chao Du <duchao@eswincomputing.c=
om> wrote:
> > >
> > > kvm_vm_ioctl_check_extension(): Return 1 if KVM_CAP_SET_GUEST_DEBUG i=
s
> > > been checked.
> > >
> > > kvm_arch_vcpu_ioctl_set_guest_debug(): Update the guest_debug flags
> > > from userspace accordingly. Route the breakpoint exceptions to HS mod=
e
> > > if the VCPU is being debugged by userspace, by clearing the
> > > corresponding bit in hedeleg. Write the actual CSR in
> > > kvm_arch_vcpu_load().
> > >
> > > Signed-off-by: Chao Du <duchao@eswincomputing.com>
> > > ---
> > >  arch/riscv/include/asm/kvm_host.h | 17 +++++++++++++++++
> > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > >  arch/riscv/kvm/main.c             | 18 ++----------------
> > >  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
> > >  arch/riscv/kvm/vm.c               |  1 +
> > >  5 files changed, 34 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/a=
sm/kvm_host.h
> > > index 484d04a92fa6..9ee3f03ba5d1 100644
> > > --- a/arch/riscv/include/asm/kvm_host.h
> > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > @@ -43,6 +43,22 @@
> > >         KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEU=
P)
> > >  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
> > >
> > > +#define KVM_HEDELEG_DEFAULT            ((_AC(1, UL) << EXC_INST_MISA=
LIGNED) | \
> > > +                                        (_AC(1, UL) << EXC_BREAKPOIN=
T) | \
> > > +                                        (_AC(1, UL) << EXC_SYSCALL) =
| \
> > > +                                        (_AC(1, UL) << EXC_INST_PAGE=
_FAULT) | \
> > > +                                        (_AC(1, UL) << EXC_LOAD_PAGE=
_FAULT) | \
> > > +                                        (_AC(1, UL) << EXC_STORE_PAG=
E_FAULT))
> >
> > Use BIT(xyz) here. For example: BIT(EXC_INST_MISALIGNED)
>
> Thanks, I will use BIT() instead in next revision.
>
> >
>
> > Also, BIT(EXC_BREAKPOINT) should not be part of KVM_HEDELEG_DEFAULT.
>
> I think the bit EXC_BREAKPOINT should be set by default, like what you
> already did in kvm_arch_hardware_enable(). Then the VS could get the ebre=
ak
> and handle it accordingly.
>
> If the guest_debug is enabled, ebreak instructions are inserted by the
> userspace(QEMU). So KVM should 'intercept' the ebreak and exit to QEMU.
> Bit EXC_BREAKPOINT should be cleared in this case.

If EXC_BREAKPOINT is delegated by default then it is not consistent with
vcpu->guest_debug which is not enabled by default.

>
> >
> > > +#define KVM_HEDELEG_GUEST_DEBUG                ((_AC(1, UL) << EXC_I=
NST_MISALIGNED) | \
> > > +                                        (_AC(1, UL) << EXC_SYSCALL) =
| \
> > > +                                        (_AC(1, UL) << EXC_INST_PAGE=
_FAULT) | \
> > > +                                        (_AC(1, UL) << EXC_LOAD_PAGE=
_FAULT) | \
> > > +                                        (_AC(1, UL) << EXC_STORE_PAG=
E_FAULT))
> >
> > No need for KVM_HEDELEG_GUEST_DEBUG, see below.
> >
> > > +
> > > +#define KVM_HIDELEG_DEFAULT            ((_AC(1, UL) << IRQ_VS_SOFT) =
| \
> > > +                                        (_AC(1, UL) << IRQ_VS_TIMER)=
 | \
> > > +                                        (_AC(1, UL) << IRQ_VS_EXT))
> > > +
> >
> > Same as above, use BIT(xyz) here.
> >
> > >  enum kvm_riscv_hfence_type {
> > >         KVM_RISCV_HFENCE_UNKNOWN =3D 0,
> > >         KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> > > @@ -169,6 +185,7 @@ struct kvm_vcpu_csr {
> > >  struct kvm_vcpu_config {
> > >         u64 henvcfg;
> > >         u64 hstateen0;
> > > +       unsigned long hedeleg;
> > >  };
> > >
> > >  struct kvm_vcpu_smstateen_csr {
> > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/u=
api/asm/kvm.h
> > > index 7499e88a947c..39f4f4b9dede 100644
> > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > @@ -17,6 +17,7 @@
> > >
> > >  #define __KVM_HAVE_IRQ_LINE
> > >  #define __KVM_HAVE_READONLY_MEM
> > > +#define __KVM_HAVE_GUEST_DEBUG
> > >
> > >  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> > >
> > > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > > index 225a435d9c9a..bab2ec34cd87 100644
> > > --- a/arch/riscv/kvm/main.c
> > > +++ b/arch/riscv/kvm/main.c
> > > @@ -22,22 +22,8 @@ long kvm_arch_dev_ioctl(struct file *filp,
> > >
> > >  int kvm_arch_hardware_enable(void)
> > >  {
> > > -       unsigned long hideleg, hedeleg;
> > > -
> > > -       hedeleg =3D 0;
> > > -       hedeleg |=3D (1UL << EXC_INST_MISALIGNED);
> > > -       hedeleg |=3D (1UL << EXC_BREAKPOINT);
> > > -       hedeleg |=3D (1UL << EXC_SYSCALL);
> > > -       hedeleg |=3D (1UL << EXC_INST_PAGE_FAULT);
> > > -       hedeleg |=3D (1UL << EXC_LOAD_PAGE_FAULT);
> > > -       hedeleg |=3D (1UL << EXC_STORE_PAGE_FAULT);
> > > -       csr_write(CSR_HEDELEG, hedeleg);
> > > -
> > > -       hideleg =3D 0;
> > > -       hideleg |=3D (1UL << IRQ_VS_SOFT);
> > > -       hideleg |=3D (1UL << IRQ_VS_TIMER);
> > > -       hideleg |=3D (1UL << IRQ_VS_EXT);
> > > -       csr_write(CSR_HIDELEG, hideleg);
> > > +       csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
> > > +       csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
> > >
> > >         /* VS should access only the time counter directly. Everythin=
g else should trap */
> > >         csr_write(CSR_HCOUNTEREN, 0x02);
> > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > index b5ca9f2e98ac..242076c2227f 100644
> > > --- a/arch/riscv/kvm/vcpu.c
> > > +++ b/arch/riscv/kvm/vcpu.c
> > > @@ -475,8 +475,15 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_v=
cpu *vcpu,
> > >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> > >                                         struct kvm_guest_debug *dbg)
> > >  {
> > > -       /* TODO; To be implemented later. */
> > > -       return -EINVAL;
> >
> > if (vcpu->arch.ran_atleast_once)
> >         return -EBUSY;
>
> If we enabled the guest_debug in QEMU side, then the KVM_SET_GUEST_DEBUG =
ioctl
> will come before the first KVM_RUN. This will always cause an ERROR.

The check ensures that KVM user space can only enable/disable
guest debug before the VCPU is run. I don't see why this would
fail for QEMU.

>
> >
> >
> > > +       if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > > +               vcpu->guest_debug =3D dbg->control;
> > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_GUEST_DEBUG;
> > > +       } else {
> > > +               vcpu->guest_debug =3D 0;
> > > +               vcpu->arch.cfg.hedeleg =3D KVM_HEDELEG_DEFAULT;
> > > +       }
> >
> > Don't update vcpu->arch.cfg.hedeleg here since it should be only done
> > in kvm_riscv_vcpu_setup_config().
> >
> > > +
> > > +       return 0;
> > >  }
> > >
> > >  static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> > > @@ -505,6 +512,9 @@ static void kvm_riscv_vcpu_setup_config(struct kv=
m_vcpu *vcpu)
> > >                 if (riscv_isa_extension_available(isa, SMSTATEEN))
> > >                         cfg->hstateen0 |=3D SMSTATEEN0_SSTATEEN0;
> > >         }
> > > +
> > > +       if (!vcpu->guest_debug)
> > > +               cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> >
> > This should be:
> >
> > cfg->hedeleg =3D KVM_HEDELEG_DEFAULT;
> > if (vcpu->guest_debug)
> >         cfg->hedeleg |=3D BIT(EXC_BREAKPOINT);
>
> Like above, here the logic should be:
>
> cfg->hedeleg =3D KVM_HEDELEG_DEFAULT; // with BIT(EXC_BREAKPOINT)
> if (vcpu->guest_debug)
>         cfg->hedeleg &=3D ~BIT(EXC_BREAKPOINT);
>
> Another approach is:
> initialize the cfg->hedeleg as KVM_HEDELEG_DEFAULT during kvm_arch_vcpu_c=
reate().
> Besides that, only update the cfg->hedeleg in kvm_arch_vcpu_ioctl_set_gue=
st_debug().

I disagree. We should handle hedeleg just like we handle henvcfg.

>
> >
> > >  }
> > >
> > >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > > @@ -519,6 +529,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, in=
t cpu)
> > >         csr_write(CSR_VSEPC, csr->vsepc);
> > >         csr_write(CSR_VSCAUSE, csr->vscause);
> > >         csr_write(CSR_VSTVAL, csr->vstval);
> > > +       csr_write(CSR_HEDELEG, cfg->hedeleg);
> > >         csr_write(CSR_HVIP, csr->hvip);
> > >         csr_write(CSR_VSATP, csr->vsatp);
> > >         csr_write(CSR_HENVCFG, cfg->henvcfg);
> > > diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> > > index ce58bc48e5b8..7396b8654f45 100644
> > > --- a/arch/riscv/kvm/vm.c
> > > +++ b/arch/riscv/kvm/vm.c
> > > @@ -186,6 +186,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> > >         case KVM_CAP_READONLY_MEM:
> > >         case KVM_CAP_MP_STATE:
> > >         case KVM_CAP_IMMEDIATE_EXIT:
> > > +       case KVM_CAP_SET_GUEST_DEBUG:
> > >                 r =3D 1;
> > >                 break;
> > >         case KVM_CAP_NR_VCPUS:
> > > --
> > > 2.17.1
> > >
> >
> > Regards,
> > Anup
>
> Thanks,
> Chao

Regards,
Anup

