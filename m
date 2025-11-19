Return-Path: <kvm+bounces-63653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C8824C6C6C8
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0BF1B36100E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7052BD02A;
	Wed, 19 Nov 2025 02:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aS0uvsVu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5147428469F
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763520340; cv=none; b=UOn3t2WeoDypWuUxevSkVtHHxSV98t56n3uBJdf8XeXbItkncKvJfWHOBfLkOdvZNT0iXUhpY66Q5vF17DUCPjwVSF5rwY5GSTgvVC8GwXWrUMfnXh7gaiazdedVlw8P9l68HVHTtMZrFOmwNvi5cDPaTsqHdQoIhNNJHQOozgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763520340; c=relaxed/simple;
	bh=J9sCTJushm1JHHtB6DJLn0P4W4jTBlrxYzkyXFYtnaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n9vOB+MXIzkyVfBFTHs8cMiGpF3uVPLoj0tt23ZoY9EsqCVdL6G9HNMTEZ28uqP84RYqck8ZsrUsPLPd6OCrF3j0OjrLabtU2Brqo+7MkC2YqLGnJktbJEDK4PX27YGPEv/7bh+2BU6UBArS1iANrl6UWcEk1y/g6P4Jz5NbtZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aS0uvsVu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D48C2BCB0
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763520339;
	bh=J9sCTJushm1JHHtB6DJLn0P4W4jTBlrxYzkyXFYtnaA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aS0uvsVuGwHn385CEdmtoCixs28aCXGvhgOkDVa/rJPfM+KbC1yEbnI+wawNcRHju
	 xgOFT4qobb86r7X6W18Nz0O+SeR0xt7SgTq1/+AHbg4W1NyDoBZq+O2szIMpKJ8hlU
	 6gInCawI4KFQ502+kl1R9+Ic6NQGMMYNM8brRC4XXfbXLor5Eb0UfXwOi/uOrJ4qL9
	 lgCnXsBjdnTS+upfNt8xZzrIW8Rw8DDNV2dAKCebzmqcJm7GMuZtq9LUbkucwk6wLh
	 /+1m1F2n6MdX84NGUn6uDbD7H5njQNbgUSRGhWLkHSZ6fvJD7k/KIoqMHv3xnzjH33
	 6tfDaywon1nww==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso1091201a12.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:45:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWy3TVn1jMrrM463A/Qpa+D5i4r6NVLonFuAV/lDsIqd4ENhigCElP5Npx4hkCh34UDk6g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykb8mAT0nv0//G9rtelqsmTLT8OUQ+xYwisa40tIcE2Yjc8eV1
	iSq18stJB6kLjO8+hTs2eaxNFMouF+8jRgcsXK+yAuLTTpz8ElaTQixAzgLciW+tBXR88dI/syI
	/aUZmXWDj+Zvl6bOTvebMclDNnxBpjF8=
X-Google-Smtp-Source: AGHT+IH3/s7TABBHGBByfn70c9SOGW4Huj9ScJRicXimBItjFikcJqF8E58IZO+US5VRdo6IpLtpAUKwZIC38p6/twE=
X-Received: by 2002:a17:906:c10b:b0:b73:5acd:4650 with SMTP id
 a640c23a62f3a-b7367896a70mr1998629666b.23.1763520337513; Tue, 18 Nov 2025
 18:45:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118080656.2012805-1-maobibo@loongson.cn> <20251118080656.2012805-2-maobibo@loongson.cn>
 <CAAhV-H5qZ3_KTvkZ-zQni6Lg-6W5y9oBXDb9+2VAeFV82BEzhA@mail.gmail.com> <3e36f507-a907-7143-41a7-58dbefb73fb5@loongson.cn>
In-Reply-To: <3e36f507-a907-7143-41a7-58dbefb73fb5@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 19 Nov 2025 10:45:39 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7CEhk9tNGr9sOzhoPAE+UtA2AtogBg8+HQCko31YUc2A@mail.gmail.com>
X-Gm-Features: AWmQ_bm-fzfP3zdiaHHSi_2QvYUOWVFqpMZ0UORDO4Pt-qaWemZzxWXfO4R-488
Message-ID: <CAAhV-H7CEhk9tNGr9sOzhoPAE+UtA2AtogBg8+HQCko31YUc2A@mail.gmail.com>
Subject: Re: [PATCH 1/3] LoongArch: KVM: Add preempt hint feature in
 hypervisor side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 9:23=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/11/18 =E4=B8=8B=E5=8D=888:46, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Tue, Nov 18, 2025 at 4:07=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Feature KVM_FEATURE_PREEMPT_HINT is added to show whether vCPU is
> >> preempted or not. It is to help guest OS scheduling or lock checking
> >> etc. Here add KVM_FEATURE_PREEMPT_HINT feature and use one byte as
> >> preempted flag in steal time structure.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_host.h      |  2 +
> >>   arch/loongarch/include/asm/kvm_para.h      |  5 +-
> >>   arch/loongarch/include/uapi/asm/kvm.h      |  1 +
> >>   arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
> >>   arch/loongarch/kvm/vcpu.c                  | 54 ++++++++++++++++++++=
+-
> >>   arch/loongarch/kvm/vm.c                    |  5 +-
> >>   6 files changed, 65 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index 0cecbd038bb3..04c6dd171877 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -163,6 +163,7 @@ enum emulation_result {
> >>   #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
> >>   #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |      =
   \
> >>                                           BIT(KVM_FEATURE_STEAL_TIME) =
|  \
> >> +                                        BIT(KVM_FEATURE_PREEMPT_HINT)=
 |\
> >>                                           BIT(KVM_FEATURE_USER_HCALL) =
|  \
> >>                                           BIT(KVM_FEATURE_VIRT_EXTIOI)=
)
> >>
> >> @@ -250,6 +251,7 @@ struct kvm_vcpu_arch {
> >>                  u64 guest_addr;
> >>                  u64 last_steal;
> >>                  struct gfn_to_hva_cache cache;
> >> +               u8  preempted;
> >>          } st;
> >>   };
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/in=
clude/asm/kvm_para.h
> >> index 3e4b397f423f..d8592a7f5922 100644
> >> --- a/arch/loongarch/include/asm/kvm_para.h
> >> +++ b/arch/loongarch/include/asm/kvm_para.h
> >> @@ -37,8 +37,11 @@ struct kvm_steal_time {
> >>          __u64 steal;
> >>          __u32 version;
> >>          __u32 flags;
> >> -       __u32 pad[12];
> >> +       __u8  preempted;
> >> +       __u8  u8_pad[3];
> >> +       __u32 pad[11];
> > Maybe a single __u8 pad[47] is enough?
> yes, pad[47] seems better unless there is definitely __u32 type
> requirement in future.
>
> Will do in next version.
> >
> >>   };
> >> +#define KVM_VCPU_PREEMPTED             (1 << 0)
> >>
> >>   /*
> >>    * Hypercall interface for KVM hypervisor
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/in=
clude/uapi/asm/kvm.h
> >> index 57ba1a563bb1..bca7154aa651 100644
> >> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >> @@ -104,6 +104,7 @@ struct kvm_fpu {
> >>   #define  KVM_LOONGARCH_VM_FEAT_PV_IPI          6
> >>   #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    7
> >>   #define  KVM_LOONGARCH_VM_FEAT_PTW             8
> >> +#define KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT  10
> >  From the name it is a "hint", from include/linux/kvm_para.h we know
> > features and hints are different. If preempt is really a feature,
> > rename it?
> It is a feature. yes, in generic hint is suggestion for VM and VM can
> selectively do or not.
>
> Will rename it with KVM_LOONGARCH_VM_FEAT_PV_PREEMPT.
> >
> >>
> >>   /* Device Control API on vcpu fd */
> >>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongar=
ch/include/uapi/asm/kvm_para.h
> >> index 76d802ef01ce..fe4107869ce6 100644
> >> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
> >> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
> >> @@ -15,6 +15,7 @@
> >>   #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> >>   #define  KVM_FEATURE_IPI               1
> >>   #define  KVM_FEATURE_STEAL_TIME                2
> >> +#define  KVM_FEATURE_PREEMPT_HINT      3
> >>   /* BIT 24 - 31 are features configurable by user space vmm */
> >>   #define  KVM_FEATURE_VIRT_EXTIOI       24
> >>   #define  KVM_FEATURE_USER_HCALL                25
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 1245a6b35896..33a94b191b5d 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -180,6 +180,11 @@ static void kvm_update_stolen_time(struct kvm_vcp=
u *vcpu)
> >>          }
> >>
> >>          st =3D (struct kvm_steal_time __user *)ghc->hva;
> >> +       if (kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_PREEMPT_HINT)) =
{
> >> +               unsafe_put_user(0, &st->preempted, out);
> >> +               vcpu->arch.st.preempted =3D 0;
> >> +       }
> >> +
> >>          unsafe_get_user(version, &st->version, out);
> >>          if (version & 1)
> >>                  version +=3D 1; /* first time write, random junk */
> >> @@ -1757,11 +1762,58 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu=
, int cpu)
> >>          return 0;
> >>   }
> >>
> >> +static void _kvm_set_vcpu_preempted(struct kvm_vcpu *vcpu)
> > Just using kvm_set_vcpu_preempted() is enough, no "_".
> >
> >> +{
> >> +       struct gfn_to_hva_cache *ghc;
> >> +       struct kvm_steal_time __user *st;
> >> +       struct kvm_memslots *slots;
> >> +       static const u8 preempted =3D KVM_VCPU_PREEMPTED;
> > I'm not sure whether "static" is right, it's not reentrant.
> I think static is better here, it saves one cycle with assignment here.
I know, but I want to know whether the logic is correct.
vcpu->arch.st.preempted is per-cpu, but the local variable "preempted"
can be used across multiple VCPU? I'm not sure.

Huacai

>
> Regards
> Bibo Mao
> >
> >
> > Huacai
> >
> >> +       gpa_t gpa;
> >> +
> >> +       gpa =3D vcpu->arch.st.guest_addr;
> >> +       if (!(gpa & KVM_STEAL_PHYS_VALID))
> >> +               return;
> >> +
> >> +       /* vCPU may be preempted for many times */
> >> +       if (vcpu->arch.st.preempted)
> >> +               return;
> >> +
> >> +       /* This happens on process exit */
> >> +       if (unlikely(current->mm !=3D vcpu->kvm->mm))
> >> +               return;
> >> +
> >> +       gpa &=3D KVM_STEAL_PHYS_MASK;
> >> +       ghc =3D &vcpu->arch.st.cache;
> >> +       slots =3D kvm_memslots(vcpu->kvm);
> >> +       if (slots->generation !=3D ghc->generation || gpa !=3D ghc->gp=
a) {
> >> +               if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, siz=
eof(*st))) {
> >> +                       ghc->gpa =3D INVALID_GPA;
> >> +                       return;
> >> +               }
> >> +       }
> >> +
> >> +       st =3D (struct kvm_steal_time __user *)ghc->hva;
> >> +       unsafe_put_user(preempted, &st->preempted, out);
> >> +       vcpu->arch.st.preempted =3D KVM_VCPU_PREEMPTED;
> >> +out:
> >> +       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(gh=
c->gpa));
> >> +}
> >> +
> >>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >>   {
> >> -       int cpu;
> >> +       int cpu, idx;
> >>          unsigned long flags;
> >>
> >> +       if (vcpu->preempted && kvm_guest_has_pv_feature(vcpu, KVM_FEAT=
URE_PREEMPT_HINT)) {
> >> +               /*
> >> +                * Take the srcu lock as memslots will be accessed to =
check the gfn
> >> +                * cache generation against the memslots generation.
> >> +                */
> >> +               idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> >> +               _kvm_set_vcpu_preempted(vcpu);
> >> +               srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >> +       }
> >> +
> >>          local_irq_save(flags);
> >>          cpu =3D smp_processor_id();
> >>          vcpu->arch.last_sched_cpu =3D cpu;
> >> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >> index a49b1c1a3dd1..b8879110a0a1 100644
> >> --- a/arch/loongarch/kvm/vm.c
> >> +++ b/arch/loongarch/kvm/vm.c
> >> @@ -45,8 +45,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >>
> >>          /* Enable all PV features by default */
> >>          kvm->arch.pv_features =3D BIT(KVM_FEATURE_IPI);
> >> -       if (kvm_pvtime_supported())
> >> +       if (kvm_pvtime_supported()) {
> >>                  kvm->arch.pv_features |=3D BIT(KVM_FEATURE_STEAL_TIME=
);
> >> +               kvm->arch.pv_features |=3D BIT(KVM_FEATURE_PREEMPT_HIN=
T);
> >> +       }
> >>
> >>          /*
> >>           * cpu_vabits means user address space only (a half of total)=
.
> >> @@ -143,6 +145,7 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm=
, struct kvm_device_attr *attr
> >>          case KVM_LOONGARCH_VM_FEAT_PV_IPI:
> >>                  return 0;
> >>          case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
> >> +       case KVM_LOONGARCH_VM_FEAT_PV_PREEMPT_HINT:
> >>                  if (kvm_pvtime_supported())
> >>                          return 0;
> >>                  return -ENXIO;
> >> --
> >> 2.39.3
> >>
> >>
>
>

