Return-Path: <kvm+bounces-37879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85260A30F6C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1020D3A3885
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F4187250BE2;
	Tue, 11 Feb 2025 15:16:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC838320F
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739286984; cv=none; b=do8kQC2jgCJf2shLecoYtAFiDGR0443E/JUCFwA5GAx9MrY0JaHuIXXthpl6XhFuYzh8S73nMctWm6qPVmPOb+2dAMd5ORvk/8HEc7IGayP1VSfktF/8xNiQh6FP8zpUtoR51Sa6rVbeVkOfWRgfGtYI5kLE2B3nEiTRsHjF+us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739286984; c=relaxed/simple;
	bh=oZ09FJmn+Z8euj3LYf2twh7Qmv2ffcvT4atyKSfhDhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2UKJLq61U6UfaPWo0dkDuhRT9Bz6FtfStTI2IFtF/Afuks8NG4MDV9o2lU/NDk3WW+qwIINieY0q6L82aqX/hLvatzGr7mCv/t29MgHzmlqg0iL2pxaq49yiMU1mQdQFR7dPDfP//cIgIq7FGtHPzUP8y9r9hRKuj0IzHHsHo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89566113E;
	Tue, 11 Feb 2025 07:16:43 -0800 (PST)
Received: from arm.com (e134078.arm.com [10.1.26.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 646043F5A1;
	Tue, 11 Feb 2025 07:16:21 -0800 (PST)
Date: Tue, 11 Feb 2025 15:16:18 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: Re: [kvmtool PATCH] riscv: Fix no params with nodefault segfault
Message-ID: <Z6tpwskaTCfS2mjR@arm.com>
References: <20250123151339.185908-2-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123151339.185908-2-ajones@ventanamicro.com>

Hi Drew,

On Thu, Jan 23, 2025 at 04:13:40PM +0100, Andrew Jones wrote:
> Fix segfault received when using --nodefault without --params.
> 
> Fixes: 7c9aac003925 ("riscv: Generate FDT at runtime for Guest/VM")
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  riscv/fdt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 85c8f95604f6..f6a702533258 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -256,9 +256,10 @@ static int setup_fdt(struct kvm *kvm)
>  		if (kvm->cfg.kernel_cmdline)
>  			_FDT(fdt_property_string(fdt, "bootargs",
>  						 kvm->cfg.kernel_cmdline));
> -	} else
> +	} else if (kvm->cfg.real_cmdline) {

Looks good to me, matches how arm/fdt.c handles real_cmdline:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Some context here. Before the patch that introduced --nodefaults, in commit
5613ae26b998 ("Add --nodefaults command line argument"), kvmtool would
always fiddle with the kernel command line to make it more likely that a
kernel boots - kvm_cmd_run_init() called kvm_run_set_real_cmdline()
unconditionally, which made it that kvm->cfg.real_cmdline was always
pointing to a valid string. Hence no check was needed here.

After --nodefaults was introduced, if the user specifies --nodefaults and
doesn't set the kernel command line (via -p/--params), real_cmdline ends up
being NULL and the fdt generator segfaults below.

The riscv port was developed in parallel to the series that introduced
--nodefaults, so I guess this check was missed during integration.

Thanks,
Alex

>  		_FDT(fdt_property_string(fdt, "bootargs",
>  					 kvm->cfg.real_cmdline));
> +	}
>  
>  	_FDT(fdt_property_string(fdt, "stdout-path", "serial0"));
>  
> -- 
> 2.48.1
> 

