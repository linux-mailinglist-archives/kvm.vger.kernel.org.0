Return-Path: <kvm+bounces-9860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD4E8675DB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD8F81C280F2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A4C823A5;
	Mon, 26 Feb 2024 12:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyB8eRkG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B577F7FB;
	Mon, 26 Feb 2024 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952337; cv=none; b=S3ZxFup361Tt9+TGHoxBLX3zc4kRFjiKgDfJND5FTpOY/HG8bHbNj5HHYFrnd0p+EjsDMJHnhjIZcBYqGYkk4VVNJ5jxbysj85cuXs5arpCJUx6FtufxnBwvde1T8YOIXZC59qKEpa4JQKyCZmdyD7+qAzfYi2SmC0qPDwOz4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952337; c=relaxed/simple;
	bh=idV7OLDy+mbGz4M8S3DgS0wIv3UQ68q7P/tsruOyKso=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G6DoAj4M3s+qtLW8QBVW2qEAD/I1RGrnkZhIa3dPIHnseO85EdwPGKMjrwc2uAZ+bAf62L4IJLAvaIMGy3APEDgROp88SgmOiBylKqAgEV5LYu3s/06V/z7CP00+QGftDA5R2xqwOVgTkSujFbv+2gSTWcGHiXS7N+xgKhesZi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyB8eRkG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A02C43394;
	Mon, 26 Feb 2024 12:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708952337;
	bh=idV7OLDy+mbGz4M8S3DgS0wIv3UQ68q7P/tsruOyKso=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QyB8eRkGR/5FQaU3uLi1rwHY4UQGxV8agSRelPI0a5aFSCrLd+T2o4kxQCJcS0CcN
	 VvEjDbrBS6vgnpSIRUf3bbbjOhU1LXzbiqaiQdmPvuPMcpbLu1b+caHk4r/xOk8U2H
	 bz7bOKE7UMaNSekhmqiCTG4gtCy8tvyPtSBul6TBoeRHJpeviyPuA46/gnbIr0nljN
	 UNkomlcatazeIrMHZKOwLPQn8q5kezWfELVPY0VXZxv/rsoggSdbADClaNEd/AiHhM
	 IkdM1c4CMdL1XZ9ub2W1u/5VUCBzAOkRBIPItIXZdV0ZrotcIYhzuln2rI8XRC+DiF
	 WqY/0AaMI+2mQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a3e6f79e83dso324076566b.2;
        Mon, 26 Feb 2024 04:58:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVUzNQTBxSco23I+bwmOhzvJ9Y1kV8J8l2rbP7ubLesWv+PJKzc9dgVsRvzVpvcBKBOro2HvLVr6A8jBcfJQCcKi/0z6jtJRuEPaBUquKl6fIXZ4STSIFkzYnqsI+GtRnZA
X-Gm-Message-State: AOJu0YySPZQGeEN3ZYeh0HQW4qbt5ylJCKYlx3qgHFTHTr+q7mettHrk
	228OPcyrnC4ZMmwiUTktrP/9lHjBCcwZiWr2PsdZSJD/01xW4DGvTzAhzrynfaWoPSjsh4BDHs7
	p0TeNY/o+5oszeKoRLj8LTEWTM5s=
X-Google-Smtp-Source: AGHT+IGXCSZWvLRKFT7NJXNilWCinPsc/SVFE6bSQ9YmWlejc9mhru5MEAy0mGEjskm/QYn69DS7IUtliiRIpPNaMPg=
X-Received: by 2002:a17:906:f0cb:b0:a3e:c2de:2b9e with SMTP id
 dk11-20020a170906f0cb00b00a3ec2de2b9emr4144567ejb.39.1708952335539; Mon, 26
 Feb 2024 04:58:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130072238.2829831-1-maobibo@loongson.cn> <20240130072238.2829831-2-maobibo@loongson.cn>
In-Reply-To: <20240130072238.2829831-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 26 Feb 2024 20:58:43 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4rFwX2rm-PtvfY_4FA7qoj9UBH9or0LN31n+zdFozimg@mail.gmail.com>
Message-ID: <CAAhV-H4rFwX2rm-PtvfY_4FA7qoj9UBH9or0LN31n+zdFozimg@mail.gmail.com>
Subject: Re: [PATCH 1/2] LoongArch: KVM: Start SW timer only when vcpu is blocking
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Queued for loongarch-kvm, thanks.

Huacai

On Tue, Jan 30, 2024 at 3:22=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> SW timer is enabled when vcpu thread is scheduled out, and it is
> to wake up vcpu from blocked queue. If vcpu thread is scheduled out
> however is not blocked, such as it is preempted by other threads,
> it is not necessary to enable SW timer. Since vcpu thread is still
> on running queue if preempted and SW timer is only to wake up vcpu
> on blocking queue, so SW timer is not useful in this situation.
>
> This patch enables SW timer only when vcpu is scheduled out and
> is blocking.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/timer.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
> index 111328f60872..a9125f0a12d1 100644
> --- a/arch/loongarch/kvm/timer.c
> +++ b/arch/loongarch/kvm/timer.c
> @@ -93,7 +93,8 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
>         /*
>          * Freeze the soft-timer and sync the guest stable timer with it.
>          */
> -       hrtimer_cancel(&vcpu->arch.swtimer);
> +       if (kvm_vcpu_is_blocking(vcpu))
> +               hrtimer_cancel(&vcpu->arch.swtimer);
>
>         /*
>          * From LoongArch Reference Manual Volume 1 Chapter 7.6.2
> @@ -168,26 +169,19 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
>          * Here judge one-shot timer fired by checking whether TVAL is la=
rger
>          * than TCFG
>          */
> -       if (ticks < cfg) {
> +       if (ticks < cfg)
>                 delta =3D tick_to_ns(vcpu, ticks);
> -               expire =3D ktime_add_ns(ktime_get(), delta);
> -               vcpu->arch.expire =3D expire;
> +       else
> +               delta =3D 0;
> +       expire =3D ktime_add_ns(ktime_get(), delta);
> +       vcpu->arch.expire =3D expire;
> +       if (kvm_vcpu_is_blocking(vcpu)) {
>
>                 /*
>                  * HRTIMER_MODE_PINNED is suggested since vcpu may run in
>                  * the same physical cpu in next time
>                  */
>                 hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_A=
BS_PINNED);
> -       } else if (vcpu->stat.generic.blocking) {
> -               /*
> -                * Inject timer interrupt so that halt polling can dectec=
t and exit.
> -                * VCPU is scheduled out already and sleeps in rcuwait qu=
eue and
> -                * will not poll pending events again. kvm_queue_irq() is=
 not enough,
> -                * hrtimer swtimer should be used here.
> -                */
> -               expire =3D ktime_add_ns(ktime_get(), 10);
> -               vcpu->arch.expire =3D expire;
> -               hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_A=
BS_PINNED);
>         }
>  }
>
> --
> 2.39.3
>

