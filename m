Return-Path: <kvm+bounces-16601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A27B98BC595
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 03:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6113C282351
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 01:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0475E3D984;
	Mon,  6 May 2024 01:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZQWdlG7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2751F1FC4;
	Mon,  6 May 2024 01:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714960194; cv=none; b=lQqIkRYtD2dUzg1VOUkJN6Z7djkxMWl6EextpnxCuzW4NPHPwwKX6Aa9WR5j+6UyX3OQQ6laS5JP4RDKNtLFpakewpMiI/kNQvFHcw02tjShmrgQod7niRdY3jg28xyLQq7x1LdRAArbruDl7dvtc44CdD2j2EyjjbhwKJO2dCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714960194; c=relaxed/simple;
	bh=gYQGZyOiQYHIZ1WrvLkBT/wTJ55iEU1mQbEjApORefk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2xoqjS/+HJmAD0VoifZCe2c8NGynmHC1xFVWKmc+txNX5/i+fa+f/dLYwIMVf8Dnu8XtMOJWaH4Vl9+bmMfjNUsAdU4o0Jz2CPu0hWDIynaKReGHX6aEiNlrLYMtI6jlxZzeyXXwLV5O24u2774u4A/PmrvtJNL40YmIjFyJ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZQWdlG7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FACC4DDE1;
	Mon,  6 May 2024 01:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714960193;
	bh=gYQGZyOiQYHIZ1WrvLkBT/wTJ55iEU1mQbEjApORefk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tZQWdlG7XiPCj1bx4y466g4mE7uXFtYGuY2AjqDkLJ/EqedxPdNO6q6y0tEbxMINN
	 RGzmD3S1fvbiyEaPy0nYYeV9IrGSlrb41o6v06iqa1p8nGdZgDsi2uWYm+jbgGTbDQ
	 c6GBYVm18sU1QlM9/UrM6Q8rGoTMe7h7EW9KVbnZrArsR/wSZy+4fG39hnevp9t33n
	 PNqOKVX18u/ZComuuWtedOCLGOssmEWEtvFiR0cFce7aEYT72HlTdQySejhgoJOMsO
	 ODlR3M1aj/G1jBBAgJAj/VRVb2oVegKSvqfeZiDzTaLAs0h+O+zLWqkBRMT3JDeGCu
	 OjSTpUvjtgAUg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a59a387fbc9so301066066b.1;
        Sun, 05 May 2024 18:49:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVqxQ01PYMzmZNFdiPbtF9UEX3qgB5VvfCFa9vmzhLw6m+sBW2ubWfi3rwKQUGb490m6Pn80NqkDK7Q5XgGNV6llEqAtcV5B349XH8Lr0jyDkJ4uv19pqZ93BWltJMhz7gO
X-Gm-Message-State: AOJu0YwzeLeLl6FN4QXlq3XG0a5SC0AM56Ca0eLLew1ocUbIwMe7TOJ3
	nJVbyGi1rNaXQkATN1AhFev7VjhYvuFE9rjissoLs+zXXwOCh0abqpfZsPmv2VrDuCmCFFDeIt4
	N0TSIpyChO8jV9Sebl4SZq6aRfrw=
X-Google-Smtp-Source: AGHT+IGTNGyPz70vBGDD1ALG+YqXxy7Bv7g2vDP7TCoJoDC6AlHMjWCYZzuLvBcS+7zqLq2kFrYmzjb2MaVGcFsVS6U=
X-Received: by 2002:a17:907:60ce:b0:a59:9e55:7489 with SMTP id
 hv14-20020a17090760ce00b00a599e557489mr4977187ejc.25.1714960192238; Sun, 05
 May 2024 18:49:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn> <20240428100518.1642324-5-maobibo@loongson.cn>
In-Reply-To: <20240428100518.1642324-5-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 6 May 2024 09:49:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
Message-ID: <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
Subject: Re: [PATCH v8 4/6] LoongArch: KVM: Add vcpu search support from
 physical cpuid
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Physical cpuid is used for interrupt routing for irqchips such as
> ipi/msi/extioi interrupt controller. And physical cpuid is stored
> at CSR register LOONGARCH_CSR_CPUID, it can not be changed once vcpu
> is created and physical cpuid of two vcpus cannot be the same.
>
> Different irqchips have different size declaration about physical cpuid,
> max cpuid value for CSR LOONGARCH_CSR_CPUID on 3A5000 is 512, max cpuid
> supported by IPI hardware is 1024, 256 for extioi irqchip, and 65536
> for MSI irqchip.
>
> The smallest value from all interrupt controllers is selected now,
> and the max cpuid size is defines as 256 by KVM which comes from
> extioi irqchip.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h | 26 ++++++++
>  arch/loongarch/include/asm/kvm_vcpu.h |  1 +
>  arch/loongarch/kvm/vcpu.c             | 93 ++++++++++++++++++++++++++-
>  arch/loongarch/kvm/vm.c               | 11 ++++
>  4 files changed, 130 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 2d62f7b0d377..3ba16ef1fe69 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -64,6 +64,30 @@ struct kvm_world_switch {
>
>  #define MAX_PGTABLE_LEVELS     4
>
> +/*
> + * Physical cpu id is used for interrupt routing, there are different
> + * definitions about physical cpuid on different hardwares.
> + *  For LOONGARCH_CSR_CPUID register, max cpuid size if 512
> + *  For IPI HW, max dest CPUID size 1024
> + *  For extioi interrupt controller, max dest CPUID size is 256
> + *  For MSI interrupt controller, max supported CPUID size is 65536
> + *
> + * Currently max CPUID is defined as 256 for KVM hypervisor, in future
> + * it will be expanded to 4096, including 16 packages at most. And every
> + * package supports at most 256 vcpus
> + */
> +#define KVM_MAX_PHYID          256
> +
> +struct kvm_phyid_info {
> +       struct kvm_vcpu *vcpu;
> +       bool            enabled;
> +};
> +
> +struct kvm_phyid_map {
> +       int max_phyid;
> +       struct kvm_phyid_info phys_map[KVM_MAX_PHYID];
> +};
> +
>  struct kvm_arch {
>         /* Guest physical mm */
>         kvm_pte_t *pgd;
> @@ -71,6 +95,8 @@ struct kvm_arch {
>         unsigned long invalid_ptes[MAX_PGTABLE_LEVELS];
>         unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
>         unsigned int  root_level;
> +       spinlock_t    phyid_map_lock;
> +       struct kvm_phyid_map  *phyid_map;
>
>         s64 time_offset;
>         struct kvm_context __percpu *vmcs;
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inclu=
de/asm/kvm_vcpu.h
> index 0cb4fdb8a9b5..9f53950959da 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -81,6 +81,7 @@ void kvm_save_timer(struct kvm_vcpu *vcpu);
>  void kvm_restore_timer(struct kvm_vcpu *vcpu);
>
>  int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt=
 *irq);
> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid);
>
>  /*
>   * Loongarch KVM guest interrupt handling
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 3a8779065f73..b633fd28b8db 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -274,6 +274,95 @@ static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsign=
ed int id, u64 *val)
>         return 0;
>  }
>
> +static inline int kvm_set_cpuid(struct kvm_vcpu *vcpu, u64 val)
> +{
> +       int cpuid;
> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> +       struct kvm_phyid_map  *map;
> +
> +       if (val >=3D KVM_MAX_PHYID)
> +               return -EINVAL;
> +
> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> +       map =3D vcpu->kvm->arch.phyid_map;
> +       spin_lock(&vcpu->kvm->arch.phyid_map_lock);
> +       if (map->phys_map[cpuid].enabled) {
> +               /*
> +                * Cpuid is already set before
> +                * Forbid changing different cpuid at runtime
> +                */
> +               if (cpuid !=3D val) {
> +                       /*
> +                        * Cpuid 0 is initial value for vcpu, maybe inval=
id
> +                        * unset value for vcpu
> +                        */
> +                       if (cpuid) {
> +                               spin_unlock(&vcpu->kvm->arch.phyid_map_lo=
ck);
> +                               return -EINVAL;
> +                       }
> +               } else {
> +                        /* Discard duplicated cpuid set */
> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +                       return 0;
> +               }
> +       }
I have changed the logic and comments when I apply, you can double
check whether it is correct.

> +
> +       if (map->phys_map[val].enabled) {
> +               /*
> +                * New cpuid is already set with other vcpu
> +                * Forbid sharing the same cpuid between different vcpus
> +                */
> +               if (map->phys_map[val].vcpu !=3D vcpu) {
> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +                       return -EINVAL;
> +               }
> +
> +               /* Discard duplicated cpuid set operation*/
> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +               return 0;
> +       }
> +
> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
> +       map->phys_map[val].enabled      =3D true;
> +       map->phys_map[val].vcpu         =3D vcpu;
> +       if (map->max_phyid < val)
> +               map->max_phyid =3D val;
> +       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> +       return 0;
> +}
> +
> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid)
> +{
> +       struct kvm_phyid_map  *map;
> +
> +       if (cpuid >=3D KVM_MAX_PHYID)
> +               return NULL;
> +
> +       map =3D kvm->arch.phyid_map;
> +       if (map->phys_map[cpuid].enabled)
> +               return map->phys_map[cpuid].vcpu;
> +
> +       return NULL;
> +}
> +
> +static inline void kvm_drop_cpuid(struct kvm_vcpu *vcpu)
> +{
> +       int cpuid;
> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> +       struct kvm_phyid_map  *map;
> +
> +       map =3D vcpu->kvm->arch.phyid_map;
> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> +       if (cpuid >=3D KVM_MAX_PHYID)
> +               return;
> +
> +       if (map->phys_map[cpuid].enabled) {
> +               map->phys_map[cpuid].vcpu =3D NULL;
> +               map->phys_map[cpuid].enabled =3D false;
> +               kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, 0);
> +       }
> +}
While kvm_set_cpuid() is protected by a spinlock, do kvm_drop_cpuid()
and kvm_get_vcpu_by_cpuid() also need it?

> +
>  static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>  {
>         int ret =3D 0, gintc;
> @@ -291,7 +380,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigne=
d int id, u64 val)
>                 kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
>
>                 return ret;
> -       }
> +       } else if (id =3D=3D LOONGARCH_CSR_CPUID)
> +               return kvm_set_cpuid(vcpu, val);
>
>         kvm_write_sw_gcsr(csr, id, val);
>
> @@ -943,6 +1033,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         hrtimer_cancel(&vcpu->arch.swtimer);
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>         kfree(vcpu->arch.csr);
> +       kvm_drop_cpuid(vcpu);
I think this line should be before the above kfree(), otherwise you
get a "use after free".

Huacai

>
>         /*
>          * If the vCPU is freed and reused as another vCPU, we don't want=
 the
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index 0a37f6fa8f2d..6006a28653ad 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -30,6 +30,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long ty=
pe)
>         if (!kvm->arch.pgd)
>                 return -ENOMEM;
>
> +       kvm->arch.phyid_map =3D kvzalloc(sizeof(struct kvm_phyid_map),
> +                               GFP_KERNEL_ACCOUNT);
> +       if (!kvm->arch.phyid_map) {
> +               free_page((unsigned long)kvm->arch.pgd);
> +               kvm->arch.pgd =3D NULL;
> +               return -ENOMEM;
> +       }
> +
>         kvm_init_vmcs(kvm);
>         kvm->arch.gpa_size =3D BIT(cpu_vabits - 1);
>         kvm->arch.root_level =3D CONFIG_PGTABLE_LEVELS - 1;
> @@ -44,6 +52,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long typ=
e)
>         for (i =3D 0; i <=3D kvm->arch.root_level; i++)
>                 kvm->arch.pte_shifts[i] =3D PAGE_SHIFT + i * (PAGE_SHIFT =
- 3);
>
> +       spin_lock_init(&kvm->arch.phyid_map_lock);
>         return 0;
>  }
>
> @@ -51,7 +60,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>         kvm_destroy_vcpus(kvm);
>         free_page((unsigned long)kvm->arch.pgd);
> +       kvfree(kvm->arch.phyid_map);
>         kvm->arch.pgd =3D NULL;
> +       kvm->arch.phyid_map =3D NULL;
>  }
>
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> --
> 2.39.3
>

