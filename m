Return-Path: <kvm+bounces-63660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85700C6C7F2
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:01:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 623D02C78C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FD52D1F44;
	Wed, 19 Nov 2025 02:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPMfD+Jq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC272D193F
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521098; cv=none; b=h7x63jemaoddVrGtJusScDGJMbPgInhPlb98STc1bTRbMk5jwzMmt6ahj3ulZDgbSmzBsW/pBPPd7oMIL5P++xaFPyOBQDPXfWgLrZzCIM7gFAczmS/lmSw8F+OMqQgpwGxRl6ZQ4Bt0Uu9yBbTfrMrKq89NIiTKWvlIkCZjjvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521098; c=relaxed/simple;
	bh=fulMuwf+Zku9Wjdj6WDVSh3QTRYYFwW1Pjwn+4hpd84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mjpZ2rgg+iuqSGfvELJGMAf/7pR0y14wF6WsgN12jVG5CYryW0JwIpuASnyCPRrGdaNAPjh7ejPD5qi8JjrL2BUhOcMEhmifhI2zQO3M21vBUAKiwPIEduOf/h6QK/XyOBV1r5iEwg9/tiRxIbHPj1PvkytZd5TBSbm9tc39d90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPMfD+Jq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EFEC4AF13
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763521096;
	bh=fulMuwf+Zku9Wjdj6WDVSh3QTRYYFwW1Pjwn+4hpd84=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jPMfD+JqFz+RjYO8RJDpBsZRBu7hwInjPJZT2hUv+IgQrkOEfaTnRvQRSIFK8C7kN
	 C8Ga5WpstRnossYiRzo8VGsKj0xgVAk4j308+kH18Pxkntpq4/qhIlPqweMctzd29c
	 JUHDsOxHbRXhBcfXMYOOawvyeUIflbdHsxymykCv//xuE673Jp8OWBikXzueETyL7a
	 hIbuJIHBc7u+DhDQWkUwqUIDQXG87d02oW5W7/sM5O7IX84SP2YFkMTK5aK/C9+bqm
	 D50QFbeSMs1sj8+quzLZUYQrWQvuV1rfbgVlbYRHsZ/taSCF3EMsT9WoHRaQ73wecp
	 T0TsOUPTbU6TA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b728a43e410so1015889966b.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:58:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVZHkklWYJ14RC7lQ7UrV3Np3x+7Yon1LGq59PxXgiKSXC/FCDPwLLodwJ04abKFdMsjzg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxExnb7KiN9bYvB2pmAL4omOJgxDR+KCEk8egzhkOuvVjbIj/OH
	lj1V7ZH7bIgM+vI39PbO3MxOTIVOVTzDqI3dio0gP2PBg7NcT4R9jQacYSlaDxGAeMD2F4Xd+f/
	GoAw6com6nlR6pC1/cUiH3WKLEtjdqlA=
X-Google-Smtp-Source: AGHT+IGulmRfiYU5r7OCw8XMXKdKd/hzLF72d9CVxsP2o9LalMaTSpYijeEvweeFAVPlW1fKbNr+rgzvOtBuNfw2kuU=
X-Received: by 2002:a17:906:6a10:b0:b73:8bd4:8fb with SMTP id
 a640c23a62f3a-b738bd40df4mr1413543666b.42.1763521093584; Tue, 18 Nov 2025
 18:58:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118080656.2012805-1-maobibo@loongson.cn> <20251118080656.2012805-3-maobibo@loongson.cn>
 <CAAhV-H4hoS0Wo3TS+FdikXMkb7qjWNFSPDoajQr0bzdeROJwGw@mail.gmail.com> <db8a26ca-8430-9e7d-4ad1-9b7743c4cfd1@loongson.cn>
In-Reply-To: <db8a26ca-8430-9e7d-4ad1-9b7743c4cfd1@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 19 Nov 2025 10:58:15 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7uU6U9okJKqkUEXRT9OATpdMRgzZ8a7x0Xr6_bzD-x4A@mail.gmail.com>
X-Gm-Features: AWmQ_bkYm_hlDiJIOm45FDB6rcjF7ZstDv8Qh2OULTDqpWqLpv9LAIRM02fxjtk
Message-ID: <CAAhV-H7uU6U9okJKqkUEXRT9OATpdMRgzZ8a7x0Xr6_bzD-x4A@mail.gmail.com>
Subject: Re: [PATCH 2/3] LoongArch: Add paravirt support with vcpu_is_preempted()
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, 
	Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 10:01=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
>
>
> On 2025/11/18 =E4=B8=8B=E5=8D=888:48, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Tue, Nov 18, 2025 at 4:07=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Function vcpu_is_preempted() is used to check whether vCPU is preempte=
d
> >> or not. Here add implementation with vcpu_is_preempted() when option
> >> CONFIG_PARAVIRT is enabled.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/smp.h      |  1 +
> >>   arch/loongarch/include/asm/spinlock.h |  5 +++++
> >>   arch/loongarch/kernel/paravirt.c      | 16 ++++++++++++++++
> >>   arch/loongarch/kernel/smp.c           |  6 ++++++
> >>   4 files changed, 28 insertions(+)
> >>
> >> diff --git a/arch/loongarch/include/asm/smp.h b/arch/loongarch/include=
/asm/smp.h
> >> index 3a47f52959a8..5b37f7bf2060 100644
> >> --- a/arch/loongarch/include/asm/smp.h
> >> +++ b/arch/loongarch/include/asm/smp.h
> >> @@ -18,6 +18,7 @@ struct smp_ops {
> >>          void (*init_ipi)(void);
> >>          void (*send_ipi_single)(int cpu, unsigned int action);
> >>          void (*send_ipi_mask)(const struct cpumask *mask, unsigned in=
t action);
> >> +       bool (*vcpu_is_preempted)(int cpu);
> >>   };
> >>   extern struct smp_ops mp_ops;
> >>
> >> diff --git a/arch/loongarch/include/asm/spinlock.h b/arch/loongarch/in=
clude/asm/spinlock.h
> >> index 7cb3476999be..c001cef893aa 100644
> >> --- a/arch/loongarch/include/asm/spinlock.h
> >> +++ b/arch/loongarch/include/asm/spinlock.h
> >> @@ -5,6 +5,11 @@
> >>   #ifndef _ASM_SPINLOCK_H
> >>   #define _ASM_SPINLOCK_H
> >>
> >> +#ifdef CONFIG_PARAVIRT
> >> +#define vcpu_is_preempted      vcpu_is_preempted
> >> +bool vcpu_is_preempted(int cpu);
> >> +#endif
> > Maybe paravirt.h is a better place?
>
> It is actually a little strange to add macro CONFIG_PARAVIRT in file
> asm/spinlock.h
>
> vcpu_is_preempted is originally defined in header file
> include/linux/sched.h like this
> #ifndef vcpu_is_preempted
> static inline bool vcpu_is_preempted(int cpu)
> {
>          return false;
> }
> #endif
>
> that requires that header file is included before sched.h, file
> asm/spinlock.h can meet this requirement, however header file paravirt.h
> maybe it is not included before sched.h in generic.
>
> Here vcpu_is_preempted definition is added before the following including=
.
>     #include <asm/processor.h>
>     #include <asm/qspinlock.h>
>     #include <asm/qrwlock.h>
> Maybe it is better to be added after the above header files including
> sentences, but need further investigation.
powerpc put it in paravirt.h, so I think it is possible.

> >
> >> +
> >>   #include <asm/processor.h>
> >>   #include <asm/qspinlock.h>
> >>   #include <asm/qrwlock.h>
> >> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/=
paravirt.c
> >> index b1b51f920b23..b99404b6b13f 100644
> >> --- a/arch/loongarch/kernel/paravirt.c
> >> +++ b/arch/loongarch/kernel/paravirt.c
> >> @@ -52,6 +52,13 @@ static u64 paravt_steal_clock(int cpu)
> >>   #ifdef CONFIG_SMP
> >>   static struct smp_ops native_ops;
> >>
> >> +static bool pv_vcpu_is_preempted(int cpu)
> >> +{
> >> +       struct kvm_steal_time *src =3D &per_cpu(steal_time, cpu);
> >> +
> >> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >> +}
> >> +
> >>   static void pv_send_ipi_single(int cpu, unsigned int action)
> >>   {
> >>          int min, old;
> >> @@ -308,6 +315,9 @@ int __init pv_time_init(void)
> >>                  pr_err("Failed to install cpu hotplug callbacks\n");
> >>                  return r;
> >>          }
> >> +
> >> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
> >> +               mp_ops.vcpu_is_preempted =3D pv_vcpu_is_preempted;
> >>   #endif
> >>
> >>          static_call_update(pv_steal_clock, paravt_steal_clock);
> >> @@ -332,3 +342,9 @@ int __init pv_spinlock_init(void)
> >>
> >>          return 0;
> >>   }
> >> +
> >> +bool notrace vcpu_is_preempted(int cpu)
> >> +{
> >> +       return mp_ops.vcpu_is_preempted(cpu);
> >> +}
> >
> > We can simplify the whole patch like this, then we don't need to touch
> > smp.c, and we can merge Patch-2/3.
> >
> > +bool notrace vcpu_is_preempted(int cpu)
> > +{
> > +  if (!kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
> > +     return false;
> > + else {
> > +     struct kvm_steal_time *src =3D &per_cpu(steal_time, cpu);
> > +     return !!(src->preempted & KVM_VCPU_PREEMPTED);
> > + }
> > +}
> 1. there is assembly output about relative vcpu_is_preempted
>   <loongson_vcpu_is_preempted>:
>                 move    $r4,$r0
>                 jirl    $r0,$r1,0
>
>   <pv_vcpu_is_preempted>:
>          pcalau12i       $r13,8759(0x2237)
>          slli.d  $r4,$r4,0x3
>          addi.d  $r13,$r13,-1000(0xc18)
>          ldx.d   $r13,$r13,$r4
>          pcalau12i       $r12,5462(0x1556)
>          addi.d  $r12,$r12,384(0x180)
>          add.d   $r12,$r13,$r12
>          ld.bu   $r4,$r12,16(0x10)
>          andi    $r4,$r4,0x1
>          jirl    $r0,$r1,0
>
>   <vcpu_is_preempted>:
>          pcalau12i       $r12,8775(0x2247)
>          ld.d    $r12,$r12,-472(0xe28)
>          jirl    $r0,$r12,0
>          andi    $r0,$r0,0x0
>
>   <vcpu_is_preempted_new>:
>          pcalau12i       $r12,8151(0x1fd7)
>          ld.d    $r12,$r12,-1008(0xc10)
>          bstrpick.d      $r12,$r12,0x1a,0x1a
>          beqz    $r12,188(0xbc) # 900000000024ec60
>          pcalau12i       $r12,11802(0x2e1a)
>          addi.d  $r12,$r12,-1400(0xa88)
>          ldptr.w $r14,$r12,36(0x24)
>          beqz    $r14,108(0x6c) # 900000000024ec20
>          addi.w  $r13,$r0,1(0x1)
>          bne     $r14,$r13,164(0xa4) # 900000000024ec60
>          ldptr.w $r13,$r12,40(0x28)
>          bnez    $r13,24(0x18) # 900000000024ebdc
>          lu12i.w $r14,262144(0x40000)
>          ori     $r14,$r14,0x4
>          cpucfg  $r14,$r14
>          slli.w  $r13,$r14,0x0
>          st.w    $r14,$r12,40(0x28)
>          bstrpick.d      $r13,$r13,0x3,0x3
>          beqz    $r13,128(0x80) # 900000000024ec60
>          pcalau12i       $r13,8759(0x2237)
>          slli.d  $r4,$r4,0x3
>          addi.d  $r13,$r13,-1000(0xc18)
>          ldx.d   $r13,$r13,$r4
>          pcalau12i       $r12,5462(0x1556)
>          addi.d  $r12,$r12,384(0x180)
>          add.d   $r12,$r13,$r12
>          ld.bu   $r4,$r12,16(0x10)
>          andi    $r4,$r4,0x1
>          jirl    $r0,$r1,0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          lu12i.w $r13,262144(0x40000)
>          cpucfg  $r13,$r13
>          lu12i.w $r15,1237(0x4d5)
>          ori     $r15,$r15,0x64b
>          slli.w  $r13,$r13,0x0
>          bne     $r13,$r15,-124(0x3ff84) # 900000000024ebb8
>          addi.w  $r13,$r0,1(0x1)
>          st.w    $r13,$r12,36(0x24)
>          b       -128(0xfffff80) # 900000000024ebc0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          andi    $r0,$r0,0x0
>          move    $r4,$r0
>          jirl    $r0,$r1,0
>
> With vcpu_is_preempted(), there is one memory load and one jirl jump,
> with vcpu_is_preempted_new(), there is two memory load and two beq
> compare instructions.
Is vcpu_is_preempted() performance critical (we need performance data
here)? It seems the powerpc version is also complex.

>
> 2. In some scenery such nr_cpus =3D=3D 1, loongson_vcpu_is_preempted() is
> better than pv_vcpu_is_preempted() even if the preempt feature is enabled=
.
In your original patch, "mp_ops.vcpu_is_preempted =3D
pv_vcpu_is_preempted" if the preempt feature is enabled. Why is
loongson_vcpu_is_preempted() called when nr_cpus=3D1?

Huacai

>
> Regards
> Bibo Mao
> > Huacai
> >
> >> +EXPORT_SYMBOL(vcpu_is_preempted);
> >> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> >> index 46036d98da75..f04192fedf8d 100644
> >> --- a/arch/loongarch/kernel/smp.c
> >> +++ b/arch/loongarch/kernel/smp.c
> >> @@ -307,10 +307,16 @@ static void loongson_init_ipi(void)
> >>                  panic("IPI IRQ request failed\n");
> >>   }
> >>
> >> +static bool loongson_vcpu_is_preempted(int cpu)
> >> +{
> >> +       return false;
> >> +}
> >> +
> >>   struct smp_ops mp_ops =3D {
> >>          .init_ipi               =3D loongson_init_ipi,
> >>          .send_ipi_single        =3D loongson_send_ipi_single,
> >>          .send_ipi_mask          =3D loongson_send_ipi_mask,
> >> +       .vcpu_is_preempted      =3D loongson_vcpu_is_preempted,
> >>   };
> >>
> >>   static void __init fdt_smp_setup(void)
> >> --
> >> 2.39.3
> >>
> >>
>
>

