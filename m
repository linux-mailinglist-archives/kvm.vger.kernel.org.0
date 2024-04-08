Return-Path: <kvm+bounces-13837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 746AC89B6A7
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 05:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 959D41C210D1
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 03:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B117524F;
	Mon,  8 Apr 2024 03:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Qlb4enEK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21574687
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 03:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712548621; cv=none; b=Ur8ZuhObU+B08oqbssqdCjuTWFnT/Gzp4hc2o7aGcm4VM2I2np3mvTohOIFX3Vs6IUmmXrPOXJVdO1L1mpB47A1vQGVQwp3t+VgRdKhAIxMiaJ+t7NFwGCPDb/wlv5KHask9jH2w0XB+LnLPjVxas2ap2rNGk7/l6jfpwpOhJT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712548621; c=relaxed/simple;
	bh=tVNm71Fcrn4Kph6vsY20+75q99vXCgOCL4MpEu8ryHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NPt+mhflFjDpyvUEaX0nDzKlC+ytKAQ4RB1ZMB6w+BQfmrf/ZLbIs4X9Iuw0ky0udO6EsR59rJ3h2CiZVL7UySla0GSLTePYh9k4H2qpwZyN5v1+iN89ydnYRYqe5eMX9Dm1w6bEMWXxa+vSyCOlGEDmKCugGZdQ1ccijNYxRxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=Qlb4enEK; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5a522ae3747so1808886eaf.1
        for <kvm@vger.kernel.org>; Sun, 07 Apr 2024 20:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1712548619; x=1713153419; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5nAgfNYfB0Z+mfrRK2mpFihZrCx/GK87TdIEbmr9Oo=;
        b=Qlb4enEKOQTP/LaGVp2DVRsIJPEX2QZQHfwINZ0IRC0dUgJUib1rKsggEffSA1NNDI
         QuodTh5dgovysnedb0PrNaPfqxFiPIaPQ8Km5aLQJYghwMl3dGKrBs164Ogrec9Yqc/+
         jsAtwavLP7xDIx6XrBvGbv4a1gM6DqgL4w+vncyQ7DMVteuYMsS5mh/TR2Nj3YsYSV4x
         RQBfRyDkbaxw+5KYbrQXbAupuJ3qq3mGKzwWwvV8ULC+LuYQcDCe6fZnQhVdk+y8a0i/
         ZCazFRzdYbZG4Vhb37GR/UkZKlqPZHcHIlz5XniE23Z/JmgwnwzXLInqveN4gc7F2ZoE
         cKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712548619; x=1713153419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t5nAgfNYfB0Z+mfrRK2mpFihZrCx/GK87TdIEbmr9Oo=;
        b=P1LCjvWUpmLIkt3ET/csOCIMKs+Bddhdq3NcVNZzPnbvkqTBtJoKkVq0O6wdSteuue
         Y1wm5Om0VMcOYVZPktZsbklscjTZOfWxWsUS74ujASz20RDPu2oS9gZwFBTu3EXVacEa
         V2Hya6E88Kky8m6z2DJTLPuKPhAHPRH46RmBFw8hjHCfSWo4LUnssCiaG5pLDgxhf8ec
         1YKV6Ni+qFvd8kP/uDOJjdBsnKOP/Mql4pcG++5h4ZuowkRkgKZW1ZJNODgxhLgjLPsm
         HVAEFFlUTUwZ3Um2r1KodRLDsOVNugpnHEU0TXwn36aKpUIrXd2MtNv8HrY2mPOEkPCC
         0jpg==
X-Forwarded-Encrypted: i=1; AJvYcCVOasoGsKCtapbBYebZe/8RMOsddJivtZ6QJos9xrhOLHOypr4RgAouHA5wSwrLcs0FrK8fUuKGODIm8DUMf+rwAvqQ
X-Gm-Message-State: AOJu0Yzr4qiGCY9kwceVF8i4aChExbwQJVSYjm+bB+ep2nlQ+a3wSvXm
	Hm02vA50TKHA1Dtt++SYtOj64jXn4hLbkQqVedISgJlMUKL00ZkSRj9GN4Rnz/aC01F/jP394Em
	MWILERXFukbGUlpcEaieEQnoD4C2TVhbxLW3hjA==
X-Google-Smtp-Source: AGHT+IE/Ou7t3VMQvqKVwCYFU5LDxOSJd7+j4C4rAo22QszPPaWs4HaP202BhM7lGz72M31bL/UZ1n8l4wATZmU98dk=
X-Received: by 2002:a05:6820:619:b0:5aa:a8f:e4b1 with SMTP id
 e25-20020a056820061900b005aa0a8fe4b1mr2603089oow.4.1712548619015; Sun, 07 Apr
 2024 20:56:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240326101054.13088-1-yongxuan.wang@sifive.com> <CAAhSdy1EOyzg+Sdx5-uJJqFipehde+zGic8jNnnTXBEj7k4P3g@mail.gmail.com>
In-Reply-To: <CAAhSdy1EOyzg+Sdx5-uJJqFipehde+zGic8jNnnTXBEj7k4P3g@mail.gmail.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Mon, 8 Apr 2024 11:56:50 +0800
Message-ID: <CAMWQL2j_cca2nSerhQKVZYRu-pOQmFzxUaGmi8gbE5GFb8=oqA@mail.gmail.com>
Subject: Re: [PATCH 1/1] RISC-V: KVM: Avoid lock inversion in SBI_EXT_HSM_HART_START
To: Anup Patel <anup@brainfault.org>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anup,

On Tue, Apr 2, 2024 at 11:48=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Tue, Mar 26, 2024 at 3:41=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@sif=
ive.com> wrote:
> >
> > Documentation/virt/kvm/locking.rst advises that kvm->lock should be
> > acquired outside vcpu->mutex and kvm->srcu. However, when KVM/RISC-V
> > handling SBI_EXT_HSM_HART_START, the lock ordering is vcpu->mutex,
> > kvm->srcu then kvm->lock.
> >
> > Although the lockdep checking no longer complains about this after comm=
it
> > f0f44752f5f6 ("rcu: Annotate SRCU's update-side lockdep dependencies"),
> > it's necessary to replace kvm->lock with a new dedicated lock to ensure
> > only one hart can execute the SBI_EXT_HSM_HART_START call for the targe=
t
> > hart simultaneously.
> >
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h | 1 +
> >  arch/riscv/kvm/vcpu.c             | 1 +
> >  arch/riscv/kvm/vcpu_sbi_hsm.c     | 5 ++---
> >  3 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > index 484d04a92fa6..537099413344 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -254,6 +254,7 @@ struct kvm_vcpu_arch {
> >
> >         /* VCPU power-off state */
> >         bool power_off;
> > +       struct mutex hsm_start_lock;
>
> Instead of a mutex hsm_start_lock, let's introduce spinlock mp_state_lock
> which needs to be taken whenever power_off is accessed. Also, we should
> rename "power_off" to "mp_state" with two possible values.
>
> >
> >         /* Don't run the VCPU (blocked) */
> >         bool pause;
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index b5ca9f2e98ac..4d89b5b5afbf 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -119,6 +119,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >         spin_lock_init(&vcpu->arch.hfence_lock);
> >
> >         /* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
> > +       mutex_init(&vcpu->arch.hsm_start_lock);
> >         cntx =3D &vcpu->arch.guest_reset_context;
> >         cntx->sstatus =3D SR_SPP | SR_SPIE;
> >         cntx->hstatus =3D 0;
> > diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hs=
m.c
> > index 7dca0e9381d9..b528f6e880ae 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> > @@ -71,14 +71,13 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu =
*vcpu, struct kvm_run *run,
> >  {
> >         int ret =3D 0;
> >         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> > -       struct kvm *kvm =3D vcpu->kvm;
> >         unsigned long funcid =3D cp->a6;
> >
> >         switch (funcid) {
> >         case SBI_EXT_HSM_HART_START:
> > -               mutex_lock(&kvm->lock);
> > +               mutex_lock(&vcpu->arch.hsm_start_lock);
> >                 ret =3D kvm_sbi_hsm_vcpu_start(vcpu);
> > -               mutex_unlock(&kvm->lock);
> > +               mutex_unlock(&vcpu->arch.hsm_start_lock);
>
> The use of kvm->lock over here was also protecting
> simultaneous updates to VCPU reset context. It's better
> to introduce a separate lock for protecting VCPU reset
> context access.
>
> >                 break;
> >         case SBI_EXT_HSM_HART_STOP:
> >                 ret =3D kvm_sbi_hsm_vcpu_stop(vcpu);
> > --
> > 2.17.1
> >
>
> I think this patch can be broken down into two patches:
> 1) Patch replacing VCPU "power_off" with "enum mp_state"
>     and introducing "mp_state_lock"
> 2) Patch introducing VCPU reset context lock
>
> Regards,
> Anup

Got it! I will update these in a new patchset. Thank you!

Regards,
Yong-Xuan

