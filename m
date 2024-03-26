Return-Path: <kvm+bounces-12697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 586BC88C361
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07E022E5424
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 13:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4562474420;
	Tue, 26 Mar 2024 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aUN8J0r5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2091.outbound.protection.outlook.com [40.107.96.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5B4F890
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711459747; cv=fail; b=jYoZXWO+3yVuihSjp+3xlaxkGUvDBYFGJ8g1VET/KJ7Ro7k+O5naWG6L9wLcFoJqW8t0996HcTj16HEgzz7WaJFCDW4XxFa1F2zLrgT44wxzSRcOD38qJndBiG4K46Vt7n+5BdMk2MUqdMSYYOxGv3n3CZiBAeOeihQBwvm9flQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711459747; c=relaxed/simple;
	bh=HkGmjx1Zjlqn0Sc/n90CK7Q/himKIByQDurrKmQfkjw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kb2WXpCV1rBnFRbeIOdp55UfJ4DnGuF2HnF7AnBy6A7OczPGidCzLCDwpzYkYk25yfOqYa07OPf8PsxCGoagDJD2yMXOl0Z9YB5w4/LPBM1r2NLgisBPeIew7GU/917/idiJjhmAd0UqVELH3RmMK4I3RCNk9uiFbF5WeM8Akto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aUN8J0r5; arc=fail smtp.client-ip=40.107.96.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5FEJON7ZK9KipcXfWJpYKoAOVW+WkhQ1uf0shtHmnrg9QzLJBvkmY4g3UQaKyi7Pn0kYR9wObLE7e559SU3F/mF+H1qENSQ16/nl5spx9K4Fr56nRY9uUyAL46S7nz47Ydpd8PiVNPBYZnIHihbvxl+rJmxmrrsXn/qVWi+sHkPzQ6Sz6fcac1mQpjKspkcb8ryCAcyLmHbmTLpq6hEOWAHNY++Za6dXb5yNuLyb5BAd8Zg4mjMaHPaojZBd85tCC6MrK/RN7X8ox8q72qu8SAweCcNk/43EHLvDn9exSMS2PF506tNZZ1630h3AQ1zOUial4U4B6GpcgFIr4+Erg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/B9db0DgIh4G8OqKVzhu1l4iIPNBPrevkKuwzK0DRM=;
 b=bltFrJjKBvddVuHo2ERQtJO2MDcgpXEXwUFppGu7lVSXu4DaFK02gaL/GtcooZSSPbL8jI1hrmChyanvSfiyLRwvkMq4aKQ3JxVdWbmTfOEAMRiecFHCB8WE6Vw4DKRNweYUtqMCpTbLaeLdFf0y1x/N0vScAgv2RAMrOCstTTa91sPUwYO/Sl5zGIFDuJooS/TNGC2b6CNfIlXED36SYorzdlG6830Fpl7KeW5lXkueQhr0oSEteU0+xSqkLMSlW3Fwg/4BkZqThQCd3xqoELwa2yrf9/ro5mA/kXbhGTCHVXXNr2zlecU6nNyebe/Ei0qX6m0yDspMW+aLjhPafA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/B9db0DgIh4G8OqKVzhu1l4iIPNBPrevkKuwzK0DRM=;
 b=aUN8J0r566hSGitq57Q1VbidNV+dTXvGcfXvdbTOG6L8Xh7U3mlz6AChz3SzlvCfTzIROS6ZgODeoMs2Lt7qwrDFb0rgSGQCw/OWy1aUFatpjSCr4rB1+fqTOG0RcBZCwO2NO7iIDibxQIczReZSzYTnAxq8wUz2sk5FGDYbDWY=
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.33; Tue, 26 Mar 2024 13:29:02 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:29:02 +0000
Message-ID: <9a272fee-2639-2abe-ab39-bd62175c2e4c@amd.com>
Date: Tue, 26 Mar 2024 08:29:00 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests RFC PATCH 2/3] x86/efi: Retry call to efi exit
 boot services
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, nikos.nikoleris@arm.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, amit.shah@amd.com
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240325213623.747590-2-papaluri@amd.com>
 <20240326-8247f506a6536cbee06e4a55@orel>
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240326-8247f506a6536cbee06e4a55@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0005.namprd18.prod.outlook.com
 (2603:10b6:806:f3::24) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|DS7PR12MB6096:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gsgWeH9uJBVZk61tyjpYc2a3560X4VtRVrRKRKbqaDrhosCzgxKk7YfE8e9i1SWoYNo6nFIEvKVHOcavB7G8tkPjtr5LQdRLukUyd0P+AXHsZXoRWNk6qM/oit9svj7vpuLmiFBHidboNkwiaIfDNWqUM7RI1BHjTLXCZBKteJsNLi0Zd3ddSOWhoYmoV2zTIn/JV93hcWgXLQHeesOzLukCht1pDq+TpdQLEZf/nEY0gFhlabvvkns6UGoQ8wuUVRQQrQaER64MxHMTIgR56M4hF78mjovsAyLvxBWvbindDhrtyuuufC5ko8wC+4X4yFSJLwkS1+Vj1PYVIFvy08OvHd04lEGyPJ+rpDq2keVbKYzw/HQyTBsPGYnKbLu4VKu3tcp6g5yHitN6UORIdIz5EM73gWO0qoWkksiqjzd86gmsxKAnKb+FB5dpNN5Sb9rt6TRuFFqT9uf7LKxtnCUiPMe9dz0rt77h/fwaBHMRBgEhO1FZSUNFwEUNBVqgyAhn3lX0A4oceSmpG7NU7MSCzCFApuku1Kg/52GS/cq74blPqkegVjXJDQw4QPGyj5QMl3GtlCarCxQKMtKVKrORaFa4HGAv2/cgkb9HLCP9gZN5EVPi2TCv8B7K1CxbKJ0oEmRQ8Mh+yx0sU3h14lI/CoOJy7dhb08nDu+ykDc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tll5YVNlL1ZMNmpqMkpyRk9uV3A0cHFsWkVDWGQ3N1BCclNmNm5XUzhsRVFJ?=
 =?utf-8?B?RlZrZVp4eU81MUFwdTM1UnEwTHdiTDZvUnBpNWVQTFA0NFVKUW1hdzNzZ1Bk?=
 =?utf-8?B?YmNVT09HQ0ZVNUFBc0trUWFWcXFZWVFoeHVFVlRWY0FuRTFxZnc4NTBxS1Jm?=
 =?utf-8?B?SEUzOXg1ZUJBSXlDSVR3dkxDWmxpR2ZXQTc4R3hDRXFEUldVVy9zRDVKOVVK?=
 =?utf-8?B?T0c5SHlMS1RkczJKQlpDL3F0bTRET3dKVnA3ZW5RTUQ5ajZBOTAyMzhtYkFN?=
 =?utf-8?B?QUxOUElFK0szdG04NmNsc21kTTFrTnR4MVN4QmdBRjJ0MlAzcmxTTFk0U01m?=
 =?utf-8?B?QytJTmdsdVY2ZFExcklBZ21vc1NDRTdzZElsSnF4VUNjMnFoRkpCbTJXNTlw?=
 =?utf-8?B?Y2ZUMVJZVXFmR2o4ajYydzJaUDg3Mk9mSTVVcnJub0ZJS1IwNGhBVUNIeVVH?=
 =?utf-8?B?b09uR2QvKzVBQUdmUDhubnRmOENVZk1Uc2JyUmFTYkdYclRwVnNrWDd1bENq?=
 =?utf-8?B?bmJRUmUzajMxZDRhSk50bXBJdDdGWkhubjZLUnJJdDZ0SWJ2QUZ0S3BHWTJh?=
 =?utf-8?B?MTZzb2FCS25NZ09MOVhSN2lNNjFtTlAwZHFDS0xsK2Z0T2xqZEtKdXlZV2RT?=
 =?utf-8?B?dit4Wm93TW5SOVVaM2syeUhrL0ZlMFhBRjhYQkVKRlYvRTEvZ1Fyenk1RWph?=
 =?utf-8?B?R1NpTS9KTDZPSXpwdk1hak1qM1lHcW96c0FEMFltdlQzbVF2VkVPdnpDRTJn?=
 =?utf-8?B?WGNXYjJnUkdEUEhmVFVHcjhrY3RndExDUUJ1cWVsaTlVWDJRN2s2ZDdzMlVY?=
 =?utf-8?B?WXo0Umw5eHA0Q2RpempLWGtuUDYzbFJhV1Nxbk5kcTNlekdXU3BMMDkvNzBT?=
 =?utf-8?B?YnhKMENVRkoySlRFQnp4ZTJzQ3VHRzkyM2xtMnJaZHNXYkYrRDUxcUxEUXNG?=
 =?utf-8?B?TnhPZXk3WUtIMUFQbXlTLzhRMXZPTG9SR1Q2WE1mbzY1ZW96MzhnQmhjQXlY?=
 =?utf-8?B?cFJQTk1LSkJiUCszdUV6Mnd2Vlp1YXV1ZFAyN2dkQWNVUm5BUC84anJyQUhk?=
 =?utf-8?B?YUdqQUgyMHBhMWtzK2hDeVVmSVZXdTdlRFFwR3ZVczJuSkFvSVVLbnJmNVNH?=
 =?utf-8?B?djBZa1JHVGZjYVorbTdhMktvUzN2dFZ2Q0ZuWGpsRkttRWtwdHkrMVJMMVFr?=
 =?utf-8?B?TXFNV3JOU1BCQjdDcFRSNDFvYWtDYVl5N0pJVTU1UE95VUt6elhhQVc4MVJM?=
 =?utf-8?B?dTZXbUtoV3M1djd1QlViMTdqdVpad24wR3ZOMFlqa2pNcUJRRzNkMzVQRmhI?=
 =?utf-8?B?TjR0T2NLUnNWOTZDRnlLT3RRancwaDJucm1ZdWQreDdWRDJQTkRERGxhem4y?=
 =?utf-8?B?QUZvR3ZSem1LU3BPT3pYT0I1bGlRS0lGb09aR21WZnk5SXF1VUhVZjJ4cmdr?=
 =?utf-8?B?Vm5HMkpRVm9LcEwxQm9hMmE3Q2pwaEFBVndXcDMrd3QrWENmejAvZ2FpenJ6?=
 =?utf-8?B?R0J2OGNUMmhuT2ZPZ3krWllBOTY3ZXJnWVBXZkJZZnlUYjRKMkFTK0gwVkRF?=
 =?utf-8?B?SjZXVnlIcUVZY0l5Skk4bERjanBTRVBwNU9ydXlZVjZ3M2NjMDBxdHlpZDdH?=
 =?utf-8?B?WmFJazNVU1M1bTBuYUpuaHRoaW8wWExBZ2gyNENiSG0rNUhYUkgrc0QvdEpF?=
 =?utf-8?B?YUNZZE9TOUloY2hrOFprVkRNTWhLbHJQWGJTTzRuTWo5ck1BWVN2VW1DS0Z3?=
 =?utf-8?B?elg4eVBYYXNXRVF6cXczTTc4NWs3MWh5L1NYVkc5ODg0SkNCQldFUjZMMFRv?=
 =?utf-8?B?K3p5clVnYUhpUmhtS2UrcExlZGdvUjlmUW1hZ09CVFp5c3ZvaGZ5OEpzQzQw?=
 =?utf-8?B?NFNKN3NpMEorMDdtOFNENXBtUUJsNG94YnJVYyt3WDE2RFhaOXZvdjZpSldz?=
 =?utf-8?B?UlY5Q2taajBzcVZHOUl5ald1MUUxUWNJMzFpaU5YQURNTWdsbko5M1dCbjdR?=
 =?utf-8?B?SENDbWJ0Wll4U0pXYnhaazU5TktwQWFGQ2c1YUJsSXhIWm10U0c3M2Q0Y1Y3?=
 =?utf-8?B?UWVzWXJ4Nk5yaVpFREozZzQwbDhGL0VjOFQ1aExTbnJFeHlydGlhVlVENmVx?=
 =?utf-8?Q?iIveUi53Rg5YgIu0dfZG4r+3r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c33ba70-a49d-402c-4ef6-08dc4d98b364
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:29:02.0641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWI/JbpcgeH9dxhKnmAjEr3OcuqLlS507a1T9kMg2cF435zfyuzY+ARJO3ZER7uYm3NzJo1jY+4m4qWrvo/MLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096



On 3/26/2024 3:57 AM, Andrew Jones wrote:
> On Mon, Mar 25, 2024 at 04:36:22PM -0500, Pavan Kumar Paluri wrote:
>> In some cases, KUT guest might fail to exit boot services due to a
>> possible memory map update that might have taken place between
>> efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
>> spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
>> to update the memory map and retry call to exit boot
>> services.
>>
>> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
>> ---
>>  lib/efi.c | 23 ++++++++++++++++++-----
>>  1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/efi.c b/lib/efi.c
>> index 124e77685230..9d066bfad0b6 100644
>> --- a/lib/efi.c
>> +++ b/lib/efi.c
>> @@ -458,14 +458,27 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>  	}
>>  #endif
>>  
>> -	/* 
>> +	/*
>>  	 * Exit EFI boot services, let kvm-unit-tests take full control of the
>> -	 * guest
>> +	 * guest.
>>  	 */
>>  	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
>> -	if (status != EFI_SUCCESS) {
>> -		printf("Failed to exit boot services\n");
>> -		goto efi_main_error;
>> +
>> +	/*
>> +	 * There is a possibility that memory map might have changed
>> +	 * between efi_get_memory_map() and efi_exit_boot_services in
>> +	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
>> +	 * 2.10, we need to get the updated memory map and try again.
>> +	 */
>> +	if (status == EFI_INVALID_PARAMETER) {
> 
> Shouldn't we loop on this? The spec doesn't make it clear that the second
> try should always work.
> 
Indeed, will plug in a do-while to loop on it.

Thanks,
Pavan
>> +		efi_get_memory_map(&efi_bootinfo.mem_map);
>> +
>> +		status = efi_exit_boot_services(handle,
>> +						&efi_bootinfo.mem_map);
>> +		if (status != EFI_SUCCESS) {
>> +			printf("Failed to exit boot services\n");
>> +			goto efi_main_error;
>> +		}
>>  	}
>>  
>>  	/* Set up arch-specific resources */
>> -- 
>> 2.34.1
>>
> 
> Thanks,
> drew

