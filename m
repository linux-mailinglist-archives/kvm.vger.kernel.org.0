Return-Path: <kvm+bounces-13041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D6B890CA8
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 22:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B62E1F24127
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 21:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D7413A875;
	Thu, 28 Mar 2024 21:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GGSV3zMu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2108.outbound.protection.outlook.com [40.107.244.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52840852
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711662540; cv=fail; b=lHndPex0TSqsb/y18vNOj5WXl87yp88R7eLCbWBGJE/CNL+1fwXxAlhWYeST6Qv5gwC9VSG2aSJNgiCpQYwiFsRD0KmJNlTQZwuuKbsifHtsH7WQHhfAnWtu8BY7ZsbwBdgqAMcHXbXzMP9BmtoF9RHp+1/lKsa4SK7o5n7D8oI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711662540; c=relaxed/simple;
	bh=lmADtYatAJ4CgV39H0F3HC9VnyMZIEnsoP4hjs6qGAk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UodRLYdiMqii2h6wx5IeFpa1s6GLeqSd0sTR/jdZbyAw4stALPkCk+G6V4cg3JkiYiIC0nYPnPkmaDEB0STOnHhW5e0Qf1uyOgpJRYniHuQlrzyVgrp8LPc3bbe+J1W3hfBFdWCR4kGivvBoauNpEeYM4F2Zp/PMjDXUMqJKwzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GGSV3zMu; arc=fail smtp.client-ip=40.107.244.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ART/wjsZjQxDvu6tsK6PsP9sVFqlWX3TYql+HO9hr/4SH8FdCJhyWH6iUbioBrkgHINRHQMo1JolRuPDH1QLmnOSfyYKWmJuV+jzM4sm3LQilLN8KrHMx10Ol9ZyfB/JtzpciLwgpEMeNnYWDxORF7GGMxUmMW1hgVObgM6pHR8Mf9klJrtpAjpcCRtx13Vs4LocyDrpFZ4mlEg5LCEgEHKrvHE1SxKAgsE7l/3lZWEk9m9eS2P1BGbT4p3ESwmM0hw1suDuEEbTLQOdXIzZUo8sf19Uu+l6W79wkWiJYeGMexV6GR04YyYYUwXacJRVyzRJPykiANiJyAWXKtgn5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CiPVEl20v5cgOAW6U9JbaIWt5DIrDJy17f35xfr8am4=;
 b=SQuvjtAHiR3uAQ0aMlRsxjoRC/ZU6ngRy70qUnxIuaP2+bgSNcHSmCof3Ue3LHvAv85O+5a0ECKsJ3d8AFc7tXn89b0h+mkuiBxgSNxVikfrmIqrD00cJ5yn4B29BulEV6+L36RRZD+5NKHn5KQN0wgiS5QUSqdCW8jzile26YBztJnIaxBGul6knjRrMxv1uMOJ+VDgJupGI8m5/vscAMBg6giQyzD8X03dtA8qyheM0BJZTQjpfpVlLrlDzKhdiuzH8oOoqYhofvrpYuCDQ4S61A0RH4qOai+byml2Znvk8pbT3Gc4d2sC2rCnxobd//f4tlBHJRNYcy6DUMUr3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiPVEl20v5cgOAW6U9JbaIWt5DIrDJy17f35xfr8am4=;
 b=GGSV3zMuY7gxbptR3AVGvNXTBKFyHk2KtSuWIwNJTehZHKFGRTdHVjNJYx5zm4Hnp/3KP9oblBu2WyRv6+c26bFSugHLeY5n+uX9iThR4XBcqBFz3n5ElMJuCQ3GW5mMCFQvbGNAFtdMWAu1iqqR9h9wqggsVWa2lJLNeaHAb8E=
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by PH0PR12MB8030.namprd12.prod.outlook.com (2603:10b6:510:28d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 21:48:54 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.038; Thu, 28 Mar 2024
 21:48:54 +0000
Message-ID: <5541d533-becf-e527-e68f-d9f2cdca3382@amd.com>
Date: Thu, 28 Mar 2024 16:48:53 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v3 2/4] x86/efi: Retry call to efi exit
 boot services
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20240328152112.800177-1-papaluri@amd.com>
 <20240328152112.800177-2-papaluri@amd.com>
 <20240328-47ec1cd5ebf2292beed09e77@orel>
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240328-47ec1cd5ebf2292beed09e77@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:805:f2::20) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|PH0PR12MB8030:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RyHmhrOetmJOevMFHTLH1Ayy3cfjQKMCIirFI+HMtfPFJh9jhJmOGRFx3bRNObio6k8OLK0Y5UZfq9Q+jJo2cWf8U6w/mRH24Xfg5Te10Nhha8KAWeznL8XySnm8deyk3I4UFUltUi2BOhR/CqptnKlXeo9belbBYrgpEy2Y7vdoDQNDZwnrwdPdKaXiLYVnSDUS362YYtX9QHrVakyrQDf65EXK4iJMIOxbI2SJPj0oPhvMC9n+PTm+QsGZM7dcxx+MQrkJFny5TqgiKJcfyCF6wZvjHEzEOmeGNS7o4yullBGkNTYHF/+em8C5YNiJZPc6cNYEa7jyW4W5NUuKyX5bGRrC7P8Fc00tItKwPwWjptfUiE23W9jT8hfOrdqMco4qiV95BzeDhlUdYt5YqsFuayvTaaSHcnAK4jgxiYpdZeBuDFQSJkgG8qR/elLJNqBMDZrYtZk9ufyYE5wveyTaw9hh7JSKTRr5R4b3kSCKGE3KTo+8l+9VSBxmF99GRabu3CPwyLpiFki16qIIuQoFQP3mhom951sDj2o0DBVuyuxNLM69GFmKJOcAuvM8aD9cpZNxJgU/efJXfcSK51OpHlOHZ12VhVMK0phUuSGdYAiaooVKEFt4Tr99jnNUYrNnHDJj69vc90pUoS+JLirSsnjw2rZdmWH0wuneqyk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cE5kRytqWkZWbmxZZTZlMTBZQWdnYk10ZWZNUEZJYkFNYk00amhuL3pLUVg2?=
 =?utf-8?B?R1d3MFArUmJMMDVDekNCbjdLeSttMUg0dndwV05IUFRwQzRNdUxnUTVDa2dz?=
 =?utf-8?B?RDFPRlBrWUJYUnNieGpSQ2UwM09LcXpGbzMwNnF0Y1krSlU0K1ZCem9KSWtn?=
 =?utf-8?B?MW13UnczaEVBZ0VUaCtxbUpWd1lIM1huckdEYnd6cUk0MUpCdS9la1FsWXNi?=
 =?utf-8?B?bGxqV1BPYm4vdmxZa0lrZGFuc2h5VjVrOTVjL0lUV3h2bmhXRWlwZnFqVUVh?=
 =?utf-8?B?VFVOZC9WYTgxVjd1enEvK3h2QXoxWXdocmNMaHdURWhFUWcxdHR5ZCtWeFNH?=
 =?utf-8?B?dGkwZ0Y1WEhoc1BNdzF3bElxSWJmV1IxM1htL0tURkFCbGR6YzVUSUUwa2lS?=
 =?utf-8?B?dStPSnBZaTB3bUF2WWorU2JRVjdSTU9QanRvTG8yMnR2K0Y5dFE2dDh0N1l4?=
 =?utf-8?B?VGZITE1kcFdrY0ZIVTYwZEo5L0paT0E5SERhQWZKOG50MnlDckZpQ3NtYll1?=
 =?utf-8?B?K2FwMk1jNS81TWV5VytjWUJJZllxcEFGNVQzS0VoVFlyUnR5ckt2UWV5aGN3?=
 =?utf-8?B?dlZmSDE4b3Axem41KzRTOW54WFdaOGpGa0RYQk16U0hJMUxpZEZqbWRBKzUw?=
 =?utf-8?B?L2FjK3NNNXViRVAzUFBlTXpaNCt1QzVHOGtwS0xWVFg2dVFzRnljSldsRlpu?=
 =?utf-8?B?eXlHenRZdDdEdXlYMi9BYTAwNkVBbXVWYWJGbDQwQXJOVTA5ZktOdE5xb29V?=
 =?utf-8?B?cHBZMHBwRm5YMkNZZXBVVlBBZFUvdTIxZUVGcldCNUJHTy95S1BqRnB1TTA4?=
 =?utf-8?B?bnFqQTh1dDc3WWpZOGJaSm1NbHM5NmExdGJPV1pNbzd3dmhydHBsR1VMSXdw?=
 =?utf-8?B?WDRmdGdZRHpHNkNIT3hmYlkybEY4L2l3cjFoM1k4ejdxeDdSWUpuZnc0azVz?=
 =?utf-8?B?OFlpU1Z6NlVZNWZsbForSlVNTmprT21PUm84eTFWYnFmYVpXdm45cm5JTVp6?=
 =?utf-8?B?ZEhNdG0rbmtza0dqd0lRRlZ6Mk50TnNKeHJGK2Z0WXVTZFBacE9VekdWTWJF?=
 =?utf-8?B?RG5vZWVwWlc3MFFEaDNrWEpLcGZYU01Fc0YyREQ0S2RHY0pjd1JWVWtGYURq?=
 =?utf-8?B?eHhtWWtFZTNLRm9YZGd0bU5FTnVMZDUrU2lZZ2NOb0JNa3NIK2tmMzlwMTF2?=
 =?utf-8?B?L1cxK0RzWjlGL3JiVjAvU2lXNzIzdmRta1hwOVRHb21jNTFQZUtvNWxWak94?=
 =?utf-8?B?c0JraEUvbFgxK1BzV1h1N0l2Y2NFOUJBdDc1a3Zqbk11d2tremJwd3doWmZW?=
 =?utf-8?B?M2UzZmJqTlp2Uy9KdGtVMndRNHI3dTZVVGhaQ2d4Z0xoN0EwMDJwZ2xJR3B6?=
 =?utf-8?B?UWFLMllWWGgwbXNUdndsczhxbmtOVEJkc3ZTeG9XZkVQSFc5blp3VnNkZ3Iz?=
 =?utf-8?B?dnlFbUN2TXFWellISUhhWXFsUmhmTlM5TWZiaTlVbWRsTUNIOVpNZlZHeG5N?=
 =?utf-8?B?M0FmWVpTcGxyTjREWVNUc1NESVZUOXB5Zlk1L3hFYzVVUDh3WGYyUWhLMUVK?=
 =?utf-8?B?aWkxc01YcmY3OVk1eW53WkROQUpDNzRXUkd4Q2JnWWxwbnBMdEEvUDVkVmlh?=
 =?utf-8?B?VWtjWnNucnhpWVBoWG90ZndISG9EcHRESjZYNFZubGJuRHA3WG1XWWhRZ2J1?=
 =?utf-8?B?OXZ2N0NYSGN5dWloYm5JZCtwNnpnSE5WbDYySHpDdFYwS2oyVGZwUVBFVjhK?=
 =?utf-8?B?UFpqME9pU3pEWDcvOHZJUjdKaGVMc2pjM3dhSE5tMytqR2Y0M0pQREx5MXow?=
 =?utf-8?B?UmNMYm0vdXM2ZmlKOUg5Mmw2Nkc0M1NvTy9GamVOd2pPMmNjcS9RSStaRit3?=
 =?utf-8?B?RFJKemJ3dTA2anhTTGMveXZhS3A5Q0pkc1RVZmQ2VlVVZnUrN21zaTNmb3Zp?=
 =?utf-8?B?TzdPeWYzUzY2Z0VBazNVSkMzOW9qUnpvdWtoUU5vZytyMGRvVkc2WHR1VjAz?=
 =?utf-8?B?aWgxMVhySi9zeVg2M2h5UUlPWE9MOGV3RXRjbWNSNFhtL1I2cG9KYlArVFFp?=
 =?utf-8?B?YVgzamVNcU9vbTcxMklvbWxzMEtpUURkYk9QbjdoTnZ6TFZGSHlQNCt1OTFB?=
 =?utf-8?Q?bCUlQE6NK/6nlCOCGz+iXfbkw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0820b0f1-5d35-4bd2-2105-08dc4f70dd2b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 21:48:54.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwjXmUN81VoLUoVAYYyROItRjE+rY5N9Y58lARwFn/0q8mALf68vVJC4J1tncX9QyK2E7RLpQ0FZE1Vdyjrebg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8030



On 3/28/2024 11:33 AM, Andrew Jones wrote:
> On Thu, Mar 28, 2024 at 10:21:10AM -0500, Pavan Kumar Paluri wrote:
>> In some cases, KUT guest might fail to exit boot services due to a
>> possible memory map update that might have taken place between
>> efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
>> spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
>> to keep trying to update the memory map and calls to exit boot
>> services as long as case status is EFI_INVALID_PARAMETER. Keep freeing
>> the old memory map before obtaining new memory map via
>> efi_get_memory_map() in case of exit boot services failure.
>>
>> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
>> ---
>>  lib/efi.c | 34 ++++++++++++++++++++--------------
>>  1 file changed, 20 insertions(+), 14 deletions(-)
>>
>> diff --git a/lib/efi.c b/lib/efi.c
>> index 8a74a22834a4..d2569b22b4f2 100644
>> --- a/lib/efi.c
>> +++ b/lib/efi.c
>> @@ -406,8 +406,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>  	efi_system_table = sys_tab;
>>  
>>  	/* Memory map struct values */
>> -	efi_memory_desc_t *map = NULL;
>> -	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
>> +	efi_memory_desc_t *map;
>> +	unsigned long map_size, desc_size, key, buff_size;
>>  	u32 desc_ver;
>>  
>>  	/* Helper variables needed to get the cmdline */
>> @@ -446,13 +446,6 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>  	efi_bootinfo.mem_map.key_ptr = &key;
>>  	efi_bootinfo.mem_map.buff_size = &buff_size;
>>  
>> -	/* Get EFI memory map */
>> -	status = efi_get_memory_map(&efi_bootinfo.mem_map);
>> -	if (status != EFI_SUCCESS) {
>> -		printf("Failed to get memory map\n");
>> -		goto efi_main_error;
>> -	}
>> -
>>  #ifdef __riscv
>>  	status = efi_get_boot_hartid();
>>  	if (status != EFI_SUCCESS) {
>> @@ -461,11 +454,24 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>  	}
>>  #endif
>>  
>> -	/* 
>> -	 * Exit EFI boot services, let kvm-unit-tests take full control of the
>> -	 * guest
>> -	 */
>> -	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
>> +	status = EFI_INVALID_PARAMETER;
>> +	while (status == EFI_INVALID_PARAMETER) {
>> +		/* Get EFI memory map */
> 
> I tried to get rid of this comment since it states the exact same thing
> as the function name below does.
>
Will make the change.

>> +		status = efi_get_memory_map(&efi_bootinfo.mem_map);
>> +		if (status != EFI_SUCCESS) {
>> +			printf("Failed to get memory map\n");
>> +			goto efi_main_error;
>> +		}
>> +		/*
>> +		 * Exit EFI boot services, let kvm-unit-tests take full
>> +		 * control of the guest.
>> +		 */
>> +		status = efi_exit_boot_services(handle,
>> +						&efi_bootinfo.mem_map);
> 
> We have 100 char lines (and that's just a soft limit) so this would look
> better sticking out.
> 
Will do.
>> +		if (status == EFI_INVALID_PARAMETER)
>> +			efi_free_pool(*efi_bootinfo.mem_map.map);
>> +	}
>> +
>>  	if (status != EFI_SUCCESS) {
>>  		printf("Failed to exit boot services\n");
>>  		goto efi_main_error;
>> -- 
>> 2.34.1
>>
> 
> Besides the nits,
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> 
> (A general comment for the series is that we're on v3 but there's no
> changelog anywhere. Please use cover letters for a series and then
> put the changelog in the cover letter.)
> 
Ah, I missed out on that. I will include a cover-letter for v4 and also
plan to drop patches 3 & 4 and send them separately as they aren't very
relevant to UEFI fixes and for easier upstreaming.

Thanks,
Pavan
> Thanks,
> drew

