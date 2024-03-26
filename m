Return-Path: <kvm+bounces-12699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6059088C40C
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADA11B2237A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 13:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F2575814;
	Tue, 26 Mar 2024 13:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sPMZV4Sj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0E474E03
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460759; cv=fail; b=GUYnQcwU0/sv6lxK98gNq+kcLEmtkGuJIKZfLZNqTeNcNs0wX7t4Rm3BNOYFtzpBnnhuMDo7C2oEWg74eziWPR3HrDjiY5Js6N3oS/Y0gvg+xFAtsXSshzIQdSz4n4aPqwK3egFwguGjjIMZJG3V3q1SN5xl5XtdLhHecf4iYTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460759; c=relaxed/simple;
	bh=CwHiYYPKjSMw8snAFiiG1P6/r8FKzeR78A9vLNke3Iw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MVnsQQoxbHRuwqz15SsmuCBHVFbven0s4MJ4ojYe8vfXEQsZgs/+OTA0XxqYoat7VsrzsDoUalIsyDn4goCX3PCrrwC5zRDaOeLpXGEs/tkQ+MigXmURmONcuiVrY8MqmjqkAEPwiAZbhDOWH65bVDnJdwARoPRAepdMAD+ML3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sPMZV4Sj; arc=fail smtp.client-ip=40.107.94.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GB8UrTvkIg3DPoRVfIjyKx3MDeZfjahotzK+QSrQjWGCff8xKOpsQbrJG8ugHuNudtqoyxbXreInnse16ZaPF4W7vyHrLjJ3LorGwggRimXlTV3z28JSWiIKotnbM9li/VyI7w4DhPtnzrUFYP2w33ZUUqB6W6N61eNeaWs+qaU4ZU2oMQw6t9FVEUVNf1MuKKKQkG7IFpkVyTe/Q6mdiQUQwadK/VZO0UXJC24PplAzfTuMnXthykLaSU6MjuduFOG6DRC2W0KDJ5XVnVTStedkQtUxwhztIjex4sqwyQM/4C9Q2UODsyGu4fyad1+FpyA2FENuLAEExsRchvxFeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Fiw1g11shs/jX94LpJu5MpBR5tIrtcd/W5Cu6wLQfE=;
 b=dQH6E3iZ/2UjMn4+MAEu9AlBaF0ix/EKVsgbBP+7DMNwadmHW9ZlznAsLRr5quJN81k6r1B0Ls4/YuU9jgEZDmRl8nkf5pSlES8FZB3CJ8oPlaWM4zH0ptxDC7G3g3FrmU5H05WQ6bmunglOwouerMAILtGBvlfgtWoOHF5tWz7m2ls4U8o6jVnD6dpHTRVqOMNSVSQ+NjW/3vLbT2I2AJx/NN6Uo1NNuIVAiFqHBkPZLyhlCQB38Tb1F+3SuEC0oCQ8sgkrl88xDZhnjUTKTv76PUajDQBQvM+2QLrZJS6cPX8HV6jAohShow6cfQHdA9YVNe8i0qOXYHTOof4OXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Fiw1g11shs/jX94LpJu5MpBR5tIrtcd/W5Cu6wLQfE=;
 b=sPMZV4SjKi+WvCCAal6xLbdqKyDn5GZdnn0Q5H6Y6n0XWWyJiCdAvbqUoymH/27YGbWikilKcwj7iM0M1OXTCGt2/1O3c/LZrD5WhXyR1adOmzU1x2tJgGco3P3vcQWFPFqSeSflceC4H8hoQd5tFpr8NjLbsiA+Uk+Y31taSg8=
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by CH3PR12MB9100.namprd12.prod.outlook.com (2603:10b6:610:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 13:45:55 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:45:55 +0000
Message-ID: <4c2c7598-2c07-0cd6-620c-1a603bcb1f0f@amd.com>
Date: Tue, 26 Mar 2024 08:45:53 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests RFC PATCH 2/3] x86/efi: Retry call to efi exit
 boot services
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, andrew.jones@linux.dev,
 nikos.nikoleris@arm.com, thomas.lendacky@amd.com, amit.shah@amd.com
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240325213623.747590-2-papaluri@amd.com>
 <20240326133801.p4eqegjor54mn3h5@amd.com>
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240326133801.p4eqegjor54mn3h5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0068.namprd16.prod.outlook.com
 (2603:10b6:805:ca::45) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|CH3PR12MB9100:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wByxPNrfdQZ2kp+UrdCwS8GWXm4h8gLuL0IAfMhwA4wAwbr8d7u6nPgTOHBgLvY9Tg/A0xCICGgQvNSc1BwfsUrlkpCmUtmE3DlA8gdNwqKAX9FEiZPzOgYeDD+whg830I9A1kj/mhPfTDnwVe0fd7zbsI3+obnuOs0E7D3bIOP6GBrpN7D/NeQAW8/LZmBeCOVkHt8zJBqraxask4fbWsdgoFZVCWkVv7qA8CzDJx58cWg7lI/zOXEUPtLuOcy3rpaU6rPt6DSK9DvxikjZohmPqA4seKa4V0olL3qZgRBabTADsNaMDDtVI+3AN77Arbt6zr9wvE5NL63pABVuUOwekfOZr7NbYYqFUY+bPOp1EOH9MfD48W9z35Lc58CHv37FiC1SPyl9+L1u+t3jgPzLg7jVvdcLX8LSWNZqmwS6OfZnkKaTu4FQ8LhgfVe1bwLpBMQZlkkZWmO2pOO77OoKe8S2Sjy6tPyaHnFVCkDb1WafOgg+Bwg0iJOtT0oZdXbklzTm0Xp5TeSbvqoATmsGus3H+gEoI9c9fQjuckw+jXUKujEePFEG7nz8gOnCFRcFP87+6lfWZ+TI/BvbCd/nzM9v1yBgTViVt+r0dN9E/q1Wbf61qDXx4V5Szym9JJw7VVSIOqUjly5AYnm/EyI7HZA0pDwbV+YvCQF8HeI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXdqcTZTZXd2bTc3cGFVaXliYjJCZmYrT0tZbzV1NXU2eG9SZXgwUlNJZ1J2?=
 =?utf-8?B?TTJ0cG9SUEFPKzh5QlVxYjhoaFF5V2UxZS9aS3VOZllwNUtZa1NuVStrRUxF?=
 =?utf-8?B?czNYaTY2anl4T2RtRFdUMHNlZDlSTCtsd2pDTUJ6NzEwazB6bXVuU2t1Y3pU?=
 =?utf-8?B?K1ZRSlBTU29rbTlwZnkraEhadTVtK2xhK2dnQXI5eTVMU1NLQnFRSndldXMy?=
 =?utf-8?B?eUFYc1ZvR2JsZGtVQm9UckJjUWtYQWFBWnQrdFZMek9ZdkExZllFTHdKNnd5?=
 =?utf-8?B?T3BwYVdrMmZLdStUdHg5bXJ5RENoSkxNZis3WElzQUYxVzRGREJHOVFJeHh1?=
 =?utf-8?B?a1dyUkRkV3NOSjVhTWI4aWMwazhaKzBmL1hLR29LZWw3Nk9CTEJ6dVFFbWJz?=
 =?utf-8?B?UG0ydDl6TzBvc1Z3cHl1eE8rVk11ZXFhaVRuQnN3T0NSQVgwV1dvV2ZHNEdq?=
 =?utf-8?B?VHl6UEk4ZUhoeEk5WTArYUY2aEJlNE8zYXRFeVBYeVhPQ3MyU09lTDFmeFh3?=
 =?utf-8?B?eU9BYkNZOUlUdG4ydXJrNFNvd1c4MDZUZGpYcGc4NUpSbXFEL1NsS0dZMy9H?=
 =?utf-8?B?YW1SOFB0OFhmaURUM0c0OE5QQXErRnFJZjhDNzlnLzd3THRJdDBrYWJhQzhI?=
 =?utf-8?B?dXVOcUxNTDl0M1lvSE5UcTVMemMxUUFQbEMwSXVnN0hubU43elh3a3J1a1M5?=
 =?utf-8?B?eU1FK3FYcVNFcEhDd2E5ZU4vZGlkYW9GVFU5aWNzWDUyYVE5RHFROFRuQ0Z3?=
 =?utf-8?B?eUdtcERqR1RIOWFJWEFIemdWdmhzOWpwaUY0aUZrY0h6SyttWUZxVGRHN3F4?=
 =?utf-8?B?cTJ6MzM5dmlybUVxb2o2djZVYXpibkZmZVhXNzVvRVI2eHI3b3ZVRERoeGo0?=
 =?utf-8?B?UDBTSG51aXhmRXRTNVFZS0tmc0NqVjRhUUdmMFNYUCsrZ1NsUlJyR3BVS09t?=
 =?utf-8?B?d3lMRnNvNnp5c0FUSWVlRnBmRlF2ZDZMbGNPWWhJeHRlTUQ2VEFMQVpNU3Ux?=
 =?utf-8?B?VVFPSzhtYitvMjJOK2pCdmJjT2J5N3hzTGh0Vk53alpSRU84cnNxdmV4QnBF?=
 =?utf-8?B?c3h2bHFjcEdaTCtvcFphS3RlV3U2MWRZekNIY0FlU0FiaEdnT2FpeWw4V0Np?=
 =?utf-8?B?R0d1T1dBUWgwMlBvREpzaklQbHJqUm9ST0l5YnBBaC9ka3IxMVZ1cWVqWURH?=
 =?utf-8?B?clRHTW50dGcra3pQeWdaWUNaTWh3cnRGeTZsdVNLNGY1NTVtSkYrVGloRWl2?=
 =?utf-8?B?S1dsNmFydTVMWXNrb0FnZDlMa2RjRDkxdWpFSStkaENGbUF4TEVQWXdtUUFK?=
 =?utf-8?B?WTM2Uy9GZ2R4VDdiVTFBOGdVNVovSjJqSW5zMXZYekg5cDJ2VTZhOThvMXhX?=
 =?utf-8?B?dy83RmFtYUwxSHdkUERhRGxzWEE2RHRkUWJLLzVRb0VxUUt2dXprRHRmVk5I?=
 =?utf-8?B?T05HSFpCNXgwR2h1NTVIVGEwUHZBUnlkbHlqR1c3eS92YXQrWDVSRzhpRlBs?=
 =?utf-8?B?TGJkT3VueE4vOEh6aHZZV01hV2RrT2h0dEhMZXdBV3lZT2VxS0JQTkVieTUr?=
 =?utf-8?B?Ymw1aVZzSFB5MWQ1bndVdGdHZGNBK1RtUDdQZTZ1c1JuRDN3TVF0eHVJRmMz?=
 =?utf-8?B?NFNNdkUyc29mM0VNa1c0Vnd5bnBORy9tLzl6cVFxamdpd0N3dVBCbEVIY215?=
 =?utf-8?B?bUcvelRTbmVrUjBOVVVLYWk5ZHFjV0gvUG9nazJKRDE2VlF3ME1zNlphZWpl?=
 =?utf-8?B?MlNCbHZpYTVLZG9nbUtyUXZUOCtUUHhqZGROam9FenZ6UWNaVVJPZG1HTWNz?=
 =?utf-8?B?K0hsUWZwdUZvQ2FxZ0txVHF6Mm85V05ETDZNUGRKSjJrTXpvc1Y0YzVVa2dz?=
 =?utf-8?B?cHI2TTFPYngzYlhxRGF0QzFtd3l5NCt1SkZMa2ZZY3F4VTArcE8vTHFzR3ZL?=
 =?utf-8?B?UTM5ditlR3VxdVZod2k4WktscHdqSTUrSFFQQzY3OXJSZ3ZUcEtzcjlOWHdO?=
 =?utf-8?B?R0F6SkZ2Q2N0S3hySDhpZ1g5cUtpYXQrWlY4MStjTDVYcnFvK1hQRE1rQUdh?=
 =?utf-8?B?TjdZKzNOY0tqbmY3NUdCRkIvNVRKU1U1ci9ZSXUxSkpBR3VDVVdCeGRBdmRn?=
 =?utf-8?Q?jq3CZDlv7bbkF03prmxldFupv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108c41d3-dc11-46d4-8dd7-08dc4d9b0f8f
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:45:55.7260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cVzFrEFVPCWYiSXy9wDKbMgrKo1Tn1aiU5pyQCFPluMD+0AZhkwfmKeTnD784mqtb8OEvBhXHLyHF/b131VKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9100

Hi Mike,

On 3/26/2024 8:38 AM, Michael Roth wrote:
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
> 
> With this change, error codes other than EFI_INVALID_PARAMETER are only
> handled if the first failure is EFI_INVALID_PARAMETER. Need to to re-add
> the previous handling for when the first EBS failure is something other
> than EFI_INVALID_PARAMETER.
> 
But the status codes that could be returned from
efi_exit_boot_services() are only EFI_INVALID_PARAMETER/EFI_SUCCESS [1].

[1] UEFI 2.10 Section 7.4.6.

Thanks,
Pavan

> -Mike
> 
>> +
>> +	/*
>> +	 * There is a possibility that memory map might have changed
>> +	 * between efi_get_memory_map() and efi_exit_boot_services in
>> +	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
>> +	 * 2.10, we need to get the updated memory map and try again.
>> +	 */
>> +	if (status == EFI_INVALID_PARAMETER) {
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

