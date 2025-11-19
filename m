Return-Path: <kvm+bounces-63662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4F4C6C82E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A3DFD34B401
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F3B2D978D;
	Wed, 19 Nov 2025 03:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qarWRPVT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDAF2D7801
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 03:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521282; cv=none; b=VzMON8pVzKdxPSK/eZ2WRuYJ3xd57DV34wIZREl7HV1lYesy/KTlbXZJa8wy+YF4ufb+XlEYxO1J2F+kpTFgecU5mYMt7+0oilMzm6ILgcowiyp5ZzIEHie/4CuAygt9F4mT95lbwzgC35vbES0RbNZ3z55AIsFX4lttObUneL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521282; c=relaxed/simple;
	bh=YpqXEiTQTnQOYkX1mEsSW3woNFXlfYBNVR9i4tbFVbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thw3qVq9g0MIMnjcifd/dWyEsFyNtWUGqKIRz2H8HNnLkRu2SkrHnjsVAPqApGzclY0YUF5N9RRzGc2ZPxjlQiba7ohi6FBDxlJvd5dfbf+Tb7cyo6nKi78XnAuK/jyy9CCXeslGIvbs2I4pKZnW5SroHeCy4em3+47gF5M9YBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qarWRPVT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA798C2BCB3
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 03:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763521282;
	bh=YpqXEiTQTnQOYkX1mEsSW3woNFXlfYBNVR9i4tbFVbg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qarWRPVTYr8oups362KNXdLdjaONJdeeJeY9bQ+T2noiHQU2Xu7HS91AIKPuHy60Q
	 9r3PPdlPaeqEm+fqXbVQxgFxJcNdfjBgIvo1mzEJ3S06OgCZWb7TGRQA58zStcKofr
	 jz/Wbc7qWdJZXoxbFSgU6hlVfnVSmss75eWCYRaGRoUGnjSz3+jvSBZ4T8K0P2cc+Z
	 zf6FHeUKWSyKbJtDPIhbr214KU8YKqzZ1tiuX/gAzG+AdBXZ9XGUq23RM0y+Tv2Tw0
	 57hjR7zyERe+vTuwanALotwySh2aN8EDY1WQWoAl5y72tJfbaG8YW69zXwB5nJ0xow
	 t0D5yXfyBBTJw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso9469236a12.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 19:01:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXNPwNWefjxuioy/p5cPbLtGaFjuqholhEbojQUUjUcHLB+rIMl3zXJPFd90gdjU3dy18c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJwTn+d6HyxM65fA5742yMD+bTIH9J9Ro3LihbvaloXDocVUEh
	VAI4ONIgWwW/jYMjhl5+NAm1U9HImK8q/8375Fn/YuKNbsQvCLP28wTlkrfQ0cO/vrDEcwUZxQ8
	NMyP0o1XuB6eIbwYmTFpOsjpf5ssyReg=
X-Google-Smtp-Source: AGHT+IE06CvU/lqvbDNenJDcRDs4e3fMwZo0uMVwr+4mWc6B5V5wPWBMJaJFz0Km0UgWeMvFtAAqbGl4CC8SEHn6414=
X-Received: by 2002:a17:906:f5a9:b0:b73:8307:4e95 with SMTP id
 a640c23a62f3a-b7383075af5mr1513062966b.4.1763521279920; Tue, 18 Nov 2025
 19:01:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118080656.2012805-1-maobibo@loongson.cn> <20251118080656.2012805-2-maobibo@loongson.cn>
 <CAAhV-H5qZ3_KTvkZ-zQni6Lg-6W5y9oBXDb9+2VAeFV82BEzhA@mail.gmail.com>
 <3e36f507-a907-7143-41a7-58dbefb73fb5@loongson.cn> <CAAhV-H7CEhk9tNGr9sOzhoPAE+UtA2AtogBg8+HQCko31YUc2A@mail.gmail.com>
 <f8ad1ecb-0272-f027-807c-98d2511c2871@loongson.cn>
In-Reply-To: <f8ad1ecb-0272-f027-807c-98d2511c2871@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 19 Nov 2025 11:01:21 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4VOEbQLe0nPS99u_cQBbJOPi2eCQA+=0dAvQ4dT6-gpA@mail.gmail.com>
X-Gm-Features: AWmQ_bkxFdrcGpDKLiAMYl3FxtPvc17TS2rEvqSnkVWEfocZBZwLD7is6mGJv2U
Message-ID: <CAAhV-H4VOEbQLe0nPS99u_cQBbJOPi2eCQA+=0dAvQ4dT6-gpA@mail.gmail.com>
Subject: Re: [PATCH 1/3] LoongArch: KVM: Add preempt hint feature in
 hypervisor side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 10:58=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
>
>
> On 2025/11/19 =E4=B8=8A=E5=8D=8810:45, Huacai Chen wrote:
> > On Wed, Nov 19, 2025 at 9:23=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2025/11/18 =E4=B8=8B=E5=8D=888:46, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Tue, Nov 18, 2025 at 4:07=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> Feature KVM_FEATURE_PREEMPT_HINT is added to show whether vCPU is
> >>>> preempted or not. It is to help guest OS scheduling or lock checking
> >>>> etc. Here add KVM_FEATURE_PREEMPT_HINT feature and use one byte as
> >>>> preempted flag in steal time structure.
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/asm/kvm_host.h      |  2 +
> >>>>    arch/loongarch/include/asm/kvm_para.h      |  5 +-
> >>>>    arch/loongarch/include/uapi/asm/kvm.h      |  1 +
> >>>>    arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
> >>>>    arch/loongarch/kvm/vcpu.c                  | 54 +++++++++++++++++=
++++-
> >>>>    arch/loongarch/kvm/vm.c                    |  5 +-
> >>>>    6 files changed, 65 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/=
include/asm/kvm_host.h
> >>>> index 0cecbd038bb3..04c6dd171877 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>> @@ -163,6 +163,7 @@ enum emulation_result {
> >>>>    #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
> >>>>    #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |   =
      \
> >>>>                                            BIT(KVM_FEATURE_STEAL_TIM=
E) |  \
> >>>> +                                        BIT(KVM_FEATURE_PREEMPT_HIN=
T) |\
> >>>>                                            BIT(KVM_FEATURE_USER_HCAL=
L) |  \
> >>>>                                            BIT(KVM_FEATURE_VIRT_EXTI=
OI))
> >>>>
> >>>> @@ -250,6 +251,7 @@ struct kvm_vcpu_arch {
> >>>>                   u64 guest_addr;
> >>>>                   u64 last_steal;
> >>>>                   struct gfn_to_hva_cache cache;
> >>>> +               u8  preempted;
> >>>>           } st;
> >>>>    };
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/=
include/asm/kvm_para.h
> >>>> index 3e4b397f423f..d8592a7f5922 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_para.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_para.h
> >>>> @@ -37,8 +37,11 @@ struct kvm_steal_time {
> >>>>           __u64 steal;
> >>>>           __u32 version;
> >>>>           __u32 flags;
> >>>> -       __u32 pad[12];
> >>>> +       __u8  preempted;
> >>>> +       __u8  u8_pad[3];
> >>>> +       __u32 pad[11];
> >>> Maybe a single __u8 pad[47] is enough?
> >> yes, pad[47] seems better unless there is definitely __u32 type
> >> requirement in future.
> >>
> >> Will do in next version.
> >>>
> >>>>    };
> >>>> +#define KVM_VCPU_PREEMPTED             (1 << 0)
> >>>>
> >>>>    /*
> >>>>     * Hypercall interface for KVM hypervisor
> >>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/=
include/uapi/asm/kvm.h
> >>>> index 57ba1a563bb1..bca7154aa651 100644
> >>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>> @@ -104,6 +104,7 @@ struct kvm_fpu {
> >>>>    #define  KVM_LOONGARCH_VM_FEAT_PV_IPI          6
> >>>>    #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    7
> >>>>    #define  KVM_LOONGARCH_VM_FEAT_PTW             8
> >>>> +#define KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT  10
> >>>   From the name it is a "hint", from include/linux/kvm_para.h we know
> >>> features and hints are different. If preempt is really a feature,
> >>> rename it?
> >> It is a feature. yes, in generic hint is suggestion for VM and VM can
> >> selectively do or not.
> >>
> >> Will rename it with KVM_LOONGARCH_VM_FEAT_PV_PREEMPT.
> >>>
> >>>>
> >>>>    /* Device Control API on vcpu fd */
> >>>>    #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>>> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loong=
arch/include/uapi/asm/kvm_para.h
> >>>> index 76d802ef01ce..fe4107869ce6 100644
> >>>> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
> >>>> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
> >>>> @@ -15,6 +15,7 @@
> >>>>    #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> >>>>    #define  KVM_FEATURE_IPI               1
> >>>>    #define  KVM_FEATURE_STEAL_TIME                2
> >>>> +#define  KVM_FEATURE_PREEMPT_HINT      3
> >>>>    /* BIT 24 - 31 are features configurable by user space vmm */
> >>>>    #define  KVM_FEATURE_VIRT_EXTIOI       24
> >>>>    #define  KVM_FEATURE_USER_HCALL                25
> >>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>> index 1245a6b35896..33a94b191b5d 100644
> >>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>> @@ -180,6 +180,11 @@ static void kvm_update_stolen_time(struct kvm_v=
cpu *vcpu)
> >>>>           }
> >>>>
> >>>>           st =3D (struct kvm_steal_time __user *)ghc->hva;
> >>>> +       if (kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT_HINT)=
) {
> >>>> +               unsafe_put_user(0, &st->preempted, out);
> >>>> +               vcpu->arch.st.preempted =3D 0;
> >>>> +       }
> >>>> +
> >>>>           unsafe_get_user(version, &st->version, out);
> >>>>           if (version & 1)
> >>>>                   version +=3D 1; /* first time write, random junk *=
/
> >>>> @@ -1757,11 +1762,58 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vc=
pu, int cpu)
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> +static void _kvm_set_vcpu_preempted(struct kvm_vcpu *vcpu)
> >>> Just using kvm_set_vcpu_preempted() is enough, no "_".
> >>>
> >>>> +{
> >>>> +       struct gfn_to_hva_cache *ghc;
> >>>> +       struct kvm_steal_time __user *st;
> >>>> +       struct kvm_memslots *slots;
> >>>> +       static const u8 preempted =3D KVM_VCPU_PREEMPTED;
> >>> I'm not sure whether "static" is right, it's not reentrant.
> >> I think static is better here, it saves one cycle with assignment here=
.
> > I know, but I want to know whether the logic is correct.
> > vcpu->arch.st.preempted is per-cpu, but the local variable "preempted"
> > can be used across multiple VCPU? I'm not sure.
> It is read-only, of course can be used by multiple vCPUs. or remove it
> directly?
Good, remove it directly.

Huacai
>
> @@ -1767,7 +1767,6 @@ static void _kvm_set_vcpu_preempted(struct
> kvm_vcpu *vcpu)
>          struct gfn_to_hva_cache *ghc;
>          struct kvm_steal_time __user *st;
>          struct kvm_memslots *slots;
> -       static const u8 preempted =3D KVM_VCPU_PREEMPTED;
>          gpa_t gpa;
>
>          gpa =3D vcpu->arch.st.guest_addr;
> @@ -1793,7 +1792,7 @@ static void _kvm_set_vcpu_preempted(struct
> kvm_vcpu *vcpu)
>          }
>
>          st =3D (struct kvm_steal_time __user *)ghc->hva;
> -       unsafe_put_user(preempted, &st->preempted, out);
> +       unsafe_put_user(KVM_VCPU_PREEMPTED, &st->preempted, out);
>          vcpu->arch.st.preempted =3D KVM_VCPU_PREEMPTED;
>
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>>
> >>> Huacai
> >>>
> >>>> +       gpa_t gpa;
> >>>> +
> >>>> +       gpa =3D vcpu->arch.st.guest_addr;
> >>>> +       if (!(gpa & KVM_STEAL_PHYS_VALID))
> >>>> +               return;
> >>>> +
> >>>> +       /* vCPU may be preempted for many times */
> >>>> +       if (vcpu->arch.st.preempted)
> >>>> +               return;
> >>>> +
> >>>> +       /* This happens on process exit */
> >>>> +       if (unlikely(current->mm !=3D vcpu->kvm->mm))
> >>>> +               return;
> >>>> +
> >>>> +       gpa &=3D KVM_STEAL_PHYS_MASK;
> >>>> +       ghc =3D &vcpu->arch.st.cache;
> >>>> +       slots =3D kvm_memslots(vcpu->kvm);
> >>>> +       if (slots->generation !=3D ghc->generation || gpa !=3D ghc->=
gpa) {
> >>>> +               if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, s=
izeof(*st))) {
> >>>> +                       ghc->gpa =3D INVALID_GPA;
> >>>> +                       return;
> >>>> +               }
> >>>> +       }
> >>>> +
> >>>> +       st =3D (struct kvm_steal_time __user *)ghc->hva;
> >>>> +       unsafe_put_user(preempted, &st->preempted, out);
> >>>> +       vcpu->arch.st.preempted =3D KVM_VCPU_PREEMPTED;
> >>>> +out:
> >>>> +       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(=
ghc->gpa));
> >>>> +}
> >>>> +
> >>>>    void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >>>>    {
> >>>> -       int cpu;
> >>>> +       int cpu, idx;
> >>>>           unsigned long flags;
> >>>>
> >>>> +       if (vcpu->preempted && kvm_guest_has_pv_feature(vcpu, KVM_FE=
ATURE_PREEMPT_HINT)) {
> >>>> +               /*
> >>>> +                * Take the srcu lock as memslots will be accessed t=
o check the gfn
> >>>> +                * cache generation against the memslots generation.
> >>>> +                */
> >>>> +               idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> >>>> +               _kvm_set_vcpu_preempted(vcpu);
> >>>> +               srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >>>> +       }
> >>>> +
> >>>>           local_irq_save(flags);
> >>>>           cpu =3D smp_processor_id();
> >>>>           vcpu->arch.last_sched_cpu =3D cpu;
> >>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >>>> index a49b1c1a3dd1..b8879110a0a1 100644
> >>>> --- a/arch/loongarch/kvm/vm.c
> >>>> +++ b/arch/loongarch/kvm/vm.c
> >>>> @@ -45,8 +45,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
> >>>>
> >>>>           /* Enable all PV features by default */
> >>>>           kvm->arch.pv_features =3D BIT(KVM_FEATURE_IPI);
> >>>> -       if (kvm_pvtime_supported())
> >>>> +       if (kvm_pvtime_supported()) {
> >>>>                   kvm->arch.pv_features |=3D BIT(KVM_FEATURE_STEAL_T=
IME);
> >>>> +               kvm->arch.pv_features |=3D BIT(KVM_FEATURE_PREEMPT_H=
INT);
> >>>> +       }
> >>>>
> >>>>           /*
> >>>>            * cpu_vabits means user address space only (a half of tot=
al).
> >>>> @@ -143,6 +145,7 @@ static int kvm_vm_feature_has_attr(struct kvm *k=
vm, struct kvm_device_attr *attr
> >>>>           case KVM_LOONGARCH_VM_FEAT_PV_IPI:
> >>>>                   return 0;
> >>>>           case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
> >>>> +       case KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT:
> >>>>                   if (kvm_pvtime_supported())
> >>>>                           return 0;
> >>>>                   return -ENXIO;
> >>>> --
> >>>> 2.39.3
> >>>>
> >>>>
> >>
> >>
>
>

