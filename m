Return-Path: <kvm+bounces-56274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FD7B3B861
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05AA5204471
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C953E3081CC;
	Fri, 29 Aug 2025 10:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMLlyFpE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FD12FE07C;
	Fri, 29 Aug 2025 10:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462407; cv=none; b=l8Rsaum5YoduHyXY/qRxBmmnxqL+MiFNGwh3wAfhPgLnbm2Zve70S4B4yrcwDiQEirPJ+bTCE2DyNRRRIPNUBmNv57fLMuoZyXgwkvWW5jw4dVsrzwMOyRVA9hZItdnKbyOewaZPrNbUWNfrQ0lrj5FbwzX60GoYuuH0VEVgOQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462407; c=relaxed/simple;
	bh=sfatOopvVhU+pGUeNgSTPSm6N8YxhwlJmZkrU8pfqOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JCWIvx/dCGK1MfPFUUEx21RaucIUSFmo4sODDFrQ3gR/Ce/kGWZWr9xzQCnQUhLxhBkVcOGWBu3gdL24UNtlEAT0bO3kPv39ndlTsWMx2CsL+AA/0V2B2zd6leglY/S0bGtTq2eJo7hldrjx4lWEIW/JRiM9sOCZkTbEPRVQdzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMLlyFpE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9001DC4CEF4;
	Fri, 29 Aug 2025 10:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756462406;
	bh=sfatOopvVhU+pGUeNgSTPSm6N8YxhwlJmZkrU8pfqOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nMLlyFpEJK7X/bWG5W2gHsIA0jRTWUzYmyhx8mjdju8+4jOedxFdnoLGKuU73uKT2
	 pXfE9T91TuAj8AgZyDNSJzpRP16Iv0oBLcw0vV3VbWrzp9cLAi94GeBZicxVNpCOk7
	 iA2OqeM+fnLpIvuRD2LMQE7MjemoGlB/vU4AkcUJKtjJkIB2QE7dnY4yZZ+5n/dwgV
	 pi3Kyt4LSG8qiNV3zvqgVBIvre8DvFwkvwa+kSaH9uk/+bZ9lop3ivPurUsFebGDwl
	 lE4Pxw6aGspLgKZDpfNBmGgeC2kfyLpfLpCCU+fOIdkOGISrPRBWxxj6I7qQV0Fn6g
	 Z9hHJ/vzG+ZRA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afeceee8bb1so280269266b.3;
        Fri, 29 Aug 2025 03:13:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUY9ohjtTjHw7uFqasdS8ZvRBSlQ8xCl1mOTyeSTeNgyofM26SCAHAOjuYJvhyKif2nFFXwlbYH8foMDTwc@vger.kernel.org, AJvYcCW/2yJ5eDGoRC98TjqbjA/81DFKe3bcKcz87AjK7Yb5FVCr5N0XYaZJe23ZQyCvQupP1j8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaBLOWjGF7B0xRK8z0CPgMH4RJLz7AUeZ1pbLfzk5rNHMPTMiw
	C0oBkOi5DMYkB+TS+AjSzNrUPRsOM+CNq4sQ9k04mi+EqwGZoJ3/46kTz5Z9bhvBOrSgrsL0X/a
	kNrDjYW0onyjHOVR4n4M7idL9rz131pw=
X-Google-Smtp-Source: AGHT+IHLddUbYRy+BM+Sh0MTWUqk2T0rzSD/e1kuvihsBzjXdCdktKsTj20/zAF+CKh4JQliiUrP03WEy1Qf81wmikw=
X-Received: by 2002:a17:907:7fa1:b0:afe:7b35:9c8e with SMTP id
 a640c23a62f3a-afe7b359d2fmr1835749466b.12.1756462405153; Fri, 29 Aug 2025
 03:13:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250811021344.3678306-1-maobibo@loongson.cn>
In-Reply-To: <20250811021344.3678306-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 29 Aug 2025 18:13:09 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5E6UMo2zQiDLr3nBUGUt0HCfmCza5zja9eqL9jThKhoA@mail.gmail.com>
X-Gm-Features: Ac12FXzD1STqE5bjaWBZPYP3xxWwomWdGTRTvX_rsKShPydoI_UwB46XIN4hSKo
Message-ID: <CAAhV-H5E6UMo2zQiDLr3nBUGUt0HCfmCza5zja9eqL9jThKhoA@mail.gmail.com>
Subject: Re: [PATCH 0/5] LoongArch: KVM: Support various access size with
 pch_pic emulation
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied with some modifications (e.g. rename LoongArchPIC_ID to
pch_pic_id for kernel coding style), so you'd better test it [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongs=
on.git/log/?h=3Dloongarch-kvm


Huacai

On Mon, Aug 11, 2025 at 10:13=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> With PCH PIC interrupt controller emulation driver, its access size is
> hardcoded now. Instead the MMIO register can be accessed with different
> size such 1/2/4/8.
>
> This patchset adds various read/write size support with emulation
> function loongarch_pch_pic_read() and loongarch_pch_pic_write().
>
> Bibo Mao (5):
>   LoongArch: KVM: Set version information at initial stage
>   LoongArch: KVM: Add read length support in loongarch_pch_pic_read()
>   LoongArch: KVM: Add IRR and ISR register read emulation
>   LoongArch: KVM: Add different length support in
>     loongarch_pch_pic_write()
>   LoongArch: KVM: Add address alignment check in pch_pic register access
>
>  arch/loongarch/include/asm/kvm_pch_pic.h |  15 +-
>  arch/loongarch/kvm/intc/pch_pic.c        | 239 ++++++++++-------------
>  2 files changed, 120 insertions(+), 134 deletions(-)
>
>
> base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> --
> 2.39.3
>
>

