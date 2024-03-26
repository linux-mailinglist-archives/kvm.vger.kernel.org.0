Return-Path: <kvm+bounces-12696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8EA88C35E
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B10EB24189
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 13:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587BA74420;
	Tue, 26 Mar 2024 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jw/iDFdt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2106.outbound.protection.outlook.com [40.107.100.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C522F21A0D
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711459697; cv=fail; b=FYS51rs91t5GAiub7EeKq+DjvPiXUIYPDEeV7O+3E40CxfoFlpMNWTlqITK7mQ9Eppoblo93SEeB2p9FEZa0klz8cp4Y7ELWKvRrZQADCcStL2hHabazo7gxrBuLB1/SheflI7A5aj9xBhFmR5gFXNWH+MvpF4YGP3Ji7Mj/oq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711459697; c=relaxed/simple;
	bh=hR5K6G5m9LE4XpLkz8EFYexti6lKaNNi4lPPKVwUrmU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=abR5Qgu+lrH91vefZDkDN8mRO3HmTDZzeSj3BMUI4MhwavE3QfFK5Hm4CPkI+R+BMqEeSzbD6BejRCj541ITnHZvV5h1NNYtD/p9U2Y0y8/6tE3RQnTbNSSNgfGS1ZJqT+qLuShtr/9LRcl130NazHYo+0B6aWajf6oLL8CRVes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jw/iDFdt; arc=fail smtp.client-ip=40.107.100.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSCWBIRC1+YnqRE3sI9YBodTnihzH8u5wONURLRBTnWT+gQucjOLyNKVpe1FdBNMXiKe0iBWYST712/z8vRGIl8xoRrFMTC2Sfa8dvG23YhW63qWLR5RmX6WkfsdeQOWkmzLgIS9Zo8zGE9yPOBMjLw+OnhyndI9EOGHkqfED+xGOXO8ll9i7P558kz3NF/9YEea/NHsjMyV5isjV2yGLIr8ZZirAFyXjffvvM0EcG6WdgFPvcF19WCV8YBC1hokjw+hnjo2ec937IrJVlf/KZzhVYHaHRPsoeTUfkMkL24sPPmP8CieVHbooyh77Wxr9ECxkYJRRNupauvoXilDaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JT9T4SAjr2aOXeuHW0y+9TeZXWlC0xMJP3Uzc+pC5Y=;
 b=c2fz98Q1pjGj7XzYZUfKzadLpI4YIXnIKDep195K3towC8cCfZdgiKZtfWaL5RxzO79UD+F+4ABBKqnR3O6mp5eo2oR7PeQay0Za8Grhh+9foyi5rJsjzVUhMIyn3PR6VTL5ql7/nDOwM1N8JLQ9K2Rsx+RwbtUPtYPFjQwJPrpsZJ6o8n0CG4ZBOfe1E5+J6UYST/v/sqdUz/fK7lfCDfJjKcprxaZivJOtDimmASWJw0Lfy8SEm0YBs5BNl/uvzSRmrh0cFR954WcZIoteZNVzCrJAsCkuLHi8ip1TMYfje36qMOdZZK5xqt9f1+mrJlX/jjJdxzl94JPgQM2Naw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JT9T4SAjr2aOXeuHW0y+9TeZXWlC0xMJP3Uzc+pC5Y=;
 b=Jw/iDFdta8+YiiSutUV4r3m3qBH7Fll5xIxIx63j7eJwOiVtXX5HIL3u6uLX5EtIupTyCe+Xi2JzCB8oEysDeH7snnFGJmqS5aHLqfJ29uETKfRtc2ye/Ua9P8S/p/y2SHe4lTyzgDQSTdlkdALSRwOv9TEWcHzazUPXGEhyZIc=
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by PH7PR12MB6693.namprd12.prod.outlook.com (2603:10b6:510:1b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 13:28:11 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:28:11 +0000
Message-ID: <b32d60c8-786c-1c30-5e90-5da683f5cb36@amd.com>
Date: Tue, 26 Mar 2024 08:28:10 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests RFC PATCH 1/3] x86 EFI: Bypass call to
 fdt_check_header()
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, nikos.nikoleris@arm.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, amit.shah@amd.com
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240326-663042e3295513fb8814f80d@orel>
Content-Language: en-US
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240326-663042e3295513fb8814f80d@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:806:f3::29) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|PH7PR12MB6693:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LDqqi0Brl3QBhrvwrzhWSVX3EYw27lbDb9jh61iuJU7oL1UHKDclyOlxRMVeozkl6Cb9bFqjDtTgQTnDl6p+boSn9MdWwn1qHNZ87LdoixPS7H1eZQ64gCjgzOz2NvtT6Ya+Pu2TB2Ows4jrUmQB4kBNl+jV7G3Dppuj1d+qRa2UdqSU7qSZjwIwKPmwUoPZYv3Bsc35ZKE/c1idbcEciCg3hBCE4GLQs9cprdPHkV/J16Hp/gqhhTtCO03sJ+zKxOWiFHBbfaYeCRoIb8WAl+iq7LlUxLTvITtj92nD4Roy7j71IOG1j5JDlVhAtI//FBB3WkTvvJ1ws+KCurAGwyZvvWu0+wz2If7Erum1kbRv8jYx24ocpmoP+JbhOaxNAoeUXort51R2QLuUsBbWkCa/ghX+Rj0yttxlqr9LkOB99ZPHZ269J8iBe3EUmoIxF3QqQE7RMonTrqUQxO7c0c2+Jck4tcRV30WcX55OLG15CV++EcYmbRvM7EZJ8hDiHttl7cnthzWu3dCulmQsdtbSwh3+e00LH1G1SLEnoZ9hKPBJe0b74K0CuyGSgi9zIC2ZtJTtn7IM1Sk68eOviYeORZKmNU8v65hEeeMCL8zTGbpw8EtIY+es8MAsLvcXYMDkKF0vhI1JkI0P+OATwFrAQzq7jvCblRiXS2MI1yw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REpWSDd6TTJtVG1QZ2RvU3NjcDZmOTVrTnNqQ1BicXBjejY3ZitOMFd4RCtK?=
 =?utf-8?B?MzV2K0pqN0FVZzlFYmVSZWtwSk94dEtPSXV6Y0YyMUhNdk9kRVUwR1VwbVhL?=
 =?utf-8?B?eUVjRzU5YlNCUFNjNmsyUUc0SzFnRmdKZS9KcmVZb3NWTi9hdThiS25iL0ZZ?=
 =?utf-8?B?YVorY2FkVzltVGlnc2wxbWc3RDZ2NTJBbyt4dDZzZU1RdGdLM20zQ3BKZ29h?=
 =?utf-8?B?M2VEUFBha01GRlA0ZWZmQ2E4Um5ZNmVmQmQzYkdXYUlDOFZXQnIyV0c0SldR?=
 =?utf-8?B?dlRmdW9EbjYrRUd4U3htNUxjWkFIdGRTOVl6czlvNHh3dDR1ZGswbktzSU9s?=
 =?utf-8?B?cnp4ZXJOdmxDS3VjVjBUSjlZbHNUVTNUQUtjL0dCTTNDNmtuRmdNZWkrWHhH?=
 =?utf-8?B?RFhLTGlvWVBKanZ6MTQwMG5OWHNGSG5ZSWRMWHVXRFdIbGpPUmZPZVNqZkFq?=
 =?utf-8?B?ODl6Wlk1MHo5dGRRMHQvNkp4RDVwVmd6ZjlXdEpNK3VJL09HMFhYd21GZFlC?=
 =?utf-8?B?OEVqUk5tSUpmMGtnYnlnai9BbWMyVjhycVRmM2VUTk9oK1pwYUcxeFcydDl1?=
 =?utf-8?B?M1RuQWtUdkZwSW5KOVBvRnM3ZXdJZEdDTjcwdE5JdW5OU0dPRmJvekxsL1Nx?=
 =?utf-8?B?Um95T0JVTGhMV1BlZENNeE5ITDRxdFUzY1dwaGNEbUx0N1Z6UVN5ZVBDeVJx?=
 =?utf-8?B?SmFsYURRYjZ0V2lscWxOUzJ4bHg1dEdPTm9vaEpoRy95aEEveHNSUSt6a1BS?=
 =?utf-8?B?R09EazRDOFhBeE5JZGdCTzVnWitnelMrQWJCWlh5b2xsNHVGZnk5MW43MVVh?=
 =?utf-8?B?Z3ZyaUxVN2tPZjU2NThVUi9wYXJkcGMrdDdzQk11dFpScnVWZlNMbDNjYjQw?=
 =?utf-8?B?U1B5Rzl0RHJCQy9lMWp5cXNFanBWQmNNMWN3QmY4RHAxZmFsQ3BYWlZlUW5C?=
 =?utf-8?B?M3UrbC9VaWo4TDdhUitQMEV0VGs0a3h1WkhnYSsyb2NWdVFsa01wL2NHcUNu?=
 =?utf-8?B?dDZieFg3Tkd0ZWo1b2dWcDdQVDVpYkxmalNkRGNnMlcrMmlpNHdGNXQ4Zk5p?=
 =?utf-8?B?eDJkaGNTSy9JaVVVV0V0a0p0TmFGdWlEOEN5ZXAvdG9nMXpGbjZ4VTJiNzZD?=
 =?utf-8?B?OFMvVERqL0phZlZBU2xMM3ROQzdBbS9kem1QRVh3eVBpakxiQy9YbHpOcEdk?=
 =?utf-8?B?bXErU1p3eVhzUHJScllxRWV3bXVVd0FLQm9OOHNPTGlwMWlSa3pZZXVLd09J?=
 =?utf-8?B?OHBCdzgzVHdJSEI2ODI4ZUROM1hoejlIN1d1QWR2NFI1eU1WMkx6SnczV2lW?=
 =?utf-8?B?MUlwMGRaUlFyYVhTMFRUMFlKMEovcEgrWlpWZDhURHV4TXJ0RlFxbDRuMndS?=
 =?utf-8?B?K0RwQjVRa2I1Ujd5N3BvY2txdHJ1TEtFTlB2SmsrbGJhdFRuaTdNRld0ZjJL?=
 =?utf-8?B?Wi9jKzNXdFFDa0c1SE9xUHJ0YW0xRmd0N3FKdUpZOU01QXBHRnhkQVVvcXlH?=
 =?utf-8?B?YmFlNU1GbHdVa0RZeGhLc1UwWFlqRWNpdFN2WE9QS3VFaEJ0WHdHMzY0WFR1?=
 =?utf-8?B?M25XM0VHc0VLYVVtdTdsVFdvbS94dEVpVE1hUCttMUE3dDIxRER6Z1dzdHVR?=
 =?utf-8?B?S2lFVkswWWtra0VCQ3J5Q0FuVXYxL2E4UTB6bGsyeTN2WEtPZzV0dVEzTExs?=
 =?utf-8?B?Y0FrRFo4MUFwSU9PMTlyUHZJME1INWV4WjY1S0xnRm9Id0VFb0NaYmowUmdr?=
 =?utf-8?B?WmN3N01UeVhreGxEeC9CZHE2VXdIUFpXMmI1Vk50aFkrTXdDRHhIY1hycjNv?=
 =?utf-8?B?MDBCV3dNd2NQOU1GUVZHdTZ4dFRjdkF0WXYzckd2STFDYXBCclhNMHVPK2hE?=
 =?utf-8?B?dVp5ZjYvMndONVlWbVJBTDVFcm1kbkl3NFd6amhQR1QxR01PVENNVVJjR05x?=
 =?utf-8?B?bUxPMzRJMmVyaEJycGQ5L1ArS3hadXJ6QzRMQkh3Qmc5Q1hLbmJheG5rbUpN?=
 =?utf-8?B?bkE3Y0YrbWZtYytob2VBRUtMRUZldWd4Sk1EcEJWdkJ0L3JtWldteXJIN3Rq?=
 =?utf-8?B?U0E2ZkpLYVgwc3BXdzFBZFdiQjRTak02TlFmZnVkZUtqcytHdWFuZEdkemwz?=
 =?utf-8?Q?PKuyA/J/Lkeu/3S705mqlMcOd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06fea1f6-9dd1-4b3d-ba96-08dc4d98951b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:28:11.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lta5wVR9AiZX2MkuvsGOXZ5qhAjzMvELF/VGszG/EhlqlGkazUpr4+TgYfewcLsTOI1gnVowiQtJVUh1cy87Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6693



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

Thanks for the review, this looks better. I will soon send out a v2 with
the changes.

Thanks,
Pavan
>>
>> Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
>> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
>> ---
>>  lib/efi.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/lib/efi.c b/lib/efi.c
>> index 5314eaa81e66..124e77685230 100644
>> --- a/lib/efi.c
>> +++ b/lib/efi.c
>> @@ -328,6 +328,10 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>>  		return NULL;
>>  	}
>>  
>> +#ifdef __x86_64__
>> +	return fdt;
>> +#endif
>> +
>>  	return fdt_check_header(fdt) == 0 ? fdt : NULL;
>>  }
>>  
>> -- 
>> 2.34.1
>>

