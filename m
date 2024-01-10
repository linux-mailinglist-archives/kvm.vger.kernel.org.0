Return-Path: <kvm+bounces-6002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B20829D6A
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D57911C2240B
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 15:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E111C4BABD;
	Wed, 10 Jan 2024 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k9hYfLsg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BF94C618;
	Wed, 10 Jan 2024 15:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYp0mGHs0gHyoLYJ8qrUKrgZL4QW5u7wfxl2lCzRLr6hL4Z2gPWWQGBjtedqmDeZj9sxl0mxXQXZf90mH8pXZsdsfJSAH3VfxlMFtEtC+bRAbSiZQuqiQ7NybL9StdorzsOS4C9+Ez89vQKcIkz/TiPJzMOZ1gDmPO7QLdIQea9wIQc7FUs2Bw0Cz0aGY+a6bZJqSKeLJbyyKPRIXWBL4kYCcBqjjugORaaIMWsT+LZgmu6jME03X/QmZ+VafMFVSyMS797kjjcCwg+yIIvnV6AfSiYI/UJC/jLxsSAyHc5LP4EdgxCf/jKBRXBZmKlGOjasvxbcnIOt3LCKc/sKVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aT7VGjWDwqbCTSdMJbcTocUWkii9Loqr6EZRyYeAzaQ=;
 b=BsJvC8YPdzc75Q+CpMShCF8bCZBqgz7pvh00veDYDqPUKwG1WjvVVfhBZq2kXhUHgPrtunfu0Y/mLfSl+0ljNrNRKeK7r9gi/fV7mSx0Ml9/rEJU3NNHIBioZTSg0F7oH1KdTXS6rvdDVumVrfS3tHFYwuE7/QX6uF0lo3kkQPENtbkBKbkp00DtlQib67QUH/mNyoWbgG5J2J8JXaPzHlGf+fk5H2C2W1H7M3efKDd8DbDMam9K+2r5PVvohyPDjWvrpql2o3fKelz/d3OxQ44p/BAIIILOo25k/zXmEk/FK0bhZQcxZ4Z2ecL/Z8/qDyrVefOmhuf+GFkXchtvAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aT7VGjWDwqbCTSdMJbcTocUWkii9Loqr6EZRyYeAzaQ=;
 b=k9hYfLsgaHWoM85gjwoq6xwn5ZRTjbza4Qamw6eXSOpqJMzX1kx8V3A3HYW5mZZaJviZJIeaKYu8mg35xZ1LBX1TQ3q9Xh6dNMBgTqa40SHKvV4/4FDjcB3J1o71IMqv/XYGXiXLWeYBoLW/Px1BdUd8dIchvOqUWGvjtOS1igk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MN2PR12MB4486.namprd12.prod.outlook.com (2603:10b6:208:263::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Wed, 10 Jan
 2024 15:20:47 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%3]) with mapi id 15.20.7181.018; Wed, 10 Jan 2024
 15:20:47 +0000
Message-ID: <625926f9-6c45-4242-ac62-8f36abfcb099@amd.com>
Date: Wed, 10 Jan 2024 09:20:44 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
 <20240110111344.GBZZ576DpwHHs997Zl@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240110111344.GBZZ576DpwHHs997Zl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::7) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MN2PR12MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: 06d274ac-121a-4df4-de9e-08dc11efb8e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yOluekDxG4EM+cn97+t8l/O2DdHojHqQJLLYh8zDeDnHtEYv34kXPMVcPo8+9oI32be0iG7xM7F+gJ170fBn0yK0Gzd28MFv5j37euHEwo3OhsrtoKo8aTaYyfY55LAeMnL8P8XfzwznYQ+Erf3Cf11u77h6NBk/9glF2YA79xAk/Bw3aCwtMoWbd+KgmKrwBdJTiy6AAq3lub62VsOf7QaX9KfRsCzl2DrV0N8ijBp8SH6c1tkocuXtfgwte7WIYdia5LldYYjutUlbeIDzqj6yrEdh/If5tqI7WK5pzNHdLGTMLYG3oKim6J63Z6U1Ey7jcXEHLYpPVRUTbguI5/0SJYoU2GQ4HUGBlu41yniAFtnauC/U8O7XgdfkC1EOBBCMquBjJVEVQhbLCKJE28biHkInyU8CExJYZEW2021jGVHy1AzzfeCK70T/5SXjPgWQfg2xJWGW9xV++K02Lx56JlF2jKjztpmrLsUOtzd1Y2RSEu0i5u6uISjMWRVUfYBcUKk9sDHJO/JPauOcBRB44ToEJE9MM5sFr/IAL5yv5h3Cdmz2YuWXdch3sOjFebNdzeQaRfZe0TbdoHZ5dFHDwg+rfUNUIkiDvEoauvzcbvsxoQhXQH8WhKNG6qpaBOh5S2HUXdgi66wTR6ywmA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(366004)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(7416002)(2906002)(7406005)(5660300002)(6506007)(86362001)(6486002)(2616005)(26005)(53546011)(478600001)(8676002)(6666004)(6512007)(316002)(4326008)(36756003)(6636002)(8936002)(110136005)(66556008)(41300700001)(66946007)(66476007)(38100700002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3NWNE9kVlpKRXhqYUJJSXNRY0t3SEdudFp2V0gzQ0xHM0ZYMmU2cUsxWHlW?=
 =?utf-8?B?UklHUFlHaElkdFlsdW9sVjVrSTJpNHAydkZLR2Nvd05lZXZBYzYxRXpCYUxZ?=
 =?utf-8?B?VHVZL1cwNGlwRzU1WVdndGd5K25NRCtIeDhIbEJaVlJCVThNcnpLOVQ5OU4y?=
 =?utf-8?B?N3l3L2pmQlJtUkVEMFFQOXhFZmVzTTNzS0pTdTNwRHdWQ00zYzI3TnhHYUhK?=
 =?utf-8?B?MHFHM2Vtem1tM2Z2dUNnRzRyMnNGeW1rOWZNaWQvVHJIU2F6aUczV3dYelhI?=
 =?utf-8?B?Y0ptUTFYYUd5SjN4TU5peEd6U3dqbUZkb3o0Q2U5NHBQVzdmMjRIRzc1TWZi?=
 =?utf-8?B?NUJEZkMvUExha2xuNFp6Tkk5YnhYSlBEVGY4MUx0K3gyL1BiVGRuSjdTdkMv?=
 =?utf-8?B?bEltbm9CK21JcFFTcnlieWhKWmpzeEliWTNnU21mTmxKV1BEaUl5c2JESlJ5?=
 =?utf-8?B?U3UxSEwzMVlCNkUrVHM0RS9EMnVScVl1RkM3ZGRXaUFiczA5ejJLem03NjZD?=
 =?utf-8?B?R29RYTV0cjNYRmFLRDZHaEtLL1FuejFOcjF3TEZsc0MwWlJtVkhhRk5zSXkw?=
 =?utf-8?B?Yk50bUJWN1QxWG5UQldkTHRrVmJGb1lQMHZUZytGYjFhWU1qNVRLeDRxWHlk?=
 =?utf-8?B?bm1BaWticldTZ3Jyc3huT2Zqd0o0WjFQSVQvWjBxNzJicDIxa2xUYi96bEF5?=
 =?utf-8?B?QUNDbmJvVGhXd0hTWTk1MDAyT0VNWHZYZVpJUzJvdE82L1ZCaWJGdzVnRFVr?=
 =?utf-8?B?N2dMR3Vsc2F3MHV5c0FvYTladTNTcEJzRFRQa05aaUJ4ZmxRTEpwYm8zWUNz?=
 =?utf-8?B?L0s2ektvUmdhZmNzMnlyMU9aN0ZHcllueSt6MzI2OEpuKzhaUUZmTVVkdEhQ?=
 =?utf-8?B?RFZMV0N0TUxaV0hrWjhKYnBONXhDREc0NHV5VGphNW51aVlZbzFXMTVRclRl?=
 =?utf-8?B?QlZpTVJUVEppSzRoMkhYWjR3S1hWa3l4UFlwVXQ1UHFIY3YzQUlXd2M4ek5D?=
 =?utf-8?B?MHZMVUJpM1Y4cGpCOEViWFR0RDFONUhrcjByTUZGWVFPUG1yUlZ0QUZ1VjFt?=
 =?utf-8?B?MWtJSkpLY3FtdEJkVEhvYWljdURlOGY4NmEvTkVRQmc1MHJUeExxaWs5QU0z?=
 =?utf-8?B?RitOZzlpOWNsVGdPOGdMbW9tZExDQ0ZrckNTdkpXcGR0ZXlZRWxUMDBCdCtE?=
 =?utf-8?B?MkhhYzRMazNER0FwNDhnZVlEc0lGQkFmazFlVStaUWtRcVJBYTgrSTYyMzNl?=
 =?utf-8?B?MkV6ZXJNOUxHVmRlMEVwNEdNSlVrTzdLaVZaRERlWlk4RkUxQkNwVVZYd3dt?=
 =?utf-8?B?KzVxOXI5Z3picndlVkRnYnV3VmV4MW1TN0xZcXV0Mk8yVkRoNWVLQ0NlZ3Jt?=
 =?utf-8?B?NkN6bFhsWnJGUE5kRmk5V1ZTQVZVclFYMjR0MHcyeGRMN0tPZE5iUGNiNVRj?=
 =?utf-8?B?WisrckJqdUF2SWNIcDN5VkZ3VGFQS3B5Wk9rRER4QmZqR09NbVJld09iNERU?=
 =?utf-8?B?bWd5OGgyTkxhQ3FGVC91MTIwSEFvUFZxdldyVmJzL2FFZFpYTFlOOVROZ1Na?=
 =?utf-8?B?RjZPYi9MTzMyM2NpUko4UWVKWGQ1eW1lbTFldG9Oa3ZDZURxL0FKRnl1V0JM?=
 =?utf-8?B?WTRBdUlCdFdCLzlMWE1LandUeEtjV1lpYWpramZub0FSemlCa3dpUkhkeVM0?=
 =?utf-8?B?bFRxYSs0Rlo0Rkc1VjA2YXVRTWI1WjZGRUNsZFNoeTVHaUZVZWtma1NBbFFi?=
 =?utf-8?B?eXQyQlQ5bWtYb2d1NVJ4Y2FRTWN4SlgxWnM3UU80RHZKZkFvMjZXYStqUnBx?=
 =?utf-8?B?MVZtTk1RVU5WMG5wQ0xsWk1tT3p2cllQNzBMWjhQNVFNNG9sSXNZdUxlN2Vy?=
 =?utf-8?B?TzZobldrY3FqQTdPZVErTjBRYlZKaHRxSXd2M0llREFzRFMrTmEwSWhtc0do?=
 =?utf-8?B?UEJhRUhmZ3RDMEVmUC9vYnVpblkreVVTeUlRUWcxclpTamxPNG1HaDlnMjZK?=
 =?utf-8?B?MXM1UUJBK3ExUGhqSTFiY0lZZG9UK01Qd3FQUWhrTnlhY3pvSVE1REd3UTdE?=
 =?utf-8?B?V1V6V05QNTlTdFRMNWJYanJBenBlc0hBVDZCM29iamxpRVphMjh1MlBPM2xM?=
 =?utf-8?Q?UyWTfNJstgv+vS453kBe8u100?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d274ac-121a-4df4-de9e-08dc11efb8e1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2024 15:20:47.7955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyEYWyPvF7+QOBF2DrO3RSgn6sdVRvLO+BHu5nTJG3CgPwklhNoqF9XvdSH2sEMTzXcyzjbDbttqAHJV+J1CcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4486

On 1/10/24 05:13, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:35AM -0600, Michael Roth wrote:
>> +	while (pfn_current < pfn_end) {
>> +		e = __snp_lookup_rmpentry(pfn_current, &level);
>> +		if (IS_ERR(e)) {
>> +			pfn_current++;
>> +			continue;
>> +		}
>> +
>> +		e_data = (u64 *)e;
>> +		if (e_data[0] || e_data[1]) {
>> +			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
>> +				pfn, pfn_current, e_data[1], e_data[0]);
>> +			return;
>> +		}
>> +		pfn_current++;
>> +	}
>> +
>> +	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
>> +		pfn);
>> +}
> 
> Ok, I went and reworked this, see below.
> 
> Yes, I think it is important - at least in the beginning - to dump the
> whole 2M PFN region for debugging purposes. If that output starts
> becoming too unwieldy and overflowing terminals or log files, we'd
> shorten it or put it behind a debug option or so.
> 
> Thx.
> 
> ---
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index a8cf33b7da71..259a1dd655a7 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c

> +	pr_info("PFN 0x%llx unassigned, dumping the whole 2M PFN region: [0x%llx - 0x%llx]\n",
> +		pfn, pfn_i, pfn_end);

How about saying "... dumping all non-zero entries in the whole ..."

and then removing the print below that prints the PFN and "..."

> +
> +	while (pfn_i < pfn_end) {
> +		e = __snp_lookup_rmpentry(pfn_i, &level);
>   		if (IS_ERR(e)) {
> -			pfn_current++;
> +			pr_err("Error %ld reading RMP entry for PFN 0x%llx\n",
> +				PTR_ERR(e), pfn_i);
> +			pfn_i++;
>   			continue;
>   		}
>   
> -		e_data = (u64 *)e;
> -		if (e_data[0] || e_data[1]) {
> -			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> -				pfn, pfn_current, e_data[1], e_data[0]);
> -			return;
> -		}
> -		pfn_current++;
> -	}
> +		if (e->lo || e->hi)
> +			pr_info("PFN: 0x%llx, [0x%016llx - 0x%016llx]\n", pfn_i, e->lo, e->hi);
> +		else
> +			pr_info("PFN: 0x%llx ...\n", pfn_i);

Remove this one.

That should cut down on excess output since you are really only concerned 
with non-zero RMP entries when the input PFN RMP entry is not assigned.

Thanks,
Tom

>   
> -	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
> -		pfn);
> +		pfn_i++;
> +	}
>   }
>   
>   void snp_dump_hva_rmpentry(unsigned long hva)
> @@ -339,4 +343,3 @@ void snp_dump_hva_rmpentry(unsigned long hva)
>   
>   	dump_rmpentry(pte_pfn(*pte));
>   }
> -EXPORT_SYMBOL_GPL(snp_dump_hva_rmpentry);
> 

