Return-Path: <kvm+bounces-12672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C8C88BCED
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E6E52E45A0
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F591773D;
	Tue, 26 Mar 2024 08:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jUj21WCC"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1E14290
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 08:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711443428; cv=none; b=ORmYfFLFl6J6v2KKB9++bY3pGI6Y1gVkcXEuO0c6Jby6zvOMoZZ4Sciv5CJ6l5aGTO8P4Rq34LRuSc+7KrM3jJoIeBAa3io09sMB/niHIv+XC8El+mBZbJAvqQ4qt2u78wEf0pX83v61wGgYuXM4aqcS0Kec1zsJdWOrAFZ+aTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711443428; c=relaxed/simple;
	bh=Ehk5tfSYIrtoQtmHymO7bZ1bhwxDnv8ajVnz69qsRHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhe3QRhg/pVNyLJWvvdEDjp0vWjGnfD+AhT0HHJkjZ7zqJBggrZ9Af6ta/rDMPJm819gtlT+Fq4EHeOMh223ZcBJlzRYo5M3ySu7ZukNrYqsymyIgsUTI3IGwF8QJqw4ByKkf50FWemeZnabAt6/UWlMVekGkFi7wKpuMT4+Qxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jUj21WCC; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 26 Mar 2024 09:57:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711443423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bfy16LCtFYg0T7WUglQyqsCs6ROaU3KFsI0Pp96HXJ8=;
	b=jUj21WCCBFy7r44og7HmZ423/ZgB/mtBfzsskOm7uBCFhybsvT2GqfAM+/+cBPkAJWjq4Q
	6ZIrKI1hBu71JhYhmeYJeKboACJ2/9tXsVY54BvTQ3kESAUIQ60jVTZVb89Qil8xXzLfsi
	qsyjOqekzN7Hwos4vSyVswrhJIBXck4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Pavan Kumar Paluri <papaluri@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, nikos.nikoleris@arm.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, amit.shah@amd.com
Subject: Re: [kvm-unit-tests RFC PATCH 2/3] x86/efi: Retry call to efi exit
 boot services
Message-ID: <20240326-8247f506a6536cbee06e4a55@orel>
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240325213623.747590-2-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325213623.747590-2-papaluri@amd.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 25, 2024 at 04:36:22PM -0500, Pavan Kumar Paluri wrote:
> In some cases, KUT guest might fail to exit boot services due to a
> possible memory map update that might have taken place between
> efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
> spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
> to update the memory map and retry call to exit boot
> services.
> 
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  lib/efi.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 124e77685230..9d066bfad0b6 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -458,14 +458,27 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  	}
>  #endif
>  
> -	/* 
> +	/*
>  	 * Exit EFI boot services, let kvm-unit-tests take full control of the
> -	 * guest
> +	 * guest.
>  	 */
>  	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> -	if (status != EFI_SUCCESS) {
> -		printf("Failed to exit boot services\n");
> -		goto efi_main_error;
> +
> +	/*
> +	 * There is a possibility that memory map might have changed
> +	 * between efi_get_memory_map() and efi_exit_boot_services in
> +	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
> +	 * 2.10, we need to get the updated memory map and try again.
> +	 */
> +	if (status == EFI_INVALID_PARAMETER) {

Shouldn't we loop on this? The spec doesn't make it clear that the second
try should always work.

> +		efi_get_memory_map(&efi_bootinfo.mem_map);
> +
> +		status = efi_exit_boot_services(handle,
> +						&efi_bootinfo.mem_map);
> +		if (status != EFI_SUCCESS) {
> +			printf("Failed to exit boot services\n");
> +			goto efi_main_error;
> +		}
>  	}
>  
>  	/* Set up arch-specific resources */
> -- 
> 2.34.1
>

Thanks,
drew

