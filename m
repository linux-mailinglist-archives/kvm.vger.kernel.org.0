Return-Path: <kvm+bounces-62171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F284EC3AE30
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 13:28:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 011DC1A46C7D
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 12:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E4732AAC5;
	Thu,  6 Nov 2025 12:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILT1IGrL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF81A30BF7D
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 12:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762432072; cv=none; b=jajgLAb/pdD4XTwJUPIuQOuOChSixqScYFUa7hVPhSuk4hFVYdo5IInruKl5fFDpqfPWuWe8Qiz53dmg1bRxtMmA/sNuqGnI6q1oUNF4KCp2AGBmvW42UIZWH50WrLrPcRUPxccz6gCGOo0kLQ7YMmiGMiSi5cZmeYJLrTDRnvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762432072; c=relaxed/simple;
	bh=sm/KEkDKVz7vizhaeMVvJjcOC3jXdbItHDrSAh+s32Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hEROp/Y0FyAq4ndBQ7DtsLfl3ZjCtZ5JjKLDcT5z1zvn2dUVzGX6x0nvIrW9jv3rx/QkvkZSfdpvEuQp9f1N0Cr/jQWYtzgBlr81RpoewPuTNgAInFcBc+qeBYDIRvUA1XIcIcHv8xuXOVliqH1QOdb3VUPM91jzlGLHR13hVe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILT1IGrL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905B9C4AF0B
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 12:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762432072;
	bh=sm/KEkDKVz7vizhaeMVvJjcOC3jXdbItHDrSAh+s32Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ILT1IGrLAYWOfXBvB4nwal/UeIfixWNtXGoFSvifgSWFrxPrHrr+jjvrVDbnxGlTX
	 WNm++JnHuK89c4BGwoIPkzN0CTTYS5eeqZbxtBVBEhRErHK0KwbCfHlS8mHI24fBnW
	 S+wxfCm2DeOC8W7Svxjan4jXILutqd+0I7APAoCLBK1/vQNfMjhq34ahg2QxZU0f2f
	 4BR40Wn2VSQbg0bUoNBF0YrdFemd6Js2Ci4deRbczKwGFBmuUwa0ehwAWj40h8TwIg
	 gth8M5oMAWKvjNPSjV7Z/2Lwtdi4HX3vvrL5228q4UNnwtt4SQ7D+qMf4ERVc7qLGO
	 WK55Mq1NtHIQQ==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64034284521so1373040a12.1
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 04:27:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU9C99zD9Ajuxtmmz9oWw8PAWeEDmtW4dEijfiou6WQLf8hRgdPO85niJu/Z+s8NXAqcRg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrg+Z4+LBAwyB9JbMZlkBbqF2BIhqnn2gA5UTo7fY2XqzSki/r
	CrGMQE/qHAERqzqyVGL5PHSngihxgct654uCeEC7FJa5ZBPod0MKUkoXCoKh9EI6oV8LSTaDd8+
	vrGFjWOQM4GT4ITOpnvJbHahIQk5pk+g=
X-Google-Smtp-Source: AGHT+IFESibQa1gcJX7J+Cs+qz1FciOmFCrI+QgcI9cbug6Igg0lCqc39uumUPK1urXvMah7dkzf3k9m9UonBj3Rkuk=
X-Received: by 2002:a17:906:f59d:b0:b70:50f1:3daa with SMTP id
 a640c23a62f3a-b726564af26mr735644166b.57.1762432071206; Thu, 06 Nov 2025
 04:27:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104114659.1562404-1-maobibo@loongson.cn>
In-Reply-To: <20251104114659.1562404-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 6 Nov 2025 20:27:49 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5mzkpbZMmxtmGh3S8MAeWnn_Pfe6g-ZqWOER=oeOZNAQ@mail.gmail.com>
X-Gm-Features: AWmQ_blSEGRj-hJ4TXNc9b5AG3hqN2wmBcLXpbd4AuxFaGRrZc68C_g3pt6cP54
Message-ID: <CAAhV-H5mzkpbZMmxtmGh3S8MAeWnn_Pfe6g-ZqWOER=oeOZNAQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add delay until timer interrupt injected
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Tue, Nov 4, 2025 at 7:47=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> When timer is fired in oneshot mode, CSR TVAL will stop with value -1
> rather than 0. However when register CSR TVAL is restored, it will
> continue to count down rather than stop there.
>
> Now the method is to write 0 to CSR TVAL, wait to count down for 1
> cycle at least, which is 10ns with timer freq 100MHZ, and retore timer
> interrupt status. Here add 2 cycles delay to assure that timer interrupt
> is injected.
>
> With this patch, timer selftest case passes to run always.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/timer.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
> index 32dc213374be..daf1b60a8d47 100644
> --- a/arch/loongarch/kvm/timer.c
> +++ b/arch/loongarch/kvm/timer.c
> @@ -3,6 +3,7 @@
>   * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>   */
>
> +#include <asm/delay.h>
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_csr.h>
>  #include <asm/kvm_vcpu.h>
> @@ -95,6 +96,8 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
>                  * and set CSR TVAL with -1
>                  */
>                 write_gcsr_timertick(0);
> +               /* wait more than 1 cycle until timer interrupt injected =
*/
> +               __delay(2);
>
>                 /*
>                  * Writing CSR_TINTCLR_TI to LOONGARCH_CSR_TINTCLR will c=
lear
>
> base-commit: ec0b62ccc986c06552c57f54116171cfd186ef92
> --
> 2.39.3
>
>

