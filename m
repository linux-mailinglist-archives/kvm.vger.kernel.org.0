Return-Path: <kvm+bounces-7696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F46845607
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 12:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B595B247B0
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 11:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C871586E0;
	Thu,  1 Feb 2024 11:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zoau17Di"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F672158D9A;
	Thu,  1 Feb 2024 11:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706785825; cv=fail; b=NddfidZIaqvJbmCUSThK6yegFwugg2O3uq0M5WNHOi9qEDzNuVMioxlBtt7Oa2C55TrvO9WbHE87duYh1WTRnEz2TF1ExbGRf4Ly8rjEQa/gpru0kFXrHTCS12GFNE9/28SAkZN0xDHv/PyvAywlhBUEw9HXXZ9i4f7YlDcWAbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706785825; c=relaxed/simple;
	bh=bQpjPgRVSCG6NVwSnhfEHaDfhpEgLnAeZqqrN1QCgWI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qBP7UjDSgwFDGYgPUakDZzjyccPhO5N5PTv60VloLilr0Fflvqqz9cggLeD9OXwPnFMrXzT4OCIaatr+/jpr5Y2VbwGBmkhQfXyioRAvykfNNLxfOLnIdxusYxWNDtOFb6Td/AvDqWaRw+CM6fp/1Id5ShNzHSl3IBXPB4XVBwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zoau17Di; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdeqb2Fnbp4vyylUoSq5cMMedI0H5EAYGyfWyqZ+I3XznDybgY0KBGhBnjR8CGLMyTzOECi8DwG1nhFK593WP2FIlFf36AXhxM5iZ3B5Kv4aIJebFv4CyYqF6XBP+fCgbdQ/+3g74VBsRf3Qxwyzoig8LMglD2rHjg01h2rZdKdxCg/TGkUObYrmSnkNyv0v6W6wPvaIDbCjYkrZwH/FnruJ4R3U48vBA2mzAjUUydSwcuM5kNrzDDfX1aFLz0WQI2oFH37mEV+eULQkZe1ElH2zalWlhEfm/Opv4ntiVmBNPDDCdTkkwxFWKYaUI0x4au+aN1q/kSeCJuaiRTiIJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfuHFtGEkhRePYEPmYLzf3XrFNbM5bmnSTL1pTsH/rM=;
 b=awt2XPVCBbub80Lr3qRUvqdrxKp54oBI8QRtPLJmsnlMPezqi4k82KtEdCyWxf9xGkcJhPb+US7cdcUsgSBeX+ANIyQxGm/EYLf98H+FKOCYTnEh1L3iiDvEKNp4F5TuVp4wfH8Ad1uELID32Q1loTzmdpGecwnhhvVvii1ccGQPoOMUmmZRBsyzCc7aLbn1ljZabfbxhOAqeaMDoSMkwpUnPMX8AnsQP0lGcme8zzLbQo5Pl0NlP6oxflmvra86cWbL388jI9OM+NTAkgkHAX14Pon79ILJ2apFYoKvNo0oiOPp4qxpEeBvG8W27FDTQn/Hy/ZZmbOpG86S/sazjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfuHFtGEkhRePYEPmYLzf3XrFNbM5bmnSTL1pTsH/rM=;
 b=Zoau17DiPmLuBsEcHt+FJnOXE7wHiHB/iLagDmA0ADGUmYBp9rjTfNOEJqVSXyGEYKqz+oOnsGXMQ9f7Y6WfSTu/c1WXaRUShhlEPZINMZzVhracywKB9aKxSWONq4Cqvmg5osCmoIVq2G5J/PIXxSbsJX9DCMe8hEpRXLknAks=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS7PR12MB8232.namprd12.prod.outlook.com (2603:10b6:8:e3::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.22; Thu, 1 Feb 2024 11:10:20 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.029; Thu, 1 Feb 2024
 11:10:20 +0000
Message-ID: <98b23de9-48e4-4599-9e7f-0736055893fc@amd.com>
Date: Thu, 1 Feb 2024 16:40:10 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
 <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
 <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS7PR12MB8232:EE_
X-MS-Office365-Filtering-Correlation-Id: ac52b1f4-49f9-43e4-0c8d-08dc23166089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SM4E8oyiK4GMlO6wRo9ndi5GE4RZLaeNttx8O87x3PSB30Gf5NAwhqt8h4EVWg7mTdN2ClwVHBkMjpQjUUCR34g/wXC4y3Urs5BgJRDxkel8eRNazkeXYLUCAMwdKvwXwLkKFPCEVLuQAmWISxvwgJjgY4OQlns41jnPQcVTQ4M3oUcEWaV5Oev4zd9axGN7rvhg2I6MfCNS2SUqJSNdZ9pL9tIgSAx9FatXDNgOIto9Rar02qzu+hRTyDnZZxug1jLP6UuEUyopitQz7EC1BKbxcPBS42ucyv8skIAF3uZDCyB43rRGSc1uRilt7BAefsQY8zARDNyqrO4+h/WaO4cYlbZRBQYa93sMA8I023DIC69vFYh8gtrWY4L8uuEsRORd5gy+E3QqRq15aEa6ODwxWJUezHNNQ0wKXKVcs3xE6I6wScWv1DkHSR36xgt+d3RiV9T2yRKj/1brnR8HUVEFRapU8jXYkY8ROV8dULvMF772+Fww+sUu6lyi3EiVvemV0oCkoBDap/ZLdcI1aeHTuJBuXK0wANfvED+OSLT5Rhuy6+DWXd2hFdkkt1Zb7MKhAX6340aWkgHQWWNKKErJ3xg/4UwRwlFsjGeHvM06Ph7IaJcVIUKhkOq8afkYHxl6yoGIyOYqCKvFhn/Orw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(136003)(366004)(376002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(83380400001)(7416002)(2906002)(2616005)(5660300002)(26005)(38100700002)(3450700001)(6916009)(6486002)(66476007)(966005)(8676002)(66946007)(31686004)(66556008)(53546011)(4326008)(6506007)(8936002)(6666004)(6512007)(316002)(478600001)(31696002)(41300700001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dS9tdXVCak8ybE9QODRMdThDVHg2MVJoMzA1TDJWaVJkL1NyVVpGTVJPMmRM?=
 =?utf-8?B?RTZqTm5OcjJDMm8rV3lNcjl3M1RsN0JuT1dsbXcyTnpyc3c4ZVVBWVh4c2FC?=
 =?utf-8?B?SWNKNlg5KzNwNmF0SDZNbFdHNFYzdVN6a3ltRTNIVVZoNVZ3UDFHTm9Nakg1?=
 =?utf-8?B?N0dFQ0grdHA3LzRvVkplSVZ1OWVrb1UrcERPNjNIb1ZHbGl0QXRFUFN6Zzhk?=
 =?utf-8?B?QlA3Z3dERTluRnFOOElCRCs4N3QzbG0rRHhRc3BsT0FtanN4cGRvZ1JjejBG?=
 =?utf-8?B?MU8rZmlLbXVKKzJjT2lSL3p4UjhVNmx6MHZiaXl1dnhyZ3VXK29XUWFVK3FC?=
 =?utf-8?B?akJ3aUJNdG0yNkRuck41Z3pZb3FrK0ExMGFCZmRNa0pJbFY2TUgreW9lZTNn?=
 =?utf-8?B?WEhqL2pJWUU4ZmJoYnRBbjhxeGpneWQwKzdyZlk0MDQyZUZxak5zQVo1eCti?=
 =?utf-8?B?TzlKOFBxUzg1NzZRR210YnRlbmFWa29VUUFyMHRncUlXb0NqVXNFL05lWnRY?=
 =?utf-8?B?ekFOOTVQNHZZeXpWL0VYaTZkemdrYmZwb0llNkxMOEYySjhZRU42VER6OXI3?=
 =?utf-8?B?c3doaHY3U2gzYXlxRjFIekRmU3huWEF2VkhHaWlYQm5QRU1BY044UzU3NUgw?=
 =?utf-8?B?R0FUbG1ZajE2dEdvNk92NllGc0xSaHk3WGMzWGhDeXN2MHZTSGR2TEgyTWcx?=
 =?utf-8?B?S2EwdFNTeU8vMVlvZ3JWTnU4TDN1QWFQMFNlSkhsejJmQy9RZXIwWThadkN2?=
 =?utf-8?B?VTJxWUR5WHBwUms4eWY5ZFJYSUtJdXpwSzV5QUx5cU1TbDZBRDA4Y1cvSTlk?=
 =?utf-8?B?WVh4aFdSSHVuMWFZaVlSQjZuRU5zY2N0eEJmOVIvUFEwTDZvWEVWVkNDSUhz?=
 =?utf-8?B?dnllVjhYNnhQUXBUL3BGM2dwTnM5YW9tWnI2TW5oRkpqNlQ2SmFHd2NzOHBr?=
 =?utf-8?B?TmpONTVSaHR4R1FDOG9LSjlCelNhYm0zSkplZVMwdzhqQkpXVStIdVRxVEhE?=
 =?utf-8?B?OEFzM1FYOG5lVTBQMmtOVjExS1BUbkNKV3RFOFBjMXJxVkxaMHYyaG5DQ0pk?=
 =?utf-8?B?QUM3SzFzY0VpczJrMXhqWTBYalJHVzMwcGhlL2hydVhGY1RVbXNNRTJDOGlJ?=
 =?utf-8?B?R2k5NGlXVm11SDV4QTkybG1CU1FmUWU4T3J5L09DYVdPbDEyRWhFUm5XemNT?=
 =?utf-8?B?TzVVcjVSZThTZVBHSGFhWFZNWStWS3hJTC9MaXkyNDRNT3J4MXoza1loZ2VN?=
 =?utf-8?B?OEdUMUhhWUZCYW5CQkRLOUZiREVoaHpLbEp4dVluNEIvNm1UQ3phMW9JbHpY?=
 =?utf-8?B?ZWJxc3FCRVVmQ1d6TmdWNnJ0L0VtYXNIOVBEcC9RcmV0S2F4ZWh6UTQvRTJ5?=
 =?utf-8?B?ald4TVh3c1BPR2w4TktlOEptdElWQzJPc3MrNFh1YXFHcTFFR3RhQ3lrTm1h?=
 =?utf-8?B?M0ZMY0xnVkh4WmhEb29qMktIbGxLSHB3NEpwOGtNMHNndDVoVlB3RUtJQjNy?=
 =?utf-8?B?R2IrQTRCalBjK1JYQk1aLzhFZUhRSS9MSEpwbFRTeUs4aGRsb0IrNFdyYk1S?=
 =?utf-8?B?dDdnZ3JSa3JCSGxoOXBlTWx3OUdIVml4ZkNONmpzTW9INUQzLytsL0JUcmpo?=
 =?utf-8?B?T3RoRzh3UVZPOUp3VUVJMEpRdWpSVU14LzE4czU2dkU0L0lGMHZaai9CdUwy?=
 =?utf-8?B?MUlhYS8rWHVZTVltZnFJVnlIU1A5YzRROVAzaFFqdnkzS2dHWEN2VjVPN0dW?=
 =?utf-8?B?aHQ5WFB4c0NTdnMzWkR6SkpQeGVFNXZtZ3pOcDB4cWQrN1JlcCtlWlh4TU55?=
 =?utf-8?B?RnpWb1E0ZThNOWRCeXhxYWtyMVFVakV1VEU1aFNLZ1ZrWkVSeThQdjRjdE1U?=
 =?utf-8?B?b1ZlVWdtMDJmUzdvMjF6SmwveGlYQTNwbEdHa3hHeWN2eXFkazBDdko4S3Rx?=
 =?utf-8?B?ZkozQnF4UzBZRGhMdlI4Y1NQMUp5UHduWUdqbzNBOVpCaXp3RHZkL0F1UDc2?=
 =?utf-8?B?UGYySzE1aDVpdlJGRTRoeW9yQ3IrMVZndTFrdTBodThyRjZEdnNpMytMdVR3?=
 =?utf-8?B?T0tWTTlQUmF3QktCREJhYjdsRUd4RW1yNWNuYUV2SU51bHdYbG95LzFjRWR1?=
 =?utf-8?Q?sPphJQlBBlIpXyR1tOSVFSWF5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac52b1f4-49f9-43e4-0c8d-08dc23166089
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 11:10:19.9320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5AlXHhD5JCtM3gIaHxduqA50CP8fo0m6qU4L/+SHrrSNcDkpnkwUj22XPv0kmIM1oHjltC/dWgdVVt+8LfKGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8232

On 2/1/2024 3:59 PM, Borislav Petkov wrote:
> On Wed, Jan 31, 2024 at 07:28:05PM +0530, Nikunj A. Dadhania wrote:
>> Changed to "req" for all the guest request throughout the file. Other "req" 
>> usage are renamed appropriately.
> 
> Yes, better from what I can tell.
> 
> However, I can't apply this patch in order to have a better look, it is
> mangled. Next time, before you send a patch this way, send it yourself
> first and try applying it.
>
> If it doesn't work, throw away your mailer and use a proper one:
> 
> Documentation/process/email-clients.rst

Sorry for that, will fix it. 

> 
>> Subject: [PATCH] virt: sev-guest: Add SNP guest request structure
>>
>> Add a snp_guest_req structure to simplify the function arguments. The
>> structure will be used to call the SNP Guest message request API
>> instead of passing a long list of parameters. Use "req" as variable name
>> for guest req throughout the file and rename other variables appropriately.
>>
>> Update snp_issue_guest_request() prototype to include the new guest request
>> structure and move the prototype to sev_guest.h.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
> 
> Tested-by: tags must be dropped if you change a patch in a non-trivial
> way. And this change is not that trivial I'd say.
> 
>> ---
>>  .../x86/include/asm}/sev-guest.h              |  18 ++
>>  arch/x86/include/asm/sev.h                    |   8 -
>>  arch/x86/kernel/sev.c                         |  16 +-
>>  drivers/virt/coco/sev-guest/sev-guest.c       | 195 ++++++++++--------
>>  4 files changed, 135 insertions(+), 102 deletions(-)
>>  rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (78%)
> 
> I didn't notice this before: why am I getting a sev-guest.h header in
> arch/x86/?
> 
> Lemme quote again the file paths we agreed upon:
> 
> https://lore.kernel.org/all/Yg5nh1RknPRwIrb8@zn.tnic/

I will move it to arch/x86/coco/sev, do we need a separate "include" directory ?

As we are doing this movement, should we move guest messaging related code to arch/x86/coco/sev/guest-msg.c ?

Regards
Nikunj


