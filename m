Return-Path: <kvm+bounces-37661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F4017A2DBCC
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 10:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8A553A52B9
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 09:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6273B1509A0;
	Sun,  9 Feb 2025 09:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUBQTmCd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E9B13E02A;
	Sun,  9 Feb 2025 09:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739093914; cv=none; b=PuP9F4gYV1l6agWmFfMKvyD4VtSJZv5s6+yIDluWoioFL2uin1J5Eex/rvQ9dloaYnSEoIFRXBSvd1saVtuQXBW5ifAfEe+9AkXlYHBfOUhBMXo9oIbTIICEMkjlbCEAwO9DtY7jhMyWVq3T3H1mq3o6d+7vMFeabNEL9l+J0fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739093914; c=relaxed/simple;
	bh=keWDFt84Qk9PxNh98O77XqGOs0wHD5wAPaoGo2aheoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YhuKzKrf9LUqxK6rEzT4UTJdCKIOO75+FzBi4PsjNw8VSQlMi/VUIGnGt4kSnBZlFU6Up/E1bo6Zc5us7CuJvkPnjDfpsrAILPJ3kYOdMqMqrEyNnURjWCjTQF973w2caGwjt4f/niDC03rUYD68KT/rcUPXjmPIUV8kDLkfidU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUBQTmCd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BB4C4AF0B;
	Sun,  9 Feb 2025 09:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739093914;
	bh=keWDFt84Qk9PxNh98O77XqGOs0wHD5wAPaoGo2aheoE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QUBQTmCdM6mkWBoi1jlWr9/ycH/f0vLiGnMJEzxPLGRWH/swsAUZ+lgfTFnH5zO7C
	 xNOGVtegzgQOlrnwbbMR3h0AR8qPulmanp8Wj340NdbOvnXLK73WkCtSD1o3/1+KsY
	 Zg9G1ve7Z0hvhF+9YoezefiT2vJCCfkEHJIqTk93JlcW9Dpm+xKGODitcYT8NaFiig
	 m6XBeIOZWcn2tk+aFQBVBy9Z8TVrnALNV14xSUIkTs1gzs1AHoioHgmkwX81UM1M2q
	 OFCYt0v3oCjKDl6zpNiscAtgXdMob5S/vw1U/H/2cZ4DSey3eCCW7ZEewC/W9jXKC9
	 qtB1GlDqwlkPA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5de47cf93dfso3075325a12.2;
        Sun, 09 Feb 2025 01:38:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUhgX22cjjWDXGyMsk4LbILCb8Q2OIsAizKMIaVCIyCdMSgfhD/1GXk3C2ZxMUIJDnU1quiswvMo74o3zad@vger.kernel.org, AJvYcCWL0C6nAr5pfYxZBzqcfYKlLF4Lea/Wq/soAsf2AD3R4oFBCkrJuLnTvXxbF4XLXKAGhdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXyD8NwE+8zXQ/RMJAwSoErnggHLLMENUDrKOqE7seMxq2xlG5
	eMjqXZ/FtUSG3sCHEBm5JbRXQXrbg0V788IebzJ0A0hdkJvv3BTA1qZRRh46EN8CWk9tcjN7tXa
	KuYzzetxg9GUmA3r+3CVuSE7Cq84=
X-Google-Smtp-Source: AGHT+IHT9uUQ98YQu/y8BjhBTL/yULpuTzAAatVmfCc4Bj9x1TUc9cZz3jRCUiurw2GIyjm0NkKdrQU5jPMWlUXZLMw=
X-Received: by 2002:a05:6402:321d:b0:5dc:cfc5:9324 with SMTP id
 4fb4d7f45d1cf-5de4508084amr30165622a12.30.1739093912637; Sun, 09 Feb 2025
 01:38:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250207032634.2333300-1-maobibo@loongson.cn> <20250207032634.2333300-2-maobibo@loongson.cn>
In-Reply-To: <20250207032634.2333300-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 9 Feb 2025 17:38:21 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7p9G8At3Pz_o31u_Zpho2gfbe6WOxF6_WpebVfcfgaKQ@mail.gmail.com>
X-Gm-Features: AWEUYZlRdHv2bfY6zlWzB4lhsFqJqRV8CIJfvD701PfIrEvUhs9BHg9JVkMQT1M
Message-ID: <CAAhV-H7p9G8At3Pz_o31u_Zpho2gfbe6WOxF6_WpebVfcfgaKQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] LoongArch: KVM: Fix typo issue about GCFG feature detection
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Fri, Feb 7, 2025 at 11:26=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> This is typo issue about GCFG feature macro, comments is added for
> these macro and typo issue is fixed here.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/loongarch.h | 26 ++++++++++++++++++++++++++
>  arch/loongarch/kvm/main.c              |  4 ++--
>  2 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index 52651aa0e583..1a65b5a7d54a 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -502,49 +502,75 @@
>  #define LOONGARCH_CSR_GCFG             0x51    /* Guest config */
>  #define  CSR_GCFG_GPERF_SHIFT          24
>  #define  CSR_GCFG_GPERF_WIDTH          3
> +/* Number PMU register started from PM0 passthrough to VM */
>  #define  CSR_GCFG_GPERF                        (_ULCAST_(0x7) << CSR_GCF=
G_GPERF_SHIFT)
> +#define  CSR_GCFG_GPERFP_SHIFT         23
> +/* Read-only bit: show PMU passthrough supported or not */
> +#define  CSR_GCFG_GPERFP               (_ULCAST_(0x1) << CSR_GCFG_GPERFP=
_SHIFT)
>  #define  CSR_GCFG_GCI_SHIFT            20
>  #define  CSR_GCFG_GCI_WIDTH            2
>  #define  CSR_GCFG_GCI                  (_ULCAST_(0x3) << CSR_GCFG_GCI_SH=
IFT)
> +/* All cacheop instructions will trap to host */
>  #define  CSR_GCFG_GCI_ALL              (_ULCAST_(0x0) << CSR_GCFG_GCI_SH=
IFT)
> +/* Cacheop instruction except hit invalidate will trap to host */
>  #define  CSR_GCFG_GCI_HIT              (_ULCAST_(0x1) << CSR_GCFG_GCI_SH=
IFT)
> +/* Cacheop instruction except hit and index invalidate will trap to host=
 */
>  #define  CSR_GCFG_GCI_SECURE           (_ULCAST_(0x2) << CSR_GCFG_GCI_SH=
IFT)
>  #define  CSR_GCFG_GCIP_SHIFT           16
>  #define  CSR_GCFG_GCIP                 (_ULCAST_(0xf) << CSR_GCFG_GCIP_S=
HIFT)
> +/* Read-only bit: show feature CSR_GCFG_GCI_ALL supported or not */
>  #define  CSR_GCFG_GCIP_ALL             (_ULCAST_(0x1) << CSR_GCFG_GCIP_S=
HIFT)
> +/* Read-only bit: show feature CSR_GCFG_GCI_HIT supported or not */
>  #define  CSR_GCFG_GCIP_HIT             (_ULCAST_(0x1) << (CSR_GCFG_GCIP_=
SHIFT + 1))
> +/* Read-only bit: show feature CSR_GCFG_GCI_SECURE supported or not */
>  #define  CSR_GCFG_GCIP_SECURE          (_ULCAST_(0x1) << (CSR_GCFG_GCIP_=
SHIFT + 2))
>  #define  CSR_GCFG_TORU_SHIFT           15
> +/* Operation with CSR register unimplemented will trap to host */
>  #define  CSR_GCFG_TORU                 (_ULCAST_(0x1) << CSR_GCFG_TORU_S=
HIFT)
>  #define  CSR_GCFG_TORUP_SHIFT          14
> +/* Read-only bit: show feature CSR_GCFG_TORU supported or not */
>  #define  CSR_GCFG_TORUP                        (_ULCAST_(0x1) << CSR_GCF=
G_TORUP_SHIFT)
>  #define  CSR_GCFG_TOP_SHIFT            13
> +/* Modificattion with CRMD.PLV will trap to host */
>  #define  CSR_GCFG_TOP                  (_ULCAST_(0x1) << CSR_GCFG_TOP_SH=
IFT)
>  #define  CSR_GCFG_TOPP_SHIFT           12
> +/* Read-only bit: show feature CSR_GCFG_TOP supported or not */
>  #define  CSR_GCFG_TOPP                 (_ULCAST_(0x1) << CSR_GCFG_TOPP_S=
HIFT)
>  #define  CSR_GCFG_TOE_SHIFT            11
> +/* ertn instruction will trap to host */
>  #define  CSR_GCFG_TOE                  (_ULCAST_(0x1) << CSR_GCFG_TOE_SH=
IFT)
>  #define  CSR_GCFG_TOEP_SHIFT           10
> +/* Read-only bit: show feature CSR_GCFG_TOE supported or not */
>  #define  CSR_GCFG_TOEP                 (_ULCAST_(0x1) << CSR_GCFG_TOEP_S=
HIFT)
>  #define  CSR_GCFG_TIT_SHIFT            9
> +/* Timer instruction such as rdtime/TCFG/TVAL will trap to host */
>  #define  CSR_GCFG_TIT                  (_ULCAST_(0x1) << CSR_GCFG_TIT_SH=
IFT)
>  #define  CSR_GCFG_TITP_SHIFT           8
> +/* Read-only bit: show feature CSR_GCFG_TIT supported or not */
>  #define  CSR_GCFG_TITP                 (_ULCAST_(0x1) << CSR_GCFG_TITP_S=
HIFT)
>  #define  CSR_GCFG_SIT_SHIFT            7
> +/* All privilege instruction will trap to host */
>  #define  CSR_GCFG_SIT                  (_ULCAST_(0x1) << CSR_GCFG_SIT_SH=
IFT)
>  #define  CSR_GCFG_SITP_SHIFT           6
> +/* Read-only bit: show feature CSR_GCFG_SIT supported or not */
>  #define  CSR_GCFG_SITP                 (_ULCAST_(0x1) << CSR_GCFG_SITP_S=
HIFT)
>  #define  CSR_GCFG_MATC_SHITF           4
>  #define  CSR_GCFG_MATC_WIDTH           2
>  #define  CSR_GCFG_MATC_MASK            (_ULCAST_(0x3) << CSR_GCFG_MATC_S=
HITF)
> +/* Cache attribute comes from GVA->GPA mapping */
>  #define  CSR_GCFG_MATC_GUEST           (_ULCAST_(0x0) << CSR_GCFG_MATC_S=
HITF)
> +/* Cache attribute comes from GPA->HPA mapping */
>  #define  CSR_GCFG_MATC_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATC_S=
HITF)
> +/* Cache attribute comes from weaker one of GVA->GPA and GPA->HPA mappin=
g */
>  #define  CSR_GCFG_MATC_NEST            (_ULCAST_(0x2) << CSR_GCFG_MATC_S=
HITF)
>  #define  CSR_GCFG_MATP_NEST_SHIFT      2
> +/* Read-only bit: show feature CSR_GCFG_MATC_NEST supported or not */
>  #define  CSR_GCFG_MATP_NEST            (_ULCAST_(0x1) << CSR_GCFG_MATP_N=
EST_SHIFT)
>  #define  CSR_GCFG_MATP_ROOT_SHIFT      1
> +/* Read-only bit: show feature CSR_GCFG_MATC_ROOT supported or not */
>  #define  CSR_GCFG_MATP_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATP_R=
OOT_SHIFT)
>  #define  CSR_GCFG_MATP_GUEST_SHIFT     0
> +/* Read-only bit: show feature CSR_GCFG_MATC_GUEST suppoorted or not */
>  #define  CSR_GCFG_MATP_GUEST           (_ULCAST_(0x1) << CSR_GCFG_MATP_G=
UEST_SHIFT)
Bugfix is the majority here, so it is better to remove the comments,
make this patch easier to be backported to stable branches.

Huacai

>
>  #define LOONGARCH_CSR_GINTC            0x52    /* Guest interrupt contro=
l */
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index bf9268bf26d5..f6d3242b9234 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -303,9 +303,9 @@ int kvm_arch_enable_virtualization_cpu(void)
>          * TOE=3D0:       Trap on Exception.
>          * TIT=3D0:       Trap on Timer.
>          */
> -       if (env & CSR_GCFG_GCIP_ALL)
> +       if (env & CSR_GCFG_GCIP_SECURE)
>                 gcfg |=3D CSR_GCFG_GCI_SECURE;
> -       if (env & CSR_GCFG_MATC_ROOT)
> +       if (env & CSR_GCFG_MATP_ROOT)
>                 gcfg |=3D CSR_GCFG_MATC_ROOT;
>
>         write_csr_gcfg(gcfg);
> --
> 2.39.3
>

