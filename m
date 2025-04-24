Return-Path: <kvm+bounces-44079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 834EEA9A2A3
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:53:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A219219448BF
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85EA1E9B00;
	Thu, 24 Apr 2025 06:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgDvjjii"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5331ABED9;
	Thu, 24 Apr 2025 06:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745477606; cv=none; b=PCUVdskhFWjYAghXkyZAt4dFNiQZvN1h+A4Erq07p0FTjeBXhvtk7y4sqdr/+SFHz/ERtgxSA4QyjfUrc0HI6HYBkDes7/p4LQhVh26xoyANi4ubAqpvHsJS3yZiG7yauJhzGsHe+yEQ6zVb5E3AQ166eOMHu4VEuFqUUh+gwfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745477606; c=relaxed/simple;
	bh=wlKQpy94IqzyU+pKooghPZEJEaFEFQ8/ABRnN07poLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tb8whkdLBi1m+zGePdixGmodoXMCDmXbBBJrVqecE6rvpX+b55wJ3/csMuFZ26hKOUffJZ2Izt98p8ZZtKMIJAMDyHZ0va40KjttQbLG0o75V3I5WGJdLHYKo2dDu7+ozSJBBGLmpCCCY/8q3neK8L27y1ijgFMDwT3QwmKmk5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgDvjjii; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640CFC4CEE3;
	Thu, 24 Apr 2025 06:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745477605;
	bh=wlKQpy94IqzyU+pKooghPZEJEaFEFQ8/ABRnN07poLY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QgDvjjiiLjTWMDQIqIJRE26DsCb7ijyKxM1NEmiLwAkwSX20cKrswu6mJSIbsChhY
	 y8D6DseLj1ol1emXgjqyebFDULIigdm+ImjkuTXP8A9LdZSJKnQ/gRrdFz1tIrFg4P
	 aG0p07UIFc/oLqOJNXf6NvoGAzdY5ABDpE9Ku8Bt0oo+HCmnwYE7TH6TP7BB3ZjrMy
	 FDL3DDpGzBrrA6Mr5+mXtgRs2aeKZtslRvQPdivTjWIbR3N/h0k/TwWhwFR5o8vzRJ
	 LcsF+6b3Ph7JtzOWaZPCc73a//qqTZcoKsBNhEoAmYXChspara/7OtWZe4FXN7MoKg
	 1zDjesO6bm7qw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso136106866b.0;
        Wed, 23 Apr 2025 23:53:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVxTG/ZlidhW6LXENJHutfI6cnS37bFacfDo+PX3e1llo5of0HkZc7FU0J3WxoltQP9XmE=@vger.kernel.org, AJvYcCWFrT/8c3goy+jU1hUGO+O5f7rofAhGp+VLtThVQe9/jFAiJDwAVoakqBeKZB+JD8i/tC1AzV9MGCwzrfap@vger.kernel.org
X-Gm-Message-State: AOJu0YxD7VPk+KhskoKPRUn3ZMVR9gHB9wT2K+MJIJH1HaNOXYaIfBtg
	qIcRJnLWFE9dXy8Bv175DBkes0KVegOJqZBwwBKL7bmMlGOZfZAmhtVsFDdLxUFCTCbFryUbFlM
	Gn8tXbhqlyQm+3v4UCvK4R1ltk6Q=
X-Google-Smtp-Source: AGHT+IH1zDQoImhAjJvlBx+jXOgO96zgQRudZPeaav77Ap7segvhQ9EbaDljRcugR4pGTRnLrHoM0tsYm7ckSeZhMyI=
X-Received: by 2002:a17:907:6d14:b0:acb:ac30:61f2 with SMTP id
 a640c23a62f3a-ace57243a02mr148306266b.18.1745477604025; Wed, 23 Apr 2025
 23:53:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424063846.3927992-1-maobibo@loongson.cn>
In-Reply-To: <20250424063846.3927992-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 24 Apr 2025 14:53:12 +0800
X-Gmail-Original-Message-ID: <CAAhV-H51WRgk8Bs5dsF1LrgdaqL7dk9ioy7H79voZKapov9U2g@mail.gmail.com>
X-Gm-Features: ATxdqUHx5-Smh2JOuE6F9uXUVMiBXP6P6-4_NPAhB-OqG8EgOVLqlotdPh5t5gQ
Message-ID: <CAAhV-H51WRgk8Bs5dsF1LrgdaqL7dk9ioy7H79voZKapov9U2g@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fully clear some registers when VM reboot
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Thu, Apr 24, 2025 at 2:38=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Some registers such as LOONGARCH_CSR_ESTAT and LOONGARCH_CSR_GINTC
> are partly cleared with function _kvm_set_csr(). This comes from hardware
I cannot find the _kvm_set_csr() function, maybe it's a typo?
And the tile can be "LoongArch: KVM: Fully clear some CSRs when VM reboot"

Huacai

> specification, some bits are read only in VM mode, and however it can be
> written in host mode. So it is partly cleared in VM mode, and can be full=
y
> cleared in host mode.
>
> These read only bits show pending interrupt or exception status. When VM
> reset, the read-only bits should be cleared, otherwise vCPU will receive
> unknown interrupts in boot stage.
>
> Here registers LOONGARCH_CSR_ESTAT/LOONGARCH_CSR_GINTC are fully cleared
> in ioctl KVM_REG_LOONGARCH_VCPU_RESET vCPU reset path.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 8e427b379661..80b2316d6f58 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -902,6 +902,14 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
>                         vcpu->arch.st.guest_addr =3D 0;
>                         memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->a=
rch.irq_pending));
>                         memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arc=
h.irq_clear));
> +
> +                       /*
> +                        * When vCPU reset, clear the ESTAT and GINTC reg=
isters
> +                        * And the other CSR registers are cleared with f=
unction
> +                        * _kvm_set_csr().
> +                        */
> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_G=
INTC, 0);
> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_E=
STAT, 0);
>                         break;
>                 default:
>                         ret =3D -EINVAL;
>
> base-commit: 9d7a0577c9db35c4cc52db90bc415ea248446472
> --
> 2.39.3
>
>

