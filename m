Return-Path: <kvm+bounces-64318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 181F6C7F1AB
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 07:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D7D354E4924
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 06:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD2B2DC76C;
	Mon, 24 Nov 2025 06:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M24dS801"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7B32DC798
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 06:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965998; cv=none; b=r14Kms3SN5i6EWrwHHnQJ2ujAaAndGV+wTrEtAqHnH18A/b4kDc1iap/6qWDpwhNONoPg7TC+1mYUe9rhnFf+k6alcxdY0EpS/mZcl2ovcgwSibxWnqXQE3Dlj0TMeRJgQqqHw6D+3ukQyH3BcsNXSFWjy0gi0bzighbM5kJZYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965998; c=relaxed/simple;
	bh=RMZx3f9CZAuXaxkYtVx4KeILRSfFZOC8nYEqFDpYzCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XoheJWw+jkIbasuPgT/Bq4aSWyU8rqgADQ2Ks6fgEPpCf+0LWcD1D13nmuzOgpo6ddRxHIwhdl9cmkUd8weODNIwPtQOCHZfPuMVKmAlVFYhsORZHruc1qK9TW3NNOjd7vim0xuxMCG5Hksqpm3yH5kJObO5G9Zrj3lyaPPeUns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M24dS801; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAB1C19424
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 06:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763965998;
	bh=RMZx3f9CZAuXaxkYtVx4KeILRSfFZOC8nYEqFDpYzCE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M24dS8017dhju0mmrQtQvrYWIigGYTjLJrA4pTwWVp7o0GKQkJKupTDkDursLazVq
	 IRVupNd6PMnwTYZ3GHqJRK4KFGFWhA4DuTGwC8zlVtUyoDtHaUFKNfC+DiKYyPE7VH
	 dLBg//iY0WBFHijXK12OuRb2Kw39lAJMR5DJ0X7Xvp4l/IWK1iFHJQBpZVOUfQ0igc
	 9LEadaqbp8JtEOS4ZVQ7eRbC76cxWGxwWiTXuIguPl+MGDhDRBzjhwyhj8HFlPL/PD
	 bSm3W0qYmZmuDP+LFjSlGLGYdPUyfk/1nVaDlzOWru62DpuW4J5ryievCHUpNm/aw2
	 mDpMhJ0pvsdOA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so6464620a12.0
        for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 22:33:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUzMYAOBCpmlHzKMiPO2cFDknLMOAnCYXfsseAHAyoOwbkdWlm4NlvrCbke/qI/YtCboEw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4CRJ7bfKAK/vjKlvQvatYKNFeyrHFmjHB78k9jcE1EhvWxPQu
	JwU2l+U/3MpcmZCst0KrwPI7yNGlXg9Hgo5tXDtEDZFpLUf6bh2CGgt6OmTKw9x0g8kFRcA7UG4
	YpdidZrImoM8rAPEKEwM6p+uIuGy3nJw=
X-Google-Smtp-Source: AGHT+IFb//UjH3y68eWZjqc4FZltiS7Yzf4I2V3+/AX415J2DeCGvIhhHfDGtvZIgxxfioXlmqIgLOdEhSt2ogztvc4=
X-Received: by 2002:a17:906:ee8d:b0:b6d:505e:3da1 with SMTP id
 a640c23a62f3a-b76715161f1mr1158164066b.7.1763965997129; Sun, 23 Nov 2025
 22:33:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124035402.3817179-1-maobibo@loongson.cn> <20251124035402.3817179-4-maobibo@loongson.cn>
In-Reply-To: <20251124035402.3817179-4-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Nov 2025 14:33:20 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5xA_QcRXJsiW929pQ3zPw-5BqgbGW6K5Qy9sa3ofH+9g@mail.gmail.com>
X-Gm-Features: AWmQ_bmKuwsdh1o5ff2jGBc2izcZyqNABWbQMXFr0ctjUtqEk_quRMh86Gr16T4
Message-ID: <CAAhV-H5xA_QcRXJsiW929pQ3zPw-5BqgbGW6K5Qy9sa3ofH+9g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] LoongArch: Add paravirt preempt print prompt
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Juergen Gross <jgross@suse.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, WANG Xuerui <kernel@xen0n.name>, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Mon, Nov 24, 2025 at 11:54=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> Add paravirt preempt print prompt together with steal timer information,
> so that it is easy to check whether paravirt preempt feature is enabled
> or not.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kernel/paravirt.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/par=
avirt.c
> index d4163679adc4..ffe1cf284c41 100644
> --- a/arch/loongarch/kernel/paravirt.c
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -300,6 +300,7 @@ static struct notifier_block pv_reboot_nb =3D {
>  int __init pv_time_init(void)
>  {
>         int r;
> +       bool pv_preempted =3D false;
>
>         if (!kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
>                 return 0;
> @@ -322,8 +323,10 @@ int __init pv_time_init(void)
>                 return r;
>         }
>
> -       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT)) {
>                 static_branch_enable(&virt_preempt_key);
> +               pv_preempted =3D true;
> +       }
>  #endif
>
>         static_call_update(pv_steal_clock, paravt_steal_clock);
> @@ -334,7 +337,10 @@ int __init pv_time_init(void)
>                 static_key_slow_inc(&paravirt_steal_rq_enabled);
>  #endif
>
> -       pr_info("Using paravirt steal-time\n");
> +       if (pv_preempted)
No pv_preempted needed, you can just use
static_key_enabled(&virt_preempt_key) and merge this patch to Patch-2.


Huacai

> +               pr_info("Using paravirt steal-time with preempt hint enab=
led\n");
> +       else
> +               pr_info("Using paravirt steal-time with preempt hint disa=
bled\n");
>
>         return 0;
>  }
> --
> 2.39.3
>

