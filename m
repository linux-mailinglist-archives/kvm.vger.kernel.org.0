Return-Path: <kvm+bounces-32882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C279E1175
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 03:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66562283512
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90F9154BE4;
	Tue,  3 Dec 2024 02:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9iEx1Da"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73D7664C6;
	Tue,  3 Dec 2024 02:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733194109; cv=none; b=pLcZVEnq1g4aL2a3EMA0CEu09H/mZIhfvmP3lBxYMwFxClGl9rWrvEakqaVtK/YV89Vsfpi6C/n0mdKGUCQmCuAjL5j+L4EeyPbPRpbKsFGQK7fkdnfQGKu5gz02wBC9XjhLPBrp5reMatjrSIBE4UTpcIBbVDhmpsbCGX+a6KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733194109; c=relaxed/simple;
	bh=Ri81F8s7VDqEINClmL8zxP8/WqatIKjpNaAF/YdMX6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D/vuiWm3cwyIdWNjU39/SOlGhb8VU5oF2P+YsT3toLfsoVyHNcf9IWV4gmAI2Cgr1xgsAKIZyP5AnjuW/2iJqaaGl7hL7ziT12v09FX8c3S+iiMocOIHS3eFaW8nhx44lrWZtHvl4Y+I98VqAU5A49lyWYiiag80PbEteKZ7DqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9iEx1Da; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773DEC4CED1;
	Tue,  3 Dec 2024 02:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733194108;
	bh=Ri81F8s7VDqEINClmL8zxP8/WqatIKjpNaAF/YdMX6M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O9iEx1Daz4MHk6c5tfOgBgmtshtDwWN6viGqR321oXs1hkZbc0VHWV5gWkj2cgVO6
	 U1K9e4jG+VfIid9HYUxx9xIB5KxbZdvEK/4mSr4hFgoZzpP0SPLKIiuyvpYGgM4HzR
	 2oay2jmC61v0h0HEXWbsIZzGUuNshFwr7DCIGVJT1zK9VfOEoSdmfsFf5KsXZfZUjE
	 D/TkaNMWfqI/ZGcQEAMaKF3CfRo8p1rDyXMJOkIeh9l9zlG0gqSwCc7IHl3qdZoIJE
	 J5Z8Ow+0b6KF6p4lPwmjf/wyciBQm4/mvt7Z3lNiVK1DK679DKpuyzI8xCNuVgufqp
	 UlPfJgcbGRZWA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5ceca0ec4e7so6299428a12.0;
        Mon, 02 Dec 2024 18:48:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU4M0puL4F7kTc0ywe6U6lAXTs1BE0JCu+TdIVf0hBdchvaS8y09isdZaTXAwGk3AlZnWE=@vger.kernel.org, AJvYcCUJszMKUGOyBNdU0pV3+Tw0oD51UgtJRP94HvAwQZQdQhQGRinewSTX8H2XHtoMRFJpTEmwMCLzIb87zJIo@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9kti25m+FVB9KCXR25ZtiNvjlG34sKxXBd82tjDqF6UwqNaBG
	uB6MKeyKnMikQ7w2Jpj8wHjm2MkhDV1RvrZTPk4rY/Gd1hmQzQn2p5jDb1nHChWowuVrj/OfC7r
	nI7ya5vXA4qjRO/VKDYRK+nnJLO0=
X-Google-Smtp-Source: AGHT+IGscLpawf7f6yZPm22Rs/zQKbI/RCadnboB5yGetH6zCt2ARfqNSbsFkg8d3UsuwHvdhRZowIIiCAeCHF7lpmI=
X-Received: by 2002:a17:906:bfea:b0:aa5:3631:adcb with SMTP id
 a640c23a62f3a-aa5f7f4717emr39000766b.53.1733194107097; Mon, 02 Dec 2024
 18:48:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241113031727.2815628-1-maobibo@loongson.cn> <20241113031727.2815628-6-maobibo@loongson.cn>
In-Reply-To: <20241113031727.2815628-6-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Dec 2024 10:48:18 +0800
X-Gmail-Original-Message-ID: <CAAhV-H54WbE_6CM8L3q_jRjA_VXLqX_msEmzOmwy2s0dFABCgw@mail.gmail.com>
Message-ID: <CAAhV-H54WbE_6CM8L3q_jRjA_VXLqX_msEmzOmwy2s0dFABCgw@mail.gmail.com>
Subject: Re: [RFC 5/5] LoongArch: KVM: Enable separate vmid feature
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

I think you need to probe LOONGARCH_CPU_GUESTID at the end of
cpu_probe_common(), otherwise cpu_has_guestid is always false.

Huacai

On Wed, Nov 13, 2024 at 11:17=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> With CSR GTLBC shortname for Guest TLB Control Register, separate vmid
> feature will be enabled if bit 14 CSR_GTLBC_USEVMID is set. Enable
> this feature if cpu_has_guestid is true when KVM module is loaded.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/loongarch.h | 2 ++
>  arch/loongarch/kvm/main.c              | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index 64ad277e096e..5fee5db3bea0 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -326,6 +326,8 @@
>  #define  CSR_GTLBC_TGID_WIDTH          8
>  #define  CSR_GTLBC_TGID_SHIFT_END      (CSR_GTLBC_TGID_SHIFT + CSR_GTLBC=
_TGID_WIDTH - 1)
>  #define  CSR_GTLBC_TGID                        (_ULCAST_(0xff) << CSR_GT=
LBC_TGID_SHIFT)
> +#define  CSR_GTLBC_USEVMID_SHIFT       14
> +#define  CSR_GTLBC_USEVMID             (_ULCAST_(0x1) << CSR_GTLBC_USEVM=
ID_SHIFT)
>  #define  CSR_GTLBC_TOTI_SHIFT          13
>  #define  CSR_GTLBC_TOTI                        (_ULCAST_(0x1) << CSR_GTL=
BC_TOTI_SHIFT)
>  #define  CSR_GTLBC_USETGID_SHIFT       12
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index f89d1df885d7..50c977d8b414 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -336,7 +336,7 @@ int kvm_arch_enable_virtualization_cpu(void)
>         write_csr_gcfg(0);
>         write_csr_gstat(0);
>         write_csr_gintc(0);
> -       clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
> +       clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI | CSR_GTLBC_US=
EVMID);
>
>         /*
>          * Enable virtualization features granting guest direct control o=
f
> @@ -359,6 +359,8 @@ int kvm_arch_enable_virtualization_cpu(void)
>
>         /* Enable using TGID  */
>         set_csr_gtlbc(CSR_GTLBC_USETGID);
> +       if (cpu_has_guestid)
> +               set_csr_gtlbc(CSR_GTLBC_USEVMID);
>         kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
>                   read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), re=
ad_csr_gtlbc());
>
> --
> 2.39.3
>

