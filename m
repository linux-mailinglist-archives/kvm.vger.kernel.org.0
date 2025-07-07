Return-Path: <kvm+bounces-51649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A565AFAAA2
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92B0B189C773
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 04:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1511262FE7;
	Mon,  7 Jul 2025 04:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Kyw//ZHU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CD2262FC0
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 04:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751863743; cv=none; b=kza/Qrp8CezdwfDsweIsRM1ma0IZxbWheDFl3ER9SLvLDpWYyY/tb0CMae+cnb3vidNnvSqrVuDwz7pRi6eWnqahUEZOon89hcmQzuj6m/zQ7OW1nEXs9L/wyTYVp+l9h0TLAu5HnZEkCKpMvtePafeNENeyx2/KqXyo7gmlM8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751863743; c=relaxed/simple;
	bh=vfd9IuQhQewM4iYuqDzMNX9YrqpTWbO35sm8uOB9Zqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tvzf939mxwzA5+s7eCoyUctyX1D3PCNzkL5yGQrtr1WS50LRk+TA86z13zSUCeJ/+a4uNl+woJA6b9dkaSZlJuV2I/F3SRmdD75K5iMmUllr/eaX5dtgQJpuiS0RcvX+/ODUbHA9oe968eoTt7P6FrWQEfSBY5kK+pW6VaWxNCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Kyw//ZHU; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-32f1763673cso18717031fa.3
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 21:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751863740; x=1752468540; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnEWctI6r6awDl12Kz12r16u6Ow2Nv5sRarHCWcDisc=;
        b=Kyw//ZHUmX56obeDPoUjGFgL3IOG4xSMOk2ypoDouiJeQeynFv7rIs48RAFQIZLkbe
         fWpUJv9DofE3qiZrF4Bp6HqVaV4cA1vgHo7TaiUj5z5eunycECc/IfIoSc5ecUVfxE8O
         KzlAoTX3sYVuak4Q3/AXy2jezuQ0m2nzY5sVhdx4EPsp0kcpv4KQeAsaU+4AD9/kpHnn
         LaxrkNuJrLOW/AEHjvTRwh2ibRsZHB7+9q/IyE0tkZgB/ytMR9BYJ7CcOwx4KHu1L/30
         yNnjW6o+lSrEpWic1Frxqj8qppdHLFavmIpi6BX0LQs77nVDERxv8CafD/FtXH9evoJ7
         cnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751863740; x=1752468540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mnEWctI6r6awDl12Kz12r16u6Ow2Nv5sRarHCWcDisc=;
        b=vzC7Xox9xitFruaKRvgYj/uLhZWlE7vrUTMNxKkaGr3Q/2pcGDQNs8m88hdf5Fb1db
         jdZvXsObqH3kKlXTtydqX6MlFYaP+XYwqgLc8yQNK5RkFkvSa7fHBn8WsDAwCpc3Ejjq
         yeoybY5Y2F5b50QKsEWPHCa2YwjAwNjMzT2OhIKZfG0TFacN8BQdTljfcI9y6k4NZOun
         T0eEoGjjpzCr3KVE6NCDoJZeDHNQuoDtofw6Zn4CsnScC3YxK0LQ8oJFelM0MIK+q1Q7
         rFRJ7mg2705yoAcSc11+I0cq9YWlbg6Y2ruz2qyMmgxBIqdH0W97GzY+PYpG1KUBuL8m
         1Btg==
X-Forwarded-Encrypted: i=1; AJvYcCWAF22v703OFTV7suZUocLfYe2etJHdwGIJY5IosbemN4KkWRkvG4gNpxCF4/Kgsn0kzY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXm776EKL2c184JRqm7iTZlcxO5tyHrAIf2kRws6G5oTUa20fF
	jyRaNAqrF/rd0A7tkFDIOpd5CAqyinRcWYqJgZ77te4HUY1xhUVyWekRZ0HHk+QAP3U8m8E8iBK
	vya+ARLQtO5LAWSK2AwtnJge0OfnO+hBUm0VOJZTGvw==
X-Gm-Gg: ASbGnctGgjA+WuAEZNSAijJ6u4mDgy+O5ukpAEkPsT9un8LgQ5T4yZggysoWIl3tebi
	BhGEu0OZfKONo/tXmEXyBjS123W4dmWo0BNAQRnON55Eyn0D0SIp24Y9PgcV5uxzKcu2hFBwRGe
	hkmRLuPRTqsjbexWqYCGn2Hr4tcVPOcHnvSZdt+FdgdWrS
X-Google-Smtp-Source: AGHT+IFeuDrrS3TZkCqdMq1PfJbUtlLBFolCZ7ScRRsouf0UxlPn3CURLEsVGY8dqvu9WAjsFjCL2lcBgSJ432WUWzg=
X-Received: by 2002:a05:651c:a0b:b0:32b:70c9:5d2c with SMTP id
 38308e7fff4ca-32f092f3711mr44803851fa.32.1751863739830; Sun, 06 Jul 2025
 21:48:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707035345.17494-1-apatel@ventanamicro.com>
 <20250707035345.17494-3-apatel@ventanamicro.com> <cbdbf6f6-4645-4e93-ba5f-0d2a1cbd2116@lanxincomputing.com>
In-Reply-To: <cbdbf6f6-4645-4e93-ba5f-0d2a1cbd2116@lanxincomputing.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Mon, 7 Jul 2025 10:18:48 +0530
X-Gm-Features: Ac12FXwGvl5cPopf0MhYgcN8D8SOGoJCIH3bqjNnVD_RzeKXny50VJ-QQKfjPCU
Message-ID: <CAK9=C2VwBpG9z9XjPjfjdLU2V+ymUROXb09pFJ52nZY79OfJ_g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
To: Nutty Liu <liujingqi@lanxincomputing.com>
Cc: Atish Patra <atish.patra@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>, 
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 7, 2025 at 9:50=E2=80=AFAM Nutty Liu <liujingqi@lanxincomputing=
.com> wrote:
>
> On 7/7/2025 11:53 AM, Anup Patel wrote:
> > Currently, the common AIA functions kvm_riscv_vcpu_aia_has_interrupts()
> > and kvm_riscv_aia_wakeon_hgei() lookup HGEI line using an array of VCPU
> > pointers before accessing HGEI[E|P] CSR which is slow and prone to race
> > conditions because there is a separate per-hart lock for the VCPU point=
er
> > array and a separate per-VCPU rwlock for IMSIC VS-file (including HGEI
> > line) used by the VCPU. Due to these race conditions, it is observed
> > on QEMU RISC-V host that Guest VCPUs sleep in WFI and never wakeup even
> > with interrupt pending in the IMSIC VS-file because VCPUs were waiting
> > for HGEI wakeup on the wrong host CPU.
> >
> > The IMSIC virtualization already keeps track of the HGEI line and the
> > associated IMSIC VS-file used by each VCPU so move the HGEI[E|P] CSR
> > access to IMSIC virtualization so that costly HGEI line lookup can be
> > avoided and likelihood of race-conditions when updating HGEI[E|P] CSR
> > is also reduced.
> >
> > Reviewed-by: Atish Patra <atishp@rivosinc.com>
> > Tested-by: Atish Patra <atishp@rivosinc.com>
> > Tested-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
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
>
> Nitpick:
> Should the above two empty functions be removed ?
>

We cannot remove these functions but we can certainly
make them static inline. I will update in the next revision.

Thanks,
Anup

