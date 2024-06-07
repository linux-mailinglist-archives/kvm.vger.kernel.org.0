Return-Path: <kvm+bounces-19048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 748DB8FFA4D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 05:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16EAF28630B
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 03:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EA5199A2;
	Fri,  7 Jun 2024 03:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hB0q8tIN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95845EC2;
	Fri,  7 Jun 2024 03:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717732734; cv=none; b=XY/OYHOo2D28vKAYHwHdOGd3nJrE3p92P1lOtboHIil8n4kn9ZsL6elS5eZWzFgLyBp9LXVWZCZJ97d5tGHwuKqP/B5EtMuhUciAH0Plm+5K8eyIXJX8ZZJf6w/iEu/iQu5PC0bZuSHfpeunqWuFA8aPvgr7GJwbbabuhAieEvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717732734; c=relaxed/simple;
	bh=KGiP6ThPJ35VDSsCfPxzFa7jhXRjGboxQEacwO1xoYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ouj6ifMObdvPrir2Ptc2vpOiaT9CvCpoS/HAaujlSxhjFCOojwKC/VVjTMQ7TryqcdlB2D8DFIESOhR9nEVbaUMPnklzLbrf6GAwP9qSW3NQmmxhCTFU80F2gm7/tsxfy/JuFWT70fg5+g0enPpJxkFybgJ3YmIqYXkav1PFrfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hB0q8tIN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C17CC2BBFC;
	Fri,  7 Jun 2024 03:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717732734;
	bh=KGiP6ThPJ35VDSsCfPxzFa7jhXRjGboxQEacwO1xoYE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hB0q8tINgfwOQ1XDjImYI149Tcev1Mbj65QyDm3SG7Ih11fBvPweIzdJ3DlE5NjcZ
	 hEsM2kLiBTI3g5X9kh6rFNTkrd1VmutZQ5QVSoWWx68eIeWGbvrT1j9S7grznCr6US
	 mF3ukEwx0rZ50u4Q2kycxnvBHAaw5+tIAnJWfKdFO75hV8d5C7E13fp/92Ga5gkT/V
	 HMKuUkHAOhBtnMikeJg8wqkc9z5T1HhTSiG4DiIplxiim68X9Ya46XVEdgzL+RSesJ
	 YBGWOG4iCunYCkmIO9ccQtjqKNAOFwVo7sGMMpHnolxqschN4qsleGGGvfyZdgm6Yx
	 mjYjyDG+OJMRw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a63359aaaa6so236957666b.2;
        Thu, 06 Jun 2024 20:58:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUevKHN7QgZ2rSxHJ694BvatCUjFORpBM71qK1+/AQ4ebnRzP7LY3SGz+44GtczrevbKEfUDm6CtMfUXeSz3UlAwuUrBPpFvCKzEvn9VG2qoMVrbSxrEY8oTxTNS/nWZe8K
X-Gm-Message-State: AOJu0YxNfmDSB19LFEtyYEg5smvGR7ckGtoGStgQ29g/t+lMl2PHBV6u
	pGCTkTmQx7RWse/IrpQjcEpU1237FfoP9O3TBjHKftu0ZnlNceiVH8mlEcEh/XzDbtvM9uH4Fl2
	97ZN2DPIJzRnfzS2Z5yAfVl3H+6c=
X-Google-Smtp-Source: AGHT+IHbeMs8l/ThwyG8wYss4Fl8a3e+yvPzz9N/025J2Pg7mooTgedX6RqOok+ITV/Qz5bnFz5iWEvQzETuVjTNaSE=
X-Received: by 2002:a17:907:7e91:b0:a69:906c:9005 with SMTP id
 a640c23a62f3a-a6cdb0f5393mr104738866b.57.1717732732752; Thu, 06 Jun 2024
 20:58:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240606074850.2651896-1-maobibo@loongson.cn> <9bb552c8-fe86-43dc-9c4e-0b95c99fb25c@xen0n.name>
 <2774b010-8033-2167-474a-cb1b29b27d2b@loongson.cn> <ca286a23-f22b-092c-20d0-6ab20fd0883f@loongson.cn>
In-Reply-To: <ca286a23-f22b-092c-20d0-6ab20fd0883f@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 7 Jun 2024 11:58:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4R7GO33jggAHsq0A6qLejdhnht5eBLs3OSasCkcYwJmQ@mail.gmail.com>
Message-ID: <CAAhV-H4R7GO33jggAHsq0A6qLejdhnht5eBLs3OSasCkcYwJmQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add feature passing from user space
To: maobibo <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,


On Thu, Jun 6, 2024 at 8:05=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/6/6 =E4=B8=8B=E5=8D=887:54, maobibo wrote:
> > Xuerui,
> >
> > Thanks for your reviewing.
> > I reply inline.
> >
> > On 2024/6/6 =E4=B8=8B=E5=8D=887:20, WANG Xuerui wrote:
> >> Hi,
> >>
> >> On 6/6/24 15:48, Bibo Mao wrote:
> >>> Currently features defined in cpucfg CPUCFG_KVM_FEATURE comes from
> >>> kvm kernel mode only. Some features are defined in user space VMM,
> >>
> >> "come from kernel side only. But currently KVM is not aware of
> >> user-space VMM features which makes it hard to employ optimizations
> >> that are both (1) specific to the VM use case and (2) requiring
> >> cooperation from user space."
> > Will modify in next version.
> >>
> >>> however KVM module does not know. Here interface is added to update
> >>> register CPUCFG_KVM_FEATURE from user space, only bit 24 - 31 is vali=
d.
> >>>
> >>> Feature KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI is added from user mdoe.
> >>> FEAT_VIRT_EXTIOI is virt EXTIOI extension which can route interrupt
> >>> to 256 VCPUs rather than 4 CPUs like real hw.
> >>
> >> "A new feature bit ... is added which can be set from user space.
> >> FEAT_... indicates that the VM EXTIOI can route interrupts to 256
> >> vCPUs, rather than 4 like with real HW."
> > will modify in next version.
> >
> >>
> >> (Am I right in paraphrasing the "EXTIOI" part?)
> >>
> >>>
> >>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>> ---
> >>>   arch/loongarch/include/asm/kvm_host.h  |  4 +++
> >>>   arch/loongarch/include/asm/loongarch.h |  5 ++++
> >>>   arch/loongarch/include/uapi/asm/kvm.h  |  2 ++
> >>>   arch/loongarch/kvm/exit.c              |  1 +
> >>>   arch/loongarch/kvm/vcpu.c              | 36 +++++++++++++++++++++++=
---
> >>>   5 files changed, 44 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/arch/loongarch/include/asm/kvm_host.h
> >>> b/arch/loongarch/include/asm/kvm_host.h
> >>> index 88023ab59486..8fa50d757247 100644
> >>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>> @@ -135,6 +135,9 @@ enum emulation_result {
> >>>   #define KVM_LARCH_HWCSR_USABLE    (0x1 << 4)
> >>>   #define KVM_LARCH_LBT        (0x1 << 5)
> >>> +#define KVM_LOONGARCH_USR_FEAT_MASK            \
> >>> +    BIT(KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI)
> >>> +
> >>>   struct kvm_vcpu_arch {
> >>>       /*
> >>>        * Switch pointer-to-function type to unsigned long
> >>> @@ -210,6 +213,7 @@ struct kvm_vcpu_arch {
> >>>           u64 last_steal;
> >>>           struct gfn_to_hva_cache cache;
> >>>       } st;
> >>> +    unsigned int usr_features;
> >>>   };
> >>>   static inline unsigned long readl_sw_gcsr(struct loongarch_csrs
> >>> *csr, int reg)
> >>> diff --git a/arch/loongarch/include/asm/loongarch.h
> >>> b/arch/loongarch/include/asm/loongarch.h
> >>> index 7a4633ef284b..4d9837512c19 100644
> >>> --- a/arch/loongarch/include/asm/loongarch.h
> >>> +++ b/arch/loongarch/include/asm/loongarch.h
> >>> @@ -167,9 +167,14 @@
> >>>   #define CPUCFG_KVM_SIG            (CPUCFG_KVM_BASE + 0)
> >>>   #define  KVM_SIGNATURE            "KVM\0"
> >>> +/*
> >>> + * BIT 24 - 31 is features configurable by user space vmm
> >>> + */
> >>>   #define CPUCFG_KVM_FEATURE        (CPUCFG_KVM_BASE + 4)
> >>>   #define  KVM_FEATURE_IPI        BIT(1)
> >>>   #define  KVM_FEATURE_STEAL_TIME        BIT(2)
> >>> +/* With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs */
> >>> +#define  KVM_FEATURE_VIRT_EXTIOI    BIT(24)
> >>>   #ifndef __ASSEMBLY__
> >>
> >> What about assigning a new CPUCFG leaf ID for separating the two kinds
> >> of feature flags very cleanly?
> > For compatible issue like new kernel on old KVM host, to add a new
> > CPUCFG leaf ID, a new feature need be defined on existing
> > CPUCFG_KVM_FEATURE register. Such as:
> >     #define  KVM_FEATURE_EXTEND_CPUCFG        BIT(3)
> >
> > VM need check feature KVM_FEATURE_EXTEND_CPUCFG at first, and then read
> > the new CPUCFG leaf ID if feature EXTEND_CPUCFG is enabled.
> >
> > That maybe makes it complicated since feature bit is enough now.
> The default return value is zero with old kvm host, it is possible to
> use a new CPUCFG leaf ID. Both methods are ok for me.
>
> Huacai,
> What is your optnion about this?
I don't think we need a new leaf, but is this feature detection
duplicated with EXTIOI_VIRT_FEATURES here?
https://lore.kernel.org/lkml/871q5a2lo8.ffs@tglx/T/#t

Huacai

>
> Regards
> Bibo Mao
> >>
> >>> @@ -896,7 +907,24 @@ static int kvm_loongarch_vcpu_get_attr(struct
> >>> kvm_vcpu *vcpu,
> >>>   static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
> >>>                        struct kvm_device_attr *attr)
> >>>   {
> >>> -    return -ENXIO;
> >>> +    u64 __user *user =3D (u64 __user *)attr->addr;
> >>> +    u64 val, valid_flags;
> >>> +
> >>> +    switch (attr->attr) {
> >>> +    case CPUCFG_KVM_FEATURE:
> >>> +        if (get_user(val, user))
> >>> +            return -EFAULT;
> >>> +
> >>> +        valid_flags =3D KVM_LOONGARCH_USR_FEAT_MASK;
> >>> +        if (val & ~valid_flags)
> >>> +            return -EINVAL;
> >>> +
> >>> +        vcpu->arch.usr_features |=3D val;
> >>
> >> Isn't this usage of "|=3D" instead of "=3D" implying that the feature =
bits
> >> could not get disabled after being enabled earlier, for whatever reaso=
n?
> > yes, "=3D" is better. Will modify in next version.
> >
> > Regards
> > Bibo Mao
> >>
> >>> +        return 0;
> >>> +
> >>> +    default:
> >>> +        return -ENXIO;
> >>> +    }
> >>>   }
> >>>   static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
> >>>
> >>> base-commit: 2df0193e62cf887f373995fb8a91068562784adc
> >>
> >
>
>

