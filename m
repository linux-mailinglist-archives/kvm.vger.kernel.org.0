Return-Path: <kvm+bounces-1051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE777E484C
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3C702812F7
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C44F358B9;
	Tue,  7 Nov 2023 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="23+7iRWU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04351358B6;
	Tue,  7 Nov 2023 18:33:05 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57158125;
	Tue,  7 Nov 2023 10:33:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eafjjeK2VTLERLD9Kn9FMAoDF/ujitHYedTVnOXKt9BffqG44lmWoVoSr/+PaYHwFSmF/0KaV/EvOVrImkRAaKmgHZlXCYlYW4MXLfVh9LfJU01r9YsOmzTNrJXxrL98qT7Yx/UHjoQ5sVMUJWJHCPibDL/kM2D6QuNNP9hs/DRBbI3xJ2aDaacShtZ3a1jdR+6TnA4Gtb6SgkRuJa8xjd+kiP1W8lh5Q3/3hkEcXsfsPR8qc48VijCImlgoxMbks6xWOy8+pigLxqjkXmepfNgI5IyVqQkynIOu+p9s9UVQVhJUR0ayhQ7KbK4akSobdHCJdpWdd4Orm2ehw4fXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSp+QH1DdOCpVqoJOXbgxOk7Iu0JcI9gw1oBTKmraLA=;
 b=fq5Ur2rEp5WLVaAUgCmSp2KEsYGq+qJPVj3Km9OBIvpdX2iXe+pNREs1P9pVk2T2jYBdl4p76p8qqnyWREacaddoH5Jm1GxO4jn9dNf7Iv03dsX2/pKzb6vmd/crWf1VAUIyBptWv8FYzrKjJ3yzAwCJZaoe8ieQK8JH1+AK3wI6fvGFm+JZalqDzqdfq7ne0cwc+7UjGx+b3n2tDABAZR0Qfe6w/gvpvecP2QSEpVUbx2tNe51T3ba2KbBs4LOzAc6jUkVKQpWO0qtf9uJ+gfO9c+zksbOc9K2fM3E5X+zvRPQWfYWIgS7hPkiVMco2MitBNW9TK7Eza5eM/M/xDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSp+QH1DdOCpVqoJOXbgxOk7Iu0JcI9gw1oBTKmraLA=;
 b=23+7iRWUk1pvVW82IXzcePmCWzLAsnoBzLZEsKN99tNWG5mzCEUa0xQxriNPkYfQ0gT0crLgRpf+DW3Rl5pkde3w2lWrv3EV1DPw7HkjYJifJhrMmNGmErA61U72k6cmjAnz7rCVj9UxjOQaolF7hf4GrfQAw1lkCTHE1tHYeUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MN2PR12MB4533.namprd12.prod.outlook.com (2603:10b6:208:266::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Tue, 7 Nov
 2023 18:33:02 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 18:33:02 +0000
Message-ID: <8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com>
Date: Tue, 7 Nov 2023 12:32:58 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 1NhFSLKvfA==
In-Reply-To: <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::17) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MN2PR12MB4533:EE_
X-MS-Office365-Filtering-Correlation-Id: b9e99109-78db-4ec6-e280-08dbdfbff985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CCnnQyQtbT3wV+6sgVuSC6lTs6seO51K5HL/K+4bPEj5WxpKZ17XoMe19Zx9NCjyZ1QscFYX8yjUfPahDKCQd8krlQHtgYOkiSLhSo5cJAAYHyk2Mth4eyiBTB1U6kycz1TeL3oFNt+4rjuxWcZaja6ZnlSafOTa0BJGMuPZCDzOLx6Pycuei455b4eYUOjmfVb/BPlMZl3ae9Fkdaal1bkA5OoeuY+/5B0VpE4QHN0PHsrHQwRkD9tsuaxjQIXdzEjAWewHNYzcYnYB9KAc5vpSgmdNyRdGmQJZV2uSRYIqE6hQsrPWt0tVOWoO1Qqb6medfgS98UxuIxrwR7Spm/obVyDTTGz9RG0MXI1Hy8FGKrV0faWzDJ0a3oO9bMI5jc5977yTchGtq6Qoej6wLIXSVY+vNl5PXOpZ9N5hV5zZH3JLjBDZwfUxVQDctZxn6me6hJEcJ8XWMHuivTjJq3AEii8XMLWoJGLX6WrpHjax+fnvPFocWuXblwc2aangDzcfXJb5gh1bCs4+z5yZVGZ6DUJl5VOKNuZCxeBmrYv6CYwmf7qDn34VIENKLySYJBeaqVKdNmfhMX0PJVU2TkkyFsC3p9msNl24/nNR7dbTs5w/L7mmF75RCOVJdp6aaUTexPaYLZlhHSaL0JOPug==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(136003)(366004)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(83380400001)(6666004)(31696002)(2906002)(36756003)(110136005)(38100700002)(6486002)(66556008)(316002)(66476007)(6636002)(66946007)(86362001)(8676002)(8936002)(4326008)(478600001)(7416002)(7406005)(2616005)(6506007)(6512007)(53546011)(5660300002)(41300700001)(26005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bm9Cc1lncWR0UnhuWTc1d0M5WDZsMWRxdTNXTFpjOGY1Q01EQzN2azd2M0RP?=
 =?utf-8?B?SmRYWjUvbEdUQ1NCYXhTeWhaeGx6YWtkdHlzbnJjUWYxSjFZdnRLbzhqQmFw?=
 =?utf-8?B?YUw2TE5NVW5UelhzNDRXWlNab1pBczArOUZqZ1FkbGNsaFZKbllQU292eDdr?=
 =?utf-8?B?enVmV3dFcXNFdktraTVPaVJvYVhXVE04OVhnK3JKclo4M0N5MFVhWVkyVnY5?=
 =?utf-8?B?N0tBbXJyUmJ2RHVTdEgrZmNNcG4yKy9GS3Z5NmIzTFVxb3JTZXQ3UHFwZExB?=
 =?utf-8?B?WnNYbitWcDl3bk1QTXo3MkkwUXNtTmlMbGRHZGNEQ1lUZFFSb2hFYVVCWmpt?=
 =?utf-8?B?ZHpxc3J4N0pYaitacHVFbnpmbWZFMXZRbEZKQUFsQW9sdm85enhaVGpvek9V?=
 =?utf-8?B?OTl2RSt5aTAwNDZwUzNyTS9IR0VLOG5IZnk5aTg5WU5TNElrbSs5SGFGOHNm?=
 =?utf-8?B?TUdWcHVaNnVvVGtxL1VYNnI4QXJOSjhmamc5Qmd0cGErNzg0ZndveXFHZ29N?=
 =?utf-8?B?OTJ2eGdQWWR4UTRQOUxDYzM5Vm5INVFIblhjQ3lwc1JOakN0eFJ5anJHTHRL?=
 =?utf-8?B?aTQ0OW5ZcFFLaURlSDlMbG44ekxzVHo0WGZqWFhUbytsMnM0c2s3MFFYRzNL?=
 =?utf-8?B?Z3ljMGFqdUFldEc5UklYMXkwaHRTb2V5aFpGODJrbFRkbVJMd0dHSXF4aGdP?=
 =?utf-8?B?WkRubTJKNXZSUUgrVFhRVllKZzBMbHRjUVBmYUtML3UzeGhlNkhYQTNMc2Mx?=
 =?utf-8?B?b3MwSlcxWVMvRldBRWhxMEpJWmU3TkZqbmVwTk9ndmh5NTNuLy9YVjdHdVRY?=
 =?utf-8?B?eEY1aEJUc3VvWFRvQlI3dGxRREJHZFlsNCtyR0xLYlhBd0Q5dTZ3NHdEWG5N?=
 =?utf-8?B?bEdJSFNEMjNkdStHeWNPOXZ1Nnl6VUJ4N0VRSkFidWNEcXFQS0lpT09BZklx?=
 =?utf-8?B?VjJ4ZGdRdUtBU3NSSmwranViS3R2dlRiTVI4aE5xUkdHclhkOCtHVU1OelNR?=
 =?utf-8?B?MnQrM0ZDUkRubk13b2Nuc1V6SnZhUExYRksyWnBJZ01HTm9rVVhwSFRFNFFE?=
 =?utf-8?B?S1VMalR0WXFwRGp5RGNPYUdNdmYrQW1PN0lzQ0h2VTlObVFZenNDNHU5akNp?=
 =?utf-8?B?cThNS3ByUDFySDlOSDBHYXExN1B0d24vSHdDeWM2dHJYb2VqOFBWWTNLK3pV?=
 =?utf-8?B?cjRlR0I2UzVYVVk5YzIvaDdKL24wVjE1dEVTOU1qUFZzNUtQbXEwaHpEM1li?=
 =?utf-8?B?TmpzbUlDUUxjZjF2czNmRm9JOUZTZnlnWHlwMmgrL1NUUzVEamV5cFEyMldh?=
 =?utf-8?B?TURLbndieDY5SWtNS04yK2t6UEp2MXJzMS9NVm5adi9vekJvOUJGV0pNRjFj?=
 =?utf-8?B?VnQvQmJMQlBsdDN3NFJmaWdKanRrclJvSUZIWk5uSmVZSVRiWUdJMHZCZ2M4?=
 =?utf-8?B?Y0hCV1dUUWhsdFlka3FXWWdUd3lvSnQvbkZCV0MrTmNzaHlINVFLSHFlWDlv?=
 =?utf-8?B?QmVaTFRZa0FUakovamphUDhoSjM5VHJPTDEwN3FrZVVKaVlDa1hmVDRmeStv?=
 =?utf-8?B?Y0txRUdIa1RqdnpKQTJzSjBxUTAwUlhHTFZPZWNzeGdoRTU2dHA0R1I0eVVN?=
 =?utf-8?B?ZGxKWEFDdGtvYlFHV0RwWkpwWGRNVVNxdVlLd0JiWjh3N0tEMHRhbVdnS1Iz?=
 =?utf-8?B?T3dkdWtQdk5KdjJ4UWZ6Z1ZHeE9pZ3B1YkR0aTNDWWJQUkNoTlc5NHR0K0s3?=
 =?utf-8?B?bUlyekpLc2FEM3dLSlArUk15VVdRUmxFMFpBZTUvY25XUVEybVNheFc5QXFX?=
 =?utf-8?B?bEFTKzNuRkNXUFpySGcxdmVlVFFSYWdselNObXRQZTV2SXJ6RGxLMUdidHFr?=
 =?utf-8?B?TTliTWJUbWJZMXVMYlhUWHY0TVZVUWdOdGpXTEZOcE85V1B5ZEJQbEtkS2ZG?=
 =?utf-8?B?Q01RYzdLVEdyOU9KbzlOdDBVa29ZcG9xT2hmTmh1VzlSSktybThMQ21EdEh1?=
 =?utf-8?B?Nmd2YUdjdWtBVmgvT3pzSmJlNWxmV1NtbkdKanAvUG1ZejlDaDk4ZTFsZmp3?=
 =?utf-8?B?ZC9oUnVUYmhoajFFaElrckV1aWxxSmo5b1ZML3FXMi9WVzNkS2wxV08zcXZh?=
 =?utf-8?Q?m+BdDCodxm0k+gkt8RjiURscP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e99109-78db-4ec6-e280-08dbdfbff985
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 18:33:02.2923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WO6kaRsLBpLh8P25WXOLCk6Q0FVppHEfLHRFGS/2s4ukqKOJoowUJ8rzC9N8Qjn3WnXbLWWgbNmIM9Djvmbxfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4533

On 11/7/23 10:31, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:35AM -0500, Michael Roth wrote:
>> +static bool early_rmptable_check(void)
>> +{
>> +	u64 rmp_base, rmp_size;
>> +
>> +	/*
>> +	 * For early BSP initialization, max_pfn won't be set up yet, wait until
>> +	 * it is set before performing the RMP table calculations.
>> +	 */
>> +	if (!max_pfn)
>> +		return true;
> 
> This already says that this is called at the wrong point during init.

(Just addressing some of your comments, Mike to address others)

I commented earlier that we can remove this check and then it becomes 
purely a check for whether the RMP table has been pre-allocated by the 
BIOS. It is done early here in order to allow for AutoIBRS to be used as a 
Spectre mitigation. If an RMP table has not been allocated by BIOS then 
the SNP feature can be cleared, allowing AutoIBRS to be used, if available.

> 
> Right now we have
> 
> early_identify_cpu -> early_init_amd -> early_detect_mem_encrypt
> 
> which runs only on the BSP but then early_init_amd() is called in
> init_amd() too so that it takes care of the APs too.
> 
> Which ends up doing a lot of unnecessary work on each AP in
> early_detect_mem_encrypt() like calculating the RMP size on each AP
> unnecessarily where this needs to happen exactly once.
> 
> Is there any reason why this function cannot be moved to init_amd()
> where it'll do the normal, per-AP init?

It needs to be called early enough to allow for AutoIBRS to not be 
disabled just because SNP is supported. By calling it where it is 
currently called, the SNP feature can be cleared if, even though 
supported, SNP can't be used, allowing AutoIBRS to be used as a more 
performant Spectre mitigation.

> 
> And the stuff that needs to happen once, needs to be called once too.
> 
>> +
>> +	return snp_get_rmptable_info(&rmp_base, &rmp_size);
>> +}
>> +
>>   static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   {
>>   	u64 msr;
>> @@ -659,6 +674,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   		if (!(msr & MSR_K7_HWCR_SMMLOCK))
>>   			goto clear_sev;
>>   
>> +		if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
>> +			goto clear_snp;
>> +
>>   		return;
>>   
>>   clear_all:
>> @@ -666,6 +684,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   clear_sev:
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV);
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
>> +clear_snp:
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>>   	}
>>   }
> 
> ...
> 
>> +bool snp_get_rmptable_info(u64 *start, u64 *len)
>> +{
>> +	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
>> +
>> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
>> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
>> +
>> +	if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
>> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
>> +		return false;
>> +	}
> 
> If you're masking off bits 0-12 above...

Because the RMP_END MSR, most specifically, has a default value of 0x1fff, 
where bits [12:0] are reserved. So to specifically check if the MSR has 
been set to a non-zero end value, the bit are masked off. However, ...

> 
>> +
>> +	if (rmp_base > rmp_end) {
> 
> ... why aren't you using the masked out vars further on?

... the full values can be used once they have been determined to not be zero.

> 
> I know, the hw will say, yeah, those bits are 0 but still. IOW, do:
> 
> 	rmp_base &= RMP_ADDR_MASK;
> 	rmp_end  &= RMP_ADDR_MASK;
> 
> after reading them.

You can't for RMP_END since it will always have bits 12:0 set to one and 
you shouldn't clear them once you know that the MSR has truly been set.

Thanks,
Tom

> 

