Return-Path: <kvm+bounces-6001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB2A829D24
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C53291F228AF
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 15:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47BE4BAAC;
	Wed, 10 Jan 2024 15:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jIyyUZW2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4654B5D2;
	Wed, 10 Jan 2024 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmbPGxWHZ8uPLCBVs4tDanhPG2Q64tphqdBufHTpND0PNpbdPEkagG7Dw4LqjeohAl5Vai7O2vgx6Du86/ZkyhUokVaXCh0IwtC5vywx5gTuRVbgvY3T4eXOCKOf07dxxLl5QckAgd8unfz6HJJB17J8ZB0RaocERrJwI6drjpZNHRekdeakWU79XZ9zmDC+kq2ATFacHHnSVo4+tXDWvKpQvnBwFgeM5gA2iYG8jGBbUD0Z3SyCCcqB13yegZjxo31Mn67K60K6om218N88cF+z400GA8GuklsEfJQTPPXOGxEYB1pxfqbZP3LxJ0fv9DSoep5J0c4CbTLfDNxxUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IU92WohF5iMC8RZ2NEtQ5wMPp/iImEBZniX2tHAdRYE=;
 b=kct0YO6I+a/dLEx0VMd2UWty9aVU7QOGmKliiORgMQ+cooJb085lup4xCz0YP4YkqwUgCiJdB4GCtKjosE0V2/4PXblK1Mjl/TssltJz1G3QCk3SQ762f8N3QwCIbhsqV9KqzoUs11TVYBU3EOumm8/lDpqbPCzyZnGcHEX1iXrQoJM0/o/oHFvoQHvt332H4+UkfGSylCOy0qKgBKferO8UDtTCC8z7TZqmXW9m5wKMK5KDYK2kgMOuyKO5t/ZhQodn779wcpN3+smdLbFeXfqxKW6kzvbIreimmLXdwpjPUaEcqJ9YHQ6F59mJXT3g1tVjT7ZnRnE9LNifrqDM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IU92WohF5iMC8RZ2NEtQ5wMPp/iImEBZniX2tHAdRYE=;
 b=jIyyUZW2L50ogGNwbsQlGzZEZVnHT09fcSh1QG6l1A9rL8zlMg4847QrnygVebvzfDjIBGhR95VRPdgHtybGLOKudvQyGnIFMhR5YQIyeQnVk3S/P94Toz3kdnV0c2AuO70WJqsV11sQKKgYIuczxqEZDAJeykCxLrteJA/tIR0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Wed, 10 Jan
 2024 15:10:54 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%3]) with mapi id 15.20.7181.018; Wed, 10 Jan 2024
 15:10:53 +0000
Message-ID: <e6ce6fac-2824-42d5-a82f-429d36ccda73@amd.com>
Date: Wed, 10 Jan 2024 09:10:50 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, x86@kernel.org
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20231230161954.569267-8-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0146.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::28) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH0PR12MB5433:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ddd56d7-ed94-4ecd-d4ec-08dc11ee56d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iw5MnI3PL2x6ZozfNP0BzC3keloDAGCRMvQFoXZODFt9CSLeMLufkQUMXEnfB1KLzCvP1zQU7zEVVOXt4pXxqaJNBLEuyGq3D/G+bKCLvg/ctkdWbZgiXMBZTh3RYEhl6Iom+RVSdTw/nWdPljF/u/ot45v0S1dgEf293WlWwNHcCnIkbsj74RzpYDsUCDufSqXhigHuDPLG2/+S/rkbVKoMl4ycdftYD15NRbkqYi4J959q4aAe/qOArApNqbqPY8uLXOfWXfX6fvB0yALSg2cRFFKLmzsgOeIENB1XM6A2MJ1Xr2EqUEdULY54NJNmY4wAncS1caaAsGMNYnrfXELV+gp1q/+pncyjRx3RBKZ1fyz0vrXFP3zkyhG0ui1Bmha35y/DcZeIJ0uGQWINAWs1YHuWk5ATCIJaL7ZuMT3ruG2lntR7kPKMzYDbNZyhCKJrXHiJeMeptqX3m6wPJREcniMvrru/0vjMfUTjwOApXNsQkBAgtblYFFanbe7iQCvLyeOiackg/AfErLwkzX0Ekv4VjR0RMbM3ATWuxsAF5ws87f4DqdNmoVBVhKYc01D4LA2DbU0szaPt4uSEyreZ03TjjdYgQWkR9dd5iL8F/KDkgYsOHLnvt+sZEDF7NLdYD33pscGVCojdBKHhfw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(376002)(396003)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(31686004)(2906002)(7406005)(5660300002)(478600001)(7416002)(4326008)(41300700001)(316002)(8936002)(66946007)(66476007)(36756003)(66556008)(31696002)(6512007)(2616005)(6486002)(6506007)(53546011)(8676002)(86362001)(26005)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eThTRmRRZFNtSzhhVFdKTEs0VENKdmdBNStLN0daMVVZYkZBenRoLzQ1VU9Y?=
 =?utf-8?B?OVloZXBGUTV4MFNPK1dUTWR0S3lzcFVjcSt4YU5sclZaanZQUDEyTGxlUWJl?=
 =?utf-8?B?UGM2dWJkeW85VGZmQXc1U2tWUGRzd2Q4eTZHeThnd0UyaDJYcy84eFNXWXor?=
 =?utf-8?B?bTNaaFlDSUxWcGtBZzhKRlRHZkxGbm1LSlpuS0Z3ZVIzOTRGR3BycGExYk8x?=
 =?utf-8?B?NGduZDRKbVRqMy9NbGVsZkNERzhQb1l3dzh4bnVqREFsODZjakVnOXFXTUdH?=
 =?utf-8?B?anE5eHVHSGxKWFNySCtqTXpISE0raGxtZ1QyQ1RtcEFCK2o0TSswb0VBSkg0?=
 =?utf-8?B?YVJvVkxoL093b2RVYVFxQXJsOWNudmpLZVVPdi80OXJjWVdFTmppcktOaDBo?=
 =?utf-8?B?QXpSRG53aVp1TTRib3ZFRmZQdThoa0RNNVZhWHFGb2V6c1JjY1pCYXFpbXlT?=
 =?utf-8?B?b3l4TzQyWko0Z1VLRkZqU1VOd01MQWY5eUhmekd4aitXRllJRm9PaGdZRmlw?=
 =?utf-8?B?T2RHUzJKdnF2L3BMUEJOUU9SalJxQVdGVEpxZGR6OTRVL1NLa0NVWmNIZzhj?=
 =?utf-8?B?dmJTcGd4VnY0L05oMThKWTdlR2V0UGdOZ0RCS1c3cTY3SXF2TVcxT3l2UVdD?=
 =?utf-8?B?ZTN2MGI0bEVxU0FLSDhrajVRMncrOW85Um9zbUxKWEM5S2EzZGIzRDR5Tmsz?=
 =?utf-8?B?QWdzSHY5U252NmhJMjhIUkV3M3NRSmh5UzFOckUwNGFyUnpObUlPZDh6RCtR?=
 =?utf-8?B?c3hFYitza0l1dVhEWThMZTE5a3BZZnYrdWNCdU9sSWwrMFhncmp1bnE5ODBp?=
 =?utf-8?B?MzBZL1MyUzE1cUVzRzkyV1NZWjRjNGEyTE9WR0laZHViUDZWN1RnL29iZjdC?=
 =?utf-8?B?WmxBNHhhRFYxN2g3NjdkYWRTVjF4OW9nRzdGeGRIUXFMVmNxcTFicmNDeS9R?=
 =?utf-8?B?QU5VTWxuYmkyeDRnaFlhWUt6N2tJb29DV0dmTTVVNVN4S0F1RHFWcC9oZStR?=
 =?utf-8?B?L2YyUGlSSlJ0L1pHSlFldi9IZytUczgzU0YxWHJhbzlEWEZqdVQrU2hQamRE?=
 =?utf-8?B?Z1llNjJjdy9Uc2s3cGJNM3dmZm5IdFRQKzM2d2orRXlMVXd0eEUzaEQweEsx?=
 =?utf-8?B?NDc4UnBTbHFhUElzNFhBRktPSmV4bzFZRVFBRm84Z2d5bUx3YnlmUmFkT0Uz?=
 =?utf-8?B?cmg3Y3FVQVNJeW9NOHIyOE14dXpJa0hpUE52dnhjVVg2VFZ4QmczcDRXTUR3?=
 =?utf-8?B?UjI2akZlK0I5b3lQTkcyR1QzdlRHTlhPSjNsd01jNVFUKy9OSVg2bFJ6djY4?=
 =?utf-8?B?NmhjdStDTlJwSTNVY1BCdjl5TjFab3FZWmNETlFGbDBoLzhidzR5OFpONUkr?=
 =?utf-8?B?NXE5QzVRYnVpYWdNelJsNk8zK1JYRGdCRTdsMUg4Yk1ER3ZyZkl2MUtrWXlJ?=
 =?utf-8?B?Q2VwZ3ZJV2M3cXhFUFhEbWx2WmMvbDczV1J1djhQZDZYMUxDb2NWNms0TjJ0?=
 =?utf-8?B?b0hVZS95SG9ZSDdPTGwzdXlycEs0SjdCSHM1aytDZDNwSUFIWGZ5eW15OENp?=
 =?utf-8?B?M2RxTmdlb3VhcTZwc0dzVGFVZWNwVGNxQ00wVDI0eGFrZlZjTmZrN0duS1Nm?=
 =?utf-8?B?M0dGaEREOEIxSGdXRm9mVnAvMnRreFl5MU9OTGRZTVd2ZEhUNUtaaFp1ODhJ?=
 =?utf-8?B?Z3BxZUNDdzZRK2dyd282djZnL21vT3d6MWovUmpzUzNER2ZUMG51V2owWlRI?=
 =?utf-8?B?YkcxWnREa05yVVV3Y0l0b1BrSkVNTjRVdDN5aXJGYkxzTG9zR1RSLzROOHhD?=
 =?utf-8?B?dGdwTEJpa3JGQnRWd2NqRXVVekcwSzltTktlNlY0MmlEQm5qTVNYbkJWZzlx?=
 =?utf-8?B?bzJXdHJiN1N4cmtEVFo0aXVFRjhhNXVobHZLT3B3WHovbWdsVG5lM1BGa25l?=
 =?utf-8?B?akZaYy90d0VMWHhNU2VOVXEveHBkaDMvMEcyM0V5eFdFajczRUo0M1NGbFBu?=
 =?utf-8?B?YXJhY3lHWUV4b25XcjNnVjYxSVFUbnNtcytuZEdRdEZ4NzlHUlBrSmxGMnRD?=
 =?utf-8?B?dmdOckhkUDNNU3hHTEpEbDdFR05NekRqMTdtcy83dFlJVUhUTXlWeEswajNx?=
 =?utf-8?Q?oNjAQZQPpVp63qJWevx03fNMB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddd56d7-ed94-4ecd-d4ec-08dc11ee56d5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2024 15:10:53.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6iLCM2tzsb8yj+/hLrtnHDN3tolyabHm9chCULWfovg7D41tXV/bPJOFqMm35gwj5IC0R92JxbR38kDrkCdNww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5433

On 12/30/23 10:19, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> This information will be useful for debugging things like page faults
> due to RMP access violations and RMPUPDATE failures.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: move helper to standalone patch, rework dump logic to reduce
>        verbosity]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/include/asm/sev.h |  2 +
>   arch/x86/virt/svm/sev.c    | 77 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 79 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 01ce61b283a3..2c53e3de0b71 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -247,9 +247,11 @@ static inline u64 sev_get_status(void) { return 0; }
>   #ifdef CONFIG_KVM_AMD_SEV
>   bool snp_probe_rmptable_info(void);
>   int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
> +void snp_dump_hva_rmpentry(unsigned long address);
>   #else
>   static inline bool snp_probe_rmptable_info(void) { return false; }
>   static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
> +static inline void snp_dump_hva_rmpentry(unsigned long address) {}
>   #endif
>   
>   #endif
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 49fdfbf4e518..7c9ced8911e9 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -266,3 +266,80 @@ int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> +
> +/*
> + * Dump the raw RMP entry for a particular PFN. These bits are documented in the
> + * PPR for a particular CPU model and provide useful information about how a
> + * particular PFN is being utilized by the kernel/firmware at the time certain
> + * unexpected events occur, such as RMP faults.
> + */
> +static void dump_rmpentry(u64 pfn)
> +{
> +	u64 pfn_current, pfn_end;
> +	struct rmpentry *e;
> +	u64 *e_data;
> +	int level;
> +
> +	e = __snp_lookup_rmpentry(pfn, &level);
> +	if (IS_ERR(e)) {
> +		pr_info("Failed to read RMP entry for PFN 0x%llx, error %ld\n",
> +			pfn, PTR_ERR(e));
> +		return;
> +	}
> +
> +	e_data = (u64 *)e;
> +	if (e->assigned) {
> +		pr_info("RMP entry for PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +			pfn, e_data[1], e_data[0]);
> +		return;
> +	}
> +
> +	/*
> +	 * If the RMP entry for a particular PFN is not in an assigned state,
> +	 * then it is sometimes useful to get an idea of whether or not any RMP
> +	 * entries for other PFNs within the same 2MB region are assigned, since
> +	 * those too can affect the ability to access a particular PFN in
> +	 * certain situations, such as when the PFN is being accessed via a 2MB
> +	 * mapping in the host page table.
> +	 */
> +	pfn_current = ALIGN(pfn, PTRS_PER_PMD);
> +	pfn_end = pfn_current + PTRS_PER_PMD;
> +
> +	while (pfn_current < pfn_end) {
> +		e = __snp_lookup_rmpentry(pfn_current, &level);
> +		if (IS_ERR(e)) {
> +			pfn_current++;
> +			continue;
> +		}
> +
> +		e_data = (u64 *)e;
> +		if (e_data[0] || e_data[1]) {
> +			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +				pfn, pfn_current, e_data[1], e_data[0]);
> +			return;
> +		}
> +		pfn_current++;
> +	}
> +
> +	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
> +		pfn);
> +}
> +
> +void snp_dump_hva_rmpentry(unsigned long hva)
> +{
> +	unsigned int level;
> +	pgd_t *pgd;
> +	pte_t *pte;
> +
> +	pgd = __va(read_cr3_pa());
> +	pgd += pgd_index(hva);
> +	pte = lookup_address_in_pgd(pgd, hva, &level);
> +
> +	if (!pte) {
> +		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
> +		return;
> +	}
> +
> +	dump_rmpentry(pte_pfn(*pte));

Already worked with Mike offline when I was running into issues using this 
function. Net of that conversation is that the PFN needs to be adjusted 
using the address offset if the PTE level indicates a huge page.

Additionally the loop in dump_rmpentry() needs to use ALIGN_DOWN() in 
order to get the PFN of the starting 2MB area.

Thanks,
Tom


> +}
> +EXPORT_SYMBOL_GPL(snp_dump_hva_rmpentry);

