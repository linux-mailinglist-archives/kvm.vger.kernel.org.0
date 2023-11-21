Return-Path: <kvm+bounces-2161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 034067F285B
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 10:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25C7D1C2115D
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 09:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B18331A87;
	Tue, 21 Nov 2023 09:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="G63Feufj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2132.outbound.protection.outlook.com [40.107.212.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F904E7
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 01:07:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSp440p9YJSZOj0Qr8P+R4M3IG+K8usMro+N12oBxGfrlDD41Il6Zw1jegI/U6BIxtldTsddsiFvE5qGAEdc+76QYXPcWSdqwE+TNEWbMxf7luGGJwOmfegPF4NzdOKoz0ucQIOltJjkffyBRYOEC2MsvKcc3oMQ0O3/XsY9DdGRuNZ+dPJCxSGKRWyq60HXSLoGRifhxufokPMLR3WCANnmVsFQs6EARKrqWOzOD7GqDOUYd4HFrWvttpTsMwB7nQn8Zu6I2XrVtAJV+1k0B2zINI53eqfI6VqKWWM6ZHyX3WBdQLTPWXGalbtj+A0Gz/0mmkq/sLneXfiSPFl/2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0/QzgmTsOJ80XLBaSR8ZNBS3tn3t23lQ9NjqR36TWA=;
 b=NcGF40gmBn1SIHg0JSlqCZJ7OJ8MflQJsXwK8j4rlTAGl9N9BWjw7mvEtIdDnp5P28i7lPwKB67zlUCF4a7HZ/C2/kkdTL/+wc+OLj5/3KLBxBt9E7krrG1OHL1E7+Ywm5Jm+g1RHPnLB0RdllvB2SS10JqcD8qIxvgoDez0+IdIDoFLKYlf6BrbdvDNoBveDEHViG1chGYglbX2MfoiUMq7boGRWSEaXxdgqvftGK9sCA0yv+dfDUc6YKo0Qc89c4kfZa+0znupBopQCD0yDUm9+LUkR03M+RTM8R7ehbuFoOOtPVLDqVrSoxAvGMMPY5Yf1J4LeVJ6NgC0Q37Ecw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0/QzgmTsOJ80XLBaSR8ZNBS3tn3t23lQ9NjqR36TWA=;
 b=G63FeufjFBdeZAjfBo8GDkXa3bO5reR9KB5b9Xur1TiLgawy2+ctyKJQSV3wmU6RaimZumZ0efZviXHvSElGpuOmkB6UAndzzLoYd1E8bCTKJYekljHIWNYBwsgJIqvLHBdPjUpBVfLiOfRmxVypMgzO7VINN51ShrRCkNCmI74=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA1PR01MB6733.prod.exchangelabs.com (2603:10b6:806:1a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.28; Tue, 21 Nov 2023 09:07:41 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 09:07:41 +0000
Message-ID: <2e25b427-9df6-42f7-99b3-bb2d01a0f0c4@os.amperecomputing.com>
Date: Tue, 21 Nov 2023 14:37:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/43] arm64: cpufeatures: Restrict NV support to
 FEAT_NV2
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <20231120131027.854038-2-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20231120131027.854038-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:610:60::25) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA1PR01MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 02be5001-5531-4eef-c3a4-08dbea715090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lwrxLq2UQxTUm/dmSDmAd71TCJxFjqAAXuRJMK5kpHVJWkBqEFVNjWS8ZKcNfMNnjFAcK6CCDPsyKIY7hnBW2Bly8+tA2NpMpQKywi2R6sb7IZ5ikEPKsmp/iQnD2rsnySBvZGQOVDcEofF1wUv1hoVhCH4RvcYvA8oqn9WLR18/366ZmU5pKYG+3Zn53YPtMCyll+AQ7EAcSHpVFh0co6zb+SIa1MDtQiarh6hAdBTyAGXMpfm+wwqXfxEztQCu+uhqvC+cY2+JPGF2qFggmfVo5TX/TljRnzgO3PRjmVvyqUAmJyq//V43QoZvCQu2oIIPqFWihAJpG+2oZd/cUb7ryvXyYt7dukfNxUx5mWTn+9hRrPMgyGWt7u2KxePtW3HekLvw0yWQwt8h5wqHjGuOh40n6qUKKrvg7o1rOWIJP85a+J/MdoW4bR5hzFxmMFlvGYNI3laURitxzZkwrSw/InE/dcanO/lMUYQLwHySFB5mZIGjx6TQOIXLQ2VlRm1nwk9rkNYIE1hw8KPWU63HJCWm0Ugs3fquplYMr0MYDn/wV0p80HF2XsfdILJbYlavhso5BE7bxs73WzNQfukEpLHYWdqp3J6K2oDYBpxJNo5JOOLCKP4FEt+Rv0Su
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(376002)(346002)(366004)(136003)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(31686004)(6666004)(83380400001)(6512007)(478600001)(6506007)(66946007)(54906003)(66476007)(66556008)(316002)(38100700002)(8936002)(4326008)(8676002)(6486002)(53546011)(26005)(2616005)(31696002)(86362001)(7416002)(5660300002)(41300700001)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0VpaklYMDk3UDU2ZWlpckxFem5BNE1Bd2VHWnVEWExNcDhmZldQcnJxb3Zv?=
 =?utf-8?B?czNUQTMrRHhBbFJMYlRUTU05UW1YdW5HTW5Dd0FNYjVRU3pUWTV5QVZjbHE1?=
 =?utf-8?B?Y1owY1ZycWJNZzRRZlpjWGU5NmhXOVpQQnNWU2l6Vi9TYUM2Q3ZaS2pRNDQ2?=
 =?utf-8?B?TmxPcCtRcDVValh0RTlUWVlRQ2ZCa2g2SVhvYnVoV002bStKZi9qN0JMdkhH?=
 =?utf-8?B?WFlhZ2o2NHhTRnV6SStFdlJEeU5QM0lseFc5Y1lTVzNCdFJzMGROcTNtR0k3?=
 =?utf-8?B?VDFYYm85eU5TY01qYnpSeEhqa0V5bCtoN2M2N3VnQXRrZWM3RFBIME8xUlpZ?=
 =?utf-8?B?a2luV2M0dkFleW9ZdWt1OXJ4dXk5VjdlbGJJY1N6a1dwRVI2b2N6TmJWRlRm?=
 =?utf-8?B?dWZEZm43VnF6bUxvRUVVcXdLamdvenpSZ1pvZzFNTmJFcGszVWhFYzJTeHda?=
 =?utf-8?B?RWtnK1JZZjgydDlLZE5RLzAxd2FBOGJzRm5pdVBrRFFmSGptVzJIRnYwc0JO?=
 =?utf-8?B?NmtVSmVtZmZpemI5OWNqS0JRQ05DVURrdmVEMFhEanZEYzZDVXpZWDNrakE2?=
 =?utf-8?B?aysvQlJzSFN6cjZGQURjbmJ2RFZlNkZqOUV3Tlh0UGZQdmt5N2h3RXdsc3NZ?=
 =?utf-8?B?aWduaUVXQjJ6ckdROUQwaVlqRjl1eU1BNjBzYWVQeTlEV1Rzc05KdlR6Z3Az?=
 =?utf-8?B?WjdRQ2oxMkRFRDYzdVhsdnQzRmRaL29JSE4rdEg4cXltSVRPR3R4ajhYdTNO?=
 =?utf-8?B?czUrb2RscTMyb0Y1ajZuOXYxcmlDeW5IcjUzVEU4aldLSFl3TVRNL3BNUHF5?=
 =?utf-8?B?WW5rd0VuYkRreUdtY3lOY1BXcW5JcFZYMW9UaG1TUG8zWGZFeE1BekI5aThE?=
 =?utf-8?B?UFpESER2UVlsV1V3Y2xsYW1LN3Y1d2p1V3lpaFFWRE5DYWtVc25aUEk1ZE43?=
 =?utf-8?B?ejZRbk9IUDhxQjlQRkhJZVAyN0FUemprWVpSV3lsQnd0RWsrUkEvS1hRM01u?=
 =?utf-8?B?VUlJU3pUNnhUMlVERFV1Y1pZK3dLd2ZIU2hOd0wva2N0MXJseFZ6Q1F3M3dZ?=
 =?utf-8?B?VG1KK2ZZN0M1NXF6UDBVYlhHV25DUDBnWVhLU0x4RWYveXJuRFJFa05XOW9L?=
 =?utf-8?B?OW9mSGxtNG1RVkJUVDRJdmhuQ2tXVUlERnlaUmlnekl0ZWE5WHZBWnN5aHBz?=
 =?utf-8?B?WjFGdmtYYlNyZUtuM3hjTEk4dzI3eG8zK0V0Y0lnenZOZmNLOERHME5ld0p6?=
 =?utf-8?B?d0M4d1ZOYlFoaDA5Tm8xNGo5NnNFWUxJdnJkWFBmRWR1WnBUbkhCNGpxK0lj?=
 =?utf-8?B?Q3BtbEgySjJtWmVSRWszRHlTWUtKVkdXcUlhODhOWGdMSXYxUXBENFRvdWtz?=
 =?utf-8?B?dWVWdGRxMUMzTzFodk5PL3Q5d3hGdklCQTVqMDFzdXNiZllzbTcvY2wvbDVV?=
 =?utf-8?B?MlV2bXcvTEZMME9FeEVEMzhlZW5pR1FYeWJvWnczSmRwcVA0RTB1a1oxSGYr?=
 =?utf-8?B?SzcrOFBKOFN5cEwrTHlNOW9SOGwxZFBkU3hNRkoxVEtxK1d3UmdLZjdxQzls?=
 =?utf-8?B?SFRWZDJBWFY0T3NwYkdZamNsQ1NBczBCTmticU83cUdZSjZyeHRRZzFiNngw?=
 =?utf-8?B?NWVlKzhmNlpFeXBZNS9rVldnRHpvMkxnS0VqTjlvSFp0SkFpUEg2YVBKUitH?=
 =?utf-8?B?M1lnQUtCRm1qT3BTcVc5cGc5Z25GT3ZsekJGck9lSU5DTm1Sb3dvQTExQjNW?=
 =?utf-8?B?SlRpMmtsZVNuVUJ0N0hPdFk0Y2NFMUhwbjhYU2Q2emEwZ3Y2M3BsQ2N5dEV1?=
 =?utf-8?B?bnRwalAxREttbU52NTZqa0tERnhOcjVPU1JqQ3pRWkZVYWg5Q25XZ2VCWGMr?=
 =?utf-8?B?OTlEczhnM2JHY2phbURoVlc3MHZNTFoyOEVVN21yY0Rpd2RCdDUxN2lQYUE1?=
 =?utf-8?B?dnJxOHRUTTBJcU1oU2hPNmZPUXNxT0R1NWNNSWpZMXFuRGpNV2hJUzY4ZVdK?=
 =?utf-8?B?U2RNbklSWmRodEZrRktBSWxDSGdMVW9ESkRrZUNNOG9Ob0VpbTBqbkRpSWo4?=
 =?utf-8?B?VVRaZk5CMmZqYUVzRnNrTkQvaXAyTGh2cmVrM28rYlFTa3o4SjF4MFhPOEk0?=
 =?utf-8?B?YS9zQXE4THd6dU5mc3o3Sm5FenE5RTB0N2doRjRHbC9IazJ6dkg5czVtN29V?=
 =?utf-8?Q?vCjJDaQy3rb4jTCtYc7cLVVigCX2fUcO+xy56nlv1ygK?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02be5001-5531-4eef-c3a4-08dbea715090
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 09:07:40.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkkEALfOAsHRo0zNm4XD0Tdiki8Nrt0DEVE4K9PS4ALqD+uk2G/SE1sYVaEdc3s8VO1mA/d82V9IYM79ctFr1RzlbzfogPWrT7NlhDXD1Wb1wAEeIjORJSw0Phk/gk3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6733



On 20-11-2023 06:39 pm, Marc Zyngier wrote:
> To anyone who has played with FEAT_NV, it is obvious that the level
> of performance is rather low due to the trap amplification that it
> imposes on the host hypervisor. FEAT_NV2 solves a number of the
> problems that FEAT_NV had.
> 
> It also turns out that all the existing hardware that has FEAT_NV
> also has FEAT_NV2. Finally, it is now allowed by the architecture
> to build FEAT_NV2 *only* (as denoted by ID_AA64MMFR4_EL1.NV_frac),
> which effectively seals the fate of FEAT_NV.
> 
> Restrict the NV support to NV2, and be done with it. Nobody will
> cry over the old crap.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kernel/cpufeature.c | 22 +++++++++++++++-------
>   arch/arm64/tools/cpucaps       |  2 ++
>   2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 7dcda39537f8..95a677cf8c04 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -439,6 +439,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
>   
>   static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
>   	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
>   	ARM64_FTR_END,
>   };
>   
> @@ -2080,12 +2081,8 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
>   	if (kvm_get_mode() != KVM_MODE_NV)
>   		return false;
>   
> -	if (!has_cpuid_feature(cap, scope)) {
> -		pr_warn("unavailable: %s\n", cap->desc);
> -		return false;
> -	}
> -
> -	return true;
> +	return (__system_matches_cap(ARM64_HAS_NV2) |
> +		__system_matches_cap(ARM64_HAS_NV2_ONLY));

This seems to be typo and should it be logical OR?

>   }
>   
>   static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> @@ -2391,12 +2388,23 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.matches = runs_at_el2,
>   		.cpu_enable = cpu_copy_el2regs,
>   	},
> +	{
> +		.capability = ARM64_HAS_NV2,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, NV2)
> +	},
> +	{
> +		.capability = ARM64_HAS_NV2_ONLY,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY)
> +	},
>   	{
>   		.desc = "Nested Virtualization Support",
>   		.capability = ARM64_HAS_NESTED_VIRT,
>   		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>   		.matches = has_nested_virt_support,
> -		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, IMP)

Since only NV2 is supported, is it more appropriate to have description 
as "Enhanced Nested Virtualization Support"?

>   	},
>   	{
>   		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index fea24bcd6252..480de648cd03 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -41,6 +41,8 @@ HAS_LSE_ATOMICS
>   HAS_MOPS
>   HAS_NESTED_VIRT
>   HAS_NO_HW_PREFETCH
> +HAS_NV2
> +HAS_NV2_ONLY
>   HAS_PAN
>   HAS_S1PIE
>   HAS_RAS_EXTN


Thanks,
Ganapat

