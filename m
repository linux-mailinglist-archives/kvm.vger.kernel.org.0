Return-Path: <kvm+bounces-13027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52880890536
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 17:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05B1F2919DA
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289863A1B9;
	Thu, 28 Mar 2024 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="piD/70SG"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55A22BAF0
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643602; cv=none; b=mVpmUJztc7YTbPzbTdKDZFtaJmYgCAfHyywPABFTG/+22aXAWhAoJ5yNZ5C1jKU8TrGMPkSmCJxuEAKklpTYvIz+8zpilUT8pvncyE1Fsu2zvuKxDSvvrvFXoFHcpK24DdPsp1gnCuw3Aw1FOfQvrxXFJKFkKUexlIGbfDjTBPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643602; c=relaxed/simple;
	bh=dZ77VS8/TtSlIt3L5XA9XJ/O4KgfaDANcmlTp4LvCKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EdMQ246Gjn9Vn4mgH40OQKDS2VPDTJWp4CQ659sXZpwEkUZyiviepsgQeHLytLGBkO4cem1dgyrjBnvT2LgP7rtpNMeMXNL20AtJ3GzrQjJxsom4/fRbtddI2pC6xSMoemdrsK05RBK10Wy7U/BECZz9GfXlXxTpD+bDLdvQ5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=piD/70SG; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 28 Mar 2024 17:33:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711643597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bKEib2bEJnAPoNV2uO3LaVz4u6jFBFPp+zoBKvjPn7I=;
	b=piD/70SG4CyK3nMYWXytRPZ1JlXyULpilygvQ0LbHQPPHx+zXj+mHKF6vNC5Qu8RJ3Mjsp
	Il2A2pQ0mYH5C4hTUbeZPfNkHgM2uD7XziNvsLOShebvEogu4Bbra9ZH3Kejmgl6OJKb4k
	8jG8gsmQdSHnVrVoOoY1mJQk3uYScLs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Pavan Kumar Paluri <papaluri@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	michael.roth@amd.com
Subject: Re: [kvm-unit-tests PATCH v3 2/4] x86/efi: Retry call to efi exit
 boot services
Message-ID: <20240328-47ec1cd5ebf2292beed09e77@orel>
References: <20240328152112.800177-1-papaluri@amd.com>
 <20240328152112.800177-2-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328152112.800177-2-papaluri@amd.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 28, 2024 at 10:21:10AM -0500, Pavan Kumar Paluri wrote:
> In some cases, KUT guest might fail to exit boot services due to a
> possible memory map update that might have taken place between
> efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
> spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
> to keep trying to update the memory map and calls to exit boot
> services as long as case status is EFI_INVALID_PARAMETER. Keep freeing
> the old memory map before obtaining new memory map via
> efi_get_memory_map() in case of exit boot services failure.
> 
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  lib/efi.c | 34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 8a74a22834a4..d2569b22b4f2 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -406,8 +406,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  	efi_system_table = sys_tab;
>  
>  	/* Memory map struct values */
> -	efi_memory_desc_t *map = NULL;
> -	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
> +	efi_memory_desc_t *map;
> +	unsigned long map_size, desc_size, key, buff_size;
>  	u32 desc_ver;
>  
>  	/* Helper variables needed to get the cmdline */
> @@ -446,13 +446,6 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  	efi_bootinfo.mem_map.key_ptr = &key;
>  	efi_bootinfo.mem_map.buff_size = &buff_size;
>  
> -	/* Get EFI memory map */
> -	status = efi_get_memory_map(&efi_bootinfo.mem_map);
> -	if (status != EFI_SUCCESS) {
> -		printf("Failed to get memory map\n");
> -		goto efi_main_error;
> -	}
> -
>  #ifdef __riscv
>  	status = efi_get_boot_hartid();
>  	if (status != EFI_SUCCESS) {
> @@ -461,11 +454,24 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  	}
>  #endif
>  
> -	/* 
> -	 * Exit EFI boot services, let kvm-unit-tests take full control of the
> -	 * guest
> -	 */
> -	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> +	status = EFI_INVALID_PARAMETER;
> +	while (status == EFI_INVALID_PARAMETER) {
> +		/* Get EFI memory map */

I tried to get rid of this comment since it states the exact same thing
as the function name below does.

> +		status = efi_get_memory_map(&efi_bootinfo.mem_map);
> +		if (status != EFI_SUCCESS) {
> +			printf("Failed to get memory map\n");
> +			goto efi_main_error;
> +		}
> +		/*
> +		 * Exit EFI boot services, let kvm-unit-tests take full
> +		 * control of the guest.
> +		 */
> +		status = efi_exit_boot_services(handle,
> +						&efi_bootinfo.mem_map);

We have 100 char lines (and that's just a soft limit) so this would look
better sticking out.

> +		if (status == EFI_INVALID_PARAMETER)
> +			efi_free_pool(*efi_bootinfo.mem_map.map);
> +	}
> +
>  	if (status != EFI_SUCCESS) {
>  		printf("Failed to exit boot services\n");
>  		goto efi_main_error;
> -- 
> 2.34.1
>

Besides the nits,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

(A general comment for the series is that we're on v3 but there's no
changelog anywhere. Please use cover letters for a series and then
put the changelog in the cover letter.)

Thanks,
drew

