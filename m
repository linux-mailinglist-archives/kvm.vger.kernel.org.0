Return-Path: <kvm+bounces-64317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5CEC7F193
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 07:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45FCA3AA803
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 06:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2E82DF13E;
	Mon, 24 Nov 2025 06:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwT91n4k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71272DBF45
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 06:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965990; cv=none; b=fxVdRODXtzt9phocAMN7s+SfL2OEiD92zSdr0bNiq17VgfzCkPce1ebuswZSUQrqEelg/WXv8APy/i5+wP/xuF7q0iDDjBw6nLxTvKpPTV8FeH6+m6PC7wGcz1fc7MhLYiZxOU7bv0N4JJ76JVwxXnLxDtJfT+vYinA3+fse6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965990; c=relaxed/simple;
	bh=e2xvuF6Ny+umQar6+Cs9HNZRMtEfj1pW0zsB5mc2W04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OtQJOWe3gEkjsqcrgrbjLvxPe7DqCX1xFsFsh/Qp6aB/xHaHAB7bpC1bfka5fFmcH9PPhrvkBFhnBv02EyEoDSfnMn88ObxaJsTrPAbM90k+gBVHtN5dCjOeMv/+ZZ845Ub4P3Da3zWsKb32utthtHV7A3OPYjW0wgTyQ4e8pEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwT91n4k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7452BC19421
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 06:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763965989;
	bh=e2xvuF6Ny+umQar6+Cs9HNZRMtEfj1pW0zsB5mc2W04=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rwT91n4kQq/apBfBz+CQSQeOYQtG7sehntbFmw+AeihCzV/5I/4R8qFXMUF8XF0z1
	 x945qlg0yHb4BZq2OMCZYCu9XBoOuoS4P+I0RAdZ2pZm1MXdns5wCtYgE+RmdSoB5f
	 tySiJNbh6Eqn47mXtDFVmgWBE2a9sLLtiKE3wg6elJSQs8GAIvWhcRvBh3CbulEgWo
	 AmoDEfEutNqMtEiffLfmFShTMr03dMEWbNS/I436uFLxBZKwfNaeCTwtpFtVswO8YS
	 lPPo/AiflRjrH93TbfDOngMhFylN57AtbiAeOsVyrRgKJjch7Ib+UdyuZM45oGqaK6
	 LSHC7J2sNb8pQ==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso5506517a12.1
        for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 22:33:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXrGfh4VX82tZ0sqbgwj35wRjxwkbCZIZi5rS3BRZkL7CEZo4m7eMZ/3HCD3FuHE5BqaIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiINITK40uV3XfcJADSm3sRJOboUZ35FvnJ7mUjlBdd8FCl68M
	41h256qaiQzCGKz8mjZ0Zz5/p4i16bndJoLhomd/7pZMI67ZMVD2CcqT/7N+8gI6bp3xAbPou5Z
	XIeV8pWGS3UiK7Px9/vvRQLrxuMgs5x4=
X-Google-Smtp-Source: AGHT+IHeWhCh/2VbXQ9ILylWVVP2Ewf9rploSsqYj8iWGqLLxyXQK4O0jZg1WkatozAflwVlZpvkJPQdPrab7pyl/dg=
X-Received: by 2002:a17:907:3e0b:b0:b76:60ad:77f8 with SMTP id
 a640c23a62f3a-b767170aea1mr1147425766b.48.1763965988064; Sun, 23 Nov 2025
 22:33:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124035402.3817179-1-maobibo@loongson.cn> <20251124035402.3817179-3-maobibo@loongson.cn>
In-Reply-To: <20251124035402.3817179-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Nov 2025 14:33:10 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
X-Gm-Features: AWmQ_bnoFTnvDn1nrFrR_qppyCUACqFqJLqcscmXokW28okKe2T7YA8nUQaA0LM
Message-ID: <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
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

Hi, Bibo,

On Mon, Nov 24, 2025 at 11:54=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> Function vcpu_is_preempted() is used to check whether vCPU is preempted
> or not. Here add implementation with vcpu_is_preempted() when option
> CONFIG_PARAVIRT is enabled.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/qspinlock.h |  5 +++++
>  arch/loongarch/kernel/paravirt.c       | 16 ++++++++++++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/incl=
ude/asm/qspinlock.h
> index e76d3aa1e1eb..9a5b7ba1f4cb 100644
> --- a/arch/loongarch/include/asm/qspinlock.h
> +++ b/arch/loongarch/include/asm/qspinlock.h
> @@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspinlock *lo=
ck)
>         return true;
>  }
>
> +#ifdef CONFIG_SMP
> +#define vcpu_is_preempted      vcpu_is_preempted
> +bool vcpu_is_preempted(int cpu);
In V1 there is a build error because you reference mp_ops, so in V2
you needn't put it in CONFIG_SMP.
On the other hand, even if you really build a UP guest kernel, when
multiple guests run together, you probably need vcpu_is_preemtped.


Huacai

> +#endif
> +
>  #endif /* CONFIG_PARAVIRT */
>
>  #include <asm-generic/qspinlock.h>
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/par=
avirt.c
> index b1b51f920b23..d4163679adc4 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
>  }
>
>  #ifdef CONFIG_SMP
> +DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
>  static int pv_time_cpu_online(unsigned int cpu)
>  {
>         unsigned long flags;
> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int cpu=
)
>
>         return 0;
>  }
> +
> +bool notrace vcpu_is_preempted(int cpu)
> +{
> +       struct kvm_steal_time *src;
> +
> +       if (!static_branch_unlikely(&virt_preempt_key))
> +               return false;
> +
> +       src =3D &per_cpu(steal_time, cpu);
> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
> +}
> +EXPORT_SYMBOL(vcpu_is_preempted);
>  #endif
>
>  static void pv_cpu_reboot(void *unused)
> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
>                 pr_err("Failed to install cpu hotplug callbacks\n");
>                 return r;
>         }
> +
> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> +               static_branch_enable(&virt_preempt_key);
>  #endif
>
>         static_call_update(pv_steal_clock, paravt_steal_clock);
> --
> 2.39.3
>

