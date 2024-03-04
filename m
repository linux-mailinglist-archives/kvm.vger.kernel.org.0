Return-Path: <kvm+bounces-10757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AFC86FAEB
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A616DB2151E
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C1113FF0;
	Mon,  4 Mar 2024 07:34:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8713B134A1
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 07:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709537689; cv=none; b=RgH90rzG6NfCWvminGI+j5K6Bh3zrAwBydq74k9KIT+1QDrcp2oay0rnLos0C5M4fVAO4GbnrbNQ14YLhjSarbGS1tYV7na4giaxx3Ly/MGm8Y5HAxyec8UQ1Vpo9aCXlFXIWiQvoqispY7h7t+g+eFX04b9I46S4mVeQoGeQw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709537689; c=relaxed/simple;
	bh=FLGfyB/PyHizEPkdbQDT/hBagjA+Li3QsQ+lD3mzDVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+iQwFj4wsCHFzkSVK1aqEJrmKz8Vn8c4P1zz8JWIIM/HJUZeCC+tjjNf9MH/5V0/rOmItJ3zqX6GwwaDyS9zFgt4DNelINyIP4nezOmeidBM0qGZn9q86bVCqzQh7xGXsCFDK5Hs8kbYdWIpmR1iniTOqT5jdhyBopASKu/yj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABCB71FB;
	Sun,  3 Mar 2024 23:35:23 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA0F23F762;
	Sun,  3 Mar 2024 23:34:45 -0800 (PST)
Message-ID: <df9c5b95-0cc4-4d82-b8d9-603dc069f7de@arm.com>
Date: Mon, 4 Mar 2024 07:34:44 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 08/18] arm64: efi: Improve device tree
 discovery
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-28-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-28-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> Zero is a valid address for the device tree so add an fdt_valid data
> member to determine when the address is valid or not. Also, check the
> device tree GUID when the environment variable is missing. The latter
> change allows directly loading the unit test with QEMU's '-kernel'
> command line parameter, which is much faster than putting the test
> in the EFI file system and then running it from the UEFI shell.
>

Out of curiosity, the fdt pointer can be zero just in KUT or zero is an 
address that efi_load_image or efi_get_system_config_table could return? 
Similar code in Linux treats 0 an non valid address 
https://elixir.bootlin.com/linux/latest/source/drivers/firmware/efi/libstub/fdt.c#L370

> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

In any case, this won't hurt:

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   lib/arm/setup.c |  3 ++-
>   lib/efi.c       | 28 +++++++++++++++++-----------
>   lib/efi.h       |  3 ++-
>   lib/linux/efi.h |  2 ++
>   4 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 0382cbdaf5a1..76aae4627a7b 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -342,7 +342,8 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>   		}
>   		memregions_add(&r);
>   	}
> -	if (fdt) {
> +
> +	if (efi_bootinfo->fdt_valid) {
>   		/* Move the FDT to the base of free memory */
>   		fdt_size = fdt_totalsize(fdt);
>   		ret = fdt_move(fdt, (void *)free_mem_start, fdt_size);
> diff --git a/lib/efi.c b/lib/efi.c
> index d94f0fa16fc0..0785bd3e8916 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -6,13 +6,13 @@
>    *
>    * SPDX-License-Identifier: LGPL-2.0-or-later
>    */
> -
> -#include "efi.h"
> +#include <libcflat.h>
>   #include <argv.h>
> -#include <stdlib.h>
>   #include <ctype.h>
> -#include <libcflat.h>
> +#include <stdlib.h>
>   #include <asm/setup.h>
> +#include "efi.h"
> +#include "libfdt/libfdt.h"
>   
>   /* From lib/argv.c */
>   extern int __argc, __envc;
> @@ -283,18 +283,24 @@ static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image,
>   	return val;
>   }
>   
> -static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
> +static bool efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image, void **fdt)
>   {
>   	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
>   	efi_char16_t *val;
> -	void *fdt = NULL;
> -	int fdtsize;
> +	int fdtsize = 0;
> +
> +	*fdt = NULL;
>   
>   	val = efi_get_var(handle, image, var);
> -	if (val)
> -		efi_load_image(handle, image, &fdt, &fdtsize, val);
> +	if (val) {
> +		efi_load_image(handle, image, fdt, &fdtsize, val);
> +		if (fdtsize == 0)
> +			return false;
> +	} else if (efi_get_system_config_table(DEVICE_TREE_GUID, fdt) != EFI_SUCCESS) {
> +		return false;
> +	}
>   
> -	return fdt;
> +	return fdt_check_header(*fdt) == 0;
>   }
>   
>   efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> @@ -335,7 +341,7 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>   	}
>   	setup_args(cmdline_ptr);
>   
> -	efi_bootinfo.fdt = efi_get_fdt(handle, image);
> +	efi_bootinfo.fdt_valid = efi_get_fdt(handle, image, &efi_bootinfo.fdt);
>   	/* Set up efi_bootinfo */
>   	efi_bootinfo.mem_map.map = &map;
>   	efi_bootinfo.mem_map.map_size = &map_size;
> diff --git a/lib/efi.h b/lib/efi.h
> index db46d45068ee..4bd01f7199ce 100644
> --- a/lib/efi.h
> +++ b/lib/efi.h
> @@ -30,7 +30,8 @@
>    */
>   typedef struct {
>   	struct efi_boot_memmap mem_map;
> -	const void *fdt;
> +	void *fdt;
> +	bool fdt_valid;
>   } efi_bootinfo_t;
>   
>   efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle,
> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
> index 410f0b1a0da1..92d798f79767 100644
> --- a/lib/linux/efi.h
> +++ b/lib/linux/efi.h
> @@ -66,6 +66,8 @@ typedef guid_t efi_guid_t;
>   #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>   #define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
>   
> +#define DEVICE_TREE_GUID EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
> +
>   #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
>   
>   typedef struct {

