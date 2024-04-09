Return-Path: <kvm+bounces-13997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 534CA89DD5C
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DEDD28C7AC
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CE07C6D4;
	Tue,  9 Apr 2024 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvAFZfYK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648FD50A62
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712674538; cv=none; b=ZbZom6PXT+KLXPndljzs9BK9swfik5i4UYDvdvFQeC0uZhbRpVXn0TX2fzflRKwZ4/Qd42iMe/HIhMVLMvqRAVmuIuTwZM1jJ2RhgJcvgMSP/1/OFyuLs0s+KRFgVXIq8r7ZK8sxiqJRdyr3wruuSsEBIaUvEcCO2SUtAXV67fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712674538; c=relaxed/simple;
	bh=UQwQwW40lsaWrhU+7YpVfgsyR5CdlDhqhfNN8kjEXQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpNzzCRUvqgqrXiIhxu4cjmPe03h1zXg7qui9po5lakjhQW5mquZcy7Sfx4btjta7iO3RCw57dHudxIYEggJzAFBI/EN+fSKXO7GaDUYtYyqEUM8/+xHxVNpBOfGXPJbqnptcmNnxaPqE8LUt3n0dF7gQLHokgUDw3hf1wnw7Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvAFZfYK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DA7C433F1;
	Tue,  9 Apr 2024 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712674538;
	bh=UQwQwW40lsaWrhU+7YpVfgsyR5CdlDhqhfNN8kjEXQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HvAFZfYKT6B4fyfI7dRWdVu+d9AutKnrLtm+7jGin2TuGax6Wv6PGwF5EEDsWwNTQ
	 axEavutT+VEj7uwLShoYLXMB03YHRQao1TUpAuF2qmY4VNuFxW0rRL4Xe48u+sYR7L
	 upHpurquAgZYIJJEDeWKjF8gBy8KB5UmAx826DxaKtXYySgbnEWSf+4fDkuKkRbTy1
	 Vc/rsA1Mc7jYpKKGMX4X5ZH8F3QRyB9UTbeE0eRwbx6PDDFIhXMg0Wc9Ohc6332muy
	 XDyDCT26xcm+fcvCbQNQ2mdHICCVPu6OCFBUk5XjRn7PXHO6Y0Aou29jqNbK2XKfbR
	 X6QeBh2QPvy1w==
Date: Tue, 9 Apr 2024 15:55:32 +0100
From: Will Deacon <will@kernel.org>
To: =?utf-8?B?56em5bCR6Z2S?= <qinshaoqing@bosc.ac.cn>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org,
	Bonzini <pbonzini@redhat.com>, Patra <atishp@atishpatra.org>,
	Jones <ajones@ventanamicro.com>, Patel <anup@brainfault.org>,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Patel <apatel@ventanamicro.com>,
	=?utf-8?B?546L54S2?= <wangran@bosc.ac.cn>,
	=?utf-8?B?5byg5YGl?= <zhangjian@bosc.ac.cn>
Subject: Re: [kvmtool PATCH 1/1] riscv: Add zacas extension
Message-ID: <20240409145531.GA23464@willie-the-truck>
References: <3095a39b.95.18d3440cf62.Coremail.qinshaoqing@bosc.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3095a39b.95.18d3440cf62.Coremail.qinshaoqing@bosc.ac.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jan 23, 2024 at 10:57:59AM +0800, 秦少青 wrote:
> Add parsing for Zacas ISA extension which was ratified recently in the
> riscv-zacas manual.
> 
> Signed-off-by: Shaoqing Qin <qinshaoqing@bosc.ac.cn>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/asm/kvm.h             | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  3 files changed, 5 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 9af71b5..1b4f701 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -22,6 +22,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
>  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
>  	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
> +	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
>  	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
>  	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
> diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> index 992c5e4..0c65ff0 100644
> --- a/riscv/include/asm/kvm.h
> +++ b/riscv/include/asm/kvm.h
> @@ -122,6 +122,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZICBOM,
>  	KVM_RISCV_ISA_EXT_ZICBOZ,
>  	KVM_RISCV_ISA_EXT_ZBB,
> +	KVM_RISCV_ISA_EXT_ZACAS,
>  	KVM_RISCV_ISA_EXT_SSAIA,
>  	KVM_RISCV_ISA_EXT_V,
>  	KVM_RISCV_ISA_EXT_SVNAPOT,
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 863baea..7840f91 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -43,6 +43,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zbb",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
>  		    "Disable Zbb Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zacas",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
> +		    "Disable Zacas Extension"),				\
>  	OPT_BOOLEAN('\0', "disable-zicbom",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
>  		    "Disable Zicbom Extension"),			\

I tried to apply this now that the upstream kernel seems to understand
ZACAS, but the patch doesn't seem to apply against the latest kvmtool
sources.

Please can you rebase it onto the latest version and send a v2?

Thanks,

Will

