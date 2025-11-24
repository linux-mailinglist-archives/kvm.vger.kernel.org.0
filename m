Return-Path: <kvm+bounces-64322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EF2C7F29C
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 08:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C400D4E34DF
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 07:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20432E1F06;
	Mon, 24 Nov 2025 07:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XksjX72N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035302E172D
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 07:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763968387; cv=none; b=CRy0dWzkz+aIUABlX6mtgKHBV9MR3GhS5v5gJWgbSWPU0GMLff2p0C/9E+h06/+N5rv+O9YEk4wzIMvKPLkheQN077+HQbuoQVbFLQbYnEu8UGOC3MKrwaPl/9xPXsNcBowLD9RgKssv5Iq650Ok9TCeMR5D020BoAscsBpUrXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763968387; c=relaxed/simple;
	bh=alTm+/MjeRFfigP2b88uD23nCxku/Hj3FD3MHMj6/Wk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uS4jyJGEDBRV6cDFwtGNseSUUsTz47hTXF4JJQcLhjZ5C9QACzJ/oWhhU3v1ZOkedq5GTAkDli1yMliz+Rjuk7LA4MyODv0O4H21GD/lZJ6R3RVQubSMG6No1XqzIfk7O+Y0tQUg8L3u8v6bfc0QU5UwQfuuVAP1eT8FuyPJubg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XksjX72N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A85C116D0
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 07:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763968386;
	bh=alTm+/MjeRFfigP2b88uD23nCxku/Hj3FD3MHMj6/Wk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XksjX72NTXKUxjiIjGf59tleufLgvbgldsOxc2M+CKCTZ3mGPdKiLYdIBXUklZtES
	 3rDmk0QtPMrta01Y6ky/L4P+QGudHi8Ae2pgrlpIRhh7nbpZ7Y6KYjv5L0RamiOmE4
	 v0rm5FtMV2/xmq4/JJmB095sfQhpGStStW+DYS3GgrEl68gSNoejfkesaJWx6JpObD
	 dQo2OMxBFekK7PximRHQM5/mAVOOjPhbvWcV/ryBPEDINR4BPQFi2jFyzEXDrk7Pov
	 eFOOFOOMk5MXmrMZiHSQ+d72LHYVJKPrCn+TExEMDUuzICAWS6g5H67/G5zWtCfARu
	 kAaiXzFhDtx/Q==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7277324054so579701466b.0
        for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 23:13:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUs6B/67QR6UZ2z/zTUNokmAGvBLrkLECs13cxVK2gyxveW2lRyppckfWjFg539p0b/MW0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIpLGAvpJ4cOwqEcgwDYEDnLirmXCCNlO2Qy78UQ37awVI92k8
	HFfT96X6oFzGLpdK87YonVlNgI+ZzGLFPsE3mWEG/vi0y/id3M1X/EzRNBBG4YhHN9ot4AjS7LZ
	ufWe58Flw/0glzcFlOjP5MNrEaVqm3oU=
X-Google-Smtp-Source: AGHT+IEKpkOcfVGAxrwa4zROcIi0idPHgYqvHTbqe2+lLzxfRE2A7n4QJHfUd6jEG4011JPxtiVDoYolMBnpOyLChpw=
X-Received: by 2002:a17:907:3e23:b0:b70:fd2f:6a46 with SMTP id
 a640c23a62f3a-b76715aba5dmr1131570166b.20.1763968385035; Sun, 23 Nov 2025
 23:13:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124035402.3817179-1-maobibo@loongson.cn> <20251124035402.3817179-3-maobibo@loongson.cn>
 <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com> <5d80c452-bbc3-539a-fb8d-14dbe353f8cb@loongson.cn>
In-Reply-To: <5d80c452-bbc3-539a-fb8d-14dbe353f8cb@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Nov 2025 15:13:07 +0800
X-Gmail-Original-Message-ID: <CAAhV-H66M+GZ2kB8BKR82BUeQcNZ8ACeXLxwjh-bsVZcca1cqQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkxpuNpVf0LfbSPwRTLRS2IJjwDzYu71D5XkXGBYMCnvHHCvsWSvV_WOz4
Message-ID: <CAAhV-H66M+GZ2kB8BKR82BUeQcNZ8ACeXLxwjh-bsVZcca1cqQ@mail.gmail.com>
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

On Mon, Nov 24, 2025 at 3:03=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/11/24 =E4=B8=8B=E5=8D=882:33, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Mon, Nov 24, 2025 at 11:54=E2=80=AFAM Bibo Mao <maobibo@loongson.cn>=
 wrote:
> >>
> >> Function vcpu_is_preempted() is used to check whether vCPU is preempte=
d
> >> or not. Here add implementation with vcpu_is_preempted() when option
> >> CONFIG_PARAVIRT is enabled.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/qspinlock.h |  5 +++++
> >>   arch/loongarch/kernel/paravirt.c       | 16 ++++++++++++++++
> >>   2 files changed, 21 insertions(+)
> >>
> >> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/i=
nclude/asm/qspinlock.h
> >> index e76d3aa1e1eb..9a5b7ba1f4cb 100644
> >> --- a/arch/loongarch/include/asm/qspinlock.h
> >> +++ b/arch/loongarch/include/asm/qspinlock.h
> >> @@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspinlock =
*lock)
> >>          return true;
> >>   }
> >>
> >> +#ifdef CONFIG_SMP
> >> +#define vcpu_is_preempted      vcpu_is_preempted
> >> +bool vcpu_is_preempted(int cpu);
> > In V1 there is a build error because you reference mp_ops, so in V2
> > you needn't put it in CONFIG_SMP.
> The compile failure problem is that vcpu_is_preempted() is redefined in
> both arch/loongarch/kernel/paravirt.c and include/linux/sched.h
But other archs don't define vcpu_is_preempted() under CONFIG_SMP, and
you can consider to inline the whole vcpu_is_preempted() here.

>
> The problem is that <asm/spinlock.h> is not included by sched.h, if
> CONFIG_SMP is disabled. Here is part of file include/linux/spinlock.h
> #ifdef CONFIG_SMP
> # include <asm/spinlock.h>
> #else
> # include <linux/spinlock_up.h>
> #endif
>
> > On the other hand, even if you really build a UP guest kernel, when
> > multiple guests run together, you probably need vcpu_is_preemtped.
> It is not relative with multiple VMs. When vcpu_is_preempted() is
> called, it is to detect whether dest CPU is preempted or not, the cpu
> from smp_processor_id() should not be preempted. So in generic
> vcpu_is_preempted() works on multiple vCPUs.
OK, I'm wrong here.


Huacai

>
> Regards
> Bibo Mao
> >
> >
> > Huacai
> >
> >> +#endif
> >> +
> >>   #endif /* CONFIG_PARAVIRT */
> >>
> >>   #include <asm-generic/qspinlock.h>
> >> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/=
paravirt.c
> >> index b1b51f920b23..d4163679adc4 100644
> >> --- a/arch/loongarch/kernel/paravirt.c
> >> +++ b/arch/loongarch/kernel/paravirt.c
> >> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
> >>   }
> >>
> >>   #ifdef CONFIG_SMP
> >> +DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
> >>   static int pv_time_cpu_online(unsigned int cpu)
> >>   {
> >>          unsigned long flags;
> >> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int =
cpu)
> >>
> >>          return 0;
> >>   }
> >> +
> >> +bool notrace vcpu_is_preempted(int cpu)
> >> +{
> >> +       struct kvm_steal_time *src;
> >> +
> >> +       if (!static_branch_unlikely(&virt_preempt_key))
> >> +               return false;
> >> +
> >> +       src =3D &per_cpu(steal_time, cpu);
> >> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> >> +}
> >> +EXPORT_SYMBOL(vcpu_is_preempted);
> >>   #endif
> >>
> >>   static void pv_cpu_reboot(void *unused)
> >> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
> >>                  pr_err("Failed to install cpu hotplug callbacks\n");
> >>                  return r;
> >>          }
> >> +
> >> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> >> +               static_branch_enable(&virt_preempt_key);
> >>   #endif
> >>
> >>          static_call_update(pv_steal_clock, paravt_steal_clock);
> >> --
> >> 2.39.3
> >>
>
>

