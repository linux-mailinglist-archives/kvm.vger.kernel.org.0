Return-Path: <kvm+bounces-12908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CCB88F324
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 927292A679A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 23:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D9C153802;
	Wed, 27 Mar 2024 23:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FivoidXa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9B415099E
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 23:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711581890; cv=fail; b=cBxnJ3ZEGVBUJkPVxx4K0obcLBljQo6LUZfjnO3Yans/KlwNXWJgwa0JRyNrypAU+MB03gEL706oWygpMXaFjcoZkUQJYmhxrHYqZZinsUj7Z2CsIDt4QRSG/6gm+l/g5nWQ0SzQlTyttmYbaFCrpIQTzB9f8pAEJyrueWJaKHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711581890; c=relaxed/simple;
	bh=f/U/Dz6IxcHpEu06EkVT7WvTR3vAm8NjyzCkFgDMvKo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qdzoZJLFXL2rCBKBe9kOqAvR2g0oa2ZuxIXfb3EY1x306jKDJBZB+TNKXWCZUqCuJrQqNQtnNjbmVmEsATsWuVwczwwvLHHPL7CiaHGLcTARrHX6zDT6Mdr6sTH8l+r9Jwi7JGsSLlq+lpe40fmfFa8m8ijB5xvBOezLkEcaP78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FivoidXa; arc=fail smtp.client-ip=40.107.95.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNLmVKkCki6/uB5IHh5qAtlP5NUaqfxgZs76JyfIpewlmqbBJ06HLm1uVzZ/OnawTkFs1ZnisvYtoJ+QSK4W0uyZVrmjXocgE+3kWni7qKO3zzK00syMjYytXsGKGiN3HCuFso8heAZk5+OqymevLi7Kk5sIveqsrM+2obo+XoJSxgb0B5AEOgVmlWpdSWoXYs6d3HvqhS6sV/X2QhKvtQNBliN0ONbSAqxMOduyW6KR6ZD5m/GeXHqef4vMjyuMOss/IwMDb5MYqDJCbhN175GltfrshZLjRtiV6hkpuAvG3Xbe0R8LrrBilp3+YUb49nDpoCBG+agnAMhu6s721A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WG7PCu21zQXvPQTSsvycls5wTgPm6qBC2KFngvrw6Xk=;
 b=Fbc/RG4R/ACl26L6e+RrmGzJipHIYoUjullXgf7mBIk45n1joODVFiiIMYBpdPn03k9Tci8LfEM7kHRix2fxv+uJX6Ef5IoGWLD8+OOAx527afWYFl99T1KpYuFyLH+MFjSWQ8OVw0hDBxN1Qq29i7ALGFJ/wsfAUMPRbbbvv0/OFwXzIfdPPAmRkFl1asi2N6YBHZoyQckdCHkfBo/lIMBY/A0n3o87SRkldC55xTrnNuOx4ADL5+sFR81/ETPRNjzAqd4UDQZL7x0PecDQW19cu8DjV3crhnizWpY0DDaO+1cN+5KrPJHenBGQLah62kyE50xDAZcnMAwPxY5kpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG7PCu21zQXvPQTSsvycls5wTgPm6qBC2KFngvrw6Xk=;
 b=FivoidXaUEpPtF6SCvzDPQmAZ/xMrD4lh/go+zrNed+4ZacJpGbzeGnrtxfl0jh7xZjCRYJhlnbMhOxiMGJnw67oD66mM/2wcwQhkO+R1BGuYIQ6t/pXq/xZC+Cl0KllxjK55wfLq8DWO5ZdPx+ZmKtp9hP+o0XzHxvmTFtBdgA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by SJ0PR12MB6686.namprd12.prod.outlook.com (2603:10b6:a03:479::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.26; Wed, 27 Mar
 2024 23:24:45 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 23:24:45 +0000
Message-ID: <0816d004-1f81-5126-8afb-279864e79185@amd.com>
Date: Wed, 27 Mar 2024 18:24:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86 EFI: Bypass call to
 fdt_check_header()
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, michael.roth@amd.com,
 amit.shah@amd.com
References: <20240326173400.773733-1-papaluri@amd.com>
 <20240327-f360721c639c087d16444baf@orel>
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240327-f360721c639c087d16444baf@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:4:ad::40) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|SJ0PR12MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 71ea8603-72a9-40db-14a0-08dc4eb5161e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+Ekwkm8Ob0gblnXr5qNL4VslfaopJULQjny7LW/FqDuMR2QshQ0mMaX10BSGtfFTA9o2+d8AAcRUJfTzROoaJXDF9Y2DK7g98bBW/cL3PNTL+hIf3BhqwZ8AA8RrXpDOZuJm/3OHrx7fToCalQAbB1+c81mKWCl/rAg6tm6ImsjTBm4JKrAM+2eA3CENaOQ9KmH7xtMIcX/9kp5CaHSECS5m4shO6y3VzVmK4fYgmNUbOXyxLFPqboqzrlbUgQD+Imuunb39ecaIER7jlLp1XfacGYWyXAD23aR50qBF8AdXychsZfVdsu+rhIXKter+QvswVl1LpnFafHz5f4g9PRY0eN6qyHywjP0vfYgCCIvtvirEfhS4K0NwY6J5f6wb7Sh49X46L0bwZ8FmnylbQAY0QYhs9raoOMdMPd5gAiGvdIxB+XOANPlnhvGYdL6pgRLhMDn2BW1BtrJ3X6gRA6GvNXHheV4KRrq9EWKZMWBsyZrgsOSy7aB4aLRGWamG0LSrdx+3/dJYS2iaiy6Qf+5adBHLdC3uH9RS8K7p71THjNM22eECqxrVk0OvvCmyLV3Y9T5x3XWykm6O35OiArXaMvkDjqX/RJX4XbLzBYVI+1cYvqHU/Kqre22wKM1ouDjewTvfJCQnST7gcYHREPsCzlWjfq5CfmdAlfiYtnc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azhvY3ByS2JMZzA5NzMzc3k4SEhjazVzLzY2VWtOamUzZExhNitsM0RBZExz?=
 =?utf-8?B?WStMdUpVb29ibldaRkRGWmhLTTczUzdnZDZTVC8wRWNCelZMRGRGWk5IWEdF?=
 =?utf-8?B?bkRJZHM1MllINFVoWUdLckNlT3Jkb0FRM2hTTDRRTWJDK2c3SXZvRTZsY1E0?=
 =?utf-8?B?dUN5K2t2ekZ4S1BJY2lCZ2pCaW5TQ2NVZmdRVVphYTJNYk5IUGlZVTBmTWh2?=
 =?utf-8?B?YkdDbTlzd3NMOWRlNkN1KzVUWWEwNEVtRW1PVjN2ckxsNlhpQmcvVTBLbVFT?=
 =?utf-8?B?eVM4S004NmZmZGt2Zk9CdTFJemVLWDMydjczZVE5Tng3VlJsZksxYjliUWds?=
 =?utf-8?B?Znp4dklYUlgyMlNOczJaYjFiTG51VTJkRHJWMnVZY2RTZkU4bXFHbmR4amNR?=
 =?utf-8?B?R3FpTmZDNWlCamRJSlBxOHhPVTJaRnExeEVsWFBYcVhlN0orUGNxMVlibEI4?=
 =?utf-8?B?SEVWODJ3QVRUdkhKemdwZnJMREhnWUp0OHBUUkFqUXQxdkxwWDJvNTZDM1JL?=
 =?utf-8?B?NHpkNk9LYmRCZUE2OUtwLzQweGU4KzBZVXQydkRXU2RvSVFobnVWZ1ZIbUI0?=
 =?utf-8?B?T3U4cUpLcUVTdm5iQUV2V3JoemtvZUF2WmF5TmIzNEt4aEwvK2o5R0N3NGFJ?=
 =?utf-8?B?ei9PQkVySktZa0tiWTNBZjUwTHA5QUloTk8xd3pLK25NSTZVOW1CSUhMaVJI?=
 =?utf-8?B?TVJlQjZhSUpuVnhJUmpVbVIyOVJiK0VLYXBIbERabURDNXh3RElMczhnbXdn?=
 =?utf-8?B?YnU2WkNpQ3EwZzdRMXlIQThOTWU5bDdWdSs5YU5wYWdzUldxbDNuQWZJamRj?=
 =?utf-8?B?bWlEbUNQcGUxd2p0aHJ4SUtQRGRpVGxuQzBMTFBTaFFMSDh5ODdlNnNDY201?=
 =?utf-8?B?SzhlMkJ2QW9XcXJ5NUxtRjhrUXdOeHdEYnNzZTJSRi9yQ29XSE9kRmxUZ3pa?=
 =?utf-8?B?ZklFWUhxMnRGbUUxVXJIc3N0UkcwczZOemUraTBlUUU5RFN0R3VvcEx3NU9r?=
 =?utf-8?B?d1FlSlBkZDZMVU1Pa0lrd1pGUTRlU2NLM0xVV1hUc3V3eDZsVG4wY01vUGVy?=
 =?utf-8?B?bTVFRWYvdUwzYllMdFRoU1ZENStKUTJwRkZyWmdPemtGTFJNT3pJNzJTVE0w?=
 =?utf-8?B?WnpYdk54TFZhMTJvRWhiMDloZkJ0V2VmM2tUL05ONGx3VVREanVVNU5wTkhP?=
 =?utf-8?B?K25kRmdaN2pmMlh4QkZxb3F6MDlrWm9lR1VWb1FaeHB3eElDcndSc3NUMWY1?=
 =?utf-8?B?VHI3eDYyZ1dwTlhNOTBRSHlFZVIzRlRPb3hTNHQ0WndWUHhUWThTdkxjMVh4?=
 =?utf-8?B?K1R6bWw1b1djeCtFdlNyN3VyQzBCa21qeExUblBaY0tBTmZiMUhGV1lIUmlE?=
 =?utf-8?B?eUpQTmc4WDNtVHlXYnJKNmJJdDF4SXhpd3RUMTBLVk5NQjg1TnZxNklkeThF?=
 =?utf-8?B?cTQyTXpsMFhvbFJZN01nSlE5di9tUkFGa3FHQ0ppWTF3U1NUb3dReFpTQ201?=
 =?utf-8?B?UVlsa1FUWDBpcmxTcmVxNUJFaW56SGkrVWozaWtDOE4rL0FHWDVrTDZqTTdZ?=
 =?utf-8?B?T3dJeXU4ZFV1NngyRnAya2RLUTd2OEh5NVh4dVI2aDY0UHd3Uk9zZ0VwaWRm?=
 =?utf-8?B?WE0xVkhkTFRseU9rZVhYRVowalNOanJmYXIyZ2wrZHl6QUc2VFo0bkdpYVBV?=
 =?utf-8?B?a2o5T24vTjljWXVxL09BejlXRkJ6eVZyTnltVVZDbWZqODUyRkZadjVjSGJp?=
 =?utf-8?B?eXBmc2ViT2dFbGhpNTBSVHh0OEVCUytQY3BiZm9XRzRWLzQwMk5OUjBQbnFp?=
 =?utf-8?B?ckQzU00wUDNGQVlOMkMzTXlTMEZQWFpnekgrRENMa0hIL3J3L2hhMkh0Slh3?=
 =?utf-8?B?N2JMMC9VSzJ0WDIybkJoMC9TNFl0WTNISmg1NzF3b1RWNWRnNmNxTjVrckx0?=
 =?utf-8?B?QUFJYVcxdWJ0U2hUUStxWG50RlZTcUkra25JVmJyUGY3eE0zdmtnSnMzMWFK?=
 =?utf-8?B?d0NPTjQxZlcrb2tlUU4xand1NDZoOUpzSldnNTJYYnRjd0RyVUt1bVR0V0h0?=
 =?utf-8?B?VDJDOFN2T3R2TFNDMnZIVWQwaUp5M2NWZm5lVkxvVHlYdy9UTjk4Nlp3d3JK?=
 =?utf-8?Q?HqDGNZ7RwePny3YBU7qcNzhv/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ea8603-72a9-40db-14a0-08dc4eb5161e
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 23:24:44.9420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBjjoAEsc74nVL4d1q9HBB5UlM1yY35sikTQrISEEfneb8qvmvNcHPnktstnxPyjW2nlUeEM5WT5tamJxffVIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6686



On 3/27/2024 3:08 AM, Andrew Jones wrote:
> On Tue, Mar 26, 2024 at 12:33:57PM -0500, Pavan Kumar Paluri wrote:
>> Issuing a call to fdt_check_header() prevents running any of x86 UEFI
>> enabled tests. Bypass this call for x86 and also calls to
>> efi_load_image(), efi_grow_buffer(), efi_get_var() in order to enable
>> UEFI supported tests for KUT x86 arch.
>>
>> Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
>> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
>> ---
>>  lib/efi.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/lib/efi.c b/lib/efi.c
>> index 5314eaa81e66..8a74a22834a4 100644
>> --- a/lib/efi.c
>> +++ b/lib/efi.c
>> @@ -204,6 +204,7 @@ static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, int *cmd_lin
>>  	return (char *)cmdline_addr;
>>  }
>>  
>> +#if defined(__aarch64__) || defined(__riscv)
>>  /*
>>   * Open the file and read it into a buffer.
>>   */
>> @@ -330,6 +331,12 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>>  
>>  	return fdt_check_header(fdt) == 0 ? fdt : NULL;
>>  }
>> +#else
>> +static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>> +{
>> +	return NULL;
>> +}
>> +#endif
>>  
>>  static const struct {
>>  	struct efi_vendor_dev_path	vendor;
>> -- 
>> 2.34.1
>>
> 
> It's a pity that the suggestion I made (which I obviously hadn't even
> compile tested...) isn't sufficient, because what I was going for was
> a way to annotate that specifically efi_get_fdt() was for architectures
> which use a DT (and link libfdt). It's not as nice to indicate that
> the other functions also don't apply to x86 (x86 doesn't use them
> now, but there's no reason it couldn't). With that in mind, I think I
> like your original patch better, but with a tweak to ensure we don't
> generate the undefined reference to fdt_check_header(),
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 5314eaa81e66..dfbadea60411 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -328,7 +328,12 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>                 return NULL;
>         }
> 
> +#ifdef __x86_64__
> +       /* x86 is ACPI-only */
> +       return NULL;
> +#else
>         return fdt_check_header(fdt) == 0 ? fdt : NULL;
> +#endif
>  }
> 
>  static const struct {
> 
> That said, I could go either way, since it also makes sense to not
> compile code for x86 that it doesn't currently use. So, unless you
> need to respin for other reasons,
> 
Tested the above diff as well. Both work for x86. So maybe it is better
to not compile code that x86 currently does not use for now and later
make this change when x86 makes use of efi_load_image(), etc.. ? I am
fine with either ways.

> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> 
Thanks,
Pavan

> Thanks,
> drew

