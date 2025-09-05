Return-Path: <kvm+bounces-56871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0180AB45316
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 11:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FE2E188A086
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643EB28032D;
	Fri,  5 Sep 2025 09:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yso+LdtZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829132459E7;
	Fri,  5 Sep 2025 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757064286; cv=none; b=WUYuL9RritsRJvbS8/YMSLMkdnElm5OER145v4wJBIyMaSmfRPSgz7TfInYq/jC4B9OFznvHZ8GuTdgQxQSxxL6tU7NAt6G1p89T/ucs2PKy64Mku1zNw4Y2Z+wZ6qGKO0zSeNkp4u8vVWtGxlY4bATghRiyBZ50cPJNJTfKQrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757064286; c=relaxed/simple;
	bh=xn1cBlBYowmjdOw3NEC19GzVEL4yZ/Mjcp028HUzEwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WeMCKGo9wBX+gEdpBOKHKLrLUIjdnmMNJOBFSpeWQMkMGojVu6e/pT7uRSLxXtLD3rsR3kOjzxgOooOtSMFn71N0hV7/2x/wAd/iRmfXQ2ygEaH4+zo7pbMWki1Luf4LPmMqBkd6ICVwsyM8u4kM7Sq6yC3+C+H0TmCQqc3ScRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yso+LdtZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A5EC4CEF8;
	Fri,  5 Sep 2025 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757064286;
	bh=xn1cBlBYowmjdOw3NEC19GzVEL4yZ/Mjcp028HUzEwE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Yso+LdtZACvBr8LTL6jQmOdHW3HQ89Vh2TsXJMzgK4I4bP8zrGPb8nKXJzo0LD9LP
	 PkV5F7Tx6jqkNZzX0kyoyW67DCiFESZhW9cquhhQB3XuL378Vu4iVBdo5nAd1G/7mi
	 axrMPnRw+V8GYIgvsgTYdII4D8cpNmEoDIeUb8PiAMxDfrarCU2s5glE6x07kMQFq2
	 7yvpQR1NFONJi+kiARCvzzDpvOrzKMwbd8BQwvQ0U+ouRbgxkFq5e5g+xgAXg+Nj/m
	 ICdi/ZNmqw6BkXaTe2QTPPUAnvoLXxscCBe27I+D9s51B1HEUy5ROBxw8+gLwIZP55
	 S/rBMYO3zBGxg==
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3df3be0e098so1034162f8f.1;
        Fri, 05 Sep 2025 02:24:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWonLXzfKPDsYmPeSZ9sG7Jyd05+evynz48MGETo8nGpJ6iL1yWlGewvFS2j9j+9dmx2v8HvQ8LxILImGx+@vger.kernel.org, AJvYcCWqXWfna9DuK7SNC70lSiXXsZKGg++357rc+8EqiRyGmuRQyljVK7uFFtWQWEMTchZnKuE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR7F138QFgGsUzvYwHpgrsULwEtLBSdACX1KZZZQrOi9ZO9Oa1
	IuyWhXIkvsZsp1v0RAXPsNhoE7TBEh1KLre5auJvc8U+4RL8k/kUk/kkjVqQPM59ucjG179yQwx
	GiiAix4+3r3KOwSyvXRtAE0KseZ2qA6E=
X-Google-Smtp-Source: AGHT+IFO+nNQPeTp6KTVQmXaLCZr780764cWJzX4z8CTgBpJDANTWBptG3Xs47tDUEH2ItTeLripzaIbTRt2R1kPFFY=
X-Received: by 2002:a05:6000:2407:b0:3d8:3eca:a9a9 with SMTP id
 ffacd0b85a97d-3d83ecac114mr12757978f8f.12.1757064284409; Fri, 05 Sep 2025
 02:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821142542.2472079-1-guoren@kernel.org> <20250821142542.2472079-4-guoren@kernel.org>
 <CAAhSdy2yFQYbrp8npzBUwtviJYVQ=vv1F_k3jybYBvheYMgaZQ@mail.gmail.com>
In-Reply-To: <CAAhSdy2yFQYbrp8npzBUwtviJYVQ=vv1F_k3jybYBvheYMgaZQ@mail.gmail.com>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 5 Sep 2025 17:24:32 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSmadsR9GnorXxSqgJOqaY7B098MNO-zp2cWNUSSZKEbg@mail.gmail.com>
X-Gm-Features: Ac12FXzxa70YzHM55Z06Gn0Klnlb5YFGpg5AY2m1AVnAzZyqKEQu-yGqy999y8M
Message-ID: <CAJF2gTSmadsR9GnorXxSqgJOqaY7B098MNO-zp2cWNUSSZKEbg@mail.gmail.com>
Subject: Re: [PATCH V4 RESEND 3/3] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
To: Anup Patel <anup@brainfault.org>
Cc: troy.mitchell@linux.dev, alex@ghiti.fr, aou@eecs.berkeley.edu, 
	atish.patra@linux.dev, fangyu.yu@linux.alibaba.com, guoren@linux.alibaba.com, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	palmer@dabbelt.com, paul.walmsley@sifive.com, 
	Nutty Liu <nutty.liu@hotmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 2:51=E2=80=AFPM Anup Patel <anup@brainfault.org> wro=
te:
>
> On Thu, Aug 21, 2025 at 7:56=E2=80=AFPM <guoren@kernel.org> wrote:
> >
> > From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
> >
> > urrent kvm_riscv_gstage_mode_detect() assumes H-extension must
>
> s/urrent/Current/
Oh, my fault about copy & paste.


>
> > have HGATP_MODE_SV39X4/SV32X4 at least, but the spec allows
> > H-extension with HGATP_MODE_BARE alone. The KVM depends on
> > !HGATP_MODE_BARE at least, so enhance the gstage-mode-detect
> > to block HGATP_MODE_BARE.
> >
> > Move gstage-mode-check closer to gstage-mode-detect to prevent
> > unnecessary init.
> >
> > Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
> > Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
> > Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> > ---
> >  arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
> >  arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
> >  2 files changed, 41 insertions(+), 21 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> > index 24c270d6d0e2..b67d60d722c2 100644
> > --- a/arch/riscv/kvm/gstage.c
> > +++ b/arch/riscv/kvm/gstage.c
> > @@ -321,7 +321,7 @@ void __init kvm_riscv_gstage_mode_detect(void)
> >         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE=
_SV57X4) {
> >                 kvm_riscv_gstage_mode =3D HGATP_MODE_SV57X4;
> >                 kvm_riscv_gstage_pgd_levels =3D 5;
> > -               goto skip_sv48x4_test;
> > +               goto done;
> >         }
> >
> >         /* Try Sv48x4 G-stage mode */
> > @@ -329,10 +329,31 @@ void __init kvm_riscv_gstage_mode_detect(void)
> >         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE=
_SV48X4) {
> >                 kvm_riscv_gstage_mode =3D HGATP_MODE_SV48X4;
> >                 kvm_riscv_gstage_pgd_levels =3D 4;
> > +               goto done;
> >         }
> > -skip_sv48x4_test:
> >
> > +       /* Try Sv39x4 G-stage mode */
> > +       csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> > +       if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE=
_SV39X4) {
> > +               kvm_riscv_gstage_mode =3D HGATP_MODE_SV39X4;
> > +               kvm_riscv_gstage_pgd_levels =3D 3;
> > +               goto done;
> > +       }
> > +#else /* CONFIG_32BIT */
> > +       /* Try Sv32x4 G-stage mode */
> > +       csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
> > +       if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE=
_SV32X4) {
> > +               kvm_riscv_gstage_mode =3D HGATP_MODE_SV32X4;
> > +               kvm_riscv_gstage_pgd_levels =3D 2;
> > +               goto done;
> > +       }
> > +#endif
> > +
> > +       /* KVM depends on !HGATP_MODE_OFF */
> > +       kvm_riscv_gstage_mode =3D HGATP_MODE_OFF;
> > +       kvm_riscv_gstage_pgd_levels =3D 0;
> > +
> > +done:
> >         csr_write(CSR_HGATP, 0);
> >         kvm_riscv_local_hfence_gvma_all();
> > -#endif
> >  }
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index 67c876de74ef..8ee7aaa74ddc 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -93,6 +93,23 @@ static int __init riscv_kvm_init(void)
> >                 return rc;
> >
> >         kvm_riscv_gstage_mode_detect();
> > +       switch (kvm_riscv_gstage_mode) {
> > +       case HGATP_MODE_SV32X4:
> > +               str =3D "Sv32x4";
> > +               break;
> > +       case HGATP_MODE_SV39X4:
> > +               str =3D "Sv39x4";
> > +               break;
> > +       case HGATP_MODE_SV48X4:
> > +               str =3D "Sv48x4";
> > +               break;
> > +       case HGATP_MODE_SV57X4:
> > +               str =3D "Sv57x4";
> > +               break;
> > +       default:
>
> Need kvm_riscv_nacl_exit() here.
Yes, it's another legacy problem, which lacks:
        kvm_riscv_aia_exit();
        kvm_riscv_nacl_exit();

After we move it up, it still needs:
        kvm_riscv_nacl_exit();

I'm okay with it being fixed in this patch.

>
> > +               return -ENODEV;
> > +       }
> > +       kvm_info("using %s G-stage page table format\n", str);
>
> Moving the kvm_info() over here now prints G-stage mode
> before announcing availablity of h-extension which looks odd.
> It's better to keep kvm_info() in the same location and only
> move the switch-case.
okay.

>
> >
> >         kvm_riscv_gstage_vmid_detect();
> >
> > @@ -135,24 +152,6 @@ static int __init riscv_kvm_init(void)
> >                          (rc) ? slist : "no features");
> >         }
> >
> > -       switch (kvm_riscv_gstage_mode) {
> > -       case HGATP_MODE_SV32X4:
> > -               str =3D "Sv32x4";
> > -               break;
> > -       case HGATP_MODE_SV39X4:
> > -               str =3D "Sv39x4";
> > -               break;
> > -       case HGATP_MODE_SV48X4:
> > -               str =3D "Sv48x4";
> > -               break;
> > -       case HGATP_MODE_SV57X4:
> > -               str =3D "Sv57x4";
> > -               break;
> > -       default:
> > -               return -ENODEV;
> > -       }
> > -       kvm_info("using %s G-stage page table format\n", str);
> > -
> >         kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bit=
s());
> >
> >         if (kvm_riscv_aia_available())
> > --
> > 2.40.1
> >
>
> Otherwise, this looks good to me.
>
> I will take care of minor comments mentioned above at the
> time of merging this series.
Thx for taking care. Nice!

--
Best Regards
 Guo Ren

