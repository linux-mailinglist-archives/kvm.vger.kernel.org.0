Return-Path: <kvm+bounces-7269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EBF83EAED
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 05:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDA521F21307
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 04:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5C412E6F;
	Sat, 27 Jan 2024 04:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V9xm+xMs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE4D11CBA;
	Sat, 27 Jan 2024 04:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706328383; cv=fail; b=CS8MvBAgC/xPV388IqKEHrFRbzETWTQxEHZd9rO3SXtpJ89dBW2KCKmYLL5ZIOEapPZG5xz+JFvJ5vIzg/4yOBivgICR1Pn0o7FIT7wHImH30OUtT4SDzD/J1OXQ5ZCrHVuaRDhV7PD0tsWYBO91DvVbbmGUh4JK9iDp1j3CSYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706328383; c=relaxed/simple;
	bh=j+DmChY+fy3NAS4SiB71C5JOyICBBLbqCS/XS1rO1SY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kw01BD/d+Sa18RF24ozEXK+OUeDC4HArcvZANsWPxuVNKCpbU81+TBLG75zznlJRHoYc5p+5P55o9vHukLeUJR1jT4dDBgHKE0Nj27Q/ES7t0vGCeCFrNVLTarRKhg1U4OyzV+Nvd3MYjbt3+OTSJ/CQHVVrgPI7Us+RKMfY16A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V9xm+xMs; arc=fail smtp.client-ip=40.107.100.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEg7W+chcJYbtkqIvF7AdM+oMi9dMZldr0pdoWvrDmk31toyi2JLKtUklP9VEWOXdlhXtEaZYmraI6IOoceobd+SOhkQSDJFFrMVOtsIxaKUh4YMlNSOufiLGHbzZCiSzJtGaHmHZ0Ix6zDuzpvfJiVH6mD7N+KwJOiuYG+Eh/p9Q15RMDp0EkrLHbrpUcCrPhWeuGqp7ibySRzj8VUgAMPyVNL8W3cnaMqsHdeU8j92wn5LIuBhF9voaHNGNstVWCvqd4me7cfaSn6oUUz/iOI/rm3iRingY1OFsSfwf+2I5R7mwZFWteoRiB8Zyoj/JU5WustWFNw/yNDPsNPi1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3YhB96upY22oIqFPQxwCWF51XLEvDAOxOZZRXFz4/Y=;
 b=I3qkiAh8kypEX5gR0ktOzUhTjER5GV8idISuVHnuxBov9Mskd20Z68h+9zyztwCaFoDuPwwEWCUQaYGshASc1s38he5+7OagsBVAK5smrdHUh9cEebctLbYgPUS18Bnjs5dQMyX140vH6UDXvHy2nNx6km9GobP28NkETvMggpaI/XKDWXy/4Jz+qTBNiwJWOqD8JM/FzqrAdc7xZGN1oSzvueGECisegoVIJIBFRvjfokc2fBF+yaKi+9uNrOGnOg1kAkVi5SWJqDpfwAYQ6zG3L4Ee9H2r6RZOPCG7KS2iG9Y9ZIndiHx/J4lRyjkv5qALcyctgT+idHTTWaDOMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3YhB96upY22oIqFPQxwCWF51XLEvDAOxOZZRXFz4/Y=;
 b=V9xm+xMsNjLpDk6JKI292GNKj9HA95iaNZkE9DNW0LEpraV14neKrALolyk/eRNtWtFb5iygWMhEGRkjMWdiThqmIPnQJf22GhoiAiUTIPdiTR8yPcEwQefo1rhtHaVZLUFlsK+QUG1f0+S4sXJt46Ooz87jwwKB1a/bjirm2I8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN6PR12MB8470.namprd12.prod.outlook.com (2603:10b6:208:46d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Sat, 27 Jan
 2024 04:06:19 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.022; Sat, 27 Jan 2024
 04:06:18 +0000
Message-ID: <709a64c2-a58a-4d74-bb63-2e1193c2f83b@amd.com>
Date: Sat, 27 Jan 2024 09:36:14 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 06/16] virt: sev-guest: Move SNP Guest command mutex
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-7-nikunj@amd.com>
 <47bbe1e6-e9c6-cff8-987e-e244581f689b@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <47bbe1e6-e9c6-cff8-987e-e244581f689b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0186.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN6PR12MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: e2119b50-fd7a-4867-f269-08dc1eed5076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nYiRx95UhzjoxYiq0VOphl3LE39sfDcV4br852uuOGpx1ftTr7ZfG+0ihMhEDDNdPQwLBV8lZO2vZwG77M+6EGa7RVk2PmCGuzenNJVkKIW8ZjxDDFneHd3brO3BhPrFwST+vfC5LhAD+qSc6u8j5v5iJFnN8LKLfDngrKGeclys/Gv1M5H2NVosSOxsyANOceGV2/3JolhQw9otzuZE0Ll+5rFJxWG/TwxQ8b7hUm5cNGk6s0QwPL+hF5aupDxirWyA+CilLiCVLW0x63X0oZXCe7fiLlq1DYsCUYwahFVVq5HKfU5H2c9axikGGDuIGDkUkGuAVXR4t687VTVqAuBrCVAUzKoVMRz2PmFXfKNIcJnNCwOJiBVhaNC3HLsGVK23zmrATabyHvR4SmozXEbsU+8lFOOJzi1Qj6uVaJA9EvHijapMElZQ2GUSjIQ91AfD6wbTnnKit2oGlUMhSuFiQl7mOXtXx9+/Jcp6GUyOWvczEFyk8v7THLaJq877/R6IYFFoG9khH/i5L/QY2hBD7w/chbkXajqPqiWq76fwr1h+w+ONDHi5xGt9cvtwHceXB0bpdyRdvvgGfWKESMBmGIFWD9ll/KdKhfEIgwCsthlmBvOpKu/GCwQzHN2kqz4W8axTFyqheLJX3LGuBw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(396003)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(8676002)(4326008)(8936002)(7416002)(5660300002)(38100700002)(6512007)(53546011)(6506007)(2616005)(6666004)(66556008)(66476007)(66946007)(316002)(83380400001)(31696002)(36756003)(3450700001)(2906002)(6486002)(31686004)(478600001)(26005)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDN6T0R6KzVPdFJCZFQ4NVliWlZyTW12MDRxanJNRldRMEIrbk50V3Eva0lm?=
 =?utf-8?B?aE56dWtBcE96TEM4L2J0WUhJclEvaUczMkNDU1JZUWc5bjloVGtjVi9IR1FL?=
 =?utf-8?B?SmhLTzQyMGNaZWYxYUc1UzMrWFVDZWREZ2xjTWlTZkJrdTNqQ09KKzIwcWFv?=
 =?utf-8?B?K1ZzUzJxR2dxcWVlQ0VlelppQkt3MEQwYUpDc2dIU3BXT3NFTmFkZ0xNUzJT?=
 =?utf-8?B?OXJxUWg3azl4eWhPMUtMQmd0eHBKR3RBUG0yV3hlaHNvbEhVaXJSYjE2ck1M?=
 =?utf-8?B?NHhtQVZsMlJqQ1NmT3hNSFVMZVFDTTN0akl5VDA2bCtyZ1crMFJxaU5DSWlI?=
 =?utf-8?B?OXhLOG0vYlFURnVNSVBnTWVIcG9qT0lIdldDcU9CdHMySEp6bEJxYzJqRUNC?=
 =?utf-8?B?UWdXNU5qL09TaTgrU2d5WkR3dmxqNEhIVHNKRFA5YW9KUjNpNC9wMzlRWFd0?=
 =?utf-8?B?Q2h4aHFWS3VwQnkwNllYUlk2dSs3eFRBMCtCajUvcVVJYWI2V0FtL2tYUUNm?=
 =?utf-8?B?bVAzcTNEWE1FdFFxMnFydHp4emlNNjMyMHJ2NFhTcUVucmFTKzFGeWplRHZw?=
 =?utf-8?B?VXdtYWYwK0lWbFA2UUJRRVZUU2VVVGZFd2xvTTNJQm5kMnZCTnM2UGRZWDBZ?=
 =?utf-8?B?TmlmTEEySVFjRzRPZnVsaFFxS3FjM2FNVEFEN2ZsM2tPYmlyMGtVK3d6S01G?=
 =?utf-8?B?MW5KWFdzWFZFaHhvdDJrVUZwMExuREN3YlRVWCszR2VGRXpTWTN1R3ZNb0s3?=
 =?utf-8?B?K0xWTDE3d0V2ZXZ6NmRmaEF0VmpGcWpOVlRkM0FVc05jOE5zRy8rbzVDanEr?=
 =?utf-8?B?cUdjbVJsekxxOURDK0ZQNm9ud2lCWk9LSnllZlZaMThsM25OM0UvVlNhZ3VY?=
 =?utf-8?B?NUkyeDZOQVFDSUFFOXBiOEpNZFlSdkJOVUZpNnJlUTJ2cWxuUUFFYW5sL0FJ?=
 =?utf-8?B?WUhlanJTeTh0Y0puWUIxQXFWRFdFdlVvM3pOa1ZPQW83aWEwbVljV2NtOUR1?=
 =?utf-8?B?L0lvVDVJUlRFbDFmZFl4T2tocnJjSlRYWXcrWWMzdVJaczllRGdzZWdkeEUv?=
 =?utf-8?B?c2hEbU1Bc2NmNUlaYlRSMkVXN2F3Zm5YVjhEMTFIR3lFSnNoY3dMM2Z1VGhT?=
 =?utf-8?B?WGpXZTJWV1ZwMkNvanRLS3RXdTJGUkU4SzM4dFVGeVFHVzQveFovTXoxbzND?=
 =?utf-8?B?bUhicStSVm5yY2NzSmFXaks0SUhzNEMxMUxpcTg2ODlCbEdVb1BsNEJ1b3hC?=
 =?utf-8?B?cDZvS3VJVGRITU5DaGZQV2l4SVdnSXhVSEdURGp2bzRYd255WGhGREVVR2RG?=
 =?utf-8?B?cmRoMGRZcnlrNkd1clloNVJ3TXVwRzlqM2Jmb05xTG54VWl5Z01HbW4zU01q?=
 =?utf-8?B?RXRwR0hVdUdJV1loQlhRWWtUanJtTzdRMk0rc3JDWjQ3b2lPWm9pdEV3a0Ri?=
 =?utf-8?B?YjhXd1hnTVFWMVVGR1RvenhCenBvdW4zdE5yUmt5SnNlTjg2NFZJY2cyUTRx?=
 =?utf-8?B?NE9hQmdKRmJOOUNiMEg5cmRMV1VGdzlZZWZPMUhNVmRCdGMrbkhwWFpjM0tD?=
 =?utf-8?B?eVBOT3F5NkVGY0N2WUlEbTFkb3o0V0ZZSmxqYS9uQnNoUjB2MkZpcXdsUUc0?=
 =?utf-8?B?T0NJZk0vcEUvb1RkanhuTTlRdFV4MFRROCtoWnhSSi83THpKQ1MvdlJHRkph?=
 =?utf-8?B?SW1iTWtQVTRnaG9zbUo3MHV4UFJmbGg0TUVHY2cwQ3hsVzU0WTZjMy9QcjJN?=
 =?utf-8?B?NkhLeE5FcXJBcGM3Q2E1TmZ6NTh0UU1KUDFUS3RneEpzc21mdUJTOU95dWRB?=
 =?utf-8?B?WCs1SWVNUGdtQXdqRkt3RCtPS3YrV1NRdlZibXpaa1RCSUlWZDFReldUV1pZ?=
 =?utf-8?B?TGwyUzhQQmtLSW5yK3lJZjM1ZDl5bi9EM2g4NjdIQzFxRlgrVmUwdDRiTk9Y?=
 =?utf-8?B?eVkveFFuU05pL1hJN3lWTWQvNk5ZN0ZCa2Q5NDZHUy9DSzkrTDRtMndzNjA3?=
 =?utf-8?B?VXBlOGZ4c0ZDeStYSEFFY2wyNjFEVnVTMzZsNUJwUVNxQkpsaVNZd2FZaVpN?=
 =?utf-8?B?ckNZMzB3WU1PVzhUcTkrNWhGUzFoeTJwU1V5RldSWHl2SkVaclZnTlVMQ0xN?=
 =?utf-8?Q?fv+7NtDDo7f8snzgrZYdg+vYr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2119b50-fd7a-4867-f269-08dc1eed5076
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 04:06:18.8981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KrbMvgUXqMuGJkOk5DBey63Am+0dOI9vhoH9QKGSty4R50uSF23mi1DlTUHuvToVvmY2fe5+h3hy3QK9SWz7VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8470

On 1/27/2024 3:41 AM, Tom Lendacky wrote:
> On 12/20/23 09:13, Nikunj A Dadhania wrote:
>> SNP command mutex is used to serialize the shared buffer access, command
>> handling and message sequence number races. Move the SNP guest command
>> mutex out of the sev guest driver and provide accessors to sev-guest
>> driver. Remove multiple lockdep check in sev-guest driver, next patch adds
>> a single lockdep check in snp_send_guest_request().
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/include/asm/sev-guest.h        |  3 +++
>>   arch/x86/kernel/sev.c                   | 21 +++++++++++++++++++++
>>   drivers/virt/coco/sev-guest/sev-guest.c | 23 +++++++----------------
>>   3 files changed, 31 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
>> index 27cc15ad6131..2f3cceb88396 100644
>> --- a/arch/x86/include/asm/sev-guest.h
>> +++ b/arch/x86/include/asm/sev-guest.h
>> @@ -81,4 +81,7 @@ struct snp_guest_req {
>>     int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>>                   struct snp_guest_request_ioctl *rio);
>> +void snp_guest_cmd_lock(void);
>> +void snp_guest_cmd_unlock(void);
>> +
>>   #endif /* __VIRT_SEVGUEST_H__ */
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index 6aa0bdf8a7a0..191193924b22 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -941,6 +941,21 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
>>           free_page((unsigned long)vmsa);
>>   }
>>   +/*  SNP Guest command mutex to serialize the shared buffer access and command handling. */
>> +static struct mutex snp_guest_cmd_mutex;
> 
> You should probably use:
> 
> static DEFINE_MUTEX(snp_guest_cmd_mutex);
> 
> That way you can avoid the initialization in snp_init_platform_device().
> 
> With that:
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Sure, will change.

Regards
Nikunj


