Return-Path: <kvm+bounces-63687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B64DC6D349
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 16F5F3579F6
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177463074B7;
	Wed, 19 Nov 2025 07:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pt67Kc2F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC52F066D
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 07:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538117; cv=none; b=UPda2LyVkYtvOMRKSKHpvur1gQs4g8ncxtudxhPTc+i/fmZOq5jNYFXemVzQo/Q5wbFs7qDbUO4S+1p4fETY0Mk6nnu18EyNdCXHPToLx1+0QdLHmOdMftgVr3rwvYOQErgy9GciQXbCtoV8dVVknTd7Lahr1DApwqVhOKyJ0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538117; c=relaxed/simple;
	bh=q+M8pAK93vzhowA2DZlzeNkV6+IdzOKtoY3k4WaVsTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZA+vKcEIQfcdvaKea1ZuUG9Cueie7NxqKqmoObtPZUkCNXpYzg1GoXglg1hYeMcRHS+Q+zK2D01OMBZDlpQw06oTW/0e/wwvXRH9ffpTWe/Cb1W+a+nQF/yRbGNc8Akx2RK1JutmKWZi6gGHD23LJlca1Ndq1qVAMwhbw77INk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pt67Kc2F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77415C4AF0C
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 07:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763538117;
	bh=q+M8pAK93vzhowA2DZlzeNkV6+IdzOKtoY3k4WaVsTE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pt67Kc2Fk2PSImK3q0T/RRv2T5kofkFIt/v1X+RCbUU+uGbKyVGtq37+2/BSve5HN
	 a1z3U1Q6pSk/2rsaOCxGQ0q4zR0TUTvEtNNV/cGUcpPpmVpVu8qSdfbRN6vQiGHwM0
	 TpvktNhsazuJj48lmamF0zipr2Ergr4ttMk+D3HrswC20gDAWd83TIWPMZP3ZCvc2o
	 F8szFFDP5uyQIZmTr/lGclWB+m8xe8cSG1y0ojFCo1ucHP96tTMhBGCqynkerj7ESx
	 NK0Z1ofCWM1++3f2cw47E3myFza+PbLQhkIdqquzjB+8BcjmRTAM2g2yi8DtGSn6Z6
	 S2kqtOsvD9KtQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso9729146a12.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:41:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXZIXS5DFYMSsanBddRcGY+DPVRyAicBwEZzU2rF+PpXQz1HRFScVMKmGmcA2hVmnmbRVg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA7PDnnUtXRel4vHBaZaV3lBXQtJoVPeSTOVsu80ezVGp4RNn2
	Q25uEuYJL9BVH9/wk+rGJ0DkzZWunNMdYJcHL0scSXQvx0iMAT2kfaWscGZ+aCOYmbuLqSwLSxd
	h8gQ/QpgwZULQ6XrKu+LpI04i7cqpp7I=
X-Google-Smtp-Source: AGHT+IH5PbHFy7SQADclvhkt/p7du3tmh3sfmEcVHooQlHiNoc2hfeXJOWIZLW4v82VRauSavd+AGz3Fr4UFydIhjVQ=
X-Received: by 2002:a17:907:1c81:b0:b73:42e5:a59e with SMTP id
 a640c23a62f3a-b73677edb7bmr1767735066b.12.1763538113330; Tue, 18 Nov 2025
 23:41:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118080656.2012805-1-maobibo@loongson.cn> <20251118080656.2012805-3-maobibo@loongson.cn>
 <CAAhV-H4hoS0Wo3TS+FdikXMkb7qjWNFSPDoajQr0bzdeROJwGw@mail.gmail.com>
 <db8a26ca-8430-9e7d-4ad1-9b7743c4cfd1@loongson.cn> <147fe837-5f81-4246-7d01-84b75cb94e6f@loongson.cn>
In-Reply-To: <147fe837-5f81-4246-7d01-84b75cb94e6f@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 19 Nov 2025 15:41:54 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7ij5pcr6i6q-eh-2nUzs-L2Wq79PaxMnE_t5a4w7=75A@mail.gmail.com>
X-Gm-Features: AWmQ_blo9K89j3uDki4PYxlv2C24lE5i_gVLytQcrrxj2URj4nf6q2IbqCsxLPc
Message-ID: <CAAhV-H7ij5pcr6i6q-eh-2nUzs-L2Wq79PaxMnE_t5a4w7=75A@mail.gmail.com>
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

On Wed, Nov 19, 2025 at 2:12=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/11/19 =E4=B8=8A=E5=8D=889:59, Bibo Mao wrote:
> >
> >
> > On 2025/11/18 =E4=B8=8B=E5=8D=888:48, Huacai Chen wrote:
> >> Hi, Bibo,
> >>
> >> On Tue, Nov 18, 2025 at 4:07=E2=80=AFPM Bibo Mao <maobibo@loongson.cn>=
 wrote:
> >>>
> >>> Function vcpu_is_preempted() is used to check whether vCPU is preempt=
ed
> >>> or not. Here add implementation with vcpu_is_preempted() when option
> >>> CONFIG_PARAVIRT is enabled.
> >>>
> >>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>> ---
> >>>   arch/loongarch/include/asm/smp.h      |  1 +
> >>>   arch/loongarch/include/asm/spinlock.h |  5 +++++
> >>>   arch/loongarch/kernel/paravirt.c      | 16 ++++++++++++++++
> >>>   arch/loongarch/kernel/smp.c           |  6 ++++++
> >>>   4 files changed, 28 insertions(+)
> >>>
> >>> diff --git a/arch/loongarch/include/asm/smp.h
> >>> b/arch/loongarch/include/asm/smp.h
> >>> index 3a47f52959a8..5b37f7bf2060 100644
> >>> --- a/arch/loongarch/include/asm/smp.h
> >>> +++ b/arch/loongarch/include/asm/smp.h
> >>> @@ -18,6 +18,7 @@ struct smp_ops {
> >>>          void (*init_ipi)(void);
> >>>          void (*send_ipi_single)(int cpu, unsigned int action);
> >>>          void (*send_ipi_mask)(const struct cpumask *mask, unsigned
> >>> int action);
> >>> +       bool (*vcpu_is_preempted)(int cpu);
> >>>   };
> >>>   extern struct smp_ops mp_ops;
> >>>
> >>> diff --git a/arch/loongarch/include/asm/spinlock.h
> >>> b/arch/loongarch/include/asm/spinlock.h
> >>> index 7cb3476999be..c001cef893aa 100644
> >>> --- a/arch/loongarch/include/asm/spinlock.h
> >>> +++ b/arch/loongarch/include/asm/spinlock.h
> >>> @@ -5,6 +5,11 @@
> >>>   #ifndef _ASM_SPINLOCK_H
> >>>   #define _ASM_SPINLOCK_H
> >>>
> >>> +#ifdef CONFIG_PARAVIRT
> >>> +#define vcpu_is_preempted      vcpu_is_preempted
> >>> +bool vcpu_is_preempted(int cpu);
> >>> +#endif
> >> Maybe paravirt.h is a better place?
> >
> > It is actually a little strange to add macro CONFIG_PARAVIRT in file
> > asm/spinlock.h
> >
> > vcpu_is_preempted is originally defined in header file
> > include/linux/sched.h like this
> > #ifndef vcpu_is_preempted
> > static inline bool vcpu_is_preempted(int cpu)
> > {
> >          return false;
> > }
> > #endif
> >
> > that requires that header file is included before sched.h, file
> > asm/spinlock.h can meet this requirement, however header file paravirt.=
h
> > maybe it is not included before sched.h in generic.
> >
> > Here vcpu_is_preempted definition is added before the following includi=
ng.
> >     #include <asm/processor.h>
> >     #include <asm/qspinlock.h>
> >     #include <asm/qrwlock.h>
> > Maybe it is better to be added after the above header files including
> > sentences, but need further investigation.
> >>
> >>> +
> >>>   #include <asm/processor.h>
> >>>   #include <asm/qspinlock.h>
> >>>   #include <asm/qrwlock.h>
> >>> diff --git a/arch/loongarch/kernel/paravirt.c
> >>> b/arch/loongarch/kernel/paravirt.c
> >>> index b1b51f920b23..b99404b6b13f 100644
> >>> --- a/arch/loongarch/kernel/paravirt.c
> >>> +++ b/arch/loongarch/kernel/paravirt.c
> >>> @@ -52,6 +52,13 @@ static u64 paravt_steal_clock(int cpu)
> >>>   #ifdef CONFIG_SMP
> >>>   static struct smp_ops native_ops;
> >>>
> >>> +static bool pv_vcpu_is_preempted(int cpu)
> >>> +{
> >>> +       struct kvm_steal_time *src =3D &per_cpu(steal_time, cpu);
> >>> +
> >>> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >>> +}
> >>> +
> >>>   static void pv_send_ipi_single(int cpu, unsigned int action)
> >>>   {
> >>>          int min, old;
> >>> @@ -308,6 +315,9 @@ int __init pv_time_init(void)
> >>>                  pr_err("Failed to install cpu hotplug callbacks\n");
> >>>                  return r;
> >>>          }
> >>> +
> >>> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
> >>> +               mp_ops.vcpu_is_preempted =3D pv_vcpu_is_preempted;
> >>>   #endif
> >>>
> >>>          static_call_update(pv_steal_clock, paravt_steal_clock);
> >>> @@ -332,3 +342,9 @@ int __init pv_spinlock_init(void)
> >>>
> >>>          return 0;
> >>>   }
> >>> +
> >>> +bool notrace vcpu_is_preempted(int cpu)
> >>> +{
> >>> +       return mp_ops.vcpu_is_preempted(cpu);
> >>> +}
> >>
> >> We can simplify the whole patch like this, then we don't need to touch
> >> smp.c, and we can merge Patch-2/3.
> >>
> >> +bool notrace vcpu_is_preempted(int cpu)
> >> +{
> >> +  if (!kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
> >> +     return false;
> >> + else {
> >> +     struct kvm_steal_time *src =3D &per_cpu(steal_time, cpu);
> >> +     return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >> + }
> >> +}
> > 1. there is assembly output about relative vcpu_is_preempted
> >   <loongson_vcpu_is_preempted>:
> >                 move    $r4,$r0
> >                 jirl    $r0,$r1,0
> >
> >   <pv_vcpu_is_preempted>:
> >          pcalau12i       $r13,8759(0x2237)
> >          slli.d  $r4,$r4,0x3
> >          addi.d  $r13,$r13,-1000(0xc18)
> >          ldx.d   $r13,$r13,$r4
> >          pcalau12i       $r12,5462(0x1556)
> >          addi.d  $r12,$r12,384(0x180)
> >          add.d   $r12,$r13,$r12
> >          ld.bu   $r4,$r12,16(0x10)
> >          andi    $r4,$r4,0x1
> >          jirl    $r0,$r1,0
> >
> >   <vcpu_is_preempted>:
> >          pcalau12i       $r12,8775(0x2247)
> >          ld.d    $r12,$r12,-472(0xe28)
> >          jirl    $r0,$r12,0
> >          andi    $r0,$r0,0x0
> >
> >   <vcpu_is_preempted_new>:
> >          pcalau12i       $r12,8151(0x1fd7)
> >          ld.d    $r12,$r12,-1008(0xc10)
> >          bstrpick.d      $r12,$r12,0x1a,0x1a
> >          beqz    $r12,188(0xbc) # 900000000024ec60
> >          pcalau12i       $r12,11802(0x2e1a)
> >          addi.d  $r12,$r12,-1400(0xa88)
> >          ldptr.w $r14,$r12,36(0x24)
> >          beqz    $r14,108(0x6c) # 900000000024ec20
> >          addi.w  $r13,$r0,1(0x1)
> >          bne     $r14,$r13,164(0xa4) # 900000000024ec60
> >          ldptr.w $r13,$r12,40(0x28)
> >          bnez    $r13,24(0x18) # 900000000024ebdc
> >          lu12i.w $r14,262144(0x40000)
> >          ori     $r14,$r14,0x4
> >          cpucfg  $r14,$r14
> >          slli.w  $r13,$r14,0x0
> >          st.w    $r14,$r12,40(0x28)
> >          bstrpick.d      $r13,$r13,0x3,0x3
> >          beqz    $r13,128(0x80) # 900000000024ec60
> >          pcalau12i       $r13,8759(0x2237)
> >          slli.d  $r4,$r4,0x3
> >          addi.d  $r13,$r13,-1000(0xc18)
> >          ldx.d   $r13,$r13,$r4
> >          pcalau12i       $r12,5462(0x1556)
> >          addi.d  $r12,$r12,384(0x180)
> >          add.d   $r12,$r13,$r12
> >          ld.bu   $r4,$r12,16(0x10)
> >          andi    $r4,$r4,0x1
> >          jirl    $r0,$r1,0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          lu12i.w $r13,262144(0x40000)
> >          cpucfg  $r13,$r13
> >          lu12i.w $r15,1237(0x4d5)
> >          ori     $r15,$r15,0x64b
> >          slli.w  $r13,$r13,0x0
> >          bne     $r13,$r15,-124(0x3ff84) # 900000000024ebb8
> >          addi.w  $r13,$r0,1(0x1)
> >          st.w    $r13,$r12,36(0x24)
> >          b       -128(0xfffff80) # 900000000024ebc0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          andi    $r0,$r0,0x0
> >          move    $r4,$r0
> >          jirl    $r0,$r1,0
> >
> > With vcpu_is_preempted(), there is one memory load and one jirl jump,
> > with vcpu_is_preempted_new(), there is two memory load and two beq
> > compare instructions.
> >
> > 2. In some scenery such nr_cpus =3D=3D 1, loongson_vcpu_is_preempted() =
is
> > better than pv_vcpu_is_preempted() even if the preempt feature is enabl=
ed.
> how about use static key and keep file smp.c untouched?
OK, it's better.

Huacai

> bool notrace vcpu_is_preempted(int cpu)
> {
>          struct kvm_steal_time *src;
>
>          if (!static_branch_unlikely(&virt_preempt_key))
>                  return false;
>
>          src =3D &per_cpu(steal_time, cpu);
>          return !!(src->preempted & KVM_VCPU_PREEMPTED);
> }
>
> it reduces one memory load, here is assembly output:
>   <vcpu_is_preempted>:
>          andi    $r0,$r0,0x0
>          move    $r4,$r0
>          jirl    $r0,$r1,0
>          andi    $r0,$r0,0x0
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
> Regards
> Bibo Mao
>
> >
> > Regards
> > Bibo Mao
> >> Huacai
> >>
> >>> +EXPORT_SYMBOL(vcpu_is_preempted);
> >>> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.=
c
> >>> index 46036d98da75..f04192fedf8d 100644
> >>> --- a/arch/loongarch/kernel/smp.c
> >>> +++ b/arch/loongarch/kernel/smp.c
> >>> @@ -307,10 +307,16 @@ static void loongson_init_ipi(void)
> >>>                  panic("IPI IRQ request failed\n");
> >>>   }
> >>>
> >>> +static bool loongson_vcpu_is_preempted(int cpu)
> >>> +{
> >>> +       return false;
> >>> +}
> >>> +
> >>>   struct smp_ops mp_ops =3D {
> >>>          .init_ipi               =3D loongson_init_ipi,
> >>>          .send_ipi_single        =3D loongson_send_ipi_single,
> >>>          .send_ipi_mask          =3D loongson_send_ipi_mask,
> >>> +       .vcpu_is_preempted      =3D loongson_vcpu_is_preempted,
> >>>   };
> >>>
> >>>   static void __init fdt_smp_setup(void)
> >>> --
> >>> 2.39.3
> >>>
> >>>
> >
>
>

