Return-Path: <kvm+bounces-12625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D1188B5CA
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 01:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4473B62B5A
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F8070CB3;
	Mon, 25 Mar 2024 21:59:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4FA6FE1C
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711403946; cv=none; b=fhUnE3u5Wo6f9FBhh5AL8sBXqqHwnMbI1rc2INvvSFyiJ3FnpaLkl7oAuZLWnvxQ7pFHbdp0/j422K4ItuAfmI7NGsDnAeQWHEvvLlpOV9ikgRTPeIvCU9ieqPQ37TXFziB0TfMQ0SNf4f07yXQ876ilJWiquAUDUz5VL4kAoDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711403946; c=relaxed/simple;
	bh=Y4nc67WpaM6F71EsZCC2P9fcf1/dtUO8c5BEqGBiVNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJyM7Gxtfi1pte3KGMfDAP0DCgCmw2F+w8gN8XpJsWQVx4KdV1xm+SL8MGnt34ScUbjigQSidseIFWszsWsNpfDcT+PSEjeOA8Xllvvrq20qVx3zXuhr9tu/KCNXCFqvGT7nTmP1rqtgbyb9KMhGG96+y1YfpHmlzboYt93Njn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE4D32F4;
	Mon, 25 Mar 2024 14:59:36 -0700 (PDT)
Received: from [10.57.72.244] (unknown [10.57.72.244])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED6D93F694;
	Mon, 25 Mar 2024 14:59:01 -0700 (PDT)
Message-ID: <b7ca796b-8883-4048-b441-fd5c5bdc4d52@arm.com>
Date: Mon, 25 Mar 2024 21:59:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 08/18] arm64: efi: Improve device tree
 discovery
To: "Paluri, PavanKumar" <papaluri@amd.com>,
 Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-28-andrew.jones@linux.dev>
 <39d0ed49-a6a2-c812-c4e7-444a460cb18b@amd.com>
Content-Language: en-GB
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <39d0ed49-a6a2-c812-c4e7-444a460cb18b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/03/2024 16:24, Paluri, PavanKumar wrote:
> Hi,
> 
> On 3/5/2024 10:46 AM, Andrew Jones wrote:
>> Check the device tree GUID when the environment variable is missing,
>> which allows directly loading the unit test with QEMU's '-kernel'
>> command line parameter, which is much faster than putting the test
>> in the EFI file system and then running it from the UEFI shell.
>>
>> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
>> ---
>>   lib/efi.c       | 19 ++++++++++++-------
>>   lib/linux/efi.h |  2 ++
>>   2 files changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/lib/efi.c b/lib/efi.c
>> index d94f0fa16fc0..4d1126b4a64e 100644
>> --- a/lib/efi.c
>> +++ b/lib/efi.c
>> @@ -6,13 +6,13 @@
>>    *
>>    * SPDX-License-Identifier: LGPL-2.0-or-later
>>    */
>> -
>> -#include "efi.h"
>> +#include <libcflat.h>
>>   #include <argv.h>
>> -#include <stdlib.h>
>>   #include <ctype.h>
>> -#include <libcflat.h>
>> +#include <stdlib.h>
>>   #include <asm/setup.h>
>> +#include "efi.h"
>> +#include "libfdt/libfdt.h"
>>   
>>   /* From lib/argv.c */
>>   extern int __argc, __envc;
>> @@ -288,13 +288,18 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>>   	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
>>   	efi_char16_t *val;
>>   	void *fdt = NULL;
>> -	int fdtsize;
>> +	int fdtsize = 0;
>>   
>>   	val = efi_get_var(handle, image, var);
>> -	if (val)
>> +	if (val) {
>>   		efi_load_image(handle, image, &fdt, &fdtsize, val);
>> +		if (fdtsize == 0)
>> +			return NULL;
>> +	} else if (efi_get_system_config_table(DEVICE_TREE_GUID, &fdt) != EFI_SUCCESS) {
>> +		return NULL;
>> +	}
>>   
>> -	return fdt;
>> +	return fdt_check_header(fdt) == 0 ? fdt : NULL;
> 
> The call to fdt_check_header() seems to be breaking x86 based UEFI
> tests. I have tested it with .x86/efi/run ./x86/smptest.efi

I am not familiar with the x86 boot process but I would have thought 
that the efi shell variable "fdtfile" is not set and as a result val 
would be NULL. Then efi_get_system_config_table(DEVICE_TREE_GUID, &fdt) 
would return EFI_NOT_FOUND and efi_get_fdt would return NULL without 
executing the line fdt_check_header(fdt).

Thanks,

Nikos

> 
> Thanks,
> Pavan
>>   }
>>   
>>   efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
>> index 410f0b1a0da1..92d798f79767 100644
>> --- a/lib/linux/efi.h
>> +++ b/lib/linux/efi.h
>> @@ -66,6 +66,8 @@ typedef guid_t efi_guid_t;
>>   #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>>   #define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
>>   
>> +#define DEVICE_TREE_GUID EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
>> +
>>   #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
>>   
>>   typedef struct {

