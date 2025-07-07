Return-Path: <kvm+bounces-51640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 079D5AFAA66
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5074D178509
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4716D259CA9;
	Mon,  7 Jul 2025 03:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ddnf/tFD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D72F510
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751860356; cv=none; b=PtsMUfGBO4zdwqn4P+6aNIdE1Ij96NihiQNrJy0cMUmxoqS5WuXeLAu9KBb4m1WcRFAJgQOyLVLFnU0xFVtgk4T+QUzVGxq5sZSWaH7Yjd0+c+1+6LhUV6XbqJkwUMFc6puFFlQvqkM2bA/M/AOgWdXYbM9JVCnQVj6fhzuOJyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751860356; c=relaxed/simple;
	bh=FbLIH/MbbwPuvdvJxyKy/t968nX3PCiN6WDVvIzs/UQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lHjzEisZz2NFaEtYkr4CDJvgoRXcdBsGPctzRiz8OrqUv6BdiONDTrXVENWDP+u4lxktGqhWY3t+cvnBBbPdZxH9P8xqr0xoNbtWVouNu1fx621ucaTy8NBWcT4ATrAhnyjIikbj42pW73mzc8qtLR+rCkr15oaaOitcQ/2tOsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ddnf/tFD; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55511c3e203so2476170e87.3
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751860352; x=1752465152; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUQIlBnVCvjQJOuG6eQpz9FIxtecKMH41CZkyLg0qvk=;
        b=ddnf/tFD4DWCWMFV9DLrEjbrubYjM3/vJUR+fUiGAEK/o6MSZGyI3lhVS0FIFWpkBU
         X1mrKJLzb0q/BJQLkCFQ1MnwZZkLVIe+Av2vusPMe3G1OFYzy1gOHWWcR8XAFpj4Gl5d
         rjD7GdpLHFrBOiH7l9Pu5pSH37bbBFwkml1qVHTX/KAJRoBGP2YYE8WJOXlAGkW/9hw8
         m24PQaI/nPab8raxW1x9EHfjqBiM4+UshAUFkdomm+sAO2EllflDzmybMjR/MIoXmqKu
         8TZON0EEKauolN86jKIBfduCWW0NOFLEbG3yzpSxA0bczwrtZoxEV1816zwBYLhRce+z
         Du5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751860352; x=1752465152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MUQIlBnVCvjQJOuG6eQpz9FIxtecKMH41CZkyLg0qvk=;
        b=kKiXU8XJukCUT/LWk6B498TDTVaAZeMPaqVrK8amkpcZ2gE8VNIS/yS+530/UojVHK
         6SgbxUfcL4QJQary4VkwmS6ltVwFEPXRJEvYRXhk0X64/yptcB6BQLqDKdysbcEns+Sz
         8E2PU6JXY1NVgeHhaBfbJEqaLSicvN0gaqsgWHxEM7sOuqYNJUvtvC50wmrcl4bFon0y
         zDdphT7PZfVLX2vC4lf70oj8dXJW9kTmtcXj3hCa/MqiUjkcjm+usiRAraqy3v+ntaud
         aTwr4BsIOdAhDZm58kmHRzwMELc+TJRUMOedSR0ls1cHTnQhd+qD/4idWcfm2mrXncrC
         pErg==
X-Forwarded-Encrypted: i=1; AJvYcCVxchdynfIYwVB5KClILY1gcumv2m/pSwOhr6+slObsz5YD4VqSxp+wNGORZ8Fqy9jMTTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvHw5GXghJ+v6eTwtSlR6uFS2iCOOWWePzjc6jmSOfIlELuJCF
	8oFJlC39st6BRPYxNN5pgTrG1rjhdCZK2WcTkg8JZVgKQ3vncm3nt5TXfFUfgdJXfxfRsFlf4ZD
	2ioXkdbJSr12F5ziZLN0aOUilx/UIB+gUsHgLXDLDEw==
X-Gm-Gg: ASbGncvBjCdYYT8eJjEWFwo8F0rqvXsFpgDdMbHdFVQcFBSFp3Gcu5MhWNOj85LIoXq
	U/9PQqkU2D6qv1K4cbvweckgUvyFHw4GrFSG9mUn2/9vFNQrU97wBojtN1WUYxbgGq3FDhKkjWR
	WqTMXB85eXIdKRMhlHWcofG8Za+YauGSnmcAxFWAaSE1GF
X-Google-Smtp-Source: AGHT+IFJDXlM49nFRTXjGx4L8EaFlrcU2NO1PfUWgbKlCo6Hf/HOIywhsRANHuQhpEJQAXmwbNqc18KLW6FUtpdpNs0=
X-Received: by 2002:a05:6512:3c98:b0:553:3383:6766 with SMTP id
 2adb3069b0e04-556dbe8cf86mr3642717e87.19.1751860352392; Sun, 06 Jul 2025
 20:52:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704153838.6575-1-apatel@ventanamicro.com>
 <20250704153838.6575-3-apatel@ventanamicro.com> <88ef2551-edc2-416b-9399-b45ad880d52e@linux.dev>
In-Reply-To: <88ef2551-edc2-416b-9399-b45ad880d52e@linux.dev>
From: Anup Patel <apatel@ventanamicro.com>
Date: Mon, 7 Jul 2025 09:22:20 +0530
X-Gm-Features: Ac12FXwn282f_3bW5Pneh_M2UvX4JOua-H683a3X8eh516woEbDUIqy35qDmvRo
Message-ID: <CAK9=C2V9_+HSMvk9fVkKO4878WwsqNUiUj8unmAicmCrzWDyDg@mail.gmail.com>
Subject: Re: [PATCH 2/2] RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 5, 2025 at 1:12=E2=80=AFPM Atish Patra <atish.patra@linux.dev> =
wrote:
>
>
> On 7/4/25 8:38 AM, Anup Patel wrote:
> > There is one HGEI line associated with each IMSIC VS-file on a host CPU=
.
> > The IMSIC virtualization already keeps track of the HGEI line and the
> > associated IMSIC VS-file used by each VCPU.
> >
> > Currently, the common AIA functions kvm_riscv_vcpu_aia_has_interrupts()
> > and kvm_riscv_aia_wakeon_hgei() lookup HGEI line using an array of VCPU
> > pointers before accessing HGEI[E|P] CSR which is slow. Move the HGEI[E|=
P]
> > CSR access to IMSIC virtualization so that costly HGEI line lookup and
> > potential race-conditions when updating HGEI[E|P] CSR can be avoided.
>
> The patch looks good to me. It removes the redundant hgei lookup which
> is great.
> But can you elaborate the race condition and it's effect (lost interrupt
> because of hgei is disabled during context switch) in the commit text ?

It's not a case of lost interrupt rather HGEI wakeup not firing even when
there is interrupt pending in IMSIC VS-file due to incorrect setting in HGE=
IE
CSR. I will update the commit description in the next revision.

Regards,
Anup

>
> > Fixes: 3385339296d1 ("RISC-V: KVM: Use IMSIC guest files when available=
")
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >   arch/riscv/include/asm/kvm_aia.h |  4 ++-
> >   arch/riscv/kvm/aia.c             | 51 +++++--------------------------=
-
> >   arch/riscv/kvm/aia_imsic.c       | 45 ++++++++++++++++++++++++++++
> >   arch/riscv/kvm/vcpu.c            |  2 --
> >   4 files changed, 55 insertions(+), 47 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/=
kvm_aia.h
> > index 0a0f12496f00..b04ecdd1a860 100644
> > --- a/arch/riscv/include/asm/kvm_aia.h
> > +++ b/arch/riscv/include/asm/kvm_aia.h
> > @@ -87,6 +87,9 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
> >
> >   extern struct kvm_device_ops kvm_riscv_aia_device_ops;
> >
> > +bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu);
> > +void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu);
> > +void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu);
> >   void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu);
> >   int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu);
> >
> > @@ -161,7 +164,6 @@ void kvm_riscv_aia_destroy_vm(struct kvm *kvm);
> >   int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
> >                            void __iomem **hgei_va, phys_addr_t *hgei_pa=
);
> >   void kvm_riscv_aia_free_hgei(int cpu, int hgei);
> > -void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable);
> >
> >   void kvm_riscv_aia_enable(void);
> >   void kvm_riscv_aia_disable(void);
> > diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> > index 19afd1f23537..dad318185660 100644
> > --- a/arch/riscv/kvm/aia.c
> > +++ b/arch/riscv/kvm/aia.c
> > @@ -30,28 +30,6 @@ unsigned int kvm_riscv_aia_nr_hgei;
> >   unsigned int kvm_riscv_aia_max_ids;
> >   DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
> >
> > -static int aia_find_hgei(struct kvm_vcpu *owner)
> > -{
> > -     int i, hgei;
> > -     unsigned long flags;
> > -     struct aia_hgei_control *hgctrl =3D get_cpu_ptr(&aia_hgei);
> > -
> > -     raw_spin_lock_irqsave(&hgctrl->lock, flags);
> > -
> > -     hgei =3D -1;
> > -     for (i =3D 1; i <=3D kvm_riscv_aia_nr_hgei; i++) {
> > -             if (hgctrl->owners[i] =3D=3D owner) {
> > -                     hgei =3D i;
> > -                     break;
> > -             }
> > -     }
> > -
> > -     raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> > -
> > -     put_cpu_ptr(&aia_hgei);
> > -     return hgei;
> > -}
> > -
> >   static inline unsigned long aia_hvictl_value(bool ext_irq_pending)
> >   {
> >       unsigned long hvictl;
> > @@ -95,7 +73,6 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vc=
pu *vcpu)
> >
> >   bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mas=
k)
> >   {
> > -     int hgei;
> >       unsigned long seip;
> >
> >       if (!kvm_riscv_aia_available())
> > @@ -114,11 +91,7 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_v=
cpu *vcpu, u64 mask)
> >       if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
> >               return false;
> >
> > -     hgei =3D aia_find_hgei(vcpu);
> > -     if (hgei > 0)
> > -             return !!(ncsr_read(CSR_HGEIP) & BIT(hgei));
> > -
> > -     return false;
> > +     return kvm_riscv_vcpu_aia_imsic_has_interrupt(vcpu);
> >   }
> >
> >   void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
> > @@ -164,6 +137,9 @@ void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu,=
 int cpu)
> >               csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
> >   #endif
> >       }
> > +
> > +     if (kvm_riscv_aia_initialized(vcpu->kvm))
> > +             kvm_riscv_vcpu_aia_imsic_load(vcpu, cpu);
> >   }
> >
> >   void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> > @@ -174,6 +150,9 @@ void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> >       if (!kvm_riscv_aia_available())
> >               return;
> >
> > +     if (kvm_riscv_aia_initialized(vcpu->kvm))
> > +             kvm_riscv_vcpu_aia_imsic_put(vcpu);
> > +
> >       if (kvm_riscv_nacl_available()) {
> >               nsh =3D nacl_shmem();
> >               csr->vsiselect =3D nacl_csr_read(nsh, CSR_VSISELECT);
> > @@ -472,22 +451,6 @@ void kvm_riscv_aia_free_hgei(int cpu, int hgei)
> >       raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> >   }
> >
> > -void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable)
> > -{
> > -     int hgei;
> > -
> > -     if (!kvm_riscv_aia_available())
> > -             return;
> > -
> > -     hgei =3D aia_find_hgei(owner);
> > -     if (hgei > 0) {
> > -             if (enable)
> > -                     csr_set(CSR_HGEIE, BIT(hgei));
> > -             else
> > -                     csr_clear(CSR_HGEIE, BIT(hgei));
> > -     }
> > -}
> > -
> >   static irqreturn_t hgei_interrupt(int irq, void *dev_id)
> >   {
> >       int i;
> > diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> > index ea1a36836d9c..fda0346f0ea1 100644
> > --- a/arch/riscv/kvm/aia_imsic.c
> > +++ b/arch/riscv/kvm/aia_imsic.c
> > @@ -677,6 +677,48 @@ static void imsic_swfile_update(struct kvm_vcpu *v=
cpu,
> >       imsic_swfile_extirq_update(vcpu);
> >   }
> >
> > +bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu)
> > +{
> > +     struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> > +     unsigned long flags;
> > +     bool ret =3D false;
> > +
> > +     /*
> > +      * The IMSIC SW-file directly injects interrupt via hvip so
> > +      * only check for interrupt when IMSIC VS-file is being used.
> > +      */
> > +
> > +     read_lock_irqsave(&imsic->vsfile_lock, flags);
> > +     if (imsic->vsfile_cpu > -1)
> > +             ret =3D !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei))=
;
> > +     read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> > +
> > +     return ret;
> > +}
> > +
> > +void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu)
> > +{
> > +     /*
> > +      * No need to explicitly clear HGEIE CSR bits because the
> > +      * hgei interrupt handler (aka hgei_interrupt()) will always
> > +      * clear it for us.
> > +      */
> > +}
> > +
> > +void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu)
> > +{
> > +     struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
> > +     unsigned long flags;
> > +
> > +     if (!kvm_vcpu_is_blocking(vcpu))
> > +             return;
> > +
> > +     read_lock_irqsave(&imsic->vsfile_lock, flags);
> > +     if (imsic->vsfile_cpu > -1)
> > +             csr_set(CSR_HGEIE, BIT(imsic->vsfile_hgei));
> > +     read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> > +}
> > +
> >   void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
> >   {
> >       unsigned long flags;
> > @@ -781,6 +823,9 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu=
 *vcpu)
> >        * producers to the new IMSIC VS-file.
> >        */
> >
> > +     /* Ensure HGEIE CSR bit is zero before using the new IMSIC VS-fil=
e */
> > +     csr_clear(CSR_HGEIE, BIT(new_vsfile_hgei));
> > +
> >       /* Zero-out new IMSIC VS-file */
> >       imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index fe028b4274df..b26bf35a0a19 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -211,12 +211,10 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vc=
pu)
> >
> >   void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> >   {
> > -     kvm_riscv_aia_wakeon_hgei(vcpu, true);
> >   }
> >
> >   void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >   {
> > -     kvm_riscv_aia_wakeon_hgei(vcpu, false);
> >   }
> >
> >   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
>
>

