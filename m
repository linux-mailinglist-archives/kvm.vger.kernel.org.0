Return-Path: <kvm+bounces-63541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C34CC69750
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 13:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 2F19B2B462
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 12:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7A1238C16;
	Tue, 18 Nov 2025 12:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pjo54oMU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE3C217F27
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763470014; cv=none; b=onahtfpYdjYwrtEmqLTHRM0722dwQk5J3LFr0JBeazcqWwyqkoNu3WH1VR7O8AqE1NNbzb5q5G3doFt6FuJKKA5KJe34kZ+I/kc5teAsQuvDb6sy0ufoVEsTrJjG8rm5WRGVEN/i2gWRjX3rijSOhZbKfaoKGcR2ANHmWmILRng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763470014; c=relaxed/simple;
	bh=1Vx5zDIrUHe6525T1N4BHsoVznReo7/uJUmQjilLE5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtQ/UhuHfDKDkpjETAkTWyNJqMKbsnZbhdqHS6szM1G3ljUrB88/SfZNPSk3NHIQ49GX4j5h564OycFzEuSCwTqjc4mrdIQHR3s3qahB9G+0wRHWdMV83D/XxyT7wGjS5JJ4nVeLXj6i9JuaSVazgW0WepN63mLHXfg96TeAjLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pjo54oMU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF1FC4CEFB
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763470013;
	bh=1Vx5zDIrUHe6525T1N4BHsoVznReo7/uJUmQjilLE5w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Pjo54oMUS9XO2PRPjo5UH3GSpT0q60pUj+6blcR3Ms/i1OkhFZDKNPUIpbDhWq+SK
	 4T8q+A6R0aA1uEtMwlVymVt7jIoI9U+LkghMQ3kV7DsTwhuaIZ5on1UBfFpPUkb4Jh
	 HEhIHFyXycQOMrt1UHxAkM4f1SyiErBriuGs7BCznMG9/x1DBMskHgSGtqKFE6RADS
	 rK+YIZ/YQ1XrWaRSZ02u7Lk56qeUfxfhpqJg5ycWtrT123f4C/ef98rZBwFxBJ00+O
	 Vn9JROc/2iBDy+eoyqb8YJ+sYMByfq6U01vjmftHanuOlHesGxPsrS7Qftuhz0/qD5
	 l0fNp160ggc7A==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7370698a8eso541138566b.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 04:46:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWXwrUcv3Ektbge8gmtJmagL0dcCqIuM3GNmOrCkOA7K9aR62o7Uisy/C8FU9AUFmeIM3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9zCGWbbgm5OPPWsq8gR/eCN4BI8NUrEComLfw57oDPUFpyzb5
	UdwTl0CSg5K6YUuHp0X+V73yFI7U3LSDdv+yTGQ54zdBWH8hsmYotZ9KcW1pgDI1WE5PBjOvZHw
	5/hSr5mYIMPvf6BW5XifgDIwWSIqOnYk=
X-Google-Smtp-Source: AGHT+IGtdp36AFp+DoS6ZpCiCJV51yKskUUbXD/ZQmhyZaRqm+V1iZPjh1uXIfTOOK2SAbRhvMRcdW7sb918gxJJLhE=
X-Received: by 2002:a17:907:983:b0:b71:df18:9fb6 with SMTP id
 a640c23a62f3a-b736792f1dfmr1773592166b.26.1763470011118; Tue, 18 Nov 2025
 04:46:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118080656.2012805-1-maobibo@loongson.cn> <20251118080656.2012805-2-maobibo@loongson.cn>
In-Reply-To: <20251118080656.2012805-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 18 Nov 2025 20:46:52 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5qZ3_KTvkZ-zQni6Lg-6W5y9oBXDb9+2VAeFV82BEzhA@mail.gmail.com>
X-Gm-Features: AWmQ_bknqpyGjG5hIRRFCLAPFjiuy7TGEfINhZrD6MmsmDSsayAkFn1F04oiX-g
Message-ID: <CAAhV-H5qZ3_KTvkZ-zQni6Lg-6W5y9oBXDb9+2VAeFV82BEzhA@mail.gmail.com>
Subject: Re: [PATCH 1/3] LoongArch: KVM: Add preempt hint feature in
 hypervisor side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Tue, Nov 18, 2025 at 4:07=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Feature KVM_FEATURE_PREEMPT_HINT is added to show whether vCPU is
> preempted or not. It is to help guest OS scheduling or lock checking
> etc. Here add KVM_FEATURE_PREEMPT_HINT feature and use one byte as
> preempted flag in steal time structure.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h      |  2 +
>  arch/loongarch/include/asm/kvm_para.h      |  5 +-
>  arch/loongarch/include/uapi/asm/kvm.h      |  1 +
>  arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
>  arch/loongarch/kvm/vcpu.c                  | 54 +++++++++++++++++++++-
>  arch/loongarch/kvm/vm.c                    |  5 +-
>  6 files changed, 65 insertions(+), 3 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 0cecbd038bb3..04c6dd171877 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -163,6 +163,7 @@ enum emulation_result {
>  #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
>  #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |         \
>                                          BIT(KVM_FEATURE_STEAL_TIME) |  \
> +                                        BIT(KVM_FEATURE_PREEMPT_HINT) |\
>                                          BIT(KVM_FEATURE_USER_HCALL) |  \
>                                          BIT(KVM_FEATURE_VIRT_EXTIOI))
>
> @@ -250,6 +251,7 @@ struct kvm_vcpu_arch {
>                 u64 guest_addr;
>                 u64 last_steal;
>                 struct gfn_to_hva_cache cache;
> +               u8  preempted;
>         } st;
>  };
>
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/inclu=
de/asm/kvm_para.h
> index 3e4b397f423f..d8592a7f5922 100644
> --- a/arch/loongarch/include/asm/kvm_para.h
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -37,8 +37,11 @@ struct kvm_steal_time {
>         __u64 steal;
>         __u32 version;
>         __u32 flags;
> -       __u32 pad[12];
> +       __u8  preempted;
> +       __u8  u8_pad[3];
> +       __u32 pad[11];
Maybe a single __u8 pad[47] is enough?

>  };
> +#define KVM_VCPU_PREEMPTED             (1 << 0)
>
>  /*
>   * Hypercall interface for KVM hypervisor
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index 57ba1a563bb1..bca7154aa651 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -104,6 +104,7 @@ struct kvm_fpu {
>  #define  KVM_LOONGARCH_VM_FEAT_PV_IPI          6
>  #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    7
>  #define  KVM_LOONGARCH_VM_FEAT_PTW             8
> +#define KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT  10
From the name it is a "hint", from include/linux/kvm_para.h we know
features and hints are different. If preempt is really a feature,
rename it?

>
>  /* Device Control API on vcpu fd */
>  #define KVM_LOONGARCH_VCPU_CPUCFG      0
> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/=
include/uapi/asm/kvm_para.h
> index 76d802ef01ce..fe4107869ce6 100644
> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
> @@ -15,6 +15,7 @@
>  #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>  #define  KVM_FEATURE_IPI               1
>  #define  KVM_FEATURE_STEAL_TIME                2
> +#define  KVM_FEATURE_PREEMPT_HINT      3
>  /* BIT 24 - 31 are features configurable by user space vmm */
>  #define  KVM_FEATURE_VIRT_EXTIOI       24
>  #define  KVM_FEATURE_USER_HCALL                25
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 1245a6b35896..33a94b191b5d 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -180,6 +180,11 @@ static void kvm_update_stolen_time(struct kvm_vcpu *=
vcpu)
>         }
>
>         st =3D (struct kvm_steal_time __user *)ghc->hva;
> +       if (kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT_HINT)) {
> +               unsafe_put_user(0, &st->preempted, out);
> +               vcpu->arch.st.preempted =3D 0;
> +       }
> +
>         unsafe_get_user(version, &st->version, out);
>         if (version & 1)
>                 version +=3D 1; /* first time write, random junk */
> @@ -1757,11 +1762,58 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, i=
nt cpu)
>         return 0;
>  }
>
> +static void _kvm_set_vcpu_preempted(struct kvm_vcpu *vcpu)
Just using kvm_set_vcpu_preempted() is enough, no "_".

> +{
> +       struct gfn_to_hva_cache *ghc;
> +       struct kvm_steal_time __user *st;
> +       struct kvm_memslots *slots;
> +       static const u8 preempted =3D KVM_VCPU_PREEMPTED;
I'm not sure whether "static" is right, it's not reentrant.


Huacai

> +       gpa_t gpa;
> +
> +       gpa =3D vcpu->arch.st.guest_addr;
> +       if (!(gpa & KVM_STEAL_PHYS_VALID))
> +               return;
> +
> +       /* vCPU may be preempted for many times */
> +       if (vcpu->arch.st.preempted)
> +               return;
> +
> +       /* This happens on process exit */
> +       if (unlikely(current->mm !=3D vcpu->kvm->mm))
> +               return;
> +
> +       gpa &=3D KVM_STEAL_PHYS_MASK;
> +       ghc =3D &vcpu->arch.st.cache;
> +       slots =3D kvm_memslots(vcpu->kvm);
> +       if (slots->generation !=3D ghc->generation || gpa !=3D ghc->gpa) =
{
> +               if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof=
(*st))) {
> +                       ghc->gpa =3D INVALID_GPA;
> +                       return;
> +               }
> +       }
> +
> +       st =3D (struct kvm_steal_time __user *)ghc->hva;
> +       unsafe_put_user(preempted, &st->preempted, out);
> +       vcpu->arch.st.preempted =3D KVM_VCPU_PREEMPTED;
> +out:
> +       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->=
gpa));
> +}
> +
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> -       int cpu;
> +       int cpu, idx;
>         unsigned long flags;
>
> +       if (vcpu->preempted && kvm_guest_has_pv_feature(vcpu, KVM_FEATURE=
_PREEMPT_HINT)) {
> +               /*
> +                * Take the srcu lock as memslots will be accessed to che=
ck the gfn
> +                * cache generation against the memslots generation.
> +                */
> +               idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> +               _kvm_set_vcpu_preempted(vcpu);
> +               srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +       }
> +
>         local_irq_save(flags);
>         cpu =3D smp_processor_id();
>         vcpu->arch.last_sched_cpu =3D cpu;
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index a49b1c1a3dd1..b8879110a0a1 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -45,8 +45,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long ty=
pe)
>
>         /* Enable all PV features by default */
>         kvm->arch.pv_features =3D BIT(KVM_FEATURE_IPI);
> -       if (kvm_pvtime_supported())
> +       if (kvm_pvtime_supported()) {
>                 kvm->arch.pv_features |=3D BIT(KVM_FEATURE_STEAL_TIME);
> +               kvm->arch.pv_features |=3D BIT(KVM_FEATURE_PREEMPT_HINT);
> +       }
>
>         /*
>          * cpu_vabits means user address space only (a half of total).
> @@ -143,6 +145,7 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, s=
truct kvm_device_attr *attr
>         case KVM_LOONGARCH_VM_FEAT_PV_IPI:
>                 return 0;
>         case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
> +       case KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT:
>                 if (kvm_pvtime_supported())
>                         return 0;
>                 return -ENXIO;
> --
> 2.39.3
>
>

