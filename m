Return-Path: <kvm+bounces-9861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9008675E1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E0C01C2880B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDF080047;
	Mon, 26 Feb 2024 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vB2Tswhp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F2F5A7B9;
	Mon, 26 Feb 2024 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952412; cv=none; b=PbjcCymjBniFjAEPZHHwurt3pa+viBM2Fy3i0Yw5zw5oOLU9RiQs0/cPbVSp3j7IDVVeLDM3nLRfrCd+mlFj2D+Vclq3Max3mjY9J9WXEhBvVHHnPlLeHdHMOFc5WEMxvZzT9i5mlL0zR9LPGoGshgBTF8nVsRQCw4E+Bsf8lQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952412; c=relaxed/simple;
	bh=OMiWctER0LJ1jLO/g05SXNcA18YmEBLscWZvA7VnJkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qfOOpOFrWj73Q/DTGgk+usldvuK33OwahaRko85Qzx6gzdBxFHAsHJ1SZteuBxumg1r02XlxQ3h41DLtMXhTVfqR79Hq5dPOuPYjYly94SicYVIKA6l81zxOdPKYndk2VuKwrJMJCqNMS9csMt9HHpS5ugaCe2mPKYNVK9oISXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vB2Tswhp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8000C43601;
	Mon, 26 Feb 2024 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708952411;
	bh=OMiWctER0LJ1jLO/g05SXNcA18YmEBLscWZvA7VnJkM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vB2TswhpFY1yqMJl0NwGq0yJMVGeZKkqi78nomO7G/RYeP65nMeJos1uYBNQXfy0i
	 eAnPEqB8UmbOE+IihZLRLVKVQasSgmpWjPlvcQ47uwXAI8yu9qAE6DrzfvTi2VZrwz
	 XyM35WmTBKBcuQUT0iF0LMlRuBSkLEWIEse8sW/Z7g921wFg0CJAsXdb0iWGqIz2yU
	 7rhsVLwgqqS4hYSW//RcyNmVW5ZOLrJ/NNkbUC/MLg7IRKICsGFxFiluuXNI9IwFVs
	 k1NjRbOvRu7p5Hn0AXlE2Vemb8vrhksHCQep+ctT1CZAjGTpPvaK2rs6Iv5Z0r5rTJ
	 JwU008ZHAKmuA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a437a2a46b1so57944066b.2;
        Mon, 26 Feb 2024 05:00:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXleWZLb1givXMKwGYwzupNXuMpwLvUGMzZYkOAWzEATNoob53K1LQufBFkRktYWkHZNngSMZTUWAY7FiWyzwYigDv8SexYZWPUZPuvEHOFKVPqTneako6mWSSx4oNqj+/i
X-Gm-Message-State: AOJu0YwmYvIVKejHp1u2o4s8drVNyeup6riukCyFVIi7cf38vkuLniUW
	fkXofhe+P50hsE9copXIpwemszgvkrhUpH7XscbjjaNdMLSav9+NzMWfFHcTJIYi1wItVuUQTpm
	w5D8v60YRv/0s7yv2PFYfH0Ye4WM=
X-Google-Smtp-Source: AGHT+IHLK4Exe7j67rwEw991AFJgmSFjyGqKbOmZ/W+iJwdhbSt+QDLwruPF2NYpobJ0QS7xyR1J+L7PCSAOdYvq8Ng=
X-Received: by 2002:a17:906:3411:b0:a43:1415:2f1e with SMTP id
 c17-20020a170906341100b00a4314152f1emr2987434ejb.69.1708952410260; Mon, 26
 Feb 2024 05:00:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130072238.2829831-1-maobibo@loongson.cn> <20240130072238.2829831-3-maobibo@loongson.cn>
In-Reply-To: <20240130072238.2829831-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 26 Feb 2024 20:59:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5ey2g_dmSQsM+5WM+Kir-b6jqfatxnbgBRvjggZzuXtQ@mail.gmail.com>
Message-ID: <CAAhV-H5ey2g_dmSQsM+5WM+Kir-b6jqfatxnbgBRvjggZzuXtQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] LoongArch: KVM: Do not restart SW timer when it is expired
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The code itself looks good to me, but could you please tell me what
does "LoongArch guest has separate hw timer" mean?

Huacai

On Tue, Jan 30, 2024 at 3:22=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> LoongArch guest has separate hw timer, SW timer is to wake up
> blocked vcpu thread, rather than HW timer emulation. When blocking
> vcpu schedules out, SW timer is used to wakeup blocked vcpu thread
> and injects timer interrupt. It does not care about whether guest
> timer is in period mode or oneshot mode, and SW timer needs not be
> restarted since vcpu has been woken.
>
> This patch does not restart sw timer when it is expired.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/timer.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
>
> diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
> index a9125f0a12d1..d3282f01d4d9 100644
> --- a/arch/loongarch/kvm/timer.c
> +++ b/arch/loongarch/kvm/timer.c
> @@ -23,24 +23,6 @@ static inline u64 tick_to_ns(struct kvm_vcpu *vcpu, u6=
4 tick)
>         return div_u64(tick * MNSEC_PER_SEC, vcpu->arch.timer_mhz);
>  }
>
> -/*
> - * Push timer forward on timeout.
> - * Handle an hrtimer event by push the hrtimer forward a period.
> - */
> -static enum hrtimer_restart kvm_count_timeout(struct kvm_vcpu *vcpu)
> -{
> -       unsigned long cfg, period;
> -
> -       /* Add periodic tick to current expire time */
> -       cfg =3D kvm_read_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG);
> -       if (cfg & CSR_TCFG_PERIOD) {
> -               period =3D tick_to_ns(vcpu, cfg & CSR_TCFG_VAL);
> -               hrtimer_add_expires_ns(&vcpu->arch.swtimer, period);
> -               return HRTIMER_RESTART;
> -       } else
> -               return HRTIMER_NORESTART;
> -}
> -
>  /* Low level hrtimer wake routine */
>  enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer)
>  {
> @@ -50,7 +32,7 @@ enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer =
*timer)
>         kvm_queue_irq(vcpu, INT_TI);
>         rcuwait_wake_up(&vcpu->wait);
>
> -       return kvm_count_timeout(vcpu);
> +       return HRTIMER_NORESTART;
>  }
>
>  /*
> --
> 2.39.3
>

