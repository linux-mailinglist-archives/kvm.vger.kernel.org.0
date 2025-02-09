Return-Path: <kvm+bounces-37662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA489A2DBDC
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 10:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56548165319
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 09:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6F41531E3;
	Sun,  9 Feb 2025 09:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qfj/WpNl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3F013BC35;
	Sun,  9 Feb 2025 09:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739094476; cv=none; b=N3GGFPPmEbj4XX2eEpOFX/D8I9rNJbHDtobtOhB/SW+sxuXWTR5Q1XAKBEyELA9EEw9pGlsLs77Acv33DFNt5/XZ0FCvxCINd7Ox94OYEYMMrt1r2gwrxwuPVp3z5aNQRdGk+MFntvokQshh6qaO3R1dY/hac1K+W/2DdEfdy1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739094476; c=relaxed/simple;
	bh=6DNfODvssdyHcZrHzMy5Bx/XkdAD8dxNPadgLQ9LkS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cgHhHVokvhaV9/+VrCB5MDIF50vbYK83mDqJ+/Z1zrzqlvg/7S2prws3NnsJyaGuAefMwM0qLbMGcPeGQ/ySyswnb27Pe6wJxsoDDXiZ7+Si0MRhSiRLeGLI3wovUK0/SaiFvCrtYCKnOjX4/MoJy4GXfWtwmc4adzIBYMdZG7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qfj/WpNl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50988C4CEE8;
	Sun,  9 Feb 2025 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739094476;
	bh=6DNfODvssdyHcZrHzMy5Bx/XkdAD8dxNPadgLQ9LkS8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Qfj/WpNl597razFYCQ0I5DE/mdr6ZVs/5zpjw/F7efdE1tFVmywvxBm5NTtM/DP8E
	 nGgz6Snw8Jhxwy8unNVkgdwyjMPmtrOC7YwupZCQALqhJraSAQN+QLpzhdR28niOXD
	 Grkr9DzcUTHe9iwvWBVpAyuNxXy1UT61UkCWoEM3B4YYliyEGo2EO/Qgyprf5wyOcz
	 b2K+SqWelyNwgNRJwKb+razcFVCOGNknqhSME/zmdrYsgT30mF635BM23XVXzWu0V5
	 voYkyvUKyoRHK1Rg1XZjNTKz7c6oaeTf7SSPKgSdkJpY02t09rS/8aDRF5cHI1DJw7
	 AG0zO7o++MA8w==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5de6069ceb5so1536507a12.1;
        Sun, 09 Feb 2025 01:47:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV01tmcEhJUliNqBokLha9CUbBggz8hNWAm42OUBRXLQJ5i5LsUWsPOB3W7TPWKOMP98z4=@vger.kernel.org, AJvYcCXZwSLUmodiGzzOTge9teshiB+FQer13C7/eI30nxjOCkd2vS0zusSjs7C/JgHhSim8bIOithY637mPUhvS@vger.kernel.org
X-Gm-Message-State: AOJu0YyY+NtN5LRNx/ZcMxT2HxXKe9DKFVI5CX+kq3svl7wY0QYqcCFB
	KCNhwP7vi5ly+IahVQd1EkT2BMl8mWuNYsEWLQGeoLBx32NjlEXFJ03FCHvTcju325p+q9hMb/Y
	Mk6dlnUtnS0DQEFctwysQGstkohU=
X-Google-Smtp-Source: AGHT+IG9LFzAf1oenYrJnOJQmeB1eV5sB56zP5YZtXIaoNugLOCg3z8jy3MxS04sySHdN9xDe0gHKtPZvCGIHJQ6r28=
X-Received: by 2002:a05:6402:194b:b0:5dc:8fc1:b3b5 with SMTP id
 4fb4d7f45d1cf-5de46a4f1cfmr9953881a12.15.1739094474931; Sun, 09 Feb 2025
 01:47:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250207032634.2333300-1-maobibo@loongson.cn> <20250207032634.2333300-4-maobibo@loongson.cn>
In-Reply-To: <20250207032634.2333300-4-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 9 Feb 2025 17:47:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4o7WS6J-eU=3VR16iVscrr5znpa67Do96cxmd6A0JS0g@mail.gmail.com>
X-Gm-Features: AWEUYZn5Y04jyrm4Rwpw69Gq9kl-fqicb-nqqOLjPalkQsEh8JtKtfYJPdcQ0zw
Message-ID: <CAAhV-H4o7WS6J-eU=3VR16iVscrr5znpa67Do96cxmd6A0JS0g@mail.gmail.com>
Subject: Re: [PATCH 3/3] LoongArch: KVM: Set host with kernel mode when switch
 to VM mode
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Fri, Feb 7, 2025 at 11:26=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> PRMD and ERA register is only meaningful on the beginning stage
> of exception entry, and it can be overwritten for nested irq or
> exception.
The code doesn't touch ERA, so ERA in the commit message is a typo?

Huacai
>
> When CPU runs in VM mode, interrupt need be enabled on host. And the
> mode for host had better be kernel mode rather than random.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/switch.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index 0c292f818492..1be185e94807 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -85,7 +85,7 @@
>          * Guest CRMD comes from separate GCSR_CRMD register
>          */
>         ori     t0, zero, CSR_PRMD_PIE
> -       csrxchg t0, t0,   LOONGARCH_CSR_PRMD
> +       csrwr   t0, LOONGARCH_CSR_PRMD
>
>         /* Set PVM bit to setup ertn to guest context */
>         ori     t0, zero, CSR_GSTAT_PVM
> --
> 2.39.3
>

