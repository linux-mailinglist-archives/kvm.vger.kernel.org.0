Return-Path: <kvm+bounces-12702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1463F88C6FA
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 16:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCC513207D6
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 15:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A1813C8E1;
	Tue, 26 Mar 2024 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Iw3i2ssO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2090.outbound.protection.outlook.com [40.107.95.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C85813C834
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711467027; cv=fail; b=fr1nfXcBKhqzCOyY+CG0lAw/pky3WvvJnBvrvM1enlsGfHXgTMWt5SOkhXQyqzHrWgeRKqJC4f6evbr6rf2Z+uMFN/KroO8jkjugHwLRaYUeW4z48gGeMkgtULrYNgRf7tfw+29LvdHe/pfFS6tJ2XebYaoZ+MBYhJuWQy4PH8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711467027; c=relaxed/simple;
	bh=xraMyEVkjSvsnWg9KU9ipM9v8oEvBC2fHOx8y8AyiUk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cywDPiaaEjtxAOVDsVcGHRMA255z7zxy+APim4X28D9bPMwiY2AxDpItJidTNBLcmIFE+/bE8hfUgmKDeTdGRihaytUoJLJVZKiHj5x+3EWsxWkNwY3yPeXc++oCEUBdV2sLtRgPvGjREvmY4wGVJ5OYX4wy3skfrcnxdSWPwTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Iw3i2ssO; arc=fail smtp.client-ip=40.107.95.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDqgp6SDMSY33cKwd9k498gYEMmQkHcNf9VEnxtOwD8SvvLucx1z+WQpJHIASzLxgc5P2kTCV17WSzeiwbmfUPHY+BckRtCGCxzp6pTnyieHsNPhUY6dP3W6W4SYR+agj4YdspPUowbezKEl/cgRxwHBpLwQDLWlzpSAHVF7L66nruLc+L3bmsWX4WIDstpPnAXo3TTDHliCmCosGG8QAvbLB/f9qvBQCudC5F+9deNJsc5z9XKRk8W7sUwNy1U7uhRMVXUntcS0jUO/dCchmLJJa6GFeCSvP35/xBZNoBZO8JO3P3Xqovg/uIg/+5MXBZKjHlmCxgpj06aw708ZUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvfmGSZZg2eKIggUanqetr4/cNwYM8fLWr7i7W5pjHI=;
 b=XzV0K3KcXMtRcfreYGnYiHU87zIkbwtQ1wmGbY5ZM91bxvjROoayB/uCkHD8MCu2RXfA9mBJx/7F5IJqlJdC71WfllDeoT1mxcQF0Am1Ouzn5mSsL+haHKj0k7rt5WwBy9MyX8pBvBTkWEJb1Z4G5xXWRvq5Nxqf+ZNz7nODV33OIcB8NQ/zkACGquwtAteocqWyciir50y3Vf9qS0MCUdHGGM2CSuWTDzJtt+gl0UeHKF0I6j8dM6fttM+KX0QY43b/qn9gRJR7xy8zjxOyBVJUjX1YaJvKJfyxPdb0sMioIXXiEnrtUTxnyrtCEHfzFB6iEdHSTbOKOK92TP9HzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvfmGSZZg2eKIggUanqetr4/cNwYM8fLWr7i7W5pjHI=;
 b=Iw3i2ssOlshVo76wd9LfZp55Vnk0Q/6urVQTtqHiquRYtSeetX607NKVWIQF/Xb/MFzdAWT1pWoQOfGGh5na/TbpVqUzzUckqQF3iqZ63Cu/42GPwnRnE8WxEe+5mkOzMr6qLnXhpwO+8m7sd9gq/e5Ufz/FnTcLAtLU+m+Jgo4=
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by PH7PR12MB7456.namprd12.prod.outlook.com (2603:10b6:510:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 15:30:21 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 15:30:21 +0000
Message-ID: <391fc273-0385-eaca-5c07-277ceaf1815a@amd.com>
Date: Tue, 26 Mar 2024 10:30:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests RFC PATCH 1/3] x86 EFI: Bypass call to
 fdt_check_header()
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, nikos.nikoleris@arm.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, amit.shah@amd.com
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240326-663042e3295513fb8814f80d@orel>
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240326-663042e3295513fb8814f80d@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR18CA0001.namprd18.prod.outlook.com
 (2603:10b6:806:f3::15) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|PH7PR12MB7456:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l8dTkaGVVAnwvIrm5bPK1NPYeXyyOYkOC9xgZuowjZNw0sfIlrniWqF556XWw+CbCu+r18kCSVvk/re0Hw5zHeXJnrnFfE4NsG7AyI04U64Je2lF6mH267+dN0o57T6pSGNo8b9Jux1RtROC67zjJX9V+iAlC6ikIJDaV6bXdWqL17RgZFhYL///BvCBq5KFbs5PxJjJ1sZ08IUMxWeaeW90CJG48/HNgg+E27eTTwIT4EfXstkAqmkkdkFhYBLRgiv9WOhbQsKGZIo0m7c0LDLXdrdkoENh58n7FIvfW9DEiCPUgznTToElUUjBxixxOUkWBHd3LrrSo1u7zCifo5Si8tbS5WLxCn6nT4i9hvu8xGXvfYMzh0HxDP2bLVtQhFcd1sikRiiiGT4+8s/ysfkoFik+UOUNPhn7e53qe32ThcK/8LLu5EYdvPmFsfPLyPSydl81QZPJNWmUNiuytFmggoXkvzTHMCgmxnniwhJ9DFE8dUU1bd80uAwrUG6R7HTBLB9yMeA22vgbYzzM2rlJxR+mVLEMCGwJfjLUe2sTtZIOywJn1AUJTAy1g0RwrYxfjkEpUKxtwdfgkld27CJaQNEyzaSKaiGwFEg9K0K0xweyxvpjnMslO+PzaUqkkG9POF6SXAvuxZwNRCykXYoLYdGoHUGH3u32gLrDxzw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHAwSlpHbDdsQnEwRngyYnU3NzV6emc0UzVacE1pYWFQQlhrZTZZbW8rLzlL?=
 =?utf-8?B?My81OUtSRFNaRzJUUlhlUUQrY1VkbmRiUUs4aWNUZy9MRkc5VWIwWFZzQ0o3?=
 =?utf-8?B?U1p0VFh4emJETEdmeVNPR3dSTXFwdHY1MVQ5dFRIa1pNSnZUS2xoQndydVVm?=
 =?utf-8?B?N2ZWWTZVUTcvWU1GSGRXSFZleXo1V0Q1QlFkN1JFeCt3WVNEQnNFbitEMmNQ?=
 =?utf-8?B?UTYzcW5NcG16V3RqUEdPSzlWZXRMQ3FIcmNublZ5ZHl1RkhidEVmdTM4ajJI?=
 =?utf-8?B?Vm1JYWhVVkd1d2tVOURMcnMrZFZ3MnQxVnJzZE9QZ1VrVzZBQUVTVzFDaisz?=
 =?utf-8?B?MElBdGQycllQS0VXQzNxRk5xK29BMDN1VGJtUEpvbk02T1FReW9pbzJsSjdH?=
 =?utf-8?B?WkV5SGFyc2g1d2tnM0ZGTzhybnBoeU1IL2dWcDUzZExGcDR5YkorTUhaSzhh?=
 =?utf-8?B?bCtqOVpTVVprSVR2R0RYUlkxTmlyZWhNeTY5ZHhVUkZ3dk9HelVyM05kUzlU?=
 =?utf-8?B?bTh1bzR5UWlYMEt3RndIS0t5ckpBZTF6Z25tL0R1UnJleXBPeThHZHZPOTlU?=
 =?utf-8?B?S0ZUWDI3N09MZEczZG1GU2xTdjJsV0ZYZ0FKUnkrNkExWGVZVU4xWjd4NnU2?=
 =?utf-8?B?aFdIaHp6Sm93NzJqOUZkVVpKWGpPSzRpOE1JaXFPcnVEYytBZlVyamNMTWdz?=
 =?utf-8?B?MXlsQTdFcjJ4Y1NiZ2kya05udHpjZXdCZ0dYczdwYUdiazFObE5lZFkxc3dO?=
 =?utf-8?B?akdYc0h4aGdnTGg4WDVlUUc2SEhLRSswaUdVdzBxOFAzQXhQNElnRzQ0dlZs?=
 =?utf-8?B?ZlRJSGJYQnJiT29ZeTlaWEZYTldyeFd4WmJuU0J0dG8xemVGdEZIbzUybmxY?=
 =?utf-8?B?TVBOZzFqRjF2eXpFaWtUcjVSTGRBU1Yyd2l3NjFYdm1KeUtqYWhqc3A2Skg2?=
 =?utf-8?B?a2RnVVRvL0ZXZmJGZngvMlJhZEhUQS9namJBN3lvRE54b2xwSE1LRUk2SG5s?=
 =?utf-8?B?RUFGUmNsekV3WHVtWVFxUEFYZm1aSnhNcHdXTCswSG1aWDcwWnBZSFNoZ2hq?=
 =?utf-8?B?VkowQWFtbWt2djkzQm5SQTNBcHBYK3NQaVdhaTFXMGFrUDZZME4yZ3EyM29a?=
 =?utf-8?B?UFNJUWtkWVlmZW95N2F0K3BGS0JtOTVPN1RoMnN5czNZWmtzTE5nNndKRGJU?=
 =?utf-8?B?d0NsNEk4Tjl0a2d3RFphRUhXeENhV0ZKWXEyWlZQM2dxWS9YL053UDg4WDJF?=
 =?utf-8?B?RmlVbmRXTHdKQXpqcllheG9hWG1ZUWpNZjYyUlB3RW9Ic05lUVZ4TUtUQjVl?=
 =?utf-8?B?b2dSbTl1cmsyY1VVeDNoeGRkT2d6cHBMZTc0SjJ6cDJwOHFuSVllK1hlNkpR?=
 =?utf-8?B?Q0RIMVV2VTdhSkhkaHQ1Wm4wUTNtQnoxZnRGTGNucEpsUER6Kzg1cVYrdEJ6?=
 =?utf-8?B?WHhKcUFOZS9vaEtWc1pYbmhFV0I5bEZ1ZkxsNXRsWUp0NUlkaTZiMFEvVFJD?=
 =?utf-8?B?TGpQUlFBVGRrcE0zc0tqckp5Qmw3N0lJQjlUbm9hcHgxUHVUYkM0czdibDhM?=
 =?utf-8?B?VlVjVzZyNzhKUWZCU0pnb0tkd0ZnaDZoOHJKemNNZ0t0Mkc2akhOcE8xL3JB?=
 =?utf-8?B?Z3N5c3BuWHp6SW1tajhYdmZ6T0xHVU9mZGhkck9WTHdCbEZBdmhkZUZyMmF6?=
 =?utf-8?B?Z0JoYVo2WE5QK2RyMXl2dkIrc0oxNCs2K0tENjgyMko1SkJhUS93YjR1UUNS?=
 =?utf-8?B?Y0lWVTNjNG4rbzM1R0ZWamRaZHpoeEIzQVRNUFpXeit6eTZIM05WSWx6Wkhv?=
 =?utf-8?B?RjJreFY1RzNMS2FGMmRoRzZObFUzRjJNWTVmTExKMXFnZzdjbHJDMWJqVnJG?=
 =?utf-8?B?elAzbmhBWFZHYWtsNEE5NUZna3JLVi9iekZWanNYZWliOTJTdjBIZ1dYTHlH?=
 =?utf-8?B?bno4cGdtSnZ5dnk2ei9qQVZvdzRoN01zY3FsL2NKdU43ZGRCdEV2SDN0YVRO?=
 =?utf-8?B?N1pJSlVHaGtSRTFxZHJaZi85d1grTFhXZnppdjFCT1hKM1N2dzkxNnZSWGVW?=
 =?utf-8?B?a21NK1BSblR3US9VclF0U284NnYweVpzNUErS0VENUNyL2NZcm9laDd0QlFq?=
 =?utf-8?Q?9fpyA1y+khA0kMGuT1u1moYkO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21cb6dc-9e76-44ef-6509-08dc4da9a61b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 15:30:21.2528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqOjxbu6az1ftn5iz6R1FMlAqQaNFFjBczfgpVIVMHwBliZOx+nL4+/fOjX3wl4Xq/L/7FjWtZ8687mwft1UBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7456



On 3/26/2024 3:51 AM, Andrew Jones wrote:
> On Mon, Mar 25, 2024 at 04:36:21PM -0500, Pavan Kumar Paluri wrote:
>> Issuing a call to fdt_check_header() prevents running any of x86 UEFI
>> enabled tests. Bypass this call for x86 in order to enable UEFI
>> supported tests for KUT x86 arch.
> 
> Ouch! Sorry about that. I think I prefer something like below, though.
> 
> Thanks,
> drew
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 5314eaa81e66..335b66d26092 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -312,6 +312,7 @@ static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image,
>         return val;
>  }
>  
> +#if defined(__aarch64__) || defined(__riscv)

I just realized, I had to move this line all the way upto efi_get_var in
order to avoid the following compilation warnings/errors (for x86 build):

lib/efi.c:299:14: error: ‘efi_get_var’ defined but not used
[-Werror=unused-function]
  299 | static void* efi_get_var(efi_handle_t handle, struct
efi_loaded_image_64 *image, efi_char16_t *var)
      |              ^~~~~~~~~~~
lib/efi.c:210:13: error: ‘efi_load_image’ defined but not used
[-Werror=unused-function]
  210 | static void efi_load_image(efi_handle_t handle, struct
efi_loaded_image_64 *image, void **data,
      |             ^~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Diff after applying the change below:

diff --git a/lib/efi.c b/lib/efi.c
index 5314eaa81e66..8a74a22834a4 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -204,6 +204,7 @@ static char *efi_convert_cmdline(struct
efi_loaded_image_64 *image, int *cmd_lin
        return (char *)cmdline_addr;
 }

+#if defined(__aarch64__) || defined(__riscv)
 /*
  * Open the file and read it into a buffer.
  */
@@ -330,6 +331,12 @@ static void *efi_get_fdt(efi_handle_t handle,
struct efi_loaded_image_64 *image)

        return fdt_check_header(fdt) == 0 ? fdt : NULL;
 }
+#else
+static void *efi_get_fdt(efi_handle_t handle, struct
efi_loaded_image_64 *image)
+{
+       return NULL;
+}
+#endif

 static const struct {
        struct efi_vendor_dev_path      vendor;


>  static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>  {
>         efi_char16_t var[] = ENV_VARNAME_DTBFILE;
> @@ -330,6 +331,12 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>  
>         return fdt_check_header(fdt) == 0 ? fdt : NULL;
>  }
> +#else
> +static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
> +{
> +       return NULL;
> +}
> +#endif
>  
>  static const struct {
>         struct efi_vendor_dev_path      vendor;
> 

Thanks,
Pavan

