Return-Path: <kvm+bounces-44398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6EACA9DA12
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:20:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D87EE4C01A7
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 10:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7C3250C15;
	Sat, 26 Apr 2025 10:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZbZqfpT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4095224AF0;
	Sat, 26 Apr 2025 10:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745662791; cv=none; b=FxCNADjSe2V/ChBHfQaDhW2+l1CfbmHlHYZdWOiANfF5uePZ32F710VE46iRjyOAjrl+ozjlsQ8+K8MJH419qV7CTVtXra6bX8s0ljKZadK3WIBYv2z3L85vLQlhW+ErpOHAFfj/0F2nLppreMPtFVChH0VLF3ir9Pe/26y+49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745662791; c=relaxed/simple;
	bh=UpcT+3FkVUFNLUGi/AvO/GxU4NG3xBdJi0g1eg5g5Es=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhaFWkeVbx0klYGnSYad3ZQESaPqG/gPouXVIHiIqJ/gHWQFQtSV50afd1nK2eKbLEhDBzoY2jlsqzOW+0iOlRHJwHXr2m6MJhNX7R+yCB29dtmPQ2WG1oonEFJvmzu9Nas7hr1ayGEoM3wV3HuTdVAYPXibj+dQNe+vMNjYNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZbZqfpT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4013BC4CEEC;
	Sat, 26 Apr 2025 10:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745662791;
	bh=UpcT+3FkVUFNLUGi/AvO/GxU4NG3xBdJi0g1eg5g5Es=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lZbZqfpT5XCRZyHUKyWSd2q/NHHMVv0WZYYuChGpimW2WRMtm/BM2VwSjRGeJZ/lF
	 /8tfY5kZVQb4rbROd764Os0z3ASl9+CGh3McDvh2bf/SwNd5YQ4hYLsdLypxFSB9a7
	 kLlI8W+OKfiXRmZ5NRQ6pX+N6o9h31C2RKyThwMlN4bPytq8lnNekxF63hoAXWxnnQ
	 cqo1/7RpQD3p5xihqpVV8dSs3ndXfEKGYr92CLflfyDEbesVNXhfeCq7sw/wpH5JDF
	 Wt6PimeGSkh6sJcW3GIssQF+XRipydzl4hhuNQXx9iSxouK8YeWd3D8v4TC8aZEL1L
	 Y1j0uvBENJ++Q==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac25d2b2354so454742366b.1;
        Sat, 26 Apr 2025 03:19:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV1LYA93skgHLYaqzExZfRS8anwXxnQe/bahRcob9H96q3FGZaTZcLIY5rEmbLL2AyrVQU=@vger.kernel.org, AJvYcCXoJidnjMI33jqNtJ76DcwOj0JhVbkBjaJxy2jT4mOtWwQH6oZyj2zLiiKrMks+09PQ4fjP2Ic2Q0dpZI3E@vger.kernel.org
X-Gm-Message-State: AOJu0YxQr/YsyMj3F6yK6a8tcTREBJMjNMkNfRsjgd+QK5/E02AzHOri
	FRlrTAcSWFdXhoZ1FP2enT2rK/Y3toRGeWE5SBMI62IYzHcRZT07xK1zTh54mZmriHUo42PT3wc
	p0jbSz0WMG0wQlukT+KzRW/+aHx4=
X-Google-Smtp-Source: AGHT+IFZunK+Hb5PcsmB+ExxYU41URR2dFyUsmnj9Ou2OsbUODUNI09uby4WMsjfqq5YavsfeUwqbb29lU7Bt5heJ2Q=
X-Received: by 2002:a17:907:9721:b0:ace:3a1b:d3d with SMTP id
 a640c23a62f3a-ace71047f9dmr450900566b.2.1745662789824; Sat, 26 Apr 2025
 03:19:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250421011843.1760829-1-maobibo@loongson.cn>
In-Reply-To: <20250421011843.1760829-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 26 Apr 2025 18:19:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7AFE3Th0NzmwwmN4vxsFtj1w_fUzk1CWuUyycuP9twfQ@mail.gmail.com>
X-Gm-Features: ATxdqUEwrmnqGpPaJvW3i_JuTiLrPEM7vZIKcwgtTaEHvXdfMXPni9JNDr2IoYY
Message-ID: <CAAhV-H7AFE3Th0NzmwwmN4vxsFtj1w_fUzk1CWuUyycuP9twfQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix PMU pass-through issue if VM exits to
 host finally
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Song Gao <gaosong@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Mon, Apr 21, 2025 at 9:18=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> In function kvm_pre_enter_guest(), it prepares to enter guest and check
> whether there are pending signals or events. And it will not enter guest
> if there are, PMU pass-through preparation for guest should be cancelled
> and host should own PMU hardware.
>
> Fixes: f4e40ea9f78f ("LoongArch: KVM: Add PMU support for guest")
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 8e427b379661..d96191d65f53 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -294,6 +294,8 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>                 vcpu->arch.aux_inuse &=3D ~KVM_LARCH_SWCSR_LATEST;
>
>                 if (kvm_request_pending(vcpu) || xfer_to_guest_mode_work_=
pending()) {
> +                       /* Lose pmu for guest and let host own it */
> +                       kvm_lose_pmu(vcpu);
>                         /* make sure the vcpu mode has been written */
>                         smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
>                         local_irq_enable();
>
> base-commit: 3088d26962e802efa3aa5188f88f82a957f50b22
> --
> 2.39.3
>

