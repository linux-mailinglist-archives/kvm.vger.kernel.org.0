Return-Path: <kvm+bounces-16700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBEF58BCA29
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3489B22B80
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E331428E5;
	Mon,  6 May 2024 08:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/4cA/9N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C3B142640;
	Mon,  6 May 2024 08:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714985987; cv=none; b=ru9VZGJvCC0Swc3Dz+AwJTzQTsM0YnpzDOTRYtaF7t9lE00wdoH5WaE1AGmPKAT8cME0kaGpg7ZGC2j4QwZGy5N9AZaTnC3aazBt+rYe6maCGZP49yLF6+MJSnEi+j02BxQJW5p6G3yuc51iUv9jlpjGCWOK3B7LUmMwPX+weLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714985987; c=relaxed/simple;
	bh=kKgCCQl76dsTDB1fovUVe3NUeA5TdV00aINCZ8bzN/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tu3tLZYPeKkI5SXSSq0Soja8WEWa9A+10zRR/ZdsxFE55CDEHTOKUpKUJ73V7Zbd9ZhDpPHcZhJrk+hpo7IQ3/b61Sb46yA+amfDpNKZggdIwa0A1cU1ShGJN4JLEt9AOs13BLkA5n/j2zjGTVAx0gVTj37iT4Jdz5CHjcdJuyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/4cA/9N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F50C4DDE1;
	Mon,  6 May 2024 08:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714985987;
	bh=kKgCCQl76dsTDB1fovUVe3NUeA5TdV00aINCZ8bzN/0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k/4cA/9NbwXs6PBYVhFUSXWI3rGD28Us+kYR5r0fGoJnIwnxLEehyQ84/87/7vQe4
	 wC4IOeQt5f/1OSIuS5+W2vI8wc+whxjBniTXWKYgQ9FAbQ5LiGH1JMfELqTNRu5/aN
	 vfo8lbwouCGY41UCJeemZ3MRF0F//WA+Aqsu+ySN2O47r7rvwvI34U5Gnd/U+gzMQd
	 l+IXWeOHf8t6+a5tRFv+hD/kgVeUc2Aex0A2f/LqGlvMEuQPLLuCnK55qNDc3/9TNA
	 GXz3cr0klmDyguhXHK1JkmRZB+RJ+xmq42MFO9DtcSF75uut2E5VAgcd7VZjps4uyf
	 h5UG+doA+XSbQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a59cdf7cd78so160958166b.0;
        Mon, 06 May 2024 01:59:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHNpmWjj32ELrHBQWW12tGlNuP48Ut93vggdnugxC2t6oBeiTGXNV1AgJ0eQg0aWs+fZbsupxfKQDFQoxNa0HI93sN7gKrmMIir8KeEASZQIWw0UxChNiR/BLeTZHzXb2A
X-Gm-Message-State: AOJu0YxWMkhd+5vRVlU3+yZh1dNV/zQCrkvMm8dIUwf6MvJgO39vE0Vi
	vG39kbSOIQX9QVW1mDh5odaBhQ9rr1EjgwNFGNqY7/GV9YXDKKFJIPkaBkpdjeqkBoLYHVskzfb
	o/ulSHh30FJah6yjFEspH19EU05Q=
X-Google-Smtp-Source: AGHT+IFfyIJkHZBpoIQfgKPtkyTVFePXgIjM7sAoYKk244Jvv/WO+XVe6t5C25Yl5z7WDShYY8upxxsFMzgcfp7rLTo=
X-Received: by 2002:a17:907:9493:b0:a59:bae0:b12a with SMTP id
 dm19-20020a170907949300b00a59bae0b12amr2859611ejc.63.1714985985407; Mon, 06
 May 2024 01:59:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn> <20240428100518.1642324-5-maobibo@loongson.cn>
 <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
 <7335dcde-1b3a-1260-ac62-d2d9fcbd6a78@loongson.cn> <CAAhV-H5WJ0o3bJZBq2zx7ejjFkFwYVTyVJEzJuAHEs+uMg-sxw@mail.gmail.com>
 <b10b46ce-8219-8863-470f-9bfa173b22b0@loongson.cn>
In-Reply-To: <b10b46ce-8219-8863-470f-9bfa173b22b0@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 6 May 2024 16:59:36 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7fbrOXTtSwBmR3kyTW7yhsifycjynky4HPrUJiS9s=cg@mail.gmail.com>
Message-ID: <CAAhV-H7fbrOXTtSwBmR3kyTW7yhsifycjynky4HPrUJiS9s=cg@mail.gmail.com>
Subject: Re: [PATCH v8 4/6] LoongArch: KVM: Add vcpu search support from
 physical cpuid
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 6, 2024 at 4:18=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/5/6 =E4=B8=8B=E5=8D=883:06, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Mon, May 6, 2024 at 2:36=E2=80=AFPM maobibo <maobibo@loongson.cn> wr=
ote:
> >>
> >>
> >>
> >> On 2024/5/6 =E4=B8=8A=E5=8D=889:49, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> Physical cpuid is used for interrupt routing for irqchips such as
> >>>> ipi/msi/extioi interrupt controller. And physical cpuid is stored
> >>>> at CSR register LOONGARCH_CSR_CPUID, it can not be changed once vcpu
> >>>> is created and physical cpuid of two vcpus cannot be the same.
> >>>>
> >>>> Different irqchips have different size declaration about physical cp=
uid,
> >>>> max cpuid value for CSR LOONGARCH_CSR_CPUID on 3A5000 is 512, max cp=
uid
> >>>> supported by IPI hardware is 1024, 256 for extioi irqchip, and 65536
> >>>> for MSI irqchip.
> >>>>
> >>>> The smallest value from all interrupt controllers is selected now,
> >>>> and the max cpuid size is defines as 256 by KVM which comes from
> >>>> extioi irqchip.
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/asm/kvm_host.h | 26 ++++++++
> >>>>    arch/loongarch/include/asm/kvm_vcpu.h |  1 +
> >>>>    arch/loongarch/kvm/vcpu.c             | 93 ++++++++++++++++++++++=
++++-
> >>>>    arch/loongarch/kvm/vm.c               | 11 ++++
> >>>>    4 files changed, 130 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/=
include/asm/kvm_host.h
> >>>> index 2d62f7b0d377..3ba16ef1fe69 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>> @@ -64,6 +64,30 @@ struct kvm_world_switch {
> >>>>
> >>>>    #define MAX_PGTABLE_LEVELS     4
> >>>>
> >>>> +/*
> >>>> + * Physical cpu id is used for interrupt routing, there are differe=
nt
> >>>> + * definitions about physical cpuid on different hardwares.
> >>>> + *  For LOONGARCH_CSR_CPUID register, max cpuid size if 512
> >>>> + *  For IPI HW, max dest CPUID size 1024
> >>>> + *  For extioi interrupt controller, max dest CPUID size is 256
> >>>> + *  For MSI interrupt controller, max supported CPUID size is 65536
> >>>> + *
> >>>> + * Currently max CPUID is defined as 256 for KVM hypervisor, in fut=
ure
> >>>> + * it will be expanded to 4096, including 16 packages at most. And =
every
> >>>> + * package supports at most 256 vcpus
> >>>> + */
> >>>> +#define KVM_MAX_PHYID          256
> >>>> +
> >>>> +struct kvm_phyid_info {
> >>>> +       struct kvm_vcpu *vcpu;
> >>>> +       bool            enabled;
> >>>> +};
> >>>> +
> >>>> +struct kvm_phyid_map {
> >>>> +       int max_phyid;
> >>>> +       struct kvm_phyid_info phys_map[KVM_MAX_PHYID];
> >>>> +};
> >>>> +
> >>>>    struct kvm_arch {
> >>>>           /* Guest physical mm */
> >>>>           kvm_pte_t *pgd;
> >>>> @@ -71,6 +95,8 @@ struct kvm_arch {
> >>>>           unsigned long invalid_ptes[MAX_PGTABLE_LEVELS];
> >>>>           unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
> >>>>           unsigned int  root_level;
> >>>> +       spinlock_t    phyid_map_lock;
> >>>> +       struct kvm_phyid_map  *phyid_map;
> >>>>
> >>>>           s64 time_offset;
> >>>>           struct kvm_context __percpu *vmcs;
> >>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/=
include/asm/kvm_vcpu.h
> >>>> index 0cb4fdb8a9b5..9f53950959da 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> >>>> @@ -81,6 +81,7 @@ void kvm_save_timer(struct kvm_vcpu *vcpu);
> >>>>    void kvm_restore_timer(struct kvm_vcpu *vcpu);
> >>>>
> >>>>    int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_in=
terrupt *irq);
> >>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid);
> >>>>
> >>>>    /*
> >>>>     * Loongarch KVM guest interrupt handling
> >>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>> index 3a8779065f73..b633fd28b8db 100644
> >>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>> @@ -274,6 +274,95 @@ static int _kvm_getcsr(struct kvm_vcpu *vcpu, u=
nsigned int id, u64 *val)
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> +static inline int kvm_set_cpuid(struct kvm_vcpu *vcpu, u64 val)
> >>>> +{
> >>>> +       int cpuid;
> >>>> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> >>>> +       struct kvm_phyid_map  *map;
> >>>> +
> >>>> +       if (val >=3D KVM_MAX_PHYID)
> >>>> +               return -EINVAL;
> >>>> +
> >>>> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> >>>> +       map =3D vcpu->kvm->arch.phyid_map;
> >>>> +       spin_lock(&vcpu->kvm->arch.phyid_map_lock);
> >>>> +       if (map->phys_map[cpuid].enabled) {
> >>>> +               /*
> >>>> +                * Cpuid is already set before
> >>>> +                * Forbid changing different cpuid at runtime
> >>>> +                */
> >>>> +               if (cpuid !=3D val) {
> >>>> +                       /*
> >>>> +                        * Cpuid 0 is initial value for vcpu, maybe =
invalid
> >>>> +                        * unset value for vcpu
> >>>> +                        */
> >>>> +                       if (cpuid) {
> >>>> +                               spin_unlock(&vcpu->kvm->arch.phyid_m=
ap_lock);
> >>>> +                               return -EINVAL;
> >>>> +                       }
> >>>> +               } else {
> >>>> +                        /* Discard duplicated cpuid set */
> >>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock)=
;
> >>>> +                       return 0;
> >>>> +               }
> >>>> +       }
> >>> I have changed the logic and comments when I apply, you can double
> >>> check whether it is correct.
> >> I checkout the latest version, the modification in function
> >> kvm_set_cpuid() is good for me.
> > Now the modified version is like this:
> >
> > + if (map->phys_map[cpuid].enabled) {
> > + /* Discard duplicated CPUID set operation */
> > + if (cpuid =3D=3D val) {
> > + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> > + return 0;
> > + }
> > +
> > + /*
> > + * CPUID is already set before
> > + * Forbid changing different CPUID at runtime
> > + * But CPUID 0 is the initial value for vcpu, so allow
> > + * changing from 0 to others
> > + */
> > + if (cpuid) {
> > + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> > + return -EINVAL;
> > + }
> > + }
> > But I still doubt whether we should allow changing from 0 to others
> > while map->phys_map[cpuid].enabled is 1.
> It is necessary since the default sw cpuid is zero :-( And we can
> optimize it in later, such as set INVALID cpuid in function
> kvm_arch_vcpu_create() and logic will be simple in function kvm_set_cpuid=
().
In my opinion, if a vcpu with a uninitialized default physid=3D0, then
map->phys_map[cpuid].enabled should be 0, then code won't come here.
And if a vcpu with a real physid=3D0, then map->phys_map[cpuid].enabled
is 1, but we shouldn't allow it to change physid in this case.

Huacai

>
> Regards
> Bibo Mao
>
> >
> > Huacai
> >
> >>>
> >>>> +
> >>>> +       if (map->phys_map[val].enabled) {
> >>>> +               /*
> >>>> +                * New cpuid is already set with other vcpu
> >>>> +                * Forbid sharing the same cpuid between different v=
cpus
> >>>> +                */
> >>>> +               if (map->phys_map[val].vcpu !=3D vcpu) {
> >>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock)=
;
> >>>> +                       return -EINVAL;
> >>>> +               }
> >>>> +
> >>>> +               /* Discard duplicated cpuid set operation*/
> >>>> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>> +               return 0;
> >>>> +       }
> >>>> +
> >>>> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
> >>>> +       map->phys_map[val].enabled      =3D true;
> >>>> +       map->phys_map[val].vcpu         =3D vcpu;
> >>>> +       if (map->max_phyid < val)
> >>>> +               map->max_phyid =3D val;
> >>>> +       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid)
> >>>> +{
> >>>> +       struct kvm_phyid_map  *map;
> >>>> +
> >>>> +       if (cpuid >=3D KVM_MAX_PHYID)
> >>>> +               return NULL;
> >>>> +
> >>>> +       map =3D kvm->arch.phyid_map;
> >>>> +       if (map->phys_map[cpuid].enabled)
> >>>> +               return map->phys_map[cpuid].vcpu;
> >>>> +
> >>>> +       return NULL;
> >>>> +}
> >>>> +
> >>>> +static inline void kvm_drop_cpuid(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +       int cpuid;
> >>>> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> >>>> +       struct kvm_phyid_map  *map;
> >>>> +
> >>>> +       map =3D vcpu->kvm->arch.phyid_map;
> >>>> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> >>>> +       if (cpuid >=3D KVM_MAX_PHYID)
> >>>> +               return;
> >>>> +
> >>>> +       if (map->phys_map[cpuid].enabled) {
> >>>> +               map->phys_map[cpuid].vcpu =3D NULL;
> >>>> +               map->phys_map[cpuid].enabled =3D false;
> >>>> +               kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, 0);
> >>>> +       }
> >>>> +}
> >>> While kvm_set_cpuid() is protected by a spinlock, do kvm_drop_cpuid()
> >>> and kvm_get_vcpu_by_cpuid() also need it?
> >>>
> >> It is good to me that spinlock is added in function kvm_drop_cpuid().
> >> And thinks for the efforts.
> >>
> >> Regards
> >> Bibo Mao
> >>>> +
> >>>>    static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u6=
4 val)
> >>>>    {
> >>>>           int ret =3D 0, gintc;
> >>>> @@ -291,7 +380,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, un=
signed int id, u64 val)
> >>>>                   kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
> >>>>
> >>>>                   return ret;
> >>>> -       }
> >>>> +       } else if (id =3D=3D LOONGARCH_CSR_CPUID)
> >>>> +               return kvm_set_cpuid(vcpu, val);
> >>>>
> >>>>           kvm_write_sw_gcsr(csr, id, val);
> >>>>
> >>>> @@ -943,6 +1033,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcp=
u)
> >>>>           hrtimer_cancel(&vcpu->arch.swtimer);
> >>>>           kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> >>>>           kfree(vcpu->arch.csr);
> >>>> +       kvm_drop_cpuid(vcpu);
> >>> I think this line should be before the above kfree(), otherwise you
> >>> get a "use after free".
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>>           /*
> >>>>            * If the vCPU is freed and reused as another vCPU, we don=
't want the
> >>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >>>> index 0a37f6fa8f2d..6006a28653ad 100644
> >>>> --- a/arch/loongarch/kvm/vm.c
> >>>> +++ b/arch/loongarch/kvm/vm.c
> >>>> @@ -30,6 +30,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
> >>>>           if (!kvm->arch.pgd)
> >>>>                   return -ENOMEM;
> >>>>
> >>>> +       kvm->arch.phyid_map =3D kvzalloc(sizeof(struct kvm_phyid_map=
),
> >>>> +                               GFP_KERNEL_ACCOUNT);
> >>>> +       if (!kvm->arch.phyid_map) {
> >>>> +               free_page((unsigned long)kvm->arch.pgd);
> >>>> +               kvm->arch.pgd =3D NULL;
> >>>> +               return -ENOMEM;
> >>>> +       }
> >>>> +
> >>>>           kvm_init_vmcs(kvm);
> >>>>           kvm->arch.gpa_size =3D BIT(cpu_vabits - 1);
> >>>>           kvm->arch.root_level =3D CONFIG_PGTABLE_LEVELS - 1;
> >>>> @@ -44,6 +52,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
> >>>>           for (i =3D 0; i <=3D kvm->arch.root_level; i++)
> >>>>                   kvm->arch.pte_shifts[i] =3D PAGE_SHIFT + i * (PAGE=
_SHIFT - 3);
> >>>>
> >>>> +       spin_lock_init(&kvm->arch.phyid_map_lock);
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> @@ -51,7 +60,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >>>>    {
> >>>>           kvm_destroy_vcpus(kvm);
> >>>>           free_page((unsigned long)kvm->arch.pgd);
> >>>> +       kvfree(kvm->arch.phyid_map);
> >>>>           kvm->arch.pgd =3D NULL;
> >>>> +       kvm->arch.phyid_map =3D NULL;
> >>>>    }
> >>>>
> >>>>    int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
>

