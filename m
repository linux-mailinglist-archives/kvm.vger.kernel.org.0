Return-Path: <kvm+bounces-16727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D51E48BCFE1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B0821F226B5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 14:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DFB13D271;
	Mon,  6 May 2024 14:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+zOpTel"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3B47FBCF;
	Mon,  6 May 2024 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715005082; cv=none; b=MhOk8GUTNIMNGQsd1QHhyjYtqM3oIfknAh+HKo5vOSjm9JMkMwtugiicxpFHArvXOvb81CLQMt6m/fGNZked0MmZzbgCVwti22rpapBtBBfl9inJnqId5eG9b2vADghlUuKyVsqLOzw0Te7fjarvnW/YJdtz0us9VpLSlDxR4rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715005082; c=relaxed/simple;
	bh=Xvk6WrXe1YX1h8Xjdky+G3FQGHi/PvJEX05UPmUJ500=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kwrsKledX4N6Zszanp/p+/o+Z4zF8GCRUqFZGkpqTbJswpreG6YtsdxO7yerSGQc4qbK4hm40Is3GO6+SqJqSV19X2pUqz3jI79WquHDPsDcZdbnhyZRdBswbiqsIdYLppoDh0eaEpIgRKlVZXPNUxtaVQHbjEkVtmDwP4YS5iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+zOpTel; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986ADC4AF65;
	Mon,  6 May 2024 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715005081;
	bh=Xvk6WrXe1YX1h8Xjdky+G3FQGHi/PvJEX05UPmUJ500=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U+zOpTelB53f2ggkk2VGRP0yVnmQsrkmOs3MJ348VnZgnEhVsuH7YuwHZ+OvDxR6z
	 od8lURCg+op7B4IR03S7gbiONxCYnsmvH5CRlWym8vh9OfUyhCgQCLSOHHphaRuRMg
	 SyvyBD/hC3MyVnSKbjtc7HjR/2FQcKinsZcXR9RIHvOsEW7WHmqHacl3+b5DZ3gVuM
	 g3tIaaFpHTFqeRzeWdE3yobabNf/vjHQBHkBybaDzHjlC5XiA7rPnkuoyyrYx4iCh3
	 E0cx9QkvA8PGYcOMpp3P1jWaUIKyd24WQ5XrjMfCx+aWWczyuECxhlrlBIIKD5+IYS
	 /ZgD3aTR391BA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a59c0a6415fso359284666b.1;
        Mon, 06 May 2024 07:18:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXxKQHG9eEDcjy5JcE8LEpG9XVzmb3KcZALe/iqDd6Pg94TxifppCs9lN/u15RTxHQKGtxoe/AVB6W8KnlL5gviemEbNtZv6hjvuqvum7lEOO2P0OZjUdH6ZVvooCd/CTbl
X-Gm-Message-State: AOJu0Yw6rw+7ZHn4pd7Tr4LbAA0LL4KnvPFoqiyqE4hfdwksmzwIvD/j
	C82IebBtcSZsig4DiWIiN6DVFUuhxabfHVvFz0IB/3ea9g1s6tPKyafWh1zG2/WvmQc/9rn70L3
	TKeGOeoWqbNAXh07tfFf8x+bD+co=
X-Google-Smtp-Source: AGHT+IEy6YOia8MFjRHnHVh9s9zaYj3mgiiHqNM4ppevzr8UN387NaXBAPcuJ8QcTgXgcHy73pnipf2WbgXHBp8tc3k=
X-Received: by 2002:a17:906:6ad3:b0:a58:a360:9ce4 with SMTP id
 q19-20020a1709066ad300b00a58a3609ce4mr6254704ejs.59.1715005080096; Mon, 06
 May 2024 07:18:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn> <20240428100518.1642324-5-maobibo@loongson.cn>
 <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
 <7335dcde-1b3a-1260-ac62-d2d9fcbd6a78@loongson.cn> <CAAhV-H5WJ0o3bJZBq2zx7ejjFkFwYVTyVJEzJuAHEs+uMg-sxw@mail.gmail.com>
 <b10b46ce-8219-8863-470f-9bfa173b22b0@loongson.cn> <CAAhV-H7fbrOXTtSwBmR3kyTW7yhsifycjynky4HPrUJiS9s=cg@mail.gmail.com>
 <540aa8dd-eada-1f77-0a20-38196fb5472a@loongson.cn> <CAAhV-H7o3oG2KXc2Ou0aWXTLPSNiM3evSB5Z-5dH4bLRd_P_0Q@mail.gmail.com>
 <61670353-90c6-6d0c-4430-7655b5251e17@loongson.cn>
In-Reply-To: <61670353-90c6-6d0c-4430-7655b5251e17@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 6 May 2024 22:17:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5wNmgxGincGE7cJ8WvrpKFauAJvMHrPttW-LrKB4UeHg@mail.gmail.com>
Message-ID: <CAAhV-H5wNmgxGincGE7cJ8WvrpKFauAJvMHrPttW-LrKB4UeHg@mail.gmail.com>
Subject: Re: [PATCH v8 4/6] LoongArch: KVM: Add vcpu search support from
 physical cpuid
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 6, 2024 at 6:05=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/5/6 =E4=B8=8B=E5=8D=885:40, Huacai Chen wrote:
> > On Mon, May 6, 2024 at 5:35=E2=80=AFPM maobibo <maobibo@loongson.cn> wr=
ote:
> >>
> >>
> >>
> >> On 2024/5/6 =E4=B8=8B=E5=8D=884:59, Huacai Chen wrote:
> >>> On Mon, May 6, 2024 at 4:18=E2=80=AFPM maobibo <maobibo@loongson.cn> =
wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2024/5/6 =E4=B8=8B=E5=8D=883:06, Huacai Chen wrote:
> >>>>> Hi, Bibo,
> >>>>>
> >>>>> On Mon, May 6, 2024 at 2:36=E2=80=AFPM maobibo <maobibo@loongson.cn=
> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2024/5/6 =E4=B8=8A=E5=8D=889:49, Huacai Chen wrote:
> >>>>>>> Hi, Bibo,
> >>>>>>>
> >>>>>>> On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loongso=
n.cn> wrote:
> >>>>>>>>
> >>>>>>>> Physical cpuid is used for interrupt routing for irqchips such a=
s
> >>>>>>>> ipi/msi/extioi interrupt controller. And physical cpuid is store=
d
> >>>>>>>> at CSR register LOONGARCH_CSR_CPUID, it can not be changed once =
vcpu
> >>>>>>>> is created and physical cpuid of two vcpus cannot be the same.
> >>>>>>>>
> >>>>>>>> Different irqchips have different size declaration about physica=
l cpuid,
> >>>>>>>> max cpuid value for CSR LOONGARCH_CSR_CPUID on 3A5000 is 512, ma=
x cpuid
> >>>>>>>> supported by IPI hardware is 1024, 256 for extioi irqchip, and 6=
5536
> >>>>>>>> for MSI irqchip.
> >>>>>>>>
> >>>>>>>> The smallest value from all interrupt controllers is selected no=
w,
> >>>>>>>> and the max cpuid size is defines as 256 by KVM which comes from
> >>>>>>>> extioi irqchip.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>>>> ---
> >>>>>>>>      arch/loongarch/include/asm/kvm_host.h | 26 ++++++++
> >>>>>>>>      arch/loongarch/include/asm/kvm_vcpu.h |  1 +
> >>>>>>>>      arch/loongarch/kvm/vcpu.c             | 93 ++++++++++++++++=
++++++++++-
> >>>>>>>>      arch/loongarch/kvm/vm.c               | 11 ++++
> >>>>>>>>      4 files changed, 130 insertions(+), 1 deletion(-)
> >>>>>>>>
> >>>>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loonga=
rch/include/asm/kvm_host.h
> >>>>>>>> index 2d62f7b0d377..3ba16ef1fe69 100644
> >>>>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>>>>>> @@ -64,6 +64,30 @@ struct kvm_world_switch {
> >>>>>>>>
> >>>>>>>>      #define MAX_PGTABLE_LEVELS     4
> >>>>>>>>
> >>>>>>>> +/*
> >>>>>>>> + * Physical cpu id is used for interrupt routing, there are dif=
ferent
> >>>>>>>> + * definitions about physical cpuid on different hardwares.
> >>>>>>>> + *  For LOONGARCH_CSR_CPUID register, max cpuid size if 512
> >>>>>>>> + *  For IPI HW, max dest CPUID size 1024
> >>>>>>>> + *  For extioi interrupt controller, max dest CPUID size is 256
> >>>>>>>> + *  For MSI interrupt controller, max supported CPUID size is 6=
5536
> >>>>>>>> + *
> >>>>>>>> + * Currently max CPUID is defined as 256 for KVM hypervisor, in=
 future
> >>>>>>>> + * it will be expanded to 4096, including 16 packages at most. =
And every
> >>>>>>>> + * package supports at most 256 vcpus
> >>>>>>>> + */
> >>>>>>>> +#define KVM_MAX_PHYID          256
> >>>>>>>> +
> >>>>>>>> +struct kvm_phyid_info {
> >>>>>>>> +       struct kvm_vcpu *vcpu;
> >>>>>>>> +       bool            enabled;
> >>>>>>>> +};
> >>>>>>>> +
> >>>>>>>> +struct kvm_phyid_map {
> >>>>>>>> +       int max_phyid;
> >>>>>>>> +       struct kvm_phyid_info phys_map[KVM_MAX_PHYID];
> >>>>>>>> +};
> >>>>>>>> +
> >>>>>>>>      struct kvm_arch {
> >>>>>>>>             /* Guest physical mm */
> >>>>>>>>             kvm_pte_t *pgd;
> >>>>>>>> @@ -71,6 +95,8 @@ struct kvm_arch {
> >>>>>>>>             unsigned long invalid_ptes[MAX_PGTABLE_LEVELS];
> >>>>>>>>             unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
> >>>>>>>>             unsigned int  root_level;
> >>>>>>>> +       spinlock_t    phyid_map_lock;
> >>>>>>>> +       struct kvm_phyid_map  *phyid_map;
> >>>>>>>>
> >>>>>>>>             s64 time_offset;
> >>>>>>>>             struct kvm_context __percpu *vmcs;
> >>>>>>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loonga=
rch/include/asm/kvm_vcpu.h
> >>>>>>>> index 0cb4fdb8a9b5..9f53950959da 100644
> >>>>>>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> >>>>>>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> >>>>>>>> @@ -81,6 +81,7 @@ void kvm_save_timer(struct kvm_vcpu *vcpu);
> >>>>>>>>      void kvm_restore_timer(struct kvm_vcpu *vcpu);
> >>>>>>>>
> >>>>>>>>      int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct =
kvm_interrupt *irq);
> >>>>>>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpu=
id);
> >>>>>>>>
> >>>>>>>>      /*
> >>>>>>>>       * Loongarch KVM guest interrupt handling
> >>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu=
.c
> >>>>>>>> index 3a8779065f73..b633fd28b8db 100644
> >>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>>>> @@ -274,6 +274,95 @@ static int _kvm_getcsr(struct kvm_vcpu *vcp=
u, unsigned int id, u64 *val)
> >>>>>>>>             return 0;
> >>>>>>>>      }
> >>>>>>>>
> >>>>>>>> +static inline int kvm_set_cpuid(struct kvm_vcpu *vcpu, u64 val)
> >>>>>>>> +{
> >>>>>>>> +       int cpuid;
> >>>>>>>> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> >>>>>>>> +       struct kvm_phyid_map  *map;
> >>>>>>>> +
> >>>>>>>> +       if (val >=3D KVM_MAX_PHYID)
> >>>>>>>> +               return -EINVAL;
> >>>>>>>> +
> >>>>>>>> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> >>>>>>>> +       map =3D vcpu->kvm->arch.phyid_map;
> >>>>>>>> +       spin_lock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>>> +       if (map->phys_map[cpuid].enabled) {
> >>>>>>>> +               /*
> >>>>>>>> +                * Cpuid is already set before
> >>>>>>>> +                * Forbid changing different cpuid at runtime
> >>>>>>>> +                */
> >>>>>>>> +               if (cpuid !=3D val) {
> >>>>>>>> +                       /*
> >>>>>>>> +                        * Cpuid 0 is initial value for vcpu, ma=
ybe invalid
> >>>>>>>> +                        * unset value for vcpu
> >>>>>>>> +                        */
> >>>>>>>> +                       if (cpuid) {
> >>>>>>>> +                               spin_unlock(&vcpu->kvm->arch.phy=
id_map_lock);
> >>>>>>>> +                               return -EINVAL;
> >>>>>>>> +                       }
> >>>>>>>> +               } else {
> >>>>>>>> +                        /* Discard duplicated cpuid set */
> >>>>>>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_l=
ock);
> >>>>>>>> +                       return 0;
> >>>>>>>> +               }
> >>>>>>>> +       }
> >>>>>>> I have changed the logic and comments when I apply, you can doubl=
e
> >>>>>>> check whether it is correct.
> >>>>>> I checkout the latest version, the modification in function
> >>>>>> kvm_set_cpuid() is good for me.
> >>>>> Now the modified version is like this:
> >>>>>
> >>>>> + if (map->phys_map[cpuid].enabled) {
> >>>>> + /* Discard duplicated CPUID set operation */
> >>>>> + if (cpuid =3D=3D val) {
> >>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>> + return 0;
> >>>>> + }
> >>>>> +
> >>>>> + /*
> >>>>> + * CPUID is already set before
> >>>>> + * Forbid changing different CPUID at runtime
> >>>>> + * But CPUID 0 is the initial value for vcpu, so allow
> >>>>> + * changing from 0 to others
> >>>>> + */
> >>>>> + if (cpuid) {
> >>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>> + return -EINVAL;
> >>>>> + }
> >>>>> + }
> >>>>> But I still doubt whether we should allow changing from 0 to others
> >>>>> while map->phys_map[cpuid].enabled is 1.
> >>>> It is necessary since the default sw cpuid is zero :-( And we can
> >>>> optimize it in later, such as set INVALID cpuid in function
> >>>> kvm_arch_vcpu_create() and logic will be simple in function kvm_set_=
cpuid().
> >>> In my opinion, if a vcpu with a uninitialized default physid=3D0, the=
n
> >>> map->phys_map[cpuid].enabled should be 0, then code won't come here.
> >>> And if a vcpu with a real physid=3D0, then map->phys_map[cpuid].enabl=
ed
> >>> is 1, but we shouldn't allow it to change physid in this case.
> >> yes, that is actually a problem.
> >>
> >> vcpu0 firstly set physid=3D0, and vcpu0 set physid=3D1 again is not al=
lowed.
> >> vcpu0 firstly set physid=3D0, and vcpu1 set physid=3D1 is allowed.
> >
> > So can we simply drop the if (cpuid) checking? That means:
> > + if (map->phys_map[cpuid].enabled) {
> > + /* Discard duplicated CPUID set operation */
> > + if (cpuid =3D=3D val) {
> > + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> > + return 0;
> > + }
> > +
> > + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> > + return -EINVAL;
> > + }
> yes, the similar modification such as following, since the secondary
> scenario should be allowed.
>   "vcpu0 firstly set physid=3D0, and vcpu1 set physid=3D1 is allowed thou=
gh
> default sw cpuid is zero"
>
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -272,7 +272,7 @@ static inline int kvm_set_cpuid(struct kvm_vcpu
> *vcpu, u64 val)
>          cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_CPUID);
>
>          spin_lock(&vcpu->kvm->arch.phyid_map_lock);
> -       if (map->phys_map[cpuid].enabled) {
> +       if ((cpuid !=3D KVM_MAX_PHYID) && map->phys_map[cpuid].enabled) {
>                  /* Discard duplicated CPUID set operation */
>                  if (cpuid =3D=3D val) {
>                          spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> @@ -282,13 +282,9 @@ static inline int kvm_set_cpuid(struct kvm_vcpu
> *vcpu, u64 val)
>                  /*
>                   * CPUID is already set before
>                   * Forbid changing different CPUID at runtime
> -                * But CPUID 0 is the initial value for vcpu, so allow
> -                * changing from 0 to others
>                   */
> -               if (cpuid) {
> -                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> -                       return -EINVAL;
> -               }
> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +               return -EINVAL;
>          }
>
>          if (map->phys_map[val].enabled) {
> @@ -1029,6 +1025,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>
>          /* Set cpuid */
>          kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TMID, vcpu->vcpu_id);
> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, KVM_MAX_PHYID);
>
>          /* Start with no pending virtual guest interrupts */
>          csr->csrs[LOONGARCH_CSR_GINTC] =3D 0;
Very nice, but I think kvm_drop_cpuid() should also set to KVM_MAX_PHYID.
Now I update my loongarch-kvm branch, you can test it again, and hope
it is in the perfect status.

Huacai
>
>
> >
> > Huacai
> >
> >>
> >>
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Regards
> >>>> Bibo Mao
> >>>>
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>>>
> >>>>>>>> +
> >>>>>>>> +       if (map->phys_map[val].enabled) {
> >>>>>>>> +               /*
> >>>>>>>> +                * New cpuid is already set with other vcpu
> >>>>>>>> +                * Forbid sharing the same cpuid between differe=
nt vcpus
> >>>>>>>> +                */
> >>>>>>>> +               if (map->phys_map[val].vcpu !=3D vcpu) {
> >>>>>>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_l=
ock);
> >>>>>>>> +                       return -EINVAL;
> >>>>>>>> +               }
> >>>>>>>> +
> >>>>>>>> +               /* Discard duplicated cpuid set operation*/
> >>>>>>>> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>>> +               return 0;
> >>>>>>>> +       }
> >>>>>>>> +
> >>>>>>>> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
> >>>>>>>> +       map->phys_map[val].enabled      =3D true;
> >>>>>>>> +       map->phys_map[val].vcpu         =3D vcpu;
> >>>>>>>> +       if (map->max_phyid < val)
> >>>>>>>> +               map->max_phyid =3D val;
> >>>>>>>> +       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>>> +       return 0;
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpu=
id)
> >>>>>>>> +{
> >>>>>>>> +       struct kvm_phyid_map  *map;
> >>>>>>>> +
> >>>>>>>> +       if (cpuid >=3D KVM_MAX_PHYID)
> >>>>>>>> +               return NULL;
> >>>>>>>> +
> >>>>>>>> +       map =3D kvm->arch.phyid_map;
> >>>>>>>> +       if (map->phys_map[cpuid].enabled)
> >>>>>>>> +               return map->phys_map[cpuid].vcpu;
> >>>>>>>> +
> >>>>>>>> +       return NULL;
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>> +static inline void kvm_drop_cpuid(struct kvm_vcpu *vcpu)
> >>>>>>>> +{
> >>>>>>>> +       int cpuid;
> >>>>>>>> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> >>>>>>>> +       struct kvm_phyid_map  *map;
> >>>>>>>> +
> >>>>>>>> +       map =3D vcpu->kvm->arch.phyid_map;
> >>>>>>>> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> >>>>>>>> +       if (cpuid >=3D KVM_MAX_PHYID)
> >>>>>>>> +               return;
> >>>>>>>> +
> >>>>>>>> +       if (map->phys_map[cpuid].enabled) {
> >>>>>>>> +               map->phys_map[cpuid].vcpu =3D NULL;
> >>>>>>>> +               map->phys_map[cpuid].enabled =3D false;
> >>>>>>>> +               kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, 0);
> >>>>>>>> +       }
> >>>>>>>> +}
> >>>>>>> While kvm_set_cpuid() is protected by a spinlock, do kvm_drop_cpu=
id()
> >>>>>>> and kvm_get_vcpu_by_cpuid() also need it?
> >>>>>>>
> >>>>>> It is good to me that spinlock is added in function kvm_drop_cpuid=
().
> >>>>>> And thinks for the efforts.
> >>>>>>
> >>>>>> Regards
> >>>>>> Bibo Mao
> >>>>>>>> +
> >>>>>>>>      static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int =
id, u64 val)
> >>>>>>>>      {
> >>>>>>>>             int ret =3D 0, gintc;
> >>>>>>>> @@ -291,7 +380,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu=
, unsigned int id, u64 val)
> >>>>>>>>                     kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gi=
ntc);
> >>>>>>>>
> >>>>>>>>                     return ret;
> >>>>>>>> -       }
> >>>>>>>> +       } else if (id =3D=3D LOONGARCH_CSR_CPUID)
> >>>>>>>> +               return kvm_set_cpuid(vcpu, val);
> >>>>>>>>
> >>>>>>>>             kvm_write_sw_gcsr(csr, id, val);
> >>>>>>>>
> >>>>>>>> @@ -943,6 +1033,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu =
*vcpu)
> >>>>>>>>             hrtimer_cancel(&vcpu->arch.swtimer);
> >>>>>>>>             kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache=
);
> >>>>>>>>             kfree(vcpu->arch.csr);
> >>>>>>>> +       kvm_drop_cpuid(vcpu);
> >>>>>>> I think this line should be before the above kfree(), otherwise y=
ou
> >>>>>>> get a "use after free".
> >>>>>>>
> >>>>>>> Huacai
> >>>>>>>
> >>>>>>>>
> >>>>>>>>             /*
> >>>>>>>>              * If the vCPU is freed and reused as another vCPU, =
we don't want the
> >>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >>>>>>>> index 0a37f6fa8f2d..6006a28653ad 100644
> >>>>>>>> --- a/arch/loongarch/kvm/vm.c
> >>>>>>>> +++ b/arch/loongarch/kvm/vm.c
> >>>>>>>> @@ -30,6 +30,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigne=
d long type)
> >>>>>>>>             if (!kvm->arch.pgd)
> >>>>>>>>                     return -ENOMEM;
> >>>>>>>>
> >>>>>>>> +       kvm->arch.phyid_map =3D kvzalloc(sizeof(struct kvm_phyid=
_map),
> >>>>>>>> +                               GFP_KERNEL_ACCOUNT);
> >>>>>>>> +       if (!kvm->arch.phyid_map) {
> >>>>>>>> +               free_page((unsigned long)kvm->arch.pgd);
> >>>>>>>> +               kvm->arch.pgd =3D NULL;
> >>>>>>>> +               return -ENOMEM;
> >>>>>>>> +       }
> >>>>>>>> +
> >>>>>>>>             kvm_init_vmcs(kvm);
> >>>>>>>>             kvm->arch.gpa_size =3D BIT(cpu_vabits - 1);
> >>>>>>>>             kvm->arch.root_level =3D CONFIG_PGTABLE_LEVELS - 1;
> >>>>>>>> @@ -44,6 +52,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned=
 long type)
> >>>>>>>>             for (i =3D 0; i <=3D kvm->arch.root_level; i++)
> >>>>>>>>                     kvm->arch.pte_shifts[i] =3D PAGE_SHIFT + i *=
 (PAGE_SHIFT - 3);
> >>>>>>>>
> >>>>>>>> +       spin_lock_init(&kvm->arch.phyid_map_lock);
> >>>>>>>>             return 0;
> >>>>>>>>      }
> >>>>>>>>
> >>>>>>>> @@ -51,7 +60,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >>>>>>>>      {
> >>>>>>>>             kvm_destroy_vcpus(kvm);
> >>>>>>>>             free_page((unsigned long)kvm->arch.pgd);
> >>>>>>>> +       kvfree(kvm->arch.phyid_map);
> >>>>>>>>             kvm->arch.pgd =3D NULL;
> >>>>>>>> +       kvm->arch.phyid_map =3D NULL;
> >>>>>>>>      }
> >>>>>>>>
> >>>>>>>>      int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >>>>>>>> --
> >>>>>>>> 2.39.3
> >>>>>>>>
> >>>>>>
> >>>>
> >>
>

