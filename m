Return-Path: <kvm+bounces-6472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E63F832E3E
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 18:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D22B1F252E8
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 17:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BBF56443;
	Fri, 19 Jan 2024 17:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sG2+/OEx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05C452F84;
	Fri, 19 Jan 2024 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705685817; cv=fail; b=CU7Ozf4a336izVXZddpjAwDY5YjpU0rYznRlOisGpcjVfz7apLYPOxGkpynsOPWK93Sv36v466U3n75bxGDY5E1TmARnMeg8AZJ5u50ev/8D1UMIg8kdrAPRbGX+5c617dNbsVi4IdETurm6tGot4uJfnZo+wyckAMbp2PTS+R8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705685817; c=relaxed/simple;
	bh=/37aeYYWkLHvDEFx3orprQ6y9OOk+cbsS/heyf3LJ8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S2+yJ9n4LWHhdnV12PlmJ3bW8gHAEnO4p6EffhlpgGgSoxwlyo+lgiUFr2mGf4RZVVPwBJ5IbHvmw2pe0RJkUBjRRNlOT14zJ2d7ayAsPbt63fVRj1w0heSLV65qBGmSApaYnak4iOasHMqRj4fHGs8YifPjfHo6eAkEBwV4f2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sG2+/OEx; arc=fail smtp.client-ip=40.107.100.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKiTgKtgzZNl7la7oxmYoihAJEVh2LTfvpDYBHZVZ4hx2zABpxcgBcaH1M1qoRm40sHwbICWB/gQ8NXqvYTXiGTRN8uOyGhKp2Aq9VDk7j3R00vCFHKjaWqx2fsl2pRdaTLboRT3F/zwpqs3kTHK0cTOmjUDNgj/Vnf/odVzfQpstvhrh/SZkAMfjR5KqLM6cGB2qUG69IzJP87ZGEcepq2oRZdeFoCegtGjgv0Ywgy28vZ0VDAEiCkMQ46wfIRbrp00e22R27+Wk6gnpZDW/jpBm5Tqi84tkxMPRrBN/drZa8cRMFNZYQOqxrtCLnnC827yOeRVN44s5jYsV0A6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOdYnT1MxpTTM/LrhTTqYKq6ykaWaBkauHnwzzxNet8=;
 b=Ctp0klkyRoE2cIgOAcwqETpnV34ZzlSonBoY802n54p1N5DasBgmNoozKaUxobkkYuH80tmfcbY2mAvIrxuUW/0tA1vNe7iDteCKH+ISX4JJguNW6xFKTrstpwFlOODuHr56hrEXm8eO6j7wp6uJxnqnKU8C5cvLJ5jHxJZOAm+H9tMoQ6cd9c+arXP0eUsXiZFgmmn1HHAYLkd7hj4k/2mJm/XBC0DfguGBZVraP+ACrzRDFv3EDOOCJ9+BJjcDXWLrCKuRJMnikOAVYIFMghVyD6vQsguLh/WVfNzgsJYBAYYQoX8L+A0ap1BkIIYK8P8jPwm+5Oo+cvOEiJ/OfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOdYnT1MxpTTM/LrhTTqYKq6ykaWaBkauHnwzzxNet8=;
 b=sG2+/OExmQh3HVHI1qu34d60IkG1EiRTZVRs0IPXYOCNCcUaMWLPm277vw9hTd/TzTb8PTmBMM89/9FwLki10CDMf8IDqwC/JSN95xyqYOF7+dhcLrnZaPlkj+qu2NR+Sw9noG7LqTHBVbw9O1tiamR8ASF0NObxKkSLPadSwT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CY5PR12MB6251.namprd12.prod.outlook.com (2603:10b6:930:21::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 17:36:50 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%4]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 17:36:49 +0000
Message-ID: <6d8260e3-f22b-68c9-03c7-5e0fa351fe05@amd.com>
Date: Fri, 19 Jan 2024 11:36:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 18/26] crypto: ccp: Handle legacy SEV commands when SNP
 is enabled
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-mm@kvack.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 jroedel@suse.de, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com,
 seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
 luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
 pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-19-michael.roth@amd.com>
 <20240119171816.GKZaqu2M_1Pu7Q4mBn@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240119171816.GKZaqu2M_1Pu7Q4mBn@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:806:20::30) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CY5PR12MB6251:EE_
X-MS-Office365-Filtering-Correlation-Id: c811268a-9bf1-440a-349e-08dc1915372c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l6SiJrTM0/PhL4bu45LkdFVMc4GucdA2ujxTygn9W67H5LKHNqENf7cgTBqDClh+0tqYq37YVjAkcJW2AUJtOyUBklzcuQn8fWMcZr5kidmuC95MJLTKk64yio6CMLNdQxsbgMuGvyuootDDI7qdG/3nc2ugbsZ8VkAI85ZJDnvzVLBjMlbqBmCwvtQHbYmlBQ98U/a7aEIRkktG4NtJWdo/JPBJwZjNUJCcs92g2+L+nio8ssh4x5MX+6WWJXgbB+QJDdj2Tl0b7BpwSTzgdzZCIFTZbO8Ga8WYYu45Ic3B1xR41SvHGKTAQWjt9PPljjE/iIHz5EECFf8N+DzuWKusuwjq+QC6WpMEI6cHLSfcaHiNSx8Jhm6nJhVEkrHFqn4ONPLxas/Sv0UD7gO5JNH3/uVvcwgTZcnI4ca8hNmTUHXxwKxFp2tF9zKcd2b185yL07H/CMNogbbxqgpjJwrSHEr1ZixYjJB9I3RmYVSB1+e1YzRsWreCAcaGEHzY9rYcIjxyB3CCJsbgp51CQgGnFvFqBOwNY4ohO4Jv2S2/+f82wLQUlZvYubOS5ECc+ZjNMzj13sQ/J3A9LfRjEKdhaMbYJj0i2+7lNG9eR0JVHCFjjOFteCYxZ/BiSPQH72Yo+PavpeW9n5+PrCne+A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(366004)(396003)(376002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(31686004)(83380400001)(8936002)(2616005)(6486002)(8676002)(4326008)(5660300002)(316002)(53546011)(66556008)(6666004)(6512007)(6506007)(66946007)(478600001)(6636002)(66476007)(26005)(110136005)(7406005)(38100700002)(7416002)(36756003)(2906002)(86362001)(31696002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWQ1QzVueS85YkNua0lnTlhpRlFhSU1LaktXV015TkxibHJKK2JZTCt1QVFr?=
 =?utf-8?B?U2x5azhJQjFFZ2lGWEJ5QUpFb1RnTEd5ZXpWY3EzZktDSTRZdnhMVnVtUEVY?=
 =?utf-8?B?VkFpL2hRNmhXbG1QOGRxSThJM1I3aWRrL1ZKM1JJNzhSTTliNUFJNWthaFZs?=
 =?utf-8?B?eFU2MUxSRmdvcVBGbXRmT2ZPR005RjhzcUtHNkVBNUV3NXFCMGxISGNmWEcv?=
 =?utf-8?B?M0RwUzIyMENCMjBlQVRWdmhxNmNKWnJCclV4aVdsNXBES0JMekV1U1BYOEZF?=
 =?utf-8?B?dkRFa09mR2NBazN6akp0YmIxUEJEZDVidlU5UlpLMnVJTVB3dXdVZ21ybldF?=
 =?utf-8?B?M2s4eEJyOVNLalErNnhMdHQvUXEyb0JZRkk0ZDV1TEN2NXhobGVYeXhlQWxM?=
 =?utf-8?B?Y1htc0hjTlplVHN3Vm5FdXFOZ3FMa3pKbWo1Nks4c2d0Zk8vMTRkTFBFMzdi?=
 =?utf-8?B?elpmdWVlZ1A4eWpHSFN1cTVqK3lsRDRSVmRJeHhYMi80Si9ZV3FpTFdkZkpH?=
 =?utf-8?B?VW94WHRDNG1rNU1DbzFpS2QvQll6bTFxZlRRSng4TnNZaEJ0a28xOEVFRTZ5?=
 =?utf-8?B?a1hKTXJrVVVaR1prYk9JUE9qWGhVMzNTTnF2Z1ZQZ1RVNVZzdU44QTN2TmJM?=
 =?utf-8?B?TUhNZ1dPL0dYQkE1SmxPT3JPQkR5Q1hYSjQ1RTJkUUIzRnZZNnJOcm5UUDNE?=
 =?utf-8?B?VUM1Tml5UTJzU29lU1JLVmVTNXk1aDd4cGRUYnpCaXdhQldLaUVTRVZVN0tM?=
 =?utf-8?B?cnJzU3pSb29zdHpPWmV6THBEeWRKWFNlRVNEWi9ucjVMcnBTUmlWTWRwcUEr?=
 =?utf-8?B?UjlabjZDUGN0aUZWR2pacmF3cURIYWpIUFI5eFVQN0I4R1kwT2FYVFZMRGRt?=
 =?utf-8?B?VkFkM3puaW9NeHlsUGhNNUJGUktocURuRW0yQm5EZnFHTDV1QUwrWUpWQmd5?=
 =?utf-8?B?OWJvd1h2UlZMSXhJK0dKNEZzVFNMWHdoVUtsOE9CUHFLK2N4WlhabVIzRU1D?=
 =?utf-8?B?Q3dma2h0b0hucUhyVmo3V0RDYm81MVVmaUVzVVZjYzA3TEljYVdYYTB0UEpI?=
 =?utf-8?B?dGFiaU9aRGNhS05UamtjUmt4UWl0UGxVcG40S3dYd1Ewa2Y3VU5vQVdTZzRV?=
 =?utf-8?B?WDNlTzRMWk1FSWk3aEhVV3pzNTVpdW5Oak1CTXVjVC96dU9Fang0ZDQ5WVFx?=
 =?utf-8?B?TmRBQjNSQkk3bVR4d3JvMkROWDBSZ0czeDRPQ2duVndrL09Ib0p6SThwelBT?=
 =?utf-8?B?b2JBejd1VHZCSUZwQ0dpbEx5NTBCOXpOM01EZnlrVGc3ZDZjNk9UcDhjZ1ha?=
 =?utf-8?B?TEthUFgzd2x2bFBsWS9jRGMwWlpmQlVKenBCanFwd3F6WlI0b2hxTmhvVHd5?=
 =?utf-8?B?a0tieGNxOUowdGU0ak9PTDFmVzg1QldTWE9TZ2dBY2hXRTdnZHJyaEc5YnRW?=
 =?utf-8?B?M1pXeUtaem41OUY1K2pwSnlZMjdLRTc0WFZONmNwZmtQR0FRdTlIaDhBQk5F?=
 =?utf-8?B?ZXp2ZXdTbGdNbTJaMWszazhLN3lTM3dtVldudkRXbFRNUEpoQ0VKd29XQnRJ?=
 =?utf-8?B?emc5cUhQMkN2enJVOXlQQThQRVNSQWMwK3VkN1BTd2N2Q0N0akJJZWFFU1VG?=
 =?utf-8?B?VUVVYjg3R1duQndvQ0ZNRUNvNVlxSFUrK3EyZG11WnZGWVdKZUMzakpTbDRG?=
 =?utf-8?B?WVVHeGdwem5jaU4rYnBXblQ5cmpYL0xJMDFZUnZEa0JmU1FsaUQrWWFGaVUw?=
 =?utf-8?B?ZnY3QnFHVk4xc3ZQUExRWkxmRWxBbERhQTBQeGw5RjRVUll2TlMrMWszOWY1?=
 =?utf-8?B?VmlKWEJXZE1ObFp3VUlnVWFDaDJ3WWVVeGFIb29HTmw2OVl6NjdncGp1R3VH?=
 =?utf-8?B?Y2luY0s1NFh1SkJMeVVPSjlvSnM5VVBIYmtXVkNjdG0wUlBYaHI2S0FMS3Bu?=
 =?utf-8?B?Zkx4dVJGNmRxNjVWakpGSCtjQ282ejM1dlpPb042Z0k1NGVUQ3pvVlNnd2FR?=
 =?utf-8?B?aW1wQktjTXZxelA1bnR5dnZvL285Y3VLRitWcVJ3TGwva1hFbjVxeDFJVGVQ?=
 =?utf-8?B?KzVhdmQ4UURpN3BzWHN4aGh0bFdQMjVnbmphbjV5UUJ3RlpYMm9hbTdVVXc2?=
 =?utf-8?Q?n45X+T1dV5hp+NfCrqGtH4Rfm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c811268a-9bf1-440a-349e-08dc1915372c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2024 17:36:49.1727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbD8XK7bXFLc67d70tMHjUnrTDsluyuPB5e2ZQwVlfdwmtm7h8114DCuzWRSsMGDLD8COlm2xjZlWOwVPPIo/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6251

On 1/19/24 11:18, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:46AM -0600, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The behavior of legacy SEV commands is altered when the firmware is
>> initialized for SNP support. In that case, all command buffer memory
>> that may get written to by legacy SEV commands must be marked as
>> firmware-owned in the RMP table prior to issuing the command.
>>
>> Additionally, when a command buffer contains a system physical address
>> that points to additional buffers that firmware may write to, special
>> handling is needed depending on whether:
>>
>>    1) the system physical address points to guest memory
>>    2) the system physical address points to host memory
>>
>> To handle case #1, the pages of these buffers are changed to
>> firmware-owned in the RMP table before issuing the command, and restored
>> to after the command completes.
>>
>> For case #2, a bounce buffer is used instead of the original address.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Co-developed-by: Michael Roth <michael.roth@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 421 ++++++++++++++++++++++++++++++++++-
>>   drivers/crypto/ccp/sev-dev.h |   3 +
>>   2 files changed, 414 insertions(+), 10 deletions(-)
> 
> Definitely better, thanks.
> 
> Some cleanups ontop:
> 
> ---
> 

> @@ -904,7 +904,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   		ret = snp_prep_cmd_buf(cmd, cmd_buf, desc_list);
>   		if (ret) {
>   			dev_err(sev->dev,
> -				"SEV: failed to prepare buffer for legacy command %#x. Error: %d\n",
> +				"SEV: failed to prepare buffer for legacy command 0x%#x. Error: %d\n",

Using %#x will produce the 0x in the output (except if the value is zero 
for some reason). So I would say make that 0x%x.

Thanks,
Tom

>   				cmd, ret);
>   			return ret;
>   		}
> 
> 

