Return-Path: <kvm+bounces-63332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A48DC627E1
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 07:15:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 600074E758A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 06:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B786314D38;
	Mon, 17 Nov 2025 06:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hD5ezsw9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7870930C631
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 06:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763360134; cv=none; b=nO8QrZ5/fKOxgwFU/E/dXI82J/ud7c7+UJUd8u85l843F/cnxQyeg60yik+HEshyyLIChY4sX1AHwB+bae2BJ9/xWQtaHNIkX4oOtnl7QYj73KPUr952vuCP2oZbTlKcXwQtcjHFB4hi69KaUTPjNhkM24sA81IwHhe7Xy7/agg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763360134; c=relaxed/simple;
	bh=341jL4+GbKEcWnd2PzWxd7DEeJ8xXVvnV7m1i0R7X+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbiHT0TztFBs/05KA97AR06zNnkhgyG5OFGr+ZdI4ffNIKlFKKVN4qu7b37Rse1KOtC8LdyKdZ9SrQVefcaMap4ydtLUcErL8YYLTSI6FfAwfXXsQGen1NtErjlhQLYxgDg+49GL6joqPAfFqxATvQrbju3Shcu8N8EO3ph8ZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hD5ezsw9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287A8C4AF0B
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 06:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763360134;
	bh=341jL4+GbKEcWnd2PzWxd7DEeJ8xXVvnV7m1i0R7X+g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hD5ezsw9gRX3ERVV5/LnZtts3PfIGpvrfwejjwpH1lO6D/Mu0OyLAYUryarlE9P0j
	 5LWVNXqj0xpTjCS9AWEOZ6tupS22tLBpwsQPKXjXWco7ER8Aq1tG5EU2u99nr277/i
	 OVjGU+eWNcdUFTMobdXgcW8VXicOOgArX4rFDHBhiE1p2AiSk03JUq91AsvEJOO1lV
	 cPoTMGHUovrxlhFxZgoOyc6UJ+x10xAk2MMAFNG5GnfiVv5QXHe4vyc4oZUfvWh+vq
	 BdlJclSC4OlmzH6YznsaEHT/z+9NaCxte7WyPCT+BJUhiUQH/zwI/3HurUR4PFmB6N
	 m/HgBkLj8Y+HQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7355f6ef12so628844266b.3
        for <kvm@vger.kernel.org>; Sun, 16 Nov 2025 22:15:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUIObJz0wxgVa+g6AnR10+yr5MAtpBrRTimvBnxTVkDFjT9lNrAwB93b8k0d38h0B7nulk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVbnJ5jPGtuH/dSDW8zc3bBpKiiu0U1hDyYkgppkRaJhGjWPFN
	/w9s8xPAvfXVIwrGblBTrkG7uAxRsYlO0uAv8oL3Lj6R4/koGPrZLB0/6z6xe0piTo53al1LBtq
	HFW53NSW8B7exKkDdARdnU6TRtbJ8a8Q=
X-Google-Smtp-Source: AGHT+IHAo8f77ovsIeRwd3r5qOsUX3bRRKkomFO//en+L/J37ffF6hEYQfR+SAD8cqpLPahuy9s0BYd/l3RRF/nNdZk=
X-Received: by 2002:a17:907:1c82:b0:b73:4006:1884 with SMTP id
 a640c23a62f3a-b7367b8d999mr1175498366b.37.1763360132707; Sun, 16 Nov 2025
 22:15:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251015060626.3915824-1-gaosong@loongson.cn> <28fff8cb-d436-78c7-1836-2fc0f71f806b@loongson.cn>
In-Reply-To: <28fff8cb-d436-78c7-1836-2fc0f71f806b@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 17 Nov 2025 14:15:32 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7wY1hV3syErZkY2d+dV3iy02n+67V1oBxfWjyDONGXPA@mail.gmail.com>
X-Gm-Features: AWmQ_bmXBIbLGofFYdra-KaYoBYaJ5DrW6PHww26oFzDI316URMnY7RodRjdeRk
Message-ID: <CAAhV-H7wY1hV3syErZkY2d+dV3iy02n+67V1oBxfWjyDONGXPA@mail.gmail.com>
Subject: Re: [PATCH v3] LoongArch: KVM: Add AVEC support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Song Gao <gaosong@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied with some modifications:
https://github.com/chenhuacai/linux/commit/95e73e623cf7d9404ecc6040c8a568d8=
56b84efb

Because a preparation patch is upstream now:
https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/commit/?h=3Dloongarch-next&id=3Df28abb9f96e65a28d46885afd6b70cfc4d5df5a2

Huacai

On Wed, Oct 15, 2025 at 4:25=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/10/15 =E4=B8=8B=E5=8D=882:06, Song Gao wrote:
> > Add cpu_has_msgint() to check whether the host cpu supported avec,
> > and restore/save CSR_MSGIS0-CSR_MSGIS3.
> >
> > Signed-off-by: Song Gao <gaosong@loongson.cn>
> > ---
> >   arch/loongarch/include/asm/kvm_host.h |  4 ++++
> >   arch/loongarch/include/asm/kvm_vcpu.h |  1 +
> >   arch/loongarch/include/uapi/asm/kvm.h |  1 +
> >   arch/loongarch/kvm/interrupt.c        | 15 +++++++++++++--
> >   arch/loongarch/kvm/vcpu.c             | 19 +++++++++++++++++--
> >   arch/loongarch/kvm/vm.c               |  4 ++++
> >   6 files changed, 40 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inc=
lude/asm/kvm_host.h
> > index 0cecbd038bb3..827e204bdeb3 100644
> > --- a/arch/loongarch/include/asm/kvm_host.h
> > +++ b/arch/loongarch/include/asm/kvm_host.h
> > @@ -283,6 +283,10 @@ static inline bool kvm_guest_has_lbt(struct kvm_vc=
pu_arch *arch)
> >       return arch->cpucfg[2] & (CPUCFG2_X86BT | CPUCFG2_ARMBT | CPUCFG2=
_MIPSBT);
> >   }
> >
> > +static inline bool cpu_has_msgint(void)
> > +{
> > +     return read_cpucfg(LOONGARCH_CPUCFG1) & CPUCFG1_MSGINT;
> > +}
> >   static inline bool kvm_guest_has_pmu(struct kvm_vcpu_arch *arch)
> >   {
> >       return arch->cpucfg[6] & CPUCFG6_PMP;
> > diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inc=
lude/asm/kvm_vcpu.h
> > index f1efd7cfbc20..3784ab4ccdb5 100644
> > --- a/arch/loongarch/include/asm/kvm_vcpu.h
> > +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> > @@ -15,6 +15,7 @@
> >   #define CPU_PMU                             (_ULCAST_(1) << 10)
> >   #define CPU_TIMER                   (_ULCAST_(1) << 11)
> >   #define CPU_IPI                             (_ULCAST_(1) << 12)
> > +#define CPU_AVEC                        (_ULCAST_(1) << 14)
> >
> >   /* Controlled by 0x52 guest exception VIP aligned to estat bit 5~12 *=
/
> >   #define CPU_IP0                             (_ULCAST_(1))
> > diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inc=
lude/uapi/asm/kvm.h
> > index 57ba1a563bb1..de6c3f18e40a 100644
> > --- a/arch/loongarch/include/uapi/asm/kvm.h
> > +++ b/arch/loongarch/include/uapi/asm/kvm.h
> > @@ -104,6 +104,7 @@ struct kvm_fpu {
> >   #define  KVM_LOONGARCH_VM_FEAT_PV_IPI               6
> >   #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME 7
> >   #define  KVM_LOONGARCH_VM_FEAT_PTW          8
> > +#define  KVM_LOONGARCH_VM_FEAT_MSGINT                9
> >
> >   /* Device Control API on vcpu fd */
> >   #define KVM_LOONGARCH_VCPU_CPUCFG   0
> > diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interr=
upt.c
> > index 8462083f0301..f586f421bc19 100644
> > --- a/arch/loongarch/kvm/interrupt.c
> > +++ b/arch/loongarch/kvm/interrupt.c
> > @@ -21,6 +21,7 @@ static unsigned int priority_to_irq[EXCCODE_INT_NUM] =
=3D {
> >       [INT_HWI5]      =3D CPU_IP5,
> >       [INT_HWI6]      =3D CPU_IP6,
> >       [INT_HWI7]      =3D CPU_IP7,
> > +     [INT_AVEC]      =3D CPU_AVEC,
> >   };
> >
> >   static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priori=
ty)
> > @@ -31,6 +32,11 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, un=
signed int priority)
> >       if (priority < EXCCODE_INT_NUM)
> >               irq =3D priority_to_irq[priority];
> >
> > +     if (cpu_has_msgint() && (priority =3D=3D INT_AVEC)) {
> > +             set_gcsr_estat(irq);
> > +             return 1;
> > +     }
> > +
> >       switch (priority) {
> >       case INT_TI:
> >       case INT_IPI:
> > @@ -58,6 +64,11 @@ static int kvm_irq_clear(struct kvm_vcpu *vcpu, unsi=
gned int priority)
> >       if (priority < EXCCODE_INT_NUM)
> >               irq =3D priority_to_irq[priority];
> >
> > +     if (cpu_has_msgint() && (priority =3D=3D INT_AVEC)) {
> > +             clear_gcsr_estat(irq);
> > +             return 1;
> > +     }
> > +
> >       switch (priority) {
> >       case INT_TI:
> >       case INT_IPI:
> > @@ -83,10 +94,10 @@ void kvm_deliver_intr(struct kvm_vcpu *vcpu)
> >       unsigned long *pending =3D &vcpu->arch.irq_pending;
> >       unsigned long *pending_clr =3D &vcpu->arch.irq_clear;
> >
> > -     for_each_set_bit(priority, pending_clr, INT_IPI + 1)
> > +     for_each_set_bit(priority, pending_clr, EXCCODE_INT_NUM)
> >               kvm_irq_clear(vcpu, priority);
> >
> > -     for_each_set_bit(priority, pending, INT_IPI + 1)
> > +     for_each_set_bit(priority, pending, EXCCODE_INT_NUM)
> >               kvm_irq_deliver(vcpu, priority);
> >   }
> >
> > diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> > index 30e3b089a596..226c735155be 100644
> > --- a/arch/loongarch/kvm/vcpu.c
> > +++ b/arch/loongarch/kvm/vcpu.c
> > @@ -657,8 +657,7 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
> >               *v =3D GENMASK(31, 0);
> >               return 0;
> >       case LOONGARCH_CPUCFG1:
> > -             /* CPUCFG1_MSGINT is not supported by KVM */
> > -             *v =3D GENMASK(25, 0);
> > +             *v =3D GENMASK(26, 0);
> >               return 0;
> >       case LOONGARCH_CPUCFG2:
> >               /* CPUCFG2 features unconditionally supported by KVM */
> > @@ -726,6 +725,10 @@ static int kvm_check_cpucfg(int id, u64 val)
> >               return -EINVAL;
> >
> >       switch (id) {
> > +     case LOONGARCH_CPUCFG1:
> > +             if ((val & CPUCFG1_MSGINT) && (!cpu_has_msgint()))
> > +                     return -EINVAL;
> > +             return 0;
> >       case LOONGARCH_CPUCFG2:
> >               if (!(val & CPUCFG2_LLFTP))
> >                       /* Guests must have a constant timer */
> > @@ -1658,6 +1661,12 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu,=
 int cpu)
> >       kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
> >       kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
> >       kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
> > +     if (cpu_has_msgint()) {
> > +             kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
> > +             kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
> > +             kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
> > +             kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
> > +     }
> >
> >       /* Restore Root.GINTC from unused Guest.GINTC register */
> >       write_csr_gintc(csr->csrs[LOONGARCH_CSR_GINTC]);
> > @@ -1747,6 +1756,12 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, =
int cpu)
> >       kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
> >       kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
> >       kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
> > +     if (cpu_has_msgint()) {
> > +             kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
> > +             kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
> > +             kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
> > +             kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
> > +     }
> >
> >       vcpu->arch.aux_inuse |=3D KVM_LARCH_SWCSR_LATEST;
> >
> > diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> > index a49b1c1a3dd1..ec92e6f3cf92 100644
> > --- a/arch/loongarch/kvm/vm.c
> > +++ b/arch/loongarch/kvm/vm.c
> > @@ -150,6 +150,10 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm=
, struct kvm_device_attr *attr
> >               if (cpu_has_ptw)
> >                       return 0;
> >               return -ENXIO;
> > +     case KVM_LOONGARCH_VM_FEAT_MSGINT:
> > +             if (cpu_has_msgint())
> > +                     return 0;
> > +             return -ENXIO;
> >       default:
> >               return -ENXIO;
> >       }
> >
> > base-commit: 9b332cece987ee1790b2ed4c989e28162fa47860
> >
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>
>

