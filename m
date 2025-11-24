Return-Path: <kvm+bounces-64328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E48C7F758
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 38EC64E0F56
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD012F49E9;
	Mon, 24 Nov 2025 09:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkyhnKnw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492F22F3C09
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763975029; cv=none; b=G8vvvPGg+zKl2p060DajpITwp9OgWUwCBWPoRD+qb2Hvf5gU7C/Z+i5i+t1JhlUvpRFFiH7S3nA+YhxWEwgNerfMtxHi9spLAdFnUaO0ZttBDURwZp+eTkAB1fF1CL65GIlK5qwDBFvb3HWbEeC3N2aNIYp2QUuPYUsSd77gHVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763975029; c=relaxed/simple;
	bh=W/Xk2R/t2ZoaXb6JKxqxjSvL304pXRIfylaFB3JpVbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dehq7s+ubaIrPKkNxAZIuV1Z1+Mu81GtYqd1wK4Gz1eND+nrqLOUydQCCgi5PN6ZiUi+PDnaPEb/mQGtENuJhW41ACXXyt4FkwPCB8iLgRVQCJuzb3IOUphaZEvRDDQGkrGJPlxnIha0aWzbDXUKWf62o9Fy9lozaQAL0Yrd50k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkyhnKnw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD343C2BC86
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763975028;
	bh=W/Xk2R/t2ZoaXb6JKxqxjSvL304pXRIfylaFB3JpVbY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KkyhnKnwi1Fp+C2U8U1Xu9zriTUeV/jKHYZvPq+MCa5ctcbm6gW6ZfLNjpG9X0oQH
	 18ArLHkzUrkIIwG+32N+ZOliO5fSjKEt7FIQBYAThkrYLr1+NwKZxe3JsF6kJMhrMb
	 ZF4LMCwnrfK4Ex+Ib5kx3tYdTOxRhV+T4RT+akXMQv7mCxf3pyr7QdDvS4dTuI7hFp
	 KGajSdq7H9e5dPvF9YnW5Q6SqW2H4Tfyw5IV8zfXEvI3KJvMjz6gT1WVJpqm7MDGP+
	 JcbeQcaxl1Xf2pC1WZ3CnmsZoxWcTsydnKZyD6a8dL2meJtHzLfnEOnAPupQZowzZf
	 ALWaQmtBJHuSQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7355f6ef12so848667266b.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 01:03:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWaVvnj3lZhPC78H4yahHZ0Pbsbibb40rQ5K0SGxjc4Byd5bnGnK7HxyGWlQ6S80iQilK0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTcCrADottVcLQVB8Uekkv9W4iIewKOrtiLD/a/LIPyAdTWp6h
	Dy6pZwm/FnICL1LYcT7NctCQ/SVcfu+QoIWeKB34ulceS1+XO+wOhCUA7yGzmYm7gyYHWsSog3i
	b0y4r/+grs3qcbKfjl10c5PBR5I9WP7A=
X-Google-Smtp-Source: AGHT+IGAOVH5IrByY9iy7QsmuJJSSkQzPZCk9aFnD1OugVDq9Q5D3ZHJ61TKf4j/XKBUS7hAUGPKoBGKc7IvbpdOYeU=
X-Received: by 2002:a17:907:a0d:b0:b70:be0b:6ba8 with SMTP id
 a640c23a62f3a-b76719d9598mr1115915766b.61.1763975027342; Mon, 24 Nov 2025
 01:03:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124035402.3817179-1-maobibo@loongson.cn> <20251124035402.3817179-3-maobibo@loongson.cn>
 <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
 <5d80c452-bbc3-539a-fb8d-14dbe353f8cb@loongson.cn> <CAAhV-H66M+GZ2kB8BKR82BUeQcNZ8ACeXLxwjh-bsVZcca1cqQ@mail.gmail.com>
 <718b5b5d-2bb1-5d59-409e-54f54516a6b7@loongson.cn> <CAAhV-H4X5EAgDTnSGG+1pMWywoLAis5TH_jEWkvaY8p1m8hQMg@mail.gmail.com>
 <611840bb-7f7d-3b13-dc89-b760d8eeda79@loongson.cn>
In-Reply-To: <611840bb-7f7d-3b13-dc89-b760d8eeda79@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Nov 2025 17:03:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6TWCs-tFf5HCOt9cAY01J-nirzVmu1GEAYpP=1LWznPA@mail.gmail.com>
X-Gm-Features: AWmQ_bl5WHttwyif8buPYIlczD8Qs375scySMM_FOAg_9ZNtDvE7TU_oeK5A_lo
Message-ID: <CAAhV-H6TWCs-tFf5HCOt9cAY01J-nirzVmu1GEAYpP=1LWznPA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>, 
	Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 4:35=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/11/24 =E4=B8=8B=E5=8D=884:03, Huacai Chen wrote:
> > On Mon, Nov 24, 2025 at 3:50=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2025/11/24 =E4=B8=8B=E5=8D=883:13, Huacai Chen wrote:
> >>> On Mon, Nov 24, 2025 at 3:03=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2025/11/24 =E4=B8=8B=E5=8D=882:33, Huacai Chen wrote:
> >>>>> Hi, Bibo,
> >>>>>
> >>>>> On Mon, Nov 24, 2025 at 11:54=E2=80=AFAM Bibo Mao <maobibo@loongson=
.cn> wrote:
> >>>>>>
> >>>>>> Function vcpu_is_preempted() is used to check whether vCPU is pree=
mpted
> >>>>>> or not. Here add implementation with vcpu_is_preempted() when opti=
on
> >>>>>> CONFIG_PARAVIRT is enabled.
> >>>>>>
> >>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>> ---
> >>>>>>     arch/loongarch/include/asm/qspinlock.h |  5 +++++
> >>>>>>     arch/loongarch/kernel/paravirt.c       | 16 ++++++++++++++++
> >>>>>>     2 files changed, 21 insertions(+)
> >>>>>>
> >>>>>> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongar=
ch/include/asm/qspinlock.h
> >>>>>> index e76d3aa1e1eb..9a5b7ba1f4cb 100644
> >>>>>> --- a/arch/loongarch/include/asm/qspinlock.h
> >>>>>> +++ b/arch/loongarch/include/asm/qspinlock.h
> >>>>>> @@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspinl=
ock *lock)
> >>>>>>            return true;
> >>>>>>     }
> >>>>>>
> >>>>>> +#ifdef CONFIG_SMP
> >>>>>> +#define vcpu_is_preempted      vcpu_is_preempted
> >>>>>> +bool vcpu_is_preempted(int cpu);
> >>>>> In V1 there is a build error because you reference mp_ops, so in V2
> >>>>> you needn't put it in CONFIG_SMP.
> >>>> The compile failure problem is that vcpu_is_preempted() is redefined=
 in
> >>>> both arch/loongarch/kernel/paravirt.c and include/linux/sched.h
> >>> But other archs don't define vcpu_is_preempted() under CONFIG_SMP, an=
d
> >> so what is advantage to implement this function if CONFIG_SMP is disab=
led?
> > 1. Keep consistency with other architectures.
> > 2. Keep it simple to reduce #ifdefs (and !SMP is just for build, not
> > very useful in practice).
> It seems that CONFIG_SMP can be removed in header file
> include/asm/qspinlock.h, since asm/spinlock.h and asm/qspinlock.h is
> only included when CONFIG_SMP is set, otherwise only linux/spinlock_up.h
> is included.
>
> >
> >>
> >>> you can consider to inline the whole vcpu_is_preempted() here.
> >> Defining the function vcpu_is_preempted() as inlined is not so easy fo=
r
> >> me, it beyond my ability now :(
> >>
> >> With static key method, the static key need be exported, all modules
> >> need apply the jump label, that is dangerous and I doubt whether it is
> >> deserved.
> > No, you have already done similar things in virt_spin_lock(), it is an
> > inline function and uses virt_spin_lock_key.
> virt_spin_lock is only called qspinlock in function
> queued_spin_lock_slowpath(). Function vcpu_is_preempted() is defined
> header file linux/sched.h, kernel module may use it.
Yes, if modules want to use it we need to EXPORT_SYMBOL. But don't
worry, static key infrastructure can handle this. Please see
cpu_feature_keys defined and used in
arch/powerpc/include/asm/cpu_has_feature.h, which is exported in
arch/powerpc/kernel/cputable.c.

Huacai

>
>
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>>>
> >>>> The problem is that <asm/spinlock.h> is not included by sched.h, if
> >>>> CONFIG_SMP is disabled. Here is part of file include/linux/spinlock.=
h
> >>>> #ifdef CONFIG_SMP
> >>>> # include <asm/spinlock.h>
> >>>> #else
> >>>> # include <linux/spinlock_up.h>
> >>>> #endif
> >>>>
> >>>>> On the other hand, even if you really build a UP guest kernel, when
> >>>>> multiple guests run together, you probably need vcpu_is_preemtped.
> >>>> It is not relative with multiple VMs. When vcpu_is_preempted() is
> >>>> called, it is to detect whether dest CPU is preempted or not, the cp=
u
> >>>> from smp_processor_id() should not be preempted. So in generic
> >>>> vcpu_is_preempted() works on multiple vCPUs.
> >>> OK, I'm wrong here.
> >>>
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Regards
> >>>> Bibo Mao
> >>>>>
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>> +#endif
> >>>>>> +
> >>>>>>     #endif /* CONFIG_PARAVIRT */
> >>>>>>
> >>>>>>     #include <asm-generic/qspinlock.h>
> >>>>>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/ker=
nel/paravirt.c
> >>>>>> index b1b51f920b23..d4163679adc4 100644
> >>>>>> --- a/arch/loongarch/kernel/paravirt.c
> >>>>>> +++ b/arch/loongarch/kernel/paravirt.c
> >>>>>> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
> >>>>>>     }
> >>>>>>
> >>>>>>     #ifdef CONFIG_SMP
> >>>>>> +DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
> >>>>>>     static int pv_time_cpu_online(unsigned int cpu)
> >>>>>>     {
> >>>>>>            unsigned long flags;
> >>>>>> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned =
int cpu)
> >>>>>>
> >>>>>>            return 0;
> >>>>>>     }
> >>>>>> +
> >>>>>> +bool notrace vcpu_is_preempted(int cpu)
> >>>>>> +{
> >>>>>> +       struct kvm_steal_time *src;
> >>>>>> +
> >>>>>> +       if (!static_branch_unlikely(&virt_preempt_key))
> >>>>>> +               return false;
> >>>>>> +
> >>>>>> +       src =3D &per_cpu(steal_time, cpu);
> >>>>>> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >>>>>> +}
> >>>>>> +EXPORT_SYMBOL(vcpu_is_preempted);
> >>>>>>     #endif
> >>>>>>
> >>>>>>     static void pv_cpu_reboot(void *unused)
> >>>>>> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
> >>>>>>                    pr_err("Failed to install cpu hotplug callbacks=
\n");
> >>>>>>                    return r;
> >>>>>>            }
> >>>>>> +
> >>>>>> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> >>>>>> +               static_branch_enable(&virt_preempt_key);
> >>>>>>     #endif
> >>>>>>
> >>>>>>            static_call_update(pv_steal_clock, paravt_steal_clock);
> >>>>>> --
> >>>>>> 2.39.3
> >>>>>>
> >>>>
> >>>>
> >>
> >>
>
>

